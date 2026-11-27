> Source: session transcript, 2026-11-25

> Yes to all please

From `units/0554-gram-rosser/run/gram.py`, the test of a Gram point:

```
for n in range(-1, N):
    g = mp.grampoint(n)
    z = mp.siegelz(g)
    s = (-1)**n * z
    signs.append((n, float(g), float(s)))
    if s <= 0: bad.append(n)
```
