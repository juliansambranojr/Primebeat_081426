"""The exemption list: the number shapes in a unit's prose that are ADDRESSES.

PHASE 2 of `analysis/2026-09-02/lab_design.md`. Its § The invariant says:

    "Numbers that are not measurements -- dates, entry ids, line counts of the
     unit itself -- are exempt by pattern and the exemption list lives in the
     program."

Phase 0 read that as three classes and wrote three patterns into
`lab/check.py`, with a note that a fourth was Phase 2's call. This module is
that call, and it is where the whole list lives now: `lab/check.py` holds no
pattern of its own.

WHY THIS IS NOT A PATCH. A number in prose is checked by
`lab.check.matches`, which tolerates half a unit in the last place the PROSE
states. A bare integer therefore carries a tolerance of 0.5, so ANY stored
value within half a unit of it satisfies it. That is not a defect in the
comparison -- it is what "0.0184 matches 0.018401" requires -- but it means an
address that happens to look like a small integer is accepted silently, with
no finding and no trace, and the reader is told the unit checks clean.

The reproduction Phase 1 deferred, run against `units/0000-smoke`:

    prose  `units/0003-smoke-again`      -> token 0003 -> Decimal 3, tol 0.5
    pool   3.070311505664645             -> |3.0703 - 3| = 0.0703 <= 0.5
    result MATCHED, silently: 8 number(s) in prose, 5 matched, 3 unmatched

A unit id is an identity. It has no business being compared to a measurement
at all, and the fix is to stop scanning it, not to tighten the comparison.

THE CORPUS. The classes below are not invented. Every one of them exempts a
non-measurement number shape that occurs in the prose of
`notes/lab_notebook_2.md` entry 302 (`weil_Lc_theory.py`) and entry 304
(`arrow_price.py`) -- the two entries the brief named as the corpus, because a
migrated unit is what those will look like -- WITH THREE EXCEPTIONS, stated
because the earlier wording claimed otherwise: `version`, `list-marker` and,
since PHASE 2b tightened it, `unit-path` match nothing at all in those two
entries, and their examples come from elsewhere in the tree. Each class carries
one REAL example and one or more counter-examples, and `tests/test_phase2.py`
parametrizes over this table so that every class is tested positively (its own
example matches) and negatively (each lookalike that is a measurement does not).

THE COMMANDS. Every number in this docstring is printed by one of these, from
the repository root. They are the whole reason the figures below can be
checked rather than believed:

    python3 -m lab.exempt corpus notes/lab_notebook_2.md \
        --entry 302 --entry 304 [--tokens]

    python3 -m lab.exempt rates [--exact] [--seed 20260902] \
        analysis/2026-09-02/results/arrow_price.numbers \
        analysis/2026-09-01/results/weil_Lc_theory.numbers \
        units/0000-smoke/values.tsv

BARE INTEGERS ARE STILL CHECKED. `rates --exact`, which computes the fraction
of invented values in [0, 1000) a pool accepts over EVERY grid value at that
precision rather than sampling it:

    pool                                       values  bare int    1 dp    3 dp
    analysis/2026-09-02/results/arrow_price.numbers
                                                  431    6.000%  1.400%  0.030%
    analysis/2026-09-01/results/weil_Lc_theory.numbers
                                                 4285    7.700%  2.640%  0.166%
    units/0000-smoke/values.tsv                     4    0.500%  0.040%  0.000%

PHASE 2b REPLACED THIS TABLE AND THREE OF ITS FIGURES MOVED. The version
Phase 2 wrote came from an unseeded draw and did not reproduce: entry 307
recorded a re-draw giving 1.8%/2.6%/0.0%/0.2% where the table said
1.5%/3.4%/0.1%/0.4%, same magnitudes and different digits. The 1000-draw
column was the wrong instrument for the three-decimal case, where the true
rate is a few hundredths of a percent and a thousand draws resolve only "0.0%
or 0.1%". The integer column is unmoved, because it was never a draw -- it is
all 1000 integers.

One claim in the old table was wrong rather than imprecise. "An integer check
is 15-60x weaker than a three-decimal check" came from the noisy column; the
exact ratios are 46x on the 4285-value pool and 200x on the 431-value one. The
surviving half of the claim holds: an integer check still refuses 92-94% of
invented values, so it is not near-useless and dropping it is not free.

What dropping it would cost: entry 302's prose states "15 of the 24 rows have a
fixed-window L_c inside the grid; 9 have none", root counts "full 15,
near_only 15, far_only_exact 24, far_only_bound 21", `n_near` 7,
`params.M_instrument` 16 and `params.n_zeros` 100000 -- every one an integer,
every one a count or an inventory, and the design's own second measurement
(§ The one measurement) records that of every fact that drifted across three
project trees, ALL were counts, inventories or statuses. Exempting integers
would leave the largest measured defect class unchecked by the one mechanism
built to catch it.

What checking them still costs, stated plainly: 6-8% of invented integers pass
against a real pool, and every one of those is a false accept the reader
cannot see. Three residues survive this list, measured over the corpus:

  - A small integer near a stored value passes -- a claim of "3 rungs"
    against a stored ratio of 3.07.
  - A bare numeric range with no introducing word passes. Entry 302 writes
    "cited the traceback at log lines 15-22; it is at 14-21", and the second
    range has neither `lines` before it nor a file citation attached, so it
    is scanned. Adding a class for "a range near a range" would exempt real
    intervals, so this one is left as a finding a reader dismisses.
  - An address shape not enumerated here passes the same way, which is why a
    new shape is added to this table with its example rather than
    special-cased at the call site.

Over entry 302 and entry 304 as they stand, `corpus` reports that this list
exempts 414 of 1301 number tokens (31.8%) and 248 of 331 (74.9%). What
survives in each is measurements plus small structural integers from
expressions written out in prose -- `2|B|`, `w = 1/2`, `k = 1` -- and those
are claims the pool can answer.

THE FALSE EXEMPTION PHASE 2b CLOSED, and why a false exemption is worse than a
false accept. A false accept leaves the number visible in the scanned column;
a false exemption removes it from the scan, so it is never compared to
anything and never appears in a count a reader could question.

`unit-path`'s second alternative was a bare four-or-more-digit id, a hyphen
and a slug, with nothing required around it. Over the corpus it matched
exactly two tokens, and both were measurements:

    entry 302  "U1 Psi closed form against 8000-node Gauss-Legendre quadrature"
    entry 302  "the 24000-point values agree to 1e-4 relative"

Both are grid sizes -- counts -- which is the class the design's § The one
measurement names as the one every drifted fact belonged to. The class now
requires a PATH position: `units/<id>`, an id-and-slug after a slash, or one
before a slash. `8000-node` and `24000-point` are its counter-examples and
`tests/test_phase2.py` holds them scanned in the sentences above.

    corpus, before   entry 302  416 exempt (32.0%),  885 scanned
                     entry 304  248 exempt (74.9%),   83 scanned
    corpus, after    entry 302  414 exempt (31.8%),  887 scanned
                     entry 304  248 exempt (74.9%),   83 scanned

THE OTHER ELEVEN, AUDITED THE SAME WAY. Running `corpus --tokens` and, for
each class, recomputing the spans with that class removed gives the tokens
whose exemption depends on it alone. Of the twelve, `version` and
`list-marker` match nothing in either entry; `file-cite` matches 55 times and
is load-bearing for no token, every one of them also being inside a
`code-span`; and the remaining eight exempt only addresses -- dates and
timestamp fields, `entry NNN` citations, front-matter `refs:` lines, git
shas, list enumerators, digits welded to identifiers (`R2`, `L2`, `sha256`,
`python3`, `h10`, `U1`), backticked result keys including the parameter
coordinates inside them (`theory.k=10|eps=0.01...`), and numbered theorems
(`Conjecture 4.1`, `Theorem 1.4`, `Section 0`, `lines 15-22`). No second
false exemption exists in this corpus.

WHAT IS NOT EXEMPT, DELIBERATELY. A bare decimal, a number with a unit suffix
(`12.5 s`), a parameter written with `=` outside backticks (`M = 16`, `k = 10`),
and a number inside backticks that is only a number (`` `3.07` ``). Those are
claims and they stay claims.

ONE CLASS IS NOT A PATTERN. `refs_id` below is a function rather than a regex,
because it depends on the unit rather than on the text: a bare `0001` in the
prose of a unit whose front matter reads `refs: [0001]` is that unit's own
address. Phase 0 put this in `lab/check.py`; it is here so that "the exemption
list lives in one place" is literally true.
"""

import re
from collections import namedtuple

__all__ = ["Klass", "CLASSES", "spans", "classify", "refs_id"]

Klass = namedtuple("Klass", "name why example counter pattern")
# `counter` is a TUPLE of one or more lookalikes that must stay checked, not a
# single string. PHASE 2b widened it: `unit-path` needed two counter-examples
# at once (`8000-node` and `24000-point`, the false exemption that phase found)
# and a table with room for exactly one counter would have dropped one of them.
# `tests/test_phase2.py` parametrizes over every (class, counter) pair.

# En dash, em dash and the Unicode minus all appear in the corpus:
# `entries 257-271`, `lines 15-22`, `-0700` in a timestamp. Kept as bare
# characters, so that a class can be built as `[,{_DASHES}]` -- an earlier
# version wrapped them in brackets here and every regex that embedded it
# nested a character class inside another and silently stopped matching.
_DASHES = "-‐‑‒–—−"
_DASH = f"[{_DASHES}]"

_EXT = (r"py|md|json|numbers|log|txt|lean|csv|tsv|yml|yaml|toml|sh|cfg|ini"
        r"|lock|sha256")

# A unit directory name: four-or-more digits, a hyphen, and a slug carrying at
# least one letter. PHASE 2b: this fragment is only ever used with a slash on
# one side of it. Standing alone it also matched `8000-node` and
# `24000-point` -- grid sizes in entry 302's prose, which are counts, which is
# the class the design's § The one measurement names as the one that drifts.
_SLUGGED = (r"\d{4,}-(?=[A-Za-z0-9]*[A-Za-z])[A-Za-z0-9]+"
            r"(?:[-_][A-Za-z0-9]+)*")

_NAMED = (r"§|Lemma|Theorem|Thm|Corollary|Cor|Proposition|Prop|Conjecture"
          r"|Definition|Def|Remark|Section|Chapter|Figure|Fig|Table|Appendix"
          r"|Axiom|Step|Phase|Stage|Rule|Note|Item|Question|Answer|Part"
          r"|Volume|lines?|pages?")

CLASSES = [
    Klass(
        name="date",
        why="an ISO date or timestamp, in the front matter or in prose",
        example="2026-09-02T11:12:27",
        counter=("12.5",),
        pattern=re.compile(
            r"\b\d{4}-\d{2}-\d{2}"
            r"(?:[T ]\d{2}:\d{2}:\d{2}(?:\.\d+)?"
            rf"(?:\s*(?:Z|[+{_DASHES}]\d{{4}}))?)?"),
    ),
    Klass(
        name="unit-path",
        why=("a unit address -- a four-or-more-digit id, a hyphen and a slug"
             " -- in a PATH position: after a slash, or before one"),
        example="units/0003-smoke-again",
        counter=("2026-09-02", "8000-node", "24000-point"),
        pattern=re.compile(
            r"\bunits/\d{4,}\b"
            rf"|(?<=/){_SLUGGED}"
            rf"|\b{_SLUGGED}(?=/)"),
    ),
    Klass(
        name="unit-or-entry-ref",
        why="a unit or notebook entry named by number, singly or as a range",
        example="unit 0305",
        counter=("a width of 61",),
        pattern=re.compile(
            rf"\b(?:units?|entry|entries)\s+\d+(?:\s*{_DASH}\s*\d+)?\b",
            re.I),
    ),
    Klass(
        name="refs-list",
        why="a `refs:` or `supersedes:` line, in front matter or restated",
        example="refs: 298, 299, 300, 301",
        counter=("the refs: 298 mentioned mid-sentence",),
        pattern=re.compile(r"^[ \t]*(?:refs|supersedes):.*$", re.M | re.I),
    ),
    Klass(
        name="hex",
        why="a sha256, a git sha, or any hex run -- full or truncated",
        example="47fa48680663df41146704d02a5b092d792bd5b9",
        counter=("30610046000",),
        pattern=re.compile(r"\b(?=[0-9a-f]*[a-f])[0-9a-f]{7,}\b"),
    ),
    Klass(
        name="version",
        why="a toolchain or package version",
        example="v4.32.2",
        counter=("4.32",),
        pattern=re.compile(r"\bv\d+(?:\.\d+)+\b"),
    ),
    Klass(
        name="file-cite",
        why="a Lean or file citation, `name.ext:NN` or `:NN-MM`",
        example="notes/lab_notebook_2.md:193-199",
        counter=("analysis/2026-09-01/results/weil_Lc_theory.numbers",),
        pattern=re.compile(
            rf"(?:\.(?:{_EXT})|(?<![\w.])(?:txt|log|md))"
            rf"\s*:\s*\d+(?:\s*[,{_DASHES}]\s*\d+)*"
            rf"|`:\d+(?:\s*[,{_DASHES}]\s*\d+)*`"),
    ),
    Klass(
        name="list-marker",
        why="an ordered-list marker at the start of a line",
        example="1. the height law is a regression",
        counter=("1.77 is the fitted slope",),
        pattern=re.compile(r"^[ \t]*\d+\.(?=\s)", re.M),
    ),
    Klass(
        name="enumerator",
        why="a parenthesised enumerator introducing a numbered point",
        example="(1) The height law is a regression",
        counter=("(16,)",),
        pattern=re.compile(r"\(\d{1,2}\)"),
    ),
    Klass(
        name="ident-digits",
        why="digits welded to an identifier: a label, a piece name, a stem",
        example="eq_13",
        counter=("1e-16",),
        pattern=re.compile(r"(?<=[A-Za-z_])\d+"),
    ),
    Klass(
        name="code-span",
        why=("a backticked key, path or identifier -- `notes/notes_format.md`"
             " § Rule puts the VALUE outside the backticks, so the span is the"
             " address"),
        example="`theory.k=10|eps=0.01.at_root.two_B2`",
        counter=("`3.07`",),
        pattern=re.compile(r"`(?=[^`\n]*[A-Za-z:])[^`\s]+`"),
    ),
    Klass(
        name="named-ref",
        why="a numbered reference introduced by a naming word",
        example="Theorem 1.4",
        counter=("b = 1.77",),
        pattern=re.compile(
            rf"\b(?:{_NAMED})\s*\.?\s*\d+(?:\.\d+)*"
            rf"(?:\s*{_DASH}\s*\d+(?:\.\d+)*)?"),
    ),
]

_BY_NAME = {k.name: k for k in CLASSES}


def spans(text):
    """Character ranges the exemption list removes from the scan, merged.

    Overlaps are expected -- `2026-09-02` inside a path is both a `date` and
    part of a `code-span` -- and merging keeps the caller's containment test a
    single pass.
    """
    raw = sorted(m.span()
                 for klass in CLASSES
                 for m in klass.pattern.finditer(text))
    merged = []
    for lo, hi in raw:
        if merged and lo <= merged[-1][1]:
            merged[-1][1] = max(merged[-1][1], hi)
        else:
            merged.append([lo, hi])
    return [(lo, hi) for lo, hi in merged]


def classify(text, pos):
    """The name of the class exempting `pos`, or None. For reports and tests."""
    for klass in CLASSES:
        for m in klass.pattern.finditer(text):
            if m.start() <= pos < m.end():
                return klass.name
    return None


def refs_id(token, ids):
    """The one class that is not a pattern: this unit's id, or one it names.

    `ids` is `lab.unit.Unit.ids` -- the unit's own `id` plus every entry of
    its `refs:` and `supersedes:`. A bare `0001` in the prose of a unit whose
    front matter reads `refs: [0001]` is an address; the same token in a unit
    that names nothing is a claim and stays checked.
    """
    return token in ids


# --- the measurement entrypoint ---------------------------------------------
#
# PHASE 2b. Everything the docstring above claims as a number is produced by
# one of the two subcommands below, from a seeded draw, so a reader can
# reproduce the table rather than trust it. See § THE COMMANDS in the
# docstring for the exact invocations and their recorded output.

_HEADING = "^## .*Entry {}\\b"


def entry_body(text, number):
    """The prose of one `## ... Entry N ...` notebook entry, header included.

    The header line is PART of the entry for this measurement: entry 307's
    own dry run counted it, and its numbers reproduce only with it in. That
    is also the right reading -- a notebook header states measurements, and
    a migrated unit's `title:` would carry the same sentence.
    """
    import re as _re
    lines = text.split("\n")
    start = None
    for i, line in enumerate(lines):
        if _re.match(_HEADING.format(number), line):
            if start is not None:
                raise ValueError(f"entry {number} heads more than one section")
            start = i
    if start is None:
        raise ValueError(f"no `## ... Entry {number} ...` heading")
    for j in range(start + 1, len(lines)):
        if lines[j].startswith("## "):
            return "\n".join(lines[start:j])
    return "\n".join(lines[start:])


def scan(text):
    """(every number token, the subset the exemption list removes)."""
    from .check import NUM
    covered = spans(text)
    tokens = list(NUM.finditer(text))
    removed = [m for m in tokens
               if any(lo <= m.start() < hi for lo, hi in covered)]
    return tokens, removed


def _read_pool_file(path):
    """A `key<TAB>value` table -- a `.numbers` file or a `values.tsv`."""
    import pathlib as _pathlib
    table = {}
    for line in _pathlib.Path(path).read_text(encoding="utf-8").split("\n"):
        if not line.strip() or line.startswith("#") or "\t" not in line:
            continue
        key, value = line.split("\t", 1)
        table[key] = value.strip()
    return table


def _cmd_corpus(args):
    import pathlib as _pathlib
    from collections import Counter

    text = _pathlib.Path(args.notebook).read_text(encoding="utf-8")
    per_class = {}
    print(f"corpus     {args.notebook}")
    for number in args.entry:
        body = entry_body(text, number)
        tokens, removed = scan(body)
        pct = 100.0 * len(removed) / len(tokens) if tokens else 0.0
        print(f"entry {number}  {len(tokens)} token(s), {len(removed)} exempt "
              f"({pct:.1f}%), {len(tokens) - len(removed)} scanned")
        counts = Counter()
        for m in removed:
            counts[classify(body, m.start()) or "(none)"] += 1
        per_class[number] = counts
        if args.tokens:
            seen = {}
            for klass in CLASSES:
                for m in klass.pattern.finditer(body):
                    if classify(body, m.start()) == klass.name:
                        seen.setdefault(klass.name, Counter())[m.group(0)] += 1
            for klass in CLASSES:
                hits = seen.get(klass.name)
                if not hits:
                    continue
                print(f"  -- {klass.name} ({sum(hits.values())} match(es), "
                      f"{len(hits)} distinct)")
                for token, n in sorted(hits.items(), key=lambda kv: -kv[1]):
                    flat = " ".join(token.split())
                    print(f"     {n:>4}  {flat[:96]}")
    names = [k.name for k in CLASSES]
    head = "".join(f"{n:>8}" for n in args.entry)
    print(f"\n{'class':<18}{head}{'both':>8}")
    for name in names:
        row = [per_class[n].get(name, 0) for n in args.entry]
        print(f"{name:<18}" + "".join(f"{v:>8}" for v in row)
              + f"{sum(row):>8}")
    return 0


def exact_rate(pool, places, span):
    """The EXACT fraction of `places`-decimal values in [0, span) accepted.

    No draw at all. An invented value stated to `places` decimals carries a
    tolerance of half a step, so each stored value accepts one or two grid
    points and the accepted set is computable rather than estimated. This
    exists because the three-decimal column of a 1000-draw table is noise: a
    431-value pool accepts at most 862 of the million grid points in [0,1000),
    which a thousand draws resolve only to "0.0% or 0.1%", and the docstring's
    claim that an integer check is far weaker than a three-decimal one rests
    on exactly that column.
    """
    from decimal import Decimal

    step = Decimal(10) ** places
    top = int(span * step)
    hit = set()
    for value in pool:
        scaled = value * step
        lo = int((scaled - Decimal("0.5")).to_integral_value(rounding="ROUND_CEILING"))
        hi = int((scaled + Decimal("0.5")).to_integral_value(rounding="ROUND_FLOOR"))
        for k in range(max(0, lo), min(hi, top - 1) + 1):
            hit.add(k)
    return 100.0 * len(hit) / top


def _cmd_rates(args):
    import random as _random
    from decimal import Decimal

    from .check import matches, pool_parts

    rng = _random.Random(args.seed)
    ints = [Decimal(n) for n in range(args.integers)]
    draws = {places: [Decimal(f"%.{places}f" % rng.uniform(0, args.integers))
                      for _ in range(args.draws)]
             for places in args.places}

    cols = "".join(f"{('%dp' % p) if p else 'int':>10}"
                   for p in [0] + list(args.places))
    if args.exact:
        print(f"EXACT -- every {args.places}-decimal value in "
              f"[0, {args.integers}), no draw")
    else:
        print(f"seed {args.seed}, {args.integers} integer(s), "
              f"{args.draws} draw(s) per decimal column")
    print(f"{'pool':<52}{'values':>8}{cols}")
    for path in args.pool:
        table = _read_pool_file(path)
        numeric, from_strings = pool_parts(table)
        for label, pool in (("", numeric),
                            ("  + numbers inside string values",
                             numeric | from_strings)):
            if label and not (from_strings - numeric):
                continue
            if args.exact:
                cells = [exact_rate(pool, places, args.integers)
                         for places in [0] + list(args.places)]
            else:
                cells = [100.0 * sum(1 for v in ints if matches(v, pool))
                         / len(ints)]
                for places in args.places:
                    got = draws[places]
                    cells.append(100.0 * sum(1 for v in got
                                             if matches(v, pool)) / len(got))
            print(f"{label or path:<52}{len(pool):>8}"
                  + "".join(f"{c:>9.3f}%" for c in cells))
    return 0


def main(argv=None):
    import argparse as _argparse
    import sys as _sys

    parser = _argparse.ArgumentParser(
        prog="python3 -m lab.exempt",
        description="Measurements behind lab/exempt.py's recorded decisions.")
    subs = parser.add_subparsers(dest="command", required=True)

    sub = subs.add_parser("corpus", help="exempt fractions over notebook entries")
    sub.add_argument("notebook")
    sub.add_argument("--entry", type=int, action="append", required=True)
    sub.add_argument("--tokens", action="store_true",
                     help="dump every distinct token each class exempts")
    sub.set_defaults(fn=_cmd_corpus)

    sub = subs.add_parser("rates", help="invented-value accept rate per pool")
    sub.add_argument("pool", nargs="+", help="a .numbers file or a values.tsv")
    sub.add_argument("--seed", type=int, default=20260902)
    sub.add_argument("--draws", type=int, default=1000)
    sub.add_argument("--integers", type=int, default=1000)
    sub.add_argument("--places", type=int, nargs="+", default=[1, 3])
    sub.add_argument("--exact", action="store_true",
                     help="compute the rate over every grid value, no draw")
    sub.set_defaults(fn=_cmd_rates)

    args = parser.parse_args(_sys.argv[1:] if argv is None else argv)
    return args.fn(args)


if __name__ == "__main__":
    import sys as _sys

    _sys.exit(main())
