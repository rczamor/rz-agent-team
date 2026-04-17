#!/usr/bin/env bats
# Corpus structure: 11 roles, each with 7 seed files + README, every seed file
# has valid YAML frontmatter and exactly 6 H2 sections within the documented
# word-count bounds. No TODO/FIXME markers in corpus content.

load '_helpers.bash'

EXPECTED_ROLES=(ai-eng backend-eng conductor data-eng designer devops-eng pm-lite qa-eng researcher tech-writer ui-eng)

@test "corpus/ has exactly the 11 expected role directories" {
  local got
  got="$(roles_list | tr '\n' ' ')"
  local want="ai-eng backend-eng conductor data-eng designer devops-eng pm-lite qa-eng researcher tech-writer ui-eng "
  [ "$got" = "$want" ]
}

@test "each role dir has exactly 8 .md files (7 seeds + 1 README)" {
  for role in "${EXPECTED_ROLES[@]}"; do
    local count
    count="$(ls "$REPO_ROOT/corpus/$role"/*.md 2>/dev/null | wc -l | tr -d ' ')"
    [ "$count" = "8" ] || { echo "role=$role count=$count"; return 1; }
  done
}

@test "each role dir has a README.md" {
  for role in "${EXPECTED_ROLES[@]}"; do
    [ -f "$REPO_ROOT/corpus/$role/README.md" ] || { echo "missing README for $role"; return 1; }
  done
}

# Helper: emit the path to every seed file (non-README .md inside a role dir).
# Using `corpus/*/` avoids the top-level `corpus/corpus-directory.md` meta doc.
_iter_seeds () {
  find "$REPO_ROOT/corpus"/*/ -type f -name '*.md' ! -name README.md -print0
}

@test "every non-README corpus file has YAML frontmatter with name/role/type/researched" {
  local missing=0
  while IFS= read -r -d '' f; do
    local fm name role type researched
    fm="$(read_frontmatter "$f")"
    [ -z "$fm" ] && { echo "no frontmatter: $f"; missing=$((missing + 1)); continue; }
    name="$(echo "$fm" | yaml_value name)"
    role="$(echo "$fm" | yaml_value role)"
    type="$(echo "$fm" | yaml_value type)"
    researched="$(echo "$fm" | yaml_value researched)"
    [ -n "$name" ] || { echo "missing name: $f"; missing=$((missing + 1)); }
    [ -n "$role" ] || { echo "missing role: $f"; missing=$((missing + 1)); }
    [ -n "$type" ] || { echo "missing type: $f"; missing=$((missing + 1)); }
    [ -n "$researched" ] || { echo "missing researched: $f"; missing=$((missing + 1)); }
  done < <(_iter_seeds)
  [ "$missing" = "0" ] || return 1
}

@test "frontmatter role value matches parent directory name" {
  local bad=0
  while IFS= read -r -d '' f; do
    local dir_role fm_role
    dir_role="$(basename "$(dirname "$f")")"
    fm_role="$(read_frontmatter "$f" | yaml_value role)"
    if [ "$dir_role" != "$fm_role" ]; then
      echo "role mismatch: dir=$dir_role fm=$fm_role file=$f"
      bad=$((bad + 1))
    fi
  done < <(_iter_seeds)
  [ "$bad" = "0" ] || return 1
}

@test "researched date is 2026-04-16 for every seed file" {
  local bad=0
  while IFS= read -r -d '' f; do
    local d
    d="$(read_frontmatter "$f" | yaml_value researched)"
    if [ "$d" != "2026-04-16" ]; then
      echo "researched=$d in $f"
      bad=$((bad + 1))
    fi
  done < <(_iter_seeds)
  [ "$bad" = "0" ] || return 1
}

@test "every seed file has all 6 required H2 sections" {
  local required=(
    "Why they matter"
    "Signature works"
    "Core principles"
    "Concrete templates"
    "Where they disagree"
    "Pointers to source"
  )
  local missing=0
  while IFS= read -r -d '' f; do
    for phrase in "${required[@]}"; do
      if ! grep -qE "^## .*${phrase}" "$f"; then
        echo "missing H2 '$phrase' in $f"
        missing=$((missing + 1))
      fi
    done
  done < <(_iter_seeds)
  [ "$missing" = "0" ] || return 1
}

@test "exactly 6 H2 sections per seed file (ignoring code-fenced content)" {
  local bad=0
  while IFS= read -r -d '' f; do
    local n
    n="$(count_h2_outside_code_fences "$f")"
    if [ "$n" != "6" ]; then
      echo "expected 6 H2 sections, got $n in $f"
      bad=$((bad + 1))
    fi
  done < <(_iter_seeds)
  [ "$bad" = "0" ] || return 1
}

@test "body word count is within [300, 1000] for every seed file" {
  local bad=0
  while IFS= read -r -d '' f; do
    local w
    w="$(body_word_count "$f")"
    if [ "$w" -lt 300 ] || [ "$w" -gt 1000 ]; then
      echo "words=$w out of range in $f"
      bad=$((bad + 1))
    fi
  done < <(_iter_seeds)
  [ "$bad" = "0" ] || return 1
}

@test "no TODO or FIXME markers in corpus content" {
  # Scope the scan to the role subdirectories so the top-level
  # corpus-directory.md meta-doc (which legitimately mentions these words in
  # prose about research process) is out of scope.
  local hits
  hits="$(grep -RIn -E 'TODO|FIXME' "$REPO_ROOT/corpus"/*/ || true)"
  if [ -n "$hits" ]; then
    echo "$hits"
    return 1
  fi
}
