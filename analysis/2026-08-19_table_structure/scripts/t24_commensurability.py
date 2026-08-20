"""
TEST 24 - commensurability, collected.

Whether log b1 / log b2 is rational has decided at least five results on this
bench, each time under a different name and never as one thing:

  * t6_multirate  used the IRRATIONALITY of log2/log3 as the mechanism that
    breaks the alias degeneracy.
  * CHAIN.md 10   killed inheritance between bases with the same fact - base
    3's rungs never land on base 2's.
  * t22           found the sub-integer scan's bases COMMENSURATE by
    construction, which made the zero-surface question unanswerable.
  * The-Four-Zeros C5 uses it as a censoring note: base 3 would need
    non-integer depth to match base 2's windows.
  * Euler-Factor-Chain H3/H4 is the aliasing statement it all rests on.

This script computes the single quantity behind all five and shows it
deciding each case, so the fact stops being five observations.

THE QUANTITY. Two ladders b1, b2 sample log x at steps log b1, log b2. Their
rungs land on a common lattice iff log b1 / log b2 is rational, and then the
lattice has spacing gcd-like: the largest L with log b1, log b2 both integer
multiples of L. Irrational ratio means the only shared point is the origin.

Nothing here is new arithmetic. It is one line of number theory applied five
times, and the point is that it was applied five times without being named.
"""
import math
from fractions import Fraction

from _paths import tee

tee(__file__)

G1 = 14.134725141734693


def ratio(b1, b2):
    return math.log(b1) / math.log(b2)


def rational_ratio(b1, b2, tol=1e-12, maxden=10_000):
    """Is log b1 / log b2 rational?  Reported with the witness fraction."""
    q = ratio(b1, b2)
    f = Fraction(q).limit_denominator(maxden)
    return (abs(float(f) - q) < tol), f


# --- 1. the integer bases: which pairs share a lattice? -----------------
print("1. INTEGER BASES 2..9 - WHICH PAIRS SHARE A LADDER?")
print("   log b1 / log b2 rational  <=>  the two ladders have common rungs")
print(f"   {'':>4}" + "".join(f"{b:>8}" for b in range(2, 10)))
for b1 in range(2, 10):
    row = f"   {b1:>4}"
    for b2 in range(2, 10):
        if b1 == b2:
            row += f"{'-':>8}"
            continue
        ok, f = rational_ratio(b1, b2)
        row += f"{(str(f) if ok else '.'):>8}"
    print(row)
print("   '.' means irrational, so the two ladders meet only at x = 1.")
print("   the rational entries are exactly the power-chains 2-4-8, 3-9.")

# --- 2. the same fact, as the inheritance kill --------------------------
print("\n2. THE SAME FACT AS CHAIN.md 10's INHERITANCE KILL")
for b1, b2 in [(4, 2), (8, 2), (9, 3), (3, 2), (5, 2), (6, 2), (7, 2)]:
    ok, f = rational_ratio(b1, b2)
    if ok:
        print(f"   base {b1} inherits from base {b2}: log{b1}/log{b2} = {f}"
              f"  -> every base-{b1} rung IS a base-{b2} rung")
    else:
        print(f"   base {b1} orphan of base {b2}: log{b1}/log{b2} = "
              f"{ratio(b1,b2):.9f} irrational  -> no shared rung above x = 1")

# --- 3. the sub-integer scan's bases -------------------------------------
print("\n3. THE SUB-INTEGER SCAN - COMMENSURATE BY CONSTRUCTION")
unit = math.pi / (4 * G1)
fam = [("exp(pi*%d/(2*g1))" % k, math.exp(math.pi * k / (2 * G1))) for k in range(1, 5)]
anti = [("exp(pi*%d/(4*g1))" % k, math.exp(math.pi * k / (4 * G1)))
        for k in (3, 5, 7, 9)]
refi = [("2**(1/2)", 2 ** 0.5), ("2**(1/3)", 2 ** (1 / 3)), ("2", 2.0)]
print(f"   unit = pi/(4*gamma_1) = {unit:.9f} in natural log")
print(f"   {'base':>20}{'ln b':>12}{'/unit':>9}{'exact':>7}")
for lab, b in fam + anti + refi:
    q = math.log(b) / unit
    print(f"   {lab:>20}{math.log(b):>12.6f}{q:>9.4f}"
          f"{('YES' if abs(q - round(q)) < 1e-9 else 'no'):>7}")
print("   the family and antiphase arms are m = 2..9 times one unit, so all")
print("   eight share a lattice.  2, 2^(1/2), 2^(1/3) share a different one.")
print("   there is no incommensurate PAIR anywhere in the scan.")

# --- 4. where irrationality is the mechanism, not the obstruction --------
print("\n4. THE SAME FACT WITH THE OPPOSITE SIGN - t6_multirate")
print("   a single ladder at base b aliases every zero above pi/ln b, and")
print("   returns a COMB of peaks at spacing 2*pi/ln b, all of equal height:")
for b in (2, 3):
    print(f"      base {b}: Nyquist pi/ln b = {math.pi/math.log(b):>6.3f}"
          f"   comb spacing 2*pi/ln b = {2*math.pi/math.log(b):>6.4f}")
print("   measured, base 2 alone: five peaks at 8.898 17.965 27.358 36.425")
print("   45.156, every one at variance explained 0.486 (results/t6_multirate.txt)")
print("   gaps 9.067 9.393 9.067 8.731 against the stated 9.0647")
print("   pooling base 2 with base 3 breaks the tie EXACTLY BECAUSE")
print("   ln3/ln2 is irrational - the two combs share no tooth but the first.")

# --- 5. the censoring note in The-Four-Zeros C5 -------------------------
print("\n5. THE SAME FACT AS A CENSORING NOTE - The-Four-Zeros C5")
print("   base 2 depth d spans a window of ratio 2^(d+1).  another base b")
print("   reaches that window at depth log(2^(d+1))/log b - 1, integer or not:")
for r, d in ((20, 6), (8, 3)):
    w = 2 ** (d + 1)
    print(f"      ({r},{d})'s window has ratio 2^{d+1} = {w}:")
    for b in (3, 4, 5, 6, 7, 9):
        k = math.log(w) / math.log(b)
        print(f"         base {b}: depth {k - 1:>7.3f}"
              f"   {'INTEGER' if abs(k - round(k)) < 1e-9 else 'not an integer'}")
print("   (8,3)'s window 2^4 IS reached by base 4 at depth 1, since")
print("   log2/log4 = 1/2 exactly.  (20,6)'s 2^7 is reached by no integer")
print("   base but 2, because 7 is prime.  That is the whole difference")
print("   between the two deep zeros.")
print("   7 is prime, so 2^7 is reached by no integer base but 2 - which is")
print("   Zeros.window_exclusive_of_prime_exponent, proved.")

# --- 6. the one place it is a theorem ------------------------------------
print("\n6. WHERE IT IS ALREADY PROVED")
print("   Zeros.window_exclusive_of_prime_exponent (b k : N) (hb : 2 <= b)")
print("      (hk : 2 <= k) (h : b^k = 2^7) : b = 2 and k = 7")
print("   that is the commensurability question for one window, settled in")
print("   Lean, and it turns on 7 being PRIME rather than on irrationality.")
print("   The general statement - which pairs of ladders share rungs - is")
print("   NOT in the tree.")
