# The sections and the joints

What is built in the three Lean trees, as sections with an exact statement at
each end, and where each joins the next. Written 2026-11-22 for Julian, who
put the sections together one decision at a time and asked for the build on
one page.

How this page was made, so it can be remade (CLAUDE.md, "load, don't recall"):
the module, theorem and statement counts and the list of joints come from a
script over the `.lean` files (theorem headers that mention a `Stmt*`
definition, `RiemannHypothesis`, or `tableFrom … ≠ 0`). Read in full by the
agent: `Stage3/Statement.lean` and the sixteen `Stage3/Landau*.lean`. Read by
statement only: everything else. A proof that was not read is marked by what
the build says about it and nothing more.

    tree           toolchain   modules   theorems and lemmas   sorry
    lean/          v4.28.0     29        345                   0
    lean_stage3/   v4.32.2     76        872                   1
    lean_bridge/   v4.33.0-rc2 1         17                    0

The one `sorry` is `WeilPowerAssembly.detect_gap_exists`, declared in its
block and pinned with `sorryAx`.

## The sections

**A. The table.** `lean/Construction`, `Zeros`, `PairIdentity`.
The difference table of the dyadic prime counts: its definition, that the row
forces every cell (`unique_of_isTableOf`), the four exact zeros computed
(`measured_zeros_all_vanish`), a zero as a repeat one depth up
(`zero_iff_repeat`), and prime cell plus composite cell equal to
`(b−1)^(d+1)·b^e` (`pair_identity`). Needs nothing. Everything else stands on it.

**B. Modes and the symbol.** `lean/Chain`, `Superposition`, `Transform`.
A mode `b^(ρr)` along the rows is multiplied by the symbol at each depth
(`depth_reweights_each_mode`); the zeros of ζ sit in a fundamental annulus;
three theorems `RiemannHypothesis ↔ <geometric condition>`. In: nothing.
Out: how each zero of ζ acts on the table.

**C. The census gate.** `lean/Nonvanishing`, `MainTerm`, `Expansion`,
`Schoenfeld`, `RelativeGate`.
A bound on the residual `π(2^m) − L(m)` across a window of rows makes the
cell nonzero. Two inlets:
- `StmtSchoenfeldWindow` (RH shape, constant `1/(8π)`) → `tableFrom_ne_zero_of_li`;
- `StmtRelErrWindow f L r n ρ` (any relative error `ρ`) with the gap
  `ρ < (log 2)^d / (2·r·3^(d+1))` (`relGate_iff`) → `tableFrom_ne_zero_of_relErr`.
  `powerSaving_relErr` turns `|f(m) − L(m)| ≤ A·(2^m)^θ`, `θ ≤ 1`, into the
  second inlet.
Out: `Construction.tableFrom N r d ≠ 0`.

**D. The dial.** `Stage3/Abscissa`, `LineBound`, `ThetaLine`, `ThetaPull`,
`ThetaPsi`, `ThetaPi`, `ThetaConverse`, `PsiToPi`, `VonKochScaffold`, `Statement`.
For `θ` in `[1/2, 1)`:
- `StmtZeroFreeRight θ ↔ ∃ C x₀, |ψ(t) − t| ≤ C·t^θ·log³t` (`zeroFreeRight_iff_psiWeakTheta`);
- `StmtZeroFreeRight θ → ∃ C x₀, |π(x) − Li(x)| ≤ C·x^θ·log²x` (`schoenfeldWeakTheta_of_zeroFree`);
- `RiemannHypothesis ↔` the ψ bound at `θ = 1/2` (`RH_iff_psiWeak`);
- the `√x` bound carried to the dyadic rows (`weakWindow_of_global`,
  `weakWindow_at_schoenfeld`, `window_of_global`).
In: a zero-free half-plane. Out: a bound on the prime residual, for all large `x`.

**E. The count of zeros.** `Stage3/Assembly`, `Glue`, `ArgCrude`, `ArgCount`,
`ArgIdentity`, `JensenCount`, `Stirling`, `RvMCrude`, `ZeroSum`, and others.
Riemann–von Mangoldt with explicit constants from the argument of ζ, and the
explicit formula under RH (`psiWeak_of_RH_EF_NT`). Named statements:
`StmtSCrude`, `StmtLocalCount`, `StmtArgIdentity`, `StmtBacklundPhase` (each
has a `_holds` theorem), `StmtSFromLocal`, `StmtExplicitFormulaPoly`. Not
read; the status of each leaf is its own unit's to state.

**F. The Weil ladder.** `Stage3/Weil*` (about thirty modules),
`WeilBridgeLeaf`, `lean_bridge/`.
Weil's form on a window, to detect a zero off the line:
`box_empty_of_positive_of_detect` from `StmtWeilPositive` and `StmtDetect`;
`zeroForm_eq_primeSide` from `StmtWeilBridge`, which `lean_bridge` proves
against zeta23 (`stmtWeilBridge_holds`). Open inside it: `StmtDetectGap`
(the `sorry`), `StmtShortCount`, `StmtWeilPositive`. Worksheet:
`lean_stage3/design/rung5.md`.

**G. The Landau window.** `Stage3/Landau*` (sixteen modules, units 0384–0399).
`WindowBound θ δ C → ∀ s, θ < Re s → ζ(s) ≠ 0` (`stmtLandauWindow`), and
`rh_of_windows`. In: a one-sided bound on `G` on long windows, proved
nowhere. Out: a zero-free half-plane.

## The joints

SEALED = one tree, the kernel checks it. WELD = two trees, the statement is
copied and `utilities/check_weld.py` compares the text. OPEN = the lemma is
not in any tree; what it must say is written out.

| # | From → to | Status |
|---|---|---|
| 1 | G → D: `WindowBound θ δ C → StmtZeroFreeRight θ` | SEALED (unit 0400, `JointWindowDial.zeroFreeRight_of_window`; with it `schoenfeldWeakTheta_of_window`, the window bound carried to `|π − Li| ≤ C·x^θ·log²x`). |
| 2 | D inside: zero-free at `θ` → `|π − Li| ≤ C·x^θ·log²x` | SEALED (`schoenfeldWeakTheta_of_zeroFree`). Joint 1 composes with it; checked the same day. |
| 3 | D → the dyadic rows at exponent `θ` | SEALED (unit 0402, `JointDialGate.thetaWindow_of_global`). |
| 4 | the logarithm into the exponent | SEALED (unit 0402, `JointDialGate.log_absorbed`): `C·x^θ·(log x)^k ≤ A·x^θ'` for any `θ' > θ`, `x ≥ 1`. |
| 5 | D (v4.32) → C (v4.28): `StmtRelErrWindow` | WELD, in `check_weld.py` (ten welds); `powerSaving_relErr` reproved in Stage 3, and `relErrWindow_of_window` carries a window bound on `G` to the gate's statement on the rows of `π` and `Li` (unit 0402). |
| 6 | C inside: `StmtRelErrWindow` and the gap → cell `≠ 0` | SEALED in `lean/`, with the main-term floor discharged (unit 0403, `RelativeLi.tableFrom_ne_zero_of_relErr_li`; `tableFrom_ne_zero_of_powerSaving` is the statement joint 5 reaches). The smooth interpolant is constructed in unit 0412 (`lean/Interpolant.lean`, `liRow`; `tableFrom_ne_zero_of_relErr_liRow` takes no hypothesis on the main term). That `liRow` at a row is Stage 3's `Li` there: `Stage3/RowLeaves.Li_two_rpow` (unit 0413) and `Interpolant.liRow_eq` give the same formula, each in its tree. Left: the region `2d ≤ log 2·(r − d − 1)`. |
| 7 | D ↔ C at the RH shape: `StmtSchoenfeldWindow`, `StmtSchoenfeld` | WELD, in `check_weld.py`; Stage 3 reproves `window_of_global` on its side. |
| 8 | F → zeta23: `StmtWeilBridge` and five definitions | WELD, in `check_weld.py`; proved in `lean_bridge`. |
| 9 | B ↔ D: the table of `G` and the zeros | FORWARD, on the transform: SEALED (unit 0401, `JointSymbol`): differencing `G` along the doublings `d` times multiplies its transform by the symbol `(1 − 2^(−s))^d`, and each zero's pole is reweighted by the symbol at that zero to the power `d`. Forward, pointwise (the cell as a sum over the zeros): OPEN, needs the explicit formula for `G`. CONVERSE (a bound on the cells forces a zero-free region): OPEN; derived only when the largest real part of a zero is attained (`lean_stage3/design/joints.md`, block 9 and its two corrections). |
| 10 | the rows → all `x` | OPEN for one ladder, and it is the obstruction in joint 9: on any ladder of fixed ratio the zeros' heights fold onto the whole circle. Every ladder at once is every `y` (`joints.md`, 9d): a bound on all rational-base ladders in a window gives `WindowBound`, short and nearly without content. A finite set of bases: not known. |

## What the tunnel carries (joints 1, 3, 4, 5 are in; joint 6 is in the table's tree)

    a window bound on G at θ          (hypothesis, proved nowhere)
      → no zero of ζ right of θ       G, proved
      → |π − Li| ≤ C·x^θ·log²x        D, proved
      → the residual along the rows   joints 3, 4
      → relative error ρ(r) on a window, decaying like 2^(r(θ'−1))   C
      → at each depth d, cell (r, d) ≠ 0 for every r past some r₀(d) C

Two things about that last line, both from the files:
- `C` and `x₀` in section D are existential, so `r₀(d)` has no number.
- `lean/RelativeGate.lean` says in its header that the prime number theorem
  alone already gives the gate at every depth for some crossover rung. So
  the conclusion "finitely many zeros at each depth" does not need the window
  bound. What a bound at `θ < 1` adds is the rate at which the gap closes.

The direction from the table to ζ, a fact about cells that forces a zero-free
half-plane, is joint 10 and joint 9. Neither has a statement yet.

## The constants

`A` and `x₀` in the stretch from `G` to the gate are existential. The trace
(unit 0403): the dial's constant is a sum with an explicit part and six
quantities taken from existence statements, three in `Stage3/LineBound.lean`
and three in the upstream package (`SmoothedChebyshevClose`, `I1Bound`,
`I9Bound`).

This was already worked, before the Landau chain existed, and the answer is
in the notes. Read 2026-11-22, after the trace above was written without it:
- `Stage3/ExplicitBump.lean` (NOTEPAD entry 283, 2026-09-01) is a concrete
  bump, `bump x = c·(max 0 ((x − 1/2)(2 − x)))²`, with `bump_le_numeral : bump x ≤
  1.4757`, so `B ≤ 5.4271`. The dial's `bump_exists` does not use it.
- The same entry records what carrying that numeral shows: the `B` terms
  alone give `C_π ≥ 963,567`, against the ceiling `C_π = 2640.5` at which the
  gate still covers depth 6 by row 92 (entry 233). The entry's words: the
  `66600·e/π` of the contour bound "is where it dies", and upstream "is
  irrelevant".
So making the remaining five quantities explicit would give a number, and
that number is already known to be too large by a factor of several hundred
for the gate to close inside the computed table. Entry 233's `C_π = 2604.6`
is a paper propagation of that same contour route, in
`results/scratch_lean/constants.py`; entry 283 says the Lean chain is a
different and lossier assembly.

The other route is in section E and was priced on 2026-11-22 (unit 0404,
EXPLORATORY). `Assembly.psiWeak_of_RH_EF_NT`, `Glue.stmtEF_poly`,
`ArgCount.rvM_crude` and `PsiToPi.schoenfeldWeak_of_psiWeak` are four proved
theorems that no theorem composes. Together they land on `√x·log x`, one
logarithm fewer, and on that shape the ceiling for depth 6 is `C_π` about
170,212. The numerals the route fixes come to 87,064 and fit. Its three
unnamed constants do not: `Ch` is at least `1.2·10^10`, from the cube of the
gap between the radii `23/25` and `22/25` in `EdgeBound.gz_partial_fraction`
and a factor 3418.5 in `Glue.zeta_logderiv_good_bound`. Both are fixed
constants of the proof as written, and the unit leaves open whether the
radii can be freed as entry 233 freed one on the contour route.

Unit 0405 (same day, EXPLORATORY) read those proofs. One radius is forced
(`7/8`); freeing the other three gains a factor 15. The larger loss is in
the last line of `Assembly.psiWeak_of_RH_EF_NT`: `assembly_arith` bounds
`log²x` by `√x·log²x` on the term that holds the contour constants. With the
`√x` kept the constant is `7404 + 4W + (9c₁ + c₂)/√x₀`; priced as a floor,
depth 4 as built and depth 6 on the ceiling rung with the radii freed. The
height `T` (taken just above `x`, allowed up to `x²`) is the lever not yet
priced. Nothing is restated in Lean; the decision is Julian's.

Unit 0406 priced the height (EXPLORATORY). With `T` just below `x²` the
top-edge constant leaves the bound, and the zero side, unrounded, costs a few
tens. As floors: depth 6 covered with 3 rungs to spare with the radii as
built, 9 with them freed. What carries the constant then is the left edge of
the contour, `c₂·log x`, and the floor squared between `ψ` and `π`.

Unit 0407 built it: `Stage3/AssemblyFloor.lean`, `psiWeak_floor` and
`schoenfeldWeak_floor_of_RH`. The route from RH to `|π − Li| ≤ C(x₀)·√x·log x`
is now one theorem, with `C(x₀) = 3·floorConst + 13` an explicit function of
the floor, of the band's numerals, and of the two explicit-formula constants,
which remain existential.

Unit 0409 (`Stage3/GlueFloor.lean`) removed the last of the three roundings:
the left edge of the contour enters the explicit formula at its own size,
`72·D·log²x·x^(−1/4)`, and the route's theorem is now
`schoenfeldWeak_floor_split_of_RH`. Priced in unit 0410 (EXPLORATORY, floors):
depth 6 closes at rung 76 of 93 with the radii as built, and the constants
can grow by a factor 49,000 before depth 6 is lost.

Unit 0411 (`Stage3/JointFloorGate.lean`, `relErrWindow_floor_of_RH`) carries
that route to `StmtRelErrWindow`, the gate's hypothesis. So section E now
reaches section C the same way section D does: one line of theorems in
Stage 3, then the weld of joint 5.

Units 0412–0415 closed what stood between that route and a cell of the
table: the interpolant is constructed (`lean/Interpolant.lean`), Stage 3's
`Li` at the rows is that interpolant's formula (`RowLeaves.Li_two_rpow`),
the real-zero bucket is zero (`RealSegment`), and `RouteGate.relErrWindow_route`
states the route at the gate with both put in. Its conclusion is the
hypothesis of `Interpolant.tableFrom_ne_zero_of_relErr_liRow`; the weld on
`StmtRelErrWindow` is all that stands between them. Under RH, with three
existential constants.

Units 0416–0418 (block E7) proved a numeral for every quantity that route's
constants took from compactness or left as a bare value: the compact patch
(`BoxBounds.sq_zeta_box`, 135), the ratio `‖ζ 3/ζ (3/2)‖` (at least 2/7), the
zeros below height six (`EdgeBound.low_rect_count`, 714), the logarithmic
derivative on the short segment (`logDerivZeta_short_segment`, 1620000). With
`K0 = log 2π` and `W = 0` from units 0413 and 0414, nothing under the
constants is unnamed. They are not yet substituted: the route's theorem still
says "there exist".
