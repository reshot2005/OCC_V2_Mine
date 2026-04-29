import bcrypt from "bcryptjs";
import { NextRequest, NextResponse } from "next/server";
import { ZodError } from "zod";
import { prisma } from "@/lib/prisma";
import { resetPasswordSchema } from "@/lib/validations";
import { authCookieOptions, signAuthToken } from "@/lib/jwt";
import { ACTIVITY_CATEGORIES, extractRequestIp, logActivityEvent } from "@/lib/activity-events";

export async function POST(req: NextRequest) {
  try {
    if (!process.env.DATABASE_URL) throw new Error("DATABASE_URL is not configured");
    if (!process.env.JWT_SECRET) throw new Error("JWT_SECRET is not configured");

    const body = await req.json();
    const validated = resetPasswordSchema.parse(body);

    // Find user by email.
    const user = await prisma.user.findUnique({ where: { email: validated.email } });
    if (!user) {
      // Generic response to avoid user enumeration.
      return NextResponse.json({ error: "Password reset failed" }, { status: 400 });
    }

    const hashedPassword = await bcrypt.hash(validated.newPassword, 12);
    await prisma.user.update({
      where: { id: user.id },
      data: { password: hashedPassword },
    });

    await logActivityEvent({
      actor: { userId: user.id, name: user.fullName, role: user.role },
      category: ACTIVITY_CATEGORIES.auth,
      eventType: "password_reset_completed",
      summary: `${user.fullName} reset password`,
      entityType: "user",
      entityId: user.id,
      ipAddress: extractRequestIp(req),
      broadcast: true,
    });

    // Auto-login after successful reset.
    const token = await signAuthToken({
      userId: user.id,
      email: user.email,
      role: user.role as "ADMIN" | "CLUB_HEADER" | "STUDENT",
      approvalStatus: user.approvalStatus as "PENDING" | "APPROVED" | "REJECTED",
      suspended: user.suspended,
      onboardingComplete: user.onboardingComplete,
      hasPhone: !!(user.phoneNumber && user.phoneNumber.replace(/\D/g, "").length === 10),
    });
    const response = NextResponse.json({ success: true }, { status: 200 });
    response.cookies.set("occ-token", token, authCookieOptions);
    return response;
  } catch (error) {
    if (error instanceof ZodError) {
      return NextResponse.json({ error: error.issues[0]?.message ?? "Invalid form data" }, { status: 400 });
    }
    console.error("[auth/password-reset] error:", error);
    return NextResponse.json({ error: "Password reset failed" }, { status: 500 });
  }
}
