# agent-team :: unified deploy

Single `docker-compose.yml` for the whole agent-team stack. This is a **reference artifact**, not auto-deployed — you run it by hand on the VPS when you're ready to cut over from the per-project layout currently under `/docker/`.

## Target VPS

- Host: `187.124.155.172` (srv1535988 / "delightful-crystal")
- OS: Ubuntu 24.04
- 4 vCPU / 15 GiB RAM
- Managed by Hostinger (HVPS platform: `openclaw-*`, `paperclip-*`, `monarx-agent.service`)
- SSH details: see [hostinger_vps.md](../../hostinger_vps.md)

## What this stack contains

| Service | Purpose | Public? |
|---|---|---|
| `openclaw-conductor` … `openclaw-tech-writer` (11) | Per-role agent runtimes | No (host-local port 47810–47820) |
| `paperclip` | Hostinger HVPS sidecar | `paperclip.${PUBLIC_DOMAIN}` |
| `langfuse-web` | Observability UI | `langfuse.${PUBLIC_DOMAIN}` |
| `langfuse-worker`, `langfuse-postgres`, `langfuse-redis`, `langfuse-clickhouse`, `langfuse-minio` | Langfuse internals | No |
| `agent-memory` | Shared postgres 17 for agent memory | No (loopback `127.0.0.1:54330`) |
| `ollama` | Local embeddings (`nomic-embed-text` only) | No (host-local `:32768`) |
| `cloudbeaver` | Browser DB GUI | `db.${PUBLIC_DOMAIN}` |
| `traefik` | TLS termination + ACME | `:80`, `:443` |

`n8n` is intentionally omitted (CAR-327 removes it). `sia-engine` stays at `/opt/sia`, outside this compose.

## Port map

OpenClaw instances use the fixed block `47810–47820`, one per role:

| Port | Role |
|---|---|
| 47810 | conductor *(Opus)* |
| 47811 | pm |
| 47812 | researcher |
| 47813 | designer |
| 47814 | backend-eng |
| 47815 | data-eng |
| 47816 | ai-eng *(Opus)* |
| 47817 | ui-eng |
| 47818 | qa-eng |
| 47819 | devops-eng |
| 47820 | tech-writer |

## Fresh deploy

```bash
# 1. SSH to the VPS
ssh root@187.124.155.172

# 2. Stage the project
mkdir -p /docker/agent-team-unified
cd /docker/agent-team-unified

# 3. Copy this compose file + .env.example from your laptop
#    (run on laptop:)
#    scp repo/deploy/docker-compose.yml  root@187.124.155.172:/docker/agent-team-unified/
#    scp repo/deploy/.env.example        root@187.124.155.172:/docker/agent-team-unified/.env.example

# 4. Seed .env from existing per-project .env files
cp .env.example .env
# Pull secrets from the current projects:
grep -h '^ANTHROPIC_API_KEY\|^OLLAMA_API_KEY\|^LANGFUSE_' /docker/openclaw-*/.env | sort -u
grep -h '^POSTGRES_\|^LANGFUSE_' /docker/langfuse/.env
grep -h '^POSTGRES_' /docker/agent-memory/.env
grep -h '^PAPERCLIP_' /docker/paperclip-*/.env
# Edit .env and paste the values in.
vim .env

# 5. Preflight: validate compose parses
docker compose config --quiet

# 6. Pre-create per-role bind mount directories so Docker doesn't own them as root:root
for role in conductor pm researcher designer backend-eng data-eng ai-eng ui-eng qa-eng devops-eng tech-writer; do
  mkdir -p "./openclaw/${role}/data" "./openclaw/${role}/corpus"
done

# 7. Bring it up
docker compose up -d

# 8. Pull nomic-embed-text into the local ollama
docker compose exec ollama ollama pull nomic-embed-text
```

## Incremental cutover from the current layout

The VPS currently runs the stack as separate compose projects (`/docker/langfuse`, `/docker/agent-memory`, `/docker/openclaw-*`, etc). You can migrate one piece at a time — the unified compose uses distinct container names (`openclaw-conductor`, not `openclaw-mg2c`) and a different project dir, so the two layouts don't collide unless they try to bind the same host port.

**Recommended order** (least-risky first):

1. **Agent-memory** → keep the existing `/docker/agent-memory` postgres running; point the unified compose's `AGENT_MEMORY_DSN` at the external container by temporarily commenting out the `agent-memory` service and using the existing DSN. Once you're confident, do a pg_dump → pg_restore into the unified `agent-memory` volume and flip back.
2. **Ollama** → stop `/docker/ollama-apvg` (frees host port 32768), bring up unified `ollama`, run `ollama pull nomic-embed-text`.
3. **Paperclip** → stop `/docker/paperclip-hxtc`, start unified `paperclip`.
4. **CloudBeaver** → stop `/docker/cloudbeaver`, start unified `cloudbeaver`. If you had a saved workspace, copy `/docker/cloudbeaver/workspace` into the new `cloudbeaver_data` volume first.
5. **Langfuse** → this is the scariest migration because of the 4 stateful backends (postgres, clickhouse, minio, redis). Options:
   - **Easy:** keep `/docker/langfuse` running, just point the unified openclaw services at it. Leave the unified langfuse-* services stopped.
   - **Full move:** snapshot `/docker/langfuse` volumes, stop the old stack, copy volume data into the unified volume names (`langfuse_postgres_data`, `langfuse_clickhouse_data`, `langfuse_minio_data`), start.
6. **OpenClaw instances** → for each of the 11 roles:
   - Copy any workspace state you want to keep: `cp -a /docker/openclaw-<old-name>/data/ /docker/agent-team-unified/openclaw/<role>/data/`.
   - Seed the corpus: run `scripts/build-corpus.sh <role>` so `./openclaw/<role>/corpus` is populated.
   - `docker compose up -d openclaw-<role>`.
   - Smoke test (see below).
   - Only then: `cd /docker/openclaw-<old-name> && docker compose down`. One instance at a time.
7. **Traefik** → last. The current Traefik is embedded in `/docker/n8n`. Stop that project last; the unified Traefik will bind `:80`/`:443`.

## Verify

```bash
# All services running + healthy
docker compose ps

# Resource headroom (should be well under 10 GiB resident for the whole stack)
docker stats --no-stream

# OpenClaw health sweep (on the VPS itself)
for p in 47810 47811 47812 47813 47814 47815 47816 47817 47818 47819 47820; do
  printf "port %s: " "$p"
  curl -fsS "http://localhost:${p}/health" || echo "DOWN"
  echo
done

# Public endpoints (from anywhere)
curl -fsSI "https://paperclip.${PUBLIC_DOMAIN}"   | head -1
curl -fsSI "https://langfuse.${PUBLIC_DOMAIN}"    | head -1
curl -fsSI "https://db.${PUBLIC_DOMAIN}"          | head -1

# Agent-memory reachable from an openclaw container
docker compose exec openclaw-conductor \
  psql "$AGENT_MEMORY_DSN" -c 'SELECT 1;'

# Langfuse ingest reachable
docker compose exec openclaw-conductor \
  curl -fsS http://langfuse-web:3000/api/public/health

# Embeddings reachable
docker compose exec openclaw-conductor \
  curl -fsS http://ollama:11434/api/tags
```

## Rollback

Each old `/docker/<project>` is untouched by this compose. If something goes sideways:

```bash
cd /docker/agent-team-unified && docker compose down
cd /docker/<old-project>      && docker compose up -d
```

Stateful data for the unified stack lives in named volumes (`agent_memory_data`, `langfuse_*`, `ollama_models`, `cloudbeaver_data`, `traefik_letsencrypt`) and in the per-role bind mounts under `./openclaw/`. Nothing is shared with the old projects unless you manually copied data across.

## Files

- `docker-compose.yml` — the stack
- `.env.example` — all referenced env vars, grouped by service
- This README

## Notes & gotchas

- **Don't expose 47810–47820 publicly.** They bind to the default interface in this compose; if your VPS firewall isn't already blocking inbound on that range, add a deny rule or switch the `ports:` entries to `"127.0.0.1:4781X:8080"`.
- **Opus-primary roles** (`conductor`, `ai-eng`) are flagged via `AGENT_MODEL_TIER=opus`; everything else is `workhorse`. If you start hitting Anthropic quota, that var is the knob.
- **Migrations**: `agent-memory` auto-runs `../migrations/*.sql` on first boot (relative to the compose file, i.e. `repo/migrations/`). If you're deploying without the full repo, drop those SQL files into `/docker/agent-team-unified/migrations/` and change the bind mount path.
- **Corpus freshness**: the `./openclaw/<role>/corpus` bind mounts are seeded by your build script, not by the containers. Re-run the script and the containers pick up new files on next retrieval — no restart needed.
