"use client";

import { useRouter } from "next/navigation";
import * as React from "react";

export function ApplyGigButton({
  gigId,
  applied,
}: {
  gigId: string;
  applied: boolean;
}) {
  const router = useRouter();
  const [loading, setLoading] = React.useState(false);

  return (
    <button
      type="button"
      disabled={applied || loading}
      className="w-full rounded-2xl bg-[#5227FF] px-6 py-4 text-[12px] font-black uppercase tracking-[0.2em] text-white transition-all hover:bg-[#401ED9] hover:shadow-lg hover:shadow-[#5227FF]/20 active:scale-95 disabled:cursor-not-allowed disabled:opacity-40"
      onClick={async () => {
        setLoading(true);
        const response = await fetch("/api/gigs", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ gigId }),
        });
        setLoading(false);
        if (response.ok) {
          router.refresh();
        }
      }}
    >
      {applied ? "Applied ✓" : loading ? "Applying..." : "Apply Now"}
    </button>
  );
}
