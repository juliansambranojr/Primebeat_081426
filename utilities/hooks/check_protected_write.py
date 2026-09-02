#!/usr/bin/env python3
"""PreToolUse hook (matcher "Edit|Write|MultiEdit"): protected paths need a one-use approval flag.

Denies an edit or write whose file_path, under this repo, is
  - CLAUDE.md, CONTEXT.md or REFERENCES.md, in any directory  (commitment
    files: CLAUDE.md § Permissions, "Edit this file, CONTEXT.md, or
    REFERENCES.md without Julian's explicit approval")
  - anything under `files (2)/`                     (frozen evidence)
  - any `*.json` directly inside a `results/` dir   (run artifacts)
  - any `*.log`                                     (O8's only record is its logs)
  - a prereg that is locked: preregs/*.md carrying a `STATUS:` line reading
    LOCKED (the files write it as `STATUS: **LOCKED**`), or with a sibling
    `.sha256` sidecar (preregs/FORMAT.md: "The sidecar is the authority")
  - utilities/hooks/*  and  .claude/settings*.json   (the guards themselves)
  - anything under `.approve/` itself — with NO bypass, since a flag written
    from here would be an approval Julian did not give

unless `<repo>/.approve/<basename>` exists. Then the write is allowed and
the flag is deleted, so one approval buys one write. Julian creates the
flag (`touch .approve/CLAUDE.md`); `.approve/` is gitignored. Paths outside
the repo are allowed.

check_bash_guard.py imports `protected()` and `consume_flag()` from here so
the two guards agree on what is protected.

Protocol (identical to check_direct_run.py): stdin is the PreToolUse JSON
with tool_name / tool_input; exit 0 allows, exit 2 denies with the reason
on stderr. Fails open on unparseable input.

    --selftest    canned paths: each protected class denied, an ordinary
                  file allowed, and a temporary flag consumed; exits 0.
"""
import json
import os
import pathlib
import re
import sys

HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parent.parent
APPROVE = ROOT / ".approve"
COMMITMENT = ("CLAUDE.md", "CONTEXT.md", "REFERENCES.md")
LOCKED = re.compile(r"^status:\s*[*_]*LOCKED", re.I | re.M)


def _rel(path):
    """Repo-relative PurePosixPath, or None when outside the repo."""
    try:
        p = pathlib.Path(path)
        if not p.is_absolute():
            p = ROOT / p
        # normpath, never resolve: a path is judged by where it is addressed,
        # so a symlink into a protected area is still that area
        p = pathlib.Path(os.path.normpath(p))
        return pathlib.PurePosixPath(p.relative_to(ROOT).as_posix())
    except (ValueError, OSError):
        return None


def prereg_locked(abs_path):
    if abs_path.with_suffix(".sha256").exists():
        return True
    try:
        head = abs_path.read_text(encoding="utf-8", errors="replace")[:4000]
    except OSError:
        return False
    return bool(LOCKED.search(head))


def protected(path):
    """Why `path` is protected (short text), or None."""
    rel = _rel(path)
    if rel is None or str(rel) == ".":
        return None
    parts = rel.parts
    name = rel.name
    if parts[0] == ".approve":
        return "NO BYPASS: .approve/ flags are created by Julian from his terminal only"
    if name in COMMITMENT:
        return f"{name} is a commitment file"
    if parts[0] == "files (2)":
        return "files (2)/ is frozen evidence (the only record of O1, O2, O3b)"
    if name.endswith(".json") and len(parts) >= 2 and parts[-2] == "results":
        return "results/*.json is a run artifact"
    if name.endswith(".log"):
        return "*.log files are run records (O8 has nothing else)"
    if parts[0] == "preregs" and len(parts) == 2 and name.endswith(".md"):
        if prereg_locked(ROOT / rel):
            return "a locked prereg is immutable except for its Run record"
    if parts[:2] == ("utilities", "hooks"):
        return "utilities/hooks/ holds the guards"
    if parts[0] == ".claude" and re.fullmatch(r"settings.*\.json", name):
        return ".claude/settings*.json registers the guards"
    return None


def flag_for(path):
    return APPROVE / pathlib.PurePath(path).name


def consume_flag(path):
    """Delete .approve/<basename> if present; True when it was."""
    f = flag_for(path)
    if f.is_file():
        try:
            f.unlink()
        except OSError:
            return False
        return True
    return False


def denial(path, why):
    return (f"Write denied by check_protected_write.py: {path}\n"
            f"  {why}.\n"
            f"  Julian approves one write with:  touch {flag_for(path)}\n"
            f"  (the flag is consumed by the write; .approve/ is gitignored).")


def verdict(tool_input):
    """None to allow (consuming a flag if one was needed), else the denial text."""
    fp = tool_input.get("file_path") or ""
    if not fp:
        return None
    why = protected(fp)
    if why is None:
        return None
    if why.startswith("NO BYPASS"):
        return denial(fp, why)
    if consume_flag(fp):
        sys.stderr.write(f"check_protected_write: consumed {flag_for(fp)}\n")
        return None
    return denial(fp, why)


def selftest():
    cases = {
        str(ROOT / "CLAUDE.md"): True,
        str(ROOT / "lean_stage3" / "CONTEXT.md"): True,
        str(ROOT / "files (2)" / "anything.txt"): True,
        str(ROOT / "results" / "O47_x.json"): True,
        str(ROOT / "analysis" / "2026-09-01" / "results" / "weil_Lc_mod.json"): True,
        str(ROOT / "results" / "O8_run.log"): True,
        str(ROOT / "preregs" / "alpha_depth_trend_v1_locked_20260814.md"): True,
        str(ROOT / "preregs" / "FORMAT.md"): False,
        str(ROOT / "utilities" / "hooks" / "pre-commit"): True,
        str(ROOT / ".claude" / "settings.json"): True,
        str(ROOT / ".claude" / "settings.local.json"): True,
        str(ROOT / "analysis" / "2026-09-01" / "scratch" / "x.py"): False,
        str(ROOT / "results" / "weil.numbers"): False,
        "/tmp/elsewhere/CLAUDE.md": False,
        str(ROOT / ".approve" / "no-verify"): True,
    }
    ok = True
    for p, want in cases.items():
        got = protected(p) is not None
        ok &= got == want
        print(f"{'deny ' if got else 'allow'}  {'ok ' if got == want else 'BAD'}  {p}")
    # the flag: create, consume, confirm gone
    APPROVE.mkdir(exist_ok=True)
    probe = APPROVE / "CONTEXT.md"
    probe.touch()
    r = verdict({"file_path": str(ROOT / "CONTEXT.md")})
    ok &= r is None and not probe.exists()
    print(f"flag   {'ok ' if r is None and not probe.exists() else 'BAD'}  "
          f"CONTEXT.md allowed once and .approve/CONTEXT.md consumed")
    r2 = verdict({"file_path": str(ROOT / "CONTEXT.md")})
    ok &= r2 is not None
    print(f"flag   {'ok ' if r2 else 'BAD'}  second write denied")
    print("selftest", "OK" if ok else "FAILED")
    return 0 if ok else 1


def main():
    if "--selftest" in sys.argv:
        sys.exit(selftest())
    try:
        payload = json.load(sys.stdin)
    except Exception:
        sys.exit(0)
    if payload.get("tool_name") not in (None, "Edit", "Write", "MultiEdit"):
        sys.exit(0)
    why = verdict(payload.get("tool_input") or {})
    if why is None:
        sys.exit(0)
    sys.stderr.write(why + "\n")
    sys.exit(2)


if __name__ == "__main__":
    main()
