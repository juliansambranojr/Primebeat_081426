"""
TEST 8 - O42's question, asked of 121 zeros instead of 4.

O42 tested whether the four dyadic zeros sit at a constant winding angle
and returned no_constant_angle - honestly, since four points cannot
settle it. The sub-integer scan produced 121 RESOLVED zeros across ten
bases. Same question, a sample that can carry it.

For a zero at (r,d) in base b the accumulated winding is

    Phi = gamma1 * r * ln b  +  d * arg(1 - b^(-rho))      mod 2pi

exactly the coordinate O42 locked. The null is not random angles: it is
the SUPPORT ITSELF - the resolved cells that could have been zeros and
were not. Each base contributes draws equal to its own zero count, so
the base composition of the null matches the data exactly. Without that
stratification the test would measure which bases have zeros rather than
where inside a base they sit.

Statistic: mean resultant length R of the pooled phases. R near 1 means
the zeros share an angle; R near 0 means they are spread. Reported
against the null distribution of the same statistic.
"""
import json
import math
import cmath
import numpy as np
from _paths import REPO, tee

tee(__file__)

RES = str(REPO / "results" / "sub_integer_base_scan.json")
G1 = 14.134725141734693
NPERM = 20000
RNG = np.random.default_rng(2026)          # REFERENCES.md house seed

d = json.load(open(RES))
per = d["summary"]["per_base"]


def arg_step(b):
    rho = complex(0.5, G1)
    return cmath.phase(1 - complex(b) ** (-rho))


def phi(b, r, dd, astep, lnb):
    return (G1 * r * lnb + dd * astep) % (2 * math.pi)


def resolved_cells(rmax, rthick):
    out = []
    for dd in range(1, rmax):
        for r in range(dd + 1, rmax + 1):
            if r - dd >= rthick:
                out.append((r, dd))
    return out


bases, zero_ph, supp_ph, counts = [], [], [], []
print(f"{'base':>14}{'arm':>12}{'zeros':>7}{'resolved':>10}")
for e in per:
    if e["label"] == "2":
        continue                                   # reference, not sub-integer
    b = e["b"]
    lnb, astep = math.log(b), arg_step(b)
    cells = resolved_cells(e["r_max"], e["r_thick"])
    if len(cells) != e["n_resolved_cells"]:
        print(f"   !! {e['label']}: rebuilt {len(cells)} vs locked "
              f"{e['n_resolved_cells']} - using rebuilt")
    zs = [(z["r"], z["d"]) for z in e["exact_zeros"] if z["resolved"]]
    if not zs:
        continue
    bases.append(e["label"])
    counts.append(len(zs))
    zero_ph.append(np.array([phi(b, r, dd, astep, lnb) for r, dd in zs]))
    supp_ph.append(np.array([phi(b, r, dd, astep, lnb) for r, dd in cells]))
    print(f"{e['label']:>14}{e['arm']:>12}{len(zs):>7}{len(cells):>10}")

allz = np.concatenate(zero_ph)
N = len(allz)
print(f"\npooled: {N} resolved zeros across {len(bases)} bases")


def resultant(ang):
    return abs(np.exp(1j * ang).sum()) / len(ang)


obs = resultant(allz)
null = np.empty(NPERM)
for i in range(NPERM):
    draw = [RNG.choice(sp, size=n, replace=False) for sp, n in zip(supp_ph, counts)]
    null[i] = resultant(np.concatenate(draw))
p = (1 + (null >= obs).sum()) / (1 + NPERM)

print(f"\nWINDING PHASE  (O42's coordinate)")
print(f"   observed R      {obs:.4f}")
print(f"   null mean       {null.mean():.4f}   sd {null.std():.4f}")
print(f"   z               {(obs-null.mean())/null.std():+.2f}")
print(f"   p               {p:.4f}   ({NPERM} stratified draws from the support)")

# --- r-d, the scale coordinate -----------------------------------------
zr, sr, cnt = [], [], []
for e in per:
    if e["label"] == "2":
        continue
    zs = [z["r"] - z["d"] for z in e["exact_zeros"] if z["resolved"]]
    if not zs:
        continue
    cells = resolved_cells(e["r_max"], e["r_thick"])
    zr.append(np.array(zs)); sr.append(np.array([r - dd for r, dd in cells]))
    cnt.append(len(zs))

az = np.concatenate(zr)
obs2 = az.mean()
null2 = np.empty(NPERM)
for i in range(NPERM):
    null2[i] = np.concatenate(
        [RNG.choice(s, size=n, replace=False) for s, n in zip(sr, cnt)]).mean()
p2 = (1 + (null2 <= obs2).sum()) / (1 + NPERM)
print(f"\nSCALE COORDINATE r-d")
print(f"   observed mean   {obs2:.3f}")
print(f"   null mean       {null2.mean():.3f}   sd {null2.std():.3f}")
print(f"   z               {(obs2-null2.mean())/null2.std():+.2f}")
print(f"   p (low tail)    {p2:.4f}")
print(f"   zeros' r-d      min {az.min()}  median {np.median(az):.0f}  max {az.max()}")
print(f"   support's r-d   min {np.concatenate(sr).min()}  "
      f"median {np.median(np.concatenate(sr)):.0f}  max {np.concatenate(sr).max()}")
