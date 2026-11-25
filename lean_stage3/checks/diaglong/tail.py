"""Size check for block S13, B3 step 1 (Stage3/DiagLong.lean): the diagonal at any length.

Exploratory; nothing here is a proof.

The diagonal's error after the shift is, pair by pair, I = sum_{h,k<=M} C_hk R_hk(0) e(h'k'),
with h' = h/(h,k), k' = k/(h,k), C_hk R_hk(0) = mu(h)mu(k)P(log(M/h)/log M)P(log(M/k)/log M)
(h,k)/(hk) at alpha = beta = 0, and e(x) ~ 0 for x << T, e(x) ~ -w(0) zeta(1+alpha+beta) ~ -T L
for x >> T. So I/T ~ -L * tail(T), tail(X) = sum over h'k' > X, and StmtDiagErr (I = O(T/L))
needs L^2 * tail(T) -> 0. The pairs with h'k' > T exist only when M^2 > T, i.e. theta > 1/2.

Printed, for P(x) = x, M = T^theta, X = T:
  L*S0      L times the full sum S(0,0,0) (size 1/L: Young's main term is zeta*S0 ~ O(1))
  L2tail    L^2 times the signed tail: the quantity StmtDiagErr needs to vanish
  L2abs     L^2 times the tail of |C R| : what any bound without cancellation in mu pays
  npairs    the number of squarefree pairs with h'k' > T

Part 1 prints Young's exponent: with Re u = Re v = d, Re s = -sig, and the 1/zeta factors of
(6.2) kept right of Re = 1 (sig <= d), the shifted integral is T^(1 + 2 theta d - sig) at best
T^(1 + d(2 theta - 1)).
"""
import math
import numpy as np


def mobius(n):
    mu = np.ones(n + 1, dtype=np.int64)
    mu[0] = 0
    is_p = np.ones(n + 1, dtype=bool)
    is_p[:2] = False
    for p in range(2, n + 1):
        if is_p[p]:
            is_p[2 * p::p] = False
            mu[p::p] *= -1
            mu[p * p::p * p] = 0
    return mu


def tails(M, theta):
    L = math.log(M) / theta          # L = log T, T = M^(1/theta)
    X = math.exp(L)
    mu = mobius(M)
    sf = np.nonzero(mu)[0]
    sf = sf[sf >= 1]
    logM = math.log(M)
    Pw = np.log(M / sf.astype(float)) / logM       # P(x) = x
    c = mu[sf] * Pw / sf                           # mu(h) P(..) / h
    S0 = 0.0
    tail = 0.0
    tabs = 0.0
    npairs = 0
    kk = sf.astype(np.int64)
    for i, h in enumerate(sf):
        g = np.gcd(h, kk)
        hp = h // g
        kp = kk // g
        w = c[i] * c * g
        S0 += w.sum()
        m = (hp.astype(float) * kp.astype(float)) > X
        if m.any():
            tail += w[m].sum()
            tabs += np.abs(w[m]).sum()
            npairs += int(m.sum())
    return L, S0, tail, tabs, npairs


def main():
    print("Part 1: Young's shifted line, exponent of T at Re u = Re v = d = 0.05, sig = d")
    for theta in (0.25, 0.4, 0.49, 0.5, 0.55, 4 / 7, 0.75, 1.0, 2.0):
        d = 0.05
        print(f"  theta={theta:.4f}  exponent={1 + 2 * theta * d - d:.4f}  "
              f"{'below 1' if 1 + 2 * theta * d - d < 1 else 'NOT below 1'}")
    print()
    print("Part 2: the tail of the diagonal, P(x) = x, alpha = beta = 0")
    print(f"{'theta':>6} {'M':>6} {'L':>7} {'L*S0':>9} {'L2tail':>10} {'L2abs':>10} {'npairs':>9}")
    for theta in (0.45, 0.6, 0.75, 1.0):
        for M in (1000, 2000, 4000, 8000, 16000):
            L, S0, tail, tabs, npairs = tails(M, theta)
            print(f"{theta:6.3f} {M:6d} {L:7.3f} {L * S0:9.5f} {L * L * tail:10.5f} "
                  f"{L * L * tabs:10.4f} {npairs:9d}", flush=True)


if __name__ == "__main__":
    main()
