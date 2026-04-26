# EasyHalf

**Half Marathon Training Tracker**

EasyHalf is a fitness tracking web app that helps runners follow personalized half marathon training plans. Choose a goal finish time (1:30, 1:45, or 2:00) and get a 12–15 week structured program with daily workouts you can track as complete.

## Features

- **Admin** — Default view when opening the app without a token. Plan recommender (dropdowns or quick paste), generate one-time customer links, email templates (plan access + payment), list of generated links (copy, delete, cleanup used).
- **Customer links** — One-time links: generate from admin, send to client; client opens `?token=...` and gets their plan. Tokens stored in `data/customer-tokens.json`.
- **Training dashboard** — Week-by-week view with collapsible sections and workout checkboxes (for customers with a valid token).
- **Progress tracking** — Completed workouts stored in browser localStorage.
- **Guide & strength & conditioning** — Intro content on heart rate zones, workout types, warm-up/cool-down, and S&C exercises.
- **Trial & payment-success** — Stub pages at `/trial` and `/payment-success` (trial/payment APIs not wired in this build).
- **Distance unit toggle** — Switch between km and miles.
- **Mobile-first** — Responsive layout and touch-friendly UI.

## Tech stack

- **Frontend:** React 18, TypeScript, Vite, Tailwind CSS, shadcn/ui (Radix), TanStack Query.
- **Backend:** Node.js, Express, in-memory storage (plans and guide data in code).
- **Data:** Training plans and guide content in `server/storage.ts`; no database required to run.

## Assets

- **Logo:** Put **EH new logo.jpeg** in `client/public/`. Used on the loading screen and in the dashboard header.
- **Favicon:** `client/public/favicon/favicon.svg` — used as the browser tab icon.

## Setup

```bash
npm install
```

## Development

```bash
npm run dev
```

App and API are served at **http://localhost:5000** (or the port in `PORT` env).

## Build & production

```bash
npm run build
npm start
```

Production server serves the built client from `dist/public` and runs the API on the same port.

## Environment (optional)

Copy `.env.example` to `.env` and adjust.

- `PORT` — Server port (default `5000`).
- Customer links are generated from the admin and stored in `data/customer-tokens.json` (no env needed for tokens).

## Project structure

- `client/` — React app (Vite, Tailwind, shadcn).
- `server/` — Express API and static file serving; `storage.ts` holds plan and guide data; `tokenStore.ts` persists customer tokens to `data/customer-tokens.json`.
- `shared/` — Shared types and Zod schemas (`schema.ts`).
- `public/` — Static assets (e.g. exercise images); `client/public/` is the frontend public folder (favicon, etc.).
