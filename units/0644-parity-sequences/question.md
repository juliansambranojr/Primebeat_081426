> Source: session transcript, 2026-11-28

> Is there a pattern in the rows when you look at  the rows you did work on?

From `run/parity_seq.py`:

```
def runs(x): return 1 + sum(x[i] != x[i - 1] for i in range(1, len(x)))
```
