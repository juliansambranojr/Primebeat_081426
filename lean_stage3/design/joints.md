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

