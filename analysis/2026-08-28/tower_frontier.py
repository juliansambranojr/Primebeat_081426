"""Tower frontier scan: is {4p} a family, and do the towers continue?  EXPLORATORY.

Entry 253's map: the exact zeros (r,d) = (2,1),(4,1),(8,3),(20,6) of the
backward dyadic table sit on the tower of 2 with its fixed point — except
(20,6), where 20 = 2^2 * 5 = fixed point x first off-scaffold prime. Two
frontier questions, both measurable in the exact table:

  1. Is {4p} a family? Rows 20, 28, 44, 52 (= 4*5, 4*7, 4*11, 4*13).
  2. Do the towers continue? Rows 16, 32 have no exact zero (verified to
     d<=61, CONTEXT.md:316) — do they come unusually close?

Table: a(r) = pi(2^r) - pi(2^(r-1)) from pi2n_cache.json (exact ints);
T(r,d) = backward Delta^d a; cancellation c(r,d) = |T(r,d)| / gross mass
Sum C(d,k) a(r-k); m(r) = min over d of c(r,d). Exact zero -> m = 0.
Rank m(r) across rows; low rank for the named rows = the structure dips.
"""
import json
from math import comb

cache = json.load(open("pi2n_cache.json"))
pi2 = {int(k): int(v) for k, v in cache.items()}
RMAX = 62
a = {r: pi2[r] - pi2[r - 1] for r in range(1, RMAX + 1)}

def scan(r):
    best, bd = None, None
    for d in range(1, min(r - 1, 61) + 1):
        T = sum(comb(d, k) * (-1) ** k * a[r - k] for k in range(d + 1))
        gross = sum(comb(d, k) * a[r - k] for k in range(d + 1))
        c = abs(T) / gross
        if best is None or c < best:
            best, bd = c, d
    return best, bd

rows = list(range(3, RMAX + 1))
m = {}
dstar = {}
for r in rows:
    m[r], dstar[r] = scan(r)

EXACT = {2, 4, 8, 20}
FOURP = [20, 28, 44, 52]
TOWER = [16, 32]

ranked = sorted(rows, key=lambda r: m[r])
rank = {r: i + 1 for i, r in enumerate(ranked)}

print("TOWER FRONTIER.  EXPLORATORY, no prereg.  rows 3..62, depths to 61")
print(f"  exact zeros (known): rows 4, 8, 20 in range -> m = 0 expected\n")
print("  twenty smallest m(r):")
print("   rank   r   m(r)         d*   class")
for r in ranked[:20]:
    cls = []
    if r in EXACT: cls.append("EXACT")
    if r in FOURP: cls.append("4p")
    if r in TOWER: cls.append("tower")
    print(f"   {rank[r]:4d} {r:4d}   {m[r]:.6f}   {dstar[r]:3d}   {','.join(cls)}")

print("\n  the named rows:")
print("     r   m(r)         d*    rank/60   class")
for r in FOURP + TOWER:
    cls = "4p" if r in FOURP else "tower"
    if r in EXACT: cls += ",EXACT"
    print(f"   {r:4d}   {m[r]:.6f}   {dstar[r]:3d}   {rank[r]:3d}/60    {cls}")

import statistics
others = [m[r] for r in rows if r not in EXACT]
print(f"\n  m(r) over non-exact rows: median {statistics.median(others):.4f}"
      f"   min {min(others):.6f} (r={min((r for r in rows if r not in EXACT), key=lambda r: m[r])})")
print("\nEXPLORATORY — no prereg, no decision rule, no verdict.")
