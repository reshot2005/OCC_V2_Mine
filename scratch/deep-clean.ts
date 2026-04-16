import { prisma } from "../src/lib/prisma";

async function deepCleanDummies() {
  console.log("🧹 Starting Deep Clean of all dummy accounts...");

  // Target 1: Anyone with "Not specified" college
  // Target 2: Anyone with "Not specified" phone
  // Target 3: Known dummy names
  const dummyUsers = await prisma.user.findMany({
    where: {
      OR: [
        { collegeName: "Not specified" },
        { phoneNumber: null },
        { fullName: { in: ["Hi Hi", "Anything", "Anyone", "Yasin Yasin"] } }
      ],
      role: "STUDENT"
    }
  });

  console.log(`📡 Found ${dummyUsers.length} dummy/suspect users to clean.`);

  let resetCount = 0;
  for (const user of dummyUsers) {
    await prisma.user.update({
      where: { id: user.id },
      data: {
        phoneNumber: null, // Wipe the number
        onboardingComplete: false, // Force them to Phase 3
        collegeName: "Not specified" // Reset college to be safe
      }
    });
    resetCount++;
  }

  console.log(`✅ Deep Clean Complete. ${resetCount} accounts have been wiped and hidden from Admin.`);
}

deepCleanDummies().catch(console.error);
