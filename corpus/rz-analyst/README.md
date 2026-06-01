---
role: rz-analyst
researched: 2026-04-18
---

# rz-analyst (Analyst) corpus index

Role-specific knowledge for the Analyst strategic routine. The routine produces competitive matrices, market analysis briefs, pricing/packaging studies, and sized opportunity briefs. Stateless between runs; writes durable artifacts to the [Market & Competitive Analysis Notion hub](https://www.notion.so/346ac0ea4f6581e7aa23d4ffa30b5de2). Plugin lives at `plugins/rz-analyst/`.

## Files

- [michael-porter.md](./michael-porter.md) — Five Forces, generic strategies, value chain, "What is Strategy?" — the foundational vocabulary for every competitive matrix and positioning brief.
- [clay-christensen.md](./clay-christensen.md) — Disruptive innovation theory + jobs-to-be-done. The lens for incumbent-vs-entrant dynamics and the structure for understanding buyer motivation across category boundaries.
- [rita-mcgrath.md](./rita-mcgrath.md) — Transient competitive advantage + strategic inflection points. The framework for fast-moving markets where Porter-style structural analysis alone underweights the trajectory.
- [ben-thompson-stratechery.md](./ben-thompson-stratechery.md) — Aggregation Theory, Conservation of Attractive Profits, the working vocabulary for tech-specific competitive dynamics. Real-time analysis feed for the tech portfolio.
- [a16z-sequoia.md](./a16z-sequoia.md) — Venture-grade defensibility analysis (a16z's 5-axis moat framework, Sequoia's GenAI value-chain stack). State-of reports for AI, consumer, fintech as primary sources.
- [gartner-forrester.md](./gartner-forrester.md) — Magic Quadrants, Wave reports, Hype Cycle, TEI studies. The vocabulary enterprise buyers use to evaluate vendors; required for any opportunity brief targeting enterprise customers.
- [hbr-mit-sloan.md](./hbr-mit-sloan.md) — Academic-rigor backstop and citation source for canonical strategic frameworks. The articles where Porter, Christensen, McGrath, and others first published their thinking.

## How the routine uses these

At session start, the routine's `session` skill reads this README to orient. For specific output skills:

- **competitive-matrix** → Porter (Five Forces structural framing) + a16z (defensibility audit) + Gartner/Forrester (existing analyst placements as reference points)
- **market-analysis** → Christensen (disruption + non-consumption scan) + McGrath (inflection-point watch list) + Thompson (architecture-shift lens for tech markets)
- **pricing-study** → HBR/SMR (canonical pricing-strategy articles) + Gartner/Forrester (TEI studies for ROI vocabulary) + a16z (TAM bottom-up sizing methodology)
- **opportunity-brief** → All the above; particularly McGrath (discovery-driven planning template) + Christensen (job-statement structure) + a16z (10x test for differentiation)

## Citation discipline

Every non-trivial claim cites a source. Order of preference:

1. The original framework's HBR/SMR article (most defensible)
2. The author's book elaborating the framework
3. Analyst-firm reports (Gartner, Forrester) for current vendor landscape
4. Stratechery / a16z / Sequoia for tech-specific real-time analysis
5. Peer reviews (G2, Capterra, Gartner Peer Insights) for end-user perspective

Each artifact ends with a `Confidence: low/medium/high` label and a sources list. Default to `medium` unless evidence is strong.
