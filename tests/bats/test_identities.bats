#!/usr/bin/env bats
# Identities: all 11 files exist, each has a `## Knowledge corpus` H2, a
# weekly-study instruction, a reference to the matching `corpus/<role>/` path,
# and the documented cross-role seed names where expected.

load '_helpers.bash'

EXPECTED_ROLES=(ai-eng backend-eng conductor data-eng designer devops-eng pm-lite qa-eng researcher tech-writer ui-eng)

@test "11 identity files exist" {
  local count
  count="$(ls "$REPO_ROOT/identities"/*.md 2>/dev/null | wc -l | tr -d ' ')"
  [ "$count" = "11" ]
}

@test "every expected role has an identity file" {
  for role in "${EXPECTED_ROLES[@]}"; do
    [ -f "$REPO_ROOT/identities/$role.md" ] || { echo "missing identities/$role.md"; return 1; }
  done
}

@test "every identity file has a '## Knowledge corpus' H2 section" {
  local missing=0
  for role in "${EXPECTED_ROLES[@]}"; do
    local f="$REPO_ROOT/identities/$role.md"
    if ! grep -qE '^## Knowledge corpus' "$f"; then
      echo "no '## Knowledge corpus' in $f"
      missing=$((missing + 1))
    fi
  done
  [ "$missing" = "0" ] || return 1
}

@test "every identity file references its own corpus/<role>/ directory" {
  local missing=0
  for role in "${EXPECTED_ROLES[@]}"; do
    local f="$REPO_ROOT/identities/$role.md"
    if ! grep -q "corpus/$role/" "$f"; then
      echo "no 'corpus/$role/' reference in $f"
      missing=$((missing + 1))
    fi
  done
  [ "$missing" = "0" ] || return 1
}

@test "every identity file has a weekly-study instruction" {
  local missing=0
  for role in "${EXPECTED_ROLES[@]}"; do
    local f="$REPO_ROOT/identities/$role.md"
    # Accept either a ### Weekly corpus study heading or any 'weekly' hint.
    if ! grep -qiE 'weekly' "$f"; then
      echo "no weekly-study hint in $f"
      missing=$((missing + 1))
    fi
  done
  [ "$missing" = "0" ] || return 1
}

@test "designer and ui-eng identities both reference josh-comeau" {
  grep -qi 'josh.comeau' "$REPO_ROOT/identities/designer.md"
  grep -qi 'josh.comeau' "$REPO_ROOT/identities/ui-eng.md"
}

@test "data-eng and ai-eng identities both reference chip-huyen" {
  grep -qi 'chip.huyen' "$REPO_ROOT/identities/data-eng.md"
  grep -qi 'chip.huyen' "$REPO_ROOT/identities/ai-eng.md"
}

@test "ui-eng and qa-eng identities both reference kent-c-dodds" {
  grep -qi 'kent.c..dodds' "$REPO_ROOT/identities/ui-eng.md"
  grep -qi 'kent.c..dodds' "$REPO_ROOT/identities/qa-eng.md"
}
