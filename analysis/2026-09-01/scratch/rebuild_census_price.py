#!/usr/bin/env python3
"""INDEPENDENT rebuild of the census price. Written from
lean/Nonvanishing.lean (Ehigh/Mlow/nonvanishing_of) and
O68_weak_bound_tolerance.py (R_of, wedge, window floor, O43_EXTENT).
Nothing reused from the proposal's scripts.
"""
import json, math, pathlib
from mpmath import mp, mpf, exp as mexp, log as mlog

mp.dps = 50
HERE = pathlib.Path("/Users/juliansambrano/GitHub/Primebeat_081426")
LOG2 = math.log(2)
O43_EXTENT = 92          # O68 line 39
COVER = O43_EXTENT + 1   # O68 line 108: Rs[d] <= O43_EXTENT + 1
RMAX = 4000
DMAX = 24

# ---- Nonvanishing.Mlow, verbatim from lean/Nonvanishing.lean:178-179
def M_low(r, d):
    return mpf('0.5') * mpf(2) ** (r - d - 1) * mpf(LOG2) ** d / r

# ---- Nonvanishing.Ehigh, verbatim from lean/Nonvanishing.lean:109-111
def E_high_RH_lean(r, d):
    n = d + 1
    return (mpf(LOG2) * r / (8 * mp.pi)) * mpf(2) ** (mpf(r) / 2) \
        * (1 + mpf(2) ** mpf('-0.5')) ** n

# ---- O68 generalisation, verbatim from O68_weak_bound_tolerance.py:57-59
def E_high_weak(r, d, C, k):
    return (mpf(C) * (mpf(r) * LOG2) ** k * mpf(2) ** (mpf(r) / 2)
            * mpf(1 + 2 ** -0.5) ** (d + 1))

# ---- MY derivation of the unconditional-shape ceiling.
# Per-value bound |pi(y)-li(y)| <= A*y*exp(-c*(log y)^alpha) for y >= x0.
# The stencil at (r, n=d+1) reads y = 2^(r-j), j = 0..n:
#   sum_j C(n,j) * A * 2^(r-j) * exp(-c*((r-j)*log2)^alpha)
# The exp factor is LARGEST at j = n (smallest y), so pull it out at j=n:
#   <= A * exp(-c*((r-n)*log2)^alpha) * 2^r * sum_j C(n,j) 2^-j
#    = A * exp(-c*((r-n)*log2)^alpha) * 2^r * (3/2)^n
def E_high_unc(r, d, A, c, alpha):
    n = d + 1
    L = (mpf(r - n) * LOG2) ** mpf(alpha)
    return mpf(A) * mexp(-mpf(c) * L) * mpf(2) ** r * (mpf(3) / 2) ** n

# tighter variant, exp kept inside the sum (sanity: should not move R much)
def E_high_unc_tight(r, d, A, c, alpha):
    n = d + 1
    tot = mpf(0)
    for j in range(n + 1):
        y = mpf(r - j)
        if y <= 1:
            return mpf('inf')
        tot += mpf(math.comb(n, j)) * mpf(2) ** (r - j) \
            * mexp(-mpf(c) * (y * LOG2) ** mpf(alpha))
    return mpf(A) * tot


def R_of(d, Ehigh, x0, rmax=RMAX):
    """O68_weak_bound_tolerance.py:62-71 — same three conditions."""
    floor = math.log2(x0)
    r = max(d + 2 + math.ceil(floor), 14)
    while r <= rmax:
        if (M_low(r, d) > Ehigh(r, d)
                and d <= 0.34 * (r - d - 1)
                and r - d - 1 >= floor):
            return r
        r += 1
    return None


def depth_covered(Rs):
    depth = 0
    for d in range(1, DMAX + 1):
        if Rs.get(d) is not None and Rs[d] <= COVER:
            depth = d
        else:
            break
    return depth


def row(label, Ehigh, x0, ds=(1, 2, 3, 4, 5, 6, 8, 10, 15)):
    Rs = {d: R_of(d, Ehigh, x0) for d in range(1, DMAX + 1)}
    dc = depth_covered(Rs)
    shown = "  ".join(f"d{d}={'-' if Rs[d] is None else Rs[d]}" for d in ds)
    print(f"  {label:<44} depth_covered={dc:<3} {shown}")
    return Rs, dc


print("=" * 78)
print("GATE 1 — reproduce O68's schoenfeld row from its committed log")
print("=" * 78)
o67 = json.loads((HERE / "results" / "conditional_last_zero.json").read_text())
o67R = {r["d"]: r["R"] for r in o67["rows"]}
Rs, dc = row("schoenfeld  C=1/(8pi) k=1 x0=2657",
             lambda r, d: E_high_weak(r, d, 1 / (8 * math.pi), 1), 2657.0)
print(f"    O67 committed R(1..8): {[o67R.get(d) for d in range(1,9)]}")
print(f"    mine      R(1..8): {[Rs[d] for d in range(1,9)]}")
print(f"    SANITY vs O67: {all(Rs[d]==o67R.get(d) for d in range(1,25))}")
print(f"    expect depth_covered=15 (log line 5): got {dc}")
for nm, C, k, x0, want in [("psi_style", 1/(8*math.pi), 2, 74.0, 12),
                           ("crude", 1.0, 2, 2657.0, 10),
                           ("very_crude", 100.0, 2, 2.0**30, 8),
                           ("crude_1000", 1000.0, 2, 2.0**30, 6),
                           ("brutal", 1e6, 3, 2.0**60, 0)]:
    _, d_ = row(f"{nm}  C={C:.4g} k={k}",
                lambda r, d, C=C, k=k: E_high_weak(r, d, C, k), x0)
    print(f"      expected {want} -> {'OK' if d_==want else 'MISMATCH'}")

print()
print("=" * 78)
print("GATE 2 — the RH row the proposal reports, from the LEAN defs")
print("  claimed: d=1:2^16  d=3:2^29  d=6:2^45  d=10:2^66")
print("=" * 78)
# no wedge / no floor -- exactly the proposal's cross_rh()
def cross_rh_nofloor(d):
    for r in range(2, 4000):
        if E_high_RH_lean(r, d) < M_low(r, d):
            return r
    return None
mine_nofloor = {d: cross_rh_nofloor(d) for d in (1, 3, 6, 10)}
print(f"  no wedge, no window floor : {mine_nofloor}")
Rs_lean = {d: R_of(d, E_high_RH_lean, 2657.0) for d in range(1, DMAX+1)}
print(f"  with O68 wedge+floor      : "
      f"{ {d: Rs_lean[d] for d in (1,3,6,10)} }  "
      f"depth_covered={depth_covered(Rs_lean)}")
print(f"  O67 committed table       : { {d: o67R.get(d) for d in (1,3,6,10)} }")

print()
print("=" * 78)
print("GATE 3 — the unconditional shape  A*x*exp(-c*(log x)^alpha)")
print("  R(d) AND depth_covered, under O68's own R_of (wedge + floor)")
print("  census ceiling: R(d) must be <= 93 to be 'covered'")
print("=" * 78)
for alpha, aname in ((0.10, "MediumPNT (log x)^0.10"),
                     (0.50, "dlVP      (log x)^0.50"),
                     (0.60, "VK        (log x)^0.60")):
    print(f"\n{aname}   (A=1, x0=2657)")
    for c in (10.0, 3.0, 2.0, 1.0, 0.3):
        row(f"  c={c}", lambda r, d, c=c, a=alpha: E_high_unc(r, d, 1.0, c, a),
            2657.0)

print()
print("  tightness check (exp kept inside the sum), alpha=0.5 c=1, A=1:")
row("  loose", lambda r, d: E_high_unc(r, d, 1.0, 1.0, 0.5), 2657.0)
row("  tight", lambda r, d: E_high_unc_tight(r, d, 1.0, 1.0, 0.5), 2657.0)

print()
print("=" * 78)
print("GATE 4 — INVERSE PROBLEM: what c does the census actually require?")
print("  smallest c with depth_covered >= D, at A=1, x0=2657")
print("=" * 78)
print(f"  {'alpha':>6} " + "".join(f"D>={D:<8}" for D in (1, 3, 6, 10, 15)))
for alpha in (0.10, 0.30, 0.50, 0.60, 0.80, 1.00):
    cells = []
    for D in (1, 3, 6, 10, 15):
        lo, hi = 0.0, 4096.0
        ok = None
        for _ in range(60):
            mid = (lo + hi) / 2
            Rs = {d: R_of(d, lambda r, d_, m=mid, a=alpha:
                          E_high_unc(r, d_, 1.0, m, a), 2657.0, rmax=400)
                  for d in range(1, D + 1)}
            if depth_covered(Rs) >= D:
                hi = mid; ok = mid
            else:
                lo = mid
        cells.append("none" if ok is None else f"{ok:.3g}")
    print(f"  {alpha:>6} " + "".join(f"{v:<10}" for v in cells))

print()
print("=" * 78)
print("GATE 5 — how big does the census have to get if c is small?")
print("  R(d) for the shapes the proposal headlines, vs O43's ceiling 92")
print("=" * 78)
for label, alpha, c in (("VK   alpha=0.60 c=1", 0.60, 1.0),
                        ("dlVP alpha=0.50 c=1", 0.50, 1.0),
                        ("MedPNT alpha=0.10 c=1", 0.10, 1.0)):
    Rs = {d: R_of(d, lambda r, d_, c=c, a=alpha:
                  E_high_unc(r, d_, 1.0, c, a), 2657.0, rmax=20000)
          for d in (1, 3, 6, 10)}
    print(f"  {label:<24} " +
          "  ".join(f"R({d})={'>2e4' if Rs[d] is None else Rs[d]}"
                    for d in (1, 3, 6, 10)) +
          f"    depth_covered={depth_covered({d: R_of(d, lambda r,d_,c=c,a=alpha: E_high_unc(r,d_,1.0,c,a), 2657.0, rmax=400) for d in range(1,DMAX+1)})}")
