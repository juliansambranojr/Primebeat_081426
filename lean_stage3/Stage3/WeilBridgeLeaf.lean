/-
WeilBridgeLeaf — the zero-set lemma and the bridge leaf: `zeroForm` gets a
prime side. Block 1 of `lean_stage3/design/bridge.md`. 2026-11-22.

`WeilDetect.zeroForm G` is upstream's `riemannZeta.zeroes_sum` over the
rectangle `Re ρ ∈ (0, 1)`, weighted by `riemannZeta.order`, which is a
meromorphic order with `⊤` sent to `0`. The third tree (`lean_bridge/`,
Lean v4.33.0-rc2, zeta23 as a dependency) proves the explicit formula's
consequence over Mathlib's vocabulary: the set
`{ρ | riemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1}` weighted by
`(analyticOrderAt riemannZeta ρ).toNat`. This module shows they are the
same sum and consumes the third tree's statement as a named leaf.

  order_eq_toNat          ρ ≠ 1:  riemannZeta.order ρ = (analyticOrderAt riemannZeta ρ).toNat
  zeroes_rect_strip       the rectangle is the strip set
  zeroForm_eq_strip       zeroForm G = Σ over the strip set, weighted by toNat
  zeroForm_eq_primeSide   StmtWeilBridge → IsTest L G → zeroForm G = primeSideM (kOfM G)

`order_eq_toNat` needs no non-vanishing: at analytic order `⊤` both sides
are `0`.

The five definitions `tiltF`, `ft`, `kOfM`, `primeSideM`, `StmtWeilBridge`
are character copies of `lean_bridge/Bridge/WeilBridge.lean`'s, gated by
`utilities/check_weld.py`. `StmtWeilBridge` is a leaf with no constant. Its
discharge is `Bridge.stmtWeilBridge_holds` in the third tree, kernel-checked
there against `Zeta23.WeilEF.EF_lit_zetaZeroConfig`; the join to this tree
is by statement identity, as with `lean/`.

What the next slice needs: a use for the prime side. `primeSideM (kOfM G)`
is the pole terms, minus `Σ Λ(n)/√n·(k(log n) + k(−log n))`, plus the
archimedean integral; positivity of the form is a statement about that.

Axioms: every theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.WeilDetect

namespace WeilBridgeLeaf

noncomputable section

open Complex Set MeasureTheory WeilDetect

/-- `F(u) = G(u)·e^{u/2}`: the test function in zeta23's centred variable. -/
def tiltF (G : ℝ → ℂ) : ℝ → ℂ := fun u => G u * ((Real.exp (u / 2) : ℝ) : ℂ)

/-- The transform `∫ k(u) e^{izu} du`; zeta23's `paperFT`. -/
def ft (k : ℝ → ℂ) (z : ℂ) : ℂ :=
  ∫ u : ℝ, k u * Complex.exp (Complex.I * z * (u : ℂ))

/-- `k = F ⋆ F̃` in Mathlib's convolution; zeta23's `weilTest` at `F = tiltF G`. -/
def kOfM (G : ℝ → ℂ) : ℝ → ℂ :=
  MeasureTheory.convolution (tiltF G) (fun u => (starRingEnd ℂ) (tiltF G (-u)))
    (ContinuousLinearMap.mul ℝ ℂ) MeasureTheory.volume

/-- The prime side: the pole terms, minus the prime sum, plus the archimedean integral. -/
def primeSideM (k : ℝ → ℂ) : ℂ :=
  ft k (Complex.I / 2) + ft k (-Complex.I / 2)
  - ∑' n : ℕ, ((ArithmeticFunction.vonMangoldt n / Real.sqrt n : ℝ) : ℂ)
      * (k (Real.log n) + k (-Real.log n))
  + (1 / (2 * Real.pi) : ℂ) * ∫ r : ℝ, ft k r
      * (((logDeriv Complex.Gamma (1 / 4 + Complex.I * r / 2)).re - Real.log Real.pi : ℝ) : ℂ)

/-- **The bridge, as a statement.** -/
def StmtWeilBridge : Prop :=
  ∀ (L : ℝ) (G : ℝ → ℂ), IsTest L G →
    Summable (fun ρ : {ρ : ℂ | riemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1} =>
        (((analyticOrderAt riemannZeta (ρ : ℂ)).toNat : ℕ) : ℂ)
          * (laplace G (-(ρ : ℂ)) * laplace G (-(1 - (ρ : ℂ))))) ∧
      ∑' ρ : {ρ : ℂ | riemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1},
        (((analyticOrderAt riemannZeta (ρ : ℂ)).toNat : ℕ) : ℂ)
          * (laplace G (-(ρ : ℂ)) * laplace G (-(1 - (ρ : ℂ))))
        = primeSideM (kOfM G)

/-- Upstream's order at a point other than the pole is the analytic order. -/
theorem order_eq_toNat {ρ : ℂ} (hρ : ρ ≠ 1) :
    riemannZeta.order ρ = (((analyticOrderAt riemannZeta ρ).toNat : ℕ) : ℤ) := by
  have hd : DifferentiableOn ℂ riemannZeta ({1}ᶜ : Set ℂ) := fun x hx =>
    (differentiableAt_riemannZeta hx).differentiableWithinAt
  have han : AnalyticAt ℂ riemannZeta ρ := hd.analyticAt (isOpen_compl_singleton.mem_nhds hρ)
  unfold riemannZeta.order
  rw [han.meromorphicOrderAt_eq]
  cases hO : analyticOrderAt riemannZeta ρ with
  | top => simp
  | coe n => rw [ENat.map_coe, WithTop.untopD_coe, ENat.toNat_coe]

/-- Upstream's rectangle over `(0, 1)` is the strip set. -/
theorem zeroes_rect_strip :
    riemannZeta.zeroes_rect (Set.Ioo 0 1) Set.univ
      = {ρ : ℂ | riemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1} := by
  ext ρ
  simp only [riemannZeta.zeroes_rect, riemannZeta.zeroes, Set.mem_setOf_eq, Set.mem_Ioo,
    Set.mem_univ, true_and]
  tauto

/-- **The zero-set lemma.** `zeroForm` over Mathlib's zero set and analytic order. -/
theorem zeroForm_eq_strip (G : ℝ → ℂ) :
    zeroForm G = ∑' ρ : {ρ : ℂ | riemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1},
      (((analyticOrderAt riemannZeta (ρ : ℂ)).toNat : ℕ) : ℂ)
        * (laplace G (-(ρ : ℂ)) * laplace G (-(1 - (ρ : ℂ)))) := by
  unfold zeroForm riemannZeta.zeroes_sum
  have h1 := tsum_congr_set_coe
    (fun ρ : ℂ => laplace G (-ρ) * laplace G (-(1 - ρ)) * ((riemannZeta.order ρ : ℤ) : ℂ))
    zeroes_rect_strip
  rw [h1]
  apply tsum_congr
  intro ρ
  have hne : (ρ : ℂ) ≠ 1 := by
    intro h
    have h2 := ρ.2.2.2
    rw [h] at h2
    simp at h2
  rw [order_eq_toNat hne]
  push_cast
  ring

/-- **The prime side of Weil's form.** -/
theorem zeroForm_eq_primeSide (h : StmtWeilBridge) {L : ℝ} {G : ℝ → ℂ} (hG : IsTest L G) :
    zeroForm G = primeSideM (kOfM G) := by
  rw [zeroForm_eq_strip]
  exact (h L G hG).2

end

/-- info: 'WeilBridgeLeaf.order_eq_toNat' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms order_eq_toNat

/-- info: 'WeilBridgeLeaf.zeroes_rect_strip' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeroes_rect_strip

/-- info: 'WeilBridgeLeaf.zeroForm_eq_strip' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeroForm_eq_strip

/-- info: 'WeilBridgeLeaf.zeroForm_eq_primeSide' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeroForm_eq_primeSide

end WeilBridgeLeaf
