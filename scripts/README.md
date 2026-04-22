# agent-team deploy scripts

Deployment automation for the Hostinger VPS (`srv1535988`, `187.124.155.172`)
that hosts the 11-role OpenClaw fleet.

## Scripts

| Script | Runs | Purpose |
| --- | --- | --- |
| `bootstrap-openclaw-instance.sh` | local or VPS | Create `/docker/openclaw-<role>/` tree + per-role `docker-compose.yml` + `.env` template. Does NOT start containers. |
| `deploy-identities.sh` | local (pushes via SSH) | Sync `TEAM.md`, `USER.md`, per-role `IDENTITY.md`, corpus, and shared skills into each running OpenClaw workspace. Optionally restarts containers. |
| `corpus-refresh-weekly.sh` | VPS (cron/systemd) | Pull latest repo, refresh every instance's corpus + identity, write `.last-refresh` receipt, rotate log. |
| `install-cron.sh` | VPS (once, as root) | Install `corpus-refresh-weekly.sh` to `/usr/local/bin/`, drop `/etc/cron.d/agent-team-corpus`, write systemd timer variant (disabled), ensure `/var/log/agent-team/`. Idempotent. |
| `consolidate-agent-memory.sh` | VPS (cron, nightly 02:30 UTC) | Nightly consolidation of `agent_memory`: archive sessions older than 90 days, write an audit row to `consolidation_runs`. Embed + dedupe paths gated behind pgvector availability (see TRZ-443). `--dry-run` default, `--apply` mutates. Ticket: TRZ-441. |
| `memory-health-report.sh` | VPS (weekly cron, Mondays 08:00 UTC) | Emits a JSON Slack webhook payload summarizing `agent_memory` row counts, dupes, archived sessions, and last consolidation run. Pipe output to `curl -X POST $SLACK_WEBHOOK_URL`. Ticket: TRZ-441. |

## Dependencies

### Local (dev box)
- `rsync`, `ssh`, `git`, `bash` >= 4
- `connect.sh` present two directories up from `scripts/` (i.e.
  `../../connect.sh` relative to this file). It reads `.env.local` for the
  VPS host/user/key. Override via `CONNECT_SH=/path/to/connect.sh` env var.

### VPS
- `docker` + `docker compose` plugin
- `git`, `rsync`
- `cron` (default) or `systemd` >= 240 for the timer variant

## Runbook

### First-time deployment (per role)

Run on the VPS (or via `connect.sh`):

```bash
cd /docker
/path/to/repo/scripts/bootstrap-openclaw-instance.sh ai-eng
vi /docker/openclaw-ai-eng/.env           # paste real secrets
cd /docker/openclaw-ai-eng
docker compose up -d
```

Then from your dev box:

```bash
./scripts/deploy-identities.sh --role ai-eng
```

Repeat for each of the 11 roles.

### Weekly corpus refresh (automated)

Install once on the VPS (as root):

```bash
sudo /path/to/repo/scripts/install-cron.sh
```

The cron entry runs `corpus-refresh-weekly.sh` every Monday at 03:05 UTC and
writes logs to `/var/log/agent-team/corpus-refresh.log` (rotated weekly, 12
rotations kept).

**Why cron over systemd?** Cron is the default because `/etc/cron.d/` drops are
trivial to audit and don't require `systemd daemon-reload`. The systemd timer
variant is written too but stays disabled — opt in if you need missed-run
catch-up semantics (`Persistent=true`):

```bash
sudo rm -f /etc/cron.d/agent-team-corpus
sudo systemctl enable --now agent-team-corpus-refresh.timer
```

### Recovery / ad-hoc resync

Push fresh identity + corpus to a single role (skips restart):

```bash
./scripts/deploy-identities.sh --role devops-eng --no-restart
```

Dry run (show what would change, touch nothing):

```bash
./scripts/deploy-identities.sh --dry-run
```

Force a weekly refresh right now on the VPS:

```bash
ssh root@187.124.155.172 /usr/local/bin/corpus-refresh-weekly.sh
```

## Structured log format

`deploy-identities.sh` emits one line per (role, step):

```
[deploy-identities] role=<role> step=<step> status=<ok|skipped|failed> [details]
```

`corpus-refresh-weekly.sh` emits:

```
<ISO-8601-Z> [corpus-refresh] role=<role> step=<step> status=<ok|skipped|failed> ...
```

Grep-friendly for log aggregation.

## Exit codes

- `0` — all selected roles synced successfully (or skipped tolerably).
- `1` — at least one critical step failed (SSH, rsync, git). Missing target
  directories on the VPS are warnings, not failures.
- `2` — bad arguments / usage error.
