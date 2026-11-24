"""The integers' errors, Möbius-signed, against their sizes and the square root. EXPLORATORY.
NoHoles.holes_resid: psi(N) = sum_k mu(k) S(N/k) + sum_k mu(k) e(N/k), with
S(M) = M log M - M and e(M) = log M! - S(M), |e(M)| <= log M + 1 (log_factorial_close).
Per N: the signed error sum; the bound from sizes alone, sum_k |e(N/k)|; sqrt N;
the signed smooth sum less N."""
import math, json
import numpy as np
out = {}
for N in (10**4, 10**5, 10**6, 10**7):
    mu = np.ones(N + 1, np.int8); mu[0] = 0
    sieve = np.ones(N + 1, bool); sieve[:2] = False
    for p in range(2, N + 1):
        if sieve[p]:
            sieve[p*p::p] = False
            mu[p::p] *= -1
            mu[p*p::p*p] = 0
    lf = np.concatenate([[0.0], np.cumsum(np.log(np.arange(1, N + 1)))])
    M = np.arange(N + 1, dtype=float)
    S = np.where(M > 0, M * np.log(np.maximum(M, 1)) - M, 0.0)
    e = lf - S
    q = N // np.arange(1, N + 1)
    signed = float((mu[1:] * e[q]).sum()); sizes = float(np.abs(e[q]).sum())
    row = dict(signed=round(signed, 1), sizes=round(sizes, 1), sqrtN=round(math.sqrt(N), 1),
               signed_over_sqrt=round(abs(signed) / math.sqrt(N), 3),
               sizes_over_N=round(sizes / N, 4), sizes_over_sqrt=round(sizes / math.sqrt(N), 1),
               smooth_minus_N=round(float((mu[1:] * S[q]).sum() - N), 1))
    out[f"e{int(round(math.log10(N)))}"] = row; print(N, row, flush=True)
json.dump(out, open("holes.json", "w"), indent=1)
