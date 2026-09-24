#!/usr/bin/env python3
"""PreToolUse hook: refuse any write to question.md without sources.log.

Wired by .claude/settings.json in primebeat_program. Fires on Write and
Edit to any question.md file under units/. The write is denied unless
sources.log exists in the same directory — that file is produced only by
check_prose_source.py, which searches all six source locations including
the .jsonl session transcripts.

This is the front-loaded enforcement. lab check is the back-loaded one.
Together they make it impossible to write question.md without running
the utilities.
"""
import json
import re
import sys
from pathlib import Path


def deny(reason):
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": reason,
        }
    }))
    sys.exit(0)


def allow():
    sys.exit(0)


def script_name(unit_dir):
    run_sh = unit_dir / "run" / "run.sh"
    if not run_sh.is_file():
        return None
    m = re.search(r"([A-Za-z0-9_]+\.py)", run_sh.read_text())
    return m.group(1) if m else None


def main():
    try:
        payload = json.load(sys.stdin)
    except Exception:
        return

    tool = payload.get("tool_name", "")
    ti = payload.get("tool_input", {}) or {}

    if tool not in ("Write", "Edit"):
        return

    fp = ti.get("file_path", "")
    if not fp:
        return

    path = Path(fp)
    if path.name != "question.md":
        return
    if "/units/" not in str(path) and "\\units\\" not in str(path):
        return

    unit_dir = path.parent

    # If the content being written is still a placeholder, allow it —
    # lab new and the placeholder rewrite need to work.
    if tool == "Write":
        content = ti.get("content", "")
        if "<UNFILLED" in content or "<paste the transcript" in content.lower():
            return

    # If the file on disk is currently a placeholder, this is the first
    # real write. Allow it — sources.log can only be produced AFTER the
    # content exists. The hook enforces on subsequent overwrites.
    if path.is_file():
        on_disk = path.read_text(encoding="utf-8")
        if "<UNFILLED" in on_disk or "<paste the transcript" in on_disk.lower():
            return

    sources_log = unit_dir / "sources.log"
    if not sources_log.is_file():
        unit_rel = unit_dir.name
        script = script_name(unit_dir)
        msg = (
            "Refused: question.md cannot be written without sources.log.\n\n"
            "sources.log is produced by check_prose_source.py, which "
            "searches all source locations including the .jsonl session "
            "transcripts. Run these utilities first:\n\n"
            f"  1. python3 utilities/find_provenance.py units/{unit_rel}\n"
        )
        if script:
            msg += f"  2. python3 utilities/extract_run.py {script} --all\n"
        msg += (
            f"  3. python3 utilities/check_prose_source.py units/{unit_rel}\n"
            "\nStep 3 produces sources.log. Then the write will be allowed."
        )
        deny(msg)

    # sources.log exists — check it has no MISSING lines
    stext = sources_log.read_text()
    missing = re.findall(r"^MISSING\b.*", stext, re.M)
    if missing:
        deny(
            f"Refused: sources.log has {len(missing)} MISSING line(s).\n\n"
            "question.md content does not trace to any source file. Fix "
            "question.md so every line traces to a source, then re-run:\n\n"
            f"  python3 utilities/check_prose_source.py units/{unit_dir.name}"
        )


if __name__ == "__main__":
    main()
