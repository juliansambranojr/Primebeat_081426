"""
TEST 20 - is the scale family self-similar?

The chain 2 -> 4 -> 8 -> 16 is exact: base 4's depth-0 row is base 2's
summed in pairs, base 8's in triples, verified cell for cell. That makes
it a SCALE FAMILY - the same object sampled coarsely. The open question is
whether it is also SELF-SIMILAR: does some normalisation make the coarse
table a rescaled copy of the fine one?

Two reasons to doubt it, both already measured. Block-summing attenuates a
mode by the Dirichlet kernel (18.5% at k=2) and moves it by decimation
aliasing (omega -> k*omega mod 2pi). Attenuation could be absorbed by a
scale factor. Aliasing cannot - it is not a similarity transform, it folds
distinct frequencies onto each other and is not invertible.

Three checks:

  A. Do the operators commute?  Block-summing then differencing against
     differencing then block-summing.  If S and Delta commuted the coarse
     table would be a literal sub-sampling of the fine one and similarity
     would be trivial.
  B. Is the coarse table a scalar multiple of the fine one restricted to
     its rungs?  Cell by cell, the best-fit scale and how well it holds.
  C. Are the depth PROFILES similar after normalising each row?  If the
     shape repeats and only the scale changes, that is self-similarity in
     the weaker sense that matters here.

Nothing is tuned. A ratio that fails to be constant is the finding.
"""
import math
import numpy as np
from primecountpy import prime_pi

from _paths import tee

tee(__file__)

V = 2 ** 48
GAMMA1 = 14.134725141734693


def seed(b, rmax):
    pis = [prime_pi(b ** r) for r in range(0, rmax + 1)]
    return [pis[r] - pis[r - 1] for r in range(1, rmax + 1)]


def diffs(row):
    rows = [list(row)]
    while len(rows[-1]) > 1:
        p = rows[-1]
        rows.append([p[i] - p[i - 1] for i in range(1, len(p))])
    return rows


rmax2 = int(math.log(V) / math.log(2))
N2 = seed(2, rmax2)
T2 = diffs(N2)

print(f"base 2 to r = {rmax2}\n")

# --- A. do S and Delta commute? -----------------------------------------
print("A. DO BLOCK-SUM AND DIFFERENCE COMMUTE?")
for k in (2, 3):
    rmk = rmax2 // k
    S_then_D = diffs([sum(N2[k*i:k*i+k]) for i in range(rmk)])
    D_then_S = []
    for d in range(len(T2)):
        row = T2[d]
        if len(row) < k * 2:
            break
        D_then_S.append([sum(row[k*i:k*i+k]) for i in range(len(row)//k)])
    agree = 0
    total = 0
    for d in range(1, min(len(S_then_D), len(D_then_S))):
        a, c = S_then_D[d], D_then_S[d]
        for i in range(min(len(a), len(c))):
            total += 1
            if a[i] == c[i]:
                agree += 1
    print(f"   k={k}: {agree} of {total} cells agree"
          f"  ({'commute' if agree == total else 'DO NOT commute'})")

# --- B. is the coarse table a scalar multiple of the fine one? ----------
print("\nB. IS THE COARSE TABLE A SCALED COPY?")
print("   base 4 cell (r,d) against base 2 cell (2r, 2d) - the same value")
print("   window at twice the resolution.  ratio should be constant if so.")
rmax4 = int(math.log(V) / math.log(4))
T4 = diffs(seed(4, rmax4))
ratios = []
for d in range(1, min(8, len(T4))):
    for r in range(d + 1, rmax4 + 1):
        i4 = r - d - 1
        if i4 >= len(T4[d]):
            continue
        v4 = T4[d][i4]
        R, D = 2 * r, 2 * d
        if D >= len(T2):
            continue
        i2 = R - D - 1
        if i2 < 0 or i2 >= len(T2[D]):
            continue
        v2 = T2[D][i2]
        if v2 != 0:
            ratios.append(v4 / v2)
ratios = np.array(ratios)
print(f"   {len(ratios)} paired cells")
print(f"   ratio: median {np.median(ratios):+.4f}   mean {ratios.mean():+.4f}"
      f"   sd {ratios.std():.4f}")
print(f"   spread: {np.percentile(ratios,5):+.3f} to {np.percentile(ratios,95):+.3f}"
      f"   (5th-95th)")
cv = ratios.std() / abs(ratios.mean()) if ratios.mean() else float("inf")
print(f"   coefficient of variation {cv:.2f}"
      f"   -> {'constant' if cv < 0.1 else 'NOT constant'}")

# --- C. are the depth profiles similar? ---------------------------------
print("\nC. ARE THE DEPTH PROFILES SIMILAR AFTER NORMALISING?")
print("   per depth, the row's RMS divided by its own depth-0 RMS.")
print("   if the shape repeats, the curves lie on top of each other.")


def profile(rows, nmin=8):
    out = []
    for row in rows:
        if len(row) < nmin:
            break
        out.append(math.sqrt(sum(float(v) ** 2 for v in row) / len(row)))
    if not out:
        return []
    return [math.log(v / out[0]) if v > 0 else float("nan") for v in out]


prof = {}
for b in (2, 4, 8, 16):
    rm = int(math.log(V) / math.log(b))
    if rm < 10:
        continue
    prof[b] = profile(diffs(seed(b, rm)))
    head = "  ".join(f"{v:+.2f}" for v in prof[b][:8])
    print(f"   base {b:2d}  depths {len(prof[b]):3d}   ln(RMS/RMS0) by depth: {head}")

print("\n   per-depth slope (growth in ln RMS per depth step):")
for b, p in prof.items():
    q = [v for v in p if v == v]
    if len(q) > 4:
        s = np.polyfit(np.arange(len(q), dtype=float), np.array(q), 1)[0]
        print(f"   base {b:2d}   slope {s:+.4f}   e^slope = {math.exp(s):.4f}"
              f"   (predicted |1-b^-rho| at gamma_1 = "
              f"{abs(1-complex(b)**(-complex(0.5,GAMMA1))):.4f})")
