> Source: session transcript, 2026-11-27

> All three

The first of the three, as offered: "push the unconditional census as far as computation allows: rows 21–26 with Legendre, and write that up as a dated result."

From `run/census.py`, the census the Lean file states:

```
zeros=[[r,d] for r in range(1,21) for d in range(1,r) if T[(r,d)]==0]
```
