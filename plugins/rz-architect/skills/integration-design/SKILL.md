---
name: integration-design
description: Design how two or more systems fit together when the ticket asks for a sequence of interactions, a data contract, or failure-mode planning across a system boundary. Produces a design doc with sequence diagram, contract, failure modes, and rollout plan.
---

# integration-design — cross-system design

## When to invoke

Invoke when the ticket:
- Connects two+ services, apps, or external APIs
- Asks how data should flow between components
- Proposes a new webhook, MCP tool contract, or inter-service call pattern
- Needs a rollout plan for a cross-cutting change

If the question is "which technology," use `tech-stack-eval` or `adr-author` instead.

## Template

```markdown
# Integration — {system A} ↔ {system B}

**Target app(s):** {ids}
**Triggering ticket:** [CAR-{n}]({URL})
**Status:** Proposed | Accepted

## Problem
What flow are we enabling? What's the user-visible behavior?

## Sequence (happy path)

```
Actor A → System A: action
System A → System B: request (data contract v1)
System B → System A: response (status + payload)
System A → Actor A: confirmation
```

Use mermaid if the sequence has branches. For simple linear flows, text is fine.

## Data contract

### A → B request
| Field | Type | Required | Description |
|---|---|---|---|
| ... | ... | ... | ... |

### B → A response
| Field | Type | Description |
|---|---|---|
| status | enum | "ok" / "error" |
| ... | ... | ... |

### Versioning
How the contract is versioned. How breaking changes are communicated. Deprecation window.

### Idempotency and retry
- Is the call idempotent? By what key?
- Retry policy on which failure classes
- Dedup behavior on the receiver

## Failure modes

| Failure | Detection | Response | Observability |
|---|---|---|---|
| B unreachable | timeout at A | queue + retry | Langfuse span fails, alert after N retries |
| B 5xx | response code | retry with backoff | ... |
| A → B partial | checksum mismatch | reject + log | ... |
| Malformed payload | schema validation | 400 + detailed error | ... |

## Non-functional requirements

- Latency budget (p50 / p99)
- Throughput expectations
- Auth model (who can call what; token / signature / mutual TLS)
- Rate limits

## Rollout plan

1. **Phase 1 — Shadow:** A calls B but doesn't use the response. Compare to existing behavior. Duration: {N days}.
2. **Phase 2 — Staged:** X% of traffic uses B's response. Increment over {N days}.
3. **Phase 3 — Full:** 100% traffic. Old path deprecated.
4. **Rollback:** Flag-gated at phase 1–2. Rollback is flip the flag + alert. Data rollback only if B produced divergent state.

## Observability requirements

- Every A → B call emits a Langfuse span with attributes
- Error rate dashboard requirement
- SLO targets

## Open questions
...

## References
- Linked ADRs
- External docs
```

## Output requirements

- Sequence section must include at least one error branch, not just happy path
- Data contract must specify ALL fields (no "etc.")
- Failure modes table must have at least 4 rows
- Rollout plan must include explicit rollback criteria
- If the integration crosses apps, tag both `app_id`s in page properties
