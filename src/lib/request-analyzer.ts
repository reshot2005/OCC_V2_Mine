import { NextRequest } from "next/server";
import { prisma } from "@/lib/prisma";

/**
 * Professional SOC-level request analyzer for detecting automated attacks
 * Analyzes user-agent, request patterns, headers, and timing
 */

export interface RequestFingerprint {
  ip: string;
  userAgent: string;
  acceptLanguage: string;
  acceptEncoding: string;
  connection?: string;
  cacheControl?: string;
  pragma?: string;
  isHeadlessBrowser: boolean;
  isKnownBot: boolean;
  isScriptTool: boolean;
  suspiciousHeaders: string[];
  automationScore: number; // 0-100, higher = more suspicious
}

export interface AttackSignature {
  type: "BRUTE_FORCE" | "SQL_INJECTION" | "XSS" | "PATH_TRAVERSAL" | "ADMIN_ENUMERATION" | "RATE_LIMIT_BYPASS" | "CURL_SCAN";
  severity: "LOW" | "MEDIUM" | "HIGH" | "CRITICAL";
  pattern: RegExp;
  description: string;
}

// Known attack signatures
const ATTACK_SIGNATURES: AttackSignature[] = [
  {
    type: "SQL_INJECTION",
    severity: "HIGH",
    pattern: /('|(--)|(;)|(\b(SELECT|INSERT|UPDATE|DELETE|DROP|UNION|EXEC)\b)|(\b(OR|AND)\s+\d+\s*=\s*\d))/i,
    description: "SQL injection patterns detected"
  },
  {
    type: "XSS",
    severity: "HIGH",
    pattern: /(<script|javascript:|onerror=|onload=|alert\(|document\.cookie)/i,
    description: "XSS payload detected"
  },
  {
    type: "PATH_TRAVERSAL",
    severity: "HIGH",
    pattern: /(\.\.\/|\.\.\\|%2e%2e%2f|%252e%252e%252f)/i,
    description: "Path traversal attempt"
  },
  {
    type: "ADMIN_ENUMERATION",
    severity: "MEDIUM",
    pattern: /(admin|administrator|staff|gate|control|panel|dashboard)/i,
    description: "Admin path enumeration"
  },
  {
    type: "BRUTE_FORCE",
    severity: "MEDIUM",
    pattern: /(password|pass|pwd|login|auth)/i,
    description: "Authentication-related enumeration"
  }
];

// Known bot/curl user-agent patterns
const BOT_PATTERNS = [
  /curl/i,
  /wget/i,
  /python/i,
  /requests/i,
  /httpie/i,
  /postman/i,
  /insomnia/i,
  /swagger/i,
  /bot/i,
  /crawler/i,
  /spider/i,
  /scraper/i,
  /headless/i,
  /phantom/i,
  /selenium/i,
  /puppeteer/i,
  /playwright/i,
];

// Headless browser indicators
const HEADLESS_INDICATORS = [
  /headless/i,
  /webdriver/i,
  /selenium/i,
  /phantom/i,
  /chrome\/\d+\.\d+\.\d+\.\d+.*headless/i,
];

/**
 * Extract comprehensive request fingerprint
 */
export function extractRequestFingerprint(req: NextRequest): RequestFingerprint {
  const ip = extractClientIp(req);
  const userAgent = req.headers.get("user-agent") || "Unknown";
  const acceptLanguage = req.headers.get("accept-language") || "";
  const acceptEncoding = req.headers.get("accept-encoding") || "";
  const connection = req.headers.get("connection") || "";
  const cacheControl = req.headers.get("cache-control") || "";
  const pragma = req.headers.get("pragma") || "";

  const suspiciousHeaders: string[] = [];

  // Check for suspicious headers
  if (!acceptLanguage) suspiciousHeaders.push("Missing Accept-Language");
  if (!acceptEncoding) suspiciousHeaders.push("Missing Accept-Encoding");
  if (cacheControl === "no-cache") suspiciousHeaders.push("No-Cache header");
  if (pragma === "no-cache") suspiciousHeaders.push("Pragma no-cache");

  const isKnownBot = BOT_PATTERNS.some(pattern => pattern.test(userAgent));
  const isScriptTool = /(curl|wget|python|requests|httpie)/i.test(userAgent);
  const isHeadlessBrowser = HEADLESS_INDICATORS.some(pattern => pattern.test(userAgent));

  // Calculate automation score
  let automationScore = 0;
  if (isKnownBot) automationScore += 40;
  if (isScriptTool) automationScore += 50;
  if (isHeadlessBrowser) automationScore += 30;
  if (suspiciousHeaders.length > 0) automationScore += suspiciousHeaders.length * 10;
  if (userAgent === "Unknown") automationScore += 20;

  return {
    ip,
    userAgent,
    acceptLanguage,
    acceptEncoding,
    connection,
    cacheControl,
    pragma,
    isHeadlessBrowser,
    isKnownBot,
    isScriptTool,
    suspiciousHeaders,
    automationScore: Math.min(100, automationScore)
  };
}

/**
 * Analyze request for attack signatures
 */
export function detectAttackSignatures(req: NextRequest): AttackSignature[] {
  const detected: AttackSignature[] = [];
  const url = req.url.toLowerCase();
  const headers = Object.fromEntries(req.headers.entries());
  const queryString = req.nextUrl.search;

  // Check URL, query string, and headers
  const targets = [url, queryString, JSON.stringify(headers)];

  for (const signature of ATTACK_SIGNATURES) {
    for (const target of targets) {
      if (signature.pattern.test(target)) {
        detected.push(signature);
        break;
      }
    }
  }

  return detected;
}

/**
 * Extract client IP with proxy support
 */
function extractClientIp(req: NextRequest): string {
  const forwarded = req.headers.get("x-forwarded-for") || "";
  const realIp = req.headers.get("x-real-ip") || "";
  const cfConnectingIp = req.headers.get("cf-connecting-ip") || "";
  
  // Priority: CF-Connecting-IP > X-Real-IP > X-Forwarded-For (first IP)
  if (cfConnectingIp) return cfConnectingIp;
  if (realIp) return realIp;
  if (forwarded) return forwarded.split(",")[0].trim();
  
  return req.headers.get("host") || "unknown";
}

/**
 * Log security event with full context
 */
export async function logSecurityEvent(params: {
  req: NextRequest;
  eventType: string;
  severity: "LOW" | "MEDIUM" | "HIGH" | "CRITICAL";
  details: Record<string, unknown>;
  userId?: string | null;
}) {
  const fingerprint = extractRequestFingerprint(params.req);
  const attacks = detectAttackSignatures(params.req);

  try {
    // Temporarily use SuspiciousAccess until Prisma is regenerated with SecurityEvent model
    await prisma.suspiciousAccess.create({
      data: {
        ipAddress: fingerprint.ip,
        userAgent: fingerprint.userAgent,
        path: params.req.nextUrl.pathname,
        reason: `${params.eventType}: ${attacks.map(a => a.type).join(", ") || "Suspicious activity"}`,
        severity: params.severity,
        userId: params.userId ?? null,
      }
    });
  } catch (e) {
    console.error("[security-event] Failed to log:", e);
  }

  return { fingerprint, attacks };
}

/**
 * Check if request should be blocked based on automation score
 */
export function shouldBlockRequest(fingerprint: RequestFingerprint, threshold = 70): boolean {
  return fingerprint.automationScore >= threshold;
}

/**
 * Generate device fingerprint for tracking
 */
export function generateDeviceFingerprint(fingerprint: RequestFingerprint): string {
  const data = `${fingerprint.ip}:${fingerprint.userAgent}:${fingerprint.acceptLanguage}:${fingerprint.acceptEncoding}`;
  
  // Simple hash (in production, use crypto.createHash)
  let hash = 0;
  for (let i = 0; i < data.length; i++) {
    const char = data.charCodeAt(i);
    hash = ((hash << 5) - hash) + char;
    hash = hash & hash; // Convert to 32bit integer
  }
  
  return Math.abs(hash).toString(16);
}
