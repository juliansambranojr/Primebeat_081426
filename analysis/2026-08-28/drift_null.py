"""The drift null: where is zero reachable at all?  EXPLORATORY.

Julian (entry 254 + follow-on): the table is deterministic, so each cell
answers to the drift account before any chance model; and under a given
family's null, the zero is a boundary you can't pass — absence is only
reachable where that family's deterministic drift has decayed to within
fluctuation range of zero. Beyond that locus, no exact zero can occur.

Drift null: b(r) = li(2^r) - li(2^(r-1)), T_li(r,d) = Delta^d b (backward,
in r). Fluctuation residual R = T - T_li. Reachability: |T_li| <= c*fluct
with fluct estimated per cell from the residuals themselves (RMS of R over
a (r,d)-neighborhood is overkill; use |R|'s own cell value and the sqrt
scale as brackets). Questions:
  1. does T_li keep one sign (pure decay) or cross zero?
  2. where is the reachable region, and do all four zeros + the family
     {(20,6),(39,14),(13,5)} sit inside it?
  3. does the region close - is there a max r beyond which no cell can
     reach zero (the boundary you can't pass, globally)?
"""
import json
from math import comb, sqrt, log10
from mpmath import mp, li, mpf

mp.dps = 60
cache = json.load(open("pi2n_cache.json"))
pi2 = {int(k): int(v) for k, v in cache.items()}
RMAX = 62
a = {r: pi2[r] - pi2[r - 1] for r in range(1, RMAX + 1)}
b = {r: li(mpf(2) ** r) - li(mpf(2) ** (r - 1)) for r in range(1, RMAX + 1)}

FAMILY = {(20, 6): "EXACT", (39, 14): "near", (13, 5): "near|T|=1",
          (8, 3): "EXACT", (4, 1): "EXACT", (2, 1): "EXACT"}

rows = []
sign_changes = 0
reach = []
for r in range(2, RMAX + 1):
    for d in range(1, min(r - 1, 61) + 1):
        T = sum(comb(d, k) * (-1) ** k * a[r - k] for k in range(d + 1))
        Tli = sum(mpf(comb(d, k)) * (-1) ** k * b[r - k] for k in range(d + 1))
        mass = sum(comb(d, k) * a[r - k] for k in range(d + 1))
        R = T - Tli
        rows.append((r, d, T, float(Tli), float(R), mass))

import collections
byr = collections.defaultdict(list)
for r, d, T, Tli, R, mass in rows:
    byr[r].append((d, T, Tli, R, mass))

print("DRIFT NULL.  EXPLORATORY, no prereg.  li-based smooth table, dps=60")

# 1. sign structure of T_li in d, per r
neg = [(r, d) for r, d, T, Tli, R, m in rows if Tli < 0]
print(f"\n1. SIGN: cells with T_li < 0: {len(neg)} of {len(rows)}")
if neg:
    firsts = {}
    for r, d in neg:
        firsts.setdefault(r, d)
    ex = sorted(firsts.items())[:8]
    print("   first negative depth per row (sample):",
          " ".join(f"r{r}:d{d}" for r, d in ex))

# 2. reachability: |T_li| vs sqrt(mass), and vs the actual residual |R|
print("\n2. THE NAMED CELLS — drift vs fluctuation at each:")
print("    (r,d)       T_li            |R|=|T-T_li|     sqrt(mass)   |T_li|/sqrt(m)  class")
for (r, d), cls in sorted(FAMILY.items()):
    for dd, T, Tli, R, mass in byr[r]:
        if dd == d:
            print(f"   ({r:2d},{d:2d})  {Tli:14.1f}   {abs(R):14.1f}"
                  f"   {sqrt(mass):10.1f}   {abs(Tli)/sqrt(mass):10.2f}   {cls}")

# 3. the reachable region |T_li| <= 3 sqrt(mass)
reachable = [(r, d) for r, d, T, Tli, R, m in rows if abs(Tli) <= 3 * sqrt(m)]
print(f"\n3. REACHABLE REGION (|T_li| <= 3*sqrt(mass)): {len(reachable)} cells")
byrow = collections.defaultdict(list)
for r, d in reachable:
    byrow[r].append(d)
print("    r : reachable depths")
for r in sorted(byrow):
    ds = byrow[r]
    print(f"   {r:3d} : d in [{min(ds)},{max(ds)}]  ({len(ds)} cells)")
inside = {k: (k in reachable or list(k) in [list(x) for x in reachable])
          for k in FAMILY}
print("\n   family inside the reachable region:")
for (r, d), cls in sorted(FAMILY.items()):
    print(f"   ({r:2d},{d:2d})  {'IN' if (r,d) in reachable else 'OUT'}   {cls}")

print("\nEXPLORATORY — no prereg, no decision rule, no verdict.")
