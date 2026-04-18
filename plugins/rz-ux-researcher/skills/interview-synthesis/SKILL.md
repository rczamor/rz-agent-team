---
name: interview-synthesis
description: Synthesize themes from multiple user interview transcripts. Use when the ticket provides N interview transcripts (typically 3+) and asks what common threads, pain points, or jobs-to-be-done emerge.
---

# interview-synthesis

## When to invoke

Invoke when the ticket:
- Links to N interview transcripts (usually in Notion or Google Drive)
- Asks for themes, patterns, or JTBD from those interviews
- Requests a synthesis pass, not a single-user account

For persona creation, use `persona` (often follows synthesis). For mapping the flow users described, use `journey-map`.

## Template

```markdown
# Interview synthesis — {topic}

**Date:** {YYYY-MM-DD}
**Target app(s):** {app_id}
**Triggering ticket:** [CAR-{n}]({URL})
**N interviewed:** {number}
**Segments:** {e.g., "4 early SIA users + 3 website chatbot users"}
**Confidence:** {low/medium/high}

## Methodology

- **Collection method:** Interviews, Zoom / in-person / async
- **Protocol:** Semi-structured / structured / open
- **Duration:** {min–max} per interview
- **Recording:** Transcribed by {tool}
- **When:** Date range of interviews
- **Known biases:** Self-selected respondents? Beta users only? Power users? Name the sampling bias explicitly.

## Themes (ranked by strength)

### Theme 1 — {short phrase}
**Confidence:** {low/medium/high}
**N supporting:** {count} of {total}

**Supporting quotes:**
> "{anonymized direct quote}" — {segment}, {date}
> "{second quote, different person}" — {segment}, {date}
> "{third quote}" — {segment}, {date}

**Synthesis:**
One paragraph explaining what the theme means. Not a restatement of quotes — the interpretation.

**Implications:**
- For Designer: …
- For PM-lite / Riché: …

---

### Theme 2 — {short phrase}
…

### Theme 3 — {short phrase}
…

(Aim for 3–6 themes. More than 6 is usually not synthesis; it's a transcript dump.)

## Discarded themes

Themes that appeared but didn't hold up on examination. One line each on why.

- **{Theme}** — only 1 person; not a pattern.
- **{Theme}** — contradicted by behavioral data.
- **{Theme}** — specific to prior product version we've since changed.

## Surprises

What did you NOT expect going in? Surprises are often the highest-signal finding.

## Gaps

What we still don't know after this synthesis. What the next round of research would need to cover.

## Anonymization note

All direct quotes have been stripped of: names, company names, emails, phone numbers, and other PII. If any quotes reveal segment in a way that identifies a specific user, they've been further generalized.

## Sources

- Interview IDs or Notion page links
- Date range: {start} – {end}
- Interviewer(s): {if applicable}

## Confidence: {low/medium/high}

Rationale: {e.g., "medium — themes consistent across segments, but small N (n=7)"}
```

## Output requirements

- Minimum N = 3 interviews. Fewer than that isn't synthesis, it's a summary.
- Each theme must have at least 2 supporting quotes from different people.
- Every quote must be anonymized.
- Discarded themes section mandatory — shows rigor of the synthesis.
- Surprises section mandatory — catching yourself off-guard is often the highest-value insight.
- Confidence label mandatory.
