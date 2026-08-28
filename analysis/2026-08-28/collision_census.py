"""Collision census: measuring absence by its boundary.  EXPLORATORY.

Entry 253 discussion (Julian): an arithmetic zero has no gradation — it is
a discrete coincidence of the boundary, the two parent cells agreeing.
T(r,d) = 0  <=>  T(r,d-1) = T(r-1,d-1)  <=>  the binomial ledger splits
into two exactly equal halves (E = O = mass/2). Balance, absence, half.

So the census: for every cell, the integer distance-to-balance |T| against
the mass it balances across. Surprise in digits, against a fluctuation-
scale chance model:  s = log10( sqrt(mass) / (2|T|+1) ).  s > 0 beats
chance; the exact zeros' s is the information each absence carries; the
question is whether expensive NEAR-balances exist anywhere — does (20,6)
have near-peers at its scale, or is it the lone expensive balance.

All arithmetic exact (Python ints); pi(2^n) from pi2n_cache.json.
"""
import json
from math import comb, log10, sqrt

cache = json.load(open("pi2n_cache.json"))
pi2 = {int(k): int(v) for k, v in cache.items()}
RMAX = 62
a = {r: pi2[r] - pi2[r - 1] for r in range(1, RMAX + 1)}

cells = []
for r in range(2, RMAX + 1):
    for d in range(1, min(r - 1, 61) + 1):
        T = sum(comb(d, k) * (-1) ** k * a[r - k] for k in range(d + 1))
        mass = sum(comb(d, k) * a[r - k] for k in range(d + 1))
        s = log10(sqrt(mass) / (2 * abs(T) + 1))
        cells.append((s, r, d, T, mass))

cells.sort(reverse=True)
ZEROS = {(2, 1), (4, 1), (8, 3), (20, 6)}

print("COLLISION CENSUS — absence measured at its boundary.  EXPLORATORY.")
print(f"  {len(cells)} cells, r <= {RMAX}, exact integer arithmetic\n")

print("  the four exact zeros — the information each absence carries:")
print("     (r,d)      mass            s (digits)")
for s, r, d, T, mass in cells:
    if (r, d) in ZEROS:
        print(f"   ({r:2d},{d:2d})   {mass:14d}   {s:6.2f}")

print("\n  top 20 cells by surprise (exact zeros marked):")
print("   rank  (r,d)      |T|            mass             s")
for i, (s, r, d, T, mass) in enumerate(cells[:20], 1):
    mark = "  <- EXACT ZERO" if (r, d) in ZEROS else ""
    print(f"   {i:4d}  ({r:2d},{d:2d})   {abs(T):8d}   {mass:16d}   {s:6.2f}{mark}")

nz = [(s, r, d, T, mass) for s, r, d, T, mass in cells if (r, d) not in ZEROS]
print(f"\n  best NON-zero cell: ({nz[0][1]},{nz[0][2]})  |T|={abs(nz[0][3])}"
      f"  mass={nz[0][4]}  s={nz[0][0]:.2f}")
print(f"  cells with s > 1 (ten-fold beat of chance): "
      f"{sum(1 for c in cells if c[0] > 1)} — of which exact zeros: "
      f"{sum(1 for c in cells if c[0] > 1 and (c[1], c[2]) in ZEROS)}")
print(f"  cells with s > 0 (any beat of chance): "
      f"{sum(1 for c in cells if c[0] > 0)} of {len(cells)}")

print("\nEXPLORATORY — no prereg, no decision rule, no verdict.")
