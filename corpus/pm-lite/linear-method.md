---
name: Linear (the company) — The Linear Method
role: pm-lite
type: organization
researched: 2026-04-16
---

# Linear — The Linear Method

## Why they matter to the PM-lite
Linear is the tool PM-lite lives in, and "The Linear Method" is effectively the operating manual for that tool. Linear has strong, sometimes contrarian opinions about how work should be represented — most famously: **"Write issues, not user stories."** For PM-lite, this is load-bearing. Linear's philosophy is that the issue tracker should be fast, scannable, and task-level; narrative context belongs in a linked spec doc, not in the issue body. That means PM-lite's Notion spec and Linear issue are NOT duplicates of each other — they have different jobs. The Linear Method also gives PM-lite a clean opinion on cycle length (two weeks), issue ownership (one DRI per issue, always), backlog discipline (focused over complete), and the mix of features + quality in every cycle. Because PM-lite owns "Linear ticket structure" explicitly per the team scope, this source is the highest-authority reference for what a well-formed issue looks like in this specific tool.

## Signature works & primary sources
- "The Linear Method" index — https://linear.app/method — the canonical operating manual.
- "Write issues, not user stories" — https://linear.app/method/write-issues-not-user-stories — the central, contrarian opinion.
- "Scope projects down" — https://linear.app/method/scope-projects-down — how to break work into shippable chunks.
- "Launch and keep launching" — https://linear.app/method/launch-and-keep-launching — continuous-release discipline.
- "Set useful goals" — https://linear.app/method/set-useful-goals — how goals connect to cycles.
- Linear blog — https://linear.app/blog — practitioner essays and release notes.

## Core principles (recurring patterns)
1. **Write issues, not user stories.** User stories are treated as an anti-pattern — cargo-cult rituals that obscure work. Issues should state the task directly.
2. **Every issue has one DRI.** Shared ownership kills momentum. Even if others contribute, one name owns the close.
3. **Describe concrete tasks with defined outcomes.** Exploratory work is allowed, but framed as a deliverable ("Write project spec") not an open-ended question.
4. **Write your own issues.** Authoring forces deeper thinking. PM-lite should push back when engineers expect pre-chewed tickets for their own work (PM-lite writes the parent spec; engineers can author their own sub-issues).
5. **Titles are scannable; descriptions are optional and short.** Quote customer feedback directly. Include only essential context.
6. **Keep UX discussion at the project level.** Don't re-explain user context in every child issue; do it once in the project.
7. **Two-week cycles.** Short enough to stay focused; long enough to ship real work.
8. **Balanced cycle mix.** Features + bug fixes + tooling investment in every cycle, not "quality quarters."
9. **Focused backlogs, not complete backlogs.** Important ideas resurface naturally; you don't need to archive every request forever.

## Concrete templates, checklists, or artifacts the agent can reuse

**Linear issue template (PM-lite default):**
```
Title: <verb + object, scannable at 40 chars>
Description (optional, keep short):
  <one line of context if needed>
  <link to parent Notion spec>
  <quoted customer feedback if relevant>
Assignee: <one name>
Project: <parent project>
Estimate: <points or days>
Cycle: <current or backlog>
Labels: <type: bug | feature | chore | quality>
```

**Good vs. bad Linear titles:**
- Bad: "As a user, I want to reset my password so that I can regain access"
- Good: "Add password reset flow"
- Bad: "Improve onboarding"
- Good: "Trim signup from 5 steps to 3"
- Bad: "Bug: issues"
- Good: "Fix duplicate invoice on annual plan renewal"

**Project scope-down checklist (before creating a Linear project):**
- [ ] Can it ship in ≤2 cycles? If no, split.
- [ ] Does every child issue have a single DRI?
- [ ] Is there exactly one linked Notion spec (not three)?
- [ ] Is the project goal one sentence?
- [ ] Is there a named launch milestone?

**Cycle-planning checklist (every 2 weeks):**
- [ ] Cycle goal written in one sentence
- [ ] Issue mix: features + at least 1 bug + at least 1 quality/tooling
- [ ] No issue in the cycle without an estimate
- [ ] No issue in the cycle without an assignee
- [ ] Spillover from last cycle triaged: close, move, or justify

**Triage flow for incoming issues (inbox rule):**
1. Is this a concrete task with a defined outcome? If no → bounce to author with one question.
2. Does it belong to an existing project? If yes → attach. If no → park in triage with a label until the parent project is clear.
3. Does it have a DRI candidate? If no → leave unassigned in triage, not in a cycle.
4. Age cap: any triage item >14 days with no action → close with "reviving if this recurs."

## Where they disagree with others
- **Linear vs. Atlassian/Scrum:** Linear explicitly rejects user-story format and heavy ceremony; Atlassian teaches both. PM-lite should follow Linear's conventions inside Linear and not try to retrofit Scrum vocabulary.
- **Linear vs. Cagan:** Cagan wants rich outcome/problem framing; Linear wants crisp task framing. Reconcile by keeping the outcome in Notion and the task in Linear.
- **Linear vs. Cutler:** Both oppose bloat. Cutler is more tolerant of exploratory "learning" tickets; Linear prefers they become concrete deliverables. Use Cutler's learning-backlog concept only if you label those issues clearly and time-box them.

## Pointers to source material
- linear.app/method — all method essays
- linear.app/blog — Karri Saarinen and team essays on product + engineering operations
- Linear changelog — useful for knowing what tool features exist to enforce the method
