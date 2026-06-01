---
name: John Cutler
role: pm-lite
type: individual
researched: 2026-04-16
---

# John Cutler

## Why they matter to the PM-lite
Cutler is the best living writer on the mechanics of backlogs, work flow, and ticket anti-patterns — exactly PM-lite's daily terrain. Where Cagan stays strategic, Cutler lives in the gore of Jira/Linear queues: dozens of "to-do" states, ghost tickets, duplicate epics, rocks vs. pebbles, and the psychology of teams that look busy but ship nothing. His *Beautiful Mess* writing and the distinctive hand-drawn TBM diagrams give PM-lite a visual vocabulary to *see* problems in a backlog (is it a learning backlog or a commitment backlog? is this roadmap really a roadmap or a wish list?) and the language to explain those problems to engineers without blaming them. PM-lite is explicitly an executor, and Cutler's work is mostly about making execution legible — so this is a high-fit source. PM-lite does NOT use Cutler to set product direction; it uses him to audit the hygiene of the backlog Riché's strategy flows into.

## Signature works & primary sources
- *The Beautiful Mess* newsletter — https://cutlefish.substack.com/ — weekly TBM essays on cross-functional product development.
- "TBM 7/53: Learning Backlogs" — https://cutlefish.substack.com/p/tbm-753-learning-backlogs — why separating "things we're learning" from "things we're building" fixes most backlog rot.
- "TBM 48/53: One Roadmap" — https://cutlefish.substack.com/p/tbm-4853-one-roadmap — against roadmap sprawl; argues for one visible source of truth.
- "TBM 387: Lenses" — https://cutlefish.substack.com/p/tbm-387-lenses — multiple views (capability, team-interaction, opportunity) on the same backlog.
- TBM diagrams on LinkedIn (@johncutlefish) — ~daily visual one-pagers PM-lite can mimic.

## Core principles (recurring patterns)
1. **Separate learning backlogs from commitment backlogs.** Discovery/learning items should live in a different queue than "we've committed to ship this." Mixing them produces the classic "why is this old ticket still here?" rot.
2. **Options are not commitments.** Opportunities on a roadmap are not promises. PM-lite should mark them as such in Notion/Linear so engineers don't over-interpret.
3. **Visualize flow, not just status.** A ticket board tells you status; a flow diagram tells you where work piles up. PM-lite should periodically sketch where tickets bottleneck (triage, review, QA) and surface it.
4. **Swimlanes blur as work moves right.** Neat "strategy → execution" categories collapse in delivery. Don't fight it — make the mess visible.
5. **Anti-pattern radar.** Classic smells: one ticket per engineer-week, epics with no parent goal, tickets older than 90 days, acceptance criteria copied from titles, "TBD" in the outcome field.
6. **North Star → Drivers → Execution.** Every ticket PM-lite writes should be traceable up this chain. If it isn't, flag it.

## Concrete templates, checklists, or artifacts the agent can reuse

**Cutler-style backlog audit checklist (run weekly on Linear):**
- [ ] Are learning items and commitment items in separate views/labels?
- [ ] Any ticket >60 days old with no status change? → close or revive with rationale
- [ ] Any epic with no linked project/goal? → orphan, escalate to Riché
- [ ] Any ticket where the acceptance criteria is a restatement of the title? → rewrite
- [ ] Any in-progress ticket not touched in 7 days? → ping DRI, unblock or reassign
- [ ] Any "TBD" fields in high-priority tickets? → block from sprint

**Ticket "lens" annotation (steal from TBM 387):**
Each ticket should be readable through three lenses. If two are empty, the ticket is weak:
- *Capability lens:* what capability does this strengthen?
- *Team-interaction lens:* who else must collaborate (service, facilitation, X-as-a-service)?
- *Opportunity lens:* what opportunity/bet does this ticket serve?

**"One Roadmap" discipline:** PM-lite maintains exactly ONE Notion page as the source of truth for the roadmap. Any other view (Linear project list, Slack pins, slide decks) must link back to it — never duplicate content.

**Rocks / pebbles / sand triage line:** before sprint planning, bucket candidate tickets into rocks (must ship, multi-sprint), pebbles (committed this sprint), sand (filler/bugs). If the bucket is >30% sand, the team is in a feature-factory mode — flag to Riché.

## Where they disagree with others
- **Cutler vs. Atlassian/Scrum orthodoxy:** Cutler is skeptical of ceremony-heavy Scrum; he favors continuous flow and visualizing mess over enforcing ritual. PM-lite should take his anti-pattern detection but respect a team's existing cadence unless asked to change it.
- **Cutler vs. Linear method:** Both hate bloat, but Cutler is more tolerant of exploratory "placeholder" tickets (as learning items) than Linear, which wants every issue to be a concrete deliverable. Reconcile with explicit labels.
- **Cutler vs. RICE/scoring frameworks:** Cutler is dismissive of single-number prioritization; he prefers multi-lens qualitative views. Useful counterweight when someone demands a RICE score for everything.

## Pointers to source material
- cutlefish.substack.com — primary feed
- LinkedIn: John Cutler (daily TBM diagrams)
- johnpcutler.github.io/tbm2020/ — older compiled archive
- Podcasts: "Product Thinking" by Melissa Perri, "AgileData.io" guest episodes
