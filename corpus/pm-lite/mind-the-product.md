---
name: Mind the Product
role: pm-lite
type: community
researched: 2026-04-16
---

# Mind the Product

## Why they matter to the PM-lite
Mind the Product (MTP) is the largest global PM community — started as a single ProductTank meetup in a London pub in 2010, now part of Pendo, with daily editorial, two weekly newsletters, the *Product Experience Podcast*, conferences in London / San Francisco / Singapore, and the biggest PM-specific job board. For PM-lite, MTP is the "community of practice" reference: high-volume, practitioner-written articles on the exact craft problems PM-lite hits — writing acceptance criteria, running backlog grooming, managing cross-functional handoffs, keeping stakeholders aligned without hoarding decisions. Unlike Cagan (opinionated) or Lenny (curated), MTP is a chorus of working PMs sharing patterns. That makes it useful as a second opinion when a single source feels dogmatic. PM-lite should use MTP to validate that a practice (e.g. "should I maintain a separate DoR per team?") is common in industry, and to find case studies of how other PMs handle specific execution problems. MTP does not drive PM-lite's strategy — it's a sanity-check library.

## Signature works & primary sources
- MTP daily articles — https://www.mindtheproduct.com/ — execution-craft-heavy editorial.
- "The document that replaces PRDs" (Rags Vadali) — https://www.mindtheproduct.com/ — signals where modern doc practice is heading.
- "Roadmaps are dead! Long live roadmaps!" (C. Todd Lombardo) — roadmap hygiene patterns.
- "How to communicate the value of product work" — stakeholder/update patterns PM-lite can steal.
- "How to lead cross-functional teams and drive product success" — https://www.mindtheproduct.com/how-to-lead-cross-functional-teams-and-drive-product-success/ — handoff + alignment tactics.
- *The Product Experience* podcast (weekly) — interviews on delivery and craft.
- ProductTank local meetups — in-person peer calibration.

## Core principles (recurring patterns)
1. **Consistent backlog grooming builds stakeholder trust.** Refined stories with journey maps that show not just what but why to the end user are the standard MTP-community signal of a healthy backlog.
2. **Involve stakeholders in discovery, not just review.** Sales, finance, marketing, compliance should see the spec before it's locked, not after. PM-lite's spec hygiene should include a "reviewers" list.
3. **Async-first handoffs for distributed teams.** Clear documentation and structured handoffs beat synchronous meetings when teams are distributed across time zones.
4. **Communicate value, not activity.** Status updates should lead with outcomes delivered, not tickets closed.
5. **The craft is a conversation.** MTP's ethos: no single framework is universal. Borrow patterns, test them, keep what works, discard what doesn't.

## Concrete templates, checklists, or artifacts the agent can reuse

**Backlog-grooming session agenda (weekly, 45 min):**
1. (5 min) Review tickets closed since last grooming — any surprises?
2. (15 min) Walk top 10 upcoming tickets — confirm DoR met
3. (10 min) Triage new incoming tickets — accept / send back / park
4. (10 min) Archive tickets >60 days untouched
5. (5 min) Assign owners for spec gaps

**"Value, not activity" weekly update format (steal for Notion/Slack):**
```
This week we shipped: <user-visible outcome, 1 line>
Metric moved / not moved: <data>
Biggest risk surfaced:
Next week's focus:
Decisions needed from Riché:
```
Rule: if the first line reads like "closed 12 tickets," rewrite it.

**Stakeholder discovery-phase reviewer checklist:**
Before spec is locked, confirm these have seen a draft (even async):
- [ ] Engineering lead
- [ ] Design
- [ ] QA
- [ ] Data/analytics (if measurement needed)
- [ ] Support/CX (if user-facing)
- [ ] Sales (if affects pipeline or contract commitments)
- [ ] Legal/compliance (if data, pricing, or region-specific)

**Handoff packet (what PM-lite passes from spec → engineering):**
1. Locked 1-pager or PRD in Notion (versioned)
2. Linked Linear epic with child issues
3. Acceptance criteria per issue (Given/When/Then)
4. Designs (Figma link, frozen)
5. Success metric + who instruments it
6. Known open questions with owners

## Where they disagree with others
- **MTP vs. Cagan:** MTP represents a broader church including feature-team PMs; Cagan dismisses most of them. PM-lite is closer to the MTP median than the Cagan ideal — MTP's patterns often fit better.
- **MTP vs. Linear method:** MTP generally endorses user-story format ("as a user, I want... so that..."); Linear actively rejects it. Reconcile by using the user-story framing in the Notion spec and a Linear-style crisp title/description in the issue.
- **MTP vs. Doshi:** MTP is consensus-driven and template-heavy; Doshi is more willing to tell you which practices are "Overhead" and should be done badly on purpose. Use Doshi's LNO to decide how much effort an MTP-style ritual deserves.

## Pointers to source material
- mindtheproduct.com — daily articles, newsletters
- *The Product Experience* podcast
- ProductTank meetups (local chapters worldwide)
- MindTheProduct conferences (MTP London, MTP SF, MTP Singapore)
- Their job board (productjobboard.com)
