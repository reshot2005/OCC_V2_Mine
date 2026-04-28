import { NextRequest, NextResponse } from "next/server";
import { z, ZodError } from "zod";
import { prisma } from "@/lib/prisma";
import { generateSixDigitOtp, sha256Hex } from "@/lib/otp";

// Replace this with your actual SMS provider logic (e.g., Twilio, MSG91, AWS SNS)
async function sendSms(to: string, message: string) {
  console.log(`[SMS MOCK] Sending to ${to}: ${message}`);
  // Example for Twilio:
  // const client = require('twilio')(process.env.TWILIO_SID, process.env.TWILIO_AUTH_TOKEN);
  // await client.messages.create({ body: message, from: process.env.TWILIO_PHONE_NUMBER, to });
}

const sendPhoneOtpSchema = z.object({
  phoneNumber: z.string().min(10).regex(/^(\+91[\s-]?)?[6-9]\d{9}$/, "Enter a valid 10-digit Indian mobile number").transform(v => {
    const d = v.replace(/\D/g, "");
    return d.length > 10 ? d.slice(-10) : d;
  }),
});

type OtpPurpose = "REGISTER";

export async function POST(req: NextRequest) {
  try {
    if (!process.env.DATABASE_URL) {
      return NextResponse.json({ error: "Database is not configured" }, { status: 503 });
    }

    const { phoneNumber } = sendPhoneOtpSchema.parse(await req.json());
    const purpose: OtpPurpose = "REGISTER";

    const now = Date.now();
    const windowMs = 60_000; // 1 minute
    const maxPerWindow = 3;

    const sentRecently = await prisma.phoneOtpToken.count({
      where: {
        phoneNumber,
        purpose,
        createdAt: { gte: new Date(now - windowMs) },
      },
    });
    
    if (sentRecently >= maxPerWindow) {
      // Don't send, but pretend we did to avoid leaking info and rate limit
      return NextResponse.json({ success: true }, { status: 200 });
    }

    const otp = generateSixDigitOtp();
    const expectedHash = sha256Hex(`${purpose}:${phoneNumber}:${otp}`);

    // Clean up old unused codes
    await prisma.phoneOtpToken.deleteMany({
      where: {
        phoneNumber,
        purpose: "REGISTER",
        usedAt: null,
        expiresAt: { gt: new Date(Date.now() - windowMs) },
      },
    });

    await prisma.phoneOtpToken.create({
      data: {
        phoneNumber,
        purpose,
        codeHash: expectedHash,
        attemptsLeft: 5,
        expiresAt: new Date(Date.now() + 10 * 60_000), // 10 minutes
      },
    });

    const message = `Your OCC verification code is ${otp}. It will expire in 10 minutes.`;
    
    // In production, remove the MOCK and actually trigger your SMS gateway here
    await sendSms(`+91${phoneNumber}`, message);

    return NextResponse.json({ success: true, message: "OTP sent successfully" }, { status: 200 });
  } catch (error) {
    if (error instanceof ZodError) {
      return NextResponse.json(
        { error: error.issues[0]?.message ?? "Invalid phone number" },
        { status: 400 },
      );
    }
    console.error("[register/send-phone-otp]", error);
    return NextResponse.json({ error: "OTP send failed" }, { status: 500 });
  }
}
