---
name: usability-audit
description: Heuristic evaluation of a specific UI surface or flow. Use when the ticket asks to audit an existing screen, page, or interaction against usability heuristics. Produces a structured critique with severity-ranked findings.
---

# usability-audit

## When to invoke

Invoke when the ticket:
- Asks to audit a specific UI surface (a page, modal, form, dashboard)
- Asks for heuristic evaluation
- Lists usability concerns that need structured diagnosis

For journey-level analysis, use `journey-map`. For synthesis across many users, use `interview-synthesis`.

## Template

```markdown
# Usability audit — {surface name}

**Target app:** {app_id}
**Date:** {YYYY-MM-DD}
**Triggering ticket:** [CAR-{n}]({URL})
**Confidence:** {low/medium/high}
**Evaluator:** User Researcher routine
**Method:** Nielsen's 10 heuristics + cognitive walkthrough

## Surface evaluated

Describe exactly what was audited. Link screenshots if possible. Note the date / version.

## Cognitive walkthrough

Pick the most important task on this surface. Walk through as a new user would.

- **Task:** {specific user goal}
- **Starting state:** {what the user is looking at}

### Step 1: {action}
- What the user sees
- What they probably think
- What they actually need to do
- Friction?

### Step 2: {action}
…

### Step 3: {action}
…

## Findings

Each finding maps to one or more of Nielsen's heuristics. Severity: Catastrophic, Major, Minor, Cosmetic.

### Finding 1 — {short label}
**Heuristic violated:** {#N — Name}
**Severity:** {Catastrophic / Major / Minor / Cosmetic}
**Location:** {specific UI element / screen region}
**Description:** What's wrong in user terms.
**Evidence:** Why this is a problem (cognitive load, error-proneness, violated convention, etc.)
**Suggested direction:** {not a prescribed solution — a direction for Designer to explore}

### Finding 2 — …
…

## Nielsen's heuristics reference

For the reader who needs the list:

1. Visibility of system status
2. Match between system and real world
3. User control and freedom
4. Consistency and standards
5. Error prevention
6. Recognition rather than recall
7. Flexibility and efficiency of use
8. Aesthetic and minimalist design
9. Help users recognize, diagnose, and recover from errors
10. Help and documentation

## Strengths

What this surface does well. 2–3 bullets. Audits that only critique are miscalibrated.

## Recommendations ranked by impact

1. **{Finding X}** — highest impact; fix first. Reason.
2. **{Finding Y}** — second priority. Reason.
3. **{Finding Z}** — …

## Hand-off

The routine does NOT file engineering tickets directly. Audits produce findings; solutions are Designer + Riché territory.

For Major/Catastrophic findings: the audit surfaces the problems and suggested directions. Designer reviews the audit and, with Riché's approval, decides whether to iterate the design (a `design-prototype/` branch) — at which point Designer files the ticket, not this routine.

For findings that reveal a bigger product problem (e.g., the whole surface's purpose is unclear): flag in the Linear summary comment as a candidate for a `type:strategy-decision` ticket so Riché can decide whether to re-scope.

## Confidence: {low/medium/high}

Rationale: {e.g., "medium — expert heuristic eval only; no user testing to validate severity rankings"}

## Sources

- Nielsen Norman Group, 10 Usability Heuristics for User Interface Design
- Surface screenshots (linked)
- Related user research that informs this audit
```

## Output requirements

- At least 3 findings. Fewer than that isn't an audit.
- Each finding must map to a specific Nielsen heuristic (or multiple).
- Severity mandatory on every finding.
- Cognitive walkthrough section mandatory — grounds abstract heuristics in actual user behavior.
- Strengths section mandatory.
- Recommendations ranked, not listed.
- Confidence label mandatory.
