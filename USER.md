# USER.md

This file describes the human you work for and the portfolio you build. The same copy lives on every OpenClaw instance.

## The user

**Riché Zamor** — Owner, product strategist, and sole engineer-of-record across the portfolio. Operates session-based, not always-on. Triggers work when he has time; expects agents to be quiet between sessions.

**Working style:**

- Direct. Short messages. Doesn't want filler or summaries he didn't ask for.
- Strategy stays in Riché's head. Agents execute against it; they don't propose new strategy.
- Trusts agents to make tactical decisions inside their domain. Wants escalation when a decision is architectural, cross-component, or has lasting impact.
- Reads Slack — that's where every agent reports. Don't bury status in shared memory only.
- Will jump into a session in real time. When he posts in `#agent-team` or an app channel during a session, **drop current work, acknowledge, and incorporate immediately.**

**Preferences:**

- No emojis in agent output unless Riché uses them first.
- No reflexive apologies. State what happened, what you'll do.
- No code comments unless the WHY is non-obvious.
- No backwards-compatibility shims for code not yet shipped.

## The portfolio

Riché ships and maintains 8 apps. The full app registry — including stack, repo, Linear project, Notion spec links, file ownership map, and per-app overrides — lives in Notion: [Apps & Per-App Configuration](https://www.notion.so/344ac0ea4f65810bb4a8f6331c85a2e9).

**Quick reference:**

| `app_id` | Description | Stack | Hosting |
|---|---|---|---|
| `sia` | Personal AI knowledge system / Context Layer Engine | FastAPI, Jinja2, HTMX, Pico CSS, Postgres+pgvector | Hostinger VPS |
| `website` (`rzcom`) | [richezamor.com](http://richezamor.com) — portfolio + writing + speaker site, with SIA chatbot widget | Next.js 14, TypeScript, Tailwind, MDX | Vercel |
| `recipe-remix` | Prototype | TBD | Vercel |
| `ploppy` | Prototype | TBD | TBD |
| `blocade` | Prototype | TBD | TBD |
| `ascend` | Prototype | TBD | TBD |
| `trend-analyzer` | Prototype | TBD | TBD |
| `ai-onboarding` | Prototype | TBD | TBD |

The Conductor loads the full app config (stack details, file ownership, conventions) at session start. Don't memorize stack assumptions — read the registry every session.

## Linear projects

- [Sia](https://linear.app/riche-life/project/sia-2b129975749f)
- [Professional Website](https://linear.app/riche-life/project/professional-website-4c8a9390eb23)
- [Recipe Remix](https://linear.app/riche-life/project/recipe-remix-f340403f0cdd)
- [Ploppy](https://linear.app/riche-life/project/ploppy-636d1407047b)
- [Blocade](https://linear.app/riche-life/project/blocade-1d8c7b4468f8)
- [Ascend](https://linear.app/riche-life/project/ascend-ce3b320ca092)
- [Trend Analyzer](https://linear.app/riche-life/project/trend-analyzer-2f259af101c8)
- [AI Onboarding](https://linear.app/riche-life/project/ai-onboarding-2483f08958fd)
- [Agent Team](https://linear.app/riche-life/project/agent-team-fcdd6aae2334) — for team build tickets

## Codebases

- SIA: [github.com/rczamor/sia](http://github.com/rczamor/sia)
- Website: [github.com/rczamor/rz_professional_website](http://github.com/rczamor/rz_professional_website)
- Recipe Remix: [github.com/rczamor/recipe-remix](http://github.com/rczamor/recipe-remix)
- Ploppy: [github.com/rczamor/ploppy](http://github.com/rczamor/ploppy)
- Blocade: [github.com/rczamor/blocade_crm](http://github.com/rczamor/blocade_crm)
- Ascend: [github.com/rczamor/ascend](http://github.com/rczamor/ascend)
- Trend Analyzer: [github.com/rczamor/ai_trend_analyzer](http://github.com/rczamor/ai_trend_analyzer)
- AI Onboarding: [github.com/rczamor/AI-SaaS-Onboarding-Prototype](http://github.com/rczamor/AI-SaaS-Onboarding-Prototype)

## Slack channels you post to

- `#agent-team` — portfolio-wide, cross-app, global decisions
- `#agent-sia`, `#agent-website`, `#agent-recipe-remix`, `#agent-ploppy`, `#agent-blocade`, `#agent-ascend`, `#agent-trend-analyzer`, `#agent-ai-onboarding` — per-app

## Things outside this team

- **Brand/Content design and Growth/Analytics** live in Claude Cowork on frontier models. Don't try to do that work — point Riché back to Cowork.
- **SIA's intellectual knowledge base** is NOT agent memory. It stores Riché's domain context. Don't treat it as a place to log engineering decisions.
- **Strategic product decisions** belong to Riché. Surface options, escalate, then execute the chosen direction.
