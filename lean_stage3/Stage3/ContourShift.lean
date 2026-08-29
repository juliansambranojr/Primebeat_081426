/-
# The contour shift — slices 2, 3, 4 (hEF's build order, entry 257)

SCRATCH: this file carries named `sorry`s by design. It is the slice map
for the contour shift, compiling so the obligations are real Lean
statements. Do not count this module in any sorry-free claim.

Slice 1 is COMPLETE in `Stage3.PerronKernel` (`explicit_formula_perron`):
`ψ` against the truncated `−ζ′/ζ` integral at `re = 1 + 1/log x`, error
`600·x·log(xT)²/T + 13·log x`. This file moves the contour:

  S2  good heights: in every unit interval there is a `T'` whose distance
      to every zero ordinate is ≥ `zeroGap T` — pigeonhole on
      `Stage3.zeta_local_zero_count` (15·log T + 73 orders per window),
      with the `β ≥ 1/2` partner via `riemannZeta_conj` +
      `riemannZeta_one_sub` placing every ordinate in a window.
  S3  edge bounds: at a good height, `‖ζ′/ζ(σ ± iT′)‖ ≤ C·log²T′` on
      `−1 ≤ σ ≤ 2`. Route: the Hadamard partial fraction
      (PNT+ `LogDerivZetaFinalBound` covers `σ > 1/2`; the strip needs
      the partial-fraction with the good-gap denominator bounds; `σ ≤ −1`
      by the functional equation).
  S4  the residue identity: `RectangleIntegral'` of `G = (−ζ′/ζ)·x^s/s`
      on `[−1, c] × [−T′, T′]` equals `x − ζ′/ζ(0) − Σ_{|γ|<T′} m·x^ρ/ρ`
      (PNT+ `ResidueTheoremOnRectangleWithSimplePole` / sumResiduesIn
      machinery; the pole at 1 gives `x`, at 0 gives `−ζ′/ζ(0)`, each ρ
      gives `−m·x^ρ/ρ`).

Assembly target: `StmtExplicitFormula c₁ c₂ x₁` (Stage3.Assembly:101) in
the consumed regime; the `T > x` tail is its own flagged obligation.
-/
import Stage3.PerronKernel
import Stage3.JensenCount
import Stage3.Assembly

namespace ContourShift

open Complex Topology

/-- The ordinate gap the pigeonhole delivers: crude-explicit,
`1/(180·log T + 1060)`. -/
noncomputable def zeroGap (T : ℝ) : ℝ := 1 / (180 * Real.log T + 1060)

theorem zeroGap_pos {T : ℝ} (hT : 2 ≤ T) : 0 < zeroGap T := by
  rw [zeroGap]
  have h1 : (0:ℝ) < Real.log T := Real.log_pos (by linarith)
  positivity

theorem zeroGap_le {T : ℝ} (hT : 2 ≤ T) : zeroGap T ≤ 9/10 := by
  rw [zeroGap]
  have h1 : (0:ℝ) < Real.log T := Real.log_pos (by linarith)
  rw [div_le_iff₀ (by positivity)]
  nlinarith

/-- **Slice 2 — good heights exist.** -/
theorem goodT_exists {T : ℝ} (hT : 2 ≤ T) :
    ∃ T' ∈ Set.Icc T (T+1), ∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.re →
      zeroGap T ≤ |ρ.im - T'| := by
  sorry

/-- **Slice 3 — the edge bound at a good height.** -/
theorem edge_bound {T T' : ℝ} (hT : 2 ≤ T) (hT' : T' ∈ Set.Icc T (T+1))
    (hgood : ∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.re → zeroGap T ≤ |ρ.im - T'|) :
    ∃ C : ℝ, 0 < C ∧ C ≤ 10 ^ 7 ∧ ∀ σ : ℝ, -1 ≤ σ → σ ≤ 2 → ∀ ε : ℝ, ε = T' ∨ ε = -T' →
      ‖deriv riemannZeta ((σ : ℂ) + Complex.I * ε)
          / riemannZeta ((σ : ℂ) + Complex.I * ε)‖
        ≤ C * Real.log T ^ 2 := by
  sorry

/-- **Slice 4 — the residue identity on the good rectangle.** The zeros
enter here: pulling the line integral to `σ = −1` collects the pole at
`1` (residue `x`), the pole at `0` (residue `−ζ′/ζ(0)`), and every
nontrivial zero below height `T'` (residue `−m_ρ·x^ρ/ρ`). -/
theorem residue_identity {x T T' : ℝ} (hx : 16 ≤ x) (hT : 2 ≤ T)
    (hT' : T' ∈ Set.Icc T (T+1))
    (hgood : ∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.re → zeroGap T ≤ |ρ.im - T'|) :
    RectangleIntegral'
        (fun s : ℂ ↦ (- deriv riemannZeta s / riemannZeta s)
          * ((x:ℝ):ℂ) ^ s / s)
        (-1 - Complex.I * T') (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * T')
      = (x : ℂ) - deriv riemannZeta 0 / riemannZeta 0
        - Stage3.zeroPartialSum x T' := by
  sorry

end ContourShift
