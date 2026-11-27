> Source: session transcript, 2026-11-27

> check how far Kronecker–Weyl reaches here

From `run/reach.py`, the rest against the leader:

```
        row[f"d{d}"] = {"leader": round(float(g[i]), 3), "rest_rms_over_leader": round(float(np.sqrt(w.sum() - 1)), 4)}
```
