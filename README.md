# Campus Pickup — Texas Tech

A live web app that helps students find pickup games, workouts, and watch parties happening on campus — post what you're doing, and let others join.

**[Live site →](https://stirring-pastelito-c9652e.netlify.app/)**

## Why I built this

College is a great place to meet people through shared interests, but there's no simple, casual way to say "I'm playing basketball at 6pm, come join" and have people actually see it. This is a lightweight, no-login tool to make that easier for my campus. I want to make campus lively and social again.

## Features

- Post pickup games and workouts across 12+ categories (basketball, soccer, volleyball, tennis, pickleball, squash, rock climbing, swimming, watch parties, and more)
- Join/leave games with a live "spots filled" counter
- In-app notifications when someone joins your game
- Star-rating feedback/reviews system so the community can shape what gets added next
- Automatic history: games move to a "Past games" archive after they happen, and are cleaned up automatically after 10 days
- Fully responsive, mobile-first design

## Tech stack

- **Frontend:** Vanilla HTML/CSS/JavaScript (no framework — built for simplicity and easy hosting)
- **Backend:** [Supabase](https://supabase.com) (Postgres database, row-level security, scheduled jobs via `pg_cron`)
- **Hosting:** Netlify

## Architecture notes

- No user accounts (by design, for launch simplicity) — identity is a self-declared display name, similar to early-stage social apps
- Old game cleanup runs server-side on a daily cron schedule rather than trusting the client, keeping the browser's database permissions minimal
- All data access is governed by Postgres row-level security policies (see `supabase-schema.sql`)

## Setup (if you want to run your own copy)

1. Create a free [Supabase](https://supabase.com) project
2. Run `supabase-schema.sql`, then `grant-permissions.sql`, then `schedule-cleanup.sql` in the Supabase SQL Editor
3. Copy your Project URL and anon key from Settings → API
4. Paste them into the `SUPABASE_URL` / `SUPABASE_ANON_KEY` constants near the top of `campus-pickup-web.html`
5. Deploy the HTML file to Netlify, Vercel, or any static host

## Roadmap / possible next steps

- Restrict signup to verified college email addresses
- Real push notifications via a backend worker
- Photo uploads for game posts
- Recurring/weekly game templates

---

Built as a personal learning project — feedback welcome via the in-app review feature.
