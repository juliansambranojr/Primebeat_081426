"""
TEST 22 - do the 121 sub-integer zeros form a surface, or a scatter?

O45 counted them and O47 ranked them by stencil mass. Nobody has looked at
where they sit RELATIVE TO EACH OTHER across bases. That is the open
question behind the iris picture: four points at base 2 become 125 across
ten bases, and whether those 125 are a connected object or an interval
that merely happens to be occupied has never been measured.

THE COORDINATE. r and d are not comparable across bases - base 1.1175 runs
to r = 199, base 2 to r = 32, and cell (20,6) means different things in
each. What IS comparable is the stretch of the number line the cell reads:

    cell (r,d) at base b reads  ( b^(r-d-1), b^r ]

Written in log2 that is an interval [lo, hi] with

    lo = (r - d - 1) * log2 b        hi = r * log2 b
    w  = hi - lo = (d + 1) * log2 b

This is not a matching anyone chose. It is what the cell looks at, and it
is the same column O47 already prints. Connes-Measured E1/E2 records a
bridge withdrawn for being a chosen correspondence; E4 says what saved E3
was that no coordinate matching was required. This is the E3 kind.

THE QUESTION, made specific. "Surface" means adjacency ACROSS bases: a
zero at one base should have a zero at a neighbouring base sitting nearby
in window-space. "Scatter" means cross-base neighbours are no closer than
the resolved support already puts them.

THE NULL. Per base, draw as many cells from that base's own resolved
support as that base has zeros, and map them through the same coordinate.
Stratified, so the base composition of the null matches the data exactly -
without that the test measures which bases have zeros rather than where
inside the pool they sit. This is the same null shape that survived in t8
and the same confound that killed the raw r-d result in t14.

Nothing is fitted. A null result is the answer if that is what comes back.
"""
import json
import math

import numpy as np

from _paths import REPO, tee

tee(__file__)

RES = REPO / "results" / "sub_integer_base_scan.json"
NPERM = 2000
RNG = np.random.default_rng(2026)          # REFERENCES.md house seed


def window(b, r, d):
    """[lo, hi] in log2 of the value stretch cell (r,d) reads at base b."""
    lg = math.log2(b)
    return ((r - d - 1) * lg, r * lg)


def resolved_cells(r_max, r_thick):
    """The stratum O45 locks: d >= 1, and r - d >= r_thick."""
    out = []
    for d in range(1, r_max):
        for r in range(d + 1, r_max + 1):
            if r - d >= r_thick:
                out.append((r, d))
    return out


d = json.load(open(RES))
per = d["summary"]["per_base"]

zeros, support, counts, labels = [], [], [], []
print("BASES, ZEROS, AND SUPPORT")
print(f"{'base':>18}{'b':>10}{'zeros':>7}{'resolved':>10}")
for e in per:
    b = e["b"]
    zs = [(z["r"], z["d"], z["S"]) for z in e["exact_zeros"] if z["resolved"]]
    if not zs:
        continue
    cells = resolved_cells(e["r_max"], e["r_thick"])
    if len(cells) != e["n_resolved_cells"]:
        print(f"   !! {e['label']}: rebuilt {len(cells)} vs locked "
              f"{e['n_resolved_cells']} - using rebuilt")
    labels.append(e["label"])
    counts.append(len(zs))
    zeros.append(np.array([window(b, r, dd) + (b, S) for r, dd, S in zs]))
    support.append(np.array([window(b, r, dd) for r, dd in cells]))
    print(f"{e['label']:>18}{b:>10.6f}{len(zs):>7}{len(cells):>10}")

Z = np.vstack(zeros)                       # lo, hi, b, S
N = len(Z)
print(f"\npooled: {N} resolved zeros across {len(labels)} bases")

# --- 1. the windows themselves, sorted along the number line -------------
print("\n1. EVERY ZERO'S WINDOW, log2 of the values it reads")
print("   sorted by window bottom.  w = width = (d+1) log2 b")
order = np.argsort(Z[:, 0])
print(f"   {'lo':>8}{'hi':>8}{'w':>7}{'base':>10}{'S':>12}")
for i in order:
    lo, hi, b, S = Z[i]
    print(f"   {lo:>8.3f}{hi:>8.3f}{hi-lo:>7.3f}{b:>10.6f}{int(S):>12}")

# --- 2. is the window bottom related to the width? -----------------------
print("\n2. IS THERE A RELATION BETWEEN WHERE A ZERO LOOKS AND HOW WIDE?")
lo_z, hi_z = Z[:, 0], Z[:, 1]
w_z = hi_z - lo_z
r_zeros = float(np.corrcoef(lo_z, w_z)[0, 1])
S_all = np.vstack(support)
w_s = S_all[:, 1] - S_all[:, 0]
r_supp = float(np.corrcoef(S_all[:, 0], w_s)[0, 1])
print(f"   corr(lo, width)   zeros {r_zeros:+.4f}   support {r_supp:+.4f}")
print(f"   zeros   lo in [{lo_z.min():.2f}, {lo_z.max():.2f}]   "
      f"w in [{w_z.min():.2f}, {w_z.max():.2f}]")
print(f"   support lo in [{S_all[:,0].min():.2f}, {S_all[:,0].max():.2f}]   "
      f"w in [{w_s.min():.2f}, {w_s.max():.2f}]")


# --- 3. cross-base adjacency: the surface test ---------------------------
def cross_base_nn(pts, base_of):
    """Mean distance from each point to its nearest neighbour AT ANOTHER BASE."""
    D = np.sqrt(((pts[:, None, :2] - pts[None, :, :2]) ** 2).sum(-1))
    same = base_of[:, None] == base_of[None, :]
    D = np.where(same, np.inf, D)
    return float(D.min(1).mean())


base_of = Z[:, 2]
obs = cross_base_nn(Z, base_of)

null = np.empty(NPERM)
base_ids = np.concatenate([np.full(n, i) for i, n in enumerate(counts)])
for t in range(NPERM):
    draw = np.vstack([sp[RNG.choice(len(sp), size=n, replace=False)]
                      for sp, n in zip(support, counts)])
    null[t] = cross_base_nn(draw, base_ids.astype(float))

z = (obs - null.mean()) / null.std()
p_low = (1 + (null <= obs).sum()) / (1 + NPERM)

print("\n3. CROSS-BASE ADJACENCY  (the surface test)")
print("   mean distance in the (lo, hi) plane from each zero to the")
print("   nearest zero AT A DIFFERENT BASE.  lower = more surface-like.")
print(f"   observed        {obs:.4f}")
print(f"   null mean       {null.mean():.4f}   sd {null.std():.4f}")
print(f"   z               {z:+.2f}")
print(f"   p (low tail)    {p_low:.4f}   ({NPERM} stratified draws)")
print(f"   reading: p small = zeros sit closer across bases than the")
print(f"            support does.  p near 1 or 0.5 = scatter.")

# --- 4. the same statistic within a base, as a control -------------------
def within_base_nn(pts, base_of):
    D = np.sqrt(((pts[:, None, :2] - pts[None, :, :2]) ** 2).sum(-1))
    same = base_of[:, None] == base_of[None, :]
    np.fill_diagonal(D, np.inf)
    D = np.where(same, D, np.inf)
    ok = np.isfinite(D).any(1)
    return float(D[ok].min(1).mean())


obs_w = within_base_nn(Z, base_of)
null_w = np.empty(NPERM)
for t in range(NPERM):
    draw = np.vstack([sp[RNG.choice(len(sp), size=n, replace=False)]
                      for sp, n in zip(support, counts)])
    null_w[t] = within_base_nn(draw, base_ids.astype(float))
zw = (obs_w - null_w.mean()) / null_w.std()

print("\n4. CONTROL - the same statistic WITHIN a base")
print("   if the effect is about the number line rather than about")
print("   crossing bases, this moves too.")
print(f"   observed        {obs_w:.4f}")
print(f"   null mean       {null_w.mean():.4f}   sd {null_w.std():.4f}")
print(f"   z               {zw:+.2f}")

# --- 5. where the heavy ones sit ----------------------------------------
print("\n5. THE TEN HEAVIEST ZEROS BY STENCIL MASS, in window coordinates")
heavy = np.argsort(-Z[:, 3])[:10]
print(f"   {'S':>12}{'lo':>8}{'hi':>8}{'w':>7}{'base':>10}")
for i in heavy:
    lo, hi, b, S = Z[i]
    print(f"   {int(S):>12}{lo:>8.3f}{hi:>8.3f}{hi-lo:>7.3f}{b:>10.6f}")

# --- 6. the control that matters: match on window width ------------------
print("\n6. WIDTH-MATCHED CONTROL")
print("   Sections 3 and 4 BOTH fired, so the compression is not about")
print("   crossing bases - the zeros simply occupy a corner of window")
print("   space (w <= 7.00 against the support's 32.00).  Width is")
print("   (d+1) log2 b, i.e. the shallow-depth selection O46 identified")
print("   as stencil mass, seen geometrically.  So: redraw the null from")
print("   support cells MATCHED to each zero's own width, per base, and")
print("   ask whether any cross-base adjacency survives.")

TOL = 0.25
pools = []
for zi, sp, n in zip(zeros, support, counts):
    wz = zi[:, 1] - zi[:, 0]
    ws = sp[:, 1] - sp[:, 0]
    per_zero = []
    for w in wz:
        idx = np.flatnonzero(np.abs(ws - w) <= TOL)
        if len(idx) == 0:                       # widen only if forced
            idx = np.array([int(np.argmin(np.abs(ws - w)))])
        per_zero.append(idx)
    pools.append((sp, per_zero))
sizes = [len(ix) for _, pz in pools for ix in pz]
print(f"   matching tolerance +/- {TOL} in log2 width")
print(f"   candidate pool per zero: min {min(sizes)}  median "
      f"{int(np.median(sizes))}  max {max(sizes)}")

nullm = np.empty(NPERM)
for t in range(NPERM):
    draw = np.vstack([sp[[int(RNG.choice(ix)) for ix in pz]]
                      for sp, pz in pools])
    nullm[t] = cross_base_nn(draw, base_ids.astype(float))
zm = (obs - nullm.mean()) / nullm.std()
pm = (1 + (nullm <= obs).sum()) / (1 + NPERM)
print(f"   observed        {obs:.4f}   (unchanged - same zeros)")
print(f"   matched null    {nullm.mean():.4f}   sd {nullm.std():.4f}")
print(f"   z               {zm:+.2f}")
print(f"   p (low tail)    {pm:.4f}")
print(f"   raw z was {z:+.2f}; if this collapses toward 0 the cross-base")
print(f"   adjacency was the width concentration and nothing else.")

# --- 7. why sections 3, 4 and 6 cannot answer the question ---------------
print("\n7. THE BASES ARE COMMENSURATE BY CONSTRUCTION")
print("   The sorted list in section 1 shows exact repeats of the window")
print("   bottom ACROSS bases - lo = 4.810 at 1.248897, 1.395693 and")
print("   1.320256.  Exact coincidences across different bases do not")
print("   happen by accident, so check the base set itself.")
unit = math.pi / (4 * 14.134725141734693 * math.log(2))
print(f"\n   unit = pi/(4*gamma_1) in log2 = {unit:.9f}")
print(f"   {'base':>18}{'log2 b':>12}{'/unit':>10}{'exact?':>9}{'zeros':>7}")
comm = ncomm = 0
for e, n in zip([x for x in per if any(z['resolved'] for z in x['exact_zeros'])],
                counts):
    lg = math.log2(e["b"]); q = lg / unit
    ok = abs(q - round(q)) < 1e-9
    comm += n if ok else 0
    ncomm += 0 if ok else n
    print(f"   {e['label']:>18}{lg:>12.6f}{q:>10.4f}{'YES' if ok else 'no':>9}{n:>7}")
print(f"\n   {comm} of {comm+ncomm} zeros sit at bases whose log2 is an EXACT")
print(f"   integer multiple (2,3,4,5,6,7,8,9) of a single unit.  Their")
print(f"   ladders therefore land on one shared lattice, and window edges")
print(f"   MUST coincide across them.  The remaining three bases -")
print(f"   2, 2^(1/2), 2^(1/3) - have log2 1, 1/2, 1/3, mutually")
print(f"   commensurate in their own right.")
print("\n   So every base in the scan is commensurate with the others in")
print("   its arm, and there is no incommensurate pair anywhere in it.")
print("   Cross-base window alignment is FORCED by the base selection,")
print("   which came from D4's optimal-base family exp(pi*k/(2*gamma_1))")
print("   and was chosen for winding angle, not for this.")
print("\n   VERDICT: sections 3, 4 and 6 measure the prereg's base choice,")
print("   not the zeros.  The surface question is UNANSWERABLE with this")
print("   scan.  Answering it needs bases that are pairwise incommensurate")
print("   - the same property t6_multirate used to break the alias")
print("   degeneracy, wanted here for the opposite reason.")
