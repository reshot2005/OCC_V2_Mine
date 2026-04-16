import { prisma } from "../src/lib/prisma";

async function globalRepair() {
  const headers = await prisma.user.findMany({
    where: { 
      role: "CLUB_HEADER",
      approvalStatus: "APPROVED"
    }
  });

  console.log(`Auditing and repairing ${headers.length} headers...`);

  for (const h of headers) {
    const club = await prisma.club.findFirst({ where: { headerId: h.id } });
    
    if (!club) {
      console.log(`Repairing header: ${h.email} (${h.fullName})...`);
      
      // Try to find a club by name if we can, else create a new one
      let clubName = h.collegeName ? `${h.collegeName} Club` : `${h.fullName}'s Club`;
      let slug = (h.fullName.toLowerCase().replace(/\s+/g, '-') + '-' + Math.random().toString(36).substring(7)).slice(0, 30);
      
      try {
        const newClub = await prisma.club.create({
          data: {
            name: clubName.slice(0, 50),
            slug: slug,
            description: `Official club for ${h.collegeName || h.fullName} members.`,
            theme: "blue",
            icon: "🏢",
            headerId: h.id
          }
        });
        
        await prisma.user.update({
          where: { id: h.id },
          data: { clubManagedId: newClub.id }
        });
        
        console.log(`  -> Created and linked: ${newClub.name}`);
      } catch (e) {
        console.error(`  -> Failed to repair ${h.email}:`, e);
      }
    }
  }
}

globalRepair().catch(console.error);
