"""The invariant: every number in a unit's prose appears in its values.tsv.

`analysis/2026-09-02/lab_design.md` § The invariant states it in one
sentence and settles two things this module would otherwise have to guess:

    "It covers the entry body and its fenced tables alike, since the check
     reads the file rather than a stripped copy of it."

so FENCED BLOCKS ARE READ. A number inside ```text is checked exactly like
a number in a paragraph. Every other checker in this tree strips fences
first (`utilities/check_refs.py`, `utilities/check_entry_numbers.py`); this
one does not, on the design's instruction.

    "Numbers that are not measurements -- dates, entry ids, line counts of
     the unit itself -- are exempt by pattern and the exemption list lives
     in the program."

PHASE 2 MOVED THE EXEMPTION LIST OUT OF THIS FILE. It is `lab/exempt.py`,
where each class carries its own docstring line and one real example from the
corpus, and this module holds no pattern of its own. Phase 0 wrote three
patterns here and recorded that a fourth was Phase 2's call; that call is made
in `lab/exempt.py`, together with the false accept Phase 1 deferred -- a unit
id inside a path, `units/0003-smoke-again`, matching a stored 3.070311505664645
by accident because a bare integer's tolerance is half a unit.

Why this discriminates: the design's § The one measurement records that
holding the matching rule fixed and varying only the pool, tree-wide
accepts most invented three-decimal values while one entry's own values
accepts almost none. The pool is one unit's values.tsv. That scoping is
the whole mechanism.

THE ROUNDING-AWARE COMPARISON IS COPIED, NOT IMPORTED. `NUM` and
`matches` below are a verbatim copy from
`utilities/check_entry_numbers.py`, which copied them in turn from
`utilities/check_values.py`. Copied because `lab` installs with
`pip install -e .` and runs from any working directory, while
`utilities/` is a directory of scripts rather than a package, resolves
its own repo paths at import, and is not on the installed program's
import path. An import would tie the installed console script to one
checkout. When the two drift, this file is the one the units answer to.

DECISIONS taken here where the design is silent:

  - Only `unit.md` is prose. `question.md` is a transcript bracket copied
    in verbatim (design § The unit), so its numbers are quoted rather than
    claimed, and holding a copy of a conversation to the invariant would
    make the fixture unwritable. `run/` is code and artifacts as produced.
  - The front matter is not prose. Its `id`, `date`, `refs` and
    `supersedes` are the exempt classes by construction, and scanning the
    block would only re-derive the exemption. The body begins after the
    closing `---`.
  - Every values.tsv value that parses as a number joins the pool,
    `meta.` keys included. The design excludes `meta.` from the DIGEST
    (§ The unit); it says nothing about excluding it from the pool, and a
    timing quoted in prose is still a number with evidence behind it.
  - PHASE 2b: A NUMBER INSIDE A STRING VALUE ALSO JOINS THE POOL. See the
    section below; the decision and what it costs are recorded there.
  - The prose sets the precision. `matches(want, have)` tolerates half a
    unit in the last place the PROSE states, so `0.0184` in the body
    matches `0.018401` in the file, `0.02` also matches it (two decimal
    places is what `0.018401` rounds to), and `0.03` does not.
  - An ordered-list marker (`1.`, `2.`) IS exempt as of Phase 2; the
    decision and its cost are in `lab/exempt.py`.
  - A finding is located by the bold lead-in above it, never by a line
    number, per the design's § Citations: "No line numbers anywhere, in
    any file."

PHASE 1 ADDED THE IMMUTABILITY GUARANTEE. A unit whose front matter says
`sealed: true` is also held to its `UNIT.sha256`: every file is rehashed,
every one that moved is reported, and the unit digest is recomputed. The
design's § Enforcement gives an edit to a sealed unit to a PreToolUse hook,
which is a Phase 7 concern and stops one agent in one session. The check is
where the guarantee belongs, because it runs at the commit gate over the
whole tree and it catches an edit whatever made it -- a hook that was off,
an editor, a merge, a `git checkout` of one file. A hook refuses a write;
the check is what makes the seal MEAN something afterwards.

  - Either failure alone is exit 1. A sealed unit that moved and a number
    without evidence are the same class of answer to the caller: this unit
    is not what it says it is.
  - The manifest is verified before the invariant is reported, because a
    moved file makes every number below it suspect.
  - `sealed: true` with no `UNIT.sha256` is a finding (exit 1) rather than
    an unloadable unit (exit 2). The unit loads; its claim to be sealed is
    what fails.
  - An UNSEALED unit carrying a `UNIT.sha256` is not checked against it.
    That state is what an in-progress `lab seal` leaves behind, and the
    front matter is the unit's own claim about itself.

PHASE 2b: NUMBERS INSIDE STRING VALUES ARE ADMITTED TO THE POOL.

Phase 2 admitted only values that parse as a number whole, and entry 307
recorded where that breaks. Of the 769 keys in
`analysis/2026-09-02/results/arrow_price.numbers`, 612 lines parse as a number
and 431 distinct values reach the pool; 99 lines are strings and 81 of those
hold digits.

That string count is a correction. Entry 307 wrote "157 are strings", and 157
is the number of lines that do NOT parse as a number — 99 strings plus 42
`false`, 11 `true` and 5 `null`. Counting them, from the repository root:

    python3 -c "import sys; sys.path.insert(0, '.'); \
        from lab.exempt import _read_pool_file as R; from lab.check import _decimal as D; \
        t = R('analysis/2026-09-02/results/arrow_price.numbers'); \
        print(len(t), sum(1 for v in t.values() if D(v) is not None), \
              sum(1 for v in t.values() if v.startswith('\"')))"
    769 612 99

Nothing else moves with it: 81 of the strings hold digits either way, and the
one constant with no numeric twin is the same constant.

Entry 304 states constants that live only inside them:
`inputs.Rmax_form` is the text "0.137 log T + 0.443 log log T + 4.35
(assumed)" and `consumers[0].t_req_expr` is "4.92*sqrt(x/log x) <= T, x > 59".
Three of those constants have numeric twins elsewhere in the same file, and
4.92 has none anywhere in the 431 -- so a migrated entry 304 would report
exactly one false finding, against a number whose evidence sits on a line of
its own values.tsv that the checker refused to read.

THE DECISION IS TO ADMIT THEM, and the argument is the invariant's own
wording. The design's § The invariant is "every number in a unit's prose
appears in that unit's values.tsv". 4.92 DOES appear in that file. A checker
that reports it missing is not enforcing the invariant; it is enforcing a
narrower one it never declared, and the difference falls on exactly the
constants a formula string is the natural home for. Refusing would leave a
unit no way to cite one: `lab values` generates values.tsv from the run's own
JSON, so a hand-added numeric twin would be overwritten on the next
`lab values`, and rewriting the producing script to emit every constant twice
is a change to the measurement in order to satisfy its checker.

WHAT IT BUYS THE OTHER WAY, MEASURED RATHER THAN ASSERTED. A string is free
text and its digits are not necessarily measurements, so the pool grows and
every added value is another accident a prose number can land on. Two
mitigations and then the number.

  - The exemption list is applied INSIDE the string, by `numbers_in_string`.
    A timestamp in a string value is an address exactly as it is in prose, so
    `"2026-09-02T00:00:00Z"` contributes nothing rather than contributing
    2026, 9 and 2. This is the whole reason the list lives in one module.
  - The summary line prints `+N in strings` whenever the widening is
    non-empty, so a reader sees how much of the pool came out of free text.
    A unit with no such value prints exactly what Phase 2 printed.

The cost, from `python3 -m lab.exempt rates --exact` over two real result
files (the fraction of invented values in [0, 1000) the pool accepts):

    pool                              values   bare int      1 dp      3 dp
    arrow_price.numbers, numbers only    431     6.000%    1.400%    0.030%
      + numbers inside string values     442     6.100%    1.430%    0.031%
    weil_Lc_theory.numbers, numbers      4285     7.700%    2.640%    0.166%
      + numbers inside string values     4333     7.700%    2.650%    0.167%

Eleven values added to one pool and 48 to the other, for a change in the
false-accept rate of at most a tenth of a percentage point, and none at all
on the larger pool's integer column. That is what the one real finding of
entry 304 costs to make checkable.

WHAT IT DOES NOT BUY. The digits admitted out of `"0.137 log T + 0.443 log
log T + 4.35 (assumed)"` are 0.137, 0.443 and 4.35 -- and the string also
declares "(assumed)". The pool cannot tell an assumed constant from a
measured one, here or anywhere else. A unit citing 4.35 gets evidence that
the number is in the file, which is all the invariant ever claimed; whether
it is the right number from the right row is the class of error the design's
§ What this does not fix names and leaves to adversarial review.

PHASE 2c ADDS TWO FINDINGS THAT ARE NOT ABOUT THE POOL.

  - A COUNT SPELLED IN WORDS. `lab check` scans digits, so `four runs` is
    invisible where `4 runs` resolves to a key -- the design's § Counts are
    written in digits. The number-word table, the closed noun list and the
    boundary judgement are `lab/counts.py`; this module reports what it
    returns and prints the digit form in the message.
  - A `follows:` THAT DOES NOT RESOLVE. The design's § What a unit declares
    makes `follows:` the field everything else is computed from, and Phase 2c
    builds the field and its validation only: it names an existing unit, and
    a unit does not follow itself. Walking it, forking, gaps and segments are
    Phase 4 and nothing here computes them.

Both are exit 1, for the same reason a moved file is: the unit is not what it
says it is. A unit with no `follows:` key is not checked against one -- the
key is written by `lab new` from Phase 2c onward, and the fixtures predate it.

A CORRECTION'S EVIDENCE IS A PRACTICE, NOT A MECHANISM. Unit 0308 records that
a superseded figure -- one produced by code that no longer exists -- had to be
recovered by reading it out of prose, and that a corrected number never
written down anywhere would have no route at all. The design's new
§ A correction reads its predecessor states what to do, and it is deliberately
not enforced here: the pool is scoped to one unit, which is the whole
mechanism (§ The one measurement), and a checker that resolved a corrected
figure against some other artifact would be the tree-wide pool that
measurement refused.
"""

import json
import re
from decimal import Decimal, InvalidOperation

from . import counts as counts_mod
from . import digest as digest_mod
from . import exempt as exempt_mod
from .unit import UnitError, load, units_of

__all__ = ["check", "run", "matches", "findings", "word_counts",
           "follows_problems", "NUM"]

# Copied from utilities/check_entry_numbers.py (NUM, matches). See the module
# docstring for why this is a copy rather than an import.
NUM = re.compile(r"-?\d{1,3}(?:,\d{3})+(?:\.\d+)?|-?\d+(?:\.\d+)?(?:[eE]-?\d+)?")


def matches(want, have):
    """want appears in have, at want's own precision."""
    exp = want.as_tuple().exponent
    places = -exp if isinstance(exp, int) and exp < 0 else 0
    tol = Decimal(5).scaleb(-places - 1)      # half a unit in the last stated place
    return any(abs(v - want) <= tol for v in have)
# end of copy

# The exemption list the design says lives in the program is `lab/exempt.py`.
LEAD_IN = re.compile(r"^\*\*(.+?)\*\*", re.M)          # a section's bold lead-in


def _decimal(text):
    """`text` as a Decimal, or None."""
    try:
        return Decimal(text.replace(",", ""))
    except (InvalidOperation, ValueError):
        return None


def numbers_in_string(text):
    """Every number inside a string VALUE, addresses removed.

    PHASE 2b. The exemption list is applied to the string exactly as it is
    applied to prose, and for the same reason: a timestamp inside a string
    value is an address, and admitting `2026`, `09` and `02` out of
    `"2026-09-02T00:00:00Z"` would hand the pool three numbers that measure
    nothing. `lab/exempt.py` already knows which shapes those are, so this
    reuses it rather than growing a second list.
    """
    covered = exempt_mod.spans(text)
    out = set()
    for m in NUM.finditer(text):
        if any(lo <= m.start() < hi for lo, hi in covered):
            continue
        value = _decimal(m.group(0))
        if value is not None:
            out.add(value)
    return out


def pool_parts(values):
    """(numbers stored as numbers, numbers found inside string values).

    The two are returned apart so the summary line can say how much of the
    pool came out of free text, which is the widening PHASE 2b bought and the
    thing a reader should be able to see.
    """
    numeric, from_strings = set(), set()
    for raw in values.values():
        whole = _decimal(raw)
        if whole is not None:
            numeric.add(whole)
            continue
        text = raw
        if len(raw) >= 2 and raw[0] == '"' and raw[-1] == '"':
            try:
                text = json.loads(raw)
            except ValueError:
                text = raw
        if isinstance(text, str):
            from_strings |= numbers_in_string(text)
    return numeric, from_strings


def _pool(values):
    """The unit's numeric evidence: every number `values.tsv` holds."""
    numeric, from_strings = pool_parts(values)
    return numeric | from_strings


def _section(body, pos):
    """The bold lead-in a position sits under, or '-' above the first one."""
    last = None
    for m in LEAD_IN.finditer(body, 0, pos):
        last = m.group(1)
    return last.rstrip(".").strip() if last else "-"


def _snippet(body, start, end, width=64):
    """The finding's line, squeezed to one line and trimmed around the hit."""
    lo = body.rfind("\n", 0, start) + 1
    hi = body.find("\n", end)
    hi = len(body) if hi < 0 else hi
    line = " ".join(body[lo:hi].split())
    if len(line) <= width:
        return line
    hit = " ".join(body[start:end].split())
    at = line.find(hit)
    at = 0 if at < 0 else max(0, at - width // 3)
    trimmed = line[at:at + width]
    return ("..." if at else "") + trimmed + ("..." if at + width < len(line) else "")


def findings(unit):
    """[(token, section, snippet)] for every prose number with no evidence.

    Also returns the number of prose numbers scanned and the number the
    exemption list removed, so the summary can report how much the pool
    actually covered and how much never reached it.
    """
    body, pool, ids = unit.body, _pool(unit.values), unit.ids
    spans = exempt_mod.spans(body)
    out, scanned, exempted = [], 0, 0
    for m in NUM.finditer(body):
        if any(lo <= m.start() < hi for lo, hi in spans):
            exempted += 1                              # `lab/exempt.py` CLASSES
            continue
        token = m.group(0)
        if exempt_mod.refs_id(token, ids):
            exempted += 1                              # this unit's id, or one it names
            continue
        scanned += 1
        try:
            want = Decimal(token.replace(",", ""))
        except InvalidOperation:
            out.append((token, _section(body, m.start()),
                        _snippet(body, m.start(), m.end())))
            continue
        if not matches(want, pool):
            out.append((token, _section(body, m.start()),
                        _snippet(body, m.start(), m.end())))
    return out, scanned, exempted


def word_counts(unit):
    """[(phrase, digit form, section, snippet)] for counts spelled in words.

    The design's § Counts are written in digits. `lab/counts.py` owns the
    table and the boundary; the exemption spans are passed in so that a
    number-word inside a backticked key or a path is an address here exactly
    as a digit is.
    """
    body = unit.body
    out = []
    for phrase, digits, start, end in counts_mod.findings(
            body, skip=exempt_mod.spans(body)):
        out.append((phrase, digits, _section(body, start),
                    _snippet(body, start, end)))
    return out


def follows_problems(unit):
    """[problem, ...] for a `follows:` that does not resolve. Empty is clean.

    Two rules and no more, per the design's § What a unit declares: the value
    names a unit that exists, and a unit does not follow itself. Walking the
    field is Phase 4.
    """
    value = unit.front_matter.get("follows")
    if value is None:
        return []
    if not isinstance(value, str):
        return [f"FOLLOWS    {value!r} is not a single unit id"]
    if value == str(unit.id):
        return [f"FOLLOWS    {value} is this unit's own id; a unit does not "
                f"follow itself"]
    known = units_of(unit.path.parent)
    if value not in known:
        return [f"FOLLOWS    {value} is not a unit under {unit.path.parent}"]
    return []


def check(arg, out, cwd=None):
    """Run the invariant over one unit. Returns 0 clean, 1 a finding.

    A finding is a number in the prose with no evidence, or a sealed unit
    whose files no longer match its `UNIT.sha256`.

    Raises `UnitError` when the unit cannot be loaded; the caller turns
    that into exit 2.
    """
    unit = load(arg, cwd=cwd)
    moved = digest_mod.verify(unit.path) \
        if unit.front_matter.get("sealed") is True else []
    for problem in moved:
        print(problem, file=out)
    unmatched, scanned, exempted = findings(unit)
    for token, section, snippet in unmatched:
        print(f"UNMATCHED  {token:<14} § {section}  |  {snippet}", file=out)
    spelled = word_counts(unit)
    for phrase, digits, section, snippet in spelled:
        print(f"DIGITS     {phrase:<14} § {section}  |  {snippet}"
              f"  ->  write `{digits}`", file=out)
    bad_follows = follows_problems(unit)
    for problem in bad_follows:
        print(problem, file=out)
    numeric, from_strings = pool_parts(unit.values)
    # An unsealed unit's summary says nothing about a seal, which keeps the
    # line the Phase 0 tests read exactly as Phase 0 wrote it. The same is
    # true of the string clause: a unit whose values.tsv holds no number
    # inside a string prints exactly what Phase 2 printed.
    seal_state = ""
    if unit.front_matter.get("sealed") is True:
        seal_state = ("; sealed and unchanged" if not moved
                      else f"; sealed, {len(moved)} problem(s)")
    extra = from_strings - numeric
    in_strings = f" +{len(extra)} in strings" if extra else ""
    # The two Phase 2c clauses appear only when they are non-empty, so a unit
    # with neither prints exactly the line Phase 2b printed.
    spelled_clause = (f", {len(spelled)} count(s) spelled in words"
                      if spelled else "")
    follows_clause = (f", {len(bad_follows)} follows problem(s)"
                      if bad_follows else "")
    print(f"{unit.path}: {scanned} number(s) in prose, "
          f"{scanned - len(unmatched)} matched, {len(unmatched)} unmatched "
          f"({exempted} exempt){spelled_clause}{follows_clause}; "
          f"values.tsv: {len(unit.values)} key(s), {len(numeric)} numeric"
          f"{in_strings}{seal_state}",
          file=out)
    return 1 if (unmatched or moved or spelled or bad_follows) else 0


def run(arg, out, err, cwd=None):
    """`lab check <unit>`: 0 clean, 1 unmatched, 2 unloadable."""
    try:
        return check(arg, out, cwd=cwd)
    except UnitError as exc:
        print(f"lab check: {exc}", file=err)
        return 2
