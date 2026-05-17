import { prisma } from "@/lib/prisma";

/**
 * Professional SOC-level security alerting system
 * Sends real-time alerts for critical security events
 */

export interface SecurityAlert {
  type: "CRITICAL_ATTACK" | "BRUTE_FORCE" | "ADMIN_ENUMERATION" | "AUTOMATED_ATTACK" | "RATE_LIMIT_EXCEEDED" | "SUSPICIOUS_PATTERN";
  severity: "LOW" | "MEDIUM" | "HIGH" | "CRITICAL";
  ipAddress: string;
  userAgent: string;
  path: string;
  details: Record<string, unknown>;
  timestamp: Date;
}

/**
 * Send security alert via multiple channels
 */
export async function sendSecurityAlert(alert: SecurityAlert) {
  // Log to database
  await logSecurityAlert(alert);

  // Send email alert (if configured)
  await sendEmailAlert(alert);

  // Send Slack alert (if configured)
  await sendSlackAlert(alert);

  // Send Sentry alert (if configured)
  await sendSentryAlert(alert);
}

/**
 * Log security alert to database
 */
async function logSecurityAlert(alert: SecurityAlert) {
  try {
    // Temporarily use SuspiciousAccess until Prisma is regenerated
    await prisma.suspiciousAccess.create({
      data: {
        ipAddress: alert.ipAddress,
        userAgent: alert.userAgent,
        path: alert.path,
        reason: `${alert.type}: ${JSON.stringify(alert.details)}`,
        severity: alert.severity,
        resolved: false,
      }
    });
  } catch (e) {
    console.error("[security-alert] Failed to log:", e);
  }
}

/**
 * Send email alert for critical security events
 */
async function sendEmailAlert(alert: SecurityAlert) {
  if (alert.severity !== "CRITICAL" && alert.severity !== "HIGH") return;

  try {
    const { sendSecurityAlert: sendEmail } = await import("@/lib/smtp");
    
    const subject = `[${alert.severity}] ${alert.type} detected from ${alert.ipAddress}`;
    const message = `
Security Alert Details:
- Type: ${alert.type}
- Severity: ${alert.severity}
- IP Address: ${alert.ipAddress}
- User Agent: ${alert.userAgent}
- Path: ${alert.path}
- Timestamp: ${alert.timestamp.toISOString()}

Details: ${JSON.stringify(alert.details, null, 2)}
    `.trim();

    // Send to admin email
    await sendEmailAlertInternal({
      to: process.env.SECURITY_ALERT_EMAIL || process.env.SMTP_USER || "admin@example.com",
      subject,
      message
    });
  } catch (e) {
    console.error("[security-alert] Failed to send email:", e);
  }
}

/**
 * Send Slack alert for security events
 */
async function sendSlackAlert(alert: SecurityAlert) {
  if (!process.env.SLACK_WEBHOOK_URL) return;

  try {
    const webhookUrl = process.env.SLACK_WEBHOOK_URL;
    
    const color = {
      LOW: "good",
      MEDIUM: "warning",
      HIGH: "danger",
      CRITICAL: "danger"
    }[alert.severity];

    const payload = {
      attachments: [
        {
          color,
          title: `🚨 Security Alert: ${alert.type}`,
          fields: [
            {
              title: "Severity",
              value: alert.severity,
              short: true
            },
            {
              title: "IP Address",
              value: alert.ipAddress,
              short: true
            },
            {
              title: "Path",
              value: alert.path,
              short: true
            },
            {
              title: "Timestamp",
              value: alert.timestamp.toISOString(),
              short: true
            },
            {
              title: "User Agent",
              value: alert.userAgent.substring(0, 100),
              short: false
            }
          ],
          footer: "OCC Security Monitoring",
          ts: Math.floor(alert.timestamp.getTime() / 1000)
        }
      ]
    };

    await fetch(webhookUrl, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload)
    });
  } catch (e) {
    console.error("[security-alert] Failed to send Slack alert:", e);
  }
}

/**
 * Send Sentry alert for security events
 */
async function sendSentryAlert(alert: SecurityAlert) {
  if (!process.env.SENTRY_DSN) return;

  try {
    const Sentry = await import("@sentry/nextjs");
    
    Sentry.captureMessage(`Security Alert: ${alert.type}`, {
      level: alert.severity.toLowerCase() as any,
      tags: {
        security_event: "true",
        alert_type: alert.type,
        ip_address: alert.ipAddress,
        severity: alert.severity
      },
      extra: {
        ...alert.details,
        userAgent: alert.userAgent,
        path: alert.path,
        timestamp: alert.timestamp
      }
    });
  } catch (e) {
    console.error("[security-alert] Failed to send Sentry alert:", e);
  }
}

/**
 * Internal email sending function
 */
async function sendEmailAlertInternal(params: { to: string; subject: string; message: string }) {
  const smtp = await import("@/lib/smtp");
  // Use the existing sendOtpEmail function as a template for sending custom emails
  // For now, log to console
  console.log(`[SECURITY EMAIL] To: ${params.to}, Subject: ${params.subject}`);
}

/**
 * Check for attack patterns and trigger alerts
 */
export async function analyzeAndAlert(params: {
  req: Request;
  path: string;
  automationScore: number;
  detectedAttacks: string[];
  userId?: string | null;
}) {
  const ip = params.req.headers.get("x-forwarded-for")?.split(",")[0]?.trim() || 
              params.req.headers.get("x-real-ip") || 
              "unknown";
  const userAgent = params.req.headers.get("user-agent") || "Unknown";

  // Check for critical conditions
  if (params.automationScore >= 80) {
    await sendSecurityAlert({
      type: "AUTOMATED_ATTACK",
      severity: "HIGH",
      ipAddress: ip,
      userAgent,
      path: params.path,
      details: {
        automationScore: params.automationScore,
        detectedAttacks: params.detectedAttacks
      },
      timestamp: new Date()
    });
  }

  // Check for SQL injection or XSS
  if (params.detectedAttacks.includes("SQL_INJECTION") || params.detectedAttacks.includes("XSS")) {
    await sendSecurityAlert({
      type: "CRITICAL_ATTACK",
      severity: "CRITICAL",
      ipAddress: ip,
      userAgent,
      path: params.path,
      details: {
        detectedAttacks: params.detectedAttacks,
        automationScore: params.automationScore
      },
      timestamp: new Date()
    });
  }

  // Check for admin enumeration
  if (params.detectedAttacks.includes("ADMIN_ENUMERATION") && params.automationScore >= 50) {
    await sendSecurityAlert({
      type: "ADMIN_ENUMERATION",
      severity: "HIGH",
      ipAddress: ip,
      userAgent,
      path: params.path,
      details: {
        automationScore: params.automationScore
      },
      timestamp: new Date()
    });
  }

  // Check for brute force patterns (multiple failed attempts from same IP)
  const recentFailures = await prisma.activityEvent.count({
    where: {
      ipAddress: ip,
      eventType: "login_failed",
      createdAt: {
        gte: new Date(Date.now() - 15 * 60 * 1000) // Last 15 minutes
      }
    }
  });

  if (recentFailures >= 10) {
    await sendSecurityAlert({
      type: "BRUTE_FORCE",
      severity: "HIGH",
      ipAddress: ip,
      userAgent,
      path: params.path,
      details: {
        recentFailures,
        timeWindow: "15 minutes"
      },
      timestamp: new Date()
    });
  }
}
