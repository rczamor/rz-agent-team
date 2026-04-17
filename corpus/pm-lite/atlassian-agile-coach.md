---
name: Atlassian Agile Coach / Team Playbook
role: pm-lite
type: organization
researched: 2026-04-16
---

# Atlassian Agile Coach / Team Playbook

## Why they matter to the PM-lite
Atlassian has published the most exhaustive free library of agile templates on the internet — user stories, acceptance criteria, Definition of Ready (DoR), Definition of Done (DoD), sprint planning, retros, backlog grooming. While PM-lite's tool of record is Linear (not Jira) and Linear explicitly rejects some of Atlassian's conventions ("user stories are an anti-pattern"), the Atlassian Agile Coach content remains the standard reference for the *underlying concepts* PM-lite must know: what DoR actually requires, what separates DoD from acceptance criteria, the INVEST criteria, Given/When/Then BDD format. When PM-lite writes acceptance criteria, it should write them in a format that would satisfy an Atlassian-trained engineer or QA on any team. The Team Playbook also provides concrete facilitation templates (health monitors, roles & responsibilities, sprint retros) that PM-lite can pull when shepherding handoffs. This source is PM-lite's "canonical definitions" library.

## Signature works & primary sources
- "User stories" — https://www.atlassian.com/agile/project-management/user-stories — classic format and examples.
- "What is Acceptance Criteria?" — https://www.atlassian.com/work-management/project-management/acceptance-criteria — definition, formats, examples.
- "Definition of Done (DoD)" — https://www.atlassian.com/agile/project-management/definition-of-done — shared completion criteria.
- "Definition of Ready (DoR)" — https://www.atlassian.com/agile/project-management/definition-of-ready — INVEST-based readiness check.
- Atlassian Team Playbook — https://www.atlassian.com/team-playbook — facilitation templates (Health Monitor, Roles & Responsibilities, Retro, Pre-Mortem).
- Atlassian Agile Coach — https://www.atlassian.com/agile — broader agile education hub.

## Core principles (recurring patterns)
1. **DoD applies to all work; acceptance criteria apply to the specific story.** DoD is a team-wide quality bar (tests written, reviewed, deployed, docs updated). AC is per-story behavior. Both must be met to close.
2. **INVEST every story.** Independent, Negotiable, Valuable, Estimable, Small, Testable. If a story fails any one, split or sharpen it.
3. **Acceptance criteria must be objectively testable.** Each criterion should map cleanly to at least one executable test.
4. **Given / When / Then (BDD) for behavioral criteria.** Makes AC live as test scenarios, not vague wishes.
5. **Focus AC on outcomes, not implementation.** Tell the engineer what the user should experience; leave the "how."
6. **Write AC collaboratively.** Include dev and QA representatives — AC authored in isolation by a PM is a common smell.

## Concrete templates, checklists, or artifacts the agent can reuse

**Acceptance Criteria — Given/When/Then skeleton (PM-lite default):**
```
Scenario: <one-line description of the behavior>
  Given <preconditions / state>
  When <user action or triggering event>
  Then <observable outcome>
  And <additional outcome if needed>
```
Example:
```
Scenario: User resets password via email link
  Given the user has requested a password reset
  And the reset link is less than 24h old
  When the user submits a new password meeting complexity rules
  Then the password is updated
  And the user is redirected to the login screen
  And a confirmation email is sent
```

**Checklist-style AC (when Given/When/Then is overkill):**
```
Acceptance criteria:
- [ ] The reset link expires after 24h
- [ ] Passwords must be 12+ chars and include 1 symbol
- [ ] On success, user sees a confirmation toast
- [ ] On failure, user sees an actionable error message
- [ ] A confirmation email is sent within 60s
```

**Definition of Ready (DoR) — INVEST checklist (run before pulling into a sprint):**
- [ ] **I**ndependent — can be worked without blocking on another story
- [ ] **N**egotiable — scope is flexible, not a contract
- [ ] **V**aluable — clear user or business value stated
- [ ] **E**stimable — engineers can size it
- [ ] **S**mall — fits in one cycle
- [ ] **T**estable — has acceptance criteria
- [ ] Designs attached (if UI)
- [ ] Dependencies called out
- [ ] DRI assigned

**Definition of Done (DoD) — team-wide quality bar (Notion, one per team):**
A story is DONE when:
- [ ] Code merged to main
- [ ] All acceptance criteria passing
- [ ] Unit + integration tests added and passing in CI
- [ ] Code reviewed by at least one peer
- [ ] No new high/critical bugs introduced
- [ ] Docs/README updated if public-facing change
- [ ] Analytics events instrumented (if measurable outcome)
- [ ] Feature flag set per rollout plan
- [ ] Released to production OR queued for next release window
- [ ] PM-lite has verified against the spec

**User story template (for when you do need the narrative form, e.g. in the Notion spec — NOT in Linear):**
```
As a <user role / persona>
I want <capability>
So that <outcome / benefit>
```
Then immediately follow with AC. The narrative alone is never enough.

## Where they disagree with others
- **Atlassian vs. Linear:** Atlassian builds on user-story format; Linear calls it an anti-pattern. PM-lite's reconciliation: user-story framing lives in the Notion spec; the Linear issue itself uses Linear-style crisp titling. AC format (Given/When/Then) can live in either and is tool-neutral.
- **Atlassian vs. Cutler:** Atlassian endorses ceremonies (sprint planning, grooming, retro, DoR/DoD gates); Cutler is skeptical of heavy ritual. Use the artifacts (DoR/DoD) without necessarily running every ceremony — keep the checklist, skip the 90-min meeting if async covers it.
- **Atlassian vs. Cagan:** Atlassian is process-centric; Cagan is outcome-centric and sometimes dismissive of "agile theatre." Use Atlassian's templates but stress-test them against Cagan's "is this an outcome or just output?" sniff.

## Pointers to source material
- atlassian.com/agile — full Agile Coach
- atlassian.com/team-playbook — facilitation plays
- Atlassian Community (community.atlassian.com) — practitioner Q&A and case studies
- Book: *The Atlassian Team Playbook* materials (free, downloadable)
