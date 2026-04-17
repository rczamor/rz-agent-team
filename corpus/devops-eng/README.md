# DevOps Eng — Corpus Index

Role-specific knowledge corpus for the DevOps Eng on the 11-agent team. Scope: single Hostinger VPS (Docker Compose + Postgres + Nginx + Langfuse + Ollama + Paperclip) and Vercel for web apps. Pragmatic SRE. No Kubernetes.

| File | Seed | Why it's here |
| --- | --- | --- |
| [kelsey-hightower.md](./kelsey-hightower.md) | Kelsey Hightower | Principled cover for "boring tech" and "not every workload needs K8s" — aligns with single-VPS choice. |
| [google-sre-book.md](./google-sre-book.md) | Google SRE Book team (Beyer, Jones, Petoff, Murphy) | SLOs, error budgets, blameless postmortems, four golden signals — scaled down to one box. |
| [julia-evans.md](./julia-evans.md) | Julia Evans | Best explainer of Linux/DNS/networking/debugging fundamentals — 80% of VPS incidents map to her zines. |
| [bret-fisher.md](./bret-fisher.md) | Bret Fisher | Canonical Docker Compose educator — healthchecks, good defaults, dev-vs-prod override pattern. |
| [digitalocean-hetzner-linode.md](./digitalocean-hetzner-linode.md) | DigitalOcean + Hetzner + Linode community tutorials | "Just tell me the commands" reference for Nginx, Let's Encrypt, UFW, SSH hardening, Postgres backups. |
| [vercel-docs-lee-robinson.md](./vercel-docs-lee-robinson.md) | Vercel docs + Lee Robinson + Anthony Fu | Deploy target for web apps; `leerob/next-self-host` is the eject path. |
| [selfhosted-community.md](./selfhosted-community.md) | r/selfhosted + Awesome-Selfhosted | Closest community to our actual stack; real-world Compose files and update/backup discipline. |
