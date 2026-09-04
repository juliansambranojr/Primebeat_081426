"""Recompute every number unit 0313's prose states, from source.

Counts hook blocks in .claude/settings.json. Checks deleted hook files
are gone from disk. Checks surviving hook files exist. Counts tests in
test_phase7.py. Runs the full test suite. Runs check_refs. Writes
figures.json.
"""
import json
import os
import re
import subprocess
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))

# -- hook blocks in settings.json ---------------------------------------------

settings_path = os.path.join(ROOT, ".claude", "settings.json")
with open(settings_path) as f:
    settings = json.load(f)

hook_blocks = 0
for event, matchers in settings.get("hooks", {}).items():
    hook_blocks += len(matchers)

# -- deleted hook files (should NOT exist) ------------------------------------

deleted_hooks = [
    "check_numbers_in_response.py",
    "check_agent_brief.py",
    "check_read_range.py",
]
hooks_dir = os.path.join(ROOT, "utilities", "hooks")
deleted_count = sum(
    1 for name in deleted_hooks
    if not os.path.exists(os.path.join(hooks_dir, name))
)

# -- surviving hook files (should exist) --------------------------------------

surviving_hooks = [
    "check_response_prefix.py",
    "check_protected_write.py",
]
surviving_count = sum(
    1 for name in surviving_hooks
    if os.path.exists(os.path.join(hooks_dir, name))
)

# -- test_phase7.py test count ------------------------------------------------

test_file = os.path.join(ROOT, "tests", "test_phase7.py")
with open(test_file) as f:
    test_text = f.read()

phase7_test_count = len(re.findall(r"^\s*def test_", test_text, re.M))
# parametrized tests expand: 3 deregistered + 2 retired = 5 extra
phase7_param_tests = 0
for match in re.finditer(
    r'@pytest\.mark\.parametrize\([^,]+,\s*\[(.*?)\]', test_text, re.S
):
    items = match.group(1).strip().split(",")
    items = [i.strip() for i in items if i.strip()]
    # each parametrize expands to len(items) tests, replacing 1 def
    phase7_param_tests += len(items) - 1

phase7_total_tests = phase7_test_count + phase7_param_tests

# -- test_phase2c.py fixed tests ----------------------------------------------

test_phase2c = os.path.join(ROOT, "tests", "test_phase2c.py")
with open(test_phase2c) as f:
    phase2c_text = f.read()

phase2c_test_count = len(re.findall(r"^\s*def test_", phase2c_text, re.M))

# -- full test suite -----------------------------------------------------------

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
    "hooks": {
        "hook_blocks": hook_blocks,
        "deleted_confirmed": deleted_count,
        "surviving_confirmed": surviving_count,
    },
    "tests": {
        "phase7_test_count": phase7_total_tests,
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

print(f"hooks: {hook_blocks} blocks in settings.json")
print(f"hooks: {deleted_count} deleted confirmed gone, "
      f"{surviving_count} surviving confirmed present")
print(f"tests: {phase7_total_tests} phase7 tests")
print(f"tests: {tests_passed} passed (exit {suite_exit})")
print(f"check_refs: exit {refs_exit}")
print(f"wrote {out}")
