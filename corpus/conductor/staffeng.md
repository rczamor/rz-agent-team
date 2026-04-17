---
name: StaffEng
role: conductor
type: community
researched: 2026-04-16
---

# StaffEng

## Why they matter to the Conductor
StaffEng gives the Conductor the role-level vocabulary it needs to reason about specialist-agent scope and its own scope. The four archetypes (Tech Lead, Architect, Solver, Right Hand) are the single most useful classifier the Conductor has for matching an incoming Linear issue to the right specialist agent — is this a team-scoped execution problem (Tech Lead), a deep-dive knot (Solver), a domain-design problem (Architect), or an executive-context problem (Right Hand)? The first-person stories on the site are also the best source of real-world examples of what staff+ work looks like in practice — what got the person promoted, what didn't, what scope they took on — which the Conductor can use as reference cases when reasoning about its own behavior.

## Signature works & primary sources
- StaffEng.com — https://staffeng.com — Stories, guides, and book by Will Larson.
- Staff Engineer book — https://staffeng.com/book — Companion volume compiling guides and interviews.
- "The four archetypes" guide — https://staffeng.com/guides/staff-archetypes/ — Tech Lead, Architect, Solver, Right Hand.
- "Work on what matters" guide — https://staffeng.com/guides/work-on-what-matters — Prioritization heuristic for staff+ engineers.
- Stories section — https://staffeng.com/stories — First-person accounts from Stripe, Slack, Google, Dropbox, and others.
- "Writing an engineering strategy" — https://staffeng.com/guides/writing-engineering-strategy

## Core principles (recurring patterns)
1. **Staff+ is not a promotion, it's a different job.** Scope, skills, and success metrics all change. Don't grade a staff engineer on senior-IC rubrics.
2. **Archetype determines scope.** Tech Lead owns a team's execution; Architect owns a critical area's direction; Solver owns a prioritized knot; Right Hand extends an executive's attention. Confusing them creates misassignment.
3. **Influence > authority.** Staff+ engineers don't have reports; they ship through writing, sponsorship, and calibrated disagreement.
4. **Sponsorship matters more than performance.** Promotion and scope come from senior leaders who vouch for you, not from a checklist.
5. **Snowflakes lose — generalizable work wins.** Staff+ impact requires artifacts (docs, migrations, standards) that outlast the individual.
6. **Work on what matters, not what's interesting.** Impact is bounded by org priority alignment, not technical novelty.

## Concrete templates, checklists, or artifacts the agent can reuse

**Archetype-matching dispatcher (the Conductor runs this on every incoming issue):**
```
If the issue is:
  - Team-scoped execution over weeks          → Tech Lead pattern
  - Cross-team domain design (API, platform)  → Architect pattern
  - A single knotty problem needing deep dive → Solver pattern
  - Exec-context, cross-functional ambiguity  → Right Hand pattern (escalate)
```

**Staff-project kickoff checklist (from StaffEng guides):**
1. Who is the executive sponsor? (if none: stop, find one)
2. What org priority does this connect to?
3. What's the first artifact I'll write? (usually a problem statement or ADR)
4. Who needs to read it before I start building?
5. What's my definition of done, at the org level not the code level?

**"Work on what matters" filter for dispatch:**
- Is the outcome valuable to the org, not just technically interesting?
- Is there someone uniquely positioned to do this? (if generic → defer)
- What would I stop doing to do this?
- Can I find a sponsor who'll say the same thing out loud?

**Promotion-evidence template (what to capture from each completed task):**
- Artifact produced (doc, PR, migration playbook, decision)
- Scope of impact (team / multiple teams / org / company)
- Who else was involved and their role
- What was at stake if this hadn't been done
- Link in Linear / Paperclip

**Scope-creep check for the Conductor's own work:**
- Am I doing Tech Lead work that a specialist should own?
- Am I doing Right Hand work that belongs to a human PM?
- Am I doing Solver work when the real win is an Architect-level standard?

## Where they disagree with others
- **StaffEng vs. Reilly:** StaffEng's archetypes can under-credit glue work — which Reilly names as the majority of staff+ time in practice. Treat the archetypes as the shape of visible deliverables, not the shape of the hours.
- **StaffEng vs. LeadDev:** StaffEng is IC-track only and opinionated; LeadDev covers both tracks and aggregates. Use StaffEng when the question is "what does a staff engineer do?", LeadDev when it's "what does the industry think about that?"
- **StaffEng vs. traditional career-ladder docs:** Most internal ladders are optimized for legibility across many people; StaffEng is optimized for the N=1 realities of being one. Expect disagreement, especially around "what counts as impact."

## Pointers to source material
- Primary site: https://staffeng.com
- Book: https://staffeng.com/book
- Guides index: https://staffeng.com/guides
- Stories index: https://staffeng.com/stories
- Related: Will Larson's personal site https://lethain.com
