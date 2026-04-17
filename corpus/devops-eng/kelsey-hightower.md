---
name: Kelsey Hightower
role: devops-eng
type: individual
researched: 2026-04-16
---

# Kelsey Hightower

## Why they matter to the DevOps Eng
Hightower is the most credible voice arguing that most teams don't need Kubernetes, microservices, or cloud-native maximalism — which is exactly the energy our single-Hostinger-VPS + Docker Compose + Vercel architecture lives on. He ran Kubernetes at Google, wrote *Kubernetes the Hard Way* (the reference training path), and then spent years telling engineers to stop adopting it by default. For a DevOps Eng operating one VPS with Postgres, Nginx, Langfuse, and Ollama — plus Vercel for web — Hightower's framing gives principled cover for every "boring" decision: keep the monolith, use systemd and cron before you reach for orchestrators, pick discipline over platform, and measure complexity in how many things break at 3am.

## Signature works & primary sources
- *Kubernetes the Hard Way* — https://github.com/kelseyhightower/kubernetes-the-hard-way — canonical "understand the primitives before you automate them" curriculum.
- *"Monoliths are the Future"* (Changelog, 2020) — https://changelog.com/gotime/114 — the clearest articulation of distributed-monolith antipatterns.
- Hightower–Sigelman monoliths-vs-microservices debate — https://thenewstack.io/kelsey-hightower-and-ben-sigelman-debate-microservices-vs-monoliths/ — "discipline is required no matter what the platform is."
- Twitter/X @kelseyhightower — ongoing pragmatism posts and "not every workload needs K8s" takes.
- *No Code* repo — https://github.com/kelseyhightower/nocode — satire reinforcing "the best code is no code."

## Core principles (recurring patterns)
- **Pick boring, well-understood tech.** Postgres, Nginx, systemd, cron, bash — these fail in ways you can Google.
- **Discipline > platform.** A clean monolith on one VPS beats a distributed mess on K8s. Don't outsource engineering hygiene to Helm charts.
- **Learn the primitives first.** If you can't SSH in and debug it with `journalctl`, `docker logs`, and `ss -tlnp`, you can't run it.
- **Stateful workloads stay off orchestrators.** Postgres on the VPS with a volume and `pg_dump` cron is more reliable than a StatefulSet.
- **Automate after you understand manually.** Write the runbook before the Ansible playbook.
- **"The best part is no part."** Every service you add is a 3am page you signed up for.

## Concrete templates, checklists, or artifacts the agent can reuse
- **"Do we actually need this?" gate.** Before adding any service to `docker-compose.yml`, answer: (1) what user-visible problem does this solve? (2) what's the systemd/cron/Nginx alternative? (3) who pages when it breaks?
- **Manual-first runbook template.** For every new piece of infra, write the "by-hand" procedure (SSH, commands, verification) *before* automating. Commit it to `/ops/runbooks/<service>.md`.
- **Boring-tech scorecard.** Score candidates 1–5 on: team familiarity, failure-mode Google-ability, OS-package availability, single-node viability. Anything under 15/20 needs justification.
- **Primitives debugging checklist.** `systemctl status`, `docker ps --format`, `journalctl -u -f`, `ss -tlnp`, `df -h`, `free -m`, `docker stats` — before touching any dashboard.

## Where they disagree with others
- Vs. cloud-native maximalists (CNCF landscape crowd): Hightower says most orgs should run one VM with a monolith; the CNCF ecosystem says everything should be a service mesh with eBPF observability.
- Vs. the SRE Book team: Hightower is lighter on formal SLO math for small setups — his bar is "can you explain the failure to a user?"
- Vs. serverless-everywhere (Vercel maximalism): he's sympathetic to edge for web, but skeptical of fragmenting backend state across 12 managed services.

## Pointers to source material
- GitHub: https://github.com/kelseyhightower
- Twitter/X: https://twitter.com/kelseyhightower
- Talks: "Kubernetes and the Path to Serverless" (KubeCon), "Monoliths are the Future" (various)
- Stack Overflow Podcast #279 — https://stackoverflow.blog/2020/10/20/podcast-279-kubernetes-kelsey-hightower/
- ShiftMag interview — https://shiftmag.dev/on-everything-but-kubernetes-with-kelsey-hightower-463/
