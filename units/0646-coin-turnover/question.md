> Source: session transcript, 2026-11-28

> Why I'm sharing this because what if every depth is a coin flip and every regime is a starting face? Does that help us understand a pattern within the chance of the parity

> Run it

From `run/sign.py`, the turnover test:

```
    o["parents_opposite"], _ = share(cells, lambda c: sg(T[(c[0], c[1] - 1)]) != sg(T[(c[0] - 1, c[1] - 1)]) if T[(c[0], c[1] - 1)] and T[(c[0] - 1, c[1] - 1)] else None)
```
