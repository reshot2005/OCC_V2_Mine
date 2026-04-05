import { NextRequest, NextResponse } from "next/server";
import { requireAdminApi } from "@/lib/auth";
import { prisma } from "@/lib/prisma";
import { logAudit } from "@/lib/audit";

export async function PATCH(req: NextRequest, { params }: { params: { id: string } }) {
  const admin = await requireAdminApi();
  if (admin instanceof NextResponse) return admin;

  const body = await req.json();
  const data: Record<string, any> = {};
  if (body.title) data.title = body.title;
  if (body.description) data.description = body.description;
  if (body.payMin !== undefined) data.payMin = body.payMin;
  if (body.payMax !== undefined) data.payMax = body.payMax;

  await prisma.gig.update({ where: { id: params.id }, data });

  await logAudit({
    adminId: admin.id, adminEmail: admin.email,
    action: "UPDATE_GIG", entity: "gig", entityId: params.id, details: data,
  });

  return NextResponse.json({ success: true });
}

export async function DELETE(_req: NextRequest, { params }: { params: { id: string } }) {
  const admin = await requireAdminApi();
  if (admin instanceof NextResponse) return admin;

  await prisma.gig.delete({ where: { id: params.id } });

  await logAudit({
    adminId: admin.id, adminEmail: admin.email,
    action: "DELETE_GIG", entity: "gig", entityId: params.id,
  });

  return NextResponse.json({ success: true });
}
