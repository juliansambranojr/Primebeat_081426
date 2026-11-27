> Source: session transcript, 2026-11-27

> write the units

From `run/corner.py`, the open corner:

```
def open_(r, d): return d >= 17 and r >= 93 and r < 4 * d + 30 and not (d >= 30 and 3.7 * d + 39 <= r)
```
