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

- [ ] C1. The Landau deviation: measured ratios drift 1.00000 -> 1.00042 as
        d: 1 -> 9 (entry 236 table). Measure properly: deviation vs d and vs b,
        against Landau's known error-term shape. Question: does it scale like
        the unconditional error term, or exceed it? Is its base-dependence
        Λ(b) like the main term, or something else? RH lives in the error
        term; the main term is unconditional. Artifact: script + log + entry.
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

## D. Ledger (unchanged by all of the above)

- hEF: OPEN. Routed around, not discharged. Build order exists (adversary
  report 2026-08-28, § separate section): slices 1a (truncated Perron kernel
  — the ONE missing piece, zeta-free, self-contained), 1b, 1c, 2, 3, 4.
  RH does not make 1a easier.
- StmtArgCrude: OPEN, untouched.
- The four exact zeros (2,1),(4,1),(8,3),(20,6): UNEXPLAINED. Elephant proves
  what the filter is, not why the filtered sum vanishes there. Entry 236's
  null says unremarkable; the null may be the wrong question.
- Two locked preregs await Julian's verdict lines: multibase_synthesis
  (inconclusive), dense_boundary_scan (no_step).
