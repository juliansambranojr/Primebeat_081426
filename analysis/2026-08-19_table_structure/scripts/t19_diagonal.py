"""
TEST 19 - the diagonal as the null direction of the total.

At b = 2 the cell total is 2^(r-1-d): one rung right doubles it, one depth
down halves it. Equal and opposite, so the total is CONSTANT along a
diagonal r - d = const. The diagonal is the trend's own level set.

Walking a diagonal instead of a column, a mode picks up

    b^(r rho) (1 - b^(-rho))^d  with r = d + c
      = b^(c rho) * [b^rho - 1]^d

so the per-step factor is b^rho - 1, not 1 - b^(-rho). And since
b^rho - 1 = b^rho (1 - b^(-rho)), the diagonal gain is exactly sqrt(b)
times the column gain - a depth step and a rung step taken together.

    direction   smooth (rho=1)      gamma_1              ratio
    column       0.5                1.6784               3.357
    diagonal     1.0                2.3737               2.374

The smooth gain of exactly 1 along a diagonal is forced: the trend cannot
change along its own level set.

This measures all of it against the real table. Nothing here is a null
test - it checks predicted constants against observed ones.
"""
import math
import numpy as np
from primecountpy import prime_pi

from _paths import REPO, tee

tee(__file__)

B = 2
V = 2 ** 48
GAMMA1 = 14.134725141734693


def table(b, rmax, arm="prime"):
    pis = [prime_pi(b ** r) for r in range(0, rmax + 1)]
    row = [pis[r] - pis[r - 1] for r in range(1, rmax + 1)]
    if arm == "composite":
        row = [(b ** r - b ** (r - 1)) - row[r - 1] for r in range(1, rmax + 1)]
    rows = [row]
    while len(rows[-1]) > 1:
        p = rows[-1]
        rows.append([p[i] - p[i - 1] for i in range(1, len(p))])
    return rows


def cell(rows, r, d):
    """rows[d] holds r = d+1 .. rmax"""
    i = r - d - 1
    if d >= len(rows) or i < 0 or i >= len(rows[d]):
        return None
    return rows[d][i]


rmax = int(math.log(V) / math.log(B))
P = table(B, rmax, "prime")
C = table(B, rmax, "composite")

print(f"dyadic table to r = {rmax}\n")

# --- 1. is the total constant along a diagonal? -------------------------
print("1. TOTAL ALONG A DIAGONAL   (prime + composite at each cell)")
bad = 0
checked = 0
for c in range(1, 16):
    vals = []
    for d in range(0, rmax):
        r = d + c
        p, q = cell(P, r, d), cell(C, r, d)
        if p is None or q is None:
            continue
        vals.append(p + q)
        checked += 1
    if not vals:
        continue
    const = len(set(vals)) == 1
    if not const:
        bad += 1
    if c <= 6:
        print(f"   r-d = {c:2d}   total = {vals[0]:<12d} constant over {len(vals):2d} cells: {const}")
print(f"   ... {checked} cells checked over r-d = 1..15, diagonals not constant: {bad}")

# --- 2. measured gain, column vs diagonal -------------------------------
def geo_rate(seq):
    """geometric growth rate fitted to |values|, ignoring zeros"""
    v = [abs(x) for x in seq if x != 0]
    if len(v) < 4:
        return None
    y = np.log(np.array(v, dtype=float))
    x = np.arange(len(y), dtype=float)
    return math.exp(np.polyfit(x, y, 1)[0])


print("\n2. MEASURED GROWTH RATE of |cell|")
print("   predicted: column 1.6784 (gamma_1 mode), diagonal 2.3737 = sqrt(2) x that")

cols = []
for r in range(20, rmax + 1):
    seq = [cell(P, r, d) for d in range(0, r)]
    seq = [s for s in seq if s is not None]
    g = geo_rate(seq)
    if g:
        cols.append(g)

diags = []
for c in range(1, 20):
    seq = [cell(P, d + c, d) for d in range(0, rmax)]
    seq = [s for s in seq if s is not None]
    g = geo_rate(seq)
    if g:
        diags.append(g)

print(f"   down a column   median {np.median(cols):.4f}   over {len(cols)} columns")
print(f"   along a diagonal median {np.median(diags):.4f}   over {len(diags)} diagonals")
print(f"   observed ratio diagonal/column = {np.median(diags)/np.median(cols):.4f}"
      f"   predicted sqrt(2) = {math.sqrt(2):.4f}")

# --- 3. the exact constants, computed ----------------------------------
rho = complex(0.5, GAMMA1)
col_g1 = abs(1 - complex(B) ** (-rho))
dia_g1 = abs(complex(B) ** rho - 1)
print("\n3. THE PREDICTED CONSTANTS, from the symbol")
print(f"   column   smooth (b-1)/b            = {(B-1)/B:.4f}")
print(f"   column   |1 - b^-rho| at gamma_1   = {col_g1:.4f}   ratio {col_g1/((B-1)/B):.4f}")
print(f"   diagonal smooth |b^rho - 1| at rho=1 = {abs(complex(B)**1 - 1):.4f}")
print(f"   diagonal |b^rho - 1| at gamma_1     = {dia_g1:.4f}   ratio {dia_g1/1.0:.4f}")
print(f"   dia/col = {dia_g1/col_g1:.6f}   sqrt(b) = {math.sqrt(B):.6f}")

# --- 4. where the four zeros sit ----------------------------------------
print("\n4. THE FOUR ZEROS BY DIAGONAL")
for r, d in ((2, 1), (4, 1), (8, 3), (20, 6)):
    print(f"   ({r:2d},{d}) on diagonal r-d = {r-d:2d}, total 2^{r-1-d} = {2**(r-1-d)}")
