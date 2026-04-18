# Agent Team Knowledge Corpus — Research Seeds

Curated list of thought leaders, practitioners, organizations, publications, and communities for each agent role. Covers the 10 core OpenClaw execution agents + the 4 Claude Code Routines strategic roles. Intended as input for Claude Cowork to conduct deeper research and assemble the knowledge corpus each agent will draw from.

The original 11-role structure (1–11 below) was written April 16, 2026. After the April 17 refactor, the generic "Researcher" role was retired and its work split into 4 strategic routines (sections 12–15). The `@growth` exception agent is covered under its own Notion spec rather than a dedicated corpus.

Format per role: 5–7 seeds, mixing classic authorities, modern practitioners, and relevant orgs/publications/communities. Each entry includes who/what, why they matter, signature work, and where to find them.

---

## 1. Conductor — Tech Lead & Orchestrator

The Conductor needs to think like a staff/principal engineer: system design, architectural tradeoffs, code review judgment, orchestration of multi-step work, and tiebreaker decisions.

**Will Larson**
- Why: Wrote the definitive modern playbook on tech leadership and engineering strategy.
- Signature work: *An Elegant Puzzle*, *Staff Engineer*, *The Engineering Executive's Primer*.
- Where: lethain.com, his Substack.

**Tanya Reilly**
- Why: Defined what Staff+ engineers actually do — glue work, project leadership, technical strategy documents.
- Signature work: *The Staff Engineer's Path* (book), "Being Glue" talk.
- Where: noidea.dog, conference talks on YouTube (LeadDev, QCon).

**Camille Fournier**
- Why: *The Manager's Path* is the canonical reference for engineering leadership transitions; strong on code review culture and team scaling.
- Signature work: *The Manager's Path*, blog posts on elidedbranches.
- Where: elidedbranches.com, Twitter/X.

**Gergely Orosz**
- Why: The most-read working-engineer newsletter; deep coverage of engineering practices at top companies.
- Signature work: *The Pragmatic Engineer* newsletter, *The Software Engineer's Guidebook*.
- Where: pragmaticengineer.com.

**Martin Fowler / ThoughtWorks**
- Why: Foundational on refactoring, enterprise architecture, and continuous delivery. ThoughtWorks Technology Radar is a standard reference for what to adopt/avoid.
- Signature work: *Refactoring*, *Patterns of Enterprise Application Architecture*, Technology Radar (biannual).
- Where: martinfowler.com, thoughtworks.com/radar.

**LeadDev**
- Why: Premier community and content hub for engineering leadership — conferences, articles, case studies directly applicable to tech lead decision-making.
- Where: leaddev.com, LeadDev conference recordings.

**StaffEng**
- Why: Community + narrative archive of real staff-engineer stories, promotion paths, and scope descriptions.
- Where: staffeng.com, *Staff Engineer* book (Larson).

---

## 2. Product Manager (PM-lite) — Spec Wrangler & Ticket Shepherd

This role executes — it translates strategy into tickets, writes crisp acceptance criteria, and shepherds handoffs. Needs strong writing, ticket hygiene, and backlog discipline rather than discovery/strategy chops.

**Marty Cagan / Silicon Valley Product Group**
- Why: Canonical on how modern product teams operate; clear on what "good" looks like in ticket writing, discovery vs. delivery, and empowered teams.
- Signature work: *Inspired*, *Empowered*, *Transformed*.
- Where: svpg.com, SVPG articles.

**John Cutler**
- Why: Best living writer on backlog mechanics, how teams actually work, ticket anti-patterns, and visualizing flow. Directly relevant to a PM-lite role.
- Signature work: *The Beautiful Mess* newsletter, TBM visuals/infographics.
- Where: cutlefish.substack.com, LinkedIn.

**Shreyas Doshi**
- Why: Sharpest modern voice on PM execution, writing, prioritization frameworks (LNO), and why PMs fail. Pragmatic and tactical.
- Signature work: *The Skip-Level* podcast, Twitter threads on PM craft, Maven courses.
- Where: Twitter/X @shreyas, skiplevel.co.

**Lenny Rachitsky**
- Why: Biggest PM-practitioner newsletter; extensive library on ticket writing, PRDs, roadmaps, and specifically how top companies run delivery.
- Signature work: *Lenny's Newsletter*, *Lenny's Podcast*.
- Where: lennysnewsletter.com.

**Mind the Product**
- Why: Largest global PM community; talks and articles on execution craft, acceptance-criteria patterns, stakeholder management.
- Where: mindtheproduct.com, ProductTank meetups, MTP conferences.

**Linear (the company) — method blog**
- Why: Linear's own writing on how to run engineering projects is essentially the operating manual for the tool this agent lives in.
- Signature work: "The Linear Method."
- Where: linear.app/method, linear.app/blog.

**Atlassian Agile Coach / Team Playbook**
- Why: Free, detailed templates for acceptance criteria, story writing, DoR/DoD, sprint mechanics. Direct reference material.
- Where: atlassian.com/agile, atlassian.com/team-playbook.

---

## 3. Researcher — Market, User & Technical Research

Mixes three distinct disciplines: competitive/market research, user-research synthesis, and technical framework evaluation. Needs rigor on sourcing and synthesis.

**Teresa Torres**
- Why: Modern standard for continuous discovery and opportunity-solution trees — how to structure research findings into actionable product inputs.
- Signature work: *Continuous Discovery Habits* (book), Product Talk blog.
- Where: producttalk.org.

**Erika Hall**
- Why: *Just Enough Research* is the most practical book on research methods for small teams; sharp on interview design and bias.
- Signature work: *Just Enough Research*, *Conversational Design* (both A Book Apart).
- Where: mulecollective.com, A Book Apart archive.

**Tomer Sharon**
- Why: Practical user-research methods, research-ops, and democratizing research at scale.
- Signature work: *Validating Product Ideas*, *It's Our Research*.
- Where: Medium, LinkedIn.

**Christian Rohrer / NN/g (Nielsen Norman Group)**
- Why: NN/g publishes the most rigorous, citable UX research methods library anywhere — when/how to use each method, sample sizes, synthesis.
- Signature work: "When to Use Which User-Experience Research Methods" (Rohrer), NN/g reports.
- Where: nngroup.com.

**Pew Research Center + Gartner + CB Insights**
- Why: Reference sources for competitive and market research — methodology, sizing, trend data. CB Insights specifically for tech-market mapping.
- Where: pewresearch.org, gartner.com, cbinsights.com.

**ThoughtWorks Technology Radar**
- Why: Gold-standard periodic framework/library evaluation document. Model for how a Researcher should structure "adopt/trial/assess/hold" recommendations.
- Where: thoughtworks.com/radar.

**Research Ops Community + ResearchOps Slack**
- Why: Practitioner community for research process, templates, and repository patterns — directly applicable to how agent-produced research is stored and reused.
- Where: researchops.community.

---

## 4. Product Designer — UX & Interaction Design (code-first)

This agent designs in code, not Figma. Needs grounding in interaction design, design systems as code, and accessibility — but also modern HTML/CSS craft.

**Don Norman**
- Why: Foundational. *The Design of Everyday Things* underpins every interaction decision about affordances, feedback, and error prevention.
- Signature work: *The Design of Everyday Things*, *Emotional Design*.
- Where: jnd.org, Nielsen Norman Group.

**Luke Wroblewski**
- Why: Decades of deeply practical writing on forms, mobile-first, and interaction patterns — the kind of detail a code-first designer needs.
- Signature work: *Web Form Design*, *Mobile First*, LukeW blog.
- Where: lukew.com.

**Brad Frost**
- Why: Atomic Design — how to structure a component library, which maps directly to building design systems in real code (Tailwind + React or Jinja + Pico).
- Signature work: *Atomic Design* (free online), Pattern Lab.
- Where: bradfrost.com, atomicdesign.bradfrost.com.

**Adam Wathan / Tailwind Labs**
- Why: Tailwind is the design system for richezamor.com. Adam's writing on utility-first CSS and Tailwind UI patterns is the canonical reference.
- Signature work: Tailwind docs, *Refactoring UI* (with Steve Schoger).
- Where: tailwindcss.com, refactoringui.com, adamwathan.me.

**Josh Comeau**
- Why: Best modern teacher of CSS and interaction implementation — animations, layout, and design-meets-code craft with full examples.
- Signature work: joshwcomeau.com blog posts, *CSS for JS Developers* course.
- Where: joshwcomeau.com.

**Heydon Pickering + Adrian Roselli**
- Why: Authoritative on accessible interaction patterns with working code examples — non-negotiable for a designer whose output is production-ready code.
- Signature work: *Inclusive Components* (Heydon), adrianroselli.com posts.
- Where: inclusive-components.design, adrianroselli.com.

**Smashing Magazine + A List Apart**
- Why: Two long-running publications still producing substantive design/dev craft articles directly applicable to code-first design work.
- Where: smashingmagazine.com, alistapart.com.

---

## 5. Backend Engineer — Server-Side Developer

Needs strong fundamentals on API design, data modeling, auth, and the specific stacks in play (FastAPI/Python + Next.js/Node).

**Martin Kleppmann**
- Why: *Designing Data-Intensive Applications* is the single most-referenced modern backend book — data modeling, consistency, distributed systems tradeoffs.
- Signature work: *Designing Data-Intensive Applications*.
- Where: martin.kleppmann.com.

**Sebastián Ramírez (tiangolo)**
- Why: Creator of FastAPI — SIA's backend framework. His docs and writing define idiomatic usage.
- Signature work: FastAPI docs, SQLModel, Typer.
- Where: fastapi.tiangolo.com, tiangolo.com.

**Mike Bayer**
- Why: Creator of SQLAlchemy and Alembic — SIA's ORM and migrations tool. Authoritative on Python database patterns.
- Signature work: SQLAlchemy docs, Alembic docs, zzzeek.org blog.
- Where: sqlalchemy.org, docs.sqlalchemy.org, zzzeek.org.

**Alex Xu**
- Why: System design explained concretely — practical for API and service architecture decisions.
- Signature work: *System Design Interview* (Vols 1–2), ByteByteGo newsletter/YouTube.
- Where: bytebytego.com.

**Brandur Leach**
- Why: Deep technical writing on Postgres, API design, idempotency, job queues, observability — real production-grade backend patterns.
- Signature work: brandur.org essays.
- Where: brandur.org.

**OWASP**
- Why: Authoritative reference for auth, input validation, and web security. OWASP Top 10 and ASVS are non-optional for any backend agent.
- Where: owasp.org.

**Microsoft REST API Guidelines + Google AIP**
- Why: Two of the most mature public API design standards. Good reference for consistency, versioning, and naming.
- Where: github.com/microsoft/api-guidelines, google.aip.dev.

---

## 6. Data Engineer — Pipeline & Data Flow Developer

Ingestion, ETL, scheduling, lineage, and quality — modern practitioner focus.

**Maxime Beauchemin**
- Why: Created Airflow and Superset; his writing shaped the modern data-engineering role and the "functional data engineering" paradigm.
- Signature work: "The Rise of the Data Engineer," "Functional Data Engineering," Preset blog.
- Where: Medium @maximebeauchemin, preset.io/blog.

**Joe Reis + Matt Housley**
- Why: *Fundamentals of Data Engineering* is the modern canonical text; covers the full lifecycle from ingestion to serving.
- Signature work: *Fundamentals of Data Engineering* (O'Reilly).
- Where: Joe Reis Substack, joereis.substack.com.

**Chip Huyen**
- Why: Best modern writer on ML-adjacent data systems, pipeline design, and data quality at production scale.
- Signature work: *Designing Machine Learning Systems*, *AI Engineering* (2024).
- Where: huyenchip.com.

**Jesse Anderson**
- Why: Big data/streaming specialist; practical on team structures, Kafka, and streaming pipelines.
- Signature work: *Data Teams*, *The Data Engineering Cookbook*.
- Where: jesse-anderson.com.

**dbt Labs + the dbt community**
- Why: dbt defined modern ELT patterns and transformation-as-code. Their docs + community discourse are primary references for pipeline engineers even outside dbt users.
- Where: getdbt.com, docs.getdbt.com, dbt Slack.

**Data Engineering Weekly + Locally Optimistic**
- Why: Two of the best curated newsletters tracking the field — tools, patterns, war stories.
- Where: dataengineeringweekly.com, locallyoptimistic.com.

**Airbyte + Fivetran + Meltano (open source) blogs**
- Why: These vendors publish substantial technical content on ingestion patterns, connector design, CDC, and schema evolution. Relevant even if not using the tools directly.
- Where: airbyte.com/blog, fivetran.com/blog, meltano.com/blog.

---

## 7. AI Engineer — Intelligence Layer Architect

Most demanding role on the team. Needs frontier LLM craft: prompt engineering, evals, retrieval, agents, fact-checking, MCP.

**Anthropic (Applied AI + docs)**
- Why: Direct source for Claude prompt engineering, tool use, MCP, and agent patterns — the actual models this agent uses.
- Signature work: Anthropic docs, "Building effective agents" post, prompt engineering guide, MCP spec.
- Where: docs.anthropic.com, anthropic.com/engineering, modelcontextprotocol.io.

**Hamel Husain**
- Why: Sharpest living voice on LLM evals — how to actually measure AI systems, which is the bottleneck for every real AI product.
- Signature work: "Your AI product needs evals," eval courses with Shreya Shankar.
- Where: hamel.dev, parlance-labs.com.

**Jason Liu**
- Why: Instructor library + his writing on structured outputs, RAG systems, and AI consulting patterns. Very practical.
- Signature work: Instructor (Python library), jxnl.co blog, *Systematically Improving RAG* course.
- Where: jxnl.co, github.com/jxnl/instructor.

**Simon Willison**
- Why: Tracks the LLM ecosystem daily, maintains `llm` CLI, writes the clearest tutorials on prompt injection, structured outputs, and eval patterns.
- Signature work: simonwillison.net (daily), llm CLI tool, "prompt injection" series.
- Where: simonwillison.net.

**Chip Huyen**
- Why: *AI Engineering* (2024) is the most comprehensive practitioner book on building AI applications — retrieval, evals, fine-tuning, agents.
- Signature work: *AI Engineering* (O'Reilly), *Designing Machine Learning Systems*.
- Where: huyenchip.com.

**LangChain + LlamaIndex docs/blogs**
- Why: Even if not using these frameworks, their documentation is the most extensive public corpus on RAG patterns, agent architectures, and retrieval techniques.
- Where: python.langchain.com, docs.llamaindex.ai, blog.langchain.dev.

**Latent Space (podcast + newsletter) + Lilian Weng's blog**
- Why: Latent Space is the working AI engineer's newsletter/podcast. Lilian Weng (OpenAI) writes the most technically rigorous LLM explainers on agents, hallucination, and prompt patterns.
- Where: latent.space, lilianweng.github.io.

---

## 8. UI Engineer — Frontend & Interface Developer

Productionizes design prototypes. Needs strong React/Next.js for the website, HTMX/Jinja/Pico for SIA, plus accessibility and performance.

**Dan Abramov**
- Why: Foundational React thinking; recent *Overreacted* essays and *React for Two Computers* reshape how to reason about client/server components.
- Signature work: overreacted.io, *React for Two Computers*.
- Where: overreacted.io, bsky.app.

**Kent C. Dodds**
- Why: Testing Library, Remix, and the most practical writing on modern React patterns, testing, and frontend architecture.
- Signature work: Epic React, Epic Web, kentcdodds.com blog, Testing Library.
- Where: kentcdodds.com, epicreact.dev.

**Vercel team (Lee Robinson, Delba de Oliveira, Guillermo Rauch)**
- Why: Next.js is the framework for richezamor.com. Official team writing on App Router, RSC, caching, and edge patterns is primary reference.
- Signature work: Next.js docs, leerob.io, Vercel blog.
- Where: nextjs.org/docs, leerob.io, vercel.com/blog.

**Carson Gross**
- Why: Creator of HTMX — SIA's frontend approach. His book *Hypermedia Systems* is the intellectual foundation for the HTMX/Jinja stack SIA uses.
- Signature work: *Hypermedia Systems* (free online), htmx.org essays.
- Where: htmx.org, hypermedia.systems.

**Josh Comeau**
- Why: See Designer section — also primary reference for UI engineers on CSS implementation and interaction polish.
- Where: joshwcomeau.com.

**Addy Osmani**
- Why: Chrome team; authoritative on web performance, Core Web Vitals, rendering patterns, image optimization.
- Signature work: *Learning Patterns*, web.dev articles, addyosmani.com.
- Where: addyosmani.com, web.dev.

**web.dev + MDN + Smashing Magazine**
- Why: Three authoritative references for everything platform-level: APIs, accessibility, performance, browser compat.
- Where: web.dev, developer.mozilla.org, smashingmagazine.com.

---

## 9. QA Engineer — Testing & Validation

Needs coverage on modern testing philosophy, E2E tools, and specifically LLM-system testing since this team ships AI features.

**Kent Beck**
- Why: Invented TDD; *Test-Driven Development: By Example* and his recent writing on "tidy first" are foundational.
- Signature work: *TDD: By Example*, *Tidy First?*, tidyfirst.substack.com.
- Where: tidyfirst.substack.com.

**Kent C. Dodds**
- Why: Testing Library and the "Testing Trophy" reshaped frontend testing philosophy — test behavior, not implementation.
- Signature work: Testing Library, "Write tests. Not too many. Mostly integration."
- Where: kentcdodds.com, testing-library.com.

**Microsoft Playwright team**
- Why: Playwright is the dominant modern E2E framework for JS/TS apps. Their docs + team blog are primary reference.
- Signature work: Playwright docs, Playwright YouTube channel.
- Where: playwright.dev, youtube.com/@Playwrightdev.

**pytest core team (Bruno Oliveira, Raphael Pierzina, Florian Bruhin)**
- Why: pytest is SIA's test framework. Official docs and books by the core team are authoritative.
- Signature work: *pytest Quick Start Guide* (Oliveira), pytest docs.
- Where: docs.pytest.org.

**Hamel Husain + Shreya Shankar**
- Why: Modern authority on LLM evals specifically — the uniquely hard QA problem this team faces. LLM-as-judge, golden sets, error analysis.
- Signature work: Parlance Labs course, "Your AI product needs evals" (Hamel), Shreya's academic eval papers.
- Where: hamel.dev, parlance-labs.com, sh-reya.com.

**Ministry of Testing**
- Why: Largest global testing community — practical content, conferences (TestBash), and the classic "Testing Manifesto."
- Where: ministryoftesting.com.

**Google Testing Blog + Google Engineering Practices**
- Why: Long-running source on testing philosophy, test pyramids, hermetic testing, and code review for testability.
- Where: testing.googleblog.com, google.github.io/eng-practices.

---

## 10. DevOps Engineer — Infrastructure & Deployment

Docker Compose on a single VPS, Vercel for web apps, Postgres, Nginx, Langfuse, Ollama — pragmatic SRE rather than cloud-native specialist.

**Kelsey Hightower**
- Why: Most respected voice on infrastructure pragmatism — "not everything needs Kubernetes" energy directly aligns with the single-VPS architecture.
- Signature work: Kubernetes the Hard Way, talks on simplicity vs. complexity.
- Where: Twitter/X @kelseyhightower, GitHub, conference talks.

**Google SRE Book team (Beyer, Jones, Petoff, Murphy)**
- Why: Canonical reference for reliability practices — SLOs, error budgets, incident response — scaled appropriately even for a small setup.
- Signature work: *Site Reliability Engineering*, *The Site Reliability Workbook* (free online).
- Where: sre.google/books.

**Julia Evans**
- Why: Best explainer of Linux/networking/debugging fundamentals working today; zines and blog posts map directly to VPS operations.
- Signature work: *How DNS Works*, *Bite Size Networking*, many zines; jvns.ca blog.
- Where: jvns.ca, wizardzines.com.

**Bret Fisher**
- Why: Most widely followed Docker/Compose educator; courses and YouTube content directly applicable to Docker Compose-on-VPS setups.
- Signature work: Docker Mastery course, bretfisher.com, YouTube channel.
- Where: bretfisher.com, youtube.com/@BretFisher.

**DigitalOcean + Hetzner + Linode community tutorials**
- Why: VPS-provider tutorial libraries are some of the best practical content on Nginx config, SSL/Let's Encrypt, backups, firewall setup, and hardening. Directly applicable to the Hostinger VPS.
- Where: digitalocean.com/community/tutorials, community.hetzner.com, linode.com/docs.

**Vercel docs + Anthony Fu (Vue/Nuxt) + Lee Robinson**
- Why: Primary reference for Vercel-hosted apps (website, Recipe Remix) — deployment, edge functions, Postgres integration.
- Where: vercel.com/docs, vercel.com/blog.

**r/selfhosted + Awesome-Selfhosted**
- Why: Closest community to the actual setup — single VPS, Docker Compose, self-hosted tools (Langfuse, Ollama, Paperclip). Real-world config patterns and troubleshooting.
- Where: reddit.com/r/selfhosted, github.com/awesome-selfhosted/awesome-selfhosted.

---

## 11. Technical Writer — Documentation & Specification Maintenance

Needs docs-as-code fluency, API documentation standards, and modern information-architecture practice.

**Write the Docs community**
- Why: The community for technical writing. Conference talks, Slack, and articles are the primary reference for modern docs practice.
- Signature work: writethedocs.org guide, annual conferences (Portland, Prague, Australia).
- Where: writethedocs.org.

**Daniele Procida**
- Why: Author of the Diátaxis framework — the dominant modern approach to structuring technical documentation (tutorials, how-tos, reference, explanation). Directly applicable to how Notion specs and READMEs should be organized.
- Signature work: diataxis.fr, PyCon talks.
- Where: diataxis.fr.

**Google Developer Documentation Style Guide**
- Why: Most widely referenced public style guide for technical writing — voice, terminology, structure. Free.
- Where: developers.google.com/style.

**Microsoft Writing Style Guide**
- Why: Second most referenced; strong on inclusive language, UI terminology, and API documentation patterns.
- Where: learn.microsoft.com/en-us/style-guide/welcome.

**Stripe + Twilio docs teams**
- Why: Stripe and Twilio set the bar for API documentation — code samples, interactive examples, narrative walkthroughs. Reference standard for every "great docs" list.
- Where: stripe.com/docs, twilio.com/docs.

**Tom Johnson (I'd Rather Be Writing)**
- Why: Longest-running and most substantive technical-writing blog; deep on docs-as-code, API docs, and the evolving role of the technical writer in AI-assisted workflows.
- Signature work: *API Documentation* course, idratherbewriting.com.
- Where: idratherbewriting.com.

**The Good Docs Project + GitLab Handbook**
- Why: The Good Docs Project offers open-source docs templates directly usable by this agent. GitLab's public handbook is the largest living example of documentation-as-source-of-truth done well.
- Where: thegooddocsproject.dev, about.gitlab.com/handbook.

---

## 12. Technical Architect (rz-architect) — Strategic routine

Claude Code Routine that produces ADRs, integration designs, architecture reviews, and tech-stack evaluations across the app portfolio. Stateless between runs; writes durable artifacts to the ADR Log Notion hub. Needs deep grounding in architecture decision practice, integration patterns, evolutionary architecture, and distributed-systems tradeoffs.

**Martin Fowler / ThoughtWorks**
- Why: Author of the canonical architecture-decision vocabulary (ADRs as a practice, evolutionary architecture, strangler fig). ThoughtWorks Radar is the paired signal for what to adopt/hold.
- Signature work: *Patterns of Enterprise Application Architecture*, *Refactoring*, "Who Needs an Architect?" essay, ThoughtWorks Technology Radar.
- Where: martinfowler.com, thoughtworks.com/radar.

**Gregor Hohpe**
- Why: *Enterprise Integration Patterns* is the vocabulary every integration design uses; *The Software Architect Elevator* defines the strategic architect's job of riding between exec floors and the engine room — the exact role this routine plays.
- Signature work: *Enterprise Integration Patterns*, *The Software Architect Elevator*, *Cloud Strategy*, *Platform Strategy*.
- Where: architectelevator.com, enterpriseintegrationpatterns.com.

**Michael Nygard**
- Why: Wrote *Release It!* (the production-architecture bible for timeouts, circuit breakers, bulkheads) and in 2011 introduced "Documenting Architecture Decisions" — the ADR format now used across the industry and by this routine.
- Signature work: *Release It!*, "Documenting Architecture Decisions" (2011 blog post), *Wide Awake Developers* blog.
- Where: michaelnygard.com, cognitect.com blog archive.

**Neal Ford + Mark Richards**
- Why: *Fundamentals of Software Architecture* + *Software Architecture: The Hard Parts* + *Building Evolutionary Architectures* together form the modern architect's vocabulary on architecture characteristics, fitness functions, and how to decompose the hard parts (data, transactions, workflow).
- Signature work: *Fundamentals of Software Architecture* (Ford + Richards, 2020), *Software Architecture: The Hard Parts* (2021), *Building Evolutionary Architectures* (Ford + Parsons + Kua, 2017).
- Where: O'Reilly catalog, nealford.com.

**Eric Evans + Vaughn Vernon**
- Why: Domain-Driven Design. Bounded contexts, context maps, ubiquitous language — the strategic design tools the Architect routine uses to scope integrations and argue against premature coupling.
- Signature work: *Domain-Driven Design* (Evans, 2003), *Implementing Domain-Driven Design* (Vernon, 2013).
- Where: domainlanguage.com, vaughnvernon.com.

**Sam Newman**
- Why: *Building Microservices* (2nd ed, 2021) + *Monolith to Microservices* are the pragmatic references for service decomposition and migration strategy — when to split, when to leave monoliths alone.
- Signature work: *Building Microservices*, *Monolith to Microservices*, samnewman.io blog and talks.
- Where: samnewman.io.

**Werner Vogels + AWS Well-Architected**
- Why: Vogels's "Eventually Consistent" essay and the AWS Well-Architected Framework (6 pillars: operational excellence, security, reliability, performance, cost, sustainability) are the cloud-scale architecture references every architect cites.
- Signature work: "Eventually Consistent" (2008), "10 Lessons from 10 Years of AWS" (re:Invent 2016), AWS Well-Architected Framework documentation.
- Where: allthingsdistributed.com, aws.amazon.com/architecture/well-architected.

---

## 13. Analyst (rz-analyst) — Strategic routine

Claude Code Routine that produces competitive matrices, market analysis briefs, pricing studies, and sized opportunity briefs. Needs rigor on sourcing, competitive strategy frameworks, jobs-to-be-done, and tech-industry-specific analysis.

**Michael Porter**
- Why: Five Forces, generic strategies (cost leadership / differentiation / focus), Value Chain, and "What is Strategy?" remain the most-taught frameworks in competitive strategy. Every matrix and positioning analysis traces back to Porter's vocabulary.
- Signature work: *Competitive Strategy* (1980), *Competitive Advantage* (1985), "What is Strategy?" (HBR, 1996), "The Five Competitive Forces That Shape Strategy" (HBR, 2008).
- Where: isc.hbs.edu (Institute for Strategy and Competitiveness), Harvard Business Review archive.

**Clay Christensen**
- Why: Disruptive innovation theory + jobs-to-be-done. Frame for how incumbents get disrupted from below and how to analyze buyer motivation beyond demographics. Essential mental model for startup-vs-incumbent competitive analysis.
- Signature work: *The Innovator's Dilemma* (1997), *Competing Against Luck* (2016, JTBD), "The Prime Movers of JTBD" essays.
- Where: claytonchristensen.com, Christensen Institute.

**Rita McGrath**
- Why: *The End of Competitive Advantage* — competitive advantages are transient, so you need continuous reconfiguration rather than defending a moat. Strategic inflection points (jointly with Andy Grove's original).
- Signature work: *The End of Competitive Advantage* (2013), *Seeing Around Corners* (2019), Thought Sparks blog.
- Where: ritamcgrath.com, Columbia Business School faculty page.

**Ben Thompson (Stratechery)**
- Why: The most widely-read tech-industry strategy writer. Aggregation theory, the tech-specific value chain, and weekly deep dives on competitive dynamics in platforms, AI, and SaaS. Directly relevant to Riché's tech portfolio analysis.
- Signature work: Stratechery daily updates, *Aggregation Theory* (concept), Stratechery Plus podcast, *Dithering*.
- Where: stratechery.com.

**a16z (Andreessen Horowitz) + Sequoia**
- Why: Tech-market-specific analyst content. a16z's "state of" reports (AI, consumer, fintech) and Sequoia's memos define the venture-side vocabulary for sizing, defensibility, and market structure in tech.
- Signature work: a16z.com content library, Sequoia's Data-Informed, state-of-AI-enterprise reports.
- Where: a16z.com, sequoiacap.com/perspectives.

**Gartner + Forrester**
- Why: The two incumbent analyst firms. Magic Quadrant and Wave reports set the vocabulary Riché's buyers use to evaluate tools. Essential reference for Fortune-500-focused opportunity briefs.
- Signature work: Gartner Magic Quadrants, Hype Cycles; Forrester Wave reports, Total Economic Impact studies.
- Where: gartner.com, forrester.com.

**Harvard Business Review + MIT Sloan Management Review**
- Why: The two long-running publications of strategy research. HBR for practitioner-grade case studies, MIT SMR for academic-rigor-but-accessible treatments. Primary citation source for methodology on sizing, pricing, and strategic framework selection.
- Where: hbr.org, sloanreview.mit.edu.

---

## 14. User Researcher (rz-ux-researcher) — Strategic routine

Claude Code Routine that produces interview synthesis, personas, journey maps, and usability audits. Inherits some seeds from the retired generic Researcher corpus (section 3) and adds three UX-specific voices on interview craft, persona design, and listening methodology.

**Teresa Torres** *(shared with researcher)*
- Why: Continuous discovery and opportunity-solution trees — the bridge between interview synthesis (this routine's output) and product decisions (Riché's call).
- Signature work: *Continuous Discovery Habits* (2021), Product Talk blog.
- Where: producttalk.org.

**Erika Hall** *(shared with researcher)*
- Why: *Just Enough Research* — most practical UX research methods book for small teams. Sharp on interview design and bias.
- Signature work: *Just Enough Research*, *Conversational Design*.
- Where: mulecollective.com.

**Christian Rohrer / NN/g** *(shared with researcher)*
- Why: NN/g's method-selection framework and the 10 usability heuristics — the citable foundation for usability audits.
- Signature work: "When to Use Which User-Experience Research Methods" (Rohrer), Nielsen's 10 Usability Heuristics.
- Where: nngroup.com.

**Steve Portigal**
- Why: *Interviewing Users* is the canonical reference on interview craft — how to elicit stories, handle silence, escape your own biases. The rigor for the synthesis this routine produces.
- Signature work: *Interviewing Users* (2nd ed, 2023), *Doorbells, Danger, and Dead Batteries* (user research war stories).
- Where: portigal.com.

**Kim Goodwin**
- Why: *Designing for the Digital Age* — the modern reference on goal-directed design and persona construction (from Cooper's lineage, but more rigorous than the cartoonish personas most teams ship). The method the routine uses for its persona skill.
- Signature work: *Designing for the Digital Age* (2009), Rosenfeld Media workshops.
- Where: kimgoodwin.com.

**Indi Young**
- Why: Pioneer of mental models and "listening deeply" research — surfacing the thinking styles behind user behavior rather than surveying stated preferences. Complements Torres on the synthesis side.
- Signature work: *Mental Models* (2008), *Practical Empathy* (2015), *Time to Listen* (2022).
- Where: indiyoung.com.

**Research Ops Community** *(shared with researcher)*
- Why: The Eight Pillars of ReOps + repository patterns for how this routine's artifacts are stored and retrieved by downstream agents.
- Where: researchops.community.

---

## 15. AI Researcher (rz-ai-researcher) — Strategic routine

Claude Code Routine that produces method evaluations, eval specs, ablation study designs, and literature reviews — primarily for SIA but applicable to any app using AI. Feeds recommendations to the AI Engineer execution agent. Inherits several seeds from the AI Engineer corpus (section 7) and adds academic-research-grade voices.

**Anthropic (Applied AI + research)** *(shared with ai-eng)*
- Why: Direct source for Claude capabilities, tool use, MCP, and agent patterns. Primary reference since the routines run on Claude.
- Signature work: Anthropic research papers (Sleeper Agents, Constitutional AI, sparse autoencoders), Applied AI blog, MCP spec.
- Where: anthropic.com/research, docs.anthropic.com, anthropic.com/engineering.

**Hamel Husain + Shreya Shankar** *(shared with ai-eng and qa-eng)*
- Why: The modern authority on LLM evals — rubric design, LLM-as-judge calibration, error analysis. The bottleneck discipline for any AI product.
- Signature work: "Your AI product needs evals" (Hamel), Parlance Labs course, Shankar's academic eval papers (operationalizing ML).
- Where: hamel.dev, parlance-labs.com, sh-reya.com.

**Chip Huyen** *(shared with ai-eng)*
- Why: *AI Engineering* (2024) is the most comprehensive practitioner treatment of retrieval, evals, fine-tuning, and agents. Methodology-heavy, which is what this routine produces.
- Signature work: *AI Engineering* (O'Reilly, 2024), *Designing Machine Learning Systems*.
- Where: huyenchip.com.

**Lilian Weng** *(shared with ai-eng)*
- Why: The most technically rigorous LLM-method explainers online — agent loops, hallucination taxonomies, prompt patterns, RLHF mechanics. Essential reference for literature reviews.
- Signature work: lilianweng.github.io essays ("LLM-Powered Autonomous Agents," "Hallucination in LLMs," "Prompt Engineering").
- Where: lilianweng.github.io.

**Percy Liang + Stanford CRFM**
- Why: CRFM (Center for Research on Foundation Models) produces HELM (Holistic Evaluation of Language Models) — the academic reference for rigorous LLM benchmarks. Methodology for when the routine needs to design novel evals.
- Signature work: HELM benchmark suite, "On the Opportunities and Risks of Foundation Models" (2021), DSP → DSPy lineage.
- Where: crfm.stanford.edu, helm.ai, percy liang's Stanford page.

**Sebastian Raschka**
- Why: *Build a Large Language Model (From Scratch)* (2024) — the deepest practitioner reference for understanding LLM internals, which the routine needs when evaluating proposed architectural changes or fine-tuning strategies.
- Signature work: *Build a Large Language Model (From Scratch)*, *Machine Learning Q and AI*, Ahead of AI newsletter.
- Where: sebastianraschka.com, magazine.sebastianraschka.com.

**Omar Khattab + DSPy team**
- Why: DSPy (Declarative Self-improving Python) + ColBERT retrieval research — the modern framework for programmatic prompt optimization and the research-grade vocabulary for retrieval systems. Directly applicable to SIA's consolidation and retrieval pipelines.
- Signature work: DSPy framework (Stanford), ColBERT papers, "Compound AI Systems" essays.
- Where: dspy.ai, omarkhattab.com, bair.berkeley.edu/blog/2024/02/18/compound-ai-systems.

---

## Cross-Cutting Sources (Useful for Multiple Roles)

A small set of references that multiple agents should pull from:

- **The Pragmatic Engineer** (Gergely Orosz) — engineering practice across all roles.
- **ThoughtWorks Technology Radar** — Researcher, Conductor, AI Eng, Backend, Frontend.
- **Anthropic engineering blog + docs** — every agent runs on Claude; primary reference.
- **OpenAI Cookbook + Anthropic Cookbook** — AI Eng primarily; patterns useful to Backend when integrating.
- **HackerNews + Lobsters** — daily signal for new tools, patterns, and war stories across every role.
- **A16z, Sequoia, Menlo "State of AI/Dev" reports** — trend and market context for Researcher and PM-lite.

---

## How to Use This File

1. Hand this file to Claude Cowork as the research seed list.
2. For each role, instruct Cowork to: (a) read the signature works, (b) extract recurring principles and patterns, (c) capture concrete examples/templates the agent can reuse, (d) note where authorities disagree — those are the judgment calls the agent will face.
3. Output a per-role knowledge document (one per agent) that becomes the corpus loaded into each OpenClaw agent's context on session start.
4. Revisit seeds every 6 months — this field moves quickly, especially AI Engineer and DevOps.
