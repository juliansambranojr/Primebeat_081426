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


def citations(all_names):
    """theorem fullname -> set of files citing it.

    Three citation forms are accepted, in decreasing strictness:

      1. Qualified: `Module.name` anywhere in prose.
      2. Bare unique names: a name defined in exactly one module counts when
         it appears bare, if it is >= 10 characters or carries an underscore
         at >= 6 -- the notebook discusses theorems this way constantly,
         usually inside fenced blocks.
      3. Chain labels: a theorem whose docstring opens `**A1.**` formalises
         that statement of its module's companion paper, so a prose citation
         `<companion>.md § A1` cites the theorem. The companion is read from
         the module header's "Companion to papers/..." line. This is the
         paper's own citation convention (papers cite `Euler-Factor-Chain.md
         § A1`, never `Chain.A1`), so the linker follows it rather than
         demanding the qualified form.
    """
    out = {}
    files = []
    for base in CITERS:
        files += list(base.glob("*.md")) if base.is_dir() else []
    texts = {}
    for f in files:
        try:
            texts[f.name] = f.read_text()
        except Exception:
            pass
    corpus = "\n".join(texts.values())
    # 1. qualified
    for fname, t in texts.items():
        for m in re.finditer(r"\b([A-Z]\w+)\.([a-z]\w*'?)", t):
            out.setdefault(f"{m.group(1)}.{m.group(2)}", set()).add(fname)
    # 2. bare long unique
    by_name = {}
    for full in all_names:
        mod, n = full.split(".", 1)
        by_name.setdefault(n, []).append(mod)
    for n, mods in by_name.items():
        # bare-name matching: unique across modules, and either long or
        # underscore-bearing (an underscore makes a prose false positive
        # essentially impossible; `tau_pow`, `h_zero`, `A4_of_A1` are all
        # discussed bare in the notebook)
        if len(mods) != 1 or not (len(n) >= 10 or ("_" in n and len(n) >= 6)):
            continue
        pat = re.compile(rf"\b{re.escape(n)}\b")
        for fname, t in texts.items():
            if pat.search(t):
                out.setdefault(f"{mods[0]}.{n}", set()).add(fname)
    # 3. chain labels via the companion paper
    for f in LEAN.glob("*.lean"):
        t = f.read_text()
        mcomp = re.search(r"(?:Companion to|Encodes statement.*? of `?)\s*papers/([\w\-]+\.md)", t)
        if not mcomp:
            continue
        paper = mcomp.group(1)
        ptext = texts.get(paper, "")
        for m in re.finditer(
                r"/--\s+\*\*([A-Z]\d*[a-z]?[\u2032\u2033]?)(?:[.,]?\*\*|\*\*[.,])"
                r"(?:(?!-/).)*-/\s*(?:@\[[^\]]*\]\s*)?theorem\s+([A-Za-z_][\w']*)",
                t, re.S):
            label, name = m.group(1), m.group(2)
            # the theorem FORMALISES statement `label` of the companion paper;
            # the statement existing there is the prose counterpart
            if re.search(rf"^\*\*{re.escape(label)}\.\*\*", ptext, re.M):
                out.setdefault(f"{f.stem}.{name}", set()).add(paper)
    return out


def roles():
    """Module.name -> role, from utilities/theorem_roles.txt."""
    f = ROOT / "utilities" / "theorem_roles.txt"
    out = {}
    if f.exists():
        for line in f.read_text().splitlines():
            line = line.split("#")[0].strip()
            if line:
                parts = line.split()
                if len(parts) == 2:
                    out[parts[0]] = parts[1]
    return out


def main():
    all_names = []
    for f in sorted(LEAN.glob("*.lean")):
        for m in re.finditer(r"^\s*theorem\s+([A-Za-z_][\w']*)", f.read_text(), re.M):
            all_names.append(f"{f.stem}.{m.group(1)}")
    cited = citations(all_names)
    role = roles()
    stale = [k for k in role if k not in all_names]
    if stale:
        print(f"   WARNING stale roles (not in tree): {stale}")
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
            if who:
                c = ", ".join(f"`{w}`" for w in who[:3])
                if len(who) > 3:
                    c += f" +{len(who)-3}"
            else:
                c = role.get(f"{mod}.{name}", "**UNTAGGED**")
            lines.append(f"| `{name}` | {claim} | {ax} | {c} |")
        lines.append("")

    out = LEAN / "THEOREMS.md"
    out.write_text("\n".join(lines))
    uncited = [r for r in rows if not r[4]]
    untagged = [f"{m}.{n}" for m, n, _, _, w in rows
                if not w and f"{m}.{n}" not in role]
    nodoc = sum(1 for r in rows if not r[2])
    print(f"wrote {out.relative_to(ROOT)}")
    print(f"   {len(rows)} theorems, {len(totals)} modules")
    print(f"   {len(zero)} depend on no axioms")
    print(f"   {len(uncited)} uncited "
          f"({sum(1 for r in uncited if role.get(f'{r[0]}.{r[1]}')=='support')} support, "
          f"{sum(1 for r in uncited if role.get(f'{r[0]}.{r[1]}')=='record')} record, "
          f"{len(untagged)} UNTAGGED)")
    if untagged:
        for u in untagged:
            print(f"      UNTAGGED {u}")
    print(f"   {nodoc} have no docstring claim")


if __name__ == "__main__":
    sys.exit(main())
