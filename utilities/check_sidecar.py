#!/usr/bin/env python3
"""check_sidecar.py — is every locked prereg's sidecar still verifiable?

WHY. `preregs/FORMAT.md` calls the sidecar "the authority" and "the thing
that pins the text," and it also mandates that the Run record be filled
in after the run. Those two instructions conflict: the second mutates
the file the first pins, so on disk *no* sidecar matches its prereg.
Nothing in the tree recorded how to recover the locked text, so the
guarantee was unfalsifiable in both directions — you could neither
confirm a prereg had not drifted nor discover that it had.

An audit on 2026-08-27 (notes entry 220) found that five of the nine are
recoverable and four are not. This script implements the recovery so the
five stay checkable, and baselines the four so a *tenth* failure is
visible instead of drowning in known ones.

THE RECOVERY. A sidecar is verified if any of these hashes to it:

  as-is            the file exactly as it sits
  stripped         the file truncated immediately before its `## Run
                   record` heading, no trailing newline — this is the
                   text as it stood when the sidecar was cut, and
                   `alpha_depth_trend_v1_locked_20260814.md` says so in
                   its own Run record: "both taken before this section
                   existed"
  git as-committed any blob of the file in git history
  git stripped     any such blob, truncated the same way

The four that fail every one of these were edited in place after
locking rather than only appended to, so their locked text exists
nowhere. That is a real weakening of those four preregs — their
anti-drift guarantee cannot be checked — and it is recorded rather than
quietly baselined: `utilities/sidecar_baseline.txt` carries each with
its reason, and this script prints them as KNOWN, never as PASS.

PREVENTION, now in FORMAT.md: lock the text, COMMIT it, then run. A
committed pre-image makes the `git as-committed` branch always succeed.
`multibase_synthesis_v1_20260827.md` is the first prereg locked that way
and is the only one recoverable through git rather than by stripping.

USE
---
    python3 utilities/check_sidecar.py          # exits 1 on a NEW failure
    python3 utilities/check_sidecar.py --all    # show every prereg's route
"""
import argparse
import hashlib
import os
import re
import subprocess
import sys

_HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(_HERE)
PREREGS = os.path.join(ROOT, "preregs")
BASELINE = os.path.join(_HERE, "sidecar_baseline.txt")

RUN_RECORD = re.compile(r"\n#+ Run record")


def _sha(text):
    return hashlib.sha256(text.encode()).hexdigest()


def _stripped(text):
    """The file as it stood before the Run record section was appended."""
    m = RUN_RECORD.search(text)
    return None if m is None else text[:m.start()]


def _git(*args):
    try:
        r = subprocess.run(["git", "-C", ROOT, *args],
                           capture_output=True, text=True)
        return r.stdout if r.returncode == 0 else ""
    except Exception:
        return ""


def route(rel, want):
    """Return the name of the first recovery route that reproduces `want`."""
    path = os.path.join(ROOT, rel)
    with open(path) as f:
        cur = f.read()

    if _sha(cur) == want:
        return "as-is"
    s = _stripped(cur)
    if s is not None and _sha(s) == want:
        return "stripped"

    if not os.path.isdir(os.path.join(ROOT, ".git")):
        return None                      # no history here; cannot say more
    for rev in _git("log", "--format=%H", "--", rel).split():
        blob = _git("show", f"{rev}:{rel}")
        if not blob:
            continue
        if _sha(blob) == want:
            return f"git as-committed {rev[:8]}"
        s = _stripped(blob)
        if s is not None and _sha(s) == want:
            return f"git stripped {rev[:8]}"
    return None


def baseline():
    """{basename: reason} for sidecars already known unrecoverable."""
    known = {}
    if not os.path.isfile(BASELINE):
        return known
    with open(BASELINE) as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            name, _, reason = line.partition("  ")
            known[name.strip()] = reason.strip()
    return known


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--all", action="store_true",
                    help="print every prereg's recovery route, not just "
                         "the failures")
    args = ap.parse_args()

    if not os.path.isdir(PREREGS):
        return 0                          # nothing to check; stay silent

    known, new, verified = baseline(), [], []
    for fn in sorted(os.listdir(PREREGS)):
        if not fn.endswith(".sha256"):
            continue
        md = fn[:-len(".sha256")] + ".md"
        if not os.path.isfile(os.path.join(PREREGS, md)):
            new.append((md, "sidecar with no prereg beside it"))
            continue
        with open(os.path.join(PREREGS, fn)) as f:
            want = f.read().split()[0]
        r = route(os.path.join("preregs", md), want)
        if r:
            verified.append((md, r))
        elif md in known:
            pass
        else:
            new.append((md, f"sidecar {want[:12]}… matches no recovery "
                            f"route"))

    if args.all:
        for md, r in verified:
            print(f"  VERIFIED  {md:52} via {r}")
        for md in sorted(known):
            print(f"  KNOWN     {md:52} {known[md]}")

    if new:
        print(f"check_sidecar: {len(new)} NEW unverifiable sidecar(s) — "
              f"the locked text has no recoverable pre-image:")
        for md, why in new:
            print(f"  {md}: {why}")
        print("  Lock the text, COMMIT it, then run (preregs/FORMAT.md).")
        return 1

    if not args.all:
        # silent when clean; the counts go to the caller's log, not stdout
        pass
    return 0


if __name__ == "__main__":
    sys.exit(main())
