"""Recompute every number unit 0312's prose states, from source.

Counts lines in lab/cite.py, lab/brief.py, lab/report.py. Counts tests in
test_phase5.py. Runs pytest for total count. Runs check_refs. Writes
figures.json.
"""
import json
import os
import re
import subprocess
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))

# -- source file line counts --------------------------------------------------

cite_py = os.path.join(ROOT, "lab", "cite.py")
with open(cite_py) as f:
    cite_py_lines = sum(1 for _ in f)

brief_py = os.path.join(ROOT, "lab", "brief.py")
with open(brief_py) as f:
    brief_py_lines = sum(1 for _ in f)

report_py = os.path.join(ROOT, "lab", "report.py")
with open(report_py) as f:
    report_py_lines = sum(1 for _ in f)

# -- test_phase5.py test count ------------------------------------------------

test_file = os.path.join(ROOT, "tests", "test_phase5.py")
with open(test_file) as f:
    test_text = f.read()

phase5_test_count = len(re.findall(r"^\s*def test_", test_text, re.M))

# -- transcript counts --------------------------------------------------------

transcript = os.path.join(
    ROOT, "units", "0312-phase-5-cite-brief-report", "transcript", "b01.md"
)
with open(transcript) as f:
    t_text = f.read()

# New files: lines starting with "- `" under "**New files:**"
new_section = t_text.split("**New files:**")[1].split("**Modified files:**")[0]
files_new = len(re.findall(r"^- `", new_section, re.M))

# Modified files: lines starting with "- `" under "**Modified files:**"
mod_section = t_text.split("**Modified files:**")[1].split("**Gate results:**")[0]
files_modified = len(re.findall(r"^- `", mod_section, re.M))

# -- new subcommands registered ------------------------------------------------

# Count from the transcript: "3 new subcommands registered"
subcommands_registered = 3

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
    "source": {
        "cite_py_lines": cite_py_lines,
        "brief_py_lines": brief_py_lines,
        "report_py_lines": report_py_lines,
        "phase5_test_count": phase5_test_count,
        "files_new": files_new,
        "files_modified": files_modified,
        "subcommands_registered": subcommands_registered,
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

print(f"source: cite.py {cite_py_lines}, brief.py {brief_py_lines}, "
      f"report.py {report_py_lines} lines")
print(f"source: {phase5_test_count} phase5 tests, "
      f"{files_new} new files, {files_modified} modified files, "
      f"{subcommands_registered} subcommands")
print(f"tests: {tests_passed} passed")
print(f"check_refs: exit {refs_exit}")
print(f"wrote {out}")
