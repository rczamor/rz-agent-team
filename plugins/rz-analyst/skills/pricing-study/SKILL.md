---
name: pricing-study
description: Study how the market prices similar offerings and produce pricing/packaging recommendations. Use when the ticket asks about pricing tiers, packaging models, or monetization for a specific app or feature.
---

# pricing-study

## When to invoke

Invoke when the ticket:
- Asks how competitors price a similar product
- Proposes new pricing tiers and wants validation against market
- Asks about packaging models (freemium, seats, usage, value-based, tiered)
- Wants a pricing page recommendation

## Template

```markdown
# Pricing study — {product / feature}

**Date:** {YYYY-MM-DD}
**Target app(s):** {app_id}
**Triggering ticket:** [CAR-{n}]({URL})
**Confidence:** {low/medium/high}

## What we're pricing

One paragraph: the product or feature, the buyer, the willingness-to-pay hypothesis.

## Market benchmark

| Company | Entry | Mid | Top | Model | Notes |
|---|---|---|---|---|---|
| Competitor A | $X/mo | $Y/mo | Contact us | Seat-based | Discounts on annual |
| Competitor B | Free | $Z/mo | $W/mo | Freemium → usage | 5-seat floor on paid |
| Competitor C | $V | $W | $X | Value metric ({metric}) | Custom for >{threshold} |
| Adjacent D | $A/mo | $B/mo | - | Flat monthly | No public enterprise tier |

Include 3–7 benchmarks. Cite pricing pages / public data.

## Packaging patterns observed

- **Pattern 1:** {description} — used by Company A, C
- **Pattern 2:** {description} — used by Company B
- **Pattern 3:** {description} — rare, used by D

## Willingness-to-pay signals

- From public reviews / forums / support threads where users discuss price
- From competitor churn signals (if available)
- From Riché's own telemetry if there's a free tier to analyze

## Value metric recommendation

What unit should pricing scale on? Options:
- **Seats** — good when value is per-person; bad when one buyer serves many
- **Usage** ({unit}) — good when consumption correlates with value
- **Tiers** — good when feature differentiation is sharp
- **Flat** — good when market is commoditized and friction matters most
- **Value-based** — good when outcomes are measurable and variable

Recommend one primary value metric. Justify.

## Recommended pricing

### Tier 1: {name}
- Price: $X/mo or free
- Who it's for: {segment}
- What's included: {features}
- What drives upgrade: {limit or feature gate}

### Tier 2: {name}
- Price: $Y/mo
- Who it's for: {segment}
- What's included: {features}
- What drives upgrade: {limit or feature gate}

### Tier 3: {name}
- Price: Contact / $Z
- Who it's for: {segment}
- What's included: {features}

## Rollout considerations

- Legacy user treatment (if changing existing pricing)
- Annual discount recommendation ({typical 15–20%})
- Trial length recommendation
- Expansion revenue mechanics

## Risks

- **Underpricing:** Signal of low value; race to bottom
- **Overpricing:** Small market, no adoption
- **Packaging confusion:** Tiers must be understandable in 30 seconds
- **Migration:** Changing pricing for existing users erodes trust

## Open questions

- What we don't know (e.g., conversion rate from free → paid in our category)

## Sources

- Pricing page URLs
- Review sites (G2, Capterra) for pricing mentions
- Community threads

## Confidence: {low/medium/high}
```

## Output requirements

- At least 3 benchmark competitors with specific public prices. If prices aren't public, note "contact sales" and move on.
- Must recommend a single primary value metric with justification.
- Tier structure: 2–4 tiers. More than 4 is usually overengineered.
- Risks section mandatory — pricing mistakes are easy and painful.
- Confidence label mandatory.
