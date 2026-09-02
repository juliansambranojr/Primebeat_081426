#!/usr/bin/env python3
"""PreToolUse hook (matcher "Read"): a commitment file is read by line range.

Denies a Read of CLAUDE.md, CONTEXT.md or REFERENCES.md (any directory)
when the file is longer than 120 lines and the call carries neither
`offset` nor `limit`. The three files are 258 / 762 / 174 lines here; a
whole-file read puts the entire blueprint into context to answer one
question, and the answer then comes from a paraphrase of a slab rather
than from a cited line. AGENT_CARD.md carries the line ranges for every
section an agent needs (`CLAUDE.md:31–90`, `CLAUDE.md:154–199`, ...);
read the range the card names.

A file of 120 lines or fewer, or any other filename, is allowed whole.

Protocol (identical to check_direct_run.py): stdin is the PreToolUse JSON
with tool_name / tool_input; exit 0 allows, exit 2 denies with the reason
on stderr. Fails open on unparseable input or an unreadable file.

    --selftest    a full read of the repo's CONTEXT.md is denied, a ranged
                  read and a small file are allowed; exits 0 when so.
"""
import json
import pathlib
import sys

HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parent.parent
COMMITMENT = ("CLAUDE.md", "CONTEXT.md", "REFERENCES.md")
LIMIT = 120


def line_count(path):
    with open(path, "rb") as fh:
        return sum(1 for _ in fh)


def verdict(tool_input):
    """None to allow, else the denial text."""
    fp = tool_input.get("file_path") or ""
    if pathlib.PurePath(fp).name not in COMMITMENT:
        return None
    if tool_input.get("offset") is not None or tool_input.get("limit") is not None:
        return None
    try:
        n = line_count(fp)
    except OSError:
        return None
    if n <= LIMIT:
        return None
    return (f"Read denied by check_read_range.py: {fp} is {n} lines. Read a "
            f"line range (offset/limit); AGENT_CARD.md has them — "
            f"{ROOT / 'AGENT_CARD.md'}. Grep for the section first if the "
            f"card does not name it.")


def selftest():
    big = str(ROOT / "CONTEXT.md")
    r_full = verdict({"file_path": big})
    r_range = verdict({"file_path": big, "offset": 10, "limit": 40})
    r_other = verdict({"file_path": str(ROOT / "AGENT_CARD.md")})
    print("deny   ->", (r_full or "")[:90])
    print("allow  ->", r_range)
    print("allow  ->", r_other)
    ok = r_full is not None and r_range is None and r_other is None
    print("selftest", "OK" if ok else "FAILED")
    return 0 if ok else 1


def main():
    if "--selftest" in sys.argv:
        sys.exit(selftest())
    try:
        payload = json.load(sys.stdin)
    except Exception:
        sys.exit(0)
    if payload.get("tool_name") not in (None, "Read"):
        sys.exit(0)
    why = verdict(payload.get("tool_input") or {})
    if why is None:
        sys.exit(0)
    sys.stderr.write(why + "\n")
    sys.exit(2)


if __name__ == "__main__":
    main()
