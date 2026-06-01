---
name: ThoughtWorks Technology Radar
role: researcher
type: publication
researched: 2026-04-16
---

# ThoughtWorks Technology Radar

## Why they matter to the Researcher
The Technology Radar is the gold-standard template for periodic framework and library evaluation. It is the single most copied format for "here are the technical options and here's how confident we are in each" — which is exactly the artifact the Researcher agent owes the team whenever Dev is weighing a new language, framework, platform, or tool. The Radar's discipline is that every entry ships with a movement indicator (new, moved in/out, unchanged) and a short opinionated blurb, not a vague "it depends." This format is what lets the Researcher present options with real tradeoffs while still respecting the "don't make product/eng decisions" boundary — the Radar tells you what ThoughtWorks would do if they were you, and why, but the ring assignment is explicitly an opinion to react to, not a mandate.

## Signature works & primary sources
- ThoughtWorks Technology Radar — https://www.thoughtworks.com/radar — Published twice a year since 2010.
- Radar FAQ and methodology — https://www.thoughtworks.com/radar/faq — Explains quadrants, rings, blip movement, and how the TAB curates.
- Build Your Own Radar — https://www.thoughtworks.com/radar/byor — Template and tooling to create internal radars.
- Volume archive — every past edition is online, so blip history can be tracked over time.

## Core principles (recurring patterns)
- **Four quadrants.** Techniques, Platforms, Tools, Languages & Frameworks. Every item belongs in exactly one.
- **Four rings (from center out).** Adopt (strong recommendation), Trial (worth pursuing on real projects), Assess (worth exploring and tracking), Hold (proceed with caution or avoid). Some editions use "Caution" interchangeably with Hold.
- **Blip movement matters more than position.** Watching a blip move from Assess → Trial → Adopt across editions tells a maturity story that a single snapshot can't.
- **Opinionated, not exhaustive.** The Radar only covers what ThoughtWorks has hands-on opinions about. Silence is not neutrality; it is lack of engagement. Readers should notice omissions.
- **Short blurbs, not whitepapers.** Each blip is one paragraph with a recommendation and the rationale. Forces clarity.
- **Themes.** Each edition identifies 3–5 cross-cutting themes — patterns spotted across the quadrants. The Researcher should emulate this when synthesizing internal radars.
- **Grounded in lived experience.** Blips come from actual client engagements within the last six months. No speculation.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Internal radar layout (clone into Notion):**
  - Quadrant: Techniques | Platforms | Tools | Languages & Frameworks
  - Ring: Adopt | Trial | Assess | Hold
  - Blip entry fields: Name, Ring, Movement (new / moved / unchanged), One-paragraph blurb, Evidence (projects where this was used), Primary sources, Related blips
- **Blip-writing skeleton (3–5 sentences):**
  1. What it is (one sentence, assume technical reader).
  2. What problem it solves / why it's notable now.
  3. Our actual experience with it (project, outcome).
  4. The recommendation and the caveat.
  5. Pointer to primary source or deeper read.
- **Ring-assignment rubric (to keep the Researcher from drifting into decisions):**
  - Adopt = "multiple teams have used this in production and succeeded" — requires evidence, not hope
  - Trial = "one or two successful pilots, clear fit, worth a real project" — ship it on a real thing
  - Assess = "interesting enough to watch; build a small spike" — no production commitment
  - Hold = "we've seen this fail or create harm in context X" — document the context
- **Theme synthesis pass:** after placing blips, write 3–5 themes that connect them. This is what turns a list into a narrative.
- **Build Your Own Radar tooling** — CSV input → visual radar output. Useful for internal framework evaluations rendered as a Notion embed.

## Where they disagree with others
- ThoughtWorks Radar vs. Gartner Magic Quadrant: the Radar is bottom-up, practitioner-voice, twice-yearly, opinionated; the MQ is top-down analyst-voice, annual, calibrated against vendor briefings. The Radar is stronger on OSS, techniques, and emerging tools; Gartner is stronger on enterprise vendor ecosystems.
- Radar vs. "neutral comparison" traditions (feature grids, benchmarks): the Radar is deliberately opinionated and single-voice. Omitting a technology is itself a signal. Feature grids try to be exhaustive and neutral; the Researcher should know when each mode fits.
- Radar's lived-experience requirement vs. market-trend reporting (CB Insights, Gartner hype cycle): Radar blips must come from real engagements, which makes coverage narrower but claims more defensible.

## Pointers to source material
- Primary site: https://www.thoughtworks.com/radar
- FAQ: https://www.thoughtworks.com/radar/faq
- Build Your Own Radar: https://www.thoughtworks.com/radar/byor
- Archive: every edition since 2010 accessible from the main radar page
- Podcast: *Technology Podcast by ThoughtWorks* — deeper dives on blips
