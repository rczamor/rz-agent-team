---
name: Vercel docs + Lee Robinson + Anthony Fu
role: devops-eng
type: organization
researched: 2026-04-16
---

# Vercel docs + Lee Robinson + Anthony Fu

## Why they matter to the DevOps Eng
Vercel is the deploy target for our web apps (rz-personal-website, Recipe Remix, and future Next.js surfaces). Lee Robinson (former VP DevEx at Vercel) is the most practical source on Next.js deployment tradeoffs — both on Vercel and self-hosted — and published `next-self-host`, a reference repo for the exact Next+Postgres+Nginx+Ubuntu setup we'd use if we ever eject. Anthony Fu (core Vue/Nuxt/UnJS) covers the Nitro/Nuxt side which also deploys cleanly to Vercel. Together they cover the "Vercel by default, self-host when it matters" posture we want. For a DevOps Eng, the job is: know when to stay on Vercel (CDN, preview URLs, edge, zero-ops), when to self-host (long-running work, Postgres that lives near the app, cost), and how to wire env vars, Postgres, and domains without drama.

## Signature works & primary sources
- Vercel Docs — https://vercel.com/docs — deployment, env vars, edge functions, preview URLs, cron jobs.
- Lee Robinson — https://leerob.com — blog posts on Next.js deployment, self-hosting, framework-defined infra.
- `leerob/next-self-host` — https://github.com/leerob/next-self-host — Next + Postgres + Nginx on Ubuntu reference.
- "Why I'm Using Next.js" — https://leerob.io/blog/using-nextjs
- Vercel Blog — https://vercel.com/blog — release notes, perf stories.
- Anthony Fu — https://antfu.me — Nuxt/Nitro/UnJS ecosystem deploy patterns.
- Vercel Build Output API — https://vercel.com/docs/build-output-api — the open spec that makes "eject to self-host" real.

## Core principles (recurring patterns)
- **Deploy on `git push`; preview every PR.** Every branch gets a URL; every PR is a staging environment. Non-negotiable.
- **Env vars per environment (Development / Preview / Production).** Never commit secrets; pull with `vercel env pull` for local.
- **Framework-defined infrastructure.** The framework (Next.js, Nuxt) declares what it needs; the platform provisions it. Don't hand-roll routing config.
- **Edge where it helps, Node where it doesn't.** Auth middleware and geo-routing = edge. Postgres-heavy work = Node runtime / regions close to DB.
- **Keep the DB close to the compute.** Vercel Postgres (Neon) in the same region as your functions, or accept the latency and cache aggressively.
- **Self-host is always possible.** Next.js `output: 'standalone'` runs anywhere; `leerob/next-self-host` is the template.

## Concrete templates, checklists, or artifacts the agent can reuse
- **New Vercel project day-1 checklist:**
  1. `vercel link` in the repo.
  2. Add custom domain; verify DNS (CNAME to `cname.vercel-dns.com`).
  3. Set env vars in Vercel dashboard for Production + Preview (at minimum: `DATABASE_URL`, `NEXTAUTH_SECRET`, third-party keys).
  4. `vercel env pull .env.local` for local dev.
  5. Add Neon Postgres via Marketplace integration; confirm env vars auto-inject.
  6. Protect the production branch; require PR + preview URL.
  7. Add Cron Jobs (`vercel.json`) for any scheduled work.
- **`vercel.json` cron template:**
  ```json
  {
    "crons": [
      { "path": "/api/cron/daily-digest", "schedule": "0 13 * * *" }
    ]
  }
  ```
- **Next.js standalone Dockerfile** (for self-host fallback):
  ```dockerfile
  FROM node:20-alpine AS build
  WORKDIR /app
  COPY package*.json ./
  RUN npm ci
  COPY . .
  RUN npm run build
  FROM node:20-alpine AS runtime
  WORKDIR /app
  ENV NODE_ENV=production
  COPY --from=build /app/.next/standalone ./
  COPY --from=build /app/.next/static ./.next/static
  COPY --from=build /app/public ./public
  EXPOSE 3000
  CMD ["node", "server.js"]
  ```
  (requires `output: 'standalone'` in `next.config.js`).
- **Vercel-to-VPS eject decision checklist**: long-running requests >30s? background workers? egress-heavy? Postgres co-location? If yes to 2+, consider self-host for that surface.
- **Env-var hygiene**: `NEXT_PUBLIC_*` is bundled to client — never put secrets there. Use `VERCEL_ENV` to branch behavior per environment.

## Where they disagree with others
- Vs. "everything on one VPS" (Hightower-adjacent): the Vercel camp argues a static/SSR frontend on a CDN is strictly better than Nginx-on-VPS for web — and they're largely right for marketing sites and dashboards.
- Vs. "never lock in to a platform": Lee Robinson's counter is Next.js output is identical on Vercel vs. self-host, so lock-in is low if you use standard features.
- Vs. K8s-first: Anthony Fu / UnJS approach (Nitro presets) is explicitly multi-target — same app deploys to Vercel, Netlify, Cloudflare, Node. No orchestrator needed.

## Pointers to source material
- https://vercel.com/docs
- https://leerob.com
- https://github.com/leerob/next-self-host
- https://antfu.me
- https://nitro.unjs.io — Nitro presets for multi-target deploy
- Vercel Marketplace (Neon, Upstash) — https://vercel.com/marketplace
