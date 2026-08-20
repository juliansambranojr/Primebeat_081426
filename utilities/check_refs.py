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
PAPERS, LEAN, NOTES = ROOT / "papers", ROOT / "lean", ROOT / "notes"

# what exists
sections = {}
for f in PAPERS.glob("*.md"):
    t = f.read_text()
    sections[f.name] = ({m.group(1) for m in re.finditer(r"^## ([A-Z])\s*·", t, re.M)}
                        | {m.group(1) for m in re.finditer(r"^\*\*([A-Z]\d+)\.\*\*", t, re.M)})
# named sections of root-level docs: `CLAUDE.md § Prereg discipline`
named = {}
for f in ROOT.glob("*.md"):
    named[f.name] = {m.group(1).strip() for m in
                     re.finditer(r"^#{2,3} (.+)$", f.read_text(), re.M)}

mods = {f.stem for f in LEAN.glob("*.lean")}
decls = set()
for f in LEAN.glob("*.lean"):
    for m in re.finditer(r"^(?:theorem|def|noncomputable def)\s+([A-Za-z_][\w']*)", f.read_text(), re.M):
        decls.add(f"{f.stem}.{m.group(1)}")
files = {p.name for p in ROOT.rglob("*") if p.is_file()}

ALLOW = [l.strip() for l in (ROOT / "utilities/refs_allowlist.txt").read_text().splitlines()
         if l.strip() and not l.startswith("#")] if (ROOT / "utilities/refs_allowlist.txt").exists() else []

broken = []
def check(src, why, cond):
    if cond or any(a in why for a in ALLOW): return
    broken.append((src, why))

for f in sorted(list(PAPERS.glob("*.md")) + list(LEAN.glob("*.lean"))
                + list(NOTES.glob("*.md")) + list(ROOT.glob("*.md"))):
    # agent briefs cite bad references on purpose, as examples
    if f.name in ("FORMAT.md", "notes_format.md") or f.name.startswith("claude_"):
        continue
    # fenced blocks are quoted evidence, not the file's own citations
    text, where = re.sub(r"```.*?```", "", f.read_text(), flags=re.S), f.name
    for m in re.finditer(r"`?([A-Za-z][\w\-.]*\.md)`? § ", text):
        doc = m.group(1)
        if doc not in named: continue
        rest = " ".join(text[m.end():m.end() + 140].split()).lstrip('"\'')
        if re.match(r"[A-Z]\d", rest): continue          # lettered, handled below
        hit = max((s for s in named[doc] if rest.startswith(s)), key=len, default=None)
        check(where, f"{doc} § {rest[:40]}", hit is not None)
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
        if text[m.end():m.end()+1] == "{": continue           # brace expansion in prose
        ref = raw.rstrip(".")
        check(where, ref, (ROOT / ref).exists())

# --- notes: entry numbering, types, NOTEPAD lines ---
TYPES = {"motivation","prereg","run","instrument-fix","result-triage",
         "provenance","formalization"}
entries, GAP = {}, {18}          # Entry 18 is a recorded gap, not an error
for vol, lo, hi in (("lab_notebook.md", 1, 44), ("lab_notebook_2.md", 45, 10**6)):
    f = NOTES / vol
    if not f.exists(): continue
    body = re.sub(r"```.*?```", "", f.read_text(), flags=re.S)     # drop fences
    for m in re.finditer(r"^## (\d{4}-\d\d-\d\d) — Entry (\d+).*?\ntype: (\S+)", body, re.M):
        d, n, ty = m.group(1), int(m.group(2)), m.group(3)
        check(vol, f"entry {n} outside this volume", lo <= n <= hi)
        check(vol, f"entry {n} duplicated", n not in entries)
        check(vol, f"entry {n} type '{ty}'", ty in TYPES)
        entries[n] = d
if entries:
    for n in range(1, max(entries) + 1):
        check("lab_notebook", f"entry {n} missing", n in entries or n in GAP)
np = NOTES / "NOTEPAD.md"
if np.exists():
    for i, line in enumerate(np.read_text().split("\n"), 1):
        if not line.startswith("- ["): continue
        if "YYYY-MM-DD" in line: continue                     # template example
        check("NOTEPAD.md", f"line {i} malformed",
              re.match(r"- \[(open|paused|closed|blocked)\]\s+\d{4}-\d\d-\d\d\s", line))
        check("NOTEPAD.md", f"line {i} is {len(line)} chars, not one line", len(line) <= 400)
        m = re.search(r"entry (\d+):", line)
        if m: check("NOTEPAD.md", f"line {i} cites entry {m.group(1)}", int(m.group(1)) in entries)

# notebook state, computed once and correctly: fences stripped, digits required
if entries:
    hi = max(entries)
    gaps = [n for n in range(1, hi + 1) if n not in entries and n not in GAP]
    print(f"notebook: {len(entries)} entries, newest {hi} ({entries[hi]}), "
          f"next {hi + 1}" + (f", MISSING {gaps}" if gaps else ""))

for w, why in broken: print(f"BROKEN  {w}  ->  {why}")
print(f"\n{len(broken)} broken reference(s)")
sys.exit(1 if broken else 0)
