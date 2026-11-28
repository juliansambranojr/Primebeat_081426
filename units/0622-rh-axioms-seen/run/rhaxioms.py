"""The Lean proof of RH on the Mac: its axioms, and whether its statement is the one the weld names.

Usage: python3 -I rhaxioms.py <clone of leanprover-community/riemann-hypothesis> <Primebeat repo root>

Reads, from the clone: the commit, the toolchain, the Mathlib pin, and `src/Main.lean`'s theorem line. Counts
the project's .olean files and says where they came from (the build log `cache_build.log`, copied in from the
2026-11-27 run: `lake exe cache get`, `lake build`, then `scripts/PrintAxioms.lean`). Runs
`lake env lean scripts/PrintAxioms.lean` again and parses each theorem's axioms. Compares Mathlib's
`RiemannHypothesis` in the clone with the copy the weld checks against,
`utilities/weld_sources/RiemannHypothesis_mathlib_31ce06e.lean`, line for line.

The clone's .olean files came from the repository's prebuilt cache. Printing axioms reads those files; the
kernel did not re-check the proofs from source on this machine in this run. With a third argument, a second
clone built from source with only Mathlib's cache, it also reads that build's log, source_build.log.
"""

import json
import pathlib
import re
import subprocess
import sys

clone = pathlib.Path(sys.argv[1]).expanduser().resolve()
root = pathlib.Path(sys.argv[2]).resolve()
STD = ["propext", "Classical.choice", "Quot.sound"]


def run(argv, cwd):
    return subprocess.run(argv, cwd=cwd, capture_output=True, text=True)


def defn(path):
    lines = path.read_text().splitlines()
    i = next(k for k, l in enumerate(lines) if l.startswith("def RiemannHypothesis"))
    return [l.strip() for l in lines[i:i + 2]]


out = {}
out["commit"] = run(["git", "rev-parse", "HEAD"], clone).stdout.strip()
out["toolchain"] = (clone / "lean-toolchain").read_text().strip()
man = json.loads((clone / "lake-manifest.json").read_text())
out["mathlib_rev"] = next(p["rev"] for p in man["packages"] if p["name"] == "mathlib")
out["main_theorem"] = next(l.strip() for l in (clone / "src" / "Main.lean").read_text().splitlines()
                           if l.startswith("theorem riemannHypothesis"))
out["src_lean_files"] = len(list((clone / "src").rglob("*.lean")))
out["project_oleans"] = len(list((clone / ".lake" / "build").rglob("*.olean")))

log = pathlib.Path("cache_build.log").read_text()
m = re.search(r"downloaded (\d+)/(\d+) \(curl exit (\d+); (\d+) failed SHA-256", log)
out["cache"] = {"downloaded": int(m.group(1)), "of": int(m.group(2)), "failed_sha256": int(m.group(4))}
out["cache_log_built_lines"] = log.count("Built ")

p = run(["lake", "env", "lean", "scripts/PrintAxioms.lean"], clone)
out["axioms_exit"] = p.returncode
ax = {}
for name, lst in re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]", p.stdout):
    got = [a.strip() for a in lst.split(",") if a.strip()]
    ax[name] = {"axioms": got, "count": len(got), "standard_only": sorted(got) == sorted(STD)}
out["axioms"] = ax
out["theorems_printed"] = len(ax)
out["theorems_standard_only"] = sum(1 for v in ax.values() if v["standard_only"])
out["has_sorry_ax"] = "sorryAx" in p.stdout

here = defn(clone / ".lake" / "packages" / "mathlib" / "Mathlib" / "NumberTheory" / "LSeries" / "RiemannZeta.lean")
weld = defn(root / "utilities" / "weld_sources" / "RiemannHypothesis_mathlib_31ce06e.lean")
out["definition_matches_weld_source"] = here == weld
w = run([sys.executable, str(root / "utilities" / "check_weld.py")], root)
out["weld_exit"] = w.returncode
out["welds_broken"] = w.stdout.count("WELD BROKEN")

json.dump(out, open("rhaxioms.json", "w"), indent=1, sort_keys=True)
print(json.dumps({k: out[k] for k in ("commit", "theorems_printed", "theorems_standard_only",
                                     "definition_matches_weld_source", "welds_broken")}))

# The source build, in a second clone with only Mathlib's official cache (`lake exe mathlib/cache get`, then
# `lake build`, then `scripts/PrintAxioms.lean`). Its log is source_build.log, copied in as produced.
src = pathlib.Path(sys.argv[3]).expanduser().resolve() if len(sys.argv) > 3 else None
if src is not None:
    slog = pathlib.Path("source_build.log").read_text()
    s = {"commit": run(["git", "rev-parse", "HEAD"], src).stdout.strip()}
    s["build_exit"] = int(re.search(r"build exit (\d+)", slog).group(1))
    s["build_seconds"] = int(re.search(r"build exit \d+ after (\d+)s", slog).group(1))
    s["axioms_exit"] = int(re.search(r"axioms exit (\d+)", slog).group(1))
    for kind in ("Built", "Replayed", "Restored", "Fetched", "Downloaded"):
        s[kind.lower()] = len(re.findall(rf"\] {kind} ", slog))
    by = {}
    for mod in re.findall(r"\] Built ([A-Za-z]+)", slog):
        by[mod] = by.get(mod, 0) + 1
    s["built_by_prefix"] = by
    s["built_project_modules"] = by.get("Lib", 0) + by.get("New", 0) + by.get("Statements", 0) + by.get("Main", 0)
    sax = {n: [a.strip() for a in l.split(",") if a.strip()]
           for n, l in re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]", slog)}
    s["theorems_printed"] = len(sax)
    s["theorems_standard_only"] = sum(1 for v in sax.values() if sorted(v) == sorted(STD))
    s["has_sorry_ax"] = "sorryAx" in slog
    out["source_build"] = s
    json.dump(out, open("rhaxioms.json", "w"), indent=1, sort_keys=True)
    print(json.dumps(s))
