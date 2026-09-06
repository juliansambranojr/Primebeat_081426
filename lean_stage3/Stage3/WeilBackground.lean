/-
WeilBackground — the window as a test function of the explicit formula, and
the on-line terms of the zero side. Rung 4b, first half, of the detection
ladder (units 0316–0319). 2026-09-06.

WeilDetect sums `laplace φ(−ρ)·laplace φ(−(1−ρ))·ord ρ` over the nontrivial
zeros, in Kadiri's convention `laplace φ z = ∫ φ(u)e^{−zu} du`. The window of
WeilTransform enters through

    φ(u) = 𝟙_{[−h,h]}(u) · G(u) · e^{−u/2},

so that `laplace φ (−ρ) = ghat h γ (ρ − 1/2)` (`laplace_phi`): the `e^{−u/2}`
is the `n^{−1/2}` of the instrument's prime sum, and `ρ − 1/2` is where the
transform is read. On the line, `ρ − 1/2 = iγ_ρ`, and for real `φ` the term
is a squared modulus (`online_term_eq`, via WeilDetect.laplace_conj and
WeilTransform.ghat_ofReal_I):

    term(ρ) = (h/2)²·[Ψ(h(γ_ρ + γ)) + Ψ(h(γ_ρ − γ))]²·ord ρ  ≥ 0.

The decay of `Ψ` is the lobe bound read at a purely imaginary argument
(`Psi_bound`, from WeilLobe.SigmaC_bound and WeilTransform.SigmaC_I_mul):

    |Ψ(s)| ≤ (2π + π²)/s²        (s ≠ 0),      and     |Ψ(s)| ≤ 2 always.

So an on-line zero at height `γ_ρ` contributes at most `4h²·ord ρ` near the
carrier and at most `(h/2)²·[C/(h(γ_ρ−γ))² + C/(h(γ_ρ+γ))²]²·ord ρ` away from
it (`online_term_le_near`, `online_term_le_far`). Summing those over the
zeros by height band with `JensenCount.zeta_local_zero_count` is the second
half of this rung.

  phi                  the test function
  laplace_phi          laplace φ z = ghat h γ (−z − 1/2)
  Psi_bound, Psi_le_two
  online_term_eq       on the line the term is (h/2)²[Ψ + Ψ]²·ord
  online_term_le_near  ≤ 4h²·ord
  online_term_le_far   the decay form, for |γ_ρ − γ| ≥ 1 and γ_ρ + γ ≥ 1

Axioms: every theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.WeilDetect
import Stage3.WeilLobe

namespace WeilBackground

noncomputable section

open Complex WeilWindow WeilTransform WeilLobe WeilDetect intervalIntegral Real MeasureTheory

/-- The window as a test function of the explicit formula: cut off to
`[−h, h]`, times `e^{−u/2}`. Real-valued. -/
def phi (h γ : ℝ) (u : ℝ) : ℝ :=
  Set.indicator (Set.Icc (-h) h) (fun u => G h γ u * Real.exp (-u / 2)) u

/-- The complex-valued test function WeilDetect reads. -/
def phiC (h γ : ℝ) : ℝ → ℂ := fun u => ((phi h γ u : ℝ) : ℂ)

theorem phiC_real (h γ : ℝ) (u : ℝ) : (phiC h γ u).im = 0 := by
  unfold phiC; simp

/-- **The transform in the explicit formula's convention.**
`laplace φ z = ghat h γ (−z − 1/2)`. -/
theorem laplace_phi {h : ℝ} (hh : 0 < h) (γ : ℝ) (z : ℂ) :
    laplace (phiC h γ) z = ghat h γ (-z - 1 / 2) := by
  unfold laplace phiC phi ghat
  have hind : ∀ u : ℝ,
      ((Set.indicator (Set.Icc (-h) h) (fun u => G h γ u * Real.exp (-u / 2)) u : ℝ) : ℂ)
        * Complex.exp (-(z * (u : ℂ)))
      = Set.indicator (Set.Icc (-h) h)
          (fun u : ℝ => ((G h γ u : ℝ) : ℂ) * Complex.exp ((-z - 1 / 2) * (u : ℂ))) u := by
    intro u
    by_cases hu : u ∈ Set.Icc (-h) h
    · rw [Set.indicator_of_mem hu, Set.indicator_of_mem hu]
      push_cast
      rw [mul_assoc, ← Complex.exp_add]
      congr 2
      ring
    · rw [Set.indicator_of_notMem hu, Set.indicator_of_notMem hu]
      simp
  simp_rw [hind]
  rw [MeasureTheory.integral_indicator measurableSet_Icc, MeasureTheory.integral_Icc_eq_integral_Ioc,
    intervalIntegral.integral_of_le (by linarith : -h ≤ h)]

/-- `|Ψ(s)| ≤ (2π + π²)/s²` for `s ≠ 0`: the lobe bound at a purely imaginary
argument, where `cosh(Re w) = 1` and `‖w‖ = |s|`. -/
theorem Psi_bound {s : ℝ} (hs : s ≠ 0) : |WeilTransform.Psi s| ≤ (2 * Real.pi + Real.pi ^ 2) / s ^ 2 := by
  have h1 : SigmaC (Complex.I * (s : ℂ)) = Complex.I * (WeilTransform.Psi s : ℂ) := SigmaC_I_mul s
  have hw : Complex.I * (s : ℂ) ≠ 0 := by
    intro h0
    have := congrArg Complex.im h0
    simp at this
    exact hs this
  have h2 := SigmaC_bound (Complex.I * (s : ℂ)) hw
  rw [h1] at h2
  have hre : (Complex.I * (s : ℂ)).re = 0 := by simp
  have hnorm : ‖Complex.I * (s : ℂ)‖ = |s| := by
    rw [norm_mul, Complex.norm_I, one_mul, Complex.norm_real, Real.norm_eq_abs]
  rw [hre, Real.cosh_zero, mul_one, hnorm, sq_abs, norm_mul, Complex.norm_I, one_mul,
    Complex.norm_real, Real.norm_eq_abs] at h2
  exact h2

/-- `|Ψ(s)| ≤ 2`: the integrand is at most `1` in absolute value on an
interval of length `2`. -/
theorem Psi_le_two (s : ℝ) : |WeilTransform.Psi s| ≤ 2 := by
  unfold WeilTransform.Psi
  have h := intervalIntegral.norm_integral_le_of_norm_le_const
    (a := (-1 : ℝ)) (b := 1) (C := 1)
    (f := fun x : ℝ => x * P x * Real.sin (s * x)) (by
      intro x hx
      have hx1 : |x| ≤ 1 := by
        rcases Set.mem_uIoc.mp hx with h | h
        · exact abs_le.mpr ⟨by linarith [h.1], h.2⟩
        · exact abs_le.mpr ⟨by linarith [h.1], by linarith [h.2]⟩
      rw [Real.norm_eq_abs, abs_mul, abs_mul]
      have hP : |P x| ≤ 1 := by
        rw [abs_of_nonneg (P_nonneg x)]; exact P_le_one x
      have hsin := Real.abs_sin_le_one (s * x)
      calc |x| * |P x| * |Real.sin (s * x)| ≤ 1 * 1 * 1 := by gcongr
        _ = 1 := by ring)
  rw [Real.norm_eq_abs] at h
  norm_num at h
  exact h

/-- **On the line the term is a squared modulus**: for `Re ρ = 1/2`,
`laplace φ(−ρ)·laplace φ(−(1−ρ)) = (h/2)²·[Ψ(h(γ_ρ + γ)) + Ψ(h(γ_ρ − γ))]²`. -/
theorem online_term_eq {h : ℝ} (hh : 0 < h) (γ : ℝ) {ρ : ℂ} (hρ : ρ.re = 1 / 2) :
    laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ))
      = (((h / 2) ^ 2 * (WeilTransform.Psi (h * (ρ.im + γ)) + WeilTransform.Psi (h * (ρ.im - γ))) ^ 2 : ℝ) : ℂ) := by
  have hconj : -(1 - ρ) = (starRingEnd ℂ) (-ρ) := by
    apply Complex.ext
    · simp [hρ]; try norm_num
    · simp
  rw [hconj, laplace_conj (phiC h γ) (phiC_real h γ), Complex.mul_conj]
  rw [laplace_phi hh]
  have harg : -(-ρ) - 1 / 2 = Complex.I * (ρ.im : ℂ) := by
    apply Complex.ext
    · simp [hρ]; try norm_num
    · simp
  rw [harg, ghat_ofReal_I hh]
  rw [Complex.normSq_eq_norm_sq]
  congr 1
  rw [norm_mul, norm_mul, Complex.norm_I, one_mul, norm_div, Complex.norm_real,
    Real.norm_eq_abs, abs_of_pos hh]
  push_cast
  rw [← Complex.ofReal_add, Complex.norm_real, Real.norm_eq_abs]
  norm_num
  try rw [mul_pow, sq_abs]

/-- Near the carrier: the on-line term is at most `4h²` (from `|Ψ| ≤ 2`). -/
theorem online_term_le_near {h : ℝ} (hh : 0 < h) (γ : ℝ) {ρ : ℂ} (hρ : ρ.re = 1 / 2) :
    (laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ))).re ≤ 4 * h ^ 2 := by
  rw [online_term_eq hh γ hρ, Complex.ofReal_re]
  have h1 := Psi_le_two (h * (ρ.im + γ))
  have h2 := Psi_le_two (h * (ρ.im - γ))
  have hsum : |WeilTransform.Psi (h * (ρ.im + γ)) + WeilTransform.Psi (h * (ρ.im - γ))| ≤ 4 := by
    calc |WeilTransform.Psi (h * (ρ.im + γ)) + WeilTransform.Psi (h * (ρ.im - γ))|
        ≤ |WeilTransform.Psi (h * (ρ.im + γ))| + |WeilTransform.Psi (h * (ρ.im - γ))| := abs_add_le _ _
      _ ≤ 2 + 2 := add_le_add h1 h2
      _ = 4 := by norm_num
  have hsq : (WeilTransform.Psi (h * (ρ.im + γ)) + WeilTransform.Psi (h * (ρ.im - γ))) ^ 2 ≤ 16 := by
    rw [← sq_abs]
    calc |WeilTransform.Psi (h * (ρ.im + γ)) + WeilTransform.Psi (h * (ρ.im - γ))| ^ 2 ≤ 4 ^ 2 :=
          pow_le_pow_left₀ (abs_nonneg _) hsum 2
      _ = 16 := by norm_num
  nlinarith [sq_nonneg h]

/-- Away from the carrier: for `|γ_ρ − γ| ≥ 1` and `γ_ρ + γ ≥ 1`, the on-line
term is at most `(h/2)²·[C/(h(γ_ρ−γ))² + C/(h(γ_ρ+γ))²]²`, `C = 2π + π²`. -/
theorem online_term_le_far {h : ℝ} (hh : 0 < h) (γ : ℝ) {ρ : ℂ} (hρ : ρ.re = 1 / 2)
    (hfar : 1 ≤ |ρ.im - γ|) (hsum : 1 ≤ ρ.im + γ) :
    (laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ))).re
      ≤ (h / 2) ^ 2 * ((2 * Real.pi + Real.pi ^ 2) / (h * (ρ.im - γ)) ^ 2
          + (2 * Real.pi + Real.pi ^ 2) / (h * (ρ.im + γ)) ^ 2) ^ 2 := by
  rw [online_term_eq hh γ hρ, Complex.ofReal_re]
  have hne1 : h * (ρ.im + γ) ≠ 0 := by
    apply mul_ne_zero (ne_of_gt hh); linarith
  have hne2 : h * (ρ.im - γ) ≠ 0 := by
    apply mul_ne_zero (ne_of_gt hh)
    intro h0; rw [h0, abs_zero] at hfar; linarith
  have b1 := Psi_bound hne1
  have b2 := Psi_bound hne2
  have hC : 0 ≤ 2 * Real.pi + Real.pi ^ 2 := by positivity
  have habs : |WeilTransform.Psi (h * (ρ.im + γ)) + WeilTransform.Psi (h * (ρ.im - γ))|
      ≤ (2 * Real.pi + Real.pi ^ 2) / (h * (ρ.im - γ)) ^ 2
        + (2 * Real.pi + Real.pi ^ 2) / (h * (ρ.im + γ)) ^ 2 := by
    calc |WeilTransform.Psi (h * (ρ.im + γ)) + WeilTransform.Psi (h * (ρ.im - γ))|
        ≤ |WeilTransform.Psi (h * (ρ.im + γ))| + |WeilTransform.Psi (h * (ρ.im - γ))| := abs_add_le _ _
      _ ≤ (2 * Real.pi + Real.pi ^ 2) / (h * (ρ.im + γ)) ^ 2
          + (2 * Real.pi + Real.pi ^ 2) / (h * (ρ.im - γ)) ^ 2 := add_le_add b1 b2
      _ = _ := by ring
  have hsq : (WeilTransform.Psi (h * (ρ.im + γ)) + WeilTransform.Psi (h * (ρ.im - γ))) ^ 2
      ≤ ((2 * Real.pi + Real.pi ^ 2) / (h * (ρ.im - γ)) ^ 2
          + (2 * Real.pi + Real.pi ^ 2) / (h * (ρ.im + γ)) ^ 2) ^ 2 := by
    rw [← sq_abs]
    exact pow_le_pow_left₀ (abs_nonneg _) habs 2
  have hh2 : 0 ≤ (h / 2) ^ 2 := by positivity
  exact mul_le_mul_of_nonneg_left hsq hh2

end

/-- info: 'WeilBackground.laplace_phi' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms laplace_phi

/-- info: 'WeilBackground.Psi_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Psi_bound

/-- info: 'WeilBackground.online_term_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms online_term_eq

/-- info: 'WeilBackground.online_term_le_far' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms online_term_le_far

end WeilBackground
