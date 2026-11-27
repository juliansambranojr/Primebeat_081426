> Source: session transcript, 2026-11-26

> Ok, so my posit is that in every b-advice table that same cell is the flow moving toward the zero that sits underneath it. Imagine every b-advice table is a slice of time in steps. The actual balance isn't even in a dyadic table it might be in a .25 table

From `run/bases.py`, the cell as the base moves:

```
bs = np.linspace(1.9, 2.1, 4001); v = np.array([cell(b, 2**20, 6) for b in bs])
```
