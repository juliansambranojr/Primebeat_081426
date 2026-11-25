/-
LevinsonSize — block S11 of `lean_stage3/design/stencil.md`, step 1d (i), (iii). 2026-11-24.

Two of the three error terms of `LevinsonTurn.G_turn_eq` and `LevinsonTurn.lineF_turn_eq`.

(i) The right edge. On `Re s = 3` write `G = ζ + c ζ'` as the Dirichlet series
`Σ (1 − c log n) n^{-s}` (Mathlib's `LSeries_one_eq_riemannZeta` and `LSeries_deriv`). For
`n ≥ 2` and `0 ≤ c ≤ 1`, `|1 − c log n| ≤ 1 + log n ≤ n`, so the term is at most
`n · n^{-3} = n^{-2}`, and `‖G(s) − 1‖ ≤ Σ_{n≥2} n^{-2} = π²/6 − 1 < 1`. Hence
`Re G ≥ 2 − π²/6 > 0` on the whole edge. There `arg ∘ G` is a continuous argument with
`|arg| < π/2`, and `LevinsonTurn.lift_turn_eq_integral` turns
`Re ∫_a^b logDeriv G (3 + t i) dt` into `arg G(3 + b i) − arg G(3 + a i)`, of size below `π`.

(iii) The `Gammaℝ` part. The tree's phase is `Stage3.phaseTheta T =
(1/2) ∫_0^T phasePoint − (T/2) log π` with `phasePoint t = Re ψ(1/4 + t i/2)`
(`Stage3/Stirling.lean`). On the line, `Re logDeriv Gammaℝ (1/2 + y i) = −(log π)/2 +
phasePoint y / 2` (`Stage3.logDeriv_gammaR`), so the `Gammaℝ` part is exactly
`phaseTheta b − phaseTheta a`. With `Stage3.argS T := N T − (phaseTheta T / π + 1)`
(`Stage3/ArgIdentity.lean`) and `ArgCount.sCrude_holds`, `ArgCount.argS_le_gt_two`, it is
`π (N b − N a)` plus an error of at most `π (30 log b + 1200)`.

  norm_G_sub_one_le     0 ≤ c ≤ 1, s.re = 3
                          ⊢ ‖ζ s + c ζ' s − 1‖ ≤ π²/6 − 1
  re_G_pos              0 ≤ c ≤ 1  ⊢ 0 < Re (ζ + c ζ')(3 + t i)
  right_edge_le         0 ≤ c ≤ 1, a ≤ b
                          ⊢ |Re ∫_a^b logDeriv (ζ + c ζ') (3 + t i) dt| ≤ π
  gamma_part_eq         ⊢ Re ∫_a^b logDeriv Gammaℝ (1/2 + t i) dt = phaseTheta b − phaseTheta a
  gamma_part_eq_count   ⊢ Re ∫_a^b logDeriv Gammaℝ (1/2 + t i) dt
                            = π (N b − N a) − π (argS b − argS a)
  gamma_part_count_le   2 ≤ a ≤ b
                          ⊢ |Re ∫_a^b logDeriv Gammaℝ (1/2 + t i) dt − π (N b − N a)|
                            ≤ π (30 log b + 1200)
  gamma_part_count_le_gt_two
                        2 < a ≤ b
                          ⊢ |Re ∫_a^b logDeriv Gammaℝ (1/2 + t i) dt − π (N b − N a)|
                            ≤ π (30 log b + 150)

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.ArgCount
import Stage3.LevinsonTurn

namespace LevinsonSize

open Complex

/-! ## (i) The right edge -/

/-- `ζ'` as an L-series on `re s > 1`. -/
theorem deriv_zeta_eq_LSeries {s : ℂ} (hs : 1 < s.re) :
    deriv riemannZeta s = -LSeries (LSeries.logMul 1) s := by
  have h1 : deriv (LSeries 1) s = deriv riemannZeta s := by
    refine Filter.EventuallyEq.deriv_eq <| Filter.eventuallyEq_iff_exists_mem.mpr ?_
    exact ⟨{z | 1 < z.re}, (isOpen_lt continuous_const continuous_re).mem_nhds hs,
      fun _ hz => LSeries_one_eq_riemannZeta hz⟩
  rw [← h1]
  exact LSeries_deriv (by rw [LSeries.abscissaOfAbsConv_one]; exact_mod_cast hs)

/-- **The Dirichlet tail of `ζ + c ζ'` on `Re s = 3`.** `‖G(s) − 1‖ ≤ π²/6 − 1`. -/
theorem norm_G_sub_one_le {c : ℝ} (hc0 : 0 ≤ c) (hc1 : c ≤ 1) {s : ℂ} (hs : s.re = 3) :
    ‖riemannZeta s + c * deriv riemannZeta s - 1‖ ≤ Real.pi ^ 2 / 6 - 1 := by
  have hs1 : 1 < s.re := by rw [hs]; norm_num
  have habs : LSeries.abscissaOfAbsConv 1 < (s.re : EReal) := by
    rw [LSeries.abscissaOfAbsConv_one]; exact_mod_cast hs1
  have hA : HasSum (LSeries.term 1 s) (riemannZeta s) := by
    rw [← LSeries_one_eq_riemannZeta hs1]
    exact (LSeriesSummable_one_iff.mpr hs1).LSeriesHasSum
  have hB : HasSum (LSeries.term (LSeries.logMul 1) s) (LSeries (LSeries.logMul 1) s) :=
    (LSeriesSummable_logMul_of_lt_re habs).LSeriesHasSum
  have hH : HasSum (fun n : ℕ => LSeries.term 1 s n
      - (c : ℂ) * LSeries.term (LSeries.logMul 1) s n - (if n = 1 then (1 : ℂ) else 0))
      (riemannZeta s + c * deriv riemannZeta s - 1) := by
    rw [deriv_zeta_eq_LSeries hs1]
    have h := (hA.sub (hB.mul_left (c : ℂ))).sub (hasSum_ite_eq 1 (1 : ℂ))
    have hv : riemannZeta s + ↑c * -LSeries (LSeries.logMul 1) s - 1
        = riemannZeta s - ↑c * LSeries (LSeries.logMul 1) s - 1 := by ring
    rw [hv]
    exact h
  have hR : HasSum (fun n : ℕ => 1 / (n : ℝ) ^ 2 - (if n = 1 then (1 : ℝ) else 0))
      (Real.pi ^ 2 / 6 - 1) := hasSum_zeta_two.sub (hasSum_ite_eq 1 (1 : ℝ))
  refine hH.norm_le_of_bounded hR (fun n => ?_)
  rcases Nat.lt_or_ge n 2 with hn | hn
  · interval_cases n <;> simp [LSeries.term_def, LSeries.logMul]
  · have hn0 : n ≠ 0 := by omega
    have hn1 : n ≠ 1 := by omega
    have hnpos : (0 : ℝ) < n := by exact_mod_cast (show 0 < n by omega)
    have hlogc : Complex.log (n : ℂ) = ((Real.log n : ℝ) : ℂ) := by
      exact Complex.natCast_log.symm
    have hval : LSeries.term 1 s n - (c : ℂ) * LSeries.term (LSeries.logMul 1) s n
        - (if n = 1 then (1 : ℂ) else 0)
        = ((1 - c * Real.log n : ℝ) : ℂ) / (n : ℂ) ^ s := by
      simp only [LSeries.term_def, LSeries.logMul, if_neg hn0, if_neg hn1, Pi.one_apply,
        hlogc]
      push_cast
      ring
    rw [hval, if_neg hn1, sub_zero, norm_div, Complex.norm_real, Real.norm_eq_abs,
      Complex.norm_natCast_cpow_of_pos (by omega), hs]
    have hlog0 : 0 ≤ Real.log n := Real.log_nonneg (by exact_mod_cast (show 1 ≤ n by omega))
    have hlog1 : Real.log n ≤ n - 1 := Real.log_le_sub_one_of_pos hnpos
    have hnum : |1 - c * Real.log n| ≤ n := by
      rw [abs_le]
      constructor <;> nlinarith
    have h3 : (n : ℝ) ^ (3 : ℝ) = (n : ℝ) ^ (3 : ℕ) := by
      rw [← Real.rpow_natCast]; norm_num
    rw [h3, div_le_div_iff₀ (by positivity) (by positivity)]
    calc |1 - c * Real.log n| * (n : ℝ) ^ 2 ≤ n * (n : ℝ) ^ 2 := by gcongr
      _ = 1 * (n : ℝ) ^ 3 := by ring

/-- **`ζ + c ζ'` lies in the right half-plane on `Re s = 3`.** -/
theorem re_G_pos {c : ℝ} (hc0 : 0 ≤ c) (hc1 : c ≤ 1) (t : ℝ) :
    0 < (riemannZeta (3 + t * I) + c * deriv riemannZeta (3 + t * I)).re := by
  have hs : ((3 : ℂ) + t * I).re = 3 := by simp
  have h1 := norm_G_sub_one_le hc0 hc1 hs
  have h2 := Complex.abs_re_le_norm
    (riemannZeta (3 + t * I) + c * deriv riemannZeta (3 + t * I) - 1)
  rw [Complex.sub_re, Complex.one_re, abs_le] at h2
  nlinarith [Real.pi_lt_d2, Real.pi_gt_three, h2.1, h1]

/-- The line `Re s = 3` as a path, and its derivative `i`. -/
theorem hasDerivAt_three_comp {f : ℂ → ℂ} {t : ℝ}
    (hf : DifferentiableAt ℂ f (3 + t * I)) :
    HasDerivAt (fun y : ℝ => f (3 + y * I)) (deriv f (3 + t * I) * I) t := by
  have hlin : HasDerivAt (fun w : ℂ => (3 : ℂ) + w * I) I (t : ℂ) := by
    have := ((hasDerivAt_id (t : ℂ)).mul_const I).const_add (3 : ℂ)
    simpa using this
  have hcomp : HasDerivAt (fun w : ℂ => f ((3 : ℂ) + w * I))
      (deriv f (3 + t * I) * I) (t : ℂ) :=
    HasDerivAt.comp (t : ℂ) (h₂ := f) (h := fun w : ℂ => (3 : ℂ) + w * I)
      hf.hasDerivAt hlin
  exact hcomp.comp_ofReal

theorem continuous_three : Continuous (fun t : ℝ => (3 + t * I : ℂ)) := by fun_prop

/-- **(i) The right edge.** For `0 ≤ c ≤ 1`, the right-edge term of `LevinsonTurn.G_turn_eq`
at `X = 3` is at most `π` in size. -/
theorem right_edge_le {c a b : ℝ} (hc0 : 0 ≤ c) (hc1 : c ≤ 1) (hab : a ≤ b) :
    |(∫ t in a..b, logDeriv (fun s => riemannZeta s + c * deriv riemannZeta s)
      (3 + t * I)).re| ≤ Real.pi := by
  set G : ℂ → ℂ := fun s => riemannZeta s + c * deriv riemannZeta s with hG
  have hdz : DifferentiableOn ℂ riemannZeta {1}ᶜ := fun z hz =>
    (differentiableAt_riemannZeta hz).differentiableWithinAt
  have hGa : ∀ t : ℝ, AnalyticAt ℂ G (3 + t * I) := by
    intro t
    have h1 : (3 + t * I : ℂ) ∈ ({1}ᶜ : Set ℂ) := by
      intro h
      have := congrArg Complex.re (Set.mem_singleton_iff.mp h)
      simp at this
    have hζ : AnalyticAt ℂ riemannZeta (3 + t * I) :=
      hdz.analyticAt (isOpen_compl_singleton.mem_nhds h1)
    exact hζ.add (analyticAt_const.mul hζ.deriv)
  have hpos : ∀ t : ℝ, 0 < (G (3 + t * I)).re := fun t => re_G_pos hc0 hc1 t
  have hne : ∀ t ∈ Set.Icc a b, G (3 + t * I) ≠ 0 := by
    intro t _ h
    have := hpos t
    rw [h, Complex.zero_re] at this
    exact lt_irrefl _ this
  have hFcont : Continuous (fun t : ℝ => G (3 + t * I)) := by
    rw [continuous_iff_continuousAt]
    intro t
    exact ContinuousAt.comp (g := G) (f := fun t : ℝ => (3 + t * I : ℂ))
      (hGa t).continuousAt continuous_three.continuousAt
  have hFc : ContinuousOn (fun t : ℝ => G (3 + t * I)) (Set.Icc a b) :=
    hFcont.continuousOn
  have hF'c : ContinuousOn (fun t : ℝ => deriv G (3 + t * I) * I) (Set.Icc a b) := by
    intro t _
    exact ((ContinuousAt.comp (g := deriv G) (f := fun t : ℝ => (3 + t * I : ℂ))
      (hGa t).deriv.continuousAt continuous_three.continuousAt).mul
        continuousAt_const).continuousWithinAt
  have hslit : ∀ t : ℝ, G (3 + t * I) ∈ Complex.slitPlane := fun t =>
    Complex.mem_slitPlane_iff.mpr (Or.inl (hpos t))
  have hφc : ContinuousOn (fun t : ℝ => Complex.arg (G (3 + t * I))) (Set.Icc a b) := by
    intro t _
    exact (ContinuousAt.comp (g := Complex.arg) (f := fun t : ℝ => G (3 + t * I))
      (Complex.continuousAt_arg (hslit t)) hFcont.continuousAt).continuousWithinAt
  have hφ : ∀ t ∈ Set.Icc a b, G (3 + t * I) =
      ‖G (3 + t * I)‖ * Complex.exp ((Complex.arg (G (3 + t * I)) : ℂ) * Complex.I) :=
    fun t _ => (Complex.norm_mul_exp_arg_mul_I _).symm
  have h := LevinsonTurn.lift_turn_eq_integral (F := fun t : ℝ => G (3 + t * I))
    (F' := fun t : ℝ => deriv G (3 + t * I) * I)
    (φ := fun t : ℝ => Complex.arg (G (3 + t * I))) hab hFc
    (fun t _ => hasDerivAt_three_comp (hGa t).differentiableAt) hF'c hne hφc hφ
  have heq : (∫ t in a..b, deriv G (3 + t * I) * I / G (3 + t * I)) =
      ∫ t in a..b, logDeriv G (3 + t * I) * I := by
    refine intervalIntegral.integral_congr (fun t _ => ?_)
    simp only [logDeriv_apply]
    ring
  rw [heq, intervalIntegral.integral_mul_const, Complex.mul_I_im] at h
  rw [← h]
  have hb := Complex.abs_arg_lt_pi_div_two_iff.mpr (Or.inl (hpos b))
  have ha := Complex.abs_arg_lt_pi_div_two_iff.mpr (Or.inl (hpos a))
  rw [abs_lt] at ha hb
  rw [abs_le]
  constructor <;> linarith [ha.1, ha.2, hb.1, hb.2]

/-! ## (iii) The `Gammaℝ` part -/

/-- On the line, `Re logDeriv Gammaℝ` is the tree's phase integrand. -/
theorem re_logDeriv_gammaR_line (y : ℝ) :
    (logDeriv Gammaℝ (1/2 + y * I)).re = -(Real.log Real.pi) / 2 + Stage3.phasePoint y / 2 := by
  have hpos : 0 < ((1/2 : ℂ) + y * I).re := (LevinsonLine.line_facts y).2.2
  rw [Stage3.logDeriv_gammaR hpos]
  have hzq : ((1/2 : ℂ) + y * I) / 2 = Stage3.zq y := by
    rw [Stage3.zq]; ring
  rw [hzq, Stage3.phasePoint_eq]
  simp only [Complex.add_re, Complex.div_re, Complex.neg_re, Complex.ofReal_re,
    Complex.normSq_ofNat, Complex.re_ofNat, Complex.im_ofNat]
  ring

/-- **(iii) The `Gammaℝ` part is the tree's phase difference.** -/
theorem gamma_part_eq (a b : ℝ) :
    (∫ t in a..b, logDeriv Gammaℝ (1/2 + t * I)).re =
      Stage3.phaseTheta b - Stage3.phaseTheta a := by
  have hcont : Continuous fun t : ℝ => logDeriv Gammaℝ (1/2 + t * I) :=
    Stage3.logDeriv_gammaR_comp_continuous (g := fun t : ℝ => (1/2 + t * I : ℂ))
      LevinsonTurn.continuous_line (fun t => (LevinsonLine.line_facts t).2.2)
  rw [Stage3.intervalIntegral_re (hcont.intervalIntegrable _ _)]
  rw [intervalIntegral.integral_congr (fun y _ => re_logDeriv_gammaR_line y)]
  rw [intervalIntegral.integral_add intervalIntegrable_const
    ((Stage3.intervalIntegrable_phasePoint a b).div_const 2)]
  rw [intervalIntegral.integral_const, intervalIntegral.integral_div]
  have hsub : (∫ t in (0:ℝ)..b, Stage3.phasePoint t)
      - (∫ t in (0:ℝ)..a, Stage3.phasePoint t) = ∫ t in a..b, Stage3.phasePoint t :=
    intervalIntegral.integral_interval_sub_left
      (Stage3.intervalIntegrable_phasePoint 0 b) (Stage3.intervalIntegrable_phasePoint 0 a)
  rw [← hsub]
  simp only [Stage3.phaseTheta, smul_eq_mul]
  ring

/-- **(iii), with the tree's identity.** The `Gammaℝ` part is `π (N b − N a)` minus
`π (argS b − argS a)`. -/
theorem gamma_part_eq_count (a b : ℝ) :
    (∫ t in a..b, logDeriv Gammaℝ (1/2 + t * I)).re =
      Real.pi * (riemannZeta.N b - riemannZeta.N a)
        - Real.pi * (Stage3.argS b - Stage3.argS a) := by
  rw [gamma_part_eq]
  simp only [Stage3.argS]
  have hπ : Real.pi ≠ 0 := Real.pi_ne_zero
  field_simp
  try ring

/-- **(iii), with `ArgCount`'s bound.** For `2 ≤ a ≤ b`, the `Gammaℝ` part is `π (N b − N a)`
up to `π (30 log b + 1200)`. -/
theorem gamma_part_count_le {a b : ℝ} (ha : 2 ≤ a) (hab : a ≤ b) :
    |(∫ t in a..b, logDeriv Gammaℝ (1/2 + t * I)).re
      - Real.pi * (riemannZeta.N b - riemannZeta.N a)|
      ≤ Real.pi * (30 * Real.log b + 1200) := by
  rw [gamma_part_eq_count]
  have hSa := abs_le.1 (ArgCount.sCrude_holds a ha)
  have hSb := abs_le.1 (ArgCount.sCrude_holds b (le_trans ha hab))
  have hlog : Real.log a ≤ Real.log b := Real.log_le_log (by linarith) hab
  have hπ : 0 < Real.pi := Real.pi_pos
  have hE : |Stage3.argS b - Stage3.argS a| ≤ 30 * Real.log b + 1200 := by
    rw [abs_le]; constructor <;> linarith [hSa.1, hSa.2, hSb.1, hSb.2]
  have hkey : Real.pi * (riemannZeta.N b - riemannZeta.N a)
      - Real.pi * (Stage3.argS b - Stage3.argS a)
      - Real.pi * (riemannZeta.N b - riemannZeta.N a)
      = -(Real.pi * (Stage3.argS b - Stage3.argS a)) := by ring
  rw [hkey, abs_neg, abs_mul, abs_of_pos hπ]
  exact mul_le_mul_of_nonneg_left hE hπ.le

/-- **(iii), above `2`.** For `2 < a ≤ b`, with `ArgCount.argS_le_gt_two`, the constant is
`π (30 log b + 150)`. -/
theorem gamma_part_count_le_gt_two {a b : ℝ} (ha : 2 < a) (hab : a ≤ b) :
    |(∫ t in a..b, logDeriv Gammaℝ (1/2 + t * I)).re
      - Real.pi * (riemannZeta.N b - riemannZeta.N a)|
      ≤ Real.pi * (30 * Real.log b + 150) := by
  rw [gamma_part_eq_count]
  have hSa := abs_le.1 (ArgCount.argS_le_gt_two ha)
  have hSb := abs_le.1 (ArgCount.argS_le_gt_two (lt_of_lt_of_le ha hab))
  have hlog : Real.log a ≤ Real.log b := Real.log_le_log (by linarith) hab
  have hπ : 0 < Real.pi := Real.pi_pos
  have hE : |Stage3.argS b - Stage3.argS a| ≤ 30 * Real.log b + 150 := by
    rw [abs_le]; constructor <;> linarith [hSa.1, hSa.2, hSb.1, hSb.2]
  have hkey : Real.pi * (riemannZeta.N b - riemannZeta.N a)
      - Real.pi * (Stage3.argS b - Stage3.argS a)
      - Real.pi * (riemannZeta.N b - riemannZeta.N a)
      = -(Real.pi * (Stage3.argS b - Stage3.argS a)) := by ring
  rw [hkey, abs_neg, abs_mul, abs_of_pos hπ]
  exact mul_le_mul_of_nonneg_left hE hπ.le

/-- info: 'LevinsonSize.norm_G_sub_one_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_G_sub_one_le

/-- info: 'LevinsonSize.re_G_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms re_G_pos

/-- info: 'LevinsonSize.right_edge_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms right_edge_le

/-- info: 'LevinsonSize.gamma_part_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gamma_part_eq

/-- info: 'LevinsonSize.gamma_part_eq_count' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gamma_part_eq_count

/-- info: 'LevinsonSize.gamma_part_count_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gamma_part_count_le

/-- info: 'LevinsonSize.gamma_part_count_le_gt_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gamma_part_count_le_gt_two

end LevinsonSize
