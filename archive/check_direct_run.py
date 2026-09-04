#!/usr/bin/env python3
"""PreToolUse hook: two checks at the invocation layer.

1. BLOCKS a measurement script invoked directly (below).
2. WARNS on a sliced read of a results artifact — advisory, never
   blocks. See SLICE WARNING.

SLICE WARNING
-------------
Notes entry 219: a maximum was reported from a six-row view of a
seventeen-row table. The number was wrong by a factor of 2.3 and stood
through four entries. Entry 222: the same shape again, on a ratio.

Neither is catchable by any checker over the tree, because **the defect
never enters a file** — it happens in a throwaway `python3 -c` that
prints a slice, and the aggregation is then done by eye on the printed
subset. Entry 225's audit scored a source linter for it: 7 hits, 0 of
them the defect. The invocation layer is the only place it is visible,
and this hook already parses the command.

Honest status: **unscored.** The container's rule is to score a gate
against a real corpus before adopting it, and no corpus of past
invocations exists anywhere in the tree — which is precisely why entry
225 declined to ship this. Two things make it shippable anyway. It is
advisory, so a false positive costs one line of stderr rather than a
blocked commit or a baseline file. And it writes what it sees to
`utilities/slice_observations.jsonl`, so the corpus that would score it
accumulates from here. Score it and either tighten or delete it.

It deliberately does NOT try to detect the aggregation. Tonight's two
instances both sliced, printed, and aggregated mentally — no `max(` in
the source at all — so a narrower trigger would have missed both. The
trigger is therefore "a results artifact was read and sliced", which
does fire on legitimate display-slicing. That is the accepted cost.

---

Check 1: route measurement runs through utilities/run.py.

A script invoked directly can overwrite its own previous results before
anything is committed, and leaves no record connecting the artifact to
the run. That is not hypothetical — O63, O65 and O66 each lost run 1
that way (notes entry 166), and O52 has artifacts with no dated record
of the run that made them (entry 167).

`utilities/run.py` clones results/ before the run, archives the prior
version of anything that changes, and writes a manifest linking the
artifact to the exact invocation. This hook blocks the direct form so
that protection is not optional.

It fires only on the clear case: an interpreter invoked on a
root-level O*/0*/t* measurement script. It stays out of the way when
  - the command already routes through utilities/run.py
  - `--no-json` is present, so no artifact is written
  - PB_DIRECT=1 is set, the deliberate escape

Exit 0 allows, exit 2 blocks and shows the message.
"""
import json
import os
import re
import sys

DIRECT = re.compile(
    r"(?:^|[;&|]\s*)(?:\S*python[0-9.]*)\s+(?:-\S+\s+)*"
    r"((?:O|0|t)\w*\.py)\b")

# A results artifact named anywhere in the command, and a slice anywhere.
RESULT_READ = re.compile(r"results/[\w./-]+\.(?:json|csv|log)")
SLICE = re.compile(r"\[\s*-?\d*\s*:\s*-?\d*\s*\]")
OBSERVATIONS = os.path.join(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
    "slice_observations.jsonl")


def slice_warning(cmd):
    """Advisory. Returns the warning text, or None."""
    files = RESULT_READ.findall(cmd)
    slices = SLICE.findall(cmd)
    if not (files and slices):
        return None
    try:                                    # corpus for scoring later
        with open(OBSERVATIONS, "a") as f:
            f.write(json.dumps({"files": sorted(set(files)),
                                "slices": sorted(set(slices)),
                                "cmd": cmd[:400]}) + "\n")
    except Exception:
        pass                                # never let logging break a run
    shown = ", ".join(sorted(set(files))[:3])
    cuts = " ".join(sorted(set(slices))[:3])
    return (f"note: sliced read of {shown}  {cuts}\n"
            f"  An extremum of a slice is not an extremum. Count the rows\n"
            f"  before trusting a max, a min, or a 'highest' — entry 219\n"
            f"  read 6 of 17 and was wrong by 2.3x for four entries.\n")


def main():
    try:
        payload = json.load(sys.stdin)
    except Exception:
        sys.exit(0)
    cmd = (payload.get("tool_input") or {}).get("command", "")
    if not cmd:
        sys.exit(0)

    warn = slice_warning(cmd)               # advisory, never blocks
    if warn:
        sys.stderr.write(warn)
    if "utilities/run.py" in cmd or "--no-json" in cmd:
        sys.exit(0)
    if os.environ.get("PB_DIRECT") == "1" or "PB_DIRECT=1" in cmd:
        sys.exit(0)
    m = DIRECT.search(cmd)
    if not m:
        sys.exit(0)
    script = m.group(1)
    sys.stderr.write(
        f"Direct invocation of {script} is blocked.\n\n"
        f"A measurement script run directly can overwrite its own prior\n"
        f"results before anything is committed, and leaves no record tying\n"
        f"the artifact to the run. O63, O65 and O66 each lost run 1 that\n"
        f"way (notes entry 166).\n\n"
        f"Route it through the runner instead:\n"
        f"    python3 utilities/run.py {script} <args>\n"
        f"    python3 utilities/run.py --python .venv/bin/python "
        f"{script} <args>\n\n"
        f"That clones results/ first, archives the prior version of\n"
        f"anything it changes, and writes results/runs/<utc>_<script>.json\n"
        f"connecting the artifact to the exact invocation.\n\n"
        f"Escapes: add --no-json (writes no artifact), or set PB_DIRECT=1\n"
        f"deliberately.\n")
    sys.exit(2)


if __name__ == "__main__":
    main()
