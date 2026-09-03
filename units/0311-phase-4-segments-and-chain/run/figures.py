"""Recompute every number unit 0311's prose states, from source.

Reads lab/chain.py for line count. Counts tests in test_phase4.py. Parses
CHAIN.tsv for segment/unit/gap/fork counts. Runs pytest for total count.
Writes figures.json.
"""
import json
import os
import re
import subprocess
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))

# -- lab/chain.py line count ---------------------------------------------------

chain_py = os.path.join(ROOT, "lab", "chain.py")
with open(chain_py) as f:
    chain_py_lines = sum(1 for _ in f)

# -- CHAIN.tsv counts ---------------------------------------------------------

chain_tsv = os.path.join(ROOT, "CHAIN.tsv")
with open(chain_tsv) as f:
    chain_text = f.read()

# Parse header: "N segment(s), M unit(s) in chain, K with no follows: field,
#                G gap(s), F fork(s)."
header_match = re.search(
    r"(\d+) segment\(s\), (\d+) unit\(s\) in chain, "
    r"(\d+) with no follows: field, (\d+) gap\(s\), (\d+) fork\(s\)",
    chain_text,
)
chain_segments = int(header_match.group(1)) if header_match else 0
chain_units = int(header_match.group(2)) if header_match else 0
chain_unchained = int(header_match.group(3)) if header_match else 0
chain_gaps = int(header_match.group(4)) if header_match else 0
chain_forks = int(header_match.group(5)) if header_match else 0

# -- test_phase4.py test count ------------------------------------------------

test_file = os.path.join(ROOT, "tests", "test_phase4.py")
with open(test_file) as f:
    test_text = f.read()

phase4_test_count = len(re.findall(r"^\s*def test_", test_text, re.M))

# -- transcript counts --------------------------------------------------------

transcript = os.path.join(
    ROOT, "units", "0311-phase-4-segments-and-chain", "transcript", "b01.md"
)
with open(transcript) as f:
    t_text = f.read()

# Files created: lines starting with "- `" under "**Files created:**"
created_section = t_text.split("**Files created:**")[1].split("**Modified files:**")[0]
files_created = len(re.findall(r"^- `", created_section, re.M))

# Modified files: lines starting with "- `" under "**Modified files:**"
mod_section = t_text.split("**Modified files:**")[1].split("**Gate results:**")[0]
files_modified = len(re.findall(r"^- `", mod_section, re.M))

# -- test suite ----------------------------------------------------------------

result = subprocess.run(
    [sys.executable, "-m", "pytest", "-q", "--tb=no"],
    capture_output=True, text=True, cwd=ROOT,
)
passed_match = re.search(r"(\d+) passed", result.stdout)
tests_passed = int(passed_match.group(1)) if passed_match else 0
suite_exit = result.returncode

# -- check_refs ----------------------------------------------------------------

refs_result = subprocess.run(
    [sys.executable, os.path.join(ROOT, "utilities", "check_refs.py")],
    capture_output=True, text=True, cwd=ROOT,
)
refs_exit = refs_result.returncode

# -- assemble ------------------------------------------------------------------

figures = {
    "chain_tsv": {
        "segments": chain_segments,
        "units_in_chain": chain_units,
        "unchained": chain_unchained,
        "gaps": chain_gaps,
        "forks": chain_forks,
    },
    "source": {
        "chain_py_lines": chain_py_lines,
        "phase4_test_count": phase4_test_count,
        "files_created": files_created,
        "files_modified": files_modified,
    },
    "tests": {
        "suite_passed": tests_passed,
        "suite_exit": suite_exit,
    },
    "gates": {
        "check_refs_exit": refs_exit,
    },
}

out = os.path.join(os.path.dirname(__file__), "figures.json")
with open(out, "w") as f:
    json.dump(figures, f, indent=2)
    f.write("\n")

print(f"chain_tsv: {chain_segments} segments, {chain_units} units in chain, "
      f"{chain_unchained} unchained, {chain_gaps} gaps, {chain_forks} forks")
print(f"source: chain.py {chain_py_lines} lines, "
      f"{phase4_test_count} phase4 tests, "
      f"{files_created} files created, {files_modified} files modified")
print(f"tests: {tests_passed} passed")
print(f"check_refs: exit {refs_exit}")
print(f"wrote {out}")
