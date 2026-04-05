import { setFrameImageSrc } from "./frameImage";

function normalizeBase(basePath: string) {
  const b = basePath.trim();
  if (!b) return "/";
  let path = b.startsWith("/") ? b : `/${b}`;
  if (!path.endsWith("/")) path += "/";
  return path;
}

const EASE = 0.02; // Drastically lower for ultra-long coasting

/**
 * Loads numbered frames (0001.jpg …) for scroll-cinema. Handles cached images.
 * Falls back to .webp for the same stem if .jpg fails (optional asset format).
 */
export async function loadFrameSequence(
  basePath: string,
  totalFrames: number,
  onProgress: (p: number) => void,
  prefix: string = "",
): Promise<HTMLImageElement[]> {
  const cdnBase = (process.env.NEXT_PUBLIC_FRAMES_CDN_BASE || process.env.VITE_FRAMES_CDN_BASE || "").replace(/\/$/, "");
  const normalizedBase = normalizeBase(basePath);
  const base = normalizedBase.startsWith("http") ? normalizedBase : `${cdnBase}${normalizedBase}`;
  const imgs: HTMLImageElement[] = new Array(totalFrames);
  let completed = 0;

  const bump = () => {
    completed++;
    onProgress(completed / totalFrames);
  };

  const loadIndex = (index: number) =>
    new Promise<void>((resolve) => {
      const padded = String(index + 1).padStart(4, "0");
      let settled = false;

      const finish = (ok: boolean, el: HTMLImageElement | null) => {
        if (settled) return;
        settled = true;
        if (ok && el) imgs[index] = el;
        bump();
        resolve();
      };

      const tryExt = (ext: ".jpg" | ".webp") => {
        const potentialSrcs = [
          `${base}${prefix}${padded}${ext}`,
          `${base}${padded}${ext}`,
          `${base}frame_${padded}${ext}`,
          `/fitness-frames/${prefix}${padded}${ext}`, // local fallback
        ];

        let attemptIdx = 0;

        const attempt = () => {
          if (attemptIdx >= potentialSrcs.length) {
            if (ext === ".jpg") tryExt(".webp");
            else finish(false, null);
            return;
          }

          const currentSrc = potentialSrcs[attemptIdx];
          const img = new Image();
          img.onload = () => finish(true, img);
          img.onerror = () => {
            attemptIdx++;
            attempt();
          };
          setFrameImageSrc(img, currentSrc);
          if (img.complete && img.naturalWidth > 0) {
            finish(true, img);
          }
        };

        attempt();
      };

      tryExt(".jpg");
    });

  // Aggressive parallel loading with concurrency limit
  const CONCURRENCY = 100;
  const pool = new Set<Promise<void>>();
  
  for (let i = 0; i < totalFrames; i++) {
    const task = loadIndex(i).then(() => { pool.delete(task); });
    pool.add(task);
    if (pool.size >= CONCURRENCY) {
      await Promise.race(pool);
    }
  }
  await Promise.all(pool);

  return imgs;
}
