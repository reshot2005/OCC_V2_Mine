import { NextRequest, NextResponse } from "next/server";
import { requireAdminApi } from "@/lib/auth";
import { prisma } from "@/lib/prisma";
import { logAudit } from "@/lib/audit";

export async function GET(req: Request) {
  const admin = await requireAdminApi();
  if (admin instanceof NextResponse) return admin;

  const { searchParams } = new URL(req.url);
  const resolved = searchParams.get("resolved") === "true" ? true : searchParams.get("resolved") === "false" ? false : undefined;

  const alerts = await prisma.suspiciousAccess.findMany({
    where: resolved !== undefined ? { resolved } : {},
    orderBy: { createdAt: "desc" },
    take: 100,
  });

  return NextResponse.json({
    alerts: alerts.map((a) => ({ ...a, createdAt: a.createdAt.toISOString() })),
  });
}

export async function PATCH(req: NextRequest) {
  const admin = await requireAdminApi();
  if (admin instanceof NextResponse) return admin;

  const { id } = await req.json();
  if (!id) return NextResponse.json({ error: "ID required" }, { status: 400 });

  await prisma.suspiciousAccess.update({ where: { id }, data: { resolved: true } });

  await logAudit({
    adminId: admin.id, adminEmail: admin.email,
    action: "RESOLVE_ALERT", entity: "security", entityId: id,
  });

  return NextResponse.json({ success: true });
}
