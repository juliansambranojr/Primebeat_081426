"""EXPLORATORY. The table with regimes of one half: boundaries at 2^(k/2), k = 0..K.
rung P[k] = primes in (floor 2^((k-1)/2), floor 2^(k/2)],  C[k] = composites there (1 is neither), T[k] = P[k]+C[k].
cell(k,d) = d-th backward difference down the rungs, for P, C and T.
"""
import json, math
import numpy as np
K = 53
NMAX = int(2**(K/2)) + 1
sieve = np.ones(NMAX+1, dtype=bool); sieve[:2] = False
for i in range(2, int(NMAX**0.5)+1):
    if sieve[i]: sieve[i*i::i] = False
cum = np.cumsum(sieve, dtype=np.int64)
B = [int(math.floor(2**(k/2) + 1e-9)) for k in range(K+1)]
for k in range(0, K+1, 2): B[k] = 2**(k//2)
P = [0]*(K+1); C = [0]*(K+1)
for k in range(1, K+1):
    P[k] = int(cum[B[k]] - cum[B[k-1]])
    n = B[k] - B[k-1]
    one = 1 if (B[k-1] < 1 <= B[k]) else 0
    C[k] = n - P[k] - one
def table(seed, D):
    rows = [list(seed)]
    for d in range(1, D+1):
        prev = rows[-1]; rows.append([None]*d + [prev[k]-prev[k-1] for k in range(d, len(prev))])
    return rows
D = 12
TP, TC = table(P, D), table(C, D)
zerosP = [(k, d) for d in range(1, D+1) for k in range(d+1, K+1) if TP[d][k] == 0]
zerosC = [(k, d) for d in range(1, D+1) for k in range(d+1, K+1) if TC[d][k] == 0]
both = sorted(set(zerosP) & set(zerosC))
print("boundaries", B[:14])
print("prime rungs    ", P[1:22])
print("composite rungs", C[1:22])
print("prime zeros (k,d):", zerosP)
print("composite zeros (k,d):", zerosC)
print("both zero:", both)
# the dyadic zeros in half-step coordinates would be at even k
print("depth-1 prime cells k=2..24:", TP[1][2:25])
# totals and shares along a deep row
k = K
print("row k=%d: d, prime cell, composite cell, total, prime share" % k)
for d in range(0, 9):
    p, c = TP[d][k], TC[d][k]; t = p + c
    print(d, p, c, t, round(p/t, 4) if t else None)
# ratio of totals depth to depth, against sqrt2-1
print("total ratio d+1/d at k=%d:" % k, [round((TP[d+1][k]+TC[d+1][k])/(TP[d][k]+TC[d][k]), 4) for d in range(0, 6)], "sqrt2-1 =", round(2**0.5-1, 4))
deepP = [z for z in zerosP if z[0] >= 20]; deepC = [z for z in zerosC if z[0] >= 20]
share0 = TP[0][K] / (TP[0][K] + TC[0][K])
ratio = (TP[1][K] + TC[1][K]) / (TP[0][K] + TC[0][K])
lo = B[K-1] - B[K-2]; hi = B[K] - B[K-1]
out = dict(K=K, top=B[K], depth=D, prime_zeros=len(zerosP), composite_zeros=len(zerosC), both_zero=len(both),
           both_k=both[0][0], both_d=both[0][1],
           deep_prime=[dict(k=k, d=d) for k, d in deepP], deep_composite=[dict(k=k, d=d) for k, d in deepC],
           prime_share_depth0=round(share0, 4), total_ratio=round(ratio, 4), one_minus_inv_sqrt2=round(1 - 2**-0.5, 4),
           lower_half_share=round(lo/(lo+hi), 4), upper_half_share=round(hi/(lo+hi), 4))
json.dump(out, open('halfreg.json', 'w'), indent=1)
