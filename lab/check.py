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
import pathlib
import re
from decimal import Decimal, InvalidOperation

from . import counts as counts_mod
from . import digest as digest_mod
from . import exempt as exempt_mod
from . import logsections
from .unit import UnitError, load, units_of

__all__ = ["check", "run", "matches", "findings", "word_counts",
           "follows_problems", "provenance_problems", "nan_findings",
           "citation_findings", "structure_findings", "question_problems",
           "NUM"]

# Copied from utilities/check_entry_numbers.py (NUM, matches). See the module
# docstring for why this is a copy rather than an import.
NUM = re.compile(r"-?\d{1,3}(?:,\d{3})+(?:\.\d+)?|-?\d+(?:\.\d+)?(?:[eE]-?\d+)?")


def matches(want, have):
    """want appears in have, at want's own precision."""
    exp = want.as_tuple().exponent
    places = -exp if isinstance(exp, int) and exp < 0 else 0
    tol = Decimal(5).scaleb(-places - 1)      # half a unit in the last stated place
    return any(v.is_finite() and abs(v - want) <= tol for v in have)
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
    # Digits inside an inline code span are formula, not measurement:
    # `(h/2)²`, `Σ_{j=1}^{m}`. The keyed convention puts the measured digit
    # OUTSIDE the span (`key` 3), so it is still scanned. Unit 0338.
    spans = spans + [(m.start(), m.end()) for m in INLINE_CODE.finditer(body)]
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


REF_LEAN = re.compile(r"^(lean(?:_stage3)?/.+\.lean)::(\S+)$")
LEAN_DECL = re.compile(r"^(?:theorem|lemma|def|noncomputable def)\s+(\S+)")


def refs_problems(unit):
    """[problem, ...] for refs that are empty or don't resolve. Empty is clean.

    Rules:
      - refs: [] is a finding. Every unit must either map to a lean theorem
        or explicitly say refs: [none].
      - A ref matching lean/File.lean::name must point at a file that exists
        and contain a declaration of that name.
    """
    refs = unit.front_matter.get("refs")
    if refs is None:
        return []
    if isinstance(refs, list) and len(refs) == 0:
        return ["REFS       refs is empty; map to a lean theorem "
                "(lean/File.lean::name) or write refs: [none]"]
    if not isinstance(refs, list):
        return [f"REFS       refs must be a list, got {refs!r}"]
    repo = unit.path.resolve()
    while True:
        if (repo / "lean").is_dir():
            break
        parent = repo.parent
        if parent == repo:
            return []
        repo = parent
    problems = []
    for ref in refs:
        if ref == "none":
            continue
        m = REF_LEAN.match(ref)
        if not m:
            problems.append(f"REFS       {ref} does not match "
                            f"lean/File.lean::name or lean_stage3/File.lean::name")
            continue
        filepath, name = repo / m.group(1), m.group(2)
        if not filepath.is_file():
            problems.append(f"REFS       {ref}: file {m.group(1)} not found")
            continue
        found = False
        for line in filepath.read_text(encoding="utf-8").splitlines():
            dm = LEAN_DECL.match(line.strip())
            if dm and dm.group(1) == name:
                found = True
                break
        if not found:
            problems.append(f"REFS       {ref}: no declaration of {name} "
                            f"in {m.group(1)}")
    return problems


def provenance_problems(unit):
    """[problem, ...] when run/results.json exists without a lab_run provenance file."""
    run_dir = unit.path / "run"
    if not run_dir.is_dir():
        return []
    results = list(run_dir.glob("results*.json"))
    if not results:
        return []
    provenance = list(run_dir.glob("lab_run.*.json"))
    if provenance:
        return []
    names = ", ".join(r.name for r in results)
    return [f"PROVENANCE {names} exist(s) without a lab_run provenance "
            f"file — run through `lab run`, not directly"]


def nan_findings(values):
    """[(key, raw)] for every NaN or Infinity in values.tsv."""
    out = []
    for key, raw in values.items():
        if raw in ("nan", "NaN", "inf", "-inf", "Infinity", "-Infinity"):
            out.append((key, raw))
    return out


KEY_DUMP = re.compile(r"`[a-zA-Z][a-zA-Z0-9_.]*\.[a-zA-Z][a-zA-Z0-9_.]*`\s*=")

CITATION_TAG = re.compile(r"\[§(\d+)\s*(.*?)\]")


def _log_path(unit_path):
    """The latest lab_run log in the unit's run/ directory, or None."""
    run_dir = unit_path / "run"
    if not run_dir.is_dir():
        return None
    logs = sorted(run_dir.glob("lab_run.*.log"))
    return logs[-1] if logs else None


def _numbers_in_text(text):
    """All Decimals found in a text string."""
    out = set()
    for m in NUM.finditer(text):
        d = _decimal(m.group(0))
        if d is not None and d.is_finite():
            out.add(d)
    return out


SHOWS_LEAD = re.compile(r"^\*\*What it shows\.\*\*[ \t]*(.*)$", re.M)
BULLET = re.compile(r"^- ", re.M)


def keydump_findings(unit):
    """[(problem, snippet)] for key-dump style in 'What it shows.'

    Flags lines where a dotted key path appears as `key.path` = value.
    The prose should read as sentences with numbers, not as key=value
    assignments copied from values.tsv.
    """
    body = unit.body
    m = SHOWS_LEAD.search(body)
    if m is None:
        return []
    next_lead = LEAD_IN.search(body, m.end())
    shows_end = next_lead.start() if next_lead else len(body)
    shows_text = body[m.start():shows_end]
    out = []
    for line in shows_text.splitlines():
        if KEY_DUMP.search(line):
            snippet = line.strip()[:80]
            out.append(("KEY_DUMP    dotted key path used as prose — write a "
                        "sentence with the number, not `key.path` = value",
                        snippet))
    return out


def structure_findings(unit):
    """[(problem, snippet)] for shape violations in "What it shows."

    Two rules:
      1. If "What it shows" has bullet lines, each must carry a [§N] tag.
      2. If it has any [§N] tags, a summary sentence must precede the
         first bullet.

    Units with no bullets in "What it shows" are untouched — they
    predate the citation format.
    """
    body = unit.body
    m = SHOWS_LEAD.search(body)
    if m is None:
        return []

    # Extract the "What it shows" section: from the lead-in to the next
    # bold lead-in or end of body.
    shows_start = m.start()
    next_lead = LEAD_IN.search(body, m.end())
    shows_end = next_lead.start() if next_lead else len(body)
    shows_text = body[shows_start:shows_end]

    bullets = list(BULLET.finditer(shows_text))
    if not bullets:
        return []

    out = []

    # Rule 1: every bullet must have a citation tag.
    for bm in bullets:
        line_start = bm.start()
        line_end = shows_text.find("\n", line_start)
        if line_end < 0:
            line_end = len(shows_text)
        line = shows_text[line_start:line_end]
        if not CITATION_TAG.search(line):
            snippet = line.strip()[:80]
            out.append((f"UNCITED    bullet in 'What it shows' has no "
                        f"[§N subject] citation tag", snippet))

    # Rule 2: if any tags exist, a summary sentence must come before
    # the first bullet. Text on the same line as **What it shows.**
    # counts, and so does any text between the lead-in and the first
    # bullet.
    has_tags = bool(CITATION_TAG.search(shows_text))
    if has_tags:
        lead_in_text = m.group(1).strip()
        first_bullet_pos = bullets[0].start()
        between = shows_text[m.end() - shows_start:first_bullet_pos].strip()
        if not lead_in_text and not between:
            out.append(("SUMMARY    'What it shows' has citation tags but "
                        "no summary sentence before the first bullet", ""))

    return out


def citation_findings(unit):
    """[(problem, section_snippet)] for each citation tag that doesn't verify.

    Returns (findings_list, n_citations). If the unit has no citations,
    returns ([], 0) and the check is skipped silently.
    """
    body = unit.body
    tags = list(CITATION_TAG.finditer(body))
    if not tags:
        return [], 0

    log_file = _log_path(unit.path)
    if log_file is None:
        return ([(f"CITATION   {len(tags)} citation(s) but no lab_run log "
                  f"found in run/", "")], len(tags))

    sections = logsections.parse(log_file.read_text(encoding="utf-8"))
    by_number = {s.number: s for s in sections}

    out = []
    for m in tags:
        sec_num = int(m.group(1))
        subject = m.group(2).strip()
        tag_text = m.group(0)

        if sec_num not in by_number:
            max_sec = max(by_number.keys()) if by_number else 0
            out.append((f"CITATION   {tag_text}: section §{sec_num} does not "
                        f"exist (log has §0..§{max_sec})", ""))
            continue

        section = by_number[sec_num]
        section_text = section.text

        if subject and subject.lower() not in section_text.lower():
            out.append((f"CITATION   {tag_text}: subject {subject!r} not "
                        f"found in §{sec_num} ({section.title!r})", ""))
            continue

        # Check that numbers in the claim appear in the cited section.
        # The claim is everything after the closing ] to the next newline.
        claim_start = m.end()
        claim_end = body.find("\n", claim_start)
        if claim_end < 0:
            claim_end = len(body)
        claim = body[claim_start:claim_end]

        claim_numbers = _numbers_in_text(claim)
        section_numbers = _numbers_in_text(section_text)

        missing = []
        for want in sorted(claim_numbers, key=abs):
            if not matches(want, section_numbers):
                missing.append(str(want))

        if missing:
            out.append((f"CITATION   {tag_text}: number(s) "
                        f"{', '.join(missing)} not found in §{sec_num} "
                        f"({section.title!r})",
                        claim.strip()[:80]))

    return out, len(tags)


PLACEHOLDER = re.compile(r"<(?:paste the transcript bracket|UNFILLED)", re.I)
FENCE = re.compile(r"^`{3,}", re.M)
CONTEXT_REF = re.compile(r"CONTEXT\.md", re.M)
NOTEPAD_LINE = re.compile(r"^NOTEPAD:", re.M)
INLINE_CODE = re.compile(r"`[^`\n]+`")          # one inline code span; unit 0338
SOURCE_HEADER = re.compile(r"^>\s*Source:", re.M)
SOURCES_MISSING = re.compile(r"^MISSING\b", re.M)


def _script_name(unit):
    """The O-script filename from run/run.sh, or None."""
    run_sh = unit.path / "run" / "run.sh"
    if not run_sh.is_file():
        return None
    m = re.search(r"([A-Za-z0-9_]+\.py)", run_sh.read_text(encoding="utf-8"))
    return m.group(1) if m else None


def question_problems(unit):
    """[problem, ...] for a question.md that is still a placeholder,
    missing required provenance sections, or missing sources.log.

    question.md is a transcript bracket — its numbers are not checked
    against values.tsv (line 44 of this module's docstring). But a
    placeholder is a finding: the provenance was never filled in.

    Required sections: a source header (> Source:), at least one fenced
    code block (docstring or notebook entry), a CONTEXT.md reference,
    and a NOTEPAD line.

    Required companion: sources.log, produced by check_prose_source.py.
    That tool searches all six source locations INCLUDING the session
    .jsonl transcripts. Without it, question.md has no verified
    provenance chain.
    """
    qmd = unit.path / "question.md"
    if not qmd.is_file():
        return []
    text = qmd.read_text(encoding="utf-8")
    if not text.strip():
        return ["QUESTION   question.md is empty"]
    out = []
    script = _script_name(unit)
    unit_rel = unit.path.name
    if PLACEHOLDER.search(text):
        msg = "QUESTION   question.md is still a placeholder — run the utilities:"
        out.append(msg)
        out.append(f"QUESTION     1. python3 utilities/find_provenance.py units/{unit_rel}")
        if script:
            out.append(f"QUESTION     2. python3 utilities/extract_run.py {script} --all")
        out.append(f"QUESTION     3. python3 utilities/check_prose_source.py units/{unit_rel}")
        return out
    if not SOURCE_HEADER.search(text):
        out.append("QUESTION   question.md has no source header (> Source: ...)")
    fences = FENCE.findall(text)
    if len(fences) < 2:
        out.append("QUESTION   question.md has no fenced code block "
                   "(docstring or notebook entry)")
    # The CONTEXT.md reference and the NOTEPAD line were required until
    # unit 0338: in a Lean unit they were boilerplate repeated verbatim and
    # never read. They remain welcome when they say something.
    sources_log = unit.path / "sources.log"
    if not sources_log.is_file():
        out.append("QUESTION   sources.log missing — run: "
                   f"python3 utilities/check_prose_source.py units/{unit_rel}")
    else:
        stext = sources_log.read_text(encoding="utf-8")
        missing = SOURCES_MISSING.findall(stext)
        if missing:
            out.append(f"QUESTION   sources.log has {len(missing)} MISSING line(s) — "
                       "question.md content does not trace to any source file")
    return out


def check(arg, out, cwd=None):
    """Run the invariant over one unit. Returns 0 clean, 1 a finding.

    A finding is a number in the prose with no evidence, a sealed unit
    whose files no longer match its `UNIT.sha256`, a result file without
    provenance, a NaN/Infinity in values.tsv, a citation tag whose
    section/subject/numbers don't match the run log, or a question.md
    that is still a placeholder or missing required provenance sections.

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
    bad_refs = refs_problems(unit)
    for problem in bad_refs:
        print(problem, file=out)
    bad_prov = provenance_problems(unit)
    for problem in bad_prov:
        print(problem, file=out)
    bad_nan = nan_findings(unit.values)
    for key, raw in bad_nan:
        print(f"NAN_VALUE  {key}  =  {raw}", file=out)
    bad_cite, n_citations = citation_findings(unit)
    for problem, snippet in bad_cite:
        line = f"{problem}  |  {snippet}" if snippet else problem
        print(line, file=out)
    bad_struct = structure_findings(unit)
    for problem, snippet in bad_struct:
        line = f"{problem}  |  {snippet}" if snippet else problem
        print(line, file=out)
    bad_keydump = keydump_findings(unit)
    for problem, snippet in bad_keydump:
        line = f"{problem}  |  {snippet}" if snippet else problem
        print(line, file=out)
    bad_question = question_problems(unit)
    for problem in bad_question:
        print(problem, file=out)
    numeric, from_strings = pool_parts(unit.values)
    seal_state = ""
    if unit.front_matter.get("sealed") is True:
        seal_state = ("; sealed and unchanged" if not moved
                      else f"; sealed, {len(moved)} problem(s)")
    extra = from_strings - numeric
    in_strings = f" +{len(extra)} in strings" if extra else ""
    spelled_clause = (f", {len(spelled)} count(s) spelled in words"
                      if spelled else "")
    follows_clause = (f", {len(bad_follows)} follows problem(s)"
                      if bad_follows else "")
    refs_clause = (f", {len(bad_refs)} refs problem(s)"
                   if bad_refs else "")
    prov_clause = (f", {len(bad_prov)} provenance problem(s)"
                   if bad_prov else "")
    nan_clause = (f", {len(bad_nan)} NaN/Inf value(s)"
                  if bad_nan else "")
    cite_clause = (f", {len(bad_cite)} citation problem(s)"
                   if bad_cite else
                   f", {n_citations} citation(s) verified"
                   if n_citations else "")
    struct_clause = (f", {len(bad_struct)} structure problem(s)"
                     if bad_struct else "")
    keydump_clause = (f", {len(bad_keydump)} key-dump warning(s)"
                      if bad_keydump else "")
    question_clause = (f", {len(bad_question)} question.md problem(s)"
                       if bad_question else "")
    print(f"{unit.path}: {scanned} number(s) in prose, "
          f"{scanned - len(unmatched)} matched, {len(unmatched)} unmatched "
          f"({exempted} exempt){spelled_clause}{follows_clause}"
          f"{refs_clause}{prov_clause}{nan_clause}{cite_clause}"
          f"{struct_clause}{keydump_clause}{question_clause}; "
          f"values.tsv: {len(unit.values)} key(s), {len(numeric)} numeric"
          f"{in_strings}{seal_state}",
          file=out)
    return 1 if (unmatched or moved or spelled or bad_follows
                 or bad_refs or bad_prov or bad_nan or bad_cite
                 or bad_struct or bad_keydump or bad_question) else 0


def run(arg, out, err, cwd=None):
    """`lab check <unit>`: 0 clean, 1 unmatched, 2 unloadable."""
    try:
        return check(arg, out, cwd=cwd)
    except UnitError as exc:
        print(f"lab check: {exc}", file=err)
        return 2
