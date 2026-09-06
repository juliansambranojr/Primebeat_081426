> Source: session transcript, 2026-09-06 (this session), after the probe's outcome was reported

> yes to the notebook entry on loop vs checker. then come back and lets discuss

From `units/0340-probe-loop-transfer/run/report.md`, the agent's finding:

```
1. Step 7 contradicts the gate it commits through. "Any recipe edit bumps `version:` above and is committed with the unit that caused it" cannot happen: `check_lean_unit.py`'s LOOP check demands the unit's `loop_version` equal LOOP.md's current `version:`, and the pre-commit runs it on every staged Lean unit.
```

From `utilities/check_lean_unit.py` before the fix (commit 654150c):

```
    elif vals.get("loop_version") != loop_version:
        fails.append(f"LOOP     values loop_version={vals.get('loop_version')} but LOOP.md version={loop_version}")
```
