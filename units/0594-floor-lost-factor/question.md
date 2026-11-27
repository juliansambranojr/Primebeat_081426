> Source: session transcript, 2026-11-26

> (1) depths 12 and up in the middle band (d up to about r/3): the gate (Interpolant.tableFrom_ne_zero_of_relErr_liRow) with the needed bound, census below where each depth closes

From `run/floor.py`, the two floors:

```
def exact(r, d): return sum((-1)**k * math.comb(d, k) * s(r-k) for k in range(d+1))
def mlow(r, d): return mpf(0.5) * mpf(2)**(r-d-1) * L2**d / r
```
