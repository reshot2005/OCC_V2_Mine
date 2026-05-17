"use client";

import { useState, useEffect } from "react";
import { motion } from "framer-motion";
import { formatDistanceToNow } from "date-fns";
import { Shield, AlertTriangle, Filter } from "lucide-react";

type SecurityEvent = { id: string; ipAddress: string; userAgent: string; path: string; reason: string; severity: "LOW" | "MEDIUM" | "HIGH" | "CRITICAL"; userId: string | null; createdAt: string };

export default function SecurityPage() {
  const [events, setEvents] = useState<SecurityEvent[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [severityF, setSeverityF] = useState("");
  const [stats, setStats] = useState({ total: 0, high: 0, critical: 0, uniqueIps: 0 });

  const fetchEvents = async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams({ page: page.toString() });
      if (severityF) params.set("severity", severityF);
      const res = await fetch(`/api/admin-cp/security?${params}`);
      const data = await res.json();
      setEvents(data.events || []);
      setTotalPages(data.totalPages || 1);
      setStats(data.stats || { total: 0, high: 0, critical: 0, uniqueIps: 0 });
    } catch {} finally { setLoading(false); }
  };

  useEffect(() => { fetchEvents(); }, [page, severityF]);

  const getSeverityColor = (severity: string) => {
    if (severity === "CRITICAL") return "text-red-400 bg-red-500/10 border-red-500/20";
    if (severity === "HIGH") return "text-orange-400 bg-orange-500/10 border-orange-500/20";
    if (severity === "MEDIUM") return "text-yellow-400 bg-yellow-500/10 border-yellow-500/20";
    return "text-blue-400 bg-blue-500/10 border-blue-500/20";
  };

  return (
    <div className="space-y-6">
      <div>
        <p className="text-[11px] font-bold uppercase tracking-[0.2em] text-[#5227FF]">Security Operations Center</p>
        <h1 className="mt-1 text-2xl font-bold text-white flex items-center gap-3">
          <Shield className="h-6 w-6 text-[#5227FF]" /> Security Monitoring
        </h1>
        <p className="text-sm text-white/40 mt-1">Real-time attack detection and security event tracking</p>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <div className="px-4 py-3 rounded-xl border border-white/[0.04] bg-white/[0.01]">
          <p className="text-[10px] uppercase tracking-wider text-white/40">Total Events</p>
          <p className="text-2xl font-bold text-white mt-1">{stats.total}</p>
        </div>
        <div className="px-4 py-3 rounded-xl border border-orange-500/20 bg-orange-500/5">
          <p className="text-[10px] uppercase tracking-wider text-orange-400">High Severity</p>
          <p className="text-2xl font-bold text-orange-400 mt-1">{stats.high}</p>
        </div>
        <div className="px-4 py-3 rounded-xl border border-red-500/20 bg-red-500/5">
          <p className="text-[10px] uppercase tracking-wider text-red-400">Critical</p>
          <p className="text-2xl font-bold text-red-400 mt-1">{stats.critical}</p>
        </div>
        <div className="px-4 py-3 rounded-xl border border-white/[0.04] bg-white/[0.01]">
          <p className="text-[10px] uppercase tracking-wider text-white/40">Unique IPs</p>
          <p className="text-2xl font-bold text-white mt-1">{stats.uniqueIps}</p>
        </div>
      </div>

      <div className="flex items-center gap-3">
        <Filter className="h-4 w-4 text-white/30" />
        <select value={severityF} onChange={(e) => { setSeverityF(e.target.value); setPage(1); }}
          className="rounded-xl border border-white/10 bg-white/[0.03] px-3 py-2 text-sm text-white outline-none">
          <option value="">All severities</option>
          <option value="CRITICAL">Critical</option>
          <option value="HIGH">High</option>
          <option value="MEDIUM">Medium</option>
          <option value="LOW">Low</option>
        </select>
      </div>

      <div className="space-y-1.5">
        {loading && <div className="py-12 text-center text-white/20">Loading security events...</div>}
        {!loading && events.map((e) => (
          <motion.div key={e.id} initial={{ opacity: 0 }} animate={{ opacity: 1 }}
            className={`flex items-center gap-4 px-4 py-3 rounded-xl border ${getSeverityColor(e.severity)} hover:bg-white/[0.02]`}>
            <AlertTriangle className={`h-4 w-4 ${e.severity === "CRITICAL" ? "text-red-400" : e.severity === "HIGH" ? "text-orange-400" : "text-white/50"}`} />
            <div className="flex-1 min-w-0">
              <div className="flex items-center gap-2 flex-wrap">
                <span className="text-xs font-mono text-white/70">{e.ipAddress}</span>
                <span className={`text-[9px] font-bold uppercase px-2 py-0.5 rounded-full ${getSeverityColor(e.severity)}`}>{e.severity}</span>
              </div>
              <p className="text-[10px] text-white/30 mt-0.5 truncate">{e.reason}</p>
              <div className="flex items-center gap-2 mt-1">
                <span className="text-[9px] text-white/20 font-mono">{e.path}</span>
                {e.userId && <span className="text-[9px] text-white/20">User: {e.userId.slice(0, 8)}</span>}
              </div>
            </div>
            <span className="text-[10px] text-white/25 whitespace-nowrap">{formatDistanceToNow(new Date(e.createdAt), { addSuffix: true })}</span>
          </motion.div>
        ))}
        {!loading && events.length === 0 && <div className="py-12 text-center text-white/20">No security events yet</div>}
      </div>

      {totalPages > 1 && (
        <div className="flex items-center justify-center gap-2 pt-4">
          <button onClick={() => setPage((p) => Math.max(1, p - 1))} disabled={page === 1} className="px-3 py-1.5 rounded-lg bg-white/5 text-xs text-white/50 disabled:opacity-30">Prev</button>
          <span className="text-xs text-white/40">Page {page} of {totalPages}</span>
          <button onClick={() => setPage((p) => Math.min(totalPages, p + 1))} disabled={page === totalPages} className="px-3 py-1.5 rounded-lg bg-white/5 text-xs text-white/50 disabled:opacity-30">Next</button>
        </div>
      )}
    </div>
  );
}
