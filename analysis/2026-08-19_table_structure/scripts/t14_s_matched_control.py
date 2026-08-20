"""
TEST 14 - the S-matched control for test 8.  RECONSTRUCTION.

t8_subzeros.py measured the scale coordinate r-d of the 121 resolved
sub-integer zeros against a null drawn from the resolved support,
stratified by base, and returned

    observed mean r-d 26.744   null 47.846 +- 2.301   z = -9.17

i.e. the zeros sit far shallower in r-d than the support does.  That
null controls for WHICH BASE a cell is in and for nothing else.  It does
not control for how much prime mass the stencil at that cell touches.

S(r,d) = sum_k C(d,k) N(r-k) is that mass: the L1 weight of the depth-d
backward-difference stencil against the true rung populations - what the
cell would read if no cancellation happened at all.  It is the same S
the O45 run records per zero (results/sub_integer_base_scan.json,
summary.per_base[*].exact_zeros[*].S), and it is recomputed here from
scratch by the Pascal recurrence

    S(r,0) = N(r)        S(r,d) = S(r,d-1) + S(r-1,d-1)

and checked cell by cell against the recorded values.  S grows steeply
with both r and d, so a cell that can land on exactly zero is
overwhelmingly likely to be a thin one, and thin means small r-d.  If
that alone accounts for the -9.17, matching the null on ln S should
remove it.

The matched null: for each zero, draw one support cell UNIFORMLY from
the cells in the same base whose ln S is within LN_S_TOL of the zero's.
Stratification by base is retained, so the base composition of the null
still matches the data exactly.

WHAT THIS DOES NOT CLAIM.  Removing a z-score under a matched null shows
the raw statistic was not independent of stencil mass; it does not show
that stencil mass is the cause of anything, and it is not evidence for
or against any zero-placement mechanism.  This is a control, not a test
of a hypothesis - no prereg, no decision rule, no verdict.  The p-value
below is a Monte Carlo tail proportion over NPERM draws and inherits
that Monte Carlo error.

RECONSTRUCTION NOTE.  Originally run inline as a heredoc during the
2026-08-19 session; no script survived.  Written afterwards from the
reported numbers and re-run.  Reproduced within Monte Carlo error.  See
the NOTEPAD line for the chronology.
"""
import json
import math

import numpy as np
from primecountpy import prime_pi
from _paths import REPO, tee

tee(__file__)

# --- locked constants ---------------------------------------------------
RESULTS = str(REPO / "results" / "sub_integer_base_scan.json")
LN_S_TOL = 0.35            # matching half-width in ln S
NPERM = 20000
SEED = 2026                # REFERENCES.md house seed; t8_subzeros.py's too
REFERENCE_LABEL = "2"      # the integer reference arm, excluded

# t8_subzeros.py's unmatched result, for the comparison line
T8_OBS = 26.744
T8_NULL_MEAN = 47.846
T8_NULL_SD = 2.301
T8_Z = -9.17

RNG = np.random.default_rng(SEED)


def mass_table(b, r_max):
    """S[d][i] = S(r, d) with r = i + d + 1, by the Pascal recurrence."""
    pis = [prime_pi(int(math.floor(b ** r))) for r in range(r_max + 1)]
    S = [[pis[r] - pis[r - 1] for r in range(1, r_max + 1)]]
    while len(S[-1]) > 1:
        p = S[-1]
        S.append([p[i] + p[i - 1] for i in range(1, len(p))])
    return S


def resolved_cells(r_max, r_thick):
    """The support: cells at d >= 1 thick enough to be resolved.  Same
    rule as t8_subzeros.py."""
    return [(r, d)
            for d in range(1, r_max)
            for r in range(d + 1, r_max + 1)
            if r - d >= r_thick]


doc = json.load(open(RESULTS))
per = doc["summary"]["per_base"]
print("TEST 14 - S-matched control for test 8.  Reconstruction; exploratory.")
print(f"source {RESULTS}")
print(f"value ceiling 2^{doc['params']['value_ceiling_exp']} = "
      f"{doc['params']['value_ceiling']}   "
      f"ln S tolerance +-{LN_S_TOL}   {NPERM} draws   seed {SEED}")
print()

obs_rd, pools = [], []
mismatch = 0
print(f"{'base':>18}{'arm':>12}{'zeros':>7}{'support':>9}"
      f"{'median pool':>13}{'min pool':>10}")
for e in per:
    if e["label"] == REFERENCE_LABEL:
        continue
    zs = [(z["r"], z["d"], z["S"]) for z in e["exact_zeros"] if z["resolved"]]
    if not zs:
        continue
    b, r_max, r_thick = e["b"], e["r_max"], e["r_thick"]
    S = mass_table(b, r_max)

    for r, d, s_recorded in zs:                 # audit against the run of record
        if S[d][r - d - 1] != s_recorded:
            mismatch += 1
            print(f"   !! S mismatch {e['label']} ({r},{d}): "
                  f"rebuilt {S[d][r-d-1]} vs recorded {s_recorded}")

    cells = resolved_cells(r_max, r_thick)
    if len(cells) != e["n_resolved_cells"]:
        print(f"   !! {e['label']}: rebuilt {len(cells)} support cells vs "
              f"locked {e['n_resolved_cells']}")
    ln_s = np.log(np.array([S[d][r - d - 1] for r, d in cells], dtype=float))
    rd = np.array([r - d for r, d in cells], dtype=float)

    sizes = []
    for r, d, s_recorded in zs:
        obs_rd.append(r - d)
        sel = np.where(np.abs(ln_s - math.log(s_recorded)) <= LN_S_TOL)[0]
        pools.append(rd[sel])
        sizes.append(len(sel))
    print(f"{e['label']:>18}{e['arm']:>12}{len(zs):>7}{len(cells):>9}"
          f"{np.median(sizes):>13.0f}{min(sizes):>10}")

n = len(obs_rd)
observed = float(np.mean(obs_rd))
empty = sum(1 for p in pools if len(p) == 0)
print()
print(f"S recomputation vs the run of record: {mismatch} mismatches over "
      f"{n} zeros")
print(f"pooled: {n} resolved sub-integer zeros; {empty} with an empty "
      f"matched pool")
if empty:
    raise SystemExit("empty matched pools - the tolerance cannot be applied")

null = np.empty(NPERM)
for i in range(NPERM):
    null[i] = np.mean([p[RNG.integers(len(p))] for p in pools])

z = (observed - null.mean()) / null.std()
p_low = (1 + int((null <= observed).sum())) / (1 + NPERM)

print()
print("SCALE COORDINATE r-d, matched on ln S")
print(f"   observed mean   {observed:.3f}")
print(f"   matched null    {null.mean():.3f}   sd {null.std():.3f}")
print(f"   z               {z:+.2f}")
print(f"   p (low tail)    {p_low:.3f}")
print()
print("against t8_subzeros.py's unmatched null on the same 121 zeros:")
print(f"   observed mean   {T8_OBS:.3f}   (same statistic, same zeros)")
print(f"   unmatched null  {T8_NULL_MEAN:.3f}   sd {T8_NULL_SD:.3f}")
print(f"   z               {T8_Z:+.2f}")
print()
print(f"the null mean moves {T8_NULL_MEAN - null.mean():+.2f} in r-d once the")
print("draws are matched on stencil mass, and the observed value does not")
print("move at all - it is the same 121 zeros in both.")
