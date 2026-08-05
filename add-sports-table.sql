-- Run this in Supabase → SQL Editor.
-- Moves the sport/category list into the database so you can add,
-- rename, recolor, or reorder sports without ever touching the code
-- or redeploying to Netlify — just insert/edit/delete rows in this table.

create table if not exists sports (
  id text primary key,
  label text not null,
  emoji text not null,
  color text not null,
  sort_order int not null default 0
);

alter table sports enable row level security;
create policy "public read sports" on sports for select using (true);
grant select on public.sports to anon, authenticated;

-- Seed it with your current list, in the same order they appear today.
insert into sports (id, label, emoji, color, sort_order) values
  ('indoor-basketball', 'Indoor Basketball', '🏀', '#E8602A', 10),
  ('outdoor-basketball', 'Outdoor Basketball', '🏀', '#F0A23C', 20),
  ('soccer', 'Soccer', '⚽', '#3FAE5E', 30),
  ('indoor-volleyball', 'Indoor Volleyball', '🏐', '#E0B325', 40),
  ('beach-volleyball', 'Sand Volleyball', '🏖️', '#F0924C', 50),
  ('tennis', 'Tennis', '🎾', '#8FBE2C', 60),
  ('pickleball', 'Pickleball', '🏓', '#2E9FD6', 70),
  ('squash', 'Squash', '🏸', '#8B6FD6', 80),
  ('swimming-pool', 'Swimming Pool', '🏊', '#1FADC2', 90),
  ('rock-climbing', 'Rock Climbing', '🧗', '#D6485F', 100),
  ('workout', 'Workout', '🏋️', '#D6559C', 110),
  ('watch-party', 'Watch Party', '📺', '#C4972E', 120),
  ('other', 'Other', '🔥', '#6E7D70', 130)
on conflict (id) do nothing;

-- ============================================================
-- HOW TO ADD A NEW SPORT LATER (no code, no redeploy):
-- Just run an insert like this one, any time, from the SQL Editor
-- or Table Editor:
--
-- insert into sports (id, label, emoji, color, sort_order) values
--   ('flag-football', 'Flag Football', '🏈', '#4477AA', 125);
--
-- 'id' must be unique and lowercase-with-dashes.
-- 'sort_order' controls left-to-right position in the tabs (lower = earlier).
-- ============================================================
