-- Run this in Supabase → SQL Editor. It moves game cleanup to a
-- scheduled server-side job, so the website no longer needs permission
-- to delete rows at all — safer than letting anon delete anything.

create extension if not exists pg_cron;

select cron.schedule(
  'purge-old-games',
  '0 3 * * *',  -- every day at 3am UTC
  $$ delete from games where datetime < now() - interval '10 days'; $$
);

-- Now remove the public delete permission — the cron job runs with
-- elevated privileges and doesn't need it, so the website no longer
-- has any ability to delete rows directly.
drop policy if exists "public delete old games" on games;
