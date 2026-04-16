import { prisma } from "../src/lib/prisma";

async function audit() {
  const headers = await prisma.user.findMany({
    where: { 
      role: "CLUB_HEADER",
      approvalStatus: "APPROVED"
    },
    include: { clubManaged: true }
  });

  console.log("Auditing CLUB_HEADERs...");
  for (const h of headers) {
    const club = await prisma.club.findFirst({ where: { headerId: h.id } });
    if (!club) {
      console.log(`[!] User ${h.email} (${h.fullName}) has NO CLUB. Referral code ${h.referralCode} will FAIL.`);
    } else {
      console.log(`[OK] User ${h.email} leads ${club.name}. Referral code ${h.referralCode} is ACTIVE.`);
    }
  }
}

audit().catch(console.error);
