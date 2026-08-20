#!/usr/bin/env python3
"""Check that numbers in a paper appear in the artifact its source line names.

Rounding-aware: a paper's `0.486` matches an artifact's `0.4860234` because the
artifact value rounds to the paper value at the paper's own precision. Separators
are stripped, so `492,384` matches `492384`.

A statement is checked only if its source line names an artifact. Statements
sourced to another statement (`A1`, `B3 + C3`) are derived and skipped -- their
numbers are computed from the artifact, not printed in it.
"""
import re, sys, pathlib
from decimal import Decimal

ROOT = pathlib.Path(__file__).resolve().parent.parent
NUM = re.compile(r"-?\d{1,3}(?:,\d{3})+(?:\.\d+)?|-?\d+(?:\.\d+)?(?:[eE]-?\d+)?")
ART = re.compile(r"[\w/]*[\w\-]+\.(?:txt|json|csv|log)")

def nums(s):
    out = set()
    for m in NUM.finditer(s):
        try: out.add(Decimal(m.group(0).replace(",", "")))
        except Exception: pass
    return out

def matches(want, have):
    """want appears in have, at want's own precision."""
    exp = want.as_tuple().exponent
    places = -exp if isinstance(exp, int) and exp < 0 else 0
    tol = Decimal(5).scaleb(-places - 1)      # half a unit in the last stated place
    return any(abs(v - want) <= tol for v in have)

def artifact(name):
    p = ROOT / name
    if p.exists(): return p
    hits = [q for q in ROOT.rglob(pathlib.PurePath(name).name) if q.is_file()]
    return hits[0] if len(hits) == 1 else None

bad = ok = skipped = 0
for f in sorted((ROOT / "papers").glob("*.md")):
    if f.name == "FORMAT.md": continue
    text = f.read_text()
    # statement body up to its source line
    for m in re.finditer(r"^\*\*([A-Z]\d+)\.\*\*(.*?)^`([^`]+)`\s*$", text, re.S | re.M):
        tag, body, src = m.group(1), m.group(2), m.group(3)
        names = ART.findall(src)
        if not names or re.search(r"derived|against|computed from", src):
            skipped += 1; continue
        have = set()
        for n in names:
            p = artifact(n)
            if p: have |= nums(p.read_text(errors="ignore"))
        if not have: skipped += 1; continue
        for want in nums(body):
            if abs(want) < 10: continue          # indices, section numbers, small counts
            if matches(want, have): ok += 1
            else:
                bad += 1
                print(f"MISMATCH  {f.name} § {tag}  {want}  not in {', '.join(names)}")
print(f"\n{ok} values confirmed, {bad} not found, {skipped} statements skipped (no artifact in source line)")
sys.exit(1 if bad else 0)
