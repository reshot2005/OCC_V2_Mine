# Professional SOC-Level Security Monitoring Implementation Guide

## Overview
This guide provides a complete security monitoring implementation for detecting automated scripts, curl commands, and attacks against your Vercel-deployed application with complete IP and device tracking.

## Implementation Steps

### 1. Database Schema Updates

Run the following to regenerate Prisma client after schema changes:
```bash
npx prisma generate
npx prisma db push
```

### 2. Environment Variables

Add these to your `.env` file:
```env
# Security Alerting
SECURITY_ALERT_EMAIL="your-security@example.com"
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/YOUR/WEBHOOK/URL"
SENTRY_DSN="your-sentry-dsn"

# Security Thresholds
AUTOMATION_SCORE_THRESHOLD=70
BRUTE_FORCE_THRESHOLD=10
RATE_LIMIT_WINDOW_MS=60000
```

### 3. Middleware Integration

Add to your `middleware.ts` to enable automatic security monitoring:

```typescript
import { performSecurityCheck } from "@/lib/security-analyzer";

// In your middleware function
export async function middleware(req: NextRequest) {
  const token = req.cookies.get("occ-token")?.value;
  const userId = token ? (await verifyAuthToken(token)).userId : null;

  // Perform security check on all requests
  const securityCheck = await performSecurityCheck(req, userId);
  
  if (securityCheck.shouldBlock) {
    console.warn(`[SECURITY] Blocked request from ${securityCheck.fingerprint.ip}: ${securityCheck.reason}`);
    return new NextResponse("Access Denied", { status: 403 });
  }

  // Continue with existing middleware logic...
}
```

### 4. Vercel Monitoring Setup

#### A. Enable Vercel Analytics
```bash
npm install @vercel/analytics
```

Add to `app/layout.tsx`:
```tsx
import { Analytics } from '@vercel/analytics/react';

export default function RootLayout({ children }) {
  return (
    <html>
      <body>
        {children}
        <Analytics />
      </body>
    </html>
  );
}
```

#### B. Configure Vercel Log Drains
Add to `vercel.json`:
```json
{
  "integrations": {
    "sentry": {
      "dsn": process.env.SENTRY_DSN
    }
  },
  "build": {
    "env": {
      "SENTRY_DSN": "@sentry-dsn"
    }
  }
}
```

#### C. Set Up Vercel Webhook for Real-time Alerts
1. Go to Vercel Dashboard → Your Project → Settings → Webhooks
2. Add webhook URL to receive deployment and error notifications
3. Configure to trigger on: Deployment Errors, Build Errors

### 5. Real-time Alerting Configuration

#### Email Alerts
Already configured via `sendSecurityAlert()` in `security-alerting.ts`
- Critical alerts sent immediately
- High alerts sent within 1 minute
- Medium alerts aggregated and sent hourly

#### Slack Integration
1. Create Slack Incoming Webhook: https://api.slack.com/messaging/webhooks
2. Add webhook URL to environment variables
3. Alerts include: IP, User Agent, Path, Attack Type, Severity

#### Sentry Integration
Already configured via Sentry SDK
- Captures security events with tags
- Provides real-time error tracking
- Includes IP and device fingerprinting

### 6. SOC Dashboard Access

Access the security dashboard at:
```
https://your-domain.com/k9xm2p7qv4nw8-admin-control-panel/security
```

Dashboard provides:
- Real-time threat overview
- Top suspicious IPs
- Attack pattern detection
- Failed login attempts
- Unique IP tracking
- Security event timeline

## Detection Capabilities

### Automated Script Detection
- **Curl Commands**: Detected via user-agent pattern matching
- **Python Scripts**: Detected via python-requests user-agent
- **Headless Browsers**: Detected via headless Chrome indicators
- **Bot Patterns**: Detected via known bot signatures

### Attack Detection
- **SQL Injection**: Pattern matching for SQL keywords
- **XSS**: Pattern matching for script tags and javascript:
- **Path Traversal**: Detection of ../ and encoded variants
- **Admin Enumeration**: Detection of admin path probing
- **Brute Force**: Rate-based detection of repeated failures

### Device Fingerprinting
- IP Address (with proxy support)
- User Agent analysis
- Accept-Language header
- Accept-Encoding header
- Browser type detection
- OS detection
- Device type (mobile/tablet/desktop)

## Response Procedures

### Immediate Response (Critical Alerts)
1. **Block IP**: Add to Vercel Edge Config or Cloudflare WAF
2. **Investigate**: Check SOC dashboard for attack pattern
3. **Notify**: Alert security team via Slack/email
4. **Document**: Log incident in audit trail

### Automated Response
- High automation score (>70): Auto-block request
- Critical attack patterns: Auto-block and alert
- Brute force detection: Rate limit IP
- SQL injection/XSS: Immediate block and alert

### Manual Response
1. Review SOC dashboard for suspicious activity
2. Check IP reputation (VirusTotal, AbuseIPDB)
3. Analyze attack patterns
4. Decide on blocking strategy
5. Update security rules as needed

## Monitoring Best Practices

### Daily Checks
- Review security dashboard for new threats
- Check failed login patterns
- Monitor unusual IP activity
- Review automation score trends

### Weekly Reviews
- Analyze attack trends
- Update detection rules
- Review false positives
- Adjust thresholds if needed

### Monthly Reports
- Generate security summary
- Review incident response effectiveness
- Update threat intelligence
- Plan security improvements

## Integration with Existing Security

### Current Security Features
- ✅ Audit logs (admin actions)
- ✅ Activity events (all user actions)
- ✅ Suspicious access logging
- ✅ Rate limiting (login, admin mutations)
- ✅ CSRF protection
- ✅ Security alerts (admin login)

### New Security Features
- ✅ Request fingerprinting
- ✅ Bot/automation detection
- ✅ Attack signature detection
- ✅ Real-time alerting (Email, Slack, Sentry)
- ✅ SOC dashboard
- ✅ Device fingerprinting
- ✅ IP reputation tracking
- ✅ Automated response

## Testing the Implementation

### Test Automated Script Detection
```bash
# Test curl detection
curl -I https://your-domain.com/api/test

# Test python detection
python3 -c "import requests; requests.get('https://your-domain.com/api/test')"

# Check SOC dashboard for detection
```

### Test Attack Detection
```bash
# Test SQL injection detection
curl "https://your-domain.com/api/users?id=1' OR '1'='1"

# Test XSS detection
curl "https://your-domain.com/api/search?q=<script>alert(1)</script>"

# Check SOC dashboard for alerts
```

### Test Alerting
```bash
# Trigger a high-severity event
# Check email for alert
# Check Slack for alert
# Check Sentry for event
```

## Vercel-Specific Monitoring

### Vercel Analytics
- Real-time page views
- Geographic distribution
- Device breakdown
- Performance metrics

### Vercel Logs
- Real-time log streaming
- Filter by status code
- Search by IP address
- Export logs for analysis

### Vercel Edge Config
- IP blacklisting
- Rate limiting rules
- Redirect rules
- Header manipulation

### Vercel Webhooks
- Deployment notifications
- Error alerts
- Build status updates
- Custom webhook triggers

## Incident Response Playbook

### Phase 1: Detection (0-5 minutes)
1. Alert received via Email/Slack/Sentry
2. Check SOC dashboard for details
3. Identify attack type and source IP
4. Assess severity and impact

### Phase 2: Containment (5-15 minutes)
1. Block attacking IP (Vercel Edge Config)
2. Enable enhanced rate limiting
3. Update WAF rules if applicable
4. Notify affected users if needed

### Phase 3: Investigation (15-60 minutes)
1. Analyze attack patterns
2. Check for successful compromises
3. Review audit logs for suspicious activity
4. Determine attack vector

### Phase 4: Eradication (1-4 hours)
1. Patch vulnerabilities if found
2. Reset compromised credentials
3. Update security rules
4. Enhance monitoring

### Phase 5: Recovery (4-24 hours)
1. Monitor for continued attacks
2. Verify security measures
3. Document incident
4. Update procedures

### Phase 6: Post-Incident (1-7 days)
1. Conduct post-mortem
2. Update threat intelligence
3. Improve detection rules
4. Train team on lessons learned

## Maintenance

### Regular Tasks
- Update attack signatures monthly
- Review and adjust thresholds quarterly
- Update bot patterns regularly
- Monitor false positive rates

### Updates
- Keep dependencies updated
- Update detection rules
- Enhance fingerprinting algorithms
- Add new attack patterns

## Troubleshooting

### Alerts Not Sending
1. Check environment variables
2. Verify webhook URLs
3. Check Sentry configuration
4. Review error logs

### False Positives
1. Adjust automation score threshold
2. Update bot patterns
3. Add whitelist for legitimate tools
4. Review detection rules

### Performance Impact
1. Optimize database queries
2. Add caching for security checks
3. Use edge functions for blocking
4. Monitor response times

## Compliance

### Data Protection
- IP addresses stored in compliance with GDPR
- User agents stored for security purposes only
- Data retention policy: 90 days for security logs
- Data export available for audits

### Audit Trail
- All security events logged
- Immutable audit trail
- Tamper-evident logging
- Regular integrity checks

## Support

For issues or questions:
1. Check SOC dashboard first
2. Review this guide
3. Check Vercel logs
4. Contact security team

## Next Steps

1. ✅ Implement database schema changes
2. ✅ Add environment variables
3. ✅ Integrate security middleware
4. ✅ Configure Vercel monitoring
5. ✅ Set up alerting channels
6. ✅ Test detection capabilities
7. ✅ Train team on SOC dashboard
8. ✅ Establish incident response procedures
