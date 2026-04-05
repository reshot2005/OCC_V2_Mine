export type AdminLevel = "SUPER_ADMIN" | "MODERATOR" | null;

export type AdminModule =
  | "clubs" | "users" | "posts" | "events" | "gigs"
  | "approvals" | "audit" | "security" | "settings" | "export" | "analytics";

export type AdminAction =
  | "read" | "create" | "update" | "delete"
  | "suspend" | "role_change" | "admin_promote"
  | "approve" | "reject" | "approve_applications"
  | "resolve" | "csv_users" | "csv_posts" | "csv_clubs" | "csv_events" | "csv_gigs";

const SUPER_ADMIN_PERMISSIONS: Record<AdminModule, AdminAction[]> = {
  clubs: ["read", "create", "update", "delete"],
  users: ["read", "create", "update", "delete", "suspend", "role_change", "admin_promote"],
  posts: ["read", "update", "delete"],
  events: ["read", "create", "update", "delete"],
  gigs: ["read", "create", "update", "delete", "approve_applications"],
  approvals: ["read", "approve", "reject"],
  audit: ["read"],
  security: ["read", "resolve"],
  settings: ["read", "update"],
  export: ["csv_users", "csv_posts", "csv_clubs", "csv_events", "csv_gigs"],
  analytics: ["read"],
};

const MODERATOR_PERMISSIONS: Record<AdminModule, AdminAction[]> = {
  clubs: ["read"],
  users: ["read", "suspend"],
  posts: ["read", "update", "delete"],
  events: ["read"],
  gigs: ["read"],
  approvals: ["read"],
  audit: [],
  security: [],
  settings: [],
  export: [],
  analytics: ["read"],
};

export function hasPermission(adminLevel: AdminLevel, module: AdminModule, action: AdminAction): boolean {
  // SUPER_ADMIN or anyone with role=ADMIN and no adminLevel gets full access
  if (!adminLevel || adminLevel === "SUPER_ADMIN") {
    return SUPER_ADMIN_PERMISSIONS[module]?.includes(action) ?? false;
  }
  if (adminLevel === "MODERATOR") {
    return MODERATOR_PERMISSIONS[module]?.includes(action) ?? false;
  }
  return false;
}

export function getModulePermissions(adminLevel: AdminLevel, module: AdminModule): AdminAction[] {
  if (!adminLevel || adminLevel === "SUPER_ADMIN") {
    return SUPER_ADMIN_PERMISSIONS[module] ?? [];
  }
  if (adminLevel === "MODERATOR") {
    return MODERATOR_PERMISSIONS[module] ?? [];
  }
  return [];
}

export const ALL_MODULES: { key: AdminModule; label: string; icon: string }[] = [
  { key: "clubs", label: "Clubs", icon: "Grid3X3" },
  { key: "users", label: "Users", icon: "Users" },
  { key: "posts", label: "Posts", icon: "FileText" },
  { key: "events", label: "Events", icon: "Calendar" },
  { key: "gigs", label: "Gigs", icon: "Briefcase" },
  { key: "approvals", label: "Approvals", icon: "CheckCircle2" },
  { key: "analytics", label: "Analytics", icon: "TrendingUp" },
  { key: "audit", label: "Audit Log", icon: "ScrollText" },
  { key: "security", label: "Security", icon: "ShieldAlert" },
  { key: "settings", label: "Settings", icon: "Settings" },
  { key: "export", label: "Export", icon: "Download" },
];
