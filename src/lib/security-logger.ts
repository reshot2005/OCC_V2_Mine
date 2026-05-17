import { NextRequest } from "next/server";
import { prisma } from "@/lib/prisma";

/**
 * Lightweight security logging for API routes
 * Logs suspicious activity without bloating middleware
 */

export async function logSecurityEvent(params: {
  req: NextRequest;
  eventType: string;
  severity: "LOW" | "MEDIUM" | "HIGH" | "CRITICAL";
  details: Record<string, unknown>;
  userId?: string | null;
}) {
  const ip = extractClientIp(params.req);
  const userAgent = params.req.headers.get("user-agent") || "Unknown";
  const path = params.req.nextUrl.pathname;

  // Always log to console for immediate visibility
  console.log(`[SOC EVENT] ${params.eventType} | IP: ${ip} | Severity: ${params.severity} | Path: ${path} | Details: ${JSON.stringify(params.details)}`);

  try {
    await prisma.suspiciousAccess.create({
      data: {
        ipAddress: ip,
        userAgent,
        path,
        reason: `${params.eventType}: ${JSON.stringify(params.details)}`,
        severity: params.severity,
        userId: params.userId ?? null,
      }
    });
    console.log(`[SOC EVENT] Logged to database successfully`);
  } catch (e) {
    console.error("[security-logger] Failed to log to database:", e);
  }
}

function extractClientIp(req: NextRequest): string {
  const forwarded = req.headers.get("x-forwarded-for") || "";
  const realIp = req.headers.get("x-real-ip") || "";
  const cfConnectingIp = req.headers.get("cf-connecting-ip") || "";
  
  if (cfConnectingIp) return cfConnectingIp;
  if (realIp) return realIp;
  if (forwarded) return forwarded.split(",")[0].trim();
  
  return req.headers.get("host") || "unknown";
}

export function detectSuspiciousPatterns(req: NextRequest): { isSuspicious: boolean; patterns: string[] } {
  const patterns: string[] = [];
  const userAgent = req.headers.get("user-agent")?.toLowerCase() || "";
  const url = req.url.toLowerCase();
  const queryString = req.nextUrl.search.toLowerCase();

  // Detect curl/wget/python scripts
  if (userAgent.includes("curl")) patterns.push("curl");
  if (userAgent.includes("wget")) patterns.push("wget");
  if (userAgent.includes("python")) patterns.push("python");
  if (userAgent.includes("requests")) patterns.push("python-requests");

  // Detect SQL injection
  if (/('|--|;|select|insert|update|delete|drop|union|exec)/i.test(url + queryString)) {
    patterns.push("sql_injection");
  }

  // Detect XSS
  if (/<script|javascript:|onerror=|onload=|alert\(/i.test(url + queryString)) {
    patterns.push("xss");
  }

  // Detect path traversal
  if (/\.\.\/|\.\.\\|%2e%2e%2f/i.test(url + queryString)) {
    patterns.push("path_traversal");
  }

  // Detect admin enumeration
  if (/admin|staff|gate|control|panel|dashboard/i.test(url)) {
    patterns.push("admin_enumeration");
  }

  return {
    isSuspicious: patterns.length > 0,
    patterns
  };
}

/**
 * Wrap any API handler with security logging
 * Usage: export const GET = withSecurityLogging(async (req) => { ... })
 */
export function withSecurityLogging(
  handler: (req: NextRequest) => Promise<Response>
) {
  return async (req: NextRequest): Promise<Response> => {
    const suspicious = detectSuspiciousPatterns(req);
    
    if (suspicious.isSuspicious) {
      await logSecurityEvent({
        req,
        eventType: "API_REQUEST_SUSPICIOUS",
        severity: suspicious.patterns.includes("sql_injection") || suspicious.patterns.includes("xss") ? "HIGH" : "MEDIUM",
        details: { 
          patterns: suspicious.patterns, 
          method: req.method,
          endpoint: req.nextUrl.pathname 
        },
        userId: null
      });
    }
    
    return handler(req);
  };
}
