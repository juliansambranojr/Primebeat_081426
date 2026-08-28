"""Tower frontier, take 2: z-scale = sqrt(sum C(d,k)^2 a(r-k)) — the
fluctuation scale. z ~ O(1) generic, z << 1 = cancellation beyond
square-root, z = 0 exact. EXPLORATORY. Log: results/tower_frontier2.log.
(v1, gross-mass normalization, saturated at deep d — kept as
tower_frontier.py + log for the record.)"""
import json
from math import comb, sqrt

cache = json.load(open("pi2n_cache.json"))
pi2 = {int(k): int(v) for k, v in cache.items()}
RMAX = 62
a = {r: pi2[r] - pi2[r - 1] for r in range(1, RMAX + 1)}

def scan(r):
    best, bd = None, None
    for d in range(1, min(r - 1, 61) + 1):
        T = sum(comb(d, k) * (-1) ** k * a[r - k] for k in range(d + 1))
        scale = sqrt(sum(comb(d, k) ** 2 * a[r - k] for k in range(d + 1)))
        z = abs(T) / scale
        if best is None or z < best:
            best, bd = z, d
    return best, bd

rows = list(range(3, RMAX + 1))
m, dstar = {}, {}
for r in rows:
    m[r], dstar[r] = scan(r)

EXACT = {4, 8, 20}
FOURP = [20, 28, 44, 52]
TOWER = [16, 32]
ranked = sorted(rows, key=lambda r: m[r])
rank = {r: i + 1 for i, r in enumerate(ranked)}

print("TOWER FRONTIER v2 — z on the fluctuation scale.  EXPLORATORY.")
print("  fifteen smallest min-z rows:")
print("   rank   r   min z       d*   class")
for r in ranked[:15]:
    cls = []
    if r in EXACT: cls.append("EXACT")
    if r in FOURP: cls.append("4p")
    if r in TOWER: cls.append("tower")
    print(f"   {rank[r]:4d} {r:4d}   {m[r]:8.5f}  {dstar[r]:3d}   {','.join(cls)}")
print("\n  the named rows:")
for r in FOURP + TOWER:
    cls = "4p" if r in FOURP else "tower"
    if r in EXACT: cls += ",EXACT"
    print(f"   {r:4d}   {m[r]:8.5f}  d*={dstar[r]:3d}   rank {rank[r]:2d}/60   {cls}")
import statistics
others = [m[r] for r in rows if r not in EXACT]
print(f"\n  non-exact rows: median min-z {statistics.median(others):.4f}"
      f"   p10 {sorted(others)[len(others)//10]:.4f}")
print("\nEXPLORATORY — no prereg, no decision rule, no verdict.")
