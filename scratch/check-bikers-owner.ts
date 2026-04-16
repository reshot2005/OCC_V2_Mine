import { prisma } from "../src/lib/prisma";

async function check() {
  const user = await prisma.user.findUnique({
    where: { id: 'cmnr4ki2a000iu79katbp2k6m' }
  });
  console.log("Current header for Bikers club:", user?.email, user?.fullName);
}

check().catch(console.error);
