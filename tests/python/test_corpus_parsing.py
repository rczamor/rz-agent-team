"""Richer corpus validation than the bats tests can cheaply do.

Goals:
- Parse YAML frontmatter out of every corpus/*/*.md (pure stdlib — no
  python-frontmatter or PyYAML dependency).
- Assert schema shape: name / role / type / researched all present.
- Assert frontmatter role matches directory.
- Assert documented cross-role seed files exist and are not byte-for-byte
  duplicates, and that each tilt uses its own role's vocabulary.

Runs via `pytest` or directly via `python tests/python/test_corpus_parsing.py`
(a tiny __main__ block at the bottom invokes the same asserts without pytest).
"""

from __future__ import annotations

import hashlib
import re
from pathlib import Path
from typing import Dict, Iterable, List, Tuple

try:
    import pytest
except ImportError:  # allow running without pytest
    pytest = None  # type: ignore[assignment]


FRONTMATTER_RE = re.compile(r"\A---\n(.*?)\n---\n(.*)\Z", re.DOTALL)
YAML_LINE_RE = re.compile(r"^\s*([A-Za-z0-9_-]+)\s*:\s*(.*?)\s*$")

EXPECTED_ROLES = {
    "ai-eng",
    "backend-eng",
    "conductor",
    "data-eng",
    "designer",
    "devops-eng",
    "pm-lite",
    "qa-eng",
    "researcher",
    "tech-writer",
    "ui-eng",
}


def _find_repo_root(start: Path) -> Path:
    for candidate in [start, *start.parents]:
        if (
            (candidate / "corpus").is_dir()
            and (candidate / "identities").is_dir()
            and (candidate / "skills").is_dir()
        ):
            return candidate
    raise RuntimeError(f"Could not locate repo root from {start}")


def _parse_frontmatter(text: str) -> Tuple[Dict[str, str], str]:
    """Return (frontmatter_dict, body) — tolerant of a file with no FM."""
    m = FRONTMATTER_RE.match(text)
    if not m:
        return {}, text
    fm_block, body = m.group(1), m.group(2)
    fm: Dict[str, str] = {}
    for line in fm_block.splitlines():
        if not line.strip():
            continue
        lm = YAML_LINE_RE.match(line)
        if lm:
            key, value = lm.group(1), lm.group(2)
            # Strip surrounding quotes if present.
            value = value.strip().strip('"').strip("'")
            fm[key] = value
    return fm, body


def _iter_corpus_seeds(corpus_dir: Path) -> Iterable[Path]:
    """Yield only role-scoped seed files — skip README.md and skip the
    top-level corpus-directory.md meta-doc that lives next to the role dirs."""
    for role_dir in sorted(corpus_dir.iterdir()):
        if not role_dir.is_dir():
            continue
        if role_dir.name not in EXPECTED_ROLES:
            continue
        for md in sorted(role_dir.glob("*.md")):
            if md.name == "README.md":
                continue
            yield md


# Module-level repo root — works both under pytest and __main__.
_REPO_ROOT = _find_repo_root(Path(__file__).resolve())
_CORPUS_DIR = _REPO_ROOT / "corpus"


def test_all_11_role_dirs_present() -> None:
    found = {p.name for p in _CORPUS_DIR.iterdir() if p.is_dir()}
    missing = EXPECTED_ROLES - found
    extra = found - EXPECTED_ROLES
    assert not missing, f"missing role dirs: {missing}"
    assert not extra, f"unexpected role dirs: {extra}"


def test_every_seed_file_parses_cleanly() -> None:
    for md in _iter_corpus_seeds(_CORPUS_DIR):
        text = md.read_text(encoding="utf-8")
        fm, body = _parse_frontmatter(text)
        assert fm, f"no frontmatter in {md}"
        for key in ("name", "role", "type", "researched"):
            assert key in fm and fm[key], f"missing {key!r} in {md}"
        assert body.strip(), f"empty body in {md}"


def test_frontmatter_role_matches_directory() -> None:
    for md in _iter_corpus_seeds(_CORPUS_DIR):
        fm, _ = _parse_frontmatter(md.read_text(encoding="utf-8"))
        assert fm["role"] == md.parent.name, (
            f"role mismatch: dir={md.parent.name} fm={fm['role']} file={md}"
        )


def _load_body(md: Path) -> str:
    _, body = _parse_frontmatter(md.read_text(encoding="utf-8"))
    return body


def _sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def test_chip_huyen_cross_reference() -> None:
    """Chip Huyen seeds both data-eng and ai-eng. The two files must exist,
    must not be byte-identical, and each body should use the tilt its role
    cares about."""
    a = _CORPUS_DIR / "data-eng" / "chip-huyen.md"
    b = _CORPUS_DIR / "ai-eng" / "chip-huyen.md"
    assert a.is_file(), f"missing {a}"
    assert b.is_file(), f"missing {b}"
    assert _sha(a) != _sha(b), "data-eng and ai-eng chip-huyen files are identical"

    body_a = _load_body(a).lower()
    body_b = _load_body(b).lower()

    data_eng_keywords = ("pipeline", "data quality", "ingestion", "lineage")
    ai_eng_keywords = ("evals", "eval", "retrieval", "rag", "agents")

    assert any(k in body_a for k in data_eng_keywords), (
        f"data-eng chip-huyen missing data-tilt keywords {data_eng_keywords}"
    )
    assert any(k in body_b for k in ai_eng_keywords), (
        f"ai-eng chip-huyen missing ai-tilt keywords {ai_eng_keywords}"
    )


def test_josh_comeau_cross_reference() -> None:
    a = _CORPUS_DIR / "designer" / "josh-comeau.md"
    b = _CORPUS_DIR / "ui-eng" / "josh-comeau.md"
    assert a.is_file() and b.is_file()
    assert _sha(a) != _sha(b), "designer and ui-eng josh-comeau files are identical"

    body_a = _load_body(a).lower()
    body_b = _load_body(b).lower()

    designer_keywords = ("interaction", "motion", "animation", "design", "color")
    ui_keywords = ("react", "component", "css", "hook", "implementation")

    assert any(k in body_a for k in designer_keywords), (
        f"designer josh-comeau missing design-tilt keywords {designer_keywords}"
    )
    assert any(k in body_b for k in ui_keywords), (
        f"ui-eng josh-comeau missing ui-tilt keywords {ui_keywords}"
    )


def test_kent_c_dodds_cross_reference() -> None:
    a = _CORPUS_DIR / "ui-eng" / "kent-c-dodds.md"
    b = _CORPUS_DIR / "qa-eng" / "kent-c-dodds.md"
    assert a.is_file() and b.is_file()
    assert _sha(a) != _sha(b), "ui-eng and qa-eng kent-c-dodds files are identical"

    body_a = _load_body(a).lower()
    body_b = _load_body(b).lower()

    ui_keywords = ("component", "react", "hook", "epic react")
    qa_keywords = ("testing", "test", "trophy", "testing-library", "testing library")

    assert any(k in body_a for k in ui_keywords), (
        f"ui-eng kent-c-dodds missing ui-tilt keywords {ui_keywords}"
    )
    assert any(k in body_b for k in qa_keywords), (
        f"qa-eng kent-c-dodds missing qa-tilt keywords {qa_keywords}"
    )


def test_body_word_counts_within_bounds() -> None:
    """The corpus is meant to be dense but approachable: 300-1000 words of
    body text per seed. We tracked 942 as the observed upper bound; keep a
    small buffer in case a future refresh nudges it."""
    out_of_range: List[Tuple[Path, int]] = []
    for md in _iter_corpus_seeds(_CORPUS_DIR):
        body = _load_body(md)
        wc = len(body.split())
        if wc < 300 or wc > 1000:
            out_of_range.append((md, wc))
    assert not out_of_range, f"files outside 300..1000 word range: {out_of_range}"


def _run_all() -> int:
    """Fallback runner when pytest isn't installed."""
    tests = [
        test_all_11_role_dirs_present,
        test_every_seed_file_parses_cleanly,
        test_frontmatter_role_matches_directory,
        test_chip_huyen_cross_reference,
        test_josh_comeau_cross_reference,
        test_kent_c_dodds_cross_reference,
        test_body_word_counts_within_bounds,
    ]
    failures = 0
    for t in tests:
        try:
            t()
            print(f"  ok   {t.__name__}")
        except AssertionError as e:
            print(f"  FAIL {t.__name__}: {e}")
            failures += 1
        except Exception as e:  # pragma: no cover
            print(f"  ERR  {t.__name__}: {e}")
            failures += 1
    return failures


if __name__ == "__main__":
    import sys

    sys.exit(_run_all())
