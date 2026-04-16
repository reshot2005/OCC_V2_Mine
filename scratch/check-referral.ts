import { prisma } from "../src/lib/prisma";

async function check() {
  const code = "ELVINOCC";
  const users = await prisma.user.findMany({
    where: {
      OR: [
        { referralCode: code },
        { referralCode: code.toLowerCase() },
        { email: { contains: "elvin" } }
      ]
    },
    include: {
      clubManaged: true
    }
  });

  console.log("Found users matching 'ELVINOCC' or 'elvin':");
  console.dir(users, { depth: null });

  const allHeaders = await prisma.user.findMany({
    where: { role: "CLUB_HEADER" },
    select: { email: true, role: true, approvalStatus: true, referralCode: true, clubManagedId: true }
  });
  console.log("\nAll CLUB_HEADERs in DB:");
  console.table(allHeaders);
}

check().catch(console.error);
