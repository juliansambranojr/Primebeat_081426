"""Recompute every number unit 0310's prose states, from source.

Reads INDEX.md and INDEX-values.tsv for unit/key counts. Counts tests in
test_phase3.py. Runs pytest for the total count. Counts lines in
lab/index.py. Writes figures.json.
"""
import json
import os
import re
import subprocess
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))

# -- INDEX.md counts -----------------------------------------------------------

index_md = os.path.join(ROOT, "INDEX.md")
with open(index_md) as f:
    index_text = f.read()

# Total units: parse "N units:" from the header
unit_count_match = re.search(r"^(\d+) units:", index_text, re.M)
index_unit_count = int(unit_count_match.group(1)) if unit_count_match else 0

# Sealed/unsealed from the header "N sealed, M unsealed"
sealed_match = re.search(r"(\d+) sealed, (\d+) unsealed", index_text)
index_sealed = int(sealed_match.group(1)) if sealed_match else 0
index_unsealed = int(sealed_match.group(2)) if sealed_match else 0

# Total keys: parse "N values.tsv keys across"
keys_match = re.search(r"^(\d+) values\.tsv keys across", index_text, re.M)
index_total_keys = int(keys_match.group(1)) if keys_match else 0

# Count type sections: lines starting with "### "
type_sections = re.findall(r"^### (.+)$", index_text, re.M)
index_type_count = len(type_sections)

# -- INDEX-values.tsv counts ---------------------------------------------------

index_values = os.path.join(ROOT, "INDEX-values.tsv")
with open(index_values) as f:
    iv_lines = f.readlines()

# Data lines are those not starting with #
reverse_map_keys = sum(1 for line in iv_lines if line.strip() and not line.startswith("#"))

# -- lab/index.py line count ---------------------------------------------------

index_py = os.path.join(ROOT, "lab", "index.py")
with open(index_py) as f:
    index_py_lines = sum(1 for _ in f)

# -- test_phase3.py test count -------------------------------------------------

test_file = os.path.join(ROOT, "tests", "test_phase3.py")
with open(test_file) as f:
    test_text = f.read()

phase3_test_count = len(re.findall(r"^def test_", test_text, re.M))

# -- modified files count (from transcript) ------------------------------------

transcript = os.path.join(
    ROOT, "units", "0310-phase-3-index-both-directions", "transcript", "b01.md"
)
with open(transcript) as f:
    t_text = f.read()

# New files: lines starting with "- `" under "**New files created:**"
new_section = t_text.split("**New files created:**")[1].split("**Modified files:**")[0]
new_files = len(re.findall(r"^- `", new_section, re.M))

# Modified files: lines starting with "- `" under "**Modified files:**"
mod_section = t_text.split("**Modified files:**")[1].split("**Count-slot strip:**")[0]
modified_files = len(re.findall(r"^- `", mod_section, re.M))

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
    "index_md": {
        "unit_count": index_unit_count,
        "sealed": index_sealed,
        "unsealed": index_unsealed,
        "total_keys": index_total_keys,
        "type_count": index_type_count,
    },
    "index_values": {
        "reverse_map_keys": reverse_map_keys,
    },
    "source": {
        "index_py_lines": index_py_lines,
        "phase3_test_count": phase3_test_count,
        "new_files": new_files,
        "modified_files": modified_files,
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

print(f"index_md: {index_unit_count} units ({index_sealed} sealed, "
      f"{index_unsealed} unsealed), {index_total_keys} keys, "
      f"{index_type_count} types")
print(f"index_values: {reverse_map_keys} reverse map keys")
print(f"source: index.py {index_py_lines} lines, "
      f"{phase3_test_count} phase3 tests, "
      f"{new_files} new files, {modified_files} modified files")
print(f"tests: {tests_passed} passed")
print(f"check_refs: exit {refs_exit}")
print(f"wrote {out}")
