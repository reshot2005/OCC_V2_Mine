import { prisma } from "../src/lib/prisma";

async function forceGooglePhoneReset() {
  console.log("🚀 FORCING RESET: Wiping all phone numbers for Google-registered students...");

  // EVERY student who joined via Google is suspect because they all got dummy numbers.
  const googleUsers = await prisma.user.findMany({
    where: {
      referralSource: "Google registration",
      role: "STUDENT"
    }
  });

  console.log(`📡 Found ${googleUsers.length} total Google students. Wiping phone numbers...`);

  let count = 0;
  for (const user of googleUsers) {
    await prisma.user.update({
      where: { id: user.id },
      data: {
        phoneNumber: null, // This triggers the Phase 3 redirect
        onboardingComplete: false // Ensures they go through the flow
      }
    });
    count++;
  }

  console.log(`✅ Success! ${count} Google users must now provide a real phone number on their next click/refresh.`);
}

forceGooglePhoneReset().catch(console.error);
