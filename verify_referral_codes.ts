import { prisma } from "./src/lib/prisma";
import { resolveClubHeaderByReferralCode } from "./src/lib/referral-resolve";

async function verifyAllCodes() {
  try {
    console.log("Fetching CLUB_HEADER users...");
    const headers = await prisma.user.findMany({
      where: { role: "CLUB_HEADER" },
      select: { id: true, fullName: true, referralCode: true, email: true },
    });

    console.log(`Found ${headers.length} CLUB_HEADER users.`);

    let validCount = 0;
    let invalidCount = 0;

    for (const header of headers) {
      if (!header.referralCode) {
        console.log(`❌ Header ${header.fullName} (${header.email}) has NO referral code.`);
        invalidCount++;
        continue;
      }

      const resolved = await resolveClubHeaderByReferralCode(header.referralCode);
      if (resolved) {
        console.log(`✅ Code ${header.referralCode} works. Belongs to: ${resolved.header.fullName}, Club: ${resolved.club.name}`);
        validCount++;
      } else {
        console.log(`❌ Code ${header.referralCode} for ${header.fullName} FAILED verification.`);
        invalidCount++;
      }
    }

    console.log(`\nSummary: ${validCount} valid, ${invalidCount} invalid.`);
  } catch (error) {
    console.error("Database connection or query failed:", error);
  } finally {
    await prisma.$disconnect();
  }
}

verifyAllCodes();
