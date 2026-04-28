import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { requireAdminApi, requireLightAdminApi } from "@/lib/auth";
import { logPrivilegedMutation } from "@/lib/mutation-audit";
import { checkAdminMutationRateLimit } from "@/lib/admin-rate-limit";
import {
  type AdminAction,
  type AdminModule,
  can,
  resolveEffectiveAccess,
  type EffectiveAdminAccess,
} from "@/lib/admin-permissions";

export async function getAdminEffectiveAccess(adminId: string): Promise<EffectiveAdminAccess | null> {
  const user = await prisma.user.findUnique({
    where: { id: adminId },
    select: { adminLevel: true, adminRoleTemplate: { select: { permissions: true } } },
  });
  if (!user) return null;
  return resolveEffectiveAccess({
    adminLevel: user.adminLevel,
    templatePermissions: user.adminRoleTemplate?.permissions ?? null,
  });
}

/** API routes: 401 if not admin, 403 if missing permission. */
export async function requireAdminPermission(
  module: AdminModule,
  action: AdminAction,
  req?: Request,
): Promise<{ id: string; email: string; fullName: string; access: EffectiveAdminAccess } | NextResponse> {
  // Optimization: use light session check for READ (GET) requests to save RAM.
  const isRead = req?.method === "GET" || action === "read";
  const admin = isRead ? await requireLightAdminApi() : await requireAdminApi();
  
  if (admin instanceof NextResponse) return admin;

  const access = await getAdminEffectiveAccess(admin.id);
  if (!access) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }
  if (!can(access, module, action)) {
    return NextResponse.json({ error: "Forbidden" }, { status: 403 });
  }

  // Centralized audit trail for privileged API permission checks.
  // Optimization: skip logging for READ actions in high-traffic modules to prevent DB bloat.
  const skipAudit = isRead && module === "audit";

  if (!skipAudit) {
    await logPrivilegedMutation({
      actor: { id: admin.id, email: admin.email, role: "ADMIN" },
      method: req?.method || "MUTATION_OR_READ",
      path: "admin-api-guard",
      module,
      action,
      details: { source: "requireAdminPermission" },
    });
  }

  return {
    id: admin.id,
    email: admin.email,
    fullName: admin.fullName,
    access,
  };
}

/**
 * Strict mutation guard for privileged admin APIs.
 * Keeps existing auth behavior intact while adding centralized abuse limits.
 */
export async function requireAdminMutationPermission(
  req: NextRequest,
  module: AdminModule,
  action: AdminAction,
  opts?: { rateAction?: string; limit?: number; windowMs?: number },
): Promise<{ id: string; email: string; fullName: string; access: EffectiveAdminAccess } | NextResponse> {
  const admin = await requireAdminPermission(module, action);
  if (admin instanceof NextResponse) return admin;

  const gate = checkAdminMutationRateLimit({
    req,
    adminId: admin.id,
    action: opts?.rateAction ?? `${module}:${action}`,
    limit: opts?.limit,
    windowMs: opts?.windowMs,
  });
  if (!gate.ok) {
    return NextResponse.json(
      { error: "Too many privileged requests. Retry shortly." },
      {
        status: 429,
        headers: { "Retry-After": String(gate.retryAfterSec) },
      },
    );
  }
  return admin;
}
