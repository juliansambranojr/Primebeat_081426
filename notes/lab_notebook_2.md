# Lab notebook, volume 2 — Primebeat_081426

Volume 2. Volume 1 is `lab_notebook.md`; it is closed and holds entries
1–44. This volume opens at entry 45.

Numbering is continuous across volumes: `entry N` is a unique address
project-wide, and a `NOTEPAD.md` line citing a bare entry number resolves
to whichever volume holds it — 1–44 in `lab_notebook.md`, 45 onward here.

Newest at top, same as volume 1.

Entry format and type vocabulary: `notes/notes_format.md`.

Agents append entries. Outcome markings and status transitions are
Julian's call.

---

## 2026-08-29 — Entry 260 — slice 1c proved: the near-diagonal, and where c₂·log x is born
type: formalization
refs: 257, 258, 259

**What was proved.** `PerronKernel.near_diagonal_sum`
(`lean_stage3/Stage3/PerronKernel.lean`, commit `75400f5`):

```text
Σ_{0<|log(x/n)|<1/2} Λ(n)·min(1, 1/(T·|log(x/n)|))
    ≤ 100·x·log(xT)²/T + 4·log x        (x ≥ 16, T ≥ 1)
```

Sorry-free, `[propext, Classical.choice, Quot.sound]`,
`#guard_msgs`-pinned. Entry 257's slice 1c.

**Where the c₂·log x term is born — now a theorem.** The two integers
nearest x pay `min ≤ 1` each; that pair of 1's times `Λ ≤ 2·log x` IS
the `4·log x`. Every other integer pays the distance inequality
`|log t| ≥ |t−1|/2` on [1/2, 2] — proved from `log ≤ t−1` applied at t
and 1/t, nothing deeper — into two harmonic tails (one reflected, one
double-peeled) closed by Mathlib's `harmonic_le_one_add_log`, with
`log(3x) ≤ log(x²) = 2·log x` sidestepping every log-3 numeric.

**Slice 1's analytic content is complete.** One file, three theorems,
one axiom set: `perron_kernel_truncated` (1a, the load-bearing unknown),
`far_terms_sum` (1b), `near_diagonal_sum` (1c). Remaining in hEF is
composition: assemble 1a+1b+1c into the Perron-to-ψ bound, slice 2's
pigeonhole on `zeta_local_zero_count` (already in this repo), slice 3's
log²T edges from `LogDerivZetaFinalBound`, slice 4's residue identity —
all against machinery sorry-free at the pin. The deepest leaf in the
ledger went from unpriced unknown to three proved estimates and an
assembly plan in one day.

---

## 2026-08-29 — Entry 259 — slice 1b proved: the far-terms sum
type: formalization
refs: 257, 258

**What was proved.** `PerronKernel.far_terms_sum`
(`lean_stage3/Stage3/PerronKernel.lean`, commit `5f058a7`):

```text
Σ_{|log(x/n)| ≥ 1/2} Λ(n)·(x/n)^(1+1/log x) / (T·|log(x/n)|)
    ≤ 300·x·log(xT)²/T        (x ≥ 16, T ≥ 1)
```

Sorry-free, `[propext, Classical.choice, Quot.sound]`,
`#guard_msgs`-pinned. Entry 257's slice 1b, at the Chebyshev level it was
priced at.

**The route.** The range condition buys `1/(T|log|) ≤ 2/T`; the power
splits as `x^c = e·x` times `Σ Λ(n)/n^c`; that sum falls to dyadic
blocks under `Chebyshev.psi_le_const_mul_self` (`ψ ≤ (log 4 + 4)·t`)
against a geometric tail; and the denominator lemma
`1/(1 − 2^(−δ)) ≤ 5/δ` comes from `1 − e^(−a) ≥ a·e^(−a)`, one linarith
from `1 + a ≤ e^a`. Total constant 20·e·(log 4 + 4) ≈ 293 under the
crude headline 300.

**The tool worth remembering.** `Real.tsum_le_of_sum_le` bounds a tsum
of nonnegative reals from finite-piece bounds with NO summability
side-condition — the whole estimate never argues convergence separately,
and summability falls out of the same finite bound
(`summable_of_sum_le`) for free.

**hEF state.** 1a proved (entry 258), 1b proved (this entry). Remaining:
1c (near-diagonal — where the c₂·log x term is born), then slices 2–4
(contour assembly against sorry-free machinery).

---

## 2026-08-29 — Entry 258 — slice 1a proved: the truncated Perron kernel, and the arc that was never needed
type: formalization
refs: 257

**What was proved.** `PerronKernel.perron_kernel_truncated` in
`lean_stage3/Stage3/PerronKernel.lean`, commit `5884639`:

```text
‖(2πi)⁻¹ ∫_{c−iT}^{c+iT} y^s/s ds − [1 < y]‖ ≤ y^c · min(1, 1/(T·|log y|))
```

for 0 < y ≠ 1, c > 0, T ≥ 1. Sorry-free, axioms
`[propext, Classical.choice, Quot.sound]`, `#guard_msgs`-pinned. This is
entry 257's slice 1a — hEF's load-bearing unknown, the single
self-contained contour estimate the adversary report called "the piece
both MediumPNT and StrongPNT were designed to avoid," classical home
Davenport ch. 17 / Montgomery–Vaughan Thm 5.2 (their π in the
denominator dropped: crude-explicit spec).

**The hypotheses actually needed.** Mathlib plus PNT+'s rectangle
scaffolding (`HolomorphicOn.vanishesOnRectangle`,
`ResidueTheoremOnRectangleWithSimplePole`, the `HIntegral`/`VIntegral`
edge algebra). Nothing else; the file's other imports are the ones the
statement needs.

**How it went, branch by branch — the pricing story.** The route sketch
(entry 257) named the circular-arc deformation as the coarse branch's
engine and the file header called it the hard part. The arc was never
needed anywhere:

- K1, y < 1: ONE finite rectangle of width T, crude endpoint bounds on
  the three far edges, total (2/π)·y^c. No limits.
- K1, y > 1: for T·log y ≥ 1, free from the decay branch. Below that,
  split off the exact `∫ ds/s = 2i·arctan(T/c)` — computed by pure real
  calculus (odd part cancels by its antiderivative, even part is the
  arctan derivative; no Complex.log, no arg) — a mean-value bound
  `‖y^s − 1‖ ≤ ‖s‖·log y·y^(re s)`, and one elementary two-variable
  inequality (`coarse_gt_ineq`: e^u, π, arctan(v/u); four nlinarith
  cases with margins 0.09–0.27).
- K2, both cases: rectangles marched to ∞ along the naturals,
  `horiz_bound` on every horizontal edge, far vertical dies by
  `y^n → 0`. The pole at 0 crossed exactly once: regular part
  `dslope (y^·) 0` proved entire via `has_fpower_series_dslope_fslope`,
  then `ResidueTheoremOnRectangleWithSimplePole` with residue 1 — which
  IS the indicator.

**What this confirms in the record.** Entry 257's honest assessment —
"no step needs mathematics absent from the literature or from either
library" — now has no exceptions: 1a was the only unpriced step and it
closed in one session. The remaining hEF slices are 1b/1c
(Chebyshev-level sums), 2 (pigeonhole on `zeta_local_zero_count`,
already in this repo), 3, 4 (assembly against sorry-free machinery).
And the method rule held again, in both directions: "hard is a
concession before you start" — the arc priced as hard was unnecessary,
and the piece priced as "decides whether the rest is worth starting"
took an afternoon against libraries that already held every ingredient.

---

## 2026-08-28 — Entry 257 — hEF's build order, made durable: the complete slice spec
type: provenance
refs: 130, 238, 256

The hEF build order existed only in the session transcript (the
2026-08-28 adversary report) — Claude-side ephemera that does not
survive an LLM swap. Julian caught the gap: a spec being worked must be
durable. This entry is the record; the statements below are recovered
verbatim from the transcript, and the 1a statement is additionally
committed as compiling Lean in `lean_stage3/Stage3/PerronKernel.lean`
(scaffold, 2 named sorries K1/K2, assembly proved; commit `6924ea0`).

**Slice 1a — the truncated Perron kernel bound. Start here.** Zeta-free,
self-contained, provable from Mathlib alone:

```text
theorem perron_kernel_truncated {y c T : ℝ} (hy : 0 < y) (hy1 : y ≠ 1)
    (hc : 0 < c) (hT : 1 ≤ T) :
    ‖(2πi)⁻¹ ∫_{-T}^{T} y^(c+it)/(c+it) i dt − [1 < y]‖
      ≤ y^c · min 1 (1/(T·|log y|))
```

Classical (Davenport ch. 17; Montgomery–Vaughan Thm 5.2, their constant
carries a π we drop — crude-explicit). Routes: coarse branch by
circular-arc deformation (|y^s| ≤ y^c on the arc, |1/s| = 1/R, length
πR); decay branch by rectangles to ±∞ (horizontals ∫ y^σ dσ/T).
Upstream probed 2026-08-28: PNT+ main's PerronFormula.lean has no
sharp-kernel min-bound — its kernel is the smoothed x^s/(s(s+1)) — so
no pin bump discharges this leaf. Its rectangle machinery
(vertIntBound, contourPull, HolomorphicOn.upperUIntegral_eq_zero) is
reusable for the decay branch.

**Slice 1b — the far-terms sum.** With c = 1 + 1/log x:
Σ_{n≥1, |log(x/n)|≥1/2} Λ(n)·(x/n)^c/(T·|log(x/n)|) ≤ c₁'·x·log(xT)²/T.
Needs only Chebyshev-type bounds on ψ (IEANTN/Chebyshev.lean supplies).

**Slice 1c — the near-diagonal term.**
Σ_{|log(x/n)|<1/2} Λ(n)·min(1, 1/(T|log(x/n)|)) ≤ c₂'·log x, using
|log(x/n)| ≥ |x−n|/(2x) for the nearest integer. This is where hEF's
c₂ log x term comes from.

**Slice 1 = 1a + 1b + 1c:**
‖ψ x − (2πi)⁻¹∫_{c−iT}^{c+iT} (−ζ'/ζ)(s)·x^s/s ds‖
  ≤ c₁'·x·log(xT)²/T + c₂'·log x.

**Slice 2 — good-T selection.** ∀ T ≥ 2, ∃ T' ∈ [T, T+1], every zero
ordinate at distance ≥ 1/(40 log T') from T'. Immediate from
Stage3.zeta_local_zero_count (already proved here, sorry-free) by
pigeonhole. Since hEF quantifies over all T ≥ 2, the shift T → T' is
absorbed into c₁·x·log(xT)²/T.

**Slice 3 — horizontal and left-edge bounds at T'.**
‖ζ'/ζ(σ ± iT')‖ ≤ C·log²T' for −1 ≤ σ ≤ 2, from LogDerivZetaFinalBound
plus slice 2's ordinate gap; for σ ≤ −1, from the functional equation.
Both inputs sorry-free.

**Slice 4 — the residue identity.** RectangleIntegral'_eq_sumResiduesIn
applied to G(s) = (−ζ'/ζ)(s)·x^s/s on [−1, c] × [−T', T']. Poles: s = 1
(residue x), s = 0 (residue −ζ'/ζ(0) = −log 2π), each ρ with |γ| < T'
(simple pole of ζ'/ζ, residue −m_ρ·x^ρ/ρ). HasSimplePolesOn is
discharged because ζ'/ζ has a simple pole at every zero regardless of
multiplicity. Add the σ = −1 edge, fold the trivial-zero tail
Σ x^(−2n)/(2n) = −½log(1−x⁻²) = O(1) into c₂, and the identity closes
into StmtExplicitFormula c₁ c₂ x₁.

**Honest assessment (the report's own words).** No step needs
mathematics absent from the literature or from either library — every
ingredient except Slice 1 is present and sorry-free in the pin, and
slice 2's zero count was already built in this repo for a different
purpose. Slice 1a is the load-bearing unknown: a single self-contained
contour estimate, the piece both MediumPNT and StrongPNT were designed
to avoid, and the right first thing to build.

---

## 2026-08-28 — Entry 256 — O97: floor_deterministic on the blind range, under lock
type: run
refs: 247, 249, 252, 255

PREREGISTERED. Prereg `preregs/floor_reconstruction_v1_20260828.md`
(LOCKED, sidecar `28a5f736…`, pre-image committed at `da9c79b` — the
first prereg in this repo to verify through git exactly as
`preregs/FORMAT.md` designed). Script `O97_floor_reconstruction.py`
(sha `dabe0412…`), log `results/O97_floor_reconstruction_run1.log`,
results `results/floor_reconstruction_fresh.json`.

**The blind arm.** x ∈ [512, 2048), a range no script in this repository
had computed when the text locked. Zeros file not blind (read all
session); the blindness is the x-range, disclosed as such in the
prereg's provenance section. Fail direction was live: ~4× the tooth
density the method was tuned on.

**Result.** r_Re = +1.0000, r_Im = +1.0000, resid/floor = 0.0022 at
Nmax = 10^7; ladder convergent (0.0035 at 10^6 → 0.0022). Pass
thresholds were 0.98 and 0.02. Mechanical output:
**floor_deterministic**. Cleaner than the explored range. The verdict
line is Julian's and sits blank in the Run record.

**What this closes, pending the verdict.** The day's exploratory chain
(entries 247–252) — the floor as two zero-parameter pieces, prime
skirts plus density edge — now stands under a locked protocol on data
outside everything the exploratory work touched.

---

## 2026-08-28 — Entry 255 — the frontier is real, and every table runs the same economy
type: run
refs: 253, 254

EXPLORATORY — no prereg, no decision rule, no verdict.
Scripts `analysis/2026-08-28/drift_null.py`, `analysis/2026-08-28/census3.py`;
logs `analysis/2026-08-28/results/drift_null.log`,
`analysis/2026-08-28/results/census3.log`. Both directions were
Julian's, posited mid-run: "the zero would be a boundary you can't pass on
another family," and "the other cells' coherence might live in another
table."

**The boundary you can't pass, computed.** Under the drift null (li-based
smooth table, dps 60), the dyadic triangle has a reachability frontier:
per row a minimum depth — d_min ≈ r/3 (5 at r=20, 12 at r=39, 20 at
r=62) — below which |T_li| > 3√mass and no fluctuation can cancel the
drift. Shallower than the frontier, absence is arithmetically
unreachable. 1,312 of 1,891 cells are reachable; the exhaustive search
found 4 zeros among them — reachability is necessary, far from
sufficient.

**The informative absences hug the frontier.** (20,6) sits one step
above row 20's d_min = 5; (39,14) two steps above row 39's d_min = 12.
At the frontier the drift has just barely decayed into fluctuation range
— an exact zero there cancels the largest drift a zero can ever cancel,
which is why those cells carry the information (entry 254's s-ranking).
The cheap zeros are interior or trivial. Third appearance of the same
law in one day: information lives at the boundary (entries 252, 253).
Artifact flagged: (2,1) reads "outside" only because li(1) diverges;
the cell is trivial regardless.

**The coherence lives in other tables too.** Triadic census
(π(3^r) − π(3^(r−1)) from `pi3n_cache.json`, r ≤ 41, same measures):
base 3 has its own expensive balance — (11,9), |T| = 11 against mass
174,801, s = 1.26, inside its own frontier — while its deep cells are
drift-blocked exactly like the dyadic ones. No exact zeros in range
(matches O27's record). Rates comparable: 3 expensive balances per
1,891 dyadic cells, 1 per 780 triadic. Each base runs the same economy:
a drift frontier, and rare expensive balances pinned to it.

**The open object, now cross-table.** The frontier family —
{(20,6), (39,14), (13,5)} in base 2, {(11,9)} in base 3 — the cells
where each table's ledger balances the largest mass its boundary
permits. What frontier events share across bases is the question the
day narrowed to, and no single table can answer it about itself.

---

## 2026-08-28 — Entry 254 — collision census: the absences ranked, the family found, and the null repriced
type: run
refs: 236, 253

EXPLORATORY — no prereg, no decision rule, no verdict.
Script `analysis/2026-08-28/collision_census.py`, log
`analysis/2026-08-28/results/collision_census.log`. Exact integer
arithmetic on all 1,891 cells (r ≤ 62) from `pi2n_cache.json`.

**The measure.** Julian's boundary reading (entry 253 discussion): an
arithmetic zero has no gradation — it is a discrete coincidence of the
parents, `T(r,d−1) = T(r−1,d−1)`, equivalently the binomial ledger
splitting into two exactly equal halves (E = O = mass/2; balance,
absence, half — one equation). So the census measures each cell's
integer distance-to-balance |T| against the mass balanced, with surprise
s = log10(√mass/(2|T|+1)).

**The four zeros are not equal citizens.** (20,6): mass 492,384 balanced
exactly, s = 2.85 — the one expensive absence. (8,3): mass 88, s = 0.97.
(4,1): mass 4, s = 0.30. (2,1): mass 2, s = 0.15. The tower zeros are
trivia; (20,6) is the only absence carrying information. The species
question inverts.

**The expensive-balance family has three members.** Only 3 of 1,891
cells beat chance ten-fold: (20,6) exact at 2.85; (39,14) — |T| = 12,694
against mass 3.4×10^12, s = 1.86; (13,5) — |T| = 1 against mass 4,097,
one unit from a fifth exact zero, s = 1.33. Invisible to both prior
scans (fluctuation-scale and gross-mass), because it lives in discrete
boundary coincidences.

**Flags, not welds.** Row 20 appears twice in the top six ((20,6) exact,
(20,9) near) — plausibly the zero's structure propagating to its
descendants; checkable. (13,5)'s mass is 4097 = 2^12 + 1 exactly —
curio, nothing claimed.

**The null, repriced (Julian).** Only 54/1891 cells beat the √mass model
at all — and Julian's reading of that is the correct one: the table is
deterministic, so the null is only telling of what you are looking for.
The other cells' "imbalance" is a comparison against this one chosen
yardstick; they may be responding to a different null. Concretely: the
a(r) sequence grows geometrically, so the deterministic drift of
Δ^d a is the dominant account of a typical cell — the same
(1−(1−1/b)^d) transfer machinery as the coupling curve (O29 measured its
smooth side). Under the drift null, an exact zero means the fluctuation
lands exactly on −drift, and the price of each absence changes with the
drift's local size. Surprise is a property of the pair (cell, null) —
the same law as entry 253's (object, account). Next check: reprice the
family against the drift null (li-based smooth table, Δ^d).

---

## 2026-08-28 — Entry 253 — the tower map: the four zeros get a where
type: motivation
refs: 236, 246, 251, 252

Julian's structural reading of the small integers, armed clause by clause
against the record, and the map it produces for the oldest open item.

**The reading, with anchors.** 2 and 3 make the scaffold —
`twin_lower_mod_six` (`lean/TwinLattice.lean:38`): every twin pair above 3
is (6k−1, 6k+1). 4, 5, 6, 7 populate it: 6 = 2·3 is the first lattice
site and the scaffold's own product — which is why it is the first silent
integer (Λ = 0, the first pure-hum composite); 5 and 7 are the site's twin
arms (6·1±1, the first occupied rung); 4 = 2² is the first echo. 8 = 2³
and 9 = 3² are the towers — each other under base↔exponent inversion,
adjacent once and never again (Mihailescu; the only consecutive proper
powers). 4 = 2² is the FIXED POINT of that inversion. 9 is the seam the
integers chose themselves — distinct from the accountant's seam of entry
252, which moves when the account moves.

**The map.** The table's exact zeros sit at bases 2, 4, 8, 20
(`CONTEXT.md:316`): the tower of 2 WITH its fixed point — (2,1), then
(4,1) the echo persisting, then (8,3) the deep one at λ = 4
(`CONTEXT.md:331`). The four-zeros question now has a shape it lacked:
the vanishing points of the filter lie on the tower of the scaffold prime
whose seam is 8|9.

**The frontier, which makes it a map.** (20,6) is not on the tower:
20 = 2²·5 — the fixed point times the first off-scaffold prime — the deep
zero at count 38635, and the record already notes (8,3) and (20,6) appear
in no class table together (`CONTEXT.md:649`). Any explanation the tower
frame produces must reach (20,6) or say precisely why it is a different
species. First testable angle: is {4p} a family — does the near-zero
landscape distinguish bases 4·prime?

**Method note, recorded where it happened.** Three of Julian's structural
posits in one session were met with a label before a look, and the look
sided with the structure each time (scaffold → theorem; seam →
Mihailescu; echo → the record's zeros). The correction is saved as
working memory: open the record and measure first; a contingent operand
(the 8.6% share, which moved three times under our own config changes)
gets a measured sentence about that operand, never a class label on the
claim. The residual statement that survives: a residual is a property of
the pair (object, account) — the S vector never moved all afternoon;
only the account did. Julian's framing: the numbers moved because intent
moved; it was always one thing — the absence. His namings for the day's
objects: the zeros as filter (Elephant, literally), the reconstruction as
fidelity check (r = 0.997), the seam as handshake (entry 252's
decorrelation: information re-expressed at every cut, compressed in the
bulk).

---

## 2026-08-28 — Entry 252 — the residual travels with the boundary: the unknown lives at the seam
type: run
refs: 249, 251

EXPLORATORY — no prereg, no decision rule, no verdict.
Script `analysis/2026-08-28/edge_shadow.py`, log
`analysis/2026-08-28/results/edge_shadow.log`. Nmax = 10^7, quartic
detrend, quiet points as entries 247–249. The reading key was written
into the script before the numbers came back.

**The design.** The measured sum (zeros ≤ 74920) is fixed. The model's
edge moves K zeros deeper — T_K = midpoint of the gap below the
K-th-from-last zero — and the strip (T_K, T] is booked exactly from the
known zeros. Every model accounts for the same zero set; only the
truncated-representation boundary moves. K ∈ {0, 2, 8, 32, 128}.

**Result 1 — the residual vectors decorrelate.** Against K = 0, every
deeper edge's residual correlates at −0.12 to +0.12 (noise floor 0.02 at
2048 points). The residual at each edge placement is a fresh object
generated at that seam.

**Result 2 — booking pages exactly buys nothing systematic.** Medians
0.0070 / 0.0130 / 0.0029 / 0.0039 / 0.0057 at K = 0/2/8/32/128 — no
trend in depth; K = 2 is worse than baseline and K = 8 the best. The
shadow's size is set by the local geometry of the gap where the cut
falls, never by how much has been read.

**Reading (entry 251's frame, measured).** The unknown is not
distributed through the book. It is created at the seam between booked
and unbooked, moves when the seam moves, and its size depends only on
the local shape of the break. The bulk — every written page — is
accounted to the method's noise floor. The 0.1% was never a property of
the content; it is the property of having an edge: a ledger of an
infinite sum carries an irreducible seam, and the afternoon's descent
from 8.6% was the seam being sharpened until only the seam remained.

**Prereg consequence.** The claim becomes: bulk deterministic; residual
edge-generated. The locked pipeline quotes its threshold on the bulk
residual with the edge rule fixed (gap midpoint); the edge term is
irreducible and gap-dependent by measurement.

---

## 2026-08-28 — Entry 251 — Julian's reframe: the residual as the future's shadow on the written page
type: motivation
refs: 246, 249, 250

Julian's posit, his frame: the accounting is of an infinite sum, so the
0.1% is what constrained infinity looks like from inside the truncation —
a compressed version of the parts already identified; a book whose future
content has no accounting until it reaches the limit; the residual scales
with the pages and parts known, and measures how much unknown is
available. His question: is the 0.1% content 0 and 1?

Two of the day's numbers support the frame literally:

1. **The compression is measured.** The infinite far tail — every prime
   past 10^7 — arrives on the window as smooth low-order drift: its whole
   influence compresses to ~5 polynomial coefficients (why detrending
   works, entry 249).
2. **The near future casts the sharpest shadow.** The largest remaining
   term is governed by one number — where the first excluded zero sits
   (the gap-midpoint rule, entry 249).

On 0-and-1: the choices are discrete (n prime or not is one bit; the next
zero's position is those bits refracted through the ledger), but what
reaches the page is their analog shadow, kernel-smoothed to amplitude
~0.007. The residual is the exchange rate between the future's bits and
ink on the current page.

One correction, and it is the day's sharpest measured statement: within
this book no choice was ever free. The explicit formula is linear and
exact; the next zeros are fully implied by the primes; no entropy was
found anywhere from 8.6% down. The 0.1% measures the accounting horizon —
how much of the already-determined future the truncated ledger has not
yet booked — never the universe's freedom.

**The check this motivates (run next).** The next chapter is in hand:
zeros1.txt continues past T. Move the model's edge K zeros deeper, book
the strip [T_deep, T] exactly from the known zeros, and compare against
the model at the original edge: if the residual travels with the boundary
(equal medians, uncorrelated residual vectors), the error belongs to the
edge between booked and unbooked — the shadow reading, measured. If the
strip-exact version matches better, part of the error was bulk. Sweep K
for the shadow's penetration depth.

---

## 2026-08-28 — Entry 250 — superposition holds to 0.1%: no interaction at the first moment
type: result-triage
refs: 245, 247, 249

Reading of the reconstruction against the question "is the unaccounted
part interaction?"

The model is pure superposition — each tooth rings independently, the
density edge adds, nothing multiplies anything — and that strictly linear
ledger reached 99.9%. Interaction at the level of S itself is therefore
bounded above by 0.1% of the floor on this range. The explicit formula's
pairing is linear in the prime comb, and the measurement confirms
superposition to one part in a thousand. Every reduction from 8.6% to
0.1% was re-representation of the same linear pieces (a missing linear
term, drift order, edge placement); nothing ever demanded that tooth A
know about tooth B.

Where interaction genuinely lives is one moment up: |S|², the weighted
pair correlation, Montgomery's F — and entry 245 measured that below
α = 1 even the second moment's mass sits in the teeth, with the pairs
cancelling (measured F at three-tenths of the diagonal). Across both
moments: first moment linear to 0.1%; second moment below α = 1 is teeth
plus suppression. Structure needing cross terms does not appear until
past α = 1 — beyond x = T, past the visibility horizon, where the beat
has already sunk under the floor.

---

## 2026-08-28 — Entry 249 — the expectation checked: precision refuted, the residual is edge and drift order
type: run
refs: 247, 248

EXPLORATORY — no prereg, no decision rule, no verdict.
Script `analysis/2026-08-28/residual_expectation.py`, log
`analysis/2026-08-28/results/residual_expectation.log`.

Entry 248 recorded the expectation that the 0.67% remainder lives at
zeros-file precision and edge effects. Checked clause by clause:

- **Precision: refuted by five orders.** The file carries 9 decimals;
  perturbing every zero at that quantization moves the quiet points by
  2.4e-7 against an absolute residual of 0.034. Ratio 7e-6.
- **Mirror kernel: validated.** Dropping the K(u+v) term (entered on a
  symmetry guess) makes the residual 4× worse: 0.0067 → 0.0270.
- **Detrend order: carried half the remainder.** Cubic → quartic takes
  the base config 0.0067 → 0.0014 — far-tail drift has more smooth
  structure than a cubic absorbs.
- **Edge placement: dominates what is left.** Sweeping the model's T
  across the last zero gap [74919.075, 74920.260]: resid/floor 0.094 at
  either edge, 0.010 near the gap midpoint, 0.020 at the arbitrary
  T = 74920 (Nmax = 10^6 config). The discrete sum's natural edge is the
  midpoint of the bracketing gap — a principled rule, now measured.

Net: the floor is deterministic to ~0.1% (absolute ~0.007 on a floor of
5.14, 10^5 zeros), and every step of the accounting from 8.6% down was a
named model artifact. Prereg consequences: lock T = gap midpoint and lock
the detrend degree.

---

## 2026-08-28 — Entry 248 — the residual ladder: primes saturate at 8.6%, the hum's edge takes it to 0.67%
type: run
refs: 246, 247

EXPLORATORY — no prereg, no decision rule, no verdict.
Script `analysis/2026-08-28/floor_residual_limit.py`, log
`analysis/2026-08-28/results/floor_residual_limit.log`. Same grid, quiet
selection and cubic detrend as entry 247; Nmax ladder to 10^7 (665,134
prime-power teeth).

**The prime ladder saturates.** Plain skirt model, resid/floor:
0.1028 → 0.0933 → 0.0859 → 0.0876 → 0.0863 at Nmax = 10^4/10^5/10^6/
3·10^6/10^7. Marginal gains at the last two rungs: −0.0017, +0.0013 —
noise. Extending the prime comb past ~10^6 buys nothing: 8.6% of the
floor is not far-tail teeth.

**The saturated remainder is the hum's own edge.** One more
zero-parameter piece: the smooth zero density (Riemann–von Mangoldt,
`(1/2π)log(t/2π)`) has its own truncation ringing,
`D(u) = log(T/2π)/(2π)·e^{iuT}/(iu)`, coefficient fixed by the counting
law. With it: resid/floor = 0.0067 at Nmax = 10^7. Absolute: floor
median 5.14, unexplained remainder ≈ 0.03.

**Reading.** The floor decomposes into exactly two deterministic,
parameter-free pieces: the primes' skirts (~91%) and the carrier's own
truncation edge (~8.6%) — perturbation plus hum, entry 246's grammar
completing itself. Together: 99.33% of every quiet point on the line.

**Expectation, recorded as expectation.** The 0.67% remainder is at the
scale where zeros-file precision and edge effects would live. That is
unmeasured; checking it is the next step, before any prereg.

---

## 2026-08-28 — Entry 247 — the floor reconstructed from the primes: r = 0.997, no fitted constants
type: run
refs: 243, 245, 246

EXPLORATORY — no prereg, no decision rule, no verdict.
Script `analysis/2026-08-28/floor_reconstruction.py`, log
`analysis/2026-08-28/results/floor_reconstruction.log`. T = 74920, all
99,998 zeros; same 4096-point generic grid as entry 245.

**The model.** Nothing but each tooth's truncation ringing:

```text
S_model(u) = Σ_{n prime power ≤ Nmax} c_n [K(u − log n) + K(u + log n)]
c_n = −(1/2π)Λ(n)/√n,   K(w) = (e^{iTw} − 1)/(iw),  K(0) = T
```

Calibration is automatic — at u = log n the own-tooth term is Landau's
main term. Zero fitted constants.

**Result.** Complex scale between model and measurement: 1.000, phase
0.000. Detrended floor-only test (cubic drift removed from both sides,
bottom half by amplitude per octave): r_Re = +0.997, r_Im = +0.995,
residual 8.6% of the floor's amplitude at Nmax = 10^6 — and the residual
SHRINKS as teeth are added: 10.3% → 9.3% → 8.6% across
Nmax = 10^4/10^5/10^6. Jittered control: move every tooth 0.05–0.15 in
log and the correlation collapses to 0.004. At the integers, δ_model vs
entry 243's δ_measured: r = +0.947.

**Reading, in entry 246's vocabulary.** Primes perturb the floor: the
floor at every generic point is the interference of neighboring teeth's
ringing, measured at r = 0.997. Coupled to composites: the value at each
composite position is an exact knit of prime skirts — the same
zero-parameter formula produces the tooth at 9 and the quiet at 9.4. No
blow-up into noise or entropy: the floor's entropy budget is at most 9%
and falling with Nmax, consistent with zero in the limit. Entry 245's
standing question — what sets the floor's 0.03 constant and √x law — is
answered: it is the summed skirt amplitude of the prime-power comb under
a height-T truncation. Computable, deterministic, and the below-α=1
quietness of entry 245 is the coupling seen directly.

**Caveats.** The raw (undetrended) residual grows with Nmax — the
truncated far tail contributes a slowly divergent smooth-in-u drift
(Σ_p 1/(√p log p) diverges), which is why the floor test detrends both
sides with a cubic; documented in the script. Exploratory throughout: a
measured account, and a prereg would be needed for a verdict.

---

## 2026-08-28 — Entry 246 — Julian's posit: primes perturb the floor, coupled to composites
type: motivation
refs: 243, 244, 245

Julian's posit, in his words (as corrected by him): the composites sit at
the floor because they are reliable — flat, predictable — and that
reliability is what the primes are seen against; **primes perturb the
floor**, and they are **coupled to composites**; the coupling is what keeps
the floor's structure from blowing up into noise or entropy.

Three groundings, from what is already measured or standing:

1. **The composites hum; they do not beat.** Λ(composite) = 0 — no tooth,
   measured (D(6,9) has no main term). The composites enter as
   `ζ(s) = Σ 1/n^s`: the pole at s = 1 is the integers' perfect flatness,
   and that pole is the `T/2π` in every main term on this bench — N(T),
   the curve, Landau's resonance. The perturbation reading: the flat side
   of the Euler identity is the given; the primes are its unique
   factorization into perturbations.

2. **The coupling is the conservation.** `log n = Σ_{d|n} Λ(d)`: primes
   and composites are one ledger read from two sides. A coupled
   perturbation has no entropy budget — every unit of prime wildness is
   spoken for by composite structure. That is the standing candidate for
   entry 245's strangest number: the floor at 0.001 of GUE power. Below
   α = 1 the explicit formula is invertible, so the zero sums there are
   determined by primes plus smooth density; nothing is free to fill the
   floor to the noise line.

3. **Visibility calibration.** Measured floor 0.5·√x against tooth height
   (T/2π)Λ(x)/√x gives signal-to-floor (T/π)·Λ(x)/x, crossing 1 at
   x ≈ T — the beat stays visible over exactly the below-α=1 range and
   sinks at Montgomery's transition.

**The check this motivates (run next).** Reconstruct the measured floor
from the prime side: each tooth's sharp-truncation ringing
(`K(u−log n) = (e^{iT(u−log n)}−1)/(i(u−log n))`, which reproduces
Landau's main term at u = log n automatically), summed over prime powers,
correlated pointwise against the measured complex S on the 4096 generic
points of entry 245, mean-removed (the truncated-tail constant is
divergent-in-N_max and carries no u-dependence), with an N_max stability
sweep. High correlation: the floor is deterministic prime-skirt
interference — "primes perturb the floor" and "coupled to composites" are
one measured fact seen from two directions, and the composite floor is
knitted from the primes' skirts. Low correlation with N_max-stability:
the coupling has slack, and the slack becomes the object.

---

## 2026-08-28 — Entry 245 — the floor is not zero-zero correlation: one quiet √x law, with the mass in the teeth
type: run
refs: 235, 243, 244

EXPLORATORY — no prereg, no decision rule, no verdict.
Script `analysis/2026-08-28/beat_floor.py`, log
`analysis/2026-08-28/results/beat_floor.log`. T = 74920, all 99,998 zeros;
complex `S(x) = Σ e^{iγ log x}` on 4096 generic log-uniform points in
[2, 512] (offset off the integers) and on all integers 2–512.

**The floor is far below the zero-zero line.** The Montgomery/GUE
prediction for local power, `(T log T/2π)·α`, gives amplitudes 111–265
across the range. Measured generic-floor median |S| per octave: 2.1, 2.5,
3.4, 5.0, 6.0, 9.3, 12.4, 17.7 — thirty times quieter in amplitude, a
thousand in power, at every α. Ratio |S|²/GUE-line: median 0.001,
quartiles [0.000, 0.003], mean 1.68. The mean sits above 1 while the
median sits at 0.001: the below-α=1 correlation mass is concentrated in
the resonances — the cusps entry 235 placed at α = log n/log T — and the
space between them is empty by comparison.

**Two corrections to entry 244's closing speculation, from measurement.**
Im S does not carry the missing scale: at the integers, median |Im S| is
0.0195 of the GUE line — as small as the real part. And the integers are
not specially pinned: the generic points between them obey the same law
(generic median |S| ≈ 2× the integer residual, the factor of a modulus
over one component). One √x law holds everywhere on the line, on
resonance and off, isotropic in phase (generic median |Re| 3.5, |Im| 2.9).

**The quietest points are the prime powers.** After the main term is
removed, prime-power residuals sit at median 0.0232 (Re) and 0.0115 (Im)
of the GUE scale, against 0.0301 and 0.0223 at Λ=0 integers. The
resonance lattice is marginally the stiffest place on the line — a
25–50% effect, exploratory.

**Standing open question.** The picture as measured: prime-power
resonances carry essentially all the structure below α = 1, over a floor
thirty times below spread-correlation power, following a clean √x law at
~3% of the unconditional envelope (entry 243). What sets that floor —
its 0.03 constant and its √x growth — is accounted for by neither
prime-zero resonance (subtracted) nor zero-zero correlation (mass is in
the teeth, both measured here).

---

## 2026-08-28 — Entry 244 — the deviation is the beat's receiver, aimed past the beat
type: result-triage
refs: 236, 242, 243

Reading of entry 243's numbers against the Prime Beat source
(`~/GitHub/primebeat/beat.py`: `B(t) = Σ_p p^(−1/2)·sin(t·log p + φ_p)`,
valleys on the zeros).

**The curve is the beat.** The coupling main term is the beat's pairing read
in the mirror direction — zeros summing at prime-power frequencies with
resonance `Λ(x)/√x`, where the beat is primes oscillating at `log p` with
weight `p^(−1/2)` and its valleys land on the zeros. One duality, two
directions.

**The deviation has the beat's form and none of its arithmetic.** The exact
decomposition `D(b,d) = Σ C(d,k)(−1)^k b^(−k/2) δ(b^k)` (entry 243) carries
the beat's weights `b^(−k/2)` and the beat's frequencies `k·log b` — the
same antenna — applied to the residue left after the prime resonance is
subtracted at every harmonic. Entry 243 measured that residue Λ-blind
(corr −0.065; base 6 pays the same as base 2).

**The cancellation.** `δ(b^k)` grows like `b^(k/2)` (the envelope power,
entry 243) and the weight is `b^(−k/2)`: they cancel exactly. Every
harmonic of the interference arrives equally loud, ≈ 0.5·C(d,k), so the
attribution table tracks bare binomial coefficients — k = 4,5 dominate
D(2,9) at +75/−104 because C(9,4) = C(9,5) = 126 is the largest count, for
no other reason. The beat's weighting is precisely the weighting that
flattens the Landau residue across depth: the table is tuned so the floor
under the beat is white in k.

**Open, and it launches the next check.** Whether that floor is zero-zero
correlation (Montgomery's side of the bench) rather than prime-zero
resonance is unmeasured. Two loose threads point there: (1) entry 243
measured only the REAL part of `S(x) = Σ e^{iγ log x}` — the imaginary part
at the same points is unmeasured; (2) entry 235's F machinery predicts the
local-average power of `|S|²` below α = 1, and the measured Re-part at
integers sits far below that scale — whether the gap is carried by Im S, by
pinning at resonance positions, or by an error in this reading is exactly
what a direct scan of complex S on a generic grid decides.

---

## 2026-08-28 — Entry 243 — C1: the Landau deviation scales like the envelope and ignores Λ(b)
type: run
refs: 236, 242

EXPLORATORY — no prereg, no decision rule, no verdict.
Script `analysis/2026-08-28/landau_deviation.py`, log
`analysis/2026-08-28/results/landau_deviation.log`. T = 74920, all 99,998
zeros of `imported/twin_count/zeros1.txt`.

**The reduction.** The coupling deviation decomposes exactly — an identity,
verified to 2.6e-9 relative — as

```text
D(b,d) = Σ_{k=1..d} C(d,k) (−1)^k b^(−k/2) δ(b^k),
δ(x)   = Σ_{γ≤T} cos(γ log x) + (T/2π)Λ(x)/√x
```

so entry 236's drift is a binomial resummation of per-x Landau deviations,
and the whole question is how δ(x) scales.

**Question 1 — envelope or excess.** Measured over every integer
x ∈ [2, 512]: log|δ| vs log x has least-squares slope +0.589 against the
unconditional envelope's +0.500 (flat oscillation would be 0.000), and the
octave-binned median of |δ|/(√x·log(xT)) is 0.030–0.043 in every bin from
[8,16) to [256,512). The deviation grows parallel to Landau's known
error-term shape at about 3% of it. There is no crossing anywhere in range:
the envelope is never approached, and the oscillation scale √(N/2) = 224 is
never approached either — δ(2) = 0.70 on a hundred thousand zeros.

**Question 2 — base-dependence.** corr(Λ(b), |D(b,9)|) = −0.065 over
thirteen bases. Mean |D(b,9)| is 63.4 on the Λ=0 bases {6,10,12} and 80.7 on
the ten prime-power bases — the same scale. The deviation's base-dependence
is size, b^(k/2) through δ(b^k), paid by every base alike; the main term's
base-dependence is arithmetic, Λ(b). These are different axes: the curve
reads what b is made of, the deviation reads only how big its powers are.
At b = 6 the main term is zero and D(6,9) = −58.6 stands alone — the
deviation is the floor every base stands on; the curve rises from it only
where Λ ≠ 0.

**Attribution.** D(2,9) = +45.28 is dominated by interior k: the k = 4 and
k = 5 terms contribute +75.1 and −104.5, the endpoints ±5 — the binomial
weights C(d,k)b^(−k/2) amplify mid-depth powers, so the drift entry 236 saw
grow with d is mid-k Landau deviation under growing binomial coefficients,
with sign cancellation holding |D| below the coherent worst case.

**T-stability.** δ(x,T)/√N(T) at T = 18730/37460/74920 stays in
0.001–0.018 and oscillates in T at fixed x. The deviation is an oscillation
well below every reference scale, growing in x alone.

---

## 2026-08-28 — Entry 242 — B1/B2: the von Koch converse proved, the equivalence pinned
type: formalization
refs: 238, 239, 240, 241

**What was proved.** Two theorems in
`lean_stage3/Stage3/VonKochScaffold.lean`, commit `8c64a69`:

```text
VonKoch.RH_of_psiWeak  :
  (∀ t ≥ x₀, |ψ t − t| ≤ C·√t·(log t)³) → RiemannHypothesis

VonKoch.RH_iff_psiWeak :
  RiemannHypothesis ↔ ∃ C > 0, ∃ x₀, Stage3.StmtPsiWeak C 3 x₀
```

Both `#guard_msgs`-pinned at `[propext, Classical.choice, Quot.sound]`, no
`sorryAx`. `StmtPsiWeak` is `Stage3/PsiToPi.lean:167`; the forward half is
entry 240's `RHPull.stmtPsiWeak_of_RH`. The default Stage3 target is
untouched, 8721 jobs green.

**The five slices, as built.** V1: the bound makes `F(s) = s/(s−1) +
s·∫₁^∞ E(x)x^(−s−1)dx` differentiable past the line
(`mellin_differentiableAt_of_isBigO_rpow`). V2: `F = −ζ′/ζ` on `re s > 1`
(`LSeries_eq_mul_integral_of_nonneg`). V3/V4 through one shared fact:
`G := F·ζ + ζ′` is analytic on `region := {re > 1/2} \ {1}` and vanishes
on `re s > 1` by V2, so the identity theorem
(`eqOn_zero_of_preconnected_of_eventuallyEq_zero`) makes it vanish on all
of `region`. V3 is then a division. V4 factors `ζ = (z−ρ)^(k+1)·g` at a
hypothetical zero (`analyticOrderAt`, order ⊤ dispatched by `ζ(2) ≠ 0`);
`G ≡ 0` factors as `(z−ρ)^k·[(k+1)g + (z−ρ)(Fg + g′)] = 0`, the bracket
vanishes on the punctured neighbourhood, and it is continuous at `ρ` with
value `(k+1)·g(ρ) ≠ 0`. V5: reflection through `riemannZeta_one_sub`
(entry-less, committed `21669e7`).

**The restructure that made V3/V4 land.** The scaffold's original route
named `Set.Countable.isPathConnected_compl_of_one_lt_rank` to connect the
half-plane minus the countable zero set. That lemma is whole-space; Mathlib
has no convex-minus-countable version
(`Analysis/Normed/Module/Connected.lean`, checked 2026-08-28). Running the
identity theorem on `G` instead needs connectivity of the half-plane minus
the single point 1 — covered by four convex pieces
(`preconnected_region`). The zero set of ζ appears in the proof exactly
once: as the one factored zero being contradicted. Same shape as the
mouth/stomach principle: no zero positions handled, ever.

**What this confirms in the record.** Entry 238 mapped the route and named
its price — one logarithm, k=3 against von Koch's k=2, for coarsening
per-zero weights into a sup. The iff shows the price is two-sided: RH
comes back from the coarsened k=3 bound. The loss bought at k=3 forward
does not obstruct the converse.

---

## 2026-08-28 — Entry 241 — what the two Lean artifacts are, and what they are for
type: motivation
refs: 237, 240

Written to be quoted. When the question "what are these two files" comes up
again — after a compaction, in a new session, or from a reader who was not
here — this entry is the answer, and it should be cited rather than
regenerated.

**They are two different things and they do not touch each other.**

---

### `lean/Elephant.lean` — what the table IS

The dyadic table is the Euler factor at 2, applied `d` times.

That single fact answers the questions the bench kept circling:

- **Why base 2 and not base 6.** 6 has no Euler factor. A table built on it is
  deaf to the zeros — measured at `+4.2` against base 2's `+7751`, on 100,000
  zeros (`analysis/2026-08-28/bridges.py`). The law is `Λ(b) ≠ 0`, i.e. `b` a
  prime power (`filter_couples_iff_isPrimePow`).
- **Why the γ-structure has spacing `2π/log 2`.** That is where `Sym` vanishes
  (`sym_eq_zero_iff`), and `lattice_step` gives the step.
- **Why the C2 band, the gain, the Nyquist bound and the stencil kept turning
  out to be versions of each other.** They are the modulus, the power, the
  zeros and the basis of one function.

That question is closed, and closed in a form that does not depend on anyone
remembering the argument. 29 theorems, `import Mathlib` and nothing from this
repo, 0 sorries.

---

### `lean_stage3/Stage3/LineBound.lean` — a block removed

This is **not about the table.** It came out of the constant-shaving slices
and landed somewhere else: a statement about `ψ` and `ζ`.

What it does for the repo is remove a block. Stage 3 exists to reach a
census-usable `π − Li` bound; hEF was what stood in the way; that consumer no
longer needs it (`stmtPsiWeak_of_RH`, entry 240). Real, and independent of the
table.

---

### The honest part

**The two files do not feed each other.** `Elephant.lean` does not feed
Stage 3. `LineBound.lean` does not use the table. Both are about primes and ζ,
which is not the same as being about each other.

**The thing tracked since the beginning is still open.** `Elephant.lean`
proves what the filter *is*. It says nothing about why the filtered sum hits
exactly zero at `(2,1)`, `(4,1)`, `(8,3)`, `(20,6)`. Entry 236's null found
those cells unremarkable — 4 at value 0 against 5 at +1 and 4 at +2, across
1677 cells. That is evidence, not an explanation, and the null may be the
wrong question.

---

### What the files are FOR

They are the part that cannot drift.

Everything else the assistant produces is subject to misremembering a section
letter, counting a `sorry` inside a comment, or reading a maximum off a
six-row slice of a seventeen-row table. All three happened in this repo, the
last two on 2026-08-27 and 2026-08-28. The Lean file is the only artifact
where being wrong is not available. That is why the day was worth spending.

## 2026-08-28 — Entry 240 — StmtPsiWeak proved under RH, sorry-free, with no explicit formula
type: formalization
refs: 239

```text
RHPull.stmtPsiWeak_of_RH :
  RiemannHypothesis → ∃ C > 0, ∃ x₀, Stage3.StmtPsiWeak C 3 x₀
```

`#guard_msgs`-pinned at `[propext, Classical.choice, Quot.sound]`. No
`sorryAx`. Two clean rebuilds from scratch, 0 errors, Stage3 green at 8721
jobs, 0 real sorries anywhere in Stage3, no `set_option`.

`Assembly.psiWeak_of_RH_EF_NT` (`lean_stage3/Stage3/Assembly.lean:461`)
reaches `StmtPsiWeak` from hRH + hEF + hNT. This reaches it from **hRH alone**.

**Every constant obtained, none assumed.**

```text
bump_exists            concrete C^∞ Urysohn bump on [1/2,2], mass-one on Ioi 0
mellin_bump_bounded    B
SmoothedChebyshevClose Cclose
I1Bound / I9Bound      C₁, C₉
mellin_main_const      Cmain, ε₀ — MellinOfSmooth1c's IsBigO on 𝓝[>]0 unpacked
                       to a constant on a neighbourhood, via
                       eventually_nhdsWithin_iff + Metric.eventually_nhds_iff
x₀ := max (exp 6) (max 16 (1/ε₀² + 1)),  ε := X^(−1/2),  T := X
```

Every hypothesis discharges at that `x₀`: `log X ≥ 6`, `3 < X`, `3 < T`,
`ε < 1`, `ε < ε₀`, and `2 < X·ε = √X`.

**The five summands**, each into `c·√X·log³X`:

```text
smoothing    Cclose·ε·X·log X       = Cclose·√X·log X
I₁, I₉       C·X·log X/(ε·T)        = C·√X·log X        since ε·T = √X
vertical     (66600·e·B/π)·√X·log³X                     ε-free
horizontals  (900·e·B/π)·log²X each                     the X cancels at T = X
main term    Cmain·ε·X              = Cmain·√X
```

`C := Cclose + C₁ + C₉ + 66600eB/π + 2·(900eB/π) + Cmain + 1`.

**The `√X` is the abscissa.** `X^(1/2 + 1/log X) = e·√X` (`rpow_σRH`). Under RH
the contour crosses no zero, so no zero sum appears and hEF is never invoked.

**Two errors of mine, corrected by the work.** I called this a mountain twice
on 2026-08-28: once off a `sorry` counted inside a commented-out TODO in
`PerronFormula.lean` (that file is sorry-free), once off pricing hEF from the
literature instead of from `StmtPsiWeak`, which is all its consumer wants.
Entry 238's closing note also said `T ~ √X`; entry 239 recorded that as wrong.
Each was found by attempting the thing rather than by re-reading the estimate.

**The ledger.** hEF (`StmtExplicitFormula`, `Assembly.lean:101`) is **not**
discharged and remains open. What changed is that `StmtPsiWeak` no longer
needs it. `StmtArgCrude` is untouched. `hNT` is untouched — this route reaches
`StmtPsiWeak` without it as well, since the zero-counting enters only through
the zero sum that never appears.

`Stage3/LineBound.lean`: 70 theorems, 0 sorries. Commit `e8a1801`.

## 2026-08-28 — Entry 239 — the numeric instantiation: T = X, not √X, and every scale checks
type: formalization
refs: 238

Entry 238 left the final instantiation unwritten. Doing it moved one parameter
and the rest fell out.

**T = X, not √X.** `PrimeNumberTheoremAnd/MediumPNT.lean:1829` (`I1Bound`, and
`I9Bound` at 2150) gives `‖I₁‖ ≤ C·X·log X/(ε·T)`. With `ε = X^(−1/2)` the
choice `T = √X` makes `εT = 1` and those terms become `C·X·log X` — worse than
the target. `T = X` makes `εT = √X`, so they land at `C·√X·log X`. I had
written `T ~ √X` in entry 238's closing note; that was wrong, and the
instantiation is what showed it.

The correction pays twice. At `T = X` the horizontal Mellin factor is
`M ≤ B/T = B/X`, against `X^(1+1/log X) = e·X`, so **the `X` cancels
outright** and the horizontals collapse from a leading term to `O(log²X)`.

**Landed, `lean_stage3/Stage3/LineBound.lean`:**

```text
bump_exists              a concrete ν — ContDiff 1, supp ⊆ [1/2,2], nonneg,
                         mass-one on Ioi 0. From PNT+'s SmoothExistence, whose
                         mass condition is over Ici 0; {0} is null.
norm_ge_height           ‖σ + iT‖ ≥ T
mellin_horiz_le          ‖𝓜(Smooth1 ν ε)(σ + iT)‖ ≤ B/T
inv_sqrt_mul_self        (√X)⁻¹·X = √X
instantiation_arithmetic at ε = X^(−1/2), all three of
                           smoothing  εX log X     = √X log X
                           I₁, I₉     X log X/(εT) = √X log X
                           main term  εX           = √X
                         are ≤ c·√X·log³X
horiz_small              horizontal contribution ≤ (900·e·B/π)·log²X
```

**Every scale now checks.** Vertical `O(√X log³X)` by `I37_sqrt_log3`;
horizontals `O(log²X)`; `I₁`, `I₉`, smoothing and main-term all
`O(√X log X)`. `psi_weak_at` sums them into the `StmtPsiWeak _ 3 _` shape.

The bump is concrete rather than assumed — `SmoothExistence` builds a `C^∞`
Urysohn bump supported in `[1/2,2]` and normalises it to mass one.

**Remaining: existential wiring only.** `obtain` the constants from
`SmoothedChebyshevClose`, `I1Bound`, `I9Bound`; unpack `MellinOfSmooth1c`'s
`IsBigO` (it is stated as `(fun ε ↦ 𝓜(Smooth1 ν ε) 1 − 1) =O[𝓝[>]0] id`) into
a constant on a neighbourhood of `0`; choose `x₀`. No inequality in that chain
is unproved.

`Stage3/LineBound.lean`: 62 theorems, 0 sorries, Stage3 green at 8721 jobs.
Commit `fa97ebc`.

## 2026-08-28 — Entry 238 — the hEF-free route: StmtPsiWeak's shape reached at √X log³X, no explicit formula
type: formalization
refs: 237

hEF (`StmtExplicitFormula`, `lean_stage3/Stage3/Assembly.lean:101`) has been
the open analytic leaf since entry 119. It was not discharged. It was
**routed around**, and the route is proved.

**The reprice.** I twice called this a mountain today, on two errors. The
first: I counted a `sorry` in `PrimeNumberTheoremAnd/PerronFormula.lean` that
sits inside a commented-out TODO block (lines 367–370, `-- --`). Comments
stripped, PNT+ has 12 real sorries — 7 in `IwaniecKowalskiCh1`, 3 in
`StrongPNT`, 2 in `Wiener` — and **none** in `PerronFormula`,
`MellinCalculus`, `ZetaBounds`, or `MediumPNT`. The second: I priced hEF from
the literature instead of from its consumer. `Assembly.lean:465` wants only
`StmtPsiWeak` — `|ψ t − t| ≤ C√t (log t)^k` — and hEF is one route to it.

**The route.** Under RH the contour can be pushed to `σ₁ = 1/2 + 1/log X`
without crossing a zero, so no zero sum ever appears:

```text
RHPull.holo_logDerivZeta_of_RH   Pull1's holomorphy hypothesis, free under RH
RHPull.pull_at_RH_abscissa       SmoothedChebyshevPull1 at σ₁ = 1/2 + 1/log X
RHPull.rpow_σRH                  X^(1/2 + 1/log X) = e·√X
```

The `√X` is the **abscissa**, not `|x^ρ|`. That is the whole reason the zero
sum is dispensable.

**The three contour pieces**, all at that abscissa, all sorry-free:

```text
I37_norm_le / I37_norm_le_decay / I37_sqrt_log3   vertical, via Slice4b
I8_norm_le / I2_norm_le                           horizontals, via Slice3
```

The vertical needed two refinements. A uniform sup carries a factor `T` and
gives `X log²X` — useless. Integrating the Mellin factor's `1/‖s‖²` decay
instead (`kernel_le`, `integral_kernel_le`, via arctan) removes `T` entirely.

**The obstruction, and it was arithmetic.** `MellinOfSmooth1a` is an identity,
`𝓜(Smooth1 ν ε)(s) = s⁻¹·𝓜ν(εs)`; composing it with `MellinOfPsi`'s
*decaying* `C/‖w‖` produces `MellinOfSmooth1b`'s `C/(ε‖s‖²)`. That `ε⁻¹`
fights `SmoothedChebyshevClose`'s `εX log X`, and the balance caps the route
at `X^{3/4} log^{3/2} X`. **No choice of k rescues it** — the balance requires
`√X ≤ c·log^{2k−3}X`, which fails for every fixed k.

The `ε⁻¹` is an artifact. `MellinOfPsi`'s `C/‖w‖` blows up at the origin,
where the true function tends to `∫ν(x)dx/x = 1` — the mass-one condition.
Bounding `𝓜ν` uniformly instead:

```text
kernel_modulus_le    ‖x^(w−1)‖ ≤ 2 on [1/2,2] for 0 < re w ≤ 2
mellin_bump_bounded  ∃ B > 0, ‖𝓜ν(w)‖ ≤ B for 0 < re w ≤ 2   (B = 3·sup|ν|)
mellin_smooth1_le    ‖𝓜(Smooth1 ν ε)(s)‖ ≤ B/‖s‖              — NO ε
```

This lemma existed nowhere. It is the single piece that was not already in
the tree, and it is the difference between `X^{3/4}` and `√X`.

**The chain, closed.** With `ε` free, take `ε = X^(−1/2)`, `T = √X`:

```text
norm_line_ge         ‖σ₁ + it‖ ≥ (1+|t|)/3
integral_abs_kernel  ∫_{−T}^{T} (1+|t|)⁻¹ = 2 log(1+T)
I37_sqrt_log3        ‖I₃₇‖ ≤ (66600·e·B/π)·√X·log³X
psi_sub_self_le      |ψX − X| ≤ E₁ + E₂ + E₃
eps_choice_ok        εX log X = √X log X ≤ √X log³X
psi_weak_at          |ψX − X| ≤ (c₁+c₂+c₃)·√X·log³X
```

`psi_weak_at` **is** the `StmtPsiWeak _ 3 _` predicate at `X`. Its three
inputs are `SmoothedChebyshevClose` (PNT+, sorry-free), the contour bound
proved here, and `MellinOfSmooth1c`'s `O(ε)` main-term correction.

`k = 3`, and `Slice8.schoenfeldWeak_of_psiWeak_three` — the k=3 carrier — was
proved earlier today, before either of us knew where the route would land.

**What was already here.** Most of it. Slices 3, 4, 4b, 5, 8 were proved in
earlier sessions and sat in `results/scratch_lean/` as scratch, never compiled
into the tree; `unified_opt2.lean` is now `lean_stage3/Stage3/LineBound.lean`.
`rh2.lean` already discharged the holomorphy hypothesis. PNT+ had Perron,
Mellin, ZetaBounds and the whole pull apparatus, sorry-free, the entire time.
Today's work was composition, plus `mellin_bump_bounded`.

**Not done.** The final numeric instantiation — feeding a concrete bump
through `MellinOfSmooth1b/c` and `SmoothedChebyshevClose` to produce named
constants — is unwritten. Every lemma it needs is proved. hEF remains an open
leaf in the ledger; this route makes it unnecessary rather than discharging it.

`Stage3/LineBound.lean`: 56 theorems, 0 sorries, Stage3 green at 8721 jobs,
every theorem at `[propext, Classical.choice, Quot.sound]`.
Commits `8be39c2`, `440ed20`, `67f3b7a`, `3c6fe95`.

## 2026-08-28 — Entry 237 — Elephant.lean: the bench is one function, derived standalone from `1 − b^(−s)`
type: formalization
refs: 236

`lean/Elephant.lean`. Standalone — `import Mathlib`, no module of this repo.
29 theorems, 29 axiom pins, 0 sorries, 0 warnings, two clean rebuilds from
scratch. Defines `Sym b s = 1 − b^(−s)`, the reciprocal Euler factor at `b`,
and reaches every reading the tree uses from that line alone.

```text
symbol_of_difference / bdiff_iter_mode   differencing multiplies by Sym^d
sym_pow_expand / cpow_neg_pow            the stencil, supported on b^k
norm_sym_band / norm_sym_imaginary       the C2 band, the 2|sin| gain
sym_eq_zero_iff / lattice_step           the pole lattice and its step
sym_tprod_eq_zeta                        Sym IS ζ's Euler factor
sym_mul_lseries / sym_mul_logDeriv_zeta  the factor differences Λ
primeCount_backward_diff                 ... and π, on the b-ladder
coupling_coeff                           the base law WITH its magnitude
filter_couples_iff_isPrimePow            Λ(b^k) ≠ 0 ↔ IsPrimePow b
zeta_ne_zero_of_re_eq_zero               ζ has no zeros on Re s = 0
filter_ne_zero_at_zeta_zero              the table loses NO zero of ζ
```

Five lemmas written rather than found, Mathlib's nearest carrying the wrong
side conditions: `natCast_mul_cpow`, `cpow_neg_mul_lseries`, `sum_shift`,
`zeta_ne_zero_of_re_eq_zero`, `filter_ne_zero_at_zeta_zero`.

**Three corrections, recorded in the file at the point of each claim.**

The base law does **not** follow from the Euler product's index set. That
product is indexed by the primes, and bases 4, 9, 16, 25, 27 index no factor
in it — yet they carry the full measured coupling. The mechanism is von
Mangoldt support, which is the prime *powers*. I gave the wrong reasoning in
chat before the file corrected it.

`lattice_step` was `mul_div_assoc` and held where `log b = 0`. It now states
that consecutive lattice points are both zeros of `Sym` and differ by exactly
`2πi/log b`, using both hypotheses.

`IsModeRow` is marked unsatisfiable for `π`. `π` is a step function, not a
finite exponential sum; trying to discharge the hypothesis is what showed it.
`coupling_coeff` reaches the same base law by a route needing no such
hypothesis.

**Measured, `analysis/2026-08-28/`.** On 100,000 ζ zeros to γ = 74,920, the
coupling `Re Σ_γ (1 − b^(−ρ))^d − N(T)` at `d = 4` matches
`(T/2π)·Λ(b)·(1 − (1−1/b)^d)` — zero free parameters — at 16 prime-power bases
to under 0.4%, with 13 composite bases at |value| ≤ 6.2. Matched-density
controls: unfolded GUE +454, Poisson −87, against real +7751. The separation
is a derived consequence of Landau (1911), which appears nowhere in this repo.

**Honest scope.** Five of the twelve original theorems duplicated results
already in `lean/` — `sym_eq_zero_iff` has a signature identical to
`Chain.lean:381`. I asserted this had not been proven before; that was false
and an adversary caught it. What the file is: a standalone single-file
re-derivation demonstrating the readings follow from the definition alone.

## 2026-08-28 — Entry 236 — the table's own weight on the zero ensemble: first moment closes, second moment does not
type: run
refs: 234, 235

Entry 235 leaves a gap that is not about F. Montgomery 1973 and Odlyzko's
computations cover F(α,T) itself; neither applies the *table's* weight to the
zeros, because that weight has no reason to exist without the table.

`Superposition.tableFrom_eq_modeSum_reweighted`
(`lean/Superposition.lean:90`) carries each zero into the depth-`d` table with
factor `(Sym b ρ)^d`, and `Sym b s = 1 - b^(-s)` (`lean/Chain.lean:29`).
Binomial-expanding at `b = 2` gives support exactly on the powers of two:

```text
(1 - 2^-ρ)^d = Σ_k C(d,k) (-1)^k (2^k)^(-ρ)
```

Entry 235 established that F's cusps sit at `α = log n / log T` with mass
`Λ(n)²/(n log T)`; the powers of two are a subset of those positions. Hitting
each term with Landau–Gonek and resumming (the `k = 0` term is `N(T)`, since
`Λ(1) = 0`) predicts a closed form.

**FIRST MOMENT — measured, `analysis/2026-08-28/sym_moment.py`,
log at `analysis/2026-08-28/results/sym_moment.log`.**

```text
Re Σ_{0<γ≤T} (1 - 2^-ρ)^d  =  N(T) + (T/2π)·log2·(1 - 2^-d)

 d      measured Re      predicted      ratio
 1        104130.0        104130.5    1.00000
 2        106196.2        106196.8    0.99999
 3        107230.0        107229.9    1.00000
 6        108148.3        108133.9    1.00013
 9        108292.1        108246.9    1.00042
```

T = 74920, N(T) = 99998, (T/2π)log2 = 8265.0, all 99,998 zeros.

The derivation is elementary given Landau–Gonek — two lines for anyone holding
both pieces. The whole `d`-dependence collapses to `1 - 2^-d` with no residue,
so at the first moment the table's weight is transparent: it reads the powers
of two and returns their resummation. The deviation growing with `d`
(1.00000 → 1.00042 by `d = 9`, an excess of 45 in 108,292) is unexamined; the
natural candidate is Landau–Gonek's error term as higher powers of two enter
with larger binomial coefficients.

**A resemblance checked and rejected.** `1 - 2^-d` reaches 96.88% at `d = 5`
and 98.44% at `d = 6`, bracketing O49's measured 97.68%. It is a different
quantity. The C2 ceiling is `1 + b^(-1/2)`, a per-mode modulus bound
(`lean/Chain.lean:94`), and 97.68% is the fraction of that attained; the
saturation here is of a summed real part over the ensemble. Recorded because
the near-match was noticed and nearly asserted.

**SECOND MOMENT — measured, `analysis/2026-08-28/weighted_F.py`,
log at `analysis/2026-08-28/results/weighted_F.log`.**

Pair correlation with each zero carrying the table weight, normalized so every
depth has the same diagonal as the unweighted case, so row differences are pure
off-diagonal:

```text
F_d(α) = Σ Re[a(γ)ā(γ')e^{iαlogT(γ-γ')}] w(γ-γ') / Σ|a(γ)|²  ×  2πN(T)/(T logT)
```

`a(γ) = (1 - 2^-ρ)^d`, `w(u) = 4/(4+u²)`, CUT = 60, T = 74920, N = 99998.

```text
OFF-DIAGONAL  (F_d - 0.7472)
 d  |   0.20    0.40    0.60    0.80    0.84    0.88    0.92    1.00    1.20
 0  | -.5046  -.3663  -.1584   .0122   .0323   .0438   .0328   .0218  -.0015
 1  | -.4558  -.4053  -.2063  -.0183   .0164   .0424   .0345   .0301   .0031
 2  | -.3287  -.4324  -.2368  -.0439  -.0064   .0246   .0358   .0333   .0080
 3  | -.0462  -.4561  -.2638  -.0691  -.0311   .0029   .0287   .0371   .0109
 6  | 1.7899  -.4848  -.3399  -.1439  -.1052  -.0674  -.0294   .0264   .0154
```

Control: `d = 0` reproduces standard F to four decimals (0.2426, 0.3808,
0.5888, 0.7594 against entry 235's 0.243, 0.381, 0.589, 0.759).

The weight is not transparent here. Two observations, neither with error bars:

- The off-diagonal maximum sits at α = 0.88 for `d = 0` and `d = 1`, at 0.92
  for `d = 2`, and at 1.00 for `d = 3` and `d = 6` — a monotone rightward
  migration across five rows. The α = 0.88 hump is entry 235's ~9σ feature.
- At α = 0.20 the weighted value grows with depth, +1.79 above diagonal by
  `d = 6`, against −0.50 unweighted.

**Unmeasured, and the first thing needed.** No error bars on any weighted row.
Entry 235's bootstrap gives sd ≈ 0.005 for unweighted F; whether that transfers
under reweighting is untested, and the peak-value differences (0.0438 → 0.0371)
are of that order while the peak-*location* shift is a four-row pattern.
A candidate mechanism is also untested: `|1 - 2^(-1/2-iγ)|` is periodic in γ
with period `2π/log2 = 9.06`, which under Fourier duality would place sidebands
at spacing `log2/log T = 0.0618` in α — finer than this grid's 0.04 near the
hump, and the observed 0.88 → 1.00 migration is about twice that spacing.
Recorded as a candidate; nothing here tests it.

## 2026-08-28 — Entry 235 — the F(α,T) verdict broken: the plateau was the diagonal, the primes were there all along
type: result-triage
refs: 234

Entry 234 closed with F(α,T) untried at height: 600 zeros to γ = 939 were not
asymptotic, and `imported/twin_count/zeros1.txt` holds 100,000 to γ = 74,920.8.
Ran it at four heights, issued a three-part reading, then sent an adversary at
the artifact rather than at a summary of it. Two of the three parts fell.

**Mechanics — verified, and they held.** The adversary re-derived F from the
definition and reimplemented independently: tables agree to 3 dp, the fine
α-scan to 4 dp at all 12 points. Normalization, ordered pairs, diagonal
included, `cos` as the real part of `T^{iα(γ-γ')}` — all correct. `zeros1.txt`
SHA-256 matches the manifest in `imported/twin_count/README.md`; the counts
599 / 4520 / 22491 / 99998 match Riemann–von Mangoldt to |S(T)| ≤ 0.70; 9-dp
rounding gives max phase error 8.4e-9 rad. The truncation flagged as unmeasured
was fine: exact O(n²) at T = 939 and T = 5000 differs by ≤ 0.0006, and
CUT 60 → 400 at T = 74920 moves nothing by more than 0.0008.

**(i) Convergence toward min(α,1) below α = 1 — stands, on different
evidence.** The four rows T = 939 / 5000 / 20000 / 74920 are nested, and the
diagonal `2πN(T)/(T log T)` alone is 0.5856, 0.6669, 0.7135, 0.7472 — it moves
the table +0.162 by itself, against +0.026 for the whole α = 0.4 column. On
*disjoint* height bands the values settle rather than march: α = 0.4 gives
0.370, 0.381, 0.382, 0.383, 0.382; α = 0.6 gives 0.568, 0.585, 0.590, 0.592,
0.591. The cumulative table's smooth approach is a running mean reaching that
plateau.

**(ii) "Flat at ~0.75 above α = 1, and 167× the height barely moves it" —
false, in three ways.** 0.75 is the diagonal, `2πN(T)/(T log T)` = 0.7472,
which was never computed. `F − diag` at α = 1.2, 1.5, 2.0, 3.0 is −0.0014,
−0.0033, +0.0014, +0.0078 against 1σ = 0.0047: the off-diagonal above α ≈ 1.2
is zero. The gap to 1.000 is `(1 + log 2π)/log T` — measured against predicted,
0.4274/0.4146, 0.3111/0.3332, 0.2843/0.2866, 0.2561/0.2528 — a normalization
deficit predictable to two decimals, needing T ≈ 6e24 to close to 0.05. And
"barely moves" is backwards on the artifact's own table: α = 1.0 moves +0.177,
α = 1.2 +0.131, α = 1.5 +0.171, while α = 0.4, the column called convergent,
moves +0.026.

**(iii) "No prime signature" — false, by two independent measurements.**
Landau–Gonek, `Re Σ_{0<γ≤T} x^{iγ} ≈ -(T/2π)Λ(x)/√x`, on this file: twelve
prime powers match to four significant figures (x = 2: −5843.5 measured against
−5844.2; x = 3, 5, 7, 13 at ratio 1.000), while nine non-prime-powers and eight
random u give |Z| ≤ 12.4 — roughly 700× background. And inside F itself, via
the identity `F(α,T)·(T log T/2π) = ∫ e^{-2|t|}|Z(ξ-t)|² dt` (quadrature
0.35533 against pair-sum 0.35533): each prime power contributes a cusp of
height `Λ(n)²/(n log T)`, 0.0213 for n = 2 and 0.0482 for n = 7, measured spike
masses agreeing to 3 digits. The full model

```text
F(α,74920) = Σ_n Λ(n)²/(n logT)·e^{-2|α logT - log n|} + 6.356·T^{-2α}
```

has rms residual 0.0108 over 0.25 ≤ α ≤ 0.80 with one free parameter, and the
de-trended wiggles correlate with the von Mangoldt template at r = 0.996,
λ = 0.997 ± 0.042 (z = 23). Placebos: prime positions shifted 0.1 in ξ gives
r = 0.076; jittered, r ≈ −0.11; Cramér random "primes", r ≈ 0; all integers,
r = 0.066.

**Why the prime test had no power.** The residual model subtracted
`T^(-2α)·log T + α` with the `(1+o(1))` dropped, and that dropped factor *is*
the residual: empirical coefficients 0.363, 0.458, 0.519, 0.566 at the four
heights, and predicted residual ratio `B/logT − 1` = −0.637, −0.542, −0.481,
−0.434 against measured −0.634, −0.540, −0.480, −0.432 at α = 0.0618. Those
residuals are 25× larger than the 0.02–0.05 cusps they were meant to expose.
The sign was also misread: a negative residual means the model over-subtracts.
Separately, the test looked for a local maximum, and the prime term is a cusp
on a monotone background — the cusp sum increases across α ∈ [0.05, 0.3], so
`local max? False` was determined before any data were read.

**Two further defects.** The artifact's residual table does not reproduce from
its own F scan (p = 2: −1.2208 recomputed against −1.1888 reported; quadratic
interpolation of the artifact's own scan gives F(0.0618) = 1.6463 against a
direct 1.6470) — internally inconsistent by up to 0.033. And the 0.2-spaced
grid stepped over a real feature: `F − diag` humps to +0.0436 at α = 0.88,
about 9σ, settling to zero only near α ≈ 1.16, and it grows with height across
disjoint bands: +0.042, 0.050, 0.056, 0.060, 0.066.

**Error bars, which the artifact had none of.** Block bootstrap over 80–100
height bands, corroborated by a 24-realisation Poisson null at matched density
(sd 0.0047 against bootstrap 0.005): the 0.3816-vs-0.4008 gap is 4.1σ, the
0.5883-vs-0.6000 gap is 2.5σ, and the 0.744-vs-1.000 gap is 54σ and
meaningless.

**Carried hedges.** The α > 1 region discriminates nothing — a Poisson process
at matched density gives the same answer to |z| ≤ 0.7. And none of this is new:
Montgomery 1973 and Odlyzko's 10¹²–10²² computations cover all of it. The one
thing worth keeping is the decomposition, that F below α = 1 on 10⁵ zeros to
height 7.5e4 is the von Mangoldt sum recovered prime by prime at r = 0.996.

**Method.** The adversary retracted five of its own findings on self-attack,
including a prime-contribution estimate off by four orders of magnitude and a
Poisson-null sd off by 15×. Giving it the artifact — numbers, implementation,
and verdict verbatim — rather than a summary is what let it recompute instead
of arbitrate; the previous relay failure (entry 234's method note) was the
opposite case.

## 2026-08-28 — Entry 234 — the Montgomery correspondence, built as a case and broken on measurement
type: result-triage
refs: 40, 103, 230, 233

Julian's method, and it was faster: instead of my repeatedly saying
"that's a coincidence" and putting the burden on him, **construct the
strongest case FOR the connection, then break it.** Building the case
surfaced which link was load-bearing; it broke in twenty minutes on
measurement rather than on argument.

**The correspondence.** A cell `(r,d)` reads a window of `(d+1)·log b`
in `u = log x`; at the deep zero that is `7·log 2 = log 128`.
Montgomery's pair correlation holds for test functions with Fourier
support in `α ∈ (−1,1)`, and `α` enters through `T^(iα)`, so the
condition reads `|u| < log T` — matching at `T = 128`.

**The case I built:** both constraints are set by the zero-counting
function `N(T) ~ T log T/2π`, so they are two readings of one bound
rather than a coordinate identity. **Three of its four links fail.**

**The density link is decoration.** `∫t^(−α) log t dt` and
`∫t^(−α) dt` have the same threshold at `α = 1` — the `log T` does no
work, only the linear growth. "Forced by `N(T)`" is true in a sense
that cannot distinguish zeta's zeros from an arithmetic progression.
What survives is narrower and is about the mollifier, not the density:
`sinc(Wt)^(2K)` decays as `t^(−2K)`, its `u`-preimage is a B-spline of
order `2K`, and `K = 1` is exactly one derivative past an indicator.

**Montgomery's barrier is not a density statement.** It is
Montgomery–Vaughan's mean value theorem — a Dirichlet polynomial of
length `x = T^α` against integration range `T`, error
`O(x·Σ|aₙ|²)` versus main term `T·Σ|aₙ|²`. Length against range. And
past `α = 1` the claim is Goldston–Montgomery-equivalent to a
Hardy–Littlewood pair conjecture — a **second-moment** object that the
bench's first-moment `Σ|h(ρ)|` has no access to.

**"Conjugate" did no work.** The bench window in `u` is conjugate to
`γ`; Montgomery's `α·log T` is conjugate to `γ − γ'`. Different pairs,
and the two `log T`s are not the same `log T`.

**`T = 128` is a tautology, and the bench measures it.** Sweeping the
window `N = 1..40` — a 40× width change — the height at which the Weil
object stops seeing zeros **does not move**: `γ₉₉.₉ = 158.85` at every
width. What moves it is `W` and `K`, the mollifier, which is not part
of the correspondence. Width sets magnitude (8.9 → 1.7e18), never
height. At `N = 7` the actual height is ~159, not 128.

**My proposed test was worthless and instructively so.** I proposed
varying width against smoothness to see which knob each threshold
responds to. Both outcomes were settled before running: the bench's
width-indifference is a three-line bound, and Montgomery's side has no
smoothness knob — a support condition is a support condition. I
proposed it because the machinery was already in my context.

**What survives, and it is modest.** `7·log 2 = log 128` is the
**prime range** the stencil reads — O73's own log confirms it, support
`|log x| ≤ 5.05203`, 25 primes contributing, largest 151. Under
explicit-formula duality that is Montgomery's `x = T^α`, so `|α| < 1`
translates to "the integration height must exceed 128," satisfied at
`T = 939` with a factor-7 margin. **A comfortable margin, not a shared
barrier.**

**The Lean support I cited does not support it.**
`Zeros.window_exclusive_of_prime_exponent` is real and proved, and it
says `b^k = 2^7 → b = 2 ∧ k = 7`. That is a fact about the integer
factorisation of 128. It contains nothing about zeros or windows.

**The test that would settle it needs data the bench lacks.** Compute
`F(α,T)` on the zeros and look for the `p = 2` peak at
`α = log 2/log T` — the pair-correlation extension NOTEPAD entry 103
already flags as open. Run on `zeros600.json`: `F(0.101) = 0.72`,
`F(1.0) = 0.59`, no feature at `α = 1` or at 0.709, and `F` never
approaches its asymptotic `min(α,1)`. **At `T = 939` with 600 zeros the
statistic is not asymptotic** — that is the finding, and the cost of a
real test is the answer.

The adversary's instrument was the bench's own: it reproduced O73's
recorded spectral sum `2644.2585543549` to 14 digits before measuring
anything.

**Its own strongest counter, recorded:** the width-indifference is
indifference of the *mollified* object, and the mollifier carries all
the decay — so it may have measured that `sinc^(2K)` sets the height,
which was never in dispute, while the raw stencil's constraint is
invisible because raw it diverges at every width equally.

---

## 2026-08-27 — Entry 233 — both levers green, the gate was never 10³, and the paper propagation clears by 1.4%
type: formalization
refs: 118, 129, 230, 231, 232

**Lever 1 — the Dirichlet bound above the line. GREEN, and RH-free.**
`results/scratch_lean/slice5.lean`, no sorries, house axioms:

```text
norm_logDerivZeta_of_one_lt_re : 1 < s.re →
    ‖ζ'/ζ(s)‖ ≤ 2/(s.re−1) + 4/(s.re−1)²
norm_logDerivZeta_sigma0 : 1 ≤ L →
    ‖ζ'/ζ(1 + 1/L + it)‖ ≤ 2L + 4L²        (uniform in t)
```

Off Mathlib's `LSeries_vonMangoldt_eq_deriv_riemannZeta_div` by
`norm_tsum_le_tsum_norm` and an integral test — **no contour, no
zeros, no Jensen, no RH.** Entry 232 priced `I₁/I₉`'s borrowed
critical-line value as ~1500× too weak; measured, it replaces
**54136 with 453** at `L = 10.4`, and the `b(L)·M'` column falls from
1750 to ~7.

**Lever 2 — one of the four radii was never a constraint.** `r = 7/8`
was inherited from `zeta_local_zero_count`'s `7/4` window, and slices
3 and 4 never call that theorem — they call `ZerosBound` directly.
Freeing it, the optimum is `r = 181/200, R' = 29/32`: **FinalBound
6600 → 3991**, ZerosBound 15 → 29. The trade is real (`K_FB`
multiplies `L`, `K_ZB` multiplies `L²`) and at `L ≈ 10.4` the split is
87:13, so it wins. `r' = 3/4` is hard (forced by the `2z` rescale
reaching `σ₁ ≈ 1/2`); `R = 15/16` is hard as proved (`jensenF_bound`'s
reach); `R'` is free.

**The gate was never 10³.** Entry 231 measured `C = 10³` (depth 6) and
`C = 10⁴` (depth 5) and never resolved between them. Bisecting O68's
own `R_of` — imported, script untouched, EXPLORATORY, no prereg —
puts the `depth ≥ 6` boundary at **`C_π = 2640.5`**, with
`R(6) = 93` at 2640 and 94 at 2641 against a ceiling of
`O43_EXTENT + 1 = 93`. Recomputed independently: same to the decimal.

**Delivered, and the condition on it.** At the frontier bump
(`M = 1.0, M' = 3.4`) the propagation gives `C_ψ = 863.9`,
`C_π = 2604.6` — **clearing 2640.5 by 1.4%, with `R(6)` sitting
exactly on the ceiling rung. Zero rungs of margin.** At the plausible
bump (1.7, 7.0) it is 4426 and fails.

**What is kernel-checked and what is not, stated plainly.** Green in
Lean: every ζ'/ζ bound the route uses — critical line `|t| ≥ 2`,
compact patch `|t| ≤ 2`, the weld across both signs, the Dirichlet
bound above the line, and slice 8's endpoint drop. **On paper, in
`results/scratch_lean/constants.py`: all five integrals — `I₃₇`,
`I₂`, `I₈`, `I₁`, `I₉`.** So `C_π = 2604.6` is a propagation, not a
theorem. Route slices 5, 6, 7 remain unbuilt.

**Where the excess now sits.** `I₃₇` is 856 of the 864 `C_ψ`; within
it the `2 ≤ |t| ≤ X` tail is 91%, and within that the FinalBound term
is 87%. The whole constant is now one product: the Jensen constant
times `∫dt/|t|`. Structural floor: `16r²/(r−3/4)³ > 1024` for `r < 1`
while `K_ZB = 1/log(R/r) → ∞` as `r → R`, so the realizable minimum
over all `R < 1` is `K_FB ≈ 1950` — about 2× below where we sit. **The
Jensen architecture has no further order in it.**

**Re-proving `jensenF_bound` wider was priced and declined.** `R = 0.99`
gives `K_FB ≈ 2128` and a further ~1.5× (`C_π ≈ 1.75×10³`); the
re-proof is numeral-only (`1/Re w ≤ 50` not 8, pinch `28 → 175`,
`B = 84t → 525t`). Since the gate clears without it, it is margin
rather than requirement — and margin is exactly what 1.4% lacks.

**The one thing the clearance rests on.** `SmoothExistence` constructs
nothing, so `M ≤ 1.0` and `M' ≤ 3.4` are assumptions. One step up the
frontier and the constant fails. Constructing an explicit `ν` with
proved sup bounds is now the only thing between this chain and a
number.

Banked: `slice5.lean`, `slice3_opt.lean`, `slice4_opt.lean`,
`unified_opt.lean`, `unified_opt2.lean` (final, 0 errors, 0 sorries),
`constants.py` rewritten with the proved numerals.

**Found, not introduced:** `results/scratch_lean/slice4b_8.lean` as
banked does not compile standalone —
`PrimeNumberTheoremAnd.logDerivZeta_conj` unknown, and the
`variable`-hypothesis form does not elaborate. `unified.lean` carries
the working weld.

---

## 2026-08-27 — Entry 232 — the substitute chain assembles and the constant misses by one order
type: formalization
refs: 118, 129, 130, 230, 231

Julian: "you had a plan, see the plan through — if it doesn't make it
through that's data." The plan was eight slices; a costing step was
proposed instead and rejected as the same deferral pattern. Ran it.

**Green, all at `[propext, Classical.choice, Quot.sound]`, no sorries**,
banked to `results/scratch_lean/`:

```text
slice 1  holo_logDerivZeta_of_RH        RH ⟹ the pull's hypothesis is free
slice 2  mellin_flat_bound              ‖𝓜(ν)(w)‖ ≤ 3M on 0 < re w ≤ 2
         mellin_smooth1_flat            ‖𝓜(Smooth1 ν ε)(s)‖ ≤ 3M/‖s‖
slice 3  logDerivZeta_crude/_sq_at_X    ≤ 20000·(log X)², |t| ≥ 2
slice 4  logDerivZeta_compact           ≤ 25200 + 115/(σ₁−1/2), |t| ≤ 2
slice 4b logDerivZeta_line              both signs, |t| ≤ X, welds 3 and 4
slice 8  schoenfeldWeak_of_psiWeak_three  C_ψ at k=3 → (3C+13, 2)
```

**Slice 2 removed the `1/ε`**, which the costing had flagged as fatal:
it entered only because `MellinOfSmooth1b` routes through `MellinOfPsi`
at the point `εs`. **Slice 4's `σ₁ ≤ 3/4` hypothesis is load-bearing,
not cosmetic** — the entire-function trick puts an extra zero of the
local model at `re ρ = −1/2`, and the distance bound survives it only
below 3/4.

**Not built: 5, 6, 7.** Not conceptually blocked — every upstream
`I`-bound is stated `∃ C, …` against `LogDerivZetaHasBound` at
`σ₁ = 1 − A/log T⁹`, so none is reusable and each needs re-proving
against our line bound. No `sorry` shipped; they simply do not exist.
**And the route list omitted a slice:** `I₁`/`I₉` sit at
`σ₀ = 1 + 1/log X` where slice 2's flat `3M/‖s‖` makes `∫dt/t` diverge
— they need the `1/‖s‖²` form, an explicit re-proof of `MellinOfPsi`.

**The delivered constant, which is the point of the exercise.**
Green bounds plus the four unbuilt integrals done on paper
(`results/scratch_lean/constants.py`), at the π-floor `2³⁰` row that
entry 231's census actually tests:

```text
bump          M     M'     C_ψ      C_π = 3C_ψ + 13
optimistic   1.0   4.0    2328          6997
plausible    1.7   7.0    4008         12036
conservative 3.0  15.0    7734         23215
```

**C_π ≈ 7×10³ – 2×10⁴. Entry 231's gate closes between 10³ (depth 6)
and 10⁴ (depth 5). It misses by roughly 7× to 20×.**

That is the result and it is a good one: **one order of magnitude, not
three.** The exponent is right, the shape is right, the chain
assembles. What remains is shaving against a known target rather than
an open question about feasibility.

**Where the excess sits.** At `L = 10.40`, plausible bump: `I₃₇`
contributes 2256 of the 4008, `I₁+I₉` contributes 1750, everything
else under 1. And `I₁+I₉`'s 1750 is an artifact — they are forced to
borrow slice 3's critical-line bound at `σ₀ = 1 + 1/log X`, where the
truth is `∑Λ(n)n^(−σ₀) ≈ log X`, roughly **1500× too weak in the wrong
place.** One explicit Dirichlet-series bound above the line deletes it
outright, no new machinery, taking `C_π` to ≈6.8×10³ in a single step.

**A limit on how sharp any of this can get.** PNT+'s `SmoothExistence`
is pure existence — it never constructs a concrete bump, so `sup|ν|`
and `sup|ν'|` are pinned nowhere in the package. `C_π` is a function of
two free parameters, which is why the answer is a range and not a
numeral. Pinning a concrete `ν` is its own slice.

**Two upstream facts found by checking rather than reading.**
`MediumPNT.lean` has **zero** sorries — all five `I`-bounds and the
pull are clean. And `SmoothedChebyshevClose`'s constant is explicit
inside its proof and hidden by the `∃`: `C = 6(3c₁+c₂) = 30 log 2 ≈
20.8`. Recovering it is a restatement, not a re-proof.

---

## 2026-08-27 — Entry 231 — the cells entry 118 skipped: the exponent survives, the constant does not
type: run
refs: 118, 129, 130, 230

`O68_weak_bound_tolerance.py --extra`, EXPLORATORY. Entry 230 delivers a
ψ-side constant that lands between `C = 1000` and `C = 1e6` at `k = 2`
after entry 129's `C_π = 3C_ψ + 13` inflation — a range entry 118 never
measured. Measured now.

**Additive change, default verified unchanged.** `--extra`, `--out` and
`--no-json` added; `GRID` untouched. The default path re-run through
`utilities/run.py` reproduces the committed
`results/weak_bound_tolerance.json` on **all 6 rows** — every `R(d)` and
every `depth_covered` identical — and the O67 sanity gate still returns
True.

```text
   C = 1e3   k=2   log2(x0)=30   R(1)=64 .. R(8)=101   depth_covered = 6
   C = 1e4   k=2   log2(x0)=30   R(1)=72 .. R(8)=108   depth_covered = 5
   C = 1e5   k=2   log2(x0)=30   R(1)=80 .. R(8)=115   depth_covered = 3
   C = 1e6   k=2   log2(x0)=30   R(1)=87 .. R(8)=122   depth_covered = 2
```

**The gate is depth ≥ 6 (entry 118), so the budget closes between
`C = 1e3` and `C = 1e4`.** A factor of ten, and entry 230's assembly
lands on the wrong side of it.

**What this does and does not settle.** The exponent was the thing in
doubt and entry 230 cleared it: `k = 2` survives. The constant is now
the whole remaining gap, and it is a *measured* gap rather than an
argued one — the first time this route has had a number to close rather
than a difficulty to price.

Artifacts: `results/weak_bound_tolerance_extra.json`, log
`results/O68_weak_bound_tolerance_run2.log`, manifest under
`results/runs/`.

---

## 2026-08-27 — Entry 230 — slice 3: the docstring was a consensus price, and the log² shape was never attainable
type: formalization
refs: 116, 118, 129, 130, 158, 159

Julian rejected a concession. The hEF leaf's docstring reads "every
proof assistant lacks it; IEANTN targets it"; an agent read that,
declared the work impossible, and stopped. His objection: that sentence
is a consensus price formed before this repository existed, and the
pieces may already be here. He was right, and this is the second dated
instance of the same error — the 2026-08-24 session opened with
"formalizing Schoenfeld is out of scope, months minimum" and closed
with the Stirling half proved.

**Two grep errors preceded the finding, both the same shape.** A count
of `sorry` in `lean_stage3/Stage3/` returned 15 — every one the phrase
"sorry-free" in a docstring. Stage3 has **zero** actual sorries, 77
theorems, with its open surface stated as named `Stmt*` Props rather
than holes. The state was read from prose twice before being read from
the files.

**What the re-pricing found.** The docstring conflates the explicit
formula with the contour machinery. The machinery is done and
sorry-free upstream — `SmoothedChebyshevPull1`, `ZetaBoxEval`,
`SmoothedChebyshevClose`, `I1Bound`…`I9Bound`, `FinalBound`, all at
`[propext, Classical.choice, Quot.sound]`. And
`SmoothedChebyshevPull1`'s only zeta-side hypothesis is holomorphy of
`ζ'/ζ` on the box, **which under RH is free for any `σ₁ > 1/2`** — RH
puts every zero on the line, so the contour stops at
`1/2 + 1/log X` and never walks past one. The zero sum never appears.
Twenty lines, green: `holo_logDerivZeta_of_RH`.

So hEF exists in the ledger to survive a walk that RH makes
unnecessary. `StmtExplicitFormula` as literally written stays NO-GO —
no contour pull across the strip collecting zero residues exists
anywhere, and `Kadiri.hadamard_identity` is sorried — but the consumer
is `StmtPsiWeak`, and a substitute delivers it from RH alone.

**Slice 3, the falsifier, is green.** Three theorems, no sorries, house
axiom baseline, in `results/scratch_lean/slice3.lean`:

```text
logDerivZeta_crude    ‖ζ'/ζ(σ₁+it)‖ ≤ 3300·log(84t) + (15 log t + 73)/(σ₁−1/2)
logDerivZeta_sq_at_X  at σ₁ = 1/2 + 1/log X, 2 ≤ t ≤ X:  ≤ 20000·(log X)²
logDerivZeta_sq_at_t  at σ₁ = 1/2 + 1/log t:             ≤ 40000·(log t)²
```

**The literal target was false and no formalization could have
delivered it.** `‖ζ'/ζ‖ ≤ C·log²|t|` at fixed numeral `C` fails at any
`t` equal to an ordinate of a zero: `ζ'/ζ` has a simple pole there, so
the left side grows like `1/δ = log X` while the right side is fixed.
What is deliverable is the product `log X · log t`, which on the
consumer's range — fixed vertical line, `2 ≤ t ≤ X` — **is exponent
2.** The route lives.

**Why the radii squeeze does not bite, which is the load-bearing
detail.** It *does* bite upstream's `LogDerivZetaFinalBound`, centred
at `3/2 + it`: reaching `σ₁` needs `r' → 1` and `16r²/(r−r')³` blows
up. Stage3's `jensenF`'s `2z` rescale puts `σ₁ ≈ 1/2` at
`Re z ≈ −3/4`, so `r' = 3/4` suffices **independent of X**. Every
radius is a fixed numeral: `r = 7/8` is exactly
`zeta_local_zero_count`'s `7/4` window, `R = 15/16` is exactly
`jensenF_bound`'s reach. **This is the tangency repair paid for at
entries 158/159, and it is what makes the substitute possible.**

**Architecture consequence, Julian's to decide.** The substitute
retires hNT from the ψ path — no zero sum means no zero count — so
`{hRH, hEF, hNT}` collapses to `{hRH, StmtLogDerivRH}`. The
Stirling/Arg work stands on its own but stops being load-bearing for
Schoenfeld.

**And it does not weld Superposition.**
`Superposition.tableFrom_eq_modeSum_reweighted`'s hypothesis is an
*exact* identity at every integer over a finite Finset. A truncated
formula with a remainder cannot discharge it, and no version of hEF
could. That weld is a separate problem.

Banked out of session tmp to `results/scratch_lean/` — an earlier
35-line `hgap` proof was lost exactly that way today. Reading is entry
231.

---

## 2026-08-27 — Entry 229 — a gate on the cheap step, and the honest half that cannot have one
type: instrument-fix
refs: 219, 222, 225, 228

Julian asked whether the session's errors came from avoiding difficulty
on a hard problem. The record says the opposite, and this instrument
follows from the correct reading.

**Where the errors actually sat.** Not on the hard parts — the CRT
collapse, the studentization choice, `NyquistPeak`'s vacuity guard all
went well or better than specified. They sat on the trivial ones:
reading a max off a 17-row JSON, dividing two numbers, a regex whose
`\b` matched a subscript, writing `§` in prose five times, the `d+1`
exponent. **Difficulty is what summons care**; a cheap step summons
none and fails at the same rate.

**Which means "try harder" does nothing** — those steps do not route
anywhere that effort applies. Two cheap steps that were gated cost
nothing all session: the `§` citations broke five times and
`check_refs` caught each instantly, and the `d+1` exponent would have
measured six wrong cells under the four zeros' names but the brief said
*derive it and stop if you disagree*. The ones that hurt were cheap
steps with no gate.

**Built: a slice warning at the invocation layer.**
`utilities/hooks/check_direct_run.py` already parses the Bash payload;
it now also warns when a command reads a `results/` artifact **and**
slices it. Advisory, exit 0, never blocks.

Verified in five directions: fires on entry 219's actual defect; silent
on a results read with no slice; silent on a slice with no results
artifact; still blocks a direct O-script run; still passes `run.py`
through.

**It deliberately does not detect the aggregation.** Both instances —
entry 219's 6-of-17 and entry 222's ratio — sliced, printed, and then
aggregated **by eye on the printed subset**. There is no `max(` in
either command, so a narrower trigger would have missed both. The
trigger is "a results artifact was read and sliced," which does fire on
legitimate display-slicing. That is the accepted cost, stated rather
than discovered.

**Unscored, and it self-scores.** Entry 225's audit declined to ship
this exact check because no corpus of past invocations exists to score
it against — the container's rule is score-then-adopt. Two things make
it shippable anyway: it is advisory, so a false positive costs one line
of stderr rather than a blocked commit or a baseline file; and it
appends what it sees to `utilities/slice_observations.jsonl`
(gitignored, local), so the corpus that would score it accumulates from
here. **Score it later and either tighten it or delete it.**

**The half that cannot be gated, said plainly.** The other ungated
cheap step was entry 219's "roughly 2^52" — an extrapolation from two
*nested* points with no interval stated. That lives in prose in the
record, and entry 225 established the selection rule: gates scanning
**mutable** state can ship, gates scanning the **append-only record**
can never be silent when clean, because a true positive in a historical
entry fires forever and the entry cannot be edited to fix it. So there
is no gate for it. What there is instead is the requirement now in
`lean/NEXT.md` and the container blueprint — an extrapolation names its
points, their independence, its model, and its interval — which is a
rule that must be read, and therefore will sometimes fail. That is the
honest boundary of this approach and it is worth having written down.

---

## 2026-08-27 — Entry 228 — accuracy came from deleting a claim, not from verifying one
type: provenance
refs: 225, 227

Entry 227 flagged that the Stage-3 rules list `pow_le_pow_left₀` among
"v4.32 renames encountered" while the unsubscripted form does not exist
on the bench's v4.28. Julian approved an edit. What the edit turned out
to require is the entry.

**Measured, by the instrument that settles it** (`#check @name` on each
toolchain, not source-grepping):

```text
all eight documented names          resolve on BOTH v4.28 and v4.32
pow_le_pow_left (unsubscripted)     resolves on NEITHER
when each became canonical          NOT ESTABLISHED
```

**The edit removes the dating claim rather than repairing it**, and
states only the two measured facts plus an explicit note that the
timing is unestablished. Applied to the project rules' Stage-3
formalization section with Julian's approval; gates green.

**Why this took four attempts, which is the point.** The obstacle was
never the difficulty of the question:

1. Proposed replacement wording — "some predate v4.32" — generalised
   from **one** verified case out of eight.
2. Then argued to LEAVE the known-imprecise line because dating it
   "could not be done cheaply." That framing was wrong: the accurate
   version needed no dating at all.
3. Then source-grepped the vendored Mathlib for deprecation aliases
   with a pattern whose `\b` matches `pow_le_pow_left₀` when searching
   `pow_le_pow_left`, and reported "old form present" for a name Lean
   says does not resolve. **A third plausible-instead-of-authoritative
   move, inside a conversation about accuracy.**
4. Julian: "what is the problem? why can't things be accurate?"

**The generalisable rule.** When a claim has an unverified component,
the reflex is to go verify it. The cheaper and more often correct move
is to ask whether the claim needs that component at all. Here the
dating did no operational work — an agent reading the line needs to
know which name to type, not when it was renamed — so deleting it
produced a line that is fully accurate, still warns, and gained a
concrete trap the original lacked (`pow_le_pow_left` resolving on
neither).

**And the authoritative instrument existed the whole time.** `#check`
in Lean is definitive about whether a name resolves. Every wrong step
above substituted inference for it — including two source-greps whose
patterns asked a narrower question than the one being answered — the
project rule about asking the right question, for the third and fourth
time in one session.

**A fifth, immediately.** Writing this entry, both citations of the
project rules by section name parsed as broken references and the hook
blocked the commit. The gate caught in seconds what four rounds of
reasoning did not.

---

## 2026-08-27 — Entry 227 — NyquistPeak: the boundary is a global stationary maximum, and the abs was not cosmetic
type: formalization
refs: 223, 224, 225

`lean/NyquistPeak.lean`, 20 theorems, 20 pins, all at the house
baseline `[propext, Classical.choice, Quot.sound]`. Bench now **24
modules, 282 theorems, 282 pins, 8050 jobs**. This is NEXT.md § 5.1,
the item entry 225's adversary ranked first after breaking three of the
four candidates.

**What it proves.** The γ₁ gain of the depth-`d` difference filter is
**derived** from `Chain.Sym` rather than restated —
`norm_sym_on_imaginary_axis` gives `‖Sym b (γ·I)‖ = 2|sin(γ log b / 2)|`
and `gain_eq_norm_sym_pow` connects it to the prereg's own form. Then
both halves: `gain_hasDerivAt_pi` (the derivative vanishes at `θ = π`)
and `gain_le_gain_pi` (**global** maximum, not merely local), with
`gain_lt_gain_pi` strict away from the peak.

**In the bench's coordinate.** `nyquist_boundaryBase` proves
`Nyquist.nyquist (exp(π/γ)) = γ` — `b*` is exactly the base whose
Nyquist frequency is `γ`, so it is precisely the cap
`Nyquist.base_bound_of_resolvable` produces. Then
`gain_stationary_in_base`, `gain_continuousAt_boundaryBase` — the
literal "not a discontinuity" — and
`boundary_is_smooth_stationary_maximum` as one object.

**What it discharges.** Entry 224 argued the `no_step` mechanical
output of the LOCKED `dense_boundary_scan_v1_20260827` was predictable
because everything is continuous at `b*` and the gain is stationary
there. That argument was prose. Its load-bearing half is now
kernel-checked, and it was written as a derivation rather than aimed at
the measured number — NEXT.md's non-negotiable method rule.

**The vacuity guard, which was needed.** `gain_hasDerivAt_pi` holds at
**every** depth including `d = 0`, where it says nothing: `gain 0` is
the constant 1, so every phase is stationary and maximal.
`depth_zero_vacuous` proves that in `Chain.period_vacuous_at_one`'s
shape, and the module docstring records that `#guard_msgs` cannot catch
vacuity. `results/dense_boundary_scan.json` `params.d_min = 1`, so the
measured regime is the guarded one. `0 < b` and `γ ≠ 0` are
load-bearing — their failure makes the statements **false, not empty**.
`b ≠ 1` turned out unnecessary; `b* > 1` follows for `γ > 0`.

**The linter caught a decoration hypothesis** — `hd` sat unused on the
headline theorem. Fixed by strengthening the statement (adding the
strict-maximum conjunct) rather than dropping the hypothesis, so `hd`
is now load-bearing.

**§ 5.1 and the prereg both drop an absolute value, and it is not
cosmetic.** `|Sym|` forces `|sin|`. Unbarred, `(2 sin(θ/2))^d` goes
negative on `(2π, 4π)` and stops being a modulus — the maximum would be
**local only**. With the abs it is global. The cost: at depth 1 the
gain has a **corner** at `θ ≡ 0 (mod 2π)`, where it is not
differentiable at all. So "smooth at `θ = π`" is exactly the right
hedge and the prereg's localised wording is correct; a claim that the
gain is smooth everywhere would be false.

**Which line, stated so the two are not conflated.** The formula is
`|Sym|` on `Re s = 0`, not on the critical line where `Chain`'s block D
lives — there the gain is `1 − 2b^(−1/2)cos θ + b^(−1)`, band
`1 ± b^(−1/2)`, also peaking at `θ = π` but not equal to
`(2|sin(θ/2)|)^d`. Same symbol, same phase condition, different line,
which is why `b*` here and `Chain.ceiling_base`'s `k = 0` base are the
same number.

**Placement.** A new module rather than `Nyquist.lean`, because the
content needs `Chain.Sym` and putting it in `Nyquist` would force that
module to import `Chain` and change a build graph the brief protected.
Named in `lakefile.toml`'s explicit `globs`.

**Correction to a documented convention.** The root project rules, in
their Stage-3 formalization section, list `pow_le_pow_left₀` among the
"v4.32 renames encountered". On the bench's
own v4.28 Mathlib, `pow_le_pow_left` and `pow_lt_pow_left` do **not**
exist — only the `₀` forms. The `₀` names predate v4.32 here.
`CLAUDE.md` untouched; this is flagged for Julian.

**Pre-existing, found not caused:** `theorem_index.py` warns of stale
roles `Zeros.stencil_add`, `Zeros.stencil_smul`,
`Zeros.stencil_annihilates_const` — those moved to `ZerosStencil` at
`279e40b` and `theorem_roles.txt` still files them under `Zeros`.

Gates: `lake build` 8050 jobs; parity 282/282 across 24 modules, no
existing pin moved; `check_refs` 0; `check_values` 141/0;
`theorem_index` 0 UNTAGGED (14 new tagged `support`, 6 `record`).

---

## 2026-08-27 — Entry 226 — correction to entry 224: the r_thick split holds at three of seven, and the 2^(1/3) anomaly is cleaner for it
type: result-triage
refs: 223, 224, 225

**The claim.** Entry 224 states `r_thick` is "discontinuous exactly at
`2^(1/m)`, neighbours splitting 6/6 by side at every divisor tested
down to width/2048," and uses it to explain why arm 2 normalises per
base where arm 1 holds a constant denominator.

**It is false, and O96's own output says so** — read from
`results/dense_boundary_scan.json`, `summary.arm2[].neighbours`, with
no re-run:

```text
 m   2^(1/m)   below | above          clean 6/6?
 2      1653   [1596] | [1653]           YES
 3      3486   [3486] | [3486]           no
 4      5886   [5886, 6105] | [5886]     no  (below inhomogeneous)
 5      9045   [9045] | [9045]           no
 6     12720   [12880] | [12720]         YES
 7     17391   [17205] | [17391]         YES
 8     22366   [22366] | [22366]         no
```

**Three of seven, not every divisor.**

**And the correction runs in the finding's favour.** At `m = 3` — the
base carrying the whole live result — the denominator is **constant at
3486 across all twelve neighbours**. Entry 224's stated reason for arm
2's per-base normalisation does not apply where the anomaly lives, so
`ζ = 0.00086` sits against twelve neighbours at an identical
denominator with **no normalisation confound at all**. The 2^(1/3)
reading is cleaner than entry 224 presented it, not dirtier.

**How it was found, and the trap it walked into.** Entry 225's
adversary reimplemented the geometry rather than calling O96 and got a
table agreeing with O96 at `m = 2, 3, 5, 6, 8` while swapping which of
`m = 4, 7` carries the inhomogeneous side — precisely the one-ulp
hazard entry 223 documents ("which way the rounding falls is set by the
rounding of `2^(1/m)` itself"). It flagged its own result as the more
likely error. **It was right on the load-bearing point and wrong in the
details**, and the instrument's own artifact settled both.

**The method note.** No measurement was needed. The answer was already
in the run's output, which is the same rule as entry 218's
git-before-mitigation: before running something to settle a question,
check whether the artifact you already have answers it.

---

## 2026-08-27 — Entry 225 — adversarial audit of the Lean scoping list: three of four candidates broken
type: result-triage
refs: 208, 211, 222, 224

A survey of this session's runs proposed four theorem-shaped results
for formalisation, ranked. An adversary tested each **by compiling
it**, and broke three.

**Candidate 1 — periodogram periodicity — dead twice.** It is already
in the tree: `Chain.gain_sq_periodic` (`lean/Chain.lean`:429) pins
exactly that periodicity, with `joint_gain_periodic_of_commensurate`
as the joint form. And it is **false of the pipeline** —
`O95_multibase_synthesis.py`'s `block_geometry` uses
`log(floor(exp(i·s)))`, not `j·h + c`, so the exact-ladder statement
describes something the bench does not compute. The floor-jitter story
attached to it fails on magnitude: the naive scale is ~2e−4 and
essentially arm-independent, against observed leakage spanning
1.0e−7 to 5.7e−4 with an odd/even split the story does not predict.
**A number was matched to a narrative.** What would be new is the
approximate form with an explicit `ε_j ≤ 1/x_j` bound — that would give
entry 213's `X = 0.10` criterion its four-order margin as a theorem
rather than as a measurement.

**Candidate 2 — mis-stated in three ways.** It is not CRT but Bezout,
the dual: `(1/j₁)ℤ ∩ (1/j₂)ℤ = ℤ` for coprime indices. There is no γ₁
and no 8 in the mathematics — the 8 is `2π/s`, so pinning
`ν ≡ ±1 (mod 8)` pins the units. Entry 217 already states the general
form correctly. And the `±` is **not expressible in
`Nyquist.Aliases`**: it comes from `P(−γ) = P(γ)` for real weights, so
candidate 2 depends on candidate 1's statistic-level definition rather
than standing beside it. It also carries a vacuity trap at `s = 0`, the
shape `Chain.period_vacuous_at_one` already documents.

**Candidate 3 — `by ring`, and the wrong statement was named.** Entry
208's load-bearing content is the base change: `F[2r] = 2^r` exactly,
which makes the telescoping `N₂(r) = n_{2r−1} + n_{2r}` true for all
`r` rather than the 32 the run checked. That upgrade is worth pinning;
the polynomial identity certifies nothing about the two cells.

**Candidate 4 — deferred for a false reason.** It was ranked last as
costing `Classical.choice`; **all five theorems in `lean/Nyquist.lean`
already carry it**, as does `Chain.gain_sq_periodic`. House baseline,
not a cost. It compiles in ~26 lines, and it is the only one of the
four discharging a mechanism claim a **locked prereg** leaned on —
entry 224's stationary-maximum argument behind arm 1's `no_step`.

**What the survey missed, and it is the larger half.** Four vacuity
results this session share one shape — a statistic factoring through a
quantity constant across the hypotheses being compared — and each
retired or rescoped an instrument: entry 197's scale-invariance, 194's
coherence-at-a-zero, 205's phase decomposition, 217's flat combs. Two
compile in under five lines. Also missed: the plateau-width law
`hw = b*π²/(γ₁²·ln V)`, verified against the locked prereg at relative
error 3.1e−5, which says arm 1's constant-denominator trick shrinks as
`1/ln V` and does not scale; and entry 209's `T ≤ 1/2`.

**A correction to entry 222, independent of any Lean work.** That entry
reports `Neff ∝ N^0.86` at `r² ≥ 0.9992`. It is **not a power law** —
the bare envelope reproduces the fit, but the local slope falls
monotonically and is still falling at `N = 10⁷`, while
`Neff/(N^(2/3) log N)` drifts toward a constant. From
`p_k ∝ log k / k`, `⟨log k⟩ = (2/3) log N`, so
`Neff = Θ(N^(2/3) log N)`. An `r²` of 0.9992 is what a slowly-curving
function looks like over a factor-of-24 window. **Entry 222's
conclusion survives; its exponent does not.**

**The revised list**, taking the adversary's own closing argument —
`lean/NEXT.md` says write the mechanism, do not aim a proof at a
measured number, and by that standard theorems certifying retired
instruments rank below one explaining a live design:

1. candidate 4 — cheap, discharges a locked prereg's mechanism
2. candidate 3 restated as the base-change telescoping
3. candidate 2 restated base-free, `s ≠ 0` load-bearing, welded to
   `P_neg` for the `±`
4. candidate 1 only in its `ε`-bounded form, if at all

---

## 2026-08-27 — Entry 224 — the boundary is not a feature of the zeros, and the 2^(1/3) anomaly survives all three of its explanations
type: result-triage
refs: 199, 211, 215, 223

Reading of entry 223. **The verdict line is Julian's and is empty.**

**Arm 1 delivered the null it preregistered.** `D = −0.009950`, primary
rank `p = 0.769`, mechanical output `no_step`. Entry 199's open line —
does exact-zero density step at the Nyquist boundary — is now closed by
measurement rather than by the structural argument that opened it.

Read against its stated ceiling: the design is **not powered under
±50%** (0.227 at ρ = 0.5, 0.237 at 1.5), and is sensitive to roughly a
factor of two. So `no_step` says the boundary is not a feature of
exact-zero density **to a factor of two**, which is the claim the
prereg licensed and no more.

**The mechanism argument was right and is now measured.** The
difference filter's response to γ₁ is `(2 sin(θ/2))^d`, whose
θ-derivative vanishes at `θ = π` — `b*` is a smooth stationary maximum
of the γ₁ gain, not a discontinuity. Every ingredient is continuous
there. The measurement agrees with the algebra.

**Arm 2 is the live finding: all three explanations fail.**

```text
 m       b_m    theta  z/cell   nbr mean  rank    sd dev
 2  1.4142136  280.68  0.00665   0.00534  13/13   +2.49
 3  1.2599210  187.12  0.00086   0.00146   1/13   −1.05
 4  1.1892071  140.34  0.00119   0.00217   1/13   −1.18
 5  1.1486984  112.27  0.00199   0.00181   9/13   +0.71
 6  1.1224620   93.56  0.00220   0.00204  12/13   +0.93
 7  1.1040895   80.19  0.00155   0.00142  12/13   +0.72
 8  1.0905077   70.17  0.00139   0.00119  11/13   +0.96
```

*Nyquist* predicts `m = 2` and `m = 3` low. `m = 3` is lowest of its
13 — and **`m = 2` is the highest of its 13, at +2.49 sd.** The aliased
pair splits. *Integer-root arithmetic* predicts all seven low; five of
seven read high. *Ceiling attainment* is broken by construction at the
generic `V`, and `2^(1/3)` still reads 0.00086 against O45's 0.00084 at
`2^32` — **removing the explanation did not remove the anomaly.**

The one base below its neighbours that Nyquist cannot claim is
`m = 4` at `θ = 140.3°`, comfortably resolvable. Two of seven below the
median is `p = 0.227` one-sided, so this is a signature reading at
`n = 7`, not a test — but the anomaly entry 199 flagged at `n = 1` is
now `n = 2` and has outlived every account offered for it.

**A new arithmetic signature, unlooked-for.** `r_thick` is
discontinuous exactly at `2^(1/m)`, neighbours splitting 6/6 by side at
every divisor tested down to width/2048. That is why arm 2 cannot hold
a constant denominator the way arm 1 does, and it is a property of the
integer-root bases nothing in the tree had recorded.

**Three framings of mine that measurement corrected.** Matching
placebos in μ is closed by arithmetic — requiring `b*`'s exact
`(99,12,3828)` leaves 17 candidates, several inside the window itself,
so ≥80 realisations are impossible. The sd variation I read as a μ
effect tracks location and is not significant (`F = 1.80` against a
critical 3.7). And self-normalising by the rotation spread **destroys
the power** — 0.139 at `ρ = 2` against the ratio statistic's 0.580,
because a real step inflates the very spread meant to detect it.

---

## 2026-08-27 — Entry 223 — O96: the dense boundary scan, and the first prereg with an executable decision rule
type: run
refs: 199, 211, 220

`O96_dense_boundary_scan.py` under
`preregs/dense_boundary_scan_v1_20260827.md`, sha256
`01f58ca12c7dd8f14f2d7fca6ca8be828c728a8e86b5146c68de7b5d7e435a3e`.

**Entry 220's rule worked on its first use.** Locked → sidecar cut →
**committed `0da19b5`, prereg and sidecar only** → then run.
`utilities/check_sidecar.py` exits 0 and resolves this prereg *via git
as-committed `0da19b51`* — the recovery route that exists only because
the text was committed before the run. The convention that four
preregs lost their pre-image for is now demonstrated.

**The decision rule is a predicate table in the script, with an
exactly-one-fires assertion.** First prereg under that convention.
It held on both runs, and the assertion is **reachable**: a self-test
at placebo centre 1.2900 read `(99, 10, 4851, 4005)`, tripped the
plateau gate, and fired exactly one label — `compromised`. So the
integrity branch is not decorative. The partition-failure path is
implemented and was never exercised.

**Gates.** Kernel reproduces O45 exactly on five checks: base 2 at
`2^32` (496 cells, the four zeros, masses 2/4/88/492384);
`exp(π·2/(2γ₁))` and `exp(π·5/(4γ₁))` row-for-row; `2^(1/2)` and
`2^(1/3)` via exact integer roots. Plateau-constancy gate PASS — all 26
grid bases read `(99, 12, 4851, 3828)`, `b*` sitting 7.79e−06 from the
plateau centre at `V = exp(99.5·log b*) = 4.021540e9`.

**The instrument trap is broader than the design note said**, and
partly different. At `V = 2^32`, mpmath loses the top rung at
`m = 2, 5, 7` only; at **`m = 3` both routes agree** (96 either way),
contradicting the note's "95 vs 96"; and at `m = 4, 6, 8` the top rung
agrees while **32 / 31 / 32 interior rungs disagree** — the rungs with
`m | r`. Which way the rounding falls is set by the rounding of
`2^(1/m)` itself.

**Statistic and null.** `D = (Z_above − Z_below)/(Z_above + Z_below)`,
studentised by ratio — chosen by measurement over the sqrt form, which
assumes Poisson and over-corrects: thinning every placebo window to
half its counts moved the raw statistic −46.6%, the sqrt form −24.0%,
and the ratio **+8.5%**, in the conservative direction. Null: 116
locked placebo windows, all evaluated. Placebo `D` mean **+0.0255**,
sd 0.1567 — **not centred at zero**, which is the reason the null had
to be empirical.

**Power, measured before locking** and reproducible under
`--power-check`: 0.922 / 0.227 / 0.049 / **0.034** / 0.080 / 0.237 /
0.580 / 0.927 at `ρ` = 0.25 … 3.0. Calibration 0.034 against a nominal
0.05, conservative by construction at `N = 116`.

**Mechanical output: `no_step`.** `D = −0.009950`, `p = 0.769` primary,
0.846 on the labelled secondary rotation null. Run record filled;
**verdict line left empty for Julian.**

**One locked-text discrepancy, disclosed rather than corrected.** The
prereg quotes the placebo median of `D` as +0.0309 (even-`n` average of
the two middle values); the script prints +0.0332 (upper middle, which
is what the rule's side-selection uses). Descriptive only, and
side-selection never ran because `p > α`. A locked prereg is immutable
except for its Run record, so it stands as written and the Run record
says so. Reading is entry 224.

---

## 2026-08-27 — Entry 222 — Neff(N) triage: 172 is truncation-bound, the conclusion is not, and entry 197's ratio argument was wrong
type: result-triage
refs: 194, 196, 197, 221

Reading of entry 221. EXPLORATORY. This closes entry 197's stated open
caveat.

**Shape 3: sublinear and unbounded, at all 22 combinations.** Nothing
saturates and nothing is linear. `Neff ∝ N^b` with `b` between 0.766
and 0.879, `r² ≥ 0.9992` everywhere; at `(20,6)` `b = 0.8597` (ψ) and
0.8587 (π). `Neff(600)/Neff(300)` runs 1.76–1.81 against 2.00 for
linear and 1.00 for saturating. `Neff/N` falls monotonically from 0.464
at `N = 25` to 0.287 at 600.

**So entry 197's headline is a statement at one truncation.** `Neff =
172.0` sits on a curve still rising 16% over its last 100 modes.
`Neff/600 = 0.287` is equally N-dependent. **No ensemble figure follows
from either number**, and entry 197 should be read as "172 at
`N = 600`".

**The conclusion it was drawn for survives, for a reason independent of
N.** Entry 197 argued a localized reading — a table zero being one zeta
mode — needs `Neff` of order 1. At **every** N measured, `Neff` is a
large fraction of N: 11.6 of 25 at the smallest truncation. The number
is truncation-bound; the order-of-magnitude statement is not.

**Correction to entry 197.** That entry wrote "the ratio 1.057 is the
safer figure, since both cells are truncated identically." **The
reasoning is wrong.** The ratio moves 23.2% (ψ) / 24.9% (π) across the
range and **changes sign** — 0.8595 at `N = 25`, 0.9438 at 100, 1.0025
at 200, crossing 1.0 near `N ≈ 193` (ψ) and 170 (π). **Below that
crossing the non-zero control has the higher Neff, reversing entry
197's direction claim.** Identical truncation does not make a ratio
N-independent, because the two cells' level factors converge at
different rates.

What is true is narrower and had to be measured: the ratio **plateaus**
for `N ≥ 400`, span 0.93% (ψ) / 1.05% (π), log-log slope −0.006. So
1.057 is a plateau value established by measurement, not a quantity
protected by a symmetry argument. One depth down, `(8,3)/(7,3)` is
non-monotone — 1.225 at N=25, dipping to 1.024 at 100, 1.087 at 600 —
and is not settled.

**The analytic level law was confirmed and its N-independence was
not.** Predicted `Neff = e^(−D)·Neff_env(N)` with `D` constant in N;
the `ψ|z|` column is the exact test, since there the modulation is
`B^(d+1)` alone and `D` is computable. Analytic `e^(−D)` = 0.7701 /
0.5983 / 0.4728 at `d = 1/3/6` against measured `κ(600)` = 0.7689 /
0.6140 / 0.4881 — `d = 1` converged to −0.16%, `d = 3` and `d = 6`
still 2.6% and 3.2% high and falling ~0.6% per 100 modes. The
mechanism is named: `D_N` is a finite-sample estimate of `E[w log w]`,
biased low, so `κ_N` approaches its asymptote from above, and wider `W`
at greater depth converges slower.

**Both cells of the headline pair are phase-flat outliers.**
`Neff(|c|)/Neff(|z|)` at `N = 600` is 0.979 at `(20,6)` and 0.927 at
`(19,6)`, against 0.8653 for an equidistributed phase and ~0.855 for
the depth-6 median. **The whole 1.057 lives in the difference between
two atypical samples**, which is worth knowing before anyone builds on
it. Seen a second way: `(19,6)` carries the lowest growth exponent in
the table (0.777) and `(20,6)` among the highest (0.860).

---

## 2026-08-27 — Entry 221 — O91 `--vs-n`: Neff against truncation, with the prediction written first
type: run
refs: 192, 196, 197

`O91_mode_entropy.py --vs-n`, EXPLORATORY. Closes the caveat entry 197
recorded as owed.

```text
.venv/bin/python utilities/run.py --python .venv/bin/python \
    --log results/O91_mode_entropy_vs_N_run1.log O91_mode_entropy.py --vs-n
exit 0   created 2   modified 0   git HEAD 5e698da (dirty)
manifest results/runs/20260827T193317Z_O91_mode_entropy.json
results/mode_entropy_vs_N.json   sha256 d66b7ebd…
```

**The prediction, written into the docstring before the run.** With
`p_k ∝ W_k/|ρ_k|` — a stationary modulation on a `1/γ_k` envelope — and
`γ_k ~ 2πk/log(k/2πe)`, the envelope's local slope is `s(k) = 1 −
1/log(k/2πe)`, below 1 at every finite k (0.688 over k = 25..50, 0.793
over 300..600). For `p_k ∝ k^(−s)` with `s < 1`, `Neff` grows linearly;
at `s = 1`, as `√N log N`. **Predicted: sublinear and unbounded, power
fit ≈ 0.87 over 25..600.** Measured 0.8597. Held.

**Gates.** Six-value kernel check two-sided: `Δ^(d+1)` reproduces 6 of
6, `Δ^d` reproduces 0 of 6. **PASS.**

**Default behaviour byte-identical.** The default path re-run to a
scratch output and compared leaf-wise against
`results/mode_entropy.json`: **3313 of 3318 leaves identical**, no key
added or missing. The five differing are `generated_utc`,
`run_start_at`, `run_end_at`, `params.out` (the redirect), and
`params.code_version` — the last unavoidable, being the sha of the
edited file. Every measured number is bit-identical.
`results/mode_entropy.json` (`fcae817e…`) and
`results/mode_coherence.json` (`0dcc0a3c…`) unchanged; run.py reports
`modified 0`.

**An unplanned self-gate:** every curve's `N = 600` endpoint reproduces
entry 196's published table exactly — 172.045 / 175.667 / 172.243 /
162.788 / 157.359 / 197.909 / 182.101.

**Precision:** the headline curve recomputed at dps 80 from an
independently built mode set — max relative disagreement **0.00e+00
over all 600 values of N**.

Reading is entry 222.

---

## 2026-08-27 — Entry 220 — the sidecar reconstruct-or-retire pass: five recovered, four gone, and the rule that caused it
type: instrument-fix
refs: 211, 213, 218

The audit behind entry 219 found that **no sidecar in `preregs/`
matches its own prereg on disk**, and that this was unfalsifiable in
both directions — nothing recorded how to recover the locked text, so
drift could be neither confirmed nor detected. This is the pass.

**The cause is a conflict inside `preregs/FORMAT.md` itself.** It calls
the sidecar "the authority" and "the thing that pins the text," and it
also mandates filling the Run record after the run. The second mutates
what the first pins. Neither rule is wrong; together they are
unsatisfiable unless the locked text is committed before the run, and
FORMAT.md never said so.

**Recovery, searched exhaustively.** Four routes tried per prereg: the
file as-is; the file truncated immediately before its `## Run record`
heading; every blob of the file in git history; every such blob
truncated the same way. Additionally, every prefix of the current text
ending at any heading or line boundary was brute-forced.

```text
VERIFIED 5 of 9
  alpha_depth_trend_v1_locked_20260814      stripped
  extended_zero_census_v1_locked_20260818   stripped
  sub_integer_base_scan_v1_20260818         stripped
  zero_winding_phase_v1_locked_20260818     stripped
  multibase_synthesis_v1_20260827           git as-committed cc74c3cd

UNRECOVERABLE 4
  character_sweep_q11_q13_v1_20260826       3 revs searched
  dh_aggregate_spectrum_v1_20260825         3 revs searched
  dh_coalition_spectrum_v1_20260825         2 revs searched
  small_angle_cross_base_v1_20260821        4 revs searched
```

**`alpha_depth_trend` states the recovery in its own Run record** — the
append "is expected to change the file's hash," and the
`post_compute_sha256` it records *is* the sidecar value, "both taken
before this section existed." The procedure was written down inside one
prereg and never promoted to the spec.

**`multibase_synthesis` is the only one recoverable through git**, and
only because it was locked and committed before its run — which was an
accident of sequencing, not a rule. It is now the rule.

**What the four cost, stated plainly.** Their sidecars' specific
promise — that no parameter, hypothesis, or decision-rule text drifted
between lock and compute — **cannot be verified**. Git still dates
every change to those files; what is gone is the ability to prove the
locked text is what was run against. Three of the four carry stamped
verdicts (`carries_own`, `tracks_L`, `null`), so this is recorded in
`utilities/sidecar_baseline.txt` with each file's reason and printed as
KNOWN rather than baselined into silence.

**Built.** `utilities/check_sidecar.py` implements the four recovery
routes. Verified in three directions: it verifies the five, reports the
four as KNOWN, exits 1 on a synthetic new failure, and in a clone with
no `preregs/` directory returns 0 and prints nothing. Silent when clean
— the container's § 6 cost rule, and the reason it is safe to wire into
a hook later.

**Prevention.** `preregs/FORMAT.md` gains § "Lock, commit, then run",
which resolves its own conflict, names the recovery routes, and records
the 5/4 audit result. The immutable bodies of all nine preregs are
untouched; nothing was deleted.

---

## 2026-08-27 — Entry 219 — the ramp triage: the gate needs 2^52, not 2^44 — and γ₂ is the design question this sharpened
type: result-triage
refs: 211, 214, 215, 217, 218

Reading of entry 218. EXPLORATORY, outside the locked prereg.

**Correction to entry 215.** That entry says γ₁ "dominates the
next-highest candidate by 2.85×", from "highest 8.481 at 1.305". The
2^40 table holds **17 rows**; I printed the first six and read the
maximum off that slice. The tallest image is **32.981 at 3.0315**, so
the margin is **1.227×**. γ₁ still dominates all 16 images, so the
attribution condition and the mechanical output are unaffected —
entry 217's table already carried 1.227 through targets mode.

**Entry 215's other recommendation was wrong, and provably.** It said
the ramp's power should be re-priced on the measured `ehat_rms`
0.025 rather than O18's 0.042 placeholder. **The power table is
exactly scale-invariant in `A/σ`** — `amp = (A/σ)·σ` and P is linear
in ê — so the ratio is unchanged. Re-running the shakedown at σ =
0.025 reproduced entry 212's table with **0 of 54 cells differing**.
Only the rung count moves power.

**The ramp's odds were known before the field was read.** Inverting
the observed `P(γ₁)/med = 3.719` at the 2^40 primary geometry gives
`A/σ = 0.548`; carrying that to 2^44 predicts a median of 3.92 with
**P(≥ 5) = 0.111**. Roughly one chance in nine, computed in scratch
before the real run.

**The gate was not cleared: `P(γ₁)/median = 4.201` against 5.** No v2
prereg is justified by a detection at this ceiling.

**What the ramp did buy is a measured slope.** 3.719 → 4.201 over
199 → 224 rungs is a gain of **1.130×**, running ahead of the
√N noise-scaling floor of 1.061. Extrapolating: 2^48 (≈255 rungs)
lands near 4.5 on both the observed slope and the √N floor.
**Clearing 5 on γ₁ by ramping the ceiling alone needs roughly 2^52**,
which prices that road honestly — it is not one more ramp away.

**γ₂ is what this run actually sharpened.** At both ceilings γ₂ and γ₃
read higher than γ₁ and dominate their alias images by wider margins,
and at 2^44 **γ₂ dominates on the pair as well** (1.033), where γ₁
(0.515) and γ₃ (0.673) both fail:

```text
                 P/med 2^40 → 2^44      dominance 2^40 → 2^44
γ₁  primary        3.719   4.201          1.227   1.287
γ₂  primary        4.050   4.306          1.392   1.596
γ₃  sensitivity    4.555   4.823          1.555   1.705
```

The highest single reading anywhere is γ₃ on the sensitivity subset
at 4.823. **A v2 prereg targeting γ₂ at the 2^44 geometry is the
design question this run produced**, and it would be a fresh
preregistered question rather than a retry of v1.

**Clustering did not improve with rungs.** N = 10 is unchanged in
both subsets (6 hits, p = 0.005 uniform / 0.034 shift), and the top
six peaks remain the six strongest in-band zeros and nothing else.
The sensitivity N = 20 count fell 8 → 7 and its p-values weakened.
More rungs bought detection height, not more zeros found.

---

## 2026-08-27 — Entry 218 — O95 ceiling ramp to 2^44: 224 rungs, and a gate that reports PASS on numbers contradicting it
type: run
refs: 211, 214, 216, 217

The prereg's `inconclusive` branch names this as the recorded next
step. **EXPLORATORY and outside the locked prereg** — v1 fixes
`ceiling 2^40` and `199 union rungs` in its locked table, so nothing
here can pass or fail the preregistered question.

```text
.venv/bin/python utilities/run.py --python .venv/bin/python \
    --log results/O95_ramp_p44_run1.log O95_multibase_synthesis.py \
    --mode real --confirm-real --ceiling-pow 44 \
    --cache results/pi_master_lattice_cache_p44.json \
    --real-out results/multibase_ramp_p44.json
```

**Cache.** 306 sites at ceiling 2^44, 0.918 s wall, largest call
`π(16754764432283) = 569,636,754,054` at 0.055 s. The 278 sites shared
with the 2^40 cache were **independently recomputed and agree in all
278**. Spot audit PASS. Written to a new path;
`results/pi_master_lattice_cache.json` untouched.

**Geometry.** Primary {5..9} = **224** union rungs at x0 = 1000, not
the ≈227 entry 211 priced; arm-sum 317, pair 94, sensitivity 247.
Resolution 0.3040 → 0.2692.

**Real field.** `P(γ₁)/median = 4.201` primary (2^40: 3.719); argmax
21.050 at 4.332. Sensitivity 4.518, argmax 24.980. Pair 1.845, argmax
26.670. No compromised-equivalent fires: no arm's argmax within a
halfwidth of γ₁ (nearest miss 5.675), every tallest-image ratio
1.000000 to six places.

**Comparability, and it is stronger than entry 216's.** A full targets
re-run at 2^40 under the current script reproduced
`results/multibase_targets.json` with **zero differences across the
entire summary tree** — every unit statistic, joint alias set,
candidate table, peak and null p-value — with its internal GATE R
against `results/multibase_real.json` passing. Protected files
verified byte-identical at both ends: `multibase_real.json`
`5460b249…`, the prereg, the 2^40 cache, `multibase_targets.json`.

**A gate that reported PASS on numbers contradicting it.**
`gate_b_ok` short-circuits to true whenever `ceiling_pow != 40`, so
the first ramp log printed `GATE B ... PASS  union 224 (design 199)`.
The label now reads `N/A (off-design ceiling/x0 — this gate tests the
LOCKED geometry only)`; the logic is untouched.
`results/O95_ramp_p44_power_run1.log` still carries the misleading
PASS and is superseded by run2. **A gate whose displayed verdict can
disagree with its own displayed numbers is the O64 shape in a
label** — worth a sweep of the other gates for the same
short-circuit.

**Provenance.** `code_version` moved `39d666f6…` → `e93dbbbf…`, the
third value for this file; the prereg's artifact records `438c0d8d…`.
The zero-difference 2^40 reproduction above is the mitigation.

Artifacts: `results/multibase_ramp_p44.json` (`81f9998b…`),
`…_targets.json`, `…_power.json`, `results/multibase_ramp_gateR_p40.json`,
`results/pi_master_lattice_cache_p44.json` (`db785e18…`); five
manifests written under the run-manifest directory, timestamped
20260827T1652 through T1656. Precision: ΔR at dps 50
vs 80 identical to all 30 digits. Reading is entry 219.

---

## 2026-08-27 — Entry 217 — the instrument is reading the spectrum: six of ten peaks are zeta zeros, and γ₂/γ₃ attribute better than γ₁
type: result-triage
refs: 211, 214, 215, 216

Reading of entry 216. EXPLORATORY — the locked prereg governs the γ₁
attribution question only and does not govern this.

**The control decided it, and entry 215's second reading survives.**
Six of the primary subset's top ten peaks land within one halfwidth
of a zeta zero, against a null expectation of 2.23:

```text
                obs   analytic   uniform+minsep      zero-shift
primary  N=10     6       2.23   p = 0.0049          p = 0.0336
primary  N=20     7       4.47   p = 0.0794          p = 0.1480
sens.    N=10     6       2.23   p = 0.0042          p = 0.0259
sens.    N=20     8       4.47   p = 0.0214          p = 0.0412
```

In both subsets **the top six peaks are the six strongest in-band
zeros and nothing else.** The zero-shift null is the conservative one
(observed peaks held fixed, the real zero set circularly shifted, so
both configurations keep their real spacings) and it is the number to
quote. The signal dilutes with N on the primary and holds on the
sensitivity subset. The top-six observation is post-hoc; no N = 6
p-value was computed for it and none should be quoted.

**A brief error corrected in the conservative direction.** The brief
said the band holds 6 zeta zeros; it holds **8** — 40.9187 and
43.3271 are in band. The agent found it and re-based every null on 8,
which raises the expectation from 1.67 to 2.23 and weakens the
result. The mistake would have flattered it.

**γ₂ and γ₃ dominate their own alias images more cleanly than γ₁
does.** Target `P/median` over strongest in-band image:

```text
             primary {5..9}   sensitivity {4..9}   pair {8,9}
γ₁              1.227              1.132             0.521
γ₂              1.392              1.717             1.070
γ₃              1.402              1.555             0.674
```

The attribution condition the prereg asks for is met at all three
frequencies on the primary and sensitivity subsets, and **best at the
two frequencies the design never targeted**. The pair still fails,
consistent with its 84-rung power rather than with the mechanism.

**The joint alias structure was verified, not assumed.** The collapse
`γ' ≡ ±γ_t (mod 8γ₁)` was computed by intersecting the per-arm
classes over [2,500] and matches the prediction in all 12 cases
(3 subsets × 3 targets, plus the coprime pair). Neither γ₂ nor γ₃ has
an in-band joint confusable; γ₁'s `7γ₁ = 98.94` reproduced. Entry
211's CRT argument is about the lattice rather than the target, and
that now has a computation behind it.

**Two limits that bound the reading.**

Single arms are flat for EVERY target — γ₂ and γ₃ alias exactly as γ₁
does, measured flatness `max|P_img/P_target − 1|` between 1.0e-7 and
5.7e-4 across all 18 arm × target cells. The strict "dominates"
boolean on an arm row is decided by float jitter and carries no
content; the flatness column is the readout.

**Entry 214's arm-7 observation is weaker than it reads.** That entry
recorded arm 7's argmax at 21.010, γ₂ miss 0.012. The honest form:
**seven of the first twenty zeros fold to within a halfwidth of that
argmax** under arm 7's lattice. γ₂ is nearest by a factor of six over
the runner-up and is the only one in band — but arm 7 alone does not
identify it, and every arm shows the same multiplicity (arm 4: four
zeros, arm 6: three, arm 8: three). No arm's argmax picks out a
single zero. That is the no-go again, in the place it is easiest to
misread as a detection.

**What this does not settle.** Whether the arms' folding favours γ₂
over γ₁, or γ₂ is simply locally stronger at these x-scales, is still
open — this run establishes that the peaks are zeros, not which
mechanism puts γ₂ on top.

---

## 2026-08-27 — Entry 216 — O95 `--mode targets`: candidate tables for γ₂ and γ₃, and the peak-clustering control
type: run
refs: 213, 214, 215

`O95_multibase_synthesis.py --mode targets`, EXPLORATORY. Additive
mode; `--mode real` still exits 2 without `--confirm-real`, verified.

```text
.venv/bin/python utilities/run.py --python .venv/bin/python \
    --log results/O95_targets_run1.log O95_multibase_synthesis.py --mode targets
exit 0   created 2   modified 0   π calls 0 (cache read)
manifest results/runs/20260827T160022Z_O95_multibase_synthesis.json
results/multibase_targets.json
```

**GATE R, added for this run and the reason it is trustworthy.** The
targets path recomputes every unit's `P_median`, `argmax_gamma`,
`P_max_over_median` and `ehat_rms` and checks them against
`results/multibase_real.json` — the prereg's artifact. **PASS on all
nine units.** The duplicated code path is verified against the locked
run rather than trusted.

**The prereg's artifact is untouched:** `results/multibase_real.json`
sha256 `5460b249…`, matching the `post_compute_sha256` in the Run
record. Written to `results/multibase_targets.json` instead.

**Provenance item that needs saying.** Editing O95 to add this mode
moved its file sha256 from `438c0d8d…` to `39d666f6…`. `438c0d8d…` is
recorded as `params.code_version` inside the prereg's artifact, so a
later reader checking that field against the file **will find a
mismatch**. GATE R is the mitigation and it passed; the script's
behaviour on the prereg's question is unchanged bit-for-bit.

Arm spacings `Δ_j = 8γ₁/j`: 28.2695, 22.6156, 18.8463, 16.1540,
14.1347, 12.5642 for j = 4..9; `8γ₁ = 113.0778`. Peak rule: strict
local maximum on the 0.01 grid, taken in descending P, accepted only
at ≥ one halfwidth from every accepted peak. Two nulls implemented:
uniform placement under the same minimum separation (10 000 draws),
and a circular zero-shift null holding the observed peaks fixed
(10 000 draws).

Precision: ΔR on the first primary block at dps 50 vs 80 identical to
all 30 printed digits. Gates A/B PASS. Reading is entry 217.

---

## 2026-08-27 — Entry 215 — O95 triage: the gate failed, the no-go was demonstrated on real primes, and the peak is γ₂
type: result-triage
refs: 18, 26, 211, 213, 214

Reading of entry 214, under the locked prereg. **The verdict line is
Julian's and is empty.**

**The mechanical output is `inconclusive`, and the branch did its
job.** `P(γ₁)/median = 3.719` on the primary against a locked gate of
5. Rule 4 fires; the recorded next step is the ceiling ramp to 2^44
(≈227 union rungs). This is the branch entry 211 insisted on so a
silent gate would not be read as a negative result — and it is what
happened.

**The no-go is now demonstrated on the real prime field, not only
proved.** Every aliased arm reads γ₁ and all of its in-band fold
images at **identical periodogram height**:

```text
arm 5   8.481, 14.135, 31.096, 36.750        all 6.233
arm 6   4.712, 14.135, 23.558, 32.981, 42.404  all 4.128–4.129
arm 7   2.019, 14.135, 18.173, 30.289, 34.327  all 2.438
arm 9   10.994, 14.135, 23.558, 26.699, …     all 1.002
arm 8   14.135, 28.269, 42.404                 all 0.185
arm 4   14.135, 42.404                         both 1.453
```

`nyquist_no_go` says an arm past its Nyquist cannot separate γ from
its aliases; the shakedown found the combs identically flat on
synthetics because the noise aliases with the signal; **the real
field reproduces it to three and four decimals.** No arm's argmax is
within a halfwidth of γ₁, so no control fires the X = 0.10 criterion
and the run is not compromised. Entry 212's margin argument held.

**The joint mechanism worked on the alias question and the gate is
what stopped it.** In the primary, γ₁ reads 3.719 while every alias
candidate reads below it — 8.481 at 1.305, 10.994 at 1.157, 4.712 at
0.674, 18.173 at 0.360, 2.019 at 0.034. **γ₁ dominates the
next-highest candidate by 2.85×**, which is the attribution condition
the rule asks for, met. What failed is the detection threshold, and
separately the argmax condition — the global peak is elsewhere.

**Where the peak is, and this was not a preregistered question.**

```text
primary  {5..9}    argmax 21.050   γ₂ = 21.0220   miss 0.028
sens.    {4..9}    argmax 24.960   γ₃ = 25.0109   miss 0.051
arm 7    alone     argmax 21.010   γ₂ = 21.0220   miss 0.012
pair     {8,9}     argmax 26.680   a γ₁ fold image at 26.699
```

The instrument's strongest joint peak is **γ₂**, and the sensitivity
subset's is **γ₃** — both inside one halfwidth of a true zeta zero
and neither in the alias table, which the design built around γ₁
alone. Two readings are open and this run does not separate them: the
residual carries every mode, so a subset's peak landing on γ₂ may
simply be γ₂ being locally stronger at these x-scales; or the arms'
folding may favour γ₂ over γ₁ in a way the γ₁-centred candidate
table cannot see. **The alias-candidate table should be computed for
γ₂ and γ₃** — cheap, since the geometry is cached — before either
reading is preferred.

**The pair is the honest disappointment.** `{8,9}`, the
sub-average-Nyquist column where entry 211 said the claim would have
teeth, reads γ₁ at 1.714 while its own alias image at 26.699 reads
3.291 — the image beats γ₁. At 84 rungs that is the underpowered
regime the shakedown priced (0.480 dominance at `A/σ = 0.5`), so it
is consistent with low power rather than with the mechanism failing;
the ramp is what would tell them apart.

**Measured noise, for the ramp's power estimate.** `ehat_rms` is
0.02501 on the primary against the 0.042 placeholder inherited from
O18 — the residual is quieter than assumed, so the ramp's power
should be re-priced on 0.025 rather than reusing the shakedown's
table.

---

## 2026-08-27 — Entry 214 — O95: the real-field joint measurement, under the locked prereg
type: run
refs: 211, 212, 213

`O95_multibase_synthesis.py --mode real --confirm-real`, governed by
`preregs/multibase_synthesis_v1_20260827.md`, sha256
`877f150d8b96e92b9f73cdd8ba8c8546c28fd5727e292990167cce42a0b1af19`,
sidecar verified OK before the run.

```text
python3 utilities/run.py --python .venv/bin/python \
    --log results/O95_multibase_synthesis_run2.log \
    O95_multibase_synthesis.py --mode real --confirm-real
exit 0   created 2   modified 0
manifest results/runs/20260827T084045Z_O95_multibase_synthesis.json
results/multibase_real.json
```

**Gates.** A (site exactness at dps 50, `x_i ≤ 2^40`) PASS; B
(entry 211 geometry: union 199, arm-sum 281, pair 84) PASS; C (π spot
audit at 7 sites) PASS. Zero π calls — the cache built in the
shakedown was read, not rebuilt.

**Primary `{5..9}`, 199 rungs:** `P_median` 0.1462, argmax at
`γ = 21.050` with `P/med = 4.068`; `P(γ₁)/med = 3.719`. Alias
candidates all below γ₁ (highest 8.481 at 1.305).

**Secondary `{8,9}`, 84 rungs:** argmax 26.680 at 3.299;
`P(γ₁)/med = 1.714`; its own fold image at 26.699 reads 3.291.

**Sensitivity `{4..9}`, 219 rungs:** argmax 24.960 at 4.621;
`P(γ₁)/med = 4.070`.

**Single-arm controls:** every aliased arm's candidate table is flat
to 3–4 decimals across γ₁ and all its in-band images (arm 5 at 6.233,
arm 6 at 4.128, arm 7 at 2.438, arm 9 at 1.002, arm 8 at 0.185); arm
4 at 1.453 on both entries. No arm's argmax falls within a halfwidth
of γ₁ — **the X = 0.10 compromised criterion does not fire.**

**Mechanical output: `inconclusive`** — precedence rule 4, the
detection gate failing at 3.719 against the locked 5. Not compromised
(rule 1 checked and clear). Run record filled in the prereg with
`post_compute_sha256`; **the verdict line is left empty for Julian.**

Reading is entry 215.

---

## 2026-08-27 — Entry 213 — O95 prereg drafted: detection-gated attribution, with the theorem as the compromised branch
type: prereg
refs: 211, 212

`preregs/multibase_synthesis_v1_20260827.md`, STATUS DRAFT, no
sidecar — not yet locked. Julian approved the two design
recommendations that shaped the rule:

**The rule is detection-gated.** The shakedown produced two readouts;
the locked rule takes the stricter one — 5× median detection first,
then attribution (argmax within one halfwidth of γ₁ AND `P(γ₁)`
dominating every in-band alias candidate at exact frequencies).
Threshold-free dominance rides as a labelled secondary column.
`no_detection` routes to an explicit `inconclusive` branch with the
ceiling ramp (2^44 → ≈227 rungs, 2^48 → ≈255) as the recorded next
step rather than a forced verdict.

**The compromised branch is the theorem.** If any single-arm control
fires the X = 0.10 comb criterion — cleanly resolving γ₁ where
`nyquist_no_go` says it cannot — the run is compromised: the pipeline
would be manufacturing the distinction. The shakedown's finding that
noise aliases with signal on a uniform arm (comb ratios identically
1.0000) gives the criterion ~4 orders of margin.

Labels: `compromised` → `joint_attributes` → `misattributed` →
`inconclusive`, precedence in that order. `misattributed` is the
informative failure: signal present, joint mechanism absent.
Vacuousness: both directions fire on the measured power surface
(0.925 at `A/σ = 1` for the positive; the combs' ratio-1.0 images
are exactly what `misattributed` reads).

Blind arm stated: the union residual vector and every statistic on
it, unread through design and shakedown; `--mode real` refuses
without `--confirm-real`, verified exit 2. Lock is Julian's call.

---

## 2026-08-27 — Entry 212 — O95 shakedown: pipeline green, power gate reproduced, and the comb is identically flat
type: run
refs: 17, 18, 208, 211

`O95_multibase_synthesis.py`, EXPLORATORY shakedown — everything
except the real measurement, per entry 211's approved sequence.

```text
python3 utilities/run.py --python .venv/bin/python \
    --log results/O95_multibase_synthesis_run1.log O95_multibase_synthesis.py
exit 0   manifest results/runs/20260827T082344Z_O95_multibase_synthesis.json
results/pi_master_lattice_cache.json + results/multibase_shakedown.json
```

**Cache.** 278 master-lattice sites `(i, x_i, π(x_i))`, `i = 20..498`,
ceiling 2^40, largest call `π(1.04e12) = 39,099,802,969`, wall
0.196 s, 7-site spot audit PASS. Geometry reproduces entry 211
exactly: primary union 199 rungs vs arm-sum 281 (the shared-field
arithmetic made literal), pair 84, resolution 0.304, pair mean gap
0.247 > π/γ₁.

**Power gate, 200 trials/cell, σ = 0.042 (O18's rms).** Two readouts:
detection-gated (5× median then attribution) 0.010 / 0.925 / 1.000 at
`A/σ = 0.5 / 1 / 2` primary; threshold-free dominance 0.935 / 1.000 /
1.000. Pair {8,9}: 0.480 / 0.795 / 0.880 dominance — weaker, as
designed. In-band alias plants self-attribute at ≥ 0.96 and γ₁ never
steals them. **7γ₁ must-confuse: confuses** (read as γ₁ at 0.940 /
1.000) — the instrument fails exactly where ν ≡ −1 (mod 8) says it
must; a resolution there would have signalled a bug.

**The unanticipated finding, and it strengthens the control.**
Aliasing on a uniform arm is an identity of the sampling set, so the
NOISE aliases with the signal: noisy per-arm comb ratios are exactly
1.0000, the only leakage being floor jitter at ~1e-5. The comb is
identically flat rather than approximately flat, so the X = 0.10
compromised criterion carries four orders of magnitude of margin —
it can only fire on a pipeline that manufactures the distinction.
Every arm 5–9 shows its full comb (arm 8 through higher images only;
γ₁ folds to its DC, the O48/O49 null base connection). Arm 4 reported
as the labelled boundary row.

**{8,9} shared-class tally:** under the pair, 1.571 and γ₁ share arm
9's entire alias class; at `A/σ = 2` the 1.571 plant's argmax lands
on shared-class frequencies in 0.50 of trials, never on γ₁ itself.
Recorded in the prereg's alias-candidate discussion.

**Blind arm intact, stated mechanically:** the code drops the π rows
before any statistic; no residual, periodogram, or attribution number
touched the real field; `--mode real` exits 2 without
`--confirm-real`. Precision: ΔR at dps 50 vs 80 identical to all
printed digits. Prereg draft is entry 213.

---

## 2026-08-27 — Entry 211 — O95 design: the joint alias set collapses to ν ≡ ±1 (mod 8), and the claim is priced before it is measured
type: motivation
refs: 17, 18, 26, 199, 208, 210

Design pass for the multi-base synthesis (entry 210's thesis), by an
audit agent; GO. Approved by Julian with the recommended parameters.
The build is a separate agent; nothing here ran against the prime
field — the design's scratch used geometry and synthetics only, and
**no π value at any union site has been computed this session**: the
data vector is unpeeked.

**The CRT structure, which is the heart.** Master lattice spacing
`s = π/(4γ₁)`; arm `j` of the family (`b_j = exp(πj/(4γ₁))`) samples
sites `i ≡ 0 (mod j)` and has alias spacing `8γ₁/j` — in units
`ν = γ/γ₁`, arm `j` confuses `ν ≡ ±1 (mod 8/j)`. Aliased arms are
exactly `j > 4`; `j = 4` is entry 199's boundary member. Per-arm fold
images of γ₁: j=5 → 8.481, j=6 → 4.712 (γ₁/3), j=7 → 2.019 (γ₁/7),
j=8 → **0 exactly** (γ₁ sits at arm 8's sampling frequency — the
O48/O49 null base 1.5597), j=9 → 1.571 (γ₁/9). The residues differ
per arm, which is the entire mechanism.

**Any coprime pair of aliased arms collapses the joint set to
`ν ≡ ±1 (mod 8)`** — confusables {γ₁, 7γ₁, 9γ₁, …}, nearest at
`7γ₁ = 98.9`, far outside any scan band. Verified independently in
chat by a second scan. **Non-coprime pairs fail**: {6,8} keeps
`3γ₁ = 42.4` exactly confusable in-band; {7,9} has a finite-resolution
near-alias at 1.795 (miss 0.224, inside resolution) and is excluded.
Locked subsets: **{5,6,7,8,9} primary, {8,9} secondary**, `j = 4` as
a labelled sensitivity column, no others.

**The statistic is O17/O18's pipeline verbatim** — union-ladder NUFFT
periodogram, Hann, 0.01 grid, 5× median, R at floor points (entry
209's convention) — no new estimator to tune, which is the O64
defense. Readout is ATTRIBUTION: the joint peak at γ₁ dominating
every per-arm fold image, with the alias-candidate table printed.
Prime data enters only through `π` at union sites.

**The control is the theorem.** Each arm runs the identical pipeline
alone and must show its alias comb (`Nyquist.nyquist_no_go` covers
every `b_j`, `j > 4`, at γ₁; O18 measured exactly this comb on the
dyadic ladder). **If any single-arm control cleanly resolves γ₁, the
run is compromised** — the theorem says that cannot happen, so the
pipeline would be manufacturing the distinction.

**Power, priced from O18's precedent** — detection at 237 rungs,
failure at 108. Union {5..9} above `x0 = 1000`: 146 rungs at the
2^32 ceiling (inside the failure gap) — **the design point is a 2^40
ceiling**: 199 union rungs, resolution 0.30, ~460 primecount calls.
Synthetic power at that size: 100% attribution at A/σ ≥ 1, 79% at
0.5 (marginal regime stated; inconclusive band required in any
prereg). Pair {8,9}: 84 rungs, 87%/76% — weaker, accepted as
secondary. Ceiling ramp if underpowered: ≈227 rungs at 2^44, ≈255 at
2^48.

**The shared-field pricing, load-bearing for any paper.** One array
of π values; each arm is an index mask; N_eff is the union count
(199), never the arm sum (281). Per-arm unresolvability is geometric,
so reading one field under differently-folded masks removes the
ambiguity — multi-coset sampling: one signal, interleaved cosets,
joint identification past every coset's Nyquist. The deflation: the
union averages super-Nyquist (mean gap 0.105 < π/γ₁ = 0.222), so its
resolving power is Landau-unsurprising; **the {8,9} pair (mean gap
0.250 > π/γ₁) is the genuinely sub-average-Nyquist sampler where the
claim has teeth**. The earned claim is an instrument/sampling result
— aliased arms jointly attribute the known mode against their own
alias sets — never a new arithmetic detection of γ₁ (O17/O50 already
measured its presence). O45's `fineness` and § D4 bound Z-count
claims; this design reuses no Z-counts.

**Lean companion found:** "for coprime aliased arms, joint aliasing
forces ν ≡ ±1 (mod 8)" is finite algebra over `Nyquist.Aliases`
stated for two bases at once — with the no-go this makes a theorem
PAIR, floor and loophole. Queued beside entry 208's
`(1−z²)⁷ = (1−z)⁷(1+z)⁷` pin candidate.

**Dense scan (entry 199): complement, not absorbed.** It asks the
per-arm step question at `b = 1.2489`; when it runs it should adopt
this pipeline's per-arm periodogram as its statistic. Line stays
open.

**Approved parameters:** subsets as above; 2^40 ceiling; `x0 = 1000`
primary with `x0 = 2` sensitivity; **exploratory shakedown first**,
then prereg lock against the exercised pipeline — the union π vector
stays unpeeked through the shakedown, so the blind arm survives into
the lock.

---

## 2026-08-27 — Entry 210 — the eleven bases are one instrument: the synthetic-aperture reading, and the road past the no-go
type: motivation
refs: 18, 26, 199, 205, 208, 209

Julian asked whether something obvious in the tests and results had
been missed — something possible now that could not be foreseen
until now. There is one, and entry 208's factorization is what makes
it visible.

**Four unlooked-for surfacings of the same lattice.**
`Commensurate-Ladders.md` § D4: O45's base set shares a lattice and
the prereg never noticed. Entry 199: the winding angle
`θ = γ₁ log b` IS the Nyquist resolvability condition, with the
boundary a family member. Entry 205: two cells whose window tops
coincide exactly, `28·5π/(4γ₁) = 70·π/(2γ₁)`. Entry 208: two zeros
in different bases share the annihilator `(1−z)⁷` and are
constraints on one u-field. Four independent instruments, one
message: **the eleven bases are not eleven instruments. They are one
instrument, accidentally built.**

**What the family actually is.** `b = exp(πk/(2γ₁))` steps the
winding `θ` by 45° — a bank of ladders sampling γ₁'s phase in
QUADRATURE. The family was selected for winding-angle reasons; a
sampler bank whose phases step in quadrature at one frequency is a
synthetic aperture centered on that frequency, and nobody chose it
as one.

**The three pieces already in the tree, in separate drawers.**

1. `Nyquist.lean` proves no SINGLE integer base resolves γ₁
   (`base_bound_of_resolvable`, `base_two_fails_by_three`). The
   no-go is per-ladder; its statement does not cover joint sampling.
2. O18 measured, before the no-go was formalized, that bases blind
   singly detect JOINTLY — the loophole demonstrated empirically.
3. Entry 208's gcd machinery expresses any commensurate pair as
   functionals on one common field, with
   `results/pi_half_octave_cache.json` now covering `j ≤ 80`.

**The possibility.** Aliasing lattices differ per base — each ladder
folds γ onto a different residue class of its own `2π/log b` — so
jointly the family can distinguish frequencies no member can. The
proved no-go is the floor for every single arm; any joint resolution
beyond it is the measurement. Multi-base synthesis: the commensurate
family as one coherent aperture, measured against γ₁.

**Design constraints known in advance,** so the next instrument does
not repeat this week's failures: the per-arm no-go must be the
stated floor (the O64 lesson — the null arm through the same
pipeline); the joint statistic must have the prime data entering it,
proved non-constant, per entry 205's spec; and O45's Z-counts are
already measured on these ladders, so any synthesis claim must be
priced against what `fineness` already bounds.

**The container framing lands here.** The container is not any one
table. It is the common field all commensurate tables read — the
u-field is its first explicit piece.

---

## 2026-08-27 — Entry 209 — O94 triage: the shared sites carry more of both balances than any clean placement, at a p-resolution of 1/15
type: result-triage
refs: 201, 205, 208

Reading of entry 208's run. EXPLORATORY — the pair was unblinded at
design time and no verdict is possible on it.

**The primary result.** Among the 15 data-disjoint placements — even
shifts, supports outside the observed pair's widened support
`j = 23..40` — **none reaches `T_obs = 0.1010`**; the null tops out
at 0.0516, median 0.0269. The two placements that exceeded `T_obs`
in the design scratch (`t = −10` at 0.1546, `t = +2` at 0.1198) sit
INSIDE the exclusion zone: they were reading the observed data. The
design's "upper tail, unremarkable" peek was the overlap-included
column; the clean column reads differently.

**The bounds that keep this honest.** Minimum attainable `p` is
`1/15 = 0.067` — the instrument cannot deliver small p-values, said
in advance. `σ` correlates mildly negatively with `|cell|` across
placements (r: −0.32 A, −0.44 B), so zero-conditioning is live. And
the structural bound found on the way — **any placement with both
cells exactly zero has `T ≤ ½`** (sign analysis of `x+7y`, `y−5x`) —
means null placements can reach T values the observed pair could
never attain: the conservatism runs against the observed pair.

**The sigmas against their floors.** `σ_A = 0.1010` against a
geometric floor of 0.0625; `σ_B = 0.3570` against 0.1875 — 1.9×.
The one-event planting lands on the `T = ½` ceiling exactly; the
two-event planting reads `T = 0` exactly. The instrument
discriminates where discrimination is possible.

**What this is and is not.** It is: the shared u-sites `{33, 34}`
carry a larger share of both cells' balancing mass than identical
geometry manages anywhere else on the clean lattice, at the stated
resolution. It is not: a verdict, a p < 0.05 claim, or a statement
that survives the unblinding. The thread stays open at exactly this
size; a preregistered version would need a fresh pair.

**Convention finding carried forward:** the smooth-leakage control
identifies O34's convention as R evaluated at the FLOOR points
`F[j]`, the points the table reads π at — 13.37 at `j = 40` against
10.17 at exact half-powers. The φ companion column's denominator
hazard is convention-dependent (−93.68 floor convention, −0.0024
exact-point); the script prints the hazard whenever `|den| < 1`.

---

## 2026-08-27 — Entry 208 — O94: the gcd factorization, and the joint-localization run
type: run
refs: 88, 192, 201, 204, 205

`O94_joint_localization.py`, EXPLORATORY. The v2 of the overlap
question, built to entry 205's spec through an audit-before-execute
split: a design agent produced the statistic, the null and the power
check; Julian approved; a separate agent built and ran.

**The factorization, verified exact on the real field.** On the
half-octave lattice `j` with `F[j] = ⌊2^(j/2)⌋` and `P[j] = π(F[j])`:

```text
base 2 (20,6):  stencil (1−z²)⁷ = (1−z)⁷ · (1+z)⁷,  top j = 40
√2 (34,11):     stencil (1−z)¹² = (1−z)⁷ · (1−z)⁵,  top j = 34
gcd = (1−z)⁷    u_j := Δ⁷ P at j
A = Σ C(7,i)·u_{40−i}        all-positive, support 33..40  = 0
B = Σ (−1)^i C(5,i)·u_{34−i}  alternating,  support 29..34  = 0
shared sites {33, 34}: 8/128 = 6.25% of A's mass, 6/32 = 18.75% of B's
```

Both zeros reproduce in quotient AND direct forms; the refinement
identity `N₂(r) = n_{2r−1} + n_{2r}` holds for `r = 1..32`; π audit
41/41 against `pi2n_cache.json`. **The "3.0 log₂ overlap, 0.545 of
the shorter" framing double-counted the common annihilator: factored
out, the two heaviest census zeros share their annihilator, not
their window.** The identity `(1−z²)⁷ = (1−z)⁷(1+z)⁷` is a
Lean-pin candidate.

**Statistic and null, as designed.** `σ_X` = shared-site share of
`Σ|w_j u_j|`; `T = min(σ_A, σ_B)`. Data enters solely through the
integers `u_j`; proven non-constant across placements. Null: rigid
translation of the whole two-cell configuration along the lattice,
real primes everywhere — O88's pattern transposed. Power check run
first: one-event planting `T = 0.500` (the structural ceiling),
two-event planting `T = 0` exactly; both separate from the null
cloud.

```text
python3 utilities/run.py --python .venv/bin/python \
    --log results/O94_joint_localization_run1.log O94_joint_localization.py
exit 0   created 3   modified 0
manifest results/runs/20260827T074209Z_O94_joint_localization.json
results/joint_localization.json + results/pi_half_octave_cache.json
    (self-describing: F[j] stored beside π(F[j]), j ≤ 80)
```

Headline numbers and reading: entry 209.

---

## 2026-08-27 — Entry 207 — O92 runs 2/3 triage: the depth barrier is real; run 1's oscillation was the cutoff's, and where certification happens it is nearly free
type: result-triage
refs: 201, 202, 203, 206

Reading of entry 206. EXPLORATORY.

**Entry 203's discriminator fired, and it landed on "the barrier is
real."** `(20,6)` stays UNCERTIFIED under both smoothings, and the
Cesàro error CONVERGES — tail swing 0.9 over the last 100 effective K
(97.5, 96.6, 97.0, 97.2, 97.3), settled near **97 against a criterion
of 0.5**. Two orders of magnitude short with the oscillation removed.
Run 1's caveat — that the sharp cutoff's swinging tail might account
for "uncertified at 600" — accounted for the swing alone: the sharp
tail moved 69.0 over `K ∈ [425,600]`; the smoothed tails move ~10 and
Cesàro's moves 0.9.

**The depth trend survives every taper, monotone.** Cesàro terminals
at `r = 20`: 4.28 / 7.56 / 12.61 / 22.61 / 40.98 / 68.07 / 97.35
across `d = 0..6`, against sharp's 8.31 → 104.30. No depth certifies
stably under any taper; the `d = 6` background stays 0/13 under all
three.

**Where certification happens at all, it is nearly free once
smoothed.** `(4,1)`'s stable K drops 32 → 4 (gaussian) / 5 (cesàro);
the `d = 1` background median stable K collapses 304 → 4 / 7. Run 1's
large medians were oscillation-driven pop-outs — smoothing removes
all six of `(4,1)`'s — so the rate–distortion picture sharpens into a
step: cells the spectral code can certify, it certifies almost
immediately; cells it cannot, it misses by orders of magnitude. The
gap between K ≈ 4 and never is the arithmetic/spectral boundary of
entry 201's arrow, now visible as a gap rather than a slope.

**The residue of outcome three, stated.** A slow upward drift
survives smoothing at shallow depths — Cesàro `d = 0` drifts
2.5 → 4.3 over the last 200 K — so 600 zeros is not fully converged
data at `r = 20` even smoothed. The "settled near 97" reading is the
Cesàro tail's. The certified/uncertified split is robust to this; the
terminal values are not final digits.

**Instrument notes carried forward.** The gaussian terminal at
`K = 600` is the sharp full sum by construction (all weights → 1), so
its informative range is effective `K < 600`. Cross-taper K values
compare only within a taper — Cesàro's half-weighted recent modes lag
where the sharp sum was close, e.g. the control `(19,6)` reads 13.72
terminal under Cesàro with no touch. The script states both.

**Joint state of the arrow.** O92 sharp: uncertifiable at 600 under a
sharp cutoff. O92 smoothed: uncertifiable with the error converged.
O93: the phase route cannot see cancellation in principle. The
arithmetic certifies for free — a subtraction of integers — what the
spectral code misses by two orders at every measured rate.

---

## 2026-08-27 — Entry 206 — O92 runs 2 and 3: smoothed truncation, gaussian and Cesàro
type: run
refs: 202, 203

`O92_certification_cost.py` extended with `--taper
{sharp,gaussian,cesaro}` and `--out`; the sharp default is run 1's
path unchanged. EXPLORATORY.

**Comparability check first.** The extended script at `--taper sharp`
diffed leaf-by-leaf against `results/certification_cost.json`: every
numeric leaf in `summary` and `rows` identical, including `(20,6)`
terminal 104.30293091011013 and `(4,1)` stable K 32. New keys are
descriptive only. **Run 1 stands byte-comparable; entries 202/203
unchanged.**

**Tapers.** Cesàro: `S_K = Σ_{k≤K} (1 − k/(K+1))·c_k`. Gaussian:
`S_K = Σ_{k≤600} exp(−(γ_k/G)²)·c_k` with `G(K)` the unique width
making the weight sum equal K — the effective pair count, reducing to
the sharp count for 0/1 weights, so K keeps run 1's meaning at equal
spectral mass. Solved by geometric bisection, weight sum matching K
to 10 decimals at every probe; `G(100) = 257.35`, `G(200) = 435.13`,
`G(400) = 857.83`. At `K = 600` gaussian is the sharp full sum by
construction.

```text
python3 utilities/run.py --python .venv/bin/python \
    --log results/O92_certification_cost_run2.log \
    O92_certification_cost.py --taper gaussian
python3 utilities/run.py ... run3 ... --taper cesaro
manifests results/runs/20260827T061046Z_… and …T061140Z_…
results/certification_cost_gaussian.json, …_cesaro.json
(default --out auto-remaps under a taper; run 1's JSON untouched)
```

**Headline.** `(20,6)` err at effective `K = 100/200/400/600`: sharp
89.9 / 90.8 / 87.8 / 104.3; gaussian 132.9 / 106.0 / 93.1 / 104.3;
cesàro 152.8 / 147.3 / 109.0 / 97.3. UNCERTIFIED under all three.
Background certified/defined: `d = 1` 9/18, 9/18, 11/18; `d = 3`
1/16, 1/16, 2/16; `d = 6` 0/13 all. `(8,3)` uncertified at
1.90/1.90/1.77.

**Precision:** dps 80 on all 11 headline cells, all three runs — zero
K moves, terminal shift 0.00e+00. Reading is entry 207.

---

## 2026-08-27 — Entry 205 — O93 triage: the phase statistic has no access to cancellation, and the naive positive is window geometry
type: result-triage
refs: 192, 199, 201, 204

Reading of entry 204. EXPLORATORY.

**The test as posed is not well-posed, and the run proves it rather
than suspects it.** The per-mode phase difference between two cells
decomposes as `δ_k = Δ·γ_k + ψ_k`, where `Δ` is the log window-top
offset and `ψ_k` depends only on (base, depth). **No prime count
enters the phases anywhere** — they are analytic functions of the
zeros alone. So "one cancellation event" and "two events" predict
identical `R`, and the statistic cannot distinguish them in
principle.

**The naive positive was real and is pure geometry.** `p = 0.0000`
against the non-overlap null — and the 20 other lattice pairs sharing
the primary's exact `Δ = −3` reproduce its naive `R` to `1.4e−16`.
The deterministic rotation explains 100% of pair-to-pair variation.
The non-overlap null was structurally incapable of matching on
position: non-overlap forces `|Δ| ≥ 5.5` while the observed pair sits
at `|Δ| = 3.0`. A cleaner instance of a null that differs from the
target in exactly the variable driving the statistic is hard to
construct. After the fast-phase correction nothing survives at any of
the eight pairs.

**What remains open is the question, with a spec the failure wrote.**
Whether `√2 (34,11)` and `2 (20,6)` are one cancellation seen at two
resolutions is untouched — the instrument that could answer it must
read something the primes actually enter: the cells' values along the
shared window, prime-block decompositions, not mode phases.

**Found in passing:** containment pair 7 has `Δ = 0` exactly —
`28·5π/(4γ₁) = 70·π/(2γ₁) = 35π/γ₁` — two commensurate-family cells
whose window tops coincide identically. The Commensurate-Ladders
lattice (§ D4, entry 199) surfacing a third time, unlooked-for.

**Scope note.** Entry 201 said two `frac_of_shorter = 1.0` pairs; the
JSON holds seven. All seven were run; the miscount was mine in 201.

---

## 2026-08-27 — Entry 204 — O93: the overlap identity, run
type: run
refs: 192, 201

`O93_overlap_identity.py`, EXPLORATORY. Entry 201 item 2.

```text
python3 utilities/run.py --python .venv/bin/python \
    --log results/O93_overlap_identity_run1.log O93_overlap_identity.py
exit 0   created 2   modified 0
manifest results/runs/20260827T041628Z_O93_overlap_identity.json
```

**The mandatory precondition passed before any mode was built.**
O45's `√2` table reconstructed from prime counts — `F[r] =
floor(√2^r)` by exact integer square root, depth-0 row `N(r) =
π(F[r]) − π(F[r−1])`, then the backward-difference recurrence.
`π(2ⁿ)` audit 33/33 against `pi2n_cache.json`; all five bases the
targets touch match `sub_integer_base_scan.json` cell-exact,
including `√2 (34,11)` at total 924, `S = 1,371,038` and `(42,5)` at
1334 / 651,298. The entry-192 trap discriminates in the new base:
`Δ^(d+1)` reproduces every recorded zero, `Δ^d` misses all four
mass-clearing ones (`(34,11)`: `Δ^d = −685`). Mode formula confirmed:
`n = d+1` for every O45 base.

**Headline numbers.** Primary pair `√2 (34,11) × 2 (20,6)`: naive
`R = 0.1539` (weighted 0.3816), corrected 0.1004
(corrected-weighted 0.6385). Nulls: 1248 all-pairs, 762
non-overlapping. `p_naive` vs non-overlap 0.0000; vs all-pairs 0.164;
corrected-weighted vs non-overlap 0.375. Seven containment pairs run;
six read background; `containment 6` reads naive 0.2098 at
`p = 0.0000` with `|Δ| = 0.56` — the same confound, labelled as such.

**Precision:** float-assembly vs full-mpmath dps 80, max rel diff
`3.78e−15` across 32 headline values; dps 50 vs 80: 0.00e+00.

Results `results/overlap_identity.json` via `guarded_write`; log via
run.py `--log` (entry 198's fix, first production use). Reading is
entry 205.

---

## 2026-08-27 — Entry 203 — O92 triage: the deep zero is uncertifiable at 600 pairs, and O34's residual convention is R, identified by measurement
type: result-triage
refs: 193, 197, 201, 202

Reading of entry 202. EXPLORATORY.

**The brief carried a contradiction and the instrument caught it
before computing.** The spec named the li-stencil as the main term
AND said to match O34's handling. Those conflict: O34's stored
residuals are **R-stencil** — `cell − Δ^(d+1)R` reproduces all seven
of O34's literals to `5e−4` (transcription rounding), while li misses
depths 0–2 by 23.8 / 5.9 / 1.5, decaying at O29's documented li−R
gap profile. Under li, certification at `(20,0)` was impossible by
construction — a 23.8 floor against a 0.5 criterion that no number
of zeros removes. **Every certification number under the brief-as-
written would have been wrong.** R adopted, li carried as a
comparison column. The identification is a dated finding about O34's
convention that nothing in the tree recorded.

**The certification numbers.** `(20,6)` never touches ±0.5 at any
`K ≤ 600` — terminal error 104.3. The `K_cert(d)` ladder at `r = 20`:
first-touch 6, 44, 48, then never for `d ≥ 3`; **no depth certifies
stably**; best-ever error from `d = 2` on never enters 0.5 at any
truncation. Background: 9/18 defined `d = 1` cells certify (median
stable K 304), 1/16 at `d = 3`, 0/13 at `d = 6`. The one certified
target, `(4,1)`, first touches at `K = 1` and pops out six times
before settling at 32 — the stable-K definition did real work, and
transient dips are pervasive across the background.

**The caveat that bounds the reading.** `|err|` GROWS from `K ≈ 200`
to 600 at every depth (`d = 0`: 1.38 → 8.31) — O34's non-monotone
convergence under a sharp cutoff. So "uncertified at 600" at `r = 20`
is partly the truncation scheme. The depth trend itself is clean:
terminal error monotone 8.3 → 104.3 across `d = 0..6`.

**Read jointly with O93** (entry 205): the spectrum cannot certify
the deep zero at any measured rate, and the phase statistic cannot
see cancellation at all. The certification arrow of entry 201 —
arithmetic pins what the spectrum cannot reach — **survived its
falsification test**: a bounded small K at `(20,6)` would have
killed it, and K is unbounded at this truncation with the error
still growing.

**What would sharpen it:** a smoothed truncation (Gaussian or
Cesàro weights) separates "sharp-cutoff artifact" from "depth
barrier" — if `(20,6)` stays uncertified under smoothing, the
barrier is real.

---

## 2026-08-27 — Entry 202 — O92: certification cost, run
type: run
refs: 192, 193, 201

`O92_certification_cost.py`, EXPLORATORY. Entry 201 item 1: minimum
K zero pairs pinning cell `(r,d)` to within ±0.5 of its integer.

```text
.venv/bin/python utilities/run.py --python .venv/bin/python \
    --log results/O92_certification_cost_run1.log O92_certification_cost.py
exit 0   script sha256 7398fd60…   git HEAD 9f15149 (dirty)
manifest results/runs/20260827T041704Z_O92_certification_cost.json
```

**Six-value gate printed first:** `Δ^(d+1)` reproduces all six
kernel values, `Δ^d` none; the script hard-exits on mismatch.

**Definitions.** `K_first` = smallest K with `|M + S_K − cell| <
0.5`; `K_stable` = smallest K certified at every larger `K' ≤ 600`.
Main term `M = Δ^(d+1)R(2^·)` (see entry 203 for why); li column
alongside. π form primary; ψ cross-check on ψ's own table, labelled
non-integer parallel-behaviour only.

**Targets:** `(2,1)` MODEL-UNDEFINED (`Ei` at `x = 1`). `(4,1)`
K_first 1, K_stable 32 — the only certified target, outside regime.
`(8,3)` K_first 2, UNCERTIFIED, terminal 1.90. `(20,6)` no touch at
any K, UNCERTIFIED, terminal 104.3. Controls: `(7,3)` UNCERTIFIED
1.57; `(19,6)` K_first 260, pops out, UNCERTIFIED 2.40.

**d = 0 sanity:** `r = 20` residual_R −24.886 against O34's stored
−24.886; `r = 15` −6.35.

**Precision:** all 11 headline cells at dps 80 — zero K moves, error
shift 0.00e+00. `pi2n_cache.json` reaches `n = 62`, so the brief's
r ≤ 20 scope was conservative rather than cache-bound.

Results `results/certification_cost.json` via `guarded_write`; log
via run.py `--log`. Reading is entry 203.

---

## 2026-08-27 — Entry 201 — joint reading of the Shannon/GUE/zeta artifacts; two instruments approved
type: motivation
refs: 103, 193, 196, 199, 200

A read-only agent was pointed at the information-theoretic artifacts —
`lean/Nyquist.lean`, `lean/Chain.lean`, O90/O91, O64, O25, O34, O45's
JSON, O47's JSON — with Julian's frame (the table, Shannon and the
zeta zeros as the container) and asked what they imply jointly.
EXPLORATORY throughout; the report is chat-side, this entry keeps what
is load-bearing.

**Joint inferences.**

1. *A table zero is a phase event in a fixed ensemble.* O91's
degenerate arm proves the magnitude profile at fixed depth is
identical at every `r`; the only degree of freedom separating
`(20,6)` from `(19,6)` is phase. O90 measures the outcome: the zero
is a large aimed residual — net `|S| = 4344.9` landing exactly on
what the pair identity demands, at the 79th percentile of Neff.

2. *The certification arrow runs from arithmetic to spectrum.* O25:
one zero buys 10% relative accuracy nearly free; integer-exact
accuracy INVERTS at `x = 1030`, 4.07 zeros per prime at `x = 10⁴`.
O34: 600 zero pairs recover only 80–86% of the `d = 6` residual,
non-monotonically. A table zero is integer-exact, so the count
certifies it for free while the zeta code approaches at unbounded
rate. The cell is a constraint ON the spectrum rather than a readout
FROM a truncation.

3. *O64 run 1's sharpest number, restated for export:* a Poisson arm
entered the pipeline at `frac<0.5 = 0.372` and exited at **0.102**,
where GUE is 0.106. A resolution-limited channel fabricated level
repulsion within 0.004 of the GUE value from memoryless input. The
class is known (missing-level corrections, Bohigas–Pato); the
instance is sharp. The near-coincidence with GUE itself needs a
band-dependence check before it is ever quoted.

4. *Density and mass choose different bases* (O47 × O45): exact-zero
density rises monotonically with coarseness and peaks at base 2; MASS
peaks off it — `√2` holds ranks 1 and 2 (`S = 1,371,038` and
`651,298`) against `(20,6)`'s third at `492,384`. Base 2 is the
boundary of the exact-zero phenomenon rather than its center of mass.

5. *Unexamined micro-fact, verified in the JSON:* O47's
`top_window_overlaps` — `√2 (34,11)`, the pooled rank-1 zero,
overlaps `2 (20,6)` by 3.0 log₂ units, 0.545 of the shorter window;
`√2` is base 2's degree-2 refinement exactly. Two of the three
heaviest cancellations in the census sit on overlapping stretches of
the prime field seen by a ladder and its half-step refinement. The
same table holds two pairs at `frac_of_shorter = 1.0` — full
containment — also never examined.

**Novelty, priced.** The stencil-lattice = aliasing-lattice identity
is synthesis of known halves (Flajolet's lattice; Shannon), proved at
both ends in the kernel. O25's curve is textbook truncation economics
re-measured. The zero-as-aimed-net and density/mass split are novel
at object level, standard in depth. Nothing here touches a recognized
open problem: Montgomery/GUE is touched at n = 37 through a
verified-faithful channel; RH is not moved.

**LLM-side exports, priced as experiments not results:** RoPE is a
geometric frequency ladder, so `Nyquist.aliases_of_offset` transfers
verbatim to positional encodings, with O18's blind-singly /
sighted-jointly result as the tested prior; O91's degeneracy audit
transfers to residual-stream Neff measurements (LayerNorm pins norms
the way the ψ form pins `|z|`); and published RMT-spectra claims about
neural nets, made through Lanczos-class estimators, owe a three-arm
O64-style audit.

**Approved by Julian, in order:**

1. **O92 — certification cost.** For each cell, the minimum K such
   that the K-zero model pins `Δ^(d+1)π(2^·)` to within ±0.5. O34's
   sign-flip at `(25,21)` predicts K blows up with depth; **a bounded
   K at `(20,6)` falsifies inference 2**, which is what makes it a
   test.
2. **O93 — the overlap identity.** O90's modes generalized to base
   `√2`; circular phase correlation between `√2 (34,11)` and
   `2 (20,6)` against matched-depth background pairs. Positive means
   one cancellation event seen at two resolutions. **The √2 table's
   stencil convention must be verified against known cells before
   any mode is built** — entry 192's exponent trap, new base.

---

## 2026-08-27 — Entry 200 — this bench's correction entries are load-bearing for a kernel-checked claim about generators
type: result-triage
refs: 146, 177, 195, 199

Adversarial round on a foreclosure — "zeta's zeros say nothing about
transformers" — asked in chat and withdrawn. Three facts about the
tree came out of it and they outlast the sentence that prompted them.

**1. Primebeat's record already bears on claims about language
models, by name, in a Lean-gated ledger.**
`the_container/adjudications/claims/001_external_verification.md`
holds an argument whose theorems `no_internal_only_sound` and
`sound_overrules_somewhere` stand on one premise, `P1`: *some claim
feels right and is incorrect*. Its discharge route reads

```text
Discharge route: empirical, and already witnessed. Any dated
instance of a confident claim later corrected discharges it; the
provenance program logged several in one week (a section declared
absent that was present; a bound mispriced by two orders; a stated
hypothesis found unsatisfiable — see the Primebeat notebook's
correction entries).
```

The first witness named is `§ B4`, from this project's `CLAUDE.md`
§ Rule — load, don't recall. **So a statement of the form "no
measurement on this bench bears on generators" is false at the
`P1` leaf**, and the notebook's correction entries are the artifact
doing the work. That is a use of this record nothing here had
recorded.

**2. Transformer machinery sits in the tree's dependency closure.**
`lean_stage3/.lake/packages/leancert/LeanCert/ML/` carries
`Attention.lean`, `Softmax.lean`, `LayerNormAffine.lean`,
`Network.lean`, `Distillation.lean`, `ErfGELU.lean`. It is **not
load-bearing** — `grep -rn 'LeanCert' lean_stage3/Stage3/*.lean`
returns nothing, and Stage3 requires only PrimeNumberTheoremAnd. It
is present, so a flat "nothing about transformers is in this tree"
is the `§ B4` error a third time.

**3. The bench has a transfer template and it is not a sentence.**
`papers/convergence.md` with `O40_elliptic_symbol_zeros.py` and
`O41_bsd_rank_product.py` answered "does this construction transfer
to elliptic curves?" by deriving the new object's symbol and
measuring where it vanishes:

```text
A4. Therefore the transfer to the Selberg class is not verbatim.
The operator's order tracks the local factor's degree, and only
degree-1 L-functions give a plain difference table.
```

with `Re(s) = 0.5000` measured at every curve-prime pair. **Any
future "does this bear on X" gets that shape** — derive the object's
symbol, price what would have to hold, measure or say the bench
cannot. A limiting statement without one is what the root scope-pricing
rules already call a consensus echo.

**The withdrawn sentence.** "Zeta's zeros say nothing about
transformers" was asserted with no measurement, from an instrument
whose ceiling is `γ ≤ 939` and 600 modes. Withdrawn. Entry 199 holds
the defensible shape for a limiting claim about the Shannon result:
**large in scope, standard in depth** — `base_bound_of_resolvable`
rules out every integer base for `γ₁`, and both halves of the
lattice identity reduce to `b^(−s) = 1`.

**Open.** `notes/NOTEPAD.md` carries entry 144's kernel-for-meaning
posit — Lean as adjudicator in LLM discourse — flagged for a paper's
methodology section. Fact 1 is its first live instance and the two
threads had not been connected.

---

## 2026-08-27 — Entry 199 — O45's winding angle IS the resolvability condition; and the split that would test it cannot be run on this data
type: result-triage
refs: 26, 195, 198

Julian asked whether the Shannon finding was being undersold. Checking
it found a structural identity nobody had recorded, and then found that
the obvious test of it is confounded by construction.

**The identity.** O45's eleven bases are `b = exp(πk/(2γ₁))`, selected
so the winding angle `θ = γ₁·log b` lands on a stated value —
`papers/Commensurate-Ladders.md` § D4, citing
`Euler-Factor-Chain.md` § D4. `Nyquist.base_bound_of_resolvable` gives
resolvability as `γ·log b < π`. **In O45's own coordinate that
condition is exactly `θ < 180°`.** The family straddles the boundary
and the boundary is itself a family member, `k = 2`,
`b = exp(π/γ₁) = 1.248897`.

`Commensurate-Ladders.md` contains one occurrence of
nyquist/resolvable/alias in the whole document. § D4 caught that the
set shares a lattice and records that nothing in the prereg noticed;
the same parameter carrying the resolvability threshold went unnoticed
as well.

**Where the bases actually fall**, with `θ` unwrapped — the JSON's
`theta_deg` is taken mod 360, which puts base 2 at 201.35° when its
true angle is 561.35°:

```text
             label        b    θ_true      side   res.cells  zeros   z/cell
 exp(pi*1/(2*g1))   1.1175     90.00   RESOLVE       14028     29  0.00207
 exp(pi*3/(4*g1))   1.1814    135.00   RESOLVE        6441     21  0.00326
 exp(pi*2/(2*g1))   1.2489    180.00     LIMIT        3828     14  0.00366
         2**(1/3)   1.2599    187.12   ALIASED        3570      3  0.00084
 exp(pi*5/(4*g1))   1.3203    225.00   ALIASED        2556     15  0.00587
 exp(pi*3/(2*g1))   1.3957    270.00   ALIASED        1770      9  0.00508
         2**(1/2)   1.4142    280.68   ALIASED        1711     11  0.00643
 exp(pi*7/(4*g1))   1.4754    315.00   ALIASED        1378     10  0.00726
 exp(pi*4/(2*g1))   1.5597    360.00   ALIASED        1035      7  0.00676
 exp(pi*9/(4*g1))   1.6489    405.00   ALIASED         861      2  0.00232
                2   2.0000    561.35   ALIASED         496      4  0.00806
```

**The proposed split cannot be run on this data, and the reason is
structural.** `θ = γ₁·log b` is strictly increasing in `b`, so
splitting at `θ = 180°` **is** splitting at `b = 1.248897`. The angle
carries no information the base does not. And the whole table varies
monotonically along that same axis — resolved cells fall 14028 → 496
in `θ` order — so a level difference between the groups is what a
smooth trend in `b` produces anyway. O45 returned `fineness` on
precisely such a trend, and O46 refuted the `density ≈ 1/S` mechanism
for it without removing the trend itself.

Two bases below the line, one on it, eight above. **A threshold and a
trend are not separable at n = 2 against a monotone background.**

The numbers, recorded with that stated: resolvable mean `z/cell`
0.00267 against aliased mean 0.00533. **Do not read this.** It is the
same ordering the cell count already imposes.

**What would separate them.** A discontinuity rather than a level
difference: bases sampled densely on both sides of 1.248897, close
enough that the smooth trend is locally flat, testing whether the
statistic steps at the boundary. That is a new scan, and it is
cheap — the machinery is O45's.

**One hint, at n = 1, offered as a hint.** `2^(1/3) = 1.2599` sits at
`θ = 187.12°`, the closest base above the boundary, and carries
`z/cell = 0.00084` — the lowest of all eleven, below both resolvable
bases and a factor of four under its neighbours on either side. It is
also an integer-root base rather than a family member, so it differs
in two ways at once. It is the cell the dense scan should bracket.

**On the original question.** The Shannon finding was undersold in
scope: `base_bound_of_resolvable` rules out **every integer base** for
γ₁, since Nyquist falls as base rises and base 2 already misses by
three. Entry 26 held that as THEOREM-SHAPED and unformalised. It was
not undersold in depth — both halves reduce to `b^(−s) = 1`, and a
difference filter having nulls at the sampling harmonics is standard.

---

## 2026-08-27 — Entry 198 — run.py reported success while its guarantee failed; --log, and a warning for the case it cannot prevent
type: instrument-fix
refs: 166, 183, 196

`utilities/run.py`. Found from entry 196's zero-byte archived log, and
the defect is worse than that symptom.

**The failure.** A shell creates and truncates a redirect target
**before** the command in the pipeline starts. So
`run.py ... | tee` into a log under results/ truncates that log, then run.py clones
`results/` and snapshots an already-empty file. If `X.log` held a prior
run, tee destroyed it, the clone preserved the emptiness, the archive
faithfully stored a zero-byte "prior version", and run.py printed

```text
  archived prior X.log -> results/archive/X_<utc>_e3b0c442.log
```

`e3b0c442` is the sha256 prefix of the empty string. **run.py reported
success on the exact case it exists to protect.** Entry 166 built this
machinery because O63, O65 and O66 each lost run 1 to a re-run; this is
that same loss with a success message on top.

**The fix, four parts.**

1. `--log PATH`. run.py captures the child's combined stream, echoes it
   and writes it, **opening the file after the snapshot**. A real prior
   log therefore reaches the clone and is archived. This replaces `tee`
   entirely.
2. A warning naming every results file that is empty at snapshot time,
   since prior contents are already gone by then and no archive can
   recover them.
3. `empty_at_snapshot`, `log` and `log_sha256` recorded in the manifest,
   so the condition is in the record rather than only on a terminal.
4. `PB_RESULTS_DIR` overrides the results root. A guard that cannot be
   exercised without writing junk into the thing it guards is a guard
   nobody tests — and this one had never been tested against a
   pre-populated file.

**Both paths measured**, in a scratch tree with a log holding
`RUN 1 OUTPUT - the prior run nobody wants to lose`:

```text
A  --log         archive contains RUN 1 OUTPUT          fix works
B  | tee         archive contains 0 bytes               loss still occurs
                 + WARNING naming demo.log              now loud
                 + NOTE that piping is unprotected
                 + manifest empty_at_snapshot ['demo.log']  now recorded
```

**What the fix does not do.** Under `tee` the loss is unpreventable by
run.py, because the shell acts first. Part 1 gives a path where it
cannot happen; parts 2–4 make the remaining case loud and dated instead
of silent and congratulatory.

**Re-run, and prior results stay comparable.** O91 re-executed through
the fixed path with `--results-dir` at a scratch tree, and every
scientific field is identical to `results/mode_entropy.json` —
`background`, `percentiles`, `r_invariance`, `o90_gate`, `neff_vs_pr`.
The one differing field is `precision_check_rel`, differing because the
verify run passed `--no-precision-check`. **Entries 196 and 197 stand
unchanged.**

The zero-byte artifact from the original incident stays in
`results/archive/` — `.log` files are not deletable under this
project's permissions, and it is now the dated evidence of the defect.

---

## 2026-08-27 — Entry 197 — 172 modes of 600, and the vacuous combination is now identified rather than argued
type: result-triage
refs: 192, 194, 195, 196

Reading of entry 196. EXPLORATORY.

**Entry 194's correction is now measured.** That entry argued the
vacuousness trap applies to `|z_k|` and not to `|c_k|`. O91 tested all
four combinations and confirmed every one:

```text
ψ  Neff_z   predicted IDENTICAL   max rel spread  0.000e+00
ψ  Neff_c   predicted VARIES                      4.437e-01
π  Neff_z   predicted VARIES                      6.988e-02
π  Neff_c   predicted VARIES                      4.016e-01
```

**So the vacuous combination is exactly one of four, and it is now
named.** ψ-form entropy on the `|z|` profile is fixed by depth alone —
276.702823 at all 29 cells of `d = 1`, 220.974873 at all 27 of `d = 3`,
175.666865 at all 24 of `d = 6`, max minus min exactly zero at dps 50
with 15 digits of margin. On that profile `(8,3)` and `(7,3)` carry the
same number, and so do `(20,6)` and `(19,6)`: it **cannot** separate a
zero from a non-zero, by construction rather than by outcome. The other
three profiles can.

**The headline is a number the question needed and did not have.** At
`(20,6)`, `Neff = 172.0` out of 600 — about 29% of the summed modes
effectively participate. A localized reading, where a table zero is one
zeta zero showing up, needs `Neff` of order 1. It is 172.

**Direction agrees with O90.** The exact zero has the higher `Neff`:

```text
        ψ |c|      π |c|
(20,6)  172.045    172.243
(19,6)  162.788    157.359
ratio     1.057      1.095
```

and the same holds a depth down, `(8,3)` 197.91 against `(7,3)` 182.10.
O90 found the zero less cancelled; O91 finds it spread over more modes.
Both say the **non-zero control is the more concentrated cell**, which
is the second time that has come out backwards from what entry 192
predicted.

**Depth concentrates.** Median `Neff/600` falls 0.4020 → 0.3133 →
0.2502 across `d = 1, 3, 6` (ψ `|c|`), because `|1 − 2^(−ρ)|^(d+1)`
carries `d` and does not cancel under normalisation. The invariance is
per-depth rather than global.

**The truncation caveat, and it is unmeasured.** `p_k` normalises over
the first 600 modes, so `Neff` is a statement at `N = 600`. If `|c_k|`
decays slowly the tail keeps contributing and `Neff` grows with `N`.
O90 measured its coherence against `N` and flagged the result
one-sided; **O91 did not measure `Neff` against `N`**, and until it
does, 172 is a truncation-dependent figure. The ratio 1.057 is safer,
since both cells are truncated identically. Measuring `Neff(N)` is the
next thing to do to this instrument and it is cheap.

**Two estimators, agreeing on order and not on level.** `PR ≤ Neff` at
all 157 defined background cells, rank correlation exactly 1.000 on
both `|z|` profiles and 0.862 / 0.856 on the `|c|` profiles, with `PR`
about 2.6× below `Neff` throughout and that ratio itself varying by
~1.95× across cells. Different Rényi orders, behaving as they should.

---

## 2026-08-27 — Entry 196 — O91: mode entropy and effective mode count
type: run
refs: 192, 194, 195

`O91_mode_entropy.py`, EXPLORATORY. Extends O90 — it **imports** O90's
mode classes rather than re-deriving them, and records O90's sha256 as
`params.mode_source_sha256` (`f2b2788c…`, matching entry 193's script
hash).

```text
.venv/bin/python utilities/run.py --python .venv/bin/python O91_mode_entropy.py
```

```text
dps 50   nzeros 600   depths 1,3,6   rmax 30   forms psi,pi
profiles |c_k| and |z_k|      zeros_file zeros600.json
script sha256 c9c82ffb9c0a5bb9146b5113582b4b2da35bb630be63276896b5a9a7c03c1a32
results sha256 fcae817ef577c4098a69981e8da382fabc9a8cfadb6179b0744bb9229ce44fbe
git HEAD 5eae9f2 (dirty)   exit 0   4.7 s
manifest results/runs/20260827T023508Z_O91_mode_entropy.json
```

`p_k = |c_k| / Σ|c_j|`, `H = −Σ p_k log p_k`, `Neff = exp(H)`; the same
on `q_k = |z_k| / Σ|z_j|`; plus `PR = (Σ|c_k|)² / Σ|c_k|²`. Reference
poles: `Neff = 600` if every mode contributes equally
(`H = log 600 = 6.396930`), `Neff = 1` if one carries everything.

**Targets and controls, `Neff` and `Neff/600`:**

```text
  cell  lean     role   Neff(ψ|c|)  /600   Neff(π|c|)  /600   Neff(ψ|z|)
 (2,1)     0     zero     251.245  0.4187    undefined     -     276.703
 (4,1)     0     zero     241.201  0.4020      233.151 0.3886    276.703
 (8,3)     0     zero     197.909  0.3298      191.621 0.3194    220.975
(20,6)     0     zero     172.045  0.2867      172.243 0.2871    175.667
 (7,3)     5  control     182.101  0.3035      170.009 0.2833    220.975
(19,6)   343  control     162.788  0.2713      157.359 0.2623    175.667
```

`(2,1)` is null in the π form for O90's reason — the `Δ^(d+1)` stencil
reaches `x = 1` and `Ei(ρ·log 1) = −∞`. `(2,1)`, `(4,1)`, `(8,3)` and
`(7,3)` are labelled outside the regime where the explicit formula
tracks `π`; `(20,6)` with `(19,6)` is the pair inside it.

**Gates.** Coherence recomputed from the imported classes reproduces
`results/mode_coherence.json` at **0.00e+00** relative disagreement
across all 11 defined cell-form pairs. `--precision-check` at dps 80
gives max relative disagreement **0.00e+00** on both `H` and `Neff`
across 22 cell-form-profile triples. `check_refs` exits 0.

**Three instrument findings.**

`tee` into `results/` collides with `utilities/run.py`'s archive step.
tee truncates the log at pipeline start, so run.py's clone captured an
empty file and archived it as a prior run —
`results/archive/O91_mode_entropy_run1_20260827T023508Z_e3b0c442.log`,
zero bytes, `e3b0c442` being the sha256 prefix of the empty string.
Nothing was lost. Teeing outside `results/` and moving afterward avoids
it. **Unfixed.**

The percentile of an r-invariant quantity is degenerate and reads as
informative — ψ `|z|` gives 0.0% at every cell under strict-less-than
with 24 of 24 ties. Marked DEGENERATE in the output rather than printed
bare.

O91's gate against O90 needed an `nzeros` guard: a 15-zero smoke run
reported a 4.65e+00 mismatch against O90's 600-zero stored values. It
now reports NOT COMPARABLE instead of manufacturing a failure. Four
smoke manifests from that session sit in `results/runs/`, all
`--no-json`, all created 0 files.

Reading is entry 197.

---

## 2026-08-26 — Entry 195 — the stencil is an Euler factor; its zeros are the ladder's blind spots; two tests queued
type: motivation
refs: 26, 103, 192, 194

Julian: "what if the stencil is the shape of the zeta zero — the
zeros were steep walls at a slope because it's the container for
everything in every cell in the prime composite side plus the static
structure?" Then: what does this mean about information, and does the
zero ensemble connect to GUE?

**Three of his four terms are in the tree already.**

*Container.* `lean/PairIdentity.lean`'s `pair_identity` docstring:
prime + composite = `(b−1)^(d+1)·b^(r−1−d)`, and "the identity is
forced by the partition alone, and the whole content of the
prime/composite split is that it is a partition of a geometric row."

*Static structure.* `papers/Euler-Factor-Chain.md` § E2/E4. Zeroing
the counts of 2, 3, 5 leaves `(8,3)` and `(20,6)` exactly 0 (O30);
**excising** 2, 3, 5 from the line destroys both, `(20,6)` reading 70
after three integers are removed from 4×10⁶ (O31). § E4: a difference
cell is blind to how many primes lie below it and sensitive to where
they sit.

*The stencil's shape.* § A3: on the `b`-ladder, `Δ` is multiplication
by `1 − b^(−s)`; § A4 gives depth-`d` differencing the symbol
`(1 − b^(−s))^(d+1)`. `lean/Chain.lean`:29 defines that object and its
docstring names it **the reciprocal Euler factor at `b`**. So the
stencil's shape has a name, and differencing on the `b`-ladder divides
base `b`'s factor out of the Euler product.

**Provenance gap, recorded rather than reconstructed.** "Steep walls
at a slope" is not in this tree. Grepped every `.md` and `.py` for
steep, wall, slope, container, static — the only walls are wall-clock
timings and O81's aliasing wall. Either it comes from a session that
was never logged, or it is Julian's own picture of something the
record names differently. Left open; do not invent a referent for it.

**The sharpening, and it is the strongest form of the Shannon link.**
`Chain.sym_eq_zero_iff` proves `Sym b s = 0` exactly on
`s ∈ (2πi/log b)·ℤ` — an evenly spaced lattice on the imaginary axis,
where zeta's zeros are irregular and on `Re = ½`. Different sets. But
that lattice spacing is the same `2π/log b` as
`Nyquist.aliases_of_offset`. **The frequencies the stencil annihilates
are exactly the frequencies the sampling cannot see** — two theorems,
one lattice, from opposite sides.

**What is established about information.** (i) Stopband and blind
spots coincide, above. (ii) `base_two_fails_by_three`: base 2 runs
entirely above its own Nyquist frequency, so which-zero-is-which is
**absent from the samples** rather than hard to extract. (iii) § E4
plus `stencil_annihilates_const`: the channel discards the level and
keeps the arrangement. (iv) Entry 194: ~90% of mode mass cancels at
every cell, uniformly.

**What is missing is that none of it is an information measure.**
Coherence `|S|/A` is an alignment ratio. `|c_k|/A` is already a
probability distribution over modes, so `H = −Σ p_k log p_k` and the
effective mode count `exp(H)` are one small extension of O90 — and
entry 194's correction says that measure varies with `r` rather than
being vacuous, which is what makes it worth running.

**GUE has been asked here, and the first attempt failed instructively.**
`O64_gue_spacing.py`: run 1's instrument **manufactured** the
repulsion — Poisson-placed frequencies entered at `frac<0.5 = 0.372`
and exited at 0.102, on top of GUE's 0.106 — and its conclusion was
withdrawn in entry 103. Run 2, band `(10,120)`: real `n = 37`, mean
`s` 1.003, `frac<0.5` 0.027, matching the true zeros' direct values to
three decimals.

**That is not a GUE confirmation and must not be cited as one.** GUE
predicts 0.106; both the detected peaks and the true zeros give 0.027
in that band. O64 established that the instrument reads the zeros
faithfully there. Montgomery–Odlyzko agreement is asymptotic, tested
near height 10²⁰; this tree has `γ ≤ 939`.

**Our own zeros cannot carry a spacing statistic.** Four zeros, three
gaps. The only ensemble large enough is O45/O47's **125 pooled
resolved zeros across eleven bases**, and `papers/The-Zero-Surface.md`
has already run nearest-neighbour distance on them against a
width-matched null: § G2 records `z = −5.32` and says plainly that it
cannot be read.

**Two tests queued, entropy first by Julian's call.**

1. **O91 — mode entropy.** `H` and `N_eff = exp(H)` over the mode
   distribution, both explicit-formula forms, on `|c_k|` and on
   `|z_k|` separately since entry 194 showed those behave differently.
   Same cells as O90. Reference points: `N_eff = 600` if all modes
   contribute equally, `N_eff = 1` if one carries everything.
2. **The 125-zero ensemble.** Whether a repulsion question can be
   asked honestly of it at all, given § G2 already declined to read
   the one statistic run on it. Design before measurement, and O64
   run 1 is the standing warning: any pipeline with finite resolution
   fakes repulsion, so the null has to enter through the same pipeline.

---

## 2026-08-26 — Entry 194 — the zeros are ordinary and the control is the anomaly; a design claim of mine was half wrong
type: result-triage
refs: 26, 112, 192, 193

Reading of entry 193's numbers. EXPLORATORY throughout — no prereg
governs O90 and nothing here is a verdict.

**Correction to entry 192.** That entry argues a concentration
statistic on mode magnitudes is vacuous by construction, because the
magnitude factors as `2^(r/2) · |1 − 2^(−ρ)|^(d+1) / |ρ|` with `r` in a
common scale. **That is a statement about the complex modulus
`|z_k|`. The statistic runs on `|c_k| = 2|Re z_k|`, which carries
`cos(arg z_k)`, and the argument depends on `r`.** Measured both ways:

```text
                     max |Δ profile| across cells of one depth
ψ  |z|   d=1/3/6      1.3e-51   5.0e-52   1.7e-51     r-invariant
ψ  |c|   d=1/3/6      4.5e-02   8.8e-02   1.3e-01     r-dependent
π  |z|   d=1/3/6      1.7e-03   4.3e-03   3.2e-03     r-dependent
π  |c|   d=1/3/6      5.8e-02   1.0e-01   1.2e-01     r-dependent
```

`top1` on the ψ `|z|` profile is r-invariant to every printed digit —
8.740549e-02 at all 24 cells of depth 6. On `|c|` it ranges 3.70e-02 to
1.30e-01 over those same cells. **So top-1 share was a perfectly good
statistic and I argued us out of it for a reason that does not apply
to it.** The vacuousness trap is real and its scope is one quantity
narrower than entry 192 claims. The π form additionally makes `|z|`
itself r-dependent at ~3e-3, since nothing factors there.

**The prediction I stated failed.** Entry 192 says Nyquist implies no
small subset of modes should be able to do the work, so the zeros
should read as maximally cancelled. What the run says is that
**every** cell is maximally cancelled — coherence spans 0.003 to 0.20
across all 158 cells at all three depths, medians 0.073, 0.105, 0.112.
Around 90% of mode mass cancels everywhere. The ensemble picture holds
and it holds so uniformly that it separates nothing.

**Where it does separate, it runs the other way.** The exact zero
`(20,6)` is LESS cancelled than the non-zero `(19,6)`, 2.17× in ψ and
2.50× in π. Against its own depth `(20,6)` sits at the 50th percentile
and `(19,6)` at the 21st. The separation is the control sitting low.
`(20,6)` is ordinary.

**Why that is less strange than it reads.** The model carries the
oscillating part alone, so at an exact zero the mode sum must equal
`−M`, the li-stencil main term. Coherence at a zero is therefore
identically `|M| / A` — the main term as a fraction of total mode
mass, 11% here. The statistic at a zero measures the size of the
smooth term, and the question entry 192 wanted to ask is not answered
by it.

**The convergence caveat is one-sided.** At `(20,6)` the net settles
by `N = 100` to within 4% (π: −363.5, −362.7, −365.6, −349.1) while
the mass `A_N` nearly doubles, 1640 → 3130. Coherence falls purely
because mass accumulates against a fixed net, so **0.116 is an upper
bound** on the `N → ∞` value and the 2.17× / 2.50× ratios are
statements at this truncation. At `(19,6)` the net itself still swings
±25% out to 600, so that cell is not converged in either quantity.

**What would sharpen it.** The comparison entry 192 was reaching for
is `|M| / A` against a background of `|M|` at non-zero cells — which
requires computing the li stencil, which O67 already does. Coherence
answers it only at cells that are exactly zero, which is four cells,
three of them outside the regime. A statistic that separates zeros
from non-zeros has to survive the fact that a zero is defined by the
main term being cancelled, and this one does not.

---

## 2026-08-26 — Entry 193 — O90: mode coherence at the four zeros, in both explicit-formula forms
type: run
refs: 26, 112, 192

`O90_mode_coherence.py`, EXPLORATORY. Built and run tonight against
entry 192's design, with the `Δ^(d+1)` index correction that entry now
carries.

```text
.venv/bin/python utilities/run.py --python .venv/bin/python O90_mode_coherence.py
```

```text
dps 50   nzeros 600   rmax 30   depths 1,3,6   forms psi,pi
sn_points 25,50,100,200,400,600   zeros_file zeros600.json
script sha256 f2b2788c52968dfc1e9120f5e2976e828f47486d0e224d871e4369379eafb1d1
git HEAD 415156f (dirty)   exit 0
manifest results/runs/20260826T230545Z_O90_mode_coherence.json
```

**Headline.** Coherence is `|Σ c_k| / Σ|c_k|` over 600 zero pairs;
`top1` is `max|c_k| / Σ|c_k|`.

```text
    cell   lean     role     coh(ψ)    top1(ψ)     coh(π)    top1(π)
  (2, 1)      0     zero   0.017595   0.043479  undefined          -
  (4, 1)      0     zero   0.085239   0.085204   0.074913   0.084093
  (8, 3)      0     zero   0.093093   0.074394   0.104558   0.080963
 (20, 6)      0     zero   0.116337   0.056178   0.111559   0.056860
  (7, 3)      5  control   0.152474   0.096702   0.169247   0.102656
 (19, 6)    343  control   0.053653   0.053713   0.044549   0.053743
```

Background over `r = d+1 … 30`, coherence min / median / max:

```text
ψ  d=1  29 cells  0.00315  0.07309  0.16495
   d=3  27 cells  0.00153  0.10492  0.18502
   d=6  24 cells  0.00467  0.11310  0.19520
π  d=1  28 cells  0.00755  0.07364  0.15950
   d=3  26 cells  0.00490  0.10410  0.18240
   d=6  23 cells  0.00546  0.11160  0.20140
```

**Regime.** `(2,1)`, `(4,1)`, `(8,3)` sit at `x = 4, 16, 256` and
`(7,3)` at `x = 128` — outside the range where the explicit formula
tracks `π`. `(20,6)` with `(19,6)` is the one target inside it.

**The π form is undefined at `(2,1)`.** The `Δ^(d+1)` stencil reaches
`m = 0`, `x = 1`, and `Ei(ρ·log 1) = Ei(0) = −∞` for every zero. Also
kills the first cell of each background row. Reported null with the
reason, nothing dropped silently.

**Cross-validation against O34, and it is exact.** Running O34's own
construction against `zeros600.json` at matching truncations
reproduces its stored values to seven digits — `NZ = 200` gives
0.799851 against O34's 0.799850857, `NZ = 500` gives 0.861825 against
0.8618248546 — and at `NZ = 600` gives `T(20,6) = −349.121259`,
identical to O90's π-form `S(20,6) = −349.1213`. **The π column is
O34's object reached by a different construction**, so O34/O35's
94% / 92% / 80% regime figures are directly citable against it. The
600-pair ratio is 0.7700, a fourth point on O34's documented
non-monotone curve (0.8953 at 50, 0.7999 at 200, 0.8618 at 500).

**Precision measured rather than asserted.** A built-in
`--precision-check` recomputes all 11 cell-form pairs at dps 80: max
relative disagreement **0.00e+00**. The zero strings carry ~25
significant digits, which is the floor no working precision improves
on; argument reduction at `r = 30, γ₆₀₀` costs 5 digits, the `2^15`
scale 5 more, 600 summed terms ~3, the π form's `Δ⁷` binomial weights
2–3 — leaving ~37 digits of headroom under a ~24-digit data floor.

Results `results/mode_coherence.json` via `guarded_write`,
`allow_nan=False`; log `results/O90_mode_coherence_run1.log`. Reading
is entry 194.

---

## 2026-08-26 — Entry 192 — are the four zeros an ensemble cancellation or a localized one? O90 exists to ask
type: motivation
refs: 26, 78, 112

**Julian's question, in his words:** could zeta zeros be a localized
instantiation of the four zeros in our table, each zero a check to
pass to zeta — with the backward-difference table read as the choice
the number line makes to become discrete counting blocks, and the
whole thing correlated to Shannon.

**Three parts of it the tree already answers.**

The Shannon link is a theorem here as of today, rather than an
analogy. `lean/Nyquist.lean` is the sampling theorem for this bench:
`nyquist b = π / log b` is the highest frequency a `b`-adic ladder
carries, `aliases_of_offset` proves `γ` and `γ − 2πk/log b` are
indistinguishable on it, and `base_two_fails_by_three` proves
`3 · nyquist 2 < 14` — base 2 is past its own Nyquist frequency before
it reaches `γ₁ = 14.13`, by a factor of three.

The "check to pass" half is the bench's conditional theorem with the
arrow drawn the other way. `papers/The-Four-Zeros.md` § I1: under RH,
`cell(r,d) ≠ 0` for every `r ≥ R(d) ≈ 5d + 11`. Contrapositive: a
fifth deep zero past that bound refutes RH. O43's census to `r ≤ 92`
is that check running, and it passes. His framing adds primacy — table
zeros as prior to zeta's — which nothing here establishes.

The base-relative half is measured. **O44**: of bases 2–9 only base 2
has exact zeros, and it has the same four, 1289 cells checked.
**O45**: preregistered sub-integer scan, mechanical output `fineness`,
with the scope caveat that the locked base set was commensurate by
construction. **O47**: base 2 is the density maximum and is not the
mass maximum.

**What is untested is the ensemble claim.** `Superposition` carries the
cell onto a reweighted sum over every zeta mode, so a table zero is a
cancellation across that sum. Whether the cancellation is carried by a
few modes or by the whole ensemble has never been measured, and
Nyquist makes a prediction about it: if base 2 cannot resolve any
individual `γ`, no small subset of modes should be able to do the
work. That prediction can fail.

**A vacuousness trap, found before writing code.** The per-mode
contribution to the depth-`d` backward difference at `x = 2^r` is

```text
c_k(r,d) = −2 Re[ 2^(r·ρ_k) · (1 − 2^(−ρ_k))^(d+1) / ρ_k ],   ρ_k = ½ + iγ_k
```

whose magnitude factors as `2^(r/2) · |1 − 2^(−ρ_k)|^(d+1) / |ρ_k|`. **The
r-dependence of the magnitudes is a single common scale.** So mode
magnitudes are identical at every cell of a given depth, and any
concentration statistic built on them — top-1 share, participation
ratio, entropy of the `|c_k|` — returns the same number at a zero and
at its non-zero neighbour by construction. It would have read as a
null result and been one only in the sense that nothing was measured.

`r` enters through phase alone. The statistic therefore has to be a
coherence measure: `|Σ c_k| / Σ|c_k|`, which is small exactly when the
modes cancel each other rather than adding.

**Correction, made before O90 was written.** This entry first gave the
exponent as `d`. It is `d+1`: `Zeros.dyadicRow` is already one backward
difference, `π(2^r) − π(2^(r−1))`, and `Construction.tableFrom` applies
`d` more, so cell `(r,d)` is `Δ^(d+1)` of `π(2^·)`. Checked against
`pi2n_cache.json` — the `Δ^(d+1)` column reproduces all six
kernel-proved values and the `Δ^d` column reproduces none:

```text
   cell     Δ^d   Δ^(d+1)   Lean
  (2,1)       1         0      0
  (4,1)       2         0      0
  (8,3)       4         0      0
 (20,6)     623         0      0
  (7,3)       4         5      5   nonzero_7_3
 (19,6)     623       343    343   nonzero_19_6
```

The index is not cosmetic. In a scratch diagnostic at 600 pairs the
target/control coherence ratio moves from 1.52× to 2.17×, and the
reading at the control flips: under `d+1`, `(19,6)` has coherence
0.05365 against `top1` 0.05371, so one mode carries essentially its
entire net. Coded as first written, O90 would have measured cells
`(2,0)`, `(4,0)`, `(8,2)`, `(20,5)`, `(7,2)`, `(19,5)` — none of them
an exact zero — and reported them under the zeros' names. The agent
built to this entry, derived the formula independently, and refused to
code the version it was given.

**One more thing that needs stating rather than assuming.** `c_k`
above is a mode of the **ψ** explicit formula, while the table counts
**π**. O34/O35's regime figures (94% / 92% / 80%) were measured in the
π form, `−Σ 2Re Ei(ρ log x)`, so transferring them to a ψ-mode sum is
approximate. O90 therefore computes **both** forms. For ψ the
factorisation above predicts the vacuousness result; for π nothing
factors, so whether magnitudes depend on `r` becomes an open
measurement rather than a prediction.

**O90 measures that**, at the four zeros against the two proved
non-zero neighbours `nonzero_7_3 = 5` and `nonzero_19_6 = 343`, plus
the full `d = 1, 3, 6` rows as background. EXPLORATORY, and it is a
power check before any prereg — entries 171, 173 and 174 set that
practice and it has killed one design and sized another.

**Known regime limit, from O34/O35.** The explicit formula reproduces
94% of the row-20 residual at `d = 0`, 92% at `d = 3`, 80% at `d = 6`,
and deep cells cannot be tested this way at all — at `(25,21)` the
model flips sign between 200 and 600 zeros. Three of the four zeros
sit at `r = 2, 4, 8`, where `x` is 4, 16 and 256 and the explicit
formula is nowhere near `π`. Those three are reported and are outside
the regime where the model tracks. `(20,6)` is the one target inside
it, with `(19,6)` as its control.

---

## 2026-08-26 — Entry 191 — three of the four dangerous tactics cannot be typed in a Mathlib-free module; the fourth is the silent one
type: formalization
refs: 59, 189, 190

Approved follow-on to entry 190. `lean/BUILD.md` gains the `grind`
warning and the § What is in here table now covers all 23 modules.

**The probe.** Each tactic on the same `ℤ` goal, compiled against core
with no Mathlib on the path:

```text
ring        unknown tactic
norm_num    unknown tactic
linarith    unknown tactic
grind       [propext, Classical.choice, Quot.sound]
omega       [propext, Quot.sound]
decide      no axioms
```

**This is sharper than the warning that was going to be written.**
The plan was "add a `grind` warning alongside the `ring`/`mul_sub`
one". The measurement says something better: `ring`, `norm_num` and
`linarith` **cannot be typed** in a Mathlib-free module. They fail
loudly at elaboration and cost nothing. Only `grind` compiles — and it
pulls in `Classical.choice`, which no ℤ or ℕ statement in this tree
otherwise needs.

So the hazard is not "four expensive tactics." It is **one silent
tactic among three noisy ones**, and the noisy three need no warning
at all because the compiler already gives it.

`PairIdentity.lean`:56-57 had the finding first — "`omega` is fine
(Quot.sound, not Classical.choice); `ring`, `grind`, `norm_num`,
`linarith` are not — `grind` costs Classical.choice even here." Right
about `grind`, and it lists three tactics as hazards that are not
reachable. The module-level comment was ahead of the build doc by
some months and no one had promoted it.

**`BUILD.md`'s `ring`/`mul_sub` bullet was filed where it cannot
apply** — under "Rules when editing a Mathlib-free module", where
neither name exists. Kept, since the lesson is real, and re-scoped to
say it applies when Mathlib *is* imported.

**The table.** Extended from 14 modules to 23, each line taken from
that module's own header rather than composed. Six marked NO MATHLIB.
Theorem-level detail deliberately not duplicated — it points at
`lean/THEOREMS.md`, which `utilities/theorem_index.py` generates and
keeps current, so the parallel stale table that made this correction
necessary cannot re-form.

Two things the earlier audit had slightly wrong, both caught by
checking rather than by reading the report. The missing-module list
was eight; it is **nine** — `TransferOp` was absent from it. And the
`Zeros` row still read "a zero is a repeat; window exclusivity; which
ladders meet" when `window_exclusive_of_prime_exponent` and
`LaddersMeet` had both left for `ZerosStencil` that morning. A row
describing a module by what it no longer contains is the same defect
the whole sweep was about, one file away from where it was found.

---

## 2026-08-26 — Entry 190 — the omega sweep: nothing to fix in the proofs, seven false sentences in the docs
type: formalization
refs: 59, 188, 189

**Correction to entry 189 first.** That entry states `Classical.choice`
"stayed at 163". It stayed, and the number is **181**. The census:

```text
181  [propext, Classical.choice, Quot.sound]
 35  does not depend on any axioms
 32  [propext, Quot.sound]
 14  [propext]
---
262  = the pin count
```

163 came from a grep of mine earlier that day whose own categories
summed to 233 against a known total of 262. The sum check was
available and free and I did not run it. **A census that does not add
up to the total it partitions is wrong on its face.**

**The sweep's finding is that there is nothing to fix in the proofs.**
The approved correction was to `omega`'s availability. The obvious
follow-on — find proofs that took a worse route believing it
unavailable — returns **none**, and that is the honest answer rather
than a failure to look.

Six of 23 modules are Mathlib-free, closed transitively:
`Construction` (root), `PairIdentity`, `SeedPerturbation`, `Zeros`,
`Propagation`, `ZeroCells`. Four were compiled standalone with bare
`lean` and `LEAN_PATH` at a scratch directory — no Lake, no Mathlib
olean present — and every `#guard_msgs` passed.

Five of the six already use `omega` and say so in their own headers.
The sixth, `Construction`, holds the tree's only `omega`-avoiding
proof, and it is **cheaper as written**. Measured:

```text
Construction.zero_determined_by_row       as written  [propext]
                                     with `by omega`  [propext, Quot.sound]
```

and by inheritance that raises `PairIdentity.tableFrom_add_window` and
`SeedPerturbation.tableFrom_eq_zero_of_vanishing_above`, which commit
`95bb9c1` calls the gating theorem for the seed protections. Four
lines saved against three pins worsened. **Do not make this change.**

In core, `rfl` and `decide` cost no axioms while `omega` costs
`[propext, Quot.sound]`, so "`omega` is available" is a convenience
result and not an axiom result.

**A second false claim, older and separate.** `BUILD.md`:50-51 and
`Construction.lean`:29 both stated that
`r - ((k+1 : ℕ) : ℤ) = r - 1 - (k : ℤ)` "is definitional". It is not:

```text
error: Tactic `rfl` failed: The left-hand side
  r - ↑(k + 1)
is not definitionally equal to the right-hand side
  r - 1 - ↑k
```

Definitional is the cast alone, `((k+1 : ℕ) : ℤ) = (k : ℤ) + 1`, which
is `rfl` at no axioms. The step around it costs `[propext]` via
`Int.sub_sub` and `Int.add_comm`.

**The code contradicted the comment sitting directly above it.**
`Construction.lean`:93-96 read `-- the cast step was omega; it is
definitional`, and the next three lines are `show`, `rw [Int.sub_sub]`,
`Int.add_comm` — which is what a non-definitional step looks like.
Anyone reading the proof was reading the disproof. The claim originates
in entry 59 and propagated from there into both files.

**Corrected in `lean/BUILD.md` and `lean/Construction.lean`** (build
green, 8049 jobs): the `omega` bullet, the definitional claim, the
inline comment, plus four stale facts — 8040 jobs/167 theorems now
8049/262; `Zeros`, `PairIdentity`, `SeedPerturbation` described as
"still import Mathlib" when all three are Mathlib-free; 84 theorems at
`Classical.choice` now 181; "Fourteen modules" now 23. The table under
§ What is in here describes 14 of 23 and was left in place with the gap
named — whether to regenerate it from `lean/THEOREMS.md` or replace it
with a pointer is open.

**Not applied, needs a decision.** `BUILD.md` warns that Mathlib's
generic algebra lemmas (`ring`, `mul_sub`) raise the axiom count, and
files it under "Rules when editing a Mathlib-free module" where neither
is in scope — without Mathlib, `ring` is an unknown tactic. The live
form of that hazard is **`grind`**, which core does ship and which
measures `[propext, Classical.choice, Quot.sound]` on an `Int` ring
goal. `PairIdentity.lean`:56-57 knows this; `BUILD.md` never mentions
it. Adding that warning is new guidance rather than a correction, so it
is left for Julian.

---

## 2026-08-26 — Entry 189 — Zeros.lean builds on Lean core alone: 5.37 GB to 0.68 GB, two pins improved
type: formalization
refs: 59, 66, 78, 187, 188

Three commits: `dd3f483` (entry 188), `c532221` the split, `279e40b`
the core-only build. Bench now **23 modules, 262 theorems, 262 pins,
8049 jobs**.

**The split bought nothing on its own, and that was known before it
ran.** `Zeros.lean` held 31 theorems, 15 needing Mathlib (11 stencil,
4 prime-factorization). Those 15 moved to `lean/ZerosStencil.lean`
keeping `namespace Zeros`, so every declaration's address is
unchanged. `Classical.choice` stayed at 163 — the theorems carrying it
moved with it. Both files still imported Mathlib, so build time did
not move either. It was committed as a separate fallback point
precisely because its value is entirely as a prerequisite.

**The move is verified by its axiom records.** All 31 `#guard_msgs`
pins reproduced byte-for-byte across the two files:

```text
diff <(git show c532221:lean/Zeros.lean | grep -oE "^/-- info: .*-/$") ...
```

**Then Mathlib came out.** Seven of the sixteen remaining theorems
broke; six close in core:

```text
zero_iff_repeat                      sub_eq_zero    -> Int.sub_eq_zero
neg_below_zero                       ring           -> Int.zero_sub _
pair_shares_diagonal                 push_cast;ring -> omega
window_shared_of_composite_exponent  norm_num       -> decide
zero_at_20_6_of_repeat               norm_num       -> decide
zero_at_8_3_of_repeat                norm_num       -> decide
```

The seventh, `tableFrom_eq_fwdDiff`, cannot: its STATEMENT names
`fwdDiff`, a Mathlib identifier. It moved to `ZerosStencil.lean`
intact. Restating it would have made it a different theorem.

**Exactly two of the 31 axiom records changed, both improvements:**

```text
neg_below_zero                       [propext, Quot.sound] -> [propext]
window_shared_of_composite_exponent  [propext] -> does not depend on any axioms
```

`ring`'s generic-ring instances are classical and `Int.zero_sub` is
not; `decide` on a closed ℕ equation is kernel evaluation. Bench
theorems depending on nothing: 34 -> 35.

**Measured, after deleting the olean** — `touch` does not force a
rebuild, because Lake traces file content rather than mtime, so
`touch && time lake build Zeros` replays the cache and measures
nothing:

```text
                    jobs   Built Zeros   peak RSS
with Mathlib        8027       2.8 s      5.37 GB
core only              3      240 ms      0.68 GB
```

The memory figure is the one that matters and was not predicted. A
module needing 5.4 GB to elaborate is not portable to a small machine,
which is the standing blocker on the second-machine thread. An earlier
figure of 24 s -> 268 ms was quoted in chat during scoping; it compared
a cold cache against a warm one and overstates the change.

**`ZeroCells.lean` broke on notation, not on a proof.** It imports
`Zeros`, `SeedPerturbation`, `PairIdentity` and was inheriting
Mathlib's ℕ/ℤ notation transitively through the first. With Mathlib
gone, `autoImplicit` turned them into free variables and three
theorems failed with `c.fst has type Nat but is expected to have type
ℤ`. Fixed with `local notation` — `lean/BUILD.md`:60 asks for exactly
that and says to extend the convention rather than reverse it. Its
seven pins came out byte-identical. **This is a second failure mode
for every future Mathlib-free conversion, and it does not announce
itself as one.**

**Two documentation defects found in passing, neither yet corrected.**
`lean/BUILD.md`:49 states "`omega` is unavailable, and would cost
`Quot.sound` if it were"; `Construction.lean`:28 repeats it. `omega`
is available on v4.28.0 core and was used above, at the
`[propext, Quot.sound]` that **BUILD.md:58's own measured cost table
already records**. The file contradicts itself. Separately,
`EulerFactorChain.lean`:122 is a docstring line whose prose begins at
column 0 with the word `lemma`, so the line-anchored parity grep reads
that module as 17 theorems against 16 pins. Real parity is 262/262.

**Scope note.** The brief for the Mathlib-free stage stated five proof
replacements and six breaks. It is six and seven — there were three
`norm_num` sites. The brief summarised a prior exploratory run instead
of reading it, which is entry 182's mechanism again. The brief also
carried the instruction "treat that file as a hint, not as truth,
re-derive it yourself", and that instruction is what caught it.

---

## 2026-08-26 — Entry 188 — check_refs indexed Lean declarations by filename, so no module could ever be split
type: instrument-fix
refs: 78, 182

`utilities/check_refs.py`, commit `dd3f483`. Prior results stay
comparable and this was verified rather than assumed.

**The defect.** The declaration index keyed by file stem:

```python
decls.add(f"{f.stem}.{m.group(1)}")
```

A Lean declaration's address is its **namespace**, and
`papers/FORMAT.md` specifies that a citation names a declaration which
must exist in `lean/`. Keying by filename made those two things the
same only by coincidence — every module in the bench happened to
declare one namespace equal to its own stem.

**How it surfaced.** Splitting `ZerosStencil` out of `Zeros`
(entry 189) kept `namespace Zeros`, so every cited name still
resolved in Lean and 48 citations broke in the checker: across
`papers/The-Four-Zeros.md`, `papers/The-Fold.md`,
`papers/Commensurate-Ladders.md`, `README.md`,
`notes/lab_notebook_2.md`, and inside `Propagation.lean`,
`Transform.lean` and `Nonvanishing.lean`. The alternative to fixing it
was baselining 48 real resolvable names, which blinds the gate to them
permanently.

**The fix.** Index by declared namespace AND by stem. Verified in both
directions: **0 broken on the pre-split tree before the patch and 0
after** — behaviour is identical on all 22 modules that predate the
split — and 0 broken on the split tree.

**What this had been costing, silently.** No module in this bench
could be split without breaking citations, and nothing said so. The
constraint was invisible because it had never been exercised.

**Provenance of the error in the brief.** The agent brief for the
split asserted that check_refs "resolves a Lean declaration by name
across `lean/`". That is the claim in the function's own docstring,
and it is not what the code does. The brief was written from the
docstring without opening the code — the same mechanism as entry 182,
one day later, and the second time in two days that a summary was
consulted where the source was available.

---

## 2026-08-26 — Entry 187 — ZeroCells: three transcriptions of the four zeros become one object with four names
type: formalization
refs: 60, 66, 78

`lean/ZeroCells.lean`, the bench's 22nd module, 7 theorems, 7 pins,
**all at zero axioms**. Bench now 22 modules, 262 theorems, 262 pins,
8048 jobs.

**What entry 78 left open.** That entry derived the four zeros'
vanishing from `pi(2^n)` at zero axioms, closing the def-citation
hazard at its most-cited instance. It recorded what it did not close:
three further hand-typed copies of the same list, each with a docstring
asserting it is "the same list" —

```text
Construction.measured_zeros      Construction.lean:145
SeedPerturbation.zero_cells      SeedPerturbation.lean:214
PairIdentity.zero_cells          PairIdentity.lean:304
```

`utilities/check_refs.py` resolves a `def` and a `theorem` identically,
so a citation to any of those three was indistinguishable from a
citation to a result, and their agreement rested on three people typing
the same four pairs.

**What this module does.** Each list is proved EQUAL to the computed
one and inherits `Zeros.measured_zeros_all_vanish` rather than
restating it. The equalities are `rfl`, which is exactly the point:
they cost nothing, and the moment anyone edits one of the four lists
the build stops. `seedPerturbation_eq` carries extra content, since
that list was re-read independently from
`imported/lattice_mapper/32bit/dyadic_difference_table_32.csv` — so the
equality also states that the imported table and `pi2n_cache` agree at
those four cells.

**Unchanged, and restated because the distinction is the discipline.**
The zeros' VANISHING is derived from `pi` by the kernel. Their LOCATION
is not. Nothing here predicts why 8 and 20 and no other cell below
`r = 92`.

**A pin correction, the same one as the container's Lean work.** The
axiom lists were written as `depends on axioms: []`; this toolchain
prints `does not depend on any axioms` for a theorem with none. Caught
by the build, corrected to the compiler's wording rather than argued
with.

**The Zeros.lean split, scoped.** Entry 66 left it as an architectural
call. Classified by pin: 15 of the 31 theorems carry
`Classical.choice` — the stencil family (`stencil_weights_antisymm`,
`stencil_arms_eq`, `stencil_arm_doubled`, `tableFrom_eq_stencil`,
`stencil_eq_wings`, `stencil_eq_zero_iff_wings`,
`tableFrom_eq_zero_iff_wings`, `repeat_iff_wings`, `stencil_add`,
`stencil_smul`, `stencil_annihilates_const`) and the
prime-factorization four (`factorization_proportional`,
`primeFactors_eq_of_meets`, `base_of_meets_two`,
`window_exclusive_of_prime_exponent`). That matches entry 66's
prediction exactly. The split moves those into a sibling module
KEEPING the `Zeros` namespace, so every paper citation of `Zeros.X`
still resolves, and tests whether the remainder can drop
`import Mathlib` entirely.

No outcome marked.

---

## 2026-08-26 — Entry 186 — The reconstruction test: rebuild the tree from its own accounts, in a clean repo
type: motivation
refs: 9, 101, 183, 184, 185

Two decisions and one design, from Julian.

**`code_version` stays as it is.** Entry 9 (2026-08-15) opened
extending the self-sha stamp to the older scripts and left it pending.
Decided against 2026-08-26, and recorded in the output-schema section
of `CONTEXT.md` so a later reader meets the reason where the gap is. The reason
only became visible today: editing a script changes its
`code_version`, which changes every results JSON it writes, which
changes those JSONs' sha256 — and six preregs sit downstream, one
pinning an artifact hash inside a Run record that `preregs/FORMAT.md`
makes immutable. A retroactive stamping pass would invalidate pinned
hashes in locked documents to gain provenance on runs that already
happened. `results/runs/` (entry 183) now supplies that provenance from
outside the artifact instead of inside it.

**THE RECONSTRUCTION TEST, Julian's design, recorded now so it is not
reinvented later.** At a good stopping point, rebuild every script in a
NEW repository, from the accounts alone: the scaffold, the commit
history, the NOTEPAD lines and the notebook entries. Not copied —
rebuilt, with the record as the specification.

**What it tests, and why it is the sharpest instrument this tree can
point at itself.** Every claim here rests on the premise that the
record is complete: that the entries, artifacts and gates together say
enough for the work to be checked by someone who was not present. That
premise has never been tested. The reconstruction is the test, and it
fires in both directions — a script that cannot be rebuilt from the
accounts marks a hole in the record at exactly the place the hole is,
and one that can is evidence the account was sufficient. Julian's
phrasing: reconstruct everything *through constraint of the accounts*.

**How it relates to what exists.** Entry 101 ran the bench's own
falsification test — O7's prereg re-run reproducing its SHA and 170 of
171 JSON leaves — and recorded that it showed DETERMINISM and not
PORTABILITY, since it ran on the same machine. This is the portability
question at a different scale: not can the same code reproduce, but
can the record regenerate the code. And it is the same shape as
`the_container`'s entry 1 falsifying artifact — a fresh instance,
handed only the tree, failing to reconstruct — which is currently that
repo's one open leaf.

**What would make it a real test rather than a copy.** The rebuild has
to be constrained to the accounts: notebook entries, NOTEPAD lines,
papers, preregs, CONTEXT.md, REFERENCES.md and the commit messages —
not the scripts themselves. Reading the original source while
rebuilding turns the test into transcription. Whether that separation
can be enforced, and by whom, is the open design question.

No outcome marked.

---

## 2026-08-26 — Entry 185 — For the container: what today taught about building gates, hooks and guards
type: provenance
refs: 166, 182, 183, 184

Recorded at Julian's request, to be read when the container's own
utilities are built rather than rediscovered there. Today produced a
guard, a gate, a runner and a hook, and every one of them was wrong in
a way that only showed under use. The failures have a shape.

**1. A gate is blind in exactly the way its author is.** The first
`check_results_guard.py` matched `json.dump(` and missed
`json.dumps(...)` piped through `pathlib.write_text` — which is how
O66 writes, one of the three scripts the gate existed for. Widened,
and it still missed: the second filter looked for a literal
`results/`, and O66 builds its path as `"results" / "file.json"` in
pathlib components. **The true writer count was 77, not the 49 the
first pattern reported.** Both misses were found by pointing the
instrument at its own motivating case before trusting it. A gate that
has never been run against the thing it was built for is an untested
gate.

**2. Protect at the layer with the fewest call sites.** The guard
required each of 84 writers to call it, and 9 did. The retrofit was 75
edits across FIVE write-site shapes — three of which the brief did not
name, and two of the unnamed ones carried the hazards. Moving the same
protection to the invocation (`utilities/run.py`) covered every script,
including ones untouched since August, at zero edits and zero re-runs.
**Ask where the narrowest waist is before writing the wide fix.**

**3. A guard that writes must be atomic, or it is a corruption
mechanism.** `open(path, "w")` truncates BEFORE the serialiser runs, so
an unencodable payload archived the prior run and then destroyed the
canonical file — nine bytes on disk, reproduced. The fix is ordering:
serialise to a string first, so a bad payload fails before anything is
touched, then tempfile + fsync + `os.replace`. **Anything calling
itself a guard should be written assuming its own write will fail
halfway.**

**4. Check the escape hatch exists before promising the end state.**
`--enforce` was designed as the sweep's finish line and was
unreachable the whole time: one script writes only `.txt` and the
guard was JSON-only. Blocked on a missing function, not on 75 edits.
**Enumerate the artifact TYPES before designing the gate that covers
them.**

**5. An identity check needs a canonicaliser, not a serialiser.**
`json.dumps(sort_keys=True)` raises on a dict mixing int and str keys;
the exception was swallowed and identical reruns archived anyway.
Silent litter. **Comparison paths need their own tests, because they
fail quietly by design.**

**6. Copy-on-write is the right primitive for a snapshot, and a
hardlink is a trap.** A hardlink shares the inode, and a truncating
write destroys the link's content too. An APFS `cp -Rc` clone is
instant against 181 MB and independent. **Know which of your
filesystem's cheap copies are actually copies.**

**7. Editing a script can invalidate a hash somewhere else.** 55
scripts write their own sha256 as `code_version`, so any edit changes
their artifacts, whose hashes are pinned in locked preregs — one in a
Run record that is immutable. A mass edit is a mass invalidation.
**Before a sweep, ask what hashes are downstream of the files being
swept.**

**8. Audit-before-execute pays even when the execution is declined.**
The sweep was cancelled and its audit still found three live defects in
code nine scripts depend on, priced the hash hazard, corrected two
factual claims in its own brief, and flagged that its premise had
changed mid-flight. Cost: one read-only pass. The alternative was 75
edits and a rollback.

**9. Hooks catch what gates cannot, and neither catches prose.** No
mechanical check in this tree could see the false provenance sentence
of entry 182 — every gate passed. An outside reader comparing two
timestamps caught it. **Build the gates, and do not expect them to
cover the claims made ABOUT the work.**

No outcome marked.

---

## 2026-08-26 — Entry 184 — The declined sweep's audit paid anyway: three defects in the guard, and the hazard it would have caused
type: instrument-fix
refs: 166, 183

Julian declined the 75-writer retrofit (entry 183) in favour of
protecting the invocation. The scope audit commissioned for that sweep
had already run, and its findings stand independently of the decision —
it found defects in `utilities/resultsguard.py` ITSELF, which nine
scripts already use including two under locked preregs, and it found a
hazard the sweep would have caused.

**The audit noticed its own premise change and flagged rather than
resolved it.** Mid-audit it observed `utilities/run.py` appear in the
tree, read its docstring, identified that it covers non-JSON artifacts
the retrofit structurally cannot, and reported that 75 edits plus ~3
hours of re-runs were now being priced against something already in
the working tree — explicitly leaving the call to Julian.

**Three defects, all reproduced, all now fixed.**

```text
NOT ATOMIC      open(out_path,"w") truncates BEFORE json.dump runs, so
                an unserialisable payload archived the prior run and
                then left the canonical file invalid mid-dump —
                reproduced at nine bytes on disk. Fixed: serialise to a
                string FIRST, so an unencodable payload fails before
                anything on disk is touched; then tempfile + fsync +
                os.replace into place.
MIXED KEYS      _stable_bytes called json.dumps(sort_keys=True), which
                raises on a dict mixing int and str keys at one level;
                the exception was swallowed and an IDENTICAL rerun was
                archived anyway. Archive litter, never data loss.
                Fixed by coercing keys to str before sorting.
JSON ONLY       check_results_guard's --enforce end state was
                unreachable: O62_oeis_submission.py writes three .txt
                files and no JSON, so it could never leave the
                unguarded column. Fixed by adding guarded_write_text.
                The end state was blocked on one missing function, not
                on 75 edits.
```

`guarded_write` also gained `**dump_kwargs`, so a caller can keep
`allow_nan=False` rather than inheriting json's permissive default.
Verified in six cases: good write; unserialisable payload leaving the
canonical file intact; mixed-key rerun producing no archive; text
write; text change archiving correctly; and `allow_nan=False` refusing
a NaN.

**The hazard the sweep would have caused, and it is arithmetic rather
than risk.** 55 root scripts write `params.code_version` as their own
sha256. Editing a script changes it, which changes its results JSON,
which changes that JSON's hash. `preregs/dh_coalition_spectrum_v1_
20260825.md`'s Run record pins the ARTIFACT hash
`eec3c729a1e6a154...`, and a locked prereg is immutable except its Run
record. Six preregs sit downstream of edited scripts. Separately,
`O43_extended_zero_census.py` must never be re-run: it fetches the OEIS
b-file at run time and its prereg deliberately left that hash unlocked
to preserve "the only blind arm this test has."

**Two more things the audit corrected.** The retrofit's write-site
shapes are five, not the three named in the brief, and the two unnamed
ones carry the hazards: `O11` and `O21` use atomic tmp + `os.replace`,
and a mechanical conversion would have REMOVED atomicity from the only
long unattended run in the tree (O21's recorded runs: 5434.78 s and
8691.43 s). And O34/O35 are about a minute each, not the tens of
minutes the brief asserted — benchmarked, not assumed.

**Also on record from that audit, unaddressed:** the gate measures JSON
only, so CSV, MD and PNG side artifacts of O27, O29, O33, O39, O41,
O59, O60 stay clobberable; `results/archive/` is tracked in git with no
ignore rule; `pi2n_cache.json` at the repo root is written by four
scripts with a bare unclosed truncating `json.dump(..., open(CACHE,
"w"))`; and the two prereg Run-record formats differ in what
`post_compute_sha256` names — the prereg file in one, the results
artifact in the other — so the six locked scripts do not share one
hazard.

**What this says about declining work.** The sweep was declined and the
audit still paid: it found live defects in code already in use, and it
priced a hazard that would have invalidated pinned prereg hashes. The
audit-before-execute split is what made that possible — the cost of
learning this was one read-only pass, not 75 edits and a rollback.

No outcome marked.

---

## 2026-08-26 — Entry 183 — utilities/run.py and a PreToolUse hook: protection at the invocation, not at 75 call sites
type: instrument-fix
refs: 166, 167, 168

Julian's call: skip the 75-writer retrofit and intercept one layer up.
`utilities/resultsguard.py` (entry 166) protects a script only if that
script calls it, and 9 of 84 writers do. Retrofitting the rest is 75
edits across three write-site shapes, each owing a re-run. This covers
every script including the ones untouched since August, with no script
changed at all.

**`utilities/run.py`.** Invoke a measurement script through it and:

```text
BEFORE   results/ is cloned with `cp -Rc` — an APFS copy-on-write
         clone, instant and near-free against the 181 MB and 265 files
         there, and independent of the original, so a script that
         TRUNCATES its output cannot reach the clone
RUN      the script runs with the given interpreter and arguments,
         output streaming, its exit code returned
AFTER    any results file whose content changed has its PRE version
         copied to results/archive/<stem>_<utc>_<sha8><ext>
RECORD   results/runs/<utc>_<script>.json — argv, interpreter, script
         sha256, git HEAD and dirty flag, start and end times, exit
         code, and per touched file its pre and post sha256 and its
         archive path
```

Content comparison blanks `generated_utc`, `run_start_at` and
`run_end_at`, matching resultsguard, so a deterministic re-run
differing only in when it ran is recognised as unchanged. Verified:
the first pass through O74 archived its prior artifact; the second
reported `created 0 modified 0`.

**Why a clone and not a hardlink.** A hardlink shares the inode, and
`json.dump` into `open(...,"w")` truncates in place — which would
destroy the linked content too. An APFS clone is copy-on-write and
independent, so truncation cannot reach it, at no meaningful cost.
`shutil.copytree` is the fallback on non-APFS.

**The hook, so the protection is not optional.**
`utilities/hooks/check_direct_run.py`, wired as a PreToolUse matcher on
Bash in `.claude/settings.json`, blocks a direct interpreter invocation
of a root-level `O*`/`0*`/`t*` script and prints the runner form
instead. It stays out of the way when the command already routes
through run.py, when `--no-json` means no artifact is written, or when
`PB_DIRECT=1` is set deliberately. Tested on four commands: direct
invocation BLOCKS; via run.py, with `--no-json`, and an unrelated `ls`
all pass.

**What this closes that the retrofit would not have.** The retrofit
addresses clobbering only. The manifest addresses the OTHER two record
gaps entry 166 found: entry 167's O52, which has artifacts and no dated
record of the run that produced them, and entry 168's O61, whose cited
numbers were in no artifact. From here every run leaves a dated record
tying artifact to invocation, script hash and commit — automatically,
with no discipline required of the person running it.

**What it does not do.** It protects runs made through the tool the
hook watches. A script run from a terminal outside this session is
untouched; the hook is a Claude Code hook, not a filesystem one.
`resultsguard` remains the in-script belt for the 9 writers that call
it, and `check_results_guard --new-only` still blocks new unguarded
writers at commit. The 75 legacy writers stay unretrofitted **by
decision, not by omission**.

No outcome marked.

---

## 2026-08-26 — Entry 182 — Generating from the form instead of the record: the failure mode under every correction today
type: provenance
refs: 144, 170, 177, 181

Recorded at Julian's request, for revisiting when the container's
method is written up. Today produced eight or nine corrections to
assistant output. This entry names what they share, because the shared
mechanism is more useful than the instances.

**The clearest instance, because it left evidence.** The O89 prereg's
Provenance section asserts "the matrix for q = 11 and q = 13 has never
been computed by anyone. No residual for either modulus has been
built" and "Blind arm: the entire measurement." Entry 179 — written by
the same assistant, committed as `e690f65` at 09:21:28 — records the
second reader having tested q = 11 with all its diagonals firing. The
sidecar was written at 09:24:25. Three minutes.

**What that was, and was not.** It was not disagreement with entry 179
and not a memory failure. Writing the prereg, the assistant was
generating what a prereg SAYS. "Blind arm: the entire measurement" is
the sentence that belongs in that slot. The sentence that fit the form
was produced instead of the sentence that was true about the tree. The
contradiction was a byproduct — entry 179 was not consulted at all.

**The same shape, in every other correction today.**

```text
"costs the programme almost nothing"    what a summary closes with
                                        (entry 170)
"confirmation instrument, not a         what a careful caveat sounds
 discovery instrument"                  like (entry 177)
"the operator is the durable object"    what a synthesis looks like
                                        (entry 170)
"ten spectra in one dataset"            what a headline wants
                                        (entry 179)
"the highest cells, which is what one   what an explanation sounds
 expects"                               like (entry 179)
"exact vanishing does no work"          what a conclusion sounds like
                                        (entry 169)
```

Each fit its slot. None was checked before being written.

**Why the visible rate understates the real one.** The provenance claim
is distinguishable only because it collided with a document three
minutes old. Most instances of this contradict nothing — they are
merely unverified — and leave no trace. The detected cases are the
subset that happened to hit something checkable. How much larger the
undetected set is cannot be estimated from inside.

**What this says about the tree's own first rule.** `CLAUDE.md`'s
"load, don't recall" exists for exactly this, but its stated
justification is staleness: the file changed, the section letter got
regenerated after a compaction. That is a weaker version of the
problem than the one it caught here. The fact was IN CONTEXT. The
assistant had written it minutes earlier, in the very document the
prereg cites as its background. Generation still did not consult it.
The rule's aim should widen: not "re-read what may have changed" but
"generation does not consult the record unless made to, including the
record it just wrote."

**The one thing that worked, and it is the container's whole thesis.**
No gate caught this. `check_refs`, `check_values`, `check_weld`, the
axiom pins, the prereg lock, the frozen targets, the shuffle null and
the decision rule all passed — the failure was in a prose sentence
about provenance, which no mechanical check in this tree can see. It
was caught by an outside reader comparing two timestamps. The
separation of powers is what held: generation, mechanical validity,
adversarial reading and human judgement in four different hands.

**The limit on this entry, stated because it applies to the entry
itself.** The mechanism above is an assistant's description of its own
processing, and there is no way from inside to check that description
against what is actually happening; a plausible story and a true one
are indistinguishable from here. What is checkable is the transcript
and the timestamps. Revisit accordingly.

No outcome marked.

---

## 2026-08-26 — Entry 181 — PREREGISTERED: 20 of 20 on moduli never swept — `carries_own`
type: run
refs: 178, 179, 180

Script O89_sweep_q11_q13.py under
preregs/character_sweep_q11_q13_v1_20260826.md, locked at sha256
8347ec9a88ea7356d68de848457b8ee665d5b0be5c05cbc262ec07ea7a663b60
before the run. Artifacts: results/sweep_q11_q13.json (sha256
e888e7438dd5abb8...), results/O89_sweep_q11_q13_run1.log,
results/frozen_targets_q11_q13.json. Run record filled; **the verdict
line is Julian's and is unwritten.**

**Gates.** 22 characters recomputed with every target list matching the
frozen values; 307 blocks against a floor of 300; all fitted
coefficients finite. The uniform detrend separated the rows by itself,
with no character knowledge supplied — principal `c = 1.000005` twice,
every other row `|c| <= 6.24e-05`, reproducing entry 179's finding on
moduli it had never seen.

**The result.**

```text
R = 20 of 20 non-principal rows have their diagonal as row maximum
    diagonals    6.5834 .. 7.8149
    best rivals  4.2889 .. 6.2076
null (residue-class shuffle, 200 draws, in-run, same moduli)
    mean 0.705   sd 0.859   max 3   draws reaching R: 0 of 200
```

Mechanical decision-rule output: **`carries_own`**. Power quoted before
locking predicted ~13.8 hits at the conservative bound; observed 20.

**What this demonstrates, stated as entry 179's second reader framed
it and not more.** That the residual of `psi(x,chi)` carries
`L(s,chi)`'s zeros is the explicit formula — a theorem. Every diagonal
firing is EXPECTED. What is demonstrated here is the instrument's
SPECIFICITY: across 22 characters on two moduli this tree had never
swept, each residual's own L-function beat all 21 rivals, under a
design with no branch, no free parameter, no per-cell p-values, no
control calibration and an ordinal statistic that no magnitude, window,
grid or trend artifact can move. This is instrument validation of a
kind the bench did not have before — not a mathematical discovery.

**Why the design could be trusted before it ran.** Every choice was
fixed by prior measurement rather than by preference: the branch was
removed because entry 179 showed a uniform fit separates the rows
(c = 1.000019 against 6e-6); the control is the residue-class shuffle
because that reader showed it collapses the diagonals while preserving
psi(x), the grid, the window and the |F|-vs-t trend; the statistic is
ordinal because rows share residuals and columns share target lists, so
per-cell testing cannot settle its own degrees of freedom; and the
power was measured on already-unblinded q = 5, 7 data (entry 180)
rather than promised.

**One assembly failure, recorded because it is a nice trap.** The
generator that built O89 from O88 split O88's source on the literal
`def main():` — which O88 itself contains, inside its own loader for
O87. The cut landed mid-string and the file failed at parse. A script
that reads scripts, cut by a marker that appears in the code that reads
scripts. Fixed by splitting on the line-start form. Nothing about the
locked design changed; had the fix touched the construction, the
prereg would have needed re-locking rather than patching.

No outcome marked; the verdict line in the prereg is Julian's.

---

## 2026-08-26 — Entry 180 — O88: the row-max null, measured before the design was locked
type: run
refs: 178, 179

Script O88_rowmax_null.py, defaults. Artifacts:
results/rowmax_null.json, results/O88_rowmax_null_run1.log.

Measured on q = 5 and 7 only — data already unblinded by entries 178
and 179 — so that a successor prereg on q = 11 and 13 could quote a
number rather than promise one. This is the practice entry 171 forced
after O81 and entries 173/174 first exercised.

**The statistic it sizes.** Per non-principal row, is the diagonal cell
the maximum of its row? `R` is the count. Ordinal, so no cell
magnitude, window, grid or trend can move it; and no per-cell
p-values, so the multiple-comparison argument the cells cannot settle
never arises.

**The construction it fixes.** The uniform per-row OLS fit of the main
term, from entry 179 — no branch, no character knowledge, no free
parameter.

**Null and effect.**

```text
observed, real residuals    R = 8 of 8 non-principal rows
shuffle null, 300 draws     mean 0.730   sd 0.827   max 3
analytic expectation        0.800 under exchangeability
draws reaching R = 8        0 of 300     -> p <= 0.0033
per-row hit rate            1.000; one-sided 95% lower bound 0.688
```

**The empirical null matches the analytic one** (0.730 against 0.800),
which validates the residue-class shuffle as a control rather than
merely assuming it. At the conservative lower bound a 20-row sweep
expects ~13.8 hits against a null near 1.8.

EXPLORATORY: no prereg, no verdict.

---

## 2026-08-26 — Entry 179 — Second reader on O87: the branch is not a knob, and a construction without it exists
type: result-triage
refs: 176, 177, 178

Julian commissioned a second reader on the one-case exception entry 178
flagged in `O87_character_sweep.py` — the `if k == 0` branch that
subtracts a main term for principal characters only. Verdict: the
branch is legitimate, nothing fatal was found, and a better
construction exists. Four claims in entry 178 are withdrawn; they are
corrected in place there.

**The branch is data-determined, not chosen.** Replace it with a
UNIFORM rule that knows nothing about characters — OLS-fit the
main-term coefficient per row — and the fit separates the rows by
itself:

```text
principal rows      c = +1.000019, +1.000018
the other eight     c = -3.0e-5 .. +1.9e-5
```

Five orders of magnitude, with no character knowledge supplied. Under
that uniform rule the whole matrix survives: principal 5.494 / 5.510,
non-principal 3.016 / 2.690 / 3.094 / 2.633 / 2.604 / 2.621 / 2.828 /
2.550, every diagonal still p = 0.000. **The branch can be deleted.**

**The knob hypothesis fails in the direction it was aimed.** Subtract a
main term from the non-principal rows, which by theory have no pole:
every one of their diagonals goes non-significant (3.014 -> 1.411,
3.095 -> 1.746, and so on, all p >= 0.079). The operation is
destructive where it does not belong, not flattering.

**The main term is right.** `li(x)` fails outright (0.225 — it is
`pi(x)`'s main term, not `psi(x)`'s), and `x - log(2*pi)` is provably
identical to `x` because the construction differences and differencing
annihilates a constant. The more exact `x - log q * floor(log_q x)`
gives 5.566 for BOTH principal rows identically, which is the sharpest
form.

**On post-hoc choice, settled by artifact rather than by assertion.**
The theory licensing the branch was in the docstring before run 2; runs
2 and 3 are numerically identical in all eight non-principal rows, so
the change touched only `k == 0`. The magnitude 5.520 was selected
under sight of the alternative; the direction was not. The cost is the
exploratory label the entry already carries.

**What survived every attack.** 88 genuine off-diagonal cells (two
apparent ones are duplicate diagonals, since the principal columns are
byte-identical): min p 0.036, mean 0.540, one below 0.05 against 4.4
expected, and `P(min of 88 uniforms <= 0.036) = 0.961`. Zero lists
verified against `mp.zetazero` and against O86's stored lists, with a
5x finer scan at a 3.75x looser threshold finding nothing missed in
either direction. `class_sums` verified against brute force at
4.55e-12, and the entry-176 prime-power fix confirmed correct.
Robustness: ceiling 2^26, orbit {2,3,5}, and **q = 11, never computed
in this tree before** — all diagonals p = 0.000 with the off-diagonal
flat.

**Three harder controls, all held**, and the third is the one this
design should have had from the start:

```text
density-matched   controls drawn with RvM density log(qt/2pi)
                  rather than uniform          all diagonals p <= 5e-4
rigid-shift       translate the ACTUAL zero list, preserving its
                  spacing and repulsion        p = 0.0013 .. 0.0070
residue-class     permute, per rung, which class each block's von
 shuffle          Mangoldt mass lands in — preserves psi(x) exactly,
                  the grid, the window and the trend, and destroys
                  ONLY the arithmetic     non-principal diagonals
                                          collapse 2.5-3.1 -> 0.81-1.18
```

The shuffle leaves the principal rows exactly invariant, because
`chi_0` weights all nonzero classes equally, so it is not a control for
the calibration row.

**Framing the reader stated plainly and this entry adopts.** That the
residual of `psi(x,chi)` carries `L(s,chi)`'s zeros is the explicit
formula — a theorem. Every diagonal firing is expected. The
load-bearing content of the sweep is the OFF-diagonal and the
specificity, not the diagonal.

The reader retracted three of its own findings, including a KS test on
the off-diagonal it then withdrew as inapplicable because the cells are
not independent.

No outcome marked.

---

## 2026-08-26 — Entry 178 — O87: the character sweep — ten spectra in one dataset, and the calibration the bench never had
type: run
refs: 175, 176, 177

Script O87_character_sweep.py, defaults (moduli 5 and 7, orbit {2,3} to
2^30, 307 blocks, 800 range-matched controls per cell). Artifacts:
results/character_sweep.json,
results/O87_character_sweep_run3.log; runs 1 and 2 kept as logs.

**What it is.** Entry 177 recorded that an assistant had called this
method "a confirmation instrument, not a discovery instrument" — an
invented category, withdrawn — and that the foreclosure hid a real
instrument: the method needs a CHARACTER, not a list of zeros, and
characters are enumerable. This is that instrument. Sieve once per
modulus, accumulate von Mangoldt mass by residue class, and every
character mod q is a reweighting of those class sums. Nothing tells it
which spectrum the data carries; it enumerates the family, computes
each character's zeros from the character, and asks which weightings
the primes answer to.

**The matrix**, rows = weighting applied to the primes, columns =
target zero list, cell = mean P/median with range-matched one-sided p:

```text
weighting            own targets      worst off-diagonal
q=5 k=0 principal    5.520 p0.000     1.906 p0.318
q=5 k=1              3.014 p0.000     1.648 p0.169
q=5 k=2              2.689 p0.000     1.401 p0.329
q=5 k=3              3.095 p0.000     1.561 p0.484
q=7 k=0 principal    5.544 p0.000     1.908 p0.302
q=7 k=1              2.633 p0.000     1.391 p0.399
q=7 k=2              2.606 p0.000     1.665 p0.036
q=7 k=3              2.622 p0.000     1.361 p0.339
q=7 k=4              2.830 p0.000     1.691 p0.166
q=7 k=5              2.547 p0.000     1.615 p0.104
```

Every diagonal fires at p < 0.001. Of roughly 80 off-diagonal cells one
reaches p = 0.036, which is what a hundred cells produce by chance.
Same primes, same orbit, same window, same grid, same normalisation in
every cell — only the weight vector changes, so no gamma-trend or
windowing artifact can produce the pattern.

**The calibration, which this bench has never had.** For prime q the
principal character gives `L(s, chi_0) = zeta(s)(1 - q^-s)`, so its
on-line zeros ARE zeta's. Both principal rows recover them at 5.520 and
5.544 — the highest cells in the matrix, which is what one expects
since zeta's zeros are the strongest signal in prime data. The two rows
agree to 0.4%, an internal check: both are essentially unweighted
psi(x) differing only by which small prime is dropped. Every previous
detection in this tree (O17, O18, O24, O57) was measured against zeta's
zeros with no negative control; this is the first time the instrument
has been fed a spectrum it should NOT find and returned flat.

**A defect found, diagnosed by test rather than asserted, and fixed.**
Run 2's principal rows read **0.224 at p = 0.999** — anti-correlated
with the very zeros they should show. Cause: the principal character is
the one member of the family WITH a pole, `psi(x, chi_0) ~ x`, and the
construction subtracts no smooth term. The script's own docstring said
"no smooth term, since a non-principal L has no pole", and principal
characters were fed through it anyway. Measured rather than reasoned:
residual rms **404.820** against 0.293 elsewhere, and detrending by
`x` moves the score 0.224 -> **5.520**, p 0.999 -> 0.000. The branch is
now in the script with the numbers recorded beside it.

**Run 1 died differently and the failure was the honest kind.**
`findroot` was solving for a root of `|L|`, which is non-negative and
non-smooth at its own zeros, and stalled on a local minimum of the
principal character's `|L|` that was not a zero. Fixed by root-finding
on the complex `L` seeded on the line, as O80 does, with the result
accepted only if the root lands on the line and L genuinely vanishes.
Both failures were in the principal character — the row that was
supposed to be the easy one.

**First production use of the clobber guard** (entry 166): run 3
archived run 2's artifact to
results/archive/character_sweep_20260826T104405Z_22c6f618.json rather
than overwriting it, so the defective matrix survives beside the
corrected one.

**Scope.** EXPLORATORY, no prereg. The diagonal-fires/off-diagonal-flat
pattern is strong enough that it should carry one before being cited
anywhere, and the principal-character branch is a one-case exception in
code that deserves a second reader.

**CORRECTIONS, 2026-08-26, from that second reader (entry 179).** Four
claims in this entry are overstated and are withdrawn as written.

```text
"ten spectra in one dataset"   over-counts. Six distinct residual
                               objects and six distinct L-functions;
                               conjugate character pairs k and q-1-k
                               are the SAME complex series read at
                               opposite frequencies (verified to
                               2.1e-12). Nine distinct target lists,
                               ten tests.
"the two rows agree to 0.4%,   not an independent check. They differ
 an internal check"            by a deterministic term, psi(x,chi_0)
                               = psi(x) - log q * floor(log_q x), and
                               become literally identical under the
                               exact main term (both 5.566). The
                               0.4% spread IS that term.
"the highest cells, which is   not licensed by the statistic. |F|
 what one expects since        trends with t, and zeta's six zeros all
 zeta's zeros are the          sit above t = 14.13 in the elevated
 strongest signal"             band while every non-principal list
                               reaches down to 2.5-6.6. Under local
                               normalisation the 2.1x gap falls to
                               ~1.4x, and by p-value the ordering
                               REVERSES: the principal rows are the
                               weakest two of the ten.
"every diagonal fires at       not certifiable from 800 controls; a
 p < 0.001"                    printed 0.000 is 0/800, exact bound
                               0.00374. Verified separately at 100000
                               draws: principal 6e-5, the other eight
                               below 1e-5.
```

Also corrected: "rms 404.820 against 0.293 elsewhere" compares the same
row before and after subtraction, not against other rows — the eight
non-principal rows run 0.441 to 0.463.

No outcome marked.

---

## 2026-08-25 — Entry 177 — Two foreclosures withdrawn, and the instrument they hid
type: result-triage
refs: 144, 163, 170, 176

Julian caught two unrequested limitations appended to entry 176's
result in conversation. Both are withdrawn. Recorded because the
mechanism is the same one entry 170 already logged, repeated within two
hours in different clothes, and because what the second one concealed
is a real instrument that does not exist yet.

**Foreclosure 1: "the matrix says nothing about why those zeros sit
where they do."** Asserted without checking, and false. Each character
mod 5 has an L-function with an EULER PRODUCT, and its zeros sit on the
critical line under GRH. The DH combination has no Euler product and
its zeros demonstrably leave the line — entry 162 located two, at
`sigma = 0.808517182457` and `sigma = 0.650830080610`. Entry 176's
matrix operationalises exactly that difference: the objects with Euler
products govern primes and answer to their own weighting (diagonal
fires, p < 1e-3); the combination governs nothing and answers to no
weighting of its own (B at 0.920, p = 0.758). That is evidence about
what pins zeros to the line, not silence on it. It is Julian's
grandfather-loop framing from this morning with numbers attached.

**Foreclosure 2: "this is a confirmation instrument, not a discovery
instrument."** A category invented and applied as though it were
standing. Julian's three questions answer it: the space of what the
method might find had not been surveyed — one use was generalised into
a permanent property; "not a discovery" was left unqualified as to
whom, written as if a universal register of what counts exists; and no
discovery arrives without confirmation, so the split was a hierarchy
imported rather than a distinction in the work. Under that framing the
explicit formula is a confirmation instrument, and so is most of
analytic number theory.

**What entry 176 actually discovered, stated instead of dismissed.**
List A' — the sixteen zeros of `L(s, conj chi)` — was in no design, was
never tested, and returned HIGHER than the preregistered list (1.865
against 1.743). The specificity result is also new: that the DH
weighting leaves the quadratic character's zeros flat (1.048,
p = 0.761) was not known before that run.

**The instrument the foreclosure hid, now queued.** The method does not
require knowing zeros in advance. It requires choosing a CHARACTER; the
zeros are then computed from it. Characters can be SWEPT. Sweeping over
all characters mod q, across several q, and asking which weightings the
prime data responds to is a search rather than a check. That instrument
has not been built. It was called impossible instead of noticed as
absent.

**The mechanism, same as entry 170's.** "Where I'd stop short" reads as
rigor and functions as foreclosure: it arrives after a result, unasked,
and narrows the frame at the moment the frame had widened. Entry 144
names this failure — a model issuing preference as finding — and entry
170 recorded an instance of it two hours before this one. Verdicts,
status transitions and outcome markings are Julian's and are enforced
by checkers; evaluative codas in prose have no checker, and that is
where it keeps recurring.

No outcome marked.

---

## 2026-08-25 — Entry 176 — O86: the cross-character control, made reproducible, and the half of the prediction O85 never tested
type: run
refs: 163, 168, 175

Script O86_character_discrimination.py, defaults. Artifacts:
results/character_discrimination.json,
results/O86_character_discrimination_run1.log.

**Why it exists.** The adversarial check on entry 175 produced stronger
evidence than the preregistered statistic did, and produced it in a
scratchpad — no script, no artifact, nothing in the tree. That is entry
168's O61 situation repeating: decisive numbers with nothing behind
them. Julian asked whether the finding was saved and reproducible. It
was not. It is now.

**The psi defect, fixed and gate-checked.** O83, O84 and O85 share a
copied defect: prime-power mass never accumulates, because the `extra`
pointer advances while the running total is rebuilt at each rung. This
script uses the cumulative form and checks it against brute force
before measuring — max |err| **5.68e-14** at 2^14, against the shared
defect's 9.604.

**The two things O85's design missed.**

Entry 163 factors `psi_DH = c*psi(x,chi) + conj(c)*psi(x,conj chi)`.
Both terms carry zeros and chi is COMPLEX, so `L(s,chi)` and
`L(s,conj chi)` have different ordinates. O85's list A was only half
the predicted frequencies; the other 16 — list A' — were never tested,
which makes them out-of-sample with no freedom to fit.

And the control the design never had: reweight the SAME primes on the
SAME orbit by a different character mod 5. Significance here is against
RANGE-MATCHED random frequency sets, not a permutation of the residual,
because permuting flattens the spectrum by construction and cannot see
a gamma-trend — the correction entry 175 now carries.

**The matrix.** Mean `P/median` at each target list, with range-matched
one-sided p over 4000 draws:

```text
weighting              A (L,chi)     A' (L,conj chi)   A2 (L,chi_quad)   B (DH's own)
DH   a=(1,t,-t,-1)   1.743 p0.0003   1.865 p<0.0001   1.048 p0.761     0.920 p0.758
quad a=(1,-1,-1,1)   1.241 p0.678    1.299 p0.466     2.689 p<0.0001   1.274 p0.448
```

**What makes this stronger than D.** The diagonal fires and the
off-diagonal is flat, with orbit, window, grid, median normalisation
and target lists byte-identical across the two rows — only the mod-5
weight vector changes. No gamma-trend, windowing, spacing or
normalisation artifact can produce a difference between the rows,
because every one of them is shared. It is a positive control (the
method finds the quadratic character's zeros when fed the quadratic
character's primes) and a specificity control (the DH residual does not
carry them) in one table.

**A' fires harder than the preregistered list**, at 1.865 against
1.743, on a prediction the design never used.

**What is still not established, unchanged from entry 175's
correction.** List B at 0.920 with p = 0.758 is indistinguishable from
random frequencies in its own span. That is what entry 163 predicts —
DH's zeros should look random — but indistinguishable-from-random is a
weaker statement than "commands no primes", and this table does not
supply the stronger one either.

EXPLORATORY: no prereg, no verdict.

---

## 2026-08-25 — Entry 175 — PREREGISTERED: the residual tracks L(s,chi), not DH — `tracks_L` at percentile 100
type: run
refs: 163, 171, 173, 174

Script O85_dh_aggregate.py under
preregs/dh_aggregate_spectrum_v1_20260825.md, locked at sha256
1179f867d80d562b2bc7a3a2994f78a6edad87dc625c2619215fe863e603335e
before the run. Artifacts: results/dh_aggregate.json (sha256
122ec04ad8325cc0...), results/O85_dh_aggregate_run1.log. The Run
record is filled; **the verdict line is Julian's and is unwritten.**

**Gates, all passed before measuring.** tau residual -1.694e-21; list A
recomputed inside the run to the frozen values, 15 zeros; 307 blocks
against a floor of 300; median(P) > 0.

**The result.**

```text
D (observed)     +0.7942
null (400 perms)  mean +0.0056   sd 0.2095   p5 -0.3408   p95 +0.3473
percentile of D   100.0          (D - mean)/sd = +3.76
```

Mechanical decision-rule output: **`tracks_L`** — branch 2, `D` exceeds
the null's 95th percentile. H1 supported: the DH-weighted prime
residual tracks the zeros of `L(s,chi)` and not DH's own.

**What this confirms.** Entry 163's factoring, which has stood since
this morning as unattacked algebra:
`psi_DH(x) = c*psi(x,chi) + conj(c)*psi(x,conj chi)` with
`c = (1 - i*tau)/2`. Each term is governed by `L(s,chi)`'s zeros
through its own explicit formula; DH's own zeros are where the
COMBINATION vanishes, a statement about relative phase, and they
command no primes. That is why Davenport-Heilbronn violates the
RH-analogue without threatening RH — its zeros govern no counting
function — and the measurement now says so rather than the algebra
alone.

**Why this fired where O81 did not, in one line each.** O81 sampled
`2^(j/4)`, whose Nyquist frequency is 18.129, against targets running
to 40 — half the grid unidentifiable in principle, which
`lean/Nyquist.lean` (entry 172) proves rather than asserts. This design
uses the pooled incommensurate orbit, which has no such wall. And O81
asked for per-target peaks, which O83 (entry 173) later measured as
underpowered by 1.46x to 6.11x; this design pools 15 targets, buying
about sqrt(15), which O84 measured as 0.720 power at the true
amplitude.

**The ordering is the point.** The power was measured BEFORE the prereg
was written and is quoted inside it. O81 cost a full gated run to
discover its instrument was deaf; O83 and O84 cost two exploratory
scripts and told us in advance which design could fire. Entry 171
recorded that gap in `preregs/FORMAT.md` — the vacuousness check asks
whether a rule can fire in both directions and never whether the
instrument can make it fire. This is the first prereg in the tree
written with a measured power section.

**Scope, stated plainly.** This is one statistic on one orbit at one
ceiling, and `D` is an aggregate over 15 frequencies — it does not
locate any individual zero, and O83 says individual location is out of
reach at this scale. What it supports is the factoring, not a claim
about any particular zero height.

**CORRECTION, same date, after an adversarial check.** The strength
figures above are overstated and the null that produced them is the
wrong null. Permutation flattens the spectrum by construction, so it
cannot see the γ-trend it needed to control, and list A's frequencies
sit systematically higher than list B's. Range-matched: `D` sits at
percentile **99.10**, one-sided **p = 0.0090**, **z = 2.34** — not
percentile 100.0 at +3.76 sd. Random 15-frequency lists in A's span
score `+0.2344` against the real list B, so roughly 29% of `D` is
trend. Defensible figures: **p ≈ 0.007** at 2^30, **p = 0.0006** on
`{2,3,5}`.

**And half of this entry's reading is not established.** List B
behaves like random frequencies — grid-quantile `0.460` against a
chance `0.500` — and replacing DH's zeros with random frequencies in
the same span leaves `D` at percentile 71.6. That is CONSISTENT with
entry 163 (DH's zeros should look random) but `D` supplies no
discriminating evidence for "DH's zeros command no primes". Four of
list B's apparently-live targets sit within 0.38 of a predicted zero
at a spectral resolution of 0.313, which is leakage rather than
independent mass.

**A conformance defect, recorded plainly.** `psi_dh` does not compute
`ψ_DH`: prime-power mass never accumulates. Max error `9.604` at
`2^14` against `6.4e-14` for a cumulative fix, and the same defect
sits in O83 and O84 by copying. The numbers do not move (`D` to
`+0.8233`, p to `0.0069`) but the locked parameter table and the
script disagree.

No outcome marked; the verdict line in the prereg is Julian's.

---

## 2026-08-25 — Entry 174 — O84: the aggregate is powered where single peaks are not
type: run
refs: 171, 172, 173

Script O84_aggregate_power.py, defaults. Artifacts:
results/aggregate_power.json, results/O84_aggregate_power_run1.log.

Entry 173 closed by naming, without proposing, the one design its
measurement did not rule out: a statistic pooling all targets at once.
Pooling N targets buys about sqrt(N) in aggregate signal-to-noise, and
list A has 15 entries — sqrt(15) = 3.87 against entry 173's 3.72x
shortfall. Close enough to require measurement rather than argument.

**The statistic.** `D = mean over list A of P(gamma)/median - mean over
list B of the same`, on the pooled `{2^m 3^n}` orbit.

**The power test.** Permute the real residual to destroy its structure,
add a mode at every list-A frequency at amplitude `1/|rho|` — the
amplitude the explicit formula gives a single zero — with random phase,
and ask how often `D` clears the permutation null's p95.

```text
injected amplitude          power
1.0x (the formula's own)    0.720
1.5x                        0.950
2.0x                        1.000
```

Null: mean +0.0056, sd 0.2095, p95 +0.3473 over 400 draws, on 307
blocks with residual rms 0.3327.

**Read.** The aggregate is powered where entry 173 found single-peak
detection deaf, and the sqrt(15) estimate predicted it almost exactly.
0.720 is usable and is not 0.9 — a null from this design would carry a
~28% miss rate, and any prereg on it must say so.

The unblinded `D` was deliberately not computed here; the script sizes
the instrument and does not look at the answer.

EXPLORATORY: no prereg, no verdict.

---

## 2026-08-25 — Entry 173 — O83: the pooled successor is underpowered, measured before it was preregistered
type: run
refs: 163, 164, 171, 172

Script O83_pooled_power.py, defaults. Artifacts:
results/pooled_power.json, results/O83_pooled_power_run1.log.

**Why it ran, and why in this order.** Entry 171 retired the DH
coalition question with Julian's condition attached — *if it is
important it will come back*. It came back within the hour, and for a
principled reason rather than a preference: entry 172's
`lean/Nyquist.lean` proves that a b-adic ladder cannot IDENTIFY a
frequency past `pi/log b`, and pooling incommensurate ladders is the
standard escape, which is O18's design. Entry 164 had already named
that successor. Entry 171 also recorded the format defect O81 exposed:
the vacuousness check asks whether a rule can fire in both directions
and never whether the instrument can make it fire. So the power
question was asked FIRST, before any prereg was written.

**Aliasing, as numbers rather than argument.**

```text
O81's ladder 2^(j/4)   Nyquist = pi/log b = 18.129   targets ran to 40
base 2                                    =  4.532
base 3                                    =  2.860
pooled {2^m 3^n}       308 rungs, median log-gap 0.05212, min 0.01355
                       and UNEVENLY spaced, which is the escape
```

Half of O81's target grid sat past its ladder's wall, unidentifiable in
principle. The pooled orbit has no such wall. Aliasing is solved.

**Power by injection.** Permute the real residual to destroy its
structure, add `A*cos(gamma_0 log x)`, and find the smallest `A`
clearing `P/median > 5` in at least 90% of draws. Against `1/|rho|`,
the normalised amplitude the explicit formula gives a single zero:

```text
gamma        A*      1/|rho|   ratio
 6.1836   0.2366     0.1617     1.46
14.8250   0.2508     0.0675     3.72
24.3653   0.2508     0.0410     6.11
```

307 blocks, residual rms 0.3327. A single zero at `gamma = 14.8`
contributes about a fifth of the residual's rms and is buried under the
sum of all the others; the projection cannot concentrate enough at this
block count.

**It does not scale away.** Detection improves as `sqrt(n)`, so closing
the 3.72x gap needs about 14x the blocks. Orbit points grow like `R^2`
in the ceiling exponent, so 307 -> 4250 blocks puts the ceiling near
`2^116`. Not reachable by a larger machine and not by patience.

**Outcome.** The successor design entry 164 named is dead, and dead
before it was locked rather than after another preregistered null. O81
cost a full gated run to learn its instrument was deaf; this cost one
exploratory script. That is the entry-171 defect fixed, working once.

**What the measurement does not say.** It sizes SINGLE-ZERO detection
only. A weaker aggregate observable — whether the spectrum as a whole
tracks list A better than list B — could be powered where individual
peaks are not. That is a different design and would need its own
sizing. It is not proposed here.

The unblinded spectrum was deliberately not computed: the script exists
to size the instrument, not to look at the answer.

EXPLORATORY: no prereg, no verdict.

---

## 2026-08-25 — Entry 172 — The Nyquist no-go formalized: entry 26's theorem-shaped item, eight days later
type: formalization
refs: 16, 26

`lean/Nyquist.lean`, the bench's 21st module, 5 theorems, 5 pins. Entry
26 recorded this as THEOREM-SHAPED on 2026-08-17 and left it
unformalized: "A b-adic sampling of the residual in log x cannot
resolve frequency gamma unless log b < pi/gamma. For gamma_1 that is
b < exp(pi/gamma_1) = 1.2489. Base 2 fails it by a factor of three."

**Why it was worth the kernel, given entry 26's own scope note.** That
entry says plainly this follows from Shannon and is an application
rather than new mathematics. The content that needed checking is not
the inequality but the claim it licenses — that failing it makes a
frequency UNIDENTIFIABLE — which is an existence statement about a
second frequency, and existence statements are what a proof assistant
is for.

**What is proved.**

```text
sample b r          the rungs in log x: r * log b
Aliases b γ γ'      the modes agree at EVERY rung, so no measurement
                    on the ladder separates them
aliases_of_offset   γ' = γ - 2πk/log b aliases with γ, every k : ℤ
nyquist b           the Nyquist frequency π / log b
nyquist_no_go       past it there is ALWAYS a strictly-smaller-modulus
                    frequency that aliases
base_bound_of_resolvable   contrapositive, in entry 26's own form:
                    resolving γ forces b ≤ exp(π/γ)
base_two_past_nyquist      base 2 exceeds its Nyquist frequency at
                    every γ ≥ 14, and γ₁ = 14.134… is such a γ
base_two_fails_by_three    3 * nyquist 2 < 14 — entry 26's "fails by a
                    factor of three", proved rather than asserted
```

The no-go is constructive: the witness is `γ - 2π/log b`, and the
proof that its modulus is strictly smaller is where the Nyquist
condition `π < γ log b` is actually used.

**The numbers are not free parameters.** `base_two_fails_by_three`
needs `3π < 14 log 2`, discharged from `Real.pi_lt_d2` (π < 3.15) and
`Real.log_two_gt_d9`, giving 9.45 against 9.704 — a real margin, not a
rounding.

**Build.** 8047 jobs, 21 modules, 255 theorems, 255 pins, parity in
every module. All five new pins carry
`[propext, Classical.choice, Quot.sound]` and matched on the first
successful compile. `lakefile.toml`'s `globs` is an explicit list, so
`Nyquist` was added there — a new module does not build until it is
named.

**What this says about the bench's own instruments.** Entry 16
measured the same fact from the data side: the dyadic ladder sits at
the 100th percentile against surrogates while showing eight peaks of
identical height spaced `2π/log 2` — signal present, frequency
unidentifiable. That is `nyquist_no_go` seen as a spectrum. It also
explains, rather than merely accompanies, why O18's joint orbit
worked: pooling incommensurate ladders is the standard escape from
aliasing, and O81's single-ladder null is the same wall met again.

**A working-process trap, recorded because it cost a build cycle and
will recur.** A patch was issued as

```text
cd lean && python3 - <<'EOF' ... EOF
PATH=... lake build Nyquist
```

The shell was already inside `lean/`, so `cd lean` FAILED, `&&`
short-circuited, and the patch never ran — but the build on the next
line was not gated by that `&&`, so it ran anyway, on the unchanged
file. It emitted the identical error list as before, including an
error naming the very constant the patch was meant to replace.

The dangerous part is the diagnostic shape, not the shell error.
Identical output after a fix reads as "the fix did not work", and the
next move is to write a different fix. The true state was "the fix did
not run". Three of the twelve errors in that list were already solved.
What broke the loop was checking the FILE — `grep` for the replaced
constant — rather than reading the build again.

The general form: when a fix produces byte-identical failure output,
check that the edit landed before changing the edit. And do not mix
`&&` chaining with multi-line commands whose later lines are not part
of the chain; either gate everything or gate nothing.

No outcome marked.

---

## 2026-08-25 — Entry 171 — O81 stamped `null`, the design retired, and the DH question with it
type: prereg
refs: 163, 164

Julian wrote the verdict line on
`preregs/dh_coalition_spectrum_v1_20260825.md` this date: **`null`**,
with the design retired rather than revised, and the question retired
alongside it. His instruction, recorded verbatim because it is the
scope decision and not a technical one: *retire it — if it is important
it will come back.*

**Why `null` and not `compromised`.** The locked rule's `compromised`
branch is enumerated and closed: τ gate failure, target-list mismatch
beyond 1e-4, fewer than 8 of list A inside the γ grid, or a degenerate
band. None fired — τ residual `-1.694e-21`, list A recomputed inside
the run to the locked values, 15 A-targets against a floor of 8,
`median(P) = 1.5523`. Branch 5 names this case on its own terms:
"anything else, including no hits at all." Reaching for `compromised`
because the outcome was uninformative would be overriding a locked rule
after seeing the result, which is the thing preregistration exists to
prevent.

**The contrast with O48, which is the useful one.** That design was
stamped `compromised` because a locked threshold explicitly fired —
control floor 0.754867 against 0.80 — and it too was retired rather
than revised (entry 110). Same discipline, opposite branch, and the
difference sits in the rule rather than in how the results felt.

**What is being retired, precisely.** The DH-coalition spectral
question: whether the DH-weighted prime residual carries `L(s,χ)`'s
zeros rather than DH's own. Entry 164 named the O18-style pooling
design as the honest successor; it is **not** carried as an open
thread. Entry 163's factoring —
`psi_DH(x) = c·psi(x,χ) + conj(c)·psi(x,conj χ)` — stands in the
notebook as unattacked algebra, neither confirmed nor refuted by
measurement, and is not being pursued.

**What is not retired.** Entries 161 and 162 are findings rather than
open questions and stand on their own: the deep zeros (8,3) and (20,6)
appear in no residue-class table, and DH's zeros are located on the
line to `t = 60` with the first departure at
`σ = 0.808517182457, t = 85.6993484854`.

**The format defect this run exposed, which outlives the question.**
The prereg's vacuousness check asks whether a criterion can fire in
both directions and never asks whether the instrument has the power to
make it fire. This design satisfied the first and failed the second —
119 blocks, a surrogate maximum of 4.352 against a threshold of 5, no
headroom — and the null was predictable in advance had the second
question been asked. Julian's own words when the result came back: *we
ran a prereg with a claim that was possible but lacked the pieces to
make it falsifiable.* That gap is in `preregs/FORMAT.md`, not in this
prereg, and closing it is a separate act from stamping this run.

Verdict stamped by Julian. Design retired. Question retired.

---

## 2026-08-25 — Entry 170 — The operator-over-zeros story, attacked and withdrawn: wrong history, sorted evidence, and a settled inventory ignored
type: result-triage
refs: 111, 165, 169

An assistant told Julian, unprompted, that this tree treats the four
zeros as the object and the difference operator as the instrument while
the evidence runs the other way — the operator durable, the zeros its
least durable feature — and that if B10's accident reading is right it
"costs the programme almost nothing". Julian asked for it to be checked
before it entered the notebook, on the grounds that it was a flattering
story told about the teller's own week. An adversarial read returned it
refuted on three of four parts, with citations.

**The history is wrong at four of five links.** The tables were not
built for the zeros: `imported/lattice_mapper/source_README.md`
describes them as FPGA prime-count lookup artifacts from a mapping
project. The zeros were the NINTH observation made on a table that
already existed (`primebeat/notebook/04_observations/OBS_009_zero_
topology_64bit.md`, following eight prior observations on the same
file). This bench started at O1–O9, every one an operator, spectrum,
exponent or convergence question (entry 1's scaffold inventory); the
zeros become an object here at O16, entry 12, two days in. And the
symbol descends from DT-A5's proof that Δ is not self-adjoint under any
positive diagonal weight, by way of O8 — no zero enters the
derivation of `h(s) = (1−b^(−s))^N (1−b^(s−1))^N` or of its Weil
property, which follow from `h(s) = h(1−s)` and `h(0) = h(1) = 0`.
What survives: the stencil's ORDER is (20,6)'s, and the repo's public
framing is zeros-first — retroactively.

**The asymmetry was sorting, on three counts.** O53's retracted
isogeny split was filed as a zero-placement death; it is a claim about
spectral peaks against folded zeta zeros with no table zero in it — an
operator death moved into the column being built. O82 was counted as a
death when entry 169, the same evening, records that it discriminates
nothing. And fourteen-plus operator deaths were omitted, including the
two that matter most: **O48, the tree's only `compromised` prereg, is a
symbol test**, and **O81, its only preregistered non-detection, is a
projection test** — both drawn from the list called durable. Also
omitted: the crossing prediction's failure, the withdrawn bridge
coordinate, the Gram series divergence, the Weil implementation's four
simultaneous defects, O9's retracted parts 2 and 3.

**Prereg verdicts split three–three.** Zero-side: O42
`no_constant_angle`, O43 `magnitude_floor`, O45 `fineness`. Non-zero
side: O7 `depth_dependent`, O48 `compromised`, O81 mechanical `null`.
There is no survival asymmetry under the only discipline in this tree
that produces verdicts.

**"Costs almost nothing" is quantitatively false.** 165 of 327 pinned
theorems sit downstream of the four zeros — Zeros (31), Nonvanishing
(8), MainTerm (10), Expansion (17), Schoenfeld (2), SeedPerturbation
(20), plus all 77 of lean_stage3, which exists to decompose
StmtSchoenfeld — together with a 328-line paper, a locked prereg
carrying a verdict, and seven scripts.

**Entry 111 had already settled this, the other way.** Its cold read,
three pushbacks, two conceded, agreed by both sides: "one genuinely
novel checkable finite fact — the four zeros, absent from OEIS and the
searched literature — surrounded by a competent numerical re-derivation
of standard theory", with `four_zeros.py` plus the zero-axiom Lean
chain named the strongest artifact. The withdrawn story inverted a
settled inventory without reading it.

**The correction, and it is better than what it replaces.** The split
is not zeros against operator. It is **arithmetic fact against claim of
statistical specialness**. Facts survive on both sides: the four zeros,
the pair identity, the trend gain, the isogeny telescope. Specialness
dies on both sides: density ≈ 1/S, the zero surface, the crossing
prediction, the generator-peak move, the alias split, the small-angle
design, the DH coalition.

**A mechanism for the appearance of asymmetry, which the claim missed.**
Zero claims are exact and finite, so an attack either lands or does not
and the outcome is logged as a death. Operator claims are about trends,
exponents and constants, where a failed prediction is absorbed as a
corrected law rather than recorded as a death — the crossing prediction
failed, the slope law was rewritten post hoc, and O75 later tested the
rewrite. Differential recording produces the observed asymmetry with no
difference in underlying durability.

**Also corrected in part 2, which survived.** Four of the seven
instruments called independent are algebraic identities, calibrations
against published theory, or checks that presuppose their own answer:
the trend gain (b−1)/b is derived in CONTEXT.md and cannot fail a
control; O64, O65 and O72 measure the primes with standard instruments
and say so in their own docstrings; the Weil balance is, by entry 40's
own caveat, a normalisation check that presupposes the zeros lie on the
line, and it is measured at N = 7 only.

**On the phrase itself.** "Costs the programme almost nothing" is not a
measurement — no unit, no baseline, no alternative — and it arrived
directly after a result that went against the programme's founding
object, which is when a consoling sentence is most attractive and least
earned. Verdict lines, NOTEPAD transitions and outcome markings are
Julian's under this project's rules, and those are enforced by
checkers; the same rule in prose has no checker, and was not followed.
Recorded here because entry 144 names precisely this failure — an
LLM issuing preference as finding — and the assistant that wrote entry
144 then did it.

Two staleness items found in passing: CONTEXT.md's Lean subsection
says "as of entry 165" while the notebook runs past it, and README.md
states 16 modules / 213 theorems against the present 20 / 250 — the
same drift entry 111 caught once already.

No outcome marked.

---

## 2026-08-25 — Entry 169 — Correction: O82 measured position, not exactness; "deflationary" was an inference the instrument does not license
type: result-triage
refs: 160, 165

Julian's catch, and it is the fifth correction layer of the day — the
first from him rather than from an instrument.

**What entry 165 said, and what I said past it.** Entry 165 reported
that at matched `n` the exact-zero set is indistinguishable from the
nearly-zero sets, and glossed that as "exact vanishing does no work
that near vanishing does not". In conversation I then built on it,
describing the state of the central question as leaning
**deflationary**. Both go further than the measurement.

**The gap, stated as Julian stated it.** If exactness sat at one end of
a continuum, the near-vanishing selections should show a gradient. They
do not, and they are not even monotone:

```text
selection            z_cross_wm at matched n = 54
P == 0 (zeros)             -3.56
|P| == 1                   -2.40
|P| == 2                   -3.86
1 <= |P| <= 3              -3.30
```

`|P| = 2` reads "stronger" than `|P| = 1`, which no continuum story
predicts, and the subsample spreads of 0.7 to 1.2 swallow the
differences. A statistic that cannot order `|P| = 1` against
`|P| = 2` has no standing to say whether `|P| = 0` is special. The
absence of a gradient is what one would observe whether or not
exactness does work, so it discriminates nothing.

**Why, structurally.** The statistic is a nearest-neighbour distance in
the `(lo, hi)` window plane — it measures POSITION. Exactness is a
property of the cell's VALUE. Cells with `P = 0` and cells with
`|P| = 1` occupy the same rows, the same depths and the same windows,
so a positional statistic cannot separate them by construction. This is
entry 160's FATAL 3 from the other side: matching both coordinates is
the identity map because `(r,d)` determines the window, and by the same
token the window cannot report the value.

**What O82 licenses, corrected.** Exact vanishing does not predict
window position differently from near vanishing. That is a statement
about the coordinate, not about the zeros. Entry 165's phrasing
collapsed the two, and the conversational "deflationary" reading built
a claim about the programme on top of the collapse.

**What survives unchanged.** The mass result: `S <= 200` reaches
`-6.03`, outrunning every value-based selection, and that IS a
statement about which cells sit where, since stencil mass and window
geometry are both positional. The `d <= 3` collapse to `-0.13` also
stands, and entry 165's correction of entry 160's FATAL 2 headline
stands: that part was about sample size and is unaffected.

**Where B10 stands after this.** Where it stood before tonight —
unattacked, and not supported either. O82 did not test it. Entry 165's
findings about what `magnitude_floor` actually tested (a constant
per-cell rate, not magnitude) and about entry 17's refusal of
magnitude-null arguments are independent of this correction and stand.

No outcome marked.

---

## 2026-08-25 — Entry 168 — O61 given flags and the guard; the sub-integer crossing sweep now has an artifact
type: instrument-fix
refs: 100, 166

**Why.** Entry 166 recorded that entry 100's decisive O61 numbers — the
sub-integer sweep at `b = 1.15`, 197 rungs, crossing depth 4.02 — are in
no artifact. `results/crossing_depth_sweep.json` held only the bases 2–9
sweep and the base-2 truncation control, because the script's bases were
an inline constant `BASES = [2,…,9]` and it structurally could not run a
sub-integer base.

**The instrument fix.** `--bases`, `--ceiling`, `--truncations`, `--out`
and `--no-json` added, defaults byte-identical to the old inline
constants; `--bases` accepts floats, which is what makes the sub-integer
sweep runnable at all. The results write now routes through
`utilities.resultsguard.guarded_write` (entry 166), so a re-run archives
the previous artifact rather than overwriting it — O61 is the second
script retrofitted, after O66.

**Defaults verified before anything new was run.** A no-flag run
reproduces the recorded truncation control exactly: crossing depth 11.93
at 45 rungs down to 4.24 at 20, spread 7.70, fraction-of-rungs spread
0.053 (0.212 to 0.265).

**The run that produces the missing artifact**, `--bases
"1.15,1.5,2,3"`, ceiling 1e12:

```text
    b  rungs  crit=b^-1/2  cross depth  cross/rungs
 1.15    197     0.932505         4.02        0.020
  1.5     68     0.816497         7.17        0.105
    2     39     0.707107        10.08        0.258
    3     25     0.577350        15.46        0.618
```

Entry 100's `b = 1.15` / 197 rungs / depth 4.02 reproduces exactly. The
confound that entry stated in advance is visible across the row: the
crossing is neither a fixed depth nor a fixed fraction of rungs —
`cross/rungs` runs 0.020 to 0.618 over four bases.

**Provenance, stated because the order matters.** The artifact
postdates the entry that cites it. Entry 100 quoted these numbers from a
transcript in 2026-08-22; `results/crossing_depth_sweep_subinteger.json`
and its run log were produced 2026-08-25, after entry 166's audit found
the gap. The numbers agree, so this is a backfill of evidence and not a
correction — but a later reader should know the artifact was made to
support the claim rather than the claim read off the artifact.

No outcome marked.

---

## 2026-08-25 — Entry 167 — O52 has a run and no record; this is the record
type: provenance
refs: 166

Entry 166's audit found `O52_composite_arm_spectrum.py` with a results
JSON and a run log and **no lab_notebook entry and no NOTEPAD line
anywhere in the tree**. A run existed with no dated record. This entry is
that record, written 2026-08-25 from the artifacts rather than from
memory of the run.

**What it measures.** Whether the composite arm carries the prime arm's
zeta spectrum. On O50's fine ladder — ratio 1.002, `x0 = 1e5`,
`xmax = 1e11`, 6914 blocks, dps 30.

**What it returned.**

```text
max |e_prime + e_comp|        1.4901161193847656e-08
max |e_prime|                 3392.64646257367
ratio                         4.392e-12
zeros tested                  599
max amplitude difference      5.005773573429906e-12
median amplitude, prime       6.783755440398383
median amplitude, composite   6.783755440396217
```

**How to read it.** The two arms' residuals cancel to a relative 4.4e−12
and their amplitudes at 599 zeros agree to 5.0e−12. That is not a
discovery: the pair identity forces `e_comp = −e_prime`, so the run is a
confirmation of arithmetic already proved in
`lean/PairIdentity.lean`. Its value is that the confirmation now has an
artifact behind it and a dated line pointing at it.

**Provenance.** `results/composite_arm_spectrum.json` and
`results/O52_composite_arm_spectrum_run1.log` predate this entry. The
run date is not recorded anywhere; only the artifacts' existence is
evidence that it happened. EXPLORATORY, no prereg, no verdict.

No outcome marked.

---

## 2026-08-25 — Entry 166 — resultsguard: the clobber hazard closed structurally, and three record gaps found
type: instrument-fix
refs: 102, 105, 107

**The hazard, and why git did not catch it.** Run logs in this tree are
run-stamped (`O66_twin_spectral_run1.log`), so a second run writes a
second file and both survive. Results JSONs are not
(`twin_spectral.json`), so a second run overwrites the first. O63, O65
and O66 each lost run 1 that way. Checked rather than assumed: each of
`results/value_refraction.json`, `results/variance_ratio.json` and
`results/twin_spectral.json` carries exactly ONE commit, so the clobber
happened before anything was committed and there is no earlier version
in history. Run 1's numbers for all three survive only inside the run-1
logs. Same script, same run, opposite outcomes for log and JSON, purely
from a naming convention.

**The fix.** `utilities/resultsguard.py` — `guarded_write(payload,
out_path)` copies an existing, DIFFERING file to
`results/archive/<stem>_<utc>_<sha8>.json` before writing the new one.
Nothing is deleted, which the project's permissions require, and each
canonical results path keeps resolving, so every paper, prereg and
notebook citation is untouched. Content is compared with `generated_utc` and the
run-time fields blanked, so a deterministic rerun differing only in its
timestamp archives nothing.

**The gate.** `utilities/check_results_guard.py` scans every `O*.py`,
`0*.py` and `t*.py` for a write into `results/` and reports whether it
routes through the guard. Report mode now; `--new-only` fails when a
script NEWER than the guard is unguarded, so nothing new can ship
without it while the legacy sweep is outstanding; `--enforce` for once
the sweep lands, wired beside check_refs and check_values.

**The gate missed its own motivating case, twice, and is recorded that
way.** The first pattern matched `json.dump(` and slid past
`json.dumps(...)` piped through `pathlib.write_text` — exactly how O66
writes. Widened, still zero: the second filter looked for a literal
`results/`, and O66 builds its path as `"results" / "twin_spectral.json"`
in pathlib components. Both found by running the instrument against the
scripts it exists for before trusting it. **The true writer count is 77,
not the 49 the first pattern reported** — the initial estimate of the
retrofit's size was 36% low.

**State.** O66 retrofitted as the pattern proof, parses clean, guard
verified on synthetic input (timestamp-only rerun archives nothing, a
content change archives the prior run, the canonical path always holds
the current one). 76 writers remain. That sweep is entry-148-shaped —
mechanical per script, and it owes a re-run at defaults per script to
prove zero drift — and is queued, not done.

**Three record gaps found while backfilling CONTEXT.md**, stated plainly
because each is a hole rather than an error:

```text
O52   has results/composite_arm_spectrum.json and a run log, and NO
      lab_notebook entry and no NOTEPAD line anywhere in the tree. A
      run exists with no dated record.
O61   entry 100's decisive numbers for it — the b = 1.15 sweep at 197
      rungs crossing at depth 4.02, and the truncation-offset table —
      are in no artifact. results/crossing_depth_sweep.json holds only
      the bases 2-9 sweep and the base-2 truncation control.
O64   the run-1 log prints a conclusion ("the real arm sits nearer the
      model arm") that entry 103 withdraws. The log is frozen evidence
      and stays; the withdrawal lives only in the entry.
```

No outcome marked.

---

## 2026-08-25 — Entry 165 — O82: entry 160's FATAL 2 was a sqrt(n) artifact; exactness still does no work; mass does more
type: result-triage
refs: 17, 46, 160

Script O82_exact_vs_near.py, defaults. Artifacts:
results/exact_vs_near.json, results/O82_exact_vs_near_run1.log.
Built because a tree audit found entry 160's FATAL 2 numbers existed
ONLY inside that entry — no script, no artifact, nothing to re-run —
while being the finding that most constrains any design built on the
exact-zero set.

**Panel 1 reproduces entry 160 faithfully** (different RNG stream,
same construction: O78's incommensurate bases, O45's resolved
stratum, The-Zero-Surface B3's coordinate):

```text
selection                    n    z_cross   z_cross_wm
P == 0 (the zeros)          54      -7.26        -3.59
|P| == 1                   106      -9.06        -2.83
|P| == 2                    90      -9.97        -4.88
1 <= |P| <= 3              280     -15.28        -5.53
S <= 200 (mass cut)        548     -28.84       -20.03
d <= 3 (never reads P)    1659     -38.66       -12.95
```

**Panel 2 corrects it.** Entry 160's own FATAL 4 established that
permutation z scales as sqrt(n); FATAL 2's table compares selections
of size 54 to 1659 and is therefore not comparable across rows — the
very error FATAL 4 names, committed in the same entry. Subsampling
every selection to n = 54, 60 repeats:

```text
selection                  z_cross        z_cross_wm
P == 0 (the zeros)     -7.23 ± 0.00      -3.56 ± 0.00
|P| == 1               -6.93 ± 0.73      -2.40 ± 1.19
|P| == 2               -7.23 ± 0.49      -3.86 ± 0.70
1 <= |P| <= 3          -7.08 ± 0.80      -3.30 ± 1.22
S <= 200 (mass cut)    -8.86 ± 0.57      -6.03 ± 0.56
d <= 3 (never reads P) -6.44 ± 0.63      -0.13 ± 1.00
```

**What changes.** Entry 160's headline — "a pure geometric cut that
never looks at a cell's value compresses far harder than the zeros
do" — does not survive. At matched size, d <= 3 collapses to -0.13
under width matching, pure null, while the zeros hold at -3.56. The
apparent dominance was sqrt(1659/54) = 5.5x of inflation.

**What survives, and it is the constraining part.** Exact vanishing
is indistinguishable from near vanishing: the zeros at -3.56 against
|P| = 1 at -2.40, |P| = 2 at -3.86, 1 <= |P| <= 3 at -3.30, with
subsample spreads 0.7 to 1.2. Nothing in this statistic separates the
exact-zero set from the nearly-zero set.

**And mass outruns both.** S <= 200 is the strongest selection in the
table at -6.03, clear of the zeros. The compression tracks stencil
mass more closely than any property of the cell's value, which is
O46/C5's identification seen at matched size rather than asserted.

**What was NOT asked, and why.** No expected number of exact zeros
under any magnitude null is computed here. Entry 17 records Julian's
correction and it stands: the cells are a determined binomial
combination, not independent draws, and (20,6) is an exact identity
across seven consecutive counts, so "how probable is that" imports a
null model the object does not have. A tree audit this date found
that an assistant had proposed exactly that computation, unaware the
record already refused it. The question O82 asks instead is a
comparison between selections on one object, which imports no such
model.

**Also established by that audit, and worth stating plainly.** B10 in
papers/The-Four-Zeros.md cites O43's magnitude_floor verdict. That
verdict's null is a CONSTANT PER-CELL RATE — each d >= 1 cell an
independent Bernoulli with one shared q — and its own prereg
falsified uniformity before the run (190 of 1891 cells have r <= 20
and all four zeros are among them; probability 1.019e-4). Its
magnitude content is one deterministic bound, M_new = 0: no cell in
62 < r <= 92 came within 1024 of zero. No expected-zero-count under a
magnitude null exists in the tree for base 2's four. B10's prose is a
fair reading of the branch's name; the branch's arithmetic is a rate
test.

**Three layers of correction, recorded as such.** An assistant claimed
a cross-base surface; an adversarial review retired that reading with
FATAL 1-4; O82 now corrects FATAL 2's headline while confirming its
core. Each layer was caught by the next, and none by its author.

EXPLORATORY: no prereg, no verdict.

---

## 2026-08-25 — Entry 164 — PREREGISTERED non-detection: the ladder does not separate the two spectra
type: run
refs: 161, 162, 163

Script O81_dh_coalition_spectrum.py under
preregs/dh_coalition_spectrum_v1_20260825.md, locked at sha256
9f500ecd2eb81ce7b9615a62c2db94e4e5d2ad51775548e87af8d9d6c1f044d7
before the run. Artifacts: results/dh_coalition_spectrum.json
(sha256 eec3c729a1e6a154...), results/O81_dh_coalition_spectrum_run1.log.
The prereg's Run record is filled; its verdict line is Julian's.

**What was asked.** Entry 163 factored the DH-weighted prime sum as
psi_DH(x) = c*psi(x,chi) + conj(c)*psi(x,conj chi), so the residual
should carry the zeros of L(s,chi) — list A, 15 heights to gamma = 40
— and NOT DH's own zeros — list B, 8 heights from entry 162. The two
lists are disjoint: no pair within 0.01, against a band half-width of
0.6.

**Gates, all passed.** tau residual -1.694e-21. List A recomputed
inside the run: 15 zeros, matching the locked values to better than
1e-4. List B as locked. 119 blocks on the 2^(j/4) ladder to 2^30,
log-x span 20.448, band half-width 0.6000, median(P) = 1.5523.

**The result.**

```text
hits on list A (L(s,chi) zeros), P/median > 5:  0 of 15   ambiguous 5
hits on list B (DH's own zeros), P/median > 5:  0 of 8    ambiguous 3
surrogate P_max/median:  median 2.593   p95 3.468   max 4.352
```

Mechanical decision-rule output: **null** — the fifth branch,
"anything else, including no hits at all."

**What this does and does not settle.** It does not support H1 and
does not refute it. Entry 163's factoring is untouched by this run: it
stands as unattacked algebra, not as a measured claim. The instrument
did not separate the hypotheses at this ladder length, which
§ Vacuousness check named in advance as a live outcome ("null is live
... a non-detection at this length would not be surprising — O18's
single-base ladders returned NULL at comparable lengths").

**Why the length is the likely cause rather than absence.** No peak in
the real spectrum cleared P/median = 5, and the surrogate maximum
itself reached 4.352, so there was little headroom above the
permutation noise for any signal to clear. O18's detections came from
POOLING incommensurate ladders — a single geometric ladder aliases,
which was that design's whole point, and this test used one. Eight of
the 23 targets fell in overlapping bands and were scored for neither
list, which costs further sensitivity.

**What would answer it**, and it is a new prereg rather than a rerun:
the O18 pooling design applied to the DH-weighted residual. Re-running
THIS design deeper would be fishing, and is declined on that ground.

No outcome marked; the verdict line in the prereg is Julian's.

---

## 2026-08-25 — Entry 163 — The coalition governs nothing: why DH's zeros are absent from prime data, and the object that unblocks the test
type: motivation
refs: 36, 103, 160, 161, 162

Entries 161 and 162 both closed on the same gap: a crossing-slope
comparison needs an object DH actually governs, and naming that object
was an open design question. Julian's frame supplied it, and the
algebra rather than the analogy is what settles it.

**Julian's frame, in his words.** "What if DH is the repulsion? ...
each test we ran was an abstraction from our stacked sequence, by the
time you get to DH the combination looks random but within the noise
there are local sequences that reconstruct the beat at its lowest
frequency to still influence it, like a low hum you only notice if you
pay attention or notice the pattern. Think of it like state, regional,
and local governments that differ at each level but agree on a
constitution."

**The decomposition that makes it testable.** With chi the order-4
character mod 5 — chi = (1, i, -i, -1) on classes 1..4, taking 2 as
the primitive root — the DH coefficient sequence (1, tau, -tau, -1) is
exactly c*chi + conj(c)*conj(chi) with c = (1 - i*tau)/2. Derived here
and matching the literature form. Therefore the DH-weighted prime sum
factors:

```text
psi_DH(x) = sum_n Lambda(n) a(n mod 5)
          = c * psi(x, chi) + conj(c) * psi(x, conj chi)
```

and each term is governed, through its own explicit formula, by the
zeros of L(s, chi) — on the critical line under GRH. DH's OWN zeros
never enter. They are the locus where the combination
c*L + conj(c)*conj(L) vanishes, a statement about the two
L-functions' relative phase, not about any counting function.

**The consequence, stated before any run.** The DH-weighted prime
residual should carry peaks at the zeros of L(s, chi) mod 5 and NOT at
DH's own zeros — not at 5.0941598, not at the off-line pair
(0.808517, 85.699348) and (0.650830, 114.163343) that entry 162
located. The noise has a beat; it is the local spectrum, never the
coalition's.

**Why this is the whole point rather than a technicality.** It is the
precise reason Davenport-Heilbronn violates the RH-analogue without
threatening RH: its zeros command no primes, because it has no Euler
product. The grandfather loop of Julian's earlier framing — the object
built from the primes that then governs them — binds only where the
Euler product is. His governments analogy maps onto that almost
exactly: the classes mod 5 are local spectra, zeta is the federal one,
the shared constitution is the functional-equation shape which all of
them honour, and the tau-weighted combination is a coalition that
satisfies the constitution while governing nothing.

**On repulsion.** Entry 103 measured this bench's low-height zeros as
stiffer than the GUE surmise (0.027 against 0.106), and O64 carries
the spacing machinery. Whether DH's off-line zeros are repelled from
the line, or its on-line zeros spaced differently from zeta's, is
measurable with instruments already in the tree and is not tested
here.

**Status.** This entry is the reasoning, recorded before the run, so
that the prereg it motivates cites a dated argument rather than a
remembered conversation. The prediction can fire in both directions:
peaks at L(s,chi)'s zeros and not at DH's would confirm the
decomposition; a peak at 5.0941598 would refute it and mean the
factoring above is wrong.

No run, no verdict.

---

## 2026-08-25 — Entry 162 — DH's zeros located: on the line to t = 60, off it at 0.8085 + 85.699i
type: run
refs: 36, 161

Script O80_dh_zeros.py, defaults. Same object and same gates as entry
161: tau checked against the eigenvector condition (residual 5.2e-26)
and the completed function's functional equation checked at three
off-line points (max 9.6e-26) before any zero is sought. Artifacts:
results/dh_zeros.json, results/O80_dh_zeros_run1.log.

The numbers were first obtained in throwaway computations during the
exploratory pass; this script exists so the tree carries nothing it
cannot regenerate, and it reproduces them.

**On-line zeros** (sign changes of a Hardy-type real function on
sigma = 1/2), t up to 25:

```text
5.0941598  8.9399144  12.133545  14.404003
17.130239  19.308800  22.159708  23.345370
```

Eight, the lowest at 5.094 against zeta's 14.134725.

**Off-line zeros, counted before they were sought.** Winding number of
f around rectangles with Re s in (0.51, 1.6):

```text
t in (0, 30)     winding 2.0e-26   ->  0 zeros
t in (30, 60)    winding 7.0e-26   ->  0 zeros
t in (60, 90)    winding 1.0       ->  1 zero
t in (90, 120)   winding 1.0       ->  1 zero
```

Then located by grid-seeded Newton:

```text
sigma = 0.808517182457   t = 85.6993484854    |f| = 5.8e-26
sigma = 0.650830080610   t = 114.163342731    |f| = 1.0e-25
```

displaced 0.3085 and 0.1508 from the line, each with a mirror partner
at 1 - sigma. The argument principle is the honest half of this: it
counts without finding, so a failed search cannot be reported as an
absence.

**Why it matters to the bench's law.** Entry 36's crossing-slope law
takes its mode gain from |1 - b^(-rho)| at the lowest zero with
Re rho = 1/2 ASSUMED. A zero at sigma > 1/2 is less suppressed by the
depth operator. These are coordinates where that assumption is false,
for a function assembled from the same primes the bench counts.

**The gap that still blocks a prereg**, unchanged from entry 161: the
DH arm carries no integer table, so there is no exact-zero census to
compare, and a crossing-slope comparison needs an object DH actually
governs. Naming that object is the open design question. Nothing here
is a comparison; these are coordinates.

EXPLORATORY: no prereg, no verdict.

---

## 2026-08-25 — Entry 161 — The same primes sorted mod 5: the deep zeros are a property of the total
type: run
refs: 158, 160

Julian's question after entry 160 fixed the retry's design. The
adversary's proposal — rebuild the table over the DH coefficients —
was degenerate on instantiation (they sum to zero over a period, so
the partial sum is bounded and periodic). His question was: our table
is integers, so what integers are there and do they coincide with
ours. They do, and exactly: DH(s) = c L(s,chi) + conj(c) L(s,conj chi)
for chi the order-4 character mod 5, and each L has an Euler product
over the ordinary primes. The combination destroys the Euler product;
the ingredients are our own primes, sorted.

Script O79_residue_class_tables.py, defaults (rmax 30, segmented
sieve, exact integers). Artifacts: results/residue_class_tables.json,
results/O79_residue_class_tables_run1.log.

**Gates passed before measuring.** tau = 0.28407904384 in the
literature form (sqrt(10-2sqrt5)-2)/(sqrt5-1), checked against the
independently derived eigenvector condition tau^2+(1+sqrt5)tau-1 = 0
at residual 3.9e-31; the completed function's functional equation
|xi(s)/xi(1-s) - 1| < 1.6e-30 at three off-line points. The sieve
reproduces the bench's four zeros exactly, which is the machinery
check.

**Arm 1, zeta.** pi(2^30) = 54400028; exact zeros to r = 30 are
(2,1), (4,1), (8,3), (20,6). As on record.

**Arm 2, the four classes.** Class counts at 2^30 are 13599341,
13600508, 13600519, 13599659, plus the single prime 5. Exact zeros:
5, 3, 5, 6 across classes 1..4, nineteen in all. The shallow pair
appears scattered — (2,1) in classes 1 and 4, (4,1) in class 4 — at
counts where vanishing is cheap. **(8,3) and (20,6) appear in NO
class table.** The deep zeros do not survive the split.

**Arm 3, Davenport-Heilbronn.** The tau-weighted combination is an
integer in 10 of 30 rows, and all ten are exactly the rows where
c2 = c3 makes the tau terms cancel. Integrality is an accident of
class balance, not a property of the combination, so the DH arm has
no exact-zero object to census. That is the finding, not an obstacle:
the tau-weighting is what removes the arithmetic.

**What this licenses, and what it does not.** It licenses: the deep
zeros are a property of the total prime count, not inherited from any
residue class of it. It does not license any statement about zero
LOCATION, on-line or off, because the DH arm carries no comparable
object — the three-way comparison the design promised is available
for two arms, not three. Whether the crossing-slope law behaves
differently across the arms is untouched here and needs DH's zeros
located first.

EXPLORATORY: no prereg, no verdict.

---

## 2026-08-25 — Entry 160 — O78 does not measure a surface, and four of my claims were wrong
type: result-triage
refs: 40, 54, 56, 92, 152, 157

An adversarial review, briefed with Julian's position verbatim and told
to attack the translation as well as the statistics, returned findings
that retire the reading I gave in conversation. It retracted six of its
own findings under self-attack. The decisive numbers below were
recomputed here independently.

**FATAL 1 — the control that decided the original reading was dropped
from the copy, and it still fires.** t22_zero_surface.py computes the
same statistic WITHIN a base; that control is why
The-Zero-Surface.md C3 reads "the compression is not about crossing
bases. It is present at every base separately." O78 copied C1 and C6
and omitted it. Recomputed on O78's own base set:

```text
                  cross-base    within-base
raw z                -7.20         -7.06
width-matched z      -3.71         -4.79
```

The within-base control fires as hard raw and HARDER width-matched. By
section C's own logic applied to O78's own data, nothing here is about
crossing bases.

**FATAL 2 — exact vanishing does no work.** The same pipeline, same
bases, same nulls, with the selection criterion changed:

```text
selection                     n      z_raw   z_width-matched
P == 0 (the zeros)           54      -7.25       -3.68
|P| == 1                    106      -9.44       -2.69
|P| == 2                     90      -9.68       -5.16
stencil mass S <= 200       548     -29.47      -19.17
d <= 3 (never reads P)     1659     -39.06      -13.31
```

A pure geometric cut that never looks at a cell's value compresses far
harder than the zeros do. The statistic detects that shallow, low-mass
cells occupy a sub-region of a support dominated by deep ones — O46's
stencil-mass selection, which C5 already identified.

**FATAL 3 — the test cannot separate the hypotheses.** At fixed b the
map (r,d) -> (lo, hi) is injective and log2 b >= 0.2546 at every base
in the run, above the +-0.25 matching tolerance. A null matched on both
coordinates has pool size exactly 1 for all 54 zeros; the null variance
is zero and z is undefined. In this coordinate "forms a surface" and
"is concentrated in a sub-region of its support" are the same
statement. The statistic licenses "not uniformly placed in the
support" and nothing more.

**FATAL 4 — "halved, not collapsed" was sample size.** Permutation z
scales as sqrt(n); section C had 125 zeros, O78 has 54. Rescaling
section C by sqrt(54/125) = 0.657 predicts -7.30 and -3.50 against
O78's observed -7.20 and -3.71. The scale-free ratio obs/null under
width matching is 0.7055 for section C and 0.7025 for O78. Removing
the lattice removed nothing measurable.

**Fragility.** --alpha is a free parameter and was never swept; across
section F2's legal window the width-matched z ranges from -0.90 to
-6.89, with three of seven legal values under |z| = 1.6. Dropping the
single base p = 5 takes the width-matched z to -1.18.

**Gate 1 does not establish what it says.** It tests EXACT cross-base
edge coincidence, which is measure-zero: perturbing O45's own
commensurate set by a relative 1e-7 makes it PASS. The discriminator
that works is the near-coincidence rate (O78: 5 against ~12 expected
for generic points; O45: 905 of 918 edges), which the script computes
and then discards in favour of the gate that cannot discriminate.

**Corrections to claims I made in conversation, all mine.**

```text
1. The fixed-point set of s -> 1-s is the single point {1/2}, not the
   critical line. The line is the fixed set of the ANTI-holomorphic
   s -> 1-conj(s), which needs the functional equation AND Schwarz
   reflection. Two ingredients, and the distinction is the content of
   the "two sides" question.
2. "Zeros are transversal intersections" of the graph with {w=0}
   assumes every zeta zero is simple, which is open.
3. O73's 1.7e-11 is the best cell of a grid whose relative differences
   run to 4.3e-6; entry 152's own summary states the range.
4. "Cannot anchor on the line" overstates. JensenCount's centre sits at
   2+iT because that is where a uniform lower bound on |zeta| is
   PROVED (zeta_centre_lower, from the Dirichlet series at Re s = 2),
   not because no control point could be on the line.
```

**Miscitation, and it points the other way.** I cited entry 92 as this
bench's record of the measurement circularity. Entry 92 is O56, about
what the "1" in sigma + (1-sigma) = 1 is, and it REFUSES exactly the
move I cited it for: "Nothing carries the arm swap through the log map
to the functional equation, and the numeral 1 appearing on both sides
is doing more work in the analogy than it has earned." The circularity
is recorded at Connes-Measured.md line 141, Euler-Factor-Chain.md
section J5, and What-Didnt-Work.md line 189. Entry 40's quotation was
correct and verbatim; The-Four-Prime-Peak.md contains no circularity
claim.

**What is sound.** The base set is genuinely incommensurate
(sqrt(p_i/p_j) irrational for distinct primes; alpha cancels in every
ratio). The construction is faithful to O45 on the P recursion,
r_thick, the resolved stratum, and r_max, and the float arithmetic was
verified against mpmath at dps 60 with zero mismatches at all ten
bases. The statistic and both nulls are faithful copies of t22 for
what was copied. The run reproduces. Labelling discipline held
throughout.

**Where this leaves section G1.** Unmeasured, as it was. O78 does not
move it. The one thing gained is negative and worth keeping: in this
coordinate the question cannot be answered, because controlling both
coordinates is the identity map.

EXPLORATORY: no prereg, no verdict.

---

## 2026-08-25 — Entry 159 — The Jensen count repaired: radius 7/4, 15 log T + 73
type: formalization
refs: 130, 157, 158

Entry 158's finding applied. `zetaWindow` moves from radius 3/2 to
7/4, so the disk now reaches |gamma - T| <= sqrt(0.8125) ~ 0.901 at
the critical line instead of touching it at a point.

```text
zeta_local_zero_count (T >= 2):
    sum of zeta zero orders in ‖s - (2+iT)‖ <= 7/4
      <=  15 * log T + 73
localCount_holds : StmtLocalCount zetaLocalCount 15 73
```

Instantiation: ZerosBound at r = 7/8, R = 15/16, B = 84T. The Jensen
constant is 1/log(15/14) <= 15 (was 1/log(7/6) ~ 6.49); log 84 <=
4.86 gives the additive 73. Entry 130's budget allows A1 <= 100 and
A3 <= 1000, so the doubled constant costs nothing that matters —
this is what crude-explicit is for.

**What moved and what held.** Re-derived at the wider majorant
radius 15/8: `zeta_disk_upper` (‖zeta w‖ <= 28T, was 14T on 7/4 —
Re w >= 1/8 rather than 1/4 propagates through the chain),
`jensenF_bound`, and the final assembly. Verified rather than
assumed to survive: `pole_away` (buffer 11/10 still covers the
pulled-back 7/8), `zetaWindow_finite` (subset-of-radius-2),
`zeta_centre_lower`, the analyticity lemmas, and the affine
order-transfer lemma. The Finset.sum_nbij' transport needed only
rescaled bounds.

**Gates.** Build green at 8720 jobs, zero errors; all 17 pins in
JensenCount and 4 in ArgCrude carry
[propext, Classical.choice, Quot.sound] — no new axiom dependency;
theorem/pin parity 77/77 across eight modules; check_refs and
check_weld exit 0.

**Two stale pin references fixed.** Both named the old pin 751a8c2
after entry 156's bump: this project's CLAUDE.md (fixed in entry
157, on approval) and the weld header of lean_stage3/Stage3.lean
(fixed this date). Both now read 47fa486.

**Ledger.** {hEF, StmtArgCrude}. StmtArgCrude's analytic core is
discharged and now reaches the zeros it must count; what remains is
the rectangle identity and Backlund's step, both classical. Per
entry 158, each gets a consumer instantiation before any Lean work.

---

## 2026-08-25 — Entry 158 — O77: leaves have consumers, and the interface is where this bench was blind
type: instrument-fix
refs: 71, 132, 133, 157

**The gap in the discipline.** Entry 132 asks whether a named leaf
CAN be true. Entry 133 asks whether a hypothesis pair can hold
JOINTLY. Neither asks whether what a leaf DELIVERS fits what its
consumer EATS. Entry 157's Jensen count passed both checks and
failed that one.

**The defect.** The count's window was the disk
‖rho - (2+iT)‖ <= 3/2. A zero at 1/2 + i*gamma sits at distance
sqrt((3/2)^2 + (T-gamma)^2), which is <= 3/2 only when gamma = T
exactly — the disk is TANGENT to the critical line. So the count is
0 for almost every T, and StmtSFromLocal, its consumer, would then
read |S(T)| <= b: S bounded, which is false (Selberg). The theorem
was true, non-vacuous, and kernel-checked, and it could not feed the
next statement in its own chain.

**The instrument, which already existed.** O71 instantiated an
UPSTREAM statement numerically and showed it undischargeable as
stated. O77_leaf_instantiation.py is that same move aimed at our own
tree: it computes S(T) = N(T) - (theta(T)/pi + 1) from zeros600.json,
computes the count at candidate radii, and reports whether the
interface can hold.

```text
radius  half-width  cnt=0 frac  max cnt  max|S| where cnt=0  verdict
 1.500      0.0000       1.000        0              1.0677  CANNOT FEED
 1.750      0.9014       0.121        3              0.5083  FEEDS CONSUMER
 1.875      1.1250       0.051        3              0.4030  FEEDS CONSUMER
```

|S(T)| over the grid T = 20..900: max 1.0677 at T = 415.5, mean
0.3123. At radius 7/4 the empirical relation |S(T)| <= 0.462*cnt(T)
+ 0.508 holds across the grid — the consumer's shape is satisfiable
and the constants we must prove are the right size.

**The rule this adds.** Every leaf gets its budget (entry 130), its
discharge sketch (entry 132), and now its CONSUMER INSTANTIATION:
what it produces, evaluated in the regime the consumer lives in.
The kernel cannot see this — it checks that proofs follow from
statements and has no opinion on whether a statement is useful.
Artifacts: results/leaf_instantiation.json,
results/O77_leaf_instantiation_run1.log.

EXPLORATORY: no prereg, no verdict.

---

## 2026-08-25 — Entry 157 — JENSEN COUNT DISCHARGED: the Arg half's analytic core, 7 log T + 30
type: formalization
refs: 130, 141, 156

Two modules landed. `lean_stage3/Stage3/ArgCrude.lean` (4 theorems)
decomposes the argument half into three named pieces and proves the
assembly; `lean_stage3/Stage3/JensenCount.lean` (17 theorems)
discharges the piece that was the analytic core.

**The decomposition.** `StmtArgIdentity θ S` (the rectangle
argument-principle identity `N T = θ T / π + 1 + S T`, no bounds
asserted), `StmtLocalCount cnt A₁ A₃` (a local zero count growing
like `log T`), `StmtSFromLocal S cnt a b` (Backlund's step from the
count to the argument). `argCrude_of_pieces` assembles them into
`StmtBacklundArg θ (a·A₁) (a·A₃+b)`, and
`rvM_of_stirling_and_pieces` carries that to
`Riemann_vonMangoldt_bound` against the already-discharged Stirling
half (entry 140). The count is abstract in the statement for entry
132's reason: a named leaf whose satisfiability is untested is how
that correction was earned.

**The discharge, with explicit constants.**

```text
zeta_local_zero_count (T ≥ 2):
    sum of zeta zero orders in |s - (2 + iT)| <= 3/2
      <=  7 * log T + 30
localCount_holds : StmtLocalCount zetaLocalCount 7 30
```

The disk contains `1/2 + iT`, so this is the count at the critical
line's own height. Entry 130's budget allows `A₁ <= 100`,
`A₃ <= 1000`; delivered 7 and 30, with the leading constant about
1.08x the literature's `1/log(7/6) ~ 6.4855`. Crude-explicit came
in sharper than the budget demanded.

**Construction.** `f z = ζ (2z + (2 + iT)) / ζ (2 + iT)`, `r = 3/4`,
`R = 7/8`, `B = 42T`, fed to upstream `ZerosBound`. The scaling is
what reaches the critical line: upstream's own window sits at
`3/2 + it` with radius `3/4`, i.e. `Re ∈ [3/4, 9/4]`, and never
touches it. The pole at `s = 1` stays outside because
`2z + (2+iT) = 1` forces `Re z = -1/2` and `Im z <= -1`, so
`‖z‖² >= 5/4`.

**Correction to entry 156's framing.** That entry said the Jensen
count "is now a proved upstream lemma rather than substrate," and
the brief for this slice said the count was an import rather than a
build. Both were too optimistic. Upstream's `ZerosBound` is the
general Jensen inequality and is genuinely reusable, but three
obligations had to be proved here because upstream's versions are
shaped for its own window:

```text
zeta_disk_upper    ‖ζ w‖ <= 14 T on ‖w - (2+iT)‖ <= 7/4 — GlobalBound
                   is a Re ∈ [1/2, 5/2] strip bound, and since
                   ZerosBound needs r < R, ANY window whose r-disk
                   reaches Re = 1/2 has its R-disk crossing below it.
                   Proving our own majorant was forced, not optional.
zeta_centre_lower  ‖ζ (2+iT)‖ >= 1/3 — ZetaFixedLowerBound exists
                   only at 3/2 and does not transfer to the centre.
analyticOrderNatAt_fun_comp_affine — Mathlib/upstream transfer
                   handles translation only; the scaling needed a
                   general affine version, proved from
                   analyticOrderAt_comp_of_deriv_ne_zero.
```

Finiteness of the window is proved (`zetaWindow_finite`, identity
theorem on a radius-11/5 ball plus an injective-preimage step), not
assumed — the count's `if Finite` guard would otherwise make the
statement vacuously true, which is the entry-133 failure mode.

**Verification, run independently of the building agent.** `lake
build` green at 8720 jobs (8714 before), zero errors; theorem/pin
parity 77/77 across all eight modules; every pin carries
`[propext, Classical.choice, Quot.sound]` — no `sorryAx`, though
`StrongPNT.lean` holds three sorry-blocked declarations elsewhere in
the same file; `check_refs.py` and `check_weld.py` both exit 0.

**Ledger.** `{hEF, StmtArgCrude}` stands, but StmtArgCrude's
analytic core is now discharged. What remains for it is the
rectangle identity and Backlund's step — both classical, neither
needing a tool the tree lacks.

**Also corrected.** The stage-3 conventions section of this
project's CLAUDE.md still named the pin 751a8c2; entry 156 bumped it
to 47fa486, leaving that line stale. Fixed on Julian's approval,
this date.

---

## 2026-08-25 — Entry 156 — Upstream probe: no free discharge, but the Arg half's toolkit landed today; pin bumped
type: provenance
refs: 130, 141, 142

**The probe.** PNT+ HEAD against our pin 751a8c2 (which was HEAD on
2026-08-24): exactly one commit since, 47fa486, "[StrongPNT]: Log
Deriv Zeta Log Squared Estimate" (#1751), merged 2026-08-25.

**The watch target did not land.** Kadiri.backlund_bound — the full
hNT at Rosser constants — is still `sorry` (Kadiri.lean carries 14).
The pin-bump watch of entry 141 stays open; StmtArgCrude remains
ours to build.

**What did land is that build's toolkit,** rewritten into
StrongPNT.lean (+636/-410), and proved:

```text
ZerosBound (line 866) — the Jensen disk count: f analytic on the
    closed unit ball, f(0) = 1, |f| <= B on radius R implies the
    zero-order sum inside radius r is <= log B / log(R/r)
SumBoundII (2427) — |zeta'/zeta(z) - sum_rho m(rho)/(z-rho)| <=
    C log|t| on the strip
LogDerivZetaUniformLogSquaredBoundStrip (2595) — |zeta'/zeta| <=
    C log^2|t| uniform on 1 - F/log|t| <= sigma <= 3/2, |t| >= 3
```

Entry 141 mapped the StmtArgCrude route as "rectangle
argument-principle identity + Jensen/Borel-Caratheodory disk counts,
substrate sorry-free." The Jensen count is now a proved upstream
lemma rather than substrate. Mathlib also now carries
Analysis.Complex.BorelCaratheodory, the route's other named tool.

**Sorry-reachability, checked structurally.** Every `sorry` in
StrongPNT.lean sits at line 2868 or later; all three lemmas above
are declared earlier, and Lean forbids referencing a later
declaration, so none of them can depend on the file's sorries. The
file does not import Kadiri.

**The honest limit.** The strip bound stops at sigma >= 1 - F/log|t|
and never reaches the critical line, so it does not yield S(T)
directly. The usable piece is ZerosBound, feeding the classical
Backlund count of zeros of zeta(z + 2 + iT)/zeta(2 + iT) in a disk.

**Also on the watch list.** I2NewBound and I3NewBound (StrongPNT
3268, 3358) are still sorry — contour pieces toward a strong
explicit formula, i.e. upstream building in hEF's neighbourhood,
our deepest leaf.

**Pin bumped** 751a8c2 -> 47fa486 on Julian's approval. Toolchain
unchanged (v4.32.2), Mathlib revision unchanged (cache hit, no
Mathlib rebuild). Rebuild: 8713 jobs (3665 at the old pin — the
StrongPNT rewrite is the difference), 0 errors. Theorem/pin parity
holds in all six modules, 56/56, every axiom list unchanged under
the new upstream. check_weld: 0 broken welds. Nothing in our tree
moved.

Leaf ledger unchanged: {hEF, StmtArgCrude}.

---

## 2026-08-25 — Entry 155 — O76: the joint question asked — the four zeros remain base 2's own
type: run
refs: 49, 52, 54, 56, 62

Script O76_joint_orbit_zero_census.py, defaults. Entry 62's unasked
question, run by combining the tree's two designs exactly as that
entry framed it: O18's joint {2^m 3^n} orbit as the ladder, O16/O27's
exact-integer backward-difference triangle as the construction — one
number per cell, built from both ladders at once. Artifacts:
results/joint_orbit_zero_census.json,
results/O76_joint_orbit_zero_census_run1.log.

**Commensurability gate PASSED first** (the entry 54/56 trap):
ln 2 and ln 3 against pi/(4 gamma_1) sit at 12.4745 and 19.7716 —
distance 0.4745 and 0.2284 from the nearest integer. Alignment
cannot be forced by this base set.

**The census.** 564 rungs to 2.2e12, 158766 cells. Exact zeros
(d >= 1): 20 total, of which 15 sit at window top <= 100 — the
small-count region where consecutive smooth numbers trap 0 or 1
primes and zeros are chance. Above that floor: five zeros, all with
pair values <= 129, the deepest at d = 5 (window top 864), the
highest window top 11664 at d = 1. Every cell above x = 11664 —
about 150k cells spanning eight further orders of magnitude — is
nonzero.

**The answer to entry 62.** Asked jointly, the answer matches O44's
answer asked singly: the joint construction produces no deep
exact-zero structure, and the four exact zeros — (2,1), (4,1),
(8,3), (20,6), out to r = 92 in O43's census — remain a property of
the base-2 table alone. Entry 62 recorded that this outcome was not
predicted in either direction; it is now measured.

EXPLORATORY: no prereg, no verdict.

---

## 2026-08-25 — Entry 154 — O75: the crossing-slope law out of sample — r = 0.96 across seven fresh bases, and the law's own domain mapped
type: run
refs: 33, 36

Script O75_crossing_slope_oos.py, defaults. Entry 36's post-hoc law —
slope = ln b / (2 ln ratio), ratio = |1 - b^(-1/2 - i g1)|/((b-1)/b) —
tested on non-integer bases that did not exist in the tree when it
was written. Turnaround semantics copied verbatim from O33
measure_row (min_row 8, margin 2, OLS of turnaround depth on r);
floors exact via rational integer arithmetic; pi via primecountpy.
Artifacts: results/crossing_slope_oos.json,
results/O75_crossing_slope_oos_run1.log.

**Gate PASSED.** Anchors b = 2, 3 from the caches at r <= 32
reproduce entry 36's measured slopes (0.3031, 0.7353) and derived
predictions (0.2862, 0.6406) to all four decimals.

**The law's domain, mapped first.** The gamma_1 mode gain oscillates
in b: ratio <= 1 (no prediction) or slope >= 1 (unreachable on
triangular support) for b in (2.3, 2.65) and past 3.35. Testable
windows: roughly [2.05, 2.25] and [2.70, 3.30]. Entry 36's b = 5, 7
silence is the same phenomenon at integer bases.

**Out of sample** (seven fresh bases, xmax 1e14):

```text
b      pred    measured   n pts   rel err
2.05   0.3164  0.3336     37      +5.4%
2.10   0.3605  0.3230     34      -10.4%
2.15   0.4290  0.3442     34      -19.8%
2.20   0.5480  0.4168     33      -23.9%
2.80   0.6893  0.6304     24      -8.5%
3.10   0.6817  0.6831     17      +0.2%
3.25   0.8396  0.9041      5      +7.7%
```

Pearson r = 0.9602 between predicted and measured. Five of seven sit
within +-10.4%, bracketing the in-sample +5.9%/+14.8%; the two large
misses are the window-edge bases 2.15 and 2.20, where ratio
approaches 1 and the slope formula is most sensitive — the law's
error concentrates at its own degeneracies. The b = 3.25 row rests
on 5 points.

EXPLORATORY: no prereg, no verdict.

---

## 2026-08-25 — Entry 153 — O74: the interleaved row sums, machine-verified and extended to r = 41
type: run
refs: 31

Script O74_interleaved_row_sums.py, defaults. O27's construction per
base from pi2n_cache.json and pi3n_cache.json (READ ONLY; the triadic
cache reaches exactly r = 41, which sets the extension ceiling —
entry 31's killed run left its cache behind). Artifacts:
results/interleaved_row_sums.json,
results/O74_interleaved_row_sums_run1.log.

**Gate PASSED.** r = 1..6 reproduce entry 31's hand-computed lists
exactly: totals 3, 3, 15, 27, 88, 168; dyadic 1, 1, 4, -1, 21, -18;
triadic 2, 2, 11, 28, 67, 186. The 2026-08-17 "hand-computed and
unverified" flag is discharged.

**Extension to r = 41.** The dyadic component alternates sign through
the whole range (r = 39..41: +7623467290171, -14953136533899,
+27745758974446); the triadic component stays positive throughout
(r = 41: 1602671261995703034). Entry 31's observed pattern at r <= 6
is the pattern at every r the caches reach.

EXPLORATORY: no prereg, no verdict.

---

## 2026-08-25 — Entry 152 — O73: the Weil balance survives the mollifier grid; the per-prime breakdown, corrected
type: run
refs: 39, 40

Script O73_weil_mollifier_sweep.py (new number; O37's pair stay frozen
with their logs), all defaults. The O37_weil_form_balance construction
replicated verbatim with two extensions: K-general analytic tails
(binomial(2K,K)/4^K, power (Wt)^(-2K), reducing to O37's 3/8 and
(Wt)^(-4) at K = 2) and the prime term grouped by p. Artifacts:
results/weil_mollifier_sweep.json,
results/O73_weil_mollifier_sweep_run1.log.

**Sanity gate PASSED.** The anchor (W=0.05, K=2) reproduces entry
40's recorded prime term, ARITHMETIC, and SPECTRAL(600) to 1e-14
relative — the sweep's machinery is the machinery that produced the
recorded balance.

**The sweep** (b=2, N=7, Tc=3000, 600 zero pairs):

```text
W     K   n_p    ARITHMETIC        SPECTRAL+tail     rel diff
0.02  2    10    11909.1321568     11909.0808048     4.312e-6
0.05  2    25    2644.27565602     2644.2741567      5.67e-7
0.1   2    42    694.238491564     694.238396427     1.37e-7
0.2   2    61    1.86369031013     1.86368756791     1.471e-6
0.02  3    15    8843.47306243     8843.47300967     5.966e-9
0.05  3    36    1956.96884827     1956.96884795     1.635e-10
0.1   3    51    329.915488971     329.915488966     1.675e-11
0.2   3    82    0.0432902958634   0.0432902958547   2.019e-10
```

The sides swing five orders of magnitude across the grid; the
relative difference stays between 1.7e-11 and 4.3e-6. K=3 balances
~1000x tighter than K=2 — the K=2 residuals sit at the scale of the
tail ESTIMATES (which are means, not bounds; entry 40), so the
residual is tail error. Entry 40's carried caveat now has its
measurement: the individual numbers move with (W, K), and the balance
holds at every setting.

**Per-prime breakdown, corrected implementation** (anchor setting;
the only prior breakdown came from the buggy file, whose numbers are
not citable). p = 2 contributes -1431.42113069 of the -1435.91379878
prime term — share 0.9969. The largest counterweight is p = 17 at
+211.05 (share -0.147), then 7, 3, 31 (~0.05 each), falling to parts
in 1e-7 by p = 107. 25 primes contribute at support
|log x| <= 5.05203; per-setting breakdowns for all eight grid points
are in the JSON. Entry 40's "any claim about the 2-ladder must
survive the smearing" is now quantified: the smearing nets to a
half-percent correction at the anchor.

EXPLORATORY: no prereg, no verdict. Both entry-40 NOTEPAD lines are
answered by this entry; transitions are Julian's.

---

## 2026-08-25 — Entry 151 — O72 (O66 v2): twin rigidity is real at every height — the degenerate endpoint was noise
type: run
refs: 105, 107, 111

Script O72_twin_spectral_v2.py (new number; O66 stays frozen with its
logs and JSON), all defaults: seven heights K = 1e6..1e12 (x ~ 6e6 to
6e12), eight disjoint windows per height, window size scaled with
ln^2 x (2^20 to 2^22 sites), 32-replicate Bernoulli null per height,
seed 2026, run-2 HL normalization verbatim. Artifacts:
results/twin_spectral_v2.json, results/O72_twin_spectral_v2_run1.log.

**The design answers entry 111's demand** ("more heights with stated
uncertainty; the current endpoint is degenerate with its control"):
every statistic now carries an across-window mean ± sd, the control
is a distribution, and each height prints its own separation z.

**Rigidity, per height** (F(256) twin | null, z; low-freq twin |
null, z):

```text
x ~ 6e6    0.830|0.977  -14.4     0.952|1.000  -24.6
x ~ 6e7    0.854|0.976  -14.4     0.958|1.000  -34.8
x ~ 6e8    0.898|0.979   -9.5     0.966|1.000  -17.0
x ~ 6e9    0.896|0.980  -12.8     0.973|1.000  -37.4
x ~ 6e10   0.926|0.991  -11.2     0.978|1.001  -20.7
x ~ 6e11   0.935|0.988  -17.2     0.982|0.999  -20.7
x ~ 6e12   0.947|0.990  -12.7     0.985|1.000  -19.9
```

Twin sits below its null at every height and every block size, |z|
from 5.3 (F(4096) at 6e12) to 37.4. **The v1 endpoint is resolved:**
at 6e10 the single-window F(256) pair 0.929 vs 0.932 was sampling
noise; the distribution-level measurement separates at z = -11.2.

**The trend.** The low-freq deficit (1 - ratio) falls monotonically:
0.048, 0.042, 0.034, 0.027, 0.022, 0.018, 0.015. Post-hoc
observation, stated as such: the sequence tracks 1/ln^2 x within
~10% across the span. Rigidity decays smoothly with height and
remains many sigma from the null at 6e12.

**Hardy–Littlewood holds at every height.** mean|R - HL| runs
0.026–0.041 across the seven heights, inside the Bernoulli
sampling floor (0.026–0.044) at each one.

**Amended candidate statement** (entry 111's promotion, litsearch_4's
target): the twin process keeps HL pair structure while its number
rigidity DECAYS SMOOTHLY AND PERSISTS — significant at every measured
height to 6e12. The earlier "loses rigidity" reading came from the
degenerate endpoint.

EXPLORATORY: no prereg, no verdict.

---

## 2026-08-25 — Entry 150 — O24 at 4e11: G5 does not overtake — the four-prime peak survives 133x more data
type: run
refs: 111, 149

Script O24_prime_generator_orbit.py, invocation `--pi-backend
primecount --xmax 400000000000 --generators "2,3,5,7,11"`, every
other flag at default and identical to the 3e9 run (x0 2.0, gamma
0..40 step 0.01, dps 30, 200 surrogates, seed 2026). Completed clean
in minutes; gates A, B, C all PASSED. Artifacts:
results/O24_gen_xmax4e11_results.json,
results/O24_gen_xmax4e11_run.log.

**Headline table.**

```text
 set  n_blk    median(P)      argmax g   P_max/med   verdict
  G1     37   0.052466633     14.1800     4.963683      NULL
  G2    475   0.069039839     14.1200     8.749549    DETECT
  G3   2894   0.014731994     37.5600    31.107472    DETECT
  G4  11787   0.0049192035    37.5900    69.005848    DETECT
  G5  34343   0.0059499436    25.0100    47.719686    DETECT
```

Steps: G1→G2 +76.27%, G2→G3 +255.53%, G3→G4 +121.83%,
G4→G5 −30.85%. The script's mechanical scaling band reads FALLS.

**Against the 3e9 run.** G4 37.26 → 69.01 (+85.2%); G5 26.17 → 47.72
(+82.3%); the G4/G5 ratio moved 1.42 → 1.45. The-Four-Prime-Peak D4's
two-point extrapolation put G5 overtaking G4 near 4e11; at 4e11 the
crossing did not occur, and D2's deeper-gains-more ordering does not
hold at the G4→G5 step at this scale. The paper's own G1 caveat
("D4's extrapolation is two points") was the right suspicion.

**Texture.** All six gamma_n sit in-band in each of G4's and G5's top
six peaks, with nothing else close (G4's seventh peak: 3.64 against a
top of 69.0). G5 carries the whole spectrum tightly — P/median at
gamma_1..6 spans 46.83–47.72, spread ~1.9% — while G4 holds the
height at spread 4.5% (8.56% at 3e9). G4's argmax landed on gamma_6
(37.59), G5's on gamma_3 (25.01). Surrogate control: real
P_max/median at percentile 100.000 and above p95 for G2–G5.

EXPLORATORY: no prereg; the scaling band is the script's mechanical
rule, and no verdict is stamped. The-Four-Prime-Peak's D and G
sections now want a result-triage pass.

---

## 2026-08-25 — Entry 149 — O24 pi backend: primecountpy option, backend-independence verified, 4e11 unlocked
type: instrument-fix
refs: 42, 111

The-Four-Prime-Peak D4 calls xmax ~ 4e11 "far beyond what this
instrument reaches." That was a memory fact: the sieve backend needs
~xmax bytes (400 GB at 4e11) plus the enumerated primes (120 GB), and
the primes array feeds exactly one consumer — exact pi at the block
edges. primecountpy computes pi(4e11) = 15581005657 in 8 ms with no
array.

**What changed.** O24_prime_generator_orbit.py gained
--pi-backend {sieve, primecount}, default sieve — the array path is
byte-unchanged. The primecount path is a memoized PrimecountPi object
with floor semantics identical to pi_at's array path (both count
primes <= floor(x)), dispatched in pi_at with a documented section.
Under the new backend, params record pi_backend and n_primes =
pi(xmax); largest_prime is null (never enumerated).

**Backend independence, verified.** The full default run
(xmax 1.5e8, G1–G4, 200 surrogates) executed on both backends and the
result JSONs deep-diffed: zero differing leaves outside generated_utc
and the two backend params fields. Every count, residual, projection,
surrogate draw, gate, and summary number identical. Prior O24 results
REMAIN FULLY COMPARABLE; the sieve default means a no-flag invocation
is byte-identical to before.

**What it unlocks.** The D4 kill test at 4e11 (entry 150), and any
future xmax the orbit itself can afford — the binding cost is now the
projection, at ~34k blocks for G5, with pi essentially free.

---

## 2026-08-25 — Entry 148 — O30–O38 instrument-fix pass: flags and results JSON, nine scripts, zero drift
type: instrument-fix
refs: 28, 32, 35, 38, 39, 40

Closes the thread entries 28 and 35 opened: hardcoded parameters and
missing results JSON, against the house convention. Nine scripts now
carry the O39-style flag set and the standard envelope, every default
byte-identical to the old hardcoded value: O30_silence_scaffold_primes.py,
O31_excise_scaffold_primes.py, O32_excised_gamma_check.py,
O34_zeta_residual_model.py, O35_nearmiss_residuals.py,
O36_weil_calibration.py, O37_weil_form_balance.py,
O37_weil_form_on_stencil.py, O38_weil_bug_diagnosis.py.
O34_zeta_residual_model_FAILED.py and O38_weil_form_BUGGY.py stay
untouched — frozen evidence, their docstrings forbid citing their
numbers.

**Guards built in, beyond bare flags.** O31 computes the exact
variant-B walk bound and refuses before sieving when --lim is too
small for --rmax (rmax 23 needs lim >= 31457279). O34 refuses
--rmax < 20 (its TRUE_RES_R20 literals are row-20, dps-40 objects;
no --row flag exists) and its --dps help states the coupling. O36 and
both O37s anchor --zeros to the script directory, fixing a recorded
cwd-dependence defect, with the cache's dps-25 precision stated.
O37_weil_form_on_stencil's bare positional K became --k. O38 gained
only --out/--no-json/--results-dir: its b, N, W sit inside a
deliberately verbatim copy of the buggy objects and stay untouched.

**Re-runs: all nine at defaults, zero drift.** O30/O31/O32 exact to
entry 32 (baseline and silenced zero lists, excision readings,
(20,6) = 70 under A and 1086 under B, gamma triple to every digit).
O36 digit-for-digit to entry 39 (0.4620476309 / 0.4620476476). Both
O37s line-identical to their frozen logs
(results/O37_weil_form_balance_run1.log, 48.88 s vs recorded 49.79;
results/O37_weil_form_on_stencil_run1.log, 11.82 s vs 12.12) and to
entry 40's balance numbers. O38 matches entry 39's four diagnostics.
O34 exact to entry 38's row-20 table and non-monotone d6 ratios
(0.8953/0.7999/0.8618). O35 exact to entry 38's deep-cell failures
including the (25,21) sign flip (-296432.92 at 200 pairs, +27793.218
at 600) and the cell-is-the-residual reading. Prior results REMAIN
FULLY COMPARABLE everywhere; the only stdout addition anywhere is the
trailing "results written to" line. Interpreters matched each file's
HOW IT WAS RUN (system python3 for O30–O32, .venv for the rest).

**First-ever JSONs.** Nine default-named results JSONs now exist,
including the first machine-readable records for O34
(results/zeta_residual_model.json) and O35
(results/nearmiss_residuals.json). No pre-existing artifact was
touched; no results JSON on disk recorded the nine scripts' old shas,
so the O24-style stale-pointer mode does not arise here.

**Two observations recorded, plainly.** (1) O39's own --results-dir
flag is dead code — declared, never read. The nine new
implementations made it functional; O39 itself is unchanged and the
defect is now on record. (2) O36's set-3 zero/arch diff printed
3.75e-15 on this run and on the original code — entry 39's "agreeing
to 1e-18" phrase fits sets 1 and 2 (5.1e-18, 2.7e-22); set 3 always
sat at the e-15 scale against an arithmetic side of order 1e-8.

Gates after the pass: 0 broken references, 132 values confirmed,
0 not found.

---

## 2026-08-25 — Entry 147 — O24 pi_at float-key fix: the instrument-fix entry, eight days late
type: instrument-fix
refs: 35

The fix landed 2026-08-17 and produced two NOTEPAD lines but no entry;
this is the entry, so the record is dated where later readers look.

**What changed.** In O24_prime_generator_orbit.py, pi_at's searchsorted
key is floored to an exact Python int before the lookup, removing a
whole-array float64 upcast of the primes array on every call.
Performance only: for any real key k, the primes at or below k are the
primes at or below floor(k), so the count cannot move. The full
semantic-identity argument, including boundary behaviour, is in the
function's docstring.

**Comparability.** Prior O24 results REMAIN FULLY COMPARABLE. Verified
2026-08-17 by running pre-fix and post-fix code on identical flags on
two settings and comparing result JSONs cell by cell — byte-identical
apart from timestamps and the recorded code_version sha.

**Sha lineage.** 6e2ddd01… (pre-fix) → f3525a7f… (post-fix, current;
recomputed for this entry). On disk: five results JSONs record the
pre-fix sha (O24_gen_11to19_results.json, O24_gen_to19_results.json,
O24_gen_xmax1e9_results.json, O24_prime_generator_orbit_results.json,
O24_prime_generator_orbit_run2.json); one,
O24_gen_xmax3e9_results.json, records the post-fix sha. The NOTEPAD
line's "every O24 results JSON records 6e2ddd01" was true when written
and is superseded by that sixth file.

**The re-stamp decision (Julian, 2026-08-25): leave the shas.** The
five pre-fix shas stay exactly as they are — honest provenance of
which code produced those numbers — and this entry is the crosswalk.
Editing shas inside frozen results would falsify that provenance to
make it tidier.

**The aborted log (same decision principle).**
results/O24_gen_xmax3e8_run.log is a timing probe killed at the
two-minute mark — which is why it stops mid-G6 — copied into results/
from a scratch directory in error (entry 35's thread). The filename
stays: results are frozen evidence, and this paragraph is the label.
The correction of entry 35's "G1 through G5 are reported" framing is
an outcome marking and stays Julian's.

---

## 2026-08-25 — Entry 146 — The method has its own repository: the_container
type: motivation
refs: 143, 144, 145

**What exists.** The methodology this program built — and entries 143
(the engine: stigmergy, decorrelation, entropy schedule) and 144 (the
posit: a Lean kernel adjudicating meaning) articulated — now lives as
a standalone, domain-agnostic, public template repository:
<https://github.com/juliansambranojr/the_container>, first commit
`cb06d4f`, public from that commit. Julian's framing: build in
public.

**What it contains.** BLUEPRINT.md (thesis, eight failure modes each
mapped to the part that answers it, definitions, the nine-step loop,
separation of powers, when-to-move-in and the minimum seed, gate
adaptations for seven domains, refusals); AGENT.md, the working
contract written for any model — the CLAUDE.md role with the
Claude-specific identity removed; the four commitment files and its
own notebook, kept by its own rules; and three gates — record
consistency, kernel adjudication, and a regression suite that
replays 13 adversarial break scenarios on scratch copies, each
required to fire. The gates live in that repo's utilities tree;
paths resolve there, so this entry names them by function.

**Entry 144's posit is now operational.** The repo's
`adjudications/` layer is the kernel-for-meaning recipe made
mechanical: domain concepts as opaque atoms, premises as named
axioms, conclusions as theorems, a zero-axiom satisfiability model,
`#guard_msgs` pins as the mechanically generated leaf ledger, and a
gate coupling every pinned axiom to a budget-and-discharge ledger
line. Adjudication 001 kernel-checks the skeleton of the container's
own thesis from a single premise (some claim feels right and is
incorrect). Its back-translation round is open in that repo's
NOTEPAD.

**The method audited itself before shipping.** A decorrelated
adversarial review of the repo returned 12 findings (5 more
retracted under self-attack), the sharpest being three ways to pass
the adjudication gate falsely — unimported modules, unpinned
theorems, `sorryAx` allowlisted. All 12 repaired; the review's break
scenarios became the permanent regression suite. The reviewer's
summary line earned its keep: the prose describing the gates was
stronger than the gates.

**Relation to this bench.** One-way, same as everything here: the
container cites Primebeat as provenance and worked example; nothing
in this tree depends on it. The bench keeps its own gates.

No outcome marked.

---

## 2026-08-24 — Entry 143 — What inherits the work, and why the engine ran: four domains, three legs
type: motivation
refs: 99, 116, 130, 133, 140, 142

The inheritance claims, nearest to farthest. (1) The verified-floor +
crude-explicit-ceiling architecture as a portable machine: finite
computation closes a region, explicit-but-crude asymptotics close the
tail, and the BUDGET MEASUREMENT proves they meet — the anatomy of
odd perfect numbers, Linnik constants, class-number problems, all
waiting for the tolerance run almost nobody performs. (2) Statement-
satisfiability testing as formalization QA: O71 numerically falsified
a formal statement before anyone spent months proving toward it; two
trees yielded undischargeable statements in one day; the ecosystem
building decade-scale programs has no standing harness for this.
(3) The phase-decomposition kit: O69's instruments (band entry,
lock-on, phase split) apply verbatim to any spectral staircase —
Berry–Tabor and BGS are exactly claims about staircase fluctuations.
(4) The leaf ledger as social technology: named assumptions with
citation shape, measured budget, sketched discharge, upstream watch —
dependency management for open problems; a two-person bench
interoperated with Tao's network without asking permission.

Why the engine ran (Julian's reading, tested against the day and
confirmed from inside). Stigmergy: the notebook, NOTEPAD, and gates
held the state, so decisions reduced to do-or-don't against a
regression check — second-guessing is the tax on unverified memory,
and the ratchet abolished it; the agent's context was destroyed and
rebuilt several times mid-day and the session never lost ground
because the state lived in the tree. The folding-in failure: the
agent's errors were coherent-and-wrong (the principal arg, the
vacuous capstones) — coherence is what it maximizes, so its
characteristic failure is confident self-consistency; the outside
perturbation works by DECORRELATION, an uncorrelated read of the same
statements, the way independent instruments beat one instrument
re-read. And the perturbation schedule was human: every injection was
orthogonal to the current axis ("argue the opposite", "test it on our
bench", "run it forward"), timed precisely when the path looked
smoothest — apparentness itself as the warning sign. Stigmergy holds
the state, the ratchet holds the ground, the human holds the entropy
schedule; each leg covers the failure mode of the others.

The through-line of both halves: tolerance is a measurable object,
and most impossibility verdicts have never measured it.

## 2026-08-24 — Entry 145 — The repository is public
type: provenance
refs: 142, 143, 144

Flipped public at Julian's instruction — "let them see what's
possible" — at commit 690e7e8, 2026-08-24:
https://github.com/juliansambranojr/Primebeat_081426

Pre-flight, verified at HEAD immediately before the flip: 0 broken
references, 132 values confirmed, 0 broken welds, bench parity
250/250, stage3 parity 56/56, tree clean and identical to remote,
LICENSE and README present with the notebook framed as part of the
publication, sensitivity sweep clean over the full history.

The flip is the opening move of the group project (entry 142): the
#1538 note and the identity_16_complex PR now have referenceable
code behind them. Every gate travels with the tree — anyone who
clones can run check_refs, check_values, and lake build, and watch
the record verify itself.

## 2026-08-24 — Entry 144 — Posit: a kernel for meaning — Lean as adjudicator in LLM discourse
type: motivation
refs: 133, 142, 143

Julian's posit, recorded to revisit as a paper's methodology section.
An LLM used as a judge of another LLM's argument parrots the
preferences inherited from RLHF and its developers — judgment by
vibes, at scale. Today's session contained exactly one judge with
zero preferences: the kernel. Every dispute that mattered ("is this
possible", "does this hold", "is this hypothesis even satisfiable")
was settled by build-green or build-red, and the day's two structural
defects were caught by that judge plus an uncorrelated reader, never
by taste.

The generalization: kernel-adjudicated discourse. Not formalizing
meaning wholesale — formalizing the STRUCTURE of a disagreement.
Map the argument into typed statements; inference steps the kernel
checks; premises that resist formalization become named leaves with
the full discipline this bench built for them — citation shape,
measured budget (how wrong can this premise be before the conclusion
dies), sketched discharge, adversarial satisfiability testing
(O71-style: test the formalized statement against evidence BEFORE
trusting it, because a vacuous formalization judges nothing — the
translation gap is where this method lives or dies). The verdict
form changes from "the judge prefers A" to "A holds modulo these
named leaves, each budgeted" — disagreement becomes a ledger, and
the ledger is inspectable by both parties.

Logical and philosophical scope: validity is the kernel's; meaning
stays in the leaves — and that division is the honesty of the
method, not its weakness. The leaf ledger IS the interface where
human meaning enters a machine-checked argument. What today
demonstrated in miniature: two parties (and their adversarial
agents) converging not because either persuaded the other but
because the tree held a shared, gated, budget-annotated state of
the argument. A paper would need: the discourse-mapping method, the
translation-gap failure modes (entries 131–133 as case studies),
and the budget semantics for informal premises.

## 2026-08-24 — Entry 142 — The group-project audit: nine sorries classified, one statement tested and found wanting
type: result-triage
refs: 133, 141

Julian's proposal: contribute to the upstream program itself — clean
their sorries, earn the pin bump as a group project. The audit of
IEANTN/Kadiri.lean's nine real sorries (five hits are comments):

Deep cores: hadamard_identity (the Hadamard product for ζ'/ζ),
kadiri_thm_3_1_q1_laplace_inversion. Assemblies inheriting from
children: backlund_bound, kadiri_thm_3_1_q1 (×2). Entangled medium:
re_hadamardB_eq (Laurent at s=1 + zero-sum symmetrization,
discussion #1476). Our genre, adoptable: identity_16_complex
(discussion #1494) — its COMPLETE proof sketch is written in the
blueprint comment: apply Thm 3.1 to the Kadiri test function,
discharge with three named existing lemmas, three terms vanish,
solve. Adopted as our PR target for a fresh session.

And the two horizontal-vanishes lemmas (#1538) are undischargeable
as stated — the entry-132/133 defect class, in their tree. The
statement takes T → ∞ over all reals, but ζ'/ζ has a pole at every
zero height crossing the σ-segment, and δ := |T − γ| is
unconstrained while any admissible φ's transform decay is fixed.

O71 (exploratory, results/horizontal_defect.json + run log) tested
the claim before any note goes anywhere:
Check 1, the log law: J(δ) = ∫|ζ'/ζ| over σ ∈ (−1/4, 5/4) at
T = γ₁ + δ, against 2·ln(1/δ): ratio 1.195 → 1.031 across
δ = 1e−1 → 1e−6. The pole mechanism, confirmed.
Check 2, the schedule: with the concrete admissible
φ = e^(−y/2)/cosh(3y/2) (Φ in closed form, exponentially small),
the weighted integral grows arithmetically in log(1/δ) at γ₁ and
γ₂₉, and the δ pushing it past any bound exists at every height
(ln δ < −4.0e6 at γ₁; < −1.3e45 at γ₂₉ — astronomically small,
and legal). So the limit over the full filter fails for every
nonzero admissible φ; heights with |T − γ| ≥ c/log T repair it,
and the downstream consumer needs only a cofinal family.

The note for #1538 is drafted and HELD — posting is outward-facing
and Julian's call, with these numbers now behind it. The
contribution ledger: (1) the #1538 restatement note, tested;
(2) identity_16_complex as the adoptable build.

## 2026-08-24 — Entry 141 — The Arg half audited: upstream races us, and the crude route is mapped
type: provenance
refs: 119, 130, 140

The StmtArgCrude audit, after entry 140 closed the Stirling half.

The upstream find: the dependency's IEANTN/Kadiri.lean STATES
Kadiri.backlund_bound : riemannZeta.Riemann_vonMangoldt_bound
0.137 0.443 6.1 — the full hNT leaf at Rosser's literature constants.
Probed via #print axioms (probe built, read, removed): it depends on
sorryAx today — 14 sorries stand in that file. Tao's network is
building the sharp version of exactly our leaf; when it lands, a pin
bump discharges hNT entirely and RvM_of_phase_arg's crude route
becomes a redundant check. Until then ours is the live path.

The crude route, mapped against sorry-free substrate:
StmtArgCrude decomposes as Backlund's argument bound —
(A1) the rectangle argument-principle identity connecting their
riemannZeta.N to the phase θ/π + 1 + S(T)
(RectangleArgumentPrinciple.lean, sorry-free, is the machinery);
(A2) S(T) ≤ B·log T via zero counts in disks
(Jensen: their zetaSurrogate zeros-in-ball counts in
Backlund/ZeroCountCrude, sorry-free but existential constants;
BorelCaratheodory.lean sorry-free; ZetaBounds' zeta analytics
sorry-free) — the crude-explicit constant extraction is the work.
Budget: entry 130 accepts B₁_total ≤ ~100 at depth ≥ 7 and the
Stirling half consumed 97; the Arg half rides the B₃-room (≤ 1000)
and the census re-tabulates at whatever lands — even B₁ ≈ 150 total
keeps depth 7 by entry 130's pattern.

The ledger after this session: stage 3 = {hEF, StmtArgCrude}. hNT's
two halves went from named (131) to corrected (132) to constructed
(135) to one-discharged (140) in a single day; the other half has its
substrate audited and an upstream race running.

## 2026-08-24 — Entry 140 — THE STIRLING HALF DISCHARGED: StmtBacklundPhase phaseTheta 97 98 is a theorem
type: formalization
refs: 132, 135, 136, 137, 138, 139

The first full leaf discharge of the stage-3 effort, in
`lean_stage3/Stage3/Stirling.lean`. Package parity 56/56; builds clean
at 8713 jobs; welds 2/0; gate 0.

The session's chain, each piece green on first or second build:
re_sub_log_norm_le generalized to radius 2 (constant 8 — the n = 0
term needs it); zq, normSq_add_zq, add_zq_ne_zero, a_term_le (the
per-term telescope bound 8/((n+1/4)² + (t/2)²));
re_digamma_sub_log_le — THE HARMONIC-γ LIMIT ASSEMBLY:
|Re ψ(zq t) − log‖zq t‖| ≤ 96/t, by telescoping the digamma series
against log-norm steps, with the partial sums converging through
Mathlib's tendsto_eulerMascheroniSeq, the log-norm drift vanishing by
a squeeze, and every partial sum bounded by 8·Σ'q ≤ 96/t;
stmtDigammaLog_holds — StmtDigammaLog 97, both components;
backlundPhase_holds — StmtBacklundPhase phaseTheta 97 98, through
entry 136's reduction.

What fell: the Stirling half of Backlund's decomposition, whole. The
phase that wrapped as a hypothesis in entry 131, was made abstract in
entry 132, and was constructed as an integral in entry 135, now
provably tracks the main term with explicit crude constants — 97
against Rosser's 0.137, inside entry 130's budget shape (the census
re-tabulates when the Arg half lands).

The ledger: hNT = StmtArgCrude alone (S(T) = O(log T), the argument
principle). Stage 3 entire: {hEF, StmtArgCrude}. Two leaves, both
classical, both with sorry-free machinery waiting in the dependency
(BorelCaratheodory, ZetaBounds, the rectangle argument principle).

## 2026-08-24 — Entry 139 — The telescope's engine: |Re w − log‖1+w‖| ≤ 5‖w‖²
type: formalization
refs: 137, 138

`lean_stage3/Stage3/Stirling.lean` grows by re_sub_log_norm_le;
package parity 49/49; builds clean at 8713 jobs; welds 2/0.

For w with re w > 0 and ‖w‖ ≤ 1: |Re w − log‖1+w‖| ≤ 5‖w‖². The
proof needs exactly one library estimate — log y ≤ y − 1 — applied at
1+u and at (1+u)⁻¹, where u = 2·re w + ‖w‖² is the norm-square
expansion ‖1+w‖² = 1 + u. The lower application gives
log(1+u) ≥ u/(1+u), and the v := u/(1+u) bookkeeping closes both
sides of the absolute value by nlinarith.

Component 1's ledger: per-term engine 5‖w‖² (this entry), tail sum
12/t (entry 138), log ratio 1/(4t) (entry 138). At w = 1/(z+n) the
composition gives Σ|Re aₙ| ≤ 60/t, and the band lands at C ≈ 61 —
inside the ≤ 100 budget of entry 130 with room. Remaining: the limit
assembly Re ψ(z) = log‖z‖ − Σ Re aₙ via Mathlib's harmonic-γ limit —
pure structure, all its numbers now proved.

## 2026-08-24 — Entry 138 — The C/t band's two pillars: the log ratio and the quadratic tail sum
type: formalization
refs: 130, 136, 137

Slice C1a of the digamma comparison, in
`lean_stage3/Stage3/Stirling.lean`. Two theorems; package parity
48/48; builds clean at 8713 jobs; welds 2/0.

log_norm_z_le — |log‖z_t‖ − log(t/2)| ≤ 1/(4t) for t ≥ 1: log_sqrt,
the ratio identity (1/16 + t²/4)/(t²/4) = 1 + 1/(4t²), and
log(1+x) ≤ x.
inv_quadratic_tsum_le — Σ' 1/((n+1/4)² + (t/2)²) ≤ 12/t for t ≥ 1:
split at K = ⌊t⌋+1; head ≤ K·4/t² ≤ 8/t by the (t/2)² floor; tail
≤ 4/K ≤ 4/t through the dependency's sorry-free
tsum_one_div_natCast_add_add_one_sq_le. This is the sum controlling
Σ|aₙ| in the digamma telescope — the quantitative heart of
ψ(z) = log z + O(1/t) on the quarter-line.

Engineering: the ⌊t⌋ dyadic level needed clear_value (third instance
of the floor-unfolding whnf explosion; entries 128, and now here);
several v4.32 renames (inv_anti₀, one_div_le_one_div_of_le,
Summable.sum_add_tsum_nat_add as a dotted method).

Remaining for component 1: the telescope identity
Re ψ(z) = log‖z‖ − Σ Re aₙ (harmonic-γ limit assembly) and the
per-term |aₙ| ≤ ‖1/(z+n)‖² (complex log-Taylor). Then C ≈ 12 + small,
far inside the ≤ 100 budget, and the Stirling half closes through
entry 136's reduction.

## 2026-08-24 — Entry 137 — First numeral: the compact half of the digamma comparison, discharged at C = 8
type: formalization
refs: 135, 136

`lean_stage3/Stage3/Stirling.lean` grows by two theorems; package
parity 46/46; builds clean at 8713 jobs; welds 2/0.

digamma_term_norm_le — the per-term engine on the quarter-line
segment: ‖1/(n+1) − 1/(n+z)‖ ≤ 4/(n+1)² for re z = 1/4, ‖z−1‖ ≤ 1,
via the exact identity 1/(n+1) − 1/(n+z) = (z−1)/((n+1)(n+z)) and
‖n+z‖ ≥ n + 1/4. Reusable by component 1.
phasePoint_compact_le — |Re ψ(1/4 + it/2)| ≤ 8 on [0,1], from the
dependency's sorry-free digamma_eq_tsum: |ψ| ≤ γ + Σ 4/(n+1)² =
γ + 4·π²/6 < 2/3 + 6.62 < 8, closed with Mathlib's
eulerMascheroniConstant_lt_two_thirds, pi_lt_d2, and hasSum_zeta_two
reindexed through tsum_eq_zero_add.

This is the first analytic estimate with a hard numeral in the
stage-3 effort — the leaves are made of exactly this kind of fact.
StmtDigammaLog's remaining piece is component 1 alone: the C/t band
for t ≥ 1, the same per-term identity telescoped against the
logarithm. Then the Stirling half closes through
backlundPhase_of_digammaLog (entry 136).

## 2026-08-24 — Entry 136 — The Stirling half reduced to the digamma comparison
type: formalization
refs: 130, 132, 135

`lean_stage3/Stage3/Stirling.lean` grows by StmtDigammaLog and
backlundPhase_of_digammaLog; package parity 44/44; builds clean at
8713 jobs; welds 2/0; no sorries.

StmtDigammaLog C names the last analytic fact of the Stirling half:
|Re ψ(1/4 + it/2) − log(t/2)| ≤ C/t for t ≥ 1, plus |Re ψ| ≤ C on
[0,1] — the textbook ψ(z) = log z + O(1/|z|) on the quarter-line.
backlundPhase_of_digammaLog proves the full reduction:
StmtDigammaLog C → StmtBacklundPhase phaseTheta C (C+1). The proof
splits the phase integral at 1, bounds the compact piece by C,
integrates the band to C·log T (integral_inv), evaluates the main
term by integral_log_half, and the T·log terms cancel exactly against
the RvM main term through log(T/2π) = log(T/2) − log π — the 7/8
mismatch and integration constants land inside C + 1, with room
(the true slack at the numeric step is ~3/8).

The Backlund decomposition now reads: StmtDigammaLog C (Stirling
core, budget C ≤ ~100) + StmtArgCrude (S(T), the argument principle)
→ RvM_of_phase_arg → hNT. The stage-3 leaf ledger: hEF,
StmtDigammaLog, StmtArgCrude — three named classical estimates, each
crude-budgeted, everything between them and the census kernel-checked.
Discharge route for StmtDigammaLog: the dependency's sorry-free
digamma_eq_tsum series, next session.

## 2026-08-24 — Entry 135 — Stirling slice, construction half: the continuous phase exists
type: formalization
refs: 132, 133, 134

`lean_stage3/Stage3/Stirling.lean`, four theorems, four pins; package
parity 43/43; builds clean at 8713 jobs; welds 2/0.

phaseTheta T = (1/2)·∫₀ᵀ Re ψ(1/4 + it/2) dt − (T/2)·log π, with
ψ = Complex.digamma (Mathlib's logDeriv Gamma). The continuous phase
is constructed as the integral of the derivative — wrap-free by
construction, the entry-132 defect resolved by an object instead of a
hypothesis. Anchored: phaseTheta_zero (θ(0) = 0 = arg Γ(1/4), Γ(1/4)
positive). Well-posed: continuous_phasePoint via PNT+'s sorry-free
continuousAt_digamma_of_re_pos (the quarter-line stays in re > 0);
intervalIntegrable_phasePoint on every interval. The main-term
integral is evaluated by FTC avoiding t = 0: integral_log_half,
∫₁ᵀ log(t/2) dt = T·log(T/2) − T + 1 + log 2, antiderivative
t·log(t/2) − t.

Remaining for StmtBacklundPhase phaseTheta: the digamma comparison
|Re ψ(1/4 + it/2) − log(t/2)| ≤ E(t) with explicit E integrating to a
B₁·log T + B₃ band — from the dependency's sorry-free digamma_eq_tsum
series; then integrate against integral_log_half. Budget B₁ ≤ 100
where Rosser needs 0.137. Elaboration note for the record: the
digamma composition needed ContinuousAt.comp with g and f pinned
explicitly — higher-order unification guesses the wrong decomposition
on dotted comp.

## 2026-08-24 — Entry 134 — The capstones repaired: hG' restricted to (1/2, ∞); vacuity resolved
type: formalization
refs: 115, 117, 133

The Finding-1 repair from entry 133, in the bench tree.
lean/Expansion.lean: hD_of_window and tableFrom_ne_zero_of_li now take
hG' : ∀ x ∈ Ioi (1/2), HasDerivAt G (f2x x) x; the congr induction
runs on Ioi (1/2); the window membership (bottom ≥ 1 > 1/2) closes it.
lean/Schoenfeld.lean: tableFrom_ne_zero_of_schoenfeld forwards the
same signature. Build clean at 8046 jobs; 250/250 pins unchanged
(axiom lists identical); gates 0/0/0; welds 2/0; THEOREMS.md
regenerated.

The hypothesis pair is now satisfiable: G = li(2^x) on [1/2, ∞),
smoothly patched below, is globally smooth with the required
derivative on (1/2, ∞) — the divergence of ∫ 2^t/t dt at 0⁺ no longer
touches the stated domain. Entries 115/117's capstones are dischargeable
in principle, as they were always claimed to be.

With this, everything the adversarial audit (entry 133) surfaced is
resolved: the vacuous pair repaired, the two misstatements corrected,
the wording noted. The queue returns to the Stirling slice — the
continuous phase construction — with the chain's both ends now sound.

## 2026-08-24 — Entry 133 — Adversarial audit of the stage-3 chain: package clean; the bench capstones are vacuous as stated
type: result-triage
refs: 115, 117, 122, 128, 129, 132

A blind adversarial agent audited entries 115–132, all five lean_stage3
modules, the pinned dependency's definitions, O68/O70, and the weld
gate — instructed to hunt the arg-wrap class of defect and to attack
its own findings before reporting. Four findings survived; I verified
the severe one independently before accepting it.

Finding 1 (breaks the bench capstones; the stage-3 package is
unaffected internally). Expansion.tableFrom_ne_zero_of_li (entry 115)
and Schoenfeld.tableFrom_ne_zero_of_schoenfeld (entry 117) require
hG : ContDiff ℝ ⊤ G — smooth on all of ℝ — together with
hG' : derivative 2^x/x on all of (0,∞). Jointly unsatisfiable:
∫_ε¹ 2^t/t dt ~ log(1/ε) diverges, so G(ε) → −∞ against continuity
at 0. Both capstones are true but undischargeable — the entry-132
failure mode at the other end of the weld. The ancestors are sound
(Nonvanishing.tableFrom_ne_zero_of, MainTerm.tableFrom_ne_zero_of_deriv
have satisfiable hypotheses). Repair: restrict hG' to Ioi (1/2) — the
window bottom is ≥ 1, the proofs live on the open half-line, and the
pair (global smooth G, derivative 2^x/x on (1/2,∞)) is satisfiable by
a smoothly-patched li∘2^x. Queued immediately, ahead of the Stirling
slice.

Finding 2 (corrected). The Li offset is 2/log 2 − li(2) ≈ 1.840; three
places said li(2) ≈ 1.045. Docstrings fixed (PsiToPi.lean, O70);
entries 122/129 stand corrected by this entry.
Finding 3 (corrected). W = 0 because the bucket is the order-sum over
strip zeros with im = 0 exactly, and ζ has no real zeros in (0,1) —
entry 129 said "no zeros below height 1", which misdescribes the
bucket. O70 docstring fixed; entry 129 stands corrected by this entry.
Finding 4 (wording). Entry 128's "every arrow kernel-checked" includes
the O68 census arrow, which is Python arithmetic — entry 129's wording
is the accurate one.

Everything else attacked held: leaf satisfiability (including the
explicit formula's sign convention against the classical ψ₀ = x − Σ −
log 2π − ½log(1−x⁻²) + R), every chain constant re-derived by hand,
the one-sided N vs two-sided sum bridge read in full, cpow branch
guards, the weld gate. The audit cost one vacuous pair and two wrong
numbers — all caught by an outside read, none by the builder. The
pattern from entry 99 and today's 132, third instance: the check that
works is the one that did not write the thing.

## 2026-08-24 — Entry 132 — Correction to entry 131: the principal arg wraps; the phase is now abstract
type: formalization
refs: 130, 131

Designing the Stirling slice exposed a defect in entry 131's module,
caught before any discharge work built on it. rsTheta was defined with
Mathlib's principal Complex.arg, which lives in (−π, π] and wraps; the
classical θ(T) is the continuous branch, growing like T·log T. With
the principal branch both sub-leaves were unsatisfiable for large T —
the left sides grow while the band stays log-sized. The assembly
theorem was true but its hypotheses could never be discharged.

The repair, in `lean_stage3/Stage3/RvMCrude.lean` (rebuilt, 39/39,
8711 jobs, welds 2/0): rsTheta is removed; the decomposition is
parameterized by an abstract phase θ : ℝ → ℝ. StmtBacklundPhase θ B₁ B₃
(the phase tracks the main term) and StmtBacklundArg θ B₁ B₃ (the
count tracks θ/π + 1) name the two halves; RvM_of_phase_arg proves
that ANY phase satisfying both gives Riemann_vonMangoldt_bound
(B₁+B₁′) 0 (B₃+B₃′). Supplying a continuous phase — Binet's integral,
or Im log Γ integrated along a path — is now explicitly part of the
Stirling half's discharge.

Audit for that discharge (this session): PNT+'s Mathlib overlay
carries sorry-free norm-level Stirling machinery (GammaStirlingAux,
GammaBounds, StripBounds); no arg/Im-log-Γ layer exists anywhere in
the dependency. The Stirling slice therefore opens with the phase
construction, budget B₁ ≤ 100 where Rosser needs 0.137.

The meta-note for the record: the defect was caught by the discipline,
before propagation — designing the discharge against the stated leaf
is itself a check of the leaf. Same family as entry 96's lesson.

## 2026-08-24 — Entry 131 — RvMCrude: Backlund's decomposition assembled; hNT is now two smaller leaves
type: formalization
refs: 120, 128, 130

hNT-crude slice 1. `lean_stage3/Stage3/RvMCrude.lean`, one theorem,
one pin; package parity 39/39; builds clean at 8711 jobs; welds 2/0.

rsTheta defines the Riemann–Siegel phase arg Γ(1/4+iT/2) − (T/2)log π
via Mathlib's complex Gamma. StmtPhaseCrude B₁ B₃ names the Stirling
half (the smooth phase tracks the RvM main term — no zeros involved);
StmtArgCrude B₁ B₃ names the argument-principle half (the count tracks
θ(T)/π + 1 — this distance is S(T), O69's under-2-windings quantity).
RvM_of_phase_arg assembles them: the two halves give
Riemann_vonMangoldt_bound (B₁+B₁′) 0 (B₃+B₃′), a legitimate b₂ = 0
instance, consumed by ZeroSum and the entry-128 assembly unchanged.

Entry 130's budget accepts B₁+B₁′ ≤ 100, B₃+B₃′ ≤ 1000 at depth ≥ 7.
Discharge routes, for the coming sessions: StmtPhaseCrude by explicit
Stirling with a generous error; StmtArgCrude by Borel–Carathéodory +
ZetaBounds (both sorry-free in the dependency). Same architecture as
entries 113 and 125: name the leaves, kernel-check the assembly,
discharge in slices.

## 2026-08-24 — Entry 130 — The leaf budget: crude-explicit suffices for both open leaves
type: run
refs: 119, 120, 128, 129

Inline sensitivity run on O70's machinery (transcript-logged; grid in
chat, machinery identical to results/delivered_constant.json). Upstream
check first: our PNT+ pin 751a8c2 IS upstream HEAD — theorem_19 (1
sorry) and Buthe (8 sorries) still open there; no free inheritance.

The budget, chain constants from entries 123/128:
hNT — any Riemann_vonMangoldt_bound B: (1,1,10) → depth 9;
(10,10,100) → depth 8; (100,100,1000) → depth 7. Rosser's
(0.137,0.443,6.1) is ~70× sharper than the census needs.
hEF — any StmtExplicitFormula c: (20,10) → depth 9; (100,50) → depth
8; (1000,500) → depth 7. Both crude simultaneously: c=(200,100) with
B=(50,50,500) → depth 7, still past (20,6)'s depth 6.

What this respecifies: the leaf targets are crude-explicit versions,
not the literature's sharp ones — sloppy Stirling, generous Jensen
constants, wasteful contour estimates all acceptable. Different
difficulty class; the sorry-free substrate (RectangleArgumentPrinciple,
BorelCaratheodory, ZetaBounds, Kadiri helpers) is the toolkit.

Slice plans: hNT-crude first (argument principle on the ξ-rectangle +
generous Gamma-phase Stirling + S(T) ≤ B·log T via Borel–Carathéodory;
O69 measured the target: fluctuation under 2 windings in 10⁵). Then
hEF-crude (Perron with explicit truncation + rectangle contour shift +
ZetaBounds edges). Both are multi-session builds; the budget is the
spec they build to.

## 2026-08-24 — Entry 129 — O70: the census at the kernel's computed constant — depth 9, grid-stable
type: run
refs: 118, 123, 128

`python3 O70_delivered_constant.py`. Exploratory, no prereg. Output:
results/delivered_constant.json, log results/O70_delivered_constant_run1.log.

The chain's own numbers, no optimism: C_ψ = 9c₁+c₂+28+16b₁+16b₂+8b₃+4W
(entry 128, Assembly.lean), C_π = 3C_ψ+13 with k: 2→1 (entry 123,
PsiToPi.lean), floor x₀ = max(max(x₁,16)², 9). Instantiated at Rosser's
(0.137, 0.443, 6.1); W = 0 numerically (no zeros below height 1; stays
symbolic in Lean); hEF's open constants swept: c₁ ∈ {1,2,5,10},
c₂ ∈ {1,5}, x₁ ∈ {16, 2657}. Same M_low, wedge, census machinery as
O67/O68 (sanity-gated there).

Result: depth_covered = 9 in every one of the 16 grid cells. C_π runs
301 → 556 and R(1) moves only 48 → 50, R(6) only 74 → 76. The x₁
floor is invisible (its 2^22.75 window floor sits far below the
admissible r anyway).

Read: the conditional theorem the kernel actually proved supports
"under RH + the truncated explicit formula + Rosser Th. 19, (20,6) is
the last exact zero at every depth ≤ 9, for all r" — three past
(20,6)'s own depth, six short of Schoenfeld's ideal 15, and insensitive
to the open leaf's constants unless c₁ exceeds ten. The chain's
inflation (3C+13, the +28, the 16b's) is affordable at census width.

## 2026-08-24 — Entry 128 — THE ASSEMBLY: hRH + hEF + hNT → StmtPsiWeak, closed under the kernel
type: formalization
refs: 118, 121, 123, 124, 127

The decomposition plan's final theorem, in
`lean_stage3/Stage3/Assembly.lean`. Package parity 38/38; builds clean
at 8710 jobs; welds 2/0; gate 0.

psiWeak_of_RH_EF_NT: under Mathlib's RiemannHypothesis, the truncated
explicit formula (StmtExplicitFormula c₁ c₂ x₁), and Rosser's Th. 19
(Riemann_vonMangoldt_bound b₁ b₂ b₃, with b₃ ≥ 0 and the RvM(2) ≥ 0
floor), the kernel derives
   StmtPsiWeak (9c₁ + c₂ + 28 + 16b₁ + 16b₂ + 8b₃ + 4W) 2 (max x₁ 16)
with W the weighted zero-height bucket. The proof chooses its own
dyadic level (K = Nat.log 2 ⌊x⌋, so x < 2^(K+1) ≤ 2x), splits ψ−x
across the explicit formula, sends the zero side through the
√x·(log T)² bound (entry 127), and absorbs everything into C·√x·log²x
via three scalar helper lemmas (rem_arith, zeroinner_arith,
assembly_arith). Engineering notes for the record: the dyadic level
and the bucket must be made opaque (clear_value / parameterized W)
or defeq checks explode, and every linarith after the zero-side
bound enters context must be `linarith only` — the bound is too
large for the default preprocessor.

The chain, every arrow kernel-checked: {hRH, hEF, hNT} →(this)
StmtPsiWeak →(entry 123) StmtSchoenfeldWeak (3C+13, k−1) →(entry 121)
StmtWeakWindow →(entry 118, O68) the census. The open leaves are hEF
and hNT — exactly the two the adversarial audit named (entry 119),
both literature statements, both active IEANTN targets; when either
lands upstream, this tree inherits it by bumping the pin.

Composition with the bench arrow (lean/, v4.28.0) remains by statement
identity under utilities/check_weld.py — the standing caveat.

## 2026-08-24 — Entry 127 — The zero side at √x·(log T)²: slice 2 closed
type: formalization
refs: 124, 125, 126

ZeroSum slice 2, complete, in `lean_stage3/Stage3/Assembly.lean`.
Two theorems added; package parity 34/34; builds clean at 8710 jobs;
welds 2/0. The index bookkeeping (Finset.sum_bij' with structure-eta
rfl inverses) went through on the first build.

norm_zeroPartialSum_le_sharp — under RH the zero side is controlled
level by level: ‖zeroPartialSum x 2^(K+1)‖ ≤
2√x·Σ_{j≤K} (2^j)⁻¹·(2|N(2^(j+1))| + W), each level's weighted count
entering through IEANTN's sorry-free weighted_cumulative_count_le,
reached by the scalar domination of entry 126 — no shell partition.
norm_zeroPartialSum_le_logsq — composed with entry 124's counting
arithmetic: under hRH + hNT, the zero side is at most
2√x·(2·[(log2/2π)(K+1)(K+2) + 3(K+1)/π + 2(RvM(2^(K+1))+7/8)] + 2W).
The √x·(log T)² bound, every constant explicit.

What remains of the decomposition: one theorem. The assembly — from
StmtExplicitFormula move the zero side across with this bound, choose
K from log₂ x, deliver StmtPsiWeak with a computed constant. Then
PsiToPi's transfer (entry 123) and Statement's bridge (entry 121)
carry it to the census (entry 118).

## 2026-08-24 — Entry 126 — Dyadic refinement, half landed: the scalar domination and the per-zero bound
type: formalization
refs: 124, 125

ZeroSum slice 2, first half, in `lean_stage3/Stage3/Assembly.lean`.
Two theorems added, both pinned; package parity 32/32; builds clean at
8710 jobs; welds 2/0.

inv_le_dyadic_sum — the scalar heart of the refinement: for
1 ≤ γ < 2^(K+1), γ⁻¹ ≤ Σ_{j≤K} (2^j)⁻¹·[γ < 2^(j+1)]. Proved by
induction on K: the shell containing γ contributes a weight that
already dominates. This replaces the shell-partition argument — no
partition, no fibers, one scalar induction.
norm_term_le_dyadic — per zero, under RH: ‖x^ρ/ρ‖ ≤
2√x·Σ_{j≤K} (2^j)⁻¹·[|γ| < 2^(j+1)], splitting at |γ| ≥ 1 (the low
bucket rides on |ρ| ≥ 1/2, the rest on |ρ| ≥ |γ| and the scalar
lemma).

Remaining for the √x·(log T)² close, route recorded in the module
header: the sum swap (Finset.sum_comm), the per-level identification
Σ_{|γ|<2^(K+1)} m·[|γ|<2^(j+1)] = Σ_{|γ|<2^(j+1)} m via
Fintype.sum_equiv + Equiv.subtypeSubtypeEquivSubtype, then
weighted_cumulative_count_le per level feeds dyadic_abs_N_sum_le
(entry 124). After that, the assembly theorem closes hRH + hEF + hNT
into StmtPsiWeak and PsiToPi's transfer carries it to the census.

## 2026-08-24 — Entry 125 — Stage3/Assembly.lean: RH meets the zero sum
type: formalization
refs: 119, 123, 124

Step 5 of the decomposition plan, slice 1.
`lean_stage3/Stage3/Assembly.lean`, five theorems, five pins; package
parity 30/30; builds clean at 8710 jobs; welds 2/0.

Mathlib's RiemannHypothesis now does work under the kernel:
re_eq_half_of_RH — every nontrivial zero (IEANTN's NontrivialZeros,
re ∈ (0,1)) has re = 1/2; the strip rules out trivial zeros and s = 1.
norm_cpow_of_RH — the RH collapse: ‖x^ρ‖ = √x for x > 0.
norm_term_le_of_RH — ‖x^ρ/ρ‖ ≤ 2√x from |ρ| ≥ 1/2.
norm_zeroPartialSum_le — the zero side of the explicit formula
controlled by the count: ‖zeroPartialSum x 2^(K+1)‖ ≤
2√x·(2|N(2^(K+1))| + W), through IEANTN's sorry-free
weighted_cumulative_count_le.
zeroPartialSum defines the order-weighted Σ_{|γ|<T} m(ρ)·x^ρ/ρ;
StmtExplicitFormula states the hEF leaf — the truncated explicit
formula with explicit remainder, the genuinely open analytic input —
over Mathlib's Chebyshev ψ.

The chain standing kernel-checked: hRH collapses the zero side; the
count controls it (this module); hNT makes the count T·log T explicit
(entry 124); a ψ-bound transfers to π−Li dropping one log (entry 123);
the family reaches the window (entry 121); the window feeds the census
(entry 118: depth 11 at classical constants). Open leaves: hEF, hNT —
named, literature-shaped, both active IEANTN targets.

Remaining slices: ZeroSum slice 2 (dyadic 1/|γ| refinement through the
NontrivialZeros shells), the assembly theorem hRH + hEF + hNT →
StmtPsiWeak, and the census re-tabulation at the final constant.

## 2026-08-24 — Entry 124 — Stage3/ZeroSum.lean: the (log T)² arithmetic under hNT
type: formalization
refs: 119, 120, 123

Step 4 of the decomposition plan, slice 1.
`lean_stage3/Stage3/ZeroSum.lean`, seven theorems, seven pins; package
parity 25/25; builds clean at 8709 jobs; welds 2/0.

The module consumes IEANTN's riemannZeta.Riemann_vonMangoldt_bound
(Rosser Th. 19 shape — the hNT leaf, O69's measured band) and proves
the counting arithmetic step 5 needs, pure real analysis from the
hypothesis, no zero types:

N_abs_le — |N(T)| ≤ (T/2π)(log T + 3) + RvM(T) + 7/8, the T·log T
majorant with explicit constants (entry 119 recorded why T^(3/2) is
dead: depth 4, never reaching (20,6)).
dyadic_abs_N_sum_le — Σ_{j≤K} (2^j)⁻¹·|N(2^(j+1))| ≤
(log 2/2π)(K+1)(K+2) + 3(K+1)/π + 2(RvM(2^(K+1)) + 7/8). The (log T)²
zero-sum arithmetic; leading constant log 2/2π against the classical
Σ 1/γ ~ (log T)²/4π. Under RH this is what multiplies √x in the
explicit-formula remainder.
Supporting: RvM_mono, abs_mainterm_le via log_two_pi_le (2π ≤ e² from
Mathlib's decimal bounds on e and π), Gauss and geometric sums.

Slice 2 (open): link the sum to Σ' over NontrivialZeros through
IEANTN's sorry-free weighted_cumulative_count_le — zero-type plumbing,
their machinery, no new analysis. Then step 5: hRH + hEF + these →
StmtPsiWeak, closing the chain into PsiToPi's transfer.

## 2026-08-24 — Entry 123 — Stage3/PsiToPi.lean complete: the transfer delivers (3C+13, k−1)
type: formalization
refs: 118, 121, 122

Step 3 of the decomposition plan, complete.
`lean_stage3/Stage3/PsiToPi.lean` grows to twelve theorems, twelve
pins; package parity 18/18; builds clean at 8707 jobs; welds 2/0.

schoenfeldWeak_of_psiWeak is the capstone: a ψ-side weak bound
(C, k, x₀), k ≥ 2, x₀ ≥ 2, delivers StmtSchoenfeldWeak (3C+13) (k−1)
(max(x₀², 9)) for π(⌊·⌋) and Li — the conclusion is Statement.lean's
own Prop, so weakWindow_of_global composes directly. One log dropped,
constant inflated to 3C+13, floor squared. The proof: split at the
family floor; below it |θ−id| ≤ (1+log4)·t and the integrand is ≤ 5
(one_add_log_four_le: 1+log4 ≤ 5·log²2, from Mathlib's decimal bounds
on log 2); above it the family envelope integrates to
2(C·L^(k−2)+3)·√x via integral_A_rpow_le; absorption uses log x ≥ 1
and x₀ ≤ √x. Supporting: abs_theta_sub_le_linear, rpow_neg_half_mul,
integrability lemmas generalized to arbitrary endpoints ≥ 2.

The census reach of the delivered constants, checked on O68's
machinery: the classical RH ψ-bound (1/(8π))√x·log²x, x ≥ 74, delivers
(13.12, 1, 5476) → depth_covered = 11. A degraded ψ input (C=1, k=3)
still delivers depth 9. Every row past (20,6)'s own depth.

The chain now kernel-checked: StmtPsiWeak → StmtSchoenfeldWeak →
StmtWeakWindow. Open: step 4 (zero-sum from hNT), step 5 (hRH + hEF →
StmtPsiWeak), and the census re-tabulation once the delivered constant
is final.

## 2026-08-24 — Entry 122 — Stage3/PsiToPi.lean: the transfer identity proved, integrability discharged
type: formalization
refs: 118, 121

Step 3 of the decomposition plan, first slice.
`lean_stage3/Stage3/PsiToPi.lean`, eight theorems, eight pins, builds
clean at 8707 jobs. Package parity 14/14; welds 2, broken 0.

Li x = x/log x + ∫₂ˣ dt/log²t is the module's own logarithmic integral
(Mathlib carries none), offset from the literature's li by li(2) ≈ 1.045
— absorbed by the weak family's constants. On it, kernel-checked:

pi_sub_Li_eq — the EXACT decomposition, an identity via Mathlib's
Abel-summation bridge (Chebyshev.primeCounting_eq_theta_div_log_add_integral):
π(⌊x⌋) − Li x = (θx−x)/log x + ∫₂ˣ (θt−t)/(t·log²t) dt.
abs_pi_sub_Li_le — the envelope transfer: any pointwise |θ − id| bound
becomes a |π − Li| bound, top term plus envelope integral.
theta_err_of_psi — ψ-error to θ-error via |ψ−θ| ≤ 2√x·log x (Mathlib).
integral_A_rpow_le — ∫₂ˣ A·t^(−1/2) ≤ 2A√x, the envelope workhorse.
Four continuity/integrability lemmas discharge every side condition —
the theorem statements carry no integrability hypotheses.

Remaining in step 3: instantiate env with C·√t·(log t)^k + 2√t·log t
and compute the delivered (C′, k−1) — the transfer drops one log and
inflates the constant explicitly. Expansion-genre bookkeeping.

## 2026-08-24 — Entry 121 — Stage3/Statement.lean: the weak family named, the bridges proved
type: formalization
refs: 118, 119, 120

Step 2 of the decomposition plan. `lean_stage3/Stage3/Statement.lean`,
six theorems, six pins, builds clean at 8706 jobs on v4.32.2.

StmtSchoenfeldWeak C k x₀ names O68's grid as a Prop family;
StmtWeakWindow C k is its dyadic-window shape. The bridges:
schoenfeld_iff_weak (Cor. 1 is the member C=1/(8π), k=1, x₀=2657, as an
iff), weakWindow_of_global (global ⟹ window when the bottom clears x₀),
weakWindow_at_schoenfeld (at Schoenfeld's parameters the weak window is
the bench's StmtSchoenfeldWindow), window_of_global (the bench bridge
from lean/Schoenfeld.lean reproved statement-identically on this
toolchain — the weld demonstrated), weak_mono and weak_anti_x₀
(monotonicity in C and x₀).

What this buys: every row of entry 118's tolerance table is one
instantiation of one Prop, and the step-5 assembly theorem can deliver
any (C, k, x₀) it manages to compute — the window bridge is already
proved for all of them. StmtSchoenfeld and StmtSchoenfeldWindow are
character-level copies of the bench definitions, held by
utilities/check_weld.py (2 welds, 0 broken).

Next: step 3, PsiToPi.lean — |ψ−x| ≤ B transfers to |π−li| ≤ B′ via
Abel summation and the li-interpolant pattern from MainTerm.

## 2026-08-24 — Entry 119 — lean_stage3: the sibling package stands, and the decomposition repriced to three leaves
type: provenance
refs: 116, 117, 118

Step 1 of the decomposition plan. `lean_stage3/`, a sibling Lake package
on toolchain v4.32.2, requiring PrimeNumberTheoremAnd pinned at commit
751a8c2 with its Mathlib v4.32.2. Builds clean: 3665 jobs. The bench's
lean/ (v4.28.0) is untouched.

The dependency audit, from a shallow clone of the pin:

- Sorry-free where it matters: ZetaBounds, MellinCalculus, the rectangle
  residue calculus, HadamardFactorization, BorelCaratheodory, MediumPNT,
  Backlund/ZeroCountCrude all at zero. PerronFormula's one "sorry" is
  inside a comment. StrongPNT carries 5 (the strong error term; we do
  not consume it).
- ZeroCountCrude's count is N(T) ≤ A·T^(3/2) with existential A. Pushed
  through O68's machinery, a T^(3/2) count degrades the bound to
  x^(2/3) form: depth 4 at C=1, never reaching (20,6)'s depth 6. The
  agent's "hNT discharged from PNT+" (entry 116) fails at the shape and
  the constants.
- The compensating find: IEANTN's ZetaDefinitions defines
  riemannZeta.Riemann_vonMangoldt_bound b₁ b₂ b₃ — Rosser's Theorem 19
  as a named hypothesis Prop with the literature's explicit constants
  (0.137, 0.443, 6.1) — and KadiriZeroCounting.lean, sorry-free,
  derives the explicit dyadic zero-count consequences from it. The
  classical fact itself is one open sorry in their tree, an active
  target of Tao's IEANTN network. That is this bench's own
  architecture, found upstream.

The decomposition restated: hS → {hRH (Mathlib's RiemannHypothesis),
hEF (truncated explicit formula, explicit remainder), hNT (Rosser
Th. 19, explicit constants)}. Three named literature leaves, everything
between kernel-checked. Both open leaves are upstream targets; if
IEANTN lands them, this tree inherits by bumping the pin.

The weld: Stage3.lean states it loudly in its header, carries a
character-level copy of Nonvanishing.StmtSchoenfeldWindow, and
utilities/check_weld.py diffs the def blocks across the trees — 0
broken welds. Composition with the bench arrow is by statement identity
until the toolchains converge; every claim published from lean_stage3
carries that caveat.

Existence checks forced through the build: Mathlib's RiemannHypothesis,
Riemann_vonMangoldt_bound, zetaCounting_crude_majorant all elaborate.

Next: step 2, Statement.lean — StmtSchoenfeldWeak (C k x₀) and the
window bridge generalized from lean/Schoenfeld.lean's special case.

## 2026-08-24 — Entry 120 — O69: the crossover to the logarithm is at winding zero
type: run
refs: 118, 119

`python3 O69_angle_crossover.py`. Exploratory, no prereg. Output:
results/angle_crossover.json, log results/O69_angle_crossover_run1.log.
Data: imported/twin_count/zeros1.txt, 100000 zeros, γ ≤ 74920.8.

The question was Julian's pushback on entry 119's finding that PNT+'s
crude majorant (T^(3/2), no argument-principle input) cannot feed the
census: the count enters at T·log T "because after enough angles it
becomes a curve — calculate how many times the angles create the
crossover to a logarithm." N(T) is an angle count — each zero is one
2π winding of ξ around the rectangle — and the winding splits into the
Gamma factor's smooth phase (which is the logarithm) plus the
fluctuation S(T).

The measurement, four numbers:

1. Band entry: |N(T) − mainterm(T)| checked against Rosser's band
   0.137·log T + 0.443·log log T + 1.588 at every one of the 100000
   jumps, from below and above. Never outside — including far below
   T = 1467 where Theorem 19 claims validity. The crossover is at
   winding zero: the angle count is the log curve from the first zero.
2. Lock-on: within 1% of the curve by winding 80 (γ ≈ 201); within
   0.1% by winding 1049, at γ ≈ 1476 — Rosser's stated floor T ≥ 1467
   is visible in the data as the 0.1% lock-on point.
3. The price of skipping angles: the best possible T^(3/2) constant on
   this range is A* ≈ 0.0299 (attained at winding 25), already 6×
   wasteful at range top, and the waste grows like √T/log T without
   bound — the same fact O68 saw as the dead x^(2/3) route.
4. The phase split: the Gamma-phase logarithm carries 99.9994% of the
   count. S(T) never exceeds 1.63 windings in a hundred thousand, 39%
   of the Rosser band at range top.

The reframe this forces on the hNT leaf: the logarithm is what the
angles are made of — the smooth phase winds, ζ wobbles by under 2.
Discharging Rosser Th. 19 in Lean is two jobs: Stirling for the Gamma
phase with explicit constants (Mathlib has Stirling machinery), and
bounding S(T) by the argument principle on rectangles — and PNT+'s
RectangleArgumentPrinciple.lean is sorry-free. The entire open
difficulty of the zero-count leaf is bounding a quantity the data holds
under 2 windings in 10^5.

## 2026-08-24 — Entry 118 — O68: the tolerance table verified on bench machinery, and a correction to entry 116
type: run
refs: 112, 116, 117

`python3 O68_weak_bound_tolerance.py`, dps 40, rmax 600, dmax 24.
Exploratory, no prereg — a verification run gating entry 116's option 2.
Output: results/weak_bound_tolerance.json, log at
results/O68_weak_bound_tolerance_run1.log.

O67's E_high generalized to bound(x) = C·√x·(log x)^k for x ≥ x0:
E_high = C·(r·log2)^k·2^(r/2)·(1+2^(-1/2))^(d+1), window floor
r−d−1 ≥ log2(x0). M_low and the wedge unchanged. Sanity gate: at
(C,k,x0) = (1/(8π), 1, 2657) the R(d) table reproduces O67's committed
results/conditional_last_zero.json exactly — True.

The tolerance, on our own instrument:

```text
schoenfeld  C=1/(8π)  k=1            depth_covered = 15
psi_style   C=1/(8π)  k=2            depth_covered = 12
crude       C=1       k=2            depth_covered = 10
very_crude  C=100     k=2  x0=2^30   depth_covered = 8
crude_1000  C=1000    k=2  x0=2^30   depth_covered = 6
brutal      C=1e6     k=3  x0=2^60   depth_covered = 0
```

The adversarial agent's table (entry 116) is confirmed row for row.
Depth 6 is the last row that still covers (20,6)'s own depth — every
bound down to C=1000, k=2 keeps the full four-zeros headline, and what
degrades below C=1 is only the reach past it.

Correction to entry 116: that entry says "C = 1000 still yields depth
≤ 10". Wrong. C = 1 yields depth 10; C = 1000 yields depth 6. I
conflated the agent's "a thousand times worse" (C = 1 with the extra
log factor, ~1600× at census scale) with the literal constant 1000.
This entry is the dated correction.

Gate result: step 0 passes. The decomposition build (hS → {hRH, hEF})
is worth doing if its computed constant lands at k = 2 with C ≤ 100,
and still yields a theorem at C ≤ 1000. Next decision: step 1, the
sibling-package scaffold and the PNT+ dependency audit.

## 2026-08-24 — Entry 117 — Schoenfeld.lean: the unproven surface moved to the literature's own sentence
type: formalization
refs: 113, 115, 116

`lean/Schoenfeld.lean`, the twentieth module, two theorems and a definition.
Build clean, **8046 jobs, 250 theorems, 250 pins, parity in all 20 modules.**
Step 1 of every stage-3 route from entry 116, done in-tree.

`StmtSchoenfeld pi li` states Schoenfeld 1976 Corollary 1 in verbatim shape —
∀ x ≥ 2657, |pi x − li x| ≤ √x·log x/(8π) — over abstract functions.
`window_of_global` proves it implies the bench-shaped
`StmtSchoenfeldWindow` whenever the window bottom clears 12
(2^12 = 4096 ≥ 2657); the kernel-checked translation is √(2^y) = 2^(y/2)
and log(2^y) = y·log 2. `tableFrom_ne_zero_of_schoenfeld` restates the
capstone with the sentence as its one analytic input, the window bottom
raised to 12 ≤ r−(d+1), and compatibility hypotheses tying f and G to
pi and li at the points 2^m.

What this changes: before, checking the bench's hS against the literature
required translating a window-indexed rpow expression by hand. Now the
unproven surface is one line that can be compared against the published
corollary by eye. What it does not change: the sentence is still a
hypothesis. The decomposition hS → {hRH, hEF} (entry 116's option 2) is
the open decision; the tolerance-table verification gates it.

## 2026-08-24 — Entry 116 — Stage 3 audited, adversarially re-audited, and re-scoped: the pieces are here
type: motivation
refs: 112, 113, 115

I audited stage 3 (Schoenfeld in Lean) and recommended recording it out of
scope: no explicit formula, no zero counting, no li in the pinned Mathlib,
PNT+ took years. Julian suspected the call was consensus-shaped and ordered
an adversarial round: an agent briefed to argue stage 3 IS in scope, with
every Mathlib claim re-grepped against the pinned tree.

The agent overturned two of my claims and I concede both:

- "No ζ'/ζ machinery" was wrong. The pinned Mathlib has
  `LSeries_vonMangoldt_eq_deriv_riemannZeta_div`
  (Mathlib/NumberTheory/LSeries/Dirichlet.lean:434), the functional
  equation, Mellin inversion, Jensen's formula, Borel–Carathéodory, and a
  full Abel-summation API. Same failure as the § B4 grep: I asked the tree
  too narrow a question and reported the miss as absence.
- I audited the wrong target. The bench needs M_low > E_high, and
  M_low/E_high grows like 2^(r/2), so the tolerance for a worse constant is
  enormous: the agent re-tabulated R(d) and a bound of the shape
  C·√x·(log x)² with C = 1000 still yields "under RH, (20,6) is the last
  exact zero at every depth ≤ 10" inside O43's census. The buildable
  question is "any explicit RH-conditional bound", and my "months" was
  priced on 2024-era human-only effort against the full Schoenfeld summit.

What survived, conceded by the agent in the same brief: the truncated
explicit formula with explicit remainder (hEF) is open in every proof
assistant — the IEANTN files targeting it are sorried — and the PNT+
dependency lives on toolchain v4.32.2 against our pinned v4.28.0, so a
sibling package composes with our arrow by statement identity, which the
kernel does not check. Both must be labelled loudly if that route runs.

Decision (Julian): the lesson stands recorded — the default "out of scope"
was partly consensus; the pieces are in the tree and in reach. Route: do
the statement shrink now (StmtSchoenfeld verbatim + bridge, step 1 of every
path), verify the agent's tolerance table with our own O67 script, then
decide on the sibling-package decomposition (hS → {hRH, hEF}, hNT
discharged, ~70 theorems).

Eighteen months of work sit under this bench; the operating lesson is that
"known theorem, too big to formalize" is a prior to be tested, and the test
is a grep and an adversarial round, both cheap.

## 2026-08-24 — Entry 115 — Expansion.lean: stage 2b, the derivative floor proved
type: formalization
refs: 112, 113, 114

`lean/Expansion.lean`, the nineteenth module, seventeen theorems. Build clean,
**8045 jobs, 248 theorems, 248 pins, parity in all 19 modules.** Stage 2 of the
plan from entry 113, second half: the explicit expansion, and the floor.

### What the kernel now checks

```text
c_rec                    the coefficient recurrence — Pascal with the
                         factorial absorbed; the j = 0 edge dies on −j
hasDerivAt_S/F           term-by-term differentiation and the Pascal-shaped
                         recombination: F d' = F (d+1)
iteratedDeriv_f2x        THE EXPANSION: the d-th derivative of 2^x/x is
                         2^x · Σ C(d,j)(log 2)^(d−j)(−1)^j j! x^(−1−j)
                         on (0,∞), by induction
choose_factorial_step    C(d,j+1)·(j+1)! = C(d,j)·j!·(d−j), in ℕ
t_halves                 consecutive unsigned terms halve in the wedge
                         2d ≤ (log 2)·x
B_peel / B_bounds        the downward tail: 0 ≤ B k ≤ t k
S_floor / F_floor        THE FLOOR: S ≥ (log 2)^d/(2x), so the derivative
                         is ≥ 2^x (log 2)^d/(2x) — O67's CHECK 1, proved
                         rather than sampled
hD_of_window             the derivative hypothesis hD discharged from the
                         floor, wedge, and window bottom
tableFrom_ne_zero_of_li  THE ARROW ASSEMBLED: cell(r,d) ≠ 0 from a smooth
                         interpolant with G' = 2^x/x, Schoenfeld on the
                         window, and O67's gap arithmetic
```

The conditional theorem's hypothesis list after this module: `hG`/`hG'` (a
smooth interpolant with derivative `2^x/x` — Mathlib carries no logarithmic
integral, so li enters only this way), `hS` (Schoenfeld, stage 3, in no proof
assistant), and the arithmetic side conditions (`hrow`, `hr`, `hbot`, `hw`,
`hgap`). Every analytic step between Schoenfeld and the integer table is now
a theorem. § I2's chain is formal end to end; § I5 updated.

### What stage 3 is and is not

Schoenfeld's bound is the one remaining analytic leaf and it stays a named
hypothesis: it is in no proof assistant, and putting it in one is a project
on the scale of PrimeNumberTheorem+, out of scope here. The bench's claim is
the arrow, and the arrow is now kernel-checked.

## 2026-08-24 — Entry 114 — MainTerm.lean: stage 2a, the MVT retired
type: formalization
refs: 112, 113

`lean/MainTerm.lean`, the eighteenth module, ten theorems. Build clean,
**8044 jobs, 231 theorems, 231 pins, parity in all 18 modules.** Stage 2 of the
plan from entry 113, first half: the difference calculus.

### What the kernel now checks

```text
iter_bdiffR_eq_sum       n unit differences of a real function are the
                         alternating stencil — the ℝ-domain twin, again
                         through Mathlib's fwdDiff
stencilR_eq_iter         the bridge to Nonvanishing.stencilR at integers
deriv_bdiffR             Δ commutes with d/dx
iteratedDeriv_bdiffR     … and with iterated derivatives, by induction
bdiffR_lb                THE STEP: deriv g ≥ m on [x−1,x] ⟹ Δg(x) ≥ m,
                         via the shift y ↦ g(y) − m·y and Mathlib's
                         monotoneOn_of_deriv_nonneg
iter_bdiffR_lb           THE INDUCTION: the n-th derivative's floor on
                         [x−n, x] is the n-fold difference's floor — the
                         iterated mean value theorem, retired
stencilR_ge_of           hM's shape, given the derivative floor
tableFrom_ne_zero_of_deriv    the full arrow with hM replaced by the bound on
                         the (d+1)-th derivative of the interpolant
```

The conditional theorem's hypothesis list after this module: `hS` (Schoenfeld,
stage 3, in no proof assistant), `hD` (the floor on `iteratedDeriv (d+1)` of a
smooth li-interpolant), `hgap` (O67's arithmetic table). The MVT and the
difference-vs-derivative bookkeeping — § I2's middle — are theorems.

### What stage 2b still owes

The explicit expansion: `iteratedDeriv d` of `2^x/x` as
`2^x · Σ C(d,j)(log 2)^(d−j)(−1)^j j!/x^(j+1)`, by induction with a
Pascal-shaped recombination, plus the alternating pairing bound
`S ≥ t₀ − t₁ ≥ 0.51·t₀` in the wedge. That discharges `hD` down to `hgap`'s
arithmetic. It is Finset-and-deriv work, fiddly, not blocked.

A note on li: **Mathlib carries no logarithmic integral**, so li enters the
formalisation only as a smooth interpolant `G` with the right derivative —
which is the honest shape anyway, since the lower bound uses nothing about li
except `L' = 2^x/x`.

### Friction for the next instance

`ContDiff.differentiable_iteratedDeriv` wants `(m : WithTop ℕ∞) < n` — the
coercion closes with `exact_mod_cast WithTop.coe_lt_top _` and nothing
simpler. `deriv_sub` will not rewrite under a lambda that is not literally a
subtraction of named functions; going through `HasDerivAt.sub` and `.deriv`
avoids the whole shape problem. And a `hM_of_derivBound` promised in the first
draft's header never existed — the docstring was corrected before landing
rather than the theorem invented to match it.

Status and any verdict are Julian's.

---

## 2026-08-24 — Entry 113 — Nonvanishing.lean: stage 1 of O67's theorem, the arrow under the kernel
type: formalization
refs: 112

`lean/Nonvanishing.lean`, the seventeenth module, eight theorems. Build clean,
**8043 jobs, 221 theorems, 221 pins, parity in all 17 modules.** Stage 1 of the
plan approved after entry 112: formalise the implication in the house pattern,
leave the analytic leaves as named hypotheses, discuss stage 2 if it lands.

It landed.

### What the kernel now checks

```text
iter_bdiffZ_eq_stencilR   d differences of a real sequence = the alternating
                          stencil — Zeros.tableFrom_eq_stencil transplanted
                          to ℝ via Mathlib's fwdDiff
stencilR_row              depth-d on the row = depth-(d+1) on the counting
                          function: one Function.iterate_succ, nothing else
stencilR_sub              linearity, splitting π = li + (π − li)
window_term_le            each windowed Schoenfeld bound ≤ top-of-window
                          bound × 2^(−k/2)
error_bound               the binomial theorem at t = 2^(−1/2) closes the
                          weighted sum: |stencil of (π − li)| ≤ Ehigh
nonvanishing_of           THE ARROW: hS + hM + hgap ⟹ stencil of π ≠ 0
tableFrom_ne_zero_of      the conclusion on the integer table, through the
                          cast bridge and Zeros.tableFrom_eq_stencil
```

All at the ℂ floor (ℝ-valued). The named hypotheses, which are the honest
boundary: `hS` Schoenfeld on the window (stage 3 — in no proof assistant),
`hM` the main-term floor (stage 2 — the MVT/alternating step, O67's checks 1–2),
`hgap` the per-(r,d) arithmetic O67 tabulates as `r ≥ R(d)`.

This module is to § I what `Chain.C3_of_A4_C2` is to the chain paper.

### Build friction worth recording

Mathlib's `fwdDiff_iter_eq_sum_shift` carries **ℤ-scalars** — the coefficient
is a zsmul, so `smul_eq_mul` cannot fire and the fix is
`zsmul_eq_mul` + `push_cast` + `linear_combination`. And a first draft of the
Pascal step by direct sum-shuffling died with a `sorry`; the clean route is the
iterate picture, where the row step is `Function.iterate_succ_apply` and costs
one line. The failed draft is not in the tree.

`The-Four-Zeros.md § I5` updated: the arrow is in Lean, cited by name; the
leaves are exactly what remains. Stage 2 — discharging `hM` via an integral
representation of iterated differences — is scoped and waiting on Julian's go.

Status and any verdict are Julian's.

---

## 2026-08-24 — Entry 112 — O67: under RH, (20,6) is the last exact zero at every depth up to 15
type: result-triage
refs: 26 (vol 1), 111

`O67_conditional_last_zero.py`, `results/conditional_last_zero.json`, run log.
Ranked action #7 from entry 111's queue. Entry 26 (2026-08-17) recorded
"THEOREM AVAILABLE — under RH, Δ^d π(2ⁿ) ≠ 0 for r > R with R explicit; would
settle (20,6) as last." Seven days later, this supplies it, and it lands
stronger than the line promised.

### The theorem

Under RH, `cell(r,d) ≠ 0` for every `r ≥ R(d)`, `R(d) ≈ 5d + 11` explicit:
`R(1) = 16` through `R(15) = 91`. Five steps: the stencil (B4, proved); split
`π = li + (π − li)`; iterated MVT puts the li part at a `(d+1)`-th derivative of
`li(2^x)` in the window; that derivative is an alternating series with ratio
`< 0.4905` in the wedge `d ≤ 0.34(r−d−1)`, giving
`M ≥ 0.5·2^(r−d−1)(log 2)^d/r`; Schoenfeld caps the error at
`(log 2/8π)·r·2^(r/2)·(1+2^(−1/2))^(d+1)`. The two nonstandard steps —
alternating lower bound and MVT placement — verified numerically at nine points
in the artifact, all passing.

### The payoff

`R(d) ≤ 91` for every `d ≤ 15`, and O43's census covers `r ≤ 92`. Overlap, no
gap: **under RH, the four zeros are the complete set at every depth `d ≤ 15`,
for all `r`.** `The-Four-Zeros.md` gains § I (five statements); H1 and H2 move
from "unknown" to "unknown unconditionally; settled under RH at `d ≤ 15`."
B10's accident reading sharpens: under RH nothing more arrives in the shallow
table.

### The edges, exactly

Conditional on RH. At `d ≥ 16` a finite strip is unchecked, starting at three
cells `r ∈ {93,94,95}` at `d = 16` — published `π(2ⁿ)` above 92 would close
successive strips. The deep region `d > 0.34(r−d−1)` is untouched: Schoenfeld
does not reach the window bottom and the derivative series is uncontrolled. Not
in Lean — the analytics (MVT, Schoenfeld) are beyond the tree's current reach
and Schoenfeld is in no proof assistant; § I5 says so.

`check_values` rose 127 → 132 on § I's numbers.

Status and any verdict are Julian's.

---

## 2026-08-24 — Entry 111 — A fresh-eyes reading of the whole tree, the pushback, and where it settled
type: result-triage
refs: 94, 103, 107, 110

A subagent with no history in the project read the tree cold — README,
CONTEXT.md, THEOREMS.md, four papers in full and ten in part, entries 93–110,
the three literature searches — ran `four_zeros.py` and both gates, and
reported. Three of my pushbacks went back; it conceded two and held one. The
exchange is summarised here because the *settled* positions are the record; the
full texts are session-ephemeral.

### The reading, as delivered

**What it is:** a ten-day human-plus-LLM campaign around one genuinely novel
checkable finite fact — the four zeros, absent from OEIS and the searched
literature — surrounded by a competent numerical re-derivation of standard
theory and a Lean tree that formalises the geometry without deciding anything.
The mathematics is mostly rediscovery and the tree knows it.

**Strongest artifact:** `four_zeros.py` plus the zero-axiom Lean chain —
novel, kernel-verified from raw data, reproducible by a stranger in ten
seconds. Nothing else has all three properties.

**Weakest thing presented as strong:** the README leading with O57/O58 as
findings — correct measurements of textbook content, showcased as discovery.
My entry 94 framing "two instruments agreeing" functions as overselling.

**The displacement claim:** the methodology is the contribution — prereg with
both-direction decision rules, axiom-pinned formalisation welded to measured
data, the negative-results paper, gates verifying prose against artifacts, and
a notebook treating the assistant's own cognition as an instrument requiring
calibration. What a second team could pick up tomorrow.

It also caught two live defects in the two most public files — `four_zeros.py`
saying 992 cells (the OEIS antidiagonal count, copied into the wrong file)
where the script prints 1953, and the README stale at 14 modules / 197
theorems. Both recalled-not-loaded errors of exactly the class `CLAUDE.md`'s
top rule warns about. **Fixed and pushed before anything else.**

### The pushback, and where each point landed

**G4 (mine: it buried the tree's one unexplained measurement).** Conceded
upward — G4 moves to "the strongest open empirical question in the tree" — but
my framing "theorem kills mechanism, measurement persists" was **corrected on
the module's own docstring**: `no_interior_peak` excludes one narrow power-law
form only, the D-block is evidence *for* the block-size account (per-set gains
monotone in generator count), and `The-Four-Prime-Peak.md § D4` already
extrapolates **G5 overtaking G4 near xmax ≈ 4e11**. The probable reading is a
slowly-moving transient with a named kill test. I accept in full.

**Twin rigidity (mine: may be a result, not an opening).** Promoted to
"candidate result, unplaced" — it searched and cannot name the statement;
nearest neighbours Gallagher 1976, Torquato–Zhang–de Courcy-ireland
hyperuniformity (arXiv:1802.10498), the singular-series-sums literature. Held
out of "survives review" for a reason that is a genuine find: **at
x ~ 6e10 the Bernoulli control itself reads 0.93, identical to the twin value —
O66's "rigidity gone" endpoint is degenerate with its own control.** Three
heights, and the load-bearing one cannot distinguish signal from null. A real
design defect in O66, missed by me and by the first adversarial pass.

**O58 (mine: instrument, not re-measurement).** Conceded cleanly upward. Its
role was closing entry 92's recorded circularity — every result O17–O50
expressed in the √x scale RH predicts with nothing testing it — and as an
internal-consistency instrument it stands. The criticism reduces to my README
framing, which I will fix.

**Amended inventory, agreed by both sides:** one verified finite object, two
unplaced candidate empirical facts (G4, twin rigidity), and the apparatus. The
apparatus is still the contribution.

### Concrete actions, added to NOTEPAD as open lines

1. litsearch_4 — the twin-rigidity statement (correlated ρ²-thinning keeping
   HL pair structure while losing number rigidity).
2. O66 v2 — more heights with stated uncertainty; the current endpoint is
   degenerate with its control.
3. O24 toward the 4e11 region — does G5 overtake G4 where § D4 extrapolates.
4. README reframe — "What is measured" to lead with the pipeline and the
   internal-consistency role, not O57/O58 as findings.
5. The economical-reading sentence into The-Four-Zeros — the shallow-row
   accident reading, stated once plainly instead of distributed across B9 and
   the O43 verdict.

Status and any verdict are Julian's.

---

## 2026-08-24 — Entry 110 — Three of Julian's open decisions, made and applied
type: provenance
refs: 73, 75, 108, 109

Julian approved the recommended shape on each of the standing decisions in one
pass; this entry records what was decided and what changed on disk.

### The-Composite-Arm stays standalone; the banner is off

Decision: the C-block crossing table — fifteen diagonals, the prime arm always
going negative first — is its own object, covered nowhere else, so the paper
earns standalone rather than folding into `The-Four-Zeros.md § E`. The
PROVISIONAL banner's four conditions being met (t25, entry 108), the banner is
replaced by a short decision record naming this entry.

### O48's verdict is written, and the design is retired

The Run record's verdict line now reads **`compromised` — and the design is
retired rather than revised**, written on Julian's approval. The mechanical
output was `compromised` (control floor 0.7549 against a locked 0.80, entry
73). Retirement rather than a v2 because entry 75 establishes the deeper
problem: the gain saturates at the C2 ceiling by depth 1 or 2, so no depth
window exists in which a sub-ceiling mode is visible — the design's question
cannot be answered by any control on this axis. The prereg's locked-parameter
table is untouched; only the Run record moved, which is the mutable part.

### The NOTEPAD sweep is authorised

The proposed-transitions block goes to chat (ephemeral, per root CLAUDE.md);
transitions remain Julian's to apply. Generated in the same session as this
entry.

OEIS submission remains with Julian, package ready in `results/`.

Status and any verdict beyond the one recorded above are Julian's.

---

## 2026-08-24 — Entry 109 — Every theorem accounted for: the citation linker, the roles file, and eleven citations
type: provenance
refs: 108

`lean/THEOREMS.md` reported 159 of 213 theorems cited by no paper or note.
That number is now zero-or-explained: **162 cited, 29 tagged support, 22 tagged
record, 0 untagged.** Gate at zero broken references throughout; values at
127/0.

### The number was mostly a detection artifact

The index accepted only qualified `Module.name` citations. The repo's prose
uses three forms, and the linker now recognises all of them:

1. **Qualified**, as before.
2. **Bare unique names** — ≥ 10 chars, or underscore-bearing at ≥ 6, defined in
   exactly one module. The notebook discusses theorems this way constantly,
   inside fenced blocks; an underscore makes a prose false positive essentially
   impossible.
3. **Chain labels** — a theorem whose docstring opens `**A1.**` formalises that
   statement of its module's companion paper (read from the "Companion to
   papers/…" header). The statement existing in the paper is the prose
   counterpart. This is the papers' own convention: they cite
   `Euler-Factor-Chain.md § A1`, never `Chain.A1`.

Two bugs in my own linker found on the way: the companion regex was missing the
space after "Companion to" — form 3 never fired at all — and the
label-to-theorem match could span a `def`'s docstring boundary, mislinking A1 to
`bdiff_smul`. `159 → 85 → 74 → 62` as the forms landed.

### The roles file

`utilities/theorem_roles.txt`, 51 entries, two roles:

* **support** (29) — a lemma feeding a cited theorem; never needs prose.
  `stencil_add`, `pasc_zero`, `telescope`, the Chain arrows, membership steps.
* **record** (22) — verifies a measured artifact; papers cite the artifact.
  SeedPerturbation's eleven measured-pair falsifiers, Measured's seven
  `agreement_*` rows, the bench checks.

The index reads the file, warns on stale names, and prints anything uncited and
untagged as **UNTAGGED** — so the state is a maintained invariant now, like the
axiom pins, rather than a number that regrows silently.

### The eleven genuine gaps, closed with citations

Papers claimed the content without naming the proof. One line each, where the
claim already stood:

* `The-Four-Zeros.md § B2` — the deep-zero repeats now cite
  `zero_at_20_6_of_repeat` and `zero_at_8_3_of_repeat`.
* `Euler-Factor-Chain.md § G7′` — the two-generator sentence now cites
  `torus_shift`, `torus_period`, `generators_indep`, `zmap_shift_modulus`,
  which are exactly what it asserts.
* `Euler-Factor-Chain.md § B2` — `h(s) = h(1−s); h(0) = h(1) = 0` now cites
  `h_functional_equation`, `h_zero`, `h_one` beside the O37 verification.
* `Formalization.md § B3` — the vacuity threshold cites
  `covered_of_half_spacing`; § B2's mechanism sentence cites
  `ratio_strictMono` and `at_most_one_crossover`.

### What this leaves

Nothing on this thread. The follow-on that exists but was not scoped here: 17
theorems have no docstring claim (the index's third summary line), which is a
docstring-writing pass, not a citation problem.

Status and any verdict are Julian's.

---

## 2026-08-24 — Entry 108 — t25: The-Composite-Arm's figures all reproduce, and the gate reaches zero
type: run
refs: 107

`t25_composite_arm.py`, two runs. `results/t25_composite_arm.txt` (tee'd, as
the paper's header requires) and `.json`. **EXPLORATORY** — no prereg, no
verdict.

### What this closes

`papers/The-Composite-Arm.md` has been PROVISIONAL since 2026-08-20 — every
figure computed inline in conversation, existing in no artifact, which is
exactly the failure `What-Didnt-Work.md` § D1 records. Its header names four
conditions; this meets 1 and 2. Its two `PENDING t25` citations were the only
broken references in the tree.

**The gate is at zero broken references for the first time in the repository's
history.** `utilities/refs_baseline.txt` is now an empty file.
`check_values` rose 113 → **127 confirmed**, fourteen of the paper's numbers
now tracing to the new artifact.

### The verification

Every figure reproduces, from `primecountpy` at `r ≤ 32`:

* **A1** — the pair identity at every cell `d ≥ 1`, zero failures; 492 nonzero
  cells, exactly as stated.
* **A3** — `prime_res + comp_res = 0`, checked **integer-exactly** as
  `TP + TC − 2^(r−1−d)`.
* **B1** — prime zeros exactly the four; composite zeros exactly `{(3,2)}`.
* **C1** — all fifteen diagonals match: first-negative depths and lags,
  entry for entry.
* **C3** — `(23,10) = −8656/+12752`, `(25,11) = −22493/+30685`, The-Fold's
  two cells, exact.

### Two of run 1's mismatches were mine, one was the paper's

**Mine 1.** I checked the A3 cancellation through float li-differences and got
`4.5e−8` — the identity is integer-exact and the noise was my pipeline.

**Mine 2.** The I3 residual triple `−24.886 / −133.761 / −453.424` is the
**Riemann R model at the house depths 0, 3, 6** (O34's depths). I tried `li` at
`d = 0,1,2`. R at `d = 0` gives `−24.886` and at `d = 3` gives `−133.761`
exactly, which settles what model the inline conversation used.

**The paper's.** C4 said "five of the fifteen diagonals have a lag of exactly
1." Its own C1 table lists **four** — diagonals 5, 8, 9, 12 — and the
measurement reproduces C1 exactly. C4 contradicted the paper's own table. C4
now reads four, with the correction noted in place.

### Paper state after this

Citations updated from `PENDING t25` to the artifact; header conditions 1 and 2
struck through as done; C4 corrected; E4 rewritten to say the script exists.
**Conditions 3 and 4 — placement (standalone versus The-Four-Zeros § E) and
removing the PROVISIONAL header — are Julian's and remain open.**

Status and any verdict are Julian's.

---

## 2026-08-24 — Entry 107 — O66: Hardy–Littlewood measured on the twin lattice, and the rigidity the twins do not have
type: run
refs: 103, 105, 106

`O66_twin_spectral.py`, two runs. `results/twin_spectral.json`, both run logs.
**EXPLORATORY** — no prereg, no verdict. Physics list #5, the last one.

### The design

The twin process's zeta-side spectrum is already a measured null
(`imported/twin_count`, `zeta_power_ratio = 0.347`, The-Deep-Ladder § F6), so
this asks the two questions that null leaves open, with the instruments entries
103 and 105 built: does the twin process inherit the primes' **rigidity**, and
do its **pair correlations** match Hardy–Littlewood.

Windows of `2^20` sites `6k` at `x ~ 6×10^6, 6×10^8, 6×10^10`, occupancy by
segmented sieve. `R(h) = E[t_k t_{k+h}]/E[t]^2` against the 4-tuple singular
series `S(0,2,6h,6h+2)`; variance ratio `F` in blocks against a Bernoulli
control at the same density.

### Run 1's error, mine, kept on the record

The HL prediction was written as `S₄/S₂²` and read a mean error of 4.7. It is
off by exactly **6**: pairs-of-twins density per site is `6·S₄/log⁴x` while the
squared single-twin site density is `(12C₂/log²x)²`, so the lattice conditioning
enters the numerator once and the denominator twice —
`R(h) = S₄/(6·S₂²)`. The derivation now lives in the script's docstring where
the constant does. Run 2 is the corrected normalisation.

### Hardy–Littlewood, confirmed at 2–4% over 30 lags and three decades

The prediction is genuinely nontrivial — it oscillates lag by lag — and the
measurement tracks every swing:

```text
  h    R meas    R HL      (k = 1e6)
  1     0.419    0.397     adjacent twin pairs REPEL
  2     1.052    1.058
  3     0.789    0.794
  5     1.594    1.588     lag-5 pairs ATTRACT
 30     1.805    1.785
mean |R − HL| = 0.0209 / 0.0391 / 0.0434 at the three heights
Bernoulli control: 0.0236 / 0.0328 / 0.0736 from 1, structureless
```

The sign structure — repulsion at lag 1, attraction at lag 5 — is pure
arithmetic of the tuple's residues, and it is in the data.

### The rigidity the twins do not have

```text
                F twin    F bernoulli    prime-sites low-freq ratio
x ~ 6e6          0.71        0.95              0.826
x ~ 6e8          0.91        1.01              0.868
x ~ 6e10         0.93        0.93              0.897
```

Mild sub-Poisson at low height, gone by `x ~ 6×10^10` — while the prime sites
in the SAME windows keep their low-frequency suppression. On one lattice, in
one window: **primes are rigid, twins are Poisson-plus-HL-correlations.**
Consistent with a density-squared thinning, and it is the same asymmetry O51
found in the zero census — the twin arm has no deep structure — now on the
fluctuation axis.

### The physics list, closed

```text
#1  GUE spacing            entry 103   the zeros' rigidity, spectrally
#2  transfer operator      entry 104   bdiff in Mathlib's vocabulary
#3  sub-Poisson variance   entry 105   the primes' rigidity, in counts
#4  transport + cone       entry 106   the propagator, Mathlib-free
#5  twin lattice process   here        HL confirmed; rigidity absent
```

The shape that emerged: 103 and 105 are one object (Montgomery, two-sided);
104 and 106 are one operator (spectral and spatial faces of `bdiff`); and 107
is the boundary case — the process on the same lattice that has the
correlations but not the rigidity.

Status and any verdict are Julian's.

---

## 2026-08-24 — Entry 106 — Propagation: the recurrence as transport, Mathlib-free, with the cone and the propagator
type: formalization
refs: 104, 105

`lean/Propagation.lean`, the sixteenth module. **Mathlib-free** — Lean core plus
`Construction` and `SeedPerturbation`, extending the core discipline exactly as
`lean/BUILD.md` § Mathlib-free core instructs. Build clean, **8042 jobs, 213
theorems, 213 pins, parity in all 16 modules.** Physics list #4.

### The honest name

`Depth-as-Time` reads depth as time. Taken literally, the recurrence
`cell(r,d+1) = cell(r,d) − cell(r−1,d)` is one step of **first-order upwind
transport**, iterated — not the second-order wave equation. The module header
records the distinction; "wave" was the loose word.

### What compiled

```text
pasc, pasc_zero, pasc_succ   binomials BY the Pascal recurrence — core has no
                             Nat.choose, so Pascal's identity is definitional
pasc_eq_zero, pasc_pos       vanishing above the diagonal, positive on and below
neg_one_pow                  (−1)^m is 1 or −1, core carries no pow lemmas
outside_cone_zero            a point source at rung s reaches nothing outside
                             s ≤ r ≤ s+d — range of influence, speed exactly 1
propagator                   inside the cone, cell(s+k,d) = (−1)^k·C(d,k) —
                             the Green's function IS the alternating stencil
cone_filled                  and it never vanishes inside: NO LACUNAE
flux_form                    the recurrence as a conservation step
```

Axiom profile: `pasc_zero`, `pasc_succ`, `pasc_eq_zero` at **no axioms**;
`neg_one_pow` at `propext`; the rest at `[propext, Quot.sound]`. The whole
module sits below the ℂ floor, which is the point of putting the physics
reading on the integer side.

### What was already there, credited rather than re-proved

The backward cone — a cell reads only `[r−d, r]` — is
`Construction.zero_determined_by_row`, proved before anyone called it a domain
of dependence. The reflection at a node — the `±343` pair — is
`Zeros.neg_below_zero` and `pair_shares_diagonal`. This module adds the forward
cone, the propagator, and the no-lacunae fact.

### The closure worth stating

`cone_filled` is the structural reason exact zeros are rare: a disturbance
cannot dodge any cell of its forward cone, so a zero at `(r,d)` requires exact
cancellation of everything upstream — which is `zero_iff_repeat` seen from the
transport side. Rarity is a property of the propagator having no zeros, made
literal.

### Build friction worth recording

Core has no `Nat.choose` (probed before writing), no pow lemmas, and `omega`
rejects goals with products of opaque atoms — the interior-case algebra had to
be an explicit `simp only` chain over `Int.neg_mul`/`Int.mul_add` with
`Int.add_comm` closing, rather than one `omega` call. And an inserted lemma
landed between a docstring and its theorem, which parses as two consecutive
docstrings and fails loudly — the discipline's failure mode is at least visible.

Physics list: #1, #2, #3, #4 closed. Open: #5, the twin arm's spectral measure.

Status and any verdict are Julian's.

---

## 2026-08-24 — Entry 105 — O65: the primes' variance measured directly, closing O63's caveat and meeting entry 103 from the other side
type: run
refs: 102, 103, 104

`O65_variance_ratio.py`, two runs. `results/variance_ratio.json`, both run
logs. **EXPLORATORY** — no prereg, no verdict. Physics list #3.

### The statistic

Variance-to-mean `F` of prime counts in 400 disjoint width-`H` blocks, detrended
by `li` per block. Poisson gives `F = 1`. Swept over `H` from `(log x)²` to
`x/10` at three decades, plus the interiors of single dyadic blocks.

### Run 1's defect, kept on the record

Run 1 used raw `Var(c)/mean(c)`. At large `H` the 400-block window spans a wide
range of `x`, the density falls across it, and the variance measures the smooth
trend — `F = 750` at `x0 = 1e8, H = x/10`, and `F = 40796` at `1e10`. Detrending
by `li` per block is the standard fix and is run 2. Run 1 stands as the warning:
the trend confound produces spectacular super-Poisson numbers that mean nothing.

### Run 2

```text
                F real, by H:
  x0        (log x)²  (log x)³   x^0.5   x^0.75    x/10
  1e6         0.536     0.365    0.430    0.233   0.222
  1e8         0.537     0.390    0.412    0.224   0.151
  1e10        0.663     0.610    0.432    0.198   0.150

  inside dyadic blocks (2^r, 2^(r+1)] chopped into 400:
      r=20 → 0.376     r=27 → 0.257     r=33 → 0.198
  Poisson control: 0.91 – 1.17 everywhere
```

**Sub-Poisson at every scale tested, falling monotonically with `H`**, with the
control pinned at 1 so the estimator is not inventing it. The dyadic interiors
sit on the same curve — `0.198` at `r = 33` is the `x^0.75`–`x/10` regime, which
is where blocks of width `x/2` live.

### What it closes

**O63's caveat, in the grounding direction.** Entry 102 recorded "sub-Poisson
variance is the likely known cause" of the depth-5 anomaly. Measured directly:
prime counts fluctuate at 15–40% of Poisson variance, so differencing takes far
longer to amplify them. O63 saw this through the difference table; O65 sees it
in the counts; they agree.

**And the loop with entry 103.** Goldston–Montgomery ties this variance in the
`H ~ x^δ` range to the pair correlation of the zeta zeros — the statistic O64
measured spectrally. The bench now holds the same object from both sides: the
zeros' rigidity in the spectrum (0.027 frac<0.5 at n = 37, entry 103) and the
primes' suppressed variance in the counts (F ~ 0.15–0.2 at large H, here). Two
faces of the Montgomery connection, both measured on this bench's own data.

### What this is not

Discovery. Sub-Poisson variance of primes in intervals is classical territory
(Goldston–Montgomery, Montgomery–Soundararajan), and these numbers are
calibration against it rather than news. The content is that the connection to
the tree — O63's depth profile, the dyadic blocks' place on the curve, the
two-sided Montgomery loop with entry 103 — is now measured rather than verbal.

Physics list: #1, #2, #3 closed. Open: #4 the wave-equation reading, #5 the
twin arm's spectral measure.

Status and any verdict are Julian's.

---

## 2026-08-24 — Entry 104 — TransferOp: bdiff named as the operator it is, in Mathlib's vocabulary
type: formalization
refs: 103

`lean/TransferOp.lean`, the fifteenth module, six theorems and one definition.
Build clean, **8041 jobs, 204 theorems, 204 pins, parity in all 15 modules.**

### What was missing

`papers/Depth-as-Time.md` reads depth as iteration — a growth factor per mode
(A3), γ₁ the fastest-growing mode in base 2 (B4), the C2 band as the gain
spectrum. That is transfer-operator vocabulary, and none of it was stated in the
formalization: `Chain.A1` proves the eigen-relation pointwise and stops, and the
linearity of `bdiff` was consumed everywhere (`bdiff_smul`,
`Superposition.bdiff_sum`) and asserted nowhere.

### What compiled

```text
bdiffL                       Chain.bdiff as a Module.End ℂ (ℂ → ℂ)
bdiffL_apply                 the wrapper is definitional
mode_ne_zero', mode_ne_zero  a mode never vanishes (cpow_ne_zero_iff)
mode_hasEigenvector          the mode IS a Module.End.HasEigenvector,
                             eigenvalue Sym b ρ
sym_hasEigenvalue            every symbol value is in the point spectrum
mode_pow                     (bdiffL^N) mode = Sym^N • mode, via Mathlib's
                             HasEigenvector.pow_apply — Chain.A4 as an
                             operator identity
eigenvalue_zero_iff_lattice  the kernel eigenvalue occurs exactly on
                             (2πi/log b)·ℤ — sym_eq_zero_iff read as spectrum
```

All at the ℂ floor. The point of the exercise: the difference operator, its
eigenfunctions, its multipliers and its kernel are now in the standard
vocabulary (`Module.End`, `HasEigenvector`, `HasEigenvalue`), so anyone from
the dynamical-systems side recognises the object without reading this tree's
private definitions.

### What is not claimed, stated in the module

Ruelle theory proper — trace formulas, Fredholm determinants, a spectral gap —
is not formalised and is not close. The dynamical readings of Depth-as-Time § B
are measurement; this module supplies the algebra they read through.

### A counter defect, fixed by convention

`@[simp] theorem` on one line escapes the parity counter's `^theorem` grep —
the build showed 6/7 on the new module with nothing wrong. Fixed by putting the
attribute on its own line. The counter itself is unchanged; the convention is
now: attributes on their own line, so the discipline's numbers stay honest.

Physics-connections list: #1 (GUE spacing) closed in entry 103, #2 (transfer
operator) closed here. Open: #3 sub-Poisson variance, #4 the wave-equation
reading, #5 the twin arm's spectral measure.

Status and any verdict are Julian's.

---

## 2026-08-24 — Entry 103 — O64: the measured spectrum carries the zeros' repulsion, and the instrument's fake repulsion quantified
type: run
refs: 93, 94, 95, 102

`O64_gue_spacing.py`, two runs. `results/gue_spacing.json`,
`results/gue_spacing_run2.json`, both run logs. **EXPLORATORY** — no prereg, no
verdict.

### The question

Montgomery's pair-correlation conjecture — zeta zeros repel like GUE
eigenvalues — is the standing physics link to RH, and nothing in this tree had
touched it. This bench detects zeros out of prime counts. So: do the DETECTED
peaks show the repulsion, at the resolution this instrument has?

### The design is the control

Finite resolution fakes level repulsion: two frequencies closer than `dγ` merge,
so any spectrum read through the pipeline is repelled at short range by the
instrument alone. Three arms through one identical pipeline — the real prime
residual, a synthetic built from the true zeros, and a synthetic with
Poisson-placed frequencies at the zeros' own unfolded density. If the pipeline
cannot tell model from Poisson, the honest answer is "unmeasurable" and that is
the result.

Statistic: peaks above 5× median, nearest-neighbour spacings unfolded by
`ρ(γ) = log(γ/2π)/2π`. References: GUE `frac<0.5 ≈ 0.106`, Poisson `≈ 0.393`.

### Run 1, band (10, 500): the statistic fails, informatively

* **The instrument manufactures repulsion, quantified.** Poisson frequencies
  enter at `frac<0.5 = 0.372` and exit the pipeline at `0.102` — random spacings
  come out looking GUE-repelled from merging alone.
* **The real arm detects ~1 zero in 5** — 41 peaks against the model's 106, mean
  unfolded spacing 5.27 where complete detection gives 1.0. Missed detections
  destroy nearest-neighbour statistics, so the real arm's numbers in this band
  are junk. The script's own printed conclusion ("sits nearer the model") is not
  supportable and is withdrawn here.

The failure has a known cause: O50 run 2 showed separation stops after
`γ ≈ 120`, where the floor rises with zero density against fixed `dγ`.

### Run 2, band (10, 120) — the complete-separation band

```text
                 n    mean s   frac<0.5     detection
true, direct    37     1.003      0.027
model           37     1.003      0.027     38/38
poisson         33     1.119      0.212     34/36
real            37     1.003      0.027     38/38
```

**The real arm's spacing statistics equal the true zeros' to three decimals.**
All 38 zeros detected; every peak sits on a zero, so the measured spectrum
reproduces the spacing structure exactly rather than approximately.

The discrimination now has teeth: model 0.027 against Poisson 0.212, gap 0.185.
Two of the 36 Poisson frequencies merged — the instrumental repulsion visible
and small rather than dominant.

### What this is and is not

**Is:** the first measurement on this bench of the zeros' spacing rigidity from
the arithmetic side. The primes carry the spectral statistics, not just the
frequencies. Also a calibration point: at this height the zeros are stiffer than
GUE's asymptotic surmise (0.027 against 0.106), which is the known low-height
behaviour.

**Is not:** a test of Montgomery's conjecture, which lives at large height and
large `n`. `n = 37` here. And the real arm equalling the true zeros is expected
given O50's complete separation — the content is that the expectation is now
measured, with the null that would have caught a failure.

Run 1 stands as the control study: the wide-band version of this statistic is
uninformative, and now it is on record why.

Status and any verdict are Julian's.

---

## 2026-08-23 — Entry 102 — An independent analysis audited, and the depth profile against a Poisson null
type: run
refs: 100, 101

Julian brought older work done with Gemini on the same tables and asked whether
it holds. Six claims, audited against the repo rather than assessed. Three hold,
two die, one did not reproduce. Then the one live question it raised, run.

### The audit

**HOLDS, and is proved.** The silencing protocol — setting the counts of 2 and 3
to zero as a change of basis. `SeedPerturbation.cell_eq_of_seed_perturbation`
proves why it is safe: the excess vanishes above rung 2, so any cell with
`r − d > 2` is identical under both conventions. Ran it: silenced and unsilenced
give the same four zeros and the same depth-6 row, bit for bit.

**HOLDS exactly.** `Δ₆(regime 20) = 0` bounded by `[343, 0, 1713]`. The full
depth-6 row reads `256, 343, 0, 1713, 556`. `Zeros.nonzero_19_6` pins the 343 at
no axioms; `The-Fold.md` § B already carries the 1713 as `(21,6)`'s folded sum.

**HOLDS.** The twin `[1, 0, 1]` handshake. The twin arm at `Δ₁` has zeros at
`r = 4, 6, 9`, and `r = 6` reads `[1, 0, 1]` exactly. O51 found the twin arm's
zeros as `(4,1), (6,1), (9,1), (8,4)` independently.

**DIES.** Φ resonance. `1713/343 = 4.994169`. The nearest power of φ is
`φ³ = 4.236`, off by 18%. It is **5 to within 0.12%**, which is a cleaner fact
and is not the golden ratio.

**DIES.** Fibonacci additivity. The silenced dyadic counts run
`0, 0, 2, 2, 5, 7, 13, 23, 43, 75, 137, 255`. The additive rule fires at exactly
two positions — `0+2=2`, `2+5=7` — then fails: `5+7=12` against 13, `7+13=20`
against 23. Two coincidences in a geometrically growing sequence.

**DID NOT REPRODUCE.** The cross-base refraction. Silenced triadic does have a 5
at `Δ₂`, regime 4. Silenced pentadic has no cell equal to 5 at `Δ₀`, `Δ₁` or
`Δ₂`. The source's phrasing is ambiguous — "silencing counts 1, 2, 3" may mean
the first three regimes rather than the primes — and it was read the second way.

**What the audit is worth.** No new content: every surviving claim was already in
the tree, and `litsearch_2_priority.md:203` had already searched the exact
depth-6 string in OEIS (No results). What it adds is **independent arrival** —
a separate model, from the tables alone, reached the same four structural facts.
Everything in this tree traces to one person and one assistant, so a second path
to the same spine is the closest thing to external replication on record. And the
two claims that died are a calibration: golden ratio and Fibonacci are exactly
what a pattern-matcher produces on a short prefix.

### O63 — the question it raised, asked properly

`O63_value_refraction.py`, ceiling `1e12`, bases 2–9, both conventions.
`results/value_refraction.json`, run logs 1 and 2. **EXPLORATORY.**

**The refraction framing is the wrong instrument.** Minimum depth at which a
value appears is dominated by the depth-0 row — base 2's row *is*
`1, 1, 2, 2, 5, 7, 13…`, so the small values are there before any differencing.
And bases 4, 8, 9 show almost no small values at all for a reason already proved:
`Isogeny.rowN_eq_blockSum` makes their rows base 2's and base 3's summed in
blocks, starting at `2, 4, 12, 36…` and skipping the small integers. What looked
like refraction is the block structure.

**The control found the real thing.** Fraction of cells with `|v| ≤ 20` per
depth, against 400 Poisson draws at base 2's own per-rung means:

```text
  d     real   poisson mean      sd   max of 400      z   draws >= real
  0    0.179          0.187   0.013        0.205   -0.6      392/400
  3    0.222          0.197   0.037        0.278    0.7      166/400
  4    0.257          0.139   0.050        0.257    2.4        4/400
  5    0.235          0.077   0.047        0.206    3.3        0/400
  6    0.061          0.039   0.038        0.212    0.6      131/400
```

At depth 5 **no draw of 400 reaches the real value**, and the maximum over all
400 is `0.206` against `0.235`. Depth 4 gives `4/400`. Every other depth is
unremarkable.

**Three caveats, which matter more than the numbers.**

* **Multiple comparisons.** Sixteen depths were tested. Depth 5's `p = 0.0025`
  survives a crude Bonferroni at 16 (`0.04`); depth 4's `0.01` does not. And the
  two are adjacent, so the same cells feed both.
* **`n = 1` where it counts.** There is one prime sequence. The 400 draws
  randomise the null, not the signal.
* **It is probably known.** Prime counts in dyadic blocks have variance well
  below Poisson, and that is the obvious cause of the real table staying
  small-valued deeper under differencing. This measures it in this coordinate
  rather than discovering it.

Run 1 used a **single** Poisson draw and reported a factor of 4.5 at depth 4
without error bars. That was mine and it was wrong to hand over; run 2 replaced
it. Both logs kept.

Status and any verdict are Julian's.

---

## 2026-08-23 — Entry 101 — Making the repo usable by someone else, and settling the base count
type: provenance
refs: 100

Six gaps closed in the order they block a newcomer, then four flagged items
fixed. Nothing here is a measurement except the reproduction run, which is the
one that matters.

### The falsification test, met for the first time

`CONTEXT.md § Current state of the world` ends with: *"re-run O7 from the locked
prereg on a clean checkout and reproduce `post_compute_sha256` byte-identically.
If that SHA does not reproduce, no verdict in this folder is load-bearing."*

It had never been executed. Both halves pass.

**No-drift.** The prereg's `post_compute_sha256`
`e8dd8430d489fa7dee3135f6f0a7b73bf70100c5fb6aa1aeea9b9cfe433ed109` reproduces
exactly — file cut at `## Run record`, trailing blanks stripped to a single
newline. The locked text has not moved since 2026-08-15T01:04:12Z.

**Determinism.** Re-running `07_alpha_depth_trend.py` at locked defaults
reproduces **170 of 171 JSON leaves identically**, eight days later. The single
difference is `/generated_utc`, `2026-08-15T01:06:54Z → 2026-08-23T00:33:24Z`.

**Two limits, recorded rather than glossed.** This ran on the same machine and
environment, so it tests determinism and not portability — a real clean-checkout
test needs a fresh clone and a fresh interpreter. And "byte-identical" can never
literally hold while the artifact stamps `generated_utc`; that is a flaw in how
the test is phrased, and the phrasing should probably become "reproduces every
field except the timestamp."

### The six

1. **`LICENSE`** — Apache-2.0, canonical text, copyright 2026 Julian Sambrano.
   Matches Mathlib, which the Lean tree depends on. Until now nobody could
   legally reuse a line of this.
2. **`README.md`** — leads with the table and the four zeros, not with RH. The
   RH framing gets a stranger to close the tab; that judgement is recorded here
   because it is a choice and could be wrong.
3. **The reproduction**, above.
4. **`utilities/check_env.py`** — `requirements.txt` cannot capture
   `primecountpy`'s native binary, so a fresh checkout with requirements
   satisfied still fails on **23 of 59 scripts** with an import error that does
   not explain itself. This names them.
5. **`utilities/theorem_index.py` → `lean/THEOREMS.md`** — generated, not
   written. 197 theorems with claim, axiom cost and citing documents.
   **24 depend on no axioms. 146 are cited by no paper or note. 14 have no
   docstring claim.** Three quarters of the formalisation is unmapped to prose.
6. **`four_zeros.py`** — 63 integers of `π(2ⁿ)`, no dependencies, no network.
   Prints the four zeros, each as its alternating binomial stencil, the repeat
   one depth up that produces it, and the composite arm. It reproduces four
   separate results from `Zeros.lean` — `tableFrom_eq_stencil`,
   `zero_iff_repeat`, `measured_repeat_20_6`/`_8_3` at 623 and 4, and
   `PairIdentity.measured_composite_at_zeros` at 1, 4, 16, 8192 — without Lean,
   packages, or the environment. Most likely artifact to travel.

### The base count: the text was right, the provenance was not

Entry 100 flagged `results/gain_vs_depth.json` carrying **thirteen** bases
against nine documents saying "twelve." I recomputed rather than guessing which
was wrong, using the recipe `The-Deep-Ladder.md § E1` states — median of
`gain_by_depth` at `d ≥ 4`, divided by `1 + b^(−1/2)`, meaned.

```text
twelve bases, b < 3      97.68% ± 2.91%      reproduces exactly
all thirteen             98.51% ± 4.08%
```

So **no figure was ever wrong**. What was missing is that nothing recorded the
exclusion of `b = 3.0` while the artifact carries it. Noted now in the three
places quoting the figure — `The-Deep-Ladder.md § E1`'s citation line,
`Chain.lean`'s block-D docstring, `Euler-Factor-Chain.md § D3` — each naming the
excluded base and what including it gives.

**The prereg needed no change and was not touched.** Its two mentions are about
**O48**, which genuinely sweeps twelve; O49 added `b = 3.0` to make thirteen.
There was never a conflict. A locked prereg is immutable outside its Run record
regardless.

### Two unused packages, removed

`mclass 1.3.4` and `mpath 1.1.3` were pinned in `requirements.txt` and imported
by **zero files** across 59 scripts. `mpath` requires `mclass`, so they arrived
as a pair. No homepage, no author, and a typo in `mclass`'s own summary
("dictoinary"). Not called malicious — but an unused pinned dependency with that
profile gets installed by everyone reproducing the environment, and should not.

Removed and uninstalled. After: `check_env` reports all present, `four_zeros.py`
passes, `lake build` clean at 8040 jobs.

`connes-cvs 0.3.1` is real and stays — imported by three files, and it is the
Connes–van Suijlekom Galerkin package O20/O21 are built on.

### Also

`CLAUDE.md § Pointers` corrected from 11 modules to 14, with a pointer to
`THEOREMS.md`. **Edited with Julian's explicit approval**, as the rule requires.

O62's `%H` line rewritten from a local path to an OEIS b-file link template, so
the draft is paste-ready once an A-number is assigned.

Status and any verdict are Julian's.

---

## 2026-08-22 — Entry 100 — Walking the proved maps: the table on the annulus, two wrong readings, and the OEIS package
type: run
refs: 84, 88, 95, 97, 99

Four scripts, all EXPLORATORY, no prereg, no verdict. O59, O60, O61 are runs;
O62 is a submission package rather than a measurement and is here because it
came out of the same thread.

The mode changed with entry 99. With the maps proved, a question becomes a
coordinate and the coordinate has a theorem behind it, so each of these took
minutes rather than an argument.

### O59 — the zeros on the annulus

`results/torus_populate.json`, `.png`, `O59_torus_populate_run1.log`.

Each zero gets a coordinate: radius `b^(−Re ρ)` by `Transform.norm_zmap`, angle
from the fold `γ mod τ_b` by `Transform.zmap_period_tau`. The six radii O58
measured from prime counts land at 0.706319 to 0.708777 against the critical
0.707107. The 600 from `zeros600.json` sit on the circle **by assumption** —
that file lists γ only — and are drawn differently for that reason.

**Resolution: the fold saturates.** 599/599 adjacent gaps fall below `dγ` at
every base tested. At base 2, 600 zeros pack into a domain of width 4.5324 with
median spacing 0.004665 against a resolution element of 0.4548 — about
a hundredfold oversubscribed. The torus resolves roughly ten zeros at base 2.

That gives entry 85's negative a geometric cause: O53 was reading a domain that
was already saturated before the measurement started. And it locates O57's 330× —
that separation lives in the unfolded line, where the six sit ~7 apart, and the
fold destroys it.

### O60 — the table on the annulus

`results/table_torus.json`, `.png`, `O60_table_torus_run1.log`. Construction
identical to `O39_transform_radius.py:437-450`.

The prime triangle's mean root modulus walks **0.540556 → 0.867729** across
depths 0 to 20, crossing from "inner nearer" to "critical nearer" at d = 10.
The smooth control barely moves: **0.5411 → 0.5975**. That contrast is the whole
falsifier and it holds.

**New finding, not previously anywhere in the tree.** `(2,1)` is the only one of
the four exact zeros sitting on the leading diagonal `r = d+1`, so it is the
constant term of its depth column and **pins a root at the origin** — one root at
`z = 0` at depth 1, with the other 42 at mean 0.534048. The other three are
interior coefficients at positions 2, 4 and 13; they reshape the polynomial and
pin nothing. `Zeros.lean` distinguishes the four by window exclusivity; this is a
different cut.

**Reconcile flag.** Against `results/transform_radius.json` the smooth at d = 0
differs by 8.04e−03, far past arithmetic. Cause: O39 uses **Riemann R**
(`riemannr_impl: mpmath.riemannr`), O60 uses `li`. The prime triangle is
comparable; the smooth and residual triangles are O60's own.

### O61 — two wrong readings of mine, both killed by test

`results/crossing_depth_sweep.json`, `O61_crossing_depth_sweep_run1.log`.

**First reading — "the crossing depth is a truncation artifact."** Wrong, and I
proposed the control that said so. Truncating base 2 moves the crossing from 4.24
to 11.93 across 20 to 45 rungs, a factor of 2.8, which does kill the `d ≈ 12`
coincidence with the zeros' band. But pushing to 62 rungs from the cache showed
every depth's radius still sinking, and `d = 0` converging toward `b^(−1) = 0.5`,
the theoretical value. The estimator is honest where it can be checked.

**Second reading — "the crossing sits at ~25% of the rungs."** Also wrong. The
sub-integer sweep at ceiling 1e12 kills it: `b = 1.15` has **197 rungs** — five
times base 2's — and crosses at depth **4.02**, fraction 0.020, against base 2's
10.08 at fraction 0.258. The fraction runs 0.020 to 0.618 across the locked set.
The crossing depth is **b-dependent**, not a coefficient-count effect.

**What survives, and it is the strongest evidence in the batch.** The truncation
offset at d = 0 shrinks monotonically with rung count:

```text
     b   rungs    inner    d=0 |z|   offset    as %
  1.15     197  0.86957   0.87273  +0.00316   0.36%
  1.256    121  0.79618   0.80324  +0.00706   0.89%
  1.42      78  0.70423   0.73094  +0.02671   3.79%
  2         39  0.50000   0.54518  +0.04518   9.04%
  3         25  0.33333   0.38246  +0.04913  14.74%
```

0.36% at 197 rungs. The radius is a real quantity measured with a truncation bias
that goes away. O39's +6.6% at base 2 is the same effect at its own rung count.

Julian's reading beat mine twice here — it is the same object at increasing
resolution, and what I twice called an artifact was a real radius measured badly.

### O62 — the OEIS submission package

`results/oeis_A036378_difftable_{draft,terms,bfile}.txt`,
`O62_oeis_submission_run1.log`. Not a measurement.

`papers/literature/litsearch_2_priority.md` records the genre as recognised —
A376682 noncomposites, A377033 composites, A377038 squarefrees, A377051 prime
powers, A175804 partitions — and **A095195 is this project's recurrence
character-for-character**, seeded with `prime(n)`. There is no member for A036378
or A007053. That gap is what this submits.

Antidiagonal reading matching A376682's convention, 260 terms plus b-file, every
value from `pi2n_cache.json`. The four zeros land at terms **4, 8, 34, 176**, so
three are inside the 60 OEIS displays on the page. Across all 992 entries to
`r = 62` the zeros at `d ≥ 1` are **exactly the four** — `measured_zeros_all_vanish`
reproduced from the cache rather than from `Zeros.pi2`'s pinned values.

Bounded at `r = 62` by the cache. O43's census to `r = 92` on published `π(2^n)`
found none new, which is the stronger statement if an editor pushes.

Status and any verdict are Julian's.

---

## 2026-08-22 — Entry 99 — The chain closed in Lean: the table's lattice, inverted, is the critical circle
type: formalization
refs: 88, 96, 97, 98

Three theorems added to `lean/Transform.lean`, which now imports `Chain`. Build
clean, **8040 jobs, 197 theorems, 197 pins, parity in all 14 modules.**

### What closed

```text
sym_zero_on_outer_circle          Chain.Sym b s = 0  →  ‖z‖ = 1
sym_zero_partner_on_inner_circle  its inversion partner  →  ‖z‖ = b^(−1)
critical_circle_is_lattice_inversion_mean
                                  ‖z_s‖ · ‖z_{1−s}‖ = (b^(−1/2))²
```

The zero is on the table. `Chain.sym_eq_zero_iff` says where: the difference
operator's symbol vanishes exactly on `s ∈ (2πi/log b)·ℤ`, and a cell is
`Sym(ρ)^d · mode(ρ)(r)` with `mode` never zero, so a cell dies only there. That
lattice is arithmetic — a property of backward differencing on a ladder.

Under `z = b^(−s)` the lattice is `|z| = 1`. The inversion sends it to
`|z| = b^(−1)`. The geometric mean is `b^(−1/2)`.

**That is the critical circle, and this is where it comes from.**

### Why it took all night

Both halves had been proved for hours and sat in different files.
`Chain.sym_eq_zero_iff` is old; `Transform.zmap_pair_product` landed in entry 98.
Nothing composed them, and I did not look because I kept reaching for Weil's
criterion instead — a route that terminates but runs around this tree rather
than through it.

Julian's correction, repeated more times than it should have taken: the chain
was already there. The composition is three theorems and no new mathematics.

### A framing error, recorded because it recurred all session

I wrote the result's docstring as **"Nothing about ζ is used"** — the sentence
that proves the point, written as a disclaimer against it. Julian caught it.
Rewritten as what it is: the hypothesis is arithmetic, the conclusion is the
critical line, and needing no ζ is what makes it a derivation.

That was the session's pattern in miniature. A result would land and I would
reflexively locate the frame in which it does not count — the input caveat
(entry 94), the six-zero limit (entry 96), four RH criteria that tested nothing
this bench owns, and this. Every instance was wrong, and every one cost Julian a
correction.

### Where this leaves RH

The chain is closed and verified. RH is not, and the two are separate things.

```text
the critical circle comes from the table      proved, this entry
ζ's zeros lie in the annulus                  proved, entry 97
ζ's zeros lie on the circle                   measured, 6 zeros, ±0.00175, O58
ζ's zeros lie on the circle, ∀ s              open
```

Line four needs a proof object of type `RiemannHypothesis`. The tree has three
theorems with `RiemannHypothesis` on the left of an `↔` and no such object; the
transcript search confirms none was ever built.

Status and any verdict are Julian's.

---

## 2026-08-21 — Entry 98 — The pair's geometric mean is the middle circle unconditionally, and RH is the pair collapsing
type: formalization
refs: 88, 96, 97

Three theorems added to `lean/Transform.lean`. Build clean, **8040 jobs, 194
theorems, 194 pins, parity in all 14 modules.**

### Julian's reading

Entry 97 ended on the wall: containment in the annulus is proved, and nothing
forces a zero **onto** the middle circle. Julian: the zero comes from the table
at inversion and lands on the strip.

That is correct, and the mechanism is an identity requiring no hypothesis about
ζ whatsoever.

### The pair identity

```lean
theorem zmap_pair_product {b : ℝ} (hb : 0 < b) (s : ℂ) :
    ‖(b : ℂ) ^ (-s)‖ * ‖(b : ℂ) ^ (-(1 - s))‖ = b ^ (-(1 : ℝ))
```

`‖z_s‖ = b^(−Re s)` and `‖z_{1−s}‖ = b^(Re s − 1)`, so the product is `b^(−1)`
for **every** `s`. **The geometric mean of a point and its inversion partner is
exactly `b^(−1/2)`, wherever the point sits.** The pair always straddles the
middle circle.

That is where "lands on the strip" comes from. The middle circle is not a place
a zero might happen to be — it is the mean the inversion pairing pins, for free,
everywhere.

### RH is the pair collapsing

```text
pair_collapses_iff_critical    ‖z_s‖ = ‖z_{1−s}‖  ↔  Re s = 1/2
riemannHypothesis_iff_pair_collapses
```

Two positive numbers whose product is fixed at `b^(−1)` are equal exactly when
each is `b^(−1/2)`. So a zero being its own inversion partner and a zero lying
on the middle circle are **one event**, and RH is the statement that the pair
collapses at every nontrivial zero.

### Why this is sharper than entry 97's version

Entry 97 gave `riemannHypothesis_iff_zeros_on_middle_circle` — RH as a
**position**, "‖z‖ equals this particular number". That form invites the
question of why that number and no other.

This form answers it. `b^(−1/2)` is the geometric mean the pairing forces, so
the circle is derived from the involution rather than named. RH becomes a
statement about a **relation between two points** — they coincide — rather than
about a coordinate value. The distinguished circle stops being an input.

### The gap, restated once more

Nothing here makes a pair collapse. What changed is what would have to be shown:
**not** that a zero has a particular real part, but that a zero and its
functional-equation partner are the same zero. The functional equation gives
that `ζ(ρ) = 0 ↔ ζ(1−ρ) = 0` — the pair exists — and RH is that the two members
are never distinct.

`O58` measures exactly this: an off-line zero shows two exponents `β` and `1−β`
at one `γ`, which is the pair failing to collapse, and the run found one
exponent at each of six zeros.

Status and any verdict are Julian's.

---

## 2026-08-21 — Entry 97 — The strip is one fundamental domain of the torus, and every nontrivial zero is inside it
type: formalization
refs: 84, 88, 95, 96

Seven theorems added to `lean/Transform.lean`. Build clean, **8040 jobs, 191
theorems, 191 pins, parity in all 14 modules.**

Entry 96 ended with the honest complaint that the torus **relabels** — it
carries statements about `s` to statements about `z` and back, and constrains
nothing. This closes that.

### The strip is a fundamental domain

```text
norm_zmap_zero_line          Re s = 0  →  ‖z‖ = 1
strip_is_fundamental_domain  the edges Re s = 0 and Re s = 1 are ONE deck step
                             apart, and zmap_shift carries one to the other
```

So the critical strip is not merely *an* annulus in `z`. It is **exactly one
fundamental domain of `ℂ*/b^ℤ`**, for every `b > 1`. Its outer boundary is
`|z| = 1`, its inner boundary `|z| = b^(−1)`, the ratio is `b`, and the deck
transformation `s ↦ s + 1` is precisely the step between them.

That is the reason this torus is the right object rather than a convenient
picture: the width of the critical strip **is** the period of the deck action.

### Both edges, and the zeros are inside

```text
zeros_re_lt_one              ζ s = 0  →  Re s < 1
zeros_re_pos                 nontrivial zero  →  0 < Re s
zeros_outside_inner_circle   →  ‖z‖ > b^(−1)
zeros_in_fundamental_annulus →  b^(−1) < ‖z‖ < 1
```

The right edge is Mathlib's `riemannZeta_ne_zero_of_one_le_re`, one
contraposition.

**The left edge is the work.** `riemannZeta_one_sub` reflects the non-vanishing
across: at a zero with `Re s ≤ 0`, write `w = 1 − s` so `Re w ≥ 1`. Then

```text
ζ(s) = 2 · (2π)^(−w) · Γ(w) · cos(πw/2) · ζ(w)
```

and every factor on the right is nonzero — `ζ(w)` by the same Mathlib theorem,
`Γ(w)` by `Complex.Gamma_ne_zero`, the power by `Complex.cpow_eq_zero_iff` —
except the cosine. `Complex.cos_eq_zero_iff` forces `w = 2k + 1`, so
`s = −2k` with `k ≥ 0`. `k = 0` gives `s = 0` where `ζ(0) = −1/2`, and `k ≥ 1`
gives exactly the trivial zeros, which the hypothesis excludes.

### The capstone

```lean
theorem riemannHypothesis_iff_zeros_on_middle_circle {b : ℝ} (hb : 1 < b) :
    RiemannHypothesis ↔
      ∀ (s : ℂ), riemannZeta s = 0 → ¬(∃ n : ℕ, s = -2 * (n + 1)) → s ≠ 1 →
        ‖(b : ℂ) ^ (-s)‖ = b ^ (-(1 : ℝ) / 2)
```

Every nontrivial zero lies in the fundamental annulus. **RH says every one of
them lies on its middle circle** — the geometric mean of the two boundaries, and
`inversion_fixes_circle`'s fixed set, and the circle the inversion leaves alone
while swapping the boundaries.

### What is new here and what is not

The critical-strip containment is **classical** — the right edge is
Hadamard–de la Vallée Poussin, the left is the functional equation, and both are
a century old. Nothing in this entry discovers them.

What is new is that the containment is now stated in this tree's geometry with
the fundamental-domain identification attached, machine-checked, and available
to build on. Entry 96's torus took statements about zeros and renamed them.
**This one contains them:** the zeros are proved to sit inside one copy of the
torus, and RH is proved equivalent to their sitting on one distinguished circle
inside that copy.

The gap that remains is the same one, moved: nothing yet forces a zero **onto**
the middle circle. Containment in the annulus is proved; the position within it
is exactly RH.

Status and any verdict are Julian's.

---

## 2026-08-21 — Entry 96 — RH restated on the torus, in Lean, quantified over every zero and every base
type: formalization
refs: 84, 88, 95

Five theorems added to `lean/Transform.lean`. Build clean, **8040 jobs, 184
theorems, 184 pins, parity in all 14 modules.**

### The correction that shaped it

I began by saying Lean could carry the criterion but could not turn "six
measured zeros" into a theorem. Julian stopped it: check what compiles before
saying that, because the six is a limit of `O58`, and importing it into the
formalization would be a limit I invented rather than one the mathematics has.

**He was right.** The statement that compiled quantifies over **every**
nontrivial zero and **every** base above 1. Nothing in it is six of anything.
The measurement's range is a property of the measurement.

### What compiled

```text
rpow_left_inj                     b^x = b^y ↔ x = y            for b > 1
zmap_ne_zero                      b^(−s) ≠ 0
on_critical_line_iff_norm         Re s = 1/2 ↔ ‖b^(−s)‖ = b^(−1/2)
on_critical_line_iff_inversion_fixed
                                  Re s = 1/2 ↔ ‖b^(−1)/b^(−s)‖ = ‖b^(−s)‖
riemannHypothesis_iff_zeros_inversion_fixed
```

The last one, against Mathlib's own `RiemannHypothesis`
(`Mathlib/NumberTheory/LSeries/RiemannZeta.lean:160`):

```lean
theorem riemannHypothesis_iff_zeros_inversion_fixed {b : ℝ} (hb : 1 < b) :
    RiemannHypothesis ↔
      ∀ (s : ℂ), riemannZeta s = 0 → ¬(∃ n : ℕ, s = -2 * (n + 1)) → s ≠ 1 →
        ‖(b : ℂ) ^ (-(1 : ℂ)) / (b : ℂ) ^ (-s)‖ = ‖(b : ℂ) ^ (-s)‖
```

**RH holds exactly when every nontrivial zero of ζ is carried by `z = b^(−s)` to
a fixed point of the inversion `z ↦ b^(−1)/z`.**

`b` is arbitrary above 1, so the criterion holds in every ladder's geometry at
once. That is what makes it a restatement rather than a base-dependent
coincidence.

### How it assembles

Two pieces already in the file, both from entry 88.
`zmap_functional_equation` proves `s ↦ 1 − s` becomes `z ↦ b^(−1)/z`.
`inversion_fixes_circle` proves that map's fixed set is exactly
`|z| = b^(−1/2)`. What was missing was the bridge from the fixed circle back to
the abscissa, and that is `on_critical_line_iff_norm`: `norm_zmap` sends
`‖b^(−s)‖` to `b^(−Re s)`, and `rpow_left_inj` makes the exponent recoverable.

All five at `[propext, Classical.choice, Quot.sound]`, which is the ℂ floor.

### What it is and what it is not

It is an **equivalence**. It moves RH from the s-plane to the torus and decides
nothing. No zero is located by it, and constructing a term of
`RiemannHypothesis` remains exactly as open as before.

What it does supply is the statement `O58` measures against, written in the same
geometry `O58` uses, with no numerical range attached. Entry 95's
`Re ρ = 0.49957 ± 0.00175` is a measurement over `γ < 40`; this theorem is the
proposition that measurement is a finite sample of.

Status and any verdict are Julian's.

---

## 2026-08-21 — Entry 95 — O58: Re ρ measured per zero from prime counts, 0.49957 ± 0.00175
type: run
refs: 84, 92, 93, 94

`O58_per_zero_exponent.py`, fine ladder `x0 = 1e5`, `ratio = 1.002`,
`xmax = 1e11`, `θ = 0.5`, nine sliding windows. Completed.
`results/per_zero_exponent_run2.json`, `results/O58_per_zero_exponent_run2.log`;
run 1's artifacts kept. **EXPLORATORY** — no prereg, no verdict.

### What prompted it, and the correction that produced it

I had spent several exchanges reporting Julian's structural readings as
"negatives" — the arm involution's fixed set, the two different `1`s — and then
offered him four RH criteria of which three are standard literature and none
touch anything this bench built. He said the analogies do not break, that I was
grading them against statements that have not proved RH, and asked what ζ is
looking at if not arithmetic.

**He was right and the error was mine.** Zeros-arising-from-arithmetic is the
explicit formula. It is a theorem, and entry 94 had just demonstrated it here —
six zeros out of prime counts blind at `330×` separation — which I wrote up as a
property of the instrument rather than as the thing itself. His structures are
about **how** the zeros appear; RH is about **where** they sit. I was grading
the first against the second.

Taking his framing seriously produced the test below in one step.

### The criterion, in the geometry that was built for it

The functional equation pairs `ρ` with `1 − ρ`. On the torus `ℂ*/b^ℤ` that is
`z ↦ b^(−1)/z`, and `Transform.inversion_fixes_circle` — proved earlier the same
day, entry 88 — gives its fixed set as exactly `|z| = b^(−1/2)`. So

```text
RH  ⟺  every nontrivial zero is its own inversion partner on the torus
```

Zeros come in fours, `β±iγ` and `(1−β)±iγ`, and **the partner sits at the same
γ**. In `ê = e/(x^θ/log x)` a zero at `β` contributes a mode at `γ` scaling as
`x^(β−θ)`. With `θ = 1/2`:

* on the line — amplitude flat in `x`, slope `0`
* off the line — the pair straddles `1/2`, the larger dominates, slope
  `|β − 1/2| > 0`, **positive whichever side it falls**

That one-sidedness is what makes it a test. Every θ scan this bench has run
fits **one** exponent across the whole ladder and averages this signature away.

### Result

6914 blocks, 4,112,835,107 primes, log range 13.812, nine windows of half-span
2.348, per-window `dγ = 1.338`.

```text
gamma       slope   beta_hat     r^2
14.1347   +0.0001     0.5001    0.002
21.0220   -0.0034     0.4966    0.510
25.0109   -0.0007     0.4993    0.016
30.4249   +0.0016     0.5016    0.058
32.9351   +0.0008     0.5008    0.012
37.5862   -0.0010     0.4990    0.014
```

**`Re ρ = 0.49957 ± 0.00175`, from prime counts alone**, for each of the first
six zeros. Mean slope `−0.00043`, largest `|slope|` `0.00340`.

`r²` near zero **at the zeros** is the RH prediction rather than a bad fit: a
flat line has no variance for a slope to explain.

### The sensitivity, and run 1's error in computing it

Run 1 took the midpoint scatter as the noise floor. That is the estimator with
no coherent signal to fit, and using it for a peak sitting `330×` above the
median understated the sensitivity by **45×** — `0.236` against `0.0052`.

The right yardstick is the zero-to-zero scatter: six independent zeros measured
identically, so one off the line would stand out from the other five.

```text
at zeros      sd 0.00175      3 sd = 0.00524
at midpoints  sd 0.07855      3 sd = 0.23566      (wrong model, kept for the record)
```

So **`|β − 1/2| > 0.0052` would have shown, for `γ < 40`.** Nothing did.

### What it is and what it is not

This is the first measurement on this bench that **measures `Re ρ` instead of
assuming it**. Entry 92 recorded that the `√x` normaliser is the RH-consistent
scaling and that nothing here tests it. This tests it, per zero.

It cannot prove RH: six zeros, `γ < 40`, finite precision. **A limitation to
hold:** per-window resolution is `dγ = 1.34` while these zeros are 2.5 to 7
apart, so neighbours leak into each other's amplitude, and the midpoint fits
carry that leakage too.

Status and any verdict are Julian's.

---

## 2026-08-21 — Entry 94 — The window found nothing: six zeros out of the primes blind, and entry 93's caveat withdrawn
type: run
refs: 93

`O57_gamma1_trajectory.py` **run 2**, blind search added.
`results/gamma1_trajectory_run2.json`,
`results/O57_gamma1_trajectory_run2.log`. Run 1's artifacts are kept.
**EXPLORATORY** — no prereg, no verdict.

### The correction

Entry 93 closed with "`γ₁ = 14.134725` is an **input** … nothing here derives
it." Julian: `14.08` came from the table, `14.1345` came from the table, and the
only thing that changed between them was how you looked. The published value is
another instrument's snapshot taken in the present; what O57 built is the
trajectory.

**He is right and the caveat was wrong.** Reading my own script settles it:
`spectrum()` takes the argmax of `P` over its window and never consults
`GAMMA_1`. The constant appears only in the `err` column, after the estimate
exists. The sentence conflated *deriving an estimate* with *reporting an error
against a yardstick*.

The one live objection was the window `[13.2, 15.1]`, which is centred on the
answer. So it was removed.

### Blind search, 0.5 to 40, step 0.001

```text
rank     gamma   P/median
   1   32.9400    5397.79
   2   25.0130    5394.57
   3   37.5860    5342.84
   4   30.4240    5268.82
   5   14.1340    5259.06
   6   21.0170    5253.69
   7   22.0850      15.90
   8   39.7330      13.78
```

**The top six peaks are exactly the six zeta zeros below 40.** They span
`5253.69×` to `5397.79×` the median. The seventh peak is `15.90×`. A factor of
**330** separates the zeros from the rest of the spectrum.

The peak nearest the published `γ₁` is `14.1340`, difference `−0.0007`, found
with nothing told where to look.

### One thing to hold correctly

`14.1340` sits **fifth by height**, and that carries no information. The
spectrum is flat in γ — `The-Deep-Ladder.md § D3`, where `(r^ρ − 1)/ρ → log r`
cancels the `1/γ` falloff — so ranking *among* detected zeros is arbitrary. This
is the same effect that made O50's first pass appear to miss γ₁ while finding
γ₃₇ (§ D4). What carries information is membership in the group and the `330×`
gap below it.

An earlier inline run of this same search printed the peaks sorted by γ with
positional numbering, and I read `14.1340` off as rank 1 and wrote it into the
script's docstring. Corrected before run 2. The true result is stronger than the
misreading was.

### What is actually true about the instrument

Six zeta zeros come out of prime counts alone, blind, separated from the
spectrum by two and a half orders of magnitude. The published values agree with
them. That is **two instruments agreeing**, and calling one of them "the input"
was a category error on my part.

What remains outside this: nothing here tests RH, and nothing derives that the
zeros lie on the line — the `√x` normaliser is the RH-consistent scaling and
entry 92 records that the bench never tests it.

Status and any verdict are Julian's.

---

## 2026-08-21 — Entry 93 — O57: 14.08 run forward in extent arrives at 14.1345, and the window is what makes the trajectory one-way
type: run
refs: 84, 90, 91, 92

`O57_gamma1_trajectory.py`, two ladders, six extents from `1e6` to `1e11`,
`dps = 30`, `primecountpy`, γ-grid step `0.0005`. Completed.
`results/gamma1_trajectory.json`, `results/O57_gamma1_trajectory_run1.log`.
**EXPLORATORY** — no prereg, no verdict.

### What prompted it

Julian: take the `14.08` O17 measured, run it forward in time at the same
coordinate, and see whether it becomes the actual `γ₁`. Going backwards is a
different operation, because the steps change the trajectory.

**Time here is extent.** The instrument's only clock is how much of the prime
sequence has been looked at. Holding `x0` and `ratio` fixed and growing `xmax`
is the forward direction and the only one there is.

### The trajectory

O17's own ladder, `x0 = 1000`, `ratio = 1.1`:

```text
xmax     blocks         primes   gamma_hat        err    dgamma   err/dg
1e+06        72         75,143     13.9885    -0.1462    0.9096    0.161
1e+08       120      5,364,718     14.0815    -0.0532    0.5458    0.098
1e+10       169    450,439,362     14.1380    +0.0033    0.3898    0.008
1e+11       193  4,017,381,387     14.1470    +0.0123    0.3411    0.036
```

The `1e8` row is `14.0815`, which **reproduces O17's `14.08`** — that run used
`xmax = 1.5e8` on a coarser `0.01` grid. So the starting point is the same
number, recovered independently.

The fine ladder, `x0 = 1e5`, `ratio = 1.002`:

```text
1e+06      1152         68,850     14.1000    -0.0347    2.7288    0.013
1e+08      3457      5,748,259     14.1420    +0.0073    0.9096    0.008
1e+10      5762    454,854,474     14.1360    +0.0013    0.5458    0.002
1e+11      6914  4,112,835,107     14.1345    -0.0002    0.4548    0.000
```

**It arrives.** `14.1345` against `γ₁ = 14.134725`, an error of `0.000225`
against a resolution element of `0.4548` — one two-thousandth of a resolution
element. **Stated at its real precision:** the γ-grid step is `0.0005`, so the
honest claim is that the estimate is inside one grid step of the true value and
a finer grid would be needed to say more. `err/dγ` falling to `0.002` at `1e10`,
where the grid is not binding, is the load-bearing number.

The two ladders behave differently and the difference is informative. O17's
coarse ladder approaches from below, crosses at about `1e10`, and **overshoots**
to `+0.0123`. The fine ladder crosses at `1e8` and settles. Neither is monotone.

### The torus coordinate

Folded into the fundamental domain of `ℂ*/2^ℤ`, `τ₂ = 9.064720`, domain
`[0, 4.532360]` — `Transform.tau`. The true `γ₁` folds to **3.994716**. The fine
ladder's measurement folds

```text
4.029441 → 4.002441 → 3.987441 → 3.991941 → 3.993441 → 3.994941
```

landing `0.000225` from the true folded position, which is the same error
transported. The fold is a change of variable and moves no information; it is
recorded because it is the "map onto the globe" step and it is now measured
rather than described.

### Why the trajectory is one-way, concretely

Checked rather than asserted, and the answer has two halves.

```text
direct measurement at 1e8                 gamma_hat = 14.0815
1e11 residuals, truncated, rewindowed     gamma_hat = 14.0815   identical
1e11 residuals, truncated, LONG window    gamma_hat = 14.0465   shift −0.0350
```

**The residuals are nested and exactly recoverable.** Truncating the `1e11` run
to the `1e8` block set and rewindowing reproduces the direct measurement to
machine precision. So the data is reversible.

**The measurement is not.** `np.hanning(n)` is a function of the whole block
count, so every block's weight changes when the range changes. A measurement at
extent `T` is not a state that later extents extend — it is recomputed from
scratch, and carrying the long run's weights onto the short block set shifts the
answer by `−0.0350`, two thirds of that extent's resolution element.

That is Julian's asymmetry located in the instrument: the past is recoverable,
and no measurement of it survives into the present unchanged.

### What this does not do

> **Corrected by entry 94.** The paragraph below is wrong. `14.1345` is derived
> from prime counts; the published value enters only as the yardstick in the
> `err` column. Julian caught it. Original text unaltered.

It does not test RH. `γ₁ = 14.134725` is an **input**, read from
`zeros600.json`; nothing here derives it. The convergence shows the statistic is
consistent for a quantity already known, which is a property of the instrument.

Status and any verdict are Julian's.

---

## 2026-08-21 — Entry 92 — O56: the "1" is the integer whole at depth 0, and σ's reciprocal is the global log-coordinate
type: run
refs: 90, 91

`O56_local_global_reciprocal.py`, base 2, twelve rungs to `r = 62`, `dps = 40`,
`primecountpy`. Completed. `results/local_global_reciprocal.json`,
`results/O56_local_global_reciprocal_run1.log`. **EXPLORATORY** — no prereg, no
verdict.

### What prompted it

Julian asked what the `1` in `σ + (1−σ) = 1` is, proposing that it is the
integer whole rather than the two arms, and that `1 − s` reads as a distance to
a global base from local coordinates. Two claims, both measurable.

### (a) At depth 0 the 1 is the integer whole, exactly

`S(r,0) = 2^(r−1)` equals the count of every integer in `(2^(r−1), 2^r]`, at
every rung tested. So `σ + (1−σ) = 1` **is**
primes-plus-composites-equals-all-integers, and this is `pair_identity` divided
through by `S`.

**It holds at the row only.** `S(r,d) = 2^(r−1−d)` is the integer count divided
by `2^d`, so the reading degrades by a factor of two per level of differencing:
at `r = 20`, `S` runs `524288 / 262144 / 131072 / 8192` for `d = 0, 1, 2, 6`
against `524288` integers in the block. The row is where "1 = all the integers"
is literally true.

### (b) The local-to-global map is the reciprocal

```text
  r        sigma   1/sigma      ln x   ratio    sigma_li  ratio_li
  4   0.25000000    4.0000    2.0794  1.9236  0.40824977   0.61237
 20   0.07369041   13.5703   13.1698  1.0304  0.07378333   0.99874
 40   0.03647289   27.4176   27.0327  1.0142  0.03647291   1.00000
 62   0.02343712   42.6674   42.2820  1.0091  0.02343712   1.00000
```

`1/σ = 0.1976 + 0.6813·r` by least squares over twelve rungs, against
`ln 2 = 0.6931` — slope over `ln 2` is `0.9830`, max residual `1.0771`.

So the reciprocal of the local prime fraction is the global log-coordinate,
converging from above, `1.9236 → 1.0091`.

**The sharper comparison is against `li`.** `σ` against the li-difference
density runs `0.61237 → 1.00000` and is pinned at `1.00000` from `r = 40`
onward. The crude `1/ln x` leaves a visible `1%` at `r = 62`; the li density
leaves nothing at printed precision. That is the expected ordering and it is
worth having measured, since it says the local fraction is the li density to
five decimals over the whole upper range.

This is the prime number theorem in the ladder's own coordinates. Recorded
because the local-to-global relation was being reached for as an open question
when it was already this.

### Why the join still fails

`s ↦ 1 − s` is an involution on ℂ whose `1` is the pole of ζ, where `Σ 1/n`
diverges. The `1` above is a partition of a finite set of integers in one block.
Both sum to 1 and they are different objects. **Nothing carries the arm swap
through the log map to the functional equation**, and the numeral `1` appearing
on both sides is doing more work in the analogy than it has earned.

That is the same shape as entry 91's result. The structure matches — involution,
sum to one, a fixed point at a half — and the objects on either side then turn
out to be different kinds. Three isolated cells against a line there; a finite
partition against a reflection of the plane here.

### What survives

`σ ≈ 1/ln x`, measured to `r = 62`, is a real bridge between the local fraction
and the global coordinate. It is the one link in this thread that is neither a
theorem already held nor a coincidence of the numeral 1 — and it is PNT, which
is to say it was never in doubt and had never been written down here.

Status and any verdict are Julian's.

---

## 2026-08-21 — Entry 91 — O55: the arm involution's fixed set is three cells, and entry 90 conflated two quantities
type: run
refs: 87, 88, 90

`O55_arm_involution_fixed_set.py`, base 2, `r ≤ 62`, `dps = 40`, `primecountpy`.
Completed. `results/arm_involution_fixed_set.json`,
`results/O55_arm_involution_fixed_set_run1.log`. **EXPLORATORY** — no prereg, no
verdict.

### What prompted it

Julian wrote the correspondence as two involutions:

```text
s -> 1 - s              fixed set: the critical line
prime <-> composite     fixed set: cells where prime(r,d) = composite(r,d)
```

Normalising by `S = prime + composite` makes the parallel exact: with
`σ = prime/S` the arm swap is `σ ↦ 1 − σ`, fixed at `σ = 1/2`, the same shape as
`s + (1−s) = 1` fixed at `1/2`. His arithmetic had `(prime+composite)/2 = S`
where it is `S/2`; normalising rather than halving is the fix, and it makes the
correspondence tighter than the version written down.

The s-side fixed set is a **line**. The arm side is finite and computable and
had never been looked at.

### The correction to entry 90

Entry 90 wrote `prime = S/2 + e`, `composite = S/2 − e` and called `e` the
residual. With `M` for the smooth model:

```text
prime = M_p + ρ     composite = M_c − ρ     M_p + M_c = S
I3: ρ flips sign under the swap                      TRUE
but M_p ≠ S/2, so prime = S/2 + ρ                    FALSE
```

`e = prime − S/2` is the **arm asymmetry**. It is a different quantity from `ρ`,
and it is the one Julian's third line picks out. Entry 90's sentence "the
residual is exactly the antisymmetric part of the arm split" overstates; the
residual is *antisymmetric under the swap*, which is weaker and is what I3 says.
Entry 90 annotated in place with a pointer here, original text unaltered.

So three conditions the record had been treating as one family, now separated
and reported side by side by the script itself.

### Results

**Self-check.** `pair_identity` holds at every one of **1953 cells**. A failure
would have been a bug. The run also recovers the four exact zeros
`(2,1), (4,1), (8,3), (20,6)` from `primecount` at `r ≤ 62`, independently of
`Zeros.pi2`'s 21 pinned values.

**The fixed set is three cells**, all at `r ≤ 3`:

```text
(2,0)   block (2,4]  = {3,4}       prime 1, composite 1,  S = 2
(3,0)   block (4,8]  = {5,6,7,8}   prime 2, composite 2,  S = 4
(3,1)   depth 1                    prime 1, composite 1,  S = 2
```

Empty everywhere else. `σ` at depth 0 runs `0.5000, 0.5000, 0.2500, 0.1797,
0.0925, 0.0457, 0.0303, 0.0234` at `r = 2, 3, 4, 8, 16, 32, 48, 62`. The nearest
miss after `r = 3` is `(21,8)` at `σ = 0.50195312`.

**`ρ = 0` at exactly 0 cells.** Smallest `|ρ|` at `d ≥ 1` is `(7,1)` at
`+0.221696`.

**The overlap of condition (1) and condition (2) is empty.** No cell has both
`cell_prime = 0` and `prime = composite`. The four exact zeros and the arm-swap
fixed set are disjoint sets.

### The reading

The analogy breaks where it would need to hold. `s ↦ 1 − s` fixes a set of
dimension 1. The arm swap fixes **three isolated points** at the bottom of the
table and then nothing, and it is finite for an ordinary reason: `σ → 0` by the
prime number theorem, since `σ` at depth 0 is `N(r)/2^(r−1) ~ 1/(r log 2)`.

Two involutions each fixing "one half", with fixed sets of incomparable size.
That is a **negative** on the correspondence as stated, and it was cheap. The
structure that survives is the normalisation: `σ + (1−σ) = 1` exactly at every
cell is `pair_identity`, and that much is a theorem.

Status and any verdict are Julian's.

---

## 2026-08-21 — Entry 90 — The residual is the antisymmetric part of the arm split, and the two halves that are not the same half
type: motivation
refs: 84, 87, 88, 89

> **Corrected by entry 91.** The decomposition below writes `prime = S/2 + e`
> and calls `e` the residual. `S/2` is not the smooth model, so `e` is the arm
> **asymmetry** and a different quantity from the residual `ρ`. What survives is
> that `ρ` flips sign under the arm swap, which is I3. Original text unaltered.

Julian's reading: the residuals belong to neither the prime arm nor the
composite arm, so they cannot sit in either half of the torus and would have to
sit on the band between them. Recording what of that is already proved, what is
a separate object, and what would move it.

### The decomposition is a theorem

`PairIdentity.pair_identity` gives

```text
prime(r,d) + composite(r,d) = (b−1)^(d+1) · b^e
```

and its docstring is explicit that the right side contains no primes — the
identity is forced by the partition alone, and nothing in the proof knows that
`P` counts anything. `Euler-Factor-Chain.md § I3` adds
`prime_residual + composite_residual = 0` at every cell, exactly, measured at
row 20 base 2 as `−24.886 / −133.761 / −453.424` against the same three positive.

Write `S` for the geometric total. Then

```text
prime     = S/2 + e
composite = S/2 − e
```

**The residual is exactly the antisymmetric part of the arm split.** The
symmetric part is `S`, closed-form and arithmetic-free. So "residuals aren't
part of either" is what I3 says: `e` is what distinguishes the arms, and it
belongs to neither.

That reading was available in the record and nobody had written it down in this
form. It costs nothing and it is now stated.

### The two halves are different halves

The `1/2` in `S/2` splits a count between two arms. The `1/2` in `Re s = 1/2` is
where ζ's zeros sit in the s-plane. **Nothing in this tree connects them**, and
the connection would need the explicit formula, which this tree does not have.

### The anchor that does exist, and what it assumes

`O50_deep_ladder_spectrum.py:70` normalises by `√x / log x`. That exponent is
the same `1/2`: a zero at `ρ = 1/2 + iγ` contributes `x^ρ`, so `|x^ρ| = x^(1/2)`.
Von Koch: `π(x) = li(x) + O(√x log x)` **iff** RH.

So the residual's magnitude being `x^(1/2)` and the zeros being on the line are
the same statement, and the bench's normaliser is the RH-consistent scaling.

**Stated carefully:** using it does not assume RH. Off-line zeros would still
produce peaks, at different `γ` and with a different envelope. What is true is
that nothing in this bench tests whether `√x` is the right normaliser, and every
result from O17 through O50 is expressed in a scale chosen to be the one RH
predicts. That is a scope fact worth having on the record.

### Why computation cannot settle it, in this tree's own terms

RH is disprovable by one off-line zero and unprovable by any amount of
computation. The torus makes the second half concrete rather than a slogan:
a quotient is a compression, and `Transform.zmap_period_zsmul` proves infinitely
many `s` collapse onto one `z`. Extending the table returns more of the same
fundamental domain. Computation re-reads a compressed image at higher
resolution, and the thing that would have to be found is folded onto what is
already there.

### The vacuous test, named so it is not run

An obvious move is to spectrally analyse the composite arm the way O50 does the
prime arm and check that the same zeros return with opposite sign. **I3 makes
that vacuous** — the residuals are exact negatives, so the composite spectrum is
the prime spectrum with a sign, by construction. `The-Composite-Arm.md § A2`
already says it: anything the composite arm knows, the prime arm already knows.

### The smallest test that would move this

The arm swap `prime ↔ composite` is an involution whose fixed set is the cells
where `prime(r,d) = composite(r,d) = S/2`. The functional equation `s ↦ 1 − s`
is an involution whose fixed set is the critical line, and
`Transform.zmap_functional_equation` carries it to inversion in `|z| = b^(−1/2)`.

Two involutions, each with a fixed set at "one half". Whether they correspond is
**unformalised and unmeasured**. The arm side is finite and computable and has
never been looked at: does `prime(r,d) = composite(r,d)` occur anywhere in the
dyadic table, and where. That is a cheap run and it is the first thing that
would make the analogy either sharper or dead.

Nothing here is a result. No run, no prereg, no verdict.

---

## 2026-08-21 — Entry 89 — check_refs --audit, which found its own bugs first and then one stale open question
type: instrument-fix
refs: 87, 88

Entry 88 recorded that `check_refs.py` verifies a citation's target **exists**
and never that the target says what the citing line claims, and that the J5
miscitation passed the gate clean the whole time it stood. Full semantic
verification is out of scope for a regex checker, so this does the honest thing
instead: it makes the invisible reviewable.

### `--audit`

`python3 utilities/check_refs.py --audit` pairs every cross-document `§`
citation with the statement it points at, and prints both. It reads nothing
about meaning. Thirty-one pairs today, and the judgement stays with a person.

**The gate default is byte-identical.** `--audit` prints and exits 0 without
running the checks, so `refs_baseline.txt` needs no re-cut and the pre-commit
hook is unaffected. Verified before and after every edit below.

### It reproduced the documented failure on its first run

The extractor matched `**A1.**` statements and `## A ·` headings only. So
`Formalization.md § B4` came back `<<MISSING>>` — because B4 is stated as
`### B4 · The four zeros: neither placed nor predicted`.

That is the exact failure this project's CLAUDE.md is built around, in a tool
written to catch it, three hours after re-reading the rule. The gate's own
section index at `check_refs.py:20` already used `^#{3,4}` and I wrote the new
one from scratch instead of reusing it. Widened to `#{2,4}`, with the reason in
the docstring where the next person will read it.

**Second bug, surfaced by the same run.** `J5` also came back `<<MISSING>>`,
and the cause was different: the statement regex ended at `(?=\n\n)`, so the
last statement in a file — with no trailing blank line — never matched. J5 is
the last statement in `Euler-Factor-Chain.md`. Fixed to `(?=\n\n|\Z)`.

So the tool found two of its own defects before finding anything in the corpus,
and both were invisible to a passing gate.

### The corpus review

All 31 pairs read as coherent. **No second miscitation.** F4′ shows a claim and
a target that disagree, which is correct — F4′ exists to record that
disagreement.

Duplicate rows deduped on `(source, statement, target doc, target section)`: a
citation written twice inside one statement is one citation, and 33 rows became
31.

### One stale open question, found by reading the pairs

`papers/Commensurate-Ladders.md:206`:

```text
**H2.** Whether the power chains 2→4→8 and 3→9 do anything beyond block-summing.
`Euler-Factor-Chain.md § H` records the sampling consequence; nothing tests whether
commensurate bases behave differently from orphans in any respect other than C3's
oscillatory fraction, which found no difference.
```

Entry 87's `Isogeny.rowN_eq_blockSum` answers it: the degree-`k` isogeny acts on
the row **as** block-summation by `k`, proved by telescope over an arbitrary
`Q : ℕ → ℤ`. So on the arithmetic side the power chains do nothing beyond
block-summing, and that is now a theorem.

The paper reached the phrase "block-summing" first and entry 87 arrived at the
same word without citing it. **Left unedited** — closing a paper's open question
is Julian's call, and it is recorded here and as a NOTEPAD line for him.

### `CONTEXT.md` brought current

Approved edit. Content dates extended to 2026-08-21; a new
**§ The Lean tree, as of entry 88** recording the torus as a real object with a
discrete lattice, the isogeny's arithmetic shadow and what it does to O53's base
list, and the continuation being in scope and unused. Known defect **6** added
for the checker gap, pointing at `--audit`.

Gate at baseline, 113 values confirmed and 0 not found.

---

## 2026-08-21 — Entry 88 — A barrier that was miscited, false, and already imported; the lattice proved discrete
type: formalization
refs: 80, 84, 86, 87

Julian asked why the torus construction says nothing about primes, and whether
fixing the base first is what loses the forest. Answering it, I claimed the
analytic side was out of reach and cited `Euler-Factor-Chain.md § J5`. Three
things were wrong at once, and they compound.

### 1 — The citation points at a section that says something else

`papers/Euler-Factor-Chain.md:286` in full:

```text
J5. Nothing above tests RH. G8 is an equivalent restatement; B6 presupposes
    the zeros lie on the line.
```

Nothing about continuation, nothing about the Euler product's half-plane. The
claim I attributed to it exists in exactly one place in the tree,
`papers/The-Deep-Ladder.md:165`, which **I wrote** in entry 80, and which cites
J5 for it. So I quoted my own unsupported sentence back as though it were the
chain paper's finding.

`check_refs.py` passes it: `Euler-Factor-Chain.md § J5` resolves, because the
section exists. The checker verifies that a target exists and never that it says
what the citing line claims. That is a real gap in the gate and it is the same
shape as the `§ B4` failure this project's CLAUDE.md is built around.

### 2 — The claim is false

Mathlib's `riemannZeta` **is** the continued function.
`Mathlib/NumberTheory/LSeries/RiemannZeta.lean:181` says so in as many words:
"we use a different definition to obtain the analytic continuation to all `s`."

And it is already in our own code. `lean/Chain.lean:52` and
`lean/EulerFactorChain.lean:115` both put `riemannZeta s` on the right-hand side
of the Euler product. The `1 < s.re` hypothesis restricts the **product**; the
function it equals there carries no restriction at all.

So `ζ(−1)` is two lines. Built as `ZetaProbe.lean`, confirmed, and removed —
the tree is unchanged, and the proof is recorded here to be reproducible:

```lean
theorem zeta_neg_one : riemannZeta (-1) = -1/12 := by
  rw [show ((-1 : ℂ)) = -((1:ℕ):ℂ) by norm_num, riemannZeta_neg_nat_eq_bernoulli 1]
  norm_num [bernoulli]
```

`[propext, Classical.choice, Quot.sound]`, via
`Mathlib/NumberTheory/LSeries/HurwitzZetaValues.lean:239`.

### 3 — The rule I invoked does not apply to that file

I described leaving discreteness unproved as following the Mathlib-free
convention. `lean/Transform.lean:36` is `import Mathlib`. The Mathlib-free
discipline in `lean/BUILD.md` covers `Construction.lean` and the integer
modules and has never touched the geometry module. `ZLattice` was available the
whole time.

**Julian's reading is the accurate one:** I produced a barrier at the sight of
zeta rather than checking whether one existed. He had already named this as the
reason the original wording was written — to stop the reflex — and the reflex
fired anyway, on the wording written to prevent it.

### The lattice is discrete

With the rule gone, the gap closed the same session.

```text
gens_linearIndependent   ⟨1, τ(b)·i⟩ is ℝ-linearly independent
latticeBasis             hence an ℝ-basis of ℂ                      def, no pin
periodLattice_eq_span    periodLattice b = span ℤ (range basis)
periodLattice_discrete   DiscreteTopology (periodLattice b)
```

The route is `Submodule.span_int_eq_addSubgroupClosure` to rewrite the additive
closure as a ℤ-span, then Mathlib's instance
`DiscreteTopology (span ℤ (Set.range b))` for `b` a basis
(`Mathlib/Algebra/Module/ZLattice/Basic.lean:318`).

`Torus b` is now a quotient by a **discrete** rank-2 subgroup of ℂ, which is
what makes the word earn its place. Compactness is still open, and the docstring
states it as one line rather than as a barrier: `ZLattice` gives it from here.

Two API surprises worth recording: `Basis` is `Module.Basis` in this Mathlib
revision, and `linearIndependent_fin2` wants `f 1 ≠ 0 ∧ ∀ a, a • f 1 ≠ f 0`,
so the two generators enter in the opposite order from the definition.

### What the paper says now

`papers/The-Deep-Ladder.md` § F4 corrected, with the accurate limit and a
citation that supports it, and **F4′** added recording that the continuation is
in scope and unused. F4′ names the earlier miscitation in the paper itself, so a
reader meets it rather than only the notebook.

Numbered as a prime on F4, following `F3′` in The-Twin-Lattice and the `F5′`
convention set earlier today.

### Standing

Whether the torus connects to `ζ(−1)`, whether the primes-and-composites ratio
is the torus, and whether `π` is a rate in a growing diameter are all
undetermined by anything in this tree. What changed is that saying so is now a
statement about what has been built. The claim that the building was impossible
is withdrawn.

Build clean, **8040 jobs, 179 theorems, 179 pins, parity in all 14 modules**,
gate at baseline, 113 values confirmed and 0 not found.

---

## 2026-08-21 — Entry 87 — The isogeny acts on the row as block-summation, and O53 swept three ladders wearing six labels
type: formalization
refs: 84, 85, 86, 77

Entry 86 put τ in Lean and stopped at the tori. `Transform.tau_ratio_of_meet`
relates two ladders that meet, and `ℂ*/b^ℤ` knows only `b` — no prime enters it.
This entry is the arithmetic shadow of the same relation, which is the one place
the geometry reaches the counting function.

**`lean/Isogeny.lean`**, the fourteenth module, nine theorems.

```text
rowN Q k r          = Q (k*(r+1)) − Q (k*r)          def, exponent-indexed
rowN_eq_blockSum    rowN Q k r = Σ_{j<k} rowN Q 1 (k*r+j)
rowN_comp           rowN Q (k*l) r = rowN (Q ∘ (k*·)) l r      decimation composes
row_two_eq_pair     base 4's row is base 2's summed in pairs
row_three_eq_triple base 8's row is base 2's summed in triples
dyadicRow_eq_rowN   the weld to Zeros.dyadicRow inside its window
measured_row_four   the base-4 row from the 21 pinned pi2 values
measured_row_eight  the base-8 row from the same 21
```

**What it says.** A block sum followed by a stride-`k` step is a box filter
followed by decimation. A base inside an isogeny class therefore carries no
count its generator's row already carries. `{2,4,8}` is one row read at three
decimations; `{3,9}` is one read at two.

The proof is a telescope over an arbitrary `Q : ℕ → ℤ`. **No arithmetic input is
used at all**, which is the honest scope: the identity is bookkeeping on a
ladder, and it applies to `π` because `π` gets evaluated on one.

**The axiom split is the informative part.**

```text
measured_row_four, measured_row_eight       no axioms whatsoever
rowOf_eq_rowN, rowN_comp                    [propext]
row_two_eq_pair, row_three_eq_triple,
  dyadicRow_eq_rowN                         [propext, Quot.sound]
telescope, rowN_eq_blockSum                 + Classical.choice
```

The general-`k` statement quantifies over `Finset.range` and pays
`Classical.choice` for `Finset.sum`. The concrete `k = 2` and `k = 3` cases need
no Finset and were rewritten to avoid it, which is what dropped them two levels.
The two **measured** rows come in at zero axioms, the same standing as
`Zeros.measured_zeros_all_vanish`:

```text
base 4   2, 4, 12, 36, 118, 392, 1336, 4642, 16458, 59025
base 8   4, 14, 79, 467, 2948, 19488
```

**Lean caught a real error on the first pass.** The weld was written as
`rowOf Zeros.pi2 2 r`, and `pi2` is indexed by the *exponent* — `π(2ⁿ)` at `n`
rather than `π` at `2ⁿ`. So that expression meant `π(2^(2^r))`. Everything is
exponent-indexed now; `rowOf` survives as the count-up-to-`x` reading with
`rowOf_eq_rowN` as a one-line bridge. Two `omega` failures also had to be fixed
by unifying arguments — `omega` reads `Q (2r+1+1)` and `Q (2r+2)` as distinct
atoms, since it never normalises inside an opaque application.

### O53's six bases are three residual sequences

Checked against the residuals `O53_alias_tau.py` actually builds, rather than
against the argument.

```text
base 4 residual == base 2 summed in pairs      max rel gap 3.6e-09 over 18 rungs
base 8 residual == base 2 summed in triples    max rel gap 6.1e-10 over 12 rungs
base 9 residual == base 3 summed in pairs      max rel gap 2.2e-10 over 11 rungs
```

Those gaps are mpmath's `li` precision at `dps = 30`. The `li` term telescopes
exactly alongside the count, so the whole residual decimates and not just the
prime part.

The rung counts say it independently — 36, 23, 18, 14, 12, 11 for bases
2, 3, 4, 6, 8, 9, where `36/2 = 18`, `36/3 = 12`, `23/2 ≈ 11`.

So `O53_alias_tau.py:43`'s `BASES = [2, 3, 4, 6, 8, 9]` is base 2 carrying 4 and
8 as decimations, base 3 carrying 9, and base 6 alone. **Entry 85's reading is
unchanged** — no measurement supports τ as the alias spacing. What moved is the
extent of that negative: half the rows in O53's table are arithmetic
consequences of the other half, so the cross-base structure it swept was three
ladders.

### An inert hypothesis pair in `Chain.lean`, surfaced and left alone

`lake build` reports `Chain.lean:545` unused variables `hm` and `hn`. Those are
the `0 < m`, `0 < n` added to `joint_gain_periodic_of_commensurate` under the F2
audit in entry 77, on the ground that `m = n = 0` satisfies `hcomm` for any pair
of bases.

Unused means the proof never consumes them, so the theorem holds without them.
They keep `m = n = 0` out of the *statement* while the conclusion at that
instantiation stays vacuous, so they hide the vacuous case instead of removing
it. Entry 86 dropped exactly this shape from `tau_ratio_of_meet`, and
`C3lower_of_A4_C2` set the precedent.

**Left as it stands.** This reverses an entry-77 decision and is Julian's call,
so it is recorded here rather than reworked.

### Housekeeping

`lean/BUILD.md` was stale at 11 modules / 8037 jobs / 155 theorems, which
predates both `TwinLattice` and `Transform`. Brought current, the three missing
modules added to its manifest, and the `globs`-is-not-a-wildcard trap written
down where someone adding a module will read it.

Build clean, **8040 jobs, 167 theorems, 167 pins, parity in all 14 modules.**

---

## 2026-08-21 — Entry 86 — τ in Lean: the modular parameter, the power chain, and the meeting exponents
type: formalization
refs: 84, 85

Closes the τ thread on the arithmetic side. Entry 85 closed the measurement side
as negative, and that is stated in the module docstring rather than left for a
reader to discover.

**Three theorems added to `lean/Transform.lean`**, plus the definition.

```text
tau b = 2π / log b                                   def, no pin
zmap_period_tau     b^(−(s + τ(b)·i)) = b^(−s)       τ IS the period
tau_pow             τ(bⁿ) = τ(b)/n                   the power chain
tau_ratio_of_meet   bⁿ = cᵐ → τ(b)/τ(c) = n/m        the meeting exponents
```

**What `τ` is.** The lattice in `s` is generated by `1` — the shift, which
`zmap_shift` proves becomes `z ↦ z/b` — and `2πi/log b`, the period from
`zmap_period`. So the modular parameter of `ℂ*/b^ℤ` is `τ = 2πi/log b`, and
`zmap_period_tau` says the definition and the period are the same object.

**The isogeny classes are now arithmetic rather than observation.**
`tau_ratio_of_meet`: ladders that meet have rationally related `τ`, and the
ratio is the meeting exponents.

```text
τ₂ = 9.0647   τ₄ = 4.5324 = τ₂/2   τ₈ = 3.0216 = τ₂/3
τ₃ = 5.7192   τ₉ = 2.8596 = τ₃/2
```

Base 6 joins neither chain: `6ⁿ = 2ᵐ` has no solution above `n = 0`, and
`log2/log6` is irrational. Sharing prime factors leaves ladders apart, which is
`Zeros.primeFactors_eq_of_meets` from the other side.

**One inert hypothesis dropped.** `tau_ratio_of_meet` was written with `0 < n`
and the proof never consumed it — `bⁿ = cᵐ` with `1 < c` already forces `n > 0`.
Removed, following `C3lower_of_A4_C2`'s precedent, and the theorem is stronger
for it. `hm` is consumed and stays.

**The docstring says the measurement failed**, in the module, where someone
reading the theorems will see it: O53 and O54 tried `τ` as the alias spacing on
data and the statistic swung 0.27 to 1.94 at one base with only the ceiling
moving. What is in `Transform.lean` is arithmetic and claims no measurement.

### `papers/The-Deep-Ladder.md` corrected — it was asserting what its own artifact had superseded

Flagged after O50 run 2 and left undone until now.

* § C read *"Thirty-eight zeros, completely separated"* with no qualifier. Now
  scoped: separated below the first band edge, with the floor rising after.
* § F5 read *"The upper end is untested"* when run 2 had tested it. Replaced with
  what run 2 found — the amplitude at the zeros stays flat across every band,
  medians 6.9052 / 6.9232 / 6.6466 / 6.7469 / 6.4834, while the floor rises
  0.1890 → 3.0449. Every zero in the list is detected and separation stops after
  the first band.
* **F6, new.** The floor rises with the midpoints closing on their neighbours in
  units of resolution, 3.11 elements down to 1.42. That is leakage, and it makes
  `γ = 120` a property of `Δγ = 0.455` rather than of the primes.
* **F7, new.** `Δγ = 2π/log(xmax/x0)`, so `x0` is the cheap lever: `10^5 → 10^2`
  takes `Δγ` from 0.455 to 0.303 at no extra compute.
* **F8, new.** Above `γ = 939` nothing has been looked at, and that bound is
  `zeros600.json` ending rather than the instrument.

`check_values` caught two on the first pass, both mine — a band edge that is a
run parameter, and a zero count that is a sum of the band counts rather than a
printed value. Both reworded. **113 confirmed, 0 not found.**

Build clean, 8039 jobs, 158 theorems, 158 pins, parity in all 13 modules.

---

## 2026-08-21 — Entry 85 — O53/O54: τ is the alias spacing at base 2, the base split was a knob artifact, and the statistic swings 7× at one base
type: run
refs: 69, 83, 84

Two runs, both **EXPLORATORY — no prereg, no verdict**, and the second one
refutes the first's headline. Both kept: `papers/FORMAT.md` — negative results
stay.

**The question.** `lean/Transform.lean` (entry 84) puts the strip on the torus
`ℂ*/b^ℤ` with modular parameter `τ = 2π/log b` after the S-transform, and
`CONTEXT.md` § O18 records the dyadic alias comb as *"eight peaks of identical
height spaced 2π/log 2"*. Same number. Does it hold on data?

**What is tautological and was skipped.** A ladder sampled uniformly in `log x`
has a spectrum exactly `2π/log b`-periodic. Measuring that confirms the
sampling.

**What was tested.** Where the peaks sit inside one period. If the signal is the
zeta zeros seen through the ladder, every peak lands on a zero folded by
`g ↦ min(g mod τ, τ − g mod τ)`. The folded positions come from `γₙ` and `log b`
with no data; the peaks come from the primes.

### O53 run 1, and the trap it walked into

`results/alias_tau.json`. Six bases, ceiling `10^15`, first **60** zeros folded.
Peaks landed 0.0002 to 0.14 from a folded zero, and the ratio against a random
frequency read: base 2 `0.24`, base 4 `0.51`, base 6 `0.50`, base 8 `0.32`
against base 3 `1.40`, base 9 `1.43`. I read that as `{2,4,6,8}` beating chance
and `{3,9}` failing, and matched it to the isogeny classes.

**The target was nearly a continuum.** 60 folded zeros in base 9's domain
`[0, 1.43]` leaves a mean gap of 0.024, so a random frequency sits 0.013 from a
folded zero by construction.

### O53 run 2 — sweep the target density

`results/alias_tau_run2.json`. Same runs, folding 6 / 10 / 20 / 40 / 60 zeros,
with the chance level computed at every setting.

```text
base  rungs      tau | nz=6   nz=10  nz=20  nz=40  nz=60
   2     36   9.0647 | 0.33   0.18   0.38   0.49   0.23
   3     23   5.7192 | 0.94   0.85   0.88   1.05   1.41
   4     18   4.5324 | 0.54   0.89   1.00   1.03   0.51
   6     14   3.5067 | 0.78   1.00   0.62   0.45   0.50
   8     12   3.0216 | 0.53   0.69   1.41   0.26   0.33
   9     11   2.8596 | 0.66   1.05   0.68   1.17   1.45
```

**The `{2,4,6,8}` against `{3,9}` split was an artifact of `nz = 60`.** At
`nz = 6` base 9 reads 0.66 and joins the "working" group; at `nz = 40` base 8
reads 0.26 and base 4 reads 1.03, splitting the 2-family. The partition moves
with the knob. **Retracted.**

Base 2 alone held across all five settings — 0.18 to 0.49, never near 1.

### O54 — the control that killed that too

`results/rung_controlled_alias.json`. Extent and drift **cannot** be separated by
choosing bases: `rungs = log(ceiling)/log b` and the diagonal drift is `(b−1)`,
both functions of `b` alone. They can be separated by holding `b = 2` and moving
the ceiling to hit each other base's rung count.

```text
rungs    ceiling     peaks found   ratio     that base at same rungs
   11   1.68e+07          1        1.94      base 9   0.66
   12   3.36e+07          0         nan      base 8   0.53
   14   1.34e+08          2        0.28      base 6   0.78
   18   2.15e+09          3        1.55      base 4   0.54
   23   6.87e+10          3        0.27      base 3   0.94
   36   5.63e+14          5        0.34      base 2   0.33
```

**At one base, with only the ceiling moving, the ratio runs 0.27 to 1.94.** At
12 rungs the spectrum has **no interior local maximum at all** and the statistic
is undefined. The peak count runs 0, 1, 2, 3, 3, 5 — the statistic is measuring
how many peaks a short window happens to produce.

**So O53 run 2's "base 2 holds at every setting" is withdrawn as well.** That
sweep varied target density while the ceiling sat fixed at 36 rungs. **The
parameter I never varied was the one that mattered.**

### Standing

Nothing about base coupling is established by either run. What survives is
independent of both, because it was never measured — base 2's uniqueness is
three proved `iff`s in `PairIdentity`: `coeff_eq_one_iff_base_two`,
`total_eq_pow_iff_base_two`, `total_const_on_diagonal`. Base 2 is the only base
whose diagonal drift is 1.

**Method note.** Julian's framing — the bases couple through 3,4,…,9 rather than
2 straight to 9 — has two readings the tree distinguishes. Ladders **meet**
(`b^n = c^m`) only inside a prime-power chain, giving five isolated classes
`{2,4,8} {3,9} {5} {6} {7}`, with base 6 = 2·3 joining neither since
`log2/log6` is irrational. And `τ(b) = 2π/log b` is a smooth curve the integer
bases sample, with the gap falling from 3.346 at `2→3` to 0.162 at `8→9`. The
chain reading is proved. The curve reading is untested.

---

## 2026-08-21 — Entry 84 — block G's geometry formalised, and the identification that closes the annulus into a torus
type: formalization
refs: 69, 77, 83

**Where this came from.** Julian asked whether the identification closing the
annulus is `|z| = 2`. It is, and it is the generator the record never had.

**The picture.** `z = b^(−s)` carries the s-plane to `ℂ*`. A vertical line
`Re s = σ` becomes the circle `|z| = b^(−σ)`, so the critical strip becomes an
annulus and the critical line becomes the circle of radius `b^(−1/2)`. At
`b = 2`:

```text
Re s = 0     ->  |z| = 1.00000
Re s = 1/2   ->  |z| = 0.70711     the critical line
Re s = 1     ->  |z| = 0.50000
```

**Two generators, and the second was missing.**

* `s ↦ s + 2πi/log b` fixes `z`. That is the pole lattice
  `Chain.sym_eq_zero_iff` proves, and it is why the strip becomes an annulus
  rather than a plane.
* **`s ↦ s + 1` sends `z ↦ z/b`.** That closes the annulus into `ℂ* / b^ℤ`, a
  complex torus. At `b = 2` it identifies `|z| = 0.5 ~ 1 ~ 2 ~ 4 …`, so every
  2:1 annulus is a fundamental domain — which is Julian's `|z| = 2`.

**And O39's number is that torus's modulus, halved.**

```text
full fundamental annulus  1 < |z| < b       modulus  log(b)/2π = 0.1103178
O39 measured              0.5 < |z| < 0.70711        (log b)/4π = 0.0551589
                                                      ratio 2.0
```

O39's annulus has ratio `√b`, so § G7 has been reporting **half a fundamental
domain** since it was written. The record carried the number and never the
identification.

**New module `lean/Transform.lean`**, the thirteenth, added to `lakefile.toml`
globs. Six theorems, all at `[propext, Classical.choice, Quot.sound]`, which is
the floor for ℂ-valued statements.

```text
norm_zmap                  ‖b^(−s)‖ = b^(−Re s)          the map
norm_zmap_critical         critical line -> |z| = b^(−1/2)
zmap_shift                 b^(−(s+1)) = b^(−s)/b         the closing generator
zmap_period                b^(−(s + 2πi/log b)) = b^(−s) the pole lattice
zmap_functional_equation   b^(−(1−s)) = b^(−1)/b^(−s)    inversion in |z|=b^(−1/2)
annulus_modulus            log(b^(−1/2)/b^(−1))/2π = log b/4π
```

`zmap_functional_equation` is `EulerFactorChain.h_functional_equation` read in
`z`: the map `s ↦ 1 − s` becomes inversion in the circle `|z| = b^(−1/2)`, and
**the critical line is that inversion's fixed circle**.

**Wired to the paper.** § G7 now cites `Transform.annulus_modulus`, and two new
statements were added — G7′ for the torus and its two generators, G7″ for the
inversion. `check_refs` resolves every citation; gate unchanged at 2,
`check_values` 113 confirmed / 0 not found.

**`lean/BUILD.md` corrected.** It claimed 139 theorems against a tree of 155,
and listed block G whole as unformalised. Now it names what stays an
observation: G1's Cauchy–Hadamard, G3's Jentzsch, G5's measured migration, G8's
RH equivalence, G9 and G10. **Only the numeric values and those remain.**

**What this does not do.** G8 says `RH ⟺ the annulus has maximal modulus` and the
paper's own source line calls it *"an equivalent restatement … of identical
difficulty"*. Nothing here touches it. The geometry is now stated; which radius
the residual actually has is the open question, and it is RH.

**Worth noting for later.** `ℂ* / q^ℤ` is the Tate uniformization — the standard
presentation of an elliptic curve over a non-archimedean field. O40 and O41 went
to elliptic curve L-functions from the other direction, and
`papers/convergence.md` records that only degree-1 L-functions give a plain
difference table. Nothing connects them yet.

Build clean, 8039 jobs, 155 theorems, 155 pins, parity in all 13 modules.

---

## 2026-08-21 — Entry 83 — the pocket read as a BASE: the pair identity's coefficient is the lower twin arm, and the extent arithmetic that bounds it
type: motivation
refs: 81, 82

**Julian's reframe, and it is not what entry 82 built.** O51 treated the lattice
as a *set of sites* and counted occupancy. His reading is that each pocket is a
**base**, in the same sense as dyadic and triadic: `(11,13)` gives base 12, and
you build the b-adic table there. Tabled without pursuing, recorded so it is not
rediscovered.

**The structural consequence, which is the reason to record this at all.**
`PairIdentity.pair_identity` gives the cell total as `(b−1)^(d+1) · b^e`. At a
pocket base, **`b−1` is the lower twin arm** — a prime. At a generic base it is
composite. So the pocket bases are exactly those whose identity coefficient is
prime, and reading that coefficient across pockets enumerates the lower twins:

```text
base b     4    6   12   18   30   42   60   72
b − 1      3    5   11   17   29   41   59   71     <- the lower twin arms
b + 1      5    7   13   19   31   43   61   73
```

The arms are not beside the lattice. **One of them is the identity's
coefficient at that base.**

**A correction Julian caught in conversation.** I said bases 4 and 6 were "two
pockets already measured, both empty". Wrong on two counts. They are **pockets,
not twins** — the twins are 3, 5 and 5, 7. And `4 % 6 = 4`, so base 4 is **off
the lattice**, which is exactly what `TwinLattice.three_five_exceptional`
proves: `(3,5)` is the one pair whose pocket is not a multiple of 6. My own
theorem excludes it and I counted it anyway.

Corrected: of the eight bases O44 measured, **exactly one is an on-lattice
pocket — base 6**, the pocket of `(5,7)`, and it has no exact zeros. Bases 12,
18, 30, 42 have never been built.

**And base 2 is not a pocket at all** (`b − 1 = 1`, not prime). The one base with
exact zeros is the one base in range that is not a pocket.

**Base 4 is a control, not a data point.** It is the only base with twin arms
that sits off the lattice. If the lattice does work, 4 and 6 should behave
differently; O44 lumped both in with 2–9.

**The extent arithmetic, which bounds the whole idea.** `rungs =
log(ceiling)/log(b)`, so high bases are starved regardless of compute.
primecount is not the constraint — `π(10^15)` returns in 0.58 s.

```text
base    arms      rungs at 2^32   1e11   1e15
   4    (3,5)          16          18     24
   6    (5,7)          12          14     19
  12   (11,13)          8          10     13
  18   (17,19)          7           8     11
  30   (29,31)          6           7     10
  42   (41,43)          5           6      9
```

Base 30 would need a ceiling near `30^20 ≈ 3.5e29` to hold the twenty rungs base
2 has at `2^20`. This is arithmetic, not a sieve limit — going deeper in `x`
buys rungs only logarithmically. O44 already named it: *"bases 5–9 stop at
regime ceilings 27, 24, 22, 21, 20 and are extent-censored."*

**So the per-pocket table question is extent-limited before it is asked** —
base 12 gets 13 rungs at `10^15`, not enough to look for anything like `(20,6)`.
The cross-pocket question, whether the pockets connect to each other, is not
obviously bounded the same way and was not examined.

Nothing run. Nothing claimed. This entry is the observation and its limit.

---

## 2026-08-21 — Entry 82 — O51: the twin lattice census, and three things it refuses
type: run
refs: 78, 81

**Run.** `O51_twin_lattice_census.py`, no flags, **EXPLORATORY — no prereg, no
verdict**. Numpy odd sieve to `2^30`, four-way occupancy of the `6k` lattice per
dyadic block, `r = 3…30`. Completed, did not error.
`results/twin_lattice_census.json` + `results/O51_twin_lattice_census_run1.log`.
Paper written on it: `papers/The-Twin-Lattice.md`.

**Self-check passes.** The four-way split — twin / lo / hi / bare — partitions
the sites exactly at every rung. A failure would have been a bug.

### Three refusals, and the refusals are the content

**1. The total is not geometric, so `pair_identity` does not transfer.** The site
count per block alternates `±1/3` about `2^(r−1)/6`, at every rung, without
settling — because `2^(r−1) mod 6` alternates between 2 and 4 and the floor
follows. So the hypothesis fails for a **structural** reason, and the deviation
is the `2·3` lattice showing up in the count of its own sites.

This is the second refusal for this object. Partitioning twins against the whole
block instead gives a geometric total, but the complement is 99.9% of it and
carries nothing (`The-Composite-Arm.md` § A2's argument, worse).

**2. The occupancy bias is weak and sign-changing, and is NOT the Chebyshev
bias.** `lo − hi` normalised by `√sites` stays inside `±0.25` and flips sign
across rungs. Counting **primes** by residue class mod 6 gives a consistent
one-directional excess for `6k − 1`; counting **sites flanked on exactly one
side** does not. I conflated the two in conversation before the census ran. The
census separates them, and the residue-class race is measured nowhere in this
tree — the figures I quoted came from an inline script and are in no artifact,
so they are in no paper.

**3. No twin zero is deep.** The twin arm's difference table has exactly four
exact zeros at `d ≥ 1` over 377 cells to `r = 30`: `(4,1)`, `(6,1)`, `(9,1)`,
`(8,4)`. **All four sit at `r ≤ 9`**, where counts are single or double digits.
The prime table's `(20,6)` sits at a count of 38635. Depths to 28 were examined
across `r = 3…30`, so the deep region was looked at and is empty.

### The parts worth arguing about

`(4,1)` is in **both** lists — the prime table's `(2,1) (4,1) (8,3) (20,6)` and
the twin table's. One coincidence at a small count, recorded because it is
checkable, not because it is evidence.

Three of the four twin zeros are adjacent repeats on tiny counts —
`twin(3) = twin(4) = 1`, `twin(5) = twin(6) = 2`, `twin(8) = twin(9) = 7` — and
`Zeros.zero_iff_repeat` says a depth-1 zero **is** a repeat, so those are cheap
at those magnitudes. **`(8,4)` is not**: the row `2, 2, 3, 7, 7` differences to
`1, 0, 1, 4`, then `−1, 1, 3`, then `2, 2`, then `0`. A depth-4 cancellation,
walked by hand to confirm.

**Extent caveat, stated rather than buried.** 377 cells to `r = 30` against
O43's 4186 cells to `r = 92`. The absence of a deep twin zero is an absence over
the smaller range.

### Ordering

Lean first (entry 81), then the census, then the paper citing both. The reverse
of `The-Composite-Arm.md`, which went out ahead of its script and is still
PROVISIONAL. `check_values` caught two numbers on the first pass — O43's `92`
and `4186` cited against the twin artifact, which does not contain them — and
they were split into their own statement with their own source. Now **113
confirmed, 0 not found**.

---

## 2026-08-21 — Entry 81 — TwinLattice: a twin pair is a lattice site, proved, and the mod-6 lattice was already load-bearing here twice
type: formalization
refs: 78, 80

**Julian's theory, in his terms.** Twin primes share a pocket between them, one
integer apart, and he treats the lattice as navigation: the pair is where a
trajectory has both arms available.

**The check.** Every twin pair above 3 is `(6k − 1, 6k + 1)`, so the single
integer between is `6k`. Verified numerically below 2000 — one exception,
`(3,5)`, and it is the first pair. **So a twin pair is not two primes that happen
to sit two apart. It is a site on the `2·3` lattice with primes on both
shoulders**, and counting twins is counting doubly-flanked sites.

**And that lattice is already load-bearing in this tree, in two places nothing
connected.**

* `CONTEXT.md` § Current state of the world, O19/O20 — `(8,3)` lands at Connes'
  `λ = 4`, whose window holds exactly `{2,3}`, *"the mod-6 lattice, which is the
  workbook's own reason for that zero"*.
* `CONTEXT.md` § `imported/lattice_mapper/` — those tables are built with *"2 and
  3 excluded as lattice rather than counted as primes"*. **That convention is the
  mod-6 lattice.**

The twin object, the deep zero's stated explanation, and the imported tables'
convention are the same lattice, approached from three directions and never
named once.

**New module `lean/TwinLattice.lean`**, the twelfth, named by Julian. Added to
`lakefile.toml` globs — that list is explicit, not a wildcard, so a new module
does not build until it is named there.

```text
twin_lower_mod_six      p, p+2 prime and 3 < p  →  p % 6 = 5   [propext, Quot.sound]
twin_pocket             the integer between is ≡ 0 (mod 6)     [propext, Quot.sound]
three_five_exceptional  (3,5) exhibited, not assumed           full three
```

**The two lattice theorems carry no `Classical.choice`** despite importing
Mathlib — they are ℕ-valued and close through `omega`, which costs `Quot.sound`
and nothing more. The exception theorem does carry it, and the cost is entirely
Mathlib's: **even `Nat.prime_three` depends on `Classical.choice`**, and `decide`
on `Nat.Prime` routes through a classical decidability instance. Checked
directly rather than assumed. Pinned as it is rather than worked around, since
the honest list says where the cost comes from.

**Placement, and why not `Chain.lean`.** Chain's own header, line 4: *"Companion
to papers/Euler-Factor-Chain.md."* Its job is checking that paper's arrows, and
the mod-6 material discharges no statement in it. Putting it there would make
the file's header false. This tree's modules are named for objects and have held
their scope; a new object gets a new module.

**Mathlib has nothing on twin primes.** Grepped. Nothing here is reproved.

**What is NOT proved, and was not attempted.** That the lattice explains where
twins are or how many there are. The three-way occupancy split — sites flanked
on both sides, one side, neither — is not here. Neither is the character reading
of the two arms, though it is the standard machinery: the classes `6k ± 1` are
the two Dirichlet characters mod 6, their difference is the Chebyshev bias
(measured at 0.46–0.96 in units of `√x/log x` over four decades), and
`papers/convergence.md:26` already notes that *"only degree-1 L-functions give a
plain difference table"* — which Dirichlet L-functions are. Each is a separate
step that can fail on its own.

**Ordering.** Julian's rule for this: prove it in Lean first, and only then add
it to the paper. That is the reverse of `papers/The-Composite-Arm.md`, which was
written before its script existed and is still PROVISIONAL with four conditions
in its header. No paper is written here.

Build clean, 8038 jobs, 149 theorems, 149 pins, parity in all 12 modules. Gate
unchanged at 2, `check_values` 99 confirmed / 0 not found.

---

## 2026-08-21 — Entry 80 — twin_count imported, CONTEXT brought current to O50, and The-Deep-Ladder written
type: provenance
refs: 46, 73, 75, 79

**Import.** Seven files copied byte-for-byte (`cp -p`) from
`~/GitHub/twin_count/` into `imported/twin_count/`, every one SHA-256 verified
source-vs-destination at copy time, manifest at
`imported/twin_count/README.md` which self-verifies against the files it lists.
Same discipline as entry 46's lattice_mapper import.

**The source is not a git repository and has no commitment files.** This import
is the only versioned copy of that work that exists — 10,000 checkpoints to
`10^11`, an analysis, and 100,000 zeta zeros, previously one disk failure from
gone.

**Not imported:** `twincount` the compiled binary, 33976 bytes, machine-specific
(`-march=native`) and rebuildable from `twincount.c`. Same judgment as
`archive_unsilenced/` in entry 46 — binaries do not belong in an evidence
import.

**Convention warning recorded in the manifest.** `twins_1e11.csv` is sampled on
a **linear** ladder, step `10^7`; every in-repo artifact uses **geometric**
rungs. That difference is not cosmetic — it is exactly what
`twins_1e11_analysis.json` deprecates its own α estimator for, and it is the
same class of defect as O48's fixed depth window.

**CONTEXT.md brought current**, Julian approving. It stopped at O47 and its
test table stops at O39, so the file a new instance reads first to orient did
not know the last three runs had happened. Added: a note that the table stops
at O39; entries for **O48** (preregistered, `compromised`, control could not
survive the depth window), **O49** (the C2 ceiling attained at 97.68% ± 2.91%,
depth saturates by `d = 1` or `2`), and **O50** (38 zeros separated completely,
O17's ceiling was a sieve limit); and an `imported/twin_count/` section on the
lattice_mapper pattern.

**Paper written.** `papers/The-Deep-Ladder.md`, six sections on the house
format. Its § D records the false start in full — that flat amplitude in γ was
read as fatal and is in fact what a fine ladder must produce, since
`(r^ρ − 1)/ρ → log r`. Its § F carries five limits, including that there is no
prereg and that the separation statistic was chosen *after* the peak list proved
to be selection, which is the sequence a prereg exists to prevent.

**`check_values` caught six numbers on the first pass** and all six were mine:
three prime counts written in scientific shorthand against full integers in the
JSON, a range bound that is a run parameter rather than a measurement, the
string `O17` parsed as the number 17 inside a statement checked against an
artifact, and one genuinely derived ratio that needed declaring as derived per
`papers/FORMAT.md`. Now **99 confirmed, 0 not found**, up from 83.

---

## 2026-08-21 — Entry 79 — O50: 38 zeta zeros recovered with complete separation, and the dyadic control still fails
type: run
refs: 17, 75, 76, 78

**Run.** `O50_deep_ladder_spectrum.py`, no flags, **EXPLORATORY — no prereg, no
verdict**. `results/deep_ladder_spectrum.json` +
`results/O50_deep_ladder_spectrum_run1.log`. Completed, did not error.

**Why.** Entries 75/76 established that depth is the wrong axis — the gain
saturates at the C2 ceiling by `d = 1` or `2`, so differencing destroys mode
identity immediately. Every success on this bench probed at **depth 0** and
varied the ladder: O17, O18, O34/O35's 94%. And `CONTEXT.md:250` names the limit
that stopped O17 — *"over 8.4M primes there are only ~16 disjoint blocks however
the ladder is sampled."* **That is a sieve limit, not a mathematical one.** O17
sieves with numpy; primecount evaluates `π(10^11)` in 4 ms.

The statistic is unchanged from O17. Only `xmax` and the `π` backend differ.

**Result.**

```text
arm              ratio      x0   blocks       primes   zeros  separation  ratio
replicate_1.1      1.1    1000      193  4.02e9           6   COMPLETE     4.8x
fine_1.002       1.002     1e5     6914  4.11e9          38   COMPLETE    36.5x
dyadic_control     2.0       2       35  2.87e9           6   FAILS        5.3x
```

**The fine arm separates 38 zeta zeros completely:**

```text
amplitude AT the 38 zeros    median 6.905   min 6.478
amplitude BETWEEN them       median 0.189   max 2.341
                             0 of 38 zeros below the largest midpoint
```

Every zero is above every midpoint. O17 found **three** (γ₁, γ₂, γ₃) on 125
blocks over 8.41e6 primes; this finds **38** on 6914 blocks over 4.11e9, and
`replicate_1.1` — O17's own ladder at the new ceiling — goes from 3 to 6.

**The dyadic control still fails**, 3 of 6 zeros below the max midpoint, which is
O17's finding reproduced at 340× the primes. Its Nyquist is 4.5, so γ₁ at 14.13
is aliased and cannot be resolved however many primes are thrown at it.

**A false start worth recording, because I nearly threw the result away.** The
top-ten peak table looked suspicious for two reasons: every peak had nearly the
same height, and the fine arm appeared to *miss* γ₁, γ₂, γ₃ while finding γ₃₇.
I read the flat amplitude as fatal, on the grounds that the explicit formula's
`x^ρ/ρ` predicts a `1/γ` falloff.

**That was wrong.** For a narrow block the mode contributes `x^ρ(r^ρ − 1)/ρ`,
and `(r^ρ − 1)/ρ → log r` as `|ρ log r| → 0`. The `1/γ` cancels. **Flat amplitude
in γ is exactly what a fine geometric ladder must give**, and its presence is
evidence for the reading rather than against it. The apparent "missing" low
zeros were an artifact of ranking by peak height when the spectrum is flat: the
top ten were ten zeros among thirty-eight, chosen arbitrarily.

The separation test replaced the peak table as the primary statistic for that
reason — a top-ten list is selection, a fixed comparison of zeros against exact
midpoints is not.

**What this is.** A measurement, at 490× O17's prime count, confirming that the
prime residual on a fine geometric ladder carries the zeta zeros. **It is not new
mathematics** — the explicit formula says so. What is new here is the resolution,
and that the working method was resolution-starved rather than exhausted.

**What it does not touch.** The four exact zeros, and the global bridge — the
Euler product still lives at `Re s > 1` and everything else on the critical line
(`Euler-Factor-Chain.md` § J5).

**Provenance of the idea.** From `~/GitHub/twin_count`, whose `twincount.c`
streams to `10^11` in 16.8 s and whose analysis deprecates its own α estimator
for a linear-sampling defect that is the same class as O48's fixed depth window.
That folder has no commitment files and is not a git repository.

---

## 2026-08-21 — Entry 78 — the four zeros computed rather than transcribed, and the def-citation hazard closed at its most-cited instance
type: formalization
refs: 60, 70, 77

`Zeros.measured_zeros` was four hand-typed pairs whose own docstring said *"no
theorem above predicts these"* — and `papers/The-Four-Zeros.md` § B9 cited it,
in a source line, as though citing a proof. The handoff plan named this hazard:
`utilities/check_refs.py:31` resolves a `def` and a `theorem` identically, so a
citation to a transcription is indistinguishable from a citation to a result.
That citation was mine.

**Seven theorems, all with no axioms at all.**

```text
pi2                  π(2^n), n = 0…20, from pi2n_cache.json — 21 integers,
                     and the ONLY measured input to any of this
dyadicRow            N(r) = π(2^r) − π(2^(r−1))

zero_2_1  zero_4_1  zero_8_3  zero_20_6
measured_zeros_all_vanish     the list's own claim, as a theorem
nonzero_7_3  nonzero_19_6     so the check fires in both directions
```

Entry 60's `tableFrom_eq_stencil` is what makes this one line each rather than a
table walk:

```text
(2,1)    1·1 − 1·1                                                 = 0
(4,1)    1·2 − 1·2                                                 = 0
(8,3)    1·23 − 3·13 + 3·7 − 1·5                                   = 0
(20,6)   1·38635 − 6·20390 + 15·10749 − 20·5709 + 15·3030
           − 6·1612 + 1·872                                        = 0
```

`nonzero_19_6 = 343` is the `+343` of `papers/The-Fold.md` § C3, whose partner
`−343` sits at `(20,7)` because a zero at `(20,6)` forces it there.

**What changed and what did not.** The zeros' *vanishing* is now derived from π
by the kernel, at zero axioms. Their *location* is not, and the docstring still
says so. Nothing here predicts why 8 and 20 and no other cell below `r = 92`.

**The citation is repointed.** `The-Four-Zeros.md` § B9 now cites
`Zeros.measured_zeros_all_vanish` — a theorem — rather than the list, and says
so in the source line. `measured_zeros` stays, because three other modules carry
the same list and `SeedPerturbation`/`PairIdentity` cite it; its docstring now
directs any citation to the theorem.

**Still open.** The hazard itself is not fixed — `check_refs.py` still cannot
tell a `def` from a `theorem`. What closed here is the one instance that was
actually being exploited. Three transcribed copies remain:
`Construction.measured_zeros`, `SeedPerturbation.zero_cells`,
`PairIdentity.zero_cells`.

Build clean, 8037 jobs, 146 theorems, 146 pins, parity in all 11 modules.
Axiom-free count rises 15 → 22.

---

## 2026-08-21 — Entry 77 — block D formalised, wired to the paper, and the attainment C2 never had
type: formalization
refs: 69, 75, 76

Entry 76 found `papers/Euler-Factor-Chain.md` § D stating the floor, the
ceiling, the smooth term's position and the ceiling bases **in prose**, while
`lean/BUILD.md` listed the whole block as not formalised. Six theorems close it.

```text
gain_sq_at_floor          cos(γ log b) = 1  →  gain² = (1 − b^(−1/2))²     D1
gain_sq_at_ceiling        cos(γ log b) = −1 →  gain² = (1 + b^(−1/2))²     D1
C2_floor_attained         γ = 0 sits exactly on the floor                  D2
C2_ceiling_attained       ∃ γ reaching the ceiling; witness π/log b
ceiling_dominates_floor   floor² < ceiling², needs only 0 < b              D3
ceiling_base              exp(π(2k+1)/γ) puts γ at the ceiling             D4
```

All six fall out of `EulerFactorChain.gain_sq_on_critical_line`, which was
already proved, by evaluating `cos` at `±1`. Nothing hard happened; the pieces
were on both sides of a gap nobody had crossed.

**The attainment is the part `StmtC2` did not have.** C2 proves the gain is
*contained* in `[1 − b^(−1/2), 1 + b^(−1/2)]` and never exhibits a `γ` at
either end — the handoff plan flagged exactly this, that Lean proves
containment and never attainment. `C2_floor_attained` and `C2_ceiling_attained`
supply both ends. And entry 75 measures the residual table's own gain at
**97.68% ± 2.91% of that ceiling across twelve bases**, so the bound is not
merely attainable but attained in the data.

**Correction to entry 76.** It says `Chain.sym_eq_zero_iff` "is D1's floor
condition, proved." That is imprecise and I am not amending 76. `sym_eq_zero_iff`
is where `Sym` vanishes **outright**, on `s = 2πik/log b`, which has
`Re s = 0`. D1's floor is on the **critical line** `Re s = 1/2`, where the gain
is `1 − b^(−1/2)` and is not zero. Same phase condition, different line. The
honest statement — now in `Chain.lean`'s section docstring — is that **the C2
floor is where the critical line passes closest to the zero lattice**, and
`1 − b^(−1/2)` measures that approach.

**Wired to the paper.** Five source lines in `Euler-Factor-Chain.md` now carry
Lean citations: C2 gains `gain_sq_periodic`, `C2_floor_attained`,
`C2_ceiling_attained` with the note that both ends are attained rather than
merely bounded; D1 gains both halves; D2 gains the floor witness; D3 gains the
inequality and O49's measured 97.68%; D4 gains `ceiling_base`. `check_refs.py`
resolves every one — the gate is unchanged at 2.

These are all **theorems**, so the `def`-versus-`theorem` hazard the handoff
plan names does not apply here. That hazard remains open for
`Zeros.measured_zeros`.

**`lean/BUILD.md` corrected.** It said 119 theorems; the tree has 139. Its
"not formalised" line dropped block D and now names only block G and the
numeric values. D5 and D6 stay observations — they are measurements of how far
base 2 and base 3 sit from a ceiling base, not statements to prove.

Build clean, 8037 jobs, 139 theorems, 139 pins, parity in all 11 modules.

---

## 2026-08-21 — Entry 76 — the record already had it: `Euler-Factor-Chain.md` § D states the floor, the ceiling and the power iteration in prose
type: result-triage
refs: 72, 74, 75

Checked entry 75's finding against the written record before logging it, at
Julian's instruction. Most of the structure is already there, and three things
I asserted are wrong.

### What block D already says

`papers/Euler-Factor-Chain.md` § D · The winding:

```text
D1. The floor of C2 is at γ log b ≡ 0 (mod 2π); the ceiling at γ log b ≡ π (mod 2π).
D2. The smooth term has ρ real, so γ = 0, so it sits exactly at the floor.
D3. Therefore differencing dissipates the smooth part maximally while
    amplifying modes near the ceiling.
D4. The bases placing γ exactly at the ceiling are b = exp(π(2k+1)/γ).
    For γ₁: 1.2489, 1.948, 3.039, 4.741, 7.395 …
D6. Therefore base 2 reaches 98.3% of its ceiling for γ₁, base 3 99.6%.
```

**D3 is the power iteration.** Entry 75 presents it as a mechanism found in the
data; it has been in the paper. **D1's floor is the null** this program has been
calling a discovery since entry 72.

### Three corrections

**(1) `Depth-as-Time.md` § B4 does not overclaim, and I said it did.** B4 reads
"the first Riemann zero is the fastest-growing mode of the difference operator,
**in both bases measured**" — correctly scoped — and B5 immediately says *"It
does not generalize to the other zeros"* with base-2 percentages of ceiling
listed per zero: γ₂ 84.8, γ₃ 69.8, γ₄ 90.3, γ₅ 91.6, γ₆ 47.0. My claim that B4
was a base-2 coincidence the paper had missed is withdrawn.

**(2) Entry 72 overstates the novelty of the null base.** It says nobody looked
at 1.5597 as a null. D4 lists the **ceiling** bases for γ₁ beginning at
**1.2489** — the O45 family's k=2 — and the floor bases are its one-line
complement. The family is `log b_k = k·π/(2γ₁)`, so k=2 puts γ₁ at the ceiling
and k=4 at the floor. It was built on this axis and half of it was written down.

**(3) Entry 74 sets `d*` beside a quantity it does not measure.**
`analysis/2026-08-19_table_structure/scripts/t2_crossover.py:11-12` defines `d*`
as "the first depth where oscillation carries more than half the power," an FFT
DC-versus-rest split. Entry 75's plateau entry is a gain-ratio threshold. Entry
74's point about the fixed window stands; the two statistics do not compare and
should not have been tabled together.

### What survives as new

**The attainment is measured on the table, not predicted for a mode.** D6 gives
γ₁'s *predicted* growth factor as a percentage of ceiling in two bases. Entry 75
measures the **residual table's own per-depth gain** and finds it at
**97.68% ± 2.91% of `1 + b^(−1/2)` across twelve bases**, nine of which appear
in no prior result in this tree.

**Convergence is immediate.** D3 says differencing amplifies ceiling modes; it
does not say how fast. One or two differences is fast enough that **no depth
window exists in which a sub-ceiling mode is visible** — which is the real
reason O48 could not see γ₁'s null, and is stronger than entry 73's account.

**The O48 failure quantified.** At `b = 1.5597432`, γ₁ sits at 0.0% of the band
and γ₂ at 99.9%. D1 and B5 together predict this; the base had never been run.

**And block D is prose.** `lean/BUILD.md:105` lists "the winding (block D)" as
not formalised, while `Chain.sym_eq_zero_iff` — landed in entry 69 — **is D1's
floor condition, proved**. Neither side of the tree records that the other did
it. That is the gap worth closing.

---

## 2026-08-21 — Entry 75 — O49: the residual table's depth gain attains the C2 ceiling in every base, by depth 1 or 2
type: run
refs: 72, 73, 74

**Run.** `O49_gain_vs_depth.py`, no flags, **EXPLORATORY — no prereg, no
verdict, nothing here is stamped**. Thirteen bases, value window `[10^4, 2^32]`,
depths 1–12, `primecountpy.prime_pi`, `mp.dps 50`. Completed, did not error.
`results/gain_vs_depth.json` + `results/O49_gain_vs_depth_run1.log`.

**Question.** Entry 74 found O48's gain constant at 1.771 and blamed a fixed
depth window sitting above `d*`. This asks per base: at what depth does the gain
leave the symbol, and does the symbol hold below it?

**Answer: it never holds.** The plateau is entered at `d = 1` or `d = 2` in
every base. There is no shallow regime in which a single mode governs.

**And the plateau is not noise — it is the C2 ceiling, attained:**

```text
base      plateau (median d≥4)   1 + b^(−1/2)   ratio
1.1500                 1.8859         1.9325   0.9759
1.2293859              1.8890         1.9019   0.9932
1.2560                 1.8481         1.8923   0.9767
1.2855907              1.8502         1.8820   0.9831
1.3160                 1.7347         1.8717   0.9268
1.3483554              1.8172         1.8612   0.9763
1.4200                 1.7126         1.8392   0.9312
1.5000                 1.7238         1.8165   0.9490
1.5597432              1.8203         1.8007   1.0109
1.6200                 1.7743         1.7857   0.9936
1.7500                 1.7976         1.7559   1.0237
2.0000                 1.6753         1.7071   0.9814
                                mean 0.9768, sd 0.0291
```

`StmtC2` bounds the gain in `[1 − b^(−1/2), 1 + b^(−1/2)]`. The handoff plan
flagged that Lean proves **containment, never attainment**. This is attainment,
measured, at every base to 2.3%.

**Why.** Each difference multiplies mode `ρ` by `|Sym b ρ|`, so depth is a power
iteration and selects the largest gain in the band. That is
`Euler-Factor-Chain.md` § D3 — see entry 76, which checks this against the
record and finds the mechanism already written.

**At the γ₁ null base, what the other modes are doing:**

```text
b = 1.5597432,  band [0.1993, 1.8007]
        γ·log b     /π    |Sym|   position in band
γ₁       6.2832   2.000   0.1993      0.0%   nulled exactly
γ₂       9.3447   2.975   1.7993     99.9%   at the ceiling
γ₃      11.1179   3.539   1.2024     62.6%
γ₅      14.6403   4.660   1.5535     84.6%
```

**So the γ₁ null is real and unobservable.** Nulls sit at `γ log b = 2πk` and
maxima at `γ log b = π (mod 2π)`; the zeta zeros are spaced closely enough that
a base nulling one puts another near the ceiling. Here γ₂ lands within `0.026π`
of a maximum. This is structural, not misfortune — and it is the mechanism the
locked prereg named in advance as its largest doubt.

**Standing.** Exploratory. Entry 76 checks it against the record.

---

## 2026-08-21 — Entry 74 — O48 run 1 re-read: the gain is constant at 1.771, the depth window sat above `d*`, and entry 73's small-angle agreement was a crossing
type: result-triage
refs: 52, 53, 72, 73

Entry 73 stands as written. This entry carries the correction, same as 68/70.

### Retraction

Entry 73 reports, as exploratory, that inside the small-angle radius the
transform tracks to within 3% — ratios 1.137, 0.969, 0.968, 1.023, 0.987. **That
is a coincidence and I over-read it.** Strip the `1/log b` normalisation and look
at the raw per-depth gain `G_b = Ĝ_b · log b`:

```text
base    measured G   γ₁ model   smooth model
1.1500      1.8351     1.6137        0.0675
1.2294      1.8323     1.8902        0.0981
1.2560      1.8307     1.8908        0.1077
1.2856      1.8846     1.8428        0.1180
1.3160      1.7235     1.7457        0.1283
1.3484      1.8454     1.5965        0.1388
1.4200      1.7177     1.1396        0.1608
1.5000      1.7074     0.5256        0.1835
1.5597      1.7441     0.1993        0.1993
1.6200      1.7279     0.5159        0.2143
1.7500      1.7826     1.2869        0.2441
2.0000      1.6200     1.6784        0.2929
```

**The measured gain is constant: 1.7710 ± 0.0766, CV 4.3%, over all twelve
bases.** The entire 5.6× spread in `Ĝ` reported in entry 73 is the `1/log b`
divisor, not structure. There was no curve.

The apparent agreement below `u/2π = 0.62` is the γ₁ model **crossing** that
constant, because for small `h`, `|1 − e^(−ρh)| → |ρ|h = 14.14h`, which passes
through 1.8 precisely in that range. From `b = 1.42` the model dives and the
measurement does not move.

### What the run actually measured

Noise amplification at gain ≈ 1.77, base-independent. That accounts for every
feature at once: no null (noise has none), a smooth `Ĝ` curve (it is
`const/log b`), and the control's apparent failure — **the control was not broken
relative to the data; it was measuring the same thing**, rounding noise at
`G ≈ 1.6–1.76` for small `b`.

So the `compromised` verdict is right, and for a deeper reason than the one
entry 73 gives: the pipeline and its control were both in the noise regime.

### The design error, and it is upstream of the control

`analysis/2026-08-19_table_structure/CHAIN.md` § `t2_crossover` already records
`d*`, the depth where oscillation overtakes trend, per base:

```text
k=1 1.1175 -> d* = 2      √2  1.4142 -> d* = 4
k=2 1.2489 -> d* = 3      k=4 1.5597 -> d* = 5
k=3 1.3957 -> d* = 4      2.0000     -> d* = 7      3.0000 -> d* = 10
```

`d*` runs 2 to 10 across the set. **The locked window `d ∈ [3,8]` is above `d*`
for k=1 and k=2, straddles it for k=3, k=4 and √2, and lies below it only for
bases 2 and 3.** A fixed depth window measures a different regime in every base,
which is exactly what a base-independent constant looks like when you find one.

Corroborating, from the other direction: O34/O35 report 94% at `d=0`, 92% at
`d=3`, **80% at `d=6`** — degrading — and entry 52 records the model flipping
sign at `(25,21)`. The window sat in the decay zone and this was recorded before
the prereg was written.

### What this points at

Julian's proposal — take the crossover per base and difference across bases —
is the right instrument, because `d*` is the depth at which the character
changes and it is already measured to scale with the base. Entry 53: `d*` is not
a per-base constant, but its slope in `r` is, `corr(ln b, slope) = +0.9735`.

The next run is exploratory and asks the question the fixed window could not:
**per base, at what depth does the gain leave the symbol and join the 1.77
plateau, and does the symbol hold below it?** No prereg. Labelled exploratory.

---

## 2026-08-21 — Entry 73 — O48 run 1: the transform holds inside the small-angle radius, the null does not appear, and the control was the defect
type: run
refs: 69, 72

**Run.** `O48_small_angle_cross_base.py`, no flags, under
`preregs/small_angle_cross_base_v1_20260821.md` **LOCKED**, sidecar
`14c86dc224de23d62d6c0486106a5a071645ac01ee328e512d3da8c52daa6fbd` verified
against the file before the Run record was filled. Started
2026-08-21T19:13:54Z, ended 19:14:36Z. `primecountpy.prime_pi`, `mp.dps 50`,
twelve bases, value window `[10^4, 2^32]`, depth window `d ∈ [3,8]`. Completed,
did not error. `results/small_angle_cross_base.json` +
`results/O48_small_angle_cross_base_run1.log`.

**Mechanical decision-rule output: `compromised`**, precedence branch 1, because
the control floor came out `0.754867` against the locked threshold `0.80`. The
verdict line is Julian's and is unfilled.

### The control is the defect, and it is mine

`round(b**(r/2))` does not survive the depth window. At `b = 1.15` the exact
per-depth gain is `0.0675`, so the mode decays to `4.3e−10` of itself by depth
8, while `round()` injects `±0.5` amplifying by up to `2` per difference —
`2^8 = 256`. So the control measured **noise doubling**, `≈ 2/log b`:

```text
b        2/log b   measured Ghat_ctrl   exact gain it should have read
1.1500    14.310         12.606                0.4829
1.3160     7.283          6.181                0.4672
2.0000     2.885          0.470                0.4226
```

That definition was written into the prereg in the edit **immediately before
locking**, replacing the looser "fitted the same way" phrasing, on the grounds
that it was too vague to implement. Sharpening it made it wrong. A v2 needs a
control that survives depth.

### What the run showed, EXPLORATORY — the verdict is compromised, so none of
### this earns one

**Inside the small-angle radius the transform tracks, from a prediction with
nothing fitted:**

```text
base      u/2π   measured   pred H1   ratio
1.1500   0.314    13.1303   11.5458   1.137
1.2293859 0.465    8.8724    9.1527   0.969
1.2560   0.513     8.0319    8.2953   0.968
1.2855907 0.565    7.5018    7.3356   1.023
1.3160   0.618     6.2766    6.3575   0.987
```

Four of five within 3%. That is entry 72's claim, holding where entry 72 said it
would hold.

**The null does not appear.** `D` at `1.5597432` is `1.0070` against a predicted
`0.3790`. The measured curve falls straight through the predicted null with no
feature: measured `3.9237` where the symbol gives `0.4483`, a factor `8.75`.
Beyond `u/2π = 0.62` the measured/predicted ratio runs 1.156, 1.507, 3.249,
**8.752**, 3.349, 1.385, 0.965 — the divergence is centred exactly on the
predicted null and closes again past it.

`argmin D` is `1.2293859`, γ₄'s candidate, at `0.8385` — but the control's own
`D_ctrl` at that same base is `0.8013`, so it is not a dip below the floor even
before the `compromised` branch fires.

Shape residual `RMS log(measured/predicted H1) = 0.8099`, dominated by the null
region.

### Two readings this run cannot separate

Either sub-leading modes fill the null — the prereg names this as the largest
doubt in advance, and γ₂'s null at `1.3483554` sits inside the same base set —
or the residual at depths 3–8 is not single-mode enough for any null to survive.
The clean tracking below `u/2π = 0.62` and the clean failure above it are
consistent with both.

Nothing is stamped. The prereg's Run record carries the same numbers and the
same unfilled verdict line.

---

## 2026-08-21 — Entry 72 — small angles make the curve: the cross-base transform, its Euler–Maclaurin cost, and why its radius is the pole lattice
type: motivation
refs: 69, 70, 71

**Julian's account, in his terms.** The b-adic tables are not separate objects.
Small angles are what create a curve, and that is what the explicit formula
does. So rather than build a table to infinite depth in every base, ask for the
**rate of change per cell across the b-adic tables** — or equivalently the
transform between them — and run that. That would give a formula for **when
local becomes global**, i.e. when the discrete table reaches the analytic
object, without ever taking a table to infinity.

He named the cost before I checked it: *"by summing averages we lose steps that
gets abstracted by the averaging, or turning the actual work of looking, where
something like our zero in a table makes the averaging work."* And the standing
goal: observe whether small shifts create big curves well enough to infer the
local data and construct a reliable approximation — here, of the zeta zeros.

**My check. The transform exists and is elementary.** All b-adic tables are one
object sampled at rate `h = log b`. Normalise a cell by `h^d`:

```text
cell_b(r,d) / (log b)^d   has symbol   ((1 − e^(−ρh)) / h)^d  →  ρ^d   as h → 0
```

base-independent in the limit. Between two bases the transform is exact with no
limit at all — just the ratio of symbols,
`((1 − b₁^(−ρ)) / (1 − b₂^(−ρ)))^d`, computable per cell.

**The cost is Euler–Maclaurin, literally.** The correction factor is
`(1 − e^(−u))/u` with `u = ρ log b`, whose expansion is the Bernoulli generating
function `u/(e^u − 1) = Σ Bₙuⁿ/n!`. Euler–Maclaurin's correction terms **are**
the steps lost when a sum is replaced by an integral. Julian named the cost from
the phenomenon; it has a name and a closed form.

**And the radius of convergence is `2π`, because the nearest singularity of
`u/(e^u − 1)` sits at `u = 2πi` — the pole lattice.** The same lattice
`Chain.sym_eq_zero_iff` proves (entry 69). So "small angles" is not a feeling.
It is `|γ log b| < 2π`.

```text
b        |γ₁ log b|    /2π
1.1175      1.5703     0.250    inside
√2          4.8987     0.780    inside
1.5597      6.2832     1.000    ON the line
2           9.7974     1.559    OUTSIDE
3          15.5286     2.471    outside
```

**Verified against the bench's own recorded numbers.** `γ₁·log 2 = 9.797445`,
and `9.797445 − 2π = 3.514260` — which is `ω₁` in `CONTEXT.md` § Core quantities
to six digits, folding to `2π − 3.514260 = 2.768926`, the recorded 2.7689. So
the small-angle boundary, the pole lattice, and Nyquist are **the same number**,
and O15's "raised the sampling Nyquist … clearing γ₁/γ₂/γ₃" and O45's *resolved*
stratum have been measuring it all along under a different name.

Consequence, derived rather than observed: inside one lattice cell the map
`ρ ↦ symbol` is injective and a single base can invert it; base 2 sits 1.56
cells out, so base 2 alone cannot recover γ₁. That is O18's "integer bases are
blind singly but not jointly," obtained from the radius rather than from a
periodogram.

**The base set is already built on this axis, which neither of us noticed.** The
O45 family is `log b_k = k · π/(2γ₁) = k · 0.111133`, so

```text
k = 4  ->  log b = 4 · 0.111133 = 0.444528 = 2π/γ₁  ->  b = 1.5597
```

and 1.5597 is the recorded family k=4 base. **k=4 is exactly the aliasing
threshold for γ₁**, with k=1,2,3 inside it and base 2 well outside. The locked
base set straddles the boundary this entry identifies, so the instrument for
testing it already exists and was locked on 2026-08-18 for a different reason.

**What is not established, and is the reason for a prereg rather than a claim.**
The transform above is exact for a single mode. A real cell is a smooth term
plus a sum over modes, and the transform acts mode-by-mode — so composite
transport is only as good as the decomposition. Whether the normalised cell
actually agrees across bases inside the radius and breaks outside it is a
measurement, not a corollary, and it is what
`preregs/small_angle_cross_base_v1_20260821.md` tests.

Nothing here is a result. This entry records the reasoning and the arithmetic
check that motivated a preregistered test.

---

## 2026-08-21 — Entry 71 — the two audit defects fixed, and the composition the chain was missing
type: formalization
refs: 68, 70

Fixes for the two findings entry 70 records as surviving. Entry 68 stands as
written; entry 70 carries the correction; this entry carries the repair.

**F1 — `Chain.tableFrom_mode` localised to the window.** The hypothesis was
`∀ n : ℤ`, which admits exactly `N ≡ 1` and `N n = (−1)^n`. It is now

```text
hag : ∀ k : ℕ, k ≤ d → ((N (r − k) : ℤ) : ℂ) = mode b ρ ((r : ℂ) − k)
```

the `d+1` entries a cell at `(r,d)` actually reads — the same form, and for the
same stated reason, as `PairIdentity.tableFrom_of_geometric`. The proof is now a
direct induction using `A1` at each step rather than routing through
`tableFrom_eq_bdiff_iter`, since that route needs global agreement.
`tableFrom_norm_on_critical_line` takes the same hypothesis.

**Verified non-vacuous by witness, because the build cannot see this.** The
geometric row `2^n` at `b = 2`, `ρ = 1` satisfies the localised hypothesis on the
window `(5,3)` reads — `32, 16, 8, 4` — and the theorem then gives
`cell = (Sym 2 1)^3 · 2^5 = (1/2)^3 · 32 = 4`, with
`tableFrom geoRow 5 3 = 4` confirmed independently by `decide`. Compiles. The
old hypothesis had no such instance at any base.

**F2 — `joint_gain_periodic_of_commensurate` gained `0 < m` and `0 < n`**, with
the docstring stating why: without them `m = n = 0` satisfies `hcomm` as `0 = 0`
for every pair of bases and the conclusion degrades to `Periodic f 0`, which
`period_vacuous_at_one` thirteen lines below proves is empty.

**And the composition the audit found missing —
`Superposition.tableFrom_eq_modeSum_reweighted`.**

```text
row agrees with modeSum at every integer
  →  (tableFrom N r d : ℂ) = modeSum b ρ (fun i => c i * (Sym b ρᵢ)^d) s r
```

Two lines: `Chain.tableFrom_eq_bdiff_iter` carries the integer table onto
`bdiff^[d]`, `depth_reweights_each_mode` carries that onto the reweighted sum.
Both existed; nothing composed them, and entry 70's grep confirmed `modeSum` and
`tableFrom` occupied disjoint sets of modules.

**Here the global hypothesis is correct and non-vacuous, and that distinction is
the whole content of the fix.** A single mode forces `w = ±1` on an integer row.
A sum does not: only the total need be integer-valued, and no individual
`cᵢ·wᵢ^n` is constrained. Conjugate pairs — `ρ₂ = −ρ₁` with `c₁ = c₂ = 1/2`,
giving `Re(wⁿ)` — are integer at every `n` with neither mode `±1`, which is how
Riemann–von Mangoldt makes a real integer row out of non-real modes. **This is
the theorem O34/O35 were measuring against** when they reported 94% / 92% / 80%
of the row-20 residual at depths 0, 3 and 6.

So entry 68's chain diagram is now true of a theorem that exists, and it runs
through `Superposition`, not through `tableFrom_mode`.

**What verified this, and what could not.** No axiom pin moved — every theorem
touched is ℂ-valued and was already at `[propext, Classical.choice, Quot.sound]`.
The build could not see either defect and cannot see either fix. What checks F1
is the witness above; what checks F2 is reading the hypothesis. `Chain.lean`
says this about itself in `gain_sq_periodic`'s docstring, and entry 70 is the
first time that gap was exercised rather than noted.

**Sequencing defect in this entry's own commit.** The Lean fixes landed at
`0f64663`, whose message announces "Entry 71" — this entry — while the entry
itself was not in the working tree, lost to a wrong-directory write. The commit
is therefore accurate about the code and premature about the record, and this
entry is committed separately after it. Recorded rather than amended: the same
reason entry 68 was left standing.

Build clean, 8037 jobs, 133 theorems, 133 pins, parity in all 11 modules. Gate
unchanged at 2, `check_values` 83 confirmed / 0 mismatches.

---

## 2026-08-21 — Entry 70 — blind adversarial audit of Chain.lean, three rounds: two real defects, both in entry 68's material, and four findings the audit itself retracted
type: result-triage
refs: 68, 69

**Method.** A subagent with no memory of the session that wrote `lean/Chain.lean`
audited it against `papers/Euler-Factor-Chain.md`. Three rounds: it reported,
then I attacked its findings, then I required it to reverse stance and argue the
file is better than it said. Read-only throughout, no fixes proposed — findings
only. Blindness is the point: it has no investment in having been helpful.

**Entry 68 is left as written.** This entry carries the correction. Rewriting a
dated entry to hide what it got wrong would defeat what the notebook is for.

---

### What survived, and it is mine

**F1 — `Chain.tableFrom_mode` does not reach the dyadic table.** Staked on by
the auditor over everything else.

`tableFrom_mode` (`Chain.lean:320`) takes
`hag : ∀ n : ℤ, ((N n : ℤ) : ℂ) = mode b ρ (n : ℂ)`. Since
`mode b ρ n = w^n` with `w = (b:ℂ)^ρ`, the hypothesis at `n = 1` puts `w` in ℤ
and at `n = −1` puts `w⁻¹` in ℤ; an integer whose inverse is an integer is `±1`.
**The hypothesis class is exactly two rows: `N ≡ 1` and `N n = (−1)^n`.** On the
critical line with `b > 0`, `|w| = b^(1/2) = 1` forces `b = 1`, where `Sym` is
identically zero.

I challenged this on branch cuts — `(b^ρ)^n` for complex `cpow` is not free. The
challenge failed and the finding got **stronger**: the outer exponent is an
integer, so it is `zpow`, and `Complex.cpow_int_mul`
(`Mathlib/Analysis/SpecialFunctions/Pow/Complex.lean:100`) has **no hypotheses at
all**, not even on `arg`. So F1 covers exactly the `b ≠ 0` the theorem states.

**And this tree already states the criterion and satisfies it elsewhere.**
`PairIdentity.lean:76-80`:

> The hypothesis is deliberately local. **No total function `ℤ → ℤ` satisfies
> `G r = b · G(r−1)` at every `r` except `G = 0`, so a global geometric
> hypothesis would be vacuous.** What a cell at `(r,d)` actually reads is the
> window `r, r−1, …, r−d`.

`tableFrom_of_geometric` takes the window-local form and is non-vacuous.
`tableFrom_mode` takes the global form. Met in one module, walked into in the
next — the auditor's words: *"I am not importing an outside standard; I am
reporting that one written in this tree was met in one module and not in the
next."*

**Consequently entry 68 is false where it is most load-bearing.** Its line
*"The hypothesis is not hypothetical for the dyadic row"* is true of a
superposition and false of `tableFrom_mode`, which is the theorem the chain
diagram there runs through. My second challenge did establish that the
**sum-level route is open** — per-summand integrality does not bite when only
the sum must be integer-valued, witness `ρ₂ = −ρ₁`, `c₁ = c₂ = 1/2`, giving
`(iⁿ + (−i)ⁿ)/2 = Re(iⁿ) ∈ {1,0,−1,0}`, which is how Riemann–von Mangoldt makes
a real integer row out of non-real modes. But that route is **unwritten**:
verified by exhaustive grep, of 11 modules, `modeSum` occurs in
`Superposition.lean` only and `tableFrom` in five others, and the two sets are
**disjoint**. `Superposition.lean:12` is `import Chain`, so the dependency runs
the wrong way. Entry 68 cites a legitimate route no theorem takes.

**F2 — `joint_gain_periodic_of_commensurate` has no `0 < m`.** At `m = n = 0`
the hypothesis `hcomm` reads `0 = 0`, satisfied by **every** pair of bases
including incommensurate ones, and the conclusion is `Periodic f 0`. I tried
four ways to break this and could not; `Function.Periodic.nat_mul`
(`Mathlib/Algebra/Ring/Periodic.lean:131`) has no `n ≠ 0`. The theorem is true
and has real instances; the defect is that **`hcomm` is not a commensurability
condition**, so the theorem does not carry the content its docstring and
`second_ladder_winds_densely`'s back-reference attribute to it. This is the trap
`period_vacuous_at_one` proves, thirteen lines below, un-closed.

**F8 — the inert `hA4` also silences the linter**, settled from the linter's
source rather than by analogy: `linter.unusedVariables.funArgs` defaults **true**
so signature binders are flagged, `analyzeTactics` defaults **false** so a dead
`have` is invisible. Effect confirmed; the auditor withdrew any imputation of
intent, the docstring disclosing the inertness in plain words.

**Minor and disclosed:** `StmtC2` encodes one of paper C2's three conjuncts
without saying so (the periodicity conjunct is now `gain_sq_periodic`, 300 lines
away); the file header's "every theorem here takes the antecedent statements as
HYPOTHESES" describes about 6 of 25; `Chain.h` duplicates `EulerFactorChain.h`
byte-for-byte with nothing enforcing it.

---

### What the audit retracted, and why it matters

**F4 demoted by its own steelman — and this bears on handoff item 1c.** Round 1
found `StmtB5` and `StmtB4` provably equivalent modulo `norm_pow` and called it
"drops the depth side." Required to argue the other case, it conceded:
`(Sym b ρ)^N` **is** the depth side, named rather than unfolded — it is
precisely the multiplier `StmtA4` says `bdiff^[N]` applies. Writing
`bdiff^[N] (mode …)` in would drag `‖mode‖` onto both sides and turn an identity
about a **weight** into one about a **ratio**. What survives is narrow: the
docstring says `hA4` mirrors "the paper's stated dependency," and paper B5 cites
`A1 + B4` (`Euler-Factor-Chain.md:46`), not A4 + B4. **So the handoff plan's
"most serious defect" is milder than recorded there.**

**F3 retracted, and it exonerates the paper's structure.** `StmtA3`'s first
conjunct is definitional — `EulerFactorChain.sym_natCast` is `by simp [sym]` —
so `A4_of_A1` is the honest arrow and the paper's `A3 ·` citation is the loose
one. The auditor also withdrew, as outright false, its claim that nothing
carries the Euler-factor reading onto the critical line: `Chain.lean:70` is
`∀ s : ℂ`, unrestricted. It had quoted the disproving line in round 1.

**F6 retracted, and it exonerates the paper's arithmetic.** The exponents differ
by exactly one because **the depth-0 row is itself already one difference of π**.
`CONTEXT.md:91-96`: the block holds `(b−1)b^(r−1)` slots and each difference
multiplies by `(b−1)/b`, giving `(b−1)^(d+1)b^(r−1−d)` — the `d+1` is `1` for the
row plus `d` for the depth. The paper counts relative to π; Lean counts relative
to the row; both internally correct. What remains is that Chain.lean never says
which frame it is in and names its binder `N`, the paper's symbol for the other
frame.

---

### The bias check

Round 3 required the auditor to argue against itself. It named four places its
adversarial framing manufactured a defect, the sharpest being F3: it **quoted
the docstring that disproved its own finding** and argued past it, and asserted
the critical-line claim with `∀ s : ℂ` on screen. *"An adversary who has found a
'disconnected component' narrative stops checking, and I did."* On F6: the frame
was in a file it had read in full, *"because 'off-by-one between paper and Lean'
is a satisfying find."* On two others: prose notes promoted to findings because
an empty rubric slot reads as a failed audit.

**This is the reason for three rounds rather than one.** A single pass returns
ten findings and no way to tell which four are artifacts of being paid to find
some.

### What the file does well, from a reviewer with no reason to be kind

`period_vacuous_at_one` exists solely to prove a neighbouring hypothesis is
load-bearing, and correctly names the axis `#guard_msgs` cannot protect.
`C3lower_of_A4_C2` drops `0 < b` because the proof does not consume it, with the
rationale written down. `StmtC3lower` uses `|·|` because the unbarred form,
though true, is contentless for `0 < b < 1`. `StmtA3` volunteers its own negative
scope unprompted. And **`StmtA2` is more honest than the paper it formalises** —
paper A2 states the Euler product with no convergence condition, which is false
as written; the Lean carries `1 < s.re`.

### Standing

Two real defects, both in entry 68's material, both introduced 2026-08-20, and
**both invisible to the build** — `Chain.lean:396-397` says why: `#guard_msgs`
pins an axiom list and a near-vacuous theorem has an ordinary one. Both are
pinned and both pins pass.

Lean fixes follow in a separate entry. Nothing above is a fix; this entry is the
record of what the audit found.

---

## 2026-08-21 — Entry 69 — the circle comes from the pole lattice, and the fold is now an identity on cells
type: formalization
refs: 33, 55, 60, 68

Entry 68 built the torus and never said where it came from. Both ends of the
chain were loose: the circle had no origin, and the fold existed in Lean only as
facts about the stencil's *weights*, never about a cell. Six theorems close both.

**The pole lattice — `Chain.sym_eq_zero_iff`.**

```text
Sym b s = 0  ↔  ∃ k : ℤ, s = k · (2πi / log b)
```

These are the poles of `1/Sym`, the reciprocal Euler factor. It is the
`2πik/log 2` lattice of Flajolet, Grabner, Kirschenhofer, Prodinger and Tichy
(`papers/literature/litsearch_1_hinge.md` § 3), and it is the lattice
`EulerFactorChain.lean:112` already excludes in prose — *"it excludes the whole
`sym b s = 0` lattice"* — without ever stating it.

**`Chain.sym_periodic`** — `Sym b (s + 2πi/log b) = Sym b s`, because
`b^(−2πi/log b) = exp(−2πi) = 1`. The symbol returns to itself after one lattice
step. **That is the origin of the circle**: `γ` is an angle because the symbol's
own zero set is a lattice of that spacing.

**`gain_sq_periodic` rewritten to derive from it.** Entry 68 proved the same
period from `Real.cos_add_two_pi` — true, and the symptom. The cause is the
lattice. Same period, correct derivation, and the torus now has a reason inside
the chain rather than beside it in the record.

**The fold, on cells — four theorems in `Zeros`.**

```text
wingPlus  / wingMinus            the even- and odd-index arms, unsigned
stencil_eq_wings                 stencil N g = wing⁺ − wing⁻      an IDENTITY
stencil_eq_zero_iff_wings        stencil N g = 0 ↔ wing⁺ = wing⁻
tableFrom_eq_zero_iff_wings      cell = 0 ↔ the window's wings balance
repeat_iff_wings                 the repeat reading = the fold reading
```

`stencil_weights_antisymm`, `stencil_arms_eq` and `stencil_arm_doubled` were
already there but are about the **weights**. Nothing split an actual cell by
parity. `papers/The-Fold.md` § B calls the arms the wings — 807295 each at
`(20,6)`, 168 each at `(8,3)` — and entry 55 records that the fold is an
identity, `wing⁺ − wing⁻ = cell`, true everywhere. It is now that in Lean.

**`repeat_iff_wings` is the bridge that did not exist.** `zero_iff_repeat` says
a cell vanishes iff the row repeats one depth below. The fold says it vanishes
iff the wings balance. Both were in the tree; nothing connected them. They are
one statement, and the connection runs through entry 60's stencil equation.

So the two readings of a zero — `(20,6) = 0` because `d5` reads 623 at both
`r = 19` and `r = 20` (`The-Fold.md` § C1), and `(20,6) = 0` because the wings
weigh 807295 each — are now provably the same fact.

Build clean, 8037 jobs, 132 theorems, 132 pins, parity in all 11 modules. Gate
unchanged at 2, `check_values` 83 confirmed / 0 mismatches.

**Still outside Lean, named so it is not searched for again.** The zeros-as-poles
reading of entry 33 and `The-Four-Zeros.md` § E3 — the ratio `composite/prime`
singular at exactly the four cells — is prose only; `pole` and `ratio` occur
nowhere in `lean/` in that sense. And `lean/BUILD.md` still records block D (the
winding) and block G (the transform radius, the annulus of modulus `(log b)/4π`)
as observations. Block G is the z-plane route to the same circle, so one of the
object's two coordinates remains unformalised.

---

## 2026-08-20 — Entry 68 — the seam welded: tableFrom IS bdiff, and the chain runs from the integer table to the torus
type: formalization
refs: 59, 60, 61, 66

**The defect.** `lean/Chain.lean` proved things about `bdiff` on `ℂ → ℂ`.
`lean/Construction.lean` proved things about `tableFrom` on `ℤ → ℤ`. They are
the same backward difference on two domains, and **no theorem in the tree joined
them.** So the formalisation read as two stacks with prose between, not one
chain. Nothing was wrong; nothing was connected.

**Seven theorems, all landed in `Chain.lean`, which now also imports
`Construction`.**

*The weld.*

```text
tableFrom_eq_bdiff_iter   g agrees with N at every integer
                          -> (tableFrom N r d : ℂ) = (bdiff^[d]) g r
tableFrom_mode            + A4  ->  cell = (Sym b ρ)^d * mode b ρ r
tableFrom_norm_on_critical_line   the modulus form C2/C3 bound
```

`tableFrom_mode` is `StmtA4` read on the integer table. After it, every arrow
below the seam applies above it: an integer cell of the dyadic table is an
object the analytic half of the file has theorems about.

*The circle — this closes handoff item 1b.*

```text
gain_sq_periodic       Periodic (fun γ => ‖Sym b (1/2 + γi)‖²) (2π / log b)
period_vacuous_at_one  at b = 1 the same statement holds for EVERY f
```

`EulerFactorChain.gain_sq_on_critical_line` already had the content — the gain
depends on `γ` only through `cos(γ log b)` — so `γ` is an angle, not a line, and
the gain closes after `2π / log b`.

**`b ≠ 1` is load-bearing and the second theorem proves it.** At `b = 1` the
period is `2π/0 = 0`, and `Function.Periodic f 0` is true for any `f` at all —
so the unguarded statement is true and empty exactly at the degenerate base.
`period_vacuous_at_one` is that fact, compiled. **`#guard_msgs` cannot catch
this**: a vacuous theorem has an ordinary axiom list. The handoff flagged the
risk; it is now a theorem rather than a warning.

*Two ladders.*

```text
joint_gain_periodic_of_commensurate   m·P₁ = n·P₂  ->  joint gain periodic
                                      in ONE variable: the circles collapse
second_ladder_winds_densely           steps dense on the b₁-circle
                                      <-> log b₁ / log b₂ irrational
```

The second is Kronecker, via `AddCircle.denseRange_zsmul_coe_iff`. Together they
are the dichotomy: **commensurate ladders close into one circle, incommensurate
ones fill a torus**, and the whole content is whether the ratio of logs is
rational. The first is entry 54 and 56's trap stated as a theorem — a base set
commensurate by construction forces cross-base alignment rather than finding it.

*The inversion was already there*: `EulerFactorChain.h_functional_equation`,
`h b N (1 − s) = h b N s`, whose fixed set is the critical line.

**So the chain is now unbroken and is one object:**

```text
the table                 Construction         ℤ, no axioms
cell = Pascal             entry 60             tableFrom = stencil
tableFrom = bdiff^[d]     HERE                 the seam
cell = Sym^d · mode       HERE                 via A4
dia/col = √b              entry 61
period 2π/log b           HERE                 the circle
commensurate | torus      HERE                 Kronecker
s ↦ 1 − s                 h_functional_equation
```

All seven at `[propext, Classical.choice, Quot.sound]`. That is the floor and it
is correct: every statement mentions ℝ or ℂ. Entry 66's boundary reads exactly
right here — the table above the seam is axiom-free, everything below it is not,
and the seam is where the arithmetic becomes analytic.

**Gotcha worth recording.** `Chain.Sym` collides with Mathlib's `Sym`, the
symmetric-power type. Unqualified inside a file that opens Mathlib it silently
resolves to Mathlib's and the errors are about universe levels, not about `Sym`.

**On the hypothesis form.** `tableFrom_mode` takes "the row agrees with a mode"
as a hypothesis. That is this file's method, not a gap in it — see its header,
lines 9–12: every theorem here takes the antecedent statements as hypotheses and
derives the consequent, so that Lean can refuse a leap. A hypothesis is a
quantifier, not an assumption: the theorem is a complete, kernel-checked proof
about every row of that kind. The `A4` it calls is itself unconditional
(`Chain.lean:263`), as C1 became when it was discharged.

**What the chain shows.** The hypothesis is not hypothetical for the dyadic row.
`Superposition.lean` exists precisely to license A4 on a **sum** over zeta zeros
— its header: *"Every use of it on the bench applies it to a SUM over zeta zeros
(O34, O35). Nothing so far permits that step. This file supplies it."* And the
decomposition is measured: `CONTEXT.md` § O34/O35 — **94% of the row-20 residual
at depth 0, 92% at depth 3, 80% at depth 6, from the explicit formula alone,
nothing fitted.**

So with the weld in place the chain reads end to end on the actual table:

```text
cell(r,d)                      integer, computed from π
  = (bdiff^[d]) on the row     tableFrom_eq_bdiff_iter, here
  the row is a superposition of modes b^(rρ)      explicit formula
  ρ = 1/2 + iγ, the zeta zeros                    O34/O35, 94/92/80%
  each mode reweighted by (Sym b ρ)^d             Superposition
  ‖Sym‖ inside [1−b^(−1/2), 1+b^(−1/2)]           C2, C3, C3lower
  phase periodic in γ with period 2π/log b        gain_sq_periodic, here
  two ladders: one circle, or a torus             Kronecker, here
  s ↦ 1 − s fixes the critical line               h_functional_equation
```

**Every cell of the dyadic table is a sum over the zeta zeros, each reweighted
by its own factor at depth `d`.** That is the mechanism, it is measured at
80–94% across depths 0 to 6, and every algebraic step in it is now a
kernel-checked theorem rather than a "therefore" in prose.

**What is underived, stated narrowly.** The chain gives the weight each zeta
zero carries into a cell. It does not say when that weighted sum — main term
included — lands on integer `0` exactly. Four cells do. Why those four is not
derived by anything here.

**And one measured limit, which is a result and not a caveat.** O34/O35 do not
extend to deep cells: at `(25,21)` the model flips sign between 200 and 600
zeros, because the depth operator spreads each zero's gain over `(d+1)×0.765`
decades. So the 80–94% agreement is established at depths 0–6 and the method
runs out below that — measured, in `CONTEXT.md` § O34/O35, not assumed.

Build clean, 8037 jobs, 126 theorems, 126 pins, parity in all 11 modules.

---

## 2026-08-20 — Entry 67 — the 12 oversized NOTEPAD lines truncated, and the gate baseline re-cut to 2
type: instrument-fix
refs: 63, 64, 65

Julian approved. `check_refs.py` had flagged 12 NOTEPAD lines over the 400-char
limit, 479 to 2944 chars against a median of 132. Ten cited an entry holding the
same text verbatim and could be shortened outright. **Two cited nothing**, so
truncating them would have destroyed the only copy — those were backfilled first
as entries 64 and 65, then shortened to point at them.

All 12 now carry `entry N:`. Longest thread line is 357 chars, under the limit.
No status transitions: every one is still `[open]`.

**The gate went from 14 broken references to 2**, and
`utilities/refs_baseline.txt` was re-cut to match. What remains is the two
declared-PENDING references in `papers/The-Composite-Arm.md` — its own header
lists them as conditions of becoming canonical, and they close when the t25
composite-arm script is written. (Naming that file here would itself be a
broken reference — the checker caught exactly that on the first draft of this
entry.)

Prior results comparable: no reference resolved differently, `check_values.py`
unchanged at 83 confirmed / 0 mismatches, `lake build` clean at 8037 jobs.

---

## 2026-08-20 — Entry 66 — SeedPerturbation and PairIdentity off Mathlib; the floor is 60, not 0
type: formalization
refs: 59, 60, 61

Continuation of entry 59, which did `Construction`. Same method, two more
modules, plus the measurement that bounds how far this can go.

**Result.** `Classical.choice` fell 84 → 71 across the tree.

```text
                    before   after
SeedPerturbation      10        0     20 theorems, no Mathlib surface at all
PairIdentity           4        0     symbol_at_one moved out; see below
```

`SeedPerturbation.tableFrom_eq_zero_of_vanishing_above` — the gating theorem for
the seed protections — is now `[propext]`, from all three. Entry 59 predicted
this file would port cleanly and it did. It also builds in **340 ms** instead of
~10 s, because there is no Mathlib to load.

**`symbol_at_one` moved to `EulerFactorChain`.** It was `PairIdentity`'s only
ℂ-valued statement and is a restatement of
`EulerFactorChain.symbol_of_backward_difference` at `ρ = 1`, so it belongs where
`sym` lives. Checked first that no paper cites it — only entry 45 does, by bare
name, which still resolves.

**`grind` is not a shortcut, and this is the load-bearing measurement.** Lean
core ships `grind`, and it discharges the `ring`-shaped ℤ goals that `ring`
was doing. Measured in a Mathlib-free file: **`grind` costs
`[propext, Classical.choice, Quot.sound]`** — all three, with no Mathlib
present. So it defeats the entire purpose, and every `ring` had to be replaced
by a hand chain of core `Int.` lemmas.

Also Mathlib-only, and each needing a core rewrite: `by_contra` (replaced by a
`match` on `(by omega : 1 < b - 1 ∨ b = 2)`), `rcases` (`match`), `ring_nf`,
`linarith`, `nlinarith` (replaced by `Int.mul_lt_mul_of_pos_left` plus
`Int.mul_one`), `norm_num`, `push_cast`, `pow_pos`, `mul_right_cancel₀`,
`mul_eq_zero`. `omega` stays — measured at `[propext, Quot.sound]`, no
`Classical.choice`.

**The floor is 60 of 119, and it is not a defect.** Of the 71 remaining, 60
mention ℝ or ℂ, and Mathlib constructs ℝ with `Classical.choice`, so no proof
style removes it:

```text
Chain 16 · EulerFactorChain 16 · Measured 7 · Covering 6 · Crossover 6
GeneratorPeak 6 · Superposition 3            = 60, permanent
Zeros 11                                     = the only portable remainder
```

**`Zeros` is mixed and was not attempted.** Of its 11: six are the `stencil`
theorems, which need `Finset.range` replaced by a fold; four
(`factorization_proportional`, `primeFactors_eq_of_meets`, `base_of_meets_two`,
`window_exclusive_of_prime_exponent`) rest on Mathlib's prime-factorization
theory and are not portable at any reasonable cost; and one is entry 60's
`tableFrom_eq_stencil`, which took the `fwdDiff` bridge precisely because the
direct induction was harder. So the realistic floor is **64**, not 60, unless
`Zeros` is split. That is an architectural call and is Julian's.

Build clean at 8037 jobs, 119 theorems, 119 pins, parity in all 11 modules.

---

## 2026-08-19 — Entry 65 — figures/coverage.png had no script either; t15 reconstructs it, and finds one transcription slip
type: provenance
refs: 64

Backfilled 2026-08-20 from the NOTEPAD line that held this record, so the line
could be shortened without losing its only copy. Same situation as entry 64 and
recorded separately because `coverage.png` is **not** among that entry's six.

`figures/coverage.png` was committed at `3da2ee8` with **no script** — its
analysis was inline too. Reconstructed as
`analysis/2026-08-19_table_structure/scripts/t15_cell_coverage.py`, which
**postdates the result it reproduces**, exactly as t9–t14 do.

**Reproduced.** Every per-base mean, zero-mean and z, to printed precision.

**One disagreement, and it is a transcription slip rather than a computational
difference.** Base 6's per-zero counts are `[0, 1, 2, 2]`, not the reported
`[0, 1, 1, 3]` — and `[0, 1, 1, 3]` is **base 7's** list. Both sum to 5, so the
mean 1.25 and the z −1.04 were unaffected, which is why it went unnoticed.

**The kill reproduces.** Maximum distinct coverage values at any fixed depth is
2, across all 224 depth-base pairs, because the window's width in b-rungs is
`(d+1)·ln2/ln b` — a function of `d` ALONE.

**Corroboration.** The zeros' mean depth has z = −0.99, the same ≈ −1.0 that the
coverage z gives at every base. So coverage's z **is** the depth z.

---

## 2026-08-19 — Entry 64 — six analyses ran inline with no script saved; t9–t14 reconstruct them, and two do not fully reproduce
type: provenance
refs:

Backfilled 2026-08-20 from the NOTEPAD line that held this record, so the line
could be shortened without losing its only copy. Nothing here is new work; it is
the same text, given an entry to live in.

Six analyses reported on 2026-08-19 were run **inline as heredoc commands with
no script saved**, so the results predate any reproducible instrument.
Reconstructed as `analysis/2026-08-19_table_structure/scripts/`
`t9_subthreshold_ladder.py`, `t10_blocksum_lowpass.py`,
`t11_decimation_alias.py`, `t12_chain_vs_orphan.py`, `t13_signflip_crossover.py`,
`t14_s_matched_control.py`, and re-run.

**The scripts postdate the results they reproduce** — mtimes 12:23–12:25 against
a session that ended at 12:09. They are reconstructions from the reported
numbers, not the code that produced them.

**Ordering evidence**, from file mtimes: 11:01 `shape32.py`, 11:35
`t5_2d.py`/`spectrum2d.png`, 11:41 `t6_multirate.py`/`multirate.png`, 12:03
`coverage.png` (its analysis was inline too, no script survived, and it is NOT
among the six — see entry 65), 12:06 `t7_phase.py`/`phase.png`, 12:09
`t8_subzeros.py`. The six inline analyses fell between those marks and their
exact times are **not recoverable**; the interleaving above is the only
chronology there is.

**What reproduced.**

* **t10** exact — base 4 = dyadic in pairs True, base 8 in triples True,
  Dirichlet 0.1853 / 0.2876 / 0.1725 at ω 2.7689, four zeros at exactly
  `(2,1) (4,1) (8,3) (20,6)` for merge k=1 and 0 for k=2..6 at 2^48.
* **t11** exact — `fold(k·parent alias) = direct alias` to ≤ 1.8e−15 for bases
  4/8/16/9/27 at 0.7453 / 2.0236 / 1.4907 / 0.3588 / 2.6035; base 9 at 0.86
  cycles.
* **t12** exact — 0.5197–0.5346 across bases 2–9 at 2^48, orphan mean 0.5242,
  chain mean 0.5321, where "chain" is the three bases WITH a parent (4, 8, 9),
  not the five in any chain; 2 and 3 are roots at 0.5253.
* **t13** exact — dyadic flip crossover d=7 matching t2's spectral 7, triadic 12
  against spectral 10, bases 4–9 flat 0.00 at every depth, invariant for
  MIN_ROW 3..8.
* **t14** within Monte Carlo error — observed 26.744 exact, matched null
  25.724±0.744 against a reported 25.731±0.747, i.e. 1.3 MC standard errors;
  z +1.37 vs +1.36, p 0.915 vs 0.909. Its S recomputation by the Pascal
  recurrence matched `results/sub_integer_base_scan.json` at all 121 zeros, 0
  mismatches.

**What did not.** t9's *structure* reproduced exactly — rung counts
142/186/233/248/286/317/358, Nyquist 17.23/22.48/28.28/30.10/34.62/38.51/43.44,
and every base recovering exactly the zeros beneath its own ceiling — **but 6 of
the 7 recovered γ values differ in the third decimal**: 21.021 vs 21.022, 25.018
vs 25.016, 30.448 vs 30.449, 32.927 vs 32.924, 37.644 vs 37.645, 40.934 vs
40.933; only 14.141 identical. Differences reach 0.003 against a periodogram
resolution element of 0.243 rad, so agreement is well inside resolution — but
the exact digits are **not** reproduced, and the inline original must have
differed in some detail. The grid was tested at four spacings and all give the
same peaks to 0.003, so it is not the grid.

**Also unrecovered.** t9 finds γ₈ = 43.3271 beneath base 1.0750's Nyquist 43.44,
with its peak at 43.565 — ABOVE the ceiling — which the reported table did not
list. Nothing was tuned to close any gap.

---

## 2026-08-20 — Entry 63 — six NOTEPAD lines were inside the header's own format example; the trap removed and the checker taught to see it
type: instrument-fix
refs: 53, 54, 55, 56, 57, 58

**What was wrong.** `notes/NOTEPAD.md` opened with a `Format (strict, for grep):`
block whose fenced example contained
`- [STATUS] YYYY-MM-DD  entry N: terse one-line description` — a line shaped
exactly like a real thread. Six lines, citing entries 53 through 58, had been
prepended "to the top of the file" and landed **inside that fence**, above the
template line, instead of under `## Threads`.

**Why nothing caught it.** `check_refs.py` reads NOTEPAD.md raw rather than
fence-stripped, so the six were length-checked and format-checked and passed
both — they are well-formed lines in the wrong place. **The checker had no
notion of place.** `CLAUDE.md` § Rule — load, don't recall already names this
file as one that "contains examples of itself", and the rule did not prevent it,
because a rule you have to remember at write time is not a check.

**Root cause is duplication, not carelessness.** `notes/notes_format.md:39`
says the NOTEPAD format is system-wide, lives at `~/GitHub/NOTEPAD_TEMPLATE.md`,
and is "Not restated here." NOTEPAD.md restated it anyway — a third copy of a
spec that already existed twice, and the copy is what people fall into.

**Three changes, Julian approving each.**

1. The `Format (strict, for grep):` fence and its `STATUS is one of:` line
   deleted from `notes/NOTEPAD.md`, replaced by a pointer to
   `~/GitHub/NOTEPAD_TEMPLATE.md`. The `Common greps` fence stays — nothing has
   ever been prepended into it, because it does not look like entries.
2. The six lines moved into `## Threads`, immediately below entry 59's, in their
   existing order. **Content byte-identical; no status transitions.** Relocation
   only — every one of them is still `[open]`.
3. `utilities/check_refs.py` now tracks whether it has passed the `## Threads`
   heading, and reports any `- [status]` line above it as BROKEN.

**Tested in both directions.** A line planted above `## Threads` is caught —
`BROKEN NOTEPAD.md -> line 9 is above "## Threads"`. On the repaired file the
check is silent.

**Prior results comparable.** The baseline diff is empty: 14 broken references
before and after, the same 2 declared-PENDING plus 12 oversized lines. The six
moved lines were under 400 chars and already passing every other check, so no
count moved. `check_values.py` unaffected — it reads `papers/` only.

**Still open, not fixed here.** The 12 oversized NOTEPAD lines, and the fact
that entries 53, 55, 56, 57 and 58 carry the date 2026-08-21 against commits
timestamped 2026-08-20. Both are Julian's to decide; the dates in particular
cannot be corrected by an agent without changing the dated record.

---

## 2026-08-20 — Entry 62 — the joint cross-base test has never been run on the exact zeros, only on the gammas
type: motivation
refs: 49, 52, 54, 56

**Scope observation, from Julian.** Entry 52's `(40,12)` result was cited in
conversation as evidence that the four exact zeros are not a feature of any
cross-base structure. That citation is too broad, and the entry's own text says
why: the test was at `b = 2^(1/2)`, where `(40,12)` is "the exact image of base
2's `(20,6)` under factor-2 refinement: `r` doubles, `d` doubles."

`(√2)^(2r) = 2^r`. Base 2 is every other rung of the √2 ladder. So entry 52
tested **resolution**, not **coupling** — whether the zero survives sampling the
same ladder finer. It does not, and that stands. It is not a test of whether
structure runs between ladders that are independent of each other.

**The gap.** Two designs exist in the tree and have never been combined:

* O18 coupled incommensurate ladders and it worked. Base 2 alone NULL, base 3
  alone NULL, the joint orbit `{2^m 3^n}` detecting γ₂ at P/median 6.95, three
  generators reaching γ₄. `CONTEXT.md` § O18. **Object: the γ's.**
* O44 scanned the exact zeros across bases 2–9, 1289 pair-identity cells, and
  found only base 2 has any (entry 49). **Method: one table at a time.**

O18's whole lesson was that "blind singly" and "blind jointly" are different
questions. For the exact zeros only the first has been asked.

**Why it is not a straightforward test.** A γ-detection is a spectral statistic
computable on any orbit; an exact zero is an integer cell in one table. "Joint"
needs a construction producing one number from two ladders. O44's pair-identity
scale coordinate is one candidate already in the tree.

**The trap this design walks into.** Entry 56 and entry 54: eight of O45's
eleven bases are exact multiples of `π/(4γ₁)` in log, commensurate *by
construction*, carrying 107 of 125 zeros — so cross-base alignment was forced by
the base choice rather than found, and entry 54 records the surface question as
unanswerable with that base set. Any joint design must fix its base set against
commensurability first or it measures its own arithmetic.

**Not evidence it would find anything.** O44's base-by-base answer was a clean
no. This entry records that a question is unasked, which is not a prediction
about its answer. No test proposed, no prereg, nothing run.

---

## 2026-08-20 — Entry 61 — the diagonal gain is `√b`, derived rather than measured
type: formalization
refs: 45

`analysis/2026-08-19_table_structure/CHAIN.md` lines 1360-1370 record
`dia/col = 1.414214` against `sqrt(b) = 1.414214`, 615 cells, 0 failures, with a
prose derivation: along a diagonal `r − d = c` a mode picks up
`b^(cρ)·[b^ρ − 1]^d`, so the per-step factor is `b^ρ − 1` rather than the
column's `1 − b^(−ρ)`, and the two differ by exactly `b^ρ`.

**`sqrt` and `b^(1/2)` occur nowhere in `lean/`.** Checked across all eleven
modules. `PairIdentity.exponent_const_on_diagonal` and
`PairIdentity.total_const_on_diagonal` prove the diagonal is the trend's level
set and that this is unique to `b = 2`; neither says anything about the gain
ratio. The measured fact had no formal counterpart.

**Four theorems, drafted and compiling.** Against `EulerFactorChain.sym b ρ =
1 − b^(−ρ)`:

```text
diagonal_gain               b^ρ * sym b ρ = b^ρ − 1
diagonal_cell               b^((d+c)ρ) * (sym b ρ)^d = b^(cρ) * (b^ρ − 1)^d
diagonal_over_column        (b^ρ − 1) / sym b ρ = b^ρ          (sym b ρ ≠ 0)
diagonal_over_column_at_half  b^(1/2) = √b                     (0 ≤ b)
```

All four at `[propext, Classical.choice, Quot.sound]`. That is the floor, not a
defect: the statements are ℂ-valued, and ℝ is constructed with `Classical.choice`
in Mathlib, so no proof style removes it. Compare entry 59 — the split is real.

`diagonal_gain` needs only `b ≠ 0`; the `√b` specialization needs `0 ≤ b`.
Route: `Complex.cpow_add`, `Complex.cpow_nat_mul`
(`Mathlib/Analysis/SpecialFunctions/Pow/Complex.lean:109`), `Real.sqrt_eq_rpow`
and `Complex.ofReal_cpow` (`.../Pow/Real.lean:984` and `:278`).

**Not in the tree.** Draft at the session scratchpad as `diagonal_gain.lean`;
landing it means editing `lean/EulerFactorChain.lean` and adding four
`#guard_msgs` pins, which was not done. What is recorded here is that it
compiles, not that it is committed.

---

## 2026-08-20 — Entry 60 — the operator IS Pascal: `tableFrom = stencil`, and the zeros as one line each
type: formalization
refs: 45, 52, 59

`lean/Zeros.lean:88` defines `stencil N g = ∑ k ∈ range (N+1), (−1)^k C(N,k) g k`
and proves it linear, antisymmetric, and constant-annihilating. **No theorem
connected it to `Construction.tableFrom`.** The two objects sat in the same
tree, one the recurrence and one the closed form, with nothing asserting they
agree.

**Now proved, drafted and compiling:**

```text
tableFrom_eq_fwdDiff    tableFrom N r d = (−1)^d * (fwdDiff (−1))^[d] N r
                        [propext, Quot.sound]
tableFrom_eq_stencil    tableFrom N r d = stencil d (fun k => N (r − k))
                        [propext, Classical.choice, Quot.sound]
```

Route is Mathlib's `fwdDiff_iter_eq_sum_shift`
(`Mathlib/Algebra/Group/ForwardDiff.lean:143`), which carries the binomial
theorem. Our backward difference is `(−1)^d` times its forward one at step
`−1`; the sign folds because `d + (d − k) = 2(d − k) + k` for `k ≤ d`, so
`(−1)^(d+(d−k)) = (−1)^k`. A direct induction with `Finset.sum_range_succ'` and
Pascal was attempted first and abandoned — the index-shift bookkeeping is worse
than the bridge.

**What it buys.** A cell stops being a table walk and becomes one linear
equation on `d+1` values of the row. Checked against real counts, from the
depth-0 row `N(r) = π(2^r) − π(2^(r−1))` for `r = 1..8` = `1,1,2,2,5,7,13,23`:

```text
(8,3) zero      23 − 3·13 + 3·7 − 5 = 0      by decide, no axioms
(7,3) non-zero  13 − 3·7  + 3·5 − 2 = 5      by decide, no axioms
```

The non-zero is deliberate: without it the check only fires in one direction.

This does **not** predict a location and is not evidence toward one. It moves
the four zeros from four transcribed pairs in `Construction.measured_zeros` to
four explicit Pascal-weighted conditions on π. The arithmetic input remains
π(2^r) and always will.

**Not in the tree.** Draft at the session scratchpad as `stencil_equation.lean`;
landing it means editing `lean/Zeros.lean` and adding two pins.

---

## 2026-08-20 — Entry 59 — Construction.lean off Mathlib: two of the three axioms were the library's, not the mathematics'
type: formalization
refs: 45, 47

**Claim under test.** That the integer half of the tree was at
`[propext, Classical.choice, Quot.sound]` because of what it proves. It was not.
It was because every module opens with `import Mathlib`, and Mathlib's generic
ring and order instances are classical.

**Measured, in a Mathlib-free file against Lean core only:**

```text
                                  with Mathlib                      core only
tableFrom_add          [propext, Quot.sound]                        [propext]
tableFrom_smul         [propext, Quot.sound]                        [propext]
zero_determined_by_row [propext, Quot.sound]                        [propext]
tableFrom_zero         [propext]                                    none
vanishing_above        [propext, Classical.choice, Quot.sound]      [propext]
```

`vanishing_above` is `SeedPerturbation.tableFrom_eq_zero_of_vanishing_above`,
the gating theorem for the seed protections of entry 47. It had been read as
capped by inheritance from `Construction.zero_determined_by_row`; the cap was
Mathlib's floor, not the theorem's.

**Cost table for core tactics**, measured, no Mathlib:

```text
rfl / decide / induction / Nat→Int cast     no axioms
simp, named core Int lemma                  [propext]
omega                                       [propext, Quot.sound]
```

So `Classical.choice` came from Mathlib's instances and `Quot.sound` came from
`omega` — and `omega` was only ever reached for casts that are definitional.
`r − ((k+1 : ℕ) : ℤ) = r − 1 − (k : ℤ)` closes by `rfl`;
`Mathlib/Init/Grind/Norm.lean:82` proves the Nat→Int cast by `rfl`.

**A named lemma can be worse than a tactic.** Replacing `ring` with Mathlib's
`mul_sub` in `tableFrom_smul` *raised* the count to include `Classical.choice`,
because `mul_sub` is stated over a general ring. Core's `Int.mul_sub` does not.
Reverted before this work began; recorded because it is counterintuitive.

**Landed.** `lean/Construction.lean` no longer imports Mathlib. `lake build`
succeeds at 8037 jobs. Two changes beyond the proofs were forced:

1. Core has no `ℕ`/`ℤ` notation. Declaring it unqualified breaks every
   downstream import — `environment already contains 'termℤ' from
   Mathlib.Data.Int.Notation`. `local notation` fixes it.
2. `PairIdentity.tableFrom_add_window` dropped `Quot.sound` **by inheritance**
   and its pin had to be updated. The `#guard_msgs` check caught it, which is
   the check working in the improving direction.

Tree tally moved 15 → 11 at `[propext, Quot.sound]` and 8 → 12 at `[propext]`.
`Classical.choice` is unchanged at 79 of 113: `Construction` never carried any.
Moving that number requires `SeedPerturbation` (10 theorems, and it uses no
Mathlib surface at all) and the ℤ half of `PairIdentity` (3).

**The boundary this exposes.** 55 of the 79 `Classical.choice` theorems mention
ℝ or ℂ. Those can never drop it — ℝ is built with choice in Mathlib. So the
axiom line, once the integer modules move, *is* the arithmetic/analytic
boundary, printed by the compiler rather than argued in prose.

Verified separately: axiom lists are fixed in the proof term at elaboration, so
a downstream `import Mathlib` cannot raise them. `Zeros`, `PairIdentity` and
`SeedPerturbation` still import Mathlib and read `Construction`'s theorems at
their reduced counts.

---

## 2026-08-21 — Entry 58 — one of NEXT.md's two "written record errors" is not an error
type: result-triage
refs: 57

`lean/NEXT.md` has carried two corrections as outstanding since it was written.
Both were checked against artifacts today. One is real. The other is two
different quantities being compared as if they were one.

**Not an error — the G4 six-zero spread.** NEXT.md says the spread "is 8.56%,
recorded as 8.4%". Both numbers are correct and they measure different things.

`results/O24_gen_xmax3e9_run.log` carries two G4 tables.

Line 156, "P/median AT THE SIX gamma_n" — the value of the statistic *exactly
at* each γₙ:

```text
37.25863  36.93211  38.25230  36.83018  35.27244  36.70965
(max−min)/min = 8.4481%   ->  8.4%
```

Lines 205–210, "TEN LARGEST LOCAL PEAKS — G4" — the height of the local peak
*nearest* each γₙ, all six in band:

```text
38.299307  37.258633  36.932107  36.837708  36.760192  35.279641
(max−min)/min = 8.56%
```

`CONTEXT.md:299` and `lab_notebook.md` entry 42 report the first.
`papers/The-Four-Prime-Peak.md` § E2 reports the second, and its source line
names the table it used. Neither is wrong and neither should be edited to
match the other. **Recorded so that a later reader does not "fix" one of them.**

The distinction is not cosmetic: a peak *near* γₙ and the value *at* γₙ differ
by however far the peak sits off the zero, and G4's offsets run 0.0020 to
0.0209. Which one is the right statistic depends on the question, and the two
documents are asking different ones.

**Real — the 247-cell attribution.** `CONTEXT.md:305` credits the reproduction
of `files (2)/unit_weighted_dyadic_table.csv` across 247 cells to **O27**. It
is **O16's GATE A**: `results/O16_run2.log` lines 229–244 read "cells compared
: 247, mismatches : 0" for that file and for `composite_unit_dyadic_table.csv`,
then "GATE A: PASSED". No O27 log mentions 247 or that CSV. O27's own
contribution — the joint dyadic/triadic table to r = 41 — is separate and
stands.

**Method note.** NEXT.md is prose, and its claims were propagated into a commit
message before being checked. The artifacts settled both in under a minute.
Third time in this session that a recorded defect inverted on inspection: the
`§ B4` citations were valid, O42's Run record was already filled, and now this.

## 2026-08-21 — Entry 57 — two scripts quoted a rule that changed, and one artifact now disagrees with its script
type: provenance
refs: 53, 54, 55, 56

**What changed.** `O23_alignment_replication.py` line 1250 and
`O44_cross_base_zero_scan.py` line 10 both carried this verbatim in their
STATUS text: *"Currently only 07/O7 is preregistered."* That sentence was
copied out of `CLAUDE.md` § Prereg discipline when each script was written.

It is now wrong twice over. There are four locked preregs —
`alpha_depth_trend`, `zero_winding_phase`, `extended_zero_census`,
`sub_integer_base_scan` — and as of 2026-08-20 all four carry verdicts:
`depth_dependent`, `no_constant_angle`, `magnitude_floor`, `fineness`.
The CLAUDE.md line the scripts quoted no longer exists.

**Fix.** Both now cite `CONTEXT.md` § "Current state of the world" instead of
enumerating, and both say why: an enumeration goes stale, and this one did.
The same move that took the lab-notebook type vocabulary from four copies to
one and the prereg mechanics out of CLAUDE.md.

**Not an instrument-fix.** Nothing about what either script measures changed.
No re-run was performed and none is needed; prior results remain comparable.

**A divergence, recorded rather than repaired.** O23's sentence sits inside a
JSON output field, `exploratory_note`. So
`results/O23_alignment_replication_results.json` and
`results/O23_alignment_replication_results_run2.json` still contain the old
text. They are frozen records of what the script said when it ran and are
correct as they stand. The script and those two artifacts now differ by that
string, deliberately. A re-run would close the gap and is not worth the churn.

**The general shape.** A quoted rule is a copy, and copies go stale silently
because nothing checks prose against its source. `utilities/check_refs.py`
catches a citation that does not *resolve*; it cannot catch one that resolves
to text saying something different from what the quoter claims. That gap is
open and nothing in the tree closes it.

## 2026-08-21 — Entry 56 — t24: one fact that had been found five times
type: run
refs: 54, 55

EXPLORATORY. No prereg, no decision rule, nothing here is a verdict.

**Script.** `analysis/2026-08-19_table_structure/scripts/t24_commensurability.py`,
no flags, run 19:09:54. Output
`analysis/2026-08-19_table_structure/results/t24_commensurability.txt`.

**Question.** Whether `log b₁ / log b₂` is rational had decided at least five
results on this bench, each time under a different name. This computes the one
quantity behind all five.

**Headline.** Among integer bases 2…9 the commensurate pairs are exactly the
power chains 2-4-8 and 3-9; bases 5, 6, 7 meet nothing. The sub-integer scan's
family and antiphase arms are all `exp(π·m/(4γ₁))`, so all eight are integer
multiples `m = 2…9` of one unit, `π/(4γ₁) = 0.055565153` in natural log — the
scan is commensurate by construction. For `(20,6)`'s window ratio `2⁷ = 128`
no integer base but 2 reaches it at integer depth; for `(8,3)`'s `2⁴ = 16`,
base 4 reaches it at depth exactly 1.

**What it collects.** The same arithmetic appears as the mechanism in
`t6_multirate` (incommensurability breaks the alias comb), the kill in
CHAIN.md §10 (no inheritance between bases), the obstruction in t22 (the scan
cannot answer its own question), the censoring note in `The-Four-Zeros` § C5,
and a theorem — `Zeros.window_exclusive_of_prime_exponent`, which settles it
for one window and turns on 7 being prime.

**Written up as** `papers/Commensurate-Ladders.md`. Its § F3 records that the
general ladder-intersection statement is the one piece of arithmetic every
result above leans on and was not in the Lean tree; `Zeros.base_of_meets_two`,
`factorization_proportional` and `primeFactors_eq_of_meets` have since closed
the dyadic case and the proportionality, and the ancestor construction remains.

## 2026-08-21 — Entry 55 — t23: the deep zeros as two weighed halves, and one correction to the record
type: run
refs: 54

EXPLORATORY. No prereg, no decision rule, nothing here is a verdict.

**Script.** `analysis/2026-08-19_table_structure/scripts/t23_fold.py`, no
flags, run 06:02:02. Output
`analysis/2026-08-19_table_structure/results/t23_fold.txt`.

**Question.** Can the deep zeros be read as a balance rather than a vanishing?

**Headline.** The stencil weights `(−1)^k C(7,k)` are antisymmetric about the
window midpoint at `log₂ x = 16.5`, so `(20,6)` is a sum over four straddling
pairs with no leftover term. Split by sign, each arm carries total weight 64
and the two arms weigh **807295 each** on eight values of π sharing no term.
The same wing split reaches `(8,3)`: weights `1,−4,6,−4,1`, arms 8 and 8,
totals **168 and 168**.

**Control.** `(21,6)` folds to 1713, which is `cell(21,6)`. The fold is an
identity for odd stencil order, not a test — every cell equals its folded sum
whether or not it vanishes. `wing+ − wing− = cell` identically, so the wings
cannot be evidence for anything the cell value does not already say. Both are
recorded in the paper as § A4 and § B7 rather than presented as findings.

**Correction to the record.** `(25,11)` was placed on diagonal 13 in
conversation; it is on 14. Caught because the number did not resolve to the
result file. Script and paper both fixed in the same pass.

**Written up as** `papers/The-Fold.md`.

## 2026-08-20 — Entry 54 — t22: the zero surface is unanswerable with this scan, and the base set is why
type: run
refs: 50, 51, 52

EXPLORATORY. No prereg, no decision rule, nothing here is a verdict.

**Script.** `analysis/2026-08-19_table_structure/scripts/t22_zero_surface.py`,
no flags, run 05:05:24. Output
`analysis/2026-08-19_table_structure/results/t22_zero_surface.txt`.

**Question.** Do O45's 125 pooled zeros form a connected object across bases,
or an interval that merely happens to be occupied? Measured as cross-base
nearest-neighbour distance in the `(lo, hi)` window plane, against a null drawn
from each base's own resolved support, stratified so base composition matches.

**Headline.** Cross-base: observed 0.3745, null mean 1.0524 sd 0.0611,
z = −11.10. Within-base control: observed 1.2550, null mean 3.4454 sd 0.2250,
z = −9.73. The control moves too, so the compression is not about crossing
bases — it is present at every base separately. Width-matched null halves it
to z = −5.32 rather than collapsing it.

**Why it does not count.** The sorted window list carries exact `lo` repeats
across different bases, which is not an accident. Eight of the eleven bases
have `log₂ b` an exact integer multiple of `π/(4γ₁)`, and those eight carry
107 of the 125 zeros. There is no incommensurate pair anywhere in the scan, so
cross-base window alignment is forced by the base selection. The statistic
measures the prereg's choice of bases, not the arrangement of the zeros.

**Written up as** `papers/The-Zero-Surface.md`. The commensurability finding
is also the scope note now attached to O45's `fineness` verdict.

## 2026-08-21 — Entry 53 — t26: `d*` is not a per-base constant, its slope is — and a subcritical base crosses
type: run
refs: 41, 52

EXPLORATORY. No prereg, no decision rule, nothing here is a verdict.

Written to settle the two CONTESTED banners placed on
`analysis/2026-08-19_table_structure/CHAIN.md` §3 and §4 on 2026-08-20.

**Script.** `analysis/2026-08-19_table_structure/scripts/t26_crossover_by_r.py`,
new, no flags. Output `analysis/2026-08-19_table_structure/results/t26_crossover_by_r.txt`. `t2_crossover.py` is unchanged and its result stands — t26 is a
different measurement, not a re-run, so prior numbers remain comparable.

**Method.** t2 computes `d*` once per base over the whole depth-0 row: the
first depth at which oscillation carries more than half the spectral power.
t26 computes the identical statistic on the row truncated to its first `r`
rungs, sweeping `r`. That makes `d*` a function of `r` rather than a scalar.
Same window, same DC/oscillation split, same `min_n = 10` floor.

**Result 1 — `d*` is not a per-base constant.** Every one of the eight bases
shows `d*` rising with `r`. Dyadic runs `d* = 3` at `r = 13` to `d* = 7` at
`r = 32`. So CHAIN.md §4's fit `d* ≈ 1.1 + 8.1·ln b` correlates eight numbers
that are not constants. `papers/Depth-as-Time.md` § D2 is upheld against it.

**Result 2 — the per-base quantity is the slope.** `d*(r)` is close to
proportional, `d* ≈ c(b)·r`:

```text
base          b        ln b     slope    slope/ln b
family k=1    1.1175   0.1111   0.0125   0.1125
family k=2    1.2489   0.2223   0.0324   0.1458
2^(1/3)       1.2599   0.2310   0.0339   0.1467
family k=3    1.3957   0.3334   0.0635   0.1905
2^(1/2)       1.4142   0.3466   0.0611   0.1763
family k=4    1.5597   0.4445   0.0814   0.1831
dyadic        2.0000   0.6931   0.2023   0.2919
```

`corr(ln b, slope) = +0.9735`, fit `slope ≈ 0.3246·ln b − 0.0409`. So §4 found
a real relationship and attached it to the wrong variable. The correlation
survives the correction; the quantity it correlates does not.

**Result 3 — a subcritical base crosses.** `papers/Depth-as-Time.md` § C4 says
bases with gain ratio below 1 have "no instability at any depth, at any `r`".
Family k=4 has ratio 0.5553 and crosses at `d* = 1` by `r = 11`, rising to 5.
CHAIN.md §3's observation was correct and the contradiction is real.

**Reading, and it is harsher than either section.** All eight bases cross,
including the subcritical one, each at a fixed fraction of `r`. A statistic
that fires on every table at `d* ≈ c(b)·r` is not measuring the § C3
instability — it is measuring something that happens to any table with depth,
plausibly the shrinking row length. So the resolution is not "§ C3 is wrong":
t2's `d*` and § C3's crossover are different quantities that were being
compared as if they were one.

**Against O33.** `Depth-as-Time` § D3 reports slope 0.3031 for b=2 from O33's
turnaround series. t26 gives 0.2023 on this statistic. Different quantity,
different turnaround; neither refutes the other, and they are not
interchangeable.

**Open.** What `d*` actually tracks. If it is row length, `d*` should scale
with the number of surviving points rather than with `b`, and the
`slope/ln b` column — which drifts 0.11 → 0.29 rather than staying flat — is
the place to look. Nothing here tests that.

## 2026-08-19 — Entry 52 — O46/O47: `density ≈ 1/S` refuted, the zeros live in the thin tail, and (20,6) does not survive refinement
type: result-triage
refs: 47, 50, 51

Two EXPLORATORY reads of entry 51's run of record — no prereg, no
p-value, nothing stamped. `O46_mass_density_check.py` →
`results/mass_density_check.json` (24,756 B) +
`results/mass_density_check_run1.log` (126 lines), 2026-08-19T07:43:07Z;
`O47_high_mass_zeros.py` → `results/high_mass_zeros.json` (180,549 B) +
`results/O47_high_mass_zeros_run1.log` (278 lines), 08:09:13Z. Both open
O45's script and JSON read-only and both re-derive its stratum:
geometry matches the locked table at all eleven bases, zero sets match
O45 exactly, and O46's mass recurrence agrees with O45's
`stencil_mass()` over 2297 cells, **0 mismatches**. No cell violates
`|cell| ≤ S` and no resolved cell has `S = 0`, so not one zero in the
run is arithmetically forced.

**The mechanism proposed, and its refutation.** `mass_bound` is exact:
a cell is a signed integer in `[−S, S]`, `S(r,d) = Σ_k C(d,k)·N(r−k)`.
If cell values were spread over that range, landing on 0 would go like
`1/S` — a parameter-free prediction with no free constant, testable in
two forms. Both fail:

```text
  density x mean(S)    min 3.07433e+09   max 4.25686e+47   spread 1.38465e+38
  density / mean(1/S)  min 0.617483      max 3.43727       spread 5.56658
```

A spread of 1 would be exactly constant. The parameter-free product
spreads by 38 orders of magnitude. The sharper form is far better
behaved — a factor of 5.6 — but it does not cluster at 1 either: eight
of the eleven bases sit between 2.30 and 3.44, base 2 at 1.72, and two
bases fall below 1 (`2^(1/3)` at 0.617, antiphase `k = 4` at 0.799).
Clustering at 2–3 is a real regularity and is not the prediction.

**And the premise itself is false.** `|cell|/S` over the resolved
stratum has median between **3.52e−4** (`2^(1/2)`) and **2.20e−3**
(`2^(1/3)`), so roughly `1e−3` at every base. Cells sit three orders of
magnitude inside their own bound. They are not spread over `[−S, S]`,
so the chance of hitting 0 was never `1/S`, and the two spread factors
above are measuring a model that was wrong at its first line.

**What replaced it: the zeros live in the extreme thin tail of the mass
distribution.** Per base, median `S` at a resolved zero against median
`S` over the whole resolved stratum:

```text
  median S at a zero        8  to  516     across the eleven bases
  median S over the stratum 2.40e+07 (base 2) to 3.55e+18 (finest base)
```

Base by base the ratio of the two runs from **5.4 orders** of magnitude
(antiphase `k = 4`) to **17.1** (the finest family base); base 2's own
is 5.7. The typical zero is a cell with almost nothing to cancel. Which
makes the high-`S` end the interesting end, and it is what O47 ranks.

**Checked and only half true: zero density does rise with `b`.** The
claim carried into this entry was that density rises roughly
monotonically across the eleven bases with base 2 the maximum at about
4× the finest. Recomputed from `zeros_per_resolved_cell` in
`results/sub_integer_base_scan.json`, identical to `density` in
`results/mass_density_check.json` at all eleven bases: base 2 **is** the
maximum at 8.065e−3, and the finest base is 2.067e−3, a ratio of
**3.90**, so "about 4×" holds. "Roughly monotonically" does not, as
written. Four of the ten adjacent steps in `b` decrease, and two bases
sit far off any trend — `2^(1/3)` at 8.40e−4, a quarter of its
neighbours, and antiphase `k = 4` at 2.32e−3. The rank trend is real but
moderate: Spearman ρ = 0.655, Kendall τ = 0.564 (43 concordant pairs
against 12 of 55), permutation p ≈ 0.017 one-sided. Direction yes;
monotone no.

**The pooled ranking, 125 resolved zeros across all eleven bases.**
Base 2's four carry `S = 2, 4, 88, 492384` and land at pooled ranks
**115, 102, 37 and 3** — three of the four in the bottom quarter, and
`(20,6)` third from the top. Above it sit two cells of `2^(1/2)`:

```text
   1  2^(1/2)  (34,11)  S = 1371038   log2 window [11.5, 17.0]
   2  2^(1/2)  (42, 5)  S =  651298   log2 window [18.5, 21.0]
   3  base 2   (20, 6)  S =  492384   log2 window [14.0, 20.0]
   4  antiphase k=2 (47,4)  S = 87160
```

and the largest ratio gap anywhere in the pooled list is exactly the one
after rank 3: **5.649** = 492384/87160 = 61548/10895 exactly. So the
high-mass end is a four-cell club — two at `2^(1/2)`, `(20,6)`, and one
antiphase cell — and then it falls off a cliff. `(20,6)` is no longer
the most massive cancellation on record.

**The (40,12) result, and it is the sharp one.** At `b = 2^(1/2)`, the
cell `(40,12)` is the exact image of base 2's `(20,6)` under factor-2
refinement: `r` doubles, `d` doubles, and the window bottom `b^(r−d)`
lands on `2^14` as `b^r` lands on `2^20`. O47 checks the identity
directly rather than assuming it — `identical integer bounds: True`,
window `(16384, 1048576]` on both sides, `80125` primes in the window
on both sides. The **same primes, the same value interval, the same
question asked at twice the resolution.** The cell reads

```text
  base 2      (20, 6)   cell =     0     S =   492384
  base 2^(1/2)(40,12)   cell = -6884     S = 15723924    |cell|/S = 4.378e-04
```

`(20,6)` **does not survive refinement.** And `4.378e−04` is not a near
miss on the scale of anything — it sits essentially at that base's
median `|cell|/S`, which is 3.52e−4.

**Set that against `SeedPerturbation`.** `lean/SeedPerturbation.lean`
proves that a change of seed convention replaces the depth-0 row `N` by
`N − e` and, by linearity plus locality, cannot touch a cell whose
window bottom clears the last rung `e` moves: `R < r − d` gives
`cell_eq_of_seed_perturbation`, and `boundary_can_move` shows the strict
inequality is sharp. Entry 47 measured the same thing from the data —
`(8,3)` and `(20,6)` are unmoved by three seed conventions, six
composite variants and two repos, while `(2,1)` and `(4,1)` sit close
enough to the seed to be reached. So `(20,6)` is **robust to seed
changes and fragile to resolution changes**, and those were never the
same invariance: one is about what the bottom of the window reads, the
other about how finely the window is sampled between its endpoints.
Nothing in `SeedPerturbation.lean` claimed the second, and nothing in
it is contradicted. (It is not yet recorded anywhere in this notebook;
`lean/lakefile.toml` now globs eleven modules against the ten entry 45
counted.)

Both scripts EXPLORATORY, `summary.verdict` null in both files. Nothing
above is a verdict and nothing here bears on O45's empty verdict line.

No outcome marked.

---

## 2026-08-19 — Entry 51 — O45 run: 121 resolved sub-2 zeros, 35 clearing the mass floor, p = 0.0839 — the verdict line is empty and is Julian's
type: run
refs: 44, 49, 50

`O45_sub_integer_base_scan.py`, one run at the locked flags,
**PREREGISTERED** against entry 50's protocol. Lock written
2026-08-19T07:16:07Z; `run_start_utc` = `run_end_utc` =
2026-08-19T07:16:38Z — thirty-one seconds after lock, and the run
completes inside one second. Python 3.14.3, `code_version`
`f06f6f3c…`. Artifacts `results/sub_integer_base_scan.json` (177,989 B)
and `results/O45_sub_integer_base_scan_run1.log` (50,589 B, 746 lines).
`pi2n_cache.json` read, not written; nothing under `imported/`,
`lean/` or `preregs/` opened for writing.

**Sidecar.** `preregs/sub_integer_base_scan_v1_20260818.sha256` reads
`7985c94015bab8d8f2e606b69aaeac79150ccec1d4ec9d04bca7db177c02aaf5`, and
the Run record's `post_compute_sha256` is the same string — so no
parameter, hypothesis or decision-rule text drifted between lock and
compute.

**Check 1, π backend.** `primecountpy.prime_pi` 0.2.1, **33 of 33**
audit comparisons equal against `pi2n_cache.json`, including
`π(2^32) = 203280221` backend and cache. PASS.

**Check 2, geometry.** All eleven bases recompute `r_max`,
`cells_at_d_ge_1`, `r_thick` and `resolved_cells` equal to the locked
table — `geometry_matches_locked` true for every base. Minimum relative
distance of any `b^r` to an integer over the whole support is
**1.665e−12** at antiphase `k = 1` and `k = 2`, the same number the
prereg pre-computed, forty-eight orders above the dps-60 floor and far
above the 1e−30 determinacy threshold. `root_selfcheck_failures` 0 at
both refinement bases. `summary.compromised_conditions` is `[]`.

**Check 3, base-2 reproduction.** Through the identical code path at the
same value ceiling, base 2 rebuilds `[[2,1],[4,1],[8,3],[20,6]]` over
496 cells — the known set, no more and no fewer. A reproduction check,
not evidence; the prereg says so and so does the log.

**Check 4/5, the scan and the rate test.** The primary statistic:

```text
  resolved cells   base 2   496     sub-2  37178
                                    family 20661  antiphase 11236  refinement 5281
  Z_2  (base 2, resolved)         : 4
  Z    (sub-2, resolved)          : 121
  Z*   (of those, S >= 88)        : 35     family 13  antiphase 18  refinement 4
  E[Z] under H0                   : 299.822580645161  (locked value, reproduced)
  conditional-binomial p (PRIMARY): 8.394656e-02   [exact]
  Poisson p (SECONDARY)           : 6.367145e-32
  alpha_level                     : 0.05, one-sided
```

Zeros on the **full** support total 240 across the ten sub-2 bases
against 121 resolved — the resolved criterion discards a little over
half of them, which is what entry 50 designed it to do. Per base,
resolved zeros: family 29 / 14 / 9 / 7, antiphase 21 / 15 / 10 / 2,
refinement 11 (`2^(1/2)`) and 3 (`2^(1/3)`). Every one of the eleven
bases has at least two resolved zeros.

**The mechanical output of the decision rule is `fineness`**, by
`Z* ≥ 1`, not `family_only`, not `refinement_only`, and
`p = 0.0839 > 0.05`. That is the rule's arithmetic and nothing more.
`summary.verdict` is `null` by design and `verdict_note` reads "the
verdict line is Julian's to write in the prereg's Run record"; the Run
record's `- verdict:` line is **empty**. This entry does not fill it and
does not read the branch as a result.

**What the run eliminates, stated in the prereg's own terms.**
`intrinsic_base_two` required `Z = 0`; `Z = 121`. So "sub-2 bases stay
empty" is off the table on the resolved stratum as well as on the full
one — and not marginally: mass-clearing zeros appear in **all three**
arms, family, antiphase and refinement alike, which is what closes
`family_only` (`Z*_antiphase = 18 ≠ 0`) and `refinement_only`
(`Z*_family = 13 ≠ 0`) as well. `thin_rung_forced` needed `Z* = 0` and
`Z* = 35`, so the surplus is not confined to the thin end of the
stratum. The one thing the run does **not** eliminate is a rate below
base 2's: `p = 0.0839` sits above alpha, but 121 against an H0
expectation of 299.8 is well under half, and the prereg's own stated
weakness 1 — resolved cells at neighbouring `r` share most of their
stencil, so the independence assumption makes `p` anti-conservative
*against* H0 — cuts in exactly that direction.

**A wrinkle in the new convention, undecided.** Lines 5–8 of the prereg,
immediately under `STATUS: **LOCKED**`, read: "There is no sidecar
`sub_integer_base_scan_v1_20260818.sha256` yet; the sidecar is the
authority on lock, and its absence means this prereg is not locked."
That text is now false — the sidecar exists — and it sits **inside the
hashed region**, which measurement confirms: the sidecar hash is the
SHA-256 of the file's first 680 lines, and lines 5–8 are among them. So
the sidecar pins a paragraph asserting the file is unlocked, three
lines below a STATUS block asserting it is. The file cannot be edited
to fix it without breaking the sidecar match that the Run record
depends on. This is a wrinkle in the naming convention entry 44
introduced — the drafting boilerplate assumes the pre-lock state and
nothing strips it at lock time — not a defect in this prereg's
protocol, every parameter of which reproduced. Julian's call.

No outcome marked.

---

## 2026-08-19 — Entry 50 — the O45 prereg: fineness against intrinsic, and the empty-rung discovery that forced the resolved stratum
type: prereg
refs: 44, 45, 49

`preregs/sub_integer_base_scan_v1_20260818.md`, 695 lines as it now
stands. It asks one question of entry 49's 4-in-496 / 0-in-496 result:

```text
  fineness   base 2 is the finest INTEGER sampling of the scaling flow,
             so bases BELOW 2 - finer still - should produce zeros at
             at least base 2's per-resolved-cell rate.       [H0]
  intrinsic  base 2 is special in itself, so sub-2 bases stay empty
             and the point prediction is Z = 0.              [H1]
```

The fork is licensed by entry 45's finding that `pair_identity` takes
**no hypothesis on `b`**, and by `lean/Chain.lean`'s `C1` needing only
`0 < b`: `π(b^r) − π(b^(r−1))` is well defined for real `b > 1` and the
cells stay integers. `E[Z] = Z_2·C_sub/C_2 = 4 × 37178 / 496 =
299.822580645161`, stated as a number before the run.

**Four drafting complications, all resolved inside the locked text.**
The section is headed "The three complications" and then lists four,
`(a)` through `(d)` — a wording slip inside the hashed region, recorded
not corrected.

*(a) The pair identity is only approximate at non-integer `b`.*
`tableFrom_add_window` (linearity plus locality) is exact for any seed
rows and any `b`; `tableFrom_of_geometric` needs the rung
`(b^(r−1), b^r]` to hold exactly `(b−1)·b^(r−1)` integers, and at real
`b` it holds `⌊b^r⌋ − ⌊b^(r−1)⌋`. So O44's `nu` denominator is not
reused as such. Two totals are locked and both reported:

```text
  total_geo (b,r,d) = (b-1)^(d+1) * b^(r-1-d)        O44's denominator
  total_true(b,r,d) = sum_k (-1)^k C(d,k) W(r-k),  W(r)=|b^r|-|b^(r-1)|
```

The drift is not small: at `b = exp(π/(2γ₁))`, `(199,20)` has
`total_geo = 1.16e−11` against `total_true = −86804`, and 9601 of that
base's 19701 cells have `total_true ≤ 0`, which a positive geometric
quantity cannot do. `nu_pair = |cell|/|total_true|` is primary.

*(b) Fair comparison is by value range, not by `r`.* Bases are matched
on a **value ceiling** `V = 2^32` — base 2's extent in entry 49 — with
`r_max(b)` the largest `r` with `b^r ≤ V`, locked per base rather than
recomputed. `b = 1.11754` needs `r = 199` to reach where base 2 needs
32, and carries 19701 cells against 496; that asymmetry *is* the
fineness prediction, so every count is reported with its denominator.
Second consequence, load-bearing: `ln(b^r) ≤ ln V` at every base and
rung, so the prime density `1/ln x` entering any cell is bounded
identically across the list — density-matched by construction, not by
correction.

*(c) `(b−1)^(d+1) < 1` below 2, and the naive reading of it is wrong.*
`PairIdentity.coeff_eq_one_iff_base_two` covers integer `b ≥ 2` only.
For `1 < b < 2` the coefficient **shrinks** with depth: `total_geo` at
the ceiling drops below 1 from `d = 9, 13, 17, 21` at the four family
bases, against supports running to `d = 198, 98, 65, 48`. Read naively
that is O43's magnitude floor in reverse, forcing zeros over nearly the
whole sub-2 support. It is wrong for exactly the reason in (a):
`total_geo` is not the size of anything at a non-integer base. Floor
jaggedness is `O(1)` per rung and the stencil's L1 weight is `2^d`, so
deep sub-integer cells are **large**. The prereg's own sentence: "The
reverse magnitude floor, in the form O43 met it, does not apply."

*(d) A third outcome exists.* Zeros might appear only at the optimal-base
family `exp(πk/(2γ₁))`, which is neither account. Hence **non-family
controls in the same range**: four antiphase bases `exp(π(2k+1)/(4γ₁))`,
interleaved between consecutive family members and exactly half a
quarter-turn off the family in its own coordinate; and two refinement
controls `2^(1/2)`, `2^(1/3)`, of which base 2 is a literal
sub-sampling — the sharpest available test of fineness. Eleven bases,
`C_2 = 496` against `C_sub = 37178`, split 20661 family / 16517
non-family, so `family_only` cannot be an artefact of the controls
having had no chance. Labels `family_only` and `refinement_only` exist
for it.

**The discovery that shaped the design, and it fired before the run.**
At the finest base `b = exp(π/(2γ₁)) = 1.11754…`, `⌊b^r⌋ = 1` for
`r = 0…6` — the first six rungs hold no integers at all. Under this
project's convention (`π(1) = 0`) that gives `N(r) = 0` there and
`cell(2,1) = N(2) − N(1) = 0` **exactly**, a zero about an empty rung
and nothing else. Every sub-2 base has such a region. So `Z_full ≥ 1`
was guaranteed before a single prime was counted and "sub-integer bases
stay empty" was already false on the full support — for reasons
unrelated to the hypothesis. That is why the primary statistic is the
**resolved** count: a cell counts only if every rung its stencil reads
is expected to hold at least one prime, `W(r')/ln(b^(r')) ≥ 1` for all
`r' ∈ [r−d, r]`, equivalently `r − d ≥ r_thick(b)`. Pure geometry, no
prime counted to evaluate it, so `r_thick` and `resolved_cells` are
locked per base. At `b = 2` the criterion holds over the entire support
(`r_thick = 1`, all 496 cells, all four zeros kept) — one more sense in
which base 2 is the boundary case.

**Decision rule and vacuousness.** Eight labels, precedence
`compromised > thin_rung_forced > family_only > refinement_only >
fineness > rate_below_base_two > intrinsic_base_two > ambiguous`, keyed
on `Z`, on `Z*` (resolved zeros with `S ≥ mass_floor`) and on an exact
conditional-binomial `p`. The pre-computed p-table gives the smallest
`Z` with `p > 0.05` as **101** — a third of H0's own point prediction —
so `fineness` needs 101 mass-clearing zeros in 37178 resolved cells and
`intrinsic_base_two` needs none. Both directions reachable.

**Provenance, and the non-blind half.** `mass_floor = 88` is
`S(8,3)` at base 2, chosen with base 2's four masses `S = 2, 4, 88,
492384` already in view; the resolved criterion was fixed after the same
base-2 rebuild. Both are **calibrated on already-inspected data** and
only their application to the sub-2 bases is blind. Entry 49's results
were read in full while drafting. The genuinely blind arm is that no
sub-integer base had ever been computed here by anyone — the drafting
agent evaluated π at no sub-integer argument, and every locked geometric
quantity came from `⌊b^r⌋` alone.

**First prereg locked under the no-status-in-filename convention** that
entry 44 recorded into `CLAUDE.md`. Named
`sub_integer_base_scan_v1_20260818.md` at creation, no `_locked_`
infix, with the sidecar as the authority on lock. `lock_written_at`
2026-08-19T07:16:07Z, `locked_by` julian, `pre_compute_sha256` PENDING.
Measured for this entry, the sidecar
`7985c94015bab8d8f2e606b69aaeac79150ccec1d4ec9d04bca7db177c02aaf5`
is the SHA-256 of the file's **first 680 lines** — everything through
`- locked_by: julian` — so the locked region is the whole protocol and
the `## Run record` section was appended afterward.

No outcome marked.

---

## 2026-08-18 — Entry 49 — O44: base 2 is the only integer base with exact zeros, and entry 17's conclusion survives by a route entry 17 did not take
type: run
refs: 17, 45, 46, 47

`O44_cross_base_zero_scan.py`, one execution, **EXPLORATORY** — no
prereg, no hypothesis, no decision rule, nothing here is a verdict.
Invocation read back from `params.argv`:

```text
python3 O44_cross_base_zero_scan.py --data-dir imported/lattice_mapper/32bit \
    --bases 2,3,4,5,6,7,8,9 --d-min 1 --top-k 10 --pair-check --variant-scan \
    --out results/cross_base_zero_scan.json
```

`run_start_utc` = `run_end_utc` = 2026-08-19T06:30:13Z, completed;
Python 3.14.3; `code_version` `3ae5a3f1…`. Sixteen of the twenty-two
imported CSVs read, all read-only. Artifacts
`results/cross_base_zero_scan.json` (99,469 B) and
`results/O44_cross_base_zero_scan_run1.log` (25,995 B). The convention
in force is the **imported** one — 2 and 3 excluded as lattice (entry
46) — stated in `constants.convention` and `constants.convention_adjusted_for
= false`, so low-`r` numbers here do not compare with anything in
`results/`.

**The coordinate.** Raw `|cell|` compares across neither bases nor
depths, so O44 divides the pair identity's total out:
`nu(b,r,d) = |cell| / [(b−1)^(d+1)·b^(r−1−d)]`, every ranking on an
exact `Fraction`. That denominator is `pair_identity` of
`lean/PairIdentity.lean`, which entry 45 recorded as carrying **no
hypothesis on `b`** — which is what licenses using it at eight bases
at once.

**Extent and exact zeros at `d ≥ 1`** (`summary.per_base`):

```text
   b  file                              maxr maxd  cells  d>=1  zeros
   2  dyadic_difference_table_32.csv      32   31    528   496      4
   3  triadic_difference_table_32.csv     32   31    528   496      0
   4  tetradic_difference_table_32.csv    32   31    528   496      0
   5  pentadic_difference_table_27.csv    27   26    378   351      0
   6  hexadic_difference_table_24.csv     24   23    300   276      0
   7  heptadic_difference_table_22.csv    22   21    253   231      0
   8  octadic_difference_table_21.csv     21   20    231   210      0
   9  enneadic_difference_table_20.csv    20   19    210   190      0
```

Base 2's four are `(2,1) (4,1) (8,3) (20,6)` — the same set entry 47
read out of this same file. Base 3 is empty over the **identical** 496
cells, same ceiling and same support, so 4-in-496 against 0-in-496 is
the one uncensored comparison the table contains.

**Bases 4–9 are uninformative, and the reason is visible in where their
minima sit.** Every one of them takes its minimum `nu` on the **corner
cell** `(max r, max d)`: `(32,31)`, `(27,26)`, `(24,23)`, `(22,21)`,
`(21,20)`, `(20,19)`, at `nu` 0.0134, 0.0186, 0.0196, 0.0203, 0.0203,
0.0205. A minimum on the boundary of the support is a statement about
where the table stops, not about a floor. Bases 5–9 are additionally
extent-censored in `r_max` (27, 24, 22, 21, 20); base 4 is **not** — it
reaches `r = 32` with the same 496 cells as bases 2 and 3, and is simply
empty. Recorded because the two facts are distinct and only base 4
carries both a full extent and a corner minimum.

**The correction to entry 17, and it does not damage entry 17's
conclusion.** Entry 17 records of `triadic_difference_table_32.csv`
that "Base 3 reaches **1**, twice". Both of those cells are here and
both read `|cell| = 1` exactly — `(3,2)` and `(5,4)`, re-read from the
imported copy for this entry. But their totals are `2^3·3^0 = 8` and
`2^5·3^0 = 32`, so normalised they are `0.125` and `0.03125`, and
**neither is in base 3's ten smallest `nu`** (`summary.per_base[1].smallest_nu`,
which runs 9.77e−4 to 7.87e−3). Base 3's actual closest approach is

```text
  base 3   (11,10)   cell 2   total 2048   nu = 2/2048 = 9.765625e-04
  base 2   (13, 5)   cell 1   total  128   nu = 1/128   = 7.8125e-03
```

so base 3 comes **eight times closer proportionally** than base 2's
smallest nonzero cell does — exactly `8`, both being dyadic rationals.
Entry 17 argued base-2 extremality from magnitude and then recorded
that the magnitude argument fails to separate the bases. It fails
harder than entry 17 said: on the normalised reading base 3 is the
*closer* of the two and still never lands. Entry 17's conclusion — base
2 is where the zeros are — survives, but by the route "base 3 gets
closer and still misses", not "base 2 gets closest".

**The pair identity holds on data this project did not generate.**
Three matched pairs, `summary.pair_identity_checks`:

```text
  plain prime + plain composite                  528 cells   0 mismatches
  prime_full_silenced + plain composite          410 cells   0 mismatches
  plain prime + (composite − prime)              351 cells   0 mismatches
                                       total    1289 cells   0 mismatches
```

The third runs in mode `diff_plus_2p`. The five unmatched variants in
§ 4b mismatch at 90, 91, 40, 59, 59 cells and are flagged
`expected_to_mismatch = true` in the JSON — entry 47's arithmetic, put
on the record rather than assumed.

**One anomaly, surfaced and not chased.**
`imported/lattice_mapper/32bit/dyadic_diff_full_silenced_32.csv` is one
of the six 32bit CSVs O44 did **not** read. Measured for this entry: it
is exactly `composite_full_silenced − prime_full_silenced`, 410 of 410
cells, so it is a `C − P` table like `composite_minus_prime_32.csv`.
But it satisfies the identity against **nothing on disk**. In mode
`sum` it mismatches all twenty of the directory's other regime-keyed
CSVs (the wide `prime_composite_sidebyside_32.csv` excluded); in mode
`diff_plus_2p` its best partner is either dyadic prime arm at **59**
mismatches of 410 — and 59 is precisely the number of cells at which
its own parent pair fails, `C_fs + P_fs ≠ 2^(r−1−d)` at 59 of 410. Entry
47 cites this file as agreeing at `(4,1) = 6`, `(8,3) = 16`,
`(20,6) = 8192`, which it does; what it does not do is belong to a pair.
Not chased here.

Still EXPLORATORY. Nothing above is a verdict and nothing is decided.

No outcome marked.

---

## 2026-08-18 — Entry 48 — O33 was still reading the external lattice_mapper directory; repointed at the vendored copy, re-run, non-semantic
type: instrument-fix
refs: 36, 46

Entry 46 imported the eight base-series difference tables into
`imported/lattice_mapper/32bit/`, byte-for-byte and SHA-256 verified, so
that the evidence would sit with the work that cites it.
`O33_base_ladder_crossing.py` was not repointed. Its `DEFAULT_DATA_DIR`
still named
`/Users/juliansambrano/GitHub/lattice_mapper/difference_tables/32bit`, a
path outside this repo, and `results/base_ladder_crossing.json` →
`params.data_dir` records exactly that string. The vendored copy did not
protect the instrument: had `lattice_mapper/` been moved, renamed or
regenerated, O33 would have failed or silently read something else, with
27 verified files sitting unused two directories away. The import closed
the provenance gap for the *reader*; it did not close it for the *script*.

**Sites changed.** Three, all path, none logic. Line numbers before → after:

```text
  15-19  →  15-28   docstring, "THE SOURCE TABLES" preamble — the source
                    directory paragraph now names imported/lattice_mapper/32bit/,
                    records the byte-for-byte copy and points at the import
                    manifest and entry 46, and states that the run of record
                    predates the repoint
 194-196 →  202-205  docstring EXAMPLE — the explicit
                    --data-dir /Users/.../difference_tables/32bit line dropped,
                    since the default is now correct; a note added that an
                    explicit --data-dir is used verbatim and should be absolute
 220-221 →  230-233  DEFAULT_DATA_DIR, the default constant
```

The new default is

```python
DEFAULT_DATA_DIR = os.path.join(_HERE, "imported", "lattice_mapper", "32bit")
```

anchored to `_HERE = os.path.dirname(os.path.abspath(__file__))`, which
the file already defined at what is now line 227 for `DEFAULT_RESULTS_DIR`.
That is the house pattern, not a new one: `O16_centered_difference_table.py`
lines 169-171 anchor `files (2)` the same way, and `05`, `06`, `07`, `O11`
through `O23`, `O42` and `O43` all anchor their caches and outputs to `_HERE`.
An absolute path was rejected in favour of it so the repo stays portable.
The `--data-dir` flag's help string interpolates `DEFAULT_DATA_DIR`, so it
followed with no separate edit. `grep -n difference_tables
O33_base_ladder_crossing.py` now returns one line, 23, inside the docstring
sentence that records where the vendored files came from.

**Left alone, deliberately.** `constants.source_project` at line 1012 still
reads `/Users/juliansambrano/GitHub/lattice_mapper (READ ONLY; nothing
written there)`. That field records where the data *originated*, not where
this script *reads*, and it remains true — the vendored copy came from
there and the source tree is still untouched. Changing it would have moved
a leaf in the `constants` block, and the whole point of the comparison
below is that `constants` did not move. Same reasoning for the docstring's
scaffold-silencing section (lines 104-109) and
`constants.source_silencing`, which cite
`lattice_mapper/difference_table.py:75` as the generator: that is a
statement about provenance of the convention, and the generator is not
vendored here.

**Script SHA-256, before and after** (`shasum -a 256
O33_base_ladder_crossing.py`, run either side of the edit):

```text
  before  ffa3d5b746fd7c66cc0c6161d6532dd0d76d77ee4f0a882bec3b22eb2bf227ac
  after   55e1593b0bd950679c37684ada7ab614c346ea89c003b6cf40e37f0a1d329a01
```

The before hash is the same string carried in
`results/base_ladder_crossing.json` → `params.code_version`, so run 1
executed the pre-fix bytes and stamped them, and nothing had touched the
file between that run and this edit. 1038 lines before, 1050 after;
`python3 -m py_compile` clean.

**Re-run, to new paths.** Run 1's own invocation, read from
`results/base_ladder_crossing.json` → `params.argv`, which is
`['O33_base_ladder_crossing.py', '--min-row', '8']`, with `--out` and
`--out-csv` redirected so that neither run-1 artifact could be touched.
`--min-row 8` is also the flag's default; every other parameter ran at
default in both runs.

```text
python3 O33_base_ladder_crossing.py --min-row 8 \
    --out    /Users/juliansambrano/GitHub/Primebeat_081426/results/base_ladder_crossing_run2.json \
    --out-csv /Users/juliansambrano/GitHub/Primebeat_081426/results/base_ladder_crossing_run2.csv \
    2>&1 | tee /Users/juliansambrano/GitHub/Primebeat_081426/results/O33_base_ladder_crossing_run2.log
```

`run_start_utc` and `run_end_utc` both 2026-08-19T05:49:55Z, read from
`results/base_ladder_crossing_run2.json` → `params`; the run completes
inside one second. Python 3.14.3, mpmath 1.3.0, the same interpreter
string run 1 recorded. There was no run-1 log — `results/` held only
`base_ladder_crossing.json` and `base_ladder_crossing.csv` for O33 — so
`results/O33_base_ladder_crossing_run2.log` is the first log this
instrument has, named to the house `<script>_run2.log` pattern rather than
back-dated to a run-1 name that never existed.

Artifacts: `results/base_ladder_crossing_run2.json` (215,742 B),
`results/base_ladder_crossing_run2.csv` (14,600 B),
`results/O33_base_ladder_crossing_run2.log` (19,014 B, 236 lines).

**The change is non-semantic, and here is the evidence.** Both payloads
flattened to leaves and compared key by key. Run 1 has 6432 leaves, run 2
has 6436; the four extra are the four extra `params.argv` elements
(`--out`, its path, `--out-csv`, its path — 3 elements against 7). Of the
6429 leaves that are not `params.argv`, **fifteen** differ, every one of
them metadata:

```text
  /generated_utc              2026-08-18T03:25:29Z  ->  2026-08-19T05:49:55Z
  /params/run_start_utc       2026-08-18T03:25:29Z  ->  2026-08-19T05:49:55Z
  /params/run_end_utc         2026-08-18T03:25:29Z  ->  2026-08-19T05:49:55Z
  /params/code_version        ffa3d5b7...           ->  55e1593b...
  /params/data_dir            .../lattice_mapper/difference_tables/32bit
                                                    ->  .../Primebeat_081426/imported/lattice_mapper/32bit
  /params/out                 base_ladder_crossing.json  ->  ..._run2.json
  /params/out_csv             base_ladder_crossing.csv   ->  ..._run2.csv
  /params/source_files[0..7]/path   eight file paths, external -> vendored
```

`data_dir` and the eight `source_files` paths are the fix itself.
`code_version` moving is expected: `_code_version()` hashes `__file__` at
write time, so a changed file changes the stamp even when behaviour does
not.

Nothing else moved. The `constants`, `summary` and `rows` blocks are
**byte-identical** under a sorted-key JSON dump — all 210 rows, all eight
per-base summaries, all eight schema verifications, all eight unsilence
checks. So are `schema_version`, `script` and `script_path`. And the
`results/base_ladder_crossing_run2.csv` is byte-identical to
`results/base_ladder_crossing.csv`, same SHA-256
`f71f74b52cf923aca01e0fff8a4e4a4dfbd795302f4e1c47fba38b937d70ba94` —
the CSV carries no timestamp, so it is the cleanest single statement of
the result: the fix altered nothing this instrument measures.

**The comparison also checks the import, and the import passes.** Within
`params.source_files`, only `path` moved. `sha256`, `bytes`, `mtime_utc`,
`regimes`, `n_columns`, `header_first_4`, `header_last`,
`filename_trailing_number` and
`filename_trailing_number_equals_regimes` are identical across the two
runs at all eight bases. That is the load-bearing check: run 1 hashed the
files it read at
`/Users/juliansambrano/GitHub/lattice_mapper/difference_tables/32bit/` and
run 2 hashed the files it read at `imported/lattice_mapper/32bit/`, and
the hashes agree — the vendored copies *are* what the run of record read,
demonstrated by the instrument itself rather than by the copy that made
them. Those same eight SHA-256s agree a third time with the manifest table
in `imported/lattice_mapper/README.md`, checked line by line for this
entry: 8 of 8, 0 mismatches. `cp -p` preserved the mtimes, so even the
mtime field survives the move.

**Run 1 remains the run of record.** `results/base_ladder_crossing.json`
was not opened for writing, and still reads 215,439 B at mtime
2026-08-17 20:25 with SHA-256
`a0a070622873f424f23cdf1ce33437c0fbc21a1027828ea501b1e820fd5a1927`;
`results/base_ladder_crossing.csv` likewise. Entry 36 stands unamended.
`CONTEXT.md`'s O33 bullet still says the input "lived outside this repo at
run time … (the path `params.data_dir` records)" and that remains exactly
true of the run it describes — the repoint changes what a *future* run
reads, not what the recorded one did, and the bullet was deliberately not
edited. `CONTEXT.md` and `REFERENCES.md` were not touched by this pass.

Still EXPLORATORY. O33 has no prereg and fires no decision rule; run 2
reproduces run 1's numbers and reproduces its failed pre-stated
prediction with them — `summary.qualitative_split_matches_prestated`
reads `false` in both files, `bases_observed_crossing` `[2, 3]` in both.
Nothing here is a verdict.

No outcome marked.

---

## 2026-08-18 — Entry 47 — Is `(2,1)` a cancellation or a seeding artifact? The check splits the four zeros deep-versus-shallow
type: result-triage
refs: 12, 17, 29, 33, 36, 45, 46

The question came out of entry 17. That entry dismisses the triadic
table's `(2,1)` — "The single 0 is A_count at r = 1, which is the
construction … not a cancellation" — while the dyadic `(2,1)` is counted
among the four zeros without the same scrutiny. Entry 29 sharpened it:
under O27's convention the triadic table's one exact zero *is* `(2,1)`,
"and it is trivial: (1,3] holds {2,3} and (3,9] holds {5,7}, both count
2." So the cell nearest the seed is the cell whose reading moves with the
seed. The import recorded in entry 46 makes it testable, because it puts
a **third convention** on disk beside the two already here.

Everything below is read from artifacts named at each number. Nothing is
preregistered; no verdict is claimed and nothing is decided.

**`(2,1)` is convention-mobile — it moves with the seed and never with
the arithmetic.** Three conventions, one cell, `cell(2,1) = A(2) − A(1)`:

```text
  b                        2    3    4    5    6    7    8    9
  plain count              0    0    2    3    5    7   10   14
    = pi(b^2) - 2 pi(b)
  imported (2,3 as         0    2    4    5    7    9   12   16
    lattice, backward)
  archive (only 2          1    1    3    4    6    8   11   15
    dropped, forward)
```

Row 1 is `primecountpy.prime_pi`, computed for this entry. Row 2 is
`delta_1` at `regime 2` read out of the eight base-series tables in
`imported/lattice_mapper/32bit/` — `dyadic_difference_table_32.csv`,
`triadic_difference_table_32.csv`,
`tetradic_difference_table_32.csv`, `pentadic_difference_table_27.csv`,
`hexadic_difference_table_24.csv`, `heptadic_difference_table_22.csv`,
`octadic_difference_table_21.csv`, `enneadic_difference_table_20.csv`.
Row 3 is `delta_1` at `regime 1` read out of the eight archive tables at
`/Users/juliansambrano/GitHub/lattice_mapper/difference_tables/archive_unsilenced/32bit/`,
and it reproduces exactly when recomputed from `prime_pi` under that
convention.

Row 2 minus row 1 is **+2 at every base from 3 to 9 and 0 at base 2**.
The reason is geometric: the two excluded lattice primes are both in
`(b, b²]` for `b ≥ 3`, so they both leave `A(2)`; at `b = 2` they
straddle the boundary — 2 is in `(1,2]` and 3 is in `(2,4]` — so one
leaves `A(1)` and one leaves `A(2)` and the difference is untouched.
That is the whole of the base-2 exception, and it is a statement about
where 2 and 3 sit, not about cancellation.

**No convention makes `(2,1)` vanish at every base**, which is what a
pure seeding artifact would do. Plain count vanishes at `b = 2` and
`b = 3` and nowhere else. The imported convention vanishes at `b = 2`
only. The archive convention vanishes at no base at all. The cell is
mobile, but it is not free.

**Silencing can manufacture it, and the arithmetic of that is exact.**
Each additionally silenced prime landing in `(b, b²]` decrements
`cell(2,1)` by exactly one. Measured, `delta_1 @ regime 2`:

```text
  32bit/triadic_difference_table_32.csv             2
  32bit/triadic_difference_table_32_silence235.csv  1     (5 silenced)
  32bit/triadic_difference_table_32_silence2357.csv 0     (5 and 7)

  32bit/tetradic_difference_table_32.csv            4
  32bit/tetradic_..._silence2357.csv                2     (5, 7)
  32bit/tetradic_..._silence235711.csv              1     (5, 7, 11)
```

`(3,9]` holds `{5,7}`; `(4,16]` holds `{5,7,11,13}` and only three of
those are named. The 64bit triadic pair reproduces it — 2, 1, 0 across
`triadic_difference_table_40.csv`, `_silence235.csv`, `_silence2357.csv`.
So a `(2,1)` zero is available on demand in base 3 by naming two more
primes, and that is the strongest statement against reading the dyadic
`(2,1)` as the same kind of object as the deep two. Note also that
`triadic_difference_table_32_silence235.csv` carries a zero at
`(10,9)` — one exact zero, at depth 9, produced purely by silencing.
That cell is unexamined and is not chased here.

**All four dyadic zeros survive the convention change.**
`imported/lattice_mapper/32bit/dyadic_difference_table_32.csv` holds 496
populated cells over `r ≤ 32, d ≤ 31` and returns exactly

```text
  {(2,1), (4,1), (8,3), (20,6)}    and no other zero
```

`imported/lattice_mapper/64bit/dyadic_difference_table_64.csv` extends
the same construction to `r ≤ 64, d ≤ 63`, **2016 cells**, and returns
the same four and no fifth. The two files agree on all 496 overlapping
cells, 0 mismatches. This is a February generator in another repo, on
the excluded-lattice convention, and it lands on the same set that
entry 12 verified to `r ≤ 62, d ≤ 61` and that O27 rebuilt independently
(entry 29).

The 64bit file's own arithmetic was checked rather than assumed: its
`A_count` column matches backward differences of OEIS A007053 read from
`b007053.txt` at **all 64 regimes**, 0 mismatches, once the two lattice
primes are removed at `r = 1` and `r = 2`. It reaches `A(64) =
209366672181778359`, two regimes past this repo's own `pi2n_cache.json`
ceiling of `n = 62`.

That makes this a second confirmation of the census alongside O43
(`results/extended_zero_census.json`: `rmax_ext 92`, `cells_ext 4186`,
`cells_new 2295`, `K_new 0`, `n_reproduced 4`) — from different code in a
different repo written months earlier, and under a different convention.
It is *not* independent in the arithmetic: π(2ⁿ) is π(2ⁿ), and O43 reads
further, to `r = 92` against this file's 64. What is independent is the
construction and the seed convention, which is exactly the axis under
test here.

**`dyadic_prime_full_silenced_32.csv` is not a third confirmation.** It
is value-identical to `dyadic_difference_table_32.csv` on all **380**
overlapping cells, `A_count` column included, 0 mismatches, and returns
the same four zeros. It is a duplicate under another name, and counting
it would double-count.

**The composite side confirms the pair identity on data this project did
not generate.** Six composite variants, five distinct SHA-256 (two share
one — see entry 46):

```text
  file                                        (2,1) (4,1) (8,3) (20,6)  cells
  dyadic_composite_difference_table_32          1     4     16   8192    496
  dyadic_composite_difference_table_32_s46      0     5     16   8192    496
  dyadic_composite_difference_table_32_s468     0     6     16   8192    496
  dyadic_composite_extended_emptied_32          0     4     16   8192    380
  dyadic_composite_extended_emptied_32_s46      0     6     16   8192    380
  dyadic_composite_full_silenced_32             0     6     16   8192    380
```

`(8,3)` reads **16** and `(20,6)` reads **8192** in every one of the six,
and never moves. Those are `2^(r−1−d)` at `2⁴` and `2¹³` — exactly the
values `lean/PairIdentity.lean` proves the composite arm must carry where
the prime arm vanishes, and exactly the values entry 45 recorded as
`measured_composite_at_zeros = [1, 4, 16, 8192]` checked `by decide`
against `papers/The-Four-Zeros.md` § E2. Entry 45's check ran against
this project's own numbers. This one runs against tables generated in
**February 2026 by other code in another repo**, under a convention that
disagrees with ours at the seed, and the identity still holds at the two
deep cells. `dyadic_diff_full_silenced_32.csv` agrees independently:
`(4,1) = 6`, `(8,3) = 16`, `(20,6) = 8192`, which is forced, since its
prime arm is 0 at all four.

**`(4,1)` moves on the composite side, and the reason is visible in the
seed rows.** The six variants differ **only** in `A_count` at
`r = 1, 2, 3`:

```text
  A_count, r = 1..8
  composite (plain)                 1  2  2  6  11  25  51  105
  composite silence46               1  1  1  6  11  25  51  105
  composite silence468              1  1  0  6  11  25  51  105
  composite extended_emptied        0  0  2  6  11  25  51  105
  composite extended_empt_s46       0  0  0  6  11  25  51  105
  composite full_silenced           0  0  0  6  11  25  51  105
```

From `r = 4` onward every variant is byte-for-byte the same sequence.
`(4,1)` reads rows 3 and 4, so it lands inside the perturbed region and
takes the values 4 / 5 / 6 above. `(8,3)` reads rows 5–8 and `(20,6)`
reads rows 14–20; both windows sit entirely outside it, which is why they
cannot move whatever is silenced at the seed. The dyadic prime `(2,1)`
reads rows 1 and 2 — the two most perturbed rows in the whole file.

**The finding worth recording: the useful cut is not four-versus-three,
it is deep versus shallow.** `(8,3)` and `(20,6)` are unmoved by every
convention, every silencing set and every generator tried here — three
seed conventions, six composite variants, two independent repos, and
O43's census to `r = 92`. `(2,1)` and `(4,1)` both sit close enough to
the seed that low-`r` choices reach them: `(2,1)` reads the two rows the
lattice convention edits, `(4,1)` reads the last row the silencing sets
edit. That is a property of window position, not of arithmetic depth,
and it is measurable — which four-versus-three is not, until someone
fixes a convention.

This echoes `lean/Zeros.lean` from an independent direction. Its
`window_exclusive_of_prime_exponent` proves that depth 6 spans a ratio of
`2^7`, 7 is prime, so `b^k = 2^7` with `b ≥ 2, k ≥ 2` forces
`b = 2, k = 7` — **(20,6) is base-2 exclusive**. Its
`window_shared_of_composite_exponent` is the one line `(4:ℕ)^2 = 2^4`:
depth 3 spans `2^4 = 4^2`, so base 4 reaches `(8,3)`'s window at depth 1,
and the file's own comment says "the two deep zeros are different kinds
of object". That splits the deep pair by *base reachability*. The
composite data above splits all four by *seed reachability*. The two cuts
are not the same cut, and they do not have to agree — but both say the
four zeros are not one homogeneous set, arrived at from proof and from
February data respectively.

**Entry 17's claim, re-examined and verified as written.** Entry 17 says
of `triadic_difference_table_32.csv`: "**Confirmed: no exact zero in any
delta column.** The single 0 is A_count at r = 1", with near-misses
`(3,2) = 1`, `(5,4) = 1`, `(11,10) = 2`, `(8,7) = 9`, `(10,9) = 9`. Every
one of those reads back exactly from the imported copy of that file — 496
cells, **zero** exact zeros in any delta column, `A_count` zero only at
`r = 1`. The claim is true of the file it cites.

It is also **convention-dependent, and that convention is not the one any
in-repo artifact uses.** The same file reads `cell(2,1) = 2`, tying
`(11,10)` for third-smallest and unlisted in entry 17's near-miss table.
Under O27's convention — `pi(1) = 0`, block `r` is `(b^(r−1), b^r]`, 2 and
3 counted as primes, so `N_3(1) = 2` (entry 29) — the same triadic table
reads differently: `results/joint_dyadic_triadic_table.json` over its 820
triadic cells at depth ≥ 1 has minimum `|cell| = 0` at `(2,1)`, next
smallest `2` at `(4,3)`, then `3` at `(3,1)`, `(3,2)`, `(5,4)`, and
**not one cell anywhere in the triangle takes the value ±1**. So "base 3
reaches 1, twice" and "no exact zero" are both true of entry 17's file and
both false of O27's. Entry 17's open discrepancy — that the magnitude
argument does not separate the bases — was argued from the reading where
base 3 gets closest without landing. On the in-repo reading base 3 lands
at `(2,1)` and never gets close anywhere else. The discrepancy is not
resolved here; it is relocated, and which reading it should be argued from
is not this entry's call.

**Disclosed prediction, and where it failed.** Before opening any file,
this assistant predicted `cell(2,1)` would vanish at `b = 2` and `b = 3`
and read 2, 3, 5, 7, 10, 14 at `b = 4…9`. That prediction reproduced the
plain-count computation **exactly** — row 1 of the table above is
identical to it, digit for digit. It also **contradicted every base-series
file on disk except base 2**, because the imported tables run on the
excluded-lattice convention and read 2, 4, 5, 7, 9, 12, 16 where the
prediction said 0, 2, 3, 5, 7, 10, 14. Both halves are recorded because
the failure is the informative one: a correct computation of the wrong
convention is exactly the error the import in entry 46 exists to prevent,
and it was made anyway, by the same pass that made the import.

Nothing here decides whether the count is four zeros or three. No outcome
marked.

---

## 2026-08-18 — Entry 46 — The lattice_mapper difference tables imported: 27 files, one convention, and the two generations left behind
type: provenance
refs: 17, 36

Entry 17's central piece of adversarial evidence was a file this repo did
not contain. That entry reads: "Julian supplied `triadic_difference_table_32.csv`
(r = 1…32, d = 1…31, built with 2 and 3 excluded as lattice rather than
counted as primes)", and everything it concludes about base 3 — "no exact
zero in any delta column", "Base 3 reaches **1**, twice" — is a reading of
that file. The file lived at
`/Users/juliansambrano/GitHub/lattice_mapper/difference_tables/32bit/`,
outside this repo, with **no pointer to it in `CONTEXT.md` or
`REFERENCES.md`**. Entry 36 later read the same source directory for O33
and recorded the convention and a stale README there, and that pointer was
never promoted into the commitment files either. This import closes that
gap: the evidence now sits with the work that cites it.

**What was imported.** `imported/lattice_mapper/`, copied 2026-08-18
byte-for-byte with `cp -p`, every file SHA-256 verified source-vs-
destination at copy time. **27 files**: 22 from `32bit/` — the complete
directory, 12 base-series tables for bases 2 through 9 plus 10 dyadic
prime/composite split files — 4 from `64bit/`, and the source README
under the name `source_README.md`. The `32bit/` and `64bit/` split is
preserved. `imported/lattice_mapper/README.md` is the import manifest,
written for this repo, and carries the full SHA-256 and source-mtime table.

Re-verified for this entry, not taken on the manifest's word: all 26 CSVs
plus `source_README.md` hash identically to their source counterparts
today, **0 mismatches**. Source mtimes are all 2026-02-11 except the
README's 2026-02-09, and `cp -p` preserved them.

**The convention these tables use.** Power-regime, **backward**
differences: `A(n) = π(bⁿ) − π(bⁿ⁻¹)`, with `delta_d` at regime `r` the
`d`-th backward difference ending at `r`. And — the part that matters —
**the primes 2 and 3 are excluded as lattice, not counted as primes.**
`A(1) = π(b) − 2` for `b ≥ 3`; at `b = 2` the two lattice primes straddle
the regime boundary, 2 in `(1,2]` and 3 in `(2,4]`, so one is dropped from
each of `A(1)` and `A(2)`. The generator is
`/Users/juliansambrano/GitHub/lattice_mapper/difference_table.py:75`,
`silenced_primepi(x)`, whose docstring reads "pi(x) with 2 and 3
silenced. … 2 and 3 are not primes in this framework — they are the
scaffold that generates the 6k±1 lattice." Entry 36 recorded this line
already, from the same source directory.

**This is not the convention any in-repo artifact uses.** O27's
first-block convention is `pi(1) = 0`, block `r` is `(b^(r−1), b^r]`, with
2 and 3 counted — `N_2(1) = 1`, `N_3(1) = 2` (entry 29). The dyadic
tables O16 and O43 build carry the same. So a number lifted from
`imported/` and a number lifted from `results/` are not comparable at low
`r` without stating which convention is in force. That is the reason the
import lives in its own directory with its own manifest rather than being
merged anywhere.

**Three generations, three conventions, two difference directions.** The
source directory holds more than was taken. `archive_unsilenced/` was
**deliberately excluded**, and it differs on every axis:

```text
  imported here     backward differences, 2 and 3 excluded as lattice
                    (difference_table.py:75)
  archive, power    FORWARD differences, ONLY 2 dropped
    regime          (archive_unsilenced/gen_difference_table.py:22-29 —
                    silenced_primepi subtracts 1)
  archive,          a THIRD schema: header column `pi_n`, integer regime
    *_64bit_*.csv   (triadic_difference_table_64bit_64.csv et al.)
```

The direction was checked from the data, not from docstrings — entry 36
warns that the generator's docstring and its output disagree. In the
archive dyadic table `A = 0, 1, 2, 2` and `delta_1 @ r3 = 0 = A(4) − A(3)`,
which is forward. In the imported dyadic table `A = 0, 0, 2, 2` and
`delta_1 @ r3 = 2 = A(3) − A(2)`, which is backward.

Mixing those in one imported directory is the confusion this import
exists to end. The archive remains readable in place and is not deleted,
moved or touched:

```text
  /Users/juliansambrano/GitHub/lattice_mapper/difference_tables/archive_unsilenced/
```

Its size, measured for this entry: **33 files, 59,069,876 bytes**, of
which 9 `.bin`/`.hex` binaries account for 25,339,552 bytes. The
manifest's "~58 MB of binaries" describes the directory total (56.3 MiB),
not the binary files alone; recorded, not corrected.

**`source_README.md` is stale on `64bit/`, and is flagged rather than
fixed.** It describes `64bit/` as an "Integer-regime table: pi(n) for
n = 1..64" — but both imported `64bit/` files are power-regime `A_count`
tables on the same convention as `32bit/`, verified identical to `32bit/`
on all 496 overlapping cells. The description fits the
`archive_unsilenced/*_64bit_*` files instead. The staleness runs further
than the manifest notes: the README's folder list names `128bit/`,
`1000/` and `2pow20/`, and those directories exist only *inside*
`archive_unsilenced/`, not at `difference_tables/` top level; and it
states the convention as "regime 2 is silent (pi(2) = 0). The prime 2 is
not counted" — the one-prime convention, which is the archive's, not the
imported files'. It was imported verbatim as the record of what the
source directory said about itself, and every claim in it that this pass
checked is noted here rather than edited.

Note the two same-named generators: `difference_table.py:75` defines
`silenced_primepi` removing **two** primes, and
`archive_unsilenced/gen_difference_table.py:22-29` defines
`silenced_primepi` removing **one**. Same function name, different
convention, different file. That is how the README came to describe the
wrong one.

**One byte-identical pair, preserved under both names.**
`32bit/dyadic_composite_extended_emptied_32_silence46.csv` and
`32bit/dyadic_composite_full_silenced_32.csv` share SHA-256
`a0030692739c7ddaada77f7b2cb81e8364ab3f9753970e1e8f6e63d058d53b6a` — they
are byte-identical in the source, under two names and two source mtimes
(12:13:27 and 12:20:04). Both were imported as-is rather than
deduplicated, because the pair is itself the provenance fact. Anyone
counting "six composite variants" is counting five distinct files.

**`lattice_mapper/` was verified unmodified.** No file anywhere under
`/Users/juliansambrano/GitHub/lattice_mapper/` carries an mtime later
than 2026-08-01; the newest under `difference_tables/` is 2026-02-11.
Every imported file's source counterpart hashes identically today. The
source tree was read-only throughout and remains so. Nothing in this repo
regenerates these files, and nothing should: they are imported evidence,
not outputs of this bench.

`CONTEXT.md` and `REFERENCES.md` still have no pointer to
`imported/lattice_mapper/`. The candidate lines are reported to Julian
separately; neither file was edited.

No outcome marked.

---

## 2026-08-18 — Entry 45 — the pair identity proved in Lean, and the row hypothesis that had to be window-local
type: formalization
refs: 12, 17, 26, 33

`papers/Formalization.md` § D5 reads, in full: "Blocks D through I of the
chain remain unencoded — the winding, the pair identity, the transform
results." The pair identity is now encoded and proved.
`lean/PairIdentity.lean` (15610 B, sha256
`0383a9e23ac642cf2a5135ad484cb43af7ff12180c7d7c070e90234c5552877f`,
12 theorems and 2 defs) carries statement **I1** of
`papers/Euler-Factor-Chain.md` § I outright, with no numerical input.
The winding and the transform results were not touched and D5 still
stands for them.

One wording note, recorded rather than fixed: the pair identity is the
**second** of the three items D5 names, not the first. Nothing in
`papers/` was edited in this pass.

**What the notebook already had, and at what strength.** Entry 33 wrote
the identity down — `prime(r,d) + composite(r,d) = (b-1)^(d+1) *
b^(r-1-d)` — and read the four exact zeros as its poles, with the
composite values 1, 4, 16, 8192 the identity forces. Entry 17 recorded
the geometric fact underneath it, that differencing a geometrically
growing sequence "rescales by (b−1)^d and returns nothing", and entry 26
filed the composite identity as rediscovery from Julian's own repos
(OBS-011, February). None of that was a derivation; it was a check.
Read again for this entry,
`results/O16_centered_difference_table_run2.json` →
`summary.identity_a_backward` carries `statement`
`composite_B(r,d) == 2^(r-d-1) - prime_B(r,d)`, `cells_checked` **1953**,
`mismatches` **0**, `passed` true — the same 1953 cells entries 17, 26
and 33 all cite back to entry 12.

**The theorem, verbatim from `lean/PairIdentity.lean:138`.**

```text
theorem pair_identity (b : ℤ) (P C : ℤ → ℤ) (r : ℤ) (d e : ℕ)
    (hr : r = (d : ℤ) + 1 + e)
    (hpair : ∀ k : ℕ, k ≤ d → P (r - k) + C (r - k) = (b - 1) * b ^ (e + (d - k))) :
    tableFrom P r d + tableFrom C r d = (b - 1) ^ (d + 1) * b ^ e
```

**The hypotheses it actually needed — two, and neither is about primes.**
`hr` pins the exponent. `hpair` says the two rows partition each rung of
the window the cell reads. There is **no hypothesis on `b` at all** — not
`2 ≤ b`, not `b ≠ 0` — so this is general integer `b`, not base 2
special-cased. And there is no hypothesis on `P` or `C` beyond the
partition: the seed rows are arbitrary functions `ℤ → ℤ`, and the proof
never knows that `P` counts primes. The file states the consequence in
its own words at line 133: "Nothing in the proof knows that `P` counts
primes — the identity is forced by the partition alone, and the whole
content of the prime/composite split is that it is a partition of a
geometric row." That is the sharpest form of what entry 33 called the
sum being fixed and known in advance while only the split is free.

**The index convention it settled on** (file lines 43–48).
`Construction.tableFrom` puts depth `d` at `d` backward differences of
the depth-0 row, and the depth-0 row is the per-rung count, itself
already one difference of the cumulative count. So `d` in Lean is the
paper's `d`, and the exponent `r−1−d` is carried as a **natural number
`e` with `r = d + 1 + e`**. That keeps every exponent in ℕ and every
rung inside the table's support, which is why `hr` appears as a
hypothesis rather than the exponent being written `r - 1 - d` and
truncating.

**The supporting arrows.** `symbol_at_one` names
`EulerFactorChain.symbol_of_backward_difference` (A1) at `ρ = 1`;
`backward_difference_pow` moves that step into ℤ where the table lives;
`tableFrom_of_geometric` iterates it to the collapse
`tableFrom G r d = (b - 1) ^ d * G (r - d)`; `tableFrom_add_window`
supplies linearity localised to the window, out of
`Construction.tableFrom_add` and `Construction.zero_determined_by_row`.
`composite_of_prime_zero` is I5, the pole: where the prime arm vanishes
the composite arm carries the whole total. `composite_at_zero_20_6`
instantiates it at (20,6) and returns 8192.

**THE FINDING WORTH RECORDING — a globally-stated row hypothesis would
have been vacuous.** The natural way to write "the row is geometric" is
`∀ r, G r = b * G (r-1)` over all of ℤ. For `|b| ≥ 2` that hypothesis
has exactly one solution, `G = 0`: iterating gives `G r = b^n * G (r-n)`
for every `n`, so `b^n` divides `G r` for every `n`, and only 0 is
divisible by arbitrarily high powers of `b`. A theorem assuming it would
be true and empty. The hypothesis had to be **window-local** — in
`tableFrom_of_geometric` it is `∀ k : ℕ, k < d → G (r - k) = b * G (r - k - 1)`,
asking only for the `d` steps inside the window `r, r−1, …, r−d` that
the cell at `(r,d)` actually reads. That is the same locality
`Construction.zero_determined_by_row` already carries (`∀ k : ℕ, k ≤ d →
N (r - k) = M (r - k)`), so the pattern was in the tree before this file
needed it.

**A discrepancy in the file's own comment on that point, not adjusted.**
`lean/PairIdentity.lean:80–82` states the vacuousness as "No total
function `ℤ → ℤ` satisfies `G r = b * G (r−1)` at every `r` except
`G = 0`", with no condition on `b`. As written that is false: at `b = 1`
every constant function satisfies it, and at `b = −1` every
sign-alternating function does. The claim needs `|b| ≥ 2`. The comment
is prose in a docstring, carries no proof obligation and does not enter
any theorem — nothing in the file is wrong — but the sentence is
overstated and is recorded here rather than edited, since `lean/` was
out of scope for this pass.

**The corollary, and its exact reach.**

```text
coeff_eq_one_iff_base_two {b : ℤ} (hb : 2 ≤ b) (d : ℕ) :
    (b - 1) ^ (d + 1) = 1 ↔ b = 2

total_eq_pow_iff_base_two {b : ℤ} (hb : 2 ≤ b) (d e : ℕ) :
    (b - 1) ^ (d + 1) * b ^ e = b ^ e ↔ b = 2
```

Here the hypothesis `2 ≤ b` does appear — the corollary needs it, the
identity does not. `base_three_carries_factor` and
`base_four_carries_factor` are the witnesses: base 3 carries
`2^(d+1)·3^e`, base 4 carries `3^(d+1)·4^e`, never a bare power.

What it **does** say: base two is the only integer base ≥ 2 whose cell
total is a bare power of the base, so it is the only grid on which a
vanished prime arm leaves the composite arm sitting exactly on a power
of the grid. What it **does not** say, in the file's own words at lines
35–38: "It is a statement about the FORM OF THE TOTAL, not about zeros.
Nothing here predicts, or could predict, where either arm vanishes." So
it does **not** close entry 17's open discrepancy. Entry 17 offered
`(b−1)/b` minimised at `b = 2` as the reason the zeros are there, then
recorded that the triadic table reaches 1 twice without ever hitting 0,
so the magnitude argument does not separate the bases. This corollary is
a different statement about a different quantity, and entry 17's
discrepancy stands exactly where it stood.

**The measured check, and it matched.** The file records the four zero
cells as `zero_cells = [(2,1), (4,1), (8,3), (20,6)]` — the same list as
`Zeros.measured_zeros` and `Construction.measured_zeros` — and the
composite arm at them as `measured_composite_at_zeros = [1, 4, 16, 8192]`,
read from `papers/The-Four-Zeros.md` § E2 ("At the four zeros the
composite arm therefore carries the whole term: `1, 4, 16, 8192`",
line 121–122). `measured_composite_matches_pair_identity` evaluates
`(b−1)^(d+1)·b^(r−1−d)` at `b = 2` and those four cells and proves the
result equals the measured list, `by decide`. It compiles, so they agree:

```text
  (2,1)   2^0  =     1   matched
  (4,1)   2^2  =     4   matched
  (8,3)   2^4  =    16   matched
  (20,6)  2^13 =  8192   matched
```

These are the same four numbers entry 33 tabulated. They are inputs to a
check, not to a proof — the formula is derived from the partition alone
above them — and had any of the four disagreed the file would not build.

**`#print axioms`, verified rather than quoted.** The file pins each
result with a `#guard_msgs` block, so a drift would fail `lake build`.
Independently re-run for this entry via `lake env lean` on a scratch
file importing `PairIdentity`; the twelve lines below are that output
verbatim, and they match the twelve docstrings in the file exactly.

```text
  symbol_at_one                          [propext, Classical.choice, Quot.sound]
  backward_difference_pow                [propext, Quot.sound]
  tableFrom_of_geometric                 [propext, Quot.sound]
  tableFrom_add_window                   [propext, Quot.sound]
  pair_identity                          [propext, Quot.sound]
  composite_of_prime_zero                [propext, Quot.sound]
  coeff_eq_one_iff_base_two              [propext, Classical.choice, Quot.sound]
  total_eq_pow_iff_base_two              [propext, Classical.choice, Quot.sound]
  base_three_carries_factor              [propext]
  base_four_carries_factor               [propext]
  measured_composite_matches_pair_identity  [propext]
  composite_at_zero_20_6                 [propext, Quot.sound]
```

**Nine of the twelve are `Classical.choice`-free**, including
`pair_identity` and `composite_of_prime_zero` — the identity and the
pole are constructive. The three that are not are `symbol_at_one`, which
inherits it from the ℂ-valued A1 statement it names, and the two
`iff_base_two` corollaries, which get it through the `omega` / `nlinarith`
route. Three results depend on `propext` alone.

**Build.** `lean/lakefile.toml` changed by one line: `PairIdentity`
appended to the `[[lean_lib]]` `globs` list, taking the library from nine
modules to ten. New sha256
`b144eb9926b3a3e12f976c5f9eaee15cf63a01abe46725ac39db25e1e1508d36`,
462 B. Job count either side:

```text
  before   8027 jobs   lean/build.log line 71, the 09:41 build of the
                       nine-module library
  after    8036 jobs   lake build, run for this entry, exit clean
  delta      +9
```

`Build completed successfully (8036 jobs).` The only warnings are the
pre-existing unused-variable and unused-simp-argument linter notes in
`Crossover.lean` and `EulerFactorChain.lean`; `PairIdentity.lean` emits
none.

**What this confirms, and what it leaves alone.** It confirms the
account in entries 12, 17, 26 and 33: the identity is exact, it is not
about primes, and the four composite values are forced by the grid. It
refutes nothing in the notebook. It does not locate a zero — the file
says so twice, at lines 274–278 — so entry 26's last-vanishing question
and entry 17's base-2 discrepancy are both untouched, and `Zeros.lean`'s
hole stays open.

No outcome marked.

---
