import { cookies } from "next/headers";
import { redirect } from "next/navigation";
import { NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { verifyAuthToken } from "@/lib/jwt";
import { staffGateHref } from "@/lib/staff-paths";

export async function getLightSessionUser() {
  const token = cookies().get("occ-token")?.value;
  if (!token) return null;
  try {
    const payload = await verifyAuthToken(token);
    // LIGHTWEIGHT FETCH: only core fields, no relations.
    const user = await prisma.user.findUnique({
      where: { id: payload.userId },
      select: {
        id: true,
        email: true,
        fullName: true,
        role: true,
        suspended: true,
        emailVerified: true,
        adminLevel: true,
        adminRoleTemplateId: true,
      },
    });
    if (!user || user.suspended) return null;
    return user;
  } catch {
    return null;
  }
}

export async function getSessionUser() {
  const token = cookies().get("occ-token")?.value;

  if (!token) return null;

  try {
    const payload = await verifyAuthToken(token);
    const user = await prisma.user.findUnique({
      where: { id: payload.userId },
      include: {
        memberships: {
          include: {
            club: true,
          },
        },
        registrations: {
          include: {
            event: {
              include: {
                club: true,
              },
            },
          },
        },
        gigsApplied: {
          include: {
            gig: true,
          },
        },
        clubManaged: true,
        notifications: {
          orderBy: { createdAt: "desc" },
          take: 10,
        },
      },
    });
    if (user?.suspended) return null;
    return user;
  } catch {
    return null;
  }
}

export async function requireUser() {
  const user = await getSessionUser();
  if (!user) {
    redirect("/login");
  }
  return user;
}

/** Server Components: must be ADMIN or redirect to dashboard */
export async function requireAdmin() {
  const user = await getSessionUser();
  if (!user) {
    redirect(staffGateHref());
  }
  if (user.role !== "ADMIN") {
    redirect("/dashboard");
  }
  return user;
}

type SessionUser = NonNullable<Awaited<ReturnType<typeof getSessionUser>>>;
type LightSessionUser = NonNullable<Awaited<ReturnType<typeof getLightSessionUser>>>;

/** API routes: returns 401 Response or the admin user */
export async function requireAdminApi(): Promise<SessionUser | NextResponse> {
  const user = await getSessionUser();
  if (!user || user.role !== "ADMIN") {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }
  return user;
}

/** API routes (Light): returns 401 Response or the light admin user */
export async function requireLightAdminApi(): Promise<LightSessionUser | NextResponse> {
  const user = await getLightSessionUser();
  if (!user || user.role !== "ADMIN") {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }
  return user;
}
