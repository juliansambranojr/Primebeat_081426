/-
MeanQV — block S13 of `lean_stage3/design/stencil.md`, B4 step 3, the mean value with a
general Q: the mean of `|Vψ|²` for Conrey's `V = W/Gammaℝ`. 2026-11-25.

`V = VQ + E` (`MeanQRed`), `VQ = Q(−D/L)ζ`. Pointwise, for `δ > 0`,
`|a + e|² ≤ (1 + δ)|a|² + (1 + 1/δ)|e|²` (`sq_add_le`), used both ways; with
`|E| ≤ (K/L) Σ_j |ζ^{(j)}|/L^j` and `(Σ_j u_j)² ≤ (d+1) Σ_j u_j²`,
`∫ w |E|²|ψ|² ≤ (K/L)²(d+1) Σ_j ∫ w |ζ^{(j)}/L^j|² |ψ|²`, and each of those is `O(errO)`
(`MeanQBound.meanJ_bound`). At `δ = 1/L`:

  `|∫ w |Vψ|² − Re DopQ[c]·ŵ(0)| ≤ ε·errO`  from some height on.

**Sizes, the lost-factor check.** `δ·∫ w |VQ ψ|² = O(T/L)`; `(1 + 1/δ)·∫ w |Eψ|² =
(1 + L)·O(T/L²) = O(T/L)`. Both are `o(T)`, so no factor is lost; the choice `δ = 1/L` balances
them. Cauchy–Schwarz on the cross term gives the same `O(T/L)` and needs no integral inequality.

  | name               | statement                                                       | status |
  |--------------------|-----------------------------------------------------------------|--------|
  | `sq_add_le`        | `‖a + e‖² ≤ (1+δ)‖a‖² + (1+1/δ)‖e‖²`                              | PROVED |
  | `mollMeanQ_re`     | `Re mollMeanQ = ∫ w |VQ|² |ψ|²`                                   | PROVED |
  | `continuous_V_line`, `continuous_VQ_line` | `t ↦ V(σ₀+it)`, `t ↦ VQ(σ₀+it)` continuous, `0 < σ₀ < 1` | PROVED |
  | `mollMeanV`        | `∫ w |V|² |ψ|²` (real)                                           | defined |
  | `StmtMollMeanV`    | `|mollMeanV − Re DopQ[c]·ŵ(0)| ≤ ε·errO` from some height on     | defined |
  | `mollMeanV_long`   | Lemma 3 at `κ = 2R+1+1/R`, `StmtGrRatio d` ⊢ `StmtMollMeanV`      | PROVED |

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.MeanQBound

noncomputable section

namespace MeanQ

open Complex Polynomial MeasureTheory Metric Filter Topology ApproxFE TwistedMoment Operator
  DiagMainStmt DiagonalO OffDiagClose

/-- `‖a + e‖² ≤ (1 + δ)‖a‖² + (1 + 1/δ)‖e‖²`, `δ > 0`. -/
theorem sq_add_le (a e : ℂ) {δ : ℝ} (hδ : 0 < δ) :
    ‖a + e‖ ^ 2 ≤ (1 + δ) * ‖a‖ ^ 2 + (1 + 1 / δ) * ‖e‖ ^ 2 := by
  have h1 : ‖a + e‖ ^ 2 ≤ (‖a‖ + ‖e‖) ^ 2 :=
    pow_le_pow_left₀ (norm_nonneg _) (norm_add_le a e) 2
  have key : (1 + δ) * ‖a‖ ^ 2 + (1 + 1 / δ) * ‖e‖ ^ 2 - (‖a‖ + ‖e‖) ^ 2 =
      (δ * ‖a‖ - ‖e‖) ^ 2 / δ := by
    field_simp
    ring
  have h2 : 0 ≤ (δ * ‖a‖ - ‖e‖) ^ 2 / δ := by positivity
  linarith

/-- `‖VQ (X^j)‖ = ‖ζ^{(j)}‖/L^j`. -/
theorem norm_VQ_X_pow (j : ℕ) {L : ℝ} (hL : 0 < L) (s : ℂ) :
    ‖VQ (X ^ j) L s‖ = ‖iteratedDeriv j riemannZeta s‖ / L ^ j := by
  rw [VQ_X_pow, norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_pow, abs_div, abs_neg,
    abs_one, abs_of_pos hL, one_div_pow]
  ring

/-- `Re mollMeanQ = ∫ w |VQ|² |ψ|²`. -/
theorem mollMeanQ_re {T L : ℝ} (W : Weight T L) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ) (Q : ℝ[X])
    (L' : ℝ) : (mollMeanQ W M a σ₀ Q L').re =
      ∫ t, W.w t * (‖VQ Q L' ((σ₀ : ℂ) + t * I)‖ ^ 2 * msq M a σ₀ t) := by
  unfold mollMeanQ
  have e : (fun t : ℝ => (W.w t : ℂ) * ((‖VQ Q L' ((σ₀ : ℂ) + t * I)‖ ^ 2 : ℝ) : ℂ) *
      (msq M a σ₀ t : ℂ)) =
      fun t : ℝ => ((W.w t * (‖VQ Q L' ((σ₀ : ℂ) + t * I)‖ ^ 2 * msq M a σ₀ t) : ℝ) : ℂ) := by
    funext t
    push_cast
    ring
  rw [e, integral_complex_ofReal, Complex.ofReal_re]

theorem line_ne_one {σ₀ : ℝ} (hσ : σ₀ ≠ 1) (t : ℝ) : (σ₀ : ℂ) + t * I ≠ 1 := by
  intro h
  have h1 := congrArg Complex.re h
  simp at h1
  exact hσ h1

/-- `t ↦ VQ(σ₀+it)` is continuous for `σ₀ ≠ 1`. -/
theorem continuous_VQ_line (Q : ℝ[X]) (L : ℝ) {σ₀ : ℝ} (hσ : σ₀ ≠ 1) :
    Continuous fun t : ℝ => VQ Q L ((σ₀ : ℂ) + t * I) := by
  have hc : Continuous fun t : ℝ => (σ₀ : ℂ) + t * I := by fun_prop
  unfold VQ
  refine continuous_finsetSum _ fun j _ => continuous_const.mul ?_
  exact (zetaK_diffOn j).continuousOn.comp_continuous hc fun t =>
    Set.mem_compl_singleton_iff.mpr (line_ne_one hσ t)

/-- `t ↦ V(σ₀+it)` is continuous for `0 < σ₀ < 1`. -/
theorem continuous_V_line (Q : ℝ[X]) (L : ℝ) {σ₀ : ℝ} (h0 : 0 < σ₀) (h1 : σ₀ < 1) :
    Continuous fun t : ℝ => ConreyCount.V Q L ((σ₀ : ℂ) + t * I) := by
  have hc : Continuous fun t : ℝ => (σ₀ : ℂ) + t * I := by fun_prop
  refine continuous_iff_continuousAt.mpr fun t => ?_
  have hs0 : (σ₀ : ℂ) + t * I ≠ 0 := by
    intro h
    have := congrArg Complex.re h
    simp at this
    linarith
  have hre : 0 < ((σ₀ : ℂ) + t * I).re := by simp; exact h0
  have hA := ConreyCount.analyticAt_V Q L hs0 (line_ne_one h1.ne t)
    (Gammaℝ_ne_zero_of_re_pos hre)
  exact ContinuousAt.comp_of_eq hA.continuousAt hc.continuousAt rfl

/-- The mollified mean of Conrey's `V`: `∫ w(t) |V(σ₀+it)|² |ψ(σ₀+it)|² dt`, real. -/
def mollMeanV {T L : ℝ} (W : Weight T L) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ) (Q : ℝ[X]) (L' : ℝ) : ℝ :=
  ∫ t, W.w t * (‖ConreyCount.V Q L' ((σ₀ : ℂ) + t * I)‖ ^ 2 * msq M a σ₀ t)

/-- **The mollified mean of `V` at `o(T)`**: for every `Cs` and `ε > 0`, from some height on,
uniformly over `WeightAll T (log T)` with `C_j ≤ Cs j`,
`|∫ w |V(σ₀+it)|² |ψ(σ₀+it)|² − Re DopQ[c](−R/L, −R/L)·ŵ(0)| ≤ ε·errO W`. -/
def StmtMollMeanV (Q P : ℝ[X]) (θ R : ℝ) : Prop :=
  ∀ Cs : ℕ → ℝ, ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
    ∀ W : WeightAll T (Real.log T), (∀ j, W.Cj j ≤ Cs j) →
      |mollMeanV W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) Q (Real.log T) -
          (DopQ Q (Real.log T) (cY P (Mof T θ) T) ((-(R / Real.log T) : ℝ) : ℂ)
              ((-(R / Real.log T) : ℝ) : ℂ)).re * what0 W.toWeight| ≤
        ε * errO W.toWeight

/-- Integrability of `w·f` for continuous `f`. -/
theorem intg_w {T L : ℝ} (W : Weight T L) {f : ℝ → ℝ} (hf : Continuous f) :
    Integrable (fun t => W.w t * f t) :=
  (W.cont.mul hf).integrable_of_hasCompactSupport ((Unsmooth.w_compact W).mul_right)

/-- The two integrated comparisons, from a pointwise `E` bound on the support of `w`. -/
theorem compare_means {T L : ℝ} (W : Weight T L) {fV fQ : ℝ → ℝ} {fJ : ℕ → ℝ → ℝ}
    {n : ℕ} {δ c : ℝ}
    (hV : Continuous fV) (hQ : Continuous fQ) (hJ : ∀ j, Continuous (fJ j))
    (hle1 : ∀ t ∈ Set.Icc (T / 4) (2 * T),
      fV t ≤ (1 + δ) * fQ t + c * ∑ j ∈ Finset.range n, fJ j t)
    (hle2 : ∀ t ∈ Set.Icc (T / 4) (2 * T),
      fQ t ≤ (1 + δ) * fV t + c * ∑ j ∈ Finset.range n, fJ j t) :
    (∫ t, W.w t * fV t) ≤ (1 + δ) * (∫ t, W.w t * fQ t) +
        c * ∑ j ∈ Finset.range n, ∫ t, W.w t * fJ j t ∧
      (∫ t, W.w t * fQ t) ≤ (1 + δ) * (∫ t, W.w t * fV t) +
        c * ∑ j ∈ Finset.range n, ∫ t, W.w t * fJ j t := by
  have iV := intg_w W hV
  have iQ := intg_w W hQ
  have iJ := fun j => intg_w W (hJ j)
  have iS : Integrable (fun t => ∑ j ∈ Finset.range n, W.w t * fJ j t) :=
    integrable_finsetSum _ fun j _ => iJ j
  have hsum : ∫ t, ∑ j ∈ Finset.range n, W.w t * fJ j t =
      ∑ j ∈ Finset.range n, ∫ t, W.w t * fJ j t := integral_finsetSum _ fun j _ => iJ j
  have hpt : ∀ (f g : ℝ → ℝ), (∀ t ∈ Set.Icc (T / 4) (2 * T),
      f t ≤ (1 + δ) * g t + c * ∑ j ∈ Finset.range n, fJ j t) → ∀ t,
      W.w t * f t ≤ (1 + δ) * (W.w t * g t) + c * ∑ j ∈ Finset.range n, W.w t * fJ j t := by
    intro f g h t
    by_cases hw : W.w t = 0
    · rw [hw]
      simp
    · have ht := W.supp t hw
      have := mul_le_mul_of_nonneg_left (h t ⟨ht.1, ht.2⟩) (W.nonneg t)
      rw [← Finset.mul_sum]
      nlinarith [this]
  have hint : ∀ (f g : ℝ → ℝ), Integrable (fun t => W.w t * f t) →
      Integrable (fun t => W.w t * g t) →
      (∀ t, W.w t * f t ≤ (1 + δ) * (W.w t * g t) + c * ∑ j ∈ Finset.range n, W.w t * fJ j t) →
      (∫ t, W.w t * f t) ≤ (1 + δ) * (∫ t, W.w t * g t) +
        c * ∑ j ∈ Finset.range n, ∫ t, W.w t * fJ j t := by
    intro f g hf hg h
    have hR : Integrable (fun t => (1 + δ) * (W.w t * g t) +
        c * ∑ j ∈ Finset.range n, W.w t * fJ j t) := (hg.const_mul _).add (iS.const_mul _)
    calc (∫ t, W.w t * f t) ≤ ∫ t, ((1 + δ) * (W.w t * g t) +
          c * ∑ j ∈ Finset.range n, W.w t * fJ j t) := integral_mono hf hR h
      _ = _ := by
        rw [integral_add (hg.const_mul _) (iS.const_mul _), integral_const_mul,
          integral_const_mul, hsum]
  exact ⟨hint fV fQ iV iQ (hpt fV fQ hle1), hint fQ fV iQ iV (hpt fQ fV hle2)⟩

set_option maxHeartbeats 800000 in
/-- **The mean of Conrey's `V` from Lemma 3**, every length, with the `Gammaℝ` ratio as the one
open input: `V = Q(−D/L)ζ + E`, `E` paid as `O(T/L)` at `δ = 1/L`. -/
theorem mollMeanV_long (Q P : ℝ[X]) {θ R : ℝ} (hθ0 : 0 < θ) (hR : 0 < R)
    (hL3 : StmtLemma3resO P θ R (2 * R + 1 + 1 / R)) (hG : StmtGrRatio Q.natDegree) :
    StmtMollMeanV Q P θ R := by
  intro Cs ε hε
  set d := Q.natDegree with hd
  set r : ℝ := R / 2 with hrdef
  obtain ⟨KD, hKD0, T2, hT2⟩ := dopQ_cY_bdd Q P hθ0 hR
  obtain ⟨KJ, hKJ0, T3, hT3⟩ := meanJ_bound P hθ0 hR hL3 Cs
  obtain ⟨KE, T4, hKE0, hT4⟩ := E_bound Q hG
  obtain ⟨T1, hT1⟩ := mollMeanQ_long Q P hR hL3 Cs (ε / 4) (by positivity)
  set Bj : ℝ := ∑ j ∈ Finset.range (d + 1), KJ * ((j.factorial : ℝ) / r ^ j) ^ 2 with hBj
  have hBj0 : 0 ≤ Bj := Finset.sum_nonneg fun _ _ => by positivity
  set Kc : ℝ := 2 * KE ^ 2 * (d + 1) with hKc
  have hKc0 : 0 ≤ Kc := by positivity
  set U : ℝ := 2 * KD + ε / 4 with hU
  have hU0 : 0 ≤ U := by positivity
  set V0 : ℝ := 2 * U + Kc * Bj with hV0
  have hV00 : 0 ≤ V0 := by positivity
  set Lb : ℝ := 4 * (U + V0 + Kc * Bj) / ε + 4 * R + 1 with hLb
  refine ⟨max (max (max T1 T2) (max T3 T4)) (max 4 (Real.exp Lb)), fun T hT W hW => ?_⟩
  simp only [max_le_iff] at hT
  obtain ⟨⟨⟨hTa, hTb⟩, hTc, hTd⟩, hT4', hTe⟩ := hT
  have hT0 : 0 < T := by linarith
  have hLge : Lb ≤ Real.log T := (Real.le_log_iff_exp_le hT0).mpr hTe
  have hL1 : 1 ≤ Real.log T := by
    have : 0 ≤ 4 * (U + V0 + Kc * Bj) / ε := by positivity
    linarith
  have hL0 : 0 < Real.log T := by linarith
  have hL4R : 4 * R ≤ Real.log T := by
    have : 0 ≤ 4 * (U + V0 + Kc * Bj) / ε := by positivity
    linarith
  have hLε : 4 * (U + V0 + Kc * Bj) / ε ≤ Real.log T := by linarith
  -- the line
  set σ₀ := sig0 T R with hσ₀
  have hσlo : 1/4 ≤ σ₀ := by
    rw [hσ₀]; unfold sig0
    have : R / Real.log T ≤ 1 / 4 := by rw [div_le_iff₀ hL0]; linarith
    linarith
  have hσhi : σ₀ ≤ 1 := by
    rw [hσ₀]; unfold sig0
    have : 0 < R / Real.log T := by positivity
    linarith
  have hσ1 : σ₀ < 1 := by
    rw [hσ₀]; unfold sig0
    have : 0 < R / Real.log T := by positivity
    linarith
  have hσ0 : 0 < σ₀ := by linarith
  set δ : ℝ := 1 / Real.log T with hδdef
  have hδ : 0 < δ := by positivity
  have hδ1 : δ ≤ 1 := by rw [hδdef, div_le_one hL0]; exact hL1
  set c : ℝ := (1 + 1 / δ) * (KE / Real.log T) ^ 2 * (d + 1) with hcdef
  have hc0 : 0 ≤ c := by positivity
  have hcK : c ≤ Kc * δ := by
    have e : c = (1 + Real.log T) * KE ^ 2 * (d + 1) / Real.log T ^ 2 := by
      rw [hcdef, hδdef]; field_simp
    have e2 : Kc * δ = 2 * Real.log T * KE ^ 2 * (d + 1) / Real.log T ^ 2 := by
      rw [hKc, hδdef]; field_simp
    rw [e, e2]
    apply div_le_div_of_nonneg_right _ (by positivity)
    have : 0 ≤ KE ^ 2 * ((d : ℝ) + 1) := by positivity
    nlinarith
  -- the functions
  set m : ℝ → ℝ := msq (Mof T θ) (aY P T θ R) σ₀ with hm
  set fV : ℝ → ℝ := fun t => ‖ConreyCount.V Q (Real.log T) ((σ₀ : ℂ) + t * I)‖ ^ 2 * m t with hfV
  set fQ : ℝ → ℝ := fun t => ‖VQ Q (Real.log T) ((σ₀ : ℂ) + t * I)‖ ^ 2 * m t with hfQ
  set fJ : ℕ → ℝ → ℝ := fun j t => ‖VQ (X ^ j) (Real.log T) ((σ₀ : ℂ) + t * I)‖ ^ 2 * m t with hfJ
  have hmc : Continuous m := continuous_msq _ _ _
  have cV : Continuous fV := ((continuous_V_line Q (Real.log T) hσ0 hσ1).norm.pow 2).mul hmc
  have cQ : Continuous fQ := ((continuous_VQ_line Q (Real.log T) hσ1.ne).norm.pow 2).mul hmc
  have cJ : ∀ j, Continuous (fJ j) := fun j =>
    ((continuous_VQ_line (X ^ j) (Real.log T) hσ1.ne).norm.pow 2).mul hmc
  -- the pointwise `E` bound
  have hE2 : ∀ t ∈ Set.Icc (T / 4) (2 * T),
      ‖ConreyCount.V Q (Real.log T) ((σ₀ : ℂ) + t * I) - VQ Q (Real.log T) ((σ₀ : ℂ) + t * I)‖ ^ 2 ≤
        (KE / Real.log T) ^ 2 * (d + 1) * ∑ j ∈ Finset.range (d + 1),
          ‖VQ (X ^ j) (Real.log T) ((σ₀ : ℂ) + t * I)‖ ^ 2 := by
    intro t ht
    have h1 := hT4 T hTd σ₀ ⟨hσlo, hσhi⟩ t ht
    simp_rw [← norm_VQ_X_pow _ hL0] at h1
    have h2 := pow_le_pow_left₀ (norm_nonneg _) h1 2
    have h3 := sq_sum_le_card_mul_sum_sq (s := Finset.range (d + 1))
      (f := fun j => ‖VQ (X ^ j) (Real.log T) ((σ₀ : ℂ) + t * I)‖)
    rw [Finset.card_range] at h3
    push_cast at h3
    calc _ ≤ (KE / Real.log T * ∑ j ∈ Finset.range (d + 1), ‖VQ (X ^ j) (Real.log T) ((σ₀ : ℂ) + t * I)‖) ^ 2 := h2
      _ = (KE / Real.log T) ^ 2 * (∑ j ∈ Finset.range (d + 1), ‖VQ (X ^ j) (Real.log T) ((σ₀ : ℂ) + t * I)‖) ^ 2 := by
          ring
      _ ≤ (KE / Real.log T) ^ 2 * (((d : ℝ) + 1) * ∑ j ∈ Finset.range (d + 1),
            ‖VQ (X ^ j) (Real.log T) ((σ₀ : ℂ) + t * I)‖ ^ 2) :=
          mul_le_mul_of_nonneg_left h3 (by positivity)
      _ = _ := by ring
  have hmul : ∀ t, (c * ∑ j ∈ Finset.range (d + 1), fJ j t) =
      (1 + 1 / δ) * ((KE / Real.log T) ^ 2 * (d + 1) * ∑ j ∈ Finset.range (d + 1),
        ‖VQ (X ^ j) (Real.log T) ((σ₀ : ℂ) + t * I)‖ ^ 2) * m t := by
    intro t
    simp only [hfJ, hcdef]
    rw [← Finset.sum_mul]
    ring
  have hle1 : ∀ t ∈ Set.Icc (T / 4) (2 * T),
      fV t ≤ (1 + δ) * fQ t + c * ∑ j ∈ Finset.range (d + 1), fJ j t := by
    intro t ht
    have hm0 : 0 ≤ m t := msq_nonneg _ _ _ _
    have h1 := sq_add_le (VQ Q (Real.log T) ((σ₀ : ℂ) + t * I))
      (ConreyCount.V Q (Real.log T) ((σ₀ : ℂ) + t * I) - VQ Q (Real.log T) ((σ₀ : ℂ) + t * I)) hδ
    rw [add_sub_cancel] at h1
    have h2 := mul_le_mul_of_nonneg_left (hE2 t ht) (by positivity : (0 : ℝ) ≤ 1 + 1 / δ)
    rw [hmul t]
    simp only [hfV, hfQ]
    have h1m := mul_le_mul_of_nonneg_right h1 hm0
    have h2m := mul_le_mul_of_nonneg_right h2 hm0
    rw [add_mul] at h1m
    linarith
  have hle2 : ∀ t ∈ Set.Icc (T / 4) (2 * T),
      fQ t ≤ (1 + δ) * fV t + c * ∑ j ∈ Finset.range (d + 1), fJ j t := by
    intro t ht
    have hm0 : 0 ≤ m t := msq_nonneg _ _ _ _
    have h1 := sq_add_le (ConreyCount.V Q (Real.log T) ((σ₀ : ℂ) + t * I))
      (VQ Q (Real.log T) ((σ₀ : ℂ) + t * I) - ConreyCount.V Q (Real.log T) ((σ₀ : ℂ) + t * I)) hδ
    rw [add_sub_cancel, norm_sub_rev] at h1
    have h2 := mul_le_mul_of_nonneg_left (hE2 t ht) (by positivity : (0 : ℝ) ≤ 1 + 1 / δ)
    rw [hmul t]
    simp only [hfV, hfQ]
    have h1m := mul_le_mul_of_nonneg_right h1 hm0
    have h2m := mul_le_mul_of_nonneg_right h2 hm0
    rw [add_mul] at h1m
    linarith
  obtain ⟨hup, hdown⟩ := compare_means W.toWeight cV cQ cJ hle1 hle2
  -- the pieces
  set Vint : ℝ := ∫ t, W.w t * fV t with hVint
  set A : ℝ := ∫ t, W.w t * fQ t with hA
  set Ej : ℝ := ∑ j ∈ Finset.range (d + 1), ∫ t, W.w t * fJ j t with hEj
  set e := errO W.toWeight with he
  have herr := T_le_errO W.toWeight hT0.le
  have he0 : 0 ≤ e := le_trans hT0.le herr
  set D := DopQ Q (Real.log T) (cY P (Mof T θ) T) ((-(R / Real.log T) : ℝ) : ℂ) ((-(R / Real.log T) : ℝ) : ℂ) with hDdef
  set ŵ := what0 W.toWeight with hŵ
  have hAre : A = (mollMeanQ W.toWeight (Mof T θ) (aY P T θ R) σ₀ Q (Real.log T)).re := by
    rw [mollMeanQ_re]
  have hVdef : mollMeanV W.toWeight (Mof T θ) (aY P T θ R) σ₀ Q (Real.log T) = Vint := rfl
  -- `|A − Re D·ŵ| ≤ (ε/4) e`
  have hA1 : |A - D.re * ŵ| ≤ ε / 4 * e := by
    have h := hT1 T hTa W hW
    have h2 := Complex.abs_re_le_norm
      (mollMeanQ W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) Q (Real.log T) - D * (ŵ : ℂ))
    rw [Complex.sub_re, Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im, mul_zero,
      sub_zero] at h2
    rw [hAre]
    exact h2.trans h
  -- `|Re D·ŵ| ≤ 2 KD e`
  have hDw : |D.re * ŵ| ≤ 2 * KD * e := by
    have h1 : |D.re| ≤ KD := (Complex.abs_re_le_norm D).trans (hT2 T hTb)
    have h2 : |ŵ| ≤ 2 * T := by
      have := what0_le W.toWeight hT0
      rwa [Complex.norm_real, Real.norm_eq_abs] at this
    rw [abs_mul]
    have h3 : KD * T ≤ KD * e := mul_le_mul_of_nonneg_left herr hKD0
    calc |D.re| * |ŵ| ≤ KD * (2 * T) := mul_le_mul h1 h2 (abs_nonneg _) hKD0
      _ ≤ 2 * KD * e := by linarith
  -- `Ej ≤ Bj e`
  have hEj : Ej ≤ Bj * e := by
    rw [hEj, hBj, Finset.sum_mul]
    refine Finset.sum_le_sum fun j _ => ?_
    have h := hT3 T hTc W hW j
    have hre : (∫ t, W.w t * fJ j t) =
        (mollMeanQ W.toWeight (Mof T θ) (aY P T θ R) σ₀ (X ^ j) (Real.log T)).re := by
      rw [mollMeanQ_re]
    rw [hre]
    exact (Complex.re_le_norm _).trans h
  have hEj0 : 0 ≤ Ej := Finset.sum_nonneg fun j _ =>
    integral_nonneg fun t => mul_nonneg (W.nonneg t) (mul_nonneg (by positivity)
      (msq_nonneg _ _ _ _))
  have hcE : c * Ej ≤ Kc * Bj * e * δ := by
    calc c * Ej ≤ (Kc * δ) * (Bj * e) := mul_le_mul hcK hEj hEj0 (by positivity)
      _ = Kc * Bj * e * δ := by ring
  have hUe : U * e = 2 * KD * e + ε / 4 * e := by rw [hU]; ring
  have hV0e : V0 * e = 2 * (U * e) + Kc * Bj * e := by rw [hV0]; ring
  have hAU : A ≤ U * e := by
    have := (le_abs_self _).trans hA1
    have := (le_abs_self _).trans hDw
    linarith
  have hA0 : 0 ≤ A := integral_nonneg fun t => mul_nonneg (W.nonneg t)
    (mul_nonneg (by positivity) (msq_nonneg _ _ _ _))
  have hδsmall : δ * (U + V0 + Kc * Bj) ≤ ε / 4 := by
    rw [hδdef, one_div_mul_eq_div, div_le_iff₀ hL0]
    rw [div_le_iff₀ hε] at hLε
    linarith
  have hVup : Vint ≤ V0 * e := by
    have h1 : δ * A ≤ U * e := by
      calc δ * A ≤ 1 * A := mul_le_mul_of_nonneg_right hδ1 hA0
        _ ≤ U * e := by linarith
    have h2 : Kc * Bj * e * δ ≤ Kc * Bj * e := by
      have := mul_le_mul_of_nonneg_left hδ1 (by positivity : 0 ≤ Kc * Bj * e)
      linarith
    linarith
  have hV0' : 0 ≤ Vint := integral_nonneg fun t => mul_nonneg (W.nonneg t)
    (mul_nonneg (by positivity) (msq_nonneg _ _ _ _))
  have hk1 : δ * A ≤ δ * (U * e) := mul_le_mul_of_nonneg_left hAU hδ.le
  have hk2 : δ * Vint ≤ δ * (V0 * e) := mul_le_mul_of_nonneg_left hVup hδ.le
  have hk3 : δ * (U + V0 + Kc * Bj) * e ≤ ε / 4 * e := mul_le_mul_of_nonneg_right hδsmall he0
  rw [hVdef, abs_le]
  have hA1' := abs_le.mp hA1
  have hk4 : 0 ≤ δ * V0 * e := mul_nonneg (mul_nonneg hδ.le hV00) he0
  have hk5 : 0 ≤ δ * U * e := mul_nonneg (mul_nonneg hδ.le hU0) he0
  have hk6 : δ * (U + V0 + Kc * Bj) * e = δ * U * e + δ * V0 * e + Kc * Bj * e * δ := by ring
  have hk7 : δ * (U * e) = δ * U * e := by ring
  have hk8 : δ * (V0 * e) = δ * V0 * e := by ring
  constructor
  · linarith
  · linarith

/-- info: 'MeanQ.sq_add_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sq_add_le

/-- info: 'MeanQ.compare_means' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms compare_means

/-- info: 'MeanQ.mollMeanV_long' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mollMeanV_long

end MeanQ

end
