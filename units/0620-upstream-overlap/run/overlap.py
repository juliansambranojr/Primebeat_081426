"""Which of this repo's topics Mathlib, PNT+ and IEANTN already hold.

Usage: python3 -I overlap.py <repo root>

Three readings, written to overlap.json, with the file paths each search
returned in overlap_paths.txt:

1. GitHub code search, one query per topic per project, restricted to Lean
   files. GitHub allows 10 code searches a minute, so one every 7 seconds.
2. The same words grepped in the local copies of Mathlib and PNT+ that
   lean_stage3/ builds against (PNT+ pin 47fa486). Code search is known to miss
   files, and this is the cross-check.
3. Pull requests and issues by juliansambranojr in Mathlib and PNT+.
"""

import json
import os
import subprocess
import sys
import time

ROOT = os.path.abspath(sys.argv[1])
REPOS = {
    "mathlib": "leanprover-community/mathlib4",
    "pnt": "AlexKontorovich/PrimeNumberTheoremAnd",
    "ieantn": "teorth/IEANTN",
}
# key, GitHub query, local grep word (None: not grepped)
TOPICS = [
    ("difference_table", '"difference table"', "difference table"),
    ("primecounting_pow2", '"primeCounting (2 ^"', "primeCounting (2 ^"),
    ("legendre", "Legendre", None),
    ("landau", '"Landau"', None),
    ("hardyz", "hardyZ", "hardyZ"),
    ("levinson", '"Levinson"', "Levinson"),
    ("turing", '"Turing"', "Turing"),
    ("stirling", '"Stirling"', None),
    ("digamma", "digamma", None),
    ("conrey", '"Conrey"', "Conrey"),
    ("littlewood", '"Littlewood"', "Littlewood"),
    ("backlund", '"Backlund"', None),
    ("schoenfeld", '"Schoenfeld"', None),
    ("explicit_formula", '"explicit formula"', None),
    ("weil", '"Weil"', None),
    ("riemannhypothesis", '"RiemannHypothesis"', "RiemannHypothesis"),
    ("fwddiff", "fwdDiff", "fwdDiff"),
]
LOCAL = {
    "mathlib": os.path.join(ROOT, "lean_stage3/.lake/packages/mathlib/Mathlib"),
    "pnt": os.path.join(ROOT, "lean_stage3/.lake/packages/PrimeNumberTheoremAnd/PrimeNumberTheoremAnd"),
}


def gh(args):
    r = subprocess.run(["gh", "api"] + args, capture_output=True, text=True)
    if r.returncode != 0:
        raise SystemExit("gh api failed: " + " ".join(args) + "\n" + r.stderr + r.stdout)
    return json.loads(r.stdout)


def code_search(q, repo):
    d = gh(["-X", "GET", "search/code", "-f", f"q={q} repo:{repo} language:Lean", "-f", "per_page=10"])
    return d["total_count"], [i["path"] for i in d["items"]]


def local_files(word, base):
    r = subprocess.run(["grep", "-rlF", word, base], capture_output=True, text=True)
    return [p for p in r.stdout.splitlines() if p]


out = {"search": {}, "local": {}, "authored": {}}
paths = []
for key, q, word in TOPICS:
    out["search"][key] = {}
    for short, repo in REPOS.items():
        n, ps = code_search(q, repo)
        out["search"][key][short] = n
        paths.append(f"search\t{key}\t{short}\t{n}\t{', '.join(ps)}")
        time.sleep(7)
    if word is not None:
        out["local"][key] = {}
        for short, base in LOCAL.items():
            fs = local_files(word, base)
            out["local"][key][short] = len(fs)
            rel = [os.path.relpath(f, base) for f in fs[:10]]
            paths.append(f"local\t{key}\t{short}\t{len(fs)}\t{', '.join(rel)}")

for short in ("mathlib", "pnt"):
    d = gh(["-X", "GET", "search/issues", "-f", f"q=repo:{REPOS[short]} author:juliansambranojr"])
    out["authored"][short] = d["total_count"]
    time.sleep(3)

with open("overlap.json", "w") as f:
    json.dump(out, f, indent=1, sort_keys=True)
with open("overlap_paths.txt", "w") as f:
    f.write("\n".join(paths) + "\n")
print(json.dumps(out["authored"]))
print(f"{len(TOPICS)} topics, {len(TOPICS) * len(REPOS)} code searches")
