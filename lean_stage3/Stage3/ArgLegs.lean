/-
ArgLegs — block H1 of `lean_stage3/design/hnt.md`, "The two contour legs".

The count-to-argument step needs `|zetaArgContour T|` bounded by the number
of zeros of `Re ζ` on the horizontal cut plus a constant. This module is the
geometric half: on a segment where a path `g` avoids `0`, the imaginary part
of `∫ g'/g` is a difference of two arguments, and on a piece where `Re g` does
not change sign those arguments lie in `[−π/2, π/2]`, so the piece contributes
at most `π`. Splitting at the zeros of `Re g` gives `π(|Z| + 1)`. At `ζ` the
two legs of `zetaArgContour` are read off: the vertical leg at `Re s = 2` costs
`π/2` because `Re ζ > 0` there, the horizontal leg costs `π(|Z| + 1)`, and
`(1/π)(π/2 + π(q+1)) = q + 3/2`.

The ten theorems, hypotheses copied from the block's Theorems lines:

  abs_arg_sub_le_pi            (hz : 0 ≤ z.re) (hw : 0 ≤ w.re)
  mem_slitPlane_of_re_nonneg   (hz : 0 ≤ z.re) (hne : z ≠ 0)
  integral_logDeriv_eq_log_sub L1 (hab), L2 (hd), slit-plane values (hs), L4 (hc)
  im_integral_le_pi_of_re_nonneg   L1, L2, L3, L4 and `0 ≤ (g x).re` on `Icc a b`
  im_integral_le_pi_of_re_nonpos   the same with `(g x).re ≤ 0`
  re_sign_const                L5 (hcg), `(g x).re ≠ 0` on `Ioo a b` (no `a ≤ b`: unused, row 20)
  segment_im_integral_le       L1–L5, Z1 (hZ), for a `Z : Finset ℝ`
  vertical_leg_le              T1 (hT), T3 (hpos)
  horizontal_leg_le            T1, T2 (hgood), Z2 (hZ)
  zetaArgContour_le            T1, T2, T3, Z2

Pins: im_integral_le_pi_of_re_nonneg, segment_im_integral_le,
horizontal_leg_le, zetaArgContour_le.

Composed from `Stage3/ArgIdentity.lean`: `Stage3.zetaArgContour` and
`Stage3.logDeriv_zeta_continuousAt`. The block writes these under an
`ArgIdentity` namespace; the declaring module opens `namespace Stage3`, so
they are read here as `Stage3.…` (ASSUMED, PINS.md § Current).

The block's `re_sign_const` route through `closure_Ioo` and
`ContinuousOn.preimage_isClosed_of_isClosed` is replaced by the direct one:
two points of `Icc a b` with strictly opposite signs of `Re g` put a zero of
`Re g` strictly between them, hence inside `Ioo a b` (ASSUMED). Its `a ≤ b`
was unused and is dropped, foreman's pass, TRAPS row 20; the block now agrees.

`segment_im_integral_le` generalises `a` and `b` in the strong induction on
`Z`, where the block says `a` alone: the split is at the largest zero and the
induction hypothesis is used on `[a, z]`, so the endpoint that moves is the
upper one (ASSUMED).

What the next slice needs: H2 supplies the `Z` of `horizontal_leg_le` with
`|Z| ≤ 15 log T + 64`, and the `hpos` of `vertical_leg_le` from
`Re ζ(2+it) ≥ 2 − ζ(2)`; H3 supplies the bad heights and assembles
`StmtSCrude argS 15 66`.
-/
import Stage3.ArgIdentity

namespace ArgLegs

/-- Two points of the closed right half-plane have arguments within `π`. -/
theorem abs_arg_sub_le_pi {z w : ℂ} (hz : 0 ≤ z.re) (hw : 0 ≤ w.re) :
    |z.arg - w.arg| ≤ Real.pi := by
  have h1 : |z.arg| ≤ Real.pi / 2 := Complex.abs_arg_le_pi_div_two_iff.mpr hz
  have h2 : |w.arg| ≤ Real.pi / 2 := Complex.abs_arg_le_pi_div_two_iff.mpr hw
  rw [abs_le] at h1 h2 ⊢
  constructor <;> linarith [h1.1, h1.2, h2.1, h2.2]

/-- A nonzero point of the closed right half-plane lies in the slit plane. -/
theorem mem_slitPlane_of_re_nonneg {z : ℂ} (hz : 0 ≤ z.re) (hne : z ≠ 0) :
    z ∈ Complex.slitPlane := by
  rw [Complex.mem_slitPlane_iff]
  rcases lt_or_eq_of_le hz with h | h
  · exact Or.inl h
  · right
    intro him
    exact hne (Complex.ext_iff.mpr ⟨by simpa using h.symm, by simpa using him⟩)

/-- The fundamental theorem of calculus for `g'/g` in the slit plane. -/
theorem integral_logDeriv_eq_log_sub {g g' : ℝ → ℂ} {a b : ℝ} (hab : a ≤ b)
    (hd : ∀ x ∈ Set.Icc a b, HasDerivAt g (g' x) x)
    (hs : ∀ x ∈ Set.Icc a b, g x ∈ Complex.slitPlane)
    (hc : ContinuousOn (fun x => g' x / g x) (Set.Icc a b)) :
    ∫ x in a..b, g' x / g x = Complex.log (g b) - Complex.log (g a) := by
  have hint : IntervalIntegrable (fun x => g' x / g x) MeasureTheory.volume a b :=
    hc.intervalIntegrable_of_Icc hab
  have hderiv : ∀ x ∈ Set.uIcc a b,
      HasDerivAt (fun t => Complex.log (g t)) (g' x / g x) x := by
    intro x hx
    rw [Set.uIcc_of_le hab] at hx
    exact (hd x hx).clog_real (hs x hx)
  exact intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv hint

/-- One piece, `Re g ≥ 0`: the imaginary part of `∫ g'/g` moves by at most `π`. -/
theorem im_integral_le_pi_of_re_nonneg {g g' : ℝ → ℂ} {a b : ℝ} (hab : a ≤ b)
    (hd : ∀ x ∈ Set.Icc a b, HasDerivAt g (g' x) x)
    (hne : ∀ x ∈ Set.Icc a b, g x ≠ 0)
    (hre : ∀ x ∈ Set.Icc a b, 0 ≤ (g x).re)
    (hc : ContinuousOn (fun x => g' x / g x) (Set.Icc a b)) :
    |(∫ x in a..b, g' x / g x).im| ≤ Real.pi := by
  have hs : ∀ x ∈ Set.Icc a b, g x ∈ Complex.slitPlane := fun x hx =>
    mem_slitPlane_of_re_nonneg (hre x hx) (hne x hx)
  rw [integral_logDeriv_eq_log_sub hab hd hs hc, Complex.sub_im, Complex.log_im,
    Complex.log_im]
  exact abs_arg_sub_le_pi (hre b ⟨hab, le_refl b⟩) (hre a ⟨le_refl a, hab⟩)

/-- One piece, `Re g ≤ 0`: the same bound, applied at `-g`. -/
theorem im_integral_le_pi_of_re_nonpos {g g' : ℝ → ℂ} {a b : ℝ} (hab : a ≤ b)
    (hd : ∀ x ∈ Set.Icc a b, HasDerivAt g (g' x) x)
    (hne : ∀ x ∈ Set.Icc a b, g x ≠ 0)
    (hre : ∀ x ∈ Set.Icc a b, (g x).re ≤ 0)
    (hc : ContinuousOn (fun x => g' x / g x) (Set.Icc a b)) :
    |(∫ x in a..b, g' x / g x).im| ≤ Real.pi := by
  have key := im_integral_le_pi_of_re_nonneg (g := fun x => -g x) (g' := fun x => -g' x)
    hab (fun x hx => (hd x hx).fun_neg)
    (fun x hx => neg_ne_zero.mpr (hne x hx))
    (fun x hx => by simpa using neg_nonneg.mpr (hre x hx))
    (by simp only [neg_div_neg_eq]; exact hc)
  simp only [neg_div_neg_eq] at key
  exact key

/-- With no zero of `Re g` inside `(a, b)`, the sign of `Re g` is constant on `[a, b]`. -/
theorem re_sign_const {g : ℝ → ℂ} {a b : ℝ}
    (hcg : ContinuousOn g (Set.Icc a b))
    (hne : ∀ x ∈ Set.Ioo a b, (g x).re ≠ 0) :
    (∀ x ∈ Set.Icc a b, 0 ≤ (g x).re) ∨ (∀ x ∈ Set.Icc a b, (g x).re ≤ 0) := by
  have hf : ContinuousOn (fun t => (g t).re) (Set.Icc a b) :=
    Complex.continuous_re.comp_continuousOn hcg
  by_cases h : ∀ x ∈ Set.Icc a b, 0 ≤ (g x).re
  · exact Or.inl h
  · right
    obtain ⟨x, hx, hxneg⟩ : ∃ x ∈ Set.Icc a b, (g x).re < 0 := by
      by_contra hcon
      exact h fun y hy => not_lt.mp fun hlt => hcon ⟨y, hy, hlt⟩
    intro y hy
    by_contra hy0
    have hypos : 0 < (g y).re := not_le.mp hy0
    have h0 : (0:ℝ) ∈ Set.Icc ((g x).re) ((g y).re) := ⟨hxneg.le, hypos.le⟩
    rcases lt_trichotomy x y with hxy | hxy | hxy
    · have hsub : Set.Icc x y ⊆ Set.Icc a b := Set.Icc_subset_Icc hx.1 hy.2
      obtain ⟨z, hz, hz0⟩ := intermediate_value_Icc hxy.le (hf.mono hsub) h0
      have hzx : x < z := lt_of_le_of_ne hz.1 (by rintro rfl; exact absurd hz0 (ne_of_lt hxneg))
      have hzy : z < y := lt_of_le_of_ne hz.2 (by rintro rfl; exact absurd hz0 (ne_of_gt hypos))
      exact hne z ⟨lt_of_le_of_lt hx.1 hzx, lt_of_lt_of_le hzy hy.2⟩ hz0
    · rw [hxy] at hxneg; linarith
    · have hsub : Set.Icc y x ⊆ Set.Icc a b := Set.Icc_subset_Icc hy.1 hx.2
      obtain ⟨z, hz, hz0⟩ := intermediate_value_Icc' hxy.le (hf.mono hsub) h0
      have hzx : z < x := lt_of_le_of_ne hz.2 (by rintro rfl; exact absurd hz0 (ne_of_lt hxneg))
      have hzy : y < z := lt_of_le_of_ne hz.1 (by rintro rfl; exact absurd hz0 (ne_of_gt hypos))
      exact hne z ⟨lt_of_le_of_lt hy.1 hzy, lt_of_lt_of_le hzx hx.2⟩ hz0

/-- The segment bound: one piece per zero of `Re g` inside `(a, b)`, plus one. -/
theorem segment_im_integral_le {g g' : ℝ → ℂ} {a b : ℝ} (hab : a ≤ b)
    (hd : ∀ x ∈ Set.Icc a b, HasDerivAt g (g' x) x)
    (hne : ∀ x ∈ Set.Icc a b, g x ≠ 0)
    (hc : ContinuousOn (fun x => g' x / g x) (Set.Icc a b))
    (hcg : ContinuousOn g (Set.Icc a b))
    (Z : Finset ℝ) (hZ : ∀ x ∈ Set.Ioo a b, (g x).re = 0 → x ∈ Z) :
    |(∫ x in a..b, g' x / g x).im| ≤ Real.pi * ((Z.card : ℝ) + 1) := by
  induction Z using Finset.strongInduction generalizing a b with
  | _ Z ih =>
    have hpc : 0 ≤ Real.pi * (Z.card : ℝ) :=
      mul_nonneg Real.pi_pos.le (Nat.cast_nonneg _)
    by_cases hZne : (Z.filter (fun x => a < x ∧ x < b)).Nonempty
    · obtain ⟨z, hzmem, hzmax⟩ :
          ∃ z ∈ Z.filter (fun x => a < x ∧ x < b),
            ∀ x ∈ Z.filter (fun x => a < x ∧ x < b), x ≤ z :=
        ⟨_, Finset.max'_mem _ hZne, fun x hx => Finset.le_max' _ x hx⟩
      obtain ⟨hzZ, hza, hzb⟩ : z ∈ Z ∧ a < z ∧ z < b := by
        have hm := Finset.mem_filter.mp hzmem
        exact ⟨hm.1, hm.2.1, hm.2.2⟩
      have hsub1 : Set.Icc a z ⊆ Set.Icc a b := Set.Icc_subset_Icc le_rfl hzb.le
      have hsub2 : Set.Icc z b ⊆ Set.Icc a b := Set.Icc_subset_Icc hza.le le_rfl
      have hint1 : IntervalIntegrable (fun x => g' x / g x) MeasureTheory.volume a z :=
        (hc.mono hsub1).intervalIntegrable_of_Icc hza.le
      have hint2 : IntervalIntegrable (fun x => g' x / g x) MeasureTheory.volume z b :=
        (hc.mono hsub2).intervalIntegrable_of_Icc hzb.le
      have hsplit := intervalIntegral.integral_add_adjacent_intervals hint1 hint2
      have hnone : ∀ x ∈ Set.Ioo z b, (g x).re ≠ 0 := by
        intro x hx h0
        have hxab : x ∈ Set.Ioo a b := ⟨lt_trans hza hx.1, hx.2⟩
        have hxf : x ∈ Z.filter (fun y => a < y ∧ y < b) :=
          Finset.mem_filter.mpr ⟨hZ x hxab h0, hxab.1, hxab.2⟩
        exact absurd (hzmax x hxf) (not_le.mpr hx.1)
      have hpiece : |(∫ x in z..b, g' x / g x).im| ≤ Real.pi := by
        rcases re_sign_const (hcg.mono hsub2) hnone with hsign | hsign
        · exact im_integral_le_pi_of_re_nonneg hzb.le (fun x hx => hd x (hsub2 hx))
            (fun x hx => hne x (hsub2 hx)) hsign (hc.mono hsub2)
        · exact im_integral_le_pi_of_re_nonpos hzb.le (fun x hx => hd x (hsub2 hx))
            (fun x hx => hne x (hsub2 hx)) hsign (hc.mono hsub2)
      have hih := ih (Z.erase z) (Finset.erase_ssubset hzZ) hza.le
        (fun x hx => hd x (hsub1 hx)) (fun x hx => hne x (hsub1 hx))
        (hc.mono hsub1) (hcg.mono hsub1)
        (fun x hx h0 => Finset.mem_erase.mpr
          ⟨ne_of_lt hx.2, hZ x ⟨hx.1, lt_trans hx.2 hzb⟩ h0⟩)
      have hcard : ((Z.erase z).card : ℝ) + 1 = (Z.card : ℝ) := by
        have h1 : 1 ≤ Z.card := Finset.card_pos.mpr ⟨z, hzZ⟩
        rw [Finset.card_erase_of_mem hzZ, Nat.cast_sub h1, Nat.cast_one]
        ring
      have hstep : Real.pi * (((Z.erase z).card : ℝ) + 1) + Real.pi
          = Real.pi * ((Z.card : ℝ) + 1) := by
        rw [← hcard]; ring
      rw [← hsplit, Complex.add_im]
      have habs := abs_add_le ((∫ x in a..z, g' x / g x).im)
        ((∫ x in z..b, g' x / g x).im)
      linarith [habs, hih, hpiece, hstep]
    · have hnone : ∀ x ∈ Set.Ioo a b, (g x).re ≠ 0 := by
        intro x hx h0
        exact hZne ⟨x, Finset.mem_filter.mpr ⟨hZ x hx h0, hx.1, hx.2⟩⟩
      rcases re_sign_const hcg hnone with hsign | hsign
      · have hb := im_integral_le_pi_of_re_nonneg hab hd hne hsign hc
        nlinarith [hb, hpc]
      · have hb := im_integral_le_pi_of_re_nonpos hab hd hne hsign hc
        nlinarith [hb, hpc]

/-- The vertical leg at `Re s = 2`, where `Re ζ > 0`, costs at most `π/2`. -/
theorem vertical_leg_le {T : ℝ} (hT : 2 ≤ T)
    (hpos : ∀ t ∈ Set.Icc (0:ℝ) T, 0 < (riemannZeta (2 + (t : ℂ) * Complex.I)).re) :
    |(∫ t in (0:ℝ)..T, logDeriv riemannZeta (2 + (t : ℂ) * Complex.I)).re|
      ≤ Real.pi / 2 := by
  have hT0 : (0:ℝ) ≤ T := by linarith
  have hne1 : ∀ t : ℝ, (2 : ℂ) + (t : ℂ) * Complex.I ≠ 1 := by
    intro t h
    have h2 : ((2 : ℂ) + (t : ℂ) * Complex.I).re = (1 : ℂ).re := by rw [h]
    simp at h2
  have hzne : ∀ t ∈ Set.Icc (0:ℝ) T, riemannZeta (2 + (t : ℂ) * Complex.I) ≠ 0 := by
    intro t ht h
    have hp := hpos t ht
    rw [h] at hp
    simp at hp
  have hd : ∀ t ∈ Set.Icc (0:ℝ) T,
      HasDerivAt (fun y : ℝ => riemannZeta (2 + (y : ℂ) * Complex.I))
        (deriv riemannZeta (2 + (t : ℂ) * Complex.I) * Complex.I) t := by
    intro t _
    have hz : HasDerivAt (fun w : ℂ => (2 : ℂ) + w * Complex.I) Complex.I ((t : ℝ) : ℂ) := by
      simpa using ((hasDerivAt_id ((t : ℝ) : ℂ)).mul_const Complex.I).const_add (2 : ℂ)
    have hcomp :=
      (((differentiableAt_riemannZeta (hne1 t)).hasDerivAt).comp ((t : ℝ) : ℂ) hz).comp_ofReal
    simpa [Function.comp] using hcomp
  have hs : ∀ t ∈ Set.Icc (0:ℝ) T,
      riemannZeta (2 + (t : ℂ) * Complex.I) ∈ Complex.slitPlane :=
    fun t ht => mem_slitPlane_of_re_nonneg (hpos t ht).le (hzne t ht)
  -- one try spent at the first build; closed by the foreman. Goal was:
  --   T : ℝ, hT : 2 ≤ T, hT0 : 0 ≤ T,
  --   hne1 : ∀ (t : ℝ), 2 + ↑t * Complex.I ≠ 1,
  --   hzne : ∀ t ∈ Set.Icc 0 T, riemannZeta (2 + ↑t * Complex.I) ≠ 0
  --   ⊢ ContinuousOn (fun t => logDeriv riemannZeta (2 + ↑t * Complex.I)) (Set.Icc 0 T)
  -- The try was `intro t ht; ((Stage3.logDeriv_zeta_continuousAt (hne1 t) (hzne t ht)).comp
  -- hf).continuousWithinAt` with `hf : ContinuousAt (fun y : ℝ => (2:ℂ) + ↑y * Complex.I) t`;
  -- `ContinuousAt.comp` unified its implicit `f` with `HAdd.hAdd 2` at the point `↑t * I`
  -- (TRAPS row 16).
  have hlogd : ContinuousOn (fun t : ℝ => logDeriv riemannZeta (2 + (t : ℂ) * Complex.I))
      (Set.Icc (0:ℝ) T) := by
    intro t ht
    have hf : ContinuousAt (fun y : ℝ => (2 : ℂ) + (y : ℂ) * Complex.I) t := by fun_prop
    have hg := ContinuousAt.comp (g := logDeriv riemannZeta)
      (f := fun y : ℝ => (2 : ℂ) + (y : ℂ) * Complex.I)
      (Stage3.logDeriv_zeta_continuousAt (hne1 t) (hzne t ht)) hf
    exact hg.continuousWithinAt
  have hfun : (fun t : ℝ => deriv riemannZeta (2 + (t : ℂ) * Complex.I) * Complex.I
        / riemannZeta (2 + (t : ℂ) * Complex.I))
      = fun t : ℝ => logDeriv riemannZeta (2 + (t : ℂ) * Complex.I) * Complex.I := by
    funext t
    rw [logDeriv_apply, div_mul_eq_mul_div]
  have hc : ContinuousOn (fun t : ℝ => deriv riemannZeta (2 + (t : ℂ) * Complex.I) * Complex.I
      / riemannZeta (2 + (t : ℂ) * Complex.I)) (Set.Icc (0:ℝ) T) := by
    rw [hfun]
    exact hlogd.mul continuousOn_const
  have hIsplit : (∫ t in (0:ℝ)..T, logDeriv riemannZeta (2 + (t : ℂ) * Complex.I) * Complex.I)
      = (∫ t in (0:ℝ)..T, logDeriv riemannZeta (2 + (t : ℂ) * Complex.I)) * Complex.I :=
    intervalIntegral.integral_mul_const _ _
  have hEq : (∫ t in (0:ℝ)..T, deriv riemannZeta (2 + (t : ℂ) * Complex.I) * Complex.I
        / riemannZeta (2 + (t : ℂ) * Complex.I))
      = (∫ t in (0:ℝ)..T, logDeriv riemannZeta (2 + (t : ℂ) * Complex.I)) * Complex.I := by
    rw [← hIsplit]
    simp only [logDeriv_apply, div_mul_eq_mul_div]
  have hlog := integral_logDeriv_eq_log_sub
    (g := fun t : ℝ => riemannZeta (2 + (t : ℂ) * Complex.I))
    (g' := fun t : ℝ => deriv riemannZeta (2 + (t : ℂ) * Complex.I) * Complex.I)
    hT0 hd hs hc
  have hmain : (∫ t in (0:ℝ)..T, logDeriv riemannZeta (2 + (t : ℂ) * Complex.I)) * Complex.I
      = Complex.log (riemannZeta (2 + (T : ℂ) * Complex.I))
        - Complex.log (riemannZeta (2 + ((0:ℝ) : ℂ) * Complex.I)) := by
    rw [← hEq]; exact hlog
  have him := congrArg Complex.im hmain
  simp only [Complex.mul_im, Complex.I_im, Complex.I_re, mul_one, mul_zero, add_zero,
    Complex.sub_im, Complex.log_im] at him
  have hz0 : (2 : ℂ) + ((0:ℝ) : ℂ) * Complex.I = 2 := by norm_num
  have harg0 : (riemannZeta 2).arg = 0 := by
    rw [riemannZeta_two]
    have hcast : ((Real.pi : ℂ) ^ 2 / 6) = (((Real.pi ^ 2 / 6 : ℝ)) : ℂ) := by
      push_cast; ring
    rw [hcast, Complex.arg_ofReal_of_nonneg (by positivity)]
  rw [him, hz0, harg0, sub_zero]
  exact Complex.abs_arg_le_pi_div_two_iff.mpr (hpos T ⟨hT0, le_rfl⟩).le

/-- The horizontal leg on `[1/2, 2]` at height `T`, one piece per zero of `Re ζ`. -/
theorem horizontal_leg_le {T : ℝ} (hT : 2 ≤ T)
    (hgood : ∀ x ∈ Set.Icc (1/2:ℝ) 2, riemannZeta ((x : ℂ) + T * Complex.I) ≠ 0)
    (Z : Finset ℝ)
    (hZ : ∀ x ∈ Set.Ioo (1/2:ℝ) 2,
      (riemannZeta ((x : ℂ) + T * Complex.I)).re = 0 → x ∈ Z) :
    |(∫ x in (1/2:ℝ)..2, logDeriv riemannZeta ((x : ℂ) + T * Complex.I)).im|
      ≤ Real.pi * ((Z.card : ℝ) + 1) := by
  have hne1 : ∀ x : ℝ, (x : ℂ) + (T : ℂ) * Complex.I ≠ 1 := by
    intro x h
    have h2 : (((x : ℂ) + (T : ℂ) * Complex.I).im) = (1 : ℂ).im := by rw [h]
    simp at h2
    linarith
  have hd : ∀ x ∈ Set.Icc (1/2:ℝ) 2,
      HasDerivAt (fun y : ℝ => riemannZeta ((y : ℂ) + (T : ℂ) * Complex.I))
        (deriv riemannZeta ((x : ℂ) + (T : ℂ) * Complex.I)) x := by
    intro x _
    have hz : HasDerivAt (fun w : ℂ => w + (T : ℂ) * Complex.I) 1 ((x : ℝ) : ℂ) := by
      simpa using (hasDerivAt_id ((x : ℝ) : ℂ)).add_const ((T : ℂ) * Complex.I)
    have hcomp :=
      (((differentiableAt_riemannZeta (hne1 x)).hasDerivAt).comp ((x : ℝ) : ℂ) hz).comp_ofReal
    simpa [Function.comp] using hcomp
  have hcg : ContinuousOn (fun x : ℝ => riemannZeta ((x : ℂ) + (T : ℂ) * Complex.I))
      (Set.Icc (1/2:ℝ) 2) := fun x hx => ((hd x hx).continuousAt).continuousWithinAt
  have hfun : (fun x : ℝ => deriv riemannZeta ((x : ℂ) + (T : ℂ) * Complex.I)
        / riemannZeta ((x : ℂ) + (T : ℂ) * Complex.I))
      = fun x : ℝ => logDeriv riemannZeta ((x : ℂ) + (T : ℂ) * Complex.I) := by
    funext x
    rw [logDeriv_apply]
  -- one try spent at the first build; closed by the foreman. Goal was:
  --   T : ℝ, hT : 2 ≤ T,
  --   hgood : ∀ x ∈ Set.Icc (1/2) 2, riemannZeta (↑x + ↑T * Complex.I) ≠ 0,
  --   hne1 : ∀ (x : ℝ), ↑x + ↑T * Complex.I ≠ 1,
  --   hfun : (fun x => deriv riemannZeta (↑x + ↑T * Complex.I) /
  --            riemannZeta (↑x + ↑T * Complex.I))
  --          = fun x => logDeriv riemannZeta (↑x + ↑T * Complex.I)
  --   ⊢ ContinuousOn (fun x => deriv riemannZeta (↑x + ↑T * Complex.I) /
  --       riemannZeta (↑x + ↑T * Complex.I)) (Set.Icc (1/2) 2)
  -- The try was `rw [hfun]; intro x hx;
  -- ((Stage3.logDeriv_zeta_continuousAt (hne1 x) (hgood x hx)).comp hf).continuousWithinAt`
  -- with `hf : ContinuousAt (fun y : ℝ => ↑y + ↑T * Complex.I) x`; `ContinuousAt.comp`
  -- unified its implicit `f` with `HAdd.hAdd ↑x` at the point `↑T * I` (TRAPS row 16).
  have hc : ContinuousOn (fun x : ℝ => deriv riemannZeta ((x : ℂ) + (T : ℂ) * Complex.I)
      / riemannZeta ((x : ℂ) + (T : ℂ) * Complex.I)) (Set.Icc (1/2:ℝ) 2) := by
    rw [hfun]
    intro x hx
    have hf : ContinuousAt (fun y : ℝ => (y : ℂ) + (T : ℂ) * Complex.I) x := by fun_prop
    have hg := ContinuousAt.comp (g := logDeriv riemannZeta)
      (f := fun y : ℝ => (y : ℂ) + (T : ℂ) * Complex.I)
      (Stage3.logDeriv_zeta_continuousAt (hne1 x) (hgood x hx)) hf
    exact hg.continuousWithinAt
  have key := segment_im_integral_le
    (g := fun x : ℝ => riemannZeta ((x : ℂ) + (T : ℂ) * Complex.I))
    (g' := fun x : ℝ => deriv riemannZeta ((x : ℂ) + (T : ℂ) * Complex.I))
    (by norm_num : (1/2:ℝ) ≤ 2) hd hgood hc hcg Z hZ
  have hgoal : (∫ x in (1/2:ℝ)..2, logDeriv riemannZeta ((x : ℂ) + T * Complex.I))
      = ∫ x in (1/2:ℝ)..2, deriv riemannZeta ((x : ℂ) + (T : ℂ) * Complex.I)
          / riemannZeta ((x : ℂ) + (T : ℂ) * Complex.I) := by
    simp only [logDeriv_apply]
  rw [hgoal]
  exact key

/-- The two legs together: `|zetaArgContour T| ≤ q + 3/2` with `q = |Z|`. -/
theorem zetaArgContour_le {T : ℝ} (hT : 2 ≤ T)
    (hpos : ∀ t ∈ Set.Icc (0:ℝ) T, 0 < (riemannZeta (2 + (t : ℂ) * Complex.I)).re)
    (hgood : ∀ x ∈ Set.Icc (1/2:ℝ) 2, riemannZeta ((x : ℂ) + T * Complex.I) ≠ 0)
    (Z : Finset ℝ)
    (hZ : ∀ x ∈ Set.Ioo (1/2:ℝ) 2,
      (riemannZeta ((x : ℂ) + T * Complex.I)).re = 0 → x ∈ Z) :
    |Stage3.zetaArgContour T| ≤ (Z.card : ℝ) + 3 / 2 := by
  have hv := vertical_leg_le hT hpos
  have hh := horizontal_leg_le hT hgood Z hZ
  have hpi := Real.pi_pos
  have habs : |(∫ t in (0:ℝ)..T, logDeriv riemannZeta (2 + (t : ℂ) * Complex.I)).re
        - (∫ x in (1/2:ℝ)..2, logDeriv riemannZeta ((x : ℂ) + T * Complex.I)).im|
      ≤ |(∫ t in (0:ℝ)..T, logDeriv riemannZeta (2 + (t : ℂ) * Complex.I)).re|
        + |(∫ x in (1/2:ℝ)..2, logDeriv riemannZeta ((x : ℂ) + T * Complex.I)).im| := by
    have hsum := abs_add_le
      ((∫ t in (0:ℝ)..T, logDeriv riemannZeta (2 + (t : ℂ) * Complex.I)).re)
      (-(∫ x in (1/2:ℝ)..2, logDeriv riemannZeta ((x : ℂ) + T * Complex.I)).im)
    simpa [sub_eq_add_neg] using hsum
  rw [Stage3.zetaArgContour, abs_mul,
    abs_of_nonneg (by positivity : (0:ℝ) ≤ 1 / Real.pi),
    div_mul_eq_mul_div, one_mul, div_le_iff₀ hpi]
  nlinarith [habs, hv, hh, hpi]

/-- info: 'ArgLegs.im_integral_le_pi_of_re_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms im_integral_le_pi_of_re_nonneg

/-- info: 'ArgLegs.segment_im_integral_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms segment_im_integral_le

/-- info: 'ArgLegs.horizontal_leg_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms horizontal_leg_le

/-- info: 'ArgLegs.zetaArgContour_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zetaArgContour_le

end ArgLegs
