> Source: session transcript, 2026-11-26

> You don't have to connect it to zeta because zeta is imaginary. Start with a zeta zero and run that function and the numbers should fall out

> Lock it

From `run/O98_golden_step_basin.py`, the decision rule as locked:

```
def decide(S, pval, ok):
    if not ok: return "compromised"
    if S >= 0.5 and pval < 0.001: return "falls_out"
    if pval >= 0.05: return "does_not_fall_out"
    return "ambiguous"
```
