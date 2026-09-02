#!/usr/bin/env python3
"""Part 3: what the census gate ACTUALLY requires, stated without assuming a
functional form. The analysis under test never does this."""
import math
from mpmath import mp, mpf, log as mlog
mp.dps = 50
LOG2 = math.log(2)
GATE = 93

def M_low(r, d):
    return mpf('0.5') * mpf(2) ** (r - d - 1) * mpf(LOG2) ** d / r

print("=" * 74)
print("A. The gate in FORM-FREE terms.")
print("   Condition (loose factorisation, same as O68's own):")
print("     A*f(2^(r-d-1))/2^(r-d-1) * (3/2)^(d+1) * 2^(r) ... reduces to")
print("     relerr(x) := |pi(x)-li(x)|/x  <  0.5*(1/3)^(d+1)*(log2)^d / r")
print("   With r = log x / log 2 this is exactly")
print("     relerr(x) < eps_d / log x ,   eps_d = 0.5*(log2/3)^(d+1)")
print()
print("   %-5s %-14s %-16s %-16s" % ("d", "eps_d", "at r=93 need", "vs sqrt(x)/x at 2^86"))
for d in (1, 3, 6, 10, 15):
    eps = 0.5 * (LOG2 / 3) ** (d + 1)
    need = float(M_low(93, d) / (mpf(2) ** 93 * mpf(1.5) ** (d + 1)))
    print("   %-5d %-14.4g %-16.4g %-16.4g" % (d, eps, need, 2.0 ** -43))
print()
print("   -> the ASYMPTOTIC requirement is relerr = O(1/log x) with a small")
print("      constant. PNT alone gives relerr = o(1/log x). So the arrow is")
print("      unconditionally TRUE at every depth for SOME R(d); the entire")
print("      question is whether that R(d) lands at or below 93.")
print("      The analysis's 'the only place a bound strong enough exists is")
print("      the RH-shaped route' is false as stated.")

# ---------------------------------------------------------------- theta
print()
print("=" * 74)
print("B. The gate as a QUASI-RH EXPONENT.  |pi(x)-li(x)| <= A x^theta")
print("   (this is alpha=1 in the analysis's own table: A x exp(-c log x) = A x^(1-c))")

def needed_c(r, d, A, alpha):
    n = d + 1
    L = mpf(r - n) * LOG2
    if L <= 0: return mpf('inf')
    rhs = M_low(r, d) / (mpf(A) * mpf(2) ** r * mpf(1.5) ** n)
    return -mlog(rhs) / L ** mpf(alpha)

def c_gate(D, A, alpha, log2x0=11.4):
    best = mpf(0)
    for d in range(1, D + 1):
        lo = max(d + 2 + math.ceil(log2x0), 14)
        cand = [needed_c(r, d, A, alpha) for r in range(lo, GATE + 1)
                if d <= 0.34 * (r - d - 1) and r - d - 1 >= log2x0]
        if not cand: return None
        best = max(best, min(cand))
    return best

print("   %-8s %-12s %-12s %-30s" % ("depth D", "c (alpha=1)", "theta=1-c", "status of that statement"))
for D in (1, 3, 6, 10, 15):
    c = float(c_gate(D, 1.0, 1.0))
    th = 1 - c
    if th < 0.5:
        st = "FALSE (Littlewood Omega+-)"
    elif th < 1.0:
        st = "unproven quasi-RH, WEAKER than RH"
    else:
        st = "trivial"
    print("   %-8d %-12.4f %-12.4f %-30s" % (D, c, th, st))
print()
print("   A-sensitivity of theta (A=1 is the analysis's unstated assumption):")
print("   %-12s %-10s %-10s %-10s" % ("A", "D>=1", "D>=6", "D>=10"))
for A in (1.0, 235.0, 1e5, 9.39e9):
    print("   %-12.4g %-10.4f %-10.4f %-10.4f"
          % (A, *[1 - float(c_gate(D, A, 1.0)) for D in (1, 6, 10)]))

# ---------------------------------------------------------------- min-r vs sup
print()
print("=" * 74)
print("C. Where O68's `min r` semantics silently breaks for the exponential shape.")
print("   O67/O68 conclude 'cell(r,d) != 0 for ALL r >= R(d)'.")
print("   O68_weak_bound_tolerance.py:62-71 returns the FIRST r that works.")
print("   For the RH shape M_low/E_high ~ 2^(r/2)/r^(k+1): monotone, so first==threshold.")
print("   For A x exp(-c(log x)^alpha) the ratio ~ exp(c L^alpha)/r, and for small")
print("   alpha that is NOT monotone. Table: is needed_c(.,d,.) decreasing in r?")
print("   %-8s %-6s %-12s %-12s %-12s %-10s" % ("alpha", "d", "c@r=Rmin", "c@r=93", "sup_r c", "monotone?"))
for alpha in (0.1, 0.3, 0.5):
    for d in (1, 6):
        lo = max(d + 2 + 12, 14)
        adm = [r for r in range(lo, 30000) if d <= 0.34 * (r - d - 1) and r - d - 1 >= 11.4]
        vals = [float(needed_c(r, d, 1.0, alpha)) for r in adm]
        rmin = adm[0]
        c93 = float(needed_c(93, d, 1.0, alpha))
        print("   %-8s %-6d %-12.4f %-12.4f %-12.4f %-10s"
              % (alpha, d, vals[0], c93, max(vals),
                 "yes" if all(vals[i] >= vals[i+1] for i in range(len(vals)-1)) else "NO"))
print()
print("   Consequence: the analysis's alpha=0.1 D>=1 cell reads 4.79 (= the value")
print("   at r=15, where R_of stops). The gap REOPENS at r>=16 and the honest")
print("   number is sup_r = 5.287. Its alpha=0.1 D>=6 cell (10.0) survives,")
print("   because there the binding r is 93 itself.")
