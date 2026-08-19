"""
TEST 10 - block-summing and the low-pass.  RECONSTRUCTION.

Base 4 is base 2 read two rungs at a time, base 8 three at a time:

    N_4(m) = pi(4^m) - pi(4^(m-1)) = N_2(2m) + N_2(2m-1)
    N_8(m) = pi(8^m) - pi(8^(m-1)) = N_2(3m) + N_2(3m-1) + N_2(3m-2)

so the coarser base's seed row is literally the dyadic one summed in
blocks of k.  Part 1 checks that as an identity on the data rather than
asserting it.

Summing k adjacent samples is a boxcar filter, whose transfer function
at angular frequency w is the Dirichlet kernel

    D_k(w) = | sin(k w / 2) / (k sin(w / 2)) |

Part 2 evaluates it at gamma_1's dyadic alias w = 2.7689 rad/rung
(CONTEXT.md, "Core quantities": omega_1 = gamma_1 ln 2 = 3.514260 folds
to 2.768926).  Near the top of the band the boxcar is a deep attenuator,
so block-summing should cost most of what little signal survives.

Part 3 is the arithmetic consequence: rebuild the dyadic table from the
block-summed seed at merge k = 1..6 and count exact zeros in each.

WHAT THIS DOES NOT CLAIM.  The Dirichlet number is the gain of a boxcar
on a pure sinusoid; it is not a prediction for how many zeros survive,
and no causal claim connects part 2 to part 3 here.  Zero counts under
merge are a census of one table at one ceiling, not a test - no null, no
prereg, no verdict.  Part 1's identity is exact arithmetic and carries
no inferential content at all.

RECONSTRUCTION NOTE.  Originally run inline as a heredoc during the
2026-08-19 session; no script survived.  Written afterwards from the
reported numbers and re-run.  Every figure reproduced.  See the NOTEPAD
line for the chronology.
"""
import math

from primecountpy import prime_pi

# --- locked constants ---------------------------------------------------
VALUE_CEILING = 2 ** 48
GAMMA1 = 14.134725141734693
OMEGA1_ALIAS = 2.7689260          # gamma_1*ln2 = 3.514260 folded into [0,pi]
DIRICHLET_K = [2, 3, 4]
MERGE_K = [1, 2, 3, 4, 5, 6]
BLOCK_BASES = [(4, 2), (8, 3)]    # (coarse base, block width over base 2)


def seed_row(b, ceiling):
    """N(r) = pi(floor(b^r)) - pi(floor(b^(r-1))) up to the ceiling."""
    r_max = int(math.floor(math.log(ceiling) / math.log(b)))
    pis = [prime_pi(int(math.floor(b ** r))) for r in range(r_max + 1)]
    return [pis[r] - pis[r - 1] for r in range(1, r_max + 1)], r_max


def build(row):
    """Backward-difference table; rows[d][i] is cell (r, d) with r = i+d+1."""
    rows = [list(row)]
    while len(rows[-1]) > 1:
        p = rows[-1]
        rows.append([p[i] - p[i - 1] for i in range(1, len(p))])
    return rows


print("TEST 10 - block-summing and the low-pass.  Reconstruction; exploratory.")
print(f"value ceiling 2^48 = {VALUE_CEILING}")
print()

# --- part 1: the coarse bases ARE the dyadic one, summed -----------------
N2, r2 = seed_row(2, VALUE_CEILING)
print("PART 1 - is the coarse rung count the dyadic one summed in blocks?")
print(f"   base 2 has {r2} rungs")
for b, k in BLOCK_BASES:
    Nb, rb = seed_row(b, VALUE_CEILING)
    summed = [sum(N2[k * m - k: k * m]) for m in range(1, rb + 1)]
    print(f"   base {b} ({rb} rungs) == dyadic summed in {k}s : {summed == Nb}")

# --- part 2: the boxcar's gain at gamma_1's dyadic alias ------------------
print()
print(f"PART 2 - Dirichlet kernel |sin(k w/2) / (k sin(w/2))| at "
      f"w = {OMEGA1_ALIAS:.4f}")
print("   (gamma_1's dyadic alias; ln2 sampling folds 3.514260 to this)")
for k in DIRICHLET_K:
    d = abs(math.sin(k * OMEGA1_ALIAS / 2) / (k * math.sin(OMEGA1_ALIAS / 2)))
    print(f"   k={k}   D = {d:.4f}   ({100*(1-d):.1f}% of the amplitude removed)")

# --- part 3: exact zeros in the block-summed table -----------------------
print()
print("PART 3 - exact zeros in the dyadic table after block-summing")
print(f"{'merge k':>8}{'rungs':>7}{'zeros':>7}   locations (r, d)")
for k in MERGE_K:
    m_max = r2 // k
    merged = [sum(N2[k * m - k: k * m]) for m in range(1, m_max + 1)]
    rows = build(merged)
    zeros = [(i + d + 1, d)
             for d in range(1, len(rows))
             for i, v in enumerate(rows[d]) if v == 0]
    print(f"{k:>8}{m_max:>7}{len(zeros):>7}   {zeros if zeros else '-'}")

print()
print("d = 0 is excluded from the zero count: a zero there would be an")
print("empty rung, not a cancellation.  Zeros are counted on the rebuilt")
print("table only, at this ceiling only.")
