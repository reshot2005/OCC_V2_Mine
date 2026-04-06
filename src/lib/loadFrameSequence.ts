import { setFrameImageSrc } from "./frameImage";

function normalizeBase(basePath: string) {
  const b = basePath.trim();
  if (!b) return "/";
  if (b.startsWith("http")) {
    return b.endsWith("/") ? b : `${b}/`;
  }
  let path = b.startsWith("/") ? b : `/${b}`;
  if (!path.endsWith("/")) path += "/";
  return path;
}

function resolveCdnBase(): string {
  return (
    process.env.NEXT_PUBLIC_FRAMES_CDN_BASE ||
    process.env.VITE_FRAMES_CDN_BASE ||
    ""
  ).replace(/\/$/, "");
}

/** Stable key so ClubOnboardingGate + use*Frames hooks share one load. */
export function frameSequenceLoadKey(
  basePath: string,
  totalFrames: number,
  prefix: string = "",
): string {
  const cdnBase = resolveCdnBase();
  const normalizedBase = normalizeBase(basePath);
  const base = normalizedBase.startsWith("http")
    ? normalizedBase
    : `${cdnBase}${normalizedBase}`;
  return `${base}|${prefix}|${totalFrames}`;
}

const _discoveredPattern: Record<string, string> = {};
const _imageCache: Record<string, HTMLImageElement> = {};
const _completedSequences = new Map<string, HTMLImageElement[]>();
const _inFlightSequences = new Map<string, Promise<HTMLImageElement[]>>();

/** Latest progress 0–1 for in-flight loads (Strict Mode / deduped callers). */
const _seqProgress = new Map<string, number>();
const _seqListeners = new Map<string, Set<(p: number) => void>>();

function subscribeSeqProgress(
  seqKey: string,
  fn: (p: number) => void,
): () => void {
  let set = _seqListeners.get(seqKey);
  if (!set) {
    set = new Set();
    _seqListeners.set(seqKey, set);
  }
  set.add(fn);
  const cur = _seqProgress.get(seqKey);
  queueMicrotask(() => fn(cur ?? 0));
  return () => {
    set!.delete(fn);
    if (set!.size === 0) _seqListeners.delete(seqKey);
  };
}

function emitSeqProgress(seqKey: string, p: number) {
  _seqProgress.set(seqKey, p);
  _seqListeners.get(seqKey)?.forEach((fn) => {
    fn(p);
  });
}

function adaptiveConcurrency(): number {
  if (typeof navigator === "undefined") return 72;
  const c = (
    navigator as Navigator & {
      connection?: {
        saveData?: boolean;
        effectiveType?: string;
        downlink?: number;
      };
    }
  ).connection;
  if (!c) return 72;
  if (c.saveData) return 24;
  const et = c.effectiveType;
  if (et === "slow-2g" || et === "2g") return 20;
  if (et === "3g") return 44;
  const d = c.downlink;
  if (typeof d === "number" && d >= 10) return 112;
  if (typeof d === "number" && d >= 5) return 88;
  return 72;
}

function setFetchPriority(img: HTMLImageElement, index: number) {
  try {
    if ("fetchPriority" in img) {
      (img as HTMLImageElement & { fetchPriority?: string }).fetchPriority =
        index < 16 ? "high" : "low";
    }
  } catch {
    /* ignore */
  }
}

/**
 * Loads numbered frames for scroll-cinema. Dedupes concurrent callers; all
 * subscribers receive progress (fixes React Strict Mode remounts).
 */
export async function loadFrameSequence(
  basePath: string,
  totalFrames: number,
  onProgress: (p: number) => void,
  prefix: string = "",
): Promise<HTMLImageElement[]> {
  const seqKey = frameSequenceLoadKey(basePath, totalFrames, prefix);

  const cached = _completedSequences.get(seqKey);
  if (cached) {
    queueMicrotask(() => onProgress(1));
    return cached;
  }

  const inflight = _inFlightSequences.get(seqKey);
  if (inflight) {
    const unsub = subscribeSeqProgress(seqKey, onProgress);
    void inflight.finally(() => unsub());
    return inflight;
  }

  const unsub = subscribeSeqProgress(seqKey, onProgress);

  const promise = loadFrameSequenceInternal(basePath, totalFrames, seqKey, prefix)
    .then((imgs) => {
      _completedSequences.set(seqKey, imgs);
      return imgs;
    })
    .finally(() => {
      unsub();
      _inFlightSequences.delete(seqKey);
    });

  _inFlightSequences.set(seqKey, promise);
  return promise;
}

async function loadFrameSequenceInternal(
  basePath: string,
  totalFrames: number,
  seqKey: string,
  prefix: string,
): Promise<HTMLImageElement[]> {
  const cdnBase = resolveCdnBase();
  const normalizedBase = normalizeBase(basePath);
  const base = normalizedBase.startsWith("http")
    ? normalizedBase
    : `${cdnBase}${normalizedBase}`;

  const imgs: HTMLImageElement[] = new Array(totalFrames);
  let completed = 0;

  const bump = () => {
    completed++;
    emitSeqProgress(seqKey, completed / totalFrames);
  };

  const cacheKey = `${base}|${prefix}`;
  let pattern = _discoveredPattern[cacheKey];

  if (!pattern) {
    const probeTemplates = [
      ...(prefix ? [`${base}${prefix}{PAD}{EXT}`] : []),
      `${base}{PAD}{EXT}`,
      ...(prefix !== "frame_" ? [`${base}frame_{PAD}{EXT}`] : []),
      `${normalizedBase}{PAD}{EXT}`,
    ];

    const probePad = "0001";
    for (const tmpl of probeTemplates) {
      for (const ext of [".jpg", ".webp"] as const) {
        const url = tmpl.replace("{PAD}", probePad).replace("{EXT}", ext);
        const ok = await probeUrl(url);
        if (ok) {
          pattern = tmpl.replace("{EXT}", ext);
          _discoveredPattern[cacheKey] = pattern;
          break;
        }
      }
      if (pattern) break;
    }
  }

  if (!pattern) {
    for (let i = 0; i < totalFrames; i++) bump();
    return imgs;
  }

  const loadIndex = (index: number) =>
    new Promise<void>((resolve) => {
      const padded = String(index + 1).padStart(4, "0");
      const src = pattern!.replace("{PAD}", padded);

      const cachedImg = _imageCache[src];
      if (cachedImg) {
        imgs[index] = cachedImg;
        bump();
        resolve();
        return;
      }

      const img = new Image();
      setFetchPriority(img, index);

      let settled = false;
      const finishOk = async () => {
        if (settled) return;
        settled = true;
        try {
          await img.decode();
        } catch {
          // ignore decode errors
        }
        _imageCache[src] = img;
        imgs[index] = img;
        bump();
        resolve();
      };
      const finishErr = () => {
        if (settled) return;
        settled = true;
        bump();
        resolve();
      };

      img.onload = () => {
        void finishOk();
      };
      img.onerror = finishErr;
      setFrameImageSrc(img, src);
      if (img.complete && img.naturalWidth > 0) {
        void finishOk();
      }
    });

  const CRITICAL = Math.min(72, totalFrames);
  const order: number[] = [];
  for (let i = 0; i < CRITICAL; i++) order.push(i);
  for (let i = CRITICAL; i < totalFrames; i++) order.push(i);

  const CONCURRENCY = adaptiveConcurrency();
  const pool = new Set<Promise<void>>();

  for (const i of order) {
    const task = loadIndex(i).then(() => {
      pool.delete(task);
    });
    pool.add(task);
    if (pool.size >= CONCURRENCY) {
      await Promise.race(pool);
    }
  }
  await Promise.all(pool);

  return imgs;
}

function probeUrl(url: string): Promise<boolean> {
  return new Promise((resolve) => {
    const img = new Image();
    setFetchPriority(img, 0);
    const timer = setTimeout(() => {
      img.onload = img.onerror = null;
      resolve(false);
    }, 4000);
    img.onload = () => {
      clearTimeout(timer);
      _imageCache[url] = img;
      resolve(true);
    };
    img.onerror = () => {
      clearTimeout(timer);
      resolve(false);
    };
    setFrameImageSrc(img, url);
    if (img.complete && img.naturalWidth > 0) {
      clearTimeout(timer);
      _imageCache[url] = img;
      resolve(true);
    }
  });
}
