import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { getSessionUser } from "@/lib/auth";
import { pusherServer } from "@/lib/pusher";

export async function POST(req: NextRequest) {
  try {
    const user = await getSessionUser();
    if (!user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const body = await req.json();
    const { referralSource, referralCode } = body;

    if (!referralSource) {
      return NextResponse.json({ error: "referralSource is required" }, { status: 400 });
    }

    // Step 1: Update user record
    await prisma.user.update({
      where: { id: user.id },
      data: {
        onboardingComplete: true,
        referralSource,
      } as any,
    });

    // Step 2 & 3: Check referralCode, create records, Trigger Pusher
    if (referralCode) {
      const headerUser = await prisma.user.findUnique({
        where: { referralCode },
        include: { clubManaged: true },
      });

      if (headerUser && headerUser.approvalStatus === "APPROVED" && headerUser.clubManaged) {
        try {
          await prisma.clubMembership.upsert({
            where: { userId_clubId: { userId: user.id, clubId: headerUser.clubManaged.id } },
            update: {},
            create: { userId: user.id, clubId: headerUser.clubManaged.id },
          });

          await prisma.referralStat.create({
            data: {
              clubHeaderId: headerUser.id,
              studentId: user.id,
              clubId: headerUser.clubManaged.id,
            },
          });

          await prisma.notification.create({
            data: {
              userId: headerUser.id,
              type: "new-referral",
              title: "New student joined",
              message: `${user.fullName} joined using your referral code.`,
              data: { studentId: user.id },
            },
          });

          await pusherServer.trigger(`header-${headerUser.id}`, "new-member", {
            member: {
              id: user.id,
              fullName: user.fullName,
              collegeName: user.collegeName,
              registeredAt: new Date().toISOString(),
            },
          });
        } catch (referralErr) {
          console.warn("[onboarding] referral side-effects failed:", referralErr);
        }
      }
    }

    return NextResponse.json({ success: true });
  } catch (error) {
    console.error("[onboarding/complete] error:", error);
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}
