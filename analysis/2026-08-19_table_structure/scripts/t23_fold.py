"""
TEST 23 - the deep zeros as a balance rather than a vanishing.

Julian's observation: the stencil is a fold. Written out, the weights
(-1)^k C(7,k) at (20,6) are ANTISYMMETRIC about the midpoint of the cell's
own window, so the cell is a sum over pairs straddling that midpoint and a
zero is the statement that two weighted halves of pi weigh the same.

Then: two wings at 45 degrees on both sides. Split the stencil by sign and
the two arms occupy alternating positions on the axis, each carrying total
weight 64, mirrored about the fold.

This measures all of it, and it measures the things that would kill it:

  - the fold is an IDENTITY for odd stencil order, so a non-zero cell
    folds too. It explains the zero, it does not detect one.
  - wing+ - wing- = cell identically, so the wings cannot be evidence for
    anything the cell value does not already say.
  - the sevens around (20,6) are checked against how common 7 is in the
    neighbourhood, and against how common perfect powers are in the table.
  - the 45-degree directions in (r,d) are tried and do not fold.
  - base 3's closest approach is compared against base 2's zero, including
    the seed convention it depends on.

Nothing is fitted. Every negative below is reported as a negative.
"""
import math
from math import comb

from primecountpy import prime_pi
from sympy import factorint, perfect_power

from _paths import tee

tee(__file__)


def build(row):
    T = [list(row)]
    while len(T[-1]) > 1:
        p = T[-1]
        T.append([p[i] - p[i - 1] for i in range(1, len(p))])
    return T


def cell(T, r, d):
    i = r - d - 1
    return T[d][i] if 0 <= d < len(T) and 0 <= i < len(T[d]) else None


R2 = 32
pi2 = [prime_pi(2 ** r) for r in range(R2 + 1)]
N2 = [pi2[r] - pi2[r - 1] for r in range(1, R2 + 1)]
NC2 = [(2 ** r - 2 ** (r - 1)) - N2[r - 1] for r in range(1, R2 + 1)]
P, C = build(N2), build(NC2)

print("dyadic table to r = 32, project convention (seed 1,1,2,2,5,7,...)")
print(f"the four zeros: (2,1)={cell(P,2,1)} (4,1)={cell(P,4,1)} "
      f"(8,3)={cell(P,8,3)} (20,6)={cell(P,20,6)}")

# --- 1. the fold ---------------------------------------------------------
print("\n1. THE FOLD AT (20,6)")
n = 7
w = [(-1) ** k * comb(n, k) for k in range(n + 1)]
print(f"   Delta^7 pi at 2^20, weights k=0..7: {w}")
print(f"   antisymmetric about the midpoint, w[7-k] = -w[k]: "
      f"{all(w[k] == -w[n - k] for k in range(n + 1))}")
print(f"   window (2^13, 2^20], fold axis log2 x = {(13 + 20) / 2}")
print(f"   {'j':>3}{'weight':>8}{'hi=2^':>7}{'lo=2^':>7}"
      f"{'pi(hi)-pi(lo)':>16}{'term':>14}")
tot = 0
for j in range(4):
    hi, lo = 20 - j, 13 + j
    D = prime_pi(2 ** hi) - prime_pi(2 ** lo)
    tot += w[j] * D
    print(f"   {j:>3}{w[j]:>8}{hi:>7}{lo:>7}{D:>16}{w[j] * D:>14}")
print(f"   {'':>41}{'sum':>14}{tot:>14}")

print("\n   the fold is an IDENTITY, not a test - non-zero cells fold too:")
for (r, d) in [(21, 6), (19, 6), (22, 6)]:
    m = d + 1
    ww = [(-1) ** k * comb(m, k) for k in range(m + 1)]
    s = sum(ww[j] * (prime_pi(2 ** (r - j)) - prime_pi(2 ** (r - m + j)))
            for j in range((m + 1) // 2))
    print(f"      ({r},{d}) folds to {s}, and cell({r},{d}) = {cell(P,r,d)}")

# --- 2. the wings --------------------------------------------------------
def wings(r, d):
    m = d + 1
    ww = [(-1) ** k * comb(m, k) for k in range(m + 1)]
    pos = [(r - k, v) for k, v in enumerate(ww) if v > 0]
    neg = [(r - k, -v) for k, v in enumerate(ww) if v < 0]
    return (pos, neg,
            sum(v * prime_pi(2 ** e) for e, v in pos),
            sum(v * prime_pi(2 ** e) for e, v in neg))


print("\n2. THE TWO WINGS")
for (r, d) in [(20, 6), (8, 3), (21, 6)]:
    pos, neg, Pw, Nw = wings(r, d)
    tag = "ZERO" if cell(P, r, d) == 0 else f"cell = {cell(P,r,d)}"
    print(f"\n   ({r},{d})  {tag}")
    print("      wing +  " + "  ".join(f"2^{e}x{v}" for e, v in pos)
          + f"   weights sum {sum(v for _, v in pos)}")
    print("      wing -  " + "  ".join(f"2^{e}x{v}" for e, v in neg)
          + f"   weights sum {sum(v for _, v in neg)}")
    print(f"      wing + = {Pw}   wing - = {Nw}   difference = {Pw - Nw}")
print("\n   NOTE: wing+ - wing- = cell identically. The wings are a")
print("   decomposition, not an independent test.")

# --- 3. the neighbourhood and the diagonals ------------------------------
print("\n3. NEIGHBOURHOOD OF (20,6)")
print("      d=" + "".join(f"{d:>9}" for d in range(3, 10)))
for r in range(16, 25):
    row = f"  r={r:<3}"
    for d in range(3, 10):
        v = cell(P, r, d)
        row += f"{v:>9}" if v is not None else f"{'.':>9}"
    print(row)

print("\n   a zero forces cell(r,d+1) = -cell(r-1,d), and those two share")
print("   the diagonal r-d-1, so every zero puts a +-v pair on it:")
for (r, d) in [(20, 6), (8, 3)]:
    left, below = cell(P, r - 1, d), cell(P, r, d + 1)
    print(f"      ({r},{d}): left ({r-1},{d}) = {left}, below ({r},{d+1}) = "
          f"{below}, both on r-d = {r - 1 - d}: "
          f"{(r - 1) - d == r - (d + 1)}")

for diag in (13, 14):
    print(f"\n   diagonal r-d = {diag}, total 2^{diag-1} = {2**(diag-1)},"
          f" prime | composite:")
    print(f"      {'cell':>9}{'prime':>9}{'composite':>11}{'sum':>9}")
    for d in range(1, 13):
        r = d + diag
        pv, qv = cell(P, r, d), cell(C, r, d)
        if pv is None or qv is None:
            continue
        mark = ("   <-- ZERO" if pv == 0
                else "   <-- +-343" if abs(pv) == 343 else "")
        print(f"      ({r:>2},{d}){pv:>9}{qv:>11}{pv + qv:>9}{mark}")

# --- 4. are the sevens structural? --------------------------------------
print("\n4. ARE THE SEVENS STRUCTURAL?")
for (r, d) in [(19, 5), (20, 5), (19, 6), (20, 6), (21, 6), (20, 7)]:
    v = cell(P, r, d)
    f = factorint(abs(v)) if v not in (0, None) else {}
    fs = "0" if v == 0 else "  ".join(
        f"{p}^{e}" if e > 1 else str(p) for p, e in f.items())
    print(f"   ({r:>2},{d})  {v:>8}   {fs}")

box = [(r, d) for r in range(16, 25) for d in range(3, 10)
       if cell(P, r, d) not in (None, 0)]
div7 = [(r, d) for r, d in box if cell(P, r, d) % 7 == 0]
print(f"\n   cells in the 9x7 box: {len(box)}   divisible by 7: {len(div7)}"
      f" = {len(div7)/len(box):.1%}   (chance ~14.3%)")

vals = [abs(cell(P, r, d)) for r, d in box]
pp = sorted(v for v in vals if v > 1 and perfect_power(v))
print(f"   perfect powers in the box: {pp}")
allv = [abs(cell(P, r, d)) for d in range(1, len(P))
        for r in range(d + 1, R2 + 1) if cell(P, r, d) not in (None, 0)]
allpp = [v for v in allv if v > 1 and perfect_power(v)]
print(f"   perfect powers table-wide: {len(allpp)} of {len(allv)} nonzero"
      f" cells at d>=1 = {len(allpp)/len(allv):.2%}")

# --- 5. does (d+1) divide the repeated value? ----------------------------
print("\n5. DOES (d+1) DIVIDE THE REPEAT?")
print(f"   {'zero':>9}{'d+1':>5}{'r-d':>5}{'repeat':>9}"
      f"{'(d+1)|rep':>11}{'left':>8}{'(d+1)|left':>12}")
for (r, d) in [(2, 1), (4, 1), (8, 3), (20, 6)]:
    rep, left, k = cell(P, r, d - 1), cell(P, r - 1, d), d + 1
    sv = lambda v: "-" if v is None else str(v)
    dv = lambda v: "-" if v is None else str(v % k == 0)
    print(f"   ({r:>2},{d}){k:>5}{r-d:>5}{sv(rep):>9}{dv(rep):>11}"
          f"{sv(left):>8}{dv(left):>12}")
print("   (2,1) is the one cell SeedPerturbation does not protect.")

# --- 6. the 45-degree directions do not fold ----------------------------
print("\n6. THE 45-DEGREE DIRECTIONS IN (r,d) DO NOT FOLD")
print(f"   {'k':>3}{'along r-d=14':>16}{'along r+d=26':>16}")
for k in range(1, 6):
    a1, a2 = cell(P, 20 - k, 6 - k), cell(P, 20 + k, 6 + k)
    b1, b2 = cell(P, 20 - k, 6 + k), cell(P, 20 + k, 6 - k)
    sa = "-" if None in (a1, a2) else f"{a1 + a2}"
    sb = "-" if None in (b1, b2) else f"{b1 + b2}"
    print(f"   {k:>3}{sa:>16}{sb:>16}")

# --- 7. base 3's closest approach -----------------------------------------
print("\n7. BASE 3'S CLOSEST APPROACH, AND ITS CONVENTION")
pi3 = [prime_pi(3 ** r) for r in range(21)]
plain = [pi3[r] - pi3[r - 1] for r in range(1, 21)]
lat = list(plain)
lat[0] -= 2                                   # 2 and 3 both sit in rung 1
Tp, Tl = build(plain), build(lat)
print(f"   plain   seed rungs 1..5 = {plain[:5]}")
print(f"   lattice seed rungs 1..5 = {lat[:5]}     e = [2,0,...] so R_e = 1")
print(f"   cell(11,10) plain = {cell(Tp,11,10)}   lattice = {cell(Tl,11,10)}")
print(f"   (11,10) has r-d = {11-10} = R_e, so it sits ON the boundary.")
print(f"   SeedPerturbation.tableFrom_at_boundary predicts a shift of")
print(f"      (-1)^d * e(R) = (-1)^10 * 2 = 2   observed "
      f"{cell(Tp,11,10) - cell(Tl,11,10)}")
print(f"\n   is it a cell repeat, as base 2's zeros are?")
print(f"      base 2 (20,6): fed by {cell(P,20,5)} and {cell(P,19,5)} -> "
      f"{'EXACT repeat' if cell(P,20,5) == cell(P,19,5) else 'no'}")
for T, lab in ((Tp, "plain"), (Tl, "lattice")):
    a, b = cell(T, 11, 9), cell(T, 10, 9)
    print(f"      base 3 (11,10) {lab:>7}: fed by {a} and {b} -> "
          f"{'EXACT repeat' if a == b else f'differ by {a-b}'}")
print("\n   window contents:")
for lab, bb, r, d in [("base 2 (20,6)", 2, 20, 6), ("base 3 (11,10)", 3, 11, 10)]:
    lo, hi = bb ** (r - d - 1), bb ** r
    print(f"      {lab:>16} ({lo}, {hi}]  primes "
          f"{prime_pi(hi) - prime_pi(lo):>7}   log2 width "
          f"{math.log2(hi / lo):.2f}")
