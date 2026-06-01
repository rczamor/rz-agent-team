#!/usr/bin/env bash
# tests/run.sh — run the agent-team test suite.
#
# Usage:
#   bash tests/run.sh               # run everything available
#   bash tests/run.sh bats          # only bats tests
#   bash tests/run.sh python        # only python tests
#
# Falls back gracefully when `bats` or `pytest` aren't installed. The .bats
# files are written to be runnable either way: with bats-core installed they
# run via bats; without, a tiny in-script shim sources each file and calls
# every `@test "..." { ... }` block as a function.
#
# Exits non-zero if any test fails.

set -u
set -o pipefail

# Honor the caller's PWD if it's already the inner repo; otherwise cd to the
# directory containing this script's parent (i.e. the repo root).
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

MODE="${1:-all}"
BATS_BIN="$(command -v bats || true)"
PYTEST_BIN="$(command -v pytest || true)"
PY_BIN="$(command -v python3 || command -v python || true)"

echo "== agent-team test runner =="
echo "   repo:   $REPO_ROOT"
echo "   mode:   $MODE"
echo "   bats:   ${BATS_BIN:-<not installed — using shim>}"
echo "   pytest: ${PYTEST_BIN:-<not installed — using plain python>}"
echo

BATS_FAIL=0
PY_FAIL=0

run_bats () {
  echo "-- BATS tests --"
  local files=(tests/bats/test_corpus_structure.bats \
               tests/bats/test_identities.bats \
               tests/bats/test_skills.bats \
               tests/bats/test_compose.bats \
               tests/bats/test_env_example.bats \
               tests/deploy/test_deploy_scripts.bats)

  if [ -n "$BATS_BIN" ]; then
    "$BATS_BIN" "${files[@]}" || BATS_FAIL=$?
  else
    # Shim: rewrite each .bats file into a runnable bash script.
    # Preserves `@test "name" { ... }` stanzas by turning them into
    # numbered functions we then invoke with pass/fail accounting.
    #
    #   - `load 'x.bash'` → `source "$BATS_TEST_DIRNAME/x.bash"` so helper files
    #     still resolve relative to the test file's directory.
    #   - `skip "reason"` → early `return 0` so skipped tests are counted as ok.
    local fail=0
    for f in "${files[@]}"; do
      echo "  :: $f"
      local tmp
      tmp="$(mktemp)"
      local fdir
      fdir="$(cd "$(dirname "$f")" && pwd)"
      {
        echo "#!/usr/bin/env bash"
        echo "set -u"
        echo "export BATS_TEST_DIRNAME='$fdir'"
        echo "export BATS_TEST_FILENAME='$fdir/$(basename "$f")'"
        echo "load () { local p=\"\$1\"; case \"\$p\" in /*) source \"\$p\";; *) source \"\$BATS_TEST_DIRNAME/\$p\";; esac; }"
        # In the shim every test runs in a subshell; `skip` exits the subshell
        # with success so the remainder of the body is not executed — matching
        # bats-core semantics.
        echo "skip () { exit 0; }"
        awk '
          BEGIN { n = 0; in_test = 0 }
          /^[[:space:]]*@test[[:space:]]+/ {
            line = $0
            # strip leading `@test "`
            sub(/^[[:space:]]*@test[[:space:]]+"/, "", line)
            # strip trailing `" {`
            sub(/"[[:space:]]*\{[[:space:]]*$/, "", line)
            n++
            names[n] = line
            print "__run_" n " () {"
            in_test = 1
            next
          }
          in_test && /^\}[[:space:]]*$/ {
            print "}"
            in_test = 0
            next
          }
          { print }
          END {
            print ""
            print "__FAIL=0"
            for (i = 1; i <= n; i++) {
              # Escape any double-quotes in the name for the echo line.
              gsub(/"/, "\\\"", names[i])
              print "echo \"    [" i "/" n "] " names[i] "\""
              print "if ( __run_" i " ) >/tmp/bats_shim.$$ 2>&1; then"
              print "  echo \"      ok\""
              print "else"
              print "  echo \"      FAIL\""
              print "  sed -e \"s/^/        /\" /tmp/bats_shim.$$"
              print "  __FAIL=$((__FAIL + 1))"
              print "fi"
              print "rm -f /tmp/bats_shim.$$"
            }
            print "exit $__FAIL"
          }
        ' "$f"
      } > "$tmp"
      local sub_rc=0
      bash "$tmp" || sub_rc=$?
      fail=$((fail + sub_rc))
      rm -f "$tmp"
    done
    echo "  (shim summary: $fail test failures across files)"
    BATS_FAIL=$fail
  fi
  echo
}

run_python () {
  echo "-- Python tests --"
  if [ -n "$PYTEST_BIN" ]; then
    "$PYTEST_BIN" -q tests/python || PY_FAIL=$?
  elif [ -n "$PY_BIN" ]; then
    # Fallback: run each test_*.py directly — the tests are written to have
    # a `if __name__ == "__main__": run_all()` entry point for this case.
    local fail=0
    for f in tests/python/test_*.py; do
      echo "  :: $f"
      if ! "$PY_BIN" "$f"; then fail=$((fail + 1)); fi
    done
    PY_FAIL=$fail
  else
    echo "  (no python available; skipping)"
  fi
  echo
}

case "$MODE" in
  all)    run_bats; run_python ;;
  bats)   run_bats ;;
  python) run_python ;;
  *) echo "unknown mode: $MODE"; exit 2 ;;
esac

echo "== summary =="
echo "   bats failures:   $BATS_FAIL"
echo "   python failures: $PY_FAIL"

if [ "$BATS_FAIL" -ne 0 ] || [ "$PY_FAIL" -ne 0 ]; then
  exit 1
fi
exit 0
