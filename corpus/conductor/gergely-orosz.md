---
name: Gergely Orosz
role: conductor
type: individual
researched: 2026-04-16
---

# Gergely Orosz

## Why they matter to the Conductor
Orosz is the Conductor's reality check against advice that sounds good on a blog but doesn't match how shipping teams actually work. His Pragmatic Engineer newsletter is the most-read working-engineer publication in the industry; his sources are working ICs and managers at Meta, Stripe, Cursor, and hundreds of other companies. When the Conductor faces a "how do real teams handle this?" question — incident review format, PR size conventions, project management without Scrum, code-review SLAs — Orosz is the benchmarking source. His *Software Engineer's Guidebook* is also the most concrete catalog of what senior/staff engineers do day-to-day, which the Conductor uses to calibrate what to expect from specialist agent output.

## Signature works & primary sources
- *The Pragmatic Engineer* newsletter — https://www.pragmaticengineer.com — 1M+ readers; deep-dives on big-tech engineering practices.
- *The Software Engineer's Guidebook* (2024) — https://www.engguidebook.com — Career + craft guide covering engineering competencies, estimations, stakeholder work, and staying relevant.
- *Building Mobile Apps at Scale* — Earlier book; still useful on distributed-systems lessons in mobile context.
- The Pragmatic Engineer Podcast — Interviews with engineers at top companies.
- Notable pieces: "Inside Meta's engineering culture"; "Why big tech doesn't use Scrum"; "Incident review best practices"; "Building Cursor"; "How Claude Code is architected."

## Core principles (recurring patterns)
1. **Benchmark before prescribing.** Before recommending a practice, check what actually works at shipping companies with similar constraints. Avoid thought-leader advice untethered from real teams.
2. **Small, frequent PRs beat large, rare ones.** This is the single most consistent signal from high-functioning teams he covers.
3. **Scrum is not the default at top companies.** Most mature tech orgs run on lightweight project management: clear goals, written plans, async updates, and bias to autonomy.
4. **Incident reviews should be blameless, written, and read widely.** The value is in the learning artifact, not the meeting.
5. **Seniority is about judgment under ambiguity, not years.** A senior engineer knows what to build, what not to build, what to cut, and when to escalate.
6. **Make engineering work visible to non-engineers.** Written updates, demo videos, and short written summaries of decisions beat synchronous status meetings.

## Concrete templates, checklists, or artifacts the agent can reuse

**Incident postmortem template (Pragmatic Engineer synthesis):**
1. Summary — 2-3 sentences; what broke, what users saw, how long
2. Timeline — UTC timestamps, detection → mitigation → resolution
3. Root cause — technical + organizational (why didn't we catch this earlier?)
4. What went well
5. What went wrong
6. Action items — each with owner, Linear issue link, and deadline
7. Lessons learned — readable for engineers who weren't on the incident

**PR-size rule of thumb:** Aim for <400 lines changed. Above that, require an explicit justification in the PR description. The Conductor should flag oversized PRs on first pass.

**"Big tech without Scrum" project template:**
- Goal (one sentence, outcome not output)
- Why now
- Plan (milestones with rough dates, not story points)
- Who's doing what
- Async weekly update format: shipped / in flight / blocked / risks

**Senior-engineer judgment questions (run before escalating to a human):**
1. What are we optimizing for here — speed, correctness, reversibility, or cost?
2. Is this decision reversible? If yes, decide and move.
3. Who else has solved this, inside or outside the company?
4. What's the cheapest experiment that would resolve the ambiguity?

**Written status update (replacing a sync):**
- What shipped since last update
- What's in flight and its ETA
- Blockers + what would unblock
- Decisions needed from the reader

## Where they disagree with others
- **Orosz vs. Fowler/ThoughtWorks:** Orosz is more skeptical of consultant-branded methodology (capital-A Agile, capital-C Continuous Delivery frameworks). He reports what top teams actually do, which is often lighter-weight and more written-doc-driven.
- **Orosz vs. Larson:** Both agree on boring-first, but Orosz is more willing to describe positive deviance (how specific teams ship fast and differently) while Larson generalizes to durable principles.
- **Orosz vs. Reilly:** Orosz underweights glue work relative to Reilly. His "what senior engineers do" lists skew toward visible technical output; pair with Reilly to credit the coordination layer.

## Pointers to source material
- Primary site: https://www.pragmaticengineer.com
- Book: https://www.engguidebook.com
- Podcast: The Pragmatic Engineer Podcast (on all major platforms)
- Twitter/X: @GergelyOrosz
- Signature series: Real-World Engineering Challenges; Inside Big Tech; How the Tech Industry Works
