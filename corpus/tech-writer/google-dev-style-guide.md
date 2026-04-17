---
name: Google Developer Documentation Style Guide
role: tech-writer
type: organization
researched: 2026-04-16
---

# Google Developer Documentation Style Guide

## Why they matter to the Tech Writer
The Google Developer Documentation Style Guide is the most widely referenced public style guide for developer-facing technical writing. For the Tech Writer maintaining Notion specs, READMEs, docstrings, API docs, and IDENTITY.md files, it is the default arbiter of voice, terminology, and structural conventions when no in-house style guide exists. It is free, opinionated, and short enough to read end-to-end, which makes it the right "source of truth" the agent can point to when correcting drift in team-authored docs. Its close alignment with how Google writes its own API docs (which engineers already read daily) means applying it reduces friction in review.

## Signature works & primary sources
- Google Developer Documentation Style Guide — https://developers.google.com/style — the full guide, free, updated continuously.
- Highlights page — https://developers.google.com/style/highlights — the one-page cheat sheet; the right link to put in a team's CONTRIBUTING.md.
- Word list — https://developers.google.com/style/word-list — terminology decisions (email not e-mail, sign in as verb, sign-in as noun).
- Code-in-text formatting — https://developers.google.com/style/code-in-text — rules for inline code, placeholders, and command formatting.
- API reference guide — https://developers.google.com/style/api-reference-comments — canonical patterns for method/parameter/return descriptions.

## Core principles (recurring patterns)
- **Second person, active voice, present tense.** "You can create a project" beats "A project can be created."
- **Short sentences.** Average under 25 words; break up anything longer.
- **Describe what the user does, not what the system does.** User-centered phrasing.
- **Use sentence case for headings**, not title case — lowers visual weight and reads faster.
- **Placeholder convention**: `VARIABLES_IN_UPPERCASE` with optional angle brackets, consistent across the doc.
- **Be accurate, then consistent, then concise** — in that order. Don't sacrifice accuracy for style.
- **Write for a global audience**: avoid idioms, culture-specific examples, and jokes that don't translate.
- **Inclusive language**: allowlist/denylist over whitelist/blacklist; primary/replica over master/slave; they/them as default pronoun.

## Concrete templates, checklists, or artifacts the agent can reuse
- **README voice pass** before publishing: (1) second person? (2) active voice? (3) sentence-case headings? (4) no passive "should be"/"can be" unless describing system behavior? (5) terminology matches the word list?
- **Docstring pattern** (aligned with Google Python style): one-line summary in imperative mood, blank line, longer description, `Args:` / `Returns:` / `Raises:` sections with parameter names in backticks.
- **API reference comment shape**: action verb first ("Creates a new project"), required vs. optional parameters clearly marked, return type described in terms of what the caller gets, errors listed with the condition that triggers each.
- **Placeholder audit**: scan every code block for consistent placeholder format; fix stragglers in one pass.
- **Inclusive-language scan**: grep for master/slave, whitelist/blacklist, guys, sanity check, crazy; replace per the word list.

## Where they disagree with others
- Google vs. Microsoft: Google is more neutral and engineer-direct; Microsoft is warmer, uses contractions more liberally, and leans into conversational tone ("Let's get started"). For B2B developer docs Google wins; for end-user product help Microsoft reads better.
- Google vs. Write the Docs: Google is prescriptive about word choice; WTD is prescriptive about process. They complement rather than compete.
- Google vs. Stripe: Stripe's conversational, story-driven tone softens Google's terseness. Stripe is a better model for onboarding pages; Google is a better model for reference.

## Pointers to source material
- https://developers.google.com/style — full guide
- https://developers.google.com/style/highlights — cheat sheet
- https://developers.google.com/style/word-list — terminology
- https://google.github.io/styleguide/pyguide.html — companion Python code-style guide (for docstring conventions)
- GitHub source: https://github.com/google/styleguide
