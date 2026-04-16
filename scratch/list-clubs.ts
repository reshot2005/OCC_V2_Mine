import { prisma } from "../src/lib/prisma";

async function check() {
  const allClubs = await prisma.club.findMany({
    select: { id: true, name: true, slug: true, headerId: true }
  });
  console.log("All Clubs in DB:");
  console.table(allClubs);
}

check().catch(console.error);
