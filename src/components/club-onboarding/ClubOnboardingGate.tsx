"use client";

import { useEffect, useState, type ComponentType } from "react";
import { loadFrameSequence } from "@/lib/loadFrameSequence";
import type { ClubOnboardingSlug } from "@/config/clubOnboardingQuestions";
import { ClubOnboardingFlow } from "@/components/club-onboarding/ClubOnboardingFlow";
import { useClubOnboarding } from "@/hooks/useClubOnboarding";

export function ClubOnboardingGate({
  clubSlug,
  framesPath,
  totalFrames,
  framePrefix = "",
  Experience,
  userId,
  skipFramePreload = false,
}: {
  clubSlug: ClubOnboardingSlug;
  framesPath: string;
  totalFrames: number;
  framePrefix?: string;
  Experience: ComponentType<any>;
  userId?: string | null;
  skipFramePreload?: boolean;
}) {
  const onboarding = useClubOnboarding({ clubSlug, userId });
  const [frameLoadProgress, setFrameLoadProgress] = useState(0);
  const [framesPreloadComplete, setFramesPreloadComplete] = useState(false);
  const [experienceMounted, setExperienceMounted] = useState(false);
  const [revealing, setRevealing] = useState(false);
  const [revealed, setRevealed] = useState(false);

  // Start loading immediately on mount (during questions). No loadStarted ref:
  // React Strict Mode remounts would skip the second effect and leave progress
  // stuck at 0%. Progress is broadcast to all subscribers (see loadFrameSequence).
  useEffect(() => {
    if (skipFramePreload) {
      setFrameLoadProgress(1);
      setFramesPreloadComplete(true);
      setExperienceMounted(true);
      return;
    }

    let released = false;

    void loadFrameSequence(
      framesPath,
      totalFrames,
      (p) => {
        if (released) return;
        setFrameLoadProgress(p);
      },
      framePrefix,
    ).then(() => {
      if (released) return;
      setFrameLoadProgress(1);
      setFramesPreloadComplete(true);
      setExperienceMounted(true);
    });

    return () => {
      released = true;
    };
  }, [framesPath, totalFrames, skipFramePreload, framePrefix]);

  // Reveal only when onboarding is done AND every frame has finished loading
  useEffect(() => {
    if (
      !framesPreloadComplete ||
      !experienceMounted ||
      !onboarding.isComplete ||
      revealing ||
      revealed
    ) {
      return;
    }

    const startReveal = window.setTimeout(() => {
      setRevealing(true);
    }, 250);

    return () => window.clearTimeout(startReveal);
  }, [
    experienceMounted,
    framesPreloadComplete,
    onboarding.isComplete,
    revealed,
    revealing,
  ]);

  useEffect(() => {
    if (!revealing) return;

    const finishReveal = window.setTimeout(() => {
      setRevealed(true);
    }, 700);

    return () => window.clearTimeout(finishReveal);
  }, [revealing]);

  const assetsLoadProgress =
    !skipFramePreload && !framesPreloadComplete ? frameLoadProgress : null;

  return (
    <>
      {experienceMounted ? <Experience /> : null}
      {!revealed ? (
        <ClubOnboardingFlow
          config={onboarding.config}
          activeIndex={onboarding.activeIndex}
          activePrompt={onboarding.activeQuestion.prompt}
          progress={onboarding.progress}
          selectedOption={onboarding.selectedOption}
          isAdvancing={onboarding.isAdvancing}
          phase={
            revealing
              ? "revealing"
              : onboarding.isComplete
                ? "holding"
                : "questions"
          }
          onChooseOption={onboarding.chooseOption}
          assetsLoadProgress={assetsLoadProgress}
        />
      ) : null}
    </>
  );
}
