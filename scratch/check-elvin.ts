import { prisma } from "../src/lib/prisma";

async function check() {
  const email = 'elvin.prince@aksharaenterprises.in';
  const user = await prisma.user.findUnique({
    where: { email },
    include: { clubManaged: true }
  });

  console.log("User details for " + email + ":");
  console.dir(user, { depth: null });
  
  const clubs = await prisma.club.findMany({
    where: {
      OR: [
        { headerId: user?.id },
        { name: { contains: "Elvin" } }
      ]
    }
  });
  console.log("\nAssociated Clubs:");
  console.dir(clubs, { depth: null });
}

check().catch(console.error);
