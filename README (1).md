# Campus Play

A live web app that helps students find pickup games, workouts, and watch parties happening on campus. Post what you're doing, and let others join.

**[Live site →](https://stirring-pastelito-c9652e.netlify.app/)**

## Why I built this

College is a great place to meet people through shared interests, but there's no simple, casual way to say "I'm playing basketball at 6pm, come join" and have people actually see it. This is a lightweight, no-login tool to make that easier for my campus.

## Features

- Post pickup games, workouts, and watch parties across a fully customizable set of sport categories — new sports can be added anytime directly from the database, no code changes needed
- Join/leave games with a live "spots filled" counter, backed by atomic server-side functions so two people can't accidentally overbook the last spot
- "My Games" view — quickly filter down to just what you've hosted or joined
- Add any game to your phone/calendar with one tap (generates a real `.ics` file)
- In-app notifications when someone joins your game
- Star-rating feedback/reviews system so the community can shape what gets added next
- Dark mode toggle, remembered per device
- First-visit walkthrough for people arriving cold from a shared link
- A posting rate limit (3 posts per 10 minutes) to deter spam
- Automatic history: games move to a "Past games" archive after they happen, and are cleaned up automatically after 10 days via a scheduled server-side job
- Installable to your phone's home screen with a real app icon and name
- Fully responsive, mobile-first design

## Tech stack

- **Frontend:** Vanilla HTML/CSS/JavaScript (no framework — built for simplicity and easy hosting)
- **Backend:** [Supabase](https://supabase.com) (Postgres database, row-level security, Postgres functions, scheduled jobs via `pg_cron`)
- **Hosting:** Netlify

## Architecture notes

- No user accounts (by design, for launch simplicity) — identity is a self-declared display name, similar to early-stage social apps
- Joining/leaving a game goes through dedicated Postgres functions rather than a raw table update, so the browser can never rewrite someone else's roster directly via the API
- Old game cleanup runs server-side on a daily cron schedule rather than trusting the client
- The sport/category list lives in its own database table rather than in the code, so it can be edited live without a redeploy
- All data access is governed by Postgres row-level security policies

## Setup (if you want to run your own copy)

1. Create a free [Supabase](https://supabase.com) project
2. In the SQL Editor, run these files in order:
   1. `supabase-schema.sql` — core tables
   2. `grant-permissions.sql` — base table permissions
   3. `schedule-cleanup.sql` — automatic old-game cleanup
   4. `harden-data.sql` — server-side data length limits
   5. `secure-join-leave.sql` — secure join/leave functions
   6. `add-sports-table.sql` — the editable sport/category list
3. Copy your Project URL and anon key from Settings → API
4. Paste them into the `SUPABASE_URL` / `SUPABASE_ANON_KEY` constants near the top of `campus-pickup-web.html`
5. Deploy the HTML file to Netlify, Vercel, or any static host

## Adding a new sport/category

No code changes needed — just add a row to the `sports` table in Supabase (Table Editor → Insert row): an `id`, a `label`, an `emoji`, a `color`, and a `sort_order` to control its position. It appears on the live site within seconds.

## Roadmap / possible next steps

- Restrict signups to verified college email addresses
- Recurring/weekly game templates
- Report/flag button for moderation
- Real push notifications via a backend worker
- Photo uploads for game posts

## Screenshots

*(add a few screenshots here once captured — feed view, post-game modal, dark mode)*

---

Built as a personal learning project — feedback welcome via the in-app review feature.
