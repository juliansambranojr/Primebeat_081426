/-
LandauPoleSub — finitely many simple poles subtracted on an open set, and
what that gives for the Taylor coefficients. Nothing here is about `ζ`.
Block 3b1 of `lean_stage3/design/landau.md`. 2026-11-22.

  iteratedDeriv_inv_sub              the k-th derivative of (s − q)⁻¹ at c is
                                       (−1)^k · k! · (c − q)^(−1−k)
  exists_differentiableOn_sub_poles  f differentiable on U off P, a
                                       local form f = h + A p/(s − p) at each
                                       p ∈ P with h analytic at p :
                                       ∃ g differentiable on U with
                                       g = f − Σ_{q ∈ P} A q/(s − q) off P
  taylor_coeff_sub_poles             closedBall c R ⊆ U, 0 < R, c ∉ P, such a g :
                                       ∃ C, ∀ k, ‖iteratedDeriv k f c
                                         − Σ_q A q·(−1)^k·k!·(c − q)^(−1−k)‖
                                         ≤ k!·C/R^k

The gluing is the construction of `ContourShift.residue_rectangle_of_local`,
copied with the rectangle replaced by an open set. The bound is Cauchy's
estimate for `g` on the circle of radius `R`.

What the next slice needs: these with `f = Phi`, `P` the zeros of `ζ` in a
disc and the point `1`, and `A` the residues of block 3a (block 3b2).

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Mathlib

namespace LandauPoleSub

noncomputable section

open Filter Topology Metric

/-- The `k`-th derivative of `s ↦ (s − q)⁻¹` at `c` is `(−1)^k·k!·(c − q)^(−1−k)`. -/
theorem iteratedDeriv_inv_sub (k : ℕ) (q c : ℂ) :
    iteratedDeriv k (fun s : ℂ => (s - q)⁻¹) c
      = (-1) ^ k * (k.factorial : ℂ) * (c - q) ^ (-1 - (k : ℤ)) := by
  have h := congrFun (iteratedDeriv_comp_sub_const (n := k) (f := (Inv.inv : ℂ → ℂ)) (s := q)) c
  rw [h, iteratedDeriv_eq_iterate, iter_deriv_inv]

/-- If `f` is differentiable at every point of `U` off the finite set `P`, and near each
`p ∈ P` has the local form `f = h + A p/(s − p)` with `h` analytic at `p`, then there is a
`g` differentiable on `U` with `g = f − Σ_{q ∈ P} A q/(s − q)` off `P`. -/
theorem exists_differentiableOn_sub_poles {U : Set ℂ} {P : Finset ℂ}
    {f A : ℂ → ℂ} (hf : ∀ s ∈ U, s ∉ P → DifferentiableAt ℂ f s)
    (hloc : ∀ p ∈ P, ∃ h : ℂ → ℂ, AnalyticAt ℂ h p ∧
      ∀ᶠ s in 𝓝[≠] p, f s = h s + A p / (s - p)) :
    ∃ g : ℂ → ℂ, DifferentiableOn ℂ g U ∧
      ∀ s, s ∉ P → g s = f s - ∑ q ∈ P, A q / (s - q) := by
  classical
  choose! h hana hev using hloc
  set g : ℂ → ℂ := fun s ↦ if s ∈ P then h s s - ∑ q ∈ P.erase s, A q / (s - q)
    else f s - ∑ q ∈ P, A q / (s - q) with hgd
  have hPclosed : IsClosed (P : Set ℂ) := P.finite_toSet.isClosed
  refine ⟨g, ?_, fun s hs => by rw [hgd]; simp only [if_neg hs]⟩
  intro x hxU
  by_cases hxP : x ∈ P
  · -- glued point: g agrees with the local analytic model on a full neighbourhood
    have hother : {s : ℂ | s ∉ (P.erase x : Finset ℂ)} ∈ 𝓝 x := by
      have h1 : IsOpen ((↑(P.erase x) : Set ℂ))ᶜ :=
        (P.erase x).finite_toSet.isClosed.isOpen_compl
      exact h1.mem_nhds (by simp)
    have heq : g =ᶠ[𝓝 x] (fun s ↦ h x s - ∑ q ∈ P.erase x, A q / (s - q)) := by
      have h1 := hev x hxP
      rw [eventually_nhdsWithin_iff] at h1
      filter_upwards [h1, hother] with s hs1 hs2
      by_cases hsx : s = x
      · rw [hsx, hgd]
        simp only [if_pos hxP]
      · have hsP : s ∉ P := by
          intro hsP
          exact hs2 (Finset.mem_erase.mpr ⟨hsx, hsP⟩)
        have h2 := hs1 (by simpa using hsx)
        rw [hgd]
        simp only [if_neg hsP]
        rw [h2, ← Finset.add_sum_erase P (fun q ↦ A q / (s - q)) hxP]
        ring
    have hH : DifferentiableAt ℂ
        (fun s ↦ h x s - ∑ q ∈ P.erase x, A q / (s - q)) x := by
      apply DifferentiableAt.sub (hana x hxP).differentiableAt
      apply DifferentiableAt.fun_sum
      intro q hq
      have hxq : x - q ≠ 0 := by
        rw [sub_ne_zero]
        intro hxq
        exact absurd (hxq ▸ hq) (by simp)
      exact (differentiableAt_const _).div
        (differentiableAt_id.sub (differentiableAt_const _)) hxq
    exact (heq.differentiableAt_iff.mpr hH).differentiableWithinAt
  · -- plain point: g agrees with f − Σ near x
    have hcompl : {s : ℂ | s ∉ P} ∈ 𝓝 x := hPclosed.isOpen_compl.mem_nhds hxP
    have heq : g =ᶠ[𝓝 x] (fun s ↦ f s - ∑ q ∈ P, A q / (s - q)) := by
      filter_upwards [hcompl] with s hs
      rw [hgd]
      simp only [if_neg hs]
    have hd2 : DifferentiableAt ℂ (fun s ↦ ∑ q ∈ P, A q / (s - q)) x := by
      apply DifferentiableAt.fun_sum
      intro q hq
      have hxq : x - q ≠ 0 := by
        rw [sub_ne_zero]
        intro hxq
        exact hxP (hxq ▸ hq)
      exact (differentiableAt_const _).div
        (differentiableAt_id.sub (differentiableAt_const _)) hxq
    exact (heq.differentiableAt_iff.mpr ((hf x hxU hxP).sub hd2)).differentiableWithinAt

/-- If the closed ball of radius `R > 0` about `c` lies in the open set `U`, `c ∉ P`, and `g` is
differentiable on `U` with `g = f − Σ_{q ∈ P} A q/(s − q)` off `P`, then there is a `C` such
that for every `k` the `k`-th derivative of `f` at `c` is within `k!·C/R^k` of
`Σ_{q ∈ P} A q·(−1)^k·k!·(c − q)^(−1−k)`. -/
theorem taylor_coeff_sub_poles {c : ℂ} {R : ℝ} (hR : 0 < R) {U : Set ℂ} (hU : IsOpen U)
    (hball : closedBall c R ⊆ U) {P : Finset ℂ} {f A g : ℂ → ℂ} (hcP : c ∉ P)
    (hg : DifferentiableOn ℂ g U)
    (hgf : ∀ s, s ∉ P → g s = f s - ∑ q ∈ P, A q / (s - q)) :
    ∃ C : ℝ, ∀ k : ℕ, ‖iteratedDeriv k f c
      - ∑ q ∈ P, A q * ((-1) ^ k * (k.factorial : ℂ) * (c - q) ^ (-1 - (k : ℤ)))‖
        ≤ k.factorial * C / R ^ k := by
  have hcU : c ∈ U := hball (mem_closedBall_self hR.le)
  obtain ⟨C, hC⟩ := (isCompact_sphere c R).exists_bound_of_continuousOn
    (hg.continuousOn.mono (sphere_subset_closedBall.trans hball))
  refine ⟨C, fun k => ?_⟩
  set F : ℂ → ℂ := fun s => ∑ q ∈ P, A q * (s - q)⁻¹ with hF
  have hcompl : {s : ℂ | s ∉ P} ∈ 𝓝 c := P.finite_toSet.isClosed.isOpen_compl.mem_nhds hcP
  have heq : f =ᶠ[𝓝 c] g + F := by
    filter_upwards [hcompl] with s hs
    rw [Pi.add_apply, hgf s hs, hF]
    simp only [div_eq_mul_inv]
    ring
  have hgA : AnalyticAt ℂ g c := hg.analyticAt (hU.mem_nhds hcU)
  have hterm : ∀ q ∈ P, AnalyticAt ℂ (fun s : ℂ => A q * (s - q)⁻¹) c := by
    intro q hq
    have hcq : c - q ≠ 0 := by
      rw [sub_ne_zero]
      intro h
      exact hcP (h ▸ hq)
    exact analyticAt_const.mul ((analyticAt_id.sub analyticAt_const).inv hcq)
  have hFA : AnalyticAt ℂ F c := by
    rw [hF]
    exact Finset.analyticAt_fun_sum P hterm
  have hsumF : iteratedDeriv k F c
      = ∑ q ∈ P, A q * ((-1) ^ k * (k.factorial : ℂ) * (c - q) ^ (-1 - (k : ℤ))) := by
    rw [hF, iteratedDeriv_fun_sum (fun q hq => (hterm q hq).contDiffAt)]
    refine Finset.sum_congr rfl fun q _ => ?_
    rw [iteratedDeriv_const_mul_field, iteratedDeriv_inv_sub]
  rw [heq.iteratedDeriv_eq k, iteratedDeriv_add hgA.contDiffAt hFA.contDiffAt, hsumF,
    add_sub_cancel_right]
  exact Complex.norm_iteratedDeriv_le_of_forall_mem_sphere_norm_le k hR
    (hg.diffContOnCl_ball hball) hC

/-- info: 'LandauPoleSub.iteratedDeriv_inv_sub' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms iteratedDeriv_inv_sub

/-- info: 'LandauPoleSub.exists_differentiableOn_sub_poles' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms exists_differentiableOn_sub_poles

/-- info: 'LandauPoleSub.taylor_coeff_sub_poles' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms taylor_coeff_sub_poles

end

end LandauPoleSub
