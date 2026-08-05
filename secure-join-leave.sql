-- Run this in Supabase → SQL Editor.
--
-- Instead of letting the browser overwrite the entire joiners list
-- directly (which would let anyone rewrite someone else's roster via
-- the API), these functions run server-side, only ever add/remove ONE
-- name at a time, and re-check the spot limit atomically so two people
-- can't both squeeze into the last spot at the same instant.

create or replace function join_game(p_game_id text, p_name text)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_joiners jsonb;
  v_max int;
begin
  select joiners, max_spots into v_joiners, v_max from games where id = p_game_id for update;
  if v_joiners is null then
    raise exception 'game not found';
  end if;
  if v_joiners ? p_name then
    return v_joiners; -- already joined, no-op
  end if;
  if jsonb_array_length(v_joiners) >= v_max then
    raise exception 'game is full';
  end if;
  v_joiners := v_joiners || to_jsonb(p_name);
  update games set joiners = v_joiners where id = p_game_id;
  return v_joiners;
end;
$$;

create or replace function leave_game(p_game_id text, p_name text)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_joiners jsonb;
begin
  select joiners into v_joiners from games where id = p_game_id for update;
  if v_joiners is null then
    raise exception 'game not found';
  end if;
  v_joiners := (
    select coalesce(jsonb_agg(elem), '[]'::jsonb)
    from jsonb_array_elements(v_joiners) elem
    where elem <> to_jsonb(p_name)
  );
  update games set joiners = v_joiners where id = p_game_id;
  return v_joiners;
end;
$$;

grant execute on function join_game(text, text) to anon, authenticated;
grant execute on function leave_game(text, text) to anon, authenticated;

-- The browser can no longer update the games table directly at all —
-- joining/leaving now only happens through the two narrow functions above.
revoke update on public.games from anon, authenticated;
