# Joints worksheet — the lemmas that join the sections

The sections and the joints are listed in `SECTIONS.md`. This worksheet holds
one block per joint that is built, in the shape of `lean_stage3/DESIGN.md` § 1.
A joint adds no mathematics of its own: it states that the outlet of one
section is the inlet of the next, and proves it from the two.

### 1 The Landau window onto the dial — PROVED (unit 0400: `JointWindowDial.zeroFreeRight_of_window`,
`psiWeakTheta_of_window`, `schoenfeldWeakTheta_of_window`)
Objects.   Outlet of section G: `LandauCriterion.stmtLandauWindow`, for
           `0 < θ < 1`, `0 < δ`: `WindowBound θ δ C → ∀ s, θ < s.re → ζ s ≠ 0`.
           Inlet of section D: `Stage3.StmtZeroFreeRight θ := ∀ s, θ < s.re →
           s ≠ 1 → ζ s ≠ 0`. The inlet is the weaker statement (it has the
           extra hypothesis `s ≠ 1`), so the joint is one application.
Sizes.     none; no bound is made. Lost factor: none.
Regime.    W1 `0 < θ`, W2 `θ < 1`, W3 `0 < δ`; for the outlets of D also
           W4 `1/2 ≤ θ`.
Defs.      none.
Theorems.  `theorem zeroFreeRight_of_window {θ δ C : ℝ} (hθ0 : 0 < θ) (hθ1 : θ < 1)
               (hδ : 0 < δ) (hW : LandauWindow.WindowBound θ δ C) :
               Stage3.StmtZeroFreeRight θ`
           `theorem psiWeakTheta_of_window {θ δ C : ℝ} (hθlo : 1 / 2 ≤ θ) (hθ1 : θ < 1)
               (hδ : 0 < δ) (hW : LandauWindow.WindowBound θ δ C) :
               ∃ C' > 0, ∃ x₀ : ℝ, ∀ t : ℝ, x₀ ≤ t →
                 |Chebyshev.psi t - t| ≤ C' * t ^ θ * Real.log t ^ 3`
           `theorem schoenfeldWeakTheta_of_window {θ δ C : ℝ} (hθlo : 1 / 2 ≤ θ)
               (hθ1 : θ < 1) (hδ : 0 < δ) (hW : LandauWindow.WindowBound θ δ C) :
               ∃ C' > 0, ∃ x₀ : ℝ, Stage3.StmtSchoenfeldWeakTheta θ C' 2 x₀
                 (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li`
Composes.  `LandauCriterion.stmtLandauWindow`; `Stage3.psi_weak_of_theta`
           (`ThetaPsi`), `Stage3.schoenfeldWeakTheta_of_zeroFree` (`ThetaPi`).
Module.    `Stage3/JointWindowDial.lean`, namespace `JointWindowDial`. Pinned: all three.
Open.      joint 3 of `SECTIONS.md`: the bound on `π − Li` carried to the dyadic rows.

### 9 The table's rows force the zero-free region — DRAFT for Julian, nothing built
Drafted 2026-11-22 after reading `lean/Chain.lean` (statements),
`lean/Superposition.lean` (in full) and the annulus theorems of
`lean/Transform.lean`. The derivation below is by hand, in the session. It is
not checked numerically, not checked against the literature, and not in Lean.

What section B already has. A mode along the rows is `mode b ρ r = b^(rρ)`;
one difference multiplies it by the symbol `Sym b ρ = 1 − b^(−ρ)` (`A1`), `d`
differences by `Sym^d` (`A4`); and `tableFrom_eq_modeSum_reweighted`: IF an
integer row equals a FINITE sum of modes at every integer, THEN
`cell(r, d) = Σ_i c_i·Sym(ρ_i)^d·b^(rρ_i)`. The hypothesis is a model: no row
of primes is a finite sum of modes.

The row that IS a sum of modes. Unit 0383's identity, for `y > 1`:
    G(y) = Σ_ρ A_ρ·y^ρ + log 2π − T(y),   A_ρ = m_ρ/(ρ(1−ρ)),
over the nontrivial zeros, `T` the trivial zeros' term. At `y = 2^r` each term
is a mode `2^(rρ)` exactly, and `Σ_ρ |A_ρ|` is finite (`= K` under RH, unit
0383). So the row `g(r) := G(2^r)` is an absolutely convergent sum of modes,
with no `1/r` factors. (The row of `π` has them: its terms are `Ei(ρ·r·log 2)`.)

Three statements, each resting on the one before.

9a  The table of `G` is the zero sum, reweighted by depth. For `d ≥ 1`:
        (bdiff^[d] g)(r) = Σ_ρ A_ρ·Sym(2, ρ)^d·2^(rρ) − (bdiff^[d] T∘2^·)(r).
    This is `tableFrom_eq_modeSum_reweighted` with the finite sum replaced by
    the absolutely convergent one (`|Sym| ≤ 2`, so the reweighted sum
    converges for each `d`). The constant `log 2π` dies at depth one.

9b  The rows' generating function has a pole at every zero. For `Re s > 1`:
        Z(s) := Σ_{r ≥ 1} g(r)·2^(−rs) = Σ_ρ A_ρ/(2^(s−ρ) − 1) + (log 2π)/(2^s − 1) − Z_T(s),
    each mode summing as a geometric series. The right side is meromorphic on
    `Re s > 0`. Its poles are at `s = ρ + 2πik/log 2`: every zero, and every
    alias of it along the rows. At such a point the residue is
    `(1/log 2)·Σ A_ρ'` over the zeros `ρ'` in that alias class.
    THE ALIASES DO NOT CANCEL. `Re(ρ(1−ρ)) = β(1−β) + γ² > 0` for `0 < β < 1`,
    so `Re A_ρ > 0` for every nontrivial zero, and a sum of numbers with
    positive real part is not zero. Sampling once per doubling folds the
    zeros' heights together and cannot hide a zero's real part.

9c  The dyadic criterion. For `0 < θ < 1`: if `|G(2^r)| ≤ C·2^(θr)` for all
    large `r`, then `ζ` has no zero with real part above `θ`
    (`Stage3.StmtZeroFreeRight θ`). Proof: the bound makes `Z` converge
    absolutely, hence analytic, on `Re s > θ`; 9b gives it a pole at any zero
    there.
    With the dial's converse direction this reads: the growth rate of the
    table's row, `limsup |G(2^r)|^(1/r)`, is `2^Θ` with `Θ` the supremum of the
    zeros' real parts, and RH is the statement that it is `√2`.

What this changes in `SECTIONS.md`. Joint 10 said the rows cannot give a
bound between them. For the growth rate that is not needed: 9c takes a bound
on the rows alone. (What the rows cannot give is the bound on `G` at every `y`.)

What it would take to build.
- The identity for `G` with its absolute convergence, as a theorem. It needs
  the partial fractions of `ζ'/ζ` or a contour shift with the count of zeros
  (section E has Riemann–von Mangoldt; upstream has a Hadamard form). This is
  the large piece.
- 9a and 9b are then sums of geometric series.
- 9c needs the identity theorem for analytic functions on `Re s > θ`.

What is not claimed.
- This is the table of `G`, the `Λ`-weighted ramp count, sampled at the
  doublings. For the table of `π` itself the modes carry `1/r` and the
  generating function has logarithmic branch points in place of poles; the
  same positivity (`Re(1/ρ) > 0`) suggests the same conclusion, not derived.
- 9c asks the bound on all large rows and from both sides. A one-sided bound,
  or a bound on long runs of rows only (the window form), is not derived.
- The hypothesis of 9c is not proved. It is RH in the table's coordinates.

#### Block 9, corrected before building — 2026-11-22
Julian read the draft and said 9c is right, go. Working out the proof before
writing any Lean found two faults in the draft. Both are the size of what the
steps add up to, so this is design and the build stops here (CLAUDE.md, "a lost
factor is a design failure").

FAULT 1, in 9b. "The right side is meromorphic on `Re s > 0`" is false in
general. The poles are at `ρ + 2πik/log 2` for every zero `ρ` and every
integer `k`. The heights `γ·log 2` taken modulo `2π` are spread around the
circle, so the aliases of the zeros on one vertical line are dense on that
line. Poles that accumulate are not the poles of a meromorphic function. Under
RH the line `Re s = 1/2` is a wall for `Z`. Off RH, any vertical line carrying
infinitely many zeros is one.

FAULT 2, in 9c. The proof "a pole at a zero right of `θ` contradicts
analyticity" needs the pole to be an isolated singularity of the continued
function, which fault 1 removes. What survives, with a different proof:

9c′ (derived, by hand). Let `Θ` be the supremum of the real parts of the
zeros. IF SOME ZERO HAS REAL PART EXACTLY `Θ`, then `G(2^r)` is not
`o(2^(Θr))`; so a bound `|G(2^r)| ≤ C·2^(θr)` with `θ < Θ` is impossible.
Proof: `G(2^r)·2^(−Θr) = Σ_{β = Θ} A_ρ·e^(iγ r log 2) + o(1)` (dominated
convergence, `Σ|A_ρ| < ∞`). Group the zeros with `β = Θ` by `γ·log 2` modulo
`2π`; each group's coefficient is a sum of numbers with positive real part,
so it is not zero. An absolutely convergent sum of distinct unimodular powers
with a nonzero coefficient has positive mean square (the argument of
`LandauTrig.sum_sq_block_ge`, with a tail), so it does not tend to zero.

WHAT IS LOST. Whether the supremum is attained is not known. If RH fails, the
zeros' real parts could climb toward `Θ` without reaching it, and then no set
of zeros dominates the row. The cancellation the general statement must rule
out is among infinitely many modes of different sizes, seen only at the
integers `r`. Soft analysis does not rule it out: a sum `Σ A_n/(w − a_n)` with
`Σ|A_n| < ∞` and accumulating poles can continue analytically where it "has
poles" (Wolff, Denjoy), and the interpolation theorems that would transfer a
bound from the integers to the real line (Carlson, Cartwright) need
exponential type below `π` across the direction of the aliases, and sampling
once per doubling gives type exactly `π`. That is the aliasing, returning as
the obstruction.

So, as it stands:
- RH ⇒ the table's row of `G` grows no faster than `2^(r/2)` up to logarithms:
  proved (the dial, with joint 1).
- the row's rate `≤ 2^(θr)` ⇒ no zero right of `θ`: derived only when the
  largest real part is attained (for instance when finitely many zeros lie
  right of `θ`). The general case is open, and it is the case RH needs.
- today's criterion (`LandauCriterion.stmtLandauWindow`) has no such gap
  because it takes the bound at every `y` of a window. The gap is exactly the
  step from every `y` to the doublings: joint 10, which the draft claimed to
  have dissolved and has not.

Three ways on, for Julian to choose:
(a) build 9c′ with its hypothesis stated (needs the identity for `G` as a
    theorem first; the large piece);
(b) change what is sampled: more than one base, or a ladder finer than
    doubling, so that the type falls below `π`; then the transfer theorems
    apply and the general statement may be provable;
(c) leave joint 9 as the forward statement 9a (the table of `G` is the zero
    sum reweighted by the symbol), which is true without any of this, and
    state the converse as open.

#### Way (b), checked before building — 2026-11-22
Julian chose (b): change what is sampled so that the transfer theorems apply.
Worked through before any Lean. The premise of (b) as written above is wrong.

WHAT WAS WRONG. "A ladder finer than doubling brings the type below `π`."
Along a ladder of ratio `b`, a zero at height `γ` has frequency `γ·log b`
per step, seen modulo `2π`. A finer ladder shrinks each frequency, but the
heights of the zeros are unbounded, so on every ladder the frequencies still
fill the whole circle. The folded band is `(−π, π]` for every fixed ratio.
No fixed-ratio ladder is fine enough, and the same holds for any finite set
of ladders: the samples have finite density in `log y` and the signal has
unbounded frequencies.

A second route, also closed. `rampSum` is convex and increasing, so between
two samples `G` lies under its chord up to the curvature of the main term
`y·log y`, which is `η²y/8` across a step of ratio `1 + η`. For that to stay
below `y^θ` the ratio must tighten like `1 + y^((θ−1)/2)` as `y` grows. No
fixed ratio does.

WHAT IS TRUE. Every ladder at once is every `y`: the points `b^r` over all
bases `b` in `(1, 2]` and all `r` cover the half-line. `G` is continuous, so
the rational bases suffice. Hence

9d (derived; short). If `G(b^r) ≤ C·(b^r)^θ` for every rational base `b` in
`(1, 2]` and every `r` with `b^r` in a window `[Y, Y^(1+δ)]`, for arbitrarily
large `Y`, with one constant `C` for all bases, then `WindowBound θ δ C`, and
`LandauCriterion.stmtLandauWindow` gives no zero right of `θ`.

This is a true joint from the family of all base-`b` tables of `G` to the
criterion, and it is nearly without content: it says a bound on every ladder
is a bound everywhere. Its use is to say exactly what the tables must supply:
one ladder is not known to be enough, every ladder is, and whether some
countable family short of all of them is enough is open.

So the map stands corrected a third time:
- one base, all large rows, both sides: enough when the largest real part of
  a zero is attained (9c′); open otherwise;
- every base, a window, one side: enough (9d with today's criterion);
- a fixed finite set of bases: not known, and the general transfer theorems
  do not give it.

### 9a The table of `G` and the symbol, on the transform side — PROVED (unit 0401:
`JointSymbol.mellin_shift`, `mellin_dd_iter`, `dd_iter_rule`, `symPhi_principal_part`)
Julian chose the forward statement. As drafted, 9a writes the cell as a sum
over all the zeros and needs unit 0383's identity as a theorem first. The
same content has an exact form that needs no sum over zeros: take the Mellin
transform. There, one difference along the doublings is multiplication by
the symbol, for every zero at once.
Objects.   `cutG y = G y` for `y > 1` and `0` otherwise: the row starts at the
           first regime. `dd f y = f y − f (y/2)`: one difference along the
           doublings; `dd^[d]` is depth `d`. At `y = 2^r` the rule
           `(dd^[d+1] f)(2^r) = (dd^[d] f)(2^r) − (dd^[d] f)(2^(r−1))` is the
           table's rule `cell(r, d+1) = cell(r, d) − cell(r−1, d)`.
           The symbol at base `2`: `1 − 2^(−s)`, which is `Chain.Sym 2 s` of
           `lean/Chain.lean` (other toolchain; written out here).
Sizes.     identities. `∫₁^∞ f(y/2)·y^(−s−1) dy = 2^(−s)·∫₁^∞ f(y)·y^(−s−1) dy` for `f`
           vanishing on `y ≤ 1`, by `y = 2u`. So the transform of `dd f` is
           `(1 − 2^(−s))` times that of `f`, and of `dd^[d] cutG` it is
           `(1 − 2^(−s))^d·Phi s` (`LandauMellinG.mellin_G`). At a zero `ρ` of
           order `m` the principal part of `Phi` is `A/(s−ρ)`, `A = m/(ρ(1−ρ))`
           (`LandauPoleLocal.Phi_principal_part`); multiplying by an entire
           function `f` gives principal part `f(ρ)·A/(s−ρ)`. Lost factor: none.
Regime.    R1 `1 < Re s` for the transform. P0, P1, PZ of block 3a at a zero.
Defs.      `dd (f : ℝ → ℂ) : ℝ → ℂ := fun y => f y - f (y / 2)`;
           `cutG (y : ℝ) : ℂ := if 1 < y then (LandauWindow.G y : ℂ) else 0`. Two.
Theorems.  `theorem mellin_shift` — `f = 0` on `y ≤ 1`, `f·y^(−s−1)` integrable on
               `(1, ∞)` — the same for `f(·/2)`, and its transform is `2^(−s)` times.
           `theorem mellin_dd_iter {s : ℂ} (hs : 1 < s.re) (d : ℕ) :
               ∫ y in Ioi (1 : ℝ), (dd^[d] cutG) y * (y : ℂ) ^ (-s - 1)
                 = (1 - (2 : ℂ) ^ (-s)) ^ d * LandauMellinG.Phi s`
           `theorem dd_iter_rule (f : ℝ → ℂ) (d : ℕ) (y : ℝ) :
               (dd^[d + 1] f) y = (dd^[d] f) y - (dd^[d] f) (y / 2)`
           `theorem symPhi_principal_part {ρ : ℂ} (h0 : ρ ≠ 0) (h1 : ρ ≠ 1)
               (hz : riemannZeta ρ = 0) (d : ℕ) :
               ∃ h : ℂ → ℂ, AnalyticAt ℂ h ρ ∧ ∀ᶠ s in 𝓝[≠] ρ,
                 (1 - (2 : ℂ) ^ (-s)) ^ d * LandauMellinG.Phi s
                   = h s + (1 - (2 : ℂ) ^ (-ρ)) ^ d
                       * ((analyticOrderNatAt riemannZeta ρ : ℂ) / (ρ * (1 - ρ))) / (s - ρ)`
Composes.  `LandauMellinG.mellin_G`, `G_mellin_integrable`;
           `LandauPoleLocal.Phi_principal_part`. Mathlib:
           `integral_comp_mul_left_Ioi`, `integrableOn_Ioi_comp_mul_left_iff`,
           `Complex.mul_cpow_ofReal_nonneg`, `Complex.differentiableOn_dslope`.
Module.    `Stage3/JointSymbol.lean`, namespace `JointSymbol`. Pinned:
           `mellin_dd_iter`, `dd_iter_rule`, `symPhi_principal_part`.
Open.      the pointwise form, the cell as the sum over the zeros (needs unit
           0383's identity as a theorem); the converse (block 9's corrections).

### 3 The dial onto the gate (joints 3, 4, 5 of `SECTIONS.md`) — PROVED (unit 0402:
`JointDialGate.thetaWindow_of_global`, `log_absorbed`, `powerSaving_relErr`, `relErrWindow_of_theta`,
`relErrWindow_of_window`)
Objects.   The dial's outlet: `Stage3.StmtSchoenfeldWeakTheta θ C k x₀ pi li`,
           `|pi x − li x| ≤ C·x^θ·(log x)^k` for `x ≥ x₀`. The gate's inlet, in the
           table's tree: `RelativeGate.StmtRelErrWindow f L r n ρ`,
           `|f(r−j) − L(r−j)| ≤ ρ·2^(r−j)` for `j ≤ n`, with `f m = pi(2^m)`,
           `L m = li(2^m)` the rows.
Sizes.     Joint 3: read the bound at `x = 2^(r−j)`; valid when the window's
           bottom clears the floor, `x₀ ≤ 2^(r−n)`.
           Joint 4: `(log x)^k ≤ x^ε/(ε/(k+1))^k` for `x ≥ 1`
           (`LandauKernel.log_pow_le` at `a = 2ε`), so with `θ' = θ + ε` the
           bound is `A·x^θ'`, `A = C/(2ε/(2(k+1)))^k`. THE LOST-FACTOR CHECK: the
           logarithm is traded for `x^ε`, any `ε > 0`; the exponent moves from
           `θ` to `θ'`, named in the statement, and the gate needs only `θ' ≤ 1`
           with relative error falling like `2^((r−n)(θ'−1))`, so any `θ' < 1`
           still closes the gap for large rows. Nothing is hidden.
           Joint 5: `A·(2^m)^θ'` is relative error `A·2^((r−n)(θ'−1))` on the
           window, worst at its bottom (`powerSaving_relErr` of the table's
           tree, reproved here as `window_of_global` was in `Statement.lean`).
Regime.    `0 ≤ C`, `θ < θ' ≤ 1`, `x₀ ≤ 2^(r−n)`, `0 ≤ r − n`.
Defs.      `StmtRelErrWindow`, a character-level copy of
           `lean/RelativeGate.lean`'s, held by `utilities/check_weld.py`. One.
Theorems.  `theorem thetaWindow_of_global` — the dial's bound, `hf`, `hL`, the floor —
               `∀ j ∈ range (n + 1), |f (r - j) - L (r - j)|
                  ≤ C * ((2 : ℝ) ^ ((r : ℝ) - j)) ^ θ * Real.log ((2 : ℝ) ^ ((r : ℝ) - j)) ^ k`
           `theorem log_absorbed {θ θ' C : ℝ} {k : ℕ} (hC : 0 ≤ C) (hθ : θ < θ')
               {x : ℝ} (hx : 1 ≤ x) :
               C * x ^ θ * Real.log x ^ k
                 ≤ C / (2 * (θ' - θ) / (2 * ((k : ℝ) + 1))) ^ k * x ^ θ'`
           `theorem powerSaving_relErr` — statement identical to the table tree's.
           `theorem relErrWindow_of_theta` — the three composed.
           `theorem relErrWindow_of_window` — from `WindowBound θ δ C₀`, `1/2 ≤ θ < θ' ≤ 1`:
               `∃ A x₀, 0 ≤ A ∧ ∀ r n, x₀ ≤ 2^(r−n) → 0 ≤ r − n →
                  StmtRelErrWindow (π at 2^m) (Li at 2^m) r n (A·2^((r−n)(θ'−1)))`
Composes.  `JointWindowDial.schoenfeldWeakTheta_of_window`; `LandauKernel.log_pow_le`.
Module.    `Stage3/JointDialGate.lean`, namespace `JointDialGate`. Pinned:
           `thetaWindow_of_global`, `powerSaving_relErr`, `relErrWindow_of_window`.
Open.      joint 6's side conditions in the table's tree (`hM`, `hgap`), and that
           `A`, `x₀` are not explicit.

### 6 The gate's last hop, and the constants — PROVED in `lean/` (unit 0403: `RelativeLi.tableFrom_ne_zero_of_relErr_li`, `tableFrom_ne_zero_of_relErr_li'`, `tableFrom_ne_zero_of_powerSaving`)
This block is the table tree's, on its own toolchain; it is recorded here
because it closes the stretch block 3 opened.
Built.     `lean/RelativeLi.lean`: `RelativeGate.tableFrom_ne_zero_of_relErr` with
           its floor `hM` discharged by `MainTerm.stencilR_ge_of` and
           `Expansion.hD_of_window`. The inlet `tableFrom_ne_zero_of_powerSaving`
           is the statement block 3 reaches.
Found.     (i) the interpolant `G` (smooth on the line, `G' = 2^x/x` beyond `1/2`)
           is a hypothesis of every gate theorem and is constructed in no file;
           (ii) Stage 3's `Li` is `x/log x + ∫₂^x 1/log²`, the right derivative
           along the doublings, a constant off `∫ 1/log`;
           (iii) the floor holds for `2d ≤ log 2·(r − d − 1)`.
Constants. `psi_weak_of_theta`: `C_ψ = Cclose + C1 + C9 + 66600·e·B/π + 2·900·e·B/π
           + Cmain + 1`, floor `max(exp(2/(1−θ)+6), 16, (1/ε₀)^(1/(1−θ)) + 1)`.
           Existential: the bump `ν` (`LineBound.bump_exists`, from upstream's
           `SmoothExistence`); `B` (`mellin_bump_bounded`, compactness); `Cmain`,
           `ε₀` (`mellin_main_const`, from a big-O); `Cclose`, `C1`, `C9`
           (upstream `SmoothedChebyshevClose`, `I1Bound`, `I9Bound`, each stated
           "∃ C"). Then `C = 3·C_ψ + 13` on the `π` side and block 3's
           `A = C/(2(θ'−θ)/6)²`. A number needs an explicit bump and the six
           bounds reproved with constants.
Open.      the interpolant as a theorem; the six constants.
Corrected 2026-11-22, the same day. "The bump `ν` … existential" above is
true of what the dial takes (`bump_exists`) and missed that
`Stage3/ExplicitBump.lean` has held a concrete bump with `bump x ≤ 1.4757`
since NOTEPAD entry 283, and that the entry carries the numeral through:
`C_π ≥ 963,567` from the `B` terms alone, against a ceiling of `2640.5`
(entry 233). The explicit constants on this route are known to be too large
for the gate to close inside the computed table. See `SECTIONS.md`, "The
constants".

### E1 The assembly with its floor — PROVED (unit 0407: `AssemblyFloor.psiWeak_floor`, `schoenfeldWeak_floor_of_RH`, with `rem_floor`, `zeroinner_floor`, `floor_arith`, `floorConst_nonneg`)

Section E of `SECTIONS.md`, the stretch to the census at the RH shape. Units
0404–0406 priced it: `Assembly.psiWeak_of_RH_EF_NT` reaches, inside its proof,
a bound whose contour constants sit on `log²x` with no `√x`, and whose zero
side is a polynomial in `log T`; its two closing lemmas (`rem_arith`,
`zeroinner_arith`, `assembly_arith`) round every term up to one multiple of
`√x·log²x` valid from `x ≥ 16`. This block restates the assembly without the
rounding. No new mathematics.

Choice of height. `T = 2^(K+1)` with `x²/2 < T ≤ x²` (`K + 1 = Nat.log 2 ⌊x²⌋`),
allowed by `StmtExplicitFormulaPoly` (`T ≤ x²`). Then `x/T < 2/x`,
`log T ≤ 2L`, `log(xT) ≤ 3L`, `L = log x`.

Theorems.

- `rem_floor`: `0 ≤ c₁`, `0 < x`, `0 < T`, `x² ≤ 2T`, `0 ≤ G ≤ 3L` give
  `c₁·x·G²/T ≤ 18·c₁·L²/x`.
- `zeroinner_floor`: `(K+1)·log 2 ≤ 2L`, `0 ≤ K`, `1 ≤ L`, `R ≤ 2(b₁+b₂)L + b₃` give
  `2((log 2/2π)(K+1)(K+2) + 3(K+1)/π + 2(R + 7/8)) + 2W
   ≤ 2(L² + (4 + 4b₁ + 4b₂)L + 2b₃ + 2) + 2W`.
  Hint: `(K+1) ≤ 2.9L` from `log 2 > 0.693`; `π > 3`.
- `floor_arith`: with `0 < L₀ ≤ L`, `0 < S₀ ≤ S`, `0 < x₀ ≤ x`,
  `A ≤ 18c₁L²/x + c₂L + S(4L² + PL + Q)` gives
  `A ≤ (4 + P/L₀ + Q/L₀² + 18c₁/(x₀S₀) + c₂/(S₀L₀))·S·L²`.
  Hint: each term times a ratio that is at least one.
- `psiWeak_floor`: hypotheses of `psiWeak_of_RH_EF_NT`, and `16 ≤ x₀`,
  `x₁ ≤ x₀`; conclusion `StmtPsiWeak (floorConst c₁ c₂ b₁ b₂ b₃ W x₀) 2 x₀`,
  `floorConst = 4 + (16 + 16b₁ + 16b₂)/log x₀ + (8b₃ + 8 + 4W)/log²x₀
   + 18c₁/(x₀·√x₀) + c₂/(√x₀·log x₀)`.
- `schoenfeldWeak_floor_of_RH`: under RH there are `c₁, c₂ ≥ 0` with, for
  every `x₀ ≥ 16`, `|π(x) − Li(x)| ≤ (3·floorConst c₁ c₂ 112 0 698 W x₀ + 13)·√x·log x`
  for `x ≥ max (x₀²) 9`.

What the next slice needs: `c₁`, `c₂` as definitions with numerals, which
needs the three compactness constants bounded; and the gate read on the
`√x·log x` shape (`Statement.weakWindow_of_global`).

### E2 The left edge at its own size — PROVED (unit 0409: `GlueFloor.edge_left_sharp`, `explicit_formula_split`, `stmtEF_split`, `psiWeak_floor_split`, `schoenfeldWeak_floor_split_of_RH`)

Read 2026-11-22: `Glue.edge_left_bound` (lines 557–949) and its use in
`Glue.explicit_formula_poly` (the last `calc`, lines 1170–1192).

What the proof holds. On the edge `Re s = −1/4` the integrand is bounded
pointwise by `D·log T'·x^(−1/4)/(1/4 + |t|)`, with
`D = 36·Ce + 9·(Mc + 1)/log 2`; `Ce` is `EdgeBound.edge_bound_core`'s
constant, used at distance `1/4` from every zero, and `Mc` is the supremum of
`|ζ′/ζ|` on the segment `|t| ≤ 2`, from compactness. The integral of
`1/(1/4 + |t|)` over `[−T', T']` is at most `8·log T'`. So the proof reaches

    ‖left edge‖ ≤ 72·D·(log x)²·x^(−1/4).

Its last two steps then bound `(log x)²·x^(−1/4) ≤ 256` and `256 ≤ 128·log x`,
to give the statement's shape `C·log x` with `C = 72·256·D/2 + 1`.

The factor. The left edge is `O(x^(−1/4)·log²x)` and the statement records
`O(log x)`. The quotient grows like `x^(1/4)/log x`. This is the third place
on this route where a closing step rounds a term up to the shape of the
statement (units 0405, 0406), and it is the one that carries the whole of
`c₂` in unit 0408.

What the restatement is. Three pieces, each a copy with a different last line
(`LOOP.md` § 3), no new mathematics:

- `edge_left_sharp`: the proof of `edge_left_bound` stopped at the line
  `= 72 * D * ((Real.log x)^2 * x ^ (-(1:ℝ)/4))`. Statement:
  `∃ D > 0, ∀ x T', 16 ≤ x → 2 ≤ T' → T' ≤ 2x² →
   ‖VIntegral (Gf x) (-1/4) (-T') T'‖ ≤ 72·D·(log x)²·x^(−1/4)`.
- `StmtExplicitFormulaSplit c₁ c₃ c₄ x₁`: for `x₁ ≤ x`, `2 ≤ T ≤ x²`,
  `‖ψ x − x + Z(x,T)‖ ≤ c₁·x·log²(xT)/T + c₃·log x + c₄·(log x)²·x^(−1/4)`,
  and `explicit_formula_split`: the proof of `explicit_formula_poly` with
  `Cl·log x` replaced in its last `calc`; `c₃ = 13 + K0/2`, `c₄ = 72·D`.
- `psiWeak_floor_split`: block E1's theorem on the new statement, constant
  `4 + (16 + 16b₁ + 16b₂)/log x₀ + (8b₃ + 8 + 4W)/log²x₀ + 18c₁/(x₀·√x₀)
   + c₃/(√x₀·log x₀) + c₄/x₀^(3/4)`.

Size of the work: `edge_left_bound` is about 390 lines and
`explicit_formula_poly` about 215, both under `maxHeartbeats 1600000`; the
copies change a few lines each. `Glue.lean` itself stays untouched.

An estimate of what it buys, not logged as a unit (same script shape as unit
0408, `c₄` at its floor): with the radii as built, depth 6 closes near rung 76
of 93; with them freed, near 74. The floor of the route with no contour
constant at all is 74 (unit 0408). So with the left edge at its own size the
radii stop mattering to the census.

What stays unnamed after it: `Mc`, `K0` (classically `log 2π`), `W`
(classically zero), `M0` (zeros below height six, classically none), and the
compact-patch bound inside `ZetaGrowth.sq_zeta_band_bound`.

### E3 The route onto the gate — PROVED (unit 0411: `JointFloorGate.weakWindow_relErr`, `relErrWindow_floor_of_RH`)

Unit 0409's theorem is a bound on `π − Li` for all `x` above a floor. The
table's gate takes `StmtRelErrWindow f L r n ρ` (`JointDialGate`, welded to
`lean/RelativeGate.lean`). Two steps, both already present in kind:
`Statement.weakWindow_of_global` reads a weak bound at the rows, and a weak
window is a relative error.

Theorems.

- `weakWindow_relErr`: `0 ≤ C`, `0 ≤ r − n`, `StmtWeakWindow C k f L r n` give
  `StmtRelErrWindow f L r n (C·(log 2·r)^k·2^(−(r−n)/2))`.
  Hint: `(r − j) ≤ r` for the logarithm, `j ≤ n` for the power of two.
- `relErrWindow_floor_of_RH`: under RH there are `c₁, c₃, c₄ ≥ 0` such that for
  every `x₀ ≥ 16` and every `r, n` with `x₀² ≤ 2^(r−n)` and `0 ≤ r − n`,
  `StmtRelErrWindow` holds on the rows of `π` and `Li` with
  `ρ = (3·floorConstSplit c₁ c₃ c₄ 112 0 698 W x₀ + 13)·(log 2·r)·2^(−(r−n)/2)`.

What the next slice needs: nothing on this side. The gate's theorem
`RelativeLi.tableFrom_ne_zero_of_relErr_li'` is in the table's tree and takes
this statement; the join is by text (joint 5).

### C1 The interpolant of the main term — PROVED in `lean/` (unit 0412: `Interpolant.liRow_contDiff`, `liRow_hasDerivAt`, `liRow_eq`, `tableFrom_ne_zero_of_relErr_liRow`)

Every gate theorem in the table's tree takes a function `G` with
`ContDiff ℝ ⊤ G` and `HasDerivAt G (f2x x) x` for `x > 1/2`,
`f2x x = e^(log 2·x)/x` (`Expansion.f2x`). No file constructs one (unit 0403).

Construction. `F x = 2/log 2 + ∫ t in 1..x, f2x t`. On `x > 0`, `f2x` is
continuous, so `F` has derivative `f2x` there, and is smooth there because
its derivative is. `F` has no reason to be smooth at or below zero, so cut it
off: `liRow x = smoothTransition (4x − 1) · F x`. The cutoff is zero for
`x ≤ 1/4` and one for `x ≥ 1/2`.

Theorems.

- `F_hasDerivAt`: `0 < x → HasDerivAt F (f2x x) x`.
- `liRow_contDiff`: `ContDiff ℝ ⊤ liRow`. Hint: at `x < 1/4` it is locally
  zero; at `x > 0` a product of two smooth functions.
- `liRow_hasDerivAt`: `1/2 < x → HasDerivAt liRow (f2x x) x`.
- `liRow_eq`: `1/2 ≤ x → liRow x = 2/log 2 + ∫ t in 1..x, f2x t`.
- `tableFrom_ne_zero_of_relErr_liRow`: `RelativeLi`'s gate theorem with
  `G := liRow` and the two hypotheses gone.

The constant `2/log 2` is the value at the row `m = 1` of `x/log x + ∫₂ˣ dt/log²t`,
Stage 3's `Li`. That `liRow m = Li (2^m)` for `m ≥ 1` is a statement across
the two trees and is not in this block.

### E4 Two leaves: the main term at the rows, and `K0` — PROVED (unit 0413: `RowLeaves.hasDerivAt_Li`, `Li_two_rpow`, `norm_logDerivZeta_zero`)

- `hasDerivAt_Li`: `1 < y → HasDerivAt Li (1 / Real.log y) y`. From the
  definition `Li y = y/log y + ∫₂ʸ dt/log²t`: the quotient contributes
  `(log y − 1)/log²y`, the integral `1/log²y`.
- `Li_two_rpow`: `0 < x → Li (2^x) = 2/log 2 + ∫ t in 1..x, exp (log 2·t)/t`.
  Both sides have derivative `exp (log 2·x)/x` on `x > 0` and agree at
  `x = 1`, where `Li 2 = 2/log 2`. Hint: `IsOpen.eqOn_of_deriv_eq` on `Ioi 0`.
  The right side is, character for character, what `lean/Interpolant.liRow_eq`
  gives for `liRow x` when `x ≥ 1/2` (`Expansion.f2x` unfolded).
- `norm_logDerivZeta_zero`: `‖deriv riemannZeta 0 / riemannZeta 0‖ = Real.log (2π)`.
  From Mathlib's `deriv_riemannZeta_zero` and `riemannZeta_zero`. This is the
  `K0` of `Glue.explicit_formula_poly` and `explicit_formula_split`.

### E5 No zero on the real segment: `W = 0` — PROVED (unit 0414: `RealSegment.zeta_real_ne_zero`, `isEmpty_zeroHeight`, `weightedZeroHeightBucket_eq_zero`)

`W = weightedZeroHeightBucket` is the count, with multiplicity, of zeros of ζ
with `0 < Re < 1` and `Im = 0` (upstream `KadiriZeroCounting`). Upstream proves
no zero on `(−1, 0]`; nothing covers `(0, 1)`.

Route, from what the packages hold.

- For `Re s > 0`, `s ≠ 1`: `ζ s = riemannZeta0 N s` (`Zeta0EqZeta`). At `N = 1`
  and real `s = σ` in `(0, 1)`:
  `ζ σ = 1/2 − 1/(1 − σ) + σ·∫_{x>1} (⌊x⌋ + 1/2 − x)/x^(σ+1) dx`.
- `ZetaBnd_aux1b` bounds the integral by `1/σ`, so the last term has norm at
  most `1`. If `ζ σ = 0` then `1/(1 − σ) − 1/2 ≤ 1`, that is `σ ≤ 1/3`.
  So no zero on `(1/3, 1)`. (The bound `1/σ` uses `|⌊x⌋ + 1/2 − x| ≤ 1`; with
  `1/2` the argument would cover all of `(0, 1)`, but that lemma is not there.)
- For `σ` in `(0, 1/3]`: the functional equation `riemannZeta_one_sub` at
  `w = 1 − σ` in `[2/3, 1)`. The factors `2^(1−w)`, `π^(−w)`, `Γ w`,
  `cos (π w/2)` are nonzero and `ζ w ≠ 0` by the first case.

Theorems.

- `zeta_real_ne_zero_upper`: `1/3 < σ → σ < 1 → riemannZeta σ ≠ 0`.
- `zeta_real_ne_zero`: `0 < σ → σ < 1 → riemannZeta σ ≠ 0`.
- `isEmpty_zeroHeight`: `IsEmpty Kadiri.ZeroHeightNontrivialZeros`.
- `weightedZeroHeightBucket_eq_zero`: `Kadiri.weightedZeroHeightBucket = 0`.

### E6 The route at the gate, substituted — PROVED (unit 0415: `RouteGate.relErrWindow_route`)

- `relErrWindow_route`: under RH there are `c₁, c₃, c₄ ≥ 0` such that for
  every `x₀ ≥ 16` and `r, n` with `x₀² ≤ 2^(r−n)`,
  `StmtRelErrWindow` holds for the rows of `π` against
  `m ↦ 2/log 2 + ∫ t in 1..m, exp (log 2·t)/t`, with
  `ρ = (3·floorConstSplit c₁ c₃ c₄ 112 0 698 0 x₀ + 13)·(log 2·r)·2^(−(r−n)/2)`.
  From `JointFloorGate.relErrWindow_floor_of_RH`, `weightedZeroHeightBucket_eq_zero`
  and `Li_two_rpow`. The bottom row is positive because `x₀² ≥ 256`.

`K0` stays inside `c₃`: `explicit_formula_split` hands its constants out under
an existential, and naming `c₃` means a further copy of that proof. Its term
is of size `1e-5` in unit 0410.

### E7 The bounds on ζ in a bounded region — PROVED, all four sub-blocks (units 0416, 0417, 0418); the numerals are not yet wired into the route

Read 2026-11-22: `Stage3/ZetaGrowth.lean` (statements, and the proof of
`zeta_growth_strip`), `EdgeBound.gz_partial_fraction` and `ball_order_sum_le`
(in full, units 0405 and 0409), `Glue.edge_left_bound` (in full, block E2),
`JensenCount.zetaWindow`.

What is unnamed, and where each enters.

| name | what | enters |
|---|---|---|
| `CK` | sup of `‖(s−1)²ζ‖` on `[−1/2, 4] × [−2, 2]`, from compactness | `ZetaGrowth.sq_zeta_band_bound`, `Cb = max 135 CK + 1`; then `D0`, `A`, `C1` in `gz_partial_fraction` |
| `cζ` | `‖ζ 3 / ζ (3/2)‖`, a positive real with no numeral | `D0 = Cb·81/(4cζ) + 2`. Not in unit 0412's list of five; found on this read |
| `M0` | zeros with `0 ≤ Re ≤ 1`, `0 ≤ Im ≤ 6`, with multiplicity | `ball_order_sum_le`, `C2 = M0/log 2 + 8W0 + 1` |
| `Mc` | sup of `‖ζ′/ζ‖` on `Re = −1/4`, `‖t‖ ≤ 2`, from compactness | `edge_left_bound`, `D = 36Ce + 9(Mc+1)/log 2` |

What the tree already has that makes these reachable.

- `ZetaGrowth.zeta1 N s`, the Euler–Maclaurin form continued to `Re s > −1`,
  with `zeta1_eq_zeta_strip` (it is ζ on the strip region), `tail_norm_le`
  (the tail integral is at most `(1/4)·N^(−σ−1)` for `σ ≥ −1/2`) and
  `sum_norm_le`. `zeta_growth_strip` is these three at `N = ⌊‖t‖⌋`, which is
  why it needs `‖t‖ ≥ 2`. Nothing in them needs `‖t‖ ≥ 2`.
- Upstream `ZerosBound` (Jensen's count in a disc) and `FinalBound` (the
  partial fraction), both already used at heights `≥ 2`.

The blocks, in the order that makes each one's input a numeral.

- **E7a `CK`** — PROVED (unit 0416: `BoxBounds.sq_zeta_box`, `sq_zeta_band_explicit`; the proof's arithmetic reaches 132). `zeta1` at `N = 1` on the box: `ζ = 1/2 − 1/(1−s) + s(s+1)·tail`,
  so `(s−1)²ζ = (s−1)²·(1/2 + s(s+1)·tail) + (s−1)`, with `‖tail‖ ≤ 1/4`.
  On the box `‖s−1‖² ≤ 13`, `‖s‖·‖s+1‖ ≤ 24.1`, giving about `89` (hand
  arithmetic, not checked by any script). Below `135`, so `Cb = 136`.
  The one care: the identity is on `s ≠ 1`; both sides are continuous at `1`.
  Size: one theorem, no copy.
- **E7b `cζ`** — PROVED (unit 0416: `BoxBounds.zeta_ratio_ge`). A numeral below it: `ζ 3 ≥ 1` from the Dirichlet series,
  `‖ζ (3/2)‖ ≤ 7/2` from `Zeta0EqZeta` at `N = 1` as in block E5. Then
  `cζ ≥ 2/7`. Size: short.
- **E7c `M0`** — PROVED (unit 0417: `EdgeBound.low_rect_count`, `M0 ≤ 714`, on six discs about `3/2 + i(j + 1/2)` of radius `8/5`, `low_ball_count ≤ 119` each). As drafted: Jensen's count on discs of radius 2 about `3/2 + ih`,
  `h = 0, …, 6`: each covers the part of the rectangle within height `1/2` of
  `h` at scaled radius `0.79`, and needs `gz` bounded on the disc (E7a with
  `zeta_growth_strip`) and bounded below at the centre (E7b, as `gz_lower`).
  This is `ball_order_sum_le`'s own argument at seven fixed heights.
  Size: a copy of that argument with the height fixed.
- **E7d `Mc`** — PROVED (unit 0418: `EdgeBound.logDerivZeta_short_segment`, `Mc ≤ 1620000`, with `gz_partial_fraction_low` and `low_ball_count_wide`). As drafted: `gz_partial_fraction` and `edge_bound_core` are stated for
  heights `≥ 2` because their bound is `C·log T′`. At heights in `[0, 2]` the
  same proof gives a constant: `B = D0·16`. With it, on `Re = −1/4` every zero
  and the pole are at distance at least `1/4`, so
  `‖ζ′/ζ‖ ≤ C1′ + 4·(count from E7c) + 8/5`.
  Size: the two long proofs copied with the height bounded above in place of
  below, about 450 lines, a few tens changed.

After E7a–E7d the constants of `explicit_formula_split` can be written as
definitions with numerals, which is a last copy of that proof with its
constants named in the statement.

What decides whether this is worth doing. Unit 0410: the route covers depth
six seventeen rungs inside the table with these quantities at zero, and has a
factor 49,000 of slack. E7 would turn that pricing, which is of floors, into
a number the kernel checked. It would still be a theorem under RH.

### E8 The constants as definitions — PROVED (unit 0419: `EdgeNum`, `GlueNum`, `RouteNum.relErrWindow_route_num`, with `c1n_le`, `c3n_le`, `c4n_le`)

Block E7 proved a numeral for every quantity under the route's constants.
The theorems that produce the constants still say "there exists". E8 restates
each with its constant a definition: the original proof, with every
`obtain ⟨C, _, _⟩ := <existence theorem>` replaced by the named constant and
its restated theorem, and the `refine ⟨<expression>, _, ?_⟩` replaced by the
definition unfolding to that expression. No new mathematics.

- **E8a** `Stage3/EdgeNum.lean`: `gz_partial_fraction_num` (`C1n`),
  `ball_order_sum_le_num` (`C2n`), `edge_bound_core_num` (`Cen`).
- **E8b** `Stage3/GlueNum.lean`: `zeta_logderiv_good_bound_num` (`Cpn`),
  `edge_horizontal_bound_num` (`Chn`), `edge_left_sharp_num` (`Dln`, with
  `logDerivZeta_short_segment` in place of compactness),
  `zeroPartialSum_swap_num` (`Csn`), `explicit_formula_split_num`.
- **E8c** the route's theorem with the three constants named, and a numeral
  above each.

### E9 The Lean gate evaluated — DRAFT for Julian, nothing built

Read 2026-11-22: `lean/Interpolant.tableFrom_ne_zero_of_relErr_liRow` (its
five hypotheses), `RouteNum.relErrWindow_route_num`, `Stage3.routeConst`,
`floorConstSplit`. The arithmetic below is from a throwaway script, not a
logged run.

The gate, for a cell `(r, d)`:

- `hrow`: the table's row is the difference of `f` along the doublings, on
  the `d + 2` rows of the window;
- `hS`: `StmtRelErrWindow f liRow r (d+1) ρ`;
- `hbot`: `1 ≤ r − (d+1)`;  `hw`: `2d ≤ log 2·(r − (d+1))`;
- `hρ`: `ρ < (log 2)^d / (2·r·3^(d+1))`.

The route gives `hS` under RH with `ρ = routeConst x₀·(log 2·r)·2^(−(r−d−1)/2)`
whenever `x₀² ≤ 2^(r−d−1)`.

Choice of floor. `x₀ = 2^36`: then `√x₀ = 2^18` and `x₀^(1/4) = 2^9` are
exact, `floorConstSplit ≤ 133.64` from the proved ceilings, and
`routeConst (2^36) ≤ 414`. (At `2^34` the constant is larger and the fourth
root is not a power of two; at `2^40` the floor costs more rows than the
constant saves.)

Depth six. `hρ` reads `414·2·3^7·r²·2^(−(r−7)/2) < (log 2)^5`. At `r = 80`
the left side is about `0.1193` and the right side about `0.1599`. For
`r ≥ 80`, `r² ≤ 6400·2^((r−80)/2)` (from `1 + x + x²/2 ≤ e^x`), so the left
side does not grow. The floor needs `r − 7 ≥ 72`, which `r ≥ 80` gives; `hbot`
and `hw` hold with room. By the same script the inequality fails at `r = 79`.

Theorems.

- Stage 3, `routeConst_le`: `routeConst (2^36) ≤ 414`.
- Stage 3, `gate_ineq`: for real `r ≥ 80`,
  `414·(log 2·r)·2^(−(r−7)/2) < (log 2)^6/(2·r·3^7)`.
- Stage 3, `gate_hyp_of_RH`: under RH, for every integer `r ≥ 80` there is `ρ`
  with `StmtRelErrWindow (rows of π) (main term) r 7 ρ` and
  `ρ < (log 2)^6/(2·r·3^7)`.
- Table tree, `cell_ne_zero_of_route`: from that conclusion as a hypothesis,
  written in the same characters, and `hrow`: `tableFrom N r 6 ≠ 0` for
  `r ≥ 80`. The main term is `liRow` at the rows by `liRow_eq`.

What it would say, read across the weld: under RH, no cell at depth six is
zero from row 80 on. The census computed in O43 covers the rows below. It
would be a conditional statement about named cells, with RH as the
hypothesis and the weld as the one step the kernel does not check.

What it would not say: anything unconditional; anything about depths other
than six (each depth has its own `r`, by the same two lemmas); anything in
the direction from the table to the zeros.

