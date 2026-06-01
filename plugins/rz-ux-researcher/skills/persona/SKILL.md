---
name: persona
description: Build a persona from user research — segment characterization with behaviors, motivations, constraints, and jobs-to-be-done. Use when the ticket asks to characterize a user segment, typically after interview-synthesis has identified themes worth crystallizing.
---

# persona

## When to invoke

Invoke when the ticket:
- Asks to build a persona for a specific segment
- Follows an `interview-synthesis` output that identified a distinct user cluster
- Needs a reusable user-reference document for Designer and PM-lite

If the ticket wants multiple personas, invoke this skill once per persona and link them in a parent Notion page.

## Template

```markdown
# Persona — {segment name}

**Target app(s):** {app_id}
**Date:** {YYYY-MM-DD}
**Confidence:** {low/medium/high}
**Evidence base:** {e.g., "7 interviews + 42 survey responses + 3 months of telemetry on cohort X"}

## Who they are

- **Role / context:** What they do, where they do it
- **Stage / maturity:** Beginner / experienced / expert in the domain
- **Demographics:** Only include if directly relevant. Don't pad with incidentals.

## A day in their life (relevant slice)

A short narrative of what their work or life looks like in the moments where our product would fit. Concrete, not abstract.

## Behaviors

What they actually do today to solve the problem we'd address.

- **Current tools:** Specific products/systems they use
- **Frequency:** How often they encounter the need
- **Intensity:** How much energy it takes to solve
- **Workarounds:** Hacks they've built, shortcuts they take

## Motivations

Why they care. Not surface wants — underlying drivers.

- **Functional:** The practical outcome they need
- **Emotional:** What they feel when it works / doesn't work
- **Social:** How this affects their standing with peers/team

## Constraints

- **Time:** How much they can spend on a solution
- **Skill:** What they can and can't do technically
- **Budget:** Personal or team budget ceiling
- **Tooling / context:** Things in their environment they can't change

## Jobs-to-be-done

Primary job:
> When I {situation}, I want to {motivation}, so I can {expected outcome}.

Secondary jobs:
- When I {…}, I want to {…}, so I can {…}.
- When I {…}, I want to {…}, so I can {…}.

## Representative quotes

2–3 anonymized quotes that capture this persona's voice.

> "{quote}" — {segment reference}

## Anti-persona

Who this persona is NOT. What segments we should NOT optimize for based on this persona. Being explicit about the anti-persona prevents scope creep.

## Design implications

- UI patterns that align with this persona (e.g., "expects keyboard shortcuts; low tolerance for modal dialogs")
- Content tone
- Feature priorities
- Common mistakes to avoid with this persona

## Success signals

How we'd know we're serving this persona well.
- Behavioral: {e.g., "returns in < 7 days 60%+ of the time"}
- Qualitative: {e.g., "describes us using phrase X"}

## Evidence-to-claim map

| Claim | Evidence |
|---|---|
| "They prefer keyboard to mouse" | 6/7 interviews mentioned; verified in telemetry |
| "They buy without finance approval" | 4 interviews; 1 contradiction |
| … | … |

## Confidence: {low/medium/high}

Rationale: {what makes this confidence level}
```

## Output requirements

- Evidence base section mandatory — persona without evidence is fiction.
- Anti-persona section mandatory — explicit exclusion prevents future scope errors.
- Evidence-to-claim map at the bottom is mandatory; every non-trivial claim traces to a source.
- At least 2 anonymized quotes.
- Jobs-to-be-done in the canonical "when I / I want to / so I can" format.
- Confidence label mandatory; default `medium`.
