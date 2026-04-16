import { prisma } from "../src/lib/prisma";

async function auditRemainingUsers() {
  console.log("🕵️ Auditing all remaining users with phone numbers...");

  const users = await prisma.user.findMany({
    where: {
      phoneNumber: { not: null },
      role: "STUDENT"
    },
    select: {
      fullName: true,
      email: true,
      phoneNumber: true,
      collegeName: true,
      referralSource: true
    }
  });

  const googleUsers = users.filter(u => u.referralSource === "Google registration");
  const manualUsers = users.filter(u => u.referralSource !== "Google registration");

  console.log(`\n📊 Total Students with Phones: ${users.length}`);
  console.log(`🔗 Manual Registrations: ${manualUsers.length}`);
  console.log(`🌐 Google Registrations: ${googleUsers.length}`);

  if (googleUsers.length > 0) {
    console.log("\n⚠️ LIST OF GOOGLE USERS (Review for dummy numbers):");
    console.table(googleUsers.map(u => ({
      Name: u.fullName,
      Email: u.email,
      Phone: u.phoneNumber,
      College: u.collegeName
    })));
  } else {
    console.log("\n✅ No Google users found with phone numbers. All are now forced to re-verify!");
  }
}

auditRemainingUsers().catch(console.error);
