#!/usr/bin/env python3
"""Check that every reference in papers/, lean/ and units/ resolves. Exit 1 if not.

Checks four token types wherever they appear; everything else is prose.
  Paper.md § A3        section or statement exists in that paper
  Module.name          declaration exists in lean/
  script.py            file exists somewhere in the repo
  results/x.json       path exists

It checks that a target EXISTS. It cannot check that the target says what the
citing line claims, and one miscitation of exactly that shape stood undetected
(entry 88: The-Deep-Ladder § F4 cited Euler-Factor-Chain § J5, which is about
RH, for a claim about analytic continuation).

  --audit         pair every cross-document `§` citation with the text it
                  points at, for review. Reads nothing about meaning; the
                  judgement is a person's. Exits 0 and runs no gate.
  --list-scanned  print every file this walks, repo-relative, and exit 0.

PHASE 2c ADDS `units/`. It walked papers/, lean/, notes/*.md and root *.md, so
a unit's citations were ungated -- one of the three findings the design's
§ The parser matches the spec records as "spec and code written apart". Only
`units/<unit>/unit.md` is scanned, for the reason `lab/check.py` gives for
reading only that file: `question.md` is a transcript bracket copied in
verbatim and `transcript/*.md` are agent reports copied in verbatim, so their
citations are QUOTED rather than made, and holding a copy of somebody else's
text to this gate would make a unit unwritable. A unit's own claims are its
`unit.md`.

Units are labelled by their repo-relative path (`units/0308-.../unit.md`)
rather than by `f.name`, which every unit shares. Everything else keeps the
bare filename it has always had, so `utilities/refs_baseline.txt` reads
unchanged.
"""
import re, sys, pathlib

ROOT = pathlib.Path(__file__).resolve().parent.parent
PAPERS, LEAN, NOTES = ROOT / "papers", ROOT / "lean", ROOT / "notes"
UNITS = ROOT / "units"

# what exists
sections = {}
for f in PAPERS.glob("*.md"):
    t = f.read_text()
    sections[f.name] = ({m.group(1) for m in re.finditer(r"^## ([A-Z])\s*·", t, re.M)}
                        | {m.group(1) for m in re.finditer(r"^#{3,4} ([A-Z]\d*)\s*·", t, re.M)}
                        | {m.group(1) for m in re.finditer(r"^\*\*([A-Z]\d+)\.\*\*", t, re.M)})
# named sections of root-level docs: `CLAUDE.md § Prereg discipline`
named = {}
for f in ROOT.glob("*.md"):
    named[f.name] = {m.group(1).strip() for m in
                     re.finditer(r"^#{2,3} (.+)$", f.read_text(), re.M)}

# A Lean declaration's address is its NAMESPACE, not its filename, and
# papers/FORMAT.md specifies that a citation names a declaration that must
# exist in lean/. This block keyed only by file stem, so a citation broke
# the moment a theorem moved between files even when its namespace never
# changed — 48 of them did, when ZerosStencil was split out of Zeros on
# 2026-08-26. Indexing by declared namespace AND stem is byte-identical on
# every module that predates that split, because each declares exactly one
# namespace equal to its own stem; it differs only where a namespace now
# spans two files, which is the case this exists to accept.
mods, decls = set(), set()
for f in LEAN.glob("*.lean"):
    src = f.read_text()
    m_ns = re.search(r"^namespace ([A-Za-z_][\w'.]*)", src, re.M)
    ns = m_ns.group(1) if m_ns else f.stem
    mods.add(ns)
    mods.add(f.stem)
    for m in re.finditer(r"^(?:theorem|def|noncomputable def)\s+([A-Za-z_][\w']*)", src, re.M):
        decls.add(f"{ns}.{m.group(1)}")
        decls.add(f"{f.stem}.{m.group(1)}")
files = {p.name for p in ROOT.rglob("*") if p.is_file()}

ALLOW = [l.strip() for l in (ROOT / "utilities/refs_allowlist.txt").read_text().splitlines()
         if l.strip() and not l.startswith("#")] if (ROOT / "utilities/refs_allowlist.txt").exists() else []

def audit():
    """Pair each cross-document `§` citation with the statement it points at."""
    def statements(path):
        """{label: text} for `**A1.** ...`, `## A · ...` and `### A1 · ...`.

        The `#{2,4}` range is load-bearing: `Formalization.md` states B4 as
        `### B4 · ...`, and matching only `## ` is the documented failure in
        CLAUDE.md that declared a live section missing. This tool reproduced
        it on its first run.
        """
        t = path.read_text()
        out = {}
        for m in re.finditer(r"^\*\*([A-Z]\d+[\u2032\u2033\u2034]?)\.\*\*\s*(.+?)(?=\n\n|\Z)",
                             t, re.M | re.S):
            out[m.group(1)] = " ".join(m.group(2).split())
        for m in re.finditer(r"^#{2,4} ([A-Z]\d*)\s*\u00b7\s*(.+)$", t, re.M):
            out.setdefault(m.group(1), " ".join(m.group(2).split()))
        return out

    body = {f.name: statements(f) for f in PAPERS.glob("*.md")}
    rows, seen, n = [], set(), 0
    for f in sorted(PAPERS.glob("*.md")):
        if f.name == "FORMAT.md":
            continue
        text = re.sub(r"```.*?```", "", f.read_text(), flags=re.S)
        here = statements(f)
        for m in re.finditer(r"([A-Za-z][\w\-.]*\.md)`? \u00a7 ([A-Z]\d*)", text):
            doc, sec = m.group(1), m.group(2)
            if doc == f.name or doc not in body:
                continue          # same-paper and commitment-file cites skipped
            back = text[:m.start()]
            cm = list(re.finditer(r"^\*\*([A-Z]\d+[\u2032\u2033\u2034]?)\.\*\*", back, re.M))
            label = cm[-1].group(1) if cm else "?"
            key = (f.name, label, doc, sec)
            if key in seen:
                continue          # same cite twice in one statement is one cite
            seen.add(key)
            rows.append((f.name, label, here.get(label, ""), doc, sec,
                         body[doc].get(sec, "<<MISSING>>")))
            n += 1
    for src, label, claim, doc, sec, target in rows:
        print(f"\n{src} \u00a7 {label}  ->  {doc} \u00a7 {sec}")
        print(f"    claims : {claim[:150]}")
        print(f"    target : {target[:150]}")
    print(f"\n{n} cross-document citation(s). Existence is checked by the gate; "
          f"whether each target supports its claim is not.")
    sys.exit(0)


if "--audit" in sys.argv:
    audit()

broken = []
def check(src, why, cond):
    if cond or any(a in why for a in ALLOW): return
    broken.append((src, why))

def scanned_files():
    """[(path, label)] for every file the gate reads, in one place.

    The label is what a BROKEN line names, and what utilities/refs_baseline.txt
    is keyed on: a bare filename everywhere it has always been one, and a
    repo-relative path for a unit, whose `unit.md` is not a unique name.
    """
    out = []
    for f in sorted(list(PAPERS.glob("*.md")) + list(LEAN.glob("*.lean"))
                    + list(NOTES.glob("*.md")) + list(ROOT.glob("*.md"))):
        # agent briefs cite bad references on purpose, as examples
        if f.name in ("FORMAT.md", "notes_format.md") \
                or f.name.startswith("claude_"):
            continue
        out.append((f, f.name))
    for f in sorted(UNITS.glob("*/unit.md")) if UNITS.is_dir() else []:
        out.append((f, f.relative_to(ROOT).as_posix()))
    return out


if "--list-scanned" in sys.argv:
    for _, label in scanned_files():
        print(label)
    sys.exit(0)

for f, where in scanned_files():
    # fenced blocks are quoted evidence, not the file's own citations
    text = re.sub(r"```.*?```", "", f.read_text(), flags=re.S)
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
    for m in re.finditer(r"(?<![\w/.])((?:results|imported|preregs)/[\w./\-]+)", text):
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
    # Six lines once landed in the header's format example instead of the list,
    # because a restated format contains a line shaped exactly like an entry.
    # A thread line above `## Threads` is misplaced, wherever it looks fine.
    in_threads = False
    for i, line in enumerate(np.read_text().split("\n"), 1):
        if line.strip() == "## Threads":
            in_threads = True
            continue
        if not line.startswith("- ["): continue
        if "YYYY-MM-DD" in line: continue                     # template example
        if not in_threads:
            broken.append(("NOTEPAD.md",
                           f'line {i} is above "## Threads": {line[:44].strip()}…'))
            continue
        m = re.search(r"entry (\d+):", line)
        tag = f"entry {m.group(1)}" if m else f'"{line[12:44].strip()}…"'
        check("NOTEPAD.md", f"{tag} malformed",
              re.match(r"- \[(open|paused|closed|blocked)\]\s+\d{4}-\d\d-\d\d\s", line))
        check("NOTEPAD.md", f"{tag} is {len(line)} chars, not one line", len(line) <= 400)
        m = re.search(r"entry (\d+):", line)
        if m: check("NOTEPAD.md", f"line {i} cites entry {m.group(1)}", int(m.group(1)) in entries)

# notebook state, computed once and correctly: fences stripped, digits required
#
# PHASE 2c CHANGED WHAT THIS LINE SAYS. It read `next 308`, computed from
# notes/ alone, and that number is now wrong in the only sense that matters:
# entry 308 will never be written. The design's § Phases freezes
# notes/lab_notebook_2.md "exactly as volume 1 froze at entry 44", and unit
# 0308 is where the record continued. So the line names both halves and the
# next record it names is a UNIT -- the same id `lab new` will allocate, read
# from the same two places `lab/new.py` reads it from, so the two can never
# disagree.
if entries:
    hi = max(entries)
    gaps = [n for n in range(1, hi + 1) if n not in entries and n not in GAP]
    # `newest N` is kept, and the units half says `latest` rather than a second
    # `newest`: .github/workflows/audit.yml reads this line with
    # `s/^notebook: .*newest ([0-9]+) .*$/\1/p` and then does arithmetic on
    # what it captures, so a second `newest` carrying a zero-padded unit id
    # would hand a shell `$((0308 - 1))`, which is not a number in POSIX sh.
    line = (f"notebook: {len(entries)} entries, newest {hi} ({entries[hi]}), "
            f"FROZEN" + (f", MISSING {gaps}" if gaps else ""))
    try:
        sys.path.insert(0, str(ROOT))
        from lab.new import next_id
        from lab.unit import units_of
        held = units_of(UNITS)
        if held:
            line += (f"; units: {len(held)}, latest {max(held)}, "
                     f"next unit {next_id(UNITS)}")
    except ImportError:
        line += "; units: lab is not importable, so no unit state"
    print(line)

for w, why in broken: print(f"BROKEN  {w}  ->  {why}")
print(f"\n{len(broken)} broken reference(s)")
sys.exit(1 if broken else 0)
