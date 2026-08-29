# The mapped path — steps, checkable

Written 2026-08-28 with Julian. Rule: each step is DONE only when it points at
a real artifact (a Lean declaration, a script + log, an entry). Crossing off
means adding the pointer, nothing else. New finds cross off steps; they do not
redraw the map. If a step turns out wrong, it gets marked WRONG with a pointer
to what showed it — it does not get silently deleted.

Vocabulary (Julian's, keep it):

- MOUTH/STOMACH: hRH is eaten at exactly one place (Slice3/4's distance bound)
  and only its digest travels downstream. The digest is two scalars: a count
  and a distance. Never a position.
- THE CURVE: the coupling main term (T/2pi)*Lambda(b)*(1-(1-1/b)^d) —
  arithmetic (Lambda) times resolution (1-(1-1/b)^d), multiplicatively
  separated. Depth buys resolution, never arithmetic.
- THE GAP: what a route pays for not touching the infinite object. Measured
  once already: one logarithm (k=3 vs von Koch's k=2) is the price of
  coarsening per-zero weights into a sup. The gap is the proof — the object
  of study, not the obstacle.

## A. Fix the proof we have

- [ ] A1. Pin parity in LineBound.lean: 70 theorems -> 70 #guard_msgs-pinned
        #print axioms. (Adversary defect E1; CLAUDE.md Stage-3 conventions.)
- [ ] A2. Remove the three "Scratch only." headers and the dead citation to
        slice3.lean/slice4.lean (LineBound.lean:11,342,774,785).
- [ ] A3. Correction entry: entry 240's stated reason hNT is unused ("zero
        sum never appears") is wrong. Correct reason: a crude local count
        (29 log t + 129, in-house) suffices where hNT is a sharp global N(T).
        Zero information IS consumed — as a count and a distance, never a
        position.
- [ ] A4. Dedup: zeta_ne_zero_of_RH x3, finalBoundConst_le x2, log_3029_ge
        proved twice. Cosmetic; do with A1.

## B. The equivalence (the route we hold)

- [x] B1. von Koch converse in Lean: DONE 2026-08-28.
        [ARTIFACT: lean_stage3/Stage3/VonKochScaffold.lean —
        `VonKoch.RH_of_psiWeak`, axioms [propext, Classical.choice,
        Quot.sound], no sorryAx; V1–V5 all proved]
        (∃ C x₀, ∀ t ≥ x₀, |ψ t − t| ≤ C·√t·(log t)^3) → RiemannHypothesis.
        V3/V4 as built: the identity theorem ran on G := F·ζ + ζ′ over the
        half-plane minus the SINGLE point 1 (four convex pieces) — the
        countable zero set never entered a connectivity argument. V4 factors
        ζ = (z−ρ)^(k+1)·g at a hypothetical zero and contradicts g ρ ≠ 0.
- [x] B2. The iff, stated and pinned: DONE 2026-08-28.
        [ARTIFACT: same file — `VonKoch.RH_iff_psiWeak`, #guard_msgs-pinned:
        RiemannHypothesis ↔ ∃ C > 0, ∃ x₀, Stage3.StmtPsiWeak C 3 x₀]
        Forward half RHPull.stmtPsiWeak_of_RH (e8a1801); converse B1.
- [x] B3. Entry logging the equivalence as an artifact: DONE 2026-08-28.
        [ARTIFACT: notes/lab_notebook_2.md entry 242, formalization; three
        NOTEPAD lines; commit 31473ae]

## C. The gap, measured (outside the known routes)

- [x] C1. The Landau deviation: MEASURED (exploratory) 2026-08-28.
        [ARTIFACT: analysis/2026-08-28/landau_deviation.py + results/
        landau_deviation.log + entry 243]
        Answer 1: scales LIKE the unconditional envelope (slope +0.589 vs
        +0.500; flat would be 0.000) at ~3% of sqrt(x)log(xT) — inside it,
        no crossing to x=512. Answer 2: base-dependence is NOT Λ(b)
        (corr −0.065; Λ=0 bases deviate at the same scale). Curve reads
        arithmetic, deviation reads size — different axes. Exact identity:
        D(b,d) = Σ C(d,k)(−1)^k b^(−k/2) δ(b^k), verified 2.6e-9.
- [ ] C2. Pin Nyman–Beurling and Báez-Duarte from SOURCE (not recall — neither
        exists in Mathlib or PNT+; verified 2026-08-28, the "Baez" hit is
        J. Baez on Coxeter diagrams). Need: exact NB criterion; BD
        discretization; the conjectured C/log N rate. Artifact: statements in
        the roadmap's companion Lean file as named Props with citation shape,
        marked unverified until checked against a source.
- [ ] C3. The b-adic span question, stated precisely: Sym at base b is a
        dilation-difference f(x) − f(x/b); NB's family is all dilations; one
        base gives the geometrically thin subfamily {1,b,b²,…}. Question: how
        much of the NB span does the multi-base family reach, and does the
        distance close as bases are added? "Lacks the infinite sum of primes"
        = the single-base family is too thin to span. Artifact: first a
        precise statement (after C2), then a measurement on zeros1.txt.
- [ ] C4. Julian's trajectory principle, held until it can be stated
        checkably: you can't go backward without changing the trajectory
        (grandfather paradox); the small angles track the curve of infinity
        without touching it — touching would change the infinite sum; the
        proof of connection is the absence of time between two events and the
        diffs (being changed through the process). Candidate formalization
        direction: the gap between finite truncation and the infinite object
        as the invariant to measure (this is what C1–C3 each measure a piece
        of). Not crossable-off until it has a testable statement; it stays
        here so it is not lost.

## D. Ledger (updated 2026-08-28 end of day)

- hEF: OPEN, and its load-bearing unknown is DISCHARGED. Slice 1a —
  perron_kernel_truncated — is PROVED sorry-free (2026-08-29),
  #guard_msgs-pinned at [propext, Classical.choice, Quot.sound].
  [ARTIFACTS: entry 257 (build order); lean_stage3/Stage3/PerronKernel.lean
  (COMPLETE: K1 both cases, K2 both cases, pole crossed via dslope +
  ResidueTheoremOnRectangleWithSimplePole; the classical arc was never
  needed)]. Slices 1b (entry 259, far_terms_sum) and 1c (entry 260,
  near_diagonal_sum) ALSO PROVED — slice 1's analytic content complete,
  one file, one axiom set. Slice-1 assembly + Fubini PROVED (entry 261,
  explicit_formula_perron: ψ vs the −ζ′/ζ integral, 600·x·log(xT)²/T +
  13·log x, commit 04395ad). Slice 2 PROVED (entry 262, goodT_exists:
  good-height pigeonhole, gap 1/(180·log T + 1060), commit 58045ed;
  scaffold lean_stage3/Stage3/ContourShift.lean). SLICE 4
  DISCHARGED (entry 264, commit 8ca3b02): residue_identity — the
  good-rectangle contour of (−ζ′/ζ)x^s/s equals
  x − ζ′/ζ(0) − zeroPartialSum x T′, pinned clean, no sorryAx.
  Analytic layer was entry 263 (commits 2664700..2f795dd). Remaining:
  the final StmtExplicitFormula glue (S1+S2+S3+S4) and S3 edge_bound.
  S3's load-bearing unknown DISCHARGED (entry 265, ZetaGrowth.lean,
  commits 8552ffd..ca582d1): zeta continued to re > −1 by second-order
  Euler–Maclaurin (Mellin analyticity + identity theorem). S3
  analytic inputs COMPLETE (entry 266, commits 0341f71/7027223):
  ‖ζ(σ+it)‖ ≤ 15t² explicit on the band, sq_zeta_band_bound with
  compact patch. Reflection-order PROVED
  (entry 267, commits 83f2531/adad131): m(1−conj ρ) = m(ρ). RESCALE
  PROVED (entry 268, EdgeBound.gz_partial_fraction, commit e452638):
  the Landau partial fraction at 3/2+iT′ over the segment
  re ∈ [−1/4, 2], error C·log T′. S3 COMPLETE (entry 269,
  edge_bound_core, commits 905dcd0..624bf67): all four hEF slices
  proved. Glue pieces 1–2 of 4 PROVED
  (entry 270, Glue.lean: band count + height swap). Remaining: edge
  integrals (piece 3), rectangle splitting + final assembly in the
  T ≤ x² regime (piece 4) + the 3-line consumer patch — per entry 257, "no
  step needs mathematics absent from the literature or from either
  library." 
- StmtArgCrude: OPEN, untouched.
- The four exact zeros: reframed by entries 253-255. The census ranks
  them by information ((20,6) carries 2.85 digits; the rest near-free);
  the expensive-balance family {(20,6),(39,14),(13,5)}₂ ∪ {(11,9)}₃ hugs
  the drift-reachability frontier; every table runs the same economy.
  The WHY is still unproved; the question is now cross-table.
- All three verdict lines stamped by Julian 2026-08-28:
  floor_deterministic (O97, blind-range pass), inconclusive
  (multibase_synthesis; ceiling ramp is the recorded next step),
  no_step (dense_boundary_scan).
