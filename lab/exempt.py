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

THE CORPUS. The classes below are not invented. They are every non-measurement
number shape that occurs in the prose of `notes/lab_notebook_2.md` entry 302
(`weil_Lc_theory.py`) and entry 304 (`arrow_price.py`) -- the two entries the
brief names as the corpus, because a migrated unit is what those will look
like. Each class carries one REAL example, and `tests/test_phase2.py`
parametrizes over this table so that every class is tested positively (its own
example matches) and negatively (a lookalike that is a measurement does not).

BARE INTEGERS ARE STILL CHECKED. Measured against real pools, on integers
0..999 and on 1000 uniform invented values in the same range:

    pool                                  bare int   1 decimal   3 decimals
    analysis/2026-09-02/results/arrow_price.numbers (431 numeric)
                                             6.0%        1.5%         0.1%
    analysis/2026-09-01/results/weil_Lc_theory.numbers (4285 numeric)
                                             7.7%        3.4%         0.4%
    units/0000-smoke/values.tsv (4 numeric)
                                             0.5%        0.0%         0.0%

An integer check is 15-60x weaker than a three-decimal check and still refuses
92-94% of invented values, so it is not near-useless and dropping it is not
free. What it would cost: entry 302's prose states "15 of the 24 rows have a
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

Over entry 302 and entry 304 as they stand, this list exempts 32% and 74% of
the number tokens respectively. What survives in each is measurements plus
small structural integers from expressions written out in prose -- `2|B|`,
`w = 1/2`, `k = 1` -- and those are claims the pool can answer.

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

# En dash, em dash and the Unicode minus all appear in the corpus:
# `entries 257-271`, `lines 15-22`, `-0700` in a timestamp. Kept as bare
# characters, so that a class can be built as `[,{_DASHES}]` -- an earlier
# version wrapped them in brackets here and every regex that embedded it
# nested a character class inside another and silently stopped matching.
_DASHES = "-‐‑‒–—−"
_DASH = f"[{_DASHES}]"

_EXT = (r"py|md|json|numbers|log|txt|lean|csv|tsv|yml|yaml|toml|sh|cfg|ini"
        r"|lock|sha256")

_NAMED = (r"§|Lemma|Theorem|Thm|Corollary|Cor|Proposition|Prop|Conjecture"
          r"|Definition|Def|Remark|Section|Chapter|Figure|Fig|Table|Appendix"
          r"|Axiom|Step|Phase|Stage|Rule|Note|Item|Question|Answer|Part"
          r"|Volume|lines?|pages?")

CLASSES = [
    Klass(
        name="date",
        why="an ISO date or timestamp, in the front matter or in prose",
        example="2026-09-02T11:12:27",
        counter="12.5",
        pattern=re.compile(
            r"\b\d{4}-\d{2}-\d{2}"
            r"(?:[T ]\d{2}:\d{2}:\d{2}(?:\.\d+)?"
            rf"(?:\s*(?:Z|[+{_DASHES}]\d{{4}}))?)?"),
    ),
    Klass(
        name="unit-path",
        why="a unit id and slug wherever it appears, including inside a path",
        example="units/0003-smoke-again",
        counter="2026-09-02",
        pattern=re.compile(
            r"\bunits/\d{4,}\b"
            r"|\b\d{4,}-(?=[A-Za-z0-9]*[A-Za-z])[A-Za-z0-9]+"
            r"(?:[-_][A-Za-z0-9]+)*"),
    ),
    Klass(
        name="unit-or-entry-ref",
        why="a unit or notebook entry named by number, singly or as a range",
        example="unit 0305",
        counter="a width of 61",
        pattern=re.compile(
            rf"\b(?:units?|entry|entries)\s+\d+(?:\s*{_DASH}\s*\d+)?\b",
            re.I),
    ),
    Klass(
        name="refs-list",
        why="a `refs:` or `supersedes:` line, in front matter or restated",
        example="refs: 298, 299, 300, 301",
        counter="the refs: 298 mentioned mid-sentence",
        pattern=re.compile(r"^[ \t]*(?:refs|supersedes):.*$", re.M | re.I),
    ),
    Klass(
        name="hex",
        why="a sha256, a git sha, or any hex run -- full or truncated",
        example="47fa48680663df41146704d02a5b092d792bd5b9",
        counter="30610046000",
        pattern=re.compile(r"\b(?=[0-9a-f]*[a-f])[0-9a-f]{7,}\b"),
    ),
    Klass(
        name="version",
        why="a toolchain or package version",
        example="v4.32.2",
        counter="4.32",
        pattern=re.compile(r"\bv\d+(?:\.\d+)+\b"),
    ),
    Klass(
        name="file-cite",
        why="a Lean or file citation, `name.ext:NN` or `:NN-MM`",
        example="notes/lab_notebook_2.md:193-199",
        counter="analysis/2026-09-01/results/weil_Lc_theory.numbers",
        pattern=re.compile(
            rf"(?:\.(?:{_EXT})|(?<![\w.])(?:txt|log|md))"
            rf"\s*:\s*\d+(?:\s*[,{_DASHES}]\s*\d+)*"
            rf"|`:\d+(?:\s*[,{_DASHES}]\s*\d+)*`"),
    ),
    Klass(
        name="list-marker",
        why="an ordered-list marker at the start of a line",
        example="1. the height law is a regression",
        counter="1.77 is the fitted slope",
        pattern=re.compile(r"^[ \t]*\d+\.(?=\s)", re.M),
    ),
    Klass(
        name="enumerator",
        why="a parenthesised enumerator introducing a numbered point",
        example="(1) The height law is a regression",
        counter="(16,)",
        pattern=re.compile(r"\(\d{1,2}\)"),
    ),
    Klass(
        name="ident-digits",
        why="digits welded to an identifier: a label, a piece name, a stem",
        example="eq_13",
        counter="1e-16",
        pattern=re.compile(r"(?<=[A-Za-z_])\d+"),
    ),
    Klass(
        name="code-span",
        why=("a backticked key, path or identifier -- `notes/notes_format.md`"
             " § Rule puts the VALUE outside the backticks, so the span is the"
             " address"),
        example="`theory.k=10|eps=0.01.at_root.two_B2`",
        counter="`3.07`",
        pattern=re.compile(r"`(?=[^`\n]*[A-Za-z:])[^`\s]+`"),
    ),
    Klass(
        name="named-ref",
        why="a numbered reference introduced by a naming word",
        example="Theorem 1.4",
        counter="b = 1.77",
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
