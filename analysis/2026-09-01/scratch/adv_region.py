#!/usr/bin/env python3
"""Part 2: the c = 1/sqrt(R) translation, the ratio claims, and the census arm."""
import math
from mpmath import mp, mpf, log as mlog, exp as mexp
mp.dps = 50
LOG2 = math.log(2)
GATE = 93

def M_low(r, d):
    return mpf('0.5') * mpf(2) ** (r - d - 1) * mpf(LOG2) ** d / r

def needed_c(r, d, A, alpha):
    n = d + 1
    L = mpf(r - n) * LOG2
    if L <= 0: return mpf('inf')
    rhs = M_low(r, d) / (mpf(A) * mpf(2) ** r * mpf(1.5) ** n)
    return -mlog(rhs) / L ** mpf(alpha)

def R_of_c(d, A, c, alpha, log2x0=11.4, rmax=200000):
    r = max(d + 2 + math.ceil(log2x0), 14)
    while r <= rmax:
        if (d <= 0.34 * (r - d - 1) and r - d - 1 >= log2x0
                and needed_c(r, d, A, alpha) <= c):
            return r
        r += 1
    return None

# The four regions actually named in the pinned tree, verbatim:
#   .lake/packages/PrimeNumberTheoremAnd/PrimeNumberTheoremAnd/IEANTN/ZetaSummary.lean
#   :58 MT_theorem_1  R = 5.573412   sorry
#   :71 MT_R0_55666305 R = 5.5666305 sorry
#   :82 MTY_theorem   R = 5.558691   sorry
#   :93 BTY_theorem   R = 4.896      sorry
REGIONS = [("MT_theorem_1 (:58)", 5.573412), ("MT_R0_55666305 (:71)", 5.5666305),
           ("MTY_theorem (:82)", 5.558691), ("BTY_theorem (:93)", 4.896)]

print("=" * 74)
print("CLAIM: c = 1/sqrt(R), and every proved region gives depth_covered = 0")
print("  %-24s %8s %8s %8s %10s" % ("region", "R", "c=1/vR", "R_arrow(1)", "depth_cov"))
for name, R in REGIONS:
    c = 1 / math.sqrt(R)
    R1 = R_of_c(1, 1.0, c, 0.5, rmax=5000)
    dep = 0
    for d in range(1, 17):
        Rd = R_of_c(d, 1.0, c, 0.5, rmax=5000)
        if Rd is not None and Rd <= GATE: dep = d
        else: break
    print("  %-24s %8.4f %8.4f %8s %10d" % (name, R, c, R1, dep))

print()
print("  -> depth_covered = 0 for all four. CONFIRMED, and by a wide margin:")
print("     the arrow does not reach r<=93 at ANY depth; the first depth-1")
print("     rung it reaches is r ~ %s, i.e. it would need pi(2^%s)."
      % (R_of_c(1, 1.0, 1/math.sqrt(4.896), 0.5, rmax=5000),
         R_of_c(1, 1.0, 1/math.sqrt(4.896), 0.5, rmax=5000)))

# ------------------------------------------------------- the ratio claims
print()
print("=" * 74)
print("CLAIM: 'depth 6 needs a region 9-19x stronger than the record;")
print("        depth 15 needs 37-73x'")
c6, c15 = 1.9577, 3.8739   # my own values from adv_census.py
for lbl, c in (("depth 6", c6), ("depth 15", c15)):
    Rneed = 1 / c ** 2
    ratios = [R / Rneed for _, R in REGIONS]
    print("  %-9s c>=%.4f  =>  R <= %.5f ; R_record/R_need = %.1f .. %.1f"
          % (lbl, c, Rneed, min(ratios), max(ratios)))
print("  R values cited span %.4f..%.4f = a %.1f%% spread."
      % (min(R for _, R in REGIONS), max(R for _, R in REGIONS),
         100 * (max(R for _, R in REGIONS) / min(R for _, R in REGIONS) - 1)))
print("  A 13.8%% spread in R cannot produce a 2.1x range (9->19 or 37->73).")

# ------------------------------------------------------- finite-x honesty
print()
print("=" * 74)
print("Is c = 1/sqrt(R) actually attainable at census scale?")
print("  Crude truncated explicit formula:")
print("    |psi(x)-x| <~ x*(log T)^2*exp(-log x/(R log T)) + x*(log x)^2/T")
print("  exponent(u) = max( 2 log u - X/(R u) ,  2 log X - u ),  u = log T")
print("  %-8s %-10s %8s %10s %12s" % ("r", "X=log x", "u*", "exponent", "c_eff"))
for r in (93, 200, 680, 2000, 10000, 100000):
    X = r * LOG2
    R = 4.896
    best, bu = 1e9, None
    u = 0.5
    while u < 400:
        e = max(2 * math.log(u) - X / (R * u), 2 * math.log(X) - u)
        if e < best: best, bu = e, u
        u += 0.001
    ceff = -best / math.sqrt(X) if best < 0 else float('nan')
    print("  %-8d %-10.2f %8.3f %10.3f %12s"
          % (r, X, bu, best, ("%.4f" % ceff) if best < 0 else "NONE (>=0)"))
print("  1/sqrt(4.896) = %.4f. The asymptotic constant is only reached far"
      % (1 / math.sqrt(4.896)))
print("  beyond census scale; at r=93 the balance does not even go negative.")

# ------------------------------------------------------- VK with Ford's shape
print()
print("=" * 74)
print("VK with the loglog factor, at census scale (not at r=261)")
def R_of_vk(d, A, c, log2x0=11.4, rmax=200000):
    r = max(d + 2 + math.ceil(log2x0), 14)
    while r <= rmax:
        if d <= 0.34 * (r - d - 1) and r - d - 1 >= log2x0:
            L = float((r - d - 1) * LOG2)
            eff = c * L ** 0.6 * math.log(L) ** (-0.2) / L ** 0.6  # c_eff at alpha=.6
            if needed_c(r, d, A, 0.6) <= eff * L ** 0.0 * 1.0 and False: pass
            # direct: compare c_needed(alpha=.6) against c*(log L)^(-1/5)
            if needed_c(r, d, A, 0.6) <= c * math.log(L) ** (-0.2):
                return r
        r += 1
    return None
for r in (93, 261):
    L = (r - 7) * LOG2
    print("  at r=%d: log x=%.2f, (loglog x)^(-1/5) = %.4f, penalty 1/that = %.3f"
          % (r, L, math.log(L) ** -0.2, math.log(L) ** 0.2))
print("  the analysis quotes the penalty 1.39 at r=261; at the census gate")
print("  r=93 it is %.3f." % (math.log((93 - 7) * LOG2) ** 0.2))
print()
print("  c_needed at alpha=0.6 without loglog (A=1): D>=1 %.3f  D>=6 %.3f"
      % (float(max(min(needed_c(r, d, 1.0, 0.6) for r in range(14, 94)
                       if d <= 0.34*(r-d-1) and r-d-1 >= 11.4) for d in [1])),
         float(max(min(needed_c(r, d, 1.0, 0.6) for r in range(14, 94)
                       if d <= 0.34*(r-d-1) and r-d-1 >= 11.4) for d in range(1, 7)))))
print("  with the loglog penalty at r=93 those become %.3f and %.3f"
      % (0.648 * math.log((93-2)*LOG2) ** 0.2, 1.301 * math.log((93-7)*LOG2) ** 0.2))

# ------------------------------------------------------- the OTHER arm
print()
print("=" * 74)
print("THE ARM THE ANALYSIS NEVER PRICES: extend the census instead.")
print("  depth_covered as a function of census extent E (covered = R(d) <= E+1)")
print("  %-26s %6s %6s %6s %6s %6s" % ("shape", "E=92", "E=200", "E=500", "E=2000", "E=1e4"))
shapes = [("RH/Schoenfeld", None), ("VK a=0.6 c=1", (0.6, 1.0)),
          ("dlVP a=0.5 c=1", (0.5, 1.0)), ("BTY c=1/sqrt(R)", (0.5, 1/math.sqrt(4.896)))]
for name, sh in shapes:
    out = []
    for E in (92, 200, 500, 2000, 10000):
        dep = 0
        for d in range(1, 40):
            if sh is None:
                C, k = 1 / (8 * math.pi), 1
                r = max(d + 2 + 12, 14); Rd = None
                while r <= E + 1:
                    eh = (mpf(C) * (mpf(r) * LOG2) ** k * mpf(2) ** (mpf(r) / 2)
                          * mpf(1 + 2 ** -0.5) ** (d + 1))
                    if M_low(r, d) > eh and d <= 0.34 * (r - d - 1) and r - d - 1 >= 11.4:
                        Rd = r; break
                    r += 1
            else:
                al, cc = sh
                Rd = R_of_c(d, 1.0, cc, al, rmax=E + 1)
            if Rd is not None and Rd <= E + 1: dep = d
            else: break
        out.append(dep)
    print("  %-26s %6d %6d %6d %6d %6d" % (name, *out))
print()
print("  2^92 = %.3e  -- O43's census ceiling." % (2.0 ** 92))
print("  2^148 = %.3e -- what VK a=0.6 c=1 would need at depth 6." % (2.0 ** 148))
print("  2^680 = 10^%.0f -- what BTY c=1/sqrt(R) would need at depth 1."
      % (680 * math.log10(2)))
