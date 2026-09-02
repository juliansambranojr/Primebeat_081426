"""EXPLORATORY price check: does the census arrow survive the UNCONDITIONAL
error shape (MediumPNT: |psi(x)-x| <= A*x*exp(-c*(log x)^(1/10))) instead of
the RH shape (C*sqrt(x)*(log x)^k) that O68's whole grid assumed?

Same construction as Nonvanishing.Ehigh/Mlow:
  Mlow(r,d)   = 0.5 * 2^(r-d-1) * (ln2)^d / r
  Ehigh_unc(r,n) = A * 2^r * exp(-c*((r-n)*ln2)^(1/10)) * (3/2)^n
     (per-value error A*2^(r-k)*exp(...), stencil weights C(n,k), sum 2^-k -> (3/2)^n)
Gate: Ehigh_unc(r,d+1) < Mlow(r,d).
"""
import math
LN2 = math.log(2)

def gate_ok(r, d, c, A=1.0):
    n = d + 1
    if r - n <= 1: return False
    L = ((r - n) * LN2) ** 0.1
    # log of Ehigh/2^r
    lhs = math.log(A) - c * L + n * math.log(1.5)
    # log of Mlow/2^r
    rhs = math.log(0.5) - (d + 1) * LN2 + d * math.log(LN2) - math.log(r)
    return lhs < rhs

def crossover(d, c, A=1.0, rmax=10**12):
    lo, hi = 2, rmax
    if not gate_ok(hi, d, c, A): return None
    while lo < hi:
        mid = (lo + hi) // 2
        if gate_ok(mid, d, c, A): hi = mid
        else: lo = mid + 1
    return lo

print("UNCONDITIONAL shape  A*x*exp(-c*(log x)^(1/10))   [MediumPNT, sorry-free]")
print("smallest r = log2(x) at which the census arrow fires:\n")
print(f"{'c':>8} " + " ".join(f"d={d:<12}" for d in (1,2,3,6,10)))
for c in (10.0, 3.0, 1.0, 0.3, 0.1):
    row = []
    for d in (1,2,3,6,10):
        r = crossover(d, c)
        row.append("never<1e12" if r is None else f"2^{r:.3g}")
    print(f"{c:>8} " + " ".join(f"{v:<14}" for v in row))

print("\nRH shape for comparison (Nonvanishing.Ehigh/Mlow, exact defs):")
def gate_rh(r, d):
    n = d + 1
    E = (LN2 * r / (8*math.pi)) * 2**(r/2) * (1 + 2**-0.5)**n
    M = 0.5 * 2**(r - d - 1) * LN2**d / r
    return E < M
def cross_rh(d):
    for r in range(2, 400):
        if gate_rh(r, d): return r
    return None
print("  " + "  ".join(f"d={d}: r>={cross_rh(d)}" for d in (1,2,3,6,10)))
