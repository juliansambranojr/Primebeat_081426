"""
TEST 11 - decimation aliasing along the base chains.  RECONSTRUCTION.

A base b samples the residual every ln b in u = ln x, so gamma_1 arrives
at angular frequency gamma_1 * ln b per rung, folded into [0, pi] by the
sampling.  When b = p^k the chain member is a DECIMATION of its parent -
it keeps every k-th sample - and the textbook consequence is that its
alias is the parent's alias multiplied by k and folded again:

    alias(p^k) = fold( k * alias(p) )

Part 1 checks that identity numerically for the five chain members
against the alias computed directly from gamma_1 * ln(p^k).  It is a
theorem about folding, so agreement to machine precision is the only
acceptable outcome; the point of measuring it is that a mismatch would
mean the fold convention in this project is not the one the chain
argument assumes.

Part 2 reports what the decimation costs: cycles available at the
ceiling, r_max * w / 2*pi.  Under one full cycle there is no frequency
to measure, whatever the alias says.

WHAT THIS DOES NOT CLAIM.  Nothing here touches prime data.  It is
arithmetic on gamma_1, ln p and the fold, plus a rung count.  It is not
evidence that any base does or does not carry a zero, and it is not a
test - no null, no prereg, no verdict.

RECONSTRUCTION NOTE.  Originally run inline as a heredoc during the
2026-08-19 session; no script survived.  Written afterwards from the
reported numbers and re-run.  Every figure reproduced.  See the NOTEPAD
line for the chronology.
"""
import math
from _paths import tee

tee(__file__)

# --- locked constants ---------------------------------------------------
GAMMA1 = 14.134725141734693
VALUE_CEILING = 2 ** 48

# (base, parent, k) with base = parent^k
CHAIN = [(4, 2, 2), (8, 2, 3), (16, 2, 4), (9, 3, 2), (27, 3, 3)]
ROOTS = [2, 3]


def fold(w):
    """Angular frequency as a sampled series can carry it: mod 2*pi, then
    reflected into [0, pi].  A sampled real signal cannot tell w from
    2*pi - w."""
    w = w % (2 * math.pi)
    return 2 * math.pi - w if w > math.pi else w


def alias(b):
    """gamma_1's frequency per rung in base b, folded."""
    return fold(GAMMA1 * math.log(b))


def r_max(b):
    return int(math.floor(math.log(VALUE_CEILING) / math.log(b)))


print("TEST 11 - decimation aliasing.  Reconstruction; exploratory.")
print(f"gamma_1 = {GAMMA1}   value ceiling 2^48 = {VALUE_CEILING}")
print()
print("roots (the bases nothing in this set decimates):")
for p in ROOTS:
    raw = GAMMA1 * math.log(p)
    print(f"   base {p:2d}   gamma_1*ln b = {raw:9.6f}   "
          f"mod 2pi = {raw % (2*math.pi):8.6f}   folded = {fold(raw):8.6f}")

print()
print("PART 1 - does fold(k * parent alias) equal the alias computed directly?")
print(f"{'base':>6}{'parent':>8}{'k':>3}{'fold(k*parent)':>17}"
      f"{'direct':>12}{'difference':>14}")
worst = 0.0
for b, p, k in CHAIN:
    via = fold(k * alias(p))
    direct = alias(b)
    diff = abs(via - direct)
    worst = max(worst, diff)
    print(f"{b:>6}{p:>8}{k:>3}{via:>17.9f}{direct:>12.9f}{diff:>14.3e}")
print(f"   largest disagreement {worst:.3e} rad "
      f"({'machine precision' if worst < 1e-12 else 'NOT machine precision'})")

print()
print("PART 2 - how much of that frequency is actually available?")
print(f"{'base':>6}{'r_max':>7}{'alias w':>11}{'cycles':>9}   note")
for b in [2, 3] + [c[0] for c in CHAIN]:
    w = alias(b)
    rm = r_max(b)
    cyc = rm * w / (2 * math.pi)
    note = "under one cycle - nothing to measure" if cyc < 1 else ""
    print(f"{b:>6}{rm:>7}{w:>11.4f}{cyc:>9.2f}   {note}")

print()
print("cycles = r_max * w / 2*pi, the number of full turns the alias makes")
print("across the whole ladder at this ceiling.")
