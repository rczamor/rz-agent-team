---
name: r/selfhosted + Awesome-Selfhosted
role: devops-eng
type: community
researched: 2026-04-16
---

# r/selfhosted + Awesome-Selfhosted

## Why they matter to the DevOps Eng
This is the closest community to our actual setup: one VPS, Docker Compose, a pile of self-hosted tools (Langfuse, Ollama, Paperclip, plus common neighbors like Vaultwarden, Uptime Kuma, Traefik/Caddy, Watchtower, Nextcloud). The r/selfhosted subreddit is where you'll find real-world "my Compose file for X + reverse proxy + backups" posts, and the Awesome-Selfhosted GitHub list is the canonical directory of alternatives. For a DevOps Eng, the value is pattern-matching: someone has already solved "Langfuse behind Nginx with SSL" or "Ollama with GPU passthrough on bare metal" — borrow their Compose and move on. The community also has strong norms around backups, update discipline, and not exposing services to the public internet without auth.

## Signature works & primary sources
- r/selfhosted — https://www.reddit.com/r/selfhosted/ — ~400k members, weekly "what are you running" threads.
- Awesome-Selfhosted — https://github.com/awesome-selfhosted/awesome-selfhosted — curated list, open-source licenses only.
- Awesome-Selfhosted website — https://awesome-selfhosted.net/
- `DoTheEvo/selfhosted-apps-docker` — https://github.com/DoTheEvo/selfhosted-apps-docker — "Guide by Example" Compose files for dozens of apps.
- `hotheadhacker/awesome-selfhost-docker` — https://github.com/hotheadhacker/awesome-selfhost-docker — Docker-deployable subset.
- Linuxserver.io images — https://docs.linuxserver.io — standardized, security-maintained images for most self-hosted apps.
- r/selfhosted wiki — https://www.reddit.com/r/selfhosted/wiki — getting-started guides.

## Core principles (recurring patterns)
- **One reverse proxy, many services.** Traefik or Caddy with automatic HTTPS, or Nginx with Certbot. Each app gets a subdomain; nothing binds to 0.0.0.0 except the proxy.
- **Pin image tags; don't run `latest` in prod.** Watchtower can auto-update, but only after you've proven an app survives it.
- **Bind-mount data next to the Compose file.** `./data/<service>` beats named volumes for "I can tar this whole folder and move it."
- **Backups on cron, offsite copy, test restores.** Restic or rclone to Backblaze B2 / S3. Untested backups are a lie.
- **Don't expose admin UIs to the public internet.** Put Portainer, Langfuse admin, etc. behind Tailscale/WireGuard or basic auth + IP allow-list.
- **Update discipline: weekly window, read release notes, snapshot first.** Most incidents are self-inflicted via careless updates.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Reference directory layout for a self-hosted stack:**
  ```
  /srv/stack/
    docker-compose.yml
    .env                       # chmod 600, gitignored
    nginx/
      conf.d/*.conf
    data/
      postgres/
      langfuse/
      ollama/
      paperclip/
    backups/                   # cron destination
  ```
- **Multi-service Compose skeleton** (abridged):
  ```yaml
  services:
    postgres:
      image: postgres:16.4-alpine
      restart: unless-stopped
      volumes: [./data/postgres:/var/lib/postgresql/data]
      environment:
        POSTGRES_PASSWORD_FILE: /run/secrets/pg_password
      healthcheck:
        test: ["CMD-SHELL", "pg_isready"]
    langfuse:
      image: langfuse/langfuse:2.90.0
      restart: unless-stopped
      depends_on: { postgres: { condition: service_healthy } }
      environment:
        DATABASE_URL: postgresql://langfuse:${PG_PASS}@postgres:5432/langfuse
        NEXTAUTH_URL: https://langfuse.example.com
      expose: ["3000"]       # not published; Nginx proxies
    ollama:
      image: ollama/ollama:0.5.4
      restart: unless-stopped
      volumes: [./data/ollama:/root/.ollama]
      expose: ["11434"]
  ```
- **Weekly update runbook**: snapshot VPS (Hostinger panel) → `docker compose pull` → read CHANGELOG for each bumped image → `docker compose up -d` → watch `docker compose logs -f` for 5 min → verify healthchecks → note result in ops log.
- **Backup-and-offsite cron** (`/etc/cron.d/stack-backup`):
  ```
  0 2 * * * root cd /srv/stack && docker compose exec -T postgres pg_dumpall -U postgres | gzip > backups/pg-$(date +\%Y\%m\%d).sql.gz
  0 3 * * 0 root restic -r b2:rz-backups:/srv backup /srv/stack/data /srv/stack/backups --exclude '*.tmp'
  0 4 * * 0 root restic -r b2:rz-backups:/srv forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune
  ```
- **"Should I expose this?" checklist**: Does it have auth? Is auth battle-tested? Do I need public access, or would Tailscale suffice? If in doubt → Tailscale-only.

## Where they disagree with others
- Vs. Vercel-style managed-everything: r/selfhosted's bias is strong toward "own your stack"; the tradeoff is more ops time and the occasional "I broke my own email server for a weekend" story.
- Vs. K8s hobbyists (r/homelab overlap): r/selfhosted is mostly pro-Compose / anti-K8s for single-box setups; k3s is tolerated but not recommended.
- Vs. enterprise-SRE formalism: less SLO math, more "watch the logs, snapshot before you touch anything, keep a restore script."

## Pointers to source material
- https://www.reddit.com/r/selfhosted/
- https://github.com/awesome-selfhosted/awesome-selfhosted
- https://awesome-selfhosted.net/
- https://github.com/DoTheEvo/selfhosted-apps-docker
- https://docs.linuxserver.io
- https://selfh.st — weekly self-hosted newsletter / app directory
