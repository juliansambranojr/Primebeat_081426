#!/usr/bin/env python3
"""PreToolUse hook: route measurement runs through utilities/run.py.

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


def main():
    try:
        payload = json.load(sys.stdin)
    except Exception:
        sys.exit(0)
    cmd = (payload.get("tool_input") or {}).get("command", "")
    if not cmd:
        sys.exit(0)
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
