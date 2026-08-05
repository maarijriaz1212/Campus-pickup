-- Run in Supabase SQL Editor. Adds server-side limits so someone calling
-- the API directly (bypassing your site's own maxlength attributes)
-- can't stuff huge junk data into your database.

alter table games
  add constraint games_title_len check (char_length(title) <= 100),
  add constraint games_location_len check (char_length(location) <= 100),
  add constraint games_notes_len check (notes is null or char_length(notes) <= 500),
  add constraint games_host_len check (char_length(host) <= 40);

alter table feedback
  add constraint feedback_comment_len check (comment is null or char_length(comment) <= 500),
  add constraint feedback_name_len check (name is null or char_length(name) <= 40);

alter table notifications
  add constraint notif_joiner_len check (char_length(joiner_name) <= 40),
  add constraint notif_title_len check (char_length(game_title) <= 100);
