---
name: architecture-review
description: Review an existing engineering proposal, ticket, or draft spec against architectural principles. Produces a structured read — approve / request changes / reject with alternatives — grounded in specific concerns, not vibes.
---

# architecture-review — read on an existing proposal

## When to invoke

Invoke when the ticket asks you to review a proposal (usually linked from the ticket description as a Notion spec, PR draft, or ADR someone else wrote). The output is a structured critique.

If the ticket asks you to make the decision yourself, use `adr-author` instead. This skill is for giving a second opinion.

## Template

```markdown
# Architecture review — {subject}

**Reviewer:** Technical Architect routine
**Date:** {YYYY-MM-DD}
**Target app(s):** {ids}
**Triggering ticket:** [CAR-{n}]({URL})
**Under review:** [link to proposal being reviewed]
**Verdict:** Approve | Approve with changes | Request rework | Reject

## Executive summary
One paragraph. What the proposal is. The verdict. The single most important reason.

## Strengths
What the proposal gets right. 2–4 bullets. Be specific — "clean separation of concerns" is not specific; "keeps auth in the provider layer, not the API handler" is.

## Concerns

### Concern 1 — {short label}
**Severity:** Blocking | Major | Minor
**Description:** What's wrong or unclear.
**Evidence:** Reference specific section/line/paragraph of the proposal.
**Suggested resolution:** What would unblock / satisfy this concern.

### Concern 2 — …
…

## Questions the proposal doesn't answer
- Question 1
- Question 2

These aren't concerns (they may not affect the decision), but the author should address them in the next revision.

## Alternatives considered by the proposal
(If the proposal includes alternatives, comment on whether the rejection reasoning holds up.)

## Recommendation to Riché

- **Approve:** Ready to proceed. Concerns are minor and can be addressed in implementation.
- **Approve with changes:** Proceed after resolving concerns 1 and 2. Concerns 3+ optional.
- **Request rework:** Too many blocking concerns. Author should revise and resubmit.
- **Reject:** Fundamental approach is wrong. Here's an alternative direction: {summary}.

## References
- Linked ADRs
- Prior reviews of this or similar proposals
```

## Output requirements

- Verdict is mandatory and singular (one of the four)
- Every "Blocking" concern must include a suggested resolution, not just criticism
- "Approve" verdict cannot include blocking concerns
- If verdict is "Reject," must include an alternative direction (one paragraph minimum)
- Strengths section is mandatory — reviews that only criticize are poorly calibrated
