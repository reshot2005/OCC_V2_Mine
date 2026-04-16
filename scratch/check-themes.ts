import { prisma } from "../src/lib/prisma";

async function check() {
  const clubs = await prisma.club.findMany({
    take: 5,
    select: { name: true, theme: true }
  });
  console.log("Existing club themes:");
  console.table(clubs);
}

check().catch(console.error);
