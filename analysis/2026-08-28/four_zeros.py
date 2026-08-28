"""The four zeros: are they surprising, and what cancels at them?

Exact table from pi2n_cache.json.  cell(r,d) = sum_k C(d,k)(-1)^k pi(2^{r-k})
(ZerosStencil.lean:66 -- stencil of order d on d+1 values).

Two questions, both answerable from data in hand:

1. NULL.  The cell is an integer.  If cells near 0 are common, an exact zero is
   ordinary.  Histogram every cell value in the window and see how 0 sits
   against +-1, +-2, ...   This is the null the four zeros have never been run
   against.

2. WHAT CANCELS.  pi(2^n) = Li(2^n) + fluctuation.  Delta^d Li(2^r) is smooth
   and computable exactly -- no divergent zero sum.  At a zero the fluctuation
   must equal minus the smooth part.  Measure how large that demand is against
   the fluctuation's own scale at the same depth.
"""
import json
from math import comb
import mpmath as mp
mp.mp.dps = 40

R = "/Users/juliansambrano/GitHub/Primebeat_081426/"
pi2 = {int(k): int(v) for k, v in json.load(open(R+"pi2n_cache.json")).items()}
RMAX = max(pi2)
def cell(r, d): return sum(comb(d,k)*(-1)**k*pi2[r-k] for k in range(d+1))

print(f"  pi(2^n) cached for n = 0..{RMAX}")

# ---------- 1. the null ----------
vals = {}
zeros = []
for d in range(1, 40):
    for r in range(d, RMAX+1):
        v = cell(r, d)
        vals.setdefault(d, []).append((r, v))
        if v == 0: zeros.append((r, d))
print(f"  exact zeros found, d<=39: {zeros}")

print()
print("  NULL - how many cells sit at each small value?  (all d in 1..39)")
from collections import Counter
c = Counter(v for d in vals for _, v in vals[d])
print("     value   count")
for k in range(-6, 7):
    star = "   <- the four zeros" if k == 0 else ""
    print(f"    {k:+4d}    {c.get(k,0):5d}{star}")
tot = sum(c.values())
small = sum(c.get(k,0) for k in range(-6,7))
print(f"    total cells {tot},  |value|<=6 accounts for {small} ({100*small/tot:.2f}%)")

print()
print("  NULL by depth - median |cell| tells you the scale a zero has to hit")
print("     d   cells   median|cell|   #|cell|<=1   #==0")
for d in (1,2,3,4,5,6,7,8,10,12,16,20):
    vs = [abs(v) for _, v in vals[d]]
    vs_s = sorted(vs)
    med = vs_s[len(vs_s)//2]
    n1 = sum(1 for v in vs if v <= 1); n0 = sum(1 for v in vs if v == 0)
    print(f"    {d:2d}   {len(vs):5d}   {med:12d}   {n1:9d}   {n0:4d}")

# ---------- 2. what cancels ----------
print()
print("  WHAT CANCELS - smooth part Delta^d Li(2^r), exact, no zero sum")
print("     r   d    exact cell   Delta^d Li(2^r)    fluctuation   fluct/typ")
def dLi(r, d):
    return sum(comb(d,k)*(-1)**k*mp.li(mp.mpf(2)**(r-k)) for k in range(d+1))
# typical fluctuation scale at depth d: rms of (cell - smooth) over that row
def typ(d, lo, hi):
    xs = [float(cell(r,d) - dLi(r,d)) for r in range(lo, hi+1)]
    return (sum(x*x for x in xs)/len(xs))**0.5
CELLS = [(2,1),(4,1),(8,3),(20,6),(20,5),(20,7),(19,6),(21,6),(30,6),(40,6)]
tcache = {}
for (r, d) in CELLS:
    s = dLi(r, d)
    f = cell(r, d) - s
    if d not in tcache:
        tcache[d] = typ(d, d+2, min(RMAX, 40))
    print(f"   {r:3d} {d:3d}  {cell(r,d):11d}   {float(s):15.3f}  {float(f):13.3f}"
          f"   {float(f)/tcache[d]:8.3f}")
print()
print("     depth   rms fluctuation over r in [d+2, 40]")
for d in sorted(tcache): print(f"      {d:3d}     {tcache[d]:12.2f}")
