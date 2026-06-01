---
name: journey-map
description: Map a user's journey through a flow with stages, actions, thoughts, feelings, pain points, and opportunities. Use when the ticket asks how users experience a specific flow end-to-end.
---

# journey-map

## When to invoke

Invoke when the ticket:
- Asks to map a specific user flow (onboarding, first value, habitual use, etc.)
- Needs to identify where users drop off or get frustrated
- Wants to surface opportunities tied to specific stages

For a snapshot of a single screen, use `usability-audit`. For segment-level characterization, use `persona`.

## Template

```markdown
# Journey map — {flow name}

**Target app:** {app_id}
**Date:** {YYYY-MM-DD}
**Triggering ticket:** [CAR-{n}]({URL})
**Confidence:** {low/medium/high}
**Persona / segment:** {which user segment — link persona if it exists}

## Scope

Clear bounds on the flow being mapped. When does it start? When does it end? What's NOT included?

Example: "From first landing on marketing site through first value (published their first knowledge base entry). Does NOT include pricing/purchase flow."

## Stages

| Stage | Actions (what they do) | Thoughts (what they're thinking) | Feelings | Pain points | Opportunities |
|---|---|---|---|---|---|
| Awareness | … | … | … | … | … |
| Consideration | … | … | … | … | … |
| Signup | … | … | … | … | … |
| Onboarding | … | … | … | … | … |
| First value | … | … | … | … | … |
| Habitual use | … | … | … | … | … |

(Adjust stages to the actual flow being mapped. Not every flow has all six.)

## Biggest drop-off

Where users lose momentum or quit. Be specific — stage and sub-step. Support with evidence:
- Behavioral: funnel data, session recordings, error logs
- Qualitative: quotes describing friction

## Top 3 pain points (ranked)

### 1. {Pain point}
**Stage:** {which}
**Evidence:** {behavioral + qualitative}
**Impact:** {how many users, how severe}
**Suggested investigation:** {what Designer should look at — don't prescribe solutions}

### 2. {Pain point}
…

### 3. {Pain point}
…

## Top 3 opportunities

Where the product could step up. Not solutions — opportunity framing.

### 1. {Opportunity}
**Stage:** {which}
**Rationale:** Why this would improve the journey
**Hand to:** Designer / PM-lite

### 2. …
### 3. …

## Quotes

> "{quote}" — {stage in journey where it applies}, {segment}

Include 4–6 quotes, one per major stage where possible.

## Methodology

- **Evidence sources:** Interviews (N), survey (N responses), telemetry (date range), session recordings (N)
- **Segments covered:** Which segments this journey applies to; which it doesn't
- **Known gaps:** Stages where evidence is thin

## Confidence: {low/medium/high}

Rationale: {}
```

## Output requirements

- Stages table must be fully populated. No blank cells — use "unknown" if evidence is missing and flag in methodology.
- Drop-off section needs specific stage/sub-step + evidence. "Users drop off somewhere in onboarding" is not useful.
- Pain points and opportunities ranked — not just listed.
- At least 4 quotes spread across stages.
- Confidence label mandatory.
