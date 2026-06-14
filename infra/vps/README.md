# VPS infra (agent-team execution layer)

Version-controlled copies of the host-side infrastructure deployed to the Hostinger VPS
(`delightful-crystal`, 187.124.155.172) that makes the OpenClaw agent team operational.
These are the **source of truth**; re-deploy with the paths noted below if the box is rebuilt.

## Containment — SNI egress proxy
- **`squid.conf`** → `/etc/squid/squid.conf`. squid-openssl 6.14, `ssl_bump peek step1 / splice
  allowed_sni / terminate all` (NO MITM — peeks the TLS SNI, splices allowlisted hosts, terminates
  the rest). Listens `:3128`; agents reach it at the ollama bridge gateway `172.19.0.1:3128` via
  `HTTPS_PROXY`. Source-gated to `172.19.0.0/16`.
- **`refresh-openclaw-egress-src.sh`** → `/usr/local/sbin/`. Rebuilds the `openclaw_egress_src`
  ipset (hash:ip) from the 11 agent containers' current IPs every 3 min (cron) so the iptables
  `OPENCLAW_EGRESS` default-deny chain self-heals across container recreates.

## Hardening
- **`assert-openclaw-perms.sh`** → `/usr/local/sbin/`. Anti-drift guard (TRZ-541): re-asserts
  mode `600` on every `openclaw.json`, logs drift to `/var/log/openclaw-perms.log`. Hourly cron.

## Event-driven trigger (Linear → team)
- **`agent-team-dispatch.py`** → `/usr/local/sbin/`. The dispatcher: polls/handles Linear issues in
  "Ready for agent build", has the Conductor (Opus) route each to a worker, fires that worker
  (`openclaw agent` CLI) to execute, writes results back to Linear. flock-guarded, dispatched-set
  dedupe. Internal-only.
- **`agent-fire-bridge.py`** + **`agent-fire-bridge.service`** → `/usr/local/sbin/` + systemd. A
  stateless HTTP→CLI connector: the n8n Router's "Fire dispatch (OpenClaw)" node POSTs here
  (token-gated, `X-Fire-Token`), it kicks the dispatcher in the background and returns 202. Bound
  to `172.18.0.1:9191` (n8n's docker bridge gateway, internal only). No schedule/queue/state —
  n8n owns orchestration + retry.

## Secrets
None of these files contain secrets — tokens/keys are read at runtime from per-container `.env`
files, `/data/.openclaw/.ghtoken`, and `/etc/agent-fire-bridge.token` (all `chmod 600`, not committed).
