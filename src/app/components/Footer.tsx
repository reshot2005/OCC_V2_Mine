"use client";

import React from "react";
import { Mail, Phone, MapPin, Globe, Share2, MessageSquare, ExternalLink } from "lucide-react";
import { OCC_BRAND_ICON } from "@/lib/brand";

export function Footer({ theme }: { theme: "dark" | "light" }) {
  const isDark = theme === "dark";
  
  return (
    <footer className={`py-20 px-4 sm:px-6 lg:px-12 border-t transition-colors duration-500 ${isDark ? "bg-[#070914] border-white/5" : "bg-white border-slate-200"}`}>
      <div className="max-w-[1400px] mx-auto">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-12 mb-20">
          {/* Brand Info */}
          <div className="space-y-8">
            <div className="flex items-center gap-3">
              <div className="flex h-10 w-10 items-center justify-center overflow-hidden rounded-xl shadow-[0_0_20px_rgba(82,39,255,0.2)]">
                <img src={OCC_BRAND_ICON} alt="OCC" className="h-full w-full object-cover" />
              </div>
              <span className={`text-2xl font-bold tracking-tight ${isDark ? "text-white" : "text-slate-900"}`}>OCC</span>
            </div>
            <p className={`text-base leading-relaxed max-w-xs ${isDark ? "text-white/40" : "text-slate-500"}`}>
              The premier off-campus platform for Gen Z students to connect, collaborate, and grow through shared interests and real-world experiences.
            </p>
            <div className="flex gap-4">
              {[
                { icon: Globe, href: "https://offcampusclub.com" },
                { icon: MessageSquare, href: "https://twitter.com" },
                { icon: Share2, href: "https://linkedin.com" }
              ].map((social, i) => (
                <a 
                  key={i}
                  href={social.href} 
                  target="_blank"
                  rel="noopener noreferrer"
                  className={`p-2.5 rounded-xl transition-all duration-300 ${isDark ? "bg-white/[0.03] hover:bg-[#5227FF] text-white/40 hover:text-white" : "bg-slate-100 hover:bg-indigo-600 text-slate-400 hover:text-white"}`}
                >
                  <social.icon size={20} />
                </a>
              ))}
            </div>
          </div>

          {/* Quick Links */}
          <div className="lg:pl-8">
            <h4 className={`text-xs font-bold uppercase tracking-[0.2em] mb-8 ${isDark ? "text-indigo-400" : "text-indigo-600"}`}>Explore</h4>
            <ul className="space-y-4">
              {["About OCC", "Find Clubs", "Upcoming Events", "Gig Board", "Student Leaderboard"].map((link) => (
                <li key={link}>
                  <a href="#" className={`text-[15px] font-medium transition-colors ${isDark ? "text-white/35 hover:text-indigo-400" : "text-slate-500 hover:text-indigo-600"}`}>
                    {link}
                  </a>
                </li>
              ))}
            </ul>
          </div>

          {/* Resources */}
          <div>
            <h4 className={`text-xs font-bold uppercase tracking-[0.2em] mb-8 ${isDark ? "text-indigo-400" : "text-indigo-600"}`}>Resources</h4>
            <ul className="space-y-4">
              {["Privacy Policy", "Terms of Service", "Cookie Policy", "Community Guidelines", "Security & Audit"].map((link) => (
                <li key={link}>
                  <a href="#" className={`text-[15px] font-medium transition-colors ${isDark ? "text-white/35 hover:text-indigo-400" : "text-slate-500 hover:text-indigo-600"}`}>
                    {link}
                  </a>
                </li>
              ))}
            </ul>
          </div>

          {/* Contact */}
          <div>
            <h4 className={`text-xs font-bold uppercase tracking-[0.2em] mb-8 ${isDark ? "text-indigo-400" : "text-indigo-600"}`}>Get in touch</h4>
            <ul className="space-y-6">
              <li className="flex items-start gap-4">
                <div className={`p-2 rounded-lg ${isDark ? "bg-white/5" : "bg-slate-100"}`}>
                  <MapPin size={18} className="text-indigo-500" />
                </div>
                <span className={`text-[15px] leading-relaxed ${isDark ? "text-white/40" : "text-slate-500"}`}>
                  12th Floor, MG Road, <br />
                  Cyber City, Bangalore, <br />
                  Karnataka 560001
                </span>
              </li>
              <li className="flex items-center gap-4">
                <div className={`p-2 rounded-lg ${isDark ? "bg-white/5" : "bg-slate-100"}`}>
                  <Mail size={18} className="text-indigo-500" />
                </div>
                <a href="mailto:hello@offcampusclub.com" className={`text-[15px] font-medium transition-colors ${isDark ? "text-white/40 hover:text-indigo-400" : "text-slate-500 hover:text-indigo-600"}`}>
                  hello@offcampusclub.com
                </a>
              </li>
              <li className="flex items-center gap-4">
                <div className={`p-2 rounded-lg ${isDark ? "bg-white/5" : "bg-slate-100"}`}>
                  <Phone size={18} className="text-indigo-500" />
                </div>
                <a href="tel:+918889990000" className={`text-[15px] font-medium transition-colors ${isDark ? "text-white/40 hover:text-indigo-400" : "text-slate-500 hover:text-indigo-600"}`}>
                  +91 888 999 0000
                </a>
              </li>
            </ul>
          </div>
        </div>

        {/* Bottom Bar */}
        <div className={`pt-10 border-t flex flex-col md:flex-row justify-between items-center gap-6 ${isDark ? "border-white/5" : "border-slate-100"}`}>
          <p className={`text-sm ${isDark ? "text-white/20" : "text-slate-400"}`}>
            © {new Date().getFullYear()} Off Campus Club — Built for the city.
          </p>
          <div className="flex items-center gap-8">
             <button 
               onClick={() => window.scrollTo({ top: 0, behavior: 'smooth' })}
               className={`text-xs font-bold uppercase tracking-widest flex items-center gap-2 transition-all group ${isDark ? "text-white/30 hover:text-white" : "text-slate-400 hover:text-indigo-600"}`}
             >
               Back to top 
               <ExternalLink size={14} className="transition-transform group-hover:-translate-y-0.5" />
             </button>
          </div>
        </div>
      </div>
    </footer>
  );
}
