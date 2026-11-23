/-
CountEuler — block N3-E of `lean_stage3/design/countmodes.md`, from its section
"After the independent check". 2026-11-23.

No mode outside a disc holding the others. Under `H_π`, take `E < Θ` from block
N2. Let a zero `ρ₁` have `β₁ > E`, mode `z₁ = 2^ρ₁`, direction `ẑ₁ = z₁/|z₁|`, and
let `c = −κ·ẑ₁`, `κ ≥ 0`. If every other mode of a zero right of `σ` lies within
`r₀ < |z₁| + κ` of `c`, contradiction. The Euler transform
`b_m = Σ_{j≤m} C(m,j)·(−c)^(m−j)·a_{j+1}` of the segment sums of N2 is at most
`A·(m+1)²·2^E·(2^E + κ)^m`; by the binomial theorem inside the integral it is
`Σ' m(ρ)·∫₀^∞ ζ_s·(ζ_s − c)^m/(w − s) ds`, `ζ_s = z·e^(−s)`. Divided by
`N_m = ẑ₁^(m+1)·R^(m+1)/(m+1)`, `R = |z₁| + κ`, the other modes fade (the whole
segment stays in the disc), and the class of `ρ₁` tends to its weight
`Σ_class m(ρ)/w_ρ`. That weight is then zero, against positive real parts.

  binom_shift             Σ_j C(m,j)(−c)^(m−j) ζ^(j+1) = ζ·(ζ − c)^m
  zeta, seg, F, coefE     the point of the segment, the transformed integrand,
                            its integral, the coefficients
  transform_eq            Σ_j C(m,j)(−c)^(m−j)·J_{j+1}(w) = F w c m
  transform_le            ‖Σ_j C(m,j)(−c)^(m−j)·a_{j+1}‖ ≤ A(m+1)²X(X + ‖c‖)^m
  seg_in_ball, others_le  the segment stays in the ball; ‖F‖ ≤ ‖e^w‖r^m/|Im w|
  lor, integral_lor       the Cauchy weight 1/|w − s|², of integral π/|Im w|
  gf, Pc, Qc, Gc          the class profile g = p·e^(−s) + κ, the class integrand,
                            the correction g^n/(w − s)², the antiderivative
  class_main              ∫ P = R^(m+1)/((m+1)w) + (∫ g^(m+1)/(w − s)²)/(m+1)
  Nn, class_ratio         N_m = u^(m+1)R^(m+1)/(m+1); F/N_m = 1/w + ∫ (g/R)^(m+1)/(w − s)²
  class_lim, class_bound  the correction fades (dominated convergence); F/N_m stays
                            below (1 + π)/|Im w|
  others_ratio_le         ‖F/N_m‖ ≤ ‖e^w‖/(r|Im w|)·(m+1)(r/R)^(m+1)
  aSum, tsum_transform    a_k; the transform of a is Σ' m(ρ)·F(w_ρ, c, m)
  term_class, term_other  one zero: its limit over N_m and a summable bound
  core                    the contradiction, by dominated convergence over the zeros
  euler_exposed_false     H_π, 1/2 < σ < Θ ≤ 1, β ≤ Θ ⊢ ∃ E ∈ [σ, Θ), no exposed mode
                            right of E

The class error, by another route. The design's "the rest `o(R^n/n)` by dominated
convergence" is no direct dominated convergence in `s`: `n·(g/R)^(n−1)·e^(−s)`
concentrates at `s = 0` with mass near one and has no integrable bound uniform in `n`.
Integrating by parts first, with `G = −g^(m+1)/((m+1)(w − s))`, gives
`F/N_m = 1/w + ∫₀^∞ (g/R)^(m+1)/(w − s)² ds` exactly, and that integral does tend to
zero by dominated convergence under the Cauchy weight. The reviewer's explicit
bound `K/n + K·n·q^(n−1)` is not used.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.CountReduction
import Stage3.AliasClass
import Mathlib.Probability.Distributions.Cauchy

namespace CountEuler

open Finset Filter Topology Kadiri MeasureTheory

noncomputable section

/-! ### The binomial identity -/

/-- **The binomial identity of the transform.** For any `ζ`, `c` and `m`,
`Σ_{j≤m} C(m,j)·(−c)^(m−j)·ζ^(j+1) = ζ·(ζ − c)^m`. -/
theorem binom_shift (ζ c : ℂ) (m : ℕ) :
    ∑ j ∈ Finset.range (m + 1), (m.choose j : ℂ) * (-c) ^ (m - j) * ζ ^ (j + 1)
      = ζ * (ζ - c) ^ m := by
  rw [sub_eq_add_neg, add_pow, Finset.mul_sum]
  refine Finset.sum_congr rfl fun j _ => ?_
  ring

/-! ### The transformed segment -/

/-- The point of the segment of a mode at depth `s`: `ζ_s = e^w·e^(−s)`. -/
def zeta (w : ℂ) (s : ℝ) : ℂ := Complex.exp w * ((Real.exp (-s) : ℝ) : ℂ)

/-- The coefficient of the Euler transform: `C(m,j)·(−c)^(m−j)`. -/
def coefE (c : ℂ) (m j : ℕ) : ℂ := (m.choose j : ℂ) * (-c) ^ (m - j)

/-- The transformed integrand: `ζ_s·(ζ_s − c)^m/(w − s)`. -/
def seg (w c : ℂ) (m : ℕ) (s : ℝ) : ℂ := zeta w s * (zeta w s - c) ^ m / (w - s)

/-- The transformed segment integral: `∫₀^∞ ζ_s·(ζ_s − c)^m/(w − s) ds`. -/
def F (w c : ℂ) (m : ℕ) : ℂ := ∫ s in Set.Ioi (0:ℝ), seg w c m s

/-- The power of the point of the segment is the integrand of `J`:
`ζ_s^k/(w − s) = e^(k(w−s))/(w − s)`. -/
theorem zeta_pow (k : ℕ) (w : ℂ) (s : ℝ) :
    zeta w s ^ k / (w - s) = Complex.exp ((k:ℂ) * (w - s)) / (w - s) := by
  unfold zeta
  rw [Complex.ofReal_exp, ← Complex.exp_add, ← Complex.exp_nat_mul]
  congr 2
  push_cast
  ring

/-- `J k w` written with the point of the segment. -/
theorem J_eq_zeta (k : ℕ) (w : ℂ) :
    CountModes.J k w = ∫ s in Set.Ioi (0:ℝ), zeta w s ^ k / (w - s) := by
  unfold CountModes.J
  congr 1
  funext s
  rw [zeta_pow]

/-- For `1 ≤ k` and `Im w ≠ 0`, `ζ_s^k/(w − s)` is integrable on `s > 0`. -/
theorem integrable_zeta_pow {k : ℕ} (hk : 1 ≤ k) {w : ℂ} (hw : w.im ≠ 0) :
    IntegrableOn (fun s : ℝ => zeta w s ^ k / (w - s)) (Set.Ioi 0) :=
  (CountModes.integrable_J hk hw).congr_fun (fun s _ => (zeta_pow k w s).symm)
    measurableSet_Ioi

/-- The transformed integrand is the transform of the powers. -/
theorem seg_sum (w c : ℂ) (m : ℕ) (s : ℝ) :
    seg w c m s = ∑ j ∈ Finset.range (m + 1), coefE c m j * (zeta w s ^ (j + 1) / (w - s)) := by
  unfold seg coefE
  rw [← binom_shift, Finset.sum_div]
  refine Finset.sum_congr rfl fun j _ => ?_
  ring

/-- **The transform of the segment integrals.** For `Im w ≠ 0`,
`Σ_{j≤m} C(m,j)·(−c)^(m−j)·J_{j+1}(w) = ∫₀^∞ ζ_s·(ζ_s − c)^m/(w − s) ds`. -/
theorem transform_eq {w : ℂ} (hw : w.im ≠ 0) (c : ℂ) (m : ℕ) :
    ∑ j ∈ Finset.range (m + 1), coefE c m j * CountModes.J (j + 1) w = F w c m := by
  unfold F
  simp only [seg_sum]
  rw [integral_finsetSum]
  · refine Finset.sum_congr rfl fun j _ => ?_
    rw [integral_const_mul, J_eq_zeta]
  · intro j _
    exact (integrable_zeta_pow (by omega) hw).const_mul _

/-- info: 'CountEuler.transform_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms transform_eq

/-- **The size of the transform.** If `‖a_k‖ ≤ A·k²·X^k` for every `k ≥ 1`, with
`A, X ≥ 0`, then `‖Σ_{j≤m} C(m,j)·(−c)^(m−j)·a_{j+1}‖ ≤ A·(m+1)²·X·(X + ‖c‖)^m`. -/
theorem transform_le (a : ℕ → ℂ) {A X : ℝ} (hA : 0 ≤ A) (hX : 0 ≤ X)
    (ha : ∀ k : ℕ, 1 ≤ k → ‖a k‖ ≤ A * (k:ℝ) ^ 2 * X ^ k) (c : ℂ) (m : ℕ) :
    ‖∑ j ∈ Finset.range (m + 1), coefE c m j * a (j + 1)‖
      ≤ A * ((m:ℝ) + 1) ^ 2 * X * (X + ‖c‖) ^ m := by
  have hterm : ∀ j ∈ Finset.range (m + 1), ‖coefE c m j * a (j + 1)‖
      ≤ A * ((m:ℝ) + 1) ^ 2 * X * (X ^ j * ‖c‖ ^ (m - j) * (m.choose j : ℝ)) := by
    intro j hj
    have hjm : j + 1 ≤ m + 1 := Finset.mem_range.mp hj
    have h1 := ha (j + 1) (by omega)
    have hj1 : ((j + 1 : ℕ) : ℝ) ≤ (m:ℝ) + 1 := by exact_mod_cast hjm
    have hj2 : ((j + 1 : ℕ) : ℝ) ^ 2 ≤ ((m:ℝ) + 1) ^ 2 :=
      pow_le_pow_left₀ (by positivity) hj1 2
    unfold coefE
    rw [norm_mul, norm_mul, norm_pow, norm_neg, Complex.norm_natCast]
    calc (m.choose j : ℝ) * ‖c‖ ^ (m - j) * ‖a (j + 1)‖
        ≤ (m.choose j : ℝ) * ‖c‖ ^ (m - j) * (A * ((m:ℝ) + 1) ^ 2 * X ^ (j + 1)) := by
          refine mul_le_mul_of_nonneg_left (h1.trans ?_) (by positivity)
          exact mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_left hj2 hA) (by positivity)
      _ = _ := by ring
  refine (norm_sum_le _ _).trans ((Finset.sum_le_sum hterm).trans (le_of_eq ?_))
  rw [← Finset.mul_sum, add_pow X ‖c‖ m]

/-! ### The other modes -/

/-- **The segment stays in the ball.** If `‖c‖ ≤ r` and `‖z − c‖ ≤ r`, then
`‖z·t − c‖ ≤ r` for `0 ≤ t ≤ 1`: `z·t − c = t·(z − c) + (1 − t)·(−c)`. -/
theorem seg_in_ball {z c : ℂ} {r t : ℝ} (ht0 : 0 ≤ t) (ht1 : t ≤ 1) (hc : ‖c‖ ≤ r)
    (hz : ‖z - c‖ ≤ r) : ‖z * (t:ℂ) - c‖ ≤ r := by
  have e : z * (t:ℂ) - c = (t:ℂ) * (z - c) + ((1 - t : ℝ) : ℂ) * (-c) := by
    push_cast
    ring
  rw [e]
  calc _ ≤ ‖(t:ℂ) * (z - c)‖ + ‖((1 - t : ℝ) : ℂ) * (-c)‖ := norm_add_le _ _
    _ = t * ‖z - c‖ + (1 - t) * ‖c‖ := by
        rw [norm_mul, norm_mul, norm_neg, Complex.norm_real, Complex.norm_real,
          Real.norm_of_nonneg ht0, Real.norm_of_nonneg (by linarith)]
    _ ≤ t * r + (1 - t) * r :=
        add_le_add (mul_le_mul_of_nonneg_left hz ht0) (mul_le_mul_of_nonneg_left hc (by linarith))
    _ = r := by ring

/-- **One other mode.** For `Im w ≠ 0`, `‖c‖ ≤ r` and `‖e^w − c‖ ≤ r`, the
transformed segment integral is at most `‖e^w‖·r^m/|Im w|`. -/
theorem others_le {w c : ℂ} (hw : w.im ≠ 0) {r : ℝ} (hc : ‖c‖ ≤ r)
    (hz : ‖Complex.exp w - c‖ ≤ r) (m : ℕ) :
    ‖F w c m‖ ≤ ‖Complex.exp w‖ * r ^ m / |w.im| := by
  have hb : 0 < |w.im| := abs_pos.mpr hw
  have hr : 0 ≤ r := (norm_nonneg _).trans hc
  have hg : IntegrableOn (fun s : ℝ => ‖Complex.exp w‖ * r ^ m / |w.im| * Real.exp (-1 * s))
      (Set.Ioi 0) := (exp_neg_integrableOn_Ioi 0 one_pos).const_mul _
  unfold F
  refine (norm_integral_le_of_norm_le hg ?_).trans (le_of_eq ?_)
  · refine (ae_restrict_iff' measurableSet_Ioi).mpr (Eventually.of_forall fun s hs => ?_)
    have hs0 : 0 ≤ s := le_of_lt hs
    have he0 : 0 < Real.exp (-s) := Real.exp_pos _
    have he1 : Real.exp (-s) ≤ 1 := Real.exp_le_one_iff.mpr (by linarith)
    have hball := seg_in_ball he0.le he1 hc hz
    have hden : |w.im| ≤ ‖w - (s:ℂ)‖ := by simpa using Complex.abs_im_le_norm (w - (s:ℂ))
    have hpow : ‖Complex.exp w * ((Real.exp (-s) : ℝ) : ℂ) - c‖ ^ m ≤ r ^ m :=
      pow_le_pow_left₀ (norm_nonneg _) hball m
    unfold seg zeta
    rw [norm_div, norm_mul, norm_pow, norm_mul, Complex.norm_real,
      Real.norm_of_nonneg he0.le, neg_one_mul]
    rw [div_le_iff₀ (hb.trans_le hden)]
    calc ‖Complex.exp w‖ * Real.exp (-s) * ‖Complex.exp w * ((Real.exp (-s) : ℝ) : ℂ) - c‖ ^ m
        ≤ ‖Complex.exp w‖ * Real.exp (-s) * r ^ m :=
          mul_le_mul_of_nonneg_left hpow (by positivity)
      _ = ‖Complex.exp w‖ * r ^ m / |w.im| * Real.exp (-s) * |w.im| := by
          field_simp
      _ ≤ ‖Complex.exp w‖ * r ^ m / |w.im| * Real.exp (-s) * ‖w - (s:ℂ)‖ :=
          mul_le_mul_of_nonneg_left hden (by positivity)
  · rw [integral_const_mul, CountModes.integral_exp_neg_mul one_pos]
    ring

/-! ### The Cauchy weight -/

/-- The Cauchy weight of `w`: `((s − Re w)² + (Im w)²)⁻¹ = 1/|w − s|²`. -/
def lor (w : ℂ) (s : ℝ) : ℝ := ((s - w.re) ^ 2 + w.im ^ 2)⁻¹

/-- The Cauchy weight is nonnegative. -/
theorem lor_nonneg (w : ℂ) (s : ℝ) : 0 ≤ lor w s := by
  unfold lor
  positivity

/-- The Cauchy weight is `π/|Im w|` times the Cauchy density at `Re w` of scale `|Im w|`. -/
theorem lor_eq {w : ℂ} (hw : w.im ≠ 0) (s : ℝ) :
    lor w s = Real.pi / |w.im| * ProbabilityTheory.cauchyPDFReal w.re ‖w.im‖₊ s := by
  rw [ProbabilityTheory.cauchyPDFReal_def, coe_nnnorm, Real.norm_eq_abs, sq_abs]
  unfold lor
  have hb : 0 < |w.im| := abs_pos.mpr hw
  have hq : 0 < (s - w.re) ^ 2 + w.im ^ 2 :=
    add_pos_of_nonneg_of_pos (sq_nonneg _) (lt_of_le_of_ne (sq_nonneg _) (Ne.symm (pow_ne_zero 2 hw)))
  have hpi : 0 < Real.pi := Real.pi_pos
  field_simp

/-- For `Im w ≠ 0` the Cauchy weight is integrable on the line. -/
theorem integrable_lor {w : ℂ} (hw : w.im ≠ 0) : Integrable (lor w) :=
  ((ProbabilityTheory.integrable_cauchyPDFReal w.re (γ := ‖w.im‖₊)).const_mul
    (Real.pi / |w.im|)).congr (Eventually.of_forall fun s => (lor_eq hw s).symm)

/-- For `Im w ≠ 0` the Cauchy weight integrates to `π/|Im w|` over the line. -/
theorem integral_lor {w : ℂ} (hw : w.im ≠ 0) : ∫ s, lor w s = Real.pi / |w.im| := by
  simp_rw [lor_eq hw]
  rw [integral_const_mul, ProbabilityTheory.integral_cauchyPDFReal_eq_one _
    (nnnorm_ne_zero_iff.mpr hw), mul_one]

/-- For `Im w ≠ 0` the Cauchy weight integrates to at most `π/|Im w|` over `s > 0`. -/
theorem setIntegral_lor_le {w : ℂ} (hw : w.im ≠ 0) :
    ∫ s in Set.Ioi (0:ℝ), lor w s ≤ Real.pi / |w.im| :=
  (setIntegral_le_integral (integrable_lor hw) (Eventually.of_forall fun s => lor_nonneg w s)).trans
    (le_of_eq (integral_lor hw))

/-- `‖(w − s)²‖ = (s − Re w)² + (Im w)²`. -/
theorem norm_sub_sq (w : ℂ) (s : ℝ) : ‖(w - (s:ℂ)) ^ 2‖ = (s - w.re) ^ 2 + w.im ^ 2 := by
  rw [norm_pow, Complex.sq_norm, Complex.normSq_apply]
  simp
  ring

/-! ### The class of the exposed mode -/

/-- The real profile of the class: `g(s) = p·e^(−s) + κ`. -/
def gf (p κ s : ℝ) : ℝ := p * Real.exp (-s) + κ

/-- The profile is nonnegative for `p, κ ≥ 0`. -/
theorem gf_nonneg {p κ : ℝ} (hp : 0 ≤ p) (hκ : 0 ≤ κ) (s : ℝ) : 0 ≤ gf p κ s := by
  unfold gf
  positivity

/-- For `s ≥ 0` the profile is at most `p + κ`. -/
theorem gf_le {p κ : ℝ} (hp : 0 ≤ p) {s : ℝ} (hs : 0 ≤ s) : gf p κ s ≤ p + κ := by
  unfold gf
  have h1 : Real.exp (-s) ≤ 1 := Real.exp_le_one_iff.mpr (by linarith)
  have h2 := mul_le_of_le_one_right hp h1
  linarith

/-- For `s > 0` and `p > 0` the profile is below `p + κ`. -/
theorem gf_lt {p κ : ℝ} (hp : 0 < p) {s : ℝ} (hs : 0 < s) : gf p κ s < p + κ := by
  unfold gf
  have h1 : Real.exp (-s) < 1 := Real.exp_lt_one_iff.mpr (by linarith)
  have h2 := mul_lt_of_lt_one_right hp h1
  linarith

/-- At `s = 0` the profile is `p + κ`. -/
theorem gf_zero (p κ : ℝ) : gf p κ 0 = p + κ := by
  unfold gf
  simp

/-- The derivative of the profile: `−p·e^(−s)`. -/
theorem hasDerivAt_gf (p κ s : ℝ) : HasDerivAt (gf p κ) (p * (Real.exp (-s) * -1)) s :=
  (((hasDerivAt_neg s).exp).const_mul p).add_const κ

/-- The class integrand: `p·e^(−s)·g(s)^m/(w − s)`. -/
def Pc (w : ℂ) (p κ : ℝ) (m : ℕ) (s : ℝ) : ℂ :=
  ((p * Real.exp (-s) * gf p κ s ^ m : ℝ) : ℂ) / (w - s)

/-- The correction integrand: `g(s)^n/(w − s)²`. -/
def Qc (w : ℂ) (p κ : ℝ) (n : ℕ) (s : ℝ) : ℂ := ((gf p κ s ^ n : ℝ) : ℂ) / (w - s) ^ 2

/-- The antiderivative: `−g(s)^n/(n·(w − s))`. -/
def Gc (w : ℂ) (p κ : ℝ) (n : ℕ) (s : ℝ) : ℂ :=
  -(((gf p κ s ^ n : ℝ) : ℂ) / ((n:ℂ) * (w - s)))

/-- For `Im w ≠ 0`, `p, κ ≥ 0` the class integrand is integrable on `s > 0`. -/
theorem integrable_Pc {w : ℂ} (hw : w.im ≠ 0) {p κ : ℝ} (hp : 0 ≤ p) (hκ : 0 ≤ κ) (m : ℕ) :
    IntegrableOn (Pc w p κ m) (Set.Ioi 0) := by
  have hb : 0 < |w.im| := abs_pos.mpr hw
  have hg : IntegrableOn (fun s : ℝ => p * (p + κ) ^ m / |w.im| * Real.exp (-1 * s))
      (Set.Ioi 0) := (exp_neg_integrableOn_Ioi 0 one_pos).const_mul _
  have hc : Continuous (Pc w p κ m) := by
    unfold Pc
    exact Continuous.div (Complex.continuous_ofReal.comp (by unfold gf; fun_prop))
      (by fun_prop) (CountModes.sub_ofReal_ne_zero hw)
  refine Integrable.mono' hg hc.aestronglyMeasurable ?_
  refine (ae_restrict_iff' measurableSet_Ioi).mpr (Eventually.of_forall fun s hs => ?_)
  have hs0 : 0 ≤ s := le_of_lt hs
  have hden : |w.im| ≤ ‖w - (s:ℂ)‖ := by simpa using Complex.abs_im_le_norm (w - (s:ℂ))
  have hgle := gf_le (κ := κ) hp hs0
  have hg0 := gf_nonneg hp hκ s
  have he0 : 0 < Real.exp (-s) := Real.exp_pos _
  unfold Pc
  rw [norm_div, Complex.norm_real,
    Real.norm_of_nonneg (mul_nonneg (mul_nonneg hp he0.le) (pow_nonneg hg0 m)), neg_one_mul]
  rw [div_le_iff₀ (hb.trans_le hden)]
  calc p * Real.exp (-s) * gf p κ s ^ m ≤ p * Real.exp (-s) * (p + κ) ^ m :=
        mul_le_mul_of_nonneg_left (pow_le_pow_left₀ hg0 hgle m) (mul_nonneg hp he0.le)
    _ = p * (p + κ) ^ m / |w.im| * Real.exp (-s) * |w.im| := by field_simp
    _ ≤ p * (p + κ) ^ m / |w.im| * Real.exp (-s) * ‖w - (s:ℂ)‖ := by
        refine mul_le_mul_of_nonneg_left hden ?_
        have : 0 ≤ p + κ := by linarith
        positivity

/-- For `s ≥ 0` the correction integrand is at most `(p + κ)^n` times the Cauchy weight. -/
theorem norm_Qc_le {w : ℂ} {p κ : ℝ} (hp : 0 ≤ p) (hκ : 0 ≤ κ) {s : ℝ} (hs : 0 ≤ s) (n : ℕ) :
    ‖Qc w p κ n s‖ ≤ (p + κ) ^ n * lor w s := by
  unfold Qc
  rw [norm_div, Complex.norm_real, Real.norm_of_nonneg (pow_nonneg (gf_nonneg hp hκ s) n),
    norm_sub_sq]
  unfold lor
  rw [div_eq_mul_inv]
  exact mul_le_mul_of_nonneg_right (pow_le_pow_left₀ (gf_nonneg hp hκ s) (gf_le hp hs) n)
    (by positivity)

/-- For `Im w ≠ 0`, `p, κ ≥ 0` the correction integrand is integrable on `s > 0`. -/
theorem integrable_Qc {w : ℂ} (hw : w.im ≠ 0) {p κ : ℝ} (hp : 0 ≤ p) (hκ : 0 ≤ κ) (n : ℕ) :
    IntegrableOn (Qc w p κ n) (Set.Ioi 0) := by
  have hc : Continuous (Qc w p κ n) := by
    unfold Qc
    exact Continuous.div (Complex.continuous_ofReal.comp (by unfold gf; fun_prop))
      (by fun_prop) (fun s => pow_ne_zero 2 (CountModes.sub_ofReal_ne_zero hw s))
  refine Integrable.mono' (Integrable.const_mul (integrable_lor hw).integrableOn ((p + κ) ^ n))
    hc.aestronglyMeasurable ?_
  exact (ae_restrict_iff' measurableSet_Ioi).mpr
    (Eventually.of_forall fun s hs => norm_Qc_le hp hκ (le_of_lt hs) n)

/-- The derivative of the antiderivative: `G' = P − Q/(m + 1)`. -/
theorem hasDerivAt_Gc {w : ℂ} (hw : w.im ≠ 0) (p κ : ℝ) (m : ℕ) (s : ℝ) :
    HasDerivAt (Gc w p κ (m + 1)) (Pc w p κ m s - Qc w p κ (m + 1) s / ((m + 1 : ℕ) : ℂ)) s := by
  have hg := (hasDerivAt_gf p κ s).pow (m + 1)
  have hC := hg.ofReal_comp
  have hD : HasDerivAt (fun y : ℝ => w - (y:ℂ)) (-((1:ℝ):ℂ)) s :=
    ((hasDerivAt_id s).ofReal_comp).const_sub w
  have hD' := hD.const_mul (((m + 1 : ℕ) : ℂ))
  have hne : ((m + 1 : ℕ) : ℂ) * (w - (s:ℂ)) ≠ 0 :=
    mul_ne_zero (by exact_mod_cast Nat.succ_ne_zero m) (CountModes.sub_ofReal_ne_zero hw s)
  have h := (hC.div hD' hne).neg
  unfold Gc
  refine h.congr_deriv ?_
  have hws := CountModes.sub_ofReal_ne_zero hw s
  have hn : (m:ℂ) + 1 ≠ 0 := by exact_mod_cast Nat.succ_ne_zero m
  unfold Pc Qc
  simp only [Pi.pow_apply, Nat.add_sub_cancel]
  push_cast
  field_simp
  try ring

/-- The antiderivative tends to zero at infinity. -/
theorem tendsto_Gc (w : ℂ) {p κ : ℝ} (hp : 0 ≤ p) (hκ : 0 ≤ κ) (m : ℕ) :
    Tendsto (Gc w p κ (m + 1)) atTop (𝓝 0) := by
  have hlim : Tendsto (fun s : ℝ => (p + κ) ^ (m + 1) * (s + -‖w‖)⁻¹) atTop (𝓝 0) := by
    have h := (tendsto_inv_atTop_zero.comp
      (tendsto_atTop_add_const_right _ (-‖w‖) tendsto_id)).const_mul ((p + κ) ^ (m + 1))
    rw [mul_zero] at h
    exact h
  refine squeeze_zero_norm' ?_ hlim
  filter_upwards [eventually_gt_atTop (‖w‖ + 1)] with s hs
  have hs0 : 0 ≤ s := by linarith [norm_nonneg w]
  have hpos : 0 < s + -‖w‖ := by linarith
  have hden : s + -‖w‖ ≤ ‖w - (s:ℂ)‖ := by
    have h := norm_sub_norm_le (s:ℂ) w
    rw [Complex.norm_real, Real.norm_of_nonneg hs0, norm_sub_rev] at h
    linarith
  have hg0 := gf_nonneg hp hκ s
  have hn1 : (1:ℝ) ≤ ((m + 1 : ℕ) : ℝ) := by
    push_cast
    linarith [(m.cast_nonneg : (0:ℝ) ≤ m)]
  unfold Gc
  rw [norm_neg, norm_div, norm_mul, Complex.norm_real, Complex.norm_natCast,
    Real.norm_of_nonneg (pow_nonneg hg0 _), ← div_eq_mul_inv]
  refine div_le_div₀ (by positivity) (pow_le_pow_left₀ hg0 (gf_le hp hs0) _) hpos ?_
  calc s + -‖w‖ ≤ ‖w - (s:ℂ)‖ := hden
    _ ≤ ((m + 1 : ℕ) : ℝ) * ‖w - (s:ℂ)‖ := le_mul_of_one_le_left (norm_nonneg _) hn1

/-- **The class integral, exactly.** For `Im w ≠ 0`, `p, κ ≥ 0`, `R = p + κ`:
`∫₀^∞ p·e^(−s)·g(s)^m/(w − s) ds = R^(m+1)/((m+1)·w) + (∫₀^∞ g(s)^(m+1)/(w − s)² ds)/(m+1)`.
The antiderivative is `−g^(m+1)/((m+1)(w − s))`. -/
theorem class_main {w : ℂ} (hw : w.im ≠ 0) {p κ : ℝ} (hp : 0 ≤ p) (hκ : 0 ≤ κ) (m : ℕ) :
    ∫ s in Set.Ioi (0:ℝ), Pc w p κ m s
      = (((p + κ) ^ (m + 1) : ℝ) : ℂ) / (((m + 1 : ℕ) : ℂ) * w)
        + (∫ s in Set.Ioi (0:ℝ), Qc w p κ (m + 1) s) / ((m + 1 : ℕ) : ℂ) := by
  have hP := integrable_Pc hw hp hκ m
  have hQ : IntegrableOn (fun s => Qc w p κ (m + 1) s / ((m + 1 : ℕ) : ℂ)) (Set.Ioi 0) :=
    Integrable.div_const (integrable_Qc hw hp hκ (m + 1)) _
  have h := integral_Ioi_of_hasDerivAt_of_tendsto' (a := 0)
    (fun s _ => hasDerivAt_Gc hw p κ m s) (Integrable.sub hP hQ) (tendsto_Gc w hp hκ m)
  rw [integral_sub hP hQ, integral_div] at h
  have hG0 : Gc w p κ (m + 1) 0
      = -((((p + κ) ^ (m + 1) : ℝ) : ℂ) / (((m + 1 : ℕ) : ℂ) * w)) := by
    unfold Gc
    rw [gf_zero, Complex.ofReal_zero, sub_zero]
  rw [hG0] at h
  linear_combination h

/-- info: 'CountEuler.class_main' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms class_main

/-- On the class, `ζ_s·(ζ_s − c)^m/(w − s) = u^(m+1)·p·e^(−s)·g(s)^m/(w − s)`, for
`e^w = p·u` and `c = −κ·u`. -/
theorem seg_class {w u : ℂ} {p : ℝ} (hz : Complex.exp w = (p:ℂ) * u) (κ : ℝ) (m : ℕ) (s : ℝ) :
    seg w (-(κ:ℂ) * u) m s = u ^ (m + 1) * Pc w p κ m s := by
  unfold seg zeta Pc gf
  rw [hz]
  have e : (p:ℂ) * u * ((Real.exp (-s) : ℝ) : ℂ) - -(κ:ℂ) * u
      = u * ((p * Real.exp (-s) + κ : ℝ) : ℂ) := by
    push_cast
    ring
  rw [e, mul_pow]
  push_cast
  ring

/-- On the class, the transformed segment integral is `u^(m+1)·∫₀^∞ P`. -/
theorem F_class {w u : ℂ} {p : ℝ} (hz : Complex.exp w = (p:ℂ) * u) (κ : ℝ) (m : ℕ) :
    F w (-(κ:ℂ) * u) m = u ^ (m + 1) * ∫ s in Set.Ioi (0:ℝ), Pc w p κ m s := by
  unfold F
  simp only [seg_class hz]
  rw [integral_const_mul]

/-- The normaliser: `N_m = u^(m+1)·R^(m+1)/(m+1)`. -/
def Nn (u : ℂ) (R : ℝ) (m : ℕ) : ℂ := u ^ (m + 1) * ((R ^ (m + 1) : ℝ) : ℂ) / ((m + 1 : ℕ) : ℂ)

/-- For `‖u‖ = 1` and `R ≥ 0`, `‖N_m‖ = R^(m+1)/(m+1)`. -/
theorem norm_Nn {u : ℂ} (hu : ‖u‖ = 1) {R : ℝ} (hR : 0 ≤ R) (m : ℕ) :
    ‖Nn u R m‖ = R ^ (m + 1) / ((m + 1 : ℕ) : ℝ) := by
  unfold Nn
  rw [norm_div, norm_mul, norm_pow, hu, one_pow, one_mul, Complex.norm_real,
    Real.norm_of_nonneg (pow_nonneg hR _), Complex.norm_natCast]

/-- The normalised correction integrand: `(g(s)/(p + κ))^n/(w − s)²`. -/
def Qn (w : ℂ) (p κ : ℝ) (n : ℕ) (s : ℝ) : ℂ :=
  (((gf p κ s / (p + κ)) ^ n : ℝ) : ℂ) / (w - s) ^ 2

/-- For `s ≥ 0`, `p > 0`, `κ ≥ 0`, the normalised correction integrand is at most the
Cauchy weight. -/
theorem norm_Qn_le {w : ℂ} {p κ : ℝ} (hp : 0 < p) (hκ : 0 ≤ κ) {s : ℝ} (hs : 0 ≤ s) (n : ℕ) :
    ‖Qn w p κ n s‖ ≤ lor w s := by
  have hR : 0 < p + κ := by linarith
  have hq0 : 0 ≤ gf p κ s / (p + κ) := div_nonneg (gf_nonneg hp.le hκ s) hR.le
  have hq1 : gf p κ s / (p + κ) ≤ 1 := (div_le_one hR).mpr (gf_le hp.le hs)
  unfold Qn
  rw [norm_div, Complex.norm_real, Real.norm_of_nonneg (pow_nonneg hq0 _), norm_sub_sq]
  unfold lor
  rw [div_eq_mul_inv]
  exact mul_le_of_le_one_left (by positivity) (pow_le_one₀ hq0 hq1)

/-- For `Im w ≠ 0` the normalised correction integrand is continuous. -/
theorem continuous_Qn {w : ℂ} (hw : w.im ≠ 0) (p κ : ℝ) (n : ℕ) : Continuous (Qn w p κ n) := by
  unfold Qn
  exact Continuous.div (Complex.continuous_ofReal.comp (by unfold gf; fun_prop))
    (by fun_prop) (fun s => pow_ne_zero 2 (CountModes.sub_ofReal_ne_zero hw s))

/-- **The class over the normaliser.** For `Im w ≠ 0`, `p > 0`, `κ ≥ 0`, `‖u‖ = 1`
and `e^w = p·u`: `F w (−κu) m / N_m = 1/w + ∫₀^∞ (g/R)^(m+1)/(w − s)² ds`, `R = p + κ`. -/
theorem class_ratio {w u : ℂ} (hw : w.im ≠ 0) {p κ : ℝ} (hp : 0 < p) (hκ : 0 ≤ κ)
    (hu : ‖u‖ = 1) (hz : Complex.exp w = (p:ℂ) * u) (m : ℕ) :
    F w (-(κ:ℂ) * u) m / Nn u (p + κ) m
      = 1 / w + ∫ s in Set.Ioi (0:ℝ), Qn w p κ (m + 1) s := by
  have hR : 0 < p + κ := by linarith
  have hu0 : u ≠ 0 := by
    rw [← norm_ne_zero_iff, hu]
    norm_num
  have hw0 : w ≠ 0 := fun h => hw (by rw [h, Complex.zero_im])
  have hn : ((m + 1 : ℕ) : ℂ) ≠ 0 := by exact_mod_cast Nat.succ_ne_zero m
  have hRc : (((p + κ) ^ (m + 1) : ℝ) : ℂ) ≠ 0 := by exact_mod_cast (pow_pos hR _).ne'
  have hQ : ∫ s in Set.Ioi (0:ℝ), Qn w p κ (m + 1) s
      = (∫ s in Set.Ioi (0:ℝ), Qc w p κ (m + 1) s) / (((p + κ) ^ (m + 1) : ℝ) : ℂ) := by
    rw [← integral_div]
    congr 1
    funext s
    unfold Qn Qc
    rw [div_pow, Complex.ofReal_div]
    ring
  rw [F_class hz, class_main hw hp.le hκ m, hQ]
  unfold Nn
  field_simp
  try ring

/-- **The class correction fades.** For `Im w ≠ 0`, `p > 0`, `κ ≥ 0`:
`∫₀^∞ (g/R)^(m+1)/(w − s)² ds → 0`, by dominated convergence under the Cauchy weight;
`g(s) < R` for `s > 0`. -/
theorem class_lim {w : ℂ} (hw : w.im ≠ 0) {p κ : ℝ} (hp : 0 < p) (hκ : 0 ≤ κ) :
    Tendsto (fun m : ℕ => ∫ s in Set.Ioi (0:ℝ), Qn w p κ (m + 1) s) atTop (𝓝 0) := by
  have hR : 0 < p + κ := by linarith
  have h := tendsto_integral_of_dominated_convergence (μ := volume.restrict (Set.Ioi (0:ℝ)))
    (F := fun m : ℕ => fun s => Qn w p κ (m + 1) s) (f := fun _ => (0:ℂ)) (lor w)
    (fun m => (continuous_Qn hw p κ (m + 1)).aestronglyMeasurable)
    (integrable_lor hw).integrableOn
    (fun m => (ae_restrict_iff' measurableSet_Ioi).mpr
      (Eventually.of_forall fun s hs => norm_Qn_le hp hκ (le_of_lt hs) (m + 1))) ?_
  · rw [integral_zero] at h
    exact h
  refine (ae_restrict_iff' measurableSet_Ioi).mpr (Eventually.of_forall fun s hs => ?_)
  have hq0 : 0 ≤ gf p κ s / (p + κ) := div_nonneg (gf_nonneg hp.le hκ s) hR.le
  have hq1 : gf p κ s / (p + κ) < 1 := (div_lt_one hR).mpr (gf_lt hp hs)
  have h1 := (tendsto_pow_atTop_nhds_zero_of_lt_one hq0 hq1).comp (tendsto_add_atTop_nat 1)
  have h2 := ((Complex.continuous_ofReal.tendsto 0).comp h1).div_const ((w - (s:ℂ)) ^ 2)
  rw [Complex.ofReal_zero, zero_div] at h2
  exact h2

/-- For `Im w ≠ 0`, `p > 0`, `κ ≥ 0`, the class correction is at most `π/|Im w|`. -/
theorem norm_Qn_int_le {w : ℂ} (hw : w.im ≠ 0) {p κ : ℝ} (hp : 0 < p) (hκ : 0 ≤ κ) (n : ℕ) :
    ‖∫ s in Set.Ioi (0:ℝ), Qn w p κ n s‖ ≤ Real.pi / |w.im| :=
  (norm_integral_le_of_norm_le (integrable_lor hw).integrableOn
    ((ae_restrict_iff' measurableSet_Ioi).mpr
      (Eventually.of_forall fun _ hs => norm_Qn_le hp hκ (le_of_lt hs) n))).trans
    (setIntegral_lor_le hw)

/-- **The class tends to its weight.** Under the hypotheses of `class_ratio`,
`F w (−κu) m / N_m → 1/w`. -/
theorem class_tendsto {w u : ℂ} (hw : w.im ≠ 0) {p κ : ℝ} (hp : 0 < p) (hκ : 0 ≤ κ)
    (hu : ‖u‖ = 1) (hz : Complex.exp w = (p:ℂ) * u) :
    Tendsto (fun m : ℕ => F w (-(κ:ℂ) * u) m / Nn u (p + κ) m) atTop (𝓝 (1 / w)) := by
  have h := (class_lim hw hp hκ).const_add (1 / w)
  rw [add_zero] at h
  exact h.congr (fun m => (class_ratio hw hp hκ hu hz m).symm)

/-- **The class stays bounded.** Under the hypotheses of `class_ratio`,
`‖F w (−κu) m / N_m‖ ≤ (1 + π)/|Im w|`. -/
theorem class_bound {w u : ℂ} (hw : w.im ≠ 0) {p κ : ℝ} (hp : 0 < p) (hκ : 0 ≤ κ)
    (hu : ‖u‖ = 1) (hz : Complex.exp w = (p:ℂ) * u) (m : ℕ) :
    ‖F w (-(κ:ℂ) * u) m / Nn u (p + κ) m‖ ≤ (1 + Real.pi) / |w.im| := by
  rw [class_ratio hw hp hκ hu hz m]
  have hb : 0 < |w.im| := abs_pos.mpr hw
  have h1 : ‖1 / w‖ ≤ 1 / |w.im| := by
    rw [norm_div, norm_one]
    exact one_div_le_one_div_of_le hb (Complex.abs_im_le_norm w)
  calc _ ≤ ‖1 / w‖ + ‖∫ s in Set.Ioi (0:ℝ), Qn w p κ (m + 1) s‖ := norm_add_le _ _
    _ ≤ 1 / |w.im| + Real.pi / |w.im| := add_le_add h1 (norm_Qn_int_le hw hp hκ _)
    _ = (1 + Real.pi) / |w.im| := by ring

/-! ### The other modes over the normaliser -/

/-- **One other mode over the normaliser.** For `Im w ≠ 0`, `‖c‖ ≤ r`, `‖e^w − c‖ ≤ r`,
`0 < r`, `0 < R` and `‖u‖ = 1`:
`‖F w c m / N_m‖ ≤ ‖e^w‖/(r·|Im w|)·((m+1)·(r/R)^(m+1))`. -/
theorem others_ratio_le {w c u : ℂ} (hw : w.im ≠ 0) {r R : ℝ} (hc : ‖c‖ ≤ r)
    (hz : ‖Complex.exp w - c‖ ≤ r) (hr : 0 < r) (hR : 0 < R) (hu : ‖u‖ = 1) (m : ℕ) :
    ‖F w c m / Nn u R m‖
      ≤ ‖Complex.exp w‖ / (r * |w.im|) * (((m + 1 : ℕ) : ℝ) * (r / R) ^ (m + 1)) := by
  have hb : 0 < |w.im| := abs_pos.mpr hw
  have hn : (0:ℝ) < ((m + 1 : ℕ) : ℝ) := by exact_mod_cast Nat.succ_pos m
  rw [norm_div, norm_Nn hu hR.le m]
  have hRm : 0 < R ^ (m + 1) / ((m + 1 : ℕ) : ℝ) := by positivity
  refine (div_le_div_of_nonneg_right (others_le hw hc hz m) hRm.le).trans (le_of_eq ?_)
  rw [div_pow, pow_succ r m]
  field_simp

/-! ### The zeros right of `σ` -/

/-- The order of a zero, as a complex number. -/
def ordC (ρ : NontrivialZeros) : ℂ := ((riemannZeta.order (ρ:ℂ) : ℤ) : ℂ)

/-- The exponent of a zero's mode: `w = ρ·log 2`. -/
def wz (ρ : NontrivialZeros) : ℂ := (ρ:ℂ) * Real.log 2

/-- The segment sum of block N2: `a_k = Σ'_{β≥σ} m(ρ)·J_k(ρ·log 2)`. -/
def aSum (σ : ℝ) (k : ℕ) : ℂ :=
  ∑' ρ : {ρ : NontrivialZeros // σ ≤ (ρ:ℂ).re}, ordC ρ.1 * CountModes.J k (wz ρ.1)

/-- `2^ρ = e^(ρ·log 2)`. -/
theorem two_cpow_eq (ρ : ℂ) : (2:ℂ) ^ ρ = Complex.exp (ρ * Real.log 2) := by
  rw [Complex.cpow_def_of_ne_zero two_ne_zero, Complex.ofReal_log (by norm_num : (0:ℝ) ≤ 2),
    Complex.ofReal_ofNat, mul_comm]

/-- The order of a zero, as a factor, multiplies the size by the order. -/
theorem norm_ordC_mul (ρ : NontrivialZeros) (x : ℂ) :
    ‖ordC ρ * x‖ = FiniteOffLinePi.ordR ρ * ‖x‖ :=
  FiniteOffLinePi.norm_order_mul ρ x

/-- The weight of a zero's class has positive real part: `Re(m(ρ)/(ρ·log 2)) > 0`. -/
theorem re_ord_div_w_pos (ρ : NontrivialZeros) : 0 < (ordC ρ * (1 / wz ρ)).re := by
  have hL : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hρ : (ρ:ℂ) ≠ 0 := fun h => by
    have := ρ.2.1.1
    rw [h] at this
    simp at this
  have hL' : ((Real.log 2 : ℝ) : ℂ) ≠ 0 := by exact_mod_cast hL.ne'
  have e : ordC ρ * (1 / wz ρ)
      = (((riemannZeta.order (ρ:ℂ) : ℤ) : ℂ) / (ρ:ℂ)) * ((1 / Real.log 2 : ℝ) : ℂ) := by
    unfold ordC wz
    push_cast
    field_simp
  rw [e, Complex.re_mul_ofReal]
  exact mul_pos (AliasClass.re_order_div_pos ρ) (by positivity)

/-- For `σ > 1/2` the weights `m(ρ)/|Im w_ρ|` of the zeros right of `σ` are summable:
`1/|γ| ≤ cim/|ρ|` (`CountReduction.inv_abs_im_le`) and `ZeroSummable.summable_order_div`. -/
theorem summable_ord_im {σ : ℝ} (hσ : 1/2 < σ) :
    Summable fun ρ : {ρ : NontrivialZeros // σ ≤ (ρ:ℂ).re} =>
      FiniteOffLinePi.ordR ρ.1 / |(wz ρ.1).im| := by
  refine Summable.of_nonneg_of_le
    (fun ρ => div_nonneg (FiniteOffLinePi.ordR_nonneg _) (abs_nonneg _)) (fun ρ => ?_)
    ((ZeroSummable.summable_order_div hσ).mul_left (CountReduction.cim / Real.log 2))
  have hL : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hγ : 0 < |(ρ.1 : ℂ).im| := abs_pos.mpr (CountModes.im_ne_zero ρ.1)
  have hn : 0 < ‖(ρ.1 : ℂ)‖ := lt_of_lt_of_le hγ (Complex.abs_im_le_norm _)
  have him : |(wz ρ.1).im| = |(ρ.1:ℂ).im| * Real.log 2 := by
    unfold wz
    rw [CountModes.im_w, abs_mul, abs_of_pos hL]
  rw [him]
  have hinv := CountReduction.inv_abs_im_le ρ.1
  have h0 := FiniteOffLinePi.ordR_nonneg ρ.1
  calc FiniteOffLinePi.ordR ρ.1 / (|(ρ.1:ℂ).im| * Real.log 2)
      = FiniteOffLinePi.ordR ρ.1 * |(ρ.1:ℂ).im|⁻¹ / Real.log 2 := by
        field_simp
    _ ≤ FiniteOffLinePi.ordR ρ.1 * (CountReduction.cim * ‖(ρ.1:ℂ)‖⁻¹) / Real.log 2 :=
        div_le_div_of_nonneg_right (mul_le_mul_of_nonneg_left hinv h0) hL.le
    _ = CountReduction.cim / Real.log 2 * (((riemannZeta.order ((ρ.1:NontrivialZeros):ℂ) : ℤ) : ℝ)
          / ‖((ρ.1:NontrivialZeros):ℂ)‖) := by
        unfold FiniteOffLinePi.ordR
        field_simp

/-- **The transform as a sum over the zeros.** For `σ > 1/2`:
`Σ_{j≤m} C(m,j)·(−c)^(m−j)·a_{j+1} = Σ'_{β≥σ} m(ρ)·F(w_ρ, c, m)`. The finite sum over
`j` passes through the sum over the zeros, each `j` summable by `summable_J`. -/
theorem tsum_transform {σ : ℝ} (hσ : 1/2 < σ) (c : ℂ) (m : ℕ) :
    ∑ j ∈ Finset.range (m + 1), coefE c m j * aSum σ (j + 1)
      = ∑' ρ : {ρ : NontrivialZeros // σ ≤ (ρ:ℂ).re}, ordC ρ.1 * F (wz ρ.1) c m := by
  have hs : ∀ j ∈ Finset.range (m + 1), Summable fun ρ : {ρ : NontrivialZeros // σ ≤ (ρ:ℂ).re} =>
      coefE c m j * (ordC ρ.1 * CountModes.J (j + 1) (wz ρ.1)) :=
    fun j _ => ((CountReduction.summable_J hσ (Nat.le_add_left 1 j)).of_norm).mul_left _
  unfold aSum
  simp_rw [← tsum_mul_left]
  rw [← Summable.tsum_finsetSum hs]
  refine tsum_congr fun ρ => ?_
  have hw : (wz ρ.1).im ≠ 0 := CountModes.w_im_ne_zero ρ.1
  rw [← transform_eq hw c m, Finset.mul_sum]
  refine Finset.sum_congr rfl fun j _ => ?_
  ring

/-- **A zero of the class.** If `e^(w_ρ) = p·u`, `p > 0`, `‖u‖ = 1`, `c = −κu`,
`R = p + κ`, then `m(ρ)·F/N_m → m(ρ)/w_ρ`, and every term is at most
`K₃·m(ρ)/|Im w_ρ|` for `K₃ ≥ 1 + π`. -/
theorem term_class {ρ : NontrivialZeros} {p κ R K₃ : ℝ} {u c : ℂ} (hp : 0 < p) (hκ : 0 ≤ κ)
    (hu : ‖u‖ = 1) (hz : Complex.exp (wz ρ) = (p:ℂ) * u) (hc : c = -(κ:ℂ) * u)
    (hR : R = p + κ) (hK₃ : 1 + Real.pi ≤ K₃) :
    Tendsto (fun m : ℕ => ordC ρ * (F (wz ρ) c m / Nn u R m)) atTop (𝓝 (ordC ρ * (1 / wz ρ)))
    ∧ ∀ m : ℕ, ‖ordC ρ * (F (wz ρ) c m / Nn u R m)‖
      ≤ K₃ * (FiniteOffLinePi.ordR ρ / |(wz ρ).im|) := by
  subst hc hR
  have hw : (wz ρ).im ≠ 0 := CountModes.w_im_ne_zero ρ
  have hb : 0 < |(wz ρ).im| := abs_pos.mpr hw
  refine ⟨(class_tendsto hw hp hκ hu hz).const_mul _, fun m => ?_⟩
  rw [norm_ordC_mul]
  have h0 := FiniteOffLinePi.ordR_nonneg ρ
  calc FiniteOffLinePi.ordR ρ * ‖F (wz ρ) (-(κ:ℂ) * u) m / Nn u (p + κ) m‖
      ≤ FiniteOffLinePi.ordR ρ * ((1 + Real.pi) / |(wz ρ).im|) :=
        mul_le_mul_of_nonneg_left (class_bound hw hp hκ hu hz m) h0
    _ ≤ FiniteOffLinePi.ordR ρ * (K₃ / |(wz ρ).im|) :=
        mul_le_mul_of_nonneg_left (div_le_div_of_nonneg_right hK₃ hb.le) h0
    _ = _ := by ring

/-- **A zero off the class.** If `‖c‖ ≤ r`, `‖e^(w_ρ) − c‖ ≤ r`, `0 < r < R`, `‖u‖ = 1`
and `(m+1)·(r/R)^(m+1) ≤ K` for every `m`, then `m(ρ)·F/N_m → 0`, and every term is at
most `K₃·m(ρ)/|Im w_ρ|` for `K₃ ≥ 2K/r`. -/
theorem term_other {ρ : NontrivialZeros} {c u : ℂ} {r R K K₃ : ℝ} (hc : ‖c‖ ≤ r)
    (hz : ‖Complex.exp (wz ρ) - c‖ ≤ r) (hr : 0 < r) (hR : 0 < R) (hrR : r < R)
    (hu : ‖u‖ = 1) (hK : ∀ m : ℕ, ((m + 1 : ℕ) : ℝ) * (r / R) ^ (m + 1) ≤ K)
    (hK₃ : 2 * K / r ≤ K₃) :
    Tendsto (fun m : ℕ => ordC ρ * (F (wz ρ) c m / Nn u R m)) atTop (𝓝 0)
    ∧ ∀ m : ℕ, ‖ordC ρ * (F (wz ρ) c m / Nn u R m)‖
      ≤ K₃ * (FiniteOffLinePi.ordR ρ / |(wz ρ).im|) := by
  have hw : (wz ρ).im ≠ 0 := CountModes.w_im_ne_zero ρ
  have hb : 0 < |(wz ρ).im| := abs_pos.mpr hw
  have h0 := FiniteOffLinePi.ordR_nonneg ρ
  have he : ‖Complex.exp (wz ρ)‖ ≤ 2 := by
    unfold wz
    rw [← two_cpow_eq, FiniteOffLine.norm_two_cpow]
    calc (2:ℝ) ^ (ρ:ℂ).re ≤ (2:ℝ) ^ (1:ℝ) :=
          Real.rpow_le_rpow_of_exponent_le (by norm_num) ρ.2.1.2.le
      _ = 2 := Real.rpow_one 2
  have hpt : ∀ m : ℕ, ‖ordC ρ * (F (wz ρ) c m / Nn u R m)‖
      ≤ FiniteOffLinePi.ordR ρ * (2 / (r * |(wz ρ).im|))
        * (((m + 1 : ℕ) : ℝ) * (r / R) ^ (m + 1)) := by
    intro m
    rw [norm_ordC_mul, mul_assoc]
    refine mul_le_mul_of_nonneg_left ((others_ratio_le hw hc hz hr hR hu m).trans ?_) h0
    exact mul_le_mul_of_nonneg_right (div_le_div_of_nonneg_right he (by positivity))
      (by positivity)
  refine ⟨?_, fun m => ?_⟩
  · have hq0 : 0 ≤ r / R := by positivity
    have hq1 : |r / R| < 1 := by
      rw [abs_of_nonneg hq0]
      exact (div_lt_one hR).mpr hrR
    have h1 := ((tendsto_pow_const_mul_const_pow_of_abs_lt_one 1 hq1).comp
      (tendsto_add_atTop_nat 1)).const_mul (FiniteOffLinePi.ordR ρ * (2 / (r * |(wz ρ).im|)))
    rw [mul_zero] at h1
    refine squeeze_zero_norm (fun m => (hpt m).trans (le_of_eq ?_)) h1
    simp only [Function.comp_apply, pow_one]
  · refine (hpt m).trans ?_
    calc _ ≤ FiniteOffLinePi.ordR ρ * (2 / (r * |(wz ρ).im|)) * K :=
          mul_le_mul_of_nonneg_left (hK m) (by positivity)
      _ = 2 * K / r * (FiniteOffLinePi.ordR ρ / |(wz ρ).im|) := by
          field_simp
      _ ≤ K₃ * (FiniteOffLinePi.ordR ρ / |(wz ρ).im|) :=
          mul_le_mul_of_nonneg_right hK₃ (by positivity)

/-! ### The contradiction -/

/-- **The core of block N3-E.** Let `σ > 1/2`, `σ ≤ E`, and let the segment sums
satisfy `‖a_k‖ ≤ A·k²·2^(kE)` for `k ≥ 2`. Let `ρ₁` have `β₁ > E`, `z₁ = 2^ρ₁`,
`u = z₁/|z₁|`, `κ ≥ 0`, and let every other mode of a zero right of `σ` lie within
`r₀ < |z₁| + κ` of `−κu`. Then contradiction. -/
theorem core {σ E A : ℝ} (hσ : 1/2 < σ) (hσE : σ ≤ E)
    (hA : ∀ k : ℕ, 2 ≤ k → ‖aSum σ k‖ ≤ A * (k:ℝ)^2 * (2:ℝ)^((k:ℝ) * E))
    (ρ₁ : NontrivialZeros) (hρ₁ : E < (ρ₁:ℂ).re) {κ r₀ : ℝ} (hκ : 0 ≤ κ)
    (hr₀ : r₀ < ‖(2:ℂ)^(ρ₁:ℂ)‖ + κ)
    (hball : ∀ ρ : NontrivialZeros, σ ≤ (ρ:ℂ).re → (2:ℂ)^(ρ:ℂ) ≠ (2:ℂ)^(ρ₁:ℂ) →
      ‖(2:ℂ)^(ρ:ℂ) + (κ:ℂ) * ((2:ℂ)^(ρ₁:ℂ) / ‖(2:ℂ)^(ρ₁:ℂ)‖)‖ ≤ r₀) : False := by
  classical
  -- the mode of ρ₁, its size and direction
  obtain ⟨z₁, hz₁⟩ : ∃ z : ℂ, z = (2:ℂ)^(ρ₁:ℂ) := ⟨_, rfl⟩
  rw [← hz₁] at hr₀ hball
  obtain ⟨p, hpdef⟩ : ∃ p : ℝ, p = ‖z₁‖ := ⟨_, rfl⟩
  rw [← hpdef] at hr₀ hball
  have hpe : p = (2:ℝ) ^ (ρ₁:ℂ).re := by rw [hpdef, hz₁, FiniteOffLine.norm_two_cpow]
  have hp : 0 < p := by rw [hpe]; positivity
  have hpc : (p:ℂ) ≠ 0 := by exact_mod_cast hp.ne'
  obtain ⟨u, hudef⟩ : ∃ u : ℂ, u = z₁ / (p:ℂ) := ⟨_, rfl⟩
  rw [← hudef] at hball
  have hu : ‖u‖ = 1 := by
    rw [hudef, norm_div, Complex.norm_real, Real.norm_of_nonneg hp.le, ← hpdef, div_self hp.ne']
  have hzu : z₁ = (p:ℂ) * u := by
    rw [hudef]
    field_simp
  obtain ⟨R, hRdef⟩ : ∃ R : ℝ, R = p + κ := ⟨_, rfl⟩
  have hR : 0 < R := by rw [hRdef]; linarith
  obtain ⟨c, hcdef⟩ : ∃ c : ℂ, c = -(κ:ℂ) * u := ⟨_, rfl⟩
  have hcn : ‖c‖ = κ := by
    rw [hcdef, norm_mul, norm_neg, Complex.norm_real, Real.norm_of_nonneg hκ, hu, mul_one]
  -- the radius
  obtain ⟨r, hrdef⟩ : ∃ r : ℝ, r = max r₀ (max κ (R / 2)) := ⟨_, rfl⟩
  have hR2 : R / 2 ≤ r := by rw [hrdef]; exact (le_max_right κ (R / 2)).trans (le_max_right _ _)
  have hr0 : 0 < r := lt_of_lt_of_le (by linarith) hR2
  have hκr : κ ≤ r := by rw [hrdef]; exact (le_max_left κ (R / 2)).trans (le_max_right _ _)
  have hrR : r < R := by
    rw [hrdef]
    exact max_lt (by rw [hRdef]; exact hr₀) (max_lt (by rw [hRdef]; linarith) (by linarith))
  have hr₀r : r₀ ≤ r := by rw [hrdef]; exact le_max_left _ _
  have hcr : ‖c‖ ≤ r := by rw [hcn]; exact hκr
  -- the other modes lie in the ball
  have hoth : ∀ ρ : NontrivialZeros, σ ≤ (ρ:ℂ).re → (2:ℂ)^(ρ:ℂ) ≠ z₁ →
      ‖Complex.exp (wz ρ) - c‖ ≤ r := by
    intro ρ hρ hne
    have e : Complex.exp (wz ρ) - c = (2:ℂ)^(ρ:ℂ) + (κ:ℂ) * u := by
      unfold wz
      rw [← two_cpow_eq, hcdef]
      ring
    rw [e]
    exact (hball ρ hρ hne).trans hr₀r
  -- the segment sums at every k ≥ 1
  obtain ⟨X, hXdef⟩ : ∃ X : ℝ, X = (2:ℝ) ^ E := ⟨_, rfl⟩
  have hX1 : 1 ≤ X := by rw [hXdef]; exact Real.one_le_rpow (by norm_num) (by linarith)
  have hX0 : 0 ≤ X := by linarith
  have hXp : X < p := by
    rw [hXdef, hpe]
    exact Real.rpow_lt_rpow_of_exponent_lt (by norm_num) hρ₁
  obtain ⟨A₂, hA₂⟩ : ∃ A₂ : ℝ, A₂ = |A| + ‖aSum σ 1‖ := ⟨_, rfl⟩
  have hA₂0 : 0 ≤ A₂ := by rw [hA₂]; positivity
  have ha : ∀ k : ℕ, 1 ≤ k → ‖aSum σ k‖ ≤ A₂ * (k:ℝ) ^ 2 * X ^ k := by
    intro k hk
    have hXk : (2:ℝ) ^ ((k:ℝ) * E) = X ^ k := by
      rw [hXdef, mul_comm, Real.rpow_mul (by norm_num), Real.rpow_natCast]
    have hXk1 : 1 ≤ X ^ k := one_le_pow₀ hX1
    rcases Nat.lt_or_ge k 2 with hk2 | hk2
    · obtain rfl : k = 1 := by omega
      have h1 : ‖aSum σ 1‖ ≤ A₂ := by rw [hA₂]; linarith [abs_nonneg A]
      calc ‖aSum σ 1‖ ≤ A₂ := h1
        _ ≤ A₂ * X := le_mul_of_one_le_right hA₂0 hX1
        _ = A₂ * ((1:ℕ):ℝ) ^ 2 * X ^ 1 := by simp
    · have h := hA k hk2
      rw [hXk] at h
      refine h.trans ?_
      have hAA : A ≤ A₂ := by rw [hA₂]; linarith [le_abs_self A, norm_nonneg (aSum σ 1)]
      exact mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_right hAA (by positivity))
        (by positivity)
  -- the transform over the normaliser tends to zero
  have hXκ : 0 < X + κ := by linarith
  have hq0 : 0 ≤ (X + κ) / R := by positivity
  have hq1 : |(X + κ) / R| < 1 := by
    rw [abs_of_nonneg hq0]
    exact (div_lt_one hR).mpr (by rw [hRdef]; linarith)
  have hlim3 := ((tendsto_pow_const_mul_const_pow_of_abs_lt_one 3 hq1).comp
    (tendsto_add_atTop_nat 1)).const_mul (A₂ * X / (X + κ))
  rw [mul_zero] at hlim3
  have hbN : Tendsto (fun m : ℕ =>
      (∑ j ∈ Finset.range (m + 1), coefE c m j * aSum σ (j + 1)) / Nn u R m) atTop (𝓝 0) := by
    refine squeeze_zero_norm (fun m => ?_) hlim3
    rw [norm_div, norm_Nn hu hR.le m]
    have hT := transform_le (aSum σ) hA₂0 hX0 ha c m
    rw [hcn] at hT
    have hn : (0:ℝ) < ((m + 1 : ℕ) : ℝ) := by exact_mod_cast Nat.succ_pos m
    have hRm : 0 < R ^ (m + 1) / ((m + 1 : ℕ) : ℝ) := by positivity
    refine (div_le_div_of_nonneg_right hT hRm.le).trans (le_of_eq ?_)
    simp only [Function.comp_apply]
    rw [div_pow, pow_succ (X + κ) m]
    push_cast
    field_simp
    try ring
  have hsum_eq : ∀ m : ℕ,
      (∑ j ∈ Finset.range (m + 1), coefE c m j * aSum σ (j + 1)) / Nn u R m
        = ∑' ρ : {ρ : NontrivialZeros // σ ≤ (ρ:ℂ).re}, ordC ρ.1 * (F (wz ρ.1) c m / Nn u R m) := by
    intro m
    rw [tsum_transform hσ c m, ← tsum_div_const]
    refine tsum_congr fun ρ => ?_
    ring
  -- the constants of the domination
  obtain ⟨K, hKdef⟩ : ∃ K : ℝ, K = ∑' n : ℕ, (n:ℝ) * (r / R) ^ n := ⟨_, rfl⟩
  have hqr0 : 0 ≤ r / R := by positivity
  have hqr1 : r / R < 1 := (div_lt_one hR).mpr hrR
  have hKs : Summable fun n : ℕ => (n:ℝ) * (r / R) ^ n := by
    have h := summable_pow_mul_geometric_of_norm_lt_one 1 (r := r / R)
      (by rw [Real.norm_of_nonneg hqr0]; exact hqr1)
    simpa using h
  have hKle : ∀ m : ℕ, ((m + 1 : ℕ) : ℝ) * (r / R) ^ (m + 1) ≤ K := fun m => by
    rw [hKdef]
    exact hKs.le_tsum (m + 1) (fun j _ => by positivity)
  have hK0 : 0 ≤ K := by rw [hKdef]; exact tsum_nonneg fun n => by positivity
  obtain ⟨K₃, hK₃⟩ : ∃ K₃ : ℝ, K₃ = 2 * K / r + (1 + Real.pi) := ⟨_, rfl⟩
  have hK₃a : 1 + Real.pi ≤ K₃ := by
    rw [hK₃]
    have : 0 ≤ 2 * K / r := by positivity
    linarith
  have hK₃b : 2 * K / r ≤ K₃ := by
    rw [hK₃]
    linarith [Real.pi_pos]
  -- each zero: its limit and its bound
  have hterm : ∀ ρ : {ρ : NontrivialZeros // σ ≤ (ρ:ℂ).re},
      Tendsto (fun m : ℕ => ordC ρ.1 * (F (wz ρ.1) c m / Nn u R m)) atTop
        (𝓝 (if (2:ℂ)^((ρ.1:NontrivialZeros):ℂ) = z₁ then ordC ρ.1 * (1 / wz ρ.1) else 0))
      ∧ ∀ m : ℕ, ‖ordC ρ.1 * (F (wz ρ.1) c m / Nn u R m)‖
        ≤ K₃ * (FiniteOffLinePi.ordR ρ.1 / |(wz ρ.1).im|) := by
    intro ρ
    by_cases hcl : (2:ℂ)^((ρ.1:NontrivialZeros):ℂ) = z₁
    · rw [if_pos hcl]
      have hz : Complex.exp (wz ρ.1) = (p:ℂ) * u := by
        unfold wz
        rw [← two_cpow_eq, hcl, hzu]
      exact term_class hp hκ hu hz hcdef hRdef hK₃a
    · rw [if_neg hcl]
      exact term_other hcr (hoth ρ.1 ρ.2 hcl) hr0 hR hrR hu hKle hK₃b
  have hD := (summable_ord_im hσ).mul_left K₃
  have hdom := tendsto_tsum_of_dominated_convergence (𝓕 := atTop)
    (f := fun (m : ℕ) (ρ : {ρ : NontrivialZeros // σ ≤ (ρ:ℂ).re}) =>
      ordC ρ.1 * (F (wz ρ.1) c m / Nn u R m))
    (g := fun ρ => if (2:ℂ)^((ρ.1:NontrivialZeros):ℂ) = z₁ then ordC ρ.1 * (1 / wz ρ.1) else 0)
    hD (fun ρ => (hterm ρ).1) (Eventually.of_forall fun m ρ => (hterm ρ).2 m)
  have hzero := tendsto_nhds_unique hdom (hbN.congr hsum_eq)
  -- the weight of the class of ρ₁ is zero, against positive real parts
  have hs : Summable fun ρ : {ρ : NontrivialZeros // σ ≤ (ρ:ℂ).re} =>
      (if (2:ℂ)^((ρ.1:NontrivialZeros):ℂ) = z₁ then ordC ρ.1 * (1 / wz ρ.1) else 0) :=
    Summable.of_norm_bounded hD (fun ρ =>
      le_of_tendsto' ((hterm ρ).1.norm) (fun m => (hterm ρ).2 m))
  have hre := Complex.re_tsum hs
  rw [hzero, Complex.zero_re] at hre
  have hnn : ∀ ρ : {ρ : NontrivialZeros // σ ≤ (ρ:ℂ).re},
      0 ≤ ((if (2:ℂ)^((ρ.1:NontrivialZeros):ℂ) = z₁ then ordC ρ.1 * (1 / wz ρ.1) else 0) : ℂ).re := by
    intro ρ
    split_ifs
    · exact (re_ord_div_w_pos ρ.1).le
    · rw [Complex.zero_re]
  have hmem : σ ≤ (ρ₁:ℂ).re := by linarith
  have hpos := Summable.tsum_pos (Complex.hasSum_re hs.hasSum).summable hnn ⟨ρ₁, hmem⟩
    (by
      rw [if_pos hz₁.symm]
      exact re_ord_div_w_pos ρ₁)
  linarith

/-- **No mode outside a disc holding the others** (block N3-E). Let the count of primes
at the doublings stay within `C·k²·√2^k` of `Li`, let `1/2 < σ < Θ ≤ 1`, and let every
zero have real part at most `Θ`. Then there is `E` with `σ ≤ E < Θ` such that no zero
`ρ₁` with real part above `E` has its mode `z₁ = 2^ρ₁` strictly outside a disc, centred
at `−κ·z₁/|z₁|` (`κ ≥ 0`) on the ray opposite to it, of radius `r₀ < |z₁| + κ`, which
holds every other mode of the zeros right of `σ`. -/
theorem euler_exposed_false {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → |(Nat.primeCounting ⌊(2:ℝ)^k⌋₊ : ℝ) - Stage3.Li ((2:ℝ)^k)|
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    {σ Θ : ℝ} (hσ : 1/2 < σ) (hσΘ : σ < Θ) (hΘ1 : Θ ≤ 1)
    (hΘ : ∀ ρ : Kadiri.NontrivialZeros, (ρ:ℂ).re ≤ Θ) :
    ∃ E : ℝ, σ ≤ E ∧ E < Θ ∧ ∀ (ρ₁ : Kadiri.NontrivialZeros), E < (ρ₁:ℂ).re →
      ∀ κ r₀ : ℝ, 0 ≤ κ → r₀ < ‖(2:ℂ)^(ρ₁:ℂ)‖ + κ →
      (∀ ρ : Kadiri.NontrivialZeros, σ ≤ (ρ:ℂ).re → (2:ℂ)^(ρ:ℂ) ≠ (2:ℂ)^(ρ₁:ℂ) →
        ‖(2:ℂ)^(ρ:ℂ) + (κ:ℂ) * ((2:ℂ)^(ρ₁:ℂ) / ‖(2:ℂ)^(ρ₁:ℂ)‖)‖ ≤ r₀) → False := by
  obtain ⟨E, A, hσE, hEΘ, hA⟩ := CountReduction.count_modes_small hH hσ hσΘ hΘ1 hΘ
  exact ⟨E, hσE, hEΘ, fun ρ₁ hρ₁ κ r₀ hκ hr₀ hball =>
    core hσ hσE hA ρ₁ hρ₁ hκ hr₀ hball⟩

/-- info: 'CountEuler.euler_exposed_false' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms euler_exposed_false

end

end CountEuler
