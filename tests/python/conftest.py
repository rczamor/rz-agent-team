"""pytest fixtures for the agent-team test suite.

Discovers the repo root by walking up from this file until we see the
three canonical top-level directories (corpus/, identities/, skills/).
"""

from __future__ import annotations

from pathlib import Path

import pytest


def _find_repo_root(start: Path) -> Path:
    for candidate in [start, *start.parents]:
        if (
            (candidate / "corpus").is_dir()
            and (candidate / "identities").is_dir()
            and (candidate / "skills").is_dir()
        ):
            return candidate
    raise RuntimeError(f"Could not locate repo root from {start}")


@pytest.fixture(scope="session")
def repo_root() -> Path:
    return _find_repo_root(Path(__file__).resolve())


@pytest.fixture(scope="session")
def corpus_dir(repo_root: Path) -> Path:
    return repo_root / "corpus"


@pytest.fixture(scope="session")
def identities_dir(repo_root: Path) -> Path:
    return repo_root / "identities"


@pytest.fixture(scope="session")
def skills_dir(repo_root: Path) -> Path:
    return repo_root / "skills"
