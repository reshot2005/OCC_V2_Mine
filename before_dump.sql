--
-- PostgreSQL database dump
--

\restrict IxpmjadGXaXVcHKCjAbWiGR8CBl2oId6udfm0Zjopqn8spac8BvB5Uarh6usEOQ

-- Dumped from database version 18.3 (Debian 18.3-1.pgdg12+1)
-- Dumped by pg_dump version 18.3 (Ubuntu 18.3-1.pgdg24.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: occ_4t52_user
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO occ_4t52_user;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: occ_4t52_user
--

COMMENT ON SCHEMA public IS '';


--
-- Name: ApprovalStatus; Type: TYPE; Schema: public; Owner: occ_4t52_user
--

CREATE TYPE public."ApprovalStatus" AS ENUM (
    'PENDING',
    'APPROVED',
    'REJECTED'
);


ALTER TYPE public."ApprovalStatus" OWNER TO occ_4t52_user;

--
-- Name: OtpPurpose; Type: TYPE; Schema: public; Owner: occ_4t52_user
--

CREATE TYPE public."OtpPurpose" AS ENUM (
    'REGISTER',
    'RESET_PASSWORD',
    'ADMIN_LOGIN'
);


ALTER TYPE public."OtpPurpose" OWNER TO occ_4t52_user;

--
-- Name: UserRole; Type: TYPE; Schema: public; Owner: occ_4t52_user
--

CREATE TYPE public."UserRole" AS ENUM (
    'STUDENT',
    'CLUB_HEADER',
    'ADMIN'
);


ALTER TYPE public."UserRole" OWNER TO occ_4t52_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin_broadcasts; Type: TABLE; Schema: public; Owner: occ_4t52_user
--

CREATE TABLE public.admin_broadcasts (
    id text NOT NULL,
    title text NOT NULL,
    message text NOT NULL,
    "audienceType" text DEFAULT 'all'::text NOT NULL,
    "audienceFilter" jsonb,
    "createdById" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "completedAt" timestamp(3) without time zone,
    "recipientCount" integer
);


ALTER TABLE public.admin_broadcasts OWNER TO occ_4t52_user;

--
-- Name: admin_role_templates; Type: TABLE; Schema: public; Owner: occ_4t52_user
--

CREATE TABLE public.admin_role_templates (
    id text NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    permissions jsonb NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.admin_role_templates OWNER TO occ_4t52_user;

--
-- Name: admin_scheduled_announcements; Type: TABLE; Schema: public; Owner: occ_4t52_user
--

CREATE TABLE public.admin_scheduled_announcements (
    id text NOT NULL,
    title text DEFAULT ''::text NOT NULL,
    body text NOT NULL,
    "startsAt" timestamp(3) without time zone NOT NULL,
    "endsAt" timestamp(3) without time zone NOT NULL,
    active boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.admin_scheduled_announcements OWNER TO occ_4t52_user;

--
-- Name: announcements; Type: TABLE; Schema: public; Owner: occ_4t52_user
--

CREATE TABLE public.announcements (
    id text NOT NULL,
    "clubId" text NOT NULL,
    "authorId" text NOT NULL,
    title text NOT NULL,
    content text NOT NULL,
    "isPinned" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.announcements OWNER TO occ_4t52_user;

--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: occ_4t52_user
--

CREATE TABLE public.audit_logs (
    id text NOT NULL,
    "adminId" text NOT NULL,
    "adminEmail" text NOT NULL,
    action text NOT NULL,
    entity text NOT NULL,
    "entityId" text,
    details jsonb,
    "ipAddress" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.audit_logs OWNER TO occ_4t52_user;

--
-- Name: club_memberships; Type: TABLE; Schema: public; Owner: occ_4t52_user
--

CREATE TABLE public.club_memberships (
    id text NOT NULL,
    "userId" text NOT NULL,
    "clubId" text NOT NULL,
    "joinedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    role text DEFAULT 'member'::text NOT NULL
);


ALTER TABLE public.club_memberships OWNER TO occ_4t52_user;

--
-- Name: club_onboarding; Type: TABLE; Schema: public; Owner: occ_4t52_user
--

CREATE TABLE public.club_onboarding (
    id text NOT NULL,
    "userId" text NOT NULL,
    "clubSlug" text NOT NULL,
    answer1 text NOT NULL,
    answer2 text NOT NULL,
    answer3 text NOT NULL,
    answer4 text NOT NULL,
    answer5 text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.club_onboarding OWNER TO occ_4t52_user;

--
-- Name: clubs; Type: TABLE; Schema: public; Owner: occ_4t52_user
--

CREATE TABLE public.clubs (
    id text NOT NULL,
    slug text NOT NULL,
    name text NOT NULL,
    icon text NOT NULL,
    description text NOT NULL,
    theme text NOT NULL,
    "coverImage" text,
    "memberCount" integer DEFAULT 0 NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "headerId" text,
    "postingFrozen" boolean DEFAULT false NOT NULL,
    "memberDisplayBase" integer
);


ALTER TABLE public.clubs OWNER TO occ_4t52_user;

--
-- Name: comment_reports; Type: TABLE; Schema: public; Owner: occ_4t52_user
--

CREATE TABLE public.comment_reports (
    id text NOT NULL,
    "commentId" text NOT NULL,
    "reporterId" text NOT NULL,
    reason text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.comment_reports OWNER TO occ_4t52_user;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: occ_4t52_user
--

CREATE TABLE public.comments (
    id text NOT NULL,
    "postId" text NOT NULL,
    "userId" text NOT NULL,
    content text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.comments OWNER TO occ_4t52_user;

--
-- Name: email_otp_tokens; Type: TABLE; Schema: public; Owner: occ_4t52_user
--

CREATE TABLE public.email_otp_tokens (
    id text NOT NULL,
    email text NOT NULL,
    purpose public."OtpPurpose" NOT NULL,
    "codeHash" text NOT NULL,
    "attemptsLeft" integer DEFAULT 5 NOT NULL,
    "expiresAt" timestamp(3) without time zone NOT NULL,
    "usedAt" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.email_otp_tokens OWNER TO occ_4t52_user;

--
-- Name: event_registrations; Type: TABLE; Schema: public; Owner: occ_4t52_user
--

CREATE TABLE public.event_registrations (
    id text NOT NULL,
    "userId" text NOT NULL,
    "eventId" text NOT NULL,
    status text DEFAULT 'registered'::text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.event_registrations OWNER TO occ_4t52_user;

--
-- Name: events; Type: TABLE; Schema: public; Owner: occ_4t52_user
--

CREATE TABLE public.events (
    id text NOT NULL,
    "clubId" text NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    date timestamp(3) without time zone NOT NULL,
    venue text NOT NULL,
    price integer DEFAULT 0 NOT NULL,
    "maxCapacity" integer,
    "imageUrl" text DEFAULT ''::text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.events OWNER TO occ_4t52_user;

--
-- Name: follows; Type: TABLE; Schema: public; Owner: occ_4t52_user
--

CREATE TABLE public.follows (
    id text NOT NULL,
    "followerId" text NOT NULL,
    "followingId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.follows OWNER TO occ_4t52_user;

--
-- Name: gig_applications; Type: TABLE; Schema: public; Owner: occ_4t52_user
--

CREATE TABLE public.gig_applications (
    id text NOT NULL,
    "userId" text NOT NULL,
    "gigId" text NOT NULL,
    status text DEFAULT 'PENDING'::text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    message text,
    "applicantEmail" text,
    "applicantName" text,
    "applicantPhone" text,
    "submissionFileMime" text,
    "submissionFileName" text,
    "submissionFileSize" integer,
    "submissionFileUrl" text,
    "workDescription" text
);


ALTER TABLE public.gig_applications OWNER TO occ_4t52_user;

--
-- Name: gigs; Type: TABLE; Schema: public; Owner: occ_4t52_user
--

CREATE TABLE public.gigs (
    id text NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    "payMin" integer NOT NULL,
    "payMax" integer NOT NULL,
    "clubId" text,
    deadline timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "postedById" text
);


ALTER TABLE public.gigs OWNER TO occ_4t52_user;

--
-- Name: moderation_tickets; Type: TABLE; Schema: public; Owner: occ_4t52_user
--

CREATE TABLE public.moderation_tickets (
    id text NOT NULL,
    "resourceType" text NOT NULL,
    "resourceId" text NOT NULL,
    status text DEFAULT 'OPEN'::text NOT NULL,
    "assigneeId" text,
    "dueAt" timestamp(3) without time zone,
    notes text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.moderation_tickets OWNER TO occ_4t52_user;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: occ_4t52_user
--

CREATE TABLE public.notifications (
    id text NOT NULL,
    "userId" text NOT NULL,
    type text NOT NULL,
    title text NOT NULL,
    message text NOT NULL,
    read boolean DEFAULT false NOT NULL,
    data jsonb,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.notifications OWNER TO occ_4t52_user;

--
-- Name: orbit_projects; Type: TABLE; Schema: public; Owner: occ_4t52_user
--

CREATE TABLE public.orbit_projects (
    id text NOT NULL,
    title text NOT NULL,
    category text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    "imageUrl" text NOT NULL,
    "sortOrder" integer DEFAULT 0 NOT NULL,
    active boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.orbit_projects OWNER TO occ_4t52_user;

--
-- Name: platform_settings; Type: TABLE; Schema: public; Owner: occ_4t52_user
--

CREATE TABLE public.platform_settings (
    id text DEFAULT 'singleton'::text NOT NULL,
    "siteName" text DEFAULT 'OCC'::text NOT NULL,
    "announcementBanner" text,
    "announcementActive" boolean DEFAULT false NOT NULL,
    "maintenanceMode" boolean DEFAULT false NOT NULL,
    "registrationOpen" boolean DEFAULT true NOT NULL,
    "landingHeroTitle" text,
    "landingHeroSubtitle" text,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "featureFlags" jsonb DEFAULT '{}'::jsonb NOT NULL,
    "landingCmsExtra" jsonb DEFAULT '{}'::jsonb NOT NULL,
    "legalPrivacyHtml" text,
    "legalTermsHtml" text,
    "rateLimitPolicy" jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE public.platform_settings OWNER TO occ_4t52_user;

--
-- Name: post_bookmarks; Type: TABLE; Schema: public; Owner: occ_4t52_user
--

CREATE TABLE public.post_bookmarks (
    id text NOT NULL,
    "postId" text NOT NULL,
    "userId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.post_bookmarks OWNER TO occ_4t52_user;

--
-- Name: post_likes; Type: TABLE; Schema: public; Owner: occ_4t52_user
--

CREATE TABLE public.post_likes (
    id text NOT NULL,
    "postId" text NOT NULL,
    "userId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.post_likes OWNER TO occ_4t52_user;

--
-- Name: posts; Type: TABLE; Schema: public; Owner: occ_4t52_user
--

CREATE TABLE public.posts (
    id text NOT NULL,
    "userId" text NOT NULL,
    "clubId" text NOT NULL,
    "imageUrl" text,
    caption text,
    likes integer DEFAULT 0 NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    content text,
    "imageUrls" text[] DEFAULT ARRAY[]::text[],
    "likesCount" integer DEFAULT 0 NOT NULL,
    "sharesCount" integer DEFAULT 0 NOT NULL,
    type text DEFAULT 'post'::text NOT NULL,
    hidden boolean DEFAULT false NOT NULL,
    pinned boolean DEFAULT false NOT NULL
);


ALTER TABLE public.posts OWNER TO occ_4t52_user;

--
-- Name: referral_stats; Type: TABLE; Schema: public; Owner: occ_4t52_user
--

CREATE TABLE public.referral_stats (
    id text NOT NULL,
    "clubHeaderId" text NOT NULL,
    "studentId" text NOT NULL,
    "registeredAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "clubId" text NOT NULL
);


ALTER TABLE public.referral_stats OWNER TO occ_4t52_user;

--
-- Name: shares; Type: TABLE; Schema: public; Owner: occ_4t52_user
--

CREATE TABLE public.shares (
    id text NOT NULL,
    "postId" text NOT NULL,
    "userId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.shares OWNER TO occ_4t52_user;

--
-- Name: suspicious_access; Type: TABLE; Schema: public; Owner: occ_4t52_user
--

CREATE TABLE public.suspicious_access (
    id text NOT NULL,
    "userId" text,
    "ipAddress" text NOT NULL,
    "userAgent" text,
    path text NOT NULL,
    reason text NOT NULL,
    severity text DEFAULT 'MEDIUM'::text NOT NULL,
    resolved boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.suspicious_access OWNER TO occ_4t52_user;

--
-- Name: users; Type: TABLE; Schema: public; Owner: occ_4t52_user
--

CREATE TABLE public.users (
    id text NOT NULL,
    "fullName" text NOT NULL,
    "collegeName" text NOT NULL,
    "phoneNumber" text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    "emailVerified" timestamp(3) without time zone,
    avatar text,
    bio text,
    city text,
    "graduationYear" integer,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "approvalStatus" public."ApprovalStatus" DEFAULT 'APPROVED'::public."ApprovalStatus" NOT NULL,
    "clubManagedId" text,
    "referralCode" text,
    "referredBy" text,
    role public."UserRole" DEFAULT 'STUDENT'::public."UserRole" NOT NULL,
    suspended boolean DEFAULT false NOT NULL,
    "pendingLeadClubId" text,
    "onboardingComplete" boolean DEFAULT false NOT NULL,
    "referralSource" text,
    "adminLevel" text,
    "adminRoleTemplateId" text
);


ALTER TABLE public.users OWNER TO occ_4t52_user;

--
-- Data for Name: admin_broadcasts; Type: TABLE DATA; Schema: public; Owner: occ_4t52_user
--

COPY public.admin_broadcasts (id, title, message, "audienceType", "audienceFilter", "createdById", "createdAt", "completedAt", "recipientCount") FROM stdin;
\.


--
-- Data for Name: admin_role_templates; Type: TABLE DATA; Schema: public; Owner: occ_4t52_user
--

COPY public.admin_role_templates (id, name, slug, description, permissions, "createdAt", "updatedAt") FROM stdin;
cmnpmdgx60000u79wyymw3p3v	Standard moderator	standard-moderator	Matches legacy moderator: posts, users read/suspend, approvals read.	{"gigs": ["read"], "audit": [], "clubs": ["read"], "orbit": ["read"], "posts": ["read", "update", "delete"], "roles": [], "users": ["read", "suspend"], "events": ["read"], "export": [], "security": [], "settings": [], "analytics": ["read"], "approvals": ["read"], "broadcasts": [], "compliance": [], "moderation": ["read", "update"], "feature_flags": [], "announcement_schedule": []}	2026-04-08 05:40:38.249	2026-04-08 05:40:38.249
\.


--
-- Data for Name: admin_scheduled_announcements; Type: TABLE DATA; Schema: public; Owner: occ_4t52_user
--

COPY public.admin_scheduled_announcements (id, title, body, "startsAt", "endsAt", active, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: announcements; Type: TABLE DATA; Schema: public; Owner: occ_4t52_user
--

COPY public.announcements (id, "clubId", "authorId", title, content, "isPinned", "createdAt") FROM stdin;
\.


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: occ_4t52_user
--

COPY public.audit_logs (id, "adminId", "adminEmail", action, entity, "entityId", details, "ipAddress", "createdAt") FROM stdin;
cmnlqr9470003u7xk4zsdmcdg	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	CREATE_CLUB	club	cmnlqr8sa0001u7xklay1hj3b	{"name": "Gaming Club", "slug": "gaming-club"}	\N	2026-04-05 12:32:15.079
cmnlrni2q0005u7xk4ua6ctqq	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	CHANGE_ROLE	user	cmnighgle0004u718dt5i4clk	{"role": "CLUB_HEADER"}	\N	2026-04-05 12:57:19.676
cmnm6ky8l0002u7oc875e9yny	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	CREATE_EVENT	event	cmnm6kxsu0000u7ock8acmlzh	{"type": "orbit_project", "title": "Club Launch", "category": "Clubs"}	\N	2026-04-05 19:55:14.901
cmnm6lg5w0005u7ocwyv0yohj	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	CREATE_EVENT	event	cmnm6lftx0003u7ocqh7frsx8	{"type": "orbit_project", "title": "Club Launch", "category": "Clubs"}	\N	2026-04-05 19:55:38.133
cmnm6mj470008u7ocg9al3vwm	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	CREATE_EVENT	event	cmnm6mip50006u7ocl2g15yzj	{"type": "orbit_project", "title": "OCC", "category": "Clubs"}	\N	2026-04-05 19:56:28.616
cmnm6n370000bu7ockbzi20ur	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	CREATE_EVENT	event	cmnm6n2uh0009u7oclefr8d93	{"type": "orbit_project", "title": "Great Cacth With OCC", "category": "Clubs"}	\N	2026-04-05 19:56:54.637
cmnm6nk93000eu7ocostmucd1	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	CREATE_EVENT	event	cmnm6njzw000cu7ocvr0z06r6	{"type": "orbit_project", "title": "OCC Posters", "category": "Clubs"}	\N	2026-04-05 19:57:16.743
cmnm6oayk000hu7ocfhf0rjy9	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	CREATE_EVENT	event	cmnm6oapc000fu7oc7qi9229a	{"type": "orbit_project", "title": "OCC Run Your Sense", "category": "Clubs"}	\N	2026-04-05 19:57:51.356
cmnm6ow5b000ku7oc889rhnkd	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	CREATE_EVENT	event	cmnm6ovz7000iu7ocjz0xxgxu	{"type": "orbit_project", "title": "OCC", "category": "Clubs"}	\N	2026-04-05 19:58:18.815
cmnm6pedc000nu7ocih1bz0o6	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	CREATE_EVENT	event	cmnm6pe7a000lu7ocn99d530u	{"type": "orbit_project", "title": "Our Team", "category": "Clubs"}	\N	2026-04-05 19:58:42.432
cmnm6ps1w000qu7oc60w2wk82	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	CREATE_EVENT	event	cmnm6prvv000ou7ocmvek8krm	{"type": "orbit_project", "title": "A Walk", "category": "Clubs"}	\N	2026-04-05 19:59:00.165
cmnm6qfci000tu7ocnspbk9ry	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	CREATE_EVENT	event	cmnm6qf6d000ru7ocimwcjrjv	{"type": "orbit_project", "title": "Love OCC", "category": "Clubs"}	\N	2026-04-05 19:59:30.355
cmnm6rfpj000vu7oc9c37nk1u	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	UPDATE_EVENT	event	cmnm6n2uh0009u7oclefr8d93	{"type": "orbit_project", "title": "Great Catch With OCC", "active": true, "category": "Clubs", "imageUrl": "https://res.cloudinary.com/dbu9z9ija/image/upload/v1775419001/occ/orbit/ovdgkvlf5yexif4jjepb.png", "sortOrder": 2, "description": ""}	\N	2026-04-05 20:00:17.479
cmnmc9gdp0001u7jkevdlsq8v	cmniglcfn0008u718ymztkf7y	spherefulltos@gmail.com	PROFILE_UPDATE	USER	cmniglcfn0008u718ymztkf7y	{"platform": "DASHBOARD", "timestamp": "2026-04-05T22:34:16.219Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-05 22:34:16.221
cmnmc9ytb0003u7jk8cxomrsu	cmniglcfn0008u718ymztkf7y	spherefulltos@gmail.com	PROFILE_UPDATE	USER	cmniglcfn0008u718ymztkf7y	{"platform": "DASHBOARD", "timestamp": "2026-04-05T22:34:40.124Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-05 22:34:40.127
cmnmcabc70005u7jkdvljmlxw	cmniglcfn0008u718ymztkf7y	spherefulltos@gmail.com	PROFILE_UPDATE	USER	cmniglcfn0008u718ymztkf7y	{"platform": "DASHBOARD", "timestamp": "2026-04-05T22:34:56.343Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-05 22:34:56.359
cmnmchwou0007u7jkarx8e6vy	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	DELETE_GIG	gig	cmnlo0ami002tu7g8fysosrfe	null	\N	2026-04-05 22:40:50.622
cmnmchyaq0009u7jkh3ld91q8	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	DELETE_GIG	gig	cmnlo0agh002ru7g8jnwkplg1	null	\N	2026-04-05 22:40:52.706
cmnmci07c000bu7jkmgltu7qt	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	DELETE_GIG	gig	cmnlo07or002cu7g85u0qdt9w	null	\N	2026-04-05 22:40:55.176
cmnmci52m000du7jku1o7no4z	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	DELETE_GIG	gig	cmnlo04o7001vu7g88eobv6ok	null	\N	2026-04-05 22:41:01.487
cmnmci7r3000fu7jkwpr3jx1k	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	DELETE_GIG	gig	cmnlo07ir002au7g8bcwtuvfy	null	\N	2026-04-05 22:41:04.959
cmnmci9k2000hu7jk011c58pk	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	DELETE_GIG	gig	cmnlnzyoy000xu7g8vrth921u	null	\N	2026-04-05 22:41:07.298
cmnmcibdi000ju7jkhy2gh3fa	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	DELETE_GIG	gig	cmnlnzves000eu7g89vkz4m21	null	\N	2026-04-05 22:41:09.654
cmnmciheg000lu7jkzitebc47	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	DELETE_GIG	gig	cmnlo04i3001tu7g8mad94jk4	null	\N	2026-04-05 22:41:17.463
cmnmciphc000nu7jkz8xsllck	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	DELETE_GIG	gig	cmnlnzyiz000vu7g8h4lxkziy	null	\N	2026-04-05 22:41:27.937
cmnmciuwx000pu7jk8k3xox09	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	DELETE_GIG	gig	cmnlnzvrc000gu7g8vvgayo39	null	\N	2026-04-05 22:41:34.977
cmnmkaym40001l404fxcr4ko6	cmnlll4t00001lb04hfrqrf54	itzsriharishetty@gmail.com	PROFILE_UPDATE	USER	cmnlll4t00001lb04hfrqrf54	{"platform": "DASHBOARD", "timestamp": "2026-04-06T02:19:23.451Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-06 02:19:23.452
cmnmkbao10003l404wlhunj5n	cmnlll4t00001lb04hfrqrf54	itzsriharishetty@gmail.com	PROFILE_UPDATE	USER	cmnlll4t00001lb04hfrqrf54	{"platform": "DASHBOARD", "timestamp": "2026-04-06T02:19:39.073Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-06 02:19:39.074
cmnnh6tlp0003i204xibx4j7i	cmnnfgg51000bjs04cq014frr	mamathivenugopal@gmail.com	PROFILE_UPDATE	USER	cmnnfgg51000bjs04cq014frr	{"platform": "DASHBOARD", "timestamp": "2026-04-06T17:39:57.660Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-06 17:39:57.661
cmnnu6p1m0003lb04dwm4arnz	cmnlll4t00001lb04hfrqrf54	itzsriharishetty@gmail.com	PROFILE_UPDATE	USER	cmnlll4t00001lb04hfrqrf54	{"platform": "DASHBOARD", "timestamp": "2026-04-06T23:43:46.761Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-06 23:43:46.762
cmno4eenr0001jq04bhtgemk8	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	HIDE_POST	post	cmnlsmkpb000bu7xk3khubpdy	{"hidden": true}	\N	2026-04-07 04:29:42.711
cmno4efjb0003jq04wlrng00c	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	HIDE_POST	post	cmnlsmkpb000bu7xk3khubpdy	{"hidden": true}	\N	2026-04-07 04:29:43.848
cmno4ek4h0005jq048zjxsrx7	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	HIDE_POST	post	cmnlsmkpb000bu7xk3khubpdy	{"hidden": true}	\N	2026-04-07 04:29:49.793
cmno5y4pc0003lj05fye49m2f	cmno5ve4t0001lj05iszt7inf	ammuammukutty744@gmail.com	PROFILE_UPDATE	USER	cmno5ve4t0001lj05iszt7inf	{"platform": "DASHBOARD", "timestamp": "2026-04-07T05:13:02.543Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-07 05:13:02.544
cmnopvify000rla049cdtm9zd	cmnooui3d0007l1049eg755uk	hitheshms178@gmail.com	PROFILE_UPDATE	USER	cmnooui3d0007l1049eg755uk	{"platform": "DASHBOARD", "timestamp": "2026-04-07T14:30:52.701Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-07 14:30:52.702
cmnopwp7u000tla04hb1dhfqy	cmnopk78z0001l204tjg4xfom	njnanesh59@gmail.com	PROFILE_UPDATE	USER	cmnopk78z0001l204tjg4xfom	{"platform": "DASHBOARD", "timestamp": "2026-04-07T14:31:48.138Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-07 14:31:48.139
cmnopxijl000vla04eetlg1lh	cmnopk78z0001l204tjg4xfom	njnanesh59@gmail.com	PROFILE_UPDATE	USER	cmnopk78z0001l204tjg4xfom	{"platform": "DASHBOARD", "timestamp": "2026-04-07T14:32:26.144Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-07 14:32:26.145
cmnoq0e0p0015la04ibna21ey	cmnopnp5n0004la04mg1lk58l	shrinayak06@gmail.com	PROFILE_UPDATE	USER	cmnopnp5n0004la04mg1lk58l	{"platform": "DASHBOARD", "timestamp": "2026-04-07T14:34:40.248Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-07 14:34:40.249
cmnoq1rfn0017la04otouo01y	cmnopnp5n0004la04mg1lk58l	shrinayak06@gmail.com	PROFILE_UPDATE	USER	cmnopnp5n0004la04mg1lk58l	{"platform": "DASHBOARD", "timestamp": "2026-04-07T14:35:44.291Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-07 14:35:44.292
cmnoq2hsr0019la04xbzd2gm9	cmnooui3d0007l1049eg755uk	hitheshms178@gmail.com	PROFILE_UPDATE	USER	cmnooui3d0007l1049eg755uk	{"platform": "DASHBOARD", "timestamp": "2026-04-07T14:36:18.459Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-07 14:36:18.46
cmnoq3q21001bla04uyih0z3b	cmnopnwl80005la041arwkbo9	masaladose9501@gmail.com	PROFILE_UPDATE	USER	cmnopnwl80005la041arwkbo9	{"platform": "DASHBOARD", "timestamp": "2026-04-07T14:37:15.816Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-07 14:37:15.817
cmnoq4mhv001dla04s0urplmn	cmnooui3d0007l1049eg755uk	hitheshms178@gmail.com	PROFILE_UPDATE	USER	cmnooui3d0007l1049eg755uk	{"platform": "DASHBOARD", "timestamp": "2026-04-07T14:37:57.859Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-07 14:37:57.86
cmnoq70yf001fla04w3n4civn	cmnopy6gu000xla04t0qvw9hi	abhishek.leo2006@gmail.com	PROFILE_UPDATE	USER	cmnopy6gu000xla04t0qvw9hi	{"platform": "DASHBOARD", "timestamp": "2026-04-07T14:39:49.911Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-07 14:39:49.912
cmnoq9yfy001nla04mem0zj6l	cmnopnp5n0004la04mg1lk58l	shrinayak06@gmail.com	PROFILE_UPDATE	USER	cmnopnp5n0004la04mg1lk58l	{"platform": "DASHBOARD", "timestamp": "2026-04-07T14:42:06.621Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-07 14:42:06.622
cmnoqcvr4001pla04n1bltgbk	cmnooui3d0007l1049eg755uk	hitheshms178@gmail.com	PROFILE_UPDATE	USER	cmnooui3d0007l1049eg755uk	{"platform": "DASHBOARD", "timestamp": "2026-04-07T14:44:23.103Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-07 14:44:23.104
cmnos05vo0001jv04brld03lh	cmnopnwl80005la041arwkbo9	masaladose9501@gmail.com	PROFILE_UPDATE	USER	cmnopnwl80005la041arwkbo9	{"platform": "DASHBOARD", "timestamp": "2026-04-07T15:30:28.930Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-07 15:30:28.932
cmnpmw9qx000ui804bx7s57rv	cmnpmutxr000ci804ptp4zbns	ss9097542@gmail.com	PROFILE_UPDATE	USER	cmnpmutxr000ci804ptp4zbns	{"platform": "DASHBOARD", "timestamp": "2026-04-08T05:55:15.417Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-08 05:55:15.418
cmnpo13310002jr04pdl2rlbb	cmnpo08j70000jr04h61ingzm	kruthikargowda142@gmail.com	PROFILE_UPDATE	USER	cmnpo08j70000jr04h61ingzm	{"platform": "DASHBOARD", "timestamp": "2026-04-08T06:26:59.677Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-08 06:26:59.678
cmnpo6xe70005jr04ilsycq17	cmnpo65x80003jr041jlndrgh	pragnabharadwaj1610@gmail.com	PROFILE_UPDATE	USER	cmnpo65x80003jr041jlndrgh	{"platform": "DASHBOARD", "timestamp": "2026-04-08T06:31:32.239Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-08 06:31:32.24
cmnpompub0002l104n71zoypx	cmnpokq290000l104vahy7i31	bisegowda196@gmail.com	PROFILE_UPDATE	USER	cmnpokq290000l104vahy7i31	{"platform": "DASHBOARD", "timestamp": "2026-04-08T06:43:48.947Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-08 06:43:48.948
cmnppdc0r000ol1042q9u2xnm	cmnppb2z0000gl104psm1vo0h	racchur546@gmail.com	PROFILE_UPDATE	USER	cmnppb2z0000gl104psm1vo0h	{"platform": "DASHBOARD", "timestamp": "2026-04-08T07:04:30.746Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-08 07:04:30.747
cmnppfoqu000xl104nzk4o13a	cmnppesjx000pl104x549yh1r	sm1265231@gmail.com	PROFILE_UPDATE	USER	cmnppesjx000pl104x549yh1r	{"platform": "DASHBOARD", "timestamp": "2026-04-08T07:06:20.550Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-08 07:06:20.551
cmnppfzjp000zl104z0pvi3ng	cmnppesjx000pl104x549yh1r	sm1265231@gmail.com	PROFILE_UPDATE	USER	cmnppesjx000pl104x549yh1r	{"platform": "DASHBOARD", "timestamp": "2026-04-08T07:06:34.548Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-08 07:06:34.549
cmnppk4qi0001u7bw4xcvf3lf	cmnighgle0004u718dt5i4clk	test@example.com	PROFILE_UPDATE	USER	cmnighgle0004u718dt5i4clk	{"platform": "DASHBOARD", "timestamp": "2026-04-08T07:09:47.883Z", "changedFields": ["fullName", "collegeName", "bio", "city", "avatar"]}	\N	2026-04-08 07:09:47.884
cmnppmqfz0003u7bwdfz8571x	cmnlp7mo10005u7qokf9h26km	fashion@gmail.com	PROFILE_UPDATE	USER	cmnlp7mo10005u7qokf9h26km	{"platform": "DASHBOARD", "timestamp": "2026-04-08T07:11:49.342Z", "changedFields": ["fullName", "collegeName", "bio", "city", "avatar"]}	\N	2026-04-08 07:11:49.344
cmnppmzm60005u7bw1ohervyz	cmnlp7mo10005u7qokf9h26km	fashion@gmail.com	PROFILE_UPDATE	USER	cmnlp7mo10005u7qokf9h26km	{"platform": "DASHBOARD", "timestamp": "2026-04-08T07:12:01.229Z", "changedFields": ["fullName", "collegeName", "bio", "city", "avatar"]}	\N	2026-04-08 07:12:01.23
cmnppruje0019l1040sx46v7n	cmnppqqea0017l104pcv6a8ue	lakshmi75744@gmail.com	PROFILE_UPDATE	USER	cmnppqqea0017l104pcv6a8ue	{"platform": "DASHBOARD", "timestamp": "2026-04-08T07:15:47.930Z", "changedFields": ["fullName", "phoneNumber", "collegeName", "bio", "city", "graduationYear", "avatar"]}	\N	2026-04-08 07:15:47.93
cmnprvszf0001u7kcyjv726l7	cmnmqwwe20001l704fcndlpxw	SuhasOffcampusclub@gmail.com	PROFILE_UPDATE	USER	cmnmqwwe20001l704fcndlpxw	{"platform": "DASHBOARD", "timestamp": "2026-04-08T08:14:51.770Z", "changedFields": ["fullName", "collegeName", "bio", "city", "avatar"]}	\N	2026-04-08 08:14:51.772
cmnq5ik6y0001ju04602njdc5	cmnq5enhp0000ky0491y0521w	kanthara125@gmail.com	PROFILE_UPDATE	USER	cmnq5enhp0000ky0491y0521w	{"platform": "DASHBOARD", "timestamp": "2026-04-08T14:36:28.473Z", "changedFields": ["fullName", "collegeName", "bio", "city", "phoneNumber", "graduationYear", "avatar"]}	\N	2026-04-08 14:36:28.474
cmnr1kw5u001oml07wcytwml6	cmnr1hefk0003ml07jcmdubxd	pool34111@gmail.com	PROFILE_UPDATE	USER	cmnr1hefk0003ml07jcmdubxd	{"platform": "DASHBOARD", "timestamp": "2026-04-09T05:34:05.009Z", "changedFields": ["fullName", "collegeName", "bio", "city", "phoneNumber", "graduationYear", "avatar"]}	\N	2026-04-09 05:34:05.01
cmnr27gdf000ckv04n5wfbwra	cmnr1gjhz000djy043cacv584	bhumikanv2@gmail.com	PROFILE_UPDATE	USER	cmnr1gjhz000djy043cacv584	{"platform": "DASHBOARD", "timestamp": "2026-04-09T05:51:37.635Z", "changedFields": ["fullName", "collegeName", "bio", "city", "phoneNumber", "graduationYear", "avatar"]}	\N	2026-04-09 05:51:37.636
cmnr27q91000gkv04eay5x0lx	cmnr1gjhz000djy043cacv584	bhumikanv2@gmail.com	PROFILE_UPDATE	USER	cmnr1gjhz000djy043cacv584	{"platform": "DASHBOARD", "timestamp": "2026-04-09T05:51:50.436Z", "changedFields": ["fullName", "collegeName", "bio", "city", "phoneNumber", "graduationYear", "avatar"]}	\N	2026-04-09 05:51:50.437
cmnr4455t0004u79kck4lf3o5	cmnighgle0004u718dt5i4clk	test@example.com	PROFILE_UPDATE	USER	cmnighgle0004u718dt5i4clk	{"platform": "DASHBOARD", "timestamp": "2026-04-09T06:45:02.367Z", "changedFields": ["fullName", "collegeName", "bio", "city", "phoneNumber", "graduationYear", "avatar"]}	\N	2026-04-09 06:45:02.369
cmnr4bb0q0006u79kh55r0uk6	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	CHANGE_ROLE	user	cmnighgle0004u718dt5i4clk	{"role": "CLUB_HEADER"}	\N	2026-04-09 06:50:36.554
cmnr4i1ax0008u79kkfozv1qy	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	HIDE_POST	post	cmnjdsp6j0003u7soqrneg2eb	{"hidden": true}	\N	2026-04-09 06:55:50.553
cmnr4i4ht000au79krkuvyoxx	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	HIDE_POST	post	cmnjdsp6j0003u7soqrneg2eb	{"hidden": true}	\N	2026-04-09 06:55:54.689
cmnr4i601000cu79klu21vb8p	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	HIDE_POST	post	cmnjdsp6j0003u7soqrneg2eb	{"hidden": true}	\N	2026-04-09 06:55:56.641
cmnr4in2v000eu79kyngtkesx	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	DELETE_POST	post	cmnjdsp6j0003u7soqrneg2eb	null	\N	2026-04-09 06:56:18.776
cmnr4ir3a000gu79k6vx71xyr	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	DELETE_POST	post	cmnjda5z90001u7sod3uiq9ev	null	\N	2026-04-09 06:56:23.975
cmnr4ste6000qu79keo916qy1	cmnr4ki2a000iu79katbp2k6m	theindianbiker@gmail.com	PROFILE_UPDATE	USER	cmnr4ki2a000iu79katbp2k6m	{"platform": "DASHBOARD", "timestamp": "2026-04-09T07:04:13.517Z", "changedFields": ["fullName", "collegeName", "bio", "city", "avatar"]}	\N	2026-04-09 07:04:13.519
cmnr7lw580001l1040pjp4b9t	cmnr7gjjt0000l504xt5yrtt4	salmanracykhan@gmail.com	PROFILE_UPDATE	USER	cmnr7gjjt0000l504xt5yrtt4	{"platform": "DASHBOARD", "timestamp": "2026-04-09T08:22:49.340Z", "changedFields": ["fullName", "collegeName", "bio", "city", "phoneNumber", "graduationYear", "avatar"]}	\N	2026-04-09 08:22:49.341
cmnsea3m40001u7zks1xqm8iz	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	UPDATE_SETTINGS	security	\N	{"path": "admin-api-guard", "method": "MUTATION_OR_READ", "module": "moderation", "source": "requireAdminPermission", "actorRole": "ADMIN", "targetEntity": null, "requestedAction": "read"}	\N	2026-04-10 04:17:22.635
cmnsea8i90003u7zksekurkbu	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	UPDATE_SETTINGS	security	\N	{"path": "admin-api-guard", "method": "MUTATION_OR_READ", "module": "moderation", "source": "requireAdminPermission", "actorRole": "ADMIN", "targetEntity": null, "requestedAction": "read"}	\N	2026-04-10 04:17:28.978
cmnseaghw0005u7zkfz8rz4py	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	UPDATE_SETTINGS	security	\N	{"path": "admin-api-guard", "method": "MUTATION_OR_READ", "module": "moderation", "source": "requireAdminPermission", "actorRole": "ADMIN", "targetEntity": null, "requestedAction": "read"}	\N	2026-04-10 04:17:39.332
cmnseakhr0007u7zk4cwky12u	seed-admin-occ-staff	occ-staff-r8k2@occ-local.dev	UPDATE_SETTINGS	security	\N	{"path": "admin-api-guard", "method": "MUTATION_OR_READ", "module": "moderation", "source": "requireAdminPermission", "actorRole": "ADMIN", "targetEntity": null, "requestedAction": "read"}	\N	2026-04-10 04:17:44.511
cmnseea8e0009u7zk9ee0c06z	cmno6dlbj0000i5048wzcgi92	suryas.sec.official@gmail.com	PROFILE_UPDATE	USER	cmno6dlbj0000i5048wzcgi92	{"platform": "DASHBOARD", "timestamp": "2026-04-10T04:20:37.836Z", "changedFields": ["fullName", "collegeName", "bio", "city", "phoneNumber", "graduationYear", "avatar"]}	\N	2026-04-10 04:20:37.839
cmnsgeyjt0007lj04c5duk3rw	cmno9keux0000lb047w1faixt	jishnunreddy@gmail.com	PROFILE_UPDATE	USER	cmno9keux0000lb047w1faixt	{"platform": "DASHBOARD", "timestamp": "2026-04-10T05:17:08.585Z", "changedFields": ["fullName", "collegeName", "bio", "city", "phoneNumber", "graduationYear", "avatar"]}	\N	2026-04-10 05:17:08.586
cmnsggixs0009lj0443j30yls	cmno9keux0000lb047w1faixt	jishnunreddy@gmail.com	PROFILE_UPDATE	USER	cmno9keux0000lb047w1faixt	{"platform": "DASHBOARD", "timestamp": "2026-04-10T05:18:21.663Z", "changedFields": ["fullName", "collegeName", "bio", "city", "phoneNumber", "graduationYear", "avatar"]}	\N	2026-04-10 05:18:21.664
cmnsj2qkx0001jr04ggwvvvw1	cmn74dl9900168u1jtw2fmhwp	harshitharmbaturi@gmail.com	PROFILE_UPDATE	USER	cmn74dl9900168u1jtw2fmhwp	{"platform": "DASHBOARD", "timestamp": "2026-04-10T06:31:37.233Z", "changedFields": ["fullName", "collegeName", "bio", "city", "phoneNumber", "graduationYear", "avatar"]}	\N	2026-04-10 06:31:37.234
cmnsj2x1l0003jr04199q5s4q	cmn74dl9900168u1jtw2fmhwp	harshitharmbaturi@gmail.com	PROFILE_UPDATE	USER	cmn74dl9900168u1jtw2fmhwp	{"platform": "DASHBOARD", "timestamp": "2026-04-10T06:31:45.609Z", "changedFields": ["fullName", "collegeName", "bio", "city", "phoneNumber", "graduationYear", "avatar"]}	\N	2026-04-10 06:31:45.609
\.


--
-- Data for Name: club_memberships; Type: TABLE DATA; Schema: public; Owner: occ_4t52_user
--

COPY public.club_memberships (id, "userId", "clubId", "joinedAt", role) FROM stdin;
cmnigld5c000au7185t47yzsg	cmniglcfn0008u718ymztkf7y	club-bikers	2026-04-03 05:24:25.681	member
cmniwy7b40002l804dlv3t1ok	cmniww0ri0000l804blqeohxx	club-photography	2026-04-03 13:02:18.496	member
cmnj100950003la040al6co7q	cmniz1sz20000l104bpufvsd8	club-music	2026-04-03 14:55:41.129	member
cmnjb4sa00001i904mcvtk5rz	cmniz1sz20000l104bpufvsd8	club-fashion	2026-04-03 19:39:20.232	member
cmnjtwrwf0009l804h6ggphvu	cmniz1sz20000l104bpufvsd8	club-bikers	2026-04-04 04:24:59.2	member
cmnk8g5sd0001jm04qu35tcjg	cmnjxvgi90000kz042v6o3rfw	club-music	2026-04-04 11:11:58.285	member
cmnk8l6a70003jm04aysxb6c7	cmnjxvgi90000kz042v6o3rfw	club-fitness	2026-04-04 11:15:52.207	member
cmnk9m30b0005jo04r864g57j	cmnipa7et0000lb04ns1hjdoj	club-fashion	2026-04-04 11:44:34.236	member
cmnk9s82w0009jo040p2rj51x	cmnipa7et0000lb04ns1hjdoj	club-bikers	2026-04-04 11:49:20.744	member
cmnk9tezw000bjo04df525uzr	cmnipa7et0000lb04ns1hjdoj	club-music	2026-04-04 11:50:16.365	member
cmnk9tsiq000djo04b4o2bre6	cmnipa7et0000lb04ns1hjdoj	club-sports	2026-04-04 11:50:33.89	member
cmnk9zte3000tjo04r1tc3yix	cmnipa7et0000lb04ns1hjdoj	club-fitness	2026-04-04 11:55:14.955	member
cmnka77pe0002kv045ze76v4m	cmnka6bjp0000kv047w26c7j8	club-fitness	2026-04-04 12:01:00.099	member
cmnkd92io0001l1043kqgh3or	cmnk740dd0000ju04hrjxizbw	club-bikers	2026-04-04 13:26:25.536	member
cmnkk0rra0002ky049f3qdbt1	cmnkjyasn0000ky04du50tsze	club-photography	2026-04-04 16:35:55.655	member
cmnllq34z0003l504fsccy9a8	cmnlll4t00001lb04hfrqrf54	club-photography	2026-04-05 10:11:22.595	member
cmnlm7qgy0002l4043l97la4a	cmnk80gtx0000kz04uftryiq8	club-fitness	2026-04-05 10:25:05.986	member
cmnlnsqld0001u7ygnbgxcicm	cmniglcfn0008u718ymztkf7y	club-fitness	2026-04-05 11:09:25.533	member
cmnlnzsu80002u7g8b5m3hggz	cmnlnzrgc0000u7g8bnvwieww	club-music	2026-04-05 11:14:55.041	member
cmnlnzwsg000ju7g8bxjphh4v	cmnlnzvxj000hu7g899pi5rev	club-sports	2026-04-05 11:15:00.161	member
cmnlnzzom0010u7g80r89xv4d	cmnlnzyux000yu7g8nddmimfe	club-fashion	2026-04-05 11:15:03.91	member
cmnlo02md001hu7g8ka5eir2h	cmnlo01qk001fu7g8r1o6y7y1	club-bikers	2026-04-05 11:15:07.718	member
cmnlo05pl001yu7g8pfc8pory	cmnlo04ud001wu7g88a1r9dmf	club-photography	2026-04-05 11:15:11.722	member
cmnlo08s6002fu7g8ov45bjpu	cmnlo07w2002du7g839j1r0oe	club-fitness	2026-04-05 11:15:15.702	member
cmnmoor5z0001l504its3kuqd	cmnjxvgi90000kz042v6o3rfw	cmnlqr8sa0001u7xklay1hj3b	2026-04-06 04:22:05.447	member
cmnmqsgwj0009kz04dvgpqi9g	cmnmqs0i40007kz046nr2eh1z	club-bikers	2026-04-06 05:20:58.004	member
cmnms8e1i0002jx04zoc151dx	cmnms6un70000jx04ampxv5sv	cmnlqr8sa0001u7xklay1hj3b	2026-04-06 06:01:20.407	member
cmnmtua0z0003l2049fronth4	cmnipa7et0000lb04ns1hjdoj	cmnlqr8sa0001u7xklay1hj3b	2026-04-06 06:46:21.251	member
cmnmuclp9000nl404o8k7mmyv	cmnipa7et0000lb04ns1hjdoj	club-photography	2026-04-06 07:00:36.189	member
cmnmzn1b2000ikz047p26kg00	cmnirceit0000l704lzf6xukz	club-bikers	2026-04-06 09:28:41.055	member
cmnn4lmsv0001k104izxfjkca	cmnmzce8a0008kz04bgb9abwu	club-music	2026-04-06 11:47:33.68	member
cmnn4w29b0003jp04al6fqmp2	cmnmyvc4p0003kz04i0qezemt	club-bikers	2026-04-06 11:55:40.271	member
cmnn4xsoe0001ic04u8uqp5oe	cmnk740dd0000ju04hrjxizbw	cmnlqr8sa0001u7xklay1hj3b	2026-04-06 11:57:01.166	member
cmnn5s17x0001js04vki58e0i	cmnivjy4f0003l104y9t3rceb	cmnlqr8sa0001u7xklay1hj3b	2026-04-06 12:20:31.917	member
cmnn5w0m40003js04dpxhiy2g	cmnmzipoo000ekz043lnx7r1j	club-bikers	2026-04-06 12:23:37.757	member
cmnn5w8iq0005js046t3daxin	cmnmzipoo000ekz043lnx7r1j	club-sports	2026-04-06 12:23:48.002	member
cmnnd1i350006la04qmip03cr	cmnnd0zht0004la04zai8gfv8	cmnlqr8sa0001u7xklay1hj3b	2026-04-06 15:43:50.993	member
cmnnd3qd80009la0406c3nqcy	cmnmvnjgk0001jm04b8zimpvz	cmnlqr8sa0001u7xklay1hj3b	2026-04-06 15:45:35.036	member
cmnndd9sl000ela04viubb0r8	cmnndcowz000cla04udl8xux1	cmnlqr8sa0001u7xklay1hj3b	2026-04-06 15:53:00.117	member
cmnndtcx60002js0465spnpde	cmnndsonh0000js04ev8lv2lr	cmnlqr8sa0001u7xklay1hj3b	2026-04-06 16:05:30.666	member
cmnnfa0lv0005js04ru0w30jg	cmnnf8r2a0003js04igvv8xt0	cmnlqr8sa0001u7xklay1hj3b	2026-04-06 16:46:27.475	member
cmnng8s1o0001lg04yznjqtmb	cmnnfaau10007js04koqnohvg	cmnlqr8sa0001u7xklay1hj3b	2026-04-06 17:13:29.341	member
cmno6yxpy0003l7043odmgzu0	cmno6xrdh0000l7048tj25rck	cmnlqr8sa0001u7xklay1hj3b	2026-04-07 05:41:39.766	member
cmno78j33000al7048pjim4mz	cmno77zn30008l7047ff99iwv	club-music	2026-04-07 05:49:07.359	member
cmno78kr2000cl704bxmq6rok	cmno77zn30008l7047ff99iwv	club-bikers	2026-04-07 05:49:09.519	member
cmno78mu1000el704hnv1og1t	cmno77zn30008l7047ff99iwv	club-photography	2026-04-07 05:49:12.218	member
cmno78pxa000gl704tge1urn1	cmno77zn30008l7047ff99iwv	club-fashion	2026-04-07 05:49:16.222	member
cmno8ynfq0001u77gy4agbfrv	cmno6dlbj0000i5048wzcgi92	cmnlqr8sa0001u7xklay1hj3b	2026-04-07 06:37:25.667	member
cmno9kz3v0002lb045yd374ph	cmno9keux0000lb047w1faixt	cmnlqr8sa0001u7xklay1hj3b	2026-04-07 06:54:47.228	member
cmnobyu640002l404jc3kf0wf	cmnoby71o0000l4040rvnsohr	cmnlqr8sa0001u7xklay1hj3b	2026-04-07 08:01:33.245	member
cmnodqaii0002l1049m84xhvc	cmnodphsh0000l104ppmfxjos	club-music	2026-04-07 08:50:53.754	member
cmnof9s7r0002js04mez2tocw	cmnof8b8l0000js045whsc481	club-music	2026-04-07 09:34:02.776	member
cmnojtkf80001jx04mycuoykk	cmnk740dd0000ju04hrjxizbw	club-music	2026-04-07 11:41:24.26	member
cmnojvcjp0003jx046abmnkoa	cmnk740dd0000ju04hrjxizbw	club-sports	2026-04-07 11:42:47.365	member
cmnok9gmw000eu7o8hcox7cv8	cmniglcfn0008u718ymztkf7y	cmnlqr8sa0001u7xklay1hj3b	2026-04-07 11:53:45.833	member
cmnoollyp0002l1041b2qrhdu	cmnool7ao0000l104yibxmg0d	cmnlqr8sa0001u7xklay1hj3b	2026-04-07 13:55:11.09	member
cmnoploaf0004l2043ohj6xew	cmnopk78z0001l204tjg4xfom	cmnlqr8sa0001u7xklay1hj3b	2026-04-07 14:23:13.72	member
cmnopn81q0001la045ppbl4zl	cmnooui3d0007l1049eg755uk	cmnlqr8sa0001u7xklay1hj3b	2026-04-07 14:24:25.983	member
cmnopo4ei0009la04e4gi16uy	cmnopnp5n0004la04mg1lk58l	cmnlqr8sa0001u7xklay1hj3b	2026-04-07 14:25:07.915	member
cmnopq2y4000lla04ikom1kz7	cmnopnwl80005la041arwkbo9	club-fashion	2026-04-07 14:26:39.34	member
cmnopy6xg000zla04zy7kebdr	cmnopy6gu000xla04t0qvw9hi	cmnlqr8sa0001u7xklay1hj3b	2026-04-07 14:32:57.749	member
cmnoq85tu001hla040rhi55yi	cmnopnwl80005la041arwkbo9	club-photography	2026-04-07 14:40:42.883	member
cmnoq87bx001jla04ck1koto5	cmnopnwl80005la041arwkbo9	club-fitness	2026-04-07 14:40:44.83	member
cmnoq93kf001lla04cef259gx	cmnopnwl80005la041arwkbo9	cmnlqr8sa0001u7xklay1hj3b	2026-04-07 14:41:26.608	member
cmnoqiwaa001tla049oytqg57	cmnoqhm7o001rla047j1dnsk5	cmnlqr8sa0001u7xklay1hj3b	2026-04-07 14:49:03.73	member
cmnpmuufe000ei804r2m14hxl	cmnpmutxr000ci804ptp4zbns	cmnlqr8sa0001u7xklay1hj3b	2026-04-08 05:54:08.906	member
cmnpmv986000mi804rlevbetd	cmnpmv8sb000ji804yuawurq3	cmnlqr8sa0001u7xklay1hj3b	2026-04-08 05:54:28.086	member
cmnpmwf8b000xi804lx5plu0n	cmnpmwexc000vi804jf5k0kmw	cmnlqr8sa0001u7xklay1hj3b	2026-04-08 05:55:22.524	member
cmnpmwfz20002l204m2k2wzhr	cmnpmwfg90000l2046nijyeqn	cmnlqr8sa0001u7xklay1hj3b	2026-04-08 05:55:23.487	member
cmnpmxidr000bl204dg43liyg	cmnpmxi390009l2042x607c2i	cmnlqr8sa0001u7xklay1hj3b	2026-04-08 05:56:13.263	member
cmnpp3phw0007l104nctkv6tb	cmnpp2m9z0005l104i8wndoom	cmnlqr8sa0001u7xklay1hj3b	2026-04-08 06:57:01.652	member
cmnppbqx0000il104gv0uoe46	cmnppb2z0000gl104psm1vo0h	cmnlqr8sa0001u7xklay1hj3b	2026-04-08 07:03:16.74	member
cmnppf4og000rl104gheju3t4	cmnppesjx000pl104x549yh1r	cmnlqr8sa0001u7xklay1hj3b	2026-04-08 07:05:54.544	member
cmnppn77d0012l104nop3c1e9	cmnppmg590010l1041iaj5q43	cmnlqr8sa0001u7xklay1hj3b	2026-04-08 07:12:11.066	member
cmnprnnqi0001ky04pcsz8vsx	cmno5uxkf0000lj058iik9dy5	cmnlqr8sa0001u7xklay1hj3b	2026-04-08 08:08:31.722	member
cmnpshgxf0002js04uwyaob6w	cmnpsgjg80000js040sr75m8v	club-bikers	2026-04-08 08:31:42.579	member
cmnpz248h0003ju042oroze2n	cmnpz23ng0001ju048p4qjc82	cmnlqr8sa0001u7xklay1hj3b	2026-04-08 11:35:43.601	member
cmnr1hmp20008ml07bp5owq0e	cmnr1fdi90000jy04x7jbc0ww	club-bikers	2026-04-09 05:31:32.774	member
cmnr1i16x000blf04qdskg40l	cmnr1gjhz000djy043cacv584	cmnlqr8sa0001u7xklay1hj3b	2026-04-09 05:31:51.561	member
cmnr1i2ak000elf042kjwtp4v	cmnr1fsfb0005jy04tb0ysg5o	cmnlqr8sa0001u7xklay1hj3b	2026-04-09 05:31:52.988	member
cmnr1ifyj000llf04ul61p9q9	cmnr1gjhz000djy043cacv584	club-fashion	2026-04-09 05:32:10.7	member
cmnr1indt000mml07p1tbl7y1	cmnr1h5f50000ml07toh9dkss	club-bikers	2026-04-09 05:32:20.322	member
cmnr1ipx4000qml07fiqfaypx	cmnr1fm7m0003jy04wmfy0e21	club-fashion	2026-04-09 05:32:23.608	member
cmnr1ixk6000wml07jiejcacl	cmnr1hf8t0004ml079lym4g6w	club-bikers	2026-04-09 05:32:33.51	member
cmnr1j4nc000qlf046nrv9scy	cmnr1gldl0002lf04hx59sgli	club-fitness	2026-04-09 05:32:42.696	member
cmnr1jbx3000ulf043mwauque	cmnr1gywo000gjy04e755btwj	cmnlqr8sa0001u7xklay1hj3b	2026-04-09 05:32:52.119	member
cmnr1pswl0001kv045qyshrex	cmnr1lodf0016lf042e5nvzuq	club-bikers	2026-04-09 05:37:54.069	member
cmnr2406e0007kv04nqbzhpct	cmnr1hqyx000dml07911ky6k2	club-fitness	2026-04-09 05:48:56.678	member
cmnr246720009kv04xsn5ecgw	cmnr1hqyx000dml07911ky6k2	club-music	2026-04-09 05:49:04.478	member
cmnr2jcnd0007l504y9s1tbv6	cmnr2fjmk0005l504o5ro7fp0	club-fashion	2026-04-09 06:00:52.682	member
cmnr3t2dj0001js04hxun1ydj	cmnr3rnh90000jr04dtouk34f	club-fashion	2026-04-09 06:36:25.544	member
cmnr7j2ry0004l504eb2b7rep	cmnr7gjjt0000l504xt5yrtt4	club-music	2026-04-09 08:20:37.966	member
cmnrgm3iw0002jf0427v6i2kf	cmnrgl2sj0000jf04gdmvejhs	cmnlqr8sa0001u7xklay1hj3b	2026-04-09 12:34:55.449	member
cmnri2glj0002ky04vsg5uyhd	cmnri2g3z0000ky0493id515v	cmnlqr8sa0001u7xklay1hj3b	2026-04-09 13:15:38.503	member
cmnseqxpq0001jv04nwjdy8xu	cmno9keux0000lb047w1faixt	club-sports	2026-04-10 04:30:28.142	member
cmnsey769000hjv043wbliyje	cmno9keux0000lb047w1faixt	club-bikers	2026-04-10 04:36:06.993	member
cmnsey9a9000jjv04m9gf7a16	cmno9keux0000lb047w1faixt	club-music	2026-04-10 04:36:09.73	member
cmnseyc4q000ljv04258ri3kg	cmno9keux0000lb047w1faixt	club-fitness	2026-04-10 04:36:13.418	member
cmnsgqkxu000flj04dkjuu555	cmnmzipoo000ekz043lnx7r1j	club-music	2026-04-10 05:26:10.819	member
cmnsh46ua0002lb04d98ezi92	cmnsh0d7a000jlj0452v424rh	cmnlqr8sa0001u7xklay1hj3b	2026-04-10 05:36:45.73	member
cmnsh4k57000ola04817908mn	cmnsh27e2000mlj045gtg4jz2	cmnlqr8sa0001u7xklay1hj3b	2026-04-10 05:37:02.971	member
cmnsh4ump000blb04i3r0q3ll	cmnsh2adp000nlj043edrpnrk	cmnlqr8sa0001u7xklay1hj3b	2026-04-10 05:37:16.561	member
cmnsh4y5w000hlb04f28socv2	cmnsh3wwa000olj04avygqj0o	cmnlqr8sa0001u7xklay1hj3b	2026-04-10 05:37:21.14	member
cmnsh5190000nlb04f8lkcthv	cmnsh0scz000llj04bi0nics2	cmnlqr8sa0001u7xklay1hj3b	2026-04-10 05:37:25.14	member
cmnsh5570000ulb04h03wl602	cmnsgzofj000hlj04eyyyu0fj	cmnlqr8sa0001u7xklay1hj3b	2026-04-10 05:37:30.252	member
cmnsh5c3q0010lb04zvbhzu0o	cmnsh4rfy000ula04srietnaj	cmnlqr8sa0001u7xklay1hj3b	2026-04-10 05:37:39.206	member
cmnsh5oli0016lb04yn3g7jm6	cmnsh4cnf0009lb0464mx03n3	cmnlqr8sa0001u7xklay1hj3b	2026-04-10 05:37:55.399	member
cmnsh5qca001clb04ra8pswcu	cmnsh4p76000tla042e1tuj1j	cmnlqr8sa0001u7xklay1hj3b	2026-04-10 05:37:57.658	member
cmnsh5xxo000xla04wb8frh7o	cmnsh47zn0007lb047f2e9q3l	cmnlqr8sa0001u7xklay1hj3b	2026-04-10 05:38:07.501	member
cmnsh5ye6000zla04ij93u7b2	cmnsh4dwx000mla04hjxs1r6o	cmnlqr8sa0001u7xklay1hj3b	2026-04-10 05:38:08.094	member
cmnsh640z0019la044kkzmdpi	cmnsh4dau000lla04n9hasucx	cmnlqr8sa0001u7xklay1hj3b	2026-04-10 05:38:15.395	member
cmnsh652j001fla0428io5mx8	cmnsh0scz000llj04bi0nics2	club-photography	2026-04-10 05:38:16.748	member
cmnsh6dnq001hla04g6h4ect7	cmnsh2adp000nlj043edrpnrk	club-photography	2026-04-10 05:38:27.879	member
cmnsh6fmh001jla04k6p5snl4	cmnsh2adp000nlj043edrpnrk	club-fitness	2026-04-10 05:38:30.425	member
cmnsh6ggf001lla04i1ygvmsx	cmnsh0scz000llj04bi0nics2	club-fashion	2026-04-10 05:38:31.503	member
cmnsh6h8g001nla04y52etpb8	cmnsh4rfy000ula04srietnaj	club-fashion	2026-04-10 05:38:32.512	member
cmnsh6j0c001pla04u0m4qcco	cmnsh2adp000nlj043edrpnrk	club-bikers	2026-04-10 05:38:34.813	member
cmnsh6kx9001rla049juxeaom	cmnsh4rfy000ula04srietnaj	club-photography	2026-04-10 05:38:37.293	member
cmnsh6pkl0001lh06gyg5oujq	cmnsh4rfy000ula04srietnaj	club-music	2026-04-10 05:38:43.317	member
cmnsh6rgj0003lh06izuq8shp	cmnsh0scz000llj04bi0nics2	club-music	2026-04-10 05:38:45.763	member
cmnsh6sec001tla04nfiib3lf	cmnsh5wai000vla04xk2aruz3	cmnlqr8sa0001u7xklay1hj3b	2026-04-10 05:38:46.98	member
cmnsh6tjl001zla049xywem8c	cmnsh3wwa000olj04avygqj0o	club-sports	2026-04-10 05:38:48.465	member
cmnsh6ydq0021la04vzcxbdtl	cmnsh4rfy000ula04srietnaj	club-fitness	2026-04-10 05:38:54.735	member
cmnsh6z3d0023la04zjnfhx0x	cmnsh3wwa000olj04avygqj0o	club-music	2026-04-10 05:38:55.657	member
cmnsh74nd0025la044c8m5e0i	cmnsh532u000slb04tsmuaxg2	cmnlqr8sa0001u7xklay1hj3b	2026-04-10 05:39:02.857	member
cmnsh7atg002bla04ulrr44gv	cmnsh43xv0000lb042aumlphi	cmnlqr8sa0001u7xklay1hj3b	2026-04-10 05:39:10.852	member
cmnsh7han002hla043cnoleqh	cmnsh5xbi000plj04axp3pq84	cmnlqr8sa0001u7xklay1hj3b	2026-04-10 05:39:19.247	member
cmnsjqbdv0005l5044r2s6nc3	cmnsjp5vt0002l504fayewz4k	club-sports	2026-04-10 06:49:57.283	member
cmnsjtql10004ld04mknu7y38	cmnsjsj6n0002ld04t8g9de6h	club-sports	2026-04-10 06:52:36.949	member
cmnsjwh4q000ald044844ylsg	cmnsjv78t0007l504ovfxds6h	cmnlqr8sa0001u7xklay1hj3b	2026-04-10 06:54:44.666	member
cmnsjx33p000cld04uj8uhhsw	cmnsjv78t0007l504ovfxds6h	club-fitness	2026-04-10 06:55:13.141	member
cmnsjx83k000eld04ve1mgms4	cmnsjv78t0007l504ovfxds6h	club-bikers	2026-04-10 06:55:19.616	member
cmnsjyc2x0009l504dntsza5w	cmnsjxo2w000fld04n3t2h0m9	cmnlqr8sa0001u7xklay1hj3b	2026-04-10 06:56:11.433	member
cmnskalio000jl504smaiseuy	cmnsk98mx000gl504zrfd7ehq	club-bikers	2026-04-10 07:05:43.537	member
cmnslzenl0001l104o51nrbg5	cmno6dlbj0000i5048wzcgi92	club-sports	2026-04-10 07:53:00.657	member
cmnsr62xv0002l7042cybshje	cmnsr62l60000l704vk4hnxxm	cmnlqr8sa0001u7xklay1hj3b	2026-04-10 10:18:10.147	member
cmnsu2ayu0001l704jr8egrk1	cmno9keux0000lb047w1faixt	club-fashion	2026-04-10 11:39:12.775	member
\.


--
-- Data for Name: club_onboarding; Type: TABLE DATA; Schema: public; Owner: occ_4t52_user
--

COPY public.club_onboarding (id, "userId", "clubSlug", answer1, answer2, answer3, answer4, answer5, "createdAt", "updatedAt") FROM stdin;
cmnj0z14o0001la04tboz36b1	cmniz1sz20000l104bpufvsd8	photography	Film camera	Events	Movement / action	Confident and consistent	Paid shoot opportunities	2026-04-03 14:54:55.608	2026-04-03 14:54:55.608
cmnjaxuuy0001jy04n2lflvzu	cmniz1sz20000l104bpufvsd8	bikers	Weekend regular	Cruiser	Cafe-hopping day rides	Fast and focused	Discover new routes	2026-04-03 19:33:56.986	2026-04-03 19:33:56.986
cmnjdla080001u728dld8k61v	cmniwqsu00000u7u4t7qqpggt	sports	Midfielder	Just getting started	Joining tournaments	Local college leagues	Compete in tournaments	2026-04-03 20:48:08.936	2026-04-03 21:01:46.869
cmnjtdenh0001jr0455lbrrdd	cmniz1sz20000l104bpufvsd8	sports	Defender	Just getting started	Joining tournaments	Mundial world cup passion	Find people to play with regularly	2026-04-04 04:09:55.565	2026-04-04 04:09:55.565
cmnjtiwkm0003jr04xf9obidc	cmniz1sz20000l104bpufvsd8	fashion	Minimal and clean	Modeling	Luxury houses	Runway / showcase nights	Build a portfolio	2026-04-04 04:14:12.071	2026-04-04 04:14:12.071
cmnk9q5140007jo048e2210tp	cmnipa7et0000lb04ns1hjdoj	fashion	Still discovering it	Designing	Indie labels	Pop-up drops	Build a portfolio	2026-04-04 11:47:43.48	2026-04-04 11:47:43.48
cmnka3qhv000xjo046ngktvx0	cmnipa7et0000lb04ns1hjdoj	photography	DSLR / mirrorless	Portraits	Architecture	Learning quickly	Portfolio growth	2026-04-04 11:58:17.827	2026-04-04 11:58:17.827
cmnkk1tt80001la04yztj4zb5	cmnkjyasn0000ky04du50tsze	photography	Phone camera	Portraits	People	Learning quickly	Paid shoot opportunities	2026-04-04 16:36:44.972	2026-04-04 16:36:44.972
cmnmzrgvf000kkz04rrwaetqy	cmnmsh6mc0006jx04r9obo40g	music	Singer	Indie / alt	Studio sessions	Never, but I want to start	Explore new sounds	2026-04-06 09:32:07.851	2026-04-06 10:57:37.326
cmnn32we00002lb047jpbmq90	cmnmsh6mc0006jx04r9obo40g	fitness	Beginner	Sports conditioning	Feel healthier	2-3 sessions	Love challenges	2026-04-06 11:05:00.025	2026-04-06 11:06:10.067
cmnn7luxk0001l7042mq8oewp	cmnmzipoo000ekz043lnx7r1j	fitness	Beginner	Strength training	Look leaner	4-5 sessions	Love challenges	2026-04-06 13:11:43.065	2026-04-06 13:11:43.065
cmnnczudk0003la04hyqw61e6	cmnncz0xa0001la04ijnjnlaj	bikers	Long-time rider	Cruiser	Hill roads at sunrise	Smooth and scenic	Find my riding crew	2026-04-06 15:42:33.608	2026-04-06 15:42:33.608
cmnma904y0017u7ocpcgkufx9	cmniglcfn0008u718ymztkf7y	photography	DSLR / mirrorless	Portraits	Nature	Mostly editing so far	Photo walks and peers	2026-04-05 21:37:55.954	2026-04-05 21:37:55.954
cmnndhayz000gla04ix9rk3q0	cmnk80gtx0000kz04uftryiq8	fitness	Getting consistent	Strength training	Get stronger	Daily if needed	Love challenges	2026-04-06 15:56:08.268	2026-04-06 15:56:08.268
cmnlnyesg0003u7yg4p4j8euv	cmniglcfn0008u718ymztkf7y	fashion	Streetwear	Designing	Campus-born brands	Photoshoots	Attend standout events	2026-04-05 11:13:50.176	2026-04-06 05:07:13.142
cmnmaondh001bu7oc3eqs7hlb	cmniglcfn0008u718ymztkf7y	fitness	Getting consistent	Strength training	Get stronger	4-5 sessions	Love challenges	2026-04-05 21:50:05.909	2026-04-06 05:13:42.046
cmnm9l9zs000xu7oc5152b9u3	cmniglcfn0008u718ymztkf7y	music	Singer	Indie / alt	Open mics	Performed a lot	Perform live	2026-04-05 21:19:28.982	2026-04-06 05:15:02.192
cmnmqqln10005kz04cmoc22e9	cmnmqltov0000kz04kv0wdakf	bikers	Long-time rider	Cruiser	City night loops	Smooth and scenic	Discover new routes	2026-04-06 05:19:30.829	2026-04-06 05:19:30.829
cmnndvwu90004js044mg06d9i	cmnndsonh0000js04ev8lv2lr	fitness	Getting consistent	Strength training	Look leaner	2-3 sessions	Want a workout crew	2026-04-06 16:07:29.794	2026-04-06 16:07:29.794
cmnmcryhu0001jx04rl79d9rp	cmniz1sz20000l104bpufvsd8	music	Singer	Hip-hop / rap	Big live sets	Mostly private practice	Perform live	2026-04-05 22:48:39.523	2026-04-05 22:49:34.617
cmnmcugmd0003l404i7psr2jt	cmniz1sz20000l104bpufvsd8	fitness	Getting consistent	Yoga / mobility	Feel healthier	Still figuring it out	Need accountability	2026-04-05 22:50:36.325	2026-04-05 22:50:36.325
cmnmmo7fp0001if04p6rqikal	cmnighgle0004u718dt5i4clk	bikers	Long-time rider	Cruiser	Highway distance runs	Fast and focused	Discover new routes	2026-04-06 03:25:40.645	2026-04-06 03:25:40.645
cmnmmqulb0001la04l928w2m1	cmnighgle0004u718dt5i4clk	sports	Striker	A few times a month	Watching and discussing matches	Street football energy	Compete in tournaments	2026-04-06 03:27:43.967	2026-04-06 03:27:43.967
cmnmr0q9a0005l704ephgeupb	cmniz9vbq0001l104p8ubheqo	music	Singer	Indie / alt	Open mics	A few times	Meet collaborators	2026-04-06 05:27:23.375	2026-04-06 05:27:23.375
cmnmrxf950002l704vi1i7sbv	cmnmqs0i40007kz046nr2eh1z	bikers	Long-time rider	Cruiser	Highway distance runs	Solo headspace	Find my riding crew	2026-04-06 05:52:48.761	2026-04-06 05:52:48.761
cmnnh2r070001i204457ubwww	cmnnfgg51000bjs04cq014frr	fitness	Beginner	Running / cardio	Feel healthier	Daily if needed	Want coaching and structure	2026-04-06 17:36:47.672	2026-04-06 17:36:47.672
cmnkc54op0001l404fxtf7v7q	cmnipa7et0000lb04ns1hjdoj	sports	Defender	Just getting started	Learning proper technique	Champions League prestige	Improve my skills	2026-04-04 12:55:22.105	2026-04-06 06:57:34.597
cmnmxpz0z0001l204vld9jk2o	cmnmsh6mc0006jx04r9obo40g	bikers	Long-time rider	Scooter / city ride	City night loops	Solo headspace	Learn more about biking culture	2026-04-06 08:34:58.835	2026-04-06 08:34:58.835
cmnmy54wz0001kz0419nwqirw	cmnmsh6mc0006jx04r9obo40g	photography	DSLR / mirrorless	Portraits	People	Confident and consistent	Photo walks and peers	2026-04-06 08:46:46.308	2026-04-06 08:46:46.308
cmnmzifkb000ckz04fke2421y	cmnmyhrxj0001kz04o9v2wnsg	bikers	Just getting into it	Sports bike	Highway distance runs	Fast and focused	Discover new routes	2026-04-06 09:25:06.251	2026-04-06 09:25:06.251
cmnllocae0001l504nghal6sw	cmnlll4t00001lb04hfrqrf54	photography	Whatever I can get	Events	Nature	Just experimenting	Paid shoot opportunities	2026-04-05 10:10:01.142	2026-04-06 23:40:48.94
cmnn2r7860001jy04yltzxdb1	cmnmsh6mc0006jx04r9obo40g	fashion	Streetwear	Modeling	Luxury houses	Photoshoots	Find creative collaborators	2026-04-06 10:55:54.198	2026-04-06 10:55:54.198
cmnnilz5g0001l704v5myzxz0	cmnk740dd0000ju04hrjxizbw	sports	Striker	A few times a month	Joining tournaments	Street football energy	Find people to play with regularly	2026-04-06 18:19:44.308	2026-04-06 18:19:44.308
cmnkg1urp0001jv04ij3luoet	cmnk740dd0000ju04hrjxizbw	bikers	Long-time rider	Sports bike	Hill roads at sunrise	Fast and focused	Find my riding crew	2026-04-04 14:44:47.749	2026-04-06 18:20:59.715
cmnnip6zw0005l7041aacbq8b	cmnk740dd0000ju04hrjxizbw	fashion	Minimal and clean	Styling	Luxury houses	Photoshoots	Find creative collaborators	2026-04-06 18:22:14.444	2026-04-06 18:22:14.444
cmnniqowd0007l704yl38x1re	cmnk740dd0000ju04hrjxizbw	photography	DSLR / mirrorless	Street	People	Confident and consistent	Photo walks and peers	2026-04-06 18:23:24.301	2026-04-06 18:23:24.301
cmnohnwtd0001u794wj6ss5mq	cmnmqwwe20001l704fcndlpxw	bikers	Long-time rider	Scooter / city ride	Hill roads at sunrise	Smooth and scenic	Discover new routes	2026-04-07 10:41:01.149	2026-04-07 10:43:57.449
cmnjekyii0001jv04gbxhwie5	cmniglcfn0008u718ymztkf7y	bikers	Weekend regular	Adventure bike	Cafe-hopping day rides	Fast and focused	Learn more about biking culture	2026-04-03 21:15:53.659	2026-04-07 10:02:31.459
cmnohvd3w0003u7rs6n4rhdfr	cmnmqwwe20001l704fcndlpxw	sports	Striker	Just getting started	Booking turf with friends	Local college leagues	Find people to play with regularly	2026-04-07 10:46:48.86	2026-04-07 10:46:48.86
cmnoi90ft0001l40466nnhgto	cmnmzipoo000ekz043lnx7r1j	sports	Striker	Just getting started	Watching and discussing matches	Champions League prestige	Improve my skills	2026-04-07 10:57:25.625	2026-04-07 10:57:25.625
cmnopngst0003la044i892doz	cmno5uxkf0000lj058iik9dy5	sports	Striker	A few times a month	Watching and discussing matches	Street football energy	Just enjoy the community	2026-04-07 14:24:37.325	2026-04-07 14:24:37.325
cmnopnyrf0007la04tz8bjtg9	cmno5uxkf0000lj058iik9dy5	bikers	Long-time rider	Scooter / city ride	City night loops	Group pack energy	Find my riding crew	2026-04-07 14:25:00.603	2026-04-07 14:25:00.603
cmnoprn1f000nla04qpz5jzqf	cmnopnwl80005la041arwkbo9	fashion	Minimal and clean	Modeling	Campus-born brands	Runway / showcase nights	Find creative collaborators	2026-04-07 14:27:51.959	2026-04-07 14:27:51.959
cmnpsjatz0006js04fzknf6j2	cmnpsgjg80000js040sr75m8v	bikers	Weekend regular	Scooter / city ride	Hill roads at sunrise	Group pack energy	Join organized rides	2026-04-08 08:33:07.992	2026-04-08 08:33:07.992
cmnjaqp4q0001u7awxjplotl9	cmniglcfn0008u718ymztkf7y	sports	Midfielder	Every weekend	Learning proper technique	Local college leagues	Compete in tournaments	2026-04-03 19:28:22.957	2026-04-08 09:30:14.704
cmnr0cyhz0001l204lxfvbloc	seed-admin-occ-staff	photography	DSLR / mirrorless	Street	Architecture	Learning quickly	Photo walks and peers	2026-04-09 04:59:55.175	2026-04-09 04:59:55.175
cmnr1j1270010ml07zydrhkoi	cmnr1fi6j0001jy049arsk7ww	bikers	Occasional explorer	Sports bike	Hill roads at sunrise	Fast and focused	Learn more about biking culture	2026-04-09 05:32:38.047	2026-04-09 05:32:38.047
cmnr1jt9j001eml070eb2zlqe	cmnr1fm7m0003jy04wmfy0e21	music	Just here for the vibe	Indie / alt	Big live sets	A few times	Explore new sounds	2026-04-09 05:33:14.599	2026-04-09 05:33:14.599
cmnr1ix86000uml072lnyd4nl	cmnr1hca90000mv087ypf1y9s	photography	DSLR / mirrorless	Events	People	Confident and consistent	Paid shoot opportunities	2026-04-09 05:32:33.078	2026-04-09 05:33:56.933
cmnr1ksas0010lf04pjlnpjcq	cmnr1ie0h000qjy0401r352by	music	Just here for the vibe	Indie / alt	Big live sets	Performed a lot	Perform live	2026-04-09 05:34:00.004	2026-04-09 05:34:00.004
cmnr1lheq0014lf04m0of6ypw	cmnr1h5f50000ml07toh9dkss	bikers	Weekend regular	Sports bike	Hill roads at sunrise	Fast and focused	Find my riding crew	2026-04-09 05:34:32.546	2026-04-09 05:34:32.546
cmnr1nj8y0004l104nqwjruzm	cmnmqs0i40007kz046nr2eh1z	fashion	Minimal and clean	Designing	Luxury houses	Photoshoots	Find creative collaborators	2026-04-09 05:36:08.243	2026-04-09 05:36:08.243
cmnr2595m0001l504zbk0x9t8	cmnr1fsfb0005jy04tb0ysg5o	fitness	Beginner	Strength training	Build discipline	2-3 sessions	Want coaching and structure	2026-04-09 05:49:54.971	2026-04-09 05:49:54.971
cmnr27j0g000ekv043f6ci6vg	cmnr1fsfb0005jy04tb0ysg5o	bikers	Weekend regular	Scooter / city ride	Hill roads at sunrise	Group pack energy	Discover new routes	2026-04-09 05:51:41.057	2026-04-09 05:51:41.057
cmnr7n2x90003l1041nwk7rfl	cmnr7gjjt0000l504xt5yrtt4	music	Singer	Indie / alt	Open mics	Performed a lot	Perform live	2026-04-09 08:23:44.781	2026-04-09 08:23:44.781
cmnrcf3gy0001u73gap7peiao	seed-admin-occ-staff	fitness	Beginner	Running / cardio	Feel healthier	2-3 sessions	Want coaching and structure	2026-04-09 10:37:30.32	2026-04-09 10:37:30.32
cmnsfkygv0003lj04axn24e9w	cmno9keux0000lb047w1faixt	bikers	Long-time rider	Cruiser	City night loops	Fast and focused	Discover new routes	2026-04-10 04:53:48.799	2026-04-10 04:53:48.799
cmnsfr2el000hla04ya6qxx2j	cmno9keux0000lb047w1faixt	music	Just here for the vibe	Indie / alt	Big live sets	A few times	Explore new sounds	2026-04-10 04:58:33.837	2026-04-10 04:59:04.733
cmnsjvh360008ld041sw3buv3	cmnsjsj6n0002ld04t8g9de6h	sports	Striker	A few times a month	Joining tournaments	Champions League prestige	Find people to play with regularly	2026-04-10 06:53:57.954	2026-04-10 06:53:57.954
cmnsjz0o5000bl504j762xogw	cmnsjv78t0007l504ovfxds6h	bikers	Occasional explorer	Sports bike	City night loops	Fast and focused	Find my riding crew	2026-04-10 06:56:43.302	2026-04-10 06:56:43.302
cmnsjzu6a000dl504qm7dbrjs	cmnsjv78t0007l504ovfxds6h	fitness	Getting consistent	Strength training	Get stronger	Daily if needed	Want a workout crew	2026-04-10 06:57:21.539	2026-04-10 06:57:21.539
cmnsoxeg60001kw04vjghd1qr	cmnmsducp0005jx04fw0rzjdb	music	Instrumentalist	Electronic / experimental	Studio sessions	Performed a lot	Explore new sounds	2026-04-10 09:15:25.926	2026-04-10 09:15:25.926
cmnsfzrl70005lj04pa214li8	cmno9keux0000lb047w1faixt	fitness	Getting consistent	Strength training	Build discipline	2-3 sessions	Want a workout crew	2026-04-10 05:05:19.724	2026-04-10 10:45:04.806
cmnsfuenh000bu7zkwrjj3owf	cmno6dlbj0000i5048wzcgi92	music	Instrumentalist	Pop / acoustic	Small jam circles	Performed a lot	Explore new sounds	2026-04-10 05:01:09.677	2026-04-10 10:49:05.809
cmnssarp60003u79wda23l7qh	cmno6dlbj0000i5048wzcgi92	fitness	Getting consistent	Yoga / mobility	Get stronger	4-5 sessions	Love challenges	2026-04-10 10:49:48.474	2026-04-10 11:10:11.711
cmnsu36ce0001ju043glfchjj	cmno9keux0000lb047w1faixt	photography	DSLR / mirrorless	Portraits	People	Mostly editing so far	Photo walks and peers	2026-04-10 11:39:53.438	2026-04-10 11:39:53.438
\.


--
-- Data for Name: clubs; Type: TABLE DATA; Schema: public; Owner: occ_4t52_user
--

COPY public.clubs (id, slug, name, icon, description, theme, "coverImage", "memberCount", "createdAt", "headerId", "postingFrozen", "memberDisplayBase") FROM stdin;
club-fitness	fitness	Fitness	💪	Group workouts, nutrition, challenges.	charcoal	\N	13	2026-04-03 05:10:36.73	\N	f	573
club-bikers	bikers	Bikers	🏍	Weekend rides, bike checks, mountain roads.	amber	\N	19	2026-04-03 05:10:29.303	cmnr4ki2a000iu79katbp2k6m	f	364
club-sports	sports	Sports Football	⚽	Tournaments, turf bookings, weekly matches.	green	\N	9	2026-04-03 05:10:34.303	cmnr3197o0001l804imwja3wr	f	473
cmnlqr8sa0001u7xklay1hj3b	gaming-club	Gaming Club	🎮	Organize gaming tournaments, LAN parties, and esports events across popular gaming titles and genres, providing members with opportunities to compete, showcase their skills, and connect with fellow gamers.\nBGMI\nE-FOOTBALL\nFree-Fire	purple	https://res.cloudinary.com/dbu9z9ija/image/upload/v1775392268/occ/clubs/lm5skc0th2hdjb91ikf1.png	58	2026-04-05 12:32:14.651	cmnmqwwe20001l704fcndlpxw	f	169
club-fashion	fashion	Fashion	👗	Showcases, brand deals, styling.	rose	\N	12	2026-04-03 05:10:37.974	\N	f	365
club-photography	photography	Photography	📷	Photo walks, exhibitions, paid shoots.	blue	\N	10	2026-04-03 05:10:35.477	cmnrfylea0001l7041s6sx8le	f	701
club-music	music	Music	🎵	Open mics, studio sessions, collabs.	purple	\N	16	2026-04-03 05:10:32.199	\N	f	449
\.


--
-- Data for Name: comment_reports; Type: TABLE DATA; Schema: public; Owner: occ_4t52_user
--

COPY public.comment_reports (id, "commentId", "reporterId", reason, "createdAt") FROM stdin;
\.


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: occ_4t52_user
--

COPY public.comments (id, "postId", "userId", content, "createdAt") FROM stdin;
cmnmub2lg000fl404r7sffoas	cmnlsmkpb000bu7xk3khubpdy	cmnipa7et0000lb04ns1hjdoj	great	2026-04-06 06:59:24.772
cmnmuba14000hl404w06rjo21	cmnlsmkpb000bu7xk3khubpdy	cmnipa7et0000lb04ns1hjdoj	great	2026-04-06 06:59:34.408
cmnn5ah0g000bjp046fb22lm7	cmnlsmkpb000bu7xk3khubpdy	cmnivjy4f0003l104y9t3rceb	nice	2026-04-06 12:06:52.576
cmnserzmx0005jv048pyb0lss	cmnr4rwrr000ou79kk71liflm	cmno9keux0000lb047w1faixt	hi	2026-04-10 04:31:17.29
cmnsevs3c000bjv04ek8rxlt5	cmnr4owgx000mu79kkf3dmz1k	cmno9keux0000lb047w1faixt	hiii	2026-04-10 04:34:14.137
cmnsew79b000fjv0483kjman9	cmnlsmkpb000bu7xk3khubpdy	cmno9keux0000lb047w1faixt	cool	2026-04-10 04:34:33.792
cmnsru60k0009kz04o1ebci83	cmnpqapeg0007u7bw644b9ebw	cmno9keux0000lb047w1faixt	hi	2026-04-10 10:36:53.876
\.


--
-- Data for Name: email_otp_tokens; Type: TABLE DATA; Schema: public; Owner: occ_4t52_user
--

COPY public.email_otp_tokens (id, email, purpose, "codeHash", "attemptsLeft", "expiresAt", "usedAt", "createdAt") FROM stdin;
cmnigf11v0002u7189druyilb	spherefulltos@gmail.com	REGISTER	4a4fdd655e9eed193f90692e2f3c537440199bde51f4159ea8d922499d26a3e5	5	2026-04-03 05:29:30.066	2026-04-03 05:24:25.216	2026-04-03 05:19:30.067
cmnigm3ch000fu718wow1y5lq	spherefulltos@gmail.com	REGISTER	16365530720566297a9363177c19e0633d3b8198615be389c311584a82d9457c	5	2026-04-03 05:34:59.631	\N	2026-04-03 05:24:59.634
cmnip9uk80000ju04m5izrz70	timavicii925@gmail.com	REGISTER	ce4f9c95c56479f44f07a40d31b530d42ee8bb762af4f34750c43c1412a8a5c5	5	2026-04-03 09:37:24.92	2026-04-03 09:27:41.729	2026-04-03 09:27:24.921
cmnirb2ll0000ik04rho7pb23	subramanyavdj@gmail.com	REGISTER	b60b97523cafb1c3ce11a6b37ee09ff199ae76ca5ffa6be24ff2f55e57b6d20b	5	2026-04-03 10:34:21.224	2026-04-03 10:25:23.488	2026-04-03 10:24:21.225
cmniuh8pu0000kw04plk8wye6	suhaskrishna749@gmail.com	REGISTER	e84986b6971742d203997db98d63f811f04fb796a0477bd9cc1a6b6bef0ad712	5	2026-04-03 12:03:07.938	\N	2026-04-03 11:53:07.939
cmnivdvr40000l104a4hvpcdf	rithviknair10@gmail.com	REGISTER	3fc1ae40967c61c51880e2d043ff4d76d0b7f556f85112c6011cb5047c7b5e2e	5	2026-04-03 12:28:30.783	2026-04-03 12:19:32.853	2026-04-03 12:18:30.784
cmnivj0160002l104fb32hknn	vasudhanagesh.16@gmail.com	REGISTER	7919c711d01e902e81b0e743f9b69d6e57f2bc9e0c7c78095140491899b9db3e	5	2026-04-03 12:32:29.609	2026-04-03 12:23:13.945	2026-04-03 12:22:29.61
cmnjyh6520005l504uk2mhzj4	suhaskrishna749@gmail.com	REGISTER	a5048a22da775bb101f2d28b98d60c6b67c72f4c9cecf9cf7102d1386932e222	5	2026-04-04 06:42:49.237	2026-04-04 06:40:12.248	2026-04-04 06:32:49.238
cmnk72w1b0000l1045zu8unqo	fazil80883@gmail.com	REGISTER	19ecf64290a50a254b7cff4c72f37c30ba197bef36567425bbaefff6488fa94d	5	2026-04-04 10:43:39.502	2026-04-04 10:34:31.931	2026-04-04 10:33:39.504
cmnk84idt0001kz04v4ronuio	kmaninishanth@gmail.com	REGISTER	07ef7f1f233cbdc7b008547adc44ef68cef24c84ce52efbbe20530f54449fbbb	5	2026-04-04 11:12:54.736	\N	2026-04-04 11:02:54.737
cmnkk7c720002la042fmpxba7	anaghagrao07@gmail.com	REGISTER	cf3f80ee8d0aa3e37f18bfac8d95e183d40820a3a7b1dbe91db9b1fc8f18e7b6	5	2026-04-04 16:51:02.078	2026-04-04 16:41:50.176	2026-04-04 16:41:02.079
cmnllhftz0000lb04zj7ukvij	itzsriharishetty@gmail.com	REGISTER	b830a88e101608a24840634c066b04bd8053983591ff8754f0eedf4ba1d8936e	5	2026-04-05 10:14:39.143	2026-04-05 10:07:31.628	2026-04-05 10:04:39.144
cmnmqqpjt0006kz04h921q5kv	princeelvin04@gmail.com	REGISTER	0a8d10d3efbd4bc4fb92bde246e988a87ab9d4efaaf6381c2c526a01573e246c	5	2026-04-06 05:29:35.896	2026-04-06 05:20:36.902	2026-04-06 05:19:35.897
cmnn2xbxw0002jp04uankl6w1	sharvanisubramanya@gmail.com	REGISTER	002ea2d6fdee10d3f954f6173303e498284e0ac3bd0ba09a5c4aa7e684cd4559	5	2026-04-06 11:10:40.243	2026-04-06 11:02:17.633	2026-04-06 11:00:40.244
cmnnd65wy000ala04io6mm4a3	prajwalnb024@gmail.com	REGISTER	5ecb98bf5c054fc633122b053135fedd35c7e091a6900503beecb11742ef4f7b	5	2026-04-06 15:57:28.498	2026-04-06 15:50:22.406	2026-04-06 15:47:28.498
cmnnf731m0000js04h9lc689o	mahesha0416@gmail.com	REGISTER	4073e12631c9a7c738c03e7f9b70fabbaacab95ae5e4bae987ca9862c32bdc7a	5	2026-04-06 16:54:10.665	2026-04-06 16:45:28.603	2026-04-06 16:44:10.666
cmnnf8exx0001js04g5uzq4tl	anirudhcgowda@gmail.com	REGISTER	665d1e078247363925ea9a5c3f122f4bd384079bd7830659e3678af3abec06bb	5	2026-04-06 16:55:12.741	2026-04-06 16:46:40.806	2026-04-06 16:45:12.742
cmnnfbxdo0008js04pp87dvh1	harshavardhanreddylokireddy@gmail.com	REGISTER	98b356a675eb749432f1baeafe8296e8e673283cba907f5147156133a5411ab9	5	2026-04-06 16:57:56.604	2026-04-06 16:49:12.278	2026-04-06 16:47:56.605
cmno9azet0000jr04ep55lb4p	akash22605.n@gmail.com	REGISTER	5044af488e2f39fd66150b6f6e9ed14698fbc5a0d4d61ee126a77a43e7f26441	5	2026-04-07 06:57:01.061	\N	2026-04-07 06:47:01.062
cmno9bnsh0000l204myvn0qdi	sevanth8377@gmail.com	REGISTER	0b86c7c59e32f29fd88ba31597edd35956dd1d4b04706d7485e938d76b623006	5	2026-04-07 06:57:32.657	2026-04-07 06:48:37.455	2026-04-07 06:47:32.658
cmnol09bl0005jx04cy6ti3j2	deenraj040@gmail.com	REGISTER	a22b842415768e669cf5b9c9f47881a66f79a5227ca4bca475569522872657c1	5	2026-04-07 12:24:36.08	\N	2026-04-07 12:14:36.081
cmnomqdaz0000l204ipo1esul	hemavathib1616@gmail.com	REGISTER	6c6171c0ef414bea6c8b308c9ef1629d3a1d1848bd1e74ca341b6aa818d74485	5	2026-04-07 13:12:53.914	\N	2026-04-07 13:02:53.915
cmnopjeyh0000l204orwv72a2	njnanesh59@gmail.com	REGISTER	32a17b4915fd9f77649bb5c02ffcbc4fb60496fd77e63d85a33959a76170734c	5	2026-04-07 14:31:28.312	\N	2026-04-07 14:21:28.313
cmnopkr6c0002l204lajmbzd3	shrinayak06@gmail.com	REGISTER	b8e4ba619e467baa72e98707726bffd3fbe7e1fff56ebea8266ef07825770676	5	2026-04-07 14:32:30.803	\N	2026-04-07 14:22:30.804
cmnopxnwi000wla04kqqnua7a	abhishek.leo2006@gmail.com	REGISTER	3c3ae826fc565860ef05cf29667b055ceccdd2dc490c48f0c42d6fc008aba36d	5	2026-04-07 14:42:33.09	2026-04-07 14:32:57.299	2026-04-07 14:32:33.091
cmnoqgxzc001qla049e9fhne0	skroshanali62@gmail.com	REGISTER	fa3cf29acdb727c8f10922018ce68ac3e746984234d6ff8c57b8d512700edd04	5	2026-04-07 14:57:32.616	\N	2026-04-07 14:47:32.617
cmnpmtuda0007i804vino7jxf	madeehaparveen0@gmail.com	REGISTER	ad2694a1074082f517f3463b7b87ae9f699c625bfc39ab9c8dce96f6c48bbed8	5	2026-04-08 06:03:22.173	2026-04-08 05:53:42.107	2026-04-08 05:53:22.174
cmnpmu9ye000ai8048sd0vj58	pyed7f@gmail.com	REGISTER	e064b6e1657a823ff724388b88ea55f06f9f2a6f9bf7536bcd1d066ac962a013	5	2026-04-08 06:03:42.374	\N	2026-04-08 05:53:42.375
cmnpmt2zr0002i804bmcrz2qc	ss9097542@gmail.com	REGISTER	ddd4a58ae6c2156bf5123ea604f62582d7f65055de284c10bdf192f403c1b259	5	2026-04-08 06:02:46.695	2026-04-08 05:54:08.428	2026-04-08 05:52:46.696
cmnpms7d40000i8041fb2rvhq	mishasimra09@gmail.com	REGISTER	375b37f82dec628a2e2303a63d2087a0d7e455127317819b1c2c8ff56af69f1d	5	2026-04-08 06:02:05.703	2026-04-08 05:54:27.668	2026-04-08 05:52:05.704
cmnpmsmhm0001i8049yiit0cr	bnn86031@gmail.com	REGISTER	b637a8691d1eed0d0dc5b52da86de2ce659e50f93f7f2a84a66a75a0d2f581ea	5	2026-04-08 06:02:25.306	2026-04-08 05:54:28.011	2026-04-08 05:52:25.306
cmnpmtz110008i804j5nnc73s	apoorvab889@gmail.com	REGISTER	7f1cb1111eb52c7726a518cb74d6c2799084f713c723384cd6281797059c38fa	5	2026-04-08 06:03:28.212	2026-04-08 05:54:54.978	2026-04-08 05:53:28.213
cmnpmt9v30005i804p1m15zux	zaharakouser7@gmail.com	REGISTER	712056b257465f2a965cde73c4734e9c1ba695c526d98856d79b44f48decea10	5	2026-04-08 06:02:55.599	2026-04-08 05:55:22.208	2026-04-08 05:52:55.6
cmnpmua3w000bi804j6v2mff0	sudhankumarg763@gmail.com	REGISTER	518b1aaf9b53ab99901cb126050afe3a395879dc382176819238077a510c3699	5	2026-04-08 06:03:42.572	2026-04-08 05:55:22.961	2026-04-08 05:53:42.573
cmnpmt83n0003i804w9fhku2m	shwethashanthappa1803@gmail.com	REGISTER	adc46eed26581e224e0cecc0273560576bfc0a415e970e0bd5ea86c1e078b1c6	5	2026-04-08 06:02:53.315	2026-04-08 05:55:47.811	2026-04-08 05:52:53.316
cmnpmx14c0008l204270dkgoi	vdileep036@gmail.com	REGISTER	bbbd657fd50360a6608e010d6b830bad4c6eb993ef162b959dd712642f41cee6	5	2026-04-08 06:05:50.892	2026-04-08 05:56:12.961	2026-04-08 05:55:50.893
cmnpz0tf60000ju04q6m65ec4	ppks15176@gmail.com	REGISTER	93761205c6431e2fb975f1123e88ff86b186470f91919eab13093e894d521caf	5	2026-04-08 11:44:42.93	2026-04-08 11:35:42.994	2026-04-08 11:34:42.931
cmnpn6ars000jl204qbfv1fbk	meghashreev86@gmail.com	REGISTER	e260ab7e7281e75224b05100594b2937598cade182a62befec436424918f2573	5	2026-04-08 06:13:03.303	2026-04-08 06:04:12.731	2026-04-08 06:03:03.304
cmnr19ybi0000u79kszmms81h	occ-staff-r8k2@occ-local.dev	ADMIN_LOGIN	a0eb15310683de23ab2f3fd3e8b6c61fd7cf77d9aa2f3d404549f73d860fba09	5	2026-04-09 05:35:34.589	\N	2026-04-09 05:25:34.591
cmnr1hg4k0005ml07hzu2b5f4	joshnavis62@gmail.com	REGISTER	0aecc75d9fe256be6bbf23d8a9be5bc32a2cd05f0b153b5ca6a88a87f1701723	5	2026-04-09 05:41:24.259	\N	2026-04-09 05:31:24.26
cmnr1if74000ilf04yzzt0yxw	devileye278@gmail.com	REGISTER	68991877bc0605cbca207071ffea738308ca78351504554988e51e53ce31c0f3	5	2026-04-09 05:42:09.712	\N	2026-04-09 05:32:09.713
cmnr1g8l6000ajy04v026diof	ramya2022ram16@gmail.com	REGISTER	9a8977a083fd3c80ced4ef0a19fcb1490aa8781b45e3337c86b7691f9aade35f	5	2026-04-09 05:40:27.834	2026-04-09 05:32:13.394	2026-04-09 05:30:27.834
cmnr1jowf0019ml07qxozkudw	thrishamadhu21@gmail.com	REGISTER	2cc58e13149bcf707c9d9a3553afca78a074a5309716f886492fc3f70b781454	5	2026-04-09 05:43:08.942	\N	2026-04-09 05:33:08.943
cmnr1knem001iml0786x31o4e	rashmi.ts600@gmail.com	REGISTER	edd9ae3bc1d71b4c63055585ea3b41d49281702dadb48863afc3476692c292dc	5	2026-04-09 05:43:53.662	2026-04-09 05:35:30.728	2026-04-09 05:33:53.663
cmnr2761l000akv04tqvls13p	thrishamadhu21@gmail.com	REGISTER	a056d7d7cb667e3547fb478f10a0588cb0f746ec6e3fe196b5f805a035adef16	5	2026-04-09 06:01:24.249	2026-04-09 05:54:22.183	2026-04-09 05:51:24.25
cmnshc2vq002ola04uga3yn4m	pm9812325@gmail.com	REGISTER	7fbde20879f8004576232651b085309fe69ad6b10d4fb5ad20e147edd65d893a	5	2026-04-10 05:52:53.845	\N	2026-04-10 05:42:53.846
cmnsj3npw0004jr04dc90ygju	chethankumar0928@gmail.com	REGISTER	0c89852543b4241fe3b4a7224c02a8495f07d314826605a6e3918846be70af25	5	2026-04-10 06:42:20.179	\N	2026-04-10 06:32:20.18
cmnsjabfl0001l504s5mlv8p5	pm9812325@gmail.com	REGISTER	0bbabceb3ab6cb793360da01e65f15df0e63553f5c80ef89368c704bb092433d	4	2026-04-10 06:47:30.849	\N	2026-04-10 06:37:30.849
cmnsjrgo60000ld04dbqs8jvb	snehavinodan18@gmail.com	REGISTER	590fe069df3a197579b1863aad94f7ba2155b5312925c159cd1e2334374c2507	5	2026-04-10 07:00:50.79	\N	2026-04-10 06:50:50.791
cmnsl0wl50016u7dsm6qk2zc6	spherefulltos@gmail.com	RESET_PASSWORD	e0157e620af41976afea528652928bb5216e34541dde38d87b45c903f9ee9734	5	2026-04-10 07:36:10.935	2026-04-10 07:27:12.96	2026-04-10 07:26:10.937
cmnspqpks0000l5044nnurdy2	testuser123@example.com	REGISTER	764de84ddb4e5805a74a8016eb35ffbf67c519a39d4e7c35a2b9632caa492146	5	2026-04-10 09:48:13.372	\N	2026-04-10 09:38:13.373
\.


--
-- Data for Name: event_registrations; Type: TABLE DATA; Schema: public; Owner: occ_4t52_user
--

COPY public.event_registrations (id, "userId", "eventId", status, "createdAt") FROM stdin;
cmnmtzvln0007l404xs7k29sa	cmnipa7et0000lb04ns1hjdoj	cmnlo0a45002nu7g8cojpqbzf	registered	2026-04-06 06:50:42.491
cmnmu8c8p0009l404f2pigtga	cmnipa7et0000lb04ns1hjdoj	cmnlnzy6z000ru7g8r878kjsz	registered	2026-04-06 06:57:17.305
cmno76it00005l7041iejyro1	cmnka6bjp0000kv047w26c7j8	cmnlo0a45002nu7g8cojpqbzf	registered	2026-04-07 05:47:33.684
cmnokswso0002jx0478rslaet	cmnk740dd0000ju04hrjxizbw	cmnlo010e0018u7g85szi4ris	registered	2026-04-07 12:08:53.256
cmnr1jjpc000xlf04fq16fi6p	cmnr1h5f50000ml07toh9dkss	cmnlo045r001pu7g8nw35bruo	registered	2026-04-09 05:33:02.208
cmnr7iesf0002l5047g6p04ar	cmnr7gjjt0000l504xt5yrtt4	cmnlnzuvc000au7g8fffd6vq7	registered	2026-04-09 08:20:06.879
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: occ_4t52_user
--

COPY public.events (id, "clubId", title, description, date, venue, price, "maxCapacity", "imageUrl", "createdAt") FROM stdin;
seed-bikers-dawn-ride	club-bikers	Dawn Ride To Nandi	Sunrise loop, breakfast stop, and route film drops.	2026-04-07 05:10:40.156	Hebbal Meet Point	399	\N	https://images.unsplash.com/photo-1558981806-ec527fa84c39?auto=format&fit=crop&w=1200&q=80	2026-04-03 05:10:40.175
seed-photo-nightwalk	club-photography	Night Walk Photo Jam	Golden-hour portraits and low-light city frames.	2026-04-09 05:10:43.08	Church Street	199	\N	https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&w=1200&q=80	2026-04-03 05:10:43.082
cmnlo010e0018u7g85szi4ris	club-fashion	Fashion Meetup 2026 Part 1	Join us for an exclusive gathering of Fashion members.	2026-04-12 11:15:05.628	Main Campus Auditorium	0	100	/events/fashion-event.png	2026-04-05 11:15:05.63
cmnlo0176001au7g8fdv9bmiv	club-fashion	Fashion Meetup 2026 Part 2	Join us for an exclusive gathering of Fashion members.	2026-04-19 11:15:05.873	Main Campus Auditorium	0	100	/events/fashion-event.png	2026-04-05 11:15:05.875
cmnlnzuvc000au7g8fffd6vq7	club-music	Music Meetup 2026 Part 1	Join us for an exclusive gathering of Music members.	2026-04-12 11:14:57.662	Main Campus Auditorium	0	100	/events/music-event.png	2026-04-05 11:14:57.672
cmnlnzv8q000cu7g83ev713i9	club-music	Music Meetup 2026 Part 2	Join us for an exclusive gathering of Music members.	2026-04-19 11:14:58.153	Main Campus Auditorium	0	100	/events/music-event.png	2026-04-05 11:14:58.155
cmnlnzy6z000ru7g8r878kjsz	club-sports	Sports Football Meetup 2026 Part 1	Join us for an exclusive gathering of Sports Football members.	2026-04-12 11:15:01.977	Main Campus Auditorium	0	100	/events/music-event.png	2026-04-05 11:15:01.979
cmnlnzyd0000tu7g8azcgbqnb	club-sports	Sports Football Meetup 2026 Part 2	Join us for an exclusive gathering of Sports Football members.	2026-04-19 11:15:02.194	Main Campus Auditorium	0	100	/events/music-event.png	2026-04-05 11:15:02.196
cmnlo045r001pu7g8nw35bruo	club-bikers	Bikers Meetup 2026 Part 1	Join us for an exclusive gathering of Bikers members.	2026-04-12 11:15:09.709	Main Campus Auditorium	0	100	/events/music-event.png	2026-04-05 11:15:09.711
cmnlo04c0001ru7g8g95bvl2q	club-bikers	Bikers Meetup 2026 Part 2	Join us for an exclusive gathering of Bikers members.	2026-04-19 11:15:09.933	Main Campus Auditorium	0	100	/events/music-event.png	2026-04-05 11:15:09.936
cmnlo074c0026u7g8gb197v0b	club-photography	Photography Meetup 2026 Part 1	Join us for an exclusive gathering of Photography members.	2026-04-12 11:15:13.546	Main Campus Auditorium	0	100	/events/music-event.png	2026-04-05 11:15:13.549
cmnlo07bl0028u7g8ab645k6u	club-photography	Photography Meetup 2026 Part 2	Join us for an exclusive gathering of Photography members.	2026-04-19 11:15:13.806	Main Campus Auditorium	0	100	/events/music-event.png	2026-04-05 11:15:13.809
cmnlo0a45002nu7g8cojpqbzf	club-fitness	Fitness Meetup 2026 Part 1	Join us for an exclusive gathering of Fitness members.	2026-04-12 11:15:17.426	Main Campus Auditorium	0	100	/events/music-event.png	2026-04-05 11:15:17.429
cmnlo0aaf002pu7g83iugsm2v	club-fitness	Fitness Meetup 2026 Part 2	Join us for an exclusive gathering of Fitness members.	2026-04-19 11:15:17.653	Main Campus Auditorium	0	100	/events/music-event.png	2026-04-05 11:15:17.655
\.


--
-- Data for Name: follows; Type: TABLE DATA; Schema: public; Owner: occ_4t52_user
--

COPY public.follows (id, "followerId", "followingId", "createdAt") FROM stdin;
\.


--
-- Data for Name: gig_applications; Type: TABLE DATA; Schema: public; Owner: occ_4t52_user
--

COPY public.gig_applications (id, "userId", "gigId", status, "createdAt", message, "applicantEmail", "applicantName", "applicantPhone", "submissionFileMime", "submissionFileName", "submissionFileSize", "submissionFileUrl", "workDescription") FROM stdin;
cmnj9ogn40009u7swbswyxg1s	cmniglcfn0008u718ymztkf7y	cmnj9ne9q0005u7swx25d3l95	PENDING	2026-04-03 18:58:39.04	\N	\N	\N	\N	\N	\N	\N	\N	\N
cmnk9x0y3000hjo04y29kkrjc	cmnipa7et0000lb04ns1hjdoj	cmnj9ne9q0005u7swx25d3l95	PENDING	2026-04-04 11:53:04.779	ih	timavicii925@gmail.com	Shikhar	7458072713	\N	\N	\N	\N	\N
cmnlzmgsv0005u73s72xlfzcb	cmniglcfn0008u718ymztkf7y	cmnlyx8is0001u73sic6caqsu	APPROVED	2026-04-05 16:40:28.301	\N	spherefulltos@gmail.com	Test	8234292022	\N	\N	\N	\N	\N
cmnmtyij60001l404x2smv8nv	cmnipa7et0000lb04ns1hjdoj	cmnlyx8is0001u73sic6caqsu	PENDING	2026-04-06 06:49:38.899	I am Interested in this	timavicii925@gmail.com	Shikhar	7458072713	\N	\N	\N	\N	\N
cmnn5of0y0001ju04v78ti5il	cmnivjy4f0003l104y9t3rceb	cmnj9ne9q0005u7swx25d3l95	PENDING	2026-04-06 12:17:43.186	\N	vasudhanagesh.16@gmail.com	Vasudha Nagesh	6186257525	\N	\N	\N	\N	\N
cmnomuaov0001l504l0gihklu	cmnk740dd0000ju04hrjxizbw	cmnlyx8is0001u73sic6caqsu	PENDING	2026-04-07 13:05:57.152	\N	fazil80883@gmail.com	fazil	6586023109	\N	\N	\N	\N	\N
cmnoppi30000fla04986lamcq	cmnopnwl80005la041arwkbo9	cmnlyx8is0001u73sic6caqsu	PENDING	2026-04-07 14:26:12.3	\N	masaladose9501@gmail.com	Masala Dose	7071829186	\N	\N	\N	\N	\N
cmnr4t8dk0001ie047ax18cq3	cmnr3rnh90000jr04dtouk34f	cmnlyx8is0001u73sic6caqsu	PENDING	2026-04-09 07:04:32.936	Where style meets confidence	joshnavis62@gmail.com	Joshnavi S	9353745935	\N	\N	\N	\N	Along with participating in college shows, I’ve built my passion for styling and trends, and I aim to contribute by bringing creative outfit ideas and confidence to the club.
cmnsfpui50009la04fq6u8go2	cmno9keux0000lb047w1faixt	cmnj9ne9q0005u7swx25d3l95	PENDING	2026-04-10 04:57:36.941	wefrgthyjmunb	jishnunreddy@gmail.com	jishnu n	6016275519	\N	\N	\N	\N	efwrthyjukgtdfsa
cmnsfp9ek0001la042ejaun56	cmno9keux0000lb047w1faixt	cmnlyx8is0001u73sic6caqsu	APPROVED	2026-04-10 04:57:09.596	wergthyjm	jishnunreddy@gmail.com	jishnu n	6016275519	\N	\N	\N	\N	eqwrgthyjuytr54ewhg
cmnsj6mfp000lu7dsim4n2zsu	cmno6dlbj0000i5048wzcgi92	cmnlyx8is0001u73sic6caqsu	APPROVED	2026-04-10 06:34:38.485	Im a Content Creator + Dev	suryas.sec.official@gmail.com	Surya	8346075183	application/pdf	Hyperlinks Content.pdf	125709	https://res.cloudinary.com/dbu9z9ija/image/upload/v1775804143/occ/gig-submissions/kb6rvxmoxrxdb8w927a0.pdf	I have done the work .. th Reel Shots i will uplaod in gdrive and put it inside a PDF
\.


--
-- Data for Name: gigs; Type: TABLE DATA; Schema: public; Owner: occ_4t52_user
--

COPY public.gigs (id, title, description, "payMin", "payMax", "clubId", deadline, "createdAt", "postedById") FROM stdin;
seed-gig-photo-reel-cut	Event Photography Reel Cut	Edit a 30-second vertical reel from the latest club drop.	2500	4500	\N	2026-04-12 05:10:44.248	2026-04-03 05:10:44.25	\N
seed-gig-ride-poster-pack	Weekend Ride Poster Pack	Design social posters and ticket teasers for a city ride.	1800	3200	\N	2026-04-15 05:10:44.248	2026-04-03 05:10:44.25	\N
cmnj9ne9q0005u7swx25d3l95	Event Photographer	An event photographer documents gatherings like conferences, parties, and weddings by capturing candid moments, key highlights, and atmospheric details. They specialize in telling a visual story through high-quality images, balancing technical skills in lighting and composition with the ability to work quickly and unobtrusively to document, Edit, and deliver memorable photos.	500	2000	club-bikers	2026-05-12 05:30:00	2026-04-03 18:57:49.31	cmnighgle0004u718dt5i4clk
cmnlyx8is0001u73sic6caqsu	Opportunity for Fashion Content Creators	Love creating reels, outfit transitions, or aesthetic fashion content?\nRequirements:\nConsistent posting\nStrong visual sense\nTrend awareness\nGrow your audience with us.	800	1999	club-fashion	2026-04-30 19:50:00	2026-04-05 16:20:51.17	cmnlp7mo10005u7qokf9h26km
\.


--
-- Data for Name: moderation_tickets; Type: TABLE DATA; Schema: public; Owner: occ_4t52_user
--

COPY public.moderation_tickets (id, "resourceType", "resourceId", status, "assigneeId", "dueAt", notes, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: occ_4t52_user
--

COPY public.notifications (id, "userId", type, title, message, read, data, "createdAt") FROM stdin;
cmnigj2370006u718r7uewulp	cmnighgle0004u718dt5i4clk	approval	Application approved	You are approved. Your referral code is BIKTES6QM5	f	{"referralCode": "BIKTES6QM5"}	2026-04-03 05:22:38.036
cmniglevy000eu718k9cgtn8a	cmnighgle0004u718dt5i4clk	new-referral	New student joined	Test joined using your referral code.	f	{"studentId": "cmniglcfn0008u718ymztkf7y"}	2026-04-03 05:24:27.934
cmnj9nf180007u7swfg3fzl56	seed-admin-occ-staff	gig_created	New gig posted	test posted “Event Photographer” (Bikers).	f	{"gigId": "cmnj9ne9q0005u7swx25d3l95", "clubId": "club-bikers"}	2026-04-03 18:57:50.3
cmnj9ogzd000bu7swqyxp4a5w	cmnighgle0004u718dt5i4clk	gig_apply	New gig application	Test applied to “Event Photographer”	f	{"gigId": "cmnj9ne9q0005u7swx25d3l95", "applicantId": "cmniglcfn0008u718ymztkf7y", "applicationId": "cmnj9ogn40009u7swbswyxg1s"}	2026-04-03 18:58:39.482
cmnj9ohni000du7swg8nzijx1	seed-admin-occ-staff	gig_apply	Gig application submitted	Test applied to “Event Photographer”.	f	{"gigId": "cmnj9ne9q0005u7swx25d3l95", "applicantId": "cmniglcfn0008u718ymztkf7y", "applicationId": "cmnj9ogn40009u7swbswyxg1s"}	2026-04-03 18:58:40.35
cmnjzh02a0003l804i2yknb4x	cmnjzgmo80001l8040r01288w	approval	Application approved	You are approved. Your referral code is BIKSUHXVLR	f	{"referralCode": "BIKSUHXVLR"}	2026-04-04 07:00:40.978
cmnjznpel0007l804w1w3xcw2	cmnjzmhdh0005l8047ijfjuit	approval	Application approved	You are approved. Your referral code is BIKSUHWFQK	f	{"referralCode": "BIKSUHWFQK"}	2026-04-04 07:05:53.758
cmnk9x12b000jjo04pv9c96c3	cmnighgle0004u718dt5i4clk	gig_apply	New gig application	Shikhar · timavicii925@gmail.com · 7458072713 applied to “Event Photographer”. Pitch: “ih”	f	{"gigId": "cmnj9ne9q0005u7swx25d3l95", "applicantId": "cmnipa7et0000lb04ns1hjdoj", "applicantName": "Shikhar", "applicationId": "cmnk9x0y3000hjo04y29kkrjc", "applicantEmail": "timavicii925@gmail.com", "applicantPhone": "7458072713"}	2026-04-04 11:53:04.932
cmnk9x1ar000ljo04or1rmduc	seed-admin-occ-staff	gig_apply	Gig application submitted	Shikhar applied to “Event Photographer”.	f	{"gigId": "cmnj9ne9q0005u7swx25d3l95", "applicantId": "cmnipa7et0000lb04ns1hjdoj", "applicationId": "cmnk9x0y3000hjo04y29kkrjc"}	2026-04-04 11:53:05.236
cmnlpd1890007u7qoq7dsef7v	cmnlp7mo10005u7qokf9h26km	approval	Application approved	You are approved. Your referral code is FASFAS86DV	f	{"referralCode": "FASFAS86DV"}	2026-04-05 11:53:12.058
cmnls0zd40009u7xk5llrpae5	seed-admin-occ-staff	gig_apply	Gig application submitted	Fashion applied to “Fitness Event Coordinator”.	f	{"gigId": "cmnlo0ami002tu7g8fysosrfe", "applicantId": "cmnlp7mo10005u7qokf9h26km", "applicationId": "cmnls0yo20007u7xkvydkbgnb"}	2026-04-05 13:07:48.615
cmnlyx9710003u73sgfsdoc0s	seed-admin-occ-staff	gig_created	New gig posted	Fashion posted “Opportunity for Fashion Content Creators” (Fashion).	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "clubId": "club-fashion"}	2026-04-05 16:20:52.037
cmnlzmh5l0007u73sfrcgqh0a	cmnlp7mo10005u7qokf9h26km	gig_apply	New gig application	Test · spherefulltos@gmail.com · 8234292022 applied to “Opportunity for Fashion Content Creators”.	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "applicantId": "cmniglcfn0008u718ymztkf7y", "applicantName": "Test", "applicationId": "cmnlzmgsv0005u73s72xlfzcb", "applicantEmail": "spherefulltos@gmail.com", "applicantPhone": "8234292022"}	2026-04-05 16:40:28.761
cmnlzmhu50009u73spewvrbkn	seed-admin-occ-staff	gig_apply	Gig application submitted	Test applied to “Opportunity for Fashion Content Creators”.	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "applicantId": "cmniglcfn0008u718ymztkf7y", "applicationId": "cmnlzmgsv0005u73s72xlfzcb"}	2026-04-05 16:40:29.645
cmnlzmvu9000bu73sl24fk8g1	cmniglcfn0008u718ymztkf7y	gig_application_approved	Gig application approved	Your application for “Opportunity for Fashion Content Creators” was approved.	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "applicationId": "cmnlzmgsv0005u73s72xlfzcb"}	2026-04-05 16:40:47.793
cmnlzmw6u000du73spris4j5d	seed-admin-occ-staff	gig_application_review	Gig application approved	Fashion approved Test for “Opportunity for Fashion Content Creators”.	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "status": "APPROVED", "applicationId": "cmnlzmgsv0005u73s72xlfzcb"}	2026-04-05 16:40:48.247
cmnmqpyw60003kz04grfdmgnn	cmnmqpjix0001kz04z8t57lm4	approval	Application approved	You are approved. Your referral code is MUSSUHXCQB	f	{"referralCode": "MUSSUHXCQB"}	2026-04-06 05:19:01.351
cmnmqxnp30003l70498vqczky	cmnmqwwe20001l704fcndlpxw	approval	Application approved	You are approved. Your referral code is GAMSUHSGUE	f	{"referralCode": "GAMSUHSGUE"}	2026-04-06 05:25:00.088
cmnmtyinj0003l4046jc2eots	cmnlp7mo10005u7qokf9h26km	gig_apply	New gig application	Shikhar · timavicii925@gmail.com · 7458072713 applied to “Opportunity for Fashion Content Creators”. Pitch: “I am Interested in this”	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "applicantId": "cmnipa7et0000lb04ns1hjdoj", "applicantName": "Shikhar", "applicationId": "cmnmtyij60001l404x2smv8nv", "applicantEmail": "timavicii925@gmail.com", "applicantPhone": "7458072713"}	2026-04-06 06:49:39.055
cmnmtyivx0005l404l42933xb	seed-admin-occ-staff	gig_apply	Gig application submitted	Shikhar applied to “Opportunity for Fashion Content Creators”.	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "applicantId": "cmnipa7et0000lb04ns1hjdoj", "applicationId": "cmnmtyij60001l404x2smv8nv"}	2026-04-06 06:49:39.358
cmnmyx5xa0005kz0403ipuwwe	cmnmyvc4p0003kz04i0qezemt	approval	Application approved	You are approved. Your referral code is BIKAVIWFQP	f	{"referralCode": "BIKAVIWFQP"}	2026-04-06 09:08:33.982
cmnmyx6vr0007kz044yisd2ej	cmnmyhrxj0001kz04o9v2wnsg	approval	Application approved	You are approved. Your referral code is SPOJEFYSLA	f	{"referralCode": "SPOJEFYSLA"}	2026-04-06 09:08:35.224
cmnn51gkf0007jp04aavw2slr	cmnmzipoo000ekz043lnx7r1j	approval	Application approved	You are approved. Your referral code is BIKBKM1CI	f	{"referralCode": "BIKBKM1CI"}	2026-04-06 11:59:52.095
cmnn51gw30009jp04r1sdnubj	cmnn4zdao0005jp04vqc7yirv	approval	Application approved	You are approved. Your referral code is BIKELV_UZV	f	{"referralCode": "BIKELV_UZV"}	2026-04-06 11:59:52.515
cmnn5of5e0003ju04irjxxeq3	cmnighgle0004u718dt5i4clk	gig_apply	New gig application	Vasudha Nagesh · vasudhanagesh.16@gmail.com · 6186257525 applied to “Event Photographer”.	f	{"gigId": "cmnj9ne9q0005u7swx25d3l95", "applicantId": "cmnivjy4f0003l104y9t3rceb", "applicantName": "Vasudha Nagesh", "applicationId": "cmnn5of0y0001ju04v78ti5il", "applicantEmail": "vasudhanagesh.16@gmail.com", "applicantPhone": "6186257525"}	2026-04-06 12:17:43.347
cmnn5ofe60005ju0413vmzopr	seed-admin-occ-staff	gig_apply	Gig application submitted	Vasudha Nagesh applied to “Event Photographer”.	f	{"gigId": "cmnj9ne9q0005u7swx25d3l95", "applicantId": "cmnivjy4f0003l104y9t3rceb", "applicationId": "cmnn5of0y0001ju04v78ti5il"}	2026-04-06 12:17:43.663
cmno8ypk20005u77g2gwe9tji	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Surya joined using your referral code.	f	{"studentId": "cmno6dlbj0000i5048wzcgi92"}	2026-04-07 06:37:28.419
cmno9kzvw0006lb04ok87vs8a	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	jishnu n joined using your referral code.	f	{"studentId": "cmno9keux0000lb047w1faixt"}	2026-04-07 06:54:48.236
cmnobyuzw0006l404c7m0ezmw	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Nithin Gowda joined using your referral code.	f	{"studentId": "cmnoby71o0000l4040rvnsohr"}	2026-04-07 08:01:34.316
cmnojzr2i0005k3048t28oaw7	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	fazil joined using your referral code.	f	{"studentId": "cmnk740dd0000ju04hrjxizbw"}	2026-04-07 11:46:12.81
cmnok9ite000iu7o8n57q9a9d	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Sphereboy joined using your referral code.	f	{"studentId": "cmniglcfn0008u718ymztkf7y"}	2026-04-07 11:53:48.674
cmnomuati0003l504ndpcbun2	cmnlp7mo10005u7qokf9h26km	gig_apply	New gig application	fazil · fazil80883@gmail.com · 6586023109 applied to “Opportunity for Fashion Content Creators”.	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "applicantId": "cmnk740dd0000ju04hrjxizbw", "applicantName": "fazil", "applicationId": "cmnomuaov0001l504l0gihklu", "applicantEmail": "fazil80883@gmail.com", "applicantPhone": "6586023109"}	2026-04-07 13:05:57.318
cmnomub580005l5045n3k66cc	seed-admin-occ-staff	gig_apply	Gig application submitted	fazil applied to “Opportunity for Fashion Content Creators”.	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "applicantId": "cmnk740dd0000ju04hrjxizbw", "applicationId": "cmnomuaov0001l504l0gihklu"}	2026-04-07 13:05:57.74
cmnomue1z0009l504ubwj8v95	cmnlp7mo10005u7qokf9h26km	gig_apply	New gig application	fazil · fazil80883@gmail.com · 6586023109 applied to “Opportunity for Fashion Content Creators”.	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "applicantId": "cmnk740dd0000ju04hrjxizbw", "applicantName": "fazil", "applicationId": "cmnomuaov0001l504l0gihklu", "applicantEmail": "fazil80883@gmail.com", "applicantPhone": "6586023109"}	2026-04-07 13:06:01.511
cmnomue6e000bl504kn74o5g5	seed-admin-occ-staff	gig_apply	Gig application submitted	fazil applied to “Opportunity for Fashion Content Creators”.	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "applicantId": "cmnk740dd0000ju04hrjxizbw", "applicationId": "cmnomuaov0001l504l0gihklu"}	2026-04-07 13:06:01.671
cmnoolmpj0006l104dvc6xxel	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Anurag joined using your referral code.	f	{"studentId": "cmnool7ao0000l104yibxmg0d"}	2026-04-07 13:55:12.055
cmnoplp0c0008l204wxvicdz7	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	JNANESH N joined using your referral code.	f	{"studentId": "cmnopk78z0001l204tjg4xfom"}	2026-04-07 14:23:14.653
cmnopo4xt000dla04zrfg30i2	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	SN joined using your referral code.	f	{"studentId": "cmnopnp5n0004la04mg1lk58l"}	2026-04-07 14:25:08.609
cmnoppi7t000hla04ykxue5py	cmnlp7mo10005u7qokf9h26km	gig_apply	New gig application	Masala Dose · masaladose9501@gmail.com · 7071829186 applied to “Opportunity for Fashion Content Creators”.	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "applicantId": "cmnopnwl80005la041arwkbo9", "applicantName": "Masala Dose", "applicationId": "cmnoppi30000fla04986lamcq", "applicantEmail": "masaladose9501@gmail.com", "applicantPhone": "7071829186"}	2026-04-07 14:26:12.473
cmnoppihe000jla04hhut8h5p	seed-admin-occ-staff	gig_apply	Gig application submitted	Masala Dose applied to “Opportunity for Fashion Content Creators”.	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "applicantId": "cmnopnwl80005la041arwkbo9", "applicationId": "cmnoppi30000fla04986lamcq"}	2026-04-07 14:26:12.819
cmnopy7mz0013la04udybj9ay	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Abhishek satish joined using your referral code.	f	{"studentId": "cmnopy6gu000xla04t0qvw9hi"}	2026-04-07 14:32:58.667
cmnoqiwzo001xla04c0h48rb3	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Sk Roshan Ali joined using your referral code.	f	{"studentId": "cmnoqhm7o001rla047j1dnsk5"}	2026-04-07 14:49:04.645
cmnpmuv64000ii804yttaubsm	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Preethu. S joined using your referral code.	f	{"studentId": "cmnpmutxr000ci804ptp4zbns"}	2026-04-08 05:54:09.868
cmnpmv9xh000qi804hwrfs467	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Misha Simra joined using your referral code.	f	{"studentId": "cmnpmv8sb000ji804yuawurq3"}	2026-04-08 05:54:28.997
cmnpmwfnp0011i804562t12by	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Zahara kouser joined using your referral code.	f	{"studentId": "cmnpmwexc000vi804jf5k0kmw"}	2026-04-08 05:55:23.077
cmnpmwgp80006l204zqm7jhlf	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Sudhankumar g joined using your referral code.	f	{"studentId": "cmnpmwfg90000l2046nijyeqn"}	2026-04-08 05:55:24.429
cmnpmxisc000fl204oxbgh4u3	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Dileep V joined using your referral code.	f	{"studentId": "cmnpmxi390009l2042x607c2i"}	2026-04-08 05:56:13.788
cmnpp3qcd000bl104lqsqigxp	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Sudarshan G joined using your referral code.	f	{"studentId": "cmnpp2m9z0005l104i8wndoom"}	2026-04-08 06:57:02.75
cmnppbrnn000ml104835d4m65	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Rashmi joined using your referral code.	f	{"studentId": "cmnppb2z0000gl104psm1vo0h"}	2026-04-08 07:03:17.7
cmnppf53u000vl104s8q7mbte	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Spoorthi M joined using your referral code.	f	{"studentId": "cmnppesjx000pl104x549yh1r"}	2026-04-08 07:05:55.099
cmnppn7wq0016l104v36hhs7z	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Deepa Chandra joined using your referral code.	f	{"studentId": "cmnppmg590010l1041iaj5q43"}	2026-04-08 07:12:11.979
cmnprnofm0005ky043rv1db1x	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Reshot Official01 joined using your referral code.	f	{"studentId": "cmno5uxkf0000lj058iik9dy5"}	2026-04-08 08:08:32.627
cmnpz24yn0007ju04rqylqo07	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	PAVAN KUMAR S joined using your referral code.	f	{"studentId": "cmnpz23ng0001ju048p4qjc82"}	2026-04-08 11:35:44.543
cmnr31lbz0002u79kifjzbjwf	cmnr3197o0001l804imwja3wr	approval	Application approved	You are approved. Your referral code is SPOSHU8HNA	f	{"referralCode": "SPOSHU8HNA"}	2026-04-09 06:15:03.742
cmnr4mkdy000ku79k7q83prbp	cmnr4ki2a000iu79katbp2k6m	approval	Application approved	You are approved. Your referral code is BIKTHE9VUA	f	{"referralCode": "BIKTHE9VUA"}	2026-04-09 06:59:21.911
cmnr4t8i10003ie04enajroar	cmnlp7mo10005u7qokf9h26km	gig_apply	New gig application	Joshnavi S · joshnavis62@gmail.com · 9353745935 applied to “Opportunity for Fashion Content Creators”. Pitch: “Where style meets confidence”	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "applicantId": "cmnr3rnh90000jr04dtouk34f", "applicantName": "Joshnavi S", "applicationId": "cmnr4t8dk0001ie047ax18cq3", "applicantEmail": "joshnavis62@gmail.com", "applicantPhone": "9353745935"}	2026-04-09 07:04:33.097
cmnr4t8qh0005ie04wasbl9jr	cmn4i6c7o0000jfvwsva02o1k	gig_apply	Gig application submitted	Joshnavi S applied to “Opportunity for Fashion Content Creators”.	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "applicantId": "cmnr3rnh90000jr04dtouk34f", "applicationId": "cmnr4t8dk0001ie047ax18cq3"}	2026-04-09 07:04:33.402
cmnr4t9250007ie04tvxctjkr	seed-admin-occ-staff	gig_apply	Gig application submitted	Joshnavi S applied to “Opportunity for Fashion Content Creators”.	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "applicantId": "cmnr3rnh90000jr04dtouk34f", "applicationId": "cmnr4t8dk0001ie047ax18cq3"}	2026-04-09 07:04:33.402
cmnrgm47w0006jf04xhd3olia	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	2025222 ROSHAN PAUL joined using your referral code.	f	{"studentId": "cmnrgl2sj0000jf04gdmvejhs"}	2026-04-09 12:34:56.349
cmnri2haz0006ky048mdw289q	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	kitty gaming joined using your referral code.	f	{"studentId": "cmnri2g3z0000ky0493id515v"}	2026-04-09 13:15:39.419
cmnrjf68h0001jr04pm7hql55	cmnrfylea0001l7041s6sx8le	approval	Application approved	You are approved. Your referral code is PHORAHIH0P	f	{"referralCode": "PHORAHIH0P"}	2026-04-09 13:53:31.218
cmnsfp9k40003la04vjd89huj	cmnlp7mo10005u7qokf9h26km	gig_apply	New gig application	jishnu n · jishnunreddy@gmail.com · 6016275519 applied to “Opportunity for Fashion Content Creators”. Pitch: “wergthyjm”	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "applicantId": "cmno9keux0000lb047w1faixt", "applicantName": "jishnu n", "applicationId": "cmnsfp9ek0001la042ejaun56", "applicantEmail": "jishnunreddy@gmail.com", "applicantPhone": "6016275519"}	2026-04-10 04:57:09.797
cmnsfp9t00005la04wy87g3h8	seed-admin-occ-staff	gig_apply	Gig application submitted	jishnu n applied to “Opportunity for Fashion Content Creators”.	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "applicantId": "cmno9keux0000lb047w1faixt", "applicationId": "cmnsfp9ek0001la042ejaun56"}	2026-04-10 04:57:10.116
cmnsfpa6t0007la04bh3fte52	cmn4i6c7o0000jfvwsva02o1k	gig_apply	Gig application submitted	jishnu n applied to “Opportunity for Fashion Content Creators”.	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "applicantId": "cmno9keux0000lb047w1faixt", "applicationId": "cmnsfp9ek0001la042ejaun56"}	2026-04-10 04:57:10.116
cmnsfpumg000bla04jkekh5rh	cmnighgle0004u718dt5i4clk	gig_apply	New gig application	jishnu n · jishnunreddy@gmail.com · 6016275519 applied to “Event Photographer”. Pitch: “wefrgthyjmunb”	f	{"gigId": "cmnj9ne9q0005u7swx25d3l95", "applicantId": "cmno9keux0000lb047w1faixt", "applicantName": "jishnu n", "applicationId": "cmnsfpui50009la04fq6u8go2", "applicantEmail": "jishnunreddy@gmail.com", "applicantPhone": "6016275519"}	2026-04-10 04:57:37.096
cmnsfpusz000dla04q9worg3u	seed-admin-occ-staff	gig_apply	Gig application submitted	jishnu n applied to “Event Photographer”.	f	{"gigId": "cmnj9ne9q0005u7swx25d3l95", "applicantId": "cmno9keux0000lb047w1faixt", "applicationId": "cmnsfpui50009la04fq6u8go2"}	2026-04-10 04:57:37.332
cmnsfpuv4000fla04mu7b479e	cmn4i6c7o0000jfvwsva02o1k	gig_apply	Gig application submitted	jishnu n applied to “Event Photographer”.	f	{"gigId": "cmnj9ne9q0005u7swx25d3l95", "applicantId": "cmno9keux0000lb047w1faixt", "applicationId": "cmnsfpui50009la04fq6u8go2"}	2026-04-10 04:57:37.332
cmnsh47zk0006lb040co6655o	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Ramoji nayak Rj joined using your referral code.	f	{"studentId": "cmnsh0d7a000jlj0452v424rh"}	2026-04-10 05:36:47.217
cmnsh4kuj000sla04vtkdlksl	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Kavana.M.U Kavana.M.U joined using your referral code.	f	{"studentId": "cmnsh27e2000mlj045gtg4jz2"}	2026-04-10 05:37:03.883
cmnsh4v7o000flb04ohjsom5x	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Chandru joined using your referral code.	f	{"studentId": "cmnsh2adp000nlj043edrpnrk"}	2026-04-10 05:37:17.316
cmnsh4ykr000llb04vyzm2n7u	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Jenish Kc joined using your referral code.	f	{"studentId": "cmnsh3wwa000olj04avygqj0o"}	2026-04-10 05:37:21.676
cmnsh51no000rlb04thdzb7mn	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Anusha H C joined using your referral code.	f	{"studentId": "cmnsh0scz000llj04bi0nics2"}	2026-04-10 05:37:25.669
cmnsh55ln000ylb04cwhuez12	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Nandan K S joined using your referral code.	f	{"studentId": "cmnsgzofj000hlj04eyyyu0fj"}	2026-04-10 05:37:30.78
cmnsh5ciw0014lb04918cckcv	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Meghana.M.R Meghana joined using your referral code.	f	{"studentId": "cmnsh4rfy000ula04srietnaj"}	2026-04-10 05:37:39.752
cmnsh5p0i001alb04xspr4fnl	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Chandana GS joined using your referral code.	f	{"studentId": "cmnsh4cnf0009lb0464mx03n3"}	2026-04-10 05:37:55.939
cmnsh5qr1001glb04nknuddib	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Kiccha Gagan joined using your referral code.	f	{"studentId": "cmnsh4p76000tla042e1tuj1j"}	2026-04-10 05:37:58.189
cmnsh5ymp0013la04oeah1r6u	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Ankitha G joined using your referral code.	f	{"studentId": "cmnsh47zn0007lb047f2e9q3l"}	2026-04-10 05:38:08.402
cmnsh5z3p0017la0417h3id9s	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Ganavi B. g joined using your referral code.	f	{"studentId": "cmnsh4dwx000mla04hjxs1r6o"}	2026-04-10 05:38:09.013
cmnsh64fw001dla04frmqzof6	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Devika ko Devika joined using your referral code.	f	{"studentId": "cmnsh4dau000lla04n9hasucx"}	2026-04-10 05:38:15.932
cmnsh6st7001xla045n9ngl5r	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Gagan S joined using your referral code.	f	{"studentId": "cmnsh5wai000vla04xk2aruz3"}	2026-04-10 05:38:47.515
cmnsh75250029la0461ye6zm4	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	ABHISHEK HG joined using your referral code.	f	{"studentId": "cmnsh532u000slb04tsmuaxg2"}	2026-04-10 05:39:03.39
cmnsh7b89002fla0477x9v76n	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Keerthana B S joined using your referral code.	f	{"studentId": "cmnsh43xv0000lb042aumlphi"}	2026-04-10 05:39:11.385
cmnsh7hpf002lla04v15s2k44	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Nirmitha H.N joined using your referral code.	f	{"studentId": "cmnsh5xbi000plj04axp3pq84"}	2026-04-10 05:39:19.78
cmnsht4s00007u7dsfspodgo3	cmnr4ki2a000iu79katbp2k6m	post_like	New like on your post	Surya liked “Throttle on. City off. 🏍️🌄”.	f	{"clubId": "club-bikers", "postId": "cmnr4rwrr000ou79kk71liflm", "actorUserId": "cmno6dlbj0000i5048wzcgi92"}	2026-04-10 05:56:09.456
cmnsht5n70009u7dsrfq795ou	seed-admin-occ-staff	post_like	New like on your post	Surya liked a post in club feed. “Throttle on. City off. 🏍️🌄”	f	{"clubId": "club-bikers", "postId": "cmnr4rwrr000ou79kk71liflm", "actorUserId": "cmno6dlbj0000i5048wzcgi92"}	2026-04-10 05:56:10.58
cmnsht6ah000bu7dst2yf91ly	cmn4i6c7o0000jfvwsva02o1k	post_like	New like on your post	Surya liked a post in club feed. “Throttle on. City off. 🏍️🌄”	f	{"clubId": "club-bikers", "postId": "cmnr4rwrr000ou79kk71liflm", "actorUserId": "cmno6dlbj0000i5048wzcgi92"}	2026-04-10 05:56:10.58
cmnshu7n6000fu7dsjne81xs6	cmnr4ki2a000iu79katbp2k6m	post_like	New like on your post	Surya liked “7–8 hours. One unforgettable ride.”.	f	{"clubId": "club-bikers", "postId": "cmnr4owgx000mu79kkf3dmz1k", "actorUserId": "cmno6dlbj0000i5048wzcgi92"}	2026-04-10 05:56:59.826
cmnshu8a8000ju7ds3wqrid51	seed-admin-occ-staff	post_like	New like on your post	Surya liked a post in club feed. “7–8 hours. One unforgettable ride.”	f	{"clubId": "club-bikers", "postId": "cmnr4owgx000mu79kkf3dmz1k", "actorUserId": "cmno6dlbj0000i5048wzcgi92"}	2026-04-10 05:57:00.657
cmnshu8a8000iu7dsyk46739x	cmn4i6c7o0000jfvwsva02o1k	post_like	New like on your post	Surya liked a post in club feed. “7–8 hours. One unforgettable ride.”	f	{"clubId": "club-bikers", "postId": "cmnr4owgx000mu79kkf3dmz1k", "actorUserId": "cmno6dlbj0000i5048wzcgi92"}	2026-04-10 05:57:00.657
cmnsj6ms1000nu7dsmtx7gkqd	cmnlp7mo10005u7qokf9h26km	gig_apply	New gig application	Surya · suryas.sec.official@gmail.com · 8346075183 applied to “Opportunity for Fashion Content Creators”. Pitch: “Im a Content Creator + Dev”	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "applicantId": "cmno6dlbj0000i5048wzcgi92", "applicantName": "Surya", "applicationId": "cmnsj6mfp000lu7dsim4n2zsu", "applicantEmail": "suryas.sec.official@gmail.com", "applicantPhone": "8346075183"}	2026-04-10 06:34:38.929
cmnsj6nhs000pu7dsgpr3d4v8	seed-admin-occ-staff	gig_apply	Gig application submitted	Surya applied to “Opportunity for Fashion Content Creators”.	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "applicantId": "cmno6dlbj0000i5048wzcgi92", "applicationId": "cmnsj6mfp000lu7dsim4n2zsu"}	2026-04-10 06:34:39.856
cmnsj6ojh000ru7ds88qnyqe3	cmn4i6c7o0000jfvwsva02o1k	gig_apply	Gig application submitted	Surya applied to “Opportunity for Fashion Content Creators”.	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "applicantId": "cmno6dlbj0000i5048wzcgi92", "applicationId": "cmnsj6mfp000lu7dsim4n2zsu"}	2026-04-10 06:34:39.856
cmnsjhi34000tu7ds4kf6mc8y	cmno6dlbj0000i5048wzcgi92	gig_application_approved	Gig application approved	Your application for “Opportunity for Fashion Content Creators” was approved.	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "applicationId": "cmnsj6mfp000lu7dsim4n2zsu"}	2026-04-10 06:43:06.065
cmnsjhis3000vu7ds5vkqaux7	seed-admin-occ-staff	gig_application_review	Gig application approved	Fashion approved Surya for “Opportunity for Fashion Content Creators”.	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "status": "APPROVED", "applicationId": "cmnsj6mfp000lu7dsim4n2zsu"}	2026-04-10 06:43:06.963
cmnsjhis3000xu7dsoi5yi920	cmn4i6c7o0000jfvwsva02o1k	gig_application_review	Gig application approved	Fashion approved Surya for “Opportunity for Fashion Content Creators”.	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "status": "APPROVED", "applicationId": "cmnsj6mfp000lu7dsim4n2zsu"}	2026-04-10 06:43:06.963
cmnsjhlp0000zu7dstuw96fnx	cmno9keux0000lb047w1faixt	gig_application_approved	Gig application approved	Your application for “Opportunity for Fashion Content Creators” was approved.	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "applicationId": "cmnsfp9ek0001la042ejaun56"}	2026-04-10 06:43:10.74
cmnsjhmhc0013u7dsvsxzbh5r	seed-admin-occ-staff	gig_application_review	Gig application approved	Fashion approved jishnu n for “Opportunity for Fashion Content Creators”.	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "status": "APPROVED", "applicationId": "cmnsfp9ek0001la042ejaun56"}	2026-04-10 06:43:11.761
cmnsjhmhc0012u7ds2fwlvwbs	cmn4i6c7o0000jfvwsva02o1k	gig_application_review	Gig application approved	Fashion approved jishnu n for “Opportunity for Fashion Content Creators”.	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "status": "APPROVED", "applicationId": "cmnsfp9ek0001la042ejaun56"}	2026-04-10 06:43:11.761
cmnsjxuqv0015u7dslhl1iq04	cmnlp7mo10005u7qokf9h26km	gig_submission	Gig deliverables submitted	Surya submitted work for “Opportunity for Fashion Content Creators”.	f	{"gigId": "cmnlyx8is0001u73sic6caqsu", "applicantId": "cmno6dlbj0000i5048wzcgi92", "applicationId": "cmnsj6mfp000lu7dsim4n2zsu"}	2026-04-10 06:55:48.967
cmnslzfpo0005l104hss2cuu7	cmnr3197o0001l804imwja3wr	new-referral	New student joined	Surya joined using your referral code.	f	{"studentId": "cmno6dlbj0000i5048wzcgi92"}	2026-04-10 07:53:02.028
cmnsr63v10006l70407hnkpra	cmnmqwwe20001l704fcndlpxw	new-referral	New student joined	Akarsh joined using your referral code.	f	{"studentId": "cmnsr62l60000l704vk4hnxxm"}	2026-04-10 10:18:11.341
cmnsru25a0003kz0435p0abvq	cmnmqwwe20001l704fcndlpxw	post_like	New like on your post	jishnu n liked “OCC ESPORTS CHAMPIONSHIP 2026\n\nPlay. Compete. Conquer.\n\nRegistrations…”.	f	{"clubId": "cmnlqr8sa0001u7xklay1hj3b", "postId": "cmnpqapeg0007u7bw644b9ebw", "actorUserId": "cmno9keux0000lb047w1faixt"}	2026-04-10 10:36:48.862
cmnsru3g90005kz04hqmq03hk	seed-admin-occ-staff	post_like	New like on your post	jishnu n liked a post in club feed. “OCC ESPORTS CHAMPIONSHIP 2026\n\nPlay. Compete. Conquer.\n\nRegistrations…”	f	{"clubId": "cmnlqr8sa0001u7xklay1hj3b", "postId": "cmnpqapeg0007u7bw644b9ebw", "actorUserId": "cmno9keux0000lb047w1faixt"}	2026-04-10 10:36:50.553
cmnsru3tc0007kz04cdq0h6xf	cmn4i6c7o0000jfvwsva02o1k	post_like	New like on your post	jishnu n liked a post in club feed. “OCC ESPORTS CHAMPIONSHIP 2026\n\nPlay. Compete. Conquer.\n\nRegistrations…”	f	{"clubId": "cmnlqr8sa0001u7xklay1hj3b", "postId": "cmnpqapeg0007u7bw644b9ebw", "actorUserId": "cmno9keux0000lb047w1faixt"}	2026-04-10 10:36:50.553
cmnsru6ut000bkz04l1gy54kr	cmnmqwwe20001l704fcndlpxw	post_comment	New comment on your post	jishnu n commented on “OCC ESPORTS CHAMPIONSHIP 2026\n\nPlay. Compete. Conquer.\n\nRegistrations…”: “hi”	f	{"clubId": "cmnlqr8sa0001u7xklay1hj3b", "postId": "cmnpqapeg0007u7bw644b9ebw", "actorUserId": "cmno9keux0000lb047w1faixt"}	2026-04-10 10:36:54.966
cmnsrugyz000dkz04fdaleiww	cmn4i6c7o0000jfvwsva02o1k	post_comment	New post comment	jishnu n on “OCC ESPORTS CHAMPIONSHIP 2026\n\nPlay. Compete. Conquer.\n\nRegistrations…”: “hi”	f	{"clubId": "cmnlqr8sa0001u7xklay1hj3b", "postId": "cmnpqapeg0007u7bw644b9ebw", "actorUserId": "cmno9keux0000lb047w1faixt"}	2026-04-10 10:37:08.075
cmnsruh14000fkz04ds1kax5i	seed-admin-occ-staff	post_comment	New post comment	jishnu n on “OCC ESPORTS CHAMPIONSHIP 2026\n\nPlay. Compete. Conquer.\n\nRegistrations…”: “hi”	f	{"clubId": "cmnlqr8sa0001u7xklay1hj3b", "postId": "cmnpqapeg0007u7bw644b9ebw", "actorUserId": "cmno9keux0000lb047w1faixt"}	2026-04-10 10:37:08.075
cmnss8mjv0005lf04f405bihf	cmnr4ki2a000iu79katbp2k6m	post_like	New like on your post	jishnu n liked “Throttle on. City off. 🏍️🌄”.	f	{"clubId": "club-bikers", "postId": "cmnr4rwrr000ou79kk71liflm", "actorUserId": "cmno9keux0000lb047w1faixt"}	2026-04-10 10:48:08.491
cmnss8ofi0007lf04w0e86yuy	cmn4i6c7o0000jfvwsva02o1k	post_like	New like on your post	jishnu n liked a post in club feed. “Throttle on. City off. 🏍️🌄”	f	{"clubId": "club-bikers", "postId": "cmnr4rwrr000ou79kk71liflm", "actorUserId": "cmno9keux0000lb047w1faixt"}	2026-04-10 10:48:10.926
cmnss8ohs0009lf04e22urge0	seed-admin-occ-staff	post_like	New like on your post	jishnu n liked a post in club feed. “Throttle on. City off. 🏍️🌄”	f	{"clubId": "club-bikers", "postId": "cmnr4rwrr000ou79kk71liflm", "actorUserId": "cmno9keux0000lb047w1faixt"}	2026-04-10 10:48:10.926
cmnstb2k10003l704psfik2od	cmnr4ki2a000iu79katbp2k6m	post_like	New like on your post	Sphereboy liked “Throttle on. City off. 🏍️🌄”.	f	{"clubId": "club-bikers", "postId": "cmnr4rwrr000ou79kk71liflm", "actorUserId": "cmniglcfn0008u718ymztkf7y"}	2026-04-10 11:18:02.161
cmnstclhl0005l704kwuzshxq	cmn4i6c7o0000jfvwsva02o1k	post_like	New like on your post	Sphereboy liked a post in club feed. “Throttle on. City off. 🏍️🌄”	f	{"clubId": "club-bikers", "postId": "cmnr4rwrr000ou79kk71liflm", "actorUserId": "cmniglcfn0008u718ymztkf7y"}	2026-04-10 11:19:13.353
cmnstcltp0007l704uyhowx30	seed-admin-occ-staff	post_like	New like on your post	Sphereboy liked a post in club feed. “Throttle on. City off. 🏍️🌄”	f	{"clubId": "club-bikers", "postId": "cmnr4rwrr000ou79kk71liflm", "actorUserId": "cmniglcfn0008u718ymztkf7y"}	2026-04-10 11:19:13.354
\.


--
-- Data for Name: orbit_projects; Type: TABLE DATA; Schema: public; Owner: occ_4t52_user
--

COPY public.orbit_projects (id, title, category, description, "imageUrl", "sortOrder", active, "createdAt", "updatedAt") FROM stdin;
cmnm46o9k0000u7wocza02nbz	Cultural Festival 2024	Events	Annual cultural showcase featuring dance, music, and art.	https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?auto=format&fit=crop&w=1200&q=80	1	t	2026-04-05 18:48:09.558	2026-04-05 18:48:09.558
cmnm46omd0001u7wokwonmr68	Tech Innovation Summit	Tech	Gathering of the brightest minds in campus technology.	https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=1200&q=80	2	t	2026-04-05 18:48:10.021	2026-04-05 18:48:10.021
cmnm6kxsu0000u7ock8acmlzh	Club Launch	Clubs		https://res.cloudinary.com/dbu9z9ija/image/upload/v1775418897/occ/orbit/oit7yskmffdkwthll9ih.png	2	t	2026-04-05 19:55:14.332	2026-04-05 19:55:14.332
cmnm6lftx0003u7ocqh7frsx8	Club Launch	Clubs		https://res.cloudinary.com/dbu9z9ija/image/upload/v1775418930/occ/orbit/ndcd4xd7bfzgg2pefsss.png	2	t	2026-04-05 19:55:37.702	2026-04-05 19:55:37.702
cmnm6mip50006u7ocl2g15yzj	OCC	Clubs		https://res.cloudinary.com/dbu9z9ija/image/upload/v1775418975/occ/orbit/dux52ixan6ksm6uugzef.png	2	t	2026-04-05 19:56:28.073	2026-04-05 19:56:28.073
cmnm6njzw000cu7ocvr0z06r6	OCC Posters	Clubs		https://res.cloudinary.com/dbu9z9ija/image/upload/v1775419029/occ/orbit/ctao0qdiwuswvhvbyz5z.png	2	t	2026-04-05 19:57:16.412	2026-04-05 19:57:16.412
cmnm6oapc000fu7oc7qi9229a	OCC Run Your Sense	Clubs		https://res.cloudinary.com/dbu9z9ija/image/upload/v1775419051/occ/orbit/skrmlxgyullsn5kybdbd.png	2	t	2026-04-05 19:57:51.024	2026-04-05 19:57:51.024
cmnm6ovz7000iu7ocjz0xxgxu	OCC	Clubs		https://res.cloudinary.com/dbu9z9ija/image/upload/v1775419083/occ/orbit/eseozsgthramwutiw4ic.png	2	t	2026-04-05 19:58:18.596	2026-04-05 19:58:18.596
cmnm6pe7a000lu7ocn99d530u	Our Team	Clubs		https://res.cloudinary.com/dbu9z9ija/image/upload/v1775419115/occ/orbit/ckrlaqkdzy1uaol44soe.png	2	t	2026-04-05 19:58:42.215	2026-04-05 19:58:42.215
cmnm6prvv000ou7ocmvek8krm	A Walk	Clubs		https://res.cloudinary.com/dbu9z9ija/image/upload/v1775419135/occ/orbit/br7rgird7nwg0p12tmnb.png	2	t	2026-04-05 19:58:59.947	2026-04-05 19:58:59.947
cmnm6qf6d000ru7ocimwcjrjv	Love OCC	Clubs		https://res.cloudinary.com/dbu9z9ija/image/upload/v1775419155/occ/orbit/b7tttym5ermr2yfy8ynu.png	2	t	2026-04-05 19:59:30.133	2026-04-05 19:59:30.133
cmnm6n2uh0009u7oclefr8d93	Great Catch With OCC	Clubs		https://res.cloudinary.com/dbu9z9ija/image/upload/v1775419001/occ/orbit/ovdgkvlf5yexif4jjepb.png	2	t	2026-04-05 19:56:54.186	2026-04-05 20:00:17.012
\.


--
-- Data for Name: platform_settings; Type: TABLE DATA; Schema: public; Owner: occ_4t52_user
--

COPY public.platform_settings (id, "siteName", "announcementBanner", "announcementActive", "maintenanceMode", "registrationOpen", "landingHeroTitle", "landingHeroSubtitle", "updatedAt", "featureFlags", "landingCmsExtra", "legalPrivacyHtml", "legalTermsHtml", "rateLimitPolicy") FROM stdin;
singleton	OCC	\N	f	f	t	\N	\N	2026-04-05 22:42:26.7	{}	{}	\N	\N	{}
\.


--
-- Data for Name: post_bookmarks; Type: TABLE DATA; Schema: public; Owner: occ_4t52_user
--

COPY public.post_bookmarks (id, "postId", "userId", "createdAt") FROM stdin;
cmnssaphw0001ky0407fqy3dq	cmnpqapeg0007u7bw644b9ebw	cmno9keux0000lb047w1faixt	2026-04-10 10:49:45.62
\.


--
-- Data for Name: post_likes; Type: TABLE DATA; Schema: public; Owner: occ_4t52_user
--

COPY public.post_likes (id, "postId", "userId", "createdAt") FROM stdin;
cmnmuaato000dl404r9d7msyd	cmnlsmkpb000bu7xk3khubpdy	cmnipa7et0000lb04ns1hjdoj	2026-04-06 06:58:48.78
cmnn4urac0001jp04jqv3r8ro	cmnlsmkpb000bu7xk3khubpdy	cmnivjy4f0003l104y9t3rceb	2026-04-06 11:54:39.396
cmnpp5pv3000dl104rmn3vjvf	cmnlsmkpb000bu7xk3khubpdy	cmnmuju0y0000jl04od32lhe7	2026-04-08 06:58:35.44
cmnps6gs60001jp04g26vzn2g	cmnpqapeg0007u7bw644b9ebw	cmno5uxkf0000lj058iik9dy5	2026-04-08 08:23:09.175
cmnpww3710001ky0489oslknv	cmnpqapeg0007u7bw644b9ebw	cmnjxvgi90000kz042v6o3rfw	2026-04-08 10:35:03.085
cmnr23xqt0005kv044jf2wx8d	cmnpqapeg0007u7bw644b9ebw	cmnr1fsfb0005jy04tb0ysg5o	2026-04-09 05:48:53.525
cmnsf9rpu000njv04jk2620y4	cmnr4owgx000mu79kkf3dmz1k	cmno9keux0000lb047w1faixt	2026-04-10 04:45:06.835
cmnsfz4gu000fu7zkda97ubhg	cmnpqapeg0007u7bw644b9ebw	cmno6dlbj0000i5048wzcgi92	2026-04-10 05:04:49.758
cmnsgptpq000blj041siplsop	cmnr4rwrr000ou79kk71liflm	cmnmzipoo000ekz043lnx7r1j	2026-04-10 05:25:35.534
cmnsgqalj000dlj04i9604i4w	cmnpqapeg0007u7bw644b9ebw	cmnmzipoo000ekz043lnx7r1j	2026-04-10 05:25:57.416
cmnsht3ko0005u7ds2uzikcro	cmnr4rwrr000ou79kk71liflm	cmno6dlbj0000i5048wzcgi92	2026-04-10 05:56:07.897
cmnshu646000du7ds42a1r1fb	cmnr4owgx000mu79kkf3dmz1k	cmno6dlbj0000i5048wzcgi92	2026-04-10 05:56:57.847
cmnsru1wp0001kz04dw04ht7d	cmnpqapeg0007u7bw644b9ebw	cmno9keux0000lb047w1faixt	2026-04-10 10:36:48.553
cmnstb26j0001l704jwuer017	cmnr4rwrr000ou79kk71liflm	cmniglcfn0008u718ymztkf7y	2026-04-10 11:18:01.676
\.


--
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: occ_4t52_user
--

COPY public.posts (id, "userId", "clubId", "imageUrl", caption, likes, "createdAt", content, "imageUrls", "likesCount", "sharesCount", type, hidden, pinned) FROM stdin;
cmnlsmkpb000bu7xk3khubpdy	cmnlp7mo10005u7qokf9h26km	club-fashion	https://res.cloudinary.com/dbu9z9ija/image/upload/v1775395441/occ/posts/h5p0z4e7t9nmqhvbmnaw.png	We’re looking for bold personalities to feature in our upcoming streetwear editorial shoot.\nIf you’ve got confidence, attitude, and a strong presence — this is your moment.\n\nTheme: Urban / Raw / Night aesthetics\n Location: Bangalore\n\n\nWho can apply:\n\nModels (beginner / experienced)\nStylists\nPhotographers\n\n✨ Selected participants will be featured on our official page + portfolio access.\n\n👉 Apply now & be part of something visual.	3	2026-04-05 13:24:36.042	We’re looking for bold personalities to feature in our upcoming streetwear editorial shoot.\nIf you’ve got confidence, attitude, and a strong presence — this is your moment.\n\nTheme: Urban / Raw / Night aesthetics\n Location: Bangalore\n\n\nWho can apply:\n\nModels (beginner / experienced)\nStylists\nPhotographers\n\n✨ Selected participants will be featured on our official page + portfolio access.\n\n👉 Apply now & be part of something visual.	{}	3	37	announcement	t	f
cmnr4rwrr000ou79kk71liflm	cmnr4ki2a000iu79katbp2k6m	club-bikers	https://res.cloudinary.com/dbu9z9ija/image/upload/v1775718199/occ/posts/yyav1lrsderek1zqgh60.jpg	Throttle on. City off. 🏍️🌄	3	2026-04-09 07:03:31.24	perfect escape to Nandi Hills — where the roads wind through clouds and every turn feels alive. From the early morning chill to that surreal sunrise above the mist, this ride is all about freedom, focus, and pure riding bliss.\n\nSmooth curves, scenic climbs, and that unbeatable view at the top — Nandi Hills never gets old.\n\nSometimes, all you need is a full tank, an open road, and a destination above the clouds.\n\n#NANDIHILLS #BIKERIDE #BANGALORERIDERS #SUNRISERIDE #RIDEMORE #TWOWHEELSLIFE #MORNINGVIBES #OPENROAD	{https://res.cloudinary.com/dbu9z9ija/image/upload/v1775718199/occ/posts/yyav1lrsderek1zqgh60.jpg}	3	0	announcement	f	f
cmnr4owgx000mu79kkf3dmz1k	cmnr4ki2a000iu79katbp2k6m	club-bikers	https://res.cloudinary.com/dbu9z9ija/image/upload/v1775718063/occ/posts/hpi7q2omovpedcfetsxj.jpg	7–8 hours. One unforgettable ride.	2	2026-04-09 07:01:10.881	From smooth highways to misty mountain roads, this journey to Ooty is pure adrenaline and peace combined. Riding through Bandipur & Mudumalai forests, with the chance of spotting wildlife, then taking on the legendary 36 hairpin bends of Kalhatty Ghat — every stretch tests your skill and rewards you with unreal views.\n\nTea estates rolling across the hills, cold wind hitting your face, and that fresh mountain air… this isn’t just a ride, it’s therapy.\n\nChose the Masinagudi route for the thrill or Gudalur for the scenic beauty — either way, Ooty never disappoints.\n\n⚠️ Ride smart:\n• Respect wildlife zones 🐘\n• Maintain control on hairpins 🛣️\n• Be ready for sudden weather changes 🌧️\n\nBest time? September to March for that perfect misty vibe.\n\nSome rides stay in your memory forever — this is one of them.\n\n#OOTYRIDE #BIKELIFE #HAIRPINBENDS #MOUNTAINRIDE #BANDIPUR #MUDUMALAI #RIDESAFE #BIKERSOFINDIA	{https://res.cloudinary.com/dbu9z9ija/image/upload/v1775718063/occ/posts/hpi7q2omovpedcfetsxj.jpg}	2	0	announcement	f	f
cmnpqapeg0007u7bw644b9ebw	cmnmqwwe20001l704fcndlpxw	cmnlqr8sa0001u7xklay1hj3b	https://res.cloudinary.com/dbu9z9ija/image/upload/v1775633384/occ/posts/x7isjnvi5bdprnn4jfx7.png	OCC ESPORTS CHAMPIONSHIP 2026\n\nPlay. Compete. Conquer.\n\nRegistrations are now open for the premier campus esports tournament featuring Free Fire, BGMI, and Valorant.\n\nRegistration Fee: ₹99\nUse code ESPORT for free entry (valid only if all team members register)\n\nPrizes:\n• ₹10,000 worth prize hampers\n• ₹5,000 worth prize hampers\n• Mystery Box\n• Certificates for all participants\n\nRules & Guidelines:\n• Open to UG and PG students only\n• Individual registration is mandatory\n• No hacks or unfair play\n• Emulators are not allowed (except for Valorant)\n• Participants must follow match timings strictly\n• The organizer’s decision will be final\n\nLimited slots available. Register now and secure your place.\n\n#OCC #OCCEsports #GamingTournament #BGMI #FreeFire #Valorant #EsportsIndia #CollegeEvents\n	6	2026-04-08 07:30:27.737	OCC ESPORTS CHAMPIONSHIP 2026\n\nPlay. Compete. Conquer.\n\nRegistrations are now open for the premier campus esports tournament featuring Free Fire, BGMI, and Valorant.\n\nRegistration Fee: ₹99\nUse code ESPORT for free entry (valid only if all team members register)\n\nPrizes:\n• ₹10,000 worth prize hampers\n• ₹5,000 worth prize hampers\n• Mystery Box\n• Certificates for all participants\n\nRules & Guidelines:\n• Open to UG and PG students only\n• Individual registration is mandatory\n• No hacks or unfair play\n• Emulators are not allowed (except for Valorant)\n• Participants must follow match timings strictly\n• The organizer’s decision will be final\n\nLimited slots available. Register now and secure your place.\n\n#OCC #OCCEsports #GamingTournament #BGMI #FreeFire #Valorant #EsportsIndia #CollegeEvents\n	{https://res.cloudinary.com/dbu9z9ija/image/upload/v1775633384/occ/posts/x7isjnvi5bdprnn4jfx7.png,https://res.cloudinary.com/dbu9z9ija/image/upload/v1775633387/occ/posts/zf1uyalvcvpmirxarudv.png}	6	0	post	f	f
\.


--
-- Data for Name: referral_stats; Type: TABLE DATA; Schema: public; Owner: occ_4t52_user
--

COPY public.referral_stats (id, "clubHeaderId", "studentId", "registeredAt", "clubId") FROM stdin;
cmniglejc000cu718y5fdb81g	cmnighgle0004u718dt5i4clk	cmniglcfn0008u718ymztkf7y	2026-04-03 05:24:27.48	club-bikers
cmno8yp7j0003u77g03vfaxx1	cmnmqwwe20001l704fcndlpxw	cmno6dlbj0000i5048wzcgi92	2026-04-07 06:37:27.967	cmnlqr8sa0001u7xklay1hj3b
cmno916xx0007u77g7a1uigdw	cmnmqwwe20001l704fcndlpxw	cmnnf8r2a0003js04igvv8xt0	2026-04-07 06:39:24.262	cmnlqr8sa0001u7xklay1hj3b
cmno917b00009u77gloe7q5dz	cmnmqwwe20001l704fcndlpxw	cmnnfaau10007js04koqnohvg	2026-04-07 06:39:24.732	cmnlqr8sa0001u7xklay1hj3b
cmno917hc000bu77gtxndivy4	cmnmqwwe20001l704fcndlpxw	cmnnfdjn1000ajs042ouz86ci	2026-04-07 06:39:24.96	cmnlqr8sa0001u7xklay1hj3b
cmno9kzra0004lb04ngrb0rov	cmnmqwwe20001l704fcndlpxw	cmno9keux0000lb047w1faixt	2026-04-07 06:54:48.07	cmnlqr8sa0001u7xklay1hj3b
cmnobyut20004l404pl5beo34	cmnmqwwe20001l704fcndlpxw	cmnoby71o0000l4040rvnsohr	2026-04-07 08:01:34.071	cmnlqr8sa0001u7xklay1hj3b
cmnojzqy90003k304sla6z1ii	cmnmqwwe20001l704fcndlpxw	cmnk740dd0000ju04hrjxizbw	2026-04-07 11:46:12.657	cmnlqr8sa0001u7xklay1hj3b
cmnok9ig8000gu7o8z8myrudn	cmnmqwwe20001l704fcndlpxw	cmniglcfn0008u718ymztkf7y	2026-04-07 11:53:48.198	cmnlqr8sa0001u7xklay1hj3b
cmnoolmlb0004l104fmfh95hh	cmnmqwwe20001l704fcndlpxw	cmnool7ao0000l104yibxmg0d	2026-04-07 13:55:11.903	cmnlqr8sa0001u7xklay1hj3b
cmnoplow30006l204c3rq3nd4	cmnmqwwe20001l704fcndlpxw	cmnopk78z0001l204tjg4xfom	2026-04-07 14:23:14.499	cmnlqr8sa0001u7xklay1hj3b
cmnopo4ti000bla04miki79xd	cmnmqwwe20001l704fcndlpxw	cmnopnp5n0004la04mg1lk58l	2026-04-07 14:25:08.454	cmnlqr8sa0001u7xklay1hj3b
cmnopy7ip0011la046nmjj9dn	cmnmqwwe20001l704fcndlpxw	cmnopy6gu000xla04t0qvw9hi	2026-04-07 14:32:58.513	cmnlqr8sa0001u7xklay1hj3b
cmnoqiwvh001vla045w1d4vnw	cmnmqwwe20001l704fcndlpxw	cmnoqhm7o001rla047j1dnsk5	2026-04-07 14:49:04.493	cmnlqr8sa0001u7xklay1hj3b
cmnpmuv12000gi804v1xli720	cmnmqwwe20001l704fcndlpxw	cmnpmutxr000ci804ptp4zbns	2026-04-08 05:54:09.686	cmnlqr8sa0001u7xklay1hj3b
cmnpmv9t9000oi804ctiixc26	cmnmqwwe20001l704fcndlpxw	cmnpmv8sb000ji804yuawurq3	2026-04-08 05:54:28.846	cmnlqr8sa0001u7xklay1hj3b
cmnpmwflh000zi804bx2s097u	cmnmqwwe20001l704fcndlpxw	cmnpmwexc000vi804jf5k0kmw	2026-04-08 05:55:22.997	cmnlqr8sa0001u7xklay1hj3b
cmnpmwgjs0004l204bw297ghr	cmnmqwwe20001l704fcndlpxw	cmnpmwfg90000l2046nijyeqn	2026-04-08 05:55:24.232	cmnlqr8sa0001u7xklay1hj3b
cmnpmxiq8000dl204xdwmms9o	cmnmqwwe20001l704fcndlpxw	cmnpmxi390009l2042x607c2i	2026-04-08 05:56:13.712	cmnlqr8sa0001u7xklay1hj3b
cmnpp3q820009l104luzkf36q	cmnmqwwe20001l704fcndlpxw	cmnpp2m9z0005l104i8wndoom	2026-04-08 06:57:02.595	cmnlqr8sa0001u7xklay1hj3b
cmnppbrj5000kl104y7ggoin7	cmnmqwwe20001l704fcndlpxw	cmnppb2z0000gl104psm1vo0h	2026-04-08 07:03:17.537	cmnlqr8sa0001u7xklay1hj3b
cmnppf51m000tl104upl8cp1n	cmnmqwwe20001l704fcndlpxw	cmnppesjx000pl104x549yh1r	2026-04-08 07:05:55.019	cmnlqr8sa0001u7xklay1hj3b
cmnppn7sh0014l104zfuinsbm	cmnmqwwe20001l704fcndlpxw	cmnppmg590010l1041iaj5q43	2026-04-08 07:12:11.826	cmnlqr8sa0001u7xklay1hj3b
cmnprnobf0003ky04zdoe2i04	cmnmqwwe20001l704fcndlpxw	cmno5uxkf0000lj058iik9dy5	2026-04-08 08:08:32.476	cmnlqr8sa0001u7xklay1hj3b
cmnpz24uf0005ju04l7evb9og	cmnmqwwe20001l704fcndlpxw	cmnpz23ng0001ju048p4qjc82	2026-04-08 11:35:44.392	cmnlqr8sa0001u7xklay1hj3b
cmnrgm43q0004jf04oo740zao	cmnmqwwe20001l704fcndlpxw	cmnrgl2sj0000jf04gdmvejhs	2026-04-09 12:34:56.199	cmnlqr8sa0001u7xklay1hj3b
cmnri2h6l0004ky04g2uyxeqz	cmnmqwwe20001l704fcndlpxw	cmnri2g3z0000ky0493id515v	2026-04-09 13:15:39.261	cmnlqr8sa0001u7xklay1hj3b
cmnsh47se0004lb04y1s3cp0y	cmnmqwwe20001l704fcndlpxw	cmnsh0d7a000jlj0452v424rh	2026-04-10 05:36:46.959	cmnlqr8sa0001u7xklay1hj3b
cmnsh4kq9000qla04roqeccwn	cmnmqwwe20001l704fcndlpxw	cmnsh27e2000mlj045gtg4jz2	2026-04-10 05:37:03.729	cmnlqr8sa0001u7xklay1hj3b
cmnsh4v5k000dlb04miwdygzc	cmnmqwwe20001l704fcndlpxw	cmnsh2adp000nlj043edrpnrk	2026-04-10 05:37:17.24	cmnlqr8sa0001u7xklay1hj3b
cmnsh4yij000jlb046w5xbdjy	cmnmqwwe20001l704fcndlpxw	cmnsh3wwa000olj04avygqj0o	2026-04-10 05:37:21.596	cmnlqr8sa0001u7xklay1hj3b
cmnsh51lk000plb04cqygxqjo	cmnmqwwe20001l704fcndlpxw	cmnsh0scz000llj04bi0nics2	2026-04-10 05:37:25.593	cmnlqr8sa0001u7xklay1hj3b
cmnsh55jj000wlb04xdtwju7c	cmnmqwwe20001l704fcndlpxw	cmnsgzofj000hlj04eyyyu0fj	2026-04-10 05:37:30.703	cmnlqr8sa0001u7xklay1hj3b
cmnsh5cgr0012lb0439bs3d7r	cmnmqwwe20001l704fcndlpxw	cmnsh4rfy000ula04srietnaj	2026-04-10 05:37:39.675	cmnlqr8sa0001u7xklay1hj3b
cmnsh5oya0018lb04fgnch7q0	cmnmqwwe20001l704fcndlpxw	cmnsh4cnf0009lb0464mx03n3	2026-04-10 05:37:55.858	cmnlqr8sa0001u7xklay1hj3b
cmnsh5qou001elb04gon272mq	cmnmqwwe20001l704fcndlpxw	cmnsh4p76000tla042e1tuj1j	2026-04-10 05:37:58.11	cmnlqr8sa0001u7xklay1hj3b
cmnsh5yij0011la04p5rg7xys	cmnmqwwe20001l704fcndlpxw	cmnsh47zn0007lb047f2e9q3l	2026-04-10 05:38:08.252	cmnlqr8sa0001u7xklay1hj3b
cmnsh5yzd0015la04gat7jifl	cmnmqwwe20001l704fcndlpxw	cmnsh4dwx000mla04hjxs1r6o	2026-04-10 05:38:08.858	cmnlqr8sa0001u7xklay1hj3b
cmnsh64dp001bla04c6qogap2	cmnmqwwe20001l704fcndlpxw	cmnsh4dau000lla04n9hasucx	2026-04-10 05:38:15.853	cmnlqr8sa0001u7xklay1hj3b
cmnsh6sr2001vla04gxuhrboy	cmnmqwwe20001l704fcndlpxw	cmnsh5wai000vla04xk2aruz3	2026-04-10 05:38:47.438	cmnlqr8sa0001u7xklay1hj3b
cmnsh74zz0027la04y6ru18y9	cmnmqwwe20001l704fcndlpxw	cmnsh532u000slb04tsmuaxg2	2026-04-10 05:39:03.311	cmnlqr8sa0001u7xklay1hj3b
cmnsh7b64002dla04ucyv1j0u	cmnmqwwe20001l704fcndlpxw	cmnsh43xv0000lb042aumlphi	2026-04-10 05:39:11.308	cmnlqr8sa0001u7xklay1hj3b
cmnsh7hnb002jla04um8sifad	cmnmqwwe20001l704fcndlpxw	cmnsh5xbi000plj04axp3pq84	2026-04-10 05:39:19.703	cmnlqr8sa0001u7xklay1hj3b
cmnslzflg0003l104lj0fs71a	cmnr3197o0001l804imwja3wr	cmno6dlbj0000i5048wzcgi92	2026-04-10 07:53:01.876	club-sports
cmnsr63qs0004l7041vn7nz5c	cmnmqwwe20001l704fcndlpxw	cmnsr62l60000l704vk4hnxxm	2026-04-10 10:18:11.188	cmnlqr8sa0001u7xklay1hj3b
\.


--
-- Data for Name: shares; Type: TABLE DATA; Schema: public; Owner: occ_4t52_user
--

COPY public.shares (id, "postId", "userId", "createdAt") FROM stdin;
\.


--
-- Data for Name: suspicious_access; Type: TABLE DATA; Schema: public; Owner: occ_4t52_user
--

COPY public.suspicious_access (id, "userId", "ipAddress", "userAgent", path, reason, severity, resolved, "createdAt") FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: occ_4t52_user
--

COPY public.users (id, "fullName", "collegeName", "phoneNumber", email, password, "emailVerified", avatar, bio, city, "graduationYear", "createdAt", "updatedAt", "approvalStatus", "clubManagedId", "referralCode", "referredBy", role, suspended, "pendingLeadClubId", "onboardingComplete", "referralSource", "adminLevel", "adminRoleTemplateId") FROM stdin;
seed-admin-occ-staff	OCC Staff	OCC HQ	0000000001	occ-staff-r8k2@occ-local.dev	$2b$12$LKwWgFPPWJoDXO0zRzmeyupnbC3oasjSSE/wTXmYURFJQwtHZJPcC	\N	\N	\N	\N	\N	2026-04-03 05:10:28.765	2026-04-03 05:10:28.765	APPROVED	\N	\N	\N	ADMIN	f	\N	f	\N	\N	\N
cmnivjy4f0003l104y9t3rceb	Vasudha Nagesh	Unknown College	6186257525	vasudhanagesh.16@gmail.com	$2b$12$DV9ShhNnnY7syYz1GEChNOp6osViIMxPI.4ab6dxNoz9Cx0jWu3nq	\N	\N	\N	\N	\N	2026-04-03 12:23:13.791	2026-04-03 12:23:13.791	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmniwqsu00000u7u4t7qqpggt	theone Who	Not specified	8767421392	theonewho.dareme@gmail.com	$2b$12$iST2vgZ0nrKCpv9x2iET5.NGqDxvcn6g6rGKNfhGRrpCMQiIn0vFO	2026-04-03 12:56:33.142	https://lh3.googleusercontent.com/a/ACg8ocKrchC_fgnAZ503rR_B7p5ZQPIWt9O-ZetpvihganN-PbEFZg=s96-c	\N	\N	\N	2026-04-03 12:56:33.144	2026-04-03 12:56:33.144	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmniz1sz20000l104bpufvsd8	Alan R	Not specified	6031500435	alanrtalip@gmail.com	$2b$12$pso/uJP06Z1aOjAz2Y2rQekTDiKQrTxwBPFYX2BSgvIHujMs6N35K	2026-04-03 14:01:05.773	https://lh3.googleusercontent.com/a/ACg8ocLzUXB1No7aJbYlrhPov96gfqKnAXPggrTgZkzXj1e6EiMl3w=s96-c	\N	\N	\N	2026-04-03 14:01:05.775	2026-04-03 14:01:05.775	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmniz9vbq0001l104p8ubheqo	Adice shree	Not specified	9470506054	adice5624@gmail.com	$2b$12$zwnoYctY9zekU1S4DA9ux.am0ngHCHQN4GpDSsBu4dHKxszFuuMDq	2026-04-03 14:07:22.07	https://lh3.googleusercontent.com/a/ACg8ocIPn1UQDfFrcuKJLFfb1wXvKgx2-lCyrhDBSF4MilN-nLPwvdY=s96-c	\N	\N	\N	2026-04-03 14:07:22.071	2026-04-03 14:07:22.071	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnirceit0000l704lzf6xukz	Subramanya K	Unknown College	6144462562	subramanyavdj@gmail.com	$2b$12$Aw6sf75E.NQs04Id1rjybOxd.k4GWbeX2C1X79ks.RA7YJfYklcEm	2026-04-03 14:08:57.238	https://lh3.googleusercontent.com/a/ACg8ocLlupvpSpjBPp7YiGs4hXYGeu9Ls4K4KC28yO0vU939Wi7RDL0=s96-c	\N	\N	\N	2026-04-03 10:25:23.333	2026-04-03 14:08:57.239	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnkjyasn0000ky04du50tsze	Abhishek Patil	Not specified	8666093510	abhishekpatil.012346@gmail.com	$2b$12$pvWlGeHbM4VBXP9GZtavx.8culHvPE3kgPuVWcmmExreemX.ilkZ6	2026-04-04 16:34:00.359	https://lh3.googleusercontent.com/a/ACg8ocKuFgE5cS0TvFHjKBgOX3yvEUfeKt6li2vC9gTUpIxQZw__f2N6=s96-c	\N	\N	\N	2026-04-04 16:34:00.36	2026-04-04 16:34:00.36	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnkk8d6u0003la049xhn7dvv	Anagha G Rao	Unknown College	7700680762	anaghagrao07@gmail.com	$2b$12$5bet7ex3lxSwRKV4voM0..VGe3lbOjJlNBmXaNkvfSCST8nqqc51m	\N	\N	\N	\N	\N	2026-04-04 16:41:50.022	2026-04-04 16:41:50.022	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnjzgmo80001l8040r01288w	Suhas Krishna	GCU	9663251106	suhasocc@gmail.com	$2b$12$J7QROIbDuipRe9..hPBhkulUUN8x5NGBjruElqKz58cLH4O/M7ozu	\N	\N	Hello	\N	\N	2026-04-04 07:00:23.624	2026-04-04 07:05:53.211	APPROVED	\N	\N	\N	STUDENT	t	\N	f	\N	\N	\N
cmnjzmhdh0005l8047ijfjuit	Suhas Krishna	Gcu	9663251102	suhaskrishnaPR@gmail.com	$2b$12$dyGdLYs3a/jjhDbG7UpPW.BaLapkhhY.5G72SAHtuoo34gPOn1d5a	\N	\N	Hello	\N	\N	2026-04-04 07:04:56.693	2026-04-04 07:05:53.524	APPROVED	\N	BIKSUHWFQK	\N	CLUB_HEADER	f	\N	f	\N	\N	\N
cmnk80gtx0000kz04uftryiq8	Madan Gowda	Not specified	8516221185	madan17gowda@gmail.com	$2b$12$vBtEDF/VyMYZHnX.SKT3ROCrk7Qa5UZzXuAgLZYa1qmmJZ5fcUaRW	2026-04-04 10:59:46.1	https://lh3.googleusercontent.com/a/ACg8ocLdfjkRhRRqOAOhUVHPVRezwmyln3jMvfKYdyc2K8Cp_K-juQ=s96-c	\N	\N	\N	2026-04-04 10:59:46.101	2026-04-04 10:59:46.101	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnlm7bss0000l4046ltybt60	Kushal A	Not specified	9517889457	kushal05092007@gmail.com	$2b$12$IUAslxNkU86847A7Xk1OO.w5NRNn0ikKxgGQWD3BEmlTbyy/ynL.u	2026-04-05 10:24:46.971	https://lh3.googleusercontent.com/a/ACg8ocI0ZcdSyOaXXYEPrDXbiaUztolbcXMey7CASZS5PG-hjtmOpQ=s96-c	\N	\N	\N	2026-04-05 10:24:46.972	2026-04-05 10:24:46.972	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnlm9h210003l404c4f58odq	Harsha	Not specified	6923844321	h4rsh4z@gmail.com	$2b$12$9cMQxr264lusmFHuwGIik.cjrpmGrKz9jblDmfvUNKRcgEGB/t0Fu	2026-04-05 10:26:27.096	https://lh3.googleusercontent.com/a/ACg8ocKP8YOlytlsAuOKPG3leH08L6YBo-pQVuNBtMAgF3z_rQeAKRo=s96-c	\N	\N	\N	2026-04-05 10:26:27.097	2026-04-05 10:26:27.097	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnlmabkt0004l4049m1ceeq5	Lohith Kumar.P.N	Not specified	7486523378	lohilohithkumar0018@gmail.com	$2b$12$GYLGI9LXnAsrRStgTjr2JOZu8bLcXmzM4wb8TtByk9ynEPBLTDMS2	2026-04-05 10:27:06.653	https://lh3.googleusercontent.com/a/ACg8ocLnzqZXLF6l6YzSgTkVZL7Au7wZ8rthwm-dpAHQu07VBiTgFaw=s96-c	\N	\N	\N	2026-04-05 10:27:06.654	2026-04-05 10:27:06.654	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnlmutzh0000l504ucgyhkpy	mahavirji kocheri	Not specified	9197696725	mahavirjiabhinandenk@gmail.com	$2b$12$jga.r7vP7UTEb/TGU41GAOCTe9qaaVCLcYGrWWMxVGh14q7LVWWcS	2026-04-05 10:43:03.628	https://lh3.googleusercontent.com/a/ACg8ocJyDIXxVGvYgNi962MPVoA1EcVXl1GPy-N4c2YcNHgihqaJhDE=s96-c	\N	\N	\N	2026-04-05 10:43:03.63	2026-04-05 10:43:03.63	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnlnzyux000yu7g8nddmimfe	Fashion Leader	Lusion University	+1000001350	dummy_fashion@example.com	hashedpassword123	\N	\N	\N	\N	\N	2026-04-05 11:15:02.842	2026-04-05 22:39:34.747	APPROVED	\N	\N	\N	STUDENT	t	\N	f	\N	\N	\N
cmnlo01qk001fu7g8r1o6y7y1	Bikers Leader	Lusion University	+1000008529	dummy_bikers@example.com	hashedpassword123	\N	\N	\N	\N	\N	2026-04-05 11:15:06.572	2026-04-05 22:39:35.404	APPROVED	\N	\N	\N	STUDENT	t	\N	f	\N	\N	\N
cmnlnzvxj000hu7g899pi5rev	Sports Football Leader	Lusion University	+1000003876	dummy_sports@example.com	hashedpassword123	\N	\N	\N	\N	\N	2026-04-05 11:14:59.047	2026-04-05 22:39:37.564	APPROVED	\N	\N	\N	STUDENT	t	\N	f	\N	\N	\N
cmnlnzrgc0000u7g8bnvwieww	Music Leader	Lusion University	+1000007642	dummy_music@example.com	hashedpassword123	\N	\N	\N	\N	\N	2026-04-05 11:14:53.244	2026-04-05 22:39:38.149	APPROVED	\N	\N	\N	STUDENT	t	\N	f	\N	\N	\N
cmnivf7ip0001l10422hubpto	Rithvik.R	Unknown College	8324848179	rithviknair10@gmail.com	$2b$12$kHF9V/7HLTRjE2GVgaqAcOLrhaxUA/uvk3dMpB2Y1qtH2odo9Nl5K	2026-04-06 09:03:54.701	https://lh3.googleusercontent.com/a/ACg8ocJo1B1sHv6QOsmpc4BCG9aHB4gjHYXVqUsOAO_1BFkZSGuImu8=s96-c	\N	\N	\N	2026-04-03 12:19:32.69	2026-04-06 09:03:54.703	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnka6bjp0000kv047w26c7j8	Varun T	Not specified	9016722477	varunt.ai24@bmsce.ac.in	$2b$12$uAwUELgX2BwdYiZvWya62euoSAI01g7b7TYTIRR.Yh.ZsqaK0GOue	2026-04-04 12:00:18.42	https://lh3.googleusercontent.com/a/ACg8ocKLB0snpb5Oy9FO41VaTjqCJ0D66xJn6YG2Cl-wNEOketJOXA=s96-c	\N	\N	\N	2026-04-04 12:00:18.421	2026-04-07 05:46:43.453	APPROVED	\N	\N	\N	STUDENT	f	\N	t	From a friend	\N	\N
cmnipa7et0000lb04ns1hjdoj	Shikhar	Unknown College	7458072713	timavicii925@gmail.com	$2b$12$TYUHAIeyyHR3kcxQ54iNZeudhkkC50o8pif268.I9lZPd23sLLMRG	\N	\N	\N	\N	\N	2026-04-03 09:27:41.574	2026-04-08 10:05:06.414	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Instagram	\N	\N
cmnjxvgi90000kz042v6o3rfw	kmaninishanth	Not specified	7247398661	kmaninishanth@gmail.com	$2b$10$XBWTFtv6j4x1N3MFnKYUVOYn5bo326EspXIdveefsXcD1nGwENKEe	2026-04-04 06:15:56.24	https://lh3.googleusercontent.com/a/ACg8ocJ39b0DjofQFYy0Xpnapg63kl3BP9FZtYHuSQBAnix--AR_SQ=s96-c	\N	\N	\N	2026-04-04 06:15:56.241	2026-03-25 13:30:22.916	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnlq98gt0000jv04uciv2zbl	Krishna Patil	Not specified	8828526347	patilkrishna3604@gmail.com	$2b$12$iWWP2FoXxCqJf7fo8116oOyGjYqOgOvivKM8zfmpia7PNG.OwItka	2026-04-05 12:18:14.428	https://lh3.googleusercontent.com/a/ACg8ocJCaJo4HzEBW_DCSrmOgpfKSOaeLwWMaW3WZ9wFY_dQWunuBQ=s96-c	\N	\N	\N	2026-04-05 12:18:14.429	2026-04-05 12:18:14.429	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnlo07w2002du7g839j1r0oe	Fitness Leader	Lusion University	+1000003020	dummy_fitness@example.com	hashedpassword123	\N	\N	\N	\N	\N	2026-04-05 11:15:14.546	2026-04-05 22:39:28.019	APPROVED	\N	\N	\N	STUDENT	t	\N	f	\N	\N	\N
cmnlo04ud001wu7g88a1r9dmf	Photography Leader	Lusion University	+1000006061	dummy_photography@example.com	hashedpassword123	\N	\N	\N	\N	\N	2026-04-05 11:15:10.597	2026-04-05 22:39:32.436	APPROVED	\N	\N	\N	STUDENT	t	\N	f	\N	\N	\N
cmnmhd9at0000kz04qgjl0uel	Niranjan gowda	Not specified	9326344329	niranjangowda747@gmail.com	$2b$12$8DS67XdRbPh8yarUIpc7aus0q7yxjDB/mUSOAxGAbsnsCRiwl9G/e	2026-04-06 00:57:11.764	https://lh3.googleusercontent.com/a/ACg8ocI-x2TowL4Z-l3qgfOAyRR-GQtzdWl0oVJPSDRXaDDKE-kGUzGR=s96-c	\N	\N	\N	2026-04-06 00:57:11.765	2026-04-06 00:57:11.765	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnmleh6p0000ks04us2m6ht9	LEKHARAJ.M .AMASHI	Not specified	7636918204	lekharaj.m.amashisrv@gmail.com	$2b$12$yxZ4zSvQRrblGz/TwV/B5eWG3RkgiX74si5LWvN.V1ks4nU5G9O6i	2026-04-06 02:50:07.105	https://lh3.googleusercontent.com/a/ACg8ocKtiGnrjurDaShq8kkx9eLCUh9yuSPc7Oe-b5G3hzqcCxwNeuM=s96-c	\N	\N	\N	2026-04-06 02:50:07.106	2026-04-06 02:50:07.106	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnmqltov0000kz04kv0wdakf	Akshay	Not specified	7775042619	akshudesai3000@gmail.com	$2b$12$7EiS7bOkLskRwkzx8exs/Oj3a6rCG63E.WWIcXg5ZrUYXrwSyMTIC	2026-04-06 05:15:47.982	https://lh3.googleusercontent.com/a/ACg8ocLEPppqqmX8A0IIoLQnRcyLKWbWp0SCI7AEMlzEKLtxnPZ6bmPf=s96-c	\N	\N	\N	2026-04-06 05:15:47.983	2026-04-06 05:15:47.983	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnmqs0i40007kz046nr2eh1z	Elvin Prince	Unknown College	9353674689	princeelvin04@gmail.com	$2b$12$vJ.9.8UoUF0MEw3JfcPNB.jkhK7DyNiFguRoABoNCNbz8H0JsnU8S	\N	\N	\N	\N	\N	2026-04-06 05:20:36.749	2026-04-06 05:20:36.749	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnmqpjix0001kz04z8t57lm4	Suhas Krishna	123	9663211066	Suhasocc@gmail.com	$2b$12$vBWTggHGl5XdijpSkNzkzehZxCEDm3.qtLx.ak1KSRwEw0mwIUvB2	\N	\N	hello	\N	\N	2026-04-06 05:18:41.434	2026-04-06 05:35:43.357	APPROVED	\N	MUSSUHXCQB	\N	CLUB_HEADER	t	\N	f	\N	\N	\N
cmnmrvsfm0000l704xue59j8i	Hemanth Kumar	Not specified	9106568379	rdshemanth@gmail.com	$2b$12$WWAZZNzXmPx6vtnfz2fZreTQrJMkdIPSGinXaef8h5EUjGiLKBx.C	2026-04-06 05:51:32.529	https://lh3.googleusercontent.com/a/ACg8ocJHyxeFAtz-ZCqE3pXETrZj9c5Yxq7nD-OqsrAnZx2Pr1Aocg=s96-c	\N	\N	\N	2026-04-06 05:51:32.53	2026-04-06 05:51:32.53	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnms6un70000jx04ampxv5sv	Jayanth Kumar	Not specified	9373931686	jayanthsetty168@gmail.com	$2b$12$c51PoxqawaOb3TLoPRP4/OPxb.eiNeOWHdj6/Ovfh6ElthJdtKRAK	2026-04-06 06:00:08.611	https://lh3.googleusercontent.com/a/ACg8ocIY7A0ndWPIShYqGO6AOdCgaAh4eAfHPy109RPJhFxATtZwJg=s96-c	\N	\N	\N	2026-04-06 06:00:08.612	2026-04-06 06:00:08.612	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnmuju0y0000jl04od32lhe7	Tharun R	Not specified	6198744709	tharunrchalam@gmail.com	$2b$12$QIxpqh8tyEHPaadm.JchFeO4oDiEjrSEPfME8zT3SE/CYMbX1gih2	2026-04-06 07:06:13.57	https://lh3.googleusercontent.com/a/ACg8ocKAUo-aPqjBbC2rf8uNwjSehEqBB38YUMNmiS9V80QnXTa78hnR=s96-c	\N	\N	\N	2026-04-06 07:06:13.571	2026-04-06 07:06:13.571	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnmvnjgk0001jm04b8zimpvz	Manas Gowda	Not specified	8171571238	manasgowda917@gmail.com	$2b$12$pMKlu6zV3oH3Y5BNcfEsvOm.V4wx1AM8Di5ZzBiLdBOKA3OGFDoJO	2026-04-06 07:37:06.115	https://lh3.googleusercontent.com/a/ACg8ocK8L0PAKmpvVoyzRzeEk0rGUQ9h3LwAZ1dOn37GNcnDcFtXaQ=s96-c	\N	\N	\N	2026-04-06 07:37:06.117	2026-04-06 07:37:06.117	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnmsh6mc0006jx04r9obo40g	Jeffery Sam	Not specified	6424944889	jefferysam99@gmail.com	$2b$12$gLYMwlQ6ccy95ON5ettg9.tQnNl.AmG1cqxlmkqqVnSkHkVlsFe5W	2026-04-06 06:08:10.691	https://lh3.googleusercontent.com/a/ACg8ocJKhHtvAgp0MJoRtbPCXcKgwMPJ6XFsvgxCc0ZYbzOaN_twbc5W=s96-c	\N	\N	\N	2026-04-06 06:08:10.693	2026-04-06 09:19:50.712	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnmzce8a0008kz04bgb9abwu	Varshini A	Not specified	8347503587	varshini.mail18@gmail.com	$2b$12$UYCg5b/kT7nhAtWhLEJjteC1vYLjqOgOXo.PTg7rErQjiE5nBSjN.	2026-04-06 09:20:24.585	https://lh3.googleusercontent.com/a/ACg8ocIUHQXu04RA1-jjXTCysoMru4zFghADo-4fJh3DkzBpXi-HsQ=s96-c	\N	\N	\N	2026-04-06 09:20:24.586	2026-04-06 09:20:24.586	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnmyvc4p0003kz04i0qezemt	Avish Krishna	Jain University 	8123054884	avishkrishna77@gmail.com	$2b$12$BQjuimpwycgv/B1FlA8PYeRwSdqvJkBEuD5Bd4qDldMzVPLoH9LS2	\N	\N	HAVE DONE THIS BEFORE	\N	\N	2026-04-06 09:07:08.713	2026-04-06 11:59:51.945	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnn4zdao0005jp04vqc7yirv	Elvin Prince	St. Josephs College of Commerce 	9353674687	elvin.prince@aksharaenterprises.in	$2b$12$IEvsvtq1p0b6Z5nURwj2Pu9mLNJvroxSO1wJ5WW.t44VtUhA0uLU2	\N	\N	Elvin here	Instagram: prince_elvin26	\N	2026-04-06 11:58:14.544	2026-04-06 12:05:18.249	APPROVED	\N	ELVINOCC	\N	CLUB_HEADER	f	\N	f	\N	\N	\N
cmnmyhrxj0001kz04o9v2wnsg	jeffery sam	SJU	8554321546	Jeff123@gmail.com	$2b$12$jO7fSYn7EVCxQUwg0EUtJ.ONNvsTOGu3/zdYz7vGY5.9I4t92yfhC	\N	\N	hello	Instagram: sdhjutryuiop	\N	2026-04-06 08:56:36.007	2026-04-09 06:15:01.896	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnmsducp0005jx04fw0rzjdb	Shubhanga Venumadhava	Pes	8455750964	shubhanga03@gmail.com	$2b$12$KsRal0I9sWDcPXiUuSSAduMuYOjXH202WkOScPdhh1IOz2IT0uEwG	2026-04-06 06:05:34.824	https://lh3.googleusercontent.com/a/ACg8ocLX4ukiZXvfojkmKdzPpPiReNdOD7AgDhN-tqz-Svl15CLKerw=s96-c	\N	\N	\N	2026-04-06 06:05:34.825	2026-04-10 09:11:05.015	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Instagram	\N	\N
cmnmqwwe20001l704fcndlpxw	SuhasKrishna	Gcu	9663251107	SuhasOffcampusclub@gmail.com	$2b$12$i2JwhiVyjgsjLX4HxkR4z.0The/wyFwxsqVqCL1TnKpDT.1yRUI9.	\N	https://res.cloudinary.com/dbu9z9ija/image/upload/v1775636080/occ/avatars/xilxuox6lae2nrjdb39l.jpg	Hello	Instagram: Suhasocc@gmail.com	\N	2026-04-06 05:24:24.699	2026-04-08 08:14:51.085	APPROVED	cmnlqr8sa0001u7xklay1hj3b	ESPORT	\N	CLUB_HEADER	f	\N	f	\N	\N	\N
cmnlp7mo10005u7qokf9h26km	Fashion	AksharaUniverity	9988778899	fashion@gmail.com	$2b$12$teEQNhwpMf5/khiDwXbJWe7a25xjMh1FCm85mtqhqkGbIfQdqvASu	\N	https://res.cloudinary.com/dbu9z9ija/image/upload/v1775632291/occ/avatars/gcm8wekystl3q26edxj9.webp	Im a Fashion Designer Expert	Instagram: @fashionDesigner	\N	2026-04-05 11:48:59.905	2026-04-08 07:12:00.782	APPROVED	\N	FASHIONGUYS	\N	CLUB_HEADER	f	\N	f	\N	\N	\N
cmniglcfn0008u718ymztkf7y	Sphereboy	bLLA uNIVERSITY	9886551771	spherefulltos@gmail.com	$2b$12$BAAK34LtdZ4uoT8IJpn3veKc7qzvw4XqbeKkBvvkPNPioHPIVWVza	2026-04-09 08:13:25.523	https://res.cloudinary.com/dbu9z9ija/image/upload/v1775428472/occ/avatars/fv7dvl2fpt6qvedjusqo.jpg	haha	Bengaluru	2026	2026-04-03 05:24:24.755	2026-04-10 07:27:13.961	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Instagram	\N	\N
cmnighgle0004u718dt5i4clk	TheIndianBiker	something	9887867199	test@example.com	$2b$10$5c4PC9naEKTbRCyJxTgyIOgM0koLdac9TxmBd3QjS05YskU.VzyO2	\N	https://res.cloudinary.com/dbu9z9ija/image/upload/v1775632181/occ/avatars/rae6yr0naso4h8mekxic.jpg	i have bike , but i dont know to ride	\N	\N	2026-04-03 05:21:23.522	2026-04-09 06:50:35.702	APPROVED	\N	\N	\N	CLUB_HEADER	f	\N	t	Google search	\N	\N
cmnmzipoo000ekz043lnx7r1j	BK Pramukh	PES University	8310452207	bkpramukh11@gmail.com	$2b$12$xTH2YvizC.KJpD7t1KmpF.Yl.giGuQNvnSUzEECoLI.5NH0U7/D1q	\N	\N	I would make this organization run for long term, have trustworthy and effective mentorship	\N	\N	2026-04-06 09:25:19.368	2026-04-06 11:59:51.859	APPROVED	\N	BIKBKM1CI	\N	CLUB_HEADER	f	\N	f	\N	\N	\N
cmnncsuoe0000la04ra0tjff3	VARUN M	Not specified	7319518044	1at24ue082@atria.edu	$2b$12$xZu3rhKHd9pZlhPWtohWi.lOcPhWwlcA2FBi71z1Yb0GC/6K.OHxS	2026-04-06 15:37:07.404	https://lh3.googleusercontent.com/a/ACg8ocJMLzUxq3g8XuwmUB-OvPXy8YvSuScTDDtBELj-syPJYvMbAQ=s96-c	\N	\N	\N	2026-04-06 15:37:07.407	2026-04-06 15:37:07.407	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnncz0xa0001la04ijnjnlaj	Varun Kumar R APT24DEME001	Not specified	8895415278	varunr.24.deme@acharya.ac.in	$2b$12$vZadmx.vrwJN2uLZX7dz3uLX.Lto1hYQFr7PHg9FJizEjsgSPFWme	2026-04-06 15:41:55.437	https://lh3.googleusercontent.com/a/ACg8ocJk5XEMU4mMYc9X6V3wPXY12QuR-IcPGHw8BD8nJPfvrPp_Ew=s96-c	\N	\N	\N	2026-04-06 15:41:55.438	2026-04-06 15:41:55.438	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnnd0zht0004la04zai8gfv8	shet ty	Not specified	8395754661	mahesha0415@gmail.com	$2b$12$9bZskO3J3KJ/B7vpZwAnOObeAbJF/6q0FdIQV0uPNdagJvjfbD6DW	2026-04-06 15:43:26.897	https://lh3.googleusercontent.com/a/ACg8ocKga11APLShovwDifmRm-ePK91N1aTld77ZS9DF9xr7xVW52nrW=s96-c	\N	\N	\N	2026-04-06 15:43:26.898	2026-04-06 15:43:26.898	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnnd2vcz0007la041fe9in72	Leo Das	Not specified	7538421685	leodassss06@gmail.com	$2b$12$Vak26hDwWCQ8LDmhfvkw1.CBUGbxrIpBr1PEjwmnzDYeKu2ozlbv.	2026-04-06 15:44:54.851	https://lh3.googleusercontent.com/a/ACg8ocJOxYnaGSs-el2PGlT7N9snOqvjlhKHyXbIHNYS3Pa5Q2tndQ=s96-c	\N	\N	\N	2026-04-06 15:44:54.852	2026-04-06 15:44:54.852	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnnd9vzi000bla045zz05dyx	Rahul	Unknown College	8296886525	prajwalnb024@gmail.com	$2b$12$pkNoWVNMTpC6BuGvPAAcY.50lELJmM9Vc9ocYa.iNevErVU3..VKK	\N	\N	\N	\N	\N	2026-04-06 15:50:22.255	2026-04-06 15:50:22.255	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnndcowz000cla04udl8xux1	Giri Mani	Not specified	7294182252	girimani400@gmail.com	$2b$12$OoVehQWPfxkE3hSObtRtOOlKjiT/g1fYZ8B/20m2IwxQjoBLu.Q9S	2026-04-06 15:52:33.059	https://lh3.googleusercontent.com/a/ACg8ocLNzpSCvD7AfQQTFAsTCmUxBXgb37NgX0sJ3M1AnlptK5MlNg=s96-c	\N	\N	\N	2026-04-06 15:52:33.06	2026-04-06 15:52:33.06	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnndsonh0000js04ev8lv2lr	Govind Ravi	Not specified	9669244748	ravigovind884@gmail.com	$2b$12$.Qn912oYSd.2qRHx5d.TVOGuBTlD5i.DwvmzD2jIHDO8lAcfa8xCO	2026-04-06 16:04:59.213	https://lh3.googleusercontent.com/a/ACg8ocIErXJn1Cm3GkQGWaJg5_ZQwQeb4B61b1ZnU2w-tvP7fGOKaw=s96-c	\N	\N	\N	2026-04-06 16:04:59.214	2026-04-06 16:04:59.214	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnnepkgb0000i404n3ticork	Nithin D	Not specified	6817437917	nithu210306@gmail.com	$2b$12$AeIbuBuAes5BJtaRZMZiceqaV/BrTl.0pjOrT0nIcbsmNDd2m1ggO	2026-04-06 16:30:33.418	https://lh3.googleusercontent.com/a/ACg8ocKiG1Cd7lj5BxPYbKpUL1hYWF9wzu7bsdv5Ww9n1YDdRqP-Tg=s96-c	\N	\N	\N	2026-04-06 16:30:33.419	2026-04-06 16:30:33.419	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnnf8r2a0003js04igvv8xt0	mahesh a	Unknown College	6362409209	mahesha0416@gmail.com	$2b$12$CfIzqZR6FosGvRm0QLdiVOIIngu1YSVRr3BJ9Y09J3Rv9uu9hMgbG	\N	\N	\N	\N	\N	2026-04-06 16:45:28.45	2026-04-06 16:45:28.45	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	f	\N	\N	\N
cmnnfaau10007js04koqnohvg	Anirudh gowda bc	Unknown College	8310206315	anirudhcgowda@gmail.com	$2b$12$pGdelwV0oDgLiWJuTYay5u5N2CjxBP1fJxcqspKVLOGlO27a3q1xm	\N	\N	\N	\N	\N	2026-04-06 16:46:40.729	2026-04-06 16:46:40.729	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	f	\N	\N	\N
cmnnfdjn1000ajs042ouz86ci	Harsha vardhan	Unknown College	7013400040	harshavardhanreddylokireddy@gmail.com	$2b$12$bE3xyBLRMP6uxGatd4tpR.ctSi8CjqmGiL/R9vBsEam96VPpe.n/e	\N	\N	\N	\N	\N	2026-04-06 16:49:12.11	2026-04-06 16:49:12.11	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	f	\N	\N	\N
cmnnfgg51000bjs04cq014frr	Mamathi Venugopal	Not specified	7022597320	mamathivenugopal@gmail.com	$2b$12$33m6KeL6n56ewKlZTI/E3.IMYDo9aX4NEPwzkZj9BCCfLsBDzo5V2	2026-04-06 16:51:27.541	https://lh3.googleusercontent.com/a/ACg8ocJIqtRaZp4VaMQdbanY-iqpJH8BEGtuct7GYv2yR-B3NPquRA=s96-c	\N	\N	\N	2026-04-06 16:51:27.542	2026-04-06 17:39:57.503	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmno3g7c40000u7o8zz5rvo78	Info Kentzhealthcare	Not specified	8236786210	infokentzhealthcare@gmail.com	$2b$12$dEMu6NB5Ife8YnNX0yUWEe3YQ9kSTLctPg2YnUGe1BxJBkPRSo9GG	2026-04-07 04:03:06.91	https://lh3.googleusercontent.com/a/ACg8ocJTLXW9_ADRzjjHdMOHNR_MfASYQoWia3y9ldYj1DaeHGCzxA=s96-c	\N	\N	\N	2026-04-07 04:03:06.913	2026-04-07 04:08:00.494	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Instagram	\N	\N
cmno59j680000l404vxk82nkn	Nandyala Jishnu 21BAI1625	Not specified	8195754695	nandyala.jishnu2021@vitstudent.ac.in	$2b$12$63isQW2Yb268Tr3dtv2EzeGmzKwQsh.WPAZ.qvtrUDqM3Dzc4kauW	2026-04-07 04:53:54.896	https://lh3.googleusercontent.com/a/ACg8ocKu9QAy2KcnB27DmN6c5doxU1AMaujX416hhtEr7LHnG9SQgw=s96-c	\N	\N	\N	2026-04-07 04:53:54.897	2026-04-07 04:53:54.897	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmno5ve4t0001lj05iszt7inf	Chaithanya	Not specified	6363125013	ammuammukutty744@gmail.com	$2b$12$3u7p5xc0eRGFNE0lYKPT1e3Qxg4OFsAuSk6DDrsflQogFACoAmveO	2026-04-07 05:10:54.797	https://lh3.googleusercontent.com/a/ACg8ocJf_LmYkk1TxNCF0cJ53eF1PPEeznsyuU2pdwT8_0L-sAHiUOQ6=s96-c	\N	\N	\N	2026-04-07 05:10:54.798	2026-04-07 05:13:02.391	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Other	\N	\N
cmno6xrdh0000l7048tj25rck	Ajay Kumar	Not specified	8327992439	ajaykumar0005600@gmail.com	$2b$12$WJvX5n8bv22LEP34xhGzKOelD8NWeKETuXUxn1kKt4FWujqagfOG2	2026-04-07 05:40:44.884	https://lh3.googleusercontent.com/a/ACg8ocKIBvJnKr-Why9zAmnkkSnqxtRQ_V62VaRIyUs3u-Xcj4vhze59=s96-c	\N	\N	\N	2026-04-07 05:40:44.885	2026-04-07 05:41:00.226	APPROVED	\N	\N	\N	STUDENT	f	\N	t	From a friend	\N	\N
cmno6yerz0001l7041qv8iqmf	Jeevith Jeevi	Not specified	8470628036	jeevithjeevi568@gmail.com	$2b$12$TsmtGgetYxP7AbpD6Dw3YOZ12fIPDHJbSC/n8KAoghB2M7H4J1Y3O	2026-04-07 05:41:15.215	https://lh3.googleusercontent.com/a/ACg8ocL4oPvUy8FaeDtxtkoVpyZb9cbHtssLdkcEk71Ap74MHyY3ig=s96-c	\N	\N	\N	2026-04-07 05:41:15.216	2026-04-07 05:41:41.007	APPROVED	\N	\N	\N	STUDENT	f	\N	t	From a friend	\N	\N
cmno77zn30008l7047ff99iwv	Sanath Bhat	Not specified	6053479153	sanathabhat28@gmail.com	$2b$12$7tzymCOvQKikCl5uPyv2F.TNxQ0J.GPo6e0rJzlRdaWp5ODIhQ0em	2026-04-07 05:48:42.158	https://lh3.googleusercontent.com/a/ACg8ocJh0Q_bUVqimM8YNJjAWkodkn0D9SQqTrxMw0SmeN88uYemvwF2=s96-c	\N	\N	\N	2026-04-07 05:48:42.159	2026-04-07 05:48:57.426	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Instagram	\N	\N
cmno7mj8t0000ju0482csufkn	BharathKumar	Not specified	8092763599	kumarbharathsg@gmail.com	$2b$12$IGKdf8BythL2jf5HloLMmu/AK821jz01Chn17hYBeJThaIi1ax/G6	2026-04-07 06:00:00.748	https://lh3.googleusercontent.com/a/ACg8ocI4dZv6gzKGluLYh5t1ZkCxoehXkdF3CixPw5rENTAmpF9x-w=s96-c	\N	\N	\N	2026-04-07 06:00:00.749	2026-04-07 06:00:00.749	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmno8jpty0000l704o0rjetpz	Killer Tharun	Not specified	8408233783	killertharun919@gmail.com	$2b$12$G4TeLfNiIAUGE/riQD4xJOMB8TYqBFd115NfVPotgd8Mq.3PDeyca	2026-04-07 06:25:48.933	https://lh3.googleusercontent.com/a/ACg8ocL8fmEZCtyl5ZkWMdX3Tp4a1vW_ZEh2q09Llu7C-X4j0yNaBkIx=s96-c	\N	\N	\N	2026-04-07 06:25:48.934	2026-04-07 06:26:01.012	APPROVED	\N	\N	\N	STUDENT	f	\N	t	From a friend	\N	\N
cmno8y59c0000jp0485ibv2jl	Tarun Suresh	Not specified	9946881833	tarunsuresh18@gmail.com	$2b$12$slTsRGPlmRre2JLCvbLpHuNrxPga2YAKyqXkzyPS/zJb9kVQVv1LO	2026-04-07 06:37:02.111	https://lh3.googleusercontent.com/a/ACg8ocK60OdNLKWH7dKwLNi5uZYC_m0IrC4-_nIswvy6QXuZD4EGRQ=s96-c	\N	\N	\N	2026-04-07 06:37:02.113	2026-04-07 06:37:15.16	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Instagram	\N	\N
cmno6dlbj0000i5048wzcgi92	Surya	AKSHARA	8346075183	suryas.sec.official@gmail.com	$2b$12$zgfiKYcRTuG79/jH4ERUTu8BmK7YRuJQOJ7yOPPzSJmsHr18kuY.2	2026-04-07 05:25:03.918	https://res.cloudinary.com/dbu9z9ija/image/upload/v1775794831/occ/avatars/mmtlbc1ouzceen05dize.jpg	\N	\N	\N	2026-04-07 05:25:03.919	2026-04-10 07:53:00.505	APPROVED	\N	\N	cmnr3197o0001l804imwja3wr	STUDENT	f	\N	t	Instagram	\N	\N
cmno5uxkf0000lj058iik9dy5	Reshot Official01	Not specified	7981893279	reshotofficial01@gmail.com	$2b$12$ntBmlKeFQZwZKF41111Kt.vRP68QAmujZNsAiM6QaNKL1fSIAPTjG	2026-04-07 05:10:33.326	https://lh3.googleusercontent.com/a/ACg8ocLT4w2hSqjNQw0Rcyi1htKLLgg-gZ8iA7IgNwr3AeXl416k7wo=s96-c	\N	\N	\N	2026-04-07 05:10:33.327	2026-04-08 08:08:31.571	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Instagram	\N	\N
cmno92z3d0000la04z08emgfq	syed harris	Not specified	8636447753	syedharris1312@gmail.com	$2b$12$MJAgpgyVnxGGd.EizO9zX.8nY4SfGTw53hTW0OEThO8qcc71EZw4q	2026-04-07 06:40:47.4	https://lh3.googleusercontent.com/a/ACg8ocIMoardTQrK08F412P8y2QOVlNKXm1uw68U0CFOc5_5vA4IRKA=s96-c	\N	\N	\N	2026-04-07 06:40:47.401	2026-04-07 06:41:05.028	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Instagram	\N	\N
cmno9d1o70001l204afmxodsn	Sevanth bm	Unknown College	8618377322	sevanth8377@gmail.com	$2b$12$w9ikJ1grF6qAKvLOFB9J9eI4afLdbMYqpmotGtcIB0O32FhqmnF1W	\N	\N	\N	\N	\N	2026-04-07 06:48:37.303	2026-04-07 06:48:37.303	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Email registration	\N	\N
cmnoa31rv0000l404r5shyot7	Benjamin Arakkal	Not specified	8907715014	benjaminarakkal10@gmail.com	$2b$12$Ea8lnw1MWLNz0zZvlNhlIOhGkyqYIS25zPtdMM95hp7zi/BvjPsVe	2026-04-07 07:08:50.49	https://lh3.googleusercontent.com/a/ACg8ocKnA7JDJevRVAKEghxWKfiVZFvIRi48PVuoGWl_QFWgDB0cug=s96-c	\N	\N	\N	2026-04-07 07:08:50.492	2026-04-07 07:09:25.782	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Instagram	\N	\N
cmnpmu9mt0009i80420fwp8f7	Madeeha parveen	Unknown College	9632001134	madeehaparveen0@gmail.com	$2b$12$TyIELg79nIW7i8JjIFB93eXzThxS5fVFzYS4lVVFOp3fDktKtmGeW	\N	\N	\N	\N	\N	2026-04-08 05:53:41.957	2026-04-08 05:53:41.957	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Email registration	\N	\N
cmnoby71o0000l4040rvnsohr	Nithin Gowda	Not specified	7247819824	nithingowda2006417@gmail.com	$2b$12$0/AgOIaV6Z01RulIiqQ5Au.Y5Del04UqjPg3xiVFGGD7vjY00k/4y	2026-04-07 08:01:03.276	https://lh3.googleusercontent.com/a/ACg8ocKx-YZq5xJvCJGvTRiingE2jbITjcVaZe5Io_GvSVNAh3ez9JU=s96-c	\N	\N	\N	2026-04-07 08:01:03.277	2026-04-07 08:01:33.086	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	From a friend	\N	\N
cmnodphsh0000l104ppmfxjos	Tanvi Vishwanath	Not specified	7112235788	tanvitvh@gmail.com	$2b$12$KlT41bM2vzdCJ8Gzkl5QAex7v5PlECgnMeGDz1p7kmGSuM6CjXmlW	2026-04-07 08:50:16.528	https://lh3.googleusercontent.com/a/ACg8ocJgJud3DqRC4P1xF9mqHP36TTuRx2qF-8VOPc3NJPeLogttWw=s96-c	\N	\N	\N	2026-04-07 08:50:16.529	2026-04-07 08:50:29.76	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Instagram	\N	\N
cmnof8b8l0000js045whsc481	red_kingdom_ 333	Not specified	7662331315	shoaibrrr9@gmail.com	$2b$12$rwrG4T69eiJM4IvD/37VvOMM40KGmTSG8w/bTTSxjoSNImE9tS07m	2026-04-07 09:32:54.116	https://lh3.googleusercontent.com/a/ACg8ocI5nZjqS3bxrTwE_FJLuU7IGUvOElHUpjn7BOXClxLegfRf0g=s96-c	\N	\N	\N	2026-04-07 09:32:54.117	2026-04-07 09:33:25.243	APPROVED	\N	\N	\N	STUDENT	f	\N	t	From a friend	\N	\N
cmnokf7290000kw04wa7uefg4	Rahul Naik v	Not specified	9840022375	rahulnaikv546@gmail.com	$2b$12$7MdDCB9Xix6kWcecd3BX1.VSZyWu74sLBdLBKf2mZcjyKiMFgk9ZS	2026-04-07 11:58:13.376	https://lh3.googleusercontent.com/a/ACg8ocL1K-NCbgvFvRsq5ANafo5-2eKtoZT5e4eSbyODUAX-px5dIw=s96-c	\N	\N	\N	2026-04-07 11:58:13.378	2026-04-07 11:58:54.822	APPROVED	\N	\N	\N	STUDENT	f	\N	t	From a friend	\N	\N
cmnokttzp0003jx0467d9g68d	Padmanabha	Not specified	9246789451	padmanabha713@gmail.com	$2b$12$HztaufrTeJdJzhWWTxF20O0EqijPR3PMMLfHUAqqYNMidQSYhVRv2	2026-04-07 12:09:36.276	https://lh3.googleusercontent.com/a/ACg8ocJzns_HdwfO1lwygFTNbfb3l3MUq7TVFldi2gBS2zLJMbmWSw=s96-c	\N	\N	\N	2026-04-07 12:09:36.277	2026-04-07 12:09:48.555	APPROVED	\N	\N	\N	STUDENT	f	\N	t	From a friend	\N	\N
cmnokz4c40004jx0433zfxm1r	Deena Raj	Not specified	6855065687	deenraj040@gmail.com	$2b$12$UxD46FsbokGRxybmqX2MQup21.V6lZcoK5ArUyC192rlB3kN04vmu	2026-04-07 12:13:42.964	https://lh3.googleusercontent.com/a/ACg8ocKf32Xlz-x38ckq_3gAqqUO5mReUuvGpueMU0sZNpsf7Z3mw-0=s96-c	\N	\N	\N	2026-04-07 12:13:42.965	2026-04-07 13:12:36.432	APPROVED	\N	\N	\N	STUDENT	f	\N	t	From a friend	\N	\N
cmnool7ao0000l104yibxmg0d	Anurag	Not specified	7861107379	martinwraith06@gmail.com	$2b$12$PQzKAo539PKxbAiLjB5pAOsse0.hAmJ2odGQQSClD6eEOcWypJoRO	2026-04-07 13:54:52.08	https://lh3.googleusercontent.com/a/ACg8ocKcwoAuWXt_y0HyOW_4jYK5oQ-d1PEN78Mq83cueTxMhQafiA=s96-c	\N	\N	\N	2026-04-07 13:54:52.081	2026-04-07 13:55:10.937	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Other	\N	\N
cmnoqhm7o001rla047j1dnsk5	Sk Roshan Ali	Not specified	7648683329	skroshanali62@gmail.com	$2b$12$UCUxqMksY2QIDURG1.j0QOXII77FTQW.TTSSpgiIRZ1WciOBDQeve	2026-04-07 14:48:04.02	https://lh3.googleusercontent.com/a/ACg8ocKw2bPxFOLMKnuOoL061r-qdjWMPy3DYjxcWibEol0qYIBj-A=s96-c	\N	\N	\N	2026-04-07 14:48:04.021	2026-04-07 14:49:03.575	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	From a friend	\N	\N
cmnopy6gu000xla04t0qvw9hi	Abhishek satish	BMS College of Engineering	9901211348	abhishek.leo2006@gmail.com	$2b$12$mIjK8qj39SZSMCr5Dl/JV.1q/8QNg..tsJxHnWAiaFOR..jiad/am	\N	\N	\N	Bangalore 	\N	2026-04-07 14:32:57.151	2026-04-07 14:39:49.829	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Email registration	\N	\N
cmnopnwl80005la041arwkbo9	Suhaas N	Dayanand sagar	9986369421	masaladose9501@gmail.com	$2b$12$KPIBMvZtJjgAqGQnFep1petuEWfbMz6TmyM6VQxbr8U3REmnc40uW	2026-04-07 14:24:57.787	https://lh3.googleusercontent.com/a/ACg8ocIYZQExWXtTRt-1Fs--2qZWSqIwytM3_UVekE5Wg3KOzJZuzA=s96-c	\N	Banglore	\N	2026-04-07 14:24:57.788	2026-04-07 15:30:28.756	APPROVED	\N	\N	\N	STUDENT	f	\N	t	From a friend	\N	\N
cmnopnp5n0004la04mg1lk58l	Shristi Nayak	Mount Carmel College Autonomous	9591560375	shrinayak06@gmail.com	$2b$12$DWEFz4L0tMbRpsJfHNVrGevfwKxyFDtDoOi6z2iEl5ev0NMMOoAyy	2026-04-07 14:24:48.154	https://lh3.googleusercontent.com/a/ACg8ocJLDByTWZ6fFav2vwNiC4pXWJbpmeNjvpCRQA3xsVyRnMCcx4i2=s96-c	\N	Bengaluru	2027	2026-04-07 14:24:48.156	2026-04-07 14:42:06.435	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Other	\N	\N
cmnopk78z0001l204tjg4xfom	JNANESH N	Not specified	9886117067	njnanesh59@gmail.com	$2b$12$ZOuk5GHqtMvBD035SNCl8.Vs3e0OC1HTAlRl4.Br3jjbozXWvgcW.	2026-04-07 14:22:04.978	https://lh3.googleusercontent.com/a/ACg8ocKH44Y4rBVErIYhjN65zyOf4EiF9aqTnmj9PMRZhHDWNBaRVD2J=s96-c	\N	Bengaluru	\N	2026-04-07 14:22:04.979	2026-04-07 14:32:26.069	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	From a friend	\N	\N
cmnooui3d0007l1049eg755uk	Hitesh MS	Dayanada college of engineering	8792596350	hitheshms178@gmail.com	$2b$12$3pOTTORpU8MabqTuXkU46uWHvotmAnDYsrAtg4DzKZcZFc1WQZK.O	2026-04-07 14:02:05.976	https://lh3.googleusercontent.com/a/ACg8ocL4uHiwxKKVZOvsz_G-eFoPMGFSdynH1jY3Zp-TzAhsd-jsG68e=s96-c	\N	Bengaluru Urban	2028	2026-04-07 14:02:05.977	2026-04-07 14:44:23.023	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Instagram	\N	\N
cmnpmt9k80004i804sy53bytz	Dileep V	Not specified	9535697011	pyed7f@gmail.com	$2b$12$xffEM07MMg/57u5AEEazTec55JiDtRpeXulYJZBiH7U0RvrpveniW	2026-04-08 05:52:55.208	https://lh3.googleusercontent.com/a/ACg8ocKktZllNycy9S06eBBcPPfBkIKtEELZXQlv_mdkg7PIX4iWvM4=s96-c	\N	\N	\N	2026-04-08 05:52:55.209	2026-04-08 05:52:55.209	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnpmtkas0006i804eg5y65ii	Sakshi1234	Not specified	7049277695	sakshitakar1234@gmail.com	$2b$12$xk0P03GOK7xb/8SGVK3XBeUgBQQOTSpVd4Y/5SovDJKIY9KQ1IuLe	2026-04-08 05:53:09.123	https://lh3.googleusercontent.com/a/ACg8ocJkDSjHNanyR-YqpEM2sVXGYmgB9opORu5GVOkcRsTluCUf6Q=s96-c	\N	\N	\N	2026-04-08 05:53:09.124	2026-04-08 05:53:54.451	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnpmv93w000ki804hfszlgfw	Bhavani N	Unknown College	7019966504	bnn86031@gmail.com	$2b$12$UdUzyi01urnFRPv.HgFHhuUiVz5F/WrVLfMzGID4/mmB4n98cgGsS	\N	\N	\N	\N	\N	2026-04-08 05:54:27.932	2026-04-08 05:54:27.932	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Email registration	\N	\N
cmnpmutxr000ci804ptp4zbns	Preethu. S	City college jayanagar 	9480464492	ss9097542@gmail.com	$2b$12$hOR7gPUN5o3RZxRoDAnq2.vDeyMZfkgj2po9T4QtPAe6tfUg2jvbq	\N	\N	\N	Bengaluru	\N	2026-04-08 05:54:08.271	2026-04-08 05:55:15.245	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Email registration	\N	\N
cmnk740dd0000ju04hrjxizbw	fazil80883	Unknown College	6586023109	fazil80883@gmail.com	$2b$10$MmoMrGauMnFaXIQb.AVPIeh2xNJDUCKnj1JPZdmtfUzifpFE4RxRC	2026-04-07 11:44:27.155	https://lh3.googleusercontent.com/a/ACg8ocIUIztzVySiUKJHpucX4xPIGl0BftwQdgE6q9eyEIHX_QgrNBQ=s96-c	\N	\N	\N	2026-04-04 10:34:31.778	2026-03-26 08:31:23.255	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Instagram	\N	\N
cmnpmv8sb000ji804yuawurq3	Misha Simra	Unknown College	6361594790	mishasimra09@gmail.com	$2b$12$2EFOJj1z41oXMAMv3SKbx.hzQEK/dI3TO8rctYzcvj07AK13rRg0S	\N	\N	\N	\N	\N	2026-04-08 05:54:27.406	2026-04-08 05:54:27.931	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Email registration	\N	\N
cmnpmvtx2000ri804reljc98v	Apoorva B	Unknown College	9036994376	apoorvab889@gmail.com	$2b$12$9HZkSXAxoEApdSl4YRqDk.yfoHmjMHpyhb7fbKJoogHBB9CTrJG1K	\N	\N	\N	\N	\N	2026-04-08 05:54:54.902	2026-04-08 05:54:54.902	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Email registration	\N	\N
cmnpmwexc000vi804jf5k0kmw	Zahara kouser	Unknown College	7676959208	zaharakouser7@gmail.com	$2b$12$iFFTLbRIafkLNcfAsLxW3.tYdh.1u1Gdw94ZQRJ4IZo3qg/rhyLHi	\N	\N	\N	\N	\N	2026-04-08 05:55:22.128	2026-04-08 05:55:22.444	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Email registration	\N	\N
cmnpmwfg90000l2046nijyeqn	Sudhankumar g	Unknown College	9731125791	sudhankumarg763@gmail.com	$2b$12$EraHuQG1bH/x2yNz4HJuD.uIbZUbb.7XEImyM4WP1LR6eb7lNecO2	\N	\N	\N	\N	\N	2026-04-08 05:55:22.809	2026-04-08 05:55:23.336	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Email registration	\N	\N
cmnpmwyme0007l204fdkk6zqq	Shwetha S K	Unknown College	8088010795	shwethashanthappa1803@gmail.com	$2b$12$FXs1/wiPB7WEkEgrpOoLhuvfB.DzZ4c6BFrgATUwvM5vNmkNIDSM.	\N	\N	\N	\N	\N	2026-04-08 05:55:47.654	2026-04-08 05:55:47.654	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Email registration	\N	\N
cmnpmxi390009l2042x607c2i	Dileep V	Unknown College	9353348535	vdileep036@gmail.com	$2b$12$6W84xtgxa4ruZ4emaT1YcOVPGq4K3fY/WqSwm3q3mdUMYEtitIhDq	\N	\N	\N	\N	\N	2026-04-08 05:56:12.885	2026-04-08 05:56:13.187	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Email registration	\N	\N
cmnpn7s7m000kl204r8mea5xb	meghashree V	Unknown College	7892273243	meghashreev86@gmail.com	$2b$12$uMwBTDXKRFUVi5xY1d1h3OyWIMaUSWC1gdzo1JTcebyUgWd09iQIK	\N	\N	\N	\N	\N	2026-04-08 06:04:12.563	2026-04-08 06:04:12.563	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Email registration	\N	\N
cmnpo08j70000jr04h61ingzm	Kruthika	Not specified	7204871274	kruthikargowda142@gmail.com	$2b$12$Y.0TopnvgsabBgQRfS7wqudTYm.XoGrJplDI4kbyoVHZFtjk/Eb7S	2026-04-08 06:26:20.082	https://lh3.googleusercontent.com/a/ACg8ocKP_WxIY_CaJztVrxZCRf6jlJ-DaRvQuFiOXhTZNp5AS8xfag=s96-c	\N	\N	\N	2026-04-08 06:26:20.083	2026-04-08 06:26:59.522	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Other	\N	\N
cmnpo65x80003jr041jlndrgh	Pragna P	Not specified	7760672357	pragnabharadwaj1610@gmail.com	$2b$12$hH6amNOZlJNd.tZZKYjci.J0STJ8I3AkuufKHK0J2mrU.p/29y7dW	2026-04-08 06:30:56.635	https://lh3.googleusercontent.com/a/ACg8ocLoW6WJD9eSwXmauFtt8FgL6q-CZWdFwt5qWVoy2tl5E292XcIFrQ=s96-c	\N	\N	\N	2026-04-08 06:30:56.636	2026-04-08 06:31:32.082	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Other	\N	\N
cmnppb2z0000gl104psm1vo0h	Rashmi	Not specified	8296894723	racchur546@gmail.com	$2b$12$VmNyc9l1twpbcdAaakKFtesQUDl4Xdt/39CLiQXAPTcA0CItD9DB.	2026-04-08 07:02:45.708	https://lh3.googleusercontent.com/a/ACg8ocK0Jfashh3v3tqqfrOEFkKtIc2A9NpkDB_YYZ3XPOJrlHP90v57=s96-c	\N	\N	\N	2026-04-08 07:02:45.709	2026-04-08 07:04:30.585	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Other	\N	\N
cmnpokq290000l104vahy7i31	Bise gowda	Not specified	8479851697	bisegowda196@gmail.com	$2b$12$a9G7uAixwIWDFvY8WJlriOVhzhtAKqcKiL4bTft1qnc55IX/NJwbK	2026-04-08 06:42:15.921	https://lh3.googleusercontent.com/a/ACg8ocLDsUmLqbafWR-Zew4RI7i_2geABBhNzcFzhWWf1Fz5Ru8SKmc=s96-c	\N	\N	\N	2026-04-08 06:42:15.922	2026-04-08 06:43:48.795	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Other	\N	\N
cmnpoq0wz0003l1042j93i1v4	Aneesh S	Not specified	9729600437	s9520116@gmail.com	$2b$12$Bkz3AcQZrM0exZEqN3ji4Oz6Pu186quAj.8qr.RE2R2x3XiZoH48i	2026-04-08 06:46:23.266	https://lh3.googleusercontent.com/a/ACg8ocIzgq7w7kiJQ1BVJSUiVEvBnh0mtoYnty7zwmJOKTbuf3m9fzbM=s96-c	\N	\N	\N	2026-04-08 06:46:23.267	2026-04-08 06:46:29.684	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Other	\N	\N
cmnpot7ln0004l104f0fk78ih	Nisarga C	Not specified	9000189149	nisarga55c@gmail.com	$2b$12$.ckHeLqjdeoTveoEgdaKJulSEBKJF2BEMxq8B/pod.kRJhRAFOfSO	2026-04-08 06:48:51.899	https://lh3.googleusercontent.com/a/ACg8ocJqpzekcAw282uhbLcwXCdWApCs2Hp_iZZ6m5lZzqx-fYehlDc=s96-c	\N	\N	\N	2026-04-08 06:48:51.9	2026-04-08 06:49:00.641	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Other	\N	\N
cmnpp2m9z0005l104i8wndoom	Sudarshan G	Not specified	7087643793	sudarshansupreth@gmail.com	$2b$12$GKlMutPJ3Q4Hw1fxnsj82u/huNN1H16qx.7o3pCFnkFea/TrsFpJ6	2026-04-08 06:56:10.823	https://lh3.googleusercontent.com/a/ACg8ocJtp5e_FknCMhMGf2bpKduWYsHHKXSP2ig4wNoCLtqBzocYrqvh=s96-c	\N	\N	\N	2026-04-08 06:56:10.824	2026-04-08 06:57:01.5	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Other	\N	\N
cmnppqqea0017l104pcv6a8ue	Lakshmi	Not specified	9663529976	lakshmi75744@gmail.com	$2b$12$i.7LoxzmnUKwCZ3hmt8q.uzdX5PdUygmVKmFlsVrRrr/jPlL3eIlm	2026-04-08 07:14:55.905	https://lh3.googleusercontent.com/a/ACg8ocK4OfzXrtCEIGmGMU8Sqi0wZFvw9DV8gIOKxr2z8HTi0ANm3g=s96-c	\N	\N	\N	2026-04-08 07:14:55.906	2026-04-08 07:15:47.745	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Other	\N	\N
cmnppesjx000pl104x549yh1r	Spoorthi M	Not specified	9019830299	sm1265231@gmail.com	$2b$12$aKHPd.q.1utA6S9he/CuZOL6RdaQLE4MdiD6Zd8TqILcTMPkWvQqW	2026-04-08 07:05:38.828	https://lh3.googleusercontent.com/a/ACg8ocLNKWjYrw_yvc8E8QtqAUXywiVqeAfiNa9tr0Kj2xHfO2b4Xm0tXw=s96-c	\N	\N	\N	2026-04-08 07:05:38.829	2026-04-08 07:06:34.47	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Other	\N	\N
cmnpsgjg80000js040sr75m8v	Aishu Gururaj	Not specified	8371600159	lakshmiag08@gmail.com	$2b$12$kQTmwp4LCBAeOV30aizmMuMDebGqw2prgAF7Ul3StCeogLS3bjGzq	2026-04-08 08:30:59.191	https://lh3.googleusercontent.com/a/ACg8ocKAwsk3Osqikqy4sBsdmoG_rjPsas7HK1lbt8etEPTtib1718VD=s96-c	\N	\N	\N	2026-04-08 08:30:59.192	2026-04-08 08:31:13.172	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Instagram	\N	\N
cmnppmg590010l1041iaj5q43	Deepa Chandra	Not specified	9950629527	deepachandra2911@gmail.com	$2b$12$vhWmwzRLw7/IRuVjAnpP8ePrpVO8SSbHJya7LsLwdCEbFWIJpRgUS	2026-04-08 07:11:35.996	https://lh3.googleusercontent.com/a/ACg8ocI8LMpvz8CtnmE81vcT0VetulKs3EXeBjR48XQ5D-TLHkFjig=s96-c	\N	\N	\N	2026-04-08 07:11:35.997	2026-04-08 07:12:10.911	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Other	\N	\N
cmnpxa4ie0000l7040q11y67j	NAYAN GAMING	Not specified	8832573266	vijayalaxmibiradar55@gmail.com	$2b$12$FXq6hevW6SGy3UYh02fwiuMrhRHG3fhv.KrKR2vWlq/USjRoUd..u	2026-04-08 10:45:57.973	https://lh3.googleusercontent.com/a/ACg8ocI8rkAkqwxYyW7OpVlY2eUx-svdzqaGsI2z1TTtrrtkzQvzAzbH=s96-c	\N	\N	\N	2026-04-08 10:45:57.974	2026-04-08 10:46:14.677	APPROVED	\N	\N	\N	STUDENT	f	\N	t	From a friend	\N	\N
cmnpz23ng0001ju048p4qjc82	PAVAN KUMAR S	Unknown College	8310289194	ppks15176@gmail.com	$2b$12$Bs8U.68L6pxl1kVgbRL2BescIBhAQjHN7qEblo6hlNUcVWL4nv52y	\N	\N	\N	\N	\N	2026-04-08 11:35:42.844	2026-04-08 11:35:43.45	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Email registration	\N	\N
cmnq5enhp0000ky0491y0521w	Raju	PES	6662400131	kanthara125@gmail.com	$2b$12$ajwpxdyc0WFCozY6MmBZc..XPxn3DmeVGYRLKlNA/AewJUnJ2K1.C	2026-04-08 14:33:26.124	https://lh3.googleusercontent.com/a/ACg8ocI2rPclZwxjk0lC5kApc4ZsEpG12QaMryaQhBFOZ8ClYVrnkg=s96-c	\N	\N	\N	2026-04-08 14:33:26.125	2026-04-08 14:36:28.317	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Instagram	\N	\N
cmn4i6c7o0000jfvwsva02o1k	adminocc	Migrated from Railway	+9198765100000	adminocc@gmail.com	$2b$10$U//VbDQs/Q6/SgsymgiY6.rHzcIiLz7RyEDUjkS.MJbvv6HpOh8m6	\N	\N	\N	\N	\N	2026-03-24 10:59:57.396	2026-03-24 10:59:57.396	APPROVED	\N	\N	\N	ADMIN	f	\N	f	\N	\N	\N
cmn5j7dog0000jfl8mvk0x760	jishnu	Migrated from Railway	+9198765100001	jishnu@gmail.com	$2b$10$qKtQcygLobO3B.n9hTcRIuxuv1eeAXKrMU05mTBK9j5lxhTCv7HT6	\N	\N	\N	\N	\N	2026-03-25 04:16:31.744	2026-03-25 04:16:31.744	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmn5nlhja0000jfqws5r637wr	naa	Migrated from Railway	+9198765100002	naa@gmail.com	$2b$10$elQFJsbm/XvQfTgWMQvIQOmt8FWmEX8bgEmWQ3zObjyYBVRy2LlnO	\N	\N	\N	\N	\N	2026-03-25 06:19:28.39	2026-03-25 06:19:28.39	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmn5no5yy0006jfqw6yf7pr98	test	Migrated from Railway	+9198765100003	test@gmail.com	$2b$10$VyvU6sORifqJzl730H/L2OkfFehkWAjCRLrQGv2ggDINdMfgAVgM2	\N	\N	\N	\N	\N	2026-03-25 06:21:33.371	2026-03-25 06:21:33.371	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmn5ogyf10000jflc12yc63eg	test1	Migrated from Railway	+9198765100004	test1@gmail.com	$2b$10$ZuTYWMiDcdD6hEs3W6lhJejc6/nk1IkluHw3naLXbN3GWv832wE9G	\N	\N	\N	\N	\N	2026-03-25 06:43:56.605	2026-03-25 06:43:56.605	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmn5uxe0l0008jf4s4szhxcxq	audit 20260325151440	Migrated from Railway	+9198765100005	audit.20260325151440@example.com	$2b$10$sopSkD6OJyEo1rhwjzLoV.XL0fetBobwUM/VHRgGPx5RpHKtrdy5G	\N	\N	\N	\N	\N	2026-03-25 09:44:41.014	2026-03-25 09:46:50.84	APPROVED	\N	\N	\N	CLUB_HEADER	f	\N	f	\N	\N	\N
cmn5vjhqu0000jf6gh9dojkb0	security audit 20260325153151	Migrated from Railway	+9198765100006	security-audit-20260325153151@example.com	$2b$10$OMUoCRIUk9/ajRC0T/vV8u5S.Rp9uOMlw4SSuHpVzF9x2kJmYIBne	\N	\N	\N	\N	\N	2026-03-25 10:01:52.278	2026-03-25 10:01:52.278	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmn5vk4u50006jf6gds084q8o	security audit 20260325153221	Migrated from Railway	+9198765100007	security-audit-20260325153221@example.com	$2b$10$eOEylHPCU0MPN3Ie2dmPJesIYMu5s2rKnzaM1fcSZ6BqbmsCjwCcO	\N	\N	\N	\N	\N	2026-03-25 10:02:22.205	2026-03-25 10:02:22.205	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmn5xqejy00069u1kzv3p6xop	mahinmanoj48	Migrated from Railway	+9198765100009	mahinmanoj48@gmail.com	$2b$10$omugIquuh4/x17omBWFxHunkqVuOYLNfhlrz1gtAoSzv3QOUVlhaq	\N	\N	\N	\N	\N	2026-03-25 11:03:13.967	2026-03-25 11:03:13.967	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnlll4t00001lb04hfrqrf54	itzsriharishetty	Sapthagiri NPS University 	6366670116	itzsriharishetty@gmail.com	$2b$10$JDwpzuBGHOSDb760mfSpruJiphd3MziVlVOzAV/6xHnINyAALMuNq	\N	\N	\N	Bengaluru 	2028	2026-04-05 10:07:31.476	2026-03-25 13:34:24.612	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmniww0ri0000l804blqeohxx	jayanthshetty168	Not specified	8655544746	jayanthshetty168@gmail.com	$2b$10$ROqet25ujksyhm5lSp/pPOOPNPqKaL1IHicHt82SsakPM9brDdMzq	2026-04-03 13:00:36.701	https://lh3.googleusercontent.com/a/ACg8ocIY5y_OXz9iybV21kSW8iCj2LhkJU0eWqSh7fLM0lBXYX73PQ=s96-c	\N	\N	\N	2026-04-03 13:00:36.702	2026-03-25 14:15:43.859	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnn2zeyx0000lb042rpehfuz	sharvanisubramanya	Unknown College	9148139730	sharvanisubramanya@gmail.com	$2b$10$i7dPPOtJ2ri6UPO9SmF1Ru7XaBKx3zCmdgL.UfX0o8s3IyYcHssEK	\N	\N	\N	\N	\N	2026-04-06 11:02:17.481	2026-03-25 14:40:11.41	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnmvlw0u0000jm047v9ef8cx	tejas s s192406	Not specified	7998833586	tejas.s.s192406@gmail.com	$2b$10$4aiY7Xbwg57WfQ30t4ynQO47YrQXtLOxR5g1gEz8u9EfUby.3Sz2K	2026-04-06 07:35:49.085	https://lh3.googleusercontent.com/a/ACg8ocJ2uS8lPgW5MK3ouVECIj7OXodTW2OclKxC7FQlupy07M9lFQ=s96-c	\N	\N	\N	2026-04-06 07:35:49.086	2026-03-25 14:40:47.913	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmn65qqzu000iap1karlrvtbg	shamithasrao06	Migrated from Railway	+9198765100015	shamithasrao06@gmail.com	$2b$10$3uxr34/uxbhH98Bn1SzgG.WKX5ICYhhafIalLVdL.jn.GcVTUvueK	\N	\N	\N	\N	\N	2026-03-25 14:47:27.018	2026-03-25 14:47:27.018	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnjyamxo0004l504a73snjmq	vamshikattemane	Not specified	7070559832	vamshikattemane@gmail.com	$2b$10$6GGMRJ69gOeEWeyP3s83N.oig99z82iHOeLOd7QgTGby8yb9ppZJ6	2026-04-04 06:27:44.411	https://lh3.googleusercontent.com/a/ACg8ocJwC9Y3aOSiSmmesxcvRKo3W28LP-XN89pEkcNsbpeIo6Y76Q=s96-c	\N	\N	\N	2026-04-04 06:27:44.412	2026-03-25 16:18:29.018	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmn69f0sx0008e11k8owavajz	keerthanayadavan	Migrated from Railway	+9198765100017	keerthanayadavan@gmail.com	$2b$10$AsaCKTapmS.0kB6stooVw.YqfLal5zmq.vIikBxaQE3IlZyyXTBUa	\N	\N	\N	\N	\N	2026-03-25 16:30:18.322	2026-03-25 16:30:18.322	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmn69r586000ge11k5q3vfcix	sinchanavenkatesh07	Migrated from Railway	+9198765100018	sinchanavenkatesh07@gmail.com	$2b$10$8HhrqZpQTMX35f0UQA5/jOESWLYblLsM475iL/Sna61Ce0Kdi3ho2	\N	\N	\N	\N	\N	2026-03-25 16:39:43.926	2026-03-25 16:39:43.926	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmn6a1h7j000me11kkqh3g5qs	24suubecs2065	Migrated from Railway	+9198765100019	24suubecs2065@snpsu.edu.in	$2b$10$s/bTmYzl3fR5Z7vXepteXeiu3JTTnT4nFEZHkD6dK1eDsa9YfIxGW	\N	\N	\N	\N	\N	2026-03-25 16:47:46.016	2026-03-25 16:47:46.016	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmn6at5yw0010e11keyk0bij4	manasasudhan55	Migrated from Railway	+9198765100020	manasasudhan55@gmail.com	$2b$10$NUSBJwjy07s.6HX9tgEGDuKYvhRsR1Hu7Akto/7nsc6U4j./Bf6uC	\N	\N	\N	\N	\N	2026-03-25 17:09:17.817	2026-03-25 17:09:17.817	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnmlv9zf0000k004tkasgqor	meghanamithyanth	Not specified	8197622843	meghanamithyanth@gmail.com	$2b$10$W9RtBel49wLKOB9bfl2BvO/p4WRuFZ.vjSNd98jKWGlbIjdYGpAmW	2026-04-06 03:03:10.92	https://lh3.googleusercontent.com/a/ACg8ocK5DiZ82Bovg3I3ltyqdT8jpVf7BswpkT438mmbFlS45IJQpg=s96-c	\N	\N	\N	2026-04-06 03:03:10.922	2026-03-26 04:45:36.71	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmn73n00q00008o1kht95ixq7	fazil9113201968	Migrated from Railway	+9198765100022	fazil9113201968@gmail.com	$2b$10$mlUIvEdd46Tv7GtsDnUeo.aHXRGz1B6l/5KsalfiIVYs8b72YH6Im	\N	\N	\N	\N	\N	2026-03-26 06:36:19.034	2026-03-26 06:36:19.034	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmn74cjfv00008u1j4v5wg49j	19cg68sindhu n	Migrated from Railway	+9198765100023	19cg68sindhu.n@gmail.com	$2b$10$yo/t2vk2MImPMQpd8Wh1M.Hn8PKgE930Utruf1zXU.w4KVbDzjFz.	\N	\N	\N	\N	\N	2026-03-26 06:56:10.604	2026-03-26 06:56:10.604	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmn74d1vx000g8u1jul6aa66g	shashankmb93	Migrated from Railway	+9198765100025	shashankmb93@gmail.com	$2b$10$hc5pk3uFk0NuE68zEuZFGeUXqlokENbreyFOG96scfplJz1FtFsE2	\N	\N	\N	\N	\N	2026-03-26 06:56:34.509	2026-03-26 06:56:34.509	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmn74d39y000m8u1j3jxcrq8a	sowjanyahm2135	Migrated from Railway	+9198765100026	sowjanyahm2135@gmail.com	$2b$10$ja3BFYaQcUfas.U.t3dqfuVwQ8atBmzLbM9xWtNqWWwUISkr6X.4C	\N	\N	\N	\N	\N	2026-03-26 06:56:36.311	2026-03-26 06:56:36.311	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmn74dejg000s8u1jre8yoxhl	ruchitharuchi4476	Migrated from Railway	+9198765100027	ruchitharuchi4476@gmail.com	$2b$10$ldBsU3EaWOLu.PpsVPyYmOnwpI.rsB4AXGO608GzXIVTxCSyVg5Ty	\N	\N	\N	\N	\N	2026-03-26 06:56:50.908	2026-03-26 06:56:50.908	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmn74djsd00108u1jag1x4wkg	salechapranjal2002	Migrated from Railway	+9198765100028	salechapranjal2002@gmail.com	$2b$10$772jxN8TIIDglbbfOq8hN.sRLEvgMiQSMVzZ1lmswVOvvHrPecHsC	\N	\N	\N	\N	\N	2026-03-26 06:56:57.709	2026-03-26 06:56:57.709	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmn78ult7000mbc1kjff66atj	testavatar1	Migrated from Railway	+9198765100031	testavatar1@example.com	$2b$10$o2xoxoSQ3LcuzmY.LFS3x.SYzgupVSq5xrmTH/jY16w.LoBuDWS86	\N	\N	\N	\N	\N	2026-03-26 09:02:11.947	2026-03-26 09:02:11.947	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmn79t4q2001cbc1knie0juxt	ji	Migrated from Railway	+9198765100032	ji@gmail.com	$2b$10$eHMCdKzUfIbS.Md/s3GsleOfMV7Gh2LgouL/u90Q1WhOfJcVKiJce	\N	\N	\N	\N	\N	2026-03-26 09:29:02.762	2026-03-26 09:29:02.762	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmn7a71ga0000b01kod0kkob9	Vedanth parmesh70	Migrated from Railway	+9198765100033	Vedanth.parmesh70@gmail.com	$2b$10$ItQrdEiaBfBXaarKE7aMs.sQbdbeZHzEivbpQ6PlUTWmZuidQIE6W	\N	\N	\N	\N	\N	2026-03-26 09:39:51.706	2026-03-26 09:39:51.706	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmn7h969u0000mv2ivfemiok7	gowdajeevan655	Migrated from Railway	+9198765100034	gowdajeevan655@gmail.com	$2b$10$cvwr6G8lIUra/bsSRMb4Meoi7W374Q71Uo2KaEE3ghvCKV3tAp0rq	\N	\N	\N	\N	\N	2026-03-26 12:57:28.578	2026-03-26 12:57:28.578	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmn7hbsfs0008mv2idtcyepvb	jishnu123	Migrated from Railway	+9198765100035	jishnu123@gmail.com	$2b$10$KxrivREjOn0DAdKBqi5fLeMqNsLlcvjZ99SWDvtmCWhNRKalwBoqi	\N	\N	\N	\N	\N	2026-03-26 12:59:30.617	2026-03-26 12:59:30.617	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmn7ih5b7000imv2ik1y8abt0	chayakirans	Migrated from Railway	+9198765100036	chayakirans@gmail.com	$2b$10$u0GhOEXk4KtSJH854PIC6OvZftb6PFc4iQpe2c/0qg9Fbf9ElGf1e	\N	\N	\N	\N	\N	2026-03-26 13:31:40.196	2026-03-26 13:31:40.196	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnjyqnul0000l8042ouibe2y	suhaskrishna749	Unknown College	8833570579	suhaskrishna749@gmail.com	$2b$10$.uObszh37.pZZls4djX8QOydf1o83qTKEZdNuUs58m7OMDF54M1GO	\N	\N	\N	\N	\N	2026-04-04 06:40:12.093	2026-03-26 14:36:46.195	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmn7l4ax1000umv2iov4vglco	janhavi5906	Migrated from Railway	+9198765100038	janhavi5906@gmail.com	$2b$10$8Asb3g6PWWjsIT4DdZk9l.axiHqt5PJVxtgnbhbXIbFwVYjyTNNsK	\N	\N	\N	\N	\N	2026-03-26 14:45:39.782	2026-03-26 14:45:39.782	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmna3p5ve0008bh1kxo5m0k2u	testuser debug	Migrated from Railway	+9198765100039	testuser_debug@gmail.com	$2b$10$wC08ADuXTjABIPJ2a.KjGOCBjq/EB4yl769yMOQy5dCOFL1NP8Sw.	\N	\N	\N	\N	\N	2026-03-28 09:01:18.458	2026-03-28 09:01:18.458	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmna3ploo000ebh1kxp9sopz2	testuser debug2	Migrated from Railway	+9198765100040	testuser_debug2@gmail.com	$2b$10$0mww0m/3em8Lh9gxzNHegemmfljndVEOIcH3eO62rOVZ1UmaJFJQq	\N	\N	\N	\N	\N	2026-03-28 09:01:38.952	2026-03-28 09:01:38.952	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmn74co2n00068u1j5hsp2k94	bhoomikarampura	Global institute of management sciences	+9198765100024	bhoomikarampura@gmail.com	$2b$10$BShnyg34kihYx0FMpFOnleYW.OAklMga9Ojz9hH5oPSgyCRFS01Ym	\N	\N	\N	\N	\N	2026-03-26 06:56:16.608	2026-04-10 05:36:35.295	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmna3sfud000kbh1k1crighee	new testuser 13	Migrated from Railway	+9198765100041	new_testuser_13@gmail.com	$2b$10$fbZUroSzW4V3djiD1ojayen7BM8jNRZnwAJFOQ0shL3CNqsfGbMpK	\N	\N	\N	\N	\N	2026-03-28 09:03:51.349	2026-03-28 09:03:51.349	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmna3zfjf000sbh1kligymchw	adil	Migrated from Railway	+9198765100042	adil@test.com	$2b$10$IBSWpITuz1UWet37XnizqeXBYiIIimUmGmUm.xQIQxwX.bKQw1o.y	\N	\N	\N	\N	\N	2026-03-28 09:09:17.548	2026-03-28 09:09:17.548	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmna48pkg000ybh1kio1fns6s	fazil90992	Migrated from Railway	+9198765100043	fazil90992@gmail.com	$2b$10$a0W49MFZrVnM6ekRuWVgoOE6Gqb1o2G47VocZnp8QHRQYMRT8eH0i	\N	\N	\N	\N	\N	2026-03-28 09:16:30.448	2026-03-28 09:16:30.448	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmna4mylw001abh1kdv6v7o5a	mehatajhatti	Migrated from Railway	+9198765100044	mehatajhatti@gmail.com	$2b$10$NBuUMJ41AGVsncuZrw1CYeTNGv3PnjHO2BWHzity.GF.W2UJknNJi	\N	\N	\N	\N	\N	2026-03-28 09:27:35.348	2026-03-28 09:27:35.348	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmna97hdy00029k1k6th9aasl	mohammadfazilf425	Migrated from Railway	+9198765100045	mohammadfazilf425@gmail.com	$2b$10$OjI4k.8kVHUAudFwD9beuO4PN6YGA4aHvvKIQLy4SCuB1rMhLkRh.	\N	\N	\N	\N	\N	2026-03-28 11:35:31.27	2026-03-28 11:35:31.27	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnaa2hzz00087s1k4khxlc7a	madiha	Migrated from Railway	+9198765100046	madiha@gmail.com	$2b$10$83oiR4kRUQB9iUMvY7tNZ.jeNqdF9JvesUNO3nPt4iCugvY9ML236	\N	\N	\N	\N	\N	2026-03-28 11:59:38.399	2026-03-28 11:59:38.399	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr1fdi90000jy04x7jbc0ww	Jeevitha Prabhakara	Ssmrv	9856642848	jeevithaprabhakara51@gmail.com	$2b$12$DbRCmO.JJTVmFLHEkzFPOOGcO0bvhurbBBHm7o8TzURhta.VOO1yy	2026-04-09 05:29:47.553	https://lh3.googleusercontent.com/a/ACg8ocLKcqW13k1QpLojeO7cBTneB3NiJqhwegfgSVzm7z_EuYMZdw=s96-c	\N	\N	\N	2026-04-09 05:29:47.554	2026-04-09 05:30:04.854	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1fi6j0001jy049arsk7ww	Muhammed Muhafiz	SSMRV college	7296355627	maxx8172@gmail.com	$2b$12$4uSt.asGyQBWxrWujuPpQ.bCv8/anfQLGfGcCLs2FQXf9U9ygyiCO	2026-04-09 05:29:53.61	https://lh3.googleusercontent.com/a/ACg8ocLju5lh7C8ih0vVKbRCeB5rpD0HJpqpnzbgKHOUxfY2AJomFPIP=s96-c	\N	\N	\N	2026-04-09 05:29:53.611	2026-04-09 05:30:23.65	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1fm7m0003jy04wmfy0e21	sai akshatha	SSMRV college	6778559198	sai.akshatha123@gmail.com	$2b$12$Erx5yJUgLLPPnhAyJn1f/ORazl08xIajrRaK3bSRtuCOV0d9yqD2y	2026-04-09 05:29:58.833	https://lh3.googleusercontent.com/a/ACg8ocKb36A25WEXDP9kr3dv_THeURJ9TslG1WXpoQJgkVwu0ZRJ4Q=s96-c	\N	\N	\N	2026-04-09 05:29:58.834	2026-04-09 05:30:28.609	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1fjdi0002jy04mlgbzojm	Ayyan Hadfa	Ssmrv	8807887091	ayyanhadfa0@gmail.com	$2b$12$Xb49Y1y9iWwqikFP6rGutuvdd2rcU583r5CpAJOZ9QPU6dmz880cS	2026-04-09 05:29:55.157	https://lh3.googleusercontent.com/a/ACg8ocJvtwJ9257lVLRsJu2NMve4n1wST2GgJYNFFjLDqE2h-hkCuA=s96-c	\N	\N	\N	2026-04-09 05:29:55.158	2026-04-09 05:30:30.247	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1foh60004jy04636wp2v5	Owaiz Khan	SSMRV college	9654918956	owaizkhan781@gmail.com	$2b$12$920UvfbLU4yrUPQzTcXlAeFUxJNiZn5ek.rXnBQ62xYLxZ6IdWaju	2026-04-09 05:30:01.769	https://lh3.googleusercontent.com/a/ACg8ocKeGpiP9BhkLrvM3T55W3SfT25TZ2KTxHAANBItmhEvliPEmA=s96-c	\N	\N	\N	2026-04-09 05:30:01.77	2026-04-09 05:30:35.565	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1g6810000lf048ystxdec	Roshan Chand	Ssmrv	8561839816	roshanchand1614@gmail.com	$2b$12$UluIY1QAPomBtqLhzogyH.ou/6WmnMyzrhjBeljKHwtv4B07oL5b.	2026-04-09 05:30:24.768	https://lh3.googleusercontent.com/a/ACg8ocLEEmmoBn0s8OvMxQzeHcWM9bTPGglpx2g4ihMxE-V2tvPnHg=s96-c	\N	\N	\N	2026-04-09 05:30:24.769	2026-04-09 05:30:38.3	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Other	\N	\N
cmnr1fzgu0006jy045b7x4uel	Charan Tej	SSMRV degree college	8411206681	charangs152@gmail.com	$2b$12$zShgdf81XvvXzHbhaGN11eFumjfhUWpJEgutdBHSW3Ke2H6y8g1zS	2026-04-09 05:30:16.014	https://lh3.googleusercontent.com/a/ACg8ocJMq_kCggQl-703UORzwHdNqgMnYcPJ5fthq_9CqoZppqe5ZA=s96-c	\N	\N	\N	2026-04-09 05:30:16.015	2026-04-09 05:30:43.434	APPROVED	\N	\N	\N	STUDENT	f	\N	t	LinkedIn	\N	\N
cmnr1g3uc0007jy04jr1hoxga	Sagar M S	SSMRV COLLEGE	6052742457	sagariyer24@gmail.com	$2b$12$02Zp3yjB71XqooQJCajl3eU8CkmJMVoyZ/wzOR8nFvvHrA1VZSrSe	2026-04-09 05:30:21.683	https://lh3.googleusercontent.com/a/ACg8ocJBeNzcpXYkYORAc7hNrnjt42lLgftTPS7ETOScqu5vs5sCqP0=s96-c	\N	\N	\N	2026-04-09 05:30:21.684	2026-04-09 05:30:46.111	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1gn0x0001lg07lboso8m4	bhoomika p	Not specified	8157340019	bhoomika2705@gmail.com	$2b$12$o3jBc9p8EIZUTAqeGGX6CeedPclPkuXgSrM/nuoHxhzf54926umpq	2026-04-09 05:30:46.545	https://lh3.googleusercontent.com/a/ACg8ocJzHTjbCeow9OlUFliGkl7S_f2S_8E3QXvuVNZ2svNnlZf5W09e=s96-c	\N	\N	\N	2026-04-09 05:30:46.546	2026-04-09 05:30:46.546	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr1gh4k000bjy04khsvu916	Heer Gupta	SSMRV DEGREE COLLEGE	8040190155	heerguptapk2005@gmail.com	$2b$12$MM3kDrsfbDwyeYpt42zBD.Y1Xp2zpqLIH0GrA725KMllNxMHEZLvm	2026-04-09 05:30:38.899	https://lh3.googleusercontent.com/a/ACg8ocLqqZg9eJqbWF5auE0vDnnyKPdwfesa1X9F2qQg-8Xjj0Xh2Q=s96-c	\N	\N	\N	2026-04-09 05:30:38.9	2026-04-09 05:31:03.709	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Instagram	\N	\N
cmnr1g4730008jy04b6gfgced	Dinesh Prajapat	SSMRV	9014469007	dineshprajapat017953blr@gmail.com	$2b$12$pkbzS5mkwRmJJr.Ygy6VoefHtEeubLzIPESN3qAY99gBJhxHpIaM2	2026-04-09 05:30:22.142	https://lh3.googleusercontent.com/a/ACg8ocJpjkx1hFLduQjkNFLZ4u2kK_SLQNXv_8liIl2EjOC3l9leprXp=s96-c	\N	\N	\N	2026-04-09 05:30:22.143	2026-04-09 05:31:09.53	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1gk0b0001lf0415ks6u3j	RAMYA C	SSMRV DEGREE COLLEGE	9556894057	ramyarc41@gmail.com	$2b$12$RoawFuuXuI6Vq2e8zUkmKuKl.aDdLeMxKOSkiFxLS/e9JSEl0sMCG	2026-04-09 05:30:42.634	https://lh3.googleusercontent.com/a/ACg8ocJ7HqWI9LjQBd4HGLvOKgi0MZMDUBEIdeqoj6Uweje3h3mkzg=s96-c	\N	\N	\N	2026-04-09 05:30:42.635	2026-04-09 05:31:09.992	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1g6n20009jy04f4on3v15	pragna Nagesh	SSmrv	8873534112	pragna2004n@gmail.com	$2b$12$uwD0pbszSARuSjN0zwu7ZOjT/OwQjlKNkXjYoNr6zywOZx1CbmUU.	2026-04-09 05:30:25.309	https://lh3.googleusercontent.com/a/ACg8ocLq2QRSD5Lbu1YOl9CIy45GX1EX3bmONZGFfhxJ_jMMHNO9uQ=s96-c	\N	\N	\N	2026-04-09 05:30:25.31	2026-04-09 05:31:10.203	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1ge0p0000lg07vap6ab3p	Punitha D	SSMRV Degree college	8492542279	punithaks164@gmail.com	$2b$12$tmc7doNQ0lNFEA8HNd5Uru/ZjBrAwVKI.cspKsC3EmcsyU9qxNCc6	2026-04-09 05:30:34.872	https://lh3.googleusercontent.com/a/ACg8ocJVG_6Rm-DcDAqIAJJ-n8_L4SNanQJu9VXA_NBIKfSMdOky2a0=s96-c	\N	\N	\N	2026-04-09 05:30:34.873	2026-04-09 05:31:12.312	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1gldl0002lf04hx59sgli	pratibha gehlot	SSMRV Degree College	8258036794	pratibhagehlot.edu2k6@gmail.com	$2b$12$0KA32XKxoHsNzEJEy/f8kO82XIKhKgRkZB0hAfHbr5Iz12.ScsTmu	2026-04-09 05:30:44.409	https://lh3.googleusercontent.com/a/ACg8ocJZAHo6Hhcmc1rtWzPvRY4oXTN6kZ8UQjmZxMIQnURzVcejNrc=s96-c	\N	\N	\N	2026-04-09 05:30:44.41	2026-04-09 05:31:13.318	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1fsfb0005jy04tb0ysg5o	Syed Tousif	SSMRV	6667939352	syedtousif306@gmail.com	$2b$12$boMUNZ6MpGciaEvyJibTaeu2t2EW8RCQaDHAcegYVR1uGM5YYu7Gq	2026-04-09 05:30:06.887	https://lh3.googleusercontent.com/a/ACg8ocJzC17Qr9_JiESYxMeuBBDHlZEt3wvz5bGof-Qi1rLKllNUcw=s96-c	\N	\N	\N	2026-04-09 05:30:06.888	2026-04-09 05:31:13.558	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1gjhz000djy043cacv584	Bhumika NG	SSMRV Bengaluru city university	9053600754	bhumikanv2@gmail.com	$2b$12$Vo8zEkEmbz8qeBiPw01y8Oi0pTxYjeBaD2PKKhItu3Bw3sOZx9frS	2026-04-09 05:30:41.974	https://res.cloudinary.com/dbu9z9ija/image/upload/v1775713885/occ/avatars/sqtwxgn01jb2p4fegqfh.jpg	\N	\N	\N	2026-04-09 05:30:41.976	2026-04-09 05:51:50.36	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Instagram	\N	\N
cmnr1gl17000ejy04p6le7ur3	Zeeshan Pasha	Ssmrv College	6713123269	zeeshanpasha531@gmail.com	$2b$12$XdGP/PzjPPyRLEIWb1e.f.0EYDTH/mYvO3CRh2yY3Jnqcu4yEiX0i	2026-04-09 05:30:43.962	https://lh3.googleusercontent.com/a/ACg8ocL4d1VUqNCpi_9QsmJk_Lp2ebEiVqPymcUjPPxMO90YZxV57RY=s96-c	\N	\N	\N	2026-04-09 05:30:43.963	2026-04-09 05:32:16.395	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Other	\N	\N
cmnr1gnzl0002lg07mgz1b96o	Siri R	Not specified	7875838479	sirirravi167@gmail.com	$2b$12$AinsnunKKmdfW.rUjFjo7.w/pGtQIRbBhfuj0K8zpm1oUrITQohLu	2026-04-09 05:30:47.792	https://lh3.googleusercontent.com/a/ACg8ocJDJD1YXI-glLTSh41UZ5mrv0AsVaGZoS5mhpTS2CPl1nISrQ=s96-c	\N	\N	\N	2026-04-09 05:30:47.793	2026-04-09 05:30:47.793	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr1gokd0003lf045aebsfiw	AKARSH	Not specified	6932980794	akarshm93@gmail.com	$2b$12$MdJWhJibLk9Gusq59VCcTepw2tTUnk3mpUxLhnyqkmURlPOqtiKGy	2026-04-09 05:30:48.54	https://lh3.googleusercontent.com/a/ACg8ocLsoHustflr8f9WXf83ihVsNqxHy3J1BVio0CtnLeTWUW4TweBX=s96-c	\N	\N	\N	2026-04-09 05:30:48.541	2026-04-09 05:30:48.541	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr1ghjz000cjy04t1isht2s	Mohammed Jasir	SSMRV College	8977771549	jasirjmj@gmail.com	$2b$12$xJlaNvDnBUnNf/Ged73oxeIRZcl3Ti5KLb0KyaQr3DU7/473.E2la	2026-04-09 05:30:39.455	https://lh3.googleusercontent.com/a/ACg8ocLRZQ0H31Qf3iap6YwPxlGn_gNMF6vWs0aRgAJz4oofd7hKNT8W=s96-c	\N	\N	\N	2026-04-09 05:30:39.456	2026-04-09 05:31:02.773	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1gxz80004lf04lsaqlcv8	MOHITH GOWDA	Ssmrv	9299262607	mohithg460@gmail.com	$2b$12$gy6UsCTr0JxMuthoS.2jyesBMvL6t0ne8rcsjKqq1UHWWgU7jnlh6	2026-04-09 05:31:00.74	https://lh3.googleusercontent.com/a/ACg8ocKERfjeo4HtVF1hmoj92YRF7A_QBV7L2uPVkdvKsuBU0Z70wjFG=s96-c	\N	\N	\N	2026-04-09 05:31:00.741	2026-04-09 05:31:15.98	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1i16x000clf04y72xmft9	Amith H.B	SSMRV DEGREE COLLEGE	6814480419	amithachu48@gmail.com	$2b$12$h/As/pvjQtANST6mvJEn1uSIn7VHXPEjir3fZRPUlY8F9E9ICzDP6	2026-04-09 05:31:51.561	https://lh3.googleusercontent.com/a/ACg8ocKnU_5MsCNzTkRmJVmGKusLHj67w2sAsMaCqNaEHv4qRUa27w0=s96-c	\N	\N	\N	2026-04-09 05:31:51.562	2026-04-09 05:32:21.565	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1gyeh000fjy04nw078ct6	Charitha Cherry	Not specified	8299165011	charithacherry8088@gmail.com	$2b$12$zzmNVSk60/EvT2U6GHDwD.rq19CjjszYLlGpnj5xu8rAjDkdfaING	2026-04-09 05:31:01.288	https://lh3.googleusercontent.com/a/ACg8ocLprS05iL8JmrVxSYhb_bbGaE7NnMQ-bHaZWVud5NglRNeqM_Uo=s96-c	\N	\N	\N	2026-04-09 05:31:01.289	2026-04-09 05:31:01.289	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr1i0wr000ljy04q0tjb2yc	Ashwini K	SSMRV college	7406908365	ashwinikashu555@gmail.com	$2b$12$JPmtD1oV4uOxxRGlEHuA6u5idIg4WnjIHZ0I7OSKkogBYkDEe2NjW	2026-04-09 05:31:51.194	https://lh3.googleusercontent.com/a/ACg8ocLk2Smx1XQB2YqUBhcAOIWzXwuaFUdXQo_GC3na9Yfb4LBIYg=s96-c	\N	\N	\N	2026-04-09 05:31:51.195	2026-04-09 05:32:31.901	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1h34s000jjy04iopka111	Spandana Sivaprasad	SSMRV	9560409847	spandanasivaprasad@gmail.com	$2b$12$b4onkXdPtCC/NqQ.63UK7up12RgTqiVF0eHDppaOpGGa/xJoUi0U2	2026-04-09 05:31:07.419	https://lh3.googleusercontent.com/a/ACg8ocIz_6wji0W_-LYXz9QCwvVN5LyWpD2Cjwc7KND_VjYt2S8fbA=s96-c	\N	\N	\N	2026-04-09 05:31:07.42	2026-04-09 05:32:34.616	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1h11j000hjy04wuq9u186	Chandana H R	SSMRV college	7930877522	chandanaaishu17@gmail.com	$2b$12$KceM9fqh09Od5BWrCNd0sejnUiDZ4sJLfNfwVAUzo6l7638oUcazS	2026-04-09 05:31:04.71	https://lh3.googleusercontent.com/a/ACg8ocLdXI8u_Wg1x9Sww7M3EWPYVcoiCxBpe1qKPXji38V8QuBi3c6M=s96-c	\N	\N	\N	2026-04-09 05:31:04.711	2026-04-09 05:32:48.697	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1h255000ijy048zsddi68	Pooja M	SSMRV DEGREE COLLEGE	8901248325	pm0554025@gmail.com	$2b$12$4zScnwmUxL3N8zKtS5KA0.DKcraAAGVhoBdJgxK0zmtiHb.ncSOYG	2026-04-09 05:31:06.137	https://lh3.googleusercontent.com/a/ACg8ocJJd_U3lcrkTJXdpOOxd4G3-hGVtE8fEgIKjktrI-eu1AyEtNc=s96-c	\N	\N	\N	2026-04-09 05:31:06.138	2026-04-09 05:32:53.085	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1h5mu0001ml07wdg9oagz	Raghavendra G	SSMRV college	9285919868	raghavendrag237@gmail.com	$2b$12$Cc/1bp.DutVUerMUaZyYpuHdbUEQ4LNZ5AOzgjIXt.a4f0RwCf6Xi	2026-04-09 05:31:10.66	https://lh3.googleusercontent.com/a/ACg8ocI-4XVLqGp6fdRpQTdHAAnLPpj2nhfO64Pv4Xgbu3aDjUqUwgVdpg=s96-c	\N	\N	\N	2026-04-09 05:31:10.662	2026-04-09 05:31:30.959	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1gywo000gjy04e755btwj	Balaji K V	SSMRV COLLEGE	6504426847	balaji1234kv@gmail.com	$2b$12$dhs7uUhN9EIbWb8q/JCI5uYFYbYmk3Ij.h5x94IHVe.21PKaKeTFi	2026-04-09 05:31:01.944	https://lh3.googleusercontent.com/a/ACg8ocJv0dNCNuPHNY2dVCBELTnI7ozEH4SHrgfJyDtHBOMfw9SIpQ=s96-c	\N	\N	\N	2026-04-09 05:31:01.945	2026-04-09 05:31:31.926	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1h5f50000ml07toh9dkss	Roshan Sahani	SSMRV	8988693100	roshanroshan5444@gmail.com	$2b$12$BhWC8ksjw0YvzuoRVDr2U.1T4J.Z7/w8/f4Mqt4jHxG3NvH51hk7a	2026-04-09 05:31:10.385	https://lh3.googleusercontent.com/a/ACg8ocINIgEfcmiVuYZkEGySjrkc170CxWB9ru1wjFMcpbrPM0c8B3hdlA=s96-c	\N	\N	\N	2026-04-09 05:31:10.386	2026-04-09 05:31:34.233	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1hosu0005mv080yeqc9zz	Deekshitha	Not specified	6883332729	deekshithaady@gmail.com	$2b$12$9/Xz0kJwtBuxsRYeLOxfK.KvEzkoPzTJRQaHHiFFCxMQ8xH3en28S	2026-04-09 05:31:35.501	https://lh3.googleusercontent.com/a/ACg8ocLS8LA7X-2FbxxtzI0sEjXqvAmDUX0JINuWHeI4pxmkltB5NA=s96-c	\N	\N	\N	2026-04-09 05:31:35.502	2026-04-09 05:31:35.502	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr1hox5000cml076msqm4nk	Rakshitha R	Not specified	7072315265	rrakshuraveesha7@gmail.com	$2b$12$Q5Vmaqt4KI.OA1u4APJZYuhhyiHjGV/Cd.wbRaod24fF3Btepy4ee	2026-04-09 05:31:35.656	https://lh3.googleusercontent.com/a/ACg8ocLJmWINxF29fRGMhHg-ePk9CkEwvUpgq2KaBizYpn9n13RQbFGd=s96-c	\N	\N	\N	2026-04-09 05:31:35.657	2026-04-09 05:31:35.657	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr1hca90000mv087ypf1y9s	Madan Kumar S	Ssmrv college	7592554540	smadankumar35@gmail.com	$2b$12$uBP16fCNekaZDQVw6txos.Q0RiMeCHpl6PlNUoXAAS4Bpv1BS7UtC	2026-04-09 05:31:19.281	https://lh3.googleusercontent.com/a/ACg8ocJdX9EPQMCu3sMhWKZexbOMr6YdAbScgfWdsoIWASA1Wils5g=s96-c	\N	\N	\N	2026-04-09 05:31:19.282	2026-04-09 05:31:36.64	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1hvij000hml07956ijd52	Dhanalakshmi Kamaraju	Ssmrv	7534948159	dhanalakshmikamaraju952@gmail.com	$2b$12$9rNmqEhnYVOdxYoz4JMLduPlmef3MKRD1SoY3FbHSgSZBXMGw9l4G	2026-04-09 05:31:44.202	https://lh3.googleusercontent.com/a/ACg8ocIa2bdEV0-Ox98A-VqgY2s5MmUP2nu0k899mFuLmexicK1ptWEG=s96-c	\N	\N	\N	2026-04-09 05:31:44.203	2026-04-09 05:34:27.013	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Instagram	\N	\N
cmnr1h7q9000kjy04i3xoj9ql	Prashant .R	SSMRV Degree college	8879145365	prashantranga6925@gmail.com	$2b$12$r7RKODtnmTD52Ux0Es94bu4uzajpMctjsoZoc9uzzuF/F5dlrqQI2	2026-04-09 05:31:13.377	https://lh3.googleusercontent.com/a/ACg8ocINy-OcL5UVFUBhCx7RBttHfdZZAil0iy1EZ9xYqoGfLVZrDA=s96-c	\N	\N	\N	2026-04-09 05:31:13.378	2026-04-09 05:31:40.414	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1hf8t0004ml079lym4g6w	Deepesh M V	SSMRV	8843511597	deepesh.magaji.av@gmail.com	$2b$12$/N8SEELfOsBm0TduwN2hkeWqrCWb1qxffBiHb7ZxUGl6ndxSDQlrC	2026-04-09 05:31:23.116	https://lh3.googleusercontent.com/a/ACg8ocLbfTfiorHc4zTQLpX0Du3tvbKNYVurhvYIwT9GCSjztqEONg=s96-c	\N	\N	\N	2026-04-09 05:31:23.117	2026-04-09 05:31:55.239	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1hnyp000bml07creoaekb	yashaswini	Ssmrv	7992747061	yashaswinivr998@gmail.com	$2b$12$vPC65yVnqH2pnZ1oujZiQuZ5U4cNgI9habOTDbnzkjD7zrYnpSdai	2026-04-09 05:31:34.413	https://lh3.googleusercontent.com/a/ACg8ocIEGSs6tCgB6fKPYTrTk1lVOVuIPMH1St8zJPzhYPcPidc_Qad9=s96-c	\N	\N	\N	2026-04-09 05:31:34.417	2026-04-09 05:31:55.377	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1hhhb0002mv08ntsgijpw	Rakshith Gowda	Ssmrv	7100287859	gowdarakshith334@gmail.com	$2b$12$OG19shexj4Rsk1AX0GVtDu34Yk9B/ntAQgavLJIBU5bDx0c4.c4oW	2026-04-09 05:31:26.014	https://lh3.googleusercontent.com/a/ACg8ocLtAoGVQMifgImx5bFBWgqlYuHVv5_J07W9ncQ5V235fh3QQfc=s96-c	\N	\N	\N	2026-04-09 05:31:26.015	2026-04-09 05:31:56.587	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1hgzd0006ml070d53wgxo	Tanya A	Ssmrv college	6478116633	kkush3995@gmail.com	$2b$12$UpGEnSP9Y3srUEGlSI5p5ekE/5n8pzsVbzatYuYeWJXimCylhnqWi	2026-04-09 05:31:25.368	https://lh3.googleusercontent.com/a/ACg8ocJ5Rfqyqxz2V3yOAbbnWfyNi2lXFno21Osb-0GWy11X3z99x6o=s96-c	\N	\N	\N	2026-04-09 05:31:25.369	2026-04-09 05:31:56.948	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1hofo0004mv08exypjs9t	Pavan U	SSMRV COLLEGE	9703661680	pavan21120056@gmail.com	$2b$12$mOy75ao5UonDhkJw608r9.tqy8cSq6ADc4EkXA5bGryY63tZzUJKO	2026-04-09 05:31:34.953	https://lh3.googleusercontent.com/a/ACg8ocJyDdQhFrOaHn-rRWXNe6rEmh9_ViubCIiAfQbUDIibQgs7ygSV=s96-c	\N	\N	\N	2026-04-09 05:31:34.954	2026-04-09 05:32:00.773	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1hcic0001mv08snri39yc	Syed Fahad	SSMRV COLLEGE	8153757421	syedfahad309@gmail.com	$2b$12$a4VuJsHfx3OOTeu9FK89aOoKCzUXM8.lAwQv6iEIikvE41r12ktk6	2026-04-09 05:31:19.566	https://lh3.googleusercontent.com/a/ACg8ocKvdNOV3UOlMdlMDpCjmm6N5B5EXTmT2PM5bH2cJFL5skG3UJc=s96-c	\N	\N	\N	2026-04-09 05:31:19.568	2026-04-09 05:32:03.776	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1hl880003mv08sayvt2pq	Dhruva_N	Ssmrv college	7849913418	dhruvannssd@gmail.com	$2b$12$CKo9YmzcRrW.sXt7pltYv.pmuwmUrGZuxSAqhHxDTca0DW1YyJo3m	2026-04-09 05:31:30.872	https://lh3.googleusercontent.com/a/ACg8ocLAdSCwh_bYQ2yr1dRIAWXfnhy_lY57jQW06IMt0YbIaXjWfYrW=s96-c	\N	\N	\N	2026-04-09 05:31:30.873	2026-04-09 05:32:19.296	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1hmtu0009ml07p41et20t	Nehal Bandlapalli	Ssmrv	7547786955	nehalbandlapalli2006@gmail.com	$2b$12$nyMnfJ0I34XWYO2Dw1FC4ekJzXrKH265tGt9NiYVKvsl.a9j3BUYS	2026-04-09 05:31:32.944	https://lh3.googleusercontent.com/a/ACg8ocJKFoyACxK-5mmikBmLZ2-uU71NjeO8Wj7JrSH31tWogh4I=s96-c	\N	\N	\N	2026-04-09 05:31:32.946	2026-04-09 05:32:23.224	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1idkm000pjy04k8013wrc	Nanditha Michael	Ssmrv	6504382874	michaelnanditha@gmail.com	$2b$12$WQTZBgFih/NJUWSYPSMFGuMnnBHJeQ2UP9p.tj1YviC3axDjXWKae	2026-04-09 05:32:07.605	https://lh3.googleusercontent.com/a/ACg8ocLAdVR4lOrZ-9RpRlvE8kS_O5fb9IbuSBFT3SmvegEABiCskA=s96-c	\N	\N	\N	2026-04-09 05:32:07.606	2026-04-09 05:32:27.654	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1hqyx000dml07911ky6k2	Vivitha N	SSMRV COLLEGE	8328238085	vivitha.n2005@gmail.com	$2b$12$I.43/qM3gpEduVdfNsPZ8uoK.iPu6QLkYvSDFHG5XPGoaYceIBY1y	2026-04-09 05:31:38.313	https://lh3.googleusercontent.com/a/ACg8ocLSKk6xMROrrxHC3uqP9yBL2OFnCei8aGmUTAemE6srnchIqV4=s96-c	\N	\N	\N	2026-04-09 05:31:38.314	2026-04-09 05:32:35.118	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1i8fq000kml07vkrdlsan	Thrusha R	Ssmrv collage	7337075418	thrushar3@gmail.com	$2b$12$MbdvUe9bCqDOwxB34BKb9.KT7IOh99gjKZf3C/OS77gzmBu/qXsjW	2026-04-09 05:32:00.949	https://lh3.googleusercontent.com/a/ACg8ocLWBAPXDjY5I7XXoLvDHz9XNtca8s-p_MWBFOc4YPEINAbxnKA=s96-c	\N	\N	\N	2026-04-09 05:32:00.951	2026-04-09 05:32:39.893	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1huus000eml07szrhomul	Shailaja Govindraj	SSMRV College	9859555135	shailajagovindraj464@gmail.com	$2b$12$YOmUCQ6.diEG8s8U6/kkHeT5L2Qe4hodXpbDyBz00AvP3Xj9coh2a	2026-04-09 05:31:43.347	https://lh3.googleusercontent.com/a/ACg8ocLHwqeF-Iu_AWT_3xHjU3KMFWhbkpgdK10kjg9Ci4JPQoFPXHs=s96-c	\N	\N	\N	2026-04-09 05:31:43.348	2026-04-09 05:32:57.418	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1hefk0003ml07jcmdubxd	Kishore Kumar m	Ssmrv degree college	7512296672	pool34111@gmail.com	$2b$12$.rC5rSMOqKizCnkVv5Ogau1LPq5Vcw6ljzBWtG4uZlr88FxDhZd/O	2026-04-09 05:31:22.062	https://lh3.googleusercontent.com/a/ACg8ocLfuKc0eepwHnIA5AeMycbq3ExZRLzG38Yw4dx42qJRipIbhA=s96-c	\N	Bangalore	2026	2026-04-09 05:31:22.064	2026-04-09 05:34:04.856	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Other	\N	\N
cmnr1i6zo000mjy043l2nqbf1	Nithesh T	Not specified	6042487362	nithesht.ssmrvpu@gmail.com	$2b$12$rodAM77WnJfVmFW1c7HcHeaqYv/sBSZ1wo06FJwiHzPOe1SXguhTa	2026-04-09 05:31:59.075	https://lh3.googleusercontent.com/a/ACg8ocJu47cjABp00r6M8vr-M-YX1KMqM44_bLJwNwiU-903o02AoQ=s96-c	\N	\N	\N	2026-04-09 05:31:59.076	2026-04-09 05:31:59.076	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr1hmyj000aml07i7dzknwr	Rakshitha F	SSMRV College	8014423622	rakshitharaksha099@gmail.com	$2b$12$XnIuTPsLiXcS8NkjI.HK0OwzXmMcc6Y6IWpKJ/OO4JoQOAp1Snlt6	2026-04-09 05:31:33.113	https://lh3.googleusercontent.com/a/ACg8ocL0o3qG_6O3hYou2NS-yqqISnc5U7BHGUAJOvXg1hZ2H542IQ=s96-c	\N	\N	\N	2026-04-09 05:31:33.115	2026-04-09 05:32:01.472	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1ie0h000qjy0401r352by	Bhoomika K	Not specified	9235647001	bhoomika.krishnapavi@gmail.com	$2b$12$lMbDE.wXXt0aZ3fXitsudu9.hsrwGsulQZbv43RZ3mIJkU5Sczm3e	2026-04-09 05:32:08.177	https://lh3.googleusercontent.com/a/ACg8ocK2JOGBE_OknB2Dif0Dzuvc1Cs5NinsaT3d6_unC4N14WdjxdY=s96-c	\N	\N	\N	2026-04-09 05:32:08.178	2026-04-09 05:32:08.178	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr1iemn000hlf04fabr25in	mohammed taiyab ulla khan	Not specified	6774181101	fyitaiyab1@gmail.com	$2b$12$PW5vVUBBiqxv1qr7O/c8LO99R6poLTbsmIyUf8coCNgpduI1qNFtm	2026-04-09 05:32:08.974	https://lh3.googleusercontent.com/a/ACg8ocJpyGvairmgqMiDLd79i9Fvv1BBv_JLoHu5VN-KuBp5ZT5T5p2o=s96-c	\N	\N	\N	2026-04-09 05:32:08.975	2026-04-09 05:32:08.975	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr1ifw4000jlf04op5xnxsf	Bhoomika Maranal	Not specified	7253050297	bhoomikanagarajmaranal@gmail.com	$2b$12$E7Tvvvkp89ylCyL38L0P/uy.HV0XrGeLzWkJentxhqCKbHn0rlsea	2026-04-09 05:32:10.611	https://lh3.googleusercontent.com/a/ACg8ocIjwEs1AJfxkW6RHEVF9Dc07g2VOT5K4JrtuPsmdzTK1ZFHRg=s96-c	\N	\N	\N	2026-04-09 05:32:10.612	2026-04-09 05:32:10.612	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr1ihwu000nlf04e3f2vi4j	Ramya S	Ssmrv college	9845162397	ramya2022ram16@gmail.com	$2b$12$gDmquwe2HP4EWNt0H4ga6unYC2V9l4tOCj.93elZkjEqVyCsMsKtK	\N	\N	\N	\N	\N	2026-04-09 05:32:13.23	2026-04-09 05:32:13.23	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Email registration	\N	\N
cmnr1i0qn0009lf046js4mfbj	Jeevan Sai	SSMRV	8259582065	jeevansai0404@gmail.com	$2b$12$FD.JoQ7l/JQ3Sq6hMqgrCuz4IOvbRnuDuabhzqmZ05a5zqjXXtHE2	2026-04-09 05:31:50.902	https://lh3.googleusercontent.com/a/ACg8ocIWjJuVNPBygiOb_9n0_ONNqN7R7aYvhEXO8iw98r3IAWHamUz_=s96-c	\N	\N	\N	2026-04-09 05:31:50.902	2026-04-09 05:32:14.248	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1i2wo000flf044yrbkuft	Keerthana Rb	SSMRV COLLEGE	9302944840	keerthannarb@gmail.com	$2b$12$k8da2E61msvjO2CRV1Qf7uHbxm2.mwEKICOKjxL0Q1WRMp4s1hkgm	2026-04-09 05:31:53.783	https://lh3.googleusercontent.com/a/ACg8ocK-2AVLp4MxiZlkD3TuKwCVBbjKulC6r9h1kRXAG6_e4Qf9BbpymQ=s96-c	\N	\N	\N	2026-04-09 05:31:53.784	2026-04-09 05:32:18.333	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1i3ot000glf04p3lcnpoc	Suma Pb	SSMRV COLLEGE	8908138286	sumayvsp19@gmail.com	$2b$12$3lG7BtZe.w00F994hX3wo.qxs6dEAxFBBBJG5uSKRR4SisRtnI35u	2026-04-09 05:31:54.797	https://lh3.googleusercontent.com/a/ACg8ocJaEt2225BGTYWpy9Qh1yvxjH8zbsGkq1wHEhhvQVtcmv6jpA=s96-c	\N	\N	\N	2026-04-09 05:31:54.798	2026-04-09 05:32:20.859	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1hzit0008lf04rkhmza5l	Chethan S	SSMRV COLLEGE	7251391027	chethan.s13102004@gmail.com	$2b$12$bZDxy3YJh1wcjlzy1V0fVO0d/.u9E52r0/yt1qsNqkZHwahUQLyA6	2026-04-09 05:31:49.396	https://lh3.googleusercontent.com/a/ACg8ocLtx8mNPSF9c1LC6rSX0gzwOh-I02wT-GwovFJ-1MBG_Aw3kg=s96-c	\N	\N	\N	2026-04-09 05:31:49.397	2026-04-09 05:32:29.291	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1iaku000ojy04idn7ug97	prajwal	SSMRV	9787037071	prajwall.2025@gmail.com	$2b$12$hpVJiHdOywXtza1UhDCRJe.ogcBmlBAem5XMM3uynG9hMtpsTPfCW	2026-04-09 05:32:03.725	https://lh3.googleusercontent.com/a/ACg8ocJXt7Y0cEIbwwGd1PA_EeANq306WJwQ71k-Kp6uAj8yATRUxvo=s96-c	\N	\N	\N	2026-04-09 05:32:03.726	2026-04-09 05:32:30.084	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1i96g000njy04xnork17s	Lucrece Mayben	Ssmrv college	8467894271	lucrecemayben@gmail.com	$2b$12$677sbVd2ZYvQCn5Gr4E.vO/mdTWvWnrQEPs/3yl5zMMrDXjeD7d4y	2026-04-09 05:32:01.911	https://lh3.googleusercontent.com/a/ACg8ocLL78fY44-C9ZLz_NqVJZJLCCmRgs_b8EPLAWxKjkHbFYokUKiD=s96-c	\N	\N	\N	2026-04-09 05:32:01.912	2026-04-09 05:32:55.366	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1hwwn0005lf04m0fgjo3t	Chaya Devi	SSMRV COLLEGE	8072911723	leelachaya24@gmail.com	$2b$12$HeVqybX9bxU5RScp7P2cR.DdSjm/x93iNh8/xH5J5fuaCtcGSwbd6	2026-04-09 05:31:46.006	https://lh3.googleusercontent.com/a/ACg8ocKANgk2tFPoDSbX6QGo1IN8toeXCP3n-hu8z2lzmZAcZ68tGA=s96-c	\N	\N	\N	2026-04-09 05:31:46.007	2026-04-09 05:32:57.002	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1ighx000mlf04g1y1ul5a	Ritesh Singh	Ssmrv college	7963560898	riteshsingh5062@gmail.com	$2b$12$B4grMU/lL2GzJqhQZJbXPu8JSWuIk0xna3UJgIobuO51.O2zFIHdO	2026-04-09 05:32:11.396	https://lh3.googleusercontent.com/a/ACg8ocJ8hVGCSvmRUbe_GyX5PxYdCe_y0nd0FsIj3mppQ4ZwGpOjEA=s96-c	\N	\N	\N	2026-04-09 05:32:11.397	2026-04-09 05:33:52.05	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1hcn70002ml07d4o4dujz	Suhas	SSMRV COLLEGE	7521963112	ssuhas713@gmail.com	$2b$12$Bws4ujjiGm00dZ/9eFLcsuinMoxSQ/uCXDDeWxdXiXZI3W//SR0Sy	2026-04-09 05:31:19.746	https://lh3.googleusercontent.com/a/ACg8ocJf1zsGEOzOjegLTHJYG4K2_PdQ2-B_Eru30pp2zCdegf8FgQ=s96-c	\N	\N	\N	2026-04-09 05:31:19.747	2026-04-09 05:31:59.608	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1hvyw000iml07wh983ffv	Kishan	Ssmrv	6075475514	kishannarasimha007@gmail.com	$2b$12$BRcClgjz.2u5ux3EvcZVyuAKFdeEuZ4sQlSrKIr78phV4ysToE01a	2026-04-09 05:31:44.792	https://lh3.googleusercontent.com/a/ACg8ocJQVkKlsic75XHjICeNzKp8mxcCHlsgJ4WpdIzuVRgpJpbvSIUCoQ=s96-c	\N	\N	\N	2026-04-09 05:31:44.793	2026-04-09 05:32:13.528	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1i777000jml07xr27w97v	Shariffzada05	SSMRV college	6494665100	shariffzada05@gmail.com	$2b$12$K4dwVUwmZfS7d7NH5zaNRel.FGLUSkyh.5hotsWIDgDfbFu2CcrY2	2026-04-09 05:31:59.345	https://lh3.googleusercontent.com/a/ACg8ocJIFEQSWLeYmJejiycfTTwDJWk8R73zm7WFwaW3JzfX8dhV=s96-c	\N	\N	\N	2026-04-09 05:31:59.347	2026-04-09 05:32:29.868	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1ivwa000olf0475yrfzin	K.L. Hari	Not specified	6162786450	klhari66666@gmail.com	$2b$12$tVuBLKN63DR0k5Wnv7EFA.yK2I8zHcLzaRFjBwo7RXvWJN3uktTKC	2026-04-09 05:32:31.353	https://lh3.googleusercontent.com/a/ACg8ocLQ0xIIGx7bkVyi09anzFgL-jA-o9TAtxDiLipXx5vSPPQ_HA=s96-c	\N	\N	\N	2026-04-09 05:32:31.354	2026-04-09 05:32:31.354	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr1ixsa000xml07e8q5i9wz	Rtr. Sri Harsha KS	Not specified	6675682610	kssriharsha7@gmail.com	$2b$12$ipNFFES/mMgDZZRByC4hcuMFF7CmMC294Z.0jzlTvwvcHD6Qy86VK	2026-04-09 05:32:33.801	https://lh3.googleusercontent.com/a/ACg8ocLPhUG79DRiUPpeOgj3ic5R-Hw0UWBOzMRZPHvg0ErxAhiqAQg=s96-c	\N	\N	\N	2026-04-09 05:32:33.802	2026-04-09 05:32:33.802	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr1j51h000rlf04nnu7for8	vamshi Krishna	Not specified	6395583640	vamshikrishnayadav800@gmail.com	$2b$12$m3wjgDoNBK1DY5ztMXQX5ODyBWFJbI48TQcn.7MbVabF4Q/3umhHi	2026-04-09 05:32:43.204	https://lh3.googleusercontent.com/a/ACg8ocJRwVpZ7KewbyfW5igKEt1b4KsE7UjIuKh2I632XzOghU-5lbSu=s96-c	\N	\N	\N	2026-04-09 05:32:43.205	2026-04-09 05:32:43.205	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr1inus000nml07mk5a49xf	GZ CRESTFALLEN	SSMRV	7606589425	gzcrestfallen@gmail.com	$2b$12$Dbmf3L9ZghQXqPwmD9zrS.Gs3Xlung0izW1tSr1vbgQ8Zy00r/alK	2026-04-09 05:32:20.931	https://lh3.googleusercontent.com/a/ACg8ocI_lODoLapEpjjObfHdmXlPmPvphJew82yOJ87lfUPus_4EmYE=s96-c	\N	\N	\N	2026-04-09 05:32:20.932	2026-04-09 05:32:47.708	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1iug0000sml07la50pxzm	Faizanraza	Ssmrv college	7551167347	f88373428@gmail.com	$2b$12$l41svSVwXSQy0CL984lAtOgebCcF3WNhk7621lOciqXW7/Kzc6xHe	2026-04-09 05:32:29.471	https://lh3.googleusercontent.com/a/ACg8ocLDg1qyzC90OQ4Mw9_nuSsfszuzTtrfZnTNveCRswNyI0lCdQ=s96-c	\N	\N	\N	2026-04-09 05:32:29.472	2026-04-09 05:32:49.113	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1itlc000rml07p4a9xslp	Prashanth Gowda	SSMRV College	8756406182	prashanthgowdad05@gmail.com	$2b$12$NwhuAi5AIQUMqCjhFn1pE.lBBYgWpKwLVtSpWuxycHMkZAWp4/iOS	2026-04-09 05:32:28.367	https://lh3.googleusercontent.com/a/ACg8ocKVx0njKfaIinlF1pgTMRrhxN90bgaP1XLsbZUUVQmx7OdEfyN-=s96-c	\N	\N	\N	2026-04-09 05:32:28.368	2026-04-09 05:32:58.542	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1jhee0014ml07b3pf14mx	Priyanka V	Not specified	9383033578	tejupriya4033@gmail.com	$2b$12$rab56eXGIxBv.9/VsttMiuGdpHle9dfhkvmfVrYvfBjGH2ToJYZnu	2026-04-09 05:32:59.222	https://lh3.googleusercontent.com/a/ACg8ocISIzsCX2-z43peRuk4wp__s_ljHs-5zYx18Jk5qGo9XupzzLSH=s96-c	\N	\N	\N	2026-04-09 05:32:59.223	2026-04-09 05:32:59.223	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr1jk520015ml07r3hslzdb	Meghana Kuruvadi	Not specified	6629513415	meghanakuruvadi@gmail.com	$2b$12$hoOZtDMypBFIi1l3tkpmN.nKLgPPakI3IJbBlvDphhDOR5asKRkX6	2026-04-09 05:33:02.773	https://lh3.googleusercontent.com/a/ACg8ocI7RULf_4Ssk__UqLCWNV1WZhk_74nRUQEombD0SP_OSkTvkw=s96-c	\N	\N	\N	2026-04-09 05:33:02.774	2026-04-09 05:33:02.774	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr1iobj000oml073fejl2lu	Charvi amarnath	SSMRV DEGREE COLLEGE	8021072208	charviamarnath@gmail.com	$2b$12$BjQVOBgdUDbEwEs60lR4BuQKkhduL1nfVMX9P6WNXPjpAe3az4YmK	2026-04-09 05:32:21.534	https://lh3.googleusercontent.com/a/ACg8ocJV5uUhV92Oekrv_WI_x7XDpmetPNFiitKxBvPPFbS9JxR4=s96-c	\N	\N	\N	2026-04-09 05:32:21.535	2026-04-09 05:33:04.531	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Other	\N	\N
cmnr1jn7z0018ml07ldd8m9fr	Navya E	Not specified	6708580170	navyae3012@gmail.com	$2b$12$aQgcSIEi.efNyHbWmvbtrubXzMkOYtWbprQt0o1.h8k9JONZ.VGsG	2026-04-09 05:33:06.766	https://lh3.googleusercontent.com/a/ACg8ocKL68ZqXWfe2I0M6z7MLLIHs-G-IwBvqmDTaP40rtoopmkGOw=s96-c	\N	\N	\N	2026-04-09 05:33:06.767	2026-04-09 05:33:06.767	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr1jqtb001bml07ek6b3ye6	Shreelekha Shastry	Not specified	9662440750	shreelekhashastry@gmail.com	$2b$12$.tlcYEKGbNL2.A7QnU8h4emI2eiS7L3v/4JldTyJiCMdq/Db1eliq	2026-04-09 05:33:11.422	https://lh3.googleusercontent.com/a/ACg8ocKREfKF2VGTkb04bRnYTBAU1-ZpytIreGNwBfi3px1xNFitjrA=s96-c	\N	\N	\N	2026-04-09 05:33:11.423	2026-04-09 05:33:11.423	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr1jset001cml07f72qpcpr	Anusha G	Not specified	7938965013	mamathagirish1981@gmail.com	$2b$12$WrUClAc8AjCK7jcjYBTJee6hZOjmcqVpJC.mRrq73kn05vBFSlpSS	2026-04-09 05:33:13.418	https://lh3.googleusercontent.com/a/ACg8ocIHqXW4otJas07NGyeA78enUB8eHyWKMM6sa9U0f6kD62u5fUvq=s96-c	\N	\N	\N	2026-04-09 05:33:13.419	2026-04-09 05:33:13.419	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr1jfbt0013ml07dhks9otl	Asif Asif	SSMRV	7239135919	mmohammedasif1234@gmail.com	$2b$12$1VnoHabY0GLQn/DejVSOCOV2dQRVSoveH9//f8VNiKuv.9OuALRrC	2026-04-09 05:32:56.537	https://lh3.googleusercontent.com/a/ACg8ocJlCUGiZz5BmQj6vB28FmFzkOTkj8_HfzRVEw-OBDi8EEYBRA=s96-c	\N	\N	\N	2026-04-09 05:32:56.538	2026-04-09 05:33:24.431	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1jckp000vlf04pzgmpphq	Girish m	SSMRV COLLEGE	7528278990	girishm787878@gmail.com	$2b$12$P7J.YU/O.kcRh50nteRJi./XHVxRt0120WSqIyM3sHgo5n9IeEXY2	2026-04-09 05:32:52.968	https://lh3.googleusercontent.com/a/ACg8ocKF8dTBRJnmxZ4TOv5A1sbfgqAlPr8H2Qu21u6OEfX9YOsdnA=s96-c	\N	\N	\N	2026-04-09 05:32:52.969	2026-04-09 05:33:26.186	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1k5to001fml07mcpq1vkg	Durga sathish	Not specified	7707427320	durga200506@gmail.com	$2b$12$j12e0JohSZrZxVT6sIU5be735/cm1ikcaZpet8C0cumwGSPFdlLHq	2026-04-09 05:33:30.874	https://lh3.googleusercontent.com/a/ACg8ocJZkLbJ8XzY-69Qx-dk_iOAF84hbO5bZFnBleRa9iCuYtSTrMur=s96-c	\N	\N	\N	2026-04-09 05:33:30.876	2026-04-09 05:33:30.876	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr1j73x0012ml07s993w34u	shrinivas	SSMRV	9568820124	kenishrinivas59@gmail.com	$2b$12$pFcwgf.eKM4.U/j840fIQ.J/Oo4txNrHBOoQJTUXdj.esOt/4T7Wy	2026-04-09 05:32:45.884	https://lh3.googleusercontent.com/a/ACg8ocIfA8X3Z5O43dKLC8zNgov1FY5bKDt4W1OhqxmpxG8QXlPxfg=s96-c	\N	\N	\N	2026-04-09 05:32:45.885	2026-04-09 05:33:37.563	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1jp1a001aml0709jjsngr	Rizwan Pasha	Ssmrv college	9841982225	rp641405@gmail.com	$2b$12$iRlAx79XUsCdYCGI..PLvuybXTAmZMNGEXC.3NQGH04fTdmK2haI.	2026-04-09 05:33:09.117	https://lh3.googleusercontent.com/a/ACg8ocKLIAFVDLP9WWlo3oHV736BU1vJDr3jnXVxweI1n_Og9cl7hAs=s96-c	\N	\N	\N	2026-04-09 05:33:09.118	2026-04-09 05:33:59.172	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Instagram	\N	\N
cmnr1j2570011ml078kti5cbp	Hema Shree	SSMRV	6554624359	hemashree226@gmail.com	$2b$12$sKp.LenyZw3Ti/i3SCmgX.8fUn6R6322E4LS6u5FN0le3eIQ0eCKS	2026-04-09 05:32:39.45	https://lh3.googleusercontent.com/a/ACg8ocJiRORY-Eei4lPKyVIWXWL9aZBydjp6X3bEnD0aMmnft70cuw=s96-c	\N	\N	\N	2026-04-09 05:32:39.451	2026-04-09 05:34:00.584	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1kdfi000ylf04f0z3rwll	Bhoomisb Raju	SSMRV	8896871181	bhoomisbraju@gmail.com	$2b$12$/UlbORpV.Qk7QzyO58z34.7Eib0BXmd81o7Ceaim5EHaqes4cWFce	2026-04-09 05:33:40.733	https://lh3.googleusercontent.com/a/ACg8ocKXmeJuR-J9hFuzhvQg7H6hRUtmFR3YHrMQuR_M2e-LHhk6uGy8=s96-c	\N	\N	\N	2026-04-09 05:33:40.734	2026-04-09 05:35:58.778	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1jarh000slf04kzm5rppa	Aravind Sharma	Ssmrv	6043094040	aravindsharma336@gmail.com	$2b$12$gg4Q/Nwnv/UBL6ZjXcuHWOnhPL88Z2TNDaBj4KE8W8brYBtsqPU5m	2026-04-09 05:32:50.621	https://lh3.googleusercontent.com/a/ACg8ocKBodyWYQ3XQYo02OV_8sCNQMaS2i-xRaFVFu0zzKYjtluDvwE=s96-c	\N	\N	\N	2026-04-09 05:32:50.622	2026-04-09 05:33:14.7	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1kaf0001gml07k4hymmc0	Varsha BS	Not specified	7724554402	varsha2005bs@gmail.com	$2b$12$VRsxWnD44qu4vS9qd7vb.un8wcKCam4xAEh0ypYlX9ImzCLcPMv..	2026-04-09 05:33:36.827	https://lh3.googleusercontent.com/a/ACg8ocKmyhUaTFh89b0lwKXIk97EtYKpEY3PbFf5tUdPEKBB7jOIzvk=s96-c	\N	\N	\N	2026-04-09 05:33:36.828	2026-04-09 05:33:36.828	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr1jluf0017ml07minaa1tp	Anushree Anu	SSMRV	8314676951	anuanushree431@gmail.com	$2b$12$PuQLU2JmbaNuMjrwu8wBPOyieHWW9MjrFgGK6AkAbK5gI7H3SVuKq	2026-04-09 05:33:04.982	https://lh3.googleusercontent.com/a/ACg8ocL2FFoMEU19YfoS6wxt72ETjN5HJQn6dKqPWOIf91tubfc-yZoO=s96-c	\N	\N	\N	2026-04-09 05:33:04.983	2026-04-09 05:33:49.359	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Instagram	\N	\N
cmnr1kajx001hml078fzkmzqd	Pawani	SSMRV college	7686940484	pawani30288@gmail.com	$2b$12$DOXPIv3DzSvf9Z7q46W7B.ohuZwIVYAMJc6vAXugJDFAgDmapuUlG	2026-04-09 05:33:37.003	https://lh3.googleusercontent.com/a/ACg8ocI5VMe5dSv9l3r41UkyRJj_VZeDMi6RAU-rWDRobn-JaFwK2Q=s96-c	\N	\N	\N	2026-04-09 05:33:37.005	2026-04-09 05:33:52.55	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1jkl80016ml07zqyua0wj	Chinmayee Srinivas	RV	7290290259	chinmayee65205@gmail.com	$2b$12$bo4HttJCEN5jIQslZGrBzu/X5.uI1ru6DxnnYMZkuP6P3fq3fGSgu	2026-04-09 05:33:03.355	https://lh3.googleusercontent.com/a/ACg8ocI9x7fuA2q0ZmjNEIUaoiEMv5WgcEy7mNvAxvzyw4LCqQCy_htt=s96-c	\N	\N	\N	2026-04-09 05:33:03.356	2026-04-09 05:33:27.849	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1iyyl000yml07kq0ut7yt	Chandan P	SSMRV COLLEGE	7678827414	chandanpchandanp3@gmail.com	$2b$12$3qpm/W5wwKqkCVYkUSWxfOvhVM/LFcbrgwI48c7TZJRPXiZSEQb7e	2026-04-09 05:32:35.325	https://lh3.googleusercontent.com/a/ACg8ocIosdp7Rnq2arV_EoG26OJw1-d_qhWJTUxdR7yx1A7iuMiN3Dup=s96-c	\N	\N	\N	2026-04-09 05:32:35.326	2026-04-09 05:33:33.859	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1knmh001jml07galbc6lx	Nidhi jain	SSMRV College	6529021084	nidhijain0726@gmail.com	$2b$12$exjJvvh32SP9TCjukMbP4esf7Tf7EZQ1PdKrbwvgZqHjDzJoS6mlO	2026-04-09 05:33:53.944	https://lh3.googleusercontent.com/a/ACg8ocLujSYsKXZv9X34UGKj-5sE-sHd9BRkaITz5YiUkZyTgCAd5E4=s96-c	\N	\N	\N	2026-04-09 05:33:53.945	2026-04-09 05:34:48.695	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1lbc40000l1042ppffqzw	Meghana Shetty	Not specified	7825846962	shettymeghana654@gmail.com	$2b$12$cUhFNBA8YaymjHwGyg3km.R/pLwcjwX2F9e9rTL.woC3bzSJ4AUBG	2026-04-09 05:34:24.676	https://lh3.googleusercontent.com/a/ACg8ocLB6H9rmFsqNMIBodrJ_yf8IrLDSgUC4a3wD070JqPYvR97cGQO_g=s96-c	\N	\N	\N	2026-04-09 05:34:24.677	2026-04-09 05:34:24.677	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr1ll2c0015lf04h5n9pfv0	Huzaifa Sultana	Not specified	8200313295	huzaifasultana1716@gmail.com	$2b$12$CbX2F6H80u4SDaafLMrLxePQ.rvvXxwOt92v2WS1Q3bTT78GiU.ti	2026-04-09 05:34:37.283	https://lh3.googleusercontent.com/a/ACg8ocJyFYFpFCOpaBQiqsmmrZcOyvHKt_FDMPULHiJkn7dQaVLaFEw=s96-c	\N	\N	\N	2026-04-09 05:34:37.284	2026-04-09 05:34:37.284	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr1lqcp0017lf04dgk68pmx	Abhiram Tallam	Not specified	9349774152	abhiramtallam72@gmail.com	$2b$12$MdBCHfz94cc44XMO0inYheDutv0x1jwd00zcpLrHzoZuxXZ4dEpoC	2026-04-09 05:34:44.136	https://lh3.googleusercontent.com/a/ACg8ocL7z_wZH2Z0gmL5C4ZHh2kC6u5i9C6X-9Kdd6nR2tARc-ZDLw=s96-c	\N	\N	\N	2026-04-09 05:34:44.137	2026-04-09 05:34:44.137	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr1lcxq0001l10419yhbcpp	Pavithra M	SSMRV	8154201912	pavithra.mn1509@gmail.com	$2b$12$euUBXUwKVW1GTA27ZcuBluEiYF8NO/nJ5sQc/qUQ35xotRmMlO/UO	2026-04-09 05:34:26.749	https://lh3.googleusercontent.com/a/ACg8ocK--o8m6I1kbslKLnKtgZZ8IJDgiMnzIow97-VhsWLn32RnPA=s96-c	\N	\N	\N	2026-04-09 05:34:26.75	2026-04-09 05:34:54.302	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1lodf0016lf042e5nvzuq	Mohammed Maqsood	SSMRV College	6616711800	mohammedmaqsood762@gmail.com	$2b$12$IbOMuCkGOJluM3Xv23YLtusURHvBmjo7bZ/wjEo2.H8OXMvhHjC.m	2026-04-09 05:34:41.57	https://lh3.googleusercontent.com/a/ACg8ocKcKqxNKC9W8Wi62N2sfGmiUHo7tJ5BTb7vbpCQqMfBsPlSEQ=s96-c	\N	\N	\N	2026-04-09 05:34:41.571	2026-04-09 05:35:00.338	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1ktb8001mml07k9y9hiag	Sujan Kashyap	SSMRV Degree College	7473446798	sujankashyap@gmail.com	$2b$12$tvLbzt1yb5QoFznEfs3SmOF3T9GEij1Chk3TdePGLjuCTm9TUuZ/K	2026-04-09 05:34:01.315	https://lh3.googleusercontent.com/a/ACg8ocI2YPjm9g80VLCNa4fQb4JwfOZ0DGcCB9o-rhNm4wgOEkbWFu_j=s96-c	\N	\N	\N	2026-04-09 05:34:01.316	2026-04-09 05:35:00.521	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Other	\N	\N
cmnr1l54x0011lf045q4w5ot4	Chandra Babu M	Ssmrv	9504961555	chandrucb112@gmail.com	$2b$12$MO29pwNN1ceFeYX75eP5gOE9zyd3AN0tpkHt90JIYKi4hM82JL876	2026-04-09 05:34:16.641	https://lh3.googleusercontent.com/a/ACg8ocIB6z2V-Y0FanEctP8MAjj0S_HZJYHw_xgF2rVgrUXChyxJcw=s96-c	\N	\N	\N	2026-04-09 05:34:16.642	2026-04-09 05:35:03.721	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Instagram	\N	\N
cmnr1ltus0018lf04zt82hanr	Aishwaryabgowda1612	Ssmrv degree college	7117584990	aishwaryabgowda82@gmail.com	$2b$12$rkQ3TJLKwCk16ltHUDFJk.wof3cJ2S/Jug8dMBv.9Aru5lP83TnmK	2026-04-09 05:34:48.675	https://lh3.googleusercontent.com/a/ACg8ocLUhOeWGXPqArzH5X_9cYiUpYwuWE5vivcBbpcdrDHOeeewtQ=s96-c	\N	\N	\N	2026-04-09 05:34:48.676	2026-04-09 05:35:15.447	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Other	\N	\N
cmnr1m51m0019lf04gi6brihi	Sheetal Bhavi	Not specified	7355604948	sheetalbhavi05@gmail.com	$2b$12$54eOW1PjnKmtJkz6QbC2EerIwExQxuX68CSXoIvJLiuqP6KfJa.Ru	2026-04-09 05:35:03.177	https://lh3.googleusercontent.com/a/ACg8ocKCdaEQJcsErvPWmx6RXmXldmjEHRjNBi0sqM0oZTL_JWeZ=s96-c	\N	\N	\N	2026-04-09 05:35:03.178	2026-04-09 05:35:03.178	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr1lf5e0012lf042fabdfjk	Charan	SSMRV COLLEGE	9446680279	charansricr8@gmail.com	$2b$12$rptg43mZMUCbx7MN1UdD5u8z4c/Co2.NQstfiKMyldJzubO5La9/C	2026-04-09 05:34:29.618	https://lh3.googleusercontent.com/a/ACg8ocIVn40lJ44JG3Heyt7f6JBlHzDNMfLWUPhnSaA3ZN1AU6_mPw=s96-c	\N	\N	\N	2026-04-09 05:34:29.619	2026-04-09 05:35:16.685	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr1mgrh0002l104uhf5zoui	Kaushik Pujari	Not specified	6998130556	kaushikkp2303@gmail.com	$2b$12$RqZnoQKtBOC.S0y.XK4OT.86i1hQYdYuKQ85W/wOtL9vDg9YGikKG	2026-04-09 05:35:18.365	https://lh3.googleusercontent.com/a/ACg8ocLnqiXcChIMWZAToZk4Vw-Mey90yfbPhLkta-59qcDgRenUwQ=s96-c	\N	\N	\N	2026-04-09 05:35:18.366	2026-04-09 05:35:18.366	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr1mq6m001alf04pl1nvqxj	Rashmi TS	SSMRV COLLEGE	8660472869	rashmi.ts600@gmail.com	$2b$12$vwGjusfnXyN3hYcUy.wW8uC3iA7WZm5GtY3OOhavgeo3UNbyeqWsq	\N	\N	\N	\N	\N	2026-04-09 05:35:30.575	2026-04-09 05:35:30.575	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Email registration	\N	\N
cmnr25e3u0002l504p03m7mtu	Sowmya.B	SSMRV Degree College	9763083805	sowmyabattur410@gmail.com	$2b$12$OwsK6RuyAq0x73JOG1RI6ecv2z2JG9ENXvMNfULeD4.GXLAYhUmjW	2026-04-09 05:50:01.385	https://lh3.googleusercontent.com/a/ACg8ocIypfDq-H_LKkpdlnY7u3nONzvLjHrca1kjYoGWa5i1SnvSUchR=s96-c	\N	\N	\N	2026-04-09 05:50:01.386	2026-04-09 05:50:36.478	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr2az7y0003l504bcuqdguq	Thrisha v	SSMRV COLLEGE	9742743132	thrishamadhu21@gmail.com	$2b$12$FmhJyzvogIyUnGr/EWSlcuQqygY.rL2RbU3t5IHdDENibmM5.pv5S	\N	\N	\N	\N	\N	2026-04-09 05:54:22.03	2026-04-09 05:54:22.03	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Email registration	\N	\N
cmnr2fcro0004l504iugap138	Manasa.h.s	Not specified	7684374600	sumamanasa27@gmail.com	$2b$12$Q4CMisFvBdpKXYr2pCv6s.qtyhSPczzubZjZpJytQ9HZEBJTfFzcu	2026-04-09 05:57:46.211	https://lh3.googleusercontent.com/a/ACg8ocIXDsg7JtnUmeVrWVm-tsArfTppuCfNWwJh7q1NDzOJFu1AKR0=s96-c	\N	\N	\N	2026-04-09 05:57:46.212	2026-04-09 05:57:46.212	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr2fjmk0005l504o5ro7fp0	Faraz Alam	Ssmrv collegw	7348928068	farazalam9906@gmail.com	$2b$12$8Wt8jR9jQu47skmFFgyUWuzqFAE7.sazSEui6yClc7PRImzbZ36g.	2026-04-09 05:57:55.099	https://lh3.googleusercontent.com/a/ACg8ocJWFrEt5KwHyG6mAWA5Abogy8rsu3HQg5LUJr5FKNGFkuWPvngfEg=s96-c	\N	\N	\N	2026-04-09 05:57:55.1	2026-04-09 05:58:10.814	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr3rnh90000jr04dtouk34f	Joshnavi S	SSMRV DEGREE COLLEGE	8288341810	joshnavis62@gmail.com	$2b$12$VhHYUdonNBnDq6FpNmG8feKPP2jxcLCfgRG8LDlRDbDfUMdji0ISe	2026-04-09 06:35:19.58	https://lh3.googleusercontent.com/a/ACg8ocLl1-cqP5_CgOxdr5F9JS0feFyXrcew5u_mdwfelkgiYCpukw=s96-c	\N	\N	\N	2026-04-09 06:35:19.581	2026-04-09 06:36:14.581	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnr4ki2a000iu79katbp2k6m	TheIndianBiker	AksharaUniveristy	8987781231	theindianbiker@gmail.com	$2b$12$wrYhI86e5noIN6vAYiHwG.SKTQhNmTsPWnEVhwZ2rgTklWAubL19.	\N	https://res.cloudinary.com/dbu9z9ija/image/upload/v1775718237/occ/avatars/afsvojrbta57qhpuf7xv.jpg	hi i know to ride bikes	Instagram: thebiker	\N	2026-04-09 06:57:45.586	2026-04-09 07:04:12.899	APPROVED	club-bikers	BIKTHE9VUA	\N	CLUB_HEADER	f	\N	f	\N	\N	\N
cmnr5vtmy0000kz04qfj5p7fg	Megan .l	Not specified	7992197244	megan.l2005.84@gmail.com	$2b$12$7Vkg/0QwHEd/SpRG5h6fJ.bmZ1IdoEP9y5xb8CyXG9xrsdYHpyCYK	2026-04-09 07:34:33.417	https://lh3.googleusercontent.com/a/ACg8ocKiuRHs7DUm2-33pkaZqrCtfnpL_-cf1tOt61aSXKYj5wKgQBI=s96-c	\N	\N	\N	2026-04-09 07:34:33.418	2026-04-09 07:34:33.418	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnr7gjjt0000l504xt5yrtt4	Salman Khan	Ssmrv degree College	8908438256	salmanracykhan@gmail.com	$2b$12$wA1u6bBfZ.iSNtGlS2m...ti14huA.fosSwDHBS9GNXQ1cR/6NKCm	2026-04-09 08:18:39.736	https://res.cloudinary.com/dbu9z9ija/image/upload/v1775722954/occ/avatars/g5jvvlmlhnoincjknseg.webp	\N	Bengaluru	\N	2026-04-09 08:18:39.737	2026-04-09 08:22:49.185	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmno9keux0000lb047w1faixt	jishnu n	pesssss	6016275519	jishnunreddy@gmail.com	$2b$12$Ny1cYt/tlvf44uxtbfzAnO9/HLRAma6FbN.eqLC7GRO9GAhrA/g/2	2026-04-07 06:54:20.984	https://res.cloudinary.com/dbu9z9ija/image/upload/v1775798142/occ/avatars/babbykpdsxycoazri3r7.jpg	yoyoyo	fgttgtgr	2040	2026-04-07 06:54:20.986	2026-04-10 05:18:21.586	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	From a friend	\N	\N
cmnrgl2sj0000jf04gdmvejhs	2025222 ROSHAN PAUL	Akshara university	9379321734	roshan2025222@sjim.edu.in	$2b$12$Dvr7OQiOvz03I8yHlIj73.KUmze5AsJ/CsN0BzwX/ZTl8nt4IvwYa	2026-04-09 12:34:07.843	https://lh3.googleusercontent.com/a/ACg8ocKjccBC0cqu_EJ93vIX9UCfTuqo9tw0t-JU7tSxrPr1eaqnoQ=s96-c	\N	\N	\N	2026-04-09 12:34:07.844	2026-04-09 12:34:55.298	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Instagram	\N	\N
cmnri2g3z0000ky0493id515v	kitty gaming	Not specified	9535039711	userkrish2006@gmail.com	$2b$12$gCjm5L3Y/xv/T.w49gTXpufvYSNLfpkDxWxiulOyKvyM69LfsMNyW	2026-04-09 13:15:37.87	https://lh3.googleusercontent.com/a/ACg8ocLjgbODoezjXqj1-h8hD4foOS99XSD-iQfH_X9rf0VZ1D54eFk=s96-c	\N	\N	\N	2026-04-09 13:15:37.872	2026-04-09 13:15:39.572	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Google registration	\N	\N
cmnr3197o0001l804imwja3wr	Shubhanga v 	Pes university 	9900906774	shubhanga2811@gmail.com	$2b$12$Tt44kxKiTH3MxlpiUaM6VuZh7SukN8NslyAyeNX2xAj73Bq2ci8UK	\N	\N	I’m head of sports	Instagram: .	\N	2026-04-09 06:14:48.036	2026-04-09 13:53:17.242	APPROVED	club-sports	VIRATKOLHI	\N	CLUB_HEADER	f	\N	f	\N	\N	\N
cmnrfylea0001l7041s6sx8le	Rahul JV	PES	9899338624	jvrahulakshara@gmail.com	$2b$12$g52DrGM9GU83nVsvY5j3K.KlTInOI7lQGjBl3rCNDo7Azb4Owszhy	\N	\N	hello	\N	\N	2026-04-09 12:16:38.866	2026-04-09 13:53:30.99	APPROVED	club-photography	PHORAHIH0P	\N	CLUB_HEADER	f	\N	f	\N	\N	\N
cmnsgzvej000ilj04udzdubkj	Aishwarya Venugopal	Not specified	8243006496	aishwaryavenugopal51@gmail.com	$2b$12$ghuNrO2wkHoAPMMR5DquCenmxeH.MIyrPJL9eFgcx37MMyJ5SzEXC	2026-04-10 05:33:24.283	https://lh3.googleusercontent.com/a/ACg8ocIIXO5_rTiSepm65WG3ua3EPouAp95IfF71io3TjZcMchGnpB8=s96-c	\N	\N	\N	2026-04-10 05:33:24.284	2026-04-10 05:33:24.284	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnsh0mfu000klj04yw23xk8r	Chaitra.j Chai	Global institute of management sciences	9994048361	chaitra.j146@gmail.com	$2b$12$slnNwNPVHLOI4unql/07OeGvzMYXiCsFrn1oOCz65UvMwB4O4V/x.	2026-04-10 05:33:59.321	https://lh3.googleusercontent.com/a/ACg8ocLdIJ7eks9Qb_ac2sr4GkhU8dpwqRAEyyl0-ZQ2NpOjRb7PAA=s96-c	\N	\N	\N	2026-04-10 05:33:59.322	2026-04-10 05:34:56.297	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnsh0d7a000jlj0452v424rh	Ramoji nayak Rj	Global institute of management and science	8053443302	ramojinayakrj@gmail.com	$2b$12$YvsJdGDhbrJqzpXBYnxeyO.2IxyLF/vGD9S7SFFPhSM3Fl0d.awmG	2026-04-10 05:33:47.349	https://lh3.googleusercontent.com/a/ACg8ocJXfCOu2VdoqNNKBog6-VRPPD2cGBLPv_JH9NhMi-6P9dc9Og=s96-c	\N	\N	\N	2026-04-10 05:33:47.35	2026-04-10 05:36:45.575	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Official college event	\N	\N
cmnsgzofj000hlj04eyyyu0fj	Nandan K S	Global Institution of management sciences	6505845796	nandannammu123@gmail.com	$2b$12$u38QYkDUw8NluFvQn/dCnueGKh64Q9eT6soxHGZuWv5i9vpWZwD9K	2026-04-10 05:33:15.247	https://lh3.googleusercontent.com/a/ACg8ocKdM7TNvdtKaKzHJnnFgDWq9h9EgiLsF7zoTLyY0piFFpgcVBk=s96-c	\N	\N	\N	2026-04-10 05:33:15.247	2026-04-10 05:37:30.175	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Other	\N	\N
cmn74dl9900168u1jtw2fmhwp	Harshitha R M	Global Institute of Management Sciences	9620779565	harshitharmbaturi@gmail.com	$2b$10$PXvb1.j72/s666ahzMIjeOJNY7afwPynxgWHzqZrdid09HbfCXkk.	\N	\N	\N	Banglore 	\N	2026-03-26 06:56:59.613	2026-04-10 06:31:45.532	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Other	\N	\N
cmnsgzkb6000glj04bnmj4z4y	Bhoomika L K	Global Institute of Management Sciences	6835024909	lkbhoomika436@gmail.com	$2b$12$WJLJVsoTrwbTePib/nvIe.enfoHo.EnhqXVsseg5z4YyrQG8vvM7m	2026-04-10 05:33:09.905	https://lh3.googleusercontent.com/a/ACg8ocK48Qjv3Ugp5YgOG1h4W_4FFSXAdcOeiAMMYl1so0j2OOJI8A=s96-c	\N	\N	\N	2026-04-10 05:33:09.906	2026-04-10 05:34:14.114	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnsh27e2000mlj045gtg4jz2	Kavana.M.U Kavana.M.U	Global Institute Of Management Sciences	9937597731	kavanamukavanamu4176@gmail.com	$2b$12$GXQRMgVmTnq8DvY/EREOgenKUm1oL0jMveqEzfbBdB6/Hib6QSwDC	2026-04-10 05:35:13.13	https://lh3.googleusercontent.com/a/ACg8ocKcy6CmmRneRlBBeZuNjOGWHfJ3cuSS_PgQm_uviCujbDt66EL0=s96-c	\N	\N	\N	2026-04-10 05:35:13.13	2026-04-10 05:37:02.818	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Official college event	\N	\N
cmnsh486y0008lb04ilt6y8ip	Nayeem Khan	Global institute of management sciences	8276851435	nayeemkhan4228@gmail.com	$2b$12$z/V1vhlkezh8zF1CLs/.A..IXRNlq1S03OM8Xu6lCp46F0DwM7mnG	2026-04-10 05:36:47.482	https://lh3.googleusercontent.com/a/ACg8ocI7b5Xb_F438sBd2yp14xTZ29PgBlv3SKMGqGENNHCVmlb78EKV=s96-c	\N	\N	\N	2026-04-10 05:36:47.482	2026-04-10 05:37:29.25	APPROVED	\N	\N	\N	STUDENT	f	\N	t	LinkedIn	\N	\N
cmnsh2adp000nlj043edrpnrk	Chandru	Global institute of management sciences	7663630384	chandru05200228@gmail.com	$2b$12$woylfMQHr6obji.tUc.mAOAWlvDRS4M6rNjJm57e9wux7dwtiEh/2	2026-04-10 05:35:17.004	https://lh3.googleusercontent.com/a/ACg8ocJHRTDjj5A9-tK5ZxDUyrrY6ndVt1Rldm7SLZWTZXQ2WLjX=s96-c	\N	\N	\N	2026-04-10 05:35:17.005	2026-04-10 05:37:16.409	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Other	\N	\N
cmnsh3yrj000kla049cd6skg0	Chethan Kumar k.v	Global institute of management science	7256607314	chethankumar0928@gmail.com	$2b$12$mAgS3uoLXWSBrR.IrzsA3ewXB1NzESEnY3MbOU2pGhHA0NwkO66iO	2026-04-10 05:36:35.263	https://lh3.googleusercontent.com/a/ACg8ocL84CpiInA72T-4SXDgv6EPk0HJFWyyoKnC7nRdDYL0ki-pNXjPSg=s96-c	\N	\N	\N	2026-04-10 05:36:35.264	2026-04-10 05:37:17.595	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Instagram	\N	\N
cmnsh4p76000tla042e1tuj1j	Kiccha Gagan	Global institute of management sciences	6628913076	gagankiccha83@gmail.com	$2b$12$lTbsHYZowWGtckRfZy0Io.IZPNexUfJ5OxrT/kBlPVYJKkuZugFqO	2026-04-10 05:37:09.522	https://lh3.googleusercontent.com/a/ACg8ocK-c7QZbE7_FS7VBzp56ovQCOjnQwsWPT8uGoub_7Lmk42j7mDQ=s96-c	\N	\N	\N	2026-04-10 05:37:09.523	2026-04-10 05:37:57.551	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Other	\N	\N
cmnsh3wwa000olj04avygqj0o	Jenish Kc	GIMS	6995362135	jenishkc0123456789@gmail.com	$2b$12$nxDLiUPbzk.uCz0xP2Cv8.4MywZiyJnGVFWEQxjwKs/C2GeMDHWDC	2026-04-10 05:36:32.841	https://lh3.googleusercontent.com/a/ACg8ocKlVigTdEFphg2EnUEGnIJ8ebvh50kjW2n_MjgNiMMEWNb0ew=s96-c	\N	\N	\N	2026-04-10 05:36:32.842	2026-04-10 05:37:21.063	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Other	\N	\N
cmnsh0scz000llj04bi0nics2	Anusha H C	Global institute of management sciences	7435668223	anushahc2003@gmail.com	$2b$12$OqtDvxRYWHlSh2TVgFnE8u68xY0Ug2gKOK9fM.7Ni8bnCgLMyRUt.	2026-04-10 05:34:06.994	https://lh3.googleusercontent.com/a/ACg8ocIXxq1mlPyLt-3Qev36ckvTZH9xdTPnqUBDQDlNPOWiG8bfDqKv=s96-c	\N	\N	\N	2026-04-10 05:34:06.995	2026-04-10 05:37:25.063	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Other	\N	\N
cmnsh4rfy000ula04srietnaj	Meghana.M.R Meghana	Global institute of management sciences	9975992760	meghanameghanamr@gmail.com	$2b$12$zNjO3RL/4Flw9G7.Jbv/g.BaM.vDwD.OB4s0sztHJqsSY93C1Emve	2026-04-10 05:37:12.429	https://lh3.googleusercontent.com/a/ACg8ocJWKMeg_z4Q-RHCSu4HhzevfGOnVv6GBKX1eZF0INQYbK-NwEb6=s96-c	\N	\N	\N	2026-04-10 05:37:12.43	2026-04-10 05:37:39.128	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Other	\N	\N
cmnsh4cnf0009lb0464mx03n3	Chandana GS	Global institute of management sciences	8562745468	gschandana3@gmail.com	$2b$12$qc9ykqO9qhpv115OZdq/QOzDsbU42vN2XxM2eOaVkJX57lYg47Jmm	2026-04-10 05:36:53.258	https://lh3.googleusercontent.com/a/ACg8ocIMeIFybTPp6N-LgPTnHInCiM_b0OKeNEKbCQyTDDm8nbZh4w=s96-c	\N	\N	\N	2026-04-10 05:36:53.259	2026-04-10 05:37:55.322	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Official college event	\N	\N
cmnsh4dau000lla04n9hasucx	Devika ko Devika	Global institute of management sciences	8757077301	devikakodevika@gmail.com	$2b$12$XghgQBs8y5u/6kyNH5SYHOdXqBGz2fq7PGNwTSpySkz.vJ4.7Vd8a	2026-04-10 05:36:54.102	https://lh3.googleusercontent.com/a/ACg8ocIhX-oYpJF6hUapgu-L369efB_sElpmIRhZrTO3soybiL7T2g=s96-c	\N	\N	\N	2026-04-10 05:36:54.103	2026-04-10 05:38:15.317	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Official college event	\N	\N
cmnsh4dwx000mla04hjxs1r6o	Ganavi B. g	Global institute of management sciences	6477290651	ganavibg340@gmail.com	$2b$12$CqCPHaaBSCQOOwx2pBgg4OZnsingaoWQqJLxqbYbaCFZPW2puFiE2	2026-04-10 05:36:54.896	https://lh3.googleusercontent.com/a/ACg8ocJJm1IXWINpMmxXxTSni9I9eb9CQqow7dURM0GOvw6q3HSbog=s96-c	\N	\N	\N	2026-04-10 05:36:54.897	2026-04-10 05:38:07.94	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Official college event	\N	\N
cmnsh47zn0007lb047f2e9q3l	Ankitha G	Global institute of management sciences	6860581602	ankithaanki0305@gmail.com	$2b$12$y6rWXcfjl0/QMCGiBHD62ePbHvl3eoUtLtEWrPf3w11AqfRLCGTHi	2026-04-10 05:36:47.218	https://lh3.googleusercontent.com/a/ACg8ocI3d56DnQgewIyRbPLIJpR4UifCW5gjzOpGfeRvfpfm0BmqXA=s96-c	\N	\N	\N	2026-04-10 05:36:47.219	2026-04-10 05:38:07.349	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Official college event	\N	\N
cmnsh43xv0000lb042aumlphi	Keerthana B S	Global institute of management science	7948506279	keerthanabs63@gmail.com	$2b$12$F3LBdwOgfonFpml6wjXY4OlDjhOIXetcMWMQsgbKbiIcOhZANwsCm	2026-04-10 05:36:41.97	https://lh3.googleusercontent.com/a/ACg8ocJOG4VWmDAjjuchvG4iIuueCDriHgothCsnr5fk7eoijSXiAQ=s96-c	\N	\N	\N	2026-04-10 05:36:41.971	2026-04-10 05:39:10.775	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Official college event	\N	\N
cmnsh532u000slb04tsmuaxg2	ABHISHEK HG	Global institute of management sciences	6759154543	abhishekhg97032@gmail.com	$2b$12$NqQTzc13k4mWKTQmx1wwLuvKv67QvxWUdsLCvWuIuI1Cbl2h8dXGW	2026-04-10 05:37:27.432	https://lh3.googleusercontent.com/a/ACg8ocJ4u2wtd23BRoorKQUTI22TA9HXewo6skEvyNmtnmHVEsNFEw=s96-c	\N	\N	\N	2026-04-10 05:37:27.433	2026-04-10 05:39:02.763	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Official college event	\N	\N
cmnsh5wai000vla04xk2aruz3	Gagan S	Global Institute of Management Sciences	9852300225	gagansg14@gmail.com	$2b$12$zF26OWFEidYUzkhqLiNoOedicvDgr/J8qmSQuhUmDjIsE7mvjcPx6	2026-04-10 05:38:05.369	https://lh3.googleusercontent.com/a/ACg8ocKlSporPSIzwKryV8puFaTqYJW-x4135r7zoo1PSrZQlSwU=s96-c	\N	\N	\N	2026-04-10 05:38:05.37	2026-04-10 05:38:46.903	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Other	\N	\N
cmnsh5xbi000plj04axp3pq84	Nirmitha H.N	Global Institute of management science	9546270814	nirmithahnnirmitha@gmail.com	$2b$12$Siip2Dd4kPnWuAJ86qWFVOwj7Z3.Vs.Q7fhnAk5rdvkyOZoNJf29S	2026-04-10 05:38:06.702	https://lh3.googleusercontent.com/a/ACg8ocK5lj8PVa9Wmkmy3sk1Md9516r450wScPIA4GkToNiSSj73uA=s96-c	\N	\N	\N	2026-04-10 05:38:06.703	2026-04-10 05:39:19.17	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Official college event	\N	\N
cmnsjp5vt0002l504fayewz4k	Mohd Afreed	ONE SCHOOL OF BUSINESS	9390700027	statushome3629@gmail.com	$2b$12$7v4XTtCt77363Yycb5g8j.5zbfZwXRUwPld68wt2f6amrY2324gte	2026-04-10 06:49:03.496	https://lh3.googleusercontent.com/a/ACg8ocKzx_gbk3QmV92jLQyICoHoq9T3OEI8L5ddPNyKMkOSh7w6dVtf=s96-c	\N	\N	\N	2026-04-10 06:49:03.497	2026-04-10 06:49:36.066	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnsjq5840003l504bg6cp566	Caartika Vimal	Not specified	8720910087	caartikavimalkumar003@gmail.com	$2b$12$.4g2ViK/fIEZ430sHzNXNe5EP/PMw3PpNt32aMh6voUF0dDkEnoMO	2026-04-10 06:49:49.299	https://lh3.googleusercontent.com/a/ACg8ocLtX5rJ1h65AA_hPaQFOY0Kk8ntxCtYAVMnLMNdd-D_0lRg5w=s96-c	\N	\N	\N	2026-04-10 06:49:49.3	2026-04-10 06:49:49.3	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnsjs2r30001ld04jua79ds5	Sahil Raza khan	Not specified	9623217001	sahilrazakhan470@gmail.com	$2b$12$mFHUvk69KvW57mtvO7QVoOYYAFzg0YzGiASVQXD/FWYuMmc45LrB2	2026-04-10 06:51:19.406	https://lh3.googleusercontent.com/a/ACg8ocJnxXqzVnwgUvUsWm5liICWFzdPZQLe4yYR3csbqgOAUoJlnV3K=s96-c	\N	\N	\N	2026-04-10 06:51:19.407	2026-04-10 06:51:19.407	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnsjsj6n0002ld04t8g9de6h	Shaheem Sabir	Onesb	9666334847	shaheemshamon7@gmail.com	$2b$12$RgW3NJpAF1CBqOQQ6CtyOuNTe4rooAgFUEl.LZ.qwWk/Zv/78eWeu	2026-04-10 06:51:40.703	https://lh3.googleusercontent.com/a/ACg8ocKf7avxt-ZVptRsqEfQOs6weov4dmtEC-TodeRJ5X7dR9kyWeVP=s96-c	\N	\N	\N	2026-04-10 06:51:40.704	2026-04-10 06:52:14.163	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Other	\N	\N
cmnsjv78t0007l504ovfxds6h	Sharath Gowda	One school of business	9454515091	gsharath079@gmail.com	$2b$12$SQ2D7R1uB1WVHPsRwTDNk.Kjob6ZZrRWvY7Tu/eko1k.GKTx4.vYq	2026-04-10 06:53:45.197	https://lh3.googleusercontent.com/a/ACg8ocK4LLv_MbCZXWztmyPlVXpXWFspIg1UFU_VUvJzKV7USRiqyjk=s96-c	\N	\N	\N	2026-04-10 06:53:45.198	2026-04-10 06:54:17.629	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnsjxo2w000fld04n3t2h0m9	Chethan bk	One school of business	7981554448	bkchethan66@gmail.com	$2b$12$rAWKmZidB7lfQDilozjcou2bAxn8ihbNM/gQKtNweEeGV5GqUou22	2026-04-10 06:55:40.328	https://lh3.googleusercontent.com/a/ACg8ocLSvoo15IYGn6g3__Fmc3AEAZ1S3TVWPhM85v5TdcFIIguu=s96-c	\N	\N	\N	2026-04-10 06:55:40.329	2026-04-10 06:56:02.292	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Other	\N	\N
cmnsk3c4j000fl504igvs5sok	Gokul mba	Not specified	7876969009	gokulmba2005@gmail.com	$2b$12$Vc6.H0uoMOrFkOUCps0TTuGltWN3Gas2Kjol7vR83Zpp8w7GPM.VS	2026-04-10 07:00:04.248	https://lh3.googleusercontent.com/a/ACg8ocLjHbUyFkMK-kQckkp2Ba6DEZOID4GNr91n_QlR_w6ZU47AQQ=s96-c	\N	\N	\N	2026-04-10 07:00:04.249	2026-04-10 07:00:04.249	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnsk1qfw000el504176uj62v	Ahmed Umar Siddiqui	One School of Business	7180879666	ahmed.umarsidd55@gmail.com	$2b$12$NL3HKDcgC4bf2YXflBPzf.fy/PZPsYJysLaRNtas./4xsc/o3HOl2	2026-04-10 06:58:50.012	https://lh3.googleusercontent.com/a/ACg8ocLRjolWXxwsI-s7GbN4Pp_tKkfz7XUfXmBdUol2eActELh1EJY=s96-c	\N	\N	\N	2026-04-10 06:58:50.013	2026-04-10 07:00:05.829	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnsk9bkc000hl5044j3dbhwf	Harin sadu	Not specified	8655969618	harinsadu@gmail.com	$2b$12$vAcEx495vjebNWabhnB/beeoMOYVlj.wbSciCxUiXvbsda7aScNGi	2026-04-10 07:04:43.98	https://lh3.googleusercontent.com/a/ACg8ocJU1_7Si_FNRSAp3stb79b9O0hMXCxOLdTt4K92sN8O2d0kug=s96-c	\N	\N	\N	2026-04-10 07:04:43.981	2026-04-10 07:04:43.981	APPROVED	\N	\N	\N	STUDENT	f	\N	f	\N	\N	\N
cmnsk98mx000gl504zrfd7ehq	mohamed tousif ahamed	One school of business	9607820558	1rahamathunnisa.786@gmail.com	$2b$12$G2M642N8xryxBVq5/JPvPOpy526tuZAYejb4sGBpI2Zri.IRLor0K	2026-04-10 07:04:40.184	https://lh3.googleusercontent.com/a/ACg8ocI9rWeQdtI-UjazJf7tOcKVOEZ56zd4wrTNhFFCOXllueEMS9cl_Q=s96-c	\N	\N	\N	2026-04-10 07:04:40.185	2026-04-10 07:05:19.376	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Instagram	\N	\N
cmnsjqn6t0006l504sz6de6hz	Sahanagowda Sahana	ONE SCHOOL OF BUSINESS	7628379865	sahanagowdas979@gmail.com	$2b$12$IXouLFz/2ialZpu22bTaBOS2HXlrRcIBZBcbDA6lemkmYrZqiC0AG	2026-04-10 06:50:12.58	https://lh3.googleusercontent.com/a/ACg8ocJC3k6KEskjJunCa-ykTK443HAWF-6WVgjwDLdNfg4s5CWmyw=s96-c	\N	\N	\N	2026-04-10 06:50:12.581	2026-04-10 07:06:01.663	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Official college event	\N	\N
cmnsr62l60000l704vk4hnxxm	Akarsh	Not specified	9097599449	akarshsuryavenkat@gmail.com	$2b$12$9CPREz9bCZTq5n3k4eM0me7Y1jSnTJ3viGmqKyBlQZcnIzE6qNnnO	2026-04-10 10:18:09.689	https://lh3.googleusercontent.com/a/ACg8ocJUEF8E2WYO4P6aL_3PRpUYgGyGyGRJsvA2z4mBHH_BEkKOPgIW=s96-c	\N	\N	\N	2026-04-10 10:18:09.69	2026-04-10 10:18:11.493	APPROVED	\N	\N	cmnmqwwe20001l704fcndlpxw	STUDENT	f	\N	t	Google registration	\N	\N
cmnssezpb000alf048flq4hmm	yogesh k	CMR University	7635265925	kyogeshyogesh42@gmail.com	$2b$12$poOq37amXbPS4qozqYPdX.CWbbDSjv3nOkwYMqijG6/0P5.V6aJTG	2026-04-10 10:53:05.47	https://lh3.googleusercontent.com/a/ACg8ocI2fNApf96yAeZkQ6nmCduUIu4f4ZlyQEUVPQe73Wx6oM4a8KY=s96-c	\N	\N	\N	2026-04-10 10:53:05.471	2026-04-10 10:53:25.714	APPROVED	\N	\N	\N	STUDENT	f	\N	t	Other	\N	\N
\.


--
-- Name: admin_broadcasts admin_broadcasts_pkey; Type: CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.admin_broadcasts
    ADD CONSTRAINT admin_broadcasts_pkey PRIMARY KEY (id);


--
-- Name: admin_role_templates admin_role_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.admin_role_templates
    ADD CONSTRAINT admin_role_templates_pkey PRIMARY KEY (id);


--
-- Name: admin_scheduled_announcements admin_scheduled_announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.admin_scheduled_announcements
    ADD CONSTRAINT admin_scheduled_announcements_pkey PRIMARY KEY (id);


--
-- Name: announcements announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY (id);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: club_memberships club_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.club_memberships
    ADD CONSTRAINT club_memberships_pkey PRIMARY KEY (id);


--
-- Name: club_onboarding club_onboarding_pkey; Type: CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.club_onboarding
    ADD CONSTRAINT club_onboarding_pkey PRIMARY KEY (id);


--
-- Name: clubs clubs_pkey; Type: CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.clubs
    ADD CONSTRAINT clubs_pkey PRIMARY KEY (id);


--
-- Name: comment_reports comment_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.comment_reports
    ADD CONSTRAINT comment_reports_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: email_otp_tokens email_otp_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.email_otp_tokens
    ADD CONSTRAINT email_otp_tokens_pkey PRIMARY KEY (id);


--
-- Name: event_registrations event_registrations_pkey; Type: CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.event_registrations
    ADD CONSTRAINT event_registrations_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: follows follows_pkey; Type: CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT follows_pkey PRIMARY KEY (id);


--
-- Name: gig_applications gig_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.gig_applications
    ADD CONSTRAINT gig_applications_pkey PRIMARY KEY (id);


--
-- Name: gigs gigs_pkey; Type: CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.gigs
    ADD CONSTRAINT gigs_pkey PRIMARY KEY (id);


--
-- Name: moderation_tickets moderation_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.moderation_tickets
    ADD CONSTRAINT moderation_tickets_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: orbit_projects orbit_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.orbit_projects
    ADD CONSTRAINT orbit_projects_pkey PRIMARY KEY (id);


--
-- Name: platform_settings platform_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.platform_settings
    ADD CONSTRAINT platform_settings_pkey PRIMARY KEY (id);


--
-- Name: post_bookmarks post_bookmarks_pkey; Type: CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.post_bookmarks
    ADD CONSTRAINT post_bookmarks_pkey PRIMARY KEY (id);


--
-- Name: post_likes post_likes_pkey; Type: CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.post_likes
    ADD CONSTRAINT post_likes_pkey PRIMARY KEY (id);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: referral_stats referral_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.referral_stats
    ADD CONSTRAINT referral_stats_pkey PRIMARY KEY (id);


--
-- Name: shares shares_pkey; Type: CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.shares
    ADD CONSTRAINT shares_pkey PRIMARY KEY (id);


--
-- Name: suspicious_access suspicious_access_pkey; Type: CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.suspicious_access
    ADD CONSTRAINT suspicious_access_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: admin_broadcasts_createdAt_idx; Type: INDEX; Schema: public; Owner: occ_4t52_user
--

CREATE INDEX "admin_broadcasts_createdAt_idx" ON public.admin_broadcasts USING btree ("createdAt");


--
-- Name: admin_role_templates_slug_key; Type: INDEX; Schema: public; Owner: occ_4t52_user
--

CREATE UNIQUE INDEX admin_role_templates_slug_key ON public.admin_role_templates USING btree (slug);


--
-- Name: admin_scheduled_announcements_active_startsAt_endsAt_idx; Type: INDEX; Schema: public; Owner: occ_4t52_user
--

CREATE INDEX "admin_scheduled_announcements_active_startsAt_endsAt_idx" ON public.admin_scheduled_announcements USING btree (active, "startsAt", "endsAt");


--
-- Name: audit_logs_adminId_createdAt_idx; Type: INDEX; Schema: public; Owner: occ_4t52_user
--

CREATE INDEX "audit_logs_adminId_createdAt_idx" ON public.audit_logs USING btree ("adminId", "createdAt");


--
-- Name: audit_logs_entity_createdAt_idx; Type: INDEX; Schema: public; Owner: occ_4t52_user
--

CREATE INDEX "audit_logs_entity_createdAt_idx" ON public.audit_logs USING btree (entity, "createdAt");


--
-- Name: club_memberships_userId_clubId_key; Type: INDEX; Schema: public; Owner: occ_4t52_user
--

CREATE UNIQUE INDEX "club_memberships_userId_clubId_key" ON public.club_memberships USING btree ("userId", "clubId");


--
-- Name: club_onboarding_clubSlug_createdAt_idx; Type: INDEX; Schema: public; Owner: occ_4t52_user
--

CREATE INDEX "club_onboarding_clubSlug_createdAt_idx" ON public.club_onboarding USING btree ("clubSlug", "createdAt");


--
-- Name: club_onboarding_userId_clubSlug_key; Type: INDEX; Schema: public; Owner: occ_4t52_user
--

CREATE UNIQUE INDEX "club_onboarding_userId_clubSlug_key" ON public.club_onboarding USING btree ("userId", "clubSlug");


--
-- Name: clubs_headerId_key; Type: INDEX; Schema: public; Owner: occ_4t52_user
--

CREATE UNIQUE INDEX "clubs_headerId_key" ON public.clubs USING btree ("headerId");


--
-- Name: clubs_slug_key; Type: INDEX; Schema: public; Owner: occ_4t52_user
--

CREATE UNIQUE INDEX clubs_slug_key ON public.clubs USING btree (slug);


--
-- Name: email_otp_tokens_email_purpose_expiresAt_idx; Type: INDEX; Schema: public; Owner: occ_4t52_user
--

CREATE INDEX "email_otp_tokens_email_purpose_expiresAt_idx" ON public.email_otp_tokens USING btree (email, purpose, "expiresAt");


--
-- Name: event_registrations_userId_eventId_key; Type: INDEX; Schema: public; Owner: occ_4t52_user
--

CREATE UNIQUE INDEX "event_registrations_userId_eventId_key" ON public.event_registrations USING btree ("userId", "eventId");


--
-- Name: follows_followerId_followingId_key; Type: INDEX; Schema: public; Owner: occ_4t52_user
--

CREATE UNIQUE INDEX "follows_followerId_followingId_key" ON public.follows USING btree ("followerId", "followingId");


--
-- Name: gig_applications_gigId_status_idx; Type: INDEX; Schema: public; Owner: occ_4t52_user
--

CREATE INDEX "gig_applications_gigId_status_idx" ON public.gig_applications USING btree ("gigId", status);


--
-- Name: gig_applications_userId_gigId_key; Type: INDEX; Schema: public; Owner: occ_4t52_user
--

CREATE UNIQUE INDEX "gig_applications_userId_gigId_key" ON public.gig_applications USING btree ("userId", "gigId");


--
-- Name: moderation_tickets_resourceType_resourceId_key; Type: INDEX; Schema: public; Owner: occ_4t52_user
--

CREATE UNIQUE INDEX "moderation_tickets_resourceType_resourceId_key" ON public.moderation_tickets USING btree ("resourceType", "resourceId");


--
-- Name: moderation_tickets_status_dueAt_idx; Type: INDEX; Schema: public; Owner: occ_4t52_user
--

CREATE INDEX "moderation_tickets_status_dueAt_idx" ON public.moderation_tickets USING btree (status, "dueAt");


--
-- Name: post_bookmarks_postId_userId_key; Type: INDEX; Schema: public; Owner: occ_4t52_user
--

CREATE UNIQUE INDEX "post_bookmarks_postId_userId_key" ON public.post_bookmarks USING btree ("postId", "userId");


--
-- Name: post_likes_postId_userId_key; Type: INDEX; Schema: public; Owner: occ_4t52_user
--

CREATE UNIQUE INDEX "post_likes_postId_userId_key" ON public.post_likes USING btree ("postId", "userId");


--
-- Name: suspicious_access_severity_resolved_createdAt_idx; Type: INDEX; Schema: public; Owner: occ_4t52_user
--

CREATE INDEX "suspicious_access_severity_resolved_createdAt_idx" ON public.suspicious_access USING btree (severity, resolved, "createdAt");


--
-- Name: users_email_key; Type: INDEX; Schema: public; Owner: occ_4t52_user
--

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);


--
-- Name: users_phoneNumber_key; Type: INDEX; Schema: public; Owner: occ_4t52_user
--

CREATE UNIQUE INDEX "users_phoneNumber_key" ON public.users USING btree ("phoneNumber");


--
-- Name: users_referralCode_key; Type: INDEX; Schema: public; Owner: occ_4t52_user
--

CREATE UNIQUE INDEX "users_referralCode_key" ON public.users USING btree ("referralCode");


--
-- Name: admin_broadcasts admin_broadcasts_createdById_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.admin_broadcasts
    ADD CONSTRAINT "admin_broadcasts_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: announcements announcements_authorId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT "announcements_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: announcements announcements_clubId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT "announcements_clubId_fkey" FOREIGN KEY ("clubId") REFERENCES public.clubs(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: audit_logs audit_logs_adminId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT "audit_logs_adminId_fkey" FOREIGN KEY ("adminId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: club_memberships club_memberships_clubId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.club_memberships
    ADD CONSTRAINT "club_memberships_clubId_fkey" FOREIGN KEY ("clubId") REFERENCES public.clubs(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: club_memberships club_memberships_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.club_memberships
    ADD CONSTRAINT "club_memberships_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: club_onboarding club_onboarding_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.club_onboarding
    ADD CONSTRAINT "club_onboarding_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: clubs clubs_headerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.clubs
    ADD CONSTRAINT "clubs_headerId_fkey" FOREIGN KEY ("headerId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: comment_reports comment_reports_commentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.comment_reports
    ADD CONSTRAINT "comment_reports_commentId_fkey" FOREIGN KEY ("commentId") REFERENCES public.comments(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: comment_reports comment_reports_reporterId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.comment_reports
    ADD CONSTRAINT "comment_reports_reporterId_fkey" FOREIGN KEY ("reporterId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: comments comments_postId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT "comments_postId_fkey" FOREIGN KEY ("postId") REFERENCES public.posts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: comments comments_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT "comments_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: event_registrations event_registrations_eventId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.event_registrations
    ADD CONSTRAINT "event_registrations_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES public.events(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: event_registrations event_registrations_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.event_registrations
    ADD CONSTRAINT "event_registrations_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: events events_clubId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT "events_clubId_fkey" FOREIGN KEY ("clubId") REFERENCES public.clubs(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: follows follows_followerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT "follows_followerId_fkey" FOREIGN KEY ("followerId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: follows follows_followingId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT "follows_followingId_fkey" FOREIGN KEY ("followingId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gig_applications gig_applications_gigId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.gig_applications
    ADD CONSTRAINT "gig_applications_gigId_fkey" FOREIGN KEY ("gigId") REFERENCES public.gigs(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gig_applications gig_applications_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.gig_applications
    ADD CONSTRAINT "gig_applications_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gigs gigs_clubId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.gigs
    ADD CONSTRAINT "gigs_clubId_fkey" FOREIGN KEY ("clubId") REFERENCES public.clubs(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: gigs gigs_postedById_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.gigs
    ADD CONSTRAINT "gigs_postedById_fkey" FOREIGN KEY ("postedById") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: moderation_tickets moderation_tickets_assigneeId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.moderation_tickets
    ADD CONSTRAINT "moderation_tickets_assigneeId_fkey" FOREIGN KEY ("assigneeId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: notifications notifications_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT "notifications_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: post_bookmarks post_bookmarks_postId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.post_bookmarks
    ADD CONSTRAINT "post_bookmarks_postId_fkey" FOREIGN KEY ("postId") REFERENCES public.posts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: post_bookmarks post_bookmarks_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.post_bookmarks
    ADD CONSTRAINT "post_bookmarks_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: post_likes post_likes_postId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.post_likes
    ADD CONSTRAINT "post_likes_postId_fkey" FOREIGN KEY ("postId") REFERENCES public.posts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: post_likes post_likes_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.post_likes
    ADD CONSTRAINT "post_likes_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: posts posts_clubId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT "posts_clubId_fkey" FOREIGN KEY ("clubId") REFERENCES public.clubs(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: posts posts_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT "posts_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: referral_stats referral_stats_clubHeaderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.referral_stats
    ADD CONSTRAINT "referral_stats_clubHeaderId_fkey" FOREIGN KEY ("clubHeaderId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: referral_stats referral_stats_clubId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.referral_stats
    ADD CONSTRAINT "referral_stats_clubId_fkey" FOREIGN KEY ("clubId") REFERENCES public.clubs(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: referral_stats referral_stats_studentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.referral_stats
    ADD CONSTRAINT "referral_stats_studentId_fkey" FOREIGN KEY ("studentId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shares shares_postId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.shares
    ADD CONSTRAINT "shares_postId_fkey" FOREIGN KEY ("postId") REFERENCES public.posts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shares shares_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.shares
    ADD CONSTRAINT "shares_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users users_adminRoleTemplateId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "users_adminRoleTemplateId_fkey" FOREIGN KEY ("adminRoleTemplateId") REFERENCES public.admin_role_templates(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: users users_pendingLeadClubId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "users_pendingLeadClubId_fkey" FOREIGN KEY ("pendingLeadClubId") REFERENCES public.clubs(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: users users_referredBy_fkey; Type: FK CONSTRAINT; Schema: public; Owner: occ_4t52_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "users_referredBy_fkey" FOREIGN KEY ("referredBy") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: occ_4t52_user
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON SEQUENCES TO occ_4t52_user;


--
-- Name: DEFAULT PRIVILEGES FOR TYPES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TYPES TO occ_4t52_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON FUNCTIONS TO occ_4t52_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TABLES TO occ_4t52_user;


--
-- PostgreSQL database dump complete
--

\unrestrict IxpmjadGXaXVcHKCjAbWiGR8CBl2oId6udfm0Zjopqn8spac8BvB5Uarh6usEOQ

