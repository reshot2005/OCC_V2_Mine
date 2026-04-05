import { requireAdmin } from "@/lib/auth";
import { prisma } from "@/lib/prisma";
import { AdminCPShell } from "@/components/admin-cp/AdminCPShell";

export default async function AdminCPLayout({ children }: { children: React.ReactNode }) {
  const user = await requireAdmin();

  const [pendingCount, alertCount] = await Promise.all([
    prisma.user.count({ where: { role: "CLUB_HEADER", approvalStatus: "PENDING" } }),
    prisma.suspiciousAccess.count({ where: { resolved: false } }).catch(() => 0),
  ]);

  return (
    <AdminCPShell
      pendingCount={pendingCount}
      alertCount={alertCount}
      adminUser={{
        id: user.id,
        fullName: user.fullName,
        email: user.email,
        adminLevel: (user as any).adminLevel ?? "SUPER_ADMIN",
      }}
    >
      {children}
    </AdminCPShell>
  );
}
