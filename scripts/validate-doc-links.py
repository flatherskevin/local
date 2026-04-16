#!/usr/bin/env python3

from __future__ import annotations

import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
DOCS = [ROOT / "README.md", *sorted((ROOT / "docs").rglob("*.md"))]
LINK_RE = re.compile(r"\[[^\]]+\]\(([^)]+)\)")


def target_path(source: Path, raw_target: str) -> Path | None:
    target = raw_target.strip()
    if not target or "://" in target or target.startswith("mailto:"):
        return None
    target = target.split("#", 1)[0]
    if not target:
        return None
    return (source.parent / target).resolve()


def main() -> int:
    failures: list[str] = []

    for doc in DOCS:
        content = doc.read_text(encoding="utf-8")
        for raw_target in LINK_RE.findall(content):
            resolved = target_path(doc, raw_target)
            if resolved is None:
                continue
            if not resolved.exists():
                failures.append(f"{doc.relative_to(ROOT)} -> {raw_target}")

    if failures:
        for failure in failures:
            print(f"[broken-link] {failure}", file=sys.stderr)
        return 1

    print("[ok] markdown links")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
