import { prisma } from "../src/lib/prisma";

async function cleanupDummyUsers() {
  console.log("🔍 Scanning for users with dummy Google registration data...");

  // Find users who:
  // 1. Joined via Google
  // 2. Still have "Not specified" as their college
  // 3. (Optional) have a phone number but haven't updated it manually
  const suspectUsers = await prisma.user.findMany({
    where: {
      OR: [
        { 
            referralSource: "Google registration",
            collegeName: "Not specified"
        },
        {
            phoneNumber: { startsWith: "RAND-" } // In case any use old RAND prefix
        }
      ]
    }
  });

  console.log(`📡 Found ${suspectUsers.length} dummy/suspect users. Resetting...`);

  let count = 0;
  for (const user of suspectUsers) {
    await prisma.user.update({
      where: { id: user.id },
      data: {
        phoneNumber: null, // Wipe the dummy number
        onboardingComplete: false // Force re-onboarding
      }
    });
    count++;
  }

  console.log(`✅ Success! ${count} users have been reset. They will now be hidden and forced to enter a real number.`);
}

cleanupDummyUsers().catch(console.error);
