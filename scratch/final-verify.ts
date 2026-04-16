import { resolveClubHeaderByReferralCode } from "../src/lib/referral-resolve";
import { prisma } from "../src/lib/prisma";

async function verifyAll() {
  const headers = await prisma.user.findMany({
    where: { 
      role: "CLUB_HEADER",
      approvalStatus: "APPROVED"
    }
  });

  console.log(`\n🔎 Auditing ${headers.length} Approved Club Headers...\n`);
  
  let successCount = 0;
  for (const h of headers) {
    if (!h.referralCode) {
        console.log(`❌ [FAIL] ${h.email} has NO referral code set.`);
        continue;
    }

    const result = await resolveClubHeaderByReferralCode(h.referralCode);
    
    if (result) {
      console.log(`✅ [WORKING] Code: ${h.referralCode.padEnd(15)} | Header: ${h.fullName.padEnd(20)} | Club: ${result.club.name}`);
      successCount++;
    } else {
      console.log(`❌ [FAIL] Code: ${h.referralCode.padEnd(15)} | Header: ${h.fullName.padEnd(20)} | REASON: Validation rejected or Club missing.`);
    }
  }

  console.log(`\n📊 Final Result: ${successCount}/${headers.length} headers are WORKNG.\n`);
}

verifyAll().catch(console.error);
