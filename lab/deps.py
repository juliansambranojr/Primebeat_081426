"""`run/deps` — declare what a unit needs from other units.

A unit whose script imports or reads files from another unit lists those
dependencies in `run/deps`, one per line. `lab run` reads this file before
executing `run.sh` and creates the symlinks or checks the paths.

Two dependency types:

    symlink  O90_mode_coherence.py  ../../0089-mode-coherence/run/O90_mode_coherence.py
    need     ../../0089-mode-coherence/run/results.json

`symlink` creates a symlink in `run/` if it doesn't already exist.
`need` checks that the target file exists and fails if it doesn't,
so the agent gets a clear error instead of a traceback mid-run.

Lines starting with `#` are comments. Blank lines are ignored.
"""

import os
import pathlib

__all__ = ["DEPS_FILE", "parse", "resolve"]

DEPS_FILE = "deps"


def parse(deps_path):
    """Parse a deps file. Returns a list of (kind, args) tuples.

    kind is 'symlink' or 'need'.
    For symlink: args is (link_name, target_path).
    For need: args is (target_path,).
    """
    entries = []
    text = deps_path.read_text(encoding="utf-8")
    for lineno, line in enumerate(text.splitlines(), 1):
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        parts = line.split()
        kind = parts[0]
        if kind == "symlink":
            if len(parts) != 3:
                raise ValueError(
                    f"{deps_path}:{lineno}: symlink needs exactly 2 arguments: "
                    f"link_name target_path")
            entries.append(("symlink", (parts[1], parts[2])))
        elif kind == "need":
            if len(parts) != 2:
                raise ValueError(
                    f"{deps_path}:{lineno}: need takes exactly 1 argument: "
                    f"target_path")
            entries.append(("need", (parts[1],)))
        else:
            raise ValueError(
                f"{deps_path}:{lineno}: unknown dependency kind '{kind}'; "
                f"expected 'symlink' or 'need'")
    return entries


def resolve(run_dir, out, err):
    """Process the deps file in run_dir. Returns 0 on success, 1 on failure."""
    deps_path = run_dir / DEPS_FILE
    if not deps_path.is_file():
        return 0

    try:
        entries = parse(deps_path)
    except ValueError as exc:
        print(f"DEPS       {exc}", file=err)
        return 1

    for kind, args in entries:
        if kind == "symlink":
            link_name, target = args
            link_path = run_dir / link_name
            target_resolved = (run_dir / target).resolve()
            if not target_resolved.is_file():
                print(f"DEPS       symlink target does not exist: {target} "
                      f"(resolved to {target_resolved})", file=err)
                return 1
            if link_path.is_symlink() or link_path.exists():
                actual = link_path.resolve()
                if actual == target_resolved:
                    continue
                print(f"DEPS       {link_name} already exists and points to "
                      f"{actual}, not {target_resolved}", file=err)
                return 1
            os.symlink(target, link_path)
            print(f"DEPS       {link_name} -> {target}", file=out)

        elif kind == "need":
            target = args[0]
            target_resolved = (run_dir / target).resolve()
            if not target_resolved.is_file():
                print(f"DEPS       required file does not exist: {target} "
                      f"(resolved to {target_resolved}). Run the upstream "
                      f"unit first.", file=err)
                return 1
            print(f"DEPS       {target} exists", file=out)

    return 0
