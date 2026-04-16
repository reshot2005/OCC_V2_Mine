import { prisma } from "../src/lib/prisma";

async function moveElvinToBikers() {
  const elvinEmail = 'elvin.prince@aksharaenterprises.in';
  const bikersSlug = 'bikers';

  console.log(`Moving Elvin Prince (${elvinEmail}) to Bikers...`);

  const user = await prisma.user.findUnique({ where: { email: elvinEmail } });
  const bikersClub = await prisma.club.findUnique({ where: { slug: bikersSlug } });

  if (!user || !bikersClub) {
    console.error("User or Bikers club not found!");
    return;
  }

  // 1. Delete the SJCC Club I created (if it exists)
  await prisma.club.deleteMany({
    where: { 
        name: "SJCC Club",
        headerId: user.id 
    }
  });

  // 2. Transfer Bikers Club to Elvin
  // If there was an old header, we set them to Student role or just un-link them
  if (bikersClub.headerId && bikersClub.headerId !== user.id) {
    await prisma.user.update({
        where: { id: bikersClub.headerId },
        data: { role: "STUDENT", referralCode: null, clubManagedId: null }
    });
  }

  await prisma.club.update({
    where: { id: bikersClub.id },
    data: { headerId: user.id }
  });

  await prisma.user.update({
    where: { id: user.id },
    data: { clubManagedId: bikersClub.id }
  });

  console.log(`✅ Success! Elvin Prince (${user.referralCode}) is now the leader of the "${bikersClub.name}" club.`);
}

moveElvinToBikers().catch(console.error);
