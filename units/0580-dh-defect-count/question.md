> Source: session transcript, 2026-11-26

> Run the Turing defect count on Davenport–Heilbronn. It should fail there, and we'd see the verifier reject a bad cookie. It's cheap and closes the question you raised.

From `run/dhdefect.py`, the function:

```
def f_dh(s):
    return 5 ** (-s) * sum(A[j] * mp.zeta(s, mp.mpf(j) / 5) for j in (1, 2, 3, 4))
```
