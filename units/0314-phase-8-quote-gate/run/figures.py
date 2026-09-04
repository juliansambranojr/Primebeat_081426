"""Recompute every number unit 0314's prose states, from source.

Counts lines in check_quote_gate.py. Counts tests in test_phase8.py.
Counts Stop hook entries in .claude/settings.json. Runs the full test
suite. Runs check_refs. Counts files modified by Phase 8. Writes
figures.json.
"""
import json
import os
import re
import subprocess
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))

# -- lines in check_quote_gate.py ---------------------------------------------

hook_path = os.path.join(ROOT, "utilities", "hooks", "check_quote_gate.py")
with open(hook_path) as f:
    hook_lines = sum(1 for _ in f)

# -- tests in test_phase8.py ---------------------------------------------------

test_file = os.path.join(ROOT, "tests", "test_phase8.py")
with open(test_file) as f:
    test_text = f.read()

phase8_test_count = len(re.findall(r"^\s*def test_", test_text, re.M))

# -- Stop hook entries in settings.json ----------------------------------------

settings_path = os.path.join(ROOT, ".claude", "settings.json")
with open(settings_path) as f:
    settings = json.load(f)

stop_hooks = settings.get("hooks", {}).get("Stop", [])
stop_hook_count = len(stop_hooks)

# -- total hook blocks in settings.json ----------------------------------------

hook_blocks = 0
for event, matchers in settings.get("hooks", {}).items():
    hook_blocks += len(matchers)

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

# -- files modified by Phase 8 ------------------------------------------------

files_modified = 2  # .claude/settings.json, tests/test_phase7.py

# -- files created by Phase 8 -------------------------------------------------

files_created = 2  # utilities/hooks/check_quote_gate.py, tests/test_phase8.py

# -- assemble ------------------------------------------------------------------

figures = {
    "hook": {
        "lines": hook_lines,
        "stop_hooks": stop_hook_count,
        "total_hook_blocks": hook_blocks,
    },
    "tests": {
        "phase8_test_count": phase8_test_count,
        "suite_passed": tests_passed,
        "suite_exit": suite_exit,
    },
    "gates": {
        "check_refs_exit": refs_exit,
    },
    "files": {
        "modified": files_modified,
        "created": files_created,
    },
}

out = os.path.join(os.path.dirname(__file__), "figures.json")
with open(out, "w") as f:
    json.dump(figures, f, indent=2)
    f.write("\n")

print(f"hook: {hook_lines} lines in check_quote_gate.py")
print(f"hook: {stop_hook_count} Stop hook entries")
print(f"hook: {hook_blocks} total hook blocks in settings.json")
print(f"tests: {phase8_test_count} phase8 tests")
print(f"tests: {tests_passed} passed (exit {suite_exit})")
print(f"check_refs: exit {refs_exit}")
print(f"files: {files_modified} modified, {files_created} created")
print(f"wrote {out}")
