import { prisma } from "@/lib/prisma";
import { AnalyticsDashboard } from "@/components/admin-cp/AnalyticsDashboard";

export default async function AdminCPAnalyticsPage() {
  const now = new Date();

  // Signups per day (last 30 days)
  const thirtyDaysAgo = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);
  const recentUsers = await prisma.user.findMany({
    where: { createdAt: { gte: thirtyDaysAgo } },
    select: { createdAt: true },
  });

  const signupsByDay: Record<string, number> = {};
  for (let d = 0; d < 30; d++) {
    const date = new Date(now.getTime() - d * 24 * 60 * 60 * 1000);
    signupsByDay[date.toISOString().split("T")[0]] = 0;
  }
  recentUsers.forEach((u) => {
    const key = u.createdAt.toISOString().split("T")[0];
    if (signupsByDay[key] !== undefined) signupsByDay[key]++;
  });

  // Posts per day (last 30 days)
  const recentPosts = await prisma.post.findMany({
    where: { createdAt: { gte: thirtyDaysAgo } },
    select: { createdAt: true },
  });

  const postsByDay: Record<string, number> = {};
  for (let d = 0; d < 30; d++) {
    const date = new Date(now.getTime() - d * 24 * 60 * 60 * 1000);
    postsByDay[date.toISOString().split("T")[0]] = 0;
  }
  recentPosts.forEach((p) => {
    const key = p.createdAt.toISOString().split("T")[0];
    if (postsByDay[key] !== undefined) postsByDay[key]++;
  });

  // Top clubs by members
  const topClubs = await prisma.club.findMany({
    select: { name: true, _count: { select: { members: true } } },
    orderBy: { memberCount: "desc" },
    take: 10,
  });

  // Role distribution
  const roleDistribution = await prisma.user.groupBy({
    by: ["role"],
    _count: { _all: true },
  });

  return (
    <AnalyticsDashboard
      signupsByDay={Object.entries(signupsByDay).sort().map(([date, count]) => ({ date, count }))}
      postsByDay={Object.entries(postsByDay).sort().map(([date, count]) => ({ date, count }))}
      topClubs={topClubs.map((c) => ({ name: c.name, members: c._count.members }))}
      roleDistribution={roleDistribution.map((r) => ({ role: r.role, count: r._count._all }))}
    />
  );
}
