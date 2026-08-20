"""
TEST 21 - identifying the aliased survivors.

CHAIN.md section 11 recorded that the residual's strongest surviving
frequencies - 23.602, 1.298, 26.114, 1.541, 3.572 - were "not within 0.4
of any zeta zero", and read that as confirmation of folding: real
structure at nobody's gamma.

That comparison was wrong. Folding is the mechanism, so the survivors
have to be compared against the FOLDED zeros, not the raw ones. A real
signal decimated to Nyquist w_n carries a frequency g > w_n at

    fold(g) = |g mod 2*w_n|  reflected into [0, w_n]

which for w_n < g < 2*w_n is just 2*w_n - g.

This computes the fold for every zero and matches it against the
survivors. It also asks whether the three small survivors are differences
of folded frequencies - reported with the number of candidate pairs, so a
loose "match" out of 45 tries is visible as the non-result it is.

Nothing is fitted. The base and Nyquist are fixed by section 11.
"""
import math

from _paths import tee

tee(__file__)

B = 1.1175405                      # section 11's base
NYQ = math.pi / math.log(B)
SURV = [23.602, 1.298, 26.114, 1.541, 3.572]
GAMMA = [14.134725141734693, 21.022039638771555, 25.010857580145688,
         30.424876125859513, 32.935061587739189, 37.586178158825671,
         40.918719012147495, 43.327073280914999, 48.005150881167159,
         49.773832477672302]


def fold(w, nyq):
    """reflect w into [0, nyq] the way real-signal decimation does"""
    w %= 2 * nyq
    return w if w <= nyq else 2 * nyq - w


print(f"base {B}   Nyquist = pi/ln b = {NYQ:.4f}")
print(f"first fold zone ends at 2*Nyquist = {2*NYQ:.4f}\n")

print("EVERY ZERO, FOLDED INTO THE VISIBLE BAND")
print(f"{'':>9}{'gamma':>10}{'':>11}{'lands at':>10}"
      f"{'nearest survivor':>19}{'d':>9}")
for k, g in enumerate(GAMMA, 1):
    f = fold(g, NYQ)
    hit = min(SURV, key=lambda s: abs(s - f))
    d = abs(hit - f)
    where = "visible " if g < NYQ else "folds to"
    mark = "   <-- MATCH" if d < 0.05 else ""
    print(f"  gamma_{k:<2}{g:>10.4f}   {where}{f:>10.4f}{hit:>19.3f}"
          f"{d:>9.4f}{mark}")

print("\nSURVIVORS, EACH AGAINST ITS BEST FOLDED ZERO")
for s in SURV:
    d, k, g = min((abs(fold(g, NYQ) - s), k, g)
                  for k, g in enumerate(GAMMA, 1))
    print(f"  {s:>7.3f}   gamma_{k} = {g:.4f} -> {fold(g, NYQ):.4f}"
          f"   d = {d:.4f}")

print("\nARE THE SMALL SURVIVORS DIFFERENCES OF FOLDED FREQUENCIES?")
pos = [fold(g, NYQ) for g in GAMMA]
pairs = [(abs(pos[i] - pos[j]), i + 1, j + 1)
         for i in range(len(pos)) for j in range(i)]
print(f"  {len(pairs)} candidate pairs - a loose fit out of this many is")
print("  selection, not identification.")
for s in (1.298, 1.541, 3.572):
    d, i, j = min((abs(v - s), i, j) for v, i, j in pairs)
    v = abs(pos[i - 1] - pos[j - 1])
    print(f"  {s:>7.3f}   best |fold(g{i}) - fold(g{j})| = {v:.4f}"
          f"   d = {d:.4f}   {'match' if d < 0.05 else 'NOT a match'}")

print("\nIS THE FOLD INVERTIBLE HERE?")
above = [g for g in GAMMA if g > NYQ]
amb = [g for g in GAMMA if g > 2 * NYQ]
print(f"  {len(above)} of {len(GAMMA)} zeros lie above Nyquist")
print(f"  {len(amb)} lie above 2*Nyquist = {2*NYQ:.4f}")
print("  first-zone folding g -> 2*nyq - g is injective, so with zero")
print("  zeros in the second zone nothing is ambiguous for this base.")
print("  NOT TESTED: whether the zeros can be recovered from their images.")
