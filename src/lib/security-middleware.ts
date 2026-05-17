import { NextRequest } from "next/server";
import { extractRequestFingerprint, detectAttackSignatures, shouldBlockRequest, logSecurityEvent } from "./request-analyzer";
import { analyzeAndAlert } from "./security-alerting";

/**
 * Professional SOC-level security middleware
 * Integrates request analysis, attack detection, and real-time alerting
 */

export interface SecurityCheckResult {
  shouldBlock: boolean;
  fingerprint: ReturnType<typeof extractRequestFingerprint>;
  attacks: ReturnType<typeof detectAttackSignatures>;
  reason?: string;
}

/**
 * Perform comprehensive security check on incoming request
 */
export async function performSecurityCheck(req: NextRequest, userId?: string | null): Promise<SecurityCheckResult> {
  const fingerprint = extractRequestFingerprint(req);
  const attacks = detectAttackSignatures(req);

  // Console log for immediate visibility
  console.log(
    `[SOC CHECK] IP: ${fingerprint.ip} | ` +
    `Score: ${fingerprint.automationScore} | ` +
    `Bot: ${fingerprint.isKnownBot} | ` +
    `Script: ${fingerprint.isScriptTool} | ` +
    `Attacks: ${attacks.map(a => a.type).join(", ") || "none"}`
  );

  // Log all security events
  await logSecurityEvent({
    req,
    eventType: "REQUEST_ANALYZED",
    severity: fingerprint.automationScore >= 50 ? "MEDIUM" : "LOW",
    details: {
      automationScore: fingerprint.automationScore,
      attacks: attacks.map(a => a.type),
      suspiciousHeaders: fingerprint.suspiciousHeaders
    },
    userId
  });

  // Check if request should be blocked
  if (shouldBlockRequest(fingerprint, 70)) {
    await logSecurityEvent({
      req,
      eventType: "REQUEST_BLOCKED",
      severity: "HIGH",
      details: {
        reason: "High automation score",
        automationScore: fingerprint.automationScore
      },
      userId
    });

    return {
      shouldBlock: true,
      fingerprint,
      attacks,
      reason: "Request blocked due to high automation score"
    };
  }

  // Check for critical attacks
  const criticalAttacks = attacks.filter(a => a.severity === "HIGH" || a.severity === "CRITICAL");
  if (criticalAttacks.length > 0) {
    await logSecurityEvent({
      req,
      eventType: "CRITICAL_ATTACK_DETECTED",
      severity: "CRITICAL",
      details: {
        attacks: criticalAttacks.map(a => ({
          type: a.type,
          severity: a.severity,
          description: a.description
        }))
      },
      userId
    });

    return {
      shouldBlock: true,
      fingerprint,
      attacks,
      reason: "Critical attack pattern detected"
    };
  }

  // Analyze and trigger alerts if needed
  await analyzeAndAlert({
    req,
    path: req.nextUrl.pathname,
    automationScore: fingerprint.automationScore,
    detectedAttacks: attacks.map(a => a.type),
    userId
  });

  return {
    shouldBlock: false,
    fingerprint,
    attacks
  };
}

/**
 * Check if IP is in blacklist
 */
export async function isIpBlacklisted(ip: string): Promise<boolean> {
  // TODO: Implement IP blacklist check from database or external service
  return false;
}

/**
 * Check if IP is rate limited
 */
export async function isIpRateLimited(ip: string, path: string): Promise<boolean> {
  // TODO: Implement rate limiting check
  // For now, check if IP has made too many requests in last minute
  return false;
}

/**
 * Get device information from user agent
 */
export function getDeviceInfo(userAgent: string) {
  const ua = userAgent.toLowerCase();
  
  const device = {
    isMobile: /mobile|android|iphone|ipad|ipod/i.test(ua),
    isTablet: /ipad|tablet/i.test(ua),
    isDesktop: !/mobile|android|iphone|ipad|ipod|tablet/i.test(ua),
    browser: "unknown" as string,
    os: "unknown" as string
  };

  // Browser detection
  if (ua.includes("chrome")) device.browser = "Chrome";
  else if (ua.includes("firefox")) device.browser = "Firefox";
  else if (ua.includes("safari")) device.browser = "Safari";
  else if (ua.includes("edge")) device.browser = "Edge";
  else if (ua.includes("opera")) device.browser = "Opera";

  // OS detection
  if (ua.includes("windows")) device.os = "Windows";
  else if (ua.includes("mac")) device.os = "MacOS";
  else if (ua.includes("linux")) device.os = "Linux";
  else if (ua.includes("android")) device.os = "Android";
  else if (ua.includes("ios") || ua.includes("iphone") || ua.includes("ipad")) device.os = "iOS";

  return device;
}

/**
 * Generate security report for SOC dashboard
 */
export function generateSecurityReport(checkResult: SecurityCheckResult) {
  const deviceInfo = getDeviceInfo(checkResult.fingerprint.userAgent);

  return {
    timestamp: new Date().toISOString(),
    ipAddress: checkResult.fingerprint.ip,
    userAgent: checkResult.fingerprint.userAgent,
    device: deviceInfo,
    automationScore: checkResult.fingerprint.automationScore,
    isKnownBot: checkResult.fingerprint.isKnownBot,
    isScriptTool: checkResult.fingerprint.isScriptTool,
    isHeadlessBrowser: checkResult.fingerprint.isHeadlessBrowser,
    suspiciousHeaders: checkResult.fingerprint.suspiciousHeaders,
    detectedAttacks: checkResult.attacks.map(a => ({
      type: a.type,
      severity: a.severity,
      description: a.description
    })),
    shouldBlock: checkResult.shouldBlock,
    blockReason: checkResult.reason
  };
}
