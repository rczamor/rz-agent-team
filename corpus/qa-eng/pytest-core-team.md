---
name: pytest Core Team (Bruno Oliveira, Raphael Pierzina, Florian Bruhin, et al.)
role: qa-eng
type: organization
researched: 2026-04-16
---

# pytest Core Team

## Why they matter to the QA Eng
pytest is SIA's test framework. The pytest core team — Bruno Oliveira (author of *pytest Quick Start Guide*), Raphael Pierzina (co-author of *Python Testing with pytest*'s modern material and many plugins), Florian Bruhin (long-time maintainer and conference regular), along with Ronny Pfannschmidt and others — has shaped not just a library but a style of Python testing: fixture-based setup over class-based setup, parametrize over loops, plain `assert` over `self.assertEqual`, and plugins over framework sprawl. For this QA Eng, their docs and books are the authoritative source for how SIA's test suite should be organized, how fixtures compose, and how to keep the suite fast.

## Signature works & primary sources
- docs.pytest.org — the official docs; the "How-to" and "Reference" sections are primary.
- *pytest Quick Start Guide* — Bruno Oliveira (Packt, 2018) — canonical intro for migrating from unittest.
- *Python Testing with pytest* — Brian Okken (Pragmatic, 2nd ed. 2022) — adjacent but universally cited.
- Florian Bruhin's EuroPython / PyCon talks on pytest internals and plugin architecture.
- Raphael Pierzina's blog (raphael.codes) — patterns for fixtures, factories, and plugin authoring.

## Core principles (recurring patterns)
- **Plain `assert` with rich introspection.** pytest rewrites assertions to show values on failure — no need for `assertEqual` family.
- **Fixtures over setUp/tearDown.** Fixtures are composable, scoped (`function`/`class`/`module`/`session`), and requested by name in test signatures. Use `yield` for teardown.
- **Parametrize exhaustively.** `@pytest.mark.parametrize("input,expected", [...])` turns N similar tests into one. Prefer parametrize to loops-inside-tests.
- **conftest.py for shared fixtures.** No imports needed; pytest discovers conftest.py walking up the tree. Keep fixtures close to the tests that use them.
- **Markers for taxonomy.** `@pytest.mark.slow`, `@pytest.mark.integration`, `@pytest.mark.llm_eval` — then select with `-m`.
- **Small, focused, fast.** The default mode is many tiny tests. Anything slow gets a marker and a separate CI job.

## Concrete templates, checklists, or artifacts the agent can reuse
- **Fixture pattern with teardown:**
  ```python
  @pytest.fixture
  def db_session(tmp_path):
      engine = create_engine(f"sqlite:///{tmp_path}/test.db")
      session = Session(engine)
      yield session
      session.close()
  ```
- **Parametrize template for AC-to-test mapping:**
  ```python
  @pytest.mark.parametrize("input,expected,ac_ref", [
      ("valid", 200, "AC-1"),
      ("missing", 400, "AC-2"),
      ("malformed", 422, "AC-3"),
  ], ids=["valid", "missing", "malformed"])
  def test_endpoint(client, input, expected, ac_ref):
      ...
  ```
- **conftest.py layout for SIA:** root `conftest.py` with DB/session/client fixtures; per-module `conftest.py` for domain-specific factories. Never import fixtures across files — let conftest do it.
- **Marker taxonomy checklist (pyproject.toml):** `unit` (default, fast), `integration` (DB/HTTP, seconds), `llm_eval` (calls a model, minutes, skipped by default), `slow` (>1s).
- **Factory fixture pattern:** fixture returns a callable so tests can parameterize the built object (`def make_user(**overrides): ...`). Cleaner than N fixtures for N variations.

## Where they disagree with others
- **pytest (fixtures) vs. unittest (xUnit):** pytest core team considers `setUp`/`tearDown` an anti-pattern for non-trivial suites — fixtures compose, `setUp` doesn't.
- **pytest (plain assert) vs. hamcrest/expect-style:** pytest leans on assert rewriting and doesn't ship a matcher library. Some teams still reach for hamcrest or assertpy — the pytest core team considers this unnecessary.
- **pytest (function-style) vs. class-based tests:** both work, but fixtures + plain functions is the idiomatic path; classes are only for logical grouping (and `cls` fixture scope).

## Pointers to source material
- Docs: https://docs.pytest.org
- Fixtures how-to: https://docs.pytest.org/en/stable/how-to/fixtures.html
- Parametrize how-to: https://docs.pytest.org/en/stable/how-to/parametrize.html
- Good practices: https://docs.pytest.org/en/stable/explanation/goodpractices.html
- Book: Bruno Oliveira, *pytest Quick Start Guide* (Packt).
- Book: Brian Okken, *Python Testing with pytest* (Pragmatic Bookshelf).
