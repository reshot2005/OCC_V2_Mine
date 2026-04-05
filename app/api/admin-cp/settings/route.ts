import { NextRequest, NextResponse } from "next/server";
import { requireAdminApi } from "@/lib/auth";
import { prisma } from "@/lib/prisma";
import { logAudit } from "@/lib/audit";

export async function GET() {
  const admin = await requireAdminApi();
  if (admin instanceof NextResponse) return admin;

  let settings = await prisma.platformSettings.findUnique({ where: { id: "singleton" } });
  if (!settings) {
    settings = await prisma.platformSettings.create({ data: { id: "singleton" } });
  }

  return NextResponse.json({ settings: { ...settings, updatedAt: settings.updatedAt.toISOString() } });
}

export async function PATCH(req: NextRequest) {
  const admin = await requireAdminApi();
  if (admin instanceof NextResponse) return admin;

  const body = await req.json();
  const data: Record<string, any> = {};

  if (body.siteName !== undefined) data.siteName = body.siteName;
  if (body.announcementBanner !== undefined) data.announcementBanner = body.announcementBanner;
  if (body.announcementActive !== undefined) data.announcementActive = body.announcementActive;
  if (body.maintenanceMode !== undefined) data.maintenanceMode = body.maintenanceMode;
  if (body.registrationOpen !== undefined) data.registrationOpen = body.registrationOpen;
  if (body.landingHeroTitle !== undefined) data.landingHeroTitle = body.landingHeroTitle;
  if (body.landingHeroSubtitle !== undefined) data.landingHeroSubtitle = body.landingHeroSubtitle;

  const settings = await prisma.platformSettings.upsert({
    where: { id: "singleton" },
    create: { id: "singleton", ...data },
    update: data,
  });

  await logAudit({
    adminId: admin.id, adminEmail: admin.email,
    action: "UPDATE_SETTINGS", entity: "settings", details: data,
  });

  return NextResponse.json({ success: true, settings: { ...settings, updatedAt: settings.updatedAt.toISOString() } });
}
