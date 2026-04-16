import { prisma } from "../src/lib/prisma";

async function repair() {
  const email = 'elvin.prince@aksharaenterprises.in';
  const targetCode = 'ELVINOCC';

  console.log(`Starting repair for ${email}...`);

  // 1. Update the referral code
  const updatedUser = await prisma.user.update({
    where: { email },
    data: {
      referralCode: targetCode,
      approvalStatus: 'APPROVED',
      role: 'CLUB_HEADER'
    }
  });

  console.log(`Updated referral code to: ${updatedUser.referralCode}`);

  // 2. Clear out any existing club links to avoid unique constraint if we are re-running
  // Actually, headerId is @unique on Club, so let's check one last time
  const existingClub = await prisma.club.findFirst({
    where: { headerId: updatedUser.id }
  });

  if (!existingClub) {
    console.log("No club found for this header. Creating one...");
    const newClub = await prisma.club.create({
      data: {
        name: "SJCC Club",
        slug: "sjcc-club-" + Math.random().toString(36).substring(7),
        description: "Official club for St. Josephs College of Commerce members led by Elvin Prince.",
        headerId: updatedUser.id,
        theme: "indigo",
        icon: "🏢"
      }
    });
    
    await prisma.user.update({
      where: { id: updatedUser.id },
      data: { clubManagedId: newClub.id }
    });
    
    console.log(`Successfully created and linked club: ${newClub.name}`);
  } else {
    console.log(`User already leads: ${existingClub.name}`);
  }

  console.log("Repair complete! The referral code ELVINOCC is now active.");
}

repair().catch(console.error);
