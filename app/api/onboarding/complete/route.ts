import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { getSessionUser } from "@/lib/auth";
import { attachStudentToReferralCode } from "@/lib/attach-referral";
import { authCookieOptions, signAuthToken } from "@/lib/jwt";
import { logSuspiciousAccess } from "@/lib/security";
import { sha256Hex } from "@/lib/otp";

export async function POST(req: NextRequest) {
  try {
    const user = await getSessionUser();
    if (!user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const body = await req.json();
    if (body && typeof body === "object" && !Array.isArray(body)) {
      const raw = body as Record<string, unknown>;
      const attempted = ["role", "adminLevel", "adminRoleTemplateId", "approvalStatus"].filter(
        (k) => k in raw,
      );
      if (attempted.length) {
        const forwarded = req.headers.get("x-forwarded-for") || "";
        const ip = forwarded.split(",")[0]?.trim() || "unknown";
        await logSuspiciousAccess({
          userId: user.id,
          ipAddress: ip,
          userAgent: req.headers.get("user-agent") || undefined,
          path: "/api/onboarding/complete",
          reason: `Role/privilege field(s) present in onboarding request: ${attempted.join(", ")}`,
          severity: "HIGH",
        });
      }
    }
    const { referralSource, referralCode, phoneNumber, otp } = body as {
      referralSource?: string;
      collegeName?: string;
      referralCode?: string;
      phoneNumber?: string;
      otp?: string;
    };
    const collegeName = typeof (body as { collegeName?: unknown })?.collegeName === "string"
      ? (body as { collegeName: string }).collegeName.trim()
      : "";

    if (!referralSource) {
      return NextResponse.json({ error: "referralSource is required" }, { status: 400 });
    }
    if (collegeName.length < 2) {
      return NextResponse.json({ error: "collegeName is required" }, { status: 400 });
    }

    const cleanPhone = typeof phoneNumber === "string" ? phoneNumber.replace(/\D/g, "") : "";
    if (cleanPhone.length !== 10) {
      return NextResponse.json({ error: "A valid 10-digit phone number is required" }, { status: 400 });
    }

    // Check if phone number is already taken
    const existing = await prisma.user.findFirst({
      where: { 
        phoneNumber: cleanPhone,
        id: { not: user.id }
      }
    });

    if (existing) {
       return NextResponse.json({ error: "This phone number is already registered with another account" }, { status: 400 });
    }

    if (!otp || typeof otp !== "string" || otp.replace(/\D/g, "").length !== 6) {
      return NextResponse.json({ error: "A valid 6-digit OTP is required" }, { status: 400 });
    }

    const otpPurpose = "REGISTER" as const;

    const latestOtpToken = await prisma.phoneOtpToken.findFirst({
      where: {
        phoneNumber: cleanPhone,
        purpose: otpPurpose,
        usedAt: null,
        expiresAt: { gt: new Date() },
      },
      orderBy: { createdAt: "desc" },
    });

    if (!latestOtpToken || latestOtpToken.attemptsLeft <= 0) {
      return NextResponse.json({ error: "Invalid or expired OTP" }, { status: 400 });
    }

    const expectedHash = sha256Hex(`${otpPurpose}:${cleanPhone}:${otp}`);
    if (expectedHash !== latestOtpToken.codeHash) {
      const nextAttempts = Math.max(0, latestOtpToken.attemptsLeft - 1);
      await prisma.phoneOtpToken.update({
        where: { id: latestOtpToken.id },
        data: {
          attemptsLeft: nextAttempts,
          usedAt: nextAttempts === 0 ? new Date() : null,
        },
      });
      return NextResponse.json({ error: "Invalid or expired OTP" }, { status: 400 });
    }

    await prisma.phoneOtpToken.update({
      where: { id: latestOtpToken.id },
      data: { usedAt: new Date() },
    });

    const codeNormalized =
      typeof referralCode === "string" && referralCode.trim().length > 0
        ? referralCode.trim().toUpperCase()
        : "";

    // Step 1: Update user record
    await prisma.user.update({
      where: { id: user.id },
      data: {
        onboardingComplete: true,
        referralSource,
        collegeName,
        phoneNumber: cleanPhone,
      },
    });

    if (codeNormalized) {
      const attached = await attachStudentToReferralCode({
        studentId: user.id,
        studentFullName: user.fullName,
        studentCollegeName: collegeName,
        codeRaw: codeNormalized,
      });
      if (!attached.ok) {
        console.warn("[onboarding] referral attach failed or invalid code for user=%s", user.id);
      }
    }

    const refreshed = await prisma.user.findUnique({ where: { id: user.id } });
    if (!refreshed) {
      return NextResponse.json({ error: "User not found" }, { status: 404 });
    }

    const token = await signAuthToken({
      userId: refreshed.id,
      email: refreshed.email,
      role: refreshed.role as "ADMIN" | "CLUB_HEADER" | "STUDENT",
      approvalStatus: refreshed.approvalStatus as "PENDING" | "APPROVED" | "REJECTED",
      suspended: refreshed.suspended,
      onboardingComplete: refreshed.onboardingComplete,
      hasPhone: !!(cleanPhone && cleanPhone.length === 10),
    });

    const res = NextResponse.json({ success: true });
    res.cookies.set("occ-token", token, authCookieOptions);
    return res;
  } catch (error) {
    console.error("[onboarding/complete] error:", error);
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}
