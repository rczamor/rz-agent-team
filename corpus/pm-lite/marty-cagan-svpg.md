---
name: Marty Cagan / Silicon Valley Product Group
role: pm-lite
type: individual+organization
researched: 2026-04-16
---

# Marty Cagan / Silicon Valley Product Group (SVPG)

## Why they matter to the PM-lite
Cagan and SVPG are the canonical reference for what "good" looks like in modern product orgs. For PM-lite, Cagan's value is not in setting strategy (Riché owns that) but in clarifying the line between strategy and execution so PM-lite stays on the execution side of it. Cagan's "product team vs. feature team" distinction is the single sharpest lens for PM-lite to check its own work: is this ticket describing an **output** (build X feature) when it should describe an **outcome** the engineer already understands? Is this spec a backlog item with no problem statement, or does it carry enough context that the empowered engineer can push back on scope? PM-lite does NOT make the strategic calls Cagan preaches — but PM-lite IS the person who translates them into tickets without losing the "why," and who flags to Riché the moment a ticket drifts from outcome to pure output.

## Signature works & primary sources
- *Inspired: How to Create Tech Products Customers Love* — https://www.svpg.com/books/ — the baseline vocabulary for what a PM is supposed to do.
- *Empowered: Ordinary People, Extraordinary Products* — https://www.svpg.com/books/ — the "why your team sucks" diagnostic that shows what PM-lite should NOT try to own (strategy, coaching) vs. what it should (crisp translation of product direction into work).
- *Transformed: Moving to the Product Operating Model* — https://www.svpg.com/books/ — the operating model PM-lite's tickets must fit inside.
- "Product vs. Feature Teams" — https://www.svpg.com/product-vs-feature-teams/ — the single article to reread before writing a spec.
- "Product Model Concepts" — https://www.svpg.com/product-model-concepts/ — clean definitions PM-lite can paste into Notion.

## Core principles (recurring patterns)
1. **Outcomes, not output.** A ticket should describe the customer/business problem being solved, not just the feature artifact. If PM-lite can't state the outcome in one line, the ticket isn't ready.
2. **Discovery is separate from delivery.** PM-lite lives in delivery. Don't smuggle unresolved discovery questions into delivery tickets — flag them back to Riché.
3. **Empowered engineers need problems, not prescriptions.** Over-specified tickets kill the team's leverage. Describe the problem + constraints; leave solution space where possible.
4. **The PM owns the "why," the designer owns the experience, the engineer owns how.** PM-lite's spec must protect the "why" even when handing off UI to designers and implementation to engineers.
5. **Feature factories lose.** A backlog that only contains outputs with no linked outcomes is a feature-factory tell. PM-lite should flag this pattern to Riché.

## Concrete templates, checklists, or artifacts the agent can reuse

**"Product vs. Feature Ticket" sniff test (run on every ticket before handoff):**
- [ ] States a user/business problem in one sentence
- [ ] States the measurable outcome (not the artifact shipped)
- [ ] Leaves solution room OR explicitly notes why the solution is fixed
- [ ] Named single DRI
- [ ] Linked to a parent project/goal — not orphaned

**Outcome-first spec skeleton (Notion):**
```
Problem: <one sentence, user's voice>
Target outcome: <metric or observable behavior change>
Evidence this matters: <link to research, ticket, data>
Non-goals: <what we are explicitly not doing>
Constraints: <tech, legal, timeline>
Open questions for Riché: <strategy-level questions PM-lite cannot answer>
```

**Handoff escalation rule:** if a ticket requires a tradeoff between two outcomes (e.g. speed vs. quality, growth vs. retention), PM-lite does NOT decide — it drafts the options and kicks to Riché.

## Where they disagree with others
- **Cagan vs. Linear:** Cagan insists on rich problem-context framing; Linear ("Write issues, not user stories") prefers concise task statements. Reconcile by keeping the "why" in the parent project/spec doc and the "what" in the Linear issue — don't duplicate.
- **Cagan vs. Shreyas Doshi:** Cagan frames PM work around discovery; Doshi breaks PM work into three levels (execution, strategic, mission-critical) and is more permissive of execution-heavy PM roles like PM-lite. Doshi is a better role model for this agent than Cagan.
- **Cagan vs. Lenny:** Cagan is prescriptive ("this is THE product model"); Lenny is pluralistic (here are 15 PRD templates that work). PM-lite should prefer Lenny's menu for templates and Cagan's lens for sniff-testing outputs.

## Pointers to source material
- svpg.com/articles — full article archive
- Books: *Inspired* (3rd ed., 2017), *Empowered* (2020), *Transformed* (2024)
- Cagan's talks on YouTube (search "Marty Cagan empowered product teams")
