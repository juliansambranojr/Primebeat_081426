"""Counts are written in digits: the number-WORDS `lab check` refuses.

PHASE 2c of `analysis/2026-09-02/lab_design.md`, whose § Counts are written in
digits states the rule and the enforcement in two sentences:

    "Rule: any number that counts something in the record is written in
     digits. Runs, units, files, findings, keys, tests, lines, entries."

    "Enforced by `lab check`: a number-word adjacent to a countable noun is a
     finding, with the digit form named in the message."

`lab/check.py` scans digits, so `four runs` is invisible where `4 runs`
resolves to a key. This module is the other half of the scan.

THE BOUNDARY, JUDGED AGAINST REAL PROSE BEFORE IT WAS IMPLEMENTED. The design
flags its own boundary as the orchestrator's reading rather than Julian's: a
number-word used as ordinary English keeps its word form ("one execution",
"the second half", "a third of the tokens"), and the rule binds only when the
number counts things the archive holds. The named fallback, if that turns out
unusable, is stricter -- digits everywhere a number appears.

The boundary is USABLE, and it is implemented as a CLOSED NOUN LIST rather
than as a part-of-speech judgement. The three phrases the brief named out of
`units/0308-phase-2b-run-capture-and-one-home/unit.md` are what settled it:

    "The four corrections the build made"        FINDING   -> 4 corrections
    "the four-line call into the commit gate"    FINDING   -> 4-line
    "bare four-or-more-digit id"                 no finding

and the separator is THE NOUN, never the hyphen. A hyphen rule would have to
call `four-line` ordinary English, and it is a count of lines written as an
adjective -- the same count, the same drift. `four-or-more-digit` is silent
because `digit` is not a thing the archive holds, which is exactly what the
design's boundary says: the rule binds on the nouns with a key behind them.

THE LIST IS THE DESIGN'S OWN ENUMERATION, plus one. `run, unit, file, finding,
key, test, line, entry` are the eight the section names. `correction` is
added because the brief names "The four corrections the build made" as a live
violation and the design's list is illustrative rather than exhaustive. Every
later addition belongs here, with the prose that motivated it, for the reason
`lab/exempt.py` gives for its own table: a shape added at a call site is a
shape no reader can find.

`one` IS NOT A NUMBER-WORD HERE. English uses it as an article -- "one line
per leaf", "one directory per notebook entry", "one execution" is the design's
own example of ordinary usage -- and a rule that fired on it would report a
finding on nearly every sentence in this tree that is not a count at all. The
scan therefore starts at `two`. What that costs: a genuine count of exactly
one thing, written "one run", passes. It is a count of 1 and the reader loses
nothing they could have looked up.

WHAT IT DOES NOT CATCH, MEASURED OVER THE FIXTURES. `units/0001-smoke-clean`
writes "two numbers its `values.tsv` does not hold" and `units/0003-run-smoke`
writes "It contributes exactly two numbers to the pool". Both are counts of
things the archive holds and neither is caught, because `number` is not on the
list. It is left off deliberately and the reason is worth stating: a count
written in digits is itself a number in the prose, so it needs a line in
`values.tsv`. `2 numbers` in those two fixtures would take a passing fixture to
a finding unless the run measured the count and wrote it out. The digits rule
and the invariant pull against each other on any count a unit makes about
itself, and this list is where that tension is paid rather than hidden.
"""

import re

__all__ = ["WORDS", "NOUNS", "digits_of", "findings"]

# Two upward. See the docstring for why `one` is not here.
WORDS = {
    "two": 2, "three": 3, "four": 4, "five": 5, "six": 6, "seven": 7,
    "eight": 8, "nine": 9, "ten": 10, "eleven": 11, "twelve": 12,
    "twenty": 20, "thirty": 30, "forty": 40, "fifty": 50, "sixty": 60,
    "seventy": 70, "eighty": 80, "ninety": 90, "hundred": 100,
}

# The design's eight, plus `correction`. Singular and plural, because a count
# reaches both -- `4 runs` and `4-line`.
NOUNS = [
    "run", "runs",
    "unit", "units",
    "file", "files",
    "finding", "findings",
    "key", "keys",
    "test", "tests",
    "line", "lines",
    "entry", "entries",
    "correction", "corrections",
]

PHRASE = re.compile(
    r"\b(" + "|".join(sorted(WORDS, key=len, reverse=True)) + r")"
    r"([- ])"
    r"(" + "|".join(sorted(NOUNS, key=len, reverse=True)) + r")\b",
    re.I)


def digits_of(word):
    """`four` -> `4`. Raises KeyError on a word this module does not know."""
    return str(WORDS[word.lower()])


def findings(text, skip=()):
    """[(phrase, digit form, start, end)] for every count spelled in words.

    `skip` is the exemption spans `lab/exempt.py` computes for the same text,
    so a number-word inside a backticked key or a path is not a finding: those
    are addresses under exactly the argument that module records.
    """
    out = []
    for m in PHRASE.finditer(text):
        if any(lo <= m.start() < hi for lo, hi in skip):
            continue
        word, sep, noun = m.group(1), m.group(2), m.group(3)
        out.append((m.group(0), f"{digits_of(word)}{sep}{noun}",
                    m.start(), m.end()))
    return out
