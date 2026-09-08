#!/usr/bin/env python3
"""
check_lean_unit.py -- refuse a Lean formalization unit whose record
disagrees with its module.  Part of lean_stage3/LOOP.md (step 6).

    python3 utilities/check_lean_unit.py units/<unit> [--repo <root>]

Checks, each a line of output, exit 1 if any fails:

  MODULE   every ref in unit.md names one lean_stage3 file; that file exists
  LINES    values.tsv module_lines == wc -l of the module
  THEOREMS values.tsv theorems_proved == count of lines starting 'theorem '
  DEFS     values.tsv defs == count of lines starting 'def '
  PIN      every ref name is declared in the module and has a
           '#print axioms <name>' line
  NEXT     unit.md has a paragraph beginning 'What the next slice' or
           'What remains'
  LOOP     values.tsv has loop_version at or below the 'version:' line of
           lean_stage3/LOOP.md
  DESIGN   values.tsv has design = <file>#<heading-slug>; the file exists
           under lean_stage3/design/ and has a heading whose slug (lower
           case, spaces to dashes, punctuation dropped) equals it or starts
           with it: `rung5.md#6` names section 6
  BUILD    run/build.log exists and ends with 'Build completed successfully'
  SORRY    the module contains no `sorry`
  SCRATCH  lean_stage3/Stage3/Scratch.lean is not in the tree (LOOP.md § 2)
  RING     no bare `ring` on the line after a `field_simp` in the module
           (LOOP.md § 4; TRAPS.md row 1); units at loop_version 16 and up
  HEADER   the module's header comment, before its first `import`, names
           the block: the part of `design` after `#` (LOOP.md § 1); 16 and up
  PINS     PINS.md names the module or the block (LOOP.md § 0b); 16 and up

Read-only over the tree.  The four checks added at loop version 16 replace
the paragraphs that carried those rules in LOOP.md as prose (unit 0353).
"""
import argparse
import os
import re
import sys


def read(path):
    with open(path, encoding="utf-8") as f:
        return f.read()


def front_matter(text):
    m = re.match(r"---\n(.*?)\n---\n(.*)", text, re.S)
    if not m:
        return {}, text
    fm = {}
    for line in m.group(1).splitlines():
        if ":" in line:
            k, v = line.split(":", 1)
            fm[k.strip()] = v.strip()
    return fm, m.group(2)


def parse_refs(s):
    s = s.strip()
    if s.startswith("[") and s.endswith("]"):
        s = s[1:-1]
    return [r.strip() for r in s.split(",") if r.strip()]


def values(path):
    out = {}
    if not os.path.exists(path):
        return out
    for line in read(path).splitlines()[1:]:
        parts = line.split("\t")
        if len(parts) >= 2:
            out[parts[0]] = parts[1]
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("unit")
    ap.add_argument("--repo", default=None, help="repo root (default: parent of units/)")
    args = ap.parse_args()
    unit = os.path.abspath(args.unit.rstrip("/"))
    repo = os.path.abspath(args.repo) if args.repo else os.path.dirname(os.path.dirname(unit))
    name = os.path.basename(unit)
    fails = []

    fm, body = front_matter(read(os.path.join(unit, "unit.md")))
    vals = values(os.path.join(unit, "values.tsv"))
    refs = parse_refs(fm.get("refs", ""))

    # MODULE
    files = set()
    names = []
    for r in refs:
        if "::" not in r:
            fails.append(f"MODULE   ref without ::name: {r}")
            continue
        f, n = r.split("::", 1)
        files.add(f)
        names.append((f, n))
    if len(files) != 1:
        fails.append(f"MODULE   refs name {len(files)} file(s); a Lean unit has one module")
        module = None
    else:
        module = os.path.join(repo, next(iter(files)))
        if not os.path.exists(module):
            fails.append(f"MODULE   {module} does not exist")
            module = None

    if module:
        src = read(module)
        lines = src.splitlines()
        n_lines = len(lines) + (0 if src.endswith("\n") else 0)
        n_thm = sum(1 for l in lines if l.startswith("theorem "))
        n_def = sum(1 for l in lines if l.startswith("def "))
        # LINES: wc -l counts newlines
        wc = src.count("\n")
        if vals.get("module_lines") != str(wc):
            fails.append(f"LINES    values module_lines={vals.get('module_lines')} but wc -l={wc}")
        if vals.get("theorems_proved") != str(n_thm):
            fails.append(f"THEOREMS values theorems_proved={vals.get('theorems_proved')} but grep -c ^theorem={n_thm}")
        if vals.get("defs") != str(n_def):
            fails.append(f"DEFS     values defs={vals.get('defs')} but grep -c ^def={n_def}")
        # PIN
        for _, n in names:
            declared = re.search(rf"^(theorem|def|abbrev) {re.escape(n)}\b", src, re.M)
            pinned = re.search(rf"^#print axioms {re.escape(n)}\s*$", src, re.M)
            if not declared:
                fails.append(f"PIN      {n} is not declared in the module")
            elif not pinned:
                fails.append(f"PIN      {n} has no '#print axioms {n}' line")

    # NEXT
    if not re.search(r"^(What the next slice|What remains)", body, re.M):
        fails.append("NEXT     unit.md has no paragraph beginning 'What the next slice' or 'What remains'")

    # LOOP
    loop_path = os.path.join(repo, "lean_stage3", "LOOP.md")
    loop_version = None
    if os.path.exists(loop_path):
        m = re.search(r"^version:\s*(\S+)", read(loop_path), re.M)
        loop_version = m.group(1) if m else None
    if loop_version is None:
        fails.append("LOOP     lean_stage3/LOOP.md has no 'version:' line")
    else:
        # A unit records the recipe it was built under; the line in LOOP.md
        # only moves up.  Refuse a version above the current line (a typo or
        # a bump that never landed); accept anything at or below it, so a
        # retrospective's bump can be committed with the unit that caused
        # it (unit 0340, the agent probe, found the equality rule refused
        # exactly that commit).
        try:
            unit_v = int(vals.get("loop_version"))
            cur_v = int(loop_version)
        except (TypeError, ValueError):
            unit_v, cur_v = None, None
        if unit_v is None or cur_v is None:
            if vals.get("loop_version") != loop_version:
                fails.append(f"LOOP     values loop_version={vals.get('loop_version')} but LOOP.md version={loop_version}")
        elif unit_v > cur_v:
            fails.append(f"LOOP     values loop_version={unit_v} is above LOOP.md version={cur_v}")

    # DESIGN
    design = vals.get("design")
    if not design or "#" not in design:
        fails.append("DESIGN   values.tsv has no row design = <file>#<heading-slug>")
    else:
        dfile, slug = design.split("#", 1)
        dpath = os.path.join(repo, "lean_stage3", "design", dfile)
        if not os.path.exists(dpath):
            fails.append(f"DESIGN   lean_stage3/design/{dfile} does not exist")
        else:
            def slugify(s):
                s = s.strip().lower()
                s = re.sub(r"[^a-z0-9\s-]", "", s)
                return re.sub(r"\s+", "-", s).strip("-")
            heads = [slugify(m.group(1)) for m in re.finditer(r"^#{1,6}\s+(.*)$", read(dpath), re.M)]
            # the slug may be a prefix of the heading's slug: `rung5.md#6` names section 6
            if not any(hd == slug or hd.startswith(slug + "-") for hd in heads):
                fails.append(f"DESIGN   no heading '{slug}' in lean_stage3/design/{dfile}; headings: {', '.join(heads)[:200]}")

    # BUILD
    log = os.path.join(unit, "run", "build.log")
    if not os.path.exists(log):
        fails.append("BUILD    run/build.log missing")
    else:
        tail = read(log).rstrip().splitlines()[-1:] or [""]
        if "Build completed successfully" not in tail[0]:
            fails.append(f"BUILD    run/build.log last line: {tail[0][:80]!r}")

    # SORRY / SCRATCH, every unit
    # A module may carry sorries when the block itself names them as OPEN and
    # the unit records the count. The check refuses drift between the module
    # and values.tsv (unit 0368 was the first partial unit under this rule).
    if module:
        n_sorry = len(re.findall(r"\bsorry\b", src))
        try:
            declared = int(vals.get("sorries", "0"))
        except (TypeError, ValueError):
            declared = -1
        if n_sorry != declared:
            fails.append(
                f"SORRY    the module has {n_sorry} `sorry`; values.tsv declares {declared}")
    if os.path.exists(os.path.join(repo, "lean_stage3", "Stage3", "Scratch.lean")):
        fails.append("SCRATCH  lean_stage3/Stage3/Scratch.lean is in the tree; delete it before the commit")

    # RING / HEADER / PINS, units built at loop version 16 and up
    try:
        gated = int(vals.get("loop_version")) >= 16
    except (TypeError, ValueError):
        gated = False
    if gated and module:
        for i in range(len(lines) - 1):
            if "field_simp" in lines[i] and lines[i + 1].strip() == "ring":
                fails.append(f"RING     bare `ring` after `field_simp` at line {i + 2}; write `try ring`")
        head = src.split("\nimport ", 1)[0]
        block = design.split("#", 1)[1] if design and "#" in design else ""
        # the design slug is lower-cased by construction (`hnt.md#h1` for `## H1`),
        # the header writes the block as the worksheet does; compare case-blind (unit 0363)
        if block and block.lower() not in head.lower():
            fails.append(f"HEADER   the header before the first import does not name the block '{block}'")
        pins_path = os.path.join(repo, "PINS.md")
        modname = os.path.splitext(os.path.basename(module))[0]
        pins_text = read(pins_path) if os.path.exists(pins_path) else ""
        if modname not in pins_text and (not block or block not in pins_text):
            fails.append(f"PINS     PINS.md names neither {modname} nor the block '{block}'")

    if fails:
        print(f"{name}: REFUSED")
        for f in fails:
            print("  " + f)
        sys.exit(1)
    print(f"{name}: OK  ({len(names)} pin(s), loop_version {loop_version}, design {vals.get('design')})")


if __name__ == "__main__":
    main()
