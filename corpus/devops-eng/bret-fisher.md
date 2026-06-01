---
name: Bret Fisher
role: devops-eng
type: individual
researched: 2026-04-16
---

# Bret Fisher

## Why they matter to the DevOps Eng
Bret Fisher (Docker Captain, long-running *Docker Mastery* course, weekly YouTube live show) is the most practical educator specifically for Docker + Docker Compose on a single server — which is exactly our Hostinger VPS setup running Postgres, Nginx, Langfuse, Ollama, and Paperclip. His "good defaults" repos are reference templates for healthchecks, graceful shutdown, multi-stage builds, and dev-vs-prod Compose files. He's also pragmatically honest about the boundary: Compose is great for dev and acceptable for small prod, but has no built-in rolling updates or self-healing, so you compensate with healthchecks, `restart: unless-stopped`, and a reverse proxy.

## Signature works & primary sources
- *Docker Mastery* (Udemy course) — https://www.bretfisher.com/courses/ — ~20h, covers everything from `docker run` to multi-host Swarm.
- *node-docker-good-defaults* — https://github.com/BretFisher/node-docker-good-defaults — the canonical Node+Compose template.
- *php-docker-good-defaults* — https://github.com/BretFisher/php-docker-good-defaults
- YouTube channel (weekly live Q&A) — https://youtube.com/@BretFisher
- Blog: https://www.bretfisher.com
- "Docker Good Defaults" talk (multiple confs incl. Craft) — covers HEALTHCHECK, SIGTERM, NODE_ENV, bind mounts.

## Core principles (recurring patterns)
- **Dev-vs-prod via Compose override.** Base `docker-compose.yml` is production-shaped; `docker-compose.override.yml` layers in bind mounts, exposed ports, and dev env vars.
- **Every service gets a HEALTHCHECK.** Compose/Swarm use it for restart logic; reverse proxies read it; it's your first-line "is this alive?" signal.
- **Use specific image tags, not `latest`.** Pin to `postgres:16.4` not `postgres:latest` so you can roll back deterministically.
- **Graceful shutdown matters.** Run the app as PID 1 (or with `tini`), handle SIGTERM, set Compose `stop_grace_period`.
- **Multi-stage builds keep images small and safe.** Don't ship your toolchain to production.
- **Compose is great for a single host; for multi-host use Swarm before Kubernetes.** Don't skip the ladder.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Compose service skeleton with healthcheck + graceful shutdown:**
  ```yaml
  services:
    web:
      image: ghcr.io/org/app:1.4.2
      restart: unless-stopped
      stop_grace_period: 30s
      init: true
      environment:
        NODE_ENV: production
      healthcheck:
        test: ["CMD", "wget", "-qO-", "http://localhost:3000/healthz"]
        interval: 30s
        timeout: 5s
        retries: 3
        start_period: 20s
      depends_on:
        postgres:
          condition: service_healthy
      networks: [backend]
  ```
- **Postgres service (the one you'll reuse across projects):**
  ```yaml
    postgres:
      image: postgres:16.4-alpine
      restart: unless-stopped
      environment:
        POSTGRES_USER_FILE: /run/secrets/pg_user
        POSTGRES_PASSWORD_FILE: /run/secrets/pg_password
        POSTGRES_DB: app
      volumes:
        - pgdata:/var/lib/postgresql/data
      healthcheck:
        test: ["CMD-SHELL", "pg_isready -U app"]
        interval: 10s
      secrets: [pg_user, pg_password]
  ```
- **Compose override pattern** — keep secrets and bind mounts out of the base file; commit `docker-compose.prod.yml` separately.
- **Multi-stage Dockerfile checklist**: `FROM node:20-alpine AS build` → install/build → `FROM node:20-alpine AS runtime` → copy only `dist/` and `node_modules` → `USER node` → `HEALTHCHECK` → `CMD ["node", "index.js"]`.

## Where they disagree with others
- Vs. "Compose in production is fine forever": Fisher is honest that Compose lacks rolling updates; he recommends Swarm (still boring Docker, no K8s) when you outgrow it.
- Vs. "latest tag is fine": he's adamantly against `:latest` in production — rollback becomes impossible.
- Vs. devs who run `npm start` in containers: he wants `node index.js` so SIGTERM actually reaches your app.

## Pointers to source material
- bretfisher.com — blog, courses, talks
- github.com/BretFisher — good-defaults repos
- youtube.com/@BretFisher — weekly Docker & DevOps live show
- Docker Captain profile: https://www.docker.com/captains/bret-fisher/
