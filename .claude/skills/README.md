# `.claude/skills/` — mirror for Claude Code Routines

This directory contains **symlinks** that mirror each plugin's skills to the repo-root `.claude/skills/` path where Claude Code auto-discovers them.

## Why the mirror

- The 4 strategic plugins at `plugins/rz-*` are consumed two ways:
  1. Via `claude plugin install rz-{role}@rz-agent-team` on Claude Code CLI — skills are discovered at `<plugin>/skills/<skill>/SKILL.md` within the installed plugin (per [docs](https://code.claude.com/docs/en/skills#where-skills-live))
  2. Via **Claude Code Routines** which clone this repo at session start — routines discover skills at `.claude/skills/<skill>/SKILL.md` within the cloned repo (per [routines docs](https://code.claude.com/docs/en/routines#create-a-routine): *"use skills committed to the cloned repository"*)

Plugins installed via `claude plugin install` aren't available inside a routine's cloud session — the session only has what the cloned repo provides. So we mirror.

## Naming convention

Symlinks are namespaced `<plugin-name>-<skill-name>` to avoid collisions when multiple plugins get mirrored:

```
.claude/skills/rz-architect-session       → ../../plugins/rz-architect/skills/session
.claude/skills/rz-architect-adr-author    → ../../plugins/rz-architect/skills/adr-author
.claude/skills/rz-analyst-session         → ../../plugins/rz-analyst/skills/session
...
```

This matches how plugin-installed skills are namespaced in Claude Code (`plugin-name:skill-name`), minus the colon.

## Source of truth

The actual skill content lives in `plugins/<plugin>/skills/<skill>/SKILL.md`. This directory only holds symlinks — editing here is redundant; editing the source updates both paths.

## Regenerating

If a new plugin or skill is added:

```bash
cd repo
mkdir -p .claude/skills
for plugin in rz-architect rz-analyst rz-ux-researcher rz-ai-researcher; do
  for skill_dir in plugins/$plugin/skills/*/; do
    skill=$(basename "$skill_dir")
    ln -sf "../../plugins/${plugin}/skills/${skill}" ".claude/skills/${plugin}-${skill}"
  done
done
```

## Git behavior

Symlinks are committed as filemode 120000 blobs and preserved on `git clone`. GitHub and GitLab both render them as symlinks. Windows developers may see broken links but the routine sessions run on Linux (Anthropic cloud), so it doesn't affect production discovery.
