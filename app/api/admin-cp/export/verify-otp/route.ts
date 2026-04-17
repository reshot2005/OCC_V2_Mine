
import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { prisma } from "@/lib/prisma";
import { requireAdminApi } from "@/lib/auth";
import { sha256Hex } from "@/lib/otp";
import { signAuthToken } from "@/lib/jwt";
import { ACTIVITY_CATEGORIES, extractRequestIp, logActivityEvent } from "@/lib/activity-events";

const verifySchema = z.object({
  email: z.string().email(),
  otp: z.string().length(6),
});

export async function POST(req: NextRequest) {
  try {
    const session = await requireAdminApi();
    if (session instanceof NextResponse) return session;

    const { email, otp } = verifySchema.parse(await req.json());
    const purpose = "EXPORT";
    
    // Find valid token
    const record = await prisma.emailOtpToken.findFirst({
      where: {
        email,
        purpose: "EXPORT" as any,
        usedAt: null,
        expiresAt: { gt: new Date() }
      },
      orderBy: { createdAt: "desc" }
    });

    if (!record) {
      return NextResponse.json({ error: "No active verification code found or code expired." }, { status: 400 });
    }

    const expectedHash = sha256Hex(`${purpose}:${email}:${otp}`);
    if (record.codeHash !== expectedHash) {
      await prisma.emailOtpToken.update({
        where: { id: record.id },
        data: { attemptsLeft: { decrement: 1 } }
      });
      return NextResponse.json({ error: "Invalid verification code." }, { status: 400 });
    }

    // Mark as used
    await prisma.emailOtpToken.update({
      where: { id: record.id },
      data: { usedAt: new Date() }
    });

    // Create a temporary export token (valid for 10 minutes)
    const exportToken = await signAuthToken(
      { 
        userId: session.id, 
        email: session.email, 
        role: "ADMIN",
        targetEmail: email 
      }, 
      { expiresIn: "10m" }
    );

    await logActivityEvent({
      actor: { userId: session.id, name: session.fullName, role: "ADMIN" },
      category: ACTIVITY_CATEGORIES.auth,
      eventType: "export_otp_verified",
      summary: `Admin verified export via personal email: ${email}`,
      entityType: "user",
      entityId: session.id,
      ipAddress: extractRequestIp(req),
    });

    return NextResponse.json({ success: true, exportToken });
  } catch (err: any) {
    console.error("Export OTP Verification Error:", err);
    return NextResponse.json({ error: "Verification failed." }, { status: 500 });
  }
}
