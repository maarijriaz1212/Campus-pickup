-- ============================================================
-- Texas Tech Campus Pickup — Supabase schema
-- Paste this entire file into Supabase → SQL Editor → New query → Run
-- ============================================================

-- Games (pickup games / workouts / watch parties)
create table if not exists games (
  id text primary key,
  sport text not null,
  title text not null,
  location text not null,
  notes text,
  host text not null,
  datetime timestamptz not null,
  max_spots int not null,
  joiners jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now()
);

-- Feedback / reviews
create table if not exists feedback (
  id text primary key,
  rating int not null check (rating between 1 and 5),
  comment text,
  name text,
  created_at timestamptz not null default now()
);

-- Notifications ("so-and-so joined your game")
create table if not exists notifications (
  id text primary key,
  recipient text not null,
  joiner_name text not null,
  game_title text not null,
  read boolean not null default false,
  created_at timestamptz not null default now()
);
create index if not exists notifications_recipient_idx on notifications (recipient);

-- App-wide settings (currently just the college name)
create table if not exists app_settings (
  key text primary key,
  value text
);

-- ============================================================
-- Row Level Security
-- This app has no login system (same trust model as the current
-- prototype), so these policies allow public read/write access —
-- anyone with your site's link can post, join, and review, same as today.
-- If you later add real student-email auth, tighten these policies.
-- ============================================================

alter table games enable row level security;
create policy "public read games" on games for select using (true);
create policy "public insert games" on games for insert with check (true);
create policy "public update games" on games for update using (true);
create policy "public delete old games" on games for delete using (true);

alter table feedback enable row level security;
create policy "public read feedback" on feedback for select using (true);
create policy "public insert feedback" on feedback for insert with check (true);

alter table notifications enable row level security;
create policy "public read notifications" on notifications for select using (true);
create policy "public insert notifications" on notifications for insert with check (true);
create policy "public update notifications" on notifications for update using (true);

alter table app_settings enable row level security;
create policy "public read settings" on app_settings for select using (true);
create policy "public upsert settings" on app_settings for insert with check (true);
create policy "public update settings" on app_settings for update using (true);
