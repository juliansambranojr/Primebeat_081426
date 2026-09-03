"""Recompute every number unit 0309's prose states, from source.

Reads the transcript at transcript/b01.md and counts findings, decisions, and
design corrections.  Runs pytest and records the count.  Reads the notebook
floor and the unit count from the tree.  Writes figures.json.
"""
import json
import os
import re
import subprocess
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
UNIT = os.path.join(ROOT, "units", "0309-phase-2c-digits-and-sealed-baseline")
TRANSCRIPT = os.path.join(UNIT, "transcript", "b01.md")

# -- transcript counts -------------------------------------------------------

with open(TRANSCRIPT) as f:
    text = f.read()

# Numbered items in the transcript: lines starting with **N.
# The header says "## The seven findings" but numbers 8 items — item 8 is "a
# practice, not a mechanism."  The finding count is the numbered items minus
# that one practice.
numbered_items = len(re.findall(r"^\*\*\d+\.", text, re.M))
practices = 1  # item 8: "a practice, not a mechanism"
findings = numbered_items - practices

# Decisions: bold paragraphs in "## The two decisions"
decisions_section = text.split("## The two decisions")[1].split(
    "## Silent or wrong")[0]
decisions = len(re.findall(r"^\*\*[A-Z]", decisions_section, re.M))

# Design corrections: bullet items in "## Silent or wrong in the design"
corrections_section = text.split("## Silent or wrong in the design")[1].split(
    "\nGates:")[0]
corrections = len(re.findall(r"^- \*\*", corrections_section, re.M))

# Rejection cases in finding 3: "8 rejection cases"
rejection_match = re.search(r"(\d+) rejection cases", text)
rejection_cases = int(rejection_match.group(1)) if rejection_match else 0

# -- notebook floor -----------------------------------------------------------

notebook = os.path.join(ROOT, "notes", "lab_notebook_2.md")
with open(notebook) as f:
    nb_text = f.read()

# The newest entry number — first ## heading with Entry N
entry_match = re.search(r"^## \d{4}-\d{2}-\d{2}\s.*Entry\s+(\d+)", nb_text, re.M)
notebook_floor = int(entry_match.group(1)) if entry_match else 0

# -- unit count (excluding the smoke/fixture units 0000-0004) -----------------

units_dir = os.path.join(ROOT, "units")
unit_dirs = sorted(d for d in os.listdir(units_dir)
                   if os.path.isdir(os.path.join(units_dir, d))
                   and re.match(r"\d{4}-", d))
unit_count = len(unit_dirs)

# -- test suite ---------------------------------------------------------------

result = subprocess.run(
    [sys.executable, "-m", "pytest", "-q", "--tb=no"],
    capture_output=True, text=True, cwd=ROOT,
)
# Parse "NNN passed" from pytest output
passed_match = re.search(r"(\d+) passed", result.stdout)
tests_passed = int(passed_match.group(1)) if passed_match else 0
suite_exit = result.returncode

# -- assemble -----------------------------------------------------------------

figures = {
    "transcript": {
        "numbered_items": numbered_items,
        "practices": practices,
        "findings": findings,
        "decisions": decisions,
        "corrections": corrections,
        "rejection_cases": rejection_cases,
    },
    "tree": {
        "notebook_floor": notebook_floor,
        "unit_count": unit_count,
    },
    "tests": {
        "suite_passed": tests_passed,
        "suite_exit": suite_exit,
    },
}

out = os.path.join(os.path.dirname(__file__), "figures.json")
with open(out, "w") as f:
    json.dump(figures, f, indent=2)
    f.write("\n")

print(f"findings={findings} decisions={decisions} corrections={corrections}")
print(f"rejection_cases={rejection_cases}")
print(f"notebook_floor={notebook_floor} unit_count={unit_count}")
print(f"tests_passed={tests_passed}")
print(f"wrote {out}")
