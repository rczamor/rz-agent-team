---
name: Google SRE Book team (Beyer, Jones, Petoff, Murphy)
role: devops-eng
type: organization
researched: 2026-04-16
---

# Google SRE Book team (Beyer, Jones, Petoff, Murphy)

## Why they matter to the DevOps Eng
The SRE Book is the canonical vocabulary for reliability work: SLIs, SLOs, error budgets, toil, blameless postmortems, on-call hygiene. At Google scale it's prescriptive; at single-VPS scale the *concepts* still apply but the *math* doesn't — a DevOps Eng on one Hostinger box needs a 99.5% web SLO with a simple Uptime Kuma probe, not a multi-region burn-rate alert. The value of this seed is cherry-picking: use the SLO/error-budget framing to decide whether to ship features or fix reliability, use the incident-response checklist when Langfuse or Ollama goes down, write blameless postmortems even for a one-person ops rotation. Skip the multi-layer alerting math until you have more than one server.

## Signature works & primary sources
- *Site Reliability Engineering* (2016, O'Reilly, free online) — https://sre.google/sre-book/table-of-contents/ — the foundational text.
- *The Site Reliability Workbook* (2018, free online) — https://sre.google/workbook/table-of-contents/ — applied chapters; more directly useful for small setups.
- *Building Secure and Reliable Systems* (2020) — https://sre.google/books/building-secure-reliable-systems/ — security/reliability overlap.
- "Embracing Risk" chapter — https://sre.google/sre-book/embracing-risk/ — the error-budget argument.
- "Service Level Objectives" chapter — https://sre.google/sre-book/service-level-objectives/ — SLI/SLO definitions.
- Incident Management Guide — https://sre.google/resources/practices-and-processes/incident-management-guide/

## Core principles (recurring patterns)
- **SLIs measure user-visible behavior; SLOs are targets; error budgets are the difference.** A 99.5% web-availability SLO gives you ~3.6h/month of downtime budget before you stop shipping features.
- **Toil is work that's manual, repetitive, automatable, and scales with service size.** Cap it at 50% of your ops time.
- **Blameless postmortems.** Assume everyone acted in good faith with the info they had. The output is a systems fix, not a performance review.
- **Monitoring has four golden signals:** latency, traffic, errors, saturation. Everything else is nice-to-have.
- **Alert on symptoms, not causes.** "The site is down" > "disk is 85% full."
- **Reliability is a feature that competes with velocity.** When you burn the error budget, freeze features until you're back in SLO.

## Concrete templates, checklists, or artifacts the agent can reuse
- **SLO spec template** (commit at `/ops/slos/<service>.md`):
  ```
  Service: rz-personal-website (Vercel)
  SLI: HTTP 2xx/3xx ratio on /api/* probed every 60s
  SLO: 99.5% over rolling 30d
  Error budget: 3h 36m/month
  Owner: DevOps Eng
  Alert: burn > 2x over 1h -> Slack #ops
  ```
- **Incident-response runbook outline** (per service): detection source, first-responder actions (kept to 5 steps), comms template, escalation, recovery verification, postmortem trigger.
- **Blameless postmortem template**: timeline, impact, root cause, contributing factors, what went well, what didn't, action items with owners and due dates.
- **Four golden signals dashboard** for the VPS — Uptime Kuma or Grafana panels for: p95 latency, RPS, 5xx rate, CPU/mem/disk saturation per container.
- **On-call handoff doc** — even for a solo rotation: active alerts, deferred work, known-flaky things, context for incoming shift.

## Where they disagree with others
- Vs. Hightower's "just ship it" energy: the SRE Book wants formal SLO math before you alert; Hightower would say `curl` the endpoint in cron and move on. At single-VPS scale Hightower is closer to right.
- Vs. early-stage velocity advocates: the SRE Book will freeze features when you burn budget; early-stage teams often can't afford that and choose to pay down debt post-PMF.
- Vs. chaos-engineering maximalists: SRE Book is more conservative on fault injection in prod; Netflix-style Chaos Monkey culture is more aggressive.

## Pointers to source material
- sre.google/books — all three books free online
- Postmortem template: https://sre.google/workbook/postmortem-culture/
- Implementing SLOs: https://sre.google/workbook/implementing-slos/
- Alerting on SLOs: https://sre.google/workbook/alerting-on-slos/
