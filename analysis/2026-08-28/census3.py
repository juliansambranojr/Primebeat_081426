"""Triadic collision census + frontier: does the coherence live in another
table?  EXPLORATORY.  (Julian, mid-run: cells incoherent under the dyadic
table's nulls may be coherent under a different base's table — each base's
family at its own frontier.)  Same measures as the dyadic census (entry
254) and drift null, on base 3: a3(r) = pi(3^r) - pi(3^(r-1)).
Log: results/census3.log."""
import json
from math import comb, sqrt, log10
from mpmath import mp, li, mpf

mp.dps = 60
cache = json.load(open("pi3n_cache.json"))
pi3 = {int(k): int(v) for k, v in cache.items()}
ks = sorted(pi3.keys())
RMAX = max(ks)
print(f"TRIADIC CENSUS.  EXPLORATORY.  pi(3^n) cache: n = {min(ks)}..{RMAX}")
a = {r: pi3[r] - pi3[r - 1] for r in range(1, RMAX + 1)}
b = {r: li(mpf(3) ** r) - li(mpf(3) ** (r - 1)) for r in range(2, RMAX + 1)}

cells = []
for r in range(3, RMAX + 1):
    for d in range(1, r - 2 + 1):          # keep b well-defined (r-d >= 2)
        T = sum(comb(d, k) * (-1) ** k * a[r - k] for k in range(d + 1))
        mass = sum(comb(d, k) * a[r - k] for k in range(d + 1))
        Tli = float(sum(mpf(comb(d, k)) * (-1) ** k * b[r - k]
                        for k in range(d + 1)))
        s = log10(sqrt(mass) / (2 * abs(T) + 1))
        cells.append((s, r, d, T, mass, Tli))

cells.sort(reverse=True)
print(f"  {len(cells)} cells\n")
print("  top 12 by surprise:")
print("   rank  (r,d)      |T|          mass           s     |T_li|/sqrt(m)")
for i, (s, r, d, T, mass, Tli) in enumerate(cells[:12], 1):
    z = " EXACT ZERO" if T == 0 else ""
    print(f"   {i:4d}  ({r:2d},{d:2d})  {abs(T):9d}  {mass:14d}  {s:6.2f}"
          f"   {abs(Tli)/sqrt(mass):8.2f}{z}")
print(f"\n  cells with s > 1: {sum(1 for c in cells if c[0] > 1)}")
print(f"  exact zeros: {[(r,d) for s,r,d,T,m,_ in cells if T==0]}")
print("\nEXPLORATORY — no prereg, no decision rule, no verdict.")
