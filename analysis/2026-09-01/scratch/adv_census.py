#!/usr/bin/env python3
"""Independent re-derivation of the census price. Nothing reused from the
prior agent's scratch. Adversarial check of the analysis under test."""
import math
from mpmath import mp, mpf, log as mlog, exp as mexp, sqrt as msqrt
mp.dps = 50

LOG2 = math.log(2)
O43 = 92          # O68_weak_bound_tolerance.py:39
GATE = O43 + 1    # line 108: Rs[d] <= O43_EXTENT + 1

# ---------------------------------------------------------------- O68 machinery
def M_low(r, d):
    "O68_weak_bound_tolerance.py:53-54"
    return mpf('0.5') * mpf(2) ** (r - d - 1) * mpf(LOG2) ** d / r

def E_high_RH(r, d, C, k):
    "O68_weak_bound_tolerance.py:57-59 -- C sqrt(x) (log x)^k shape"
    return (mpf(C) * (mpf(r) * LOG2) ** k * mpf(2) ** (mpf(r) / 2)
            * mpf(1 + 2 ** -0.5) ** (d + 1))

# ---------------------------------------------------------------- my derivation
# Unconditional shape:  |pi(x)-li(x)| <= A * x * exp(-c (log x)^alpha), x >= x0.
# Stencil at (r,d) reads n = d+1 points x = 2^(r-j), j=0..n.
#   sum_j C(n,j) A 2^(r-j) exp(-c ((r-j)log2)^alpha)
# Loose (the analogue of O68's own factorisation): pull exp to the bottom of
# the window (j = n) and sum C(n,j)2^-j = (3/2)^n:
def E_high_unc_loose(r, d, A, c, alpha):
    n = d + 1
    L = mpf(r - n) * LOG2
    if L <= 0:
        return mpf('inf')
    return mpf(A) * mpf(2) ** r * mexp(-mpf(c) * L ** mpf(alpha)) * mpf(1.5) ** n

# Tight: do the sum term by term, no factorisation at all.
def E_high_unc_tight(r, d, A, c, alpha):
    n = d + 1
    tot = mpf(0)
    for j in range(n + 1):
        L = mpf(r - j) * LOG2
        if L <= 0:
            return mpf('inf')
        tot += mpf(math.comb(n, j)) * mpf(2) ** (r - j) * mexp(-mpf(c) * L ** mpf(alpha))
    return mpf(A) * tot

# ---------------------------------------------------------------- R(d)
def wedge_ok(r, d):
    return d <= 0.34 * (r - d - 1)

def R_of(d, ehigh, log2x0, rmax=200000):
    r = max(d + 2 + math.ceil(log2x0), 14)
    while r <= rmax:
        if M_low(r, d) > ehigh(r, d) and wedge_ok(r, d) and r - d - 1 >= log2x0:
            return r
        r += 1
    return None

def depth_covered(ehigh, log2x0, dmax=24):
    dep = 0
    for d in range(1, dmax + 1):
        R = R_of(d, ehigh, log2x0)
        if R is not None and R <= GATE:
            dep = d
        else:
            break
    return dep

# ---------------------------------------------------------------- GATE 1
print("=" * 72)
print("GATE 1 -- reproduce O68's committed RH/Schoenfeld row from scratch")
o67 = {1: 16, 2: 23, 3: 29, 4: 34, 5: 40, 6: 45, 7: 50, 8: 56, 9: 61, 10: 66,
       11: 71, 12: 76, 13: 81, 14: 86, 15: 91, 16: 96}
C, k, x0 = 1 / (8 * math.pi), 1, 2657.0
mine = {d: R_of(d, lambda r, dd: E_high_RH(r, dd, C, k), math.log2(x0))
        for d in range(1, 17)}
print("  mine  ==  results/conditional_last_zero.json :", mine == o67)
print("  R(1)=%d R(3)=%d R(6)=%d R(10)=%d  depth_covered=%d"
      % (mine[1], mine[3], mine[6], mine[10],
         depth_covered(lambda r, d: E_high_RH(r, d, C, k), math.log2(x0))))

# ---------------------------------------------------------------- GATE 2
print()
print("=" * 72)
print("GATE 2 -- reproduce the analysis-under-test's R-table, unconditional shape")
print("  (loose factorisation, A=1, log2(x0)=11.4 as in O68's schoenfeld row)")
hdr = "%-28s %6s %6s %6s %6s %8s" % ("shape", "R(1)", "R(3)", "R(6)", "R(10)", "depth")
print("  " + hdr)
rows = [("VK    alpha=0.6, c=1", 0.6, 1.0), ("dlVP  alpha=0.5, c=1", 0.5, 1.0),
        ("Medium alpha=0.1, c=1", 0.1, 1.0)]
for name, al, cc in rows:
    eh = lambda r, d, al=al, cc=cc: E_high_unc_loose(r, d, 1.0, cc, al)
    Rv = {d: R_of(d, eh, 11.4, rmax=40000) for d in (1, 3, 6, 10)}
    print("  %-28s %6s %6s %6s %6s %8d"
          % (name, Rv[1], Rv[3], Rv[6], Rv[10], depth_covered(eh, 11.4)))

# ---------------------------------------------------------------- min c
print()
print("=" * 72)
print("MIN-c TABLE.  Two operators, and they are NOT the same thing.")
print("  c_minr : smallest c s.t. SOME r<=93 satisfies the gap  (what O68's")
print("           R_of computes -- min r -- and what the analysis reports)")
print("  c_sup  : smallest c s.t. the gap holds for ALL r >= that r0")
print("           (what O67's theorem 'for all r >= R(d)' actually needs)")

def needed_c(r, d, A, alpha):
    "solve M_low(r,d) = E_high_unc_loose for c"
    n = d + 1
    L = mpf(r - n) * LOG2
    if L <= 0:
        return mpf('inf')
    rhs = M_low(r, d) / (mpf(A) * mpf(2) ** r * mpf(1.5) ** n)
    return -mlog(rhs) / L ** mpf(alpha)

def c_minr(D, A, alpha, log2x0):
    "max over d<=D of min over admissible r<=93 of needed_c"
    best = mpf(0)
    for d in range(1, D + 1):
        lo = max(d + 2 + math.ceil(log2x0), 14)
        cand = [needed_c(r, d, A, alpha) for r in range(lo, GATE + 1)
                if wedge_ok(r, d) and r - d - 1 >= log2x0]
        if not cand:
            return None
        best = max(best, min(cand))
    return best

def c_sup(D, A, alpha, log2x0, rmax=200000):
    "max over d<=D of min over r0<=93 of sup_{r>=r0} needed_c"
    best = mpf(0)
    for d in range(1, D + 1):
        lo = max(d + 2 + math.ceil(log2x0), 14)
        adm = [r for r in range(lo, rmax) if wedge_ok(r, d) and r - d - 1 >= log2x0]
        vals = [needed_c(r, d, A, alpha) for r in adm]
        # suffix maxima
        suf = [mpf(0)] * (len(vals) + 1)
        for i in range(len(vals) - 1, -1, -1):
            suf[i] = max(vals[i], suf[i + 1])
        cand = [suf[i] for i, r in enumerate(adm) if r <= GATE]
        if not cand:
            return None
        best = max(best, min(cand))
    return best

print()
print("  A=1, log2(x0)=11.4")
print("  %-7s %-24s %-24s" % ("alpha", "c_minr  (D>=1/6/15)", "c_sup   (D>=1/6/15)"))
for al in (0.1, 0.3, 0.5, 0.6, 0.8, 1.0):
    a = [c_minr(D, 1.0, al, 11.4) for D in (1, 6, 15)]
    b = [c_sup(D, 1.0, al, 11.4, rmax=30000) for D in (1, 6, 15)]
    print("  %-7s %-24s %-24s"
          % (al, "  ".join("%.3f" % float(x) for x in a),
                 "  ".join("%.3f" % float(x) for x in b)))

print()
print("  full c_minr table (the analysis's own table, my arithmetic):")
print("  %-7s %8s %8s %8s %8s %8s" % ("alpha", "D>=1", "D>=3", "D>=6", "D>=10", "D>=15"))
for al in (0.1, 0.3, 0.5, 0.6, 0.8, 1.0):
    print("  %-7s %8.3f %8.3f %8.3f %8.3f %8.3f"
          % (al, *[float(c_minr(D, 1.0, al, 11.4)) for D in (1, 3, 6, 10, 15)]))

# tight vs loose
print()
print("  how much the loose factorisation costs (alpha=0.5, A=1):")
for D in (1, 6, 15):
    cl = float(c_minr(D, 1.0, 0.5, 11.4))
    # bisect on tight
    lo_, hi_ = 0.0, 20.0
    for _ in range(60):
        mid = (lo_ + hi_) / 2
        eh = lambda r, d: E_high_unc_tight(r, d, 1.0, mid, 0.5)
        ok = all((R_of(d, eh, 11.4, rmax=400) or 10**9) <= GATE for d in range(1, D + 1))
        if ok: hi_ = mid
        else:  lo_ = mid
    print("    D>=%-3d loose c=%.4f   tight c=%.4f   ratio %.4f"
          % (D, cl, hi_, hi_ / cl))

# A sensitivity
print()
print("  A sensitivity at alpha=0.5 (A=1 is the analysis's unstated assumption):")
print("  %-10s %8s %8s %8s" % ("A", "D>=1", "D>=6", "D>=15"))
for A in (1.0, 10.0, 235.0, 1e5, 9.39e9):
    print("  %-10.4g %8.3f %8.3f %8.3f"
          % (A, *[float(c_minr(D, A, 0.5, 11.4)) for D in (1, 6, 15)]))
