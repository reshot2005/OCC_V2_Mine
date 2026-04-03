"use client";

import dynamic from "next/dynamic";

const BikersRidePage = dynamic(
  () => import("@/app/components/bikers/BikersRidePage").then((mod) => mod.BikersRidePage),
  { ssr: false },
);
const FootballPage = dynamic(
  () => import("@/app/components/football/FootballPage").then((mod) => mod.FootballPage),
  { ssr: false },
);
const PhotographyPage = dynamic(
  () => import("@/app/components/photography/PhotographyPage").then((mod) => mod.PhotographyPage),
  { ssr: false },
);
const FashionPage = dynamic(
  () => import("@/app/components/fashion/FashionPage").then((mod) => mod.FashionPage),
  { ssr: false },
);

export function ClubExperience({ slug, embedded = false }: { slug: string; embedded?: boolean }) {
  if (slug === "bikers") return <BikersRidePage embedded={embedded} />;
  if (slug === "sports") return <FootballPage embedded={embedded} />;
  if (slug === "photography") return <PhotographyPage embedded={embedded} />;
  if (slug === "fashion") return <FashionPage embedded={embedded} />;
  return null;
}
