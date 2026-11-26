> Source: session transcript, 2026-11-26

> What does this all tell us?

> Yes please

From `run/parts.py`, the split of `wobble_balance`:

```
    A = float(np.sum(s * (N / d))); B = float(np.sum(s * ((N % d) / d - 0.5))); C = 0.5 * float(s.sum())
```
