#!/usr/bin/env python3
"""Report what this environment can run, and what it cannot.

`requirements.txt` cannot capture the whole environment: `primecountpy` links
against a native `primecount` binary that pip does not install. So a fresh
checkout with the requirements satisfied still fails on 23 of the 59 scripts,
with an import error that does not say why.

This says why, up front, and names exactly which scripts are affected.

    python3 utilities/check_env.py

Exit 0 if everything needed is present, 1 otherwise. Nothing is installed,
nothing is modified.
"""
import importlib, pathlib, re, subprocess, sys

ROOT = pathlib.Path(__file__).resolve().parent.parent

# module name -> (pip name, what breaks without it)
DEPS = {
    "numpy":       ("numpy",       "almost everything"),
    "mpmath":      ("mpmath",      "every script using li() or high precision"),
    "sympy":       ("sympy",       "a few prime utilities"),
    "matplotlib":  ("matplotlib",  "the plotting scripts (O59, O60)"),
    "primecountpy": ("primecountpy", "every script that counts primes"),
    "connes_cvs":  ("connes-cvs",  "O20, O21 — the Connes-van Suijlekom work"),
}


def scripts_importing(mod):
    out = []
    pat = re.compile(rf"^\s*(?:from\s+{mod}\b|import\s+{mod}\b)", re.M)
    for p in sorted(ROOT.glob("*.py")):
        try:
            if pat.search(p.read_text()):
                out.append(p.name)
        except Exception:
            pass
    return out


def main():
    print("Primebeat — environment check\n")
    print(f"python {sys.version.split()[0]}   ({sys.executable})")
    if sys.version_info < (3, 11):
        print("   WARNING: developed on 3.14; older versions untested")
    print()

    missing = []
    print(f"{'module':>14}  {'status':>9}  {'version':>10}   needed for")
    for mod, (pip, why) in DEPS.items():
        try:
            m = importlib.import_module(mod)
            v = getattr(m, "__version__", "?")
            print(f"{mod:>14}  {'present':>9}  {str(v):>10}   {why}")
        except Exception:
            missing.append((mod, pip, why))
            print(f"{mod:>14}  {'MISSING':>9}  {'-':>10}   {why}")

    # the native binary, which pip cannot supply
    print()
    try:
        r = subprocess.run(["primecount", "--version"], capture_output=True,
                           text=True, timeout=10)
        line = (r.stdout or r.stderr).splitlines()[0]
        print(f"primecount binary: {line}")
    except Exception:
        print("primecount binary: NOT ON PATH")
        print("   primecountpy links against it. Install separately:")
        print("     macOS   brew install primecount")
        print("     source  https://github.com/kimwalisch/primecount")

    # what is actually blocked
    if missing:
        print("\nBlocked scripts:")
        for mod, pip, _ in missing:
            hits = scripts_importing(mod)
            print(f"   {pip} missing -> {len(hits)} script(s)")
            for h in hits[:6]:
                print(f"      {h}")
            if len(hits) > 6:
                print(f"      … and {len(hits) - 6} more")

    # what always works
    print("\nAlways runnable, no dependencies at all:")
    print("   four_zeros.py                 the four exact zeros")
    print("   utilities/check_refs.py       citation resolution")
    print("   utilities/check_values.py     numbers traced to artifacts")

    print("\nLean is separate and needs only elan:")
    print("   cd lean && lake exe cache get && lake build")
    print("   do NOT run `lake update` — four deps track main")

    if missing:
        print(f"\n{len(missing)} missing. Install with:")
        print(f"   pip install {' '.join(p for _, p, _ in missing)}")
        return 1
    print("\nAll present.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
