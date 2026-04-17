"use client";

import React, { useState } from "react";
import { Mail, Phone, MapPin, Globe, Share2, ExternalLink, Check } from "lucide-react";

export function Footer({ theme }: { theme: "dark" | "light" }) {
  const isDark = theme === "dark";
  const [copied, setCopied] = useState(false);

  const handleShare = async () => {
    const url = window.location.origin;
    
    // Try native share first
    if (navigator.share) {
      try {
        await navigator.share({
          title: "Off Campus Club",
          text: "Check out the premier platform for campus culture!",
          url: url,
        });
        return;
      } catch (err) {
        // Fallback to copy if share was cancelled or failed
      }
    }

    // Fallback: Copy to clipboard
    try {
      await navigator.clipboard.writeText(url);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } catch (err) {
      console.error("Failed to copy:", err);
    }
  };

  const handleGlobe = () => {
    window.open(window.location.origin, "_blank");
  };
  
  return (
    <footer className={`w-full py-8 px-6 lg:px-20 border-t-2 relative z-[1000] ${
      isDark ? "bg-[#0A0C16] border-indigo-500/20" : "bg-white border-slate-100"
    }`}>
      <div className="max-w-[1400px] mx-auto">
        <div className="flex flex-col md:flex-row items-center justify-between gap-8">
          
          {/* Section 1: Address */}
          <div className="flex items-center gap-4">
            <div className={`p-2.5 rounded-xl ${isDark ? "bg-indigo-500/10" : "bg-slate-50"}`}>
              <MapPin size={16} className="text-indigo-500" />
            </div>
            <div className="flex flex-col">
              <span className={`text-[10px] font-black uppercase tracking-widest ${isDark ? "text-white/20" : "text-slate-400"}`}>Headquarters</span>
              <p className={`text-xs font-bold ${isDark ? "text-white/50" : "text-slate-600"}`}>
                MG Road, Cyber City, Bangalore, KA 560001
              </p>
            </div>
          </div>

          {/* Section 2: Contact */}
          <div className="flex flex-col md:flex-row gap-8">
            <a href="mailto:hello@offcampusclub.com" className="flex items-center gap-4 group">
              <div className={`p-2.5 rounded-xl ${isDark ? "bg-indigo-500/10 group-hover:bg-indigo-500/30" : "bg-slate-50"} transition-all`}>
                <Mail size={16} className="text-indigo-500" />
              </div>
              <span className={`text-xs font-bold ${isDark ? "text-white/50 group-hover:text-white" : "text-slate-600"} transition-colors`}>
                hello@offcampusclub.com
              </span>
            </a>
            <a href="tel:+918889990000" className="flex items-center gap-4 group">
              <div className={`p-2.5 rounded-xl ${isDark ? "bg-indigo-500/10 group-hover:bg-indigo-500/30" : "bg-slate-50"} transition-all`}>
                <Phone size={16} className="text-indigo-500" />
              </div>
              <span className={`text-xs font-bold ${isDark ? "text-white/50 group-hover:text-white" : "text-slate-600"} transition-colors`}>
                +91 888 999 0000
              </span>
            </a>
          </div>

          {/* Section 3: Action Buttons */}
          <div className="flex items-center gap-4">
            <div className="flex gap-2">
              {/* Globe Button */}
              <button 
                onClick={handleGlobe}
                title="Open Website"
                className={`p-2 rounded-lg transition-all ${isDark ? "text-white/20 hover:text-white hover:bg-white/5" : "text-slate-400 hover:text-indigo-600"}`}
              >
                <Globe size={16} />
              </button>

              {/* Share/Copy Button */}
              <button 
                onClick={handleShare}
                title={copied ? "Link Copied!" : "Share Website"}
                className={`p-2 rounded-lg transition-all relative ${
                  copied 
                  ? "text-green-500 bg-green-500/10" 
                  : isDark ? "text-white/20 hover:text-white hover:bg-white/5" : "text-slate-400 hover:text-indigo-600"
                }`}
              >
                {copied ? <Check size={16} /> : <Share2 size={16} />}
                {copied && (
                  <span className="absolute -top-8 left-1/2 -translate-x-1/2 bg-green-600 text-white text-[10px] font-bold px-2 py-0.5 rounded whitespace-nowrap">
                    LINK COPIED!
                  </span>
                )}
              </button>
            </div>
            
          </div>

        </div>
      </div>
    </footer>
  );
}
