-- Run this in Supabase → SQL Editor if posts/reviews are saving but then
-- disappearing (or not showing up in Table Editor at all).
-- This explicitly grants the anon role permission to read/write these
-- tables, in case the default project privileges didn't cover tables
-- created via the SQL Editor.

grant usage on schema public to anon, authenticated;

grant select, insert, update, delete on public.games to anon, authenticated;
grant select, insert, update, delete on public.feedback to anon, authenticated;
grant select, insert, update, delete on public.notifications to anon, authenticated;
grant select, insert, update, delete on public.app_settings to anon, authenticated;
