"""Recompute every figure unit 0308's prose states, into figures.json.

Phase 2b produced its numbers by running commands at a terminal rather than a
script, so nothing in the tree reproduced them. This is that missing script.
It is not the phase's work; it is the phase's work MEASURED AGAIN, from the
same sources, so that each number the unit's prose states has a line in the
unit's own values.tsv.

Run by run.sh with the working directory set to this run/ directory, so the
repository root is three levels up. Every path below is resolved from there
and nothing is written outside the unit.

Six blocks, in the order the prose uses them:

  commit      the shape of ccd44f0 and the range 408de2a..1193e0f
  exempt      the unit-path false exemption, before and after, over entries
              302 and 304 of notes/lab_notebook_2.md
  strings     the string-value counts in arrow_price.numbers -- the four-way
              split that corrects entry 307's "157 are strings"
  rates       the exact invented-value accept rate per pool, with and without
              numbers held inside string values
  superseded  the figures and the claim Phase 2b corrected, QUOTED out of the
              two files that still record them, so that a correction can name
              the number it corrects without hand-entering it
  tests       the test count, and lab check over the two fixtures the phase built

The `before` half of the exempt block needs the pattern Phase 2b replaced.
It is rebuilt here from lab/exempt.py's own `_SLUGGED` fragment with the path
position dropped, which is exactly what the class was: a bare four-or-more
digit id, a hyphen and a slug, with nothing required around it.
"""

import json
import pathlib
import re
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT))

from lab import exempt as exempt_mod                        # noqa: E402
from lab import unit as unit_mod                            # noqa: E402
from lab.check import NUM, _decimal, pool_parts             # noqa: E402

BUILD = "ccd44f0"
BASE = "408de2a"
HEAD = "1193e0f"
NOTEBOOK = ROOT / "notes" / "lab_notebook_2.md"
ARROW = ROOT / "analysis" / "2026-09-02" / "results" / "arrow_price.numbers"
WEIL = ROOT / "analysis" / "2026-09-01" / "results" / "weil_Lc_theory.numbers"
ENTRIES = (302, 304)
SPAN = 1000            # the invented-value range [0, SPAN) the rates are over

# lab/exempt.py's unit-path class as Phase 2 shipped it: the slug fragment
# standing alone, with no path position required. This is the pattern whose
# two matches in entry 302 were counts.
OLD_UNIT_PATH = re.compile(r"\bunits/\d{4,}\b" + "|" + exempt_mod._SLUGGED)


def git(*args):
    r = subprocess.run(["git", *args], cwd=ROOT, capture_output=True,
                       text=True, check=True)
    return r.stdout


def commit_block():
    """The shape of the build commit, read from git rather than from a report."""
    summary = git("show", "--stat", "--format=", BUILD).strip().split("\n")[-1]
    files, ins, dels = (int(m) for m in re.findall(r"(\d+) \w+", summary))
    numstat = {}
    for line in git("show", "--numstat", "--format=", BUILD).strip().split("\n"):
        added, removed, path = line.split("\t")
        numstat[path] = {"added": int(added), "removed": int(removed)}
    revs = git("rev-list", "--count", f"{BASE}..{HEAD}").strip()
    return {
        "files_changed": files,
        "insertions": ins,
        "deletions": dels,
        "commits_in_range": int(revs),
        "run_py_added": numstat["lab/run.py"]["added"],
        "test_phase2b_added": numstat["tests/test_phase2b.py"]["added"],
        "exempt_py_added": numstat["lab/exempt.py"]["added"],
        "check_py_added": numstat["lab/check.py"]["added"],
        "check_units_added": numstat["utilities/check_units.py"]["added"],
        "units_touched": sum(1 for p in numstat if p.startswith("units/")),
    }


def _scan_with(body, spans):
    tokens = list(NUM.finditer(body))
    removed = [m for m in tokens
               if any(lo <= m.start() < hi for lo, hi in spans)]
    return len(tokens), len(removed)


def _spans_with_old_unit_path(text):
    """exempt.spans, with the unit-path class swapped for its Phase 2 form."""
    raw = []
    for klass in exempt_mod.CLASSES:
        pattern = OLD_UNIT_PATH if klass.name == "unit-path" else klass.pattern
        raw += [m.span() for m in pattern.finditer(text)]
    merged = []
    for lo, hi in sorted(raw):
        if merged and lo <= merged[-1][1]:
            merged[-1][1] = max(merged[-1][1], hi)
        else:
            merged.append([lo, hi])
    return [(lo, hi) for lo, hi in merged]


def exempt_block():
    """The false exemption, before and after, over the two corpus entries."""
    text = NOTEBOOK.read_text(encoding="utf-8")
    out = {}
    for number in ENTRIES:
        body = exempt_mod.entry_body(text, number)
        b_tokens, b_removed = _scan_with(body, _spans_with_old_unit_path(body))
        a_tokens, a_removed = _scan_with(body, exempt_mod.spans(body))
        out[f"entry_{number}"] = {
            "tokens": a_tokens,
            "before_exempt": b_removed,
            "before_exempt_pct": 100.0 * b_removed / b_tokens,
            "before_scanned": b_tokens - b_removed,
            "after_exempt": a_removed,
            "after_exempt_pct": 100.0 * a_removed / a_tokens,
            "after_scanned": a_tokens - a_removed,
            "recovered": b_removed - a_removed,
        }
    out["classes"] = len(exempt_mod.CLASSES)
    return out


def strings_block():
    """The four-way split of arrow_price.numbers that corrects entry 307."""
    table = exempt_mod._read_pool_file(ARROW)
    values = list(table.values())
    numeric = [v for v in values if _decimal(v) is not None]
    strings = [v for v in values if v.startswith('"')]
    literals = {name: sum(1 for v in values if v == name)
                for name in ("true", "false", "null")}
    with_digits = [v for v in strings if any(c.isdigit() for c in v)]
    pool_numeric, from_strings = pool_parts(table)
    added = sorted(float(v) for v in (from_strings - pool_numeric))
    return {
        "added_values": added,
        "keys": len(table),
        "numeric_lines": len(numeric),
        "strings": len(strings),
        "not_numeric": len(values) - len(numeric),
        "false_lines": literals["false"],
        "true_lines": literals["true"],
        "null_lines": literals["null"],
        "strings_with_digits": len(with_digits),
        "distinct_numeric_values": len(pool_numeric),
        "added_by_strings": len(from_strings - pool_numeric),
    }


def _rates(path):
    table = exempt_mod._read_pool_file(path)
    numeric, from_strings = pool_parts(table)
    widened = numeric | from_strings
    row = {}
    for label, pool in (("numbers_only", numeric), ("widened", widened)):
        row[label] = {
            "values": len(pool),
            "int_pct": exempt_mod.exact_rate(pool, 0, SPAN),
            "one_dp_pct": exempt_mod.exact_rate(pool, 1, SPAN),
            "three_dp_pct": exempt_mod.exact_rate(pool, 3, SPAN),
        }
        row[label]["int_refused_pct"] = 100.0 - row[label]["int_pct"]
    row["added"] = row["widened"]["values"] - row["numbers_only"]["values"]
    row["int_over_three_dp"] = (row["numbers_only"]["int_pct"]
                                / row["numbers_only"]["three_dp_pct"])
    return row


def rates_block():
    """The cost of the widening, over every grid value rather than a draw.

    `int_over_three_dp` is the ratio the build's second correction is about:
    the Phase 2 docstring claimed an integer check is 15-60x weaker than a
    three-decimal one, from a 1000-draw column that could not resolve a rate
    of a few hundredths of a percent.
    """
    return {"span": SPAN,
            "arrow_price": _rates(ARROW), "weil_Lc_theory": _rates(WEIL)}


def superseded_block():
    """The four percentages Phase 2's unseeded table stated, read from entry 307.

    They are quoted here rather than typed. A correction has to name the
    number it corrects, and under the invariant a number in prose needs a line
    in this unit's values.tsv -- so the superseded figures are extracted from
    the one place in the tree that still records them, entry 307's own prose,
    which is frozen and is Julian's. The anchor is the sentence naming
    `lab/exempt.py`; a change to it makes this raise rather than guess.
    """
    body = exempt_mod.entry_body(
        NOTEBOOK.read_text(encoding="utf-8"), 307)
    m = re.search(r"`lab/exempt\.py` records\s+"
                  r"([\d.]+)%,\s*([\d.]+)%,\s*([\d.]+)%\s*and\s*([\d.]+)%",
                  " ".join(body.split()))
    if m is None:
        raise ValueError("entry 307 no longer states the Phase 2 table")
    a, b, c, d = (float(g) for g in m.groups())
    claim = re.search(
        r"integer check is (\d+)-(\d+)x weaker",
        " ".join((ROOT / "lab" / "exempt.py")
                 .read_text(encoding="utf-8").split()))
    if claim is None:
        raise ValueError("lab/exempt.py no longer quotes the Phase 2 claim")
    return {
        "phase2_arrow_one_dp_pct": a,
        "phase2_weil_one_dp_pct": b,
        "phase2_arrow_three_dp_pct": c,
        "phase2_weil_three_dp_pct": d,
        "phase2_ratio_low": int(claim.group(1)),
        "phase2_ratio_high": int(claim.group(2)),
    }


def tests_block():
    """The suite, and lab check over the two fixtures Phase 2b committed."""
    r = subprocess.run([sys.executable, "-m", "pytest", "-q"], cwd=ROOT,
                       capture_output=True, text=True)
    passed = int(re.search(r"(\d+) passed", r.stdout).group(1))
    phase2b = subprocess.run(
        [sys.executable, "-m", "pytest", "-q", "tests/test_phase2b.py"],
        cwd=ROOT, capture_output=True, text=True)
    out = {
        "suite_passed": passed,
        "suite_exit": r.returncode,
        "phase2b_passed": int(re.search(r"(\d+) passed",
                                        phase2b.stdout).group(1)),
    }
    for name in ("0003-run-smoke", "0004-run-fails"):
        u = unit_mod.load(str(ROOT / "units" / name))
        pool_n, pool_s = pool_parts(u.values)
        out[name.replace("-", "_")] = {
            "keys": len(u.values),
            "numeric": len(pool_n),
            "from_strings": len(pool_s - pool_n),
        }
    return out


def main():
    document = {
        "commit": commit_block(),
        "exempt": exempt_block(),
        "strings": strings_block(),
        "rates": rates_block(),
        "superseded": superseded_block(),
        "tests": tests_block(),
    }
    out = pathlib.Path("figures.json")
    out.write_text(json.dumps(document, indent=2) + "\n", encoding="utf-8")
    print(f"wrote {out} with {len(document)} block(s)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
