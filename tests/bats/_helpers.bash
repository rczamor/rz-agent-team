#!/usr/bin/env bash
# tests/bats/_helpers.bash — shared helpers for the bats suites.
# Sourced by every test_*.bats file.

# Walk up from the bats file's directory to the repo root (contains corpus/).
__find_repo_root () {
  local d="${BATS_TEST_DIRNAME:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
  while [ "$d" != "/" ]; do
    if [ -d "$d/corpus" ] && [ -d "$d/identities" ] && [ -d "$d/skills" ]; then
      echo "$d"; return 0
    fi
    d="$(dirname "$d")"
  done
  # Fallback: the repo two dirs up from this helper file.
  (cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
}

REPO_ROOT="$(__find_repo_root)"
export REPO_ROOT

# Canonical list of 11 roles — derived from the corpus directory listing at
# test time so a future role rename is picked up automatically.
roles_list () {
  ( cd "$REPO_ROOT/corpus" && ls -1d */ 2>/dev/null | sed 's#/##' | sort )
}

# Map a role name (used in corpus/identities) → the compose service suffix.
# pm-lite → pm; everything else is identity.
role_to_service () {
  case "$1" in
    pm-lite) echo "pm" ;;
    *)       echo "$1" ;;
  esac
}

# Extract just the YAML frontmatter block from a markdown file (content between
# the first pair of `---` lines). Emits nothing for a file without frontmatter.
read_frontmatter () {
  awk 'BEGIN{n=0} /^---[[:space:]]*$/{n++; if(n==2){exit}; next} n==1{print}' "$1"
}

# Grab a single scalar value from a YAML frontmatter block on stdin:
#   read_frontmatter file.md | yaml_value role
# Returns the trimmed string after `key:`.
yaml_value () {
  local key="$1"
  awk -v k="$key" -F: '
    $1 == k {
      sub(/^[^:]+:[[:space:]]*/, "")
      gsub(/^[[:space:]]+|[[:space:]]+$/, "")
      print
      exit
    }
  '
}

# Count H2 section headers in a markdown file, ignoring lines that fall inside
# fenced code blocks (```...```). Used by corpus + skill structure tests.
count_h2_outside_code_fences () {
  awk '
    BEGIN { in_fence = 0; n = 0 }
    /^```/ { in_fence = 1 - in_fence; next }
    !in_fence && /^## / { n++ }
    END { print n }
  ' "$1"
}

# Word count of the body (everything after the frontmatter). Falls back to
# whole-file word count if there is no frontmatter.
body_word_count () {
  awk '
    BEGIN { in_fm = 0; seen = 0; w = 0 }
    NR == 1 && /^---[[:space:]]*$/ { in_fm = 1; next }
    in_fm && /^---[[:space:]]*$/   { in_fm = 0; seen = 1; next }
    in_fm                           { next }
    { w += NF }
    END { print w }
  ' "$1"
}

# Read every `${VAR_NAME}` token outside of YAML comments. We keep this
# portable — no GNU-only flags.
extract_compose_vars () {
  awk '
    {
      line = $0
      # strip comments (everything after first "#" that is not inside quotes
      # — for this repo the simple form is sufficient).
      sub(/#.*$/, "", line)
      while (match(line, /\$\{[A-Z_][A-Z0-9_]*\}/)) {
        tok = substr(line, RSTART, RLENGTH)
        gsub(/[\$\{\}]/, "", tok)
        print tok
        line = substr(line, RSTART + RLENGTH)
      }
    }
  ' "$1" | sort -u
}
