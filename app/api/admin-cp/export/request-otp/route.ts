
import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { prisma } from "@/lib/prisma";
import { requireAdminApi } from "@/lib/auth";
import { generateSixDigitOtp, sha256Hex } from "@/lib/otp";
import { sendOtpEmail } from "@/lib/smtp";
import { ACTIVITY_CATEGORIES, extractRequestIp, logActivityEvent } from "@/lib/activity-events";

const requestSchema = z.object({
  email: z.string().email(),
});

export async function POST(req: NextRequest) {
  try {
    const session = await requireAdminApi();
    if (session instanceof NextResponse) return session;

    const { email } = requestSchema.parse(await req.json());

    const purpose = "EXPORT";
    const otp = generateSixDigitOtp();
    const expectedHash = sha256Hex(`${purpose}:${email}:${otp}`);

    console.log(`[ExportOTP] Processing request for ${email}`);

    // Standard Prisma Cleanup
    try {
      await prisma.emailOtpToken.deleteMany({
        where: { email, purpose: "EXPORT" as any, usedAt: null }
      });
    } catch (e) {
      console.warn("Prisma cleanup warning:", e);
    }

    // Standard Prisma Create
    try {
      const expiresAt = new Date(Date.now() + 10 * 60_000);
      await prisma.emailOtpToken.create({
        data: {
          email,
          purpose: "EXPORT" as any,
          codeHash: expectedHash,
          attemptsLeft: 5,
          expiresAt
        }
      });
    } catch (e: any) {
      console.error("Prisma Create Error:", e);
      // Fallback to Raw if Prisma client is out of sync with DB enum
      try {
        const id = Math.random().toString(36).substring(2, 10);
        const expiresAt = new Date(Date.now() + 10 * 60_000);
        await prisma.$executeRaw`
          INSERT INTO email_otp_tokens (id, email, purpose, "codeHash", "attemptsLeft", "expiresAt", "createdAt")
          VALUES (${id}, ${email}, 'EXPORT'::"OtpPurpose", ${expectedHash}, 5, ${expiresAt}, NOW())
        `;
      } catch (rawErr: any) {
        console.error("Raw Insert Fallback Error:", rawErr);
        return NextResponse.json({ error: "Security service unavailable. Please try again later." }, { status: 500 });
      }
    }

    // Send email
    try {
      await sendOtpEmail({ to: email, code: otp, purpose: "RESET_PASSWORD" });
    } catch (emailErr: any) {
      console.error("SMTP Error:", emailErr);
      return NextResponse.json({ error: "Verification email failed to send. Check admin email settings." }, { status: 500 });
    }
    
    await logActivityEvent({
      actor: { userId: session.id, name: session.fullName, role: "ADMIN" },
      category: ACTIVITY_CATEGORIES.auth,
      eventType: "export_otp_requested",
      summary: `Admin requested export OTP for ${email}`,
      entityType: "user",
      entityId: session.id,
      ipAddress: extractRequestIp(req),
    });

    return NextResponse.json({ success: true });
  } catch (err: any) {
    console.error("Critical Export OTP error:", err);
    return NextResponse.json({ error: "Something went wrong." }, { status: 500 });
  }
}
