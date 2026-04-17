---
name: Jesse Anderson
role: data-eng
type: individual
researched: 2026-04-16
---

# Jesse Anderson

## Why they matter to the Data Eng
Jesse Anderson — Managing Director of the Big Data Institute, long-time Kafka/Spark/Hadoop trainer — is the field's most practical voice on **why big-data projects fail**, and it is almost always not for the reasons engineers think. His book *Data Teams* argues that the technical stack is the easy part; what breaks projects is team composition — specifically, hiring only data scientists and expecting them to do data engineering, or standing up streaming infrastructure with a single engineer. For a single-VPS Postgres setup this matters precisely because you don't have a team yet: Anderson's framing tells you which roles you will need to add, in what order, and which to defer. He is also one of the few voices who writes plainly about **when streaming is overkill** — essential counter-pressure to the "everything should be Kafka" reflex.

## Signature works & primary sources
- *Data Teams: A Unified Management Model for Successful Data-Focused Teams* (Apress, 2020) — https://www.amazon.com/Data-Teams-Management-Successful-Data-Focused/dp/1484262271 — the 3-team model (data engineering, data science, operations) and ratio guidance.
- Real-time Data Pipelines course — https://www.jesse-anderson.com/courses/real-time-data-pipelines/ — Kafka + Spark Streaming applied.
- Managing Data Teams course — https://www.jesse-anderson.com/courses/managing-data-teams/ — operationalized version of the book.
- Big Data Institute blog — https://www.jesse-anderson.com — regular essays on staffing, streaming pitfalls, and why projects fail.
- (Note: *The Data Engineering Cookbook* is by Andreas Kretz, not Anderson — the seed brief mis-attributed it. Kretz's cookbook is still a good complementary reference: https://github.com/andkret/Cookbook.)

## Core principles (recurring patterns)
- **The 3-team model**: successful data orgs need distinct Data Engineering, Data Science, and Operations teams. Missing one is the most common root cause of failure. Anderson's rough ratio heuristic: for every data scientist, expect 2–3 data engineers.
- **Streaming is a commitment, not a technology**: running Kafka in production requires dedicated engineers, not a side-project hire. If you can't staff it, don't start it.
- **Batch first, streaming when justified**: pick streaming only when the business value clearly requires sub-minute freshness. Otherwise the complexity overhead dwarfs the benefit.
- **"Small data" is still most data**: a lot of what's sold as big data fits on one machine. Match the tool to the data volume, not the marketing deck.
- **Team size gates architecture**: a 1-person data team should not own a streaming platform. Architectural ambition should trail headcount, not lead it.
- **Training matters**: data engineers get hired without the distributed-systems fundamentals they actually need; budget time for real training, not "learn it in the sprint."

## Concrete templates, checklists, or artifacts the agent can reuse
- **Pre-streaming checklist**: (1) Is the SLA genuinely sub-minute, or did someone say "real-time" casually? (2) Do we have ≥2 engineers comfortable with a streaming system? (3) Is there a batch fallback when the stream breaks? (4) Who pages at 3am? If any is "no," defer streaming.
- **Data-team staffing plan**: for the current backlog, list which items are DE vs. DS vs. Ops. If any column is zero and the backlog depends on it, that's the next hire.
- **Kafka-readiness checklist** (before adopting): schema registry, topic-naming convention, consumer-group ownership map, retention policy per topic, dead-letter strategy, upgrade-in-production runbook.
- **"Batch-first" pipeline recipe** for single-VPS: Postgres source → scheduled SQL snapshot (cron/dbt) → partitioned fact table → BI query. Add streaming only when this pattern demonstrably can't meet latency.

## Where they disagree with others
- vs. "hire a data scientist and they'll figure it out": Anderson is vocal that this is the most expensive failure mode in the field; data science without data engineering produces notebooks, not products.
- vs. "streaming-first" orthodoxy (some Huyen-adjacent takes): he explicitly pushes back on adopting Kafka/Flink before you have the staff and the SLA to justify it.
- vs. "tool choice dominates": most failure root-causes are team/structural, not technical. The modern-data-stack debate matters less than whether the team exists at all.

## Pointers to source material
- Site: https://www.jesse-anderson.com
- Book: *Data Teams* — https://www.amazon.com/dp/1484262271
- Courses: https://www.jesse-anderson.com/courses/
- Podcast appearances: frequent on Data Engineering Podcast, Software Engineering Daily.
