import { NextRequest, NextResponse } from "next/server";
import { requireAdminPermission } from "@/lib/admin-api-guard";
import { prisma } from "@/lib/prisma";

/**
 * SOC Dashboard API - Security monitoring and threat intelligence
 * Provides real-time security data for SOC operations
 */

export async function GET(req: NextRequest) {
  const admin = await requireAdminPermission("compliance", "read");
  if (admin instanceof NextResponse) return admin;

  const searchParams = req.nextUrl.searchParams;
  const timeRange = searchParams.get("timeRange") || "24h";
  const severity = searchParams.get("severity");

  // Calculate time range
  const now = new Date();
  const timeRanges: Record<string, Date> = {
    "1h": new Date(now.getTime() - 60 * 60 * 1000),
    "24h": new Date(now.getTime() - 24 * 60 * 60 * 1000),
    "7d": new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000),
    "30d": new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000),
  };
  const since = timeRanges[timeRange] || timeRanges["24h"];

  // Fetch security metrics
  const [
    suspiciousAccess,
    activityEvents,
    auditLogs,
    recentFailures,
    uniqueIps,
    criticalAlerts
  ] = await Promise.all([
    // Suspicious access logs
    prisma.suspiciousAccess.findMany({
      where: {
        createdAt: { gte: since },
        ...(severity && { severity })
      },
      orderBy: { createdAt: "desc" },
      take: 100
    }),

    // Activity events
    prisma.activityEvent.findMany({
      where: {
        createdAt: { gte: since },
        category: "auth"
      },
      orderBy: { createdAt: "desc" },
      take: 100
    }),

    // Audit logs
    prisma.auditLog.findMany({
      where: {
        createdAt: { gte: since }
      },
      orderBy: { createdAt: "desc" },
      take: 50
    }),

    // Recent login failures
    prisma.activityEvent.groupBy({
      by: ["ipAddress"],
      where: {
        eventType: "login_failed",
        createdAt: { gte: since }
      },
      _count: {
        id: true
      },
      having: {
        id: {
          _count: {
            gt: 5
          }
        }
      },
      orderBy: {
        _count: {
          id: "desc"
        }
      },
      take: 20
    }),

    // Unique IPs
    prisma.activityEvent.findMany({
      where: {
        createdAt: { gte: since },
        ipAddress: { not: null }
      },
      select: {
        ipAddress: true
      },
      distinct: ["ipAddress"]
    }),

    // Critical suspicious access
    prisma.suspiciousAccess.count({
      where: {
        createdAt: { gte: since },
        severity: "HIGH",
        resolved: false
      }
    })
  ]);

  // Calculate statistics
  const totalRequests = activityEvents.length;
  const failedLogins = activityEvents.filter(e => e.eventType === "login_failed").length;
  const successfulLogins = activityEvents.filter(e => e.eventType === "login_success").length;
  const uniqueIpCount = uniqueIps.length;
  const highRiskIps = recentFailures.length;

  // Identify attack patterns
  const attackPatterns = {
    bruteForce: recentFailures.length > 0,
    adminEnumeration: suspiciousAccess.some(s => 
      s.reason.toLowerCase().includes("admin") || s.path.toLowerCase().includes("admin")
    ),
    automatedScripts: suspiciousAccess.filter(s => 
      s.userAgent?.toLowerCase().includes("curl") || 
      s.userAgent?.toLowerCase().includes("python") ||
      s.userAgent?.toLowerCase().includes("wget")
    ).length > 0,
    sqlInjection: suspiciousAccess.some(s => 
      s.reason.toLowerCase().includes("sql")
    ),
    xss: suspiciousAccess.some(s => 
      s.reason.toLowerCase().includes("xss")
    )
  };

  // Top suspicious IPs
  const topSuspiciousIps = recentFailures.map(r => ({
    ipAddress: r.ipAddress,
    failureCount: r._count.id,
    severity: r._count.id > 20 ? "CRITICAL" : r._count.id > 10 ? "HIGH" : "MEDIUM"
  }));

  // Format events for the dashboard page
  const events = suspiciousAccess.map(s => ({
    id: s.id,
    ipAddress: s.ipAddress,
    userAgent: s.userAgent,
    path: s.path,
    reason: s.reason,
    severity: s.severity as "LOW" | "MEDIUM" | "HIGH" | "CRITICAL",
    userId: s.userId,
    createdAt: s.createdAt.toISOString()
  }));

  // Calculate stats
  const total = events.length;
  const high = events.filter(e => e.severity === "HIGH").length;
  const critical = events.filter(e => e.severity === "CRITICAL").length;
  const uniqueEventIps = new Set(events.map(e => e.ipAddress)).size;

  return NextResponse.json({
    events,
    totalPages: Math.ceil(total / 20) || 1,
    stats: { total, high, critical, uniqueIps: uniqueEventIps },
    summary: {
      timeRange,
      since: since.toISOString(),
      now: now.toISOString(),
      totalRequests,
      failedLogins,
      successfulLogins,
      uniqueIpCount,
      highRiskIps,
      criticalAlerts,
      attackDetection: attackPatterns
    },
    suspiciousAccess: events,
    activityEvents: activityEvents.map(e => ({
      id: e.id,
      actorName: e.actorName,
      actorRole: e.actorRole,
      eventType: e.eventType,
      category: e.category,
      summary: e.summary,
      ipAddress: e.ipAddress,
      createdAt: e.createdAt
    })),
    auditLogs: auditLogs.map(a => ({
      id: a.id,
      adminEmail: a.adminEmail,
      action: a.action,
      entity: a.entity,
      entityId: a.entityId,
      ipAddress: a.ipAddress,
      createdAt: a.createdAt
    })),
    topSuspiciousIps,
    recentFailures
  });
}
