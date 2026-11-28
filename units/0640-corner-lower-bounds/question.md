> Source: session transcript, 2026-11-27

> A lower bound for the near-harmonic almost-periodic sums (the leader plus the near-harmonic family, units 0609–0615) at every cell along a diagonal whose leaders change. Measure whether any such bound is in reach. Use more zeros than the 2000 used before if that helps (Odlyzko's tables).

> so log the units, commit and push, along with your questions in notes/corner-questions.md

From `run/diag.py`, each cell carried divided by its scale:

```
lsc = ri * L2 / 2 + di * LG
```
