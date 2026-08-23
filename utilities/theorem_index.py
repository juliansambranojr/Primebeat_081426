#!/usr/bin/env python3
"""Generate lean/THEOREMS.md — every theorem, what it claims, what it costs.

There are 197 theorems across 14 modules. To find out whether something is
proved you currently read all of them. This builds the table instead:

    module | theorem | claim (first docstring sentence) | axioms | cited by

GENERATED, not written. Re-run after any change to lean/:

    python3 utilities/theorem_index.py

Nothing is modified except lean/THEOREMS.md.
"""
import pathlib, re, sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
LEAN = ROOT / "lean"
CITERS = [ROOT / "papers", ROOT / "notes", ROOT]

AX = {
    "[propext, Classical.choice, Quot.sound]": "ℂ floor",
    "[propext, Quot.sound]": "propext, Quot.sound",
    "[propext]": "propext",
    "does not depend on any axioms": "**none**",
}


def docstring_claim(text, pos):
    """First sentence of the /-- … -/ block immediately above `pos`."""
    head = text[:pos]
    i = head.rfind("-/")
    if i == -1:
        return ""
    j = head.rfind("/--", 0, i)
    if j == -1:
        return ""
    if head[i + 2:].strip():          # something between docstring and theorem
        return ""
    body = " ".join(head[j + 3:i].split())
    body = body.replace("**", "")
    m = re.split(r"(?<=[.!?])\s", body)
    s = m[0] if m else body
    return s[:150]


def axioms_for(text, name):
    m = re.search(rf"/-- info: '[\w.]*\.{re.escape(name)}' (does not depend on any axioms"
                  rf"|depends on axioms: (\[[^\]]*\]))", text)
    if not m:
        return "—"
    key = m.group(2) if m.group(2) else "does not depend on any axioms"
    return AX.get(key, key)


def citations():
    """theorem fullname -> set of files citing it."""
    out = {}
    files = []
    for base in CITERS:
        files += list(base.glob("*.md")) if base.is_dir() else []
    for f in files:
        try:
            t = f.read_text()
        except Exception:
            continue
        for m in re.finditer(r"\b([A-Z]\w+)\.([a-z]\w*'?)", t):
            out.setdefault(f"{m.group(1)}.{m.group(2)}", set()).add(f.name)
    return out


def main():
    cited = citations()
    rows, totals = [], {}
    for f in sorted(LEAN.glob("*.lean")):
        text = f.read_text()
        mod = f.stem
        n = 0
        for m in re.finditer(r"^\s*theorem\s+([A-Za-z_][\w']*)", text, re.M):
            name = m.group(1)
            claim = docstring_claim(text, m.start())
            ax = axioms_for(text, name)
            who = sorted(cited.get(f"{mod}.{name}", set()))
            rows.append((mod, name, claim, ax, who))
            n += 1
        totals[mod] = n

    lines = [
        "# Theorem index",
        "",
        "**GENERATED** by `utilities/theorem_index.py`. Do not edit by hand;",
        "re-run after any change to `lean/`.",
        "",
        f"{len(rows)} theorems across {len(totals)} modules. Every one carries a",
        "`#guard_msgs`-pinned `#print axioms`, so the axiom column is checked by",
        "`lake build` rather than asserted here.",
        "",
        "`ℂ floor` means `[propext, Classical.choice, Quot.sound]` — unavoidable for",
        "any statement mentioning ℝ or ℂ, since Mathlib builds ℝ with choice. The",
        "rows reading **none** are the tight ones: pure computation, nothing assumed.",
        "",
    ]

    zero = [r for r in rows if r[3] == "**none**"]
    if zero:
        lines += ["## Depending on no axioms at all", "",
                  "| module | theorem | claim |", "|---|---|---|"]
        for mod, name, claim, _, _ in zero:
            lines.append(f"| `{mod}` | `{name}` | {claim} |")
        lines.append("")

    for mod in sorted(totals):
        lines += [f"## {mod} ({totals[mod]})", "",
                  "| theorem | claim | axioms | cited by |", "|---|---|---|---|"]
        for m2, name, claim, ax, who in rows:
            if m2 != mod:
                continue
            c = ", ".join(f"`{w}`" for w in who[:3]) if who else "—"
            if len(who) > 3:
                c += f" +{len(who)-3}"
            lines.append(f"| `{name}` | {claim} | {ax} | {c} |")
        lines.append("")

    out = LEAN / "THEOREMS.md"
    out.write_text("\n".join(lines))
    uncited = sum(1 for r in rows if not r[4])
    nodoc = sum(1 for r in rows if not r[2])
    print(f"wrote {out.relative_to(ROOT)}")
    print(f"   {len(rows)} theorems, {len(totals)} modules")
    print(f"   {len(zero)} depend on no axioms")
    print(f"   {uncited} cited by no paper or note")
    print(f"   {nodoc} have no docstring claim")


if __name__ == "__main__":
    sys.exit(main())
