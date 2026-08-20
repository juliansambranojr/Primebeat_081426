#!/usr/bin/env python3
"""Check that every reference in papers/ and lean/ resolves. Exit 1 if not.

Checks four token types wherever they appear; everything else is prose.
  Paper.md § A3        section or statement exists in that paper
  Module.name          declaration exists in lean/
  script.py            file exists somewhere in the repo
  results/x.json       path exists
"""
import re, sys, pathlib

ROOT = pathlib.Path(__file__).resolve().parent.parent
PAPERS, LEAN = ROOT / "papers", ROOT / "lean"

# what exists
sections = {}
for f in PAPERS.glob("*.md"):
    t = f.read_text()
    sections[f.name] = ({m.group(1) for m in re.finditer(r"^## ([A-Z])\s*·", t, re.M)}
                        | {m.group(1) for m in re.finditer(r"^\*\*([A-Z]\d+)\.\*\*", t, re.M)})
mods = {f.stem for f in LEAN.glob("*.lean")}
decls = set()
for f in LEAN.glob("*.lean"):
    for m in re.finditer(r"^(?:theorem|def|noncomputable def)\s+([A-Za-z_][\w']*)", f.read_text(), re.M):
        decls.add(f"{f.stem}.{m.group(1)}")
files = {p.name for p in ROOT.rglob("*") if p.is_file()}

broken = []
def check(src, why, cond):
    if not cond: broken.append((src, why))

for f in sorted(list(PAPERS.glob("*.md")) + list(LEAN.glob("*.lean"))):
    if f.name == "FORMAT.md": continue
    text, where = f.read_text(), f.name
    for m in re.finditer(r"([A-Za-z][\w\-.]*\.md)`? § ([A-Z]\d*(?:\s*[,+]\s*[A-Z]\d*)*)", text):
        paper = m.group(1)
        if paper not in sections: continue          # commitment file or external
        for s in re.split(r"\s*[,+]\s*", m.group(2)):
            check(where, f"{paper} § {s}", s in sections[paper])
    for m in re.finditer(r"(?<![\w\-/])(" + "|".join(mods) + r")\.([a-z][\w']*)", text):
        if m.group(2) in ("md", "lean", "py", "json", "csv", "log", "txt"): continue
        n = f"{m.group(1)}.{m.group(2)}"
        check(where, n, n in decls or n.rstrip("'") in decls)
    for m in re.finditer(r"(?<![\w/])([\w\-]+\.py)\b", text):
        check(where, m.group(1), m.group(1) in files)
    for m in re.finditer(r"\b((?:results|imported|preregs)/[\w./\-]+)", text):
        raw = m.group(1)
        if raw.endswith("_") or "*" in raw: continue          # glob in prose
        ref = raw.rstrip(".")
        check(where, ref, (ROOT / ref).exists())

for w, why in broken: print(f"BROKEN  {w}  ->  {why}")
print(f"\n{len(broken)} broken reference(s)")
sys.exit(1 if broken else 0)
