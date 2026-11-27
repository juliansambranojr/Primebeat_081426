> Source: session transcript, 2026-11-25

> Yes to all please

It answered the proposal to measure the zeros of V_Q right of the line on test stretches, for the chain's step 2.

From `run/rightzeros.py`, how V_Q is built:

```
def make_V(q, L):
    def V(s):
        return mp.fsum(q[k] * (-1.0 / L) ** k * mp.zeta(s, derivative=k) for k in range(len(q)))
    return V
```
