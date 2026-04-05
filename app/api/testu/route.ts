import { NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";

export const dynamic = "force-dynamic";

export async function GET() {
  const u = await prisma.user.findFirst({ where: { email: "fashion@gmail.com" } });
  return NextResponse.json({ u });
}
