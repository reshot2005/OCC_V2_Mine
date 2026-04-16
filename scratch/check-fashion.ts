import { prisma } from "../src/lib/prisma";

async function check() {
  const u = await prisma.user.findUnique({ where: { email: 'fashion@gmail.com' } });
  console.log("User fashion@gmail.com:", u?.id, u?.fullName);
  
  const c = await prisma.club.findUnique({ where: { id: 'club-fashion' } });
  console.log("Club club-fashion headerId:", c?.headerId);
}

check().catch(console.error);
