/-
EdgeNum — block E8a of `lean_stage3/design/joints.md`. 2026-11-22.

`EdgeBound`'s three edge theorems with their constants as definitions.
Each proof is the original with its existence step replaced: the band bound
is `BoxBounds.sq_zeta_band_explicit` in place of `sq_zeta_band_bound`, and
each `refine ⟨<expression>, _, ?_⟩` is the definition unfolding to that
expression (`LOOP.md` § 3). `EdgeBound.lean` is untouched.

  C1n   G/2·(log D0/log 2 + 4), D0 = 135·81/(4·‖ζ 3/ζ(3/2)‖) + 2
  C2n   M0/log 2 + 8·(15 + 88/log 2) + 1, M0 the count below height six
  Cen   C1n + C2n + 1/log 2

  gz_partial_fraction_num   the partial fraction with C1n
  ball_order_sum_le_num     the ball count with C2n
  edge_bound_core_num       ‖ζ′/ζ(u)‖ ≤ Cen·log t/δ

What the next slice needs: `Glue`'s theorems on `Cen` (block E8b), and a
numeral above each constant (`BoxBounds.zeta_ratio_ge`, `low_rect_count`).

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LowEdge

namespace EdgeBound

open Complex Topology Set

/-- The partial fraction's constant. -/
noncomputable def C1n : ℝ :=
  (16 * (23/25:ℝ) ^ 2 / ((23/25:ℝ) - 22/25) ^ 3
      + 1 / (((49/50:ℝ) ^ 2 / (19/20) - 19/20) * Real.log ((49/50:ℝ) / (19/20)))) / 2
    * (Real.log (135 * 81 / (4 * ‖riemannZeta 3 / riemannZeta (3/2)‖) + 2) / Real.log 2 + 4)

/-- The partial fraction's constant `C1n` is positive. -/
theorem C1n_pos : 0 < C1n := by
  have h1 : (0:ℝ) < Real.log ((49/50:ℝ) / (19/20)) := Real.log_pos (by norm_num)
  have h2 : (0:ℝ) < (49/50:ℝ) ^ 2 / (19/20) - 19/20 := by norm_num
  have hc := zeta_ratio_pos
  have h3 : (0:ℝ) < Real.log (135 * 81 / (4 * ‖riemannZeta 3 / riemannZeta (3/2)‖) + 2) := by
    apply Real.log_pos
    have : (0:ℝ) < 135 * 81 / (4 * ‖riemannZeta 3 / riemannZeta (3/2)‖) := by positivity
    linarith
  have hl : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  unfold C1n
  positivity

set_option maxHeartbeats 1600000 in
/-- **The rescaled Landau partial fraction.** At any height `T′ ≥ 2`
and any `u` on the segment `re ∈ [−1/4, 2]` at that height that is
not a `gz`-zero, the log-derivative of `gz` minus the simple-pole sum
over `gz`-zeros within `46/25` of the center is `≤ C·log T′`.
Transported from PNT+'s normalized `FinalBound` with radii
`22/25 < 23/25 < 19/20 < 49/50`. -/
theorem gz_partial_fraction_num :
    ∀ T' : ℝ, 2 ≤ T' → ∀ u : ℂ,
      u.im = T' → -1/4 ≤ u.re → u.re ≤ 2 → gz u ≠ 0 →
      ‖deriv gz u / gz u
          - ∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0:ℝ) ≤ 46/25)).toFinset,
              (analyticOrderNatAt gz w : ℂ) / (u - w)‖
        ≤ C1n * Real.log T' := by
  classical
  obtain ⟨Cb, hCbdef⟩ : ∃ Cb : ℝ, Cb = 135 := ⟨_, rfl⟩
  have hCb0 : 0 < Cb := by rw [hCbdef]; norm_num
  have hCb : ∀ s : ℂ, -1/2 ≤ s.re → s.re ≤ 4 →
      ‖(s - 1)^2 * riemannZeta s‖ ≤ Cb * (2 + |s.im|) ^ 4 := by
    intro s h1 h2
    rw [hCbdef]
    exact BoxBounds.sq_zeta_band_explicit h1 h2
  set cζ : ℝ := ‖riemannZeta 3 / riemannZeta (3/2)‖ with hcζd
  have hcζ0 : 0 < cζ := zeta_ratio_pos
  set G : ℝ := 16 * (23/25:ℝ) ^ 2 / ((23/25:ℝ) - 22/25) ^ 3
      + 1 / (((49/50:ℝ) ^ 2 / (19/20) - 19/20) * Real.log ((49/50:ℝ) / (19/20))) with hGd
  have hG0 : 0 < G := by
    rw [hGd]
    have h1 : (0:ℝ) < Real.log ((49/50:ℝ) / (19/20)) := by
      apply Real.log_pos
      norm_num
    have h2 : (0:ℝ) < (49/50:ℝ) ^ 2 / (19/20) - 19/20 := by norm_num
    positivity
  clear_value G
  set D0 : ℝ := Cb * 81 / (4*cζ) + 2 with hD0d
  have hD02 : (2:ℝ) ≤ D0 := by
    rw [hD0d]
    have h3 : 0 < Cb * 81 / (4*cζ) := by positivity
    linarith
  have hlog2 : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  have hlogD0 : (0:ℝ) < Real.log D0 := Real.log_pos (by linarith)
  set A : ℝ := Real.log D0 / Real.log 2 + 4 with hAd
  have hCdef : C1n = G / 2 * A := by
    unfold C1n
    rw [hGd, hAd, hD0d, hcζd, hCbdef]
  rw [hCdef]
  intro T' hT' u him hre1 hre2 hune
  have hlogT : Real.log 2 ≤ Real.log T' := Real.log_le_log (by norm_num) hT'
  have hlogT0 : 0 < Real.log T' := lt_of_lt_of_le hlog2 hlogT
  have hT4 : (1:ℝ) ≤ T' ^ 4 := by
    have h40 := pow_le_pow_left₀ (show (0:ℝ) ≤ 2 by norm_num) hT' 4
    norm_num at h40
    linarith only [h40]
  set B : ℝ := D0 * T' ^ 4 with hBd
  have hB1 : 1 < B := by
    rw [hBd]
    nlinarith [hD02, hT4]
  have h19 : B * (4*cζ) = 81*Cb*T'^4 + 8*cζ*T'^4 := by
    rw [hBd, hD0d]
    field_simp
    ring
  have hlogB : Real.log B ≤ A * Real.log T' := by
    have h4 : Real.log B = Real.log D0 + 4 * Real.log T' := by
      rw [hBd, Real.log_mul (by linarith) (by positivity), Real.log_pow]
      push_cast
      ring
    have h5 : Real.log D0 ≤ Real.log D0 / Real.log 2 * Real.log T' := by
      rw [div_mul_eq_mul_div, le_div_iff₀ hlog2]
      exact mul_le_mul_of_nonneg_left hlogT hlogD0.le
    rw [h4, hAd, add_mul]
    linarith
  clear_value B D0 A
  have hgc0 : gz (c0 T') ≠ 0 := gz_c0_ne hT'
  set f : ℂ → ℂ := fun w ↦ gz (2*w + c0 T') / gz (c0 T') with hfd
  have haffan : ∀ w : ℂ, AnalyticAt ℂ (fun w : ℂ ↦ gz (2*w + c0 T')) w := by
    intro w
    have h7 : (fun w : ℂ ↦ gz (2*w + c0 T')) = gz ∘ (fun w ↦ 2*w + c0 T') := rfl
    rw [h7]
    exact (gz_analytic _).comp ((analyticAt_const.mul analyticAt_id).add analyticAt_const)
  have hfan : ∀ w : ℂ, AnalyticAt ℂ f w := by
    intro w
    rw [hfd]
    exact (haffan w).div analyticAt_const hgc0
  have hfAnalytic : AnalyticOnNhd ℂ f (Metric.closedBall (0:ℂ) 1) := fun w _ ↦ hfan w
  have hf0 : f 0 = 1 := by
    rw [hfd]
    simp only [mul_zero, zero_add]
    exact div_self hgc0
  have hinj : Function.Injective (fun ρ : ℂ ↦ 2*ρ + c0 T') := by
    intro a b hab
    have h8 : (2:ℂ) * a = 2 * b := by
      have h9 : (2:ℂ)*a + c0 T' = 2*b + c0 T' := hab
      linear_combination h9
    exact mul_left_cancel₀ two_ne_zero h8
  have hball2 := gz_zeros_ball_finite T' (by norm_num : (0:ℝ) ≤ 2)
  have hfin : (SetOfZeros 1 f).Finite := by
    apply Set.Finite.subset (Set.Finite.preimage hinj.injOn hball2)
    rintro ρ ⟨hρn, hρz⟩
    show gz (2*ρ + c0 T') = 0 ∧ ‖(2*ρ + c0 T') - c0 T'‖ ≤ 2
    have hρz2 : gz (2*ρ + c0 T') = 0 := by
      rw [hfd] at hρz
      exact (div_eq_zero_iff.mp hρz).resolve_right hgc0
    refine ⟨hρz2, ?_⟩
    rw [show (2*ρ + c0 T') - c0 T' = 2*ρ by ring, norm_mul]
    simp only [Complex.norm_ofNat]
    linarith
  have hfz_bound : ∀ z : ℂ, ‖z‖ ≤ (49/50:ℝ) → ‖f z‖ ≤ B := by
    intro z hzn
    rw [hfd]
    show ‖gz (2*z + c0 T') / gz (c0 T')‖ ≤ B
    rw [norm_div, div_le_iff₀ (norm_pos_iff.mpr hgc0)]
    have h10 := Complex.abs_re_le_norm z
    have h12 := Complex.abs_im_le_norm z
    have h11 : (2*z + c0 T').re = 2*z.re + 3/2 := by
      simp [Complex.add_re, Complex.mul_re, c0_re]
    have h13 : (2*z + c0 T').im = 2*z.im + T' := by
      simp [Complex.add_im, Complex.mul_im, c0_im]
    have h10' : |z.re| ≤ 49/50 := le_trans h10 hzn
    have h12' : |z.im| ≤ 49/50 := le_trans h12 hzn
    rw [abs_le] at h10' h12'
    have h14 := hCb (2*z + c0 T')
      (by rw [h11]; nlinarith [h10'.1]) (by rw [h11]; nlinarith [h10'.2])
    have h15im : |(2*z + c0 T').im| ≤ 2 + T' := by
      rw [h13, abs_le]
      constructor <;> nlinarith [h12'.1, h12'.2]
    have h15 : (2 + |(2*z + c0 T').im|) ^ 4 ≤ (4 + T') ^ 4 := by
      apply pow_le_pow_left₀ (by positivity)
      linarith
    have h16 : (4+T') ^ 4 ≤ 81 * T'^4 := by
      calc (4+T') ^ 4 ≤ (3*T') ^ 4 := by
            apply pow_le_pow_left₀ (by linarith)
            linarith
        _ = 81 * T'^4 := by ring
    have h20 : ‖gz (2*z + c0 T')‖ ≤ B * (4*cζ) := by
      calc ‖gz (2*z + c0 T')‖ ≤ Cb * (2 + |(2*z + c0 T').im|) ^ 4 := h14
        _ ≤ Cb * (4+T') ^ 4 := mul_le_mul_of_nonneg_left h15 hCb0.le
        _ ≤ Cb * (81 * T'^4) := mul_le_mul_of_nonneg_left h16 hCb0.le
        _ ≤ B * (4*cζ) := by
            rw [h19]
            have h30 : Cb * (81 * T'^4) = 81*Cb*T'^4 := by ring
            have h31 : (0:ℝ) ≤ 8*cζ*T'^4 := by positivity
            linarith only [h30, h31]
    calc ‖gz (2*z + c0 T')‖ ≤ B * (4*cζ) := h20
      _ ≤ B * ‖gz (c0 T')‖ := by
          apply mul_le_mul_of_nonneg_left (gz_lower hT')
          linarith only [hB1]
  set z : ℂ := (u - c0 T') / 2 with hzd
  have h2z : 2*z + c0 T' = u := by rw [hzd]; ring
  have huc0 : u - c0 T' = ((u.re - 3/2 : ℝ) : ℂ) := by
    apply Complex.ext
    · simp [Complex.sub_re, c0_re]
    · simp [Complex.sub_im, c0_im, him]
  have hzn : ‖z‖ ≤ 22/25 := by
    rw [hzd, norm_div, huc0]
    simp only [Complex.norm_ofNat, Complex.norm_real, Real.norm_eq_abs]
    have h21 : |u.re - 3/2| ≤ 7/4 := by
      rw [abs_le]
      constructor <;> linarith
    calc |u.re - 3/2| / 2 ≤ (7/4)/2 := by linarith
      _ ≤ 22/25 := by norm_num
  have hfz_ne : f z ≠ 0 := by
    rw [hfd]
    show gz (2*z + c0 T') / gz (c0 T') ≠ 0
    rw [h2z]
    exact div_ne_zero hune hgc0
  have hzmem : z ∈ Metric.closedBall (0:ℂ) (22/25) \ SetOfZeros (19/20) f := by
    constructor
    · rw [Metric.mem_closedBall, dist_zero_right]
      exact hzn
    · rintro ⟨-, hfz0⟩
      exact hfz_ne hfz0
  have hFB := FinalBound (B := B) (r' := 22/25) (r := 23/25) (R' := 19/20) (R := 49/50)
    hB1 (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    hfAnalytic hf0 hfin hfz_bound hzmem
  have hgder : HasDerivAt gz (deriv gz u) u := (gz_analytic u).differentiableAt.hasDerivAt
  have haff : HasDerivAt (fun w : ℂ ↦ 2*w + c0 T') 2 z := by
    have h22 := ((hasDerivAt_id z).const_mul (2:ℂ)).add_const (c0 T')
    simpa using h22
  have hcomp : HasDerivAt (fun w : ℂ ↦ gz (2*w + c0 T')) (deriv gz u * 2) z := by
    have h23 : HasDerivAt gz (deriv gz u) (2*z + c0 T') := by
      rw [h2z]
      exact hgder
    exact h23.comp z haff
  have hfder : deriv f z = deriv gz u * 2 / gz (c0 T') := by
    rw [hfd]
    exact (hcomp.div_const _).deriv
  have hfval : f z = gz u / gz (c0 T') := by
    rw [hfd]
    show gz (2*z + c0 T') / gz (c0 T') = gz u / gz (c0 T')
    rw [h2z]
  set Fg := (gz_zeros_ball_finite T' (by norm_num : (0:ℝ) ≤ 46/25)).toFinset with hFgd
  set Ff := (finiteSetOfZeros_mono (by norm_num : (23/25:ℝ) < 1) hfin).toFinset with hFfd
  have hFeq : Fg = Ff.image (fun ρ ↦ 2*ρ + c0 T') := by
    ext w
    rw [hFgd, hFfd, Set.Finite.mem_toFinset, Finset.mem_image]
    constructor
    · rintro ⟨hw0, hwball⟩
      refine ⟨(w - c0 T')/2, ?_, by ring⟩
      rw [Set.Finite.mem_toFinset]
      constructor
      · rw [norm_div]
        simp only [Complex.norm_ofNat]
        linarith
      · rw [hfd]
        show gz (2*((w - c0 T')/2) + c0 T') / gz (c0 T') = 0
        rw [show 2*((w - c0 T')/2) + c0 T' = w by ring, hw0, zero_div]
    · rintro ⟨ρ, hρ, rfl⟩
      rw [Set.Finite.mem_toFinset] at hρ
      obtain ⟨hρn, hρz⟩ := hρ
      have hρz2 : gz (2*ρ + c0 T') = 0 := by
        rw [hfd] at hρz
        exact (div_eq_zero_iff.mp hρz).resolve_right hgc0
      refine ⟨hρz2, ?_⟩
      rw [show (2*ρ + c0 T') - c0 T' = 2*ρ by ring, norm_mul]
      simp only [Complex.norm_ofNat]
      linarith
  have hsum : ∑ w ∈ Fg, (analyticOrderNatAt gz w : ℂ) / (u - w)
      = (1/2 : ℂ) * ∑ ρ ∈ Ff, (analyticOrderNatAt f ρ : ℂ) / (z - ρ) := by
    rw [hFeq, Finset.sum_image (fun a _ b _ hab ↦ hinj hab), Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro ρ _
    have hord : analyticOrderNatAt f ρ = analyticOrderNatAt gz (2*ρ + c0 T') := by
      rw [hfd]
      rw [show (fun w ↦ gz (2*w + c0 T') / gz (c0 T'))
          = fun w ↦ (fun v ↦ gz (2*v + c0 T')) w / gz (c0 T') from rfl]
      rw [analyticOrderNatAt_fun_div_const hgc0 (haffan ρ)]
      exact Stage3.analyticOrderNatAt_fun_comp_affine gz (c0 T') ρ two_ne_zero
    rw [hord]
    have hzρ : u - (2*ρ + c0 T') = (z - ρ) * 2 := by
      rw [hzd]
      ring
    rw [hzρ, ← div_div]
    ring
  have hmain : deriv gz u / gz u - ∑ w ∈ Fg, (analyticOrderNatAt gz w : ℂ) / (u - w)
      = (1/2 : ℂ) * (deriv f z / f z
          - ∑ ρ ∈ Ff, (analyticOrderNatAt f ρ : ℂ) / (z - ρ)) := by
    rw [hsum, hfder, hfval, mul_sub]
    congr 1
    field_simp
  rw [hmain, norm_mul, show ‖(1/2 : ℂ)‖ = 1/2 by norm_num]
  rw [← hGd] at hFB
  calc (1/2 : ℝ) * ‖deriv f z / f z
        - ∑ ρ ∈ Ff, (analyticOrderNatAt f ρ : ℂ) / (z - ρ)‖
      ≤ (1/2) * (G * Real.log B) :=
        mul_le_mul_of_nonneg_left hFB (by norm_num)
    _ ≤ (1/2) * (G * (A * Real.log T')) := by
        apply mul_le_mul_of_nonneg_left ?_ (by norm_num)
        exact mul_le_mul_of_nonneg_left hlogB hG0.le
    _ = G / 2 * A * Real.log T' := by ring



/-- The ball count's constant. -/
noncomputable def C2n : ℝ :=
  (∑ ρ ∈ (ContourShift.zeta_zeros_rectangle_finite (0:ℂ)
      ((1:ℝ) + Complex.I * (6:ℝ))).toFinset, (analyticOrderNatAt riemannZeta ρ : ℝ))
    / Real.log 2 + 8 * (15 + 88 / Real.log 2) + 1

/-- The ball count's constant `C2n` is positive. -/
theorem C2n_pos : 0 < C2n := by
  have hM : (0:ℝ) ≤ ∑ ρ ∈ (ContourShift.zeta_zeros_rectangle_finite (0:ℂ)
      ((1:ℝ) + Complex.I * (6:ℝ))).toFinset, (analyticOrderNatAt riemannZeta ρ : ℝ) :=
    Finset.sum_nonneg (fun _ _ ↦ Nat.cast_nonneg _)
  have hl : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  unfold C2n
  positivity

/-- **The ball order-count**: the total multiplicity of `gz`-zeros in
the `46/25`-ball at height `T′` is `≤ C·log T′` — four Jensen windows
for `T′ ≥ 4` with the reflection charging left-zeros to partners, and
a fixed-rectangle constant for `T′ < 4`. -/
theorem ball_order_sum_le_num :
    ∀ T' : ℝ, 2 ≤ T' →
      (∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0:ℝ) ≤ 46/25)).toFinset,
        (analyticOrderNatAt gz w : ℝ)) ≤ C2n * Real.log T' := by
  classical
  have hlog2 : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  -- the fixed low-corner constant
  set lowFin := ContourShift.zeta_zeros_rectangle_finite (0:ℂ)
      ((1:ℝ) + Complex.I * (6:ℝ)) with hlowd
  set M0 : ℝ := ∑ ρ ∈ lowFin.toFinset, (analyticOrderNatAt riemannZeta ρ : ℝ) with hM0d
  have hM00 : 0 ≤ M0 := by
    rw [hM0d]
    apply Finset.sum_nonneg
    intro ρ _
    positivity
  set W0 : ℝ := 15 + 88 / Real.log 2 with hW0d
  have hW00 : 0 < W0 := by
    rw [hW0d]
    positivity
  have hCdef : C2n = M0 / Real.log 2 + 8 * W0 + 1 := by
    unfold C2n
    rw [hM0d, hW0d]
  rw [hCdef]
  intro T' hT'
  have hlogT : Real.log 2 ≤ Real.log T' := Real.log_le_log (by norm_num) hT'
  have hlogT0 : 0 < Real.log T' := lt_of_lt_of_le hlog2 hlogT
  set BF := (gz_zeros_ball_finite T' (by norm_num : (0:ℝ) ≤ 46/25)).toFinset with hBFd
  have hmemBF : ∀ w, w ∈ BF ↔ (gz w = 0 ∧ ‖w - c0 T'‖ ≤ 46/25) := by
    intro w
    rw [hBFd, Set.Finite.mem_toFinset]
    exact Iff.rfl
  -- convert to ζ-orders
  have hconv : ∀ w ∈ BF, (analyticOrderNatAt gz w : ℝ)
      = (analyticOrderNatAt riemannZeta w : ℝ) := by
    intro w hw
    obtain ⟨hz, hball⟩ := (hmemBF w).mp hw
    obtain ⟨hζ, ⟨hre0, hre1⟩, _⟩ := ball_zero_shape hT' hz hball
    have hw1 : w ≠ 1 := by
      intro h
      rw [h] at hre1
      simp at hre1
    rw [gz_order_eq hw1]
  rw [Finset.sum_congr rfl hconv]
  by_cases hT4 : T' < 4
  · -- low case: everything sits in the fixed rectangle
    have hsub : BF ⊆ lowFin.toFinset := by
      intro w hw
      obtain ⟨hz, hball⟩ := (hmemBF w).mp hw
      obtain ⟨hζ, ⟨hre0, hre1⟩, him⟩ := ball_zero_shape hT' hz hball
      rw [hlowd, Set.Finite.mem_toFinset]
      refine ⟨hζ, ?_⟩
      rw [abs_le] at him
      simp only [Rectangle]
      have hzre : (0:ℂ).re = 0 := Complex.zero_re
      have hzim : (0:ℂ).im = 0 := Complex.zero_im
      have hwre : ((1:ℝ) + Complex.I * (6:ℝ) : ℂ).re = 1 := by simp
      have hwim : ((1:ℝ) + Complex.I * (6:ℝ) : ℂ).im = 6 := by simp
      rw [Complex.mem_reProdIm, hzre, hzim, hwre, hwim,
        Set.uIcc_of_le (by norm_num : (0:ℝ) ≤ 1),
        Set.uIcc_of_le (by norm_num : (0:ℝ) ≤ 6),
        Set.mem_Icc, Set.mem_Icc]
      constructor
      · exact ⟨hre0.le, hre1.le⟩
      · constructor <;> linarith [him.1, him.2]
    calc ∑ w ∈ BF, (analyticOrderNatAt riemannZeta w : ℝ)
        ≤ M0 := by
          rw [hM0d]
          apply Finset.sum_le_sum_of_subset_of_nonneg hsub
          intro w _ _
          positivity
      _ ≤ M0 / Real.log 2 * Real.log T' := by
          rw [div_mul_eq_mul_div, le_div_iff₀ hlog2]
          exact mul_le_mul_of_nonneg_left hlogT hM00
      _ ≤ (M0 / Real.log 2 + 8 * W0 + 1) * Real.log T' := by
          apply mul_le_mul_of_nonneg_right ?_ hlogT0.le
          nlinarith [hW00]
  · -- high case: four windows and the reflection
    push_neg at hT4
    have hc1 : (2:ℝ) ≤ T' - 9/5 := by linarith
    have hc2 : (2:ℝ) ≤ T' - 9/10 := by linarith
    have hc3 : (2:ℝ) ≤ T' := hT'
    have hc4 : (2:ℝ) ≤ T' + 9/5 := by linarith
    set W : Finset ℂ :=
      ((Stage3.zetaWindow_finite hc1).toFinset ∪ (Stage3.zetaWindow_finite hc2).toFinset)
        ∪ ((Stage3.zetaWindow_finite hc3).toFinset ∪ (Stage3.zetaWindow_finite hc4).toFinset)
      with hWd
    -- the window chooser
    have hchoice : ∀ ρ : ℂ, riemannZeta ρ = 0 → 1/2 ≤ ρ.re → ρ.re < 1 →
        |ρ.im - T'| ≤ 46/25 → ρ ∈ W := by
      intro ρ hζ hre hre1 him
      rw [hWd]
      rw [abs_le] at him
      rcases le_total (ρ.im - T') (-9/10) with h1 | h1
      · apply Finset.mem_union_left
        apply Finset.mem_union_left
        rw [Set.Finite.mem_toFinset]
        apply ContourShift.mem_zetaWindow hζ hre hre1
        rw [abs_le]
        constructor <;> linarith [him.1]
      rcases le_total (ρ.im - T') 0 with h2 | h2
      · apply Finset.mem_union_left
        apply Finset.mem_union_right
        rw [Set.Finite.mem_toFinset]
        apply ContourShift.mem_zetaWindow hζ hre hre1
        rw [abs_le]
        constructor <;> linarith
      rcases le_total (ρ.im - T') (9/10) with h3 | h3
      · apply Finset.mem_union_right
        apply Finset.mem_union_left
        rw [Set.Finite.mem_toFinset]
        apply ContourShift.mem_zetaWindow hζ hre hre1
        rw [abs_le]
        constructor <;> linarith
      · apply Finset.mem_union_right
        apply Finset.mem_union_right
        rw [Set.Finite.mem_toFinset]
        apply ContourShift.mem_zetaWindow hζ hre hre1
        rw [abs_le]
        constructor <;> linarith [him.2]
    -- union sums split
    have hunion_le : ∀ (Aset Bset : Finset ℂ),
        ∑ w ∈ Aset ∪ Bset, (analyticOrderNatAt riemannZeta w : ℝ)
          ≤ (∑ w ∈ Aset, (analyticOrderNatAt riemannZeta w : ℝ))
            + ∑ w ∈ Bset, (analyticOrderNatAt riemannZeta w : ℝ) := by
      intro Aset Bset
      have h5 := Finset.sum_union_inter (s₁ := Aset) (s₂ := Bset)
        (f := fun w ↦ (analyticOrderNatAt riemannZeta w : ℝ))
      have h6 : (0:ℝ) ≤ ∑ w ∈ Aset ∩ Bset, (analyticOrderNatAt riemannZeta w : ℝ) := by
        apply Finset.sum_nonneg
        intro w _
        positivity
      linarith
    have hwinsum : ∀ (T0 : ℝ) (hT0 : 2 ≤ T0),
        (∑ ρ ∈ (Stage3.zetaWindow_finite hT0).toFinset,
          (analyticOrderNatAt riemannZeta ρ : ℝ)) ≤ 15 * Real.log T0 + 73 :=
      fun T0 hT0 ↦ Stage3.zeta_local_zero_count hT0
    have hlogmono : ∀ (T0 : ℝ), 2 ≤ T0 → T0 ≤ T' + 9/5 →
        15 * Real.log T0 + 73 ≤ W0 * Real.log T' := by
      intro T0 hT0 hT0le
      have h7 : Real.log T0 ≤ Real.log (2 * T') := by
        apply Real.log_le_log (by linarith)
        linarith
      rw [Real.log_mul (by norm_num) (by linarith)] at h7
      have h8 : Real.log 2 ≤ 1 := by
        have := Real.log_le_sub_one_of_pos (by norm_num : (0:ℝ) < 2)
        linarith
      have h9 : (73:ℝ) ≤ 73 / Real.log 2 * Real.log T' := by
        rw [div_mul_eq_mul_div, le_div_iff₀ hlog2]
        nlinarith
      have h10 : (15:ℝ) ≤ 15 / Real.log 2 * Real.log T' := by
        rw [div_mul_eq_mul_div, le_div_iff₀ hlog2]
        nlinarith
      have h13 : 15 * Real.log T0 ≤ 15 * (Real.log 2 + Real.log T') := by linarith
      have h11 : 73 / Real.log 2 * Real.log T' + 15 / Real.log 2 * Real.log T'
          = 88 / Real.log 2 * Real.log T' := by ring
      rw [hW0d, show (15 + 88 / Real.log 2) * Real.log T'
          = 15 * Real.log T' + 88 / Real.log 2 * Real.log T' by ring]
      linarith
    have hWsum : (∑ w ∈ W, (analyticOrderNatAt riemannZeta w : ℝ))
        ≤ 4 * (W0 * Real.log T') := by
      rw [hWd]
      calc ∑ w ∈ _ ∪ _, (analyticOrderNatAt riemannZeta w : ℝ)
          ≤ _ := hunion_le _ _
        _ ≤ (W0 * Real.log T') + (W0 * Real.log T')
            + ((W0 * Real.log T') + (W0 * Real.log T')) := by
            apply add_le_add
            · apply le_trans (hunion_le _ _)
              apply add_le_add
              · exact le_trans (hwinsum _ hc1) (hlogmono _ hc1 (by linarith))
              · exact le_trans (hwinsum _ hc2) (hlogmono _ hc2 (by linarith))
            · apply le_trans (hunion_le _ _)
              apply add_le_add
              · exact le_trans (hwinsum _ hc3) (hlogmono _ hc3 (by linarith))
              · exact le_trans (hwinsum _ hc4) (hlogmono _ hc4 (by linarith))
        _ = 4 * (W0 * Real.log T') := by ring
    -- split by half-plane
    rw [← Finset.sum_filter_add_sum_filter_not BF (fun w ↦ 1/2 ≤ w.re)]
    have hpart1 : (∑ w ∈ BF.filter (fun w ↦ 1/2 ≤ w.re),
        (analyticOrderNatAt riemannZeta w : ℝ))
          ≤ ∑ w ∈ W, (analyticOrderNatAt riemannZeta w : ℝ) := by
      apply Finset.sum_le_sum_of_subset_of_nonneg
      · intro w hw
        rw [Finset.mem_filter] at hw
        obtain ⟨hwBF, hwre⟩ := hw
        obtain ⟨hz, hball⟩ := (hmemBF w).mp hwBF
        obtain ⟨hζ, ⟨hre0, hre1⟩, him⟩ := ball_zero_shape hT' hz hball
        exact hchoice w hζ hwre hre1 him
      · intro w _ _
        positivity
    have hpart2 : (∑ w ∈ BF.filter (fun w ↦ ¬(1/2 ≤ w.re)),
        (analyticOrderNatAt riemannZeta w : ℝ))
          ≤ ∑ w ∈ W, (analyticOrderNatAt riemannZeta w : ℝ) := by
      have hrinj : Function.Injective (fun w : ℂ ↦ 1 - (starRingEnd ℂ) w) := by
        intro a b hab
        have h11 : (starRingEnd ℂ) a = (starRingEnd ℂ) b := by
          have h12 : (1:ℂ) - (starRingEnd ℂ) a = 1 - (starRingEnd ℂ) b := hab
          linear_combination -h12
        have h13 := congrArg (starRingEnd ℂ) h11
        rwa [Complex.conj_conj, Complex.conj_conj] at h13
      have hsum_refl : (∑ w ∈ BF.filter (fun w ↦ ¬(1/2 ≤ w.re)),
          (analyticOrderNatAt riemannZeta w : ℝ))
            = ∑ w ∈ (BF.filter (fun w ↦ ¬(1/2 ≤ w.re))).image
                (fun w ↦ 1 - (starRingEnd ℂ) w),
              (analyticOrderNatAt riemannZeta w : ℝ) := by
        rw [Finset.sum_image (fun a _ b _ hab ↦ hrinj hab)]
        apply Finset.sum_congr rfl
        intro w hw
        rw [Finset.mem_filter] at hw
        obtain ⟨hwBF, hwre⟩ := hw
        obtain ⟨hz, hball⟩ := (hmemBF w).mp hwBF
        obtain ⟨hζ, ⟨hre0, hre1⟩, _⟩ := ball_zero_shape hT' hz hball
        rw [ContourShift.zeta_order_reflect hre0 hre1]
      rw [hsum_refl]
      apply Finset.sum_le_sum_of_subset_of_nonneg
      · intro w' hw'
        rw [Finset.mem_image] at hw'
        obtain ⟨w, hw, rfl⟩ := hw'
        rw [Finset.mem_filter] at hw
        obtain ⟨hwBF, hwre⟩ := hw
        push_neg at hwre
        obtain ⟨hz, hball⟩ := (hmemBF w).mp hwBF
        obtain ⟨hζ, ⟨hre0, hre1⟩, him⟩ := ball_zero_shape hT' hz hball
        -- the reflected point is a zero at the same height, re ∈ (1/2, 1)
        have hcw : riemannZeta ((starRingEnd ℂ) w) = 0 := by
          rw [riemannZeta_conj, hζ, map_zero]
        have hwn : ∀ n : ℕ, (starRingEnd ℂ) w ≠ -(n:ℂ) := by
          intro n hcon
          have h14 := congrArg Complex.re hcon
          simp only [Complex.conj_re, Complex.neg_re, Complex.natCast_re] at h14
          have h15 : (0:ℝ) ≤ (n:ℝ) := Nat.cast_nonneg n
          linarith
        have hw1c : (starRingEnd ℂ) w ≠ 1 := by
          intro hcon
          have h16 := congrArg Complex.re hcon
          simp only [Complex.conj_re, Complex.one_re] at h16
          linarith
        have hfe := riemannZeta_one_sub hwn hw1c
        rw [hcw, mul_zero] at hfe
        have hre' : (1 - (starRingEnd ℂ) w).re = 1 - w.re := by
          simp [Complex.sub_re, Complex.conj_re]
        have him' : (1 - (starRingEnd ℂ) w).im = w.im := by
          simp [Complex.sub_im, Complex.conj_im]
        apply hchoice _ hfe
        · rw [hre']
          linarith
        · rw [hre']
          linarith
        · rw [him']
          exact him
      · intro w _ _
        positivity
    calc (∑ w ∈ BF.filter (fun w ↦ 1/2 ≤ w.re),
          (analyticOrderNatAt riemannZeta w : ℝ))
        + ∑ w ∈ BF.filter (fun w ↦ ¬(1/2 ≤ w.re)),
          (analyticOrderNatAt riemannZeta w : ℝ)
        ≤ (∑ w ∈ W, (analyticOrderNatAt riemannZeta w : ℝ))
          + ∑ w ∈ W, (analyticOrderNatAt riemannZeta w : ℝ) :=
          add_le_add hpart1 hpart2
      _ ≤ 4 * (W0 * Real.log T') + 4 * (W0 * Real.log T') := by
          linarith [hWsum]
      _ ≤ (M0 / Real.log 2 + 8 * W0 + 1) * Real.log T' := by
          have h17 : 0 ≤ M0 / Real.log 2 * Real.log T' := by positivity
          nlinarith [hlogT0]


/-- The edge constant. -/
noncomputable def Cen : ℝ := C1n + C2n + 1 / Real.log 2

/-- The edge constant `Cen` is positive. -/
theorem Cen_pos : 0 < Cen := by
  have h1 := C1n_pos
  have h2 := C2n_pos
  have hl : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  unfold Cen
  positivity

/-- **The pointwise edge bound, unified.** For `u` on the band
`re ∈ [−1/4, 2]` at height `t ≥ 2`, with a lower bound `δ ≤ 1` on the
distance from `u` to every ball zero: `‖ζ′/ζ(u)‖ ≤ C·(log t)/δ + C·log t`.
Both edges specialize this: the left edge with `δ = 1/4`, the good
horizontals with `δ = zeroGap T`. -/
theorem edge_bound_core_num :
    ∀ t : ℝ, 2 ≤ t → ∀ u : ℂ,
      u.im = t → -1/4 ≤ u.re → u.re ≤ 2 →
      riemannZeta u ≠ 0 →
      ∀ δ : ℝ, 0 < δ → δ ≤ 1 →
      (∀ w ∈ (gz_zeros_ball_finite t (by norm_num : (0:ℝ) ≤ 46/25)).toFinset,
        δ ≤ ‖u - w‖) →
      ‖deriv riemannZeta u / riemannZeta u‖ ≤ Cen * Real.log t / δ := by
  classical
  obtain ⟨C1, hC1def⟩ : ∃ C1 : ℝ, C1 = C1n := ⟨_, rfl⟩
  have hC10 : 0 < C1 := by rw [hC1def]; exact C1n_pos
  have hC1 := gz_partial_fraction_num
  rw [← hC1def] at hC1
  obtain ⟨C2, hC2def⟩ : ∃ C2 : ℝ, C2 = C2n := ⟨_, rfl⟩
  have hC20 : 0 < C2 := by rw [hC2def]; exact C2n_pos
  have hC2 := ball_order_sum_le_num
  rw [← hC2def] at hC2
  have hlog2 : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  have hCdef : Cen = C1 + C2 + 1/Real.log 2 := by
    unfold Cen
    rw [hC1def, hC2def]
  rw [hCdef]
  intro t ht u huim hure1 hure2 huζ δ hδ0 hδ1 hδ
  have hlogt : Real.log 2 ≤ Real.log t := Real.log_le_log (by norm_num) ht
  have hlogt0 : 0 < Real.log t := lt_of_lt_of_le hlog2 hlogt
  have hu1 : u ≠ 1 := by
    intro h
    have h2 := congrArg Complex.im h
    rw [huim, Complex.one_im] at h2
    linarith
  have hugz : gz u ≠ 0 := by
    rw [gz]
    exact mul_ne_zero (pow_ne_zero _ (sub_ne_zero.mpr hu1)) huζ
  have hPF := hC1 t ht u huim hure1 hure2 hugz
  set BF := (gz_zeros_ball_finite t (by norm_num : (0:ℝ) ≤ 46/25)).toFinset with hBFd
  have hSumBound : ‖∑ w ∈ BF, (analyticOrderNatAt gz w : ℂ) / (u - w)‖
      ≤ C2 * Real.log t / δ := by
    calc ‖∑ w ∈ BF, (analyticOrderNatAt gz w : ℂ) / (u - w)‖
        ≤ ∑ w ∈ BF, ‖(analyticOrderNatAt gz w : ℂ) / (u - w)‖ := norm_sum_le _ _
      _ ≤ ∑ w ∈ BF, (analyticOrderNatAt gz w : ℝ) / δ := by
          apply Finset.sum_le_sum
          intro w hw
          have hdist := hδ w hw
          rw [norm_div, Complex.norm_natCast]
          apply div_le_div_of_nonneg_left ?_ hδ0 hdist
          positivity
      _ = (∑ w ∈ BF, (analyticOrderNatAt gz w : ℝ)) / δ := by
          rw [Finset.sum_div]
      _ ≤ C2 * Real.log t / δ := by
          gcongr
          exact hC2 t ht
  have hld := gz_logderiv hu1 huζ
  have hpole : ‖(2:ℂ)/(u - 1)‖ ≤ 1 := by
    rw [norm_div]
    have h7 := Complex.abs_im_le_norm (u - 1)
    have h8 : (u - 1).im = t := by
      rw [Complex.sub_im, huim, Complex.one_im, sub_zero]
    rw [h8, abs_of_pos (by linarith : (0:ℝ) < t)] at h7
    rw [div_le_one (by linarith : (0:ℝ) < ‖u - 1‖)]
    simp only [Complex.norm_ofNat]
    linarith
  have hsplit : deriv riemannZeta u / riemannZeta u
      = (deriv gz u / gz u
          - ∑ w ∈ BF, (analyticOrderNatAt gz w : ℂ) / (u - w))
        + (∑ w ∈ BF, (analyticOrderNatAt gz w : ℂ) / (u - w))
        - (2:ℂ)/(u - 1) := by
    rw [hld]
    ring
  rw [hsplit]
  have htri : ‖(deriv gz u / gz u
        - ∑ w ∈ BF, (analyticOrderNatAt gz w : ℂ) / (u - w))
      + (∑ w ∈ BF, (analyticOrderNatAt gz w : ℂ) / (u - w))
      - (2:ℂ)/(u - 1)‖
      ≤ ‖deriv gz u / gz u
          - ∑ w ∈ BF, (analyticOrderNatAt gz w : ℂ) / (u - w)‖
        + ‖∑ w ∈ BF, (analyticOrderNatAt gz w : ℂ) / (u - w)‖
        + ‖(2:ℂ)/(u - 1)‖ := by
    calc ‖_ + _ - _‖ ≤ ‖_ + _‖ + ‖(2:ℂ)/(u - 1)‖ := norm_sub_le _ _
      _ ≤ _ := by
          have := norm_add_le (deriv gz u / gz u
            - ∑ w ∈ BF, (analyticOrderNatAt gz w : ℂ) / (u - w))
            (∑ w ∈ BF, (analyticOrderNatAt gz w : ℂ) / (u - w))
          linarith
  calc ‖_‖ ≤ _ := htri
    _ ≤ C1 * Real.log t + C2 * Real.log t / δ + 1 := by
        have h9 := hPF
        linarith [hSumBound, hpole]
    _ ≤ (C1 + C2 + 1/Real.log 2) * Real.log t / δ := by
        have h10 : C1 * Real.log t ≤ C1 * Real.log t / δ := by
          rw [le_div_iff₀ hδ0]
          have hX : (0:ℝ) ≤ C1 * Real.log t := by positivity
          nlinarith
        have h11 : (1:ℝ) ≤ (1/Real.log 2) * Real.log t / δ := by
          rw [le_div_iff₀ hδ0]
          have h12 : (1:ℝ) ≤ (1/Real.log 2) * Real.log t := by
            rw [div_mul_eq_mul_div, le_div_iff₀ hlog2]
            linarith
          nlinarith
        have h13 : (C1 + C2 + 1/Real.log 2) * Real.log t / δ
            = C1 * Real.log t / δ + C2 * Real.log t / δ
              + (1/Real.log 2) * Real.log t / δ := by
          field_simp
        rw [h13]
        linarith


/-- info: 'EdgeBound.gz_partial_fraction_num' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gz_partial_fraction_num

/-- info: 'EdgeBound.ball_order_sum_le_num' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ball_order_sum_le_num

/-- info: 'EdgeBound.edge_bound_core_num' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms edge_bound_core_num

end EdgeBound
