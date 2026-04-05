import { NextRequest, NextResponse } from "next/server";
import { requireAdminApi } from "@/lib/auth";
import { prisma } from "@/lib/prisma";
import { logAudit } from "@/lib/audit";

export async function GET(req: NextRequest, { params }: { params: { type: string } }) {
  const admin = await requireAdminApi();
  if (admin instanceof NextResponse) return admin;

  const type = params.type;
  let csv = "";

  if (type === "users") {
    const users = await prisma.user.findMany({
      select: { id: true, fullName: true, email: true, phoneNumber: true, collegeName: true, role: true, approvalStatus: true, suspended: true, createdAt: true },
      orderBy: { createdAt: "desc" },
    });
    csv = "ID,Name,Email,Phone,College,Role,Status,Suspended,Created\n" +
      users.map((u) => `${u.id},"${u.fullName}",${u.email},${u.phoneNumber},"${u.collegeName}",${u.role},${u.approvalStatus},${u.suspended},${u.createdAt.toISOString()}`).join("\n");
  } else if (type === "clubs") {
    const clubs = await prisma.club.findMany({
      include: { header: { select: { fullName: true } }, _count: { select: { members: true, posts: true } } },
      orderBy: { createdAt: "desc" },
    });
    csv = "ID,Name,Slug,Header,Members,Posts,Created\n" +
      clubs.map((c) => `${c.id},"${c.name}",${c.slug},"${c.header?.fullName || "None"}",${c._count.members},${c._count.posts},${c.createdAt.toISOString()}`).join("\n");
  } else if (type === "posts") {
    const posts = await prisma.post.findMany({
      select: { id: true, caption: true, content: true, likesCount: true, hidden: true, createdAt: true, club: { select: { name: true } }, user: { select: { fullName: true } } },
      orderBy: { createdAt: "desc" },
    });
    csv = "ID,Caption,Club,Author,Likes,Hidden,Created\n" +
      posts.map((p) => `${p.id},"${(p.caption || "").replace(/"/g, '""').slice(0, 100)}","${p.club.name}","${p.user.fullName}",${p.likesCount},${p.hidden},${p.createdAt.toISOString()}`).join("\n");
  } else if (type === "events") {
    const events = await prisma.event.findMany({
      include: { club: { select: { name: true } }, _count: { select: { registrations: true } } },
      orderBy: { date: "desc" },
    });
    csv = "ID,Title,Club,Venue,Date,Price,Registrations\n" +
      events.map((e) => `${e.id},"${e.title}","${e.club.name}","${e.venue}",${e.date.toISOString()},${e.price},${e._count.registrations}`).join("\n");
  } else if (type === "gigs") {
    const gigs = await prisma.gig.findMany({
      include: { club: { select: { name: true } }, _count: { select: { applications: true } } },
      orderBy: { createdAt: "desc" },
    });
    csv = "ID,Title,Club,PayMin,PayMax,Applications,Created\n" +
      gigs.map((g) => `${g.id},"${g.title}","${g.club?.name || "None"}",${g.payMin},${g.payMax},${g._count.applications},${g.createdAt.toISOString()}`).join("\n");
  } else {
    return NextResponse.json({ error: "Invalid export type" }, { status: 400 });
  }

  await logAudit({
    adminId: admin.id, adminEmail: admin.email,
    action: "EXPORT_CSV", entity: "settings",
    details: { type },
  });

  return new NextResponse(csv, {
    status: 200,
    headers: {
      "Content-Type": "text/csv",
      "Content-Disposition": `attachment; filename="occ-${type}-export-${new Date().toISOString().split("T")[0]}.csv"`,
    },
  });
}
