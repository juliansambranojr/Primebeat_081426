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

