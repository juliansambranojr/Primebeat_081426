> Source: session transcript, 2026-11-25

> Yes run both measurements please

From `units/0564-basin-floor-conrey/run/basin.py`, Conrey's function through the reduction:

```
Q0 = [1.0, -0.54, -1.44, 0.96]
def V(s):
    return mp.fsum(Q0[k] * (-1.0 / L) ** k * mp.zeta(s, derivative=k) for k in range(4))
```
