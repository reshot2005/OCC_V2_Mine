"use client";

import dynamic from "next/dynamic";
import type { ComponentType } from "react";
import { ClubOnboardingGate } from "@/components/club-onboarding/ClubOnboardingGate";
import { StaticClubExperience } from "@/components/club-onboarding/StaticClubExperience";
import type { ClubOnboardingSlug } from "@/config/clubOnboardingQuestions";
import { FRAMES_PATH, TOTAL_FRAMES } from "@/app/components/bikers/constants";
import {
  FOOTBALL_FRAMES_PATH,
  FOOTBALL_TOTAL_FRAMES,
} from "@/app/components/football/footballConstants";
import {
  PHOTO_FRAMES_PATH,
  PHOTO_TOTAL_FRAMES,
} from "@/app/components/photography/photographyConstants";
import {
  FASHION_FRAMES_PATH,
  FASHION_TOTAL_FRAMES,
} from "@/app/components/fashion/fashionConstants";
import {
  MUSIC_FRAMES_PATH,
  MUSIC_TOTAL_FRAMES,
} from "@/app/components/music/MusicConstants";
import {
  FITNESS_FRAMES_PATH,
  FITNESS_TOTAL_FRAMES,
} from "@/app/components/fitness/fitnessConstants";

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
const MusicPage = dynamic(
  () => import("@/app/components/music/MusicPage").then((mod) => mod.MusicPage),
  { ssr: false },
);
const FitnessPage = dynamic(
  () => import("@/app/components/fitness/FitnessPage").then((mod) => mod.FitnessPage),
  { ssr: false },
);

function MusicStatic() {
  return <StaticClubExperience clubSlug="music" />;
}

function FitnessStatic() {
  return <StaticClubExperience clubSlug="fitness" />;
}

type ExperienceEntry = {
  framesPath: string;
  totalFrames: number;
  // Dynamic next/dynamic() pages use ComponentType<{}>; widen for the map.
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  Experience: ComponentType<any>;
  skipFramePreload: boolean;
};

const EXPERIENCE_MAP = {
  bikers: {
    framesPath: FRAMES_PATH,
    totalFrames: TOTAL_FRAMES,
    Experience: BikersRidePage as ComponentType<any>,
    skipFramePreload: false,
  },
  sports: {
    framesPath: FOOTBALL_FRAMES_PATH,
    totalFrames: FOOTBALL_TOTAL_FRAMES,
    Experience: FootballPage as ComponentType<any>,
    skipFramePreload: false,
  },
  photography: {
    framesPath: PHOTO_FRAMES_PATH,
    totalFrames: PHOTO_TOTAL_FRAMES,
    Experience: PhotographyPage as ComponentType<any>,
    skipFramePreload: false,
  },
  fashion: {
    framesPath: FASHION_FRAMES_PATH,
    totalFrames: FASHION_TOTAL_FRAMES,
    Experience: FashionPage as ComponentType<any>,
    skipFramePreload: false,
  },
  music: {
    framesPath: MUSIC_FRAMES_PATH,
    totalFrames: MUSIC_TOTAL_FRAMES,
    Experience: () => <MusicPage hideLoader />,
    skipFramePreload: false,
  },
  fitness: {
    framesPath: FITNESS_FRAMES_PATH,
    totalFrames: FITNESS_TOTAL_FRAMES,
    Experience: () => <FitnessPage hideLoader />,
    skipFramePreload: false,
  },
} satisfies Record<ClubOnboardingSlug, ExperienceEntry>;

export function ClubOnboardingEntry({
  clubSlug,
  userId,
}: {
  clubSlug: ClubOnboardingSlug;
  userId?: string | null;
}) {
  const experience = EXPERIENCE_MAP[clubSlug];

  return (
    <ClubOnboardingGate
      clubSlug={clubSlug}
      framesPath={experience.framesPath}
      totalFrames={experience.totalFrames}
      Experience={experience.Experience}
      skipFramePreload={experience.skipFramePreload}
      userId={userId}
    />
  );
}
