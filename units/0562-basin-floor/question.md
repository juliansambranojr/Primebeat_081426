> Source: session transcript, 2026-11-25

> Yes

From `units/0562-basin-floor/run/basin.py`, the floor of a basin:

```
    floors = []
    for (a, b) in basins:
        vals = []
        for j in range(SAMP):
            t = a + (b - a) * (j + 0.5) / SAMP
            vals.append(float(abs(Vleft[t] * psi(mp.mpc(s0, t))) ** 2))
        floors.append(sum(vals) / SAMP)
```
