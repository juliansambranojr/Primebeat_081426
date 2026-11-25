/-
# Stage3.SdiagLeadAd — layer (2), the per-`d` step on average, from four arithmetic facts.
2026-11-25.

`StmtAdApprox P A` (the `A_d ↦ Â_d` replacement, summed against `‖W_d‖`) is derived here from
`muSmoothR`, `muSmooth_crude` (both proved, `SdiagLeadSmooth`), `Ad_eq` (proved,
`SdiagLeadCop`) and four statements about `⟨d⟩ = {m : primes of m ⊆ primes of d}` alone, with
`S_d(X) = Σ_{m ≤ X, m ∈ ⟨d⟩} 1/m` (`Sdm`), `σ(d) = d/φ(d)` (`sig`), `T_d(X) = σ(d) − S_d(X)` (`Tl`):

* `StmtSdmLe`:     `S_d(X) ≤ σ(d)` (the finite Euler product);
* `StmtMeanSig3`:  `Σ_{d ≤ M} μ²(d) σ(d)³/d ≤ C(1 + log M)`;
* `StmtTailFixed`: `Σ_{d ≤ M} μ²(d) σ(d)² T_d(Z)/d ≤ η(1 + log M)` for `Z = Z(η)`;
* `StmtTailAvg`:   `Σ_{d ≤ M} μ²(d) σ(d)² T_d(M/(dY))/d ≤ C(1 + log Y)`.

The per-`d` bound (`ad_err`): with `a_d = A_d/μ(d) = Σ_{m ∈ ⟨d⟩, m ≤ M/d} m^{−(1+γ)} Smu(M/(dm))`
and `â_d = σ(d) mainS(M/d)`,
`‖a_d − â_d‖ ≤ (1/λ)(e^A ε σ(d) + C_s (log Z/λ) σ(d) + C_s T_d(Z) + C_7 T_d(M/d/Y′))`,
from `muSmoothR` on `m ≤ (M/d)/Y′`, `muSmooth_crude` above, `‖m^{−γ} mainS(x/m) − mainS(x)‖ ≤
C_s log m/λ²` (`mainS_shift`) below `Z` and `≤ C_s/λ` above, and `S_d(M/d) − σ(d)` at the end.
Against `‖W_d‖ ≤ e^{2A} σ(d)/d` (`Wd_bound`) and `‖a_d‖, ‖â_d‖ ≤ C σ(d)/λ` the total is
`(C/λ²)((e^A ε + C log Z/λ)(1 + λ) + η(1 + λ) + (1 + log Y′))` (`stmtAdApprox_of_arith`): the size
check of `SdiagLeadCore`, now a proof. No factor growing with `M` is lost.

| name | content | status |
|---|---|---|
| `Sdm`, `Tl` | `S_d(X)`, `T_d(X)` | def |
| `StmtSdmLe`, `StmtMeanSig3`, `StmtTailFixed`, `StmtTailAvg` | the four arithmetic facts | OPEN (named Props) |
| `norm_ncpow_le`, `norm_ncpow_sub_one_le` | `‖m^{−(1+γ)}‖ ≤ e^A/m`; `‖m^{−γ} − 1‖ ≤ ‖γ‖ log m e^A` | proved |
| `mainS_bound`, `mainS_shift`, `Smu_bound` | the sizes of `mainS` and `Smu` | proved |
| `Wd_bound` | `‖W_d‖ ≤ e^{2A} σ(d)/d` | proved (from `StmtSdmLe`) |
| `ad_err`, `ad_bound`, `ahat_bound` | the per-`d` sizes | proved (from `StmtSdmLe`) |
| `stmtAdApprox_of_arith` | the four facts → `StmtAdApprox P A` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.SdiagLeadCore

namespace SdiagLead

open Complex Finset DiagMain
open scoped ArithmeticFunction.Moebius

noncomputable section

/-- `S_d(X) = Σ_{m ≤ X, m ∈ ⟨d⟩} 1/m`. -/
def Sdm (d X : ℕ) : ℝ := ∑ m ∈ Ioc 0 X, ((chiAF d m : ℤ) : ℝ) / m

/-- `T_d(X) = σ(d) − S_d(X)`. -/
def Tl (d X : ℕ) : ℝ := sig d - Sdm d X

/-- OPEN, the finite Euler product: `S_d(X) ≤ d/φ(d)`. -/
def StmtSdmLe : Prop := ∀ d X : ℕ, 1 ≤ d → Sdm d X ≤ sig d

/-- OPEN, the mean of `σ³`: `Σ_{d ≤ M} μ²(d) σ(d)³/d ≤ C(1 + log M)`. -/
def StmtMeanSig3 : Prop := ∃ C : ℝ, 0 ≤ C ∧ ∀ M : ℕ,
  ∑ d ∈ Icc 1 M, ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 3 / d ≤ C * (1 + Real.log M)

/-- OPEN, the tail beyond a fixed `Z`, on average: `≤ η(1 + log M)` once `Z = Z(η)`. -/
def StmtTailFixed : Prop := ∀ η : ℝ, 0 < η → ∃ Z : ℕ, ∀ M : ℕ,
  ∑ d ∈ Icc 1 M, ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 * Tl d Z / d ≤ η * (1 + Real.log M)

/-- OPEN, the tail beyond `M/(dY)`, on average: `≤ C(1 + log Y)`. -/
def StmtTailAvg : Prop := ∃ C : ℝ, 0 ≤ C ∧ ∀ M Y : ℕ, 1 ≤ Y →
  ∑ d ∈ Icc 1 M, ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 * Tl d (M / d / Y) / d ≤ C * (1 + Real.log Y)

/-! ## Elementary facts on `⟨d⟩` -/

theorem chi_cases (d m : ℕ) : ((chiAF d m : ℤ) : ℝ) = 0 ∨ ((chiAF d m : ℤ) : ℝ) = 1 := by
  rw [chiAF_apply]; split_ifs <;> simp

theorem chi_nonneg (d m : ℕ) : 0 ≤ ((chiAF d m : ℤ) : ℝ) := by
  rcases chi_cases d m with h | h <;> rw [h] <;> norm_num

theorem chi_le_one (d m : ℕ) : ((chiAF d m : ℤ) : ℝ) ≤ 1 := by
  rcases chi_cases d m with h | h <;> rw [h] <;> norm_num

theorem chi_term_nonneg (d m : ℕ) : 0 ≤ ((chiAF d m : ℤ) : ℝ) / m :=
  div_nonneg (chi_nonneg d m) (Nat.cast_nonneg m)

theorem Sdm_mono (d : ℕ) {X X' : ℕ} (h : X ≤ X') : Sdm d X ≤ Sdm d X' := by
  unfold Sdm
  exact Finset.sum_le_sum_of_subset_of_nonneg (Finset.Ioc_subset_Ioc_right h)
    fun m _ _ => chi_term_nonneg d m

theorem Tl_nonneg (hS : StmtSdmLe) {d : ℕ} (hd : 1 ≤ d) (X : ℕ) : 0 ≤ Tl d X := by
  unfold Tl; linarith [hS d X hd]

theorem Tl_anti (d : ℕ) {X X' : ℕ} (h : X ≤ X') : Tl d X' ≤ Tl d X := by
  unfold Tl; linarith [Sdm_mono d h]

/-- `Σ_{m ≤ N, m > K, m ∈ ⟨d⟩} 1/m ≤ T_d(K)`. -/
theorem sum_above_le (hS : StmtSdmLe) {d : ℕ} (hd : 1 ≤ d) (N K : ℕ) :
    ∑ m ∈ Ioc 0 N, (if m ≤ K then (0 : ℝ) else ((chiAF d m : ℤ) : ℝ) / m) ≤ Tl d K := by
  rcases le_or_gt N K with hNK | hNK
  · rw [Finset.sum_eq_zero fun m hm => if_pos (le_trans (Finset.mem_Ioc.mp hm).2 hNK)]
    exact Tl_nonneg hS hd K
  · rw [← Finset.sum_Ioc_consecutive _ (Nat.zero_le K) hNK.le]
    rw [Finset.sum_eq_zero fun m hm => if_pos (Finset.mem_Ioc.mp hm).2, zero_add]
    rw [Finset.sum_congr rfl fun m hm => if_neg (by
      have := (Finset.mem_Ioc.mp hm).1; omega)]
    have e : Sdm d N = Sdm d K + ∑ m ∈ Ioc K N, ((chiAF d m : ℤ) : ℝ) / m := by
      unfold Sdm; rw [Finset.sum_Ioc_consecutive _ (Nat.zero_le K) hNK.le]
    unfold Tl; linarith [hS d N hd]

/-! ## Sizes of powers, `mainS` and `Smu` -/

/-- `‖m^{−(1+γ)}‖ ≤ e^A/m` for `1 ≤ m ≤ M`. -/
theorem norm_ncpow_le {m M : ℕ} (hm : 1 ≤ m) (hmM : m ≤ M) {γ : ℂ} {A : ℝ}
    (hγ : ‖γ‖ * Real.log M ≤ A) : ‖(m : ℂ) ^ (-(1 + γ))‖ ≤ Real.exp A / m := by
  have hm0 : (0 : ℝ) < m := by exact_mod_cast hm
  rw [Diagonal.norm_cpow_nat hm]
  have hre : (-(1 + γ)).re = -1 + -γ.re := by simp; ring
  rw [hre, Real.rpow_add hm0, Real.rpow_neg_one, Real.rpow_def_of_pos hm0]
  have hl : 0 ≤ Real.log m := Real.log_nonneg (by exact_mod_cast hm)
  have hlM : Real.log m ≤ Real.log M := Real.log_le_log hm0 (by exact_mod_cast hmM)
  have h1 : Real.log m * -γ.re ≤ A := by
    have : -γ.re ≤ ‖γ‖ := by linarith [neg_le_of_abs_le (Complex.abs_re_le_norm γ)]
    calc Real.log m * -γ.re ≤ Real.log m * ‖γ‖ := mul_le_mul_of_nonneg_left this hl
      _ ≤ Real.log M * ‖γ‖ := mul_le_mul_of_nonneg_right hlM (norm_nonneg _)
      _ ≤ A := by linarith
  rw [div_eq_inv_mul]
  exact mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr h1) (by positivity)

/-- `‖m^{−γ} − 1‖ ≤ ‖γ‖ log m e^A` for `1 ≤ m`, `‖γ‖ log m ≤ A`. -/
theorem norm_ncpow_sub_one_le {m : ℕ} (hm : 1 ≤ m) {γ : ℂ} {A : ℝ}
    (hγ : ‖γ‖ * Real.log m ≤ A) : ‖(m : ℂ) ^ (-γ) - 1‖ ≤ ‖γ‖ * Real.log m * Real.exp A := by
  have hm0 : (m : ℂ) ≠ 0 := by exact_mod_cast (by omega : m ≠ 0)
  have hl : 0 ≤ Real.log m := Real.log_nonneg (by exact_mod_cast hm)
  rw [Complex.cpow_def_of_ne_zero hm0, ← Complex.natCast_log]
  have h := Complex.norm_exp_sub_sum_le_norm_mul_exp ((Real.log m : ℂ) * -γ) 1
  simp only [Finset.range_one, Finset.sum_singleton, pow_zero, Nat.factorial_zero,
    Nat.cast_one, div_one, pow_one] at h
  have hn : ‖(Real.log m : ℂ) * -γ‖ = ‖γ‖ * Real.log m := by
    rw [norm_mul, norm_neg, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg hl]; ring
  rw [hn] at h
  refine le_trans h (mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr hγ) (by positivity))

/-- Sup bounds for `|P|`, `|P′|`, `|P″|` on `[0, 1]`. -/
theorem poly_sup (p : Polynomial ℝ) : ∃ B : ℝ, 0 ≤ B ∧ ∀ u ∈ Set.Icc (0 : ℝ) 1, |p.eval u| ≤ B := by
  obtain ⟨B, hB⟩ := (isCompact_Icc (a := (0 : ℝ)) (b := 1)).exists_bound_of_continuousOn
    (p.continuous.continuousOn (s := Set.Icc 0 1))
  exact ⟨B, le_trans (norm_nonneg _) (hB 0 ⟨le_refl _, zero_le_one⟩), fun u hu => hB u hu⟩

/-- `|p(u) − p(v)| ≤ B₁ |u − v|` on `[0, 1]`. -/
theorem poly_lip (p : Polynomial ℝ) : ∃ B : ℝ, 0 ≤ B ∧ ∀ u v : ℝ, 0 ≤ v → v ≤ u → u ≤ 1 →
    |p.eval u - p.eval v| ≤ B * (u - v) := by
  obtain ⟨B, hB0, hB⟩ := poly_sup p.derivative
  refine ⟨B, hB0, fun u v hv hvu hu => ?_⟩
  have h := norm_image_sub_le_of_norm_deriv_le_segment' (f := fun t => p.eval t)
    (f' := fun t => p.derivative.eval t) (a := v) (b := u) (C := B)
    (fun t _ => (p.hasDerivAt t).hasDerivWithinAt)
    (fun t ht => by rw [Real.norm_eq_abs]; exact hB t ⟨le_trans hv ht.1, le_trans ht.2.le hu⟩)
    u ⟨hvu, le_rfl⟩
  simpa [Real.norm_eq_abs] using h

theorem ell_mem {lM y : ℝ} (hlM : 0 < lM) (hy : 1 ≤ y) (hyl : Real.log y ≤ lM) :
    Real.log y / lM ∈ Set.Icc (0 : ℝ) 1 :=
  ⟨div_nonneg (Real.log_nonneg hy) hlM.le, (div_le_one hlM).mpr hyl⟩

/-- `‖mainS(y, γ)‖ ≤ C_m/λ` for `1 ≤ y`, `log y ≤ λ`. -/
theorem mainS_bound (P : Polynomial ℝ) {A : ℝ} (hA : 0 ≤ A) : ∃ C : ℝ, 0 ≤ C ∧ ∀ lM : ℝ, 0 < lM →
    ∀ y : ℝ, 1 ≤ y → Real.log y ≤ lM → ∀ γ : ℂ, ‖γ‖ * lM ≤ A →
      ‖mainS P lM y γ‖ ≤ C / lM := by
  obtain ⟨B0, hB0, h0⟩ := poly_sup P
  obtain ⟨B1, hB1, h1⟩ := poly_sup P.derivative
  refine ⟨A * B0 + B1, by positivity, fun lM hlM y hy hyl γ hγ => ?_⟩
  have hu := ell_mem hlM hy hyl
  unfold mainS
  refine le_trans (norm_add_le _ _) ?_
  rw [norm_mul, norm_div, Complex.norm_real, Complex.norm_real, Complex.norm_real,
    Real.norm_eq_abs, Real.norm_eq_abs, Real.norm_eq_abs, abs_of_pos hlM]
  have hb : ‖γ‖ ≤ A / lM := by rw [le_div_iff₀ hlM]; exact hγ
  have t1 : ‖γ‖ * |P.eval (Real.log y / lM)| ≤ A / lM * B0 :=
    mul_le_mul hb (h0 _ hu) (abs_nonneg _) (by positivity)
  have t2 : |P.derivative.eval (Real.log y / lM)| / lM ≤ B1 / lM :=
    div_le_div_of_nonneg_right (h1 _ hu) hlM.le
  have : A / lM * B0 + B1 / lM = (A * B0 + B1) / lM := by ring
  linarith

/-- **The shift**: `‖m^{−γ} mainS(x/m) − mainS(x)‖ ≤ C_s log m/λ²` for `1 ≤ m ≤ x`, `log x ≤ λ`. -/
theorem mainS_shift (P : Polynomial ℝ) {A : ℝ} (hA : 0 ≤ A) : ∃ C : ℝ, 0 ≤ C ∧ ∀ lM : ℝ,
    0 < lM → ∀ x : ℝ, ∀ m : ℕ, 1 ≤ m → (m : ℝ) ≤ x → Real.log x ≤ lM → ∀ γ : ℂ, ‖γ‖ * lM ≤ A →
      ‖(m : ℂ) ^ (-γ) * mainS P lM (x / m) γ - mainS P lM x γ‖ ≤ C * Real.log m / lM ^ 2 := by
  obtain ⟨Cm, hCm0, hCm⟩ := mainS_bound P hA
  obtain ⟨L0, hL00, hL0⟩ := poly_lip P
  obtain ⟨L1, hL10, hL1⟩ := poly_lip P.derivative
  refine ⟨A * Real.exp A * Cm + A * L0 + L1, by positivity,
    fun lM hlM x m hm hmx hxl γ hγ => ?_⟩
  have hm0 : (0 : ℝ) < m := by exact_mod_cast hm
  have hx1 : 1 ≤ x := le_trans (by exact_mod_cast hm) hmx
  have hx0 : 0 < x := by linarith
  have hlm : 0 ≤ Real.log m := Real.log_nonneg (by exact_mod_cast hm)
  have hxm1 : 1 ≤ x / m := (le_div_iff₀ hm0).mpr (by linarith)
  have hlxm : Real.log (x / m) = Real.log x - Real.log m := Real.log_div hx0.ne' hm0.ne'
  have hlmx : Real.log m ≤ Real.log x := Real.log_le_log hm0 hmx
  have hxml : Real.log (x / m) ≤ lM := by rw [hlxm]; linarith
  have hb : ‖γ‖ ≤ A / lM := by rw [le_div_iff₀ hlM]; exact hγ
  have hγm : ‖γ‖ * Real.log m ≤ A := le_trans (mul_le_mul_of_nonneg_left (by linarith)
    (norm_nonneg _)) hγ
  have e : (m : ℂ) ^ (-γ) * mainS P lM (x / m) γ - mainS P lM x γ =
      ((m : ℂ) ^ (-γ) - 1) * mainS P lM (x / m) γ + (mainS P lM (x / m) γ - mainS P lM x γ) := by
    ring
  rw [e]
  refine le_trans (norm_add_le _ _) ?_
  have t1 : ‖((m : ℂ) ^ (-γ) - 1) * mainS P lM (x / m) γ‖ ≤
      (A / lM * Real.log m * Real.exp A) * (Cm / lM) := by
    rw [norm_mul]
    refine mul_le_mul ?_ (hCm lM hlM _ hxm1 hxml γ hγ) (norm_nonneg _) (by positivity)
    refine le_trans (norm_ncpow_sub_one_le hm hγm) ?_
    exact mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_right hb hlm) (Real.exp_pos _).le
  -- the second piece
  set u1 := Real.log (x / m) / lM with hu1
  set u2 := Real.log x / lM with hu2
  have hu1m := ell_mem hlM hxm1 hxml
  have hu2m := ell_mem hlM hx1 hxl
  have hdu : u2 - u1 = Real.log m / lM := by rw [hu1, hu2, hlxm]; ring
  have hle : u1 ≤ u2 := by have := div_nonneg hlm hlM.le; linarith
  have hP := hL0 u2 u1 hu1m.1 hle hu2m.2
  have hP' := hL1 u2 u1 hu1m.1 hle hu2m.2
  have t2 : ‖mainS P lM (x / m) γ - mainS P lM x γ‖ ≤
      A / lM * (L0 * (Real.log m / lM)) + L1 * (Real.log m / lM) / lM := by
    unfold mainS
    rw [← hu1, ← hu2]
    have e2 : γ * ((P.eval u1 : ℝ) : ℂ) + ((P.derivative.eval u1 : ℝ) : ℂ) / (lM : ℂ) -
        (γ * ((P.eval u2 : ℝ) : ℂ) + ((P.derivative.eval u2 : ℝ) : ℂ) / (lM : ℂ)) =
        γ * (((P.eval u1 - P.eval u2 : ℝ)) : ℂ) +
          ((P.derivative.eval u1 - P.derivative.eval u2 : ℝ) : ℂ) / (lM : ℂ) := by
      push_cast; ring
    rw [e2]
    refine le_trans (norm_add_le _ _) ?_
    rw [norm_mul, norm_div, Complex.norm_real, Complex.norm_real, Complex.norm_real,
      Real.norm_eq_abs, Real.norm_eq_abs, Real.norm_eq_abs, abs_of_pos hlM, abs_sub_comm,
      abs_sub_comm (P.derivative.eval u1), hdu.symm]
    refine add_le_add (mul_le_mul hb hP (abs_nonneg _) (by positivity))
      (div_le_div_of_nonneg_right ?_ hlM.le)
    exact hP'
  have : A / lM * Real.log m * Real.exp A * (Cm / lM) +
      (A / lM * (L0 * (Real.log m / lM)) + L1 * (Real.log m / lM) / lM) =
      (A * Real.exp A * Cm + A * L0 + L1) * Real.log m / lM ^ 2 := by
    field_simp
    ring
  linarith

/-- `‖Smu(y, γ)‖ ≤ C/λ` for `1 ≤ y`, `log y ≤ λ`. -/
theorem Smu_bound (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) {A : ℝ} (hA : 0 ≤ A) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ lM : ℝ, 0 < lM → ∀ y : ℝ, 1 ≤ y → Real.log y ≤ lM → ∀ γ : ℂ,
      ‖γ‖ * lM ≤ A → ‖Smu P lM y γ‖ ≤ C / lM := by
  obtain ⟨Cc, hCc0, hCc⟩ := muSmooth_crude P hP0 hA
  obtain ⟨Cm, hCm0, hCm⟩ := mainS_bound P hA
  refine ⟨Cc + Cm, by positivity, fun lM hlM y hy hyl γ hγ => ?_⟩
  have h1 := hCc lM hlM y hy hyl γ hγ
  have h2 := hCm lM hlM y hy hyl γ hγ
  calc ‖Smu P lM y γ‖ = ‖(Smu P lM y γ - mainS P lM y γ) + mainS P lM y γ‖ := by ring_nf
    _ ≤ Cc / lM + Cm / lM := le_trans (norm_add_le _ _) (add_le_add h1 h2)
    _ = (Cc + Cm) / lM := by ring

/-! ## The weight `W_d` -/

/-- `Σ_{a | d} 1/a ≤ S_d(d)`. -/
theorem sum_div_le_Sdm {d : ℕ} (hd : 1 ≤ d) :
    ∑ a ∈ d.divisors, (1 : ℝ) / a ≤ Sdm d d := by
  unfold Sdm
  have hsub : d.divisors ⊆ Ioc 0 d := by
    intro a ha
    have ha' := Nat.mem_divisors.mp ha
    exact Finset.mem_Ioc.mpr ⟨Nat.pos_of_dvd_of_pos ha'.1 (by omega), Nat.le_of_dvd (by omega) ha'.1⟩
  calc ∑ a ∈ d.divisors, (1 : ℝ) / a = ∑ a ∈ d.divisors, ((chiAF d a : ℤ) : ℝ) / a := by
        refine Finset.sum_congr rfl fun a ha => ?_
        have ha' := Nat.mem_divisors.mp ha
        have ha0 : 0 < a := Nat.pos_of_dvd_of_pos ha'.1 (by omega)
        rw [chiAF_apply, if_pos ⟨ha0.ne', Nat.primeFactors_mono ha'.1 (by omega)⟩]; norm_num
    _ ≤ _ := Finset.sum_le_sum_of_subset_of_nonneg hsub fun m _ _ => chi_term_nonneg d m

/-- **`‖W_d‖ ≤ e^{2A} σ(d)/d`** for `1 ≤ d ≤ M`, `‖α‖λ, ‖β‖λ ≤ A`. -/
theorem Wd_bound (hS : StmtSdmLe) {M d : ℕ} (hd : 1 ≤ d) (hdM : d ≤ M) {α β : ℂ} {A : ℝ}
    (hα : ‖α‖ * Real.log M ≤ A) (hβ : ‖β‖ * Real.log M ≤ A) :
    ‖Wd α β d‖ ≤ Real.exp (2 * A) * sig d / d := by
  have hd0 : (0 : ℝ) < d := by exact_mod_cast hd
  have hlM : Real.log d ≤ Real.log M := Real.log_le_log hd0 (by exact_mod_cast hdM)
  have hld : 0 ≤ Real.log d := Real.log_nonneg (by exact_mod_cast hd)
  set s := α + β with hs
  have hsn : ‖s‖ * Real.log M ≤ 2 * A := by
    have := mul_le_mul_of_nonneg_right (norm_add_le α β)
      (Real.log_nonneg (show (1 : ℝ) ≤ M by exact_mod_cast le_trans hd hdM))
    linarith
  unfold Wd Jz
  rw [Finset.sum_mul]
  refine le_trans (norm_sum_le _ _) ?_
  have hterm : ∀ x ∈ d.divisorsAntidiagonal,
      ‖((μ x.1 : ℤ) : ℂ) * (x.2 : ℂ) ^ (1 + α + β) * (d : ℂ) ^ (-(2 + α + β))‖ ≤
        Real.exp (2 * A) / d * (1 / x.1) := by
    intro x hx
    obtain ⟨hxd, -⟩ := Nat.mem_divisorsAntidiagonal.mp hx
    have h1 : 1 ≤ x.1 := Nat.pos_of_ne_zero (by rintro h; rw [h, zero_mul] at hxd; omega)
    have h2 : 1 ≤ x.2 := Nat.pos_of_ne_zero (by rintro h; rw [h, mul_zero] at hxd; omega)
    have h10 : (0 : ℝ) < x.1 := by exact_mod_cast h1
    have h20 : (0 : ℝ) < x.2 := by exact_mod_cast h2
    have hdx : (d : ℝ) = x.1 * x.2 := by exact_mod_cast hxd.symm
    rw [norm_mul, norm_mul, Diagonal.norm_cpow_nat h2, Diagonal.norm_cpow_nat hd]
    have hmu : ‖((μ x.1 : ℤ) : ℂ)‖ ≤ 1 := by
      rw [Complex.norm_intCast]; exact_mod_cast ArithmeticFunction.abs_moebius_le_one
    have hre1 : (1 + α + β).re = 1 + s.re := by rw [hs]; simp; ring
    have hre2 : (-(2 + α + β)).re = -2 - s.re := by rw [hs]; simp; ring
    rw [hre1, hre2, hdx, Real.mul_rpow h10.le h20.le]
    have ha : (x.2 : ℝ) ^ (1 + s.re) * (x.2 : ℝ) ^ (-2 - s.re) = (x.2 : ℝ)⁻¹ := by
      rw [← Real.rpow_add h20, show (1 + s.re) + (-2 - s.re) = (-1 : ℝ) by ring, Real.rpow_neg_one]
    have hb : (x.1 : ℝ) ^ (-2 - s.re) = (x.1 : ℝ)⁻¹ * (x.1 : ℝ)⁻¹ * (x.1 : ℝ) ^ (-s.re) := by
      rw [show (-2 - s.re) = (-1 : ℝ) + (-1) + (-s.re) by ring, Real.rpow_add h10, Real.rpow_add h10,
        Real.rpow_neg_one]
    have hpow : (x.2 : ℝ) ^ (1 + s.re) * ((x.1 : ℝ) ^ (-2 - s.re) * (x.2 : ℝ) ^ (-2 - s.re)) =
        1 / (x.1 * x.2) * (1 / x.1) * (x.1 : ℝ) ^ (-s.re) := by
      calc (x.2 : ℝ) ^ (1 + s.re) * ((x.1 : ℝ) ^ (-2 - s.re) * (x.2 : ℝ) ^ (-2 - s.re))
          = ((x.2 : ℝ) ^ (1 + s.re) * (x.2 : ℝ) ^ (-2 - s.re)) * (x.1 : ℝ) ^ (-2 - s.re) := by ring
        _ = _ := by rw [ha, hb, one_div, one_div, mul_inv]; ring
    rw [mul_assoc, hpow, ← hdx]
    have hx1d : (x.1 : ℝ) ≤ d := by
      rw [hdx]; exact le_mul_of_one_le_right h10.le (by exact_mod_cast h2)
    have hl1 : Real.log x.1 ≤ Real.log M :=
      le_trans (Real.log_le_log h10 hx1d) hlM
    have hl0 : 0 ≤ Real.log x.1 := Real.log_nonneg (by exact_mod_cast h1)
    have hexp : (x.1 : ℝ) ^ (-s.re) ≤ Real.exp (2 * A) := by
      rw [Real.rpow_def_of_pos h10]
      refine Real.exp_le_exp.mpr ?_
      have : -s.re ≤ ‖s‖ := by linarith [neg_le_of_abs_le (Complex.abs_re_le_norm s)]
      calc Real.log x.1 * -s.re ≤ Real.log x.1 * ‖s‖ := mul_le_mul_of_nonneg_left this hl0
        _ ≤ Real.log M * ‖s‖ := mul_le_mul_of_nonneg_right hl1 (norm_nonneg _)
        _ ≤ 2 * A := by linarith
    calc ‖((μ x.1 : ℤ) : ℂ)‖ * (1 / d * (1 / x.1) * (x.1 : ℝ) ^ (-s.re))
        ≤ 1 * (1 / d * (1 / x.1) * Real.exp (2 * A)) :=
          mul_le_mul hmu (mul_le_mul_of_nonneg_left hexp (by positivity)) (by positivity)
            zero_le_one
      _ = Real.exp (2 * A) / d * (1 / x.1) := by ring
  refine le_trans (Finset.sum_le_sum hterm) ?_
  rw [← Finset.mul_sum]
  have hsum : ∑ x ∈ d.divisorsAntidiagonal, (1 : ℝ) / x.1 = ∑ a ∈ d.divisors, (1 : ℝ) / a :=
    Nat.sum_divisorsAntidiagonal (fun a _ => (1 : ℝ) / a)
  rw [hsum]
  have := le_trans (sum_div_le_Sdm hd) (hS d d hd)
  have hE : 0 ≤ Real.exp (2 * A) / d := by positivity
  calc Real.exp (2 * A) / d * (∑ a ∈ d.divisors, (1 : ℝ) / a) ≤ Real.exp (2 * A) / d * sig d :=
        mul_le_mul_of_nonneg_left this hE
    _ = Real.exp (2 * A) * sig d / d := by ring

/-! ## The per-`d` sizes -/

/-- `a_d(γ) = A_d(γ)/μ(d) = Σ_{m ∈ ⟨d⟩, m ≤ M/d} m^{−(1+γ)} Smu(M/(dm), γ)`. -/
def ad (P : Polynomial ℝ) (M d : ℕ) (γ : ℂ) : ℂ :=
  ∑ m ∈ Ioc 0 (M / d), ((chiAF d m : ℤ) : ℂ) *
    ((m : ℂ) ^ (-(1 + γ)) * Smu P (Real.log M) ((M : ℝ) / d / m) γ)

/-- `â_d(γ) = σ(d) mainS(M/d, γ)`. -/
def ahat0 (P : Polynomial ℝ) (M d : ℕ) (γ : ℂ) : ℂ :=
  ((sig d : ℝ) : ℂ) * mainS P (Real.log M) ((M : ℝ) / d) γ

theorem sig_nonneg (d : ℕ) : 0 ≤ sig d := div_nonneg (Nat.cast_nonneg _) (Nat.cast_nonneg _)

theorem Sdm_nonneg (d X : ℕ) : 0 ≤ Sdm d X :=
  Finset.sum_nonneg fun m _ => chi_term_nonneg d m

/-- The range facts for `m ≤ M/d`. -/
theorem range_facts {M d m : ℕ} (hd : 1 ≤ d) (hm : m ∈ Ioc 0 (M / d)) :
    1 ≤ m ∧ m ≤ M ∧ (m : ℝ) ≤ (M : ℝ) / d ∧ 1 ≤ (M : ℝ) / d / m ∧
      Real.log ((M : ℝ) / d / m) ≤ Real.log M ∧ Real.log ((M : ℝ) / d) ≤ Real.log M ∧
      1 ≤ (M : ℝ) / d := by
  obtain ⟨hm0, hmN⟩ := Finset.mem_Ioc.mp hm
  have hd0 : (0 : ℝ) < d := by exact_mod_cast hd
  have hm0' : (0 : ℝ) < m := by exact_mod_cast hm0
  have hmd : m * d ≤ M := (Nat.le_div_iff_mul_le hd).mp hmN
  have hmM : m ≤ M := le_trans (Nat.le_mul_of_pos_right m hd) hmd
  have hmx : (m : ℝ) ≤ (M : ℝ) / d := by
    rw [le_div_iff₀ hd0]; exact_mod_cast hmd
  have hx1 : 1 ≤ (M : ℝ) / d := le_trans (by exact_mod_cast hm0) hmx
  have hxM : (M : ℝ) / d ≤ M := div_le_self (Nat.cast_nonneg _) (by exact_mod_cast hd)
  have hxm1 : 1 ≤ (M : ℝ) / d / m := (le_div_iff₀ hm0').mpr (by linarith)
  have hl1 : Real.log ((M : ℝ) / d) ≤ Real.log M := Real.log_le_log (by linarith) hxM
  refine ⟨hm0, hmM, hmx, hxm1, ?_, hl1, hx1⟩
  refine le_trans (Real.log_le_log (by linarith) ?_) hl1
  exact div_le_self (by linarith) (by exact_mod_cast hm0)

theorem norm_chi_mul (d m : ℕ) (z : ℂ) :
    ‖((chiAF d m : ℤ) : ℂ) * z‖ = ((chiAF d m : ℤ) : ℝ) * ‖z‖ := by
  rw [norm_mul]; congr 1
  rcases chi_cases d m with h | h
  · have : chiAF d m = 0 := by exact_mod_cast h
    rw [this]; simp
  · have : chiAF d m = 1 := by exact_mod_cast h
    rw [this]; simp

/-- `‖a_d(γ)‖ ≤ e^A C σ(d)/λ`. -/
theorem ad_bound (hS : StmtSdmLe) {C A : ℝ} (P : Polynomial ℝ)
    (hC : ∀ lM : ℝ, 0 < lM → ∀ y : ℝ, 1 ≤ y → Real.log y ≤ lM → ∀ γ : ℂ, ‖γ‖ * lM ≤ A →
      ‖Smu P lM y γ‖ ≤ C / lM) (hC0 : 0 ≤ C)
    {M d : ℕ} (hd : 1 ≤ d) (hlM : 0 < Real.log M) {γ : ℂ} (hγ : ‖γ‖ * Real.log M ≤ A) :
    ‖ad P M d γ‖ ≤ Real.exp A * C * sig d / Real.log M := by
  unfold ad
  refine le_trans (norm_sum_le _ _) ?_
  have hterm : ∀ m ∈ Ioc 0 (M / d), ‖((chiAF d m : ℤ) : ℂ) *
      ((m : ℂ) ^ (-(1 + γ)) * Smu P (Real.log M) ((M : ℝ) / d / m) γ)‖ ≤
        ((chiAF d m : ℤ) : ℝ) / m * (Real.exp A * C / Real.log M) := by
    intro m hm
    obtain ⟨hm1, hmM, -, hxm1, hl, -⟩ := range_facts hd hm
    rw [norm_chi_mul, norm_mul]
    have h1 := norm_ncpow_le hm1 hmM hγ
    have h2 := hC _ hlM _ hxm1 hl γ hγ
    have : ‖(m : ℂ) ^ (-(1 + γ))‖ * ‖Smu P (Real.log M) ((M : ℝ) / d / m) γ‖ ≤
        Real.exp A / m * (C / Real.log M) := mul_le_mul h1 h2 (norm_nonneg _) (by positivity)
    calc ((chiAF d m : ℤ) : ℝ) * (‖(m : ℂ) ^ (-(1 + γ))‖ *
          ‖Smu P (Real.log M) ((M : ℝ) / d / m) γ‖)
        ≤ ((chiAF d m : ℤ) : ℝ) * (Real.exp A / m * (C / Real.log M)) :=
          mul_le_mul_of_nonneg_left this (chi_nonneg d m)
      _ = _ := by ring
  refine le_trans (Finset.sum_le_sum hterm) ?_
  rw [← Finset.sum_mul]
  have := hS d (M / d) hd
  unfold Sdm at this
  calc (∑ m ∈ Ioc 0 (M / d), ((chiAF d m : ℤ) : ℝ) / m) * (Real.exp A * C / Real.log M)
      ≤ sig d * (Real.exp A * C / Real.log M) :=
        mul_le_mul_of_nonneg_right this (by positivity)
    _ = _ := by ring

/-- `‖â_d(γ)‖ ≤ σ(d) C_m/λ`. -/
theorem ahat0_bound {Cm A : ℝ} (P : Polynomial ℝ)
    (hCm : ∀ lM : ℝ, 0 < lM → ∀ y : ℝ, 1 ≤ y → Real.log y ≤ lM → ∀ γ : ℂ, ‖γ‖ * lM ≤ A →
      ‖mainS P lM y γ‖ ≤ Cm / lM)
    {M d : ℕ} (hd : 1 ≤ d) (hdM : d ≤ M) (hlM : 0 < Real.log M) {γ : ℂ}
    (hγ : ‖γ‖ * Real.log M ≤ A) :
    ‖ahat0 P M d γ‖ ≤ sig d * Cm / Real.log M := by
  have hd0 : (0 : ℝ) < d := by exact_mod_cast hd
  have hx1 : 1 ≤ (M : ℝ) / d := (le_div_iff₀ hd0).mpr (by simpa using (by exact_mod_cast hdM : (d : ℝ) ≤ M))
  have hxM : (M : ℝ) / d ≤ M := div_le_self (Nat.cast_nonneg _) (by exact_mod_cast hd)
  have hl : Real.log ((M : ℝ) / d) ≤ Real.log M := Real.log_le_log (by linarith) hxM
  unfold ahat0
  rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg (sig_nonneg d), mul_div_assoc]
  exact mul_le_mul_of_nonneg_left (hCm _ hlM _ hx1 hl γ hγ) (sig_nonneg d)

/-- **The per-`d` error**: `‖a_d − â_d‖ ≤ (e^A ε σ + C_s log Z σ/λ + C_s T_d(Z) +
(e^A C_c + C_m) T_d(M/d/Y′))/λ`. -/
theorem ad_err (hS : StmtSdmLe) (P : Polynomial ℝ) {A ε Y L₀ Cc Cm Cs : ℝ}
    (hsm : ∀ lM : ℝ, L₀ ≤ lM → ∀ x : ℝ, Y ≤ x → Real.log x ≤ lM → ∀ β : ℂ, ‖β‖ * lM ≤ A →
      ‖Smu P lM x β - mainS P lM x β‖ ≤ ε / lM)
    (hcr : ∀ lM : ℝ, 0 < lM → ∀ x : ℝ, 1 ≤ x → Real.log x ≤ lM → ∀ β : ℂ, ‖β‖ * lM ≤ A →
      ‖Smu P lM x β - mainS P lM x β‖ ≤ Cc / lM)
    (hCm : ∀ lM : ℝ, 0 < lM → ∀ y : ℝ, 1 ≤ y → Real.log y ≤ lM → ∀ γ : ℂ, ‖γ‖ * lM ≤ A →
      ‖mainS P lM y γ‖ ≤ Cm / lM)
    (hCs : ∀ lM : ℝ, 0 < lM → ∀ x : ℝ, ∀ m : ℕ, 1 ≤ m → (m : ℝ) ≤ x → Real.log x ≤ lM →
      ∀ γ : ℂ, ‖γ‖ * lM ≤ A →
        ‖(m : ℂ) ^ (-γ) * mainS P lM (x / m) γ - mainS P lM x γ‖ ≤ Cs * Real.log m / lM ^ 2)
    (hε : 0 ≤ ε) (hCc : 0 ≤ Cc) (hCs0 : 0 ≤ Cs)
    {Y' Z : ℕ} (hYY : Y ≤ Y') (hY' : 1 ≤ Y') (hZ : 1 ≤ Z)
    {M d : ℕ} (hd : 1 ≤ d) (hdM : d ≤ M) (hlM : 0 < Real.log M) (hL : L₀ ≤ Real.log M)
    {γ : ℂ} (hγ : ‖γ‖ * Real.log M ≤ A) :
    ‖ad P M d γ - ahat0 P M d γ‖ ≤
      (Real.exp A * ε * sig d + Cs * Real.log Z / Real.log M * sig d + Cs * Tl d Z +
        (Real.exp A * Cc + Cm) * Tl d (M / d / Y')) / Real.log M := by
  set lM := Real.log M with hlMdef
  set x : ℝ := (M : ℝ) / d with hx
  set N := M / d with hN
  have hd0 : (0 : ℝ) < d := by exact_mod_cast hd
  have hx1 : 1 ≤ x := (le_div_iff₀ hd0).mpr (by simpa using (by exact_mod_cast hdM : (d : ℝ) ≤ M))
  have hxM : x ≤ M := div_le_self (Nat.cast_nonneg _) (by exact_mod_cast hd)
  have hxl : Real.log x ≤ lM := Real.log_le_log (by linarith) hxM
  have hlZ : 0 ≤ Real.log Z := Real.log_nonneg (by exact_mod_cast hZ)
  set f1 : ℕ → ℂ := fun m => ((chiAF d m : ℤ) : ℂ) * ((m : ℂ) ^ (-(1 + γ)) *
    (Smu P lM (x / m) γ - mainS P lM (x / m) γ)) with hf1
  set f2 : ℕ → ℂ := fun m => ((chiAF d m : ℤ) : ℂ) * ((m : ℂ) ^ (-(1 + γ)) *
    mainS P lM (x / m) γ - (1 / (m : ℂ)) * mainS P lM x γ) with hf2
  have hdec : ad P M d γ - ahat0 P M d γ = ∑ m ∈ Ioc 0 N, f1 m + ∑ m ∈ Ioc 0 N, f2 m +
      ((Sdm d N - sig d : ℝ) : ℂ) * mainS P lM x γ := by
    have key : ∀ m ∈ Ioc 0 N, ((chiAF d m : ℤ) : ℂ) * ((m : ℂ) ^ (-(1 + γ)) *
        Smu P lM (x / m) γ) = f1 m + f2 m + ((((chiAF d m : ℤ) : ℝ) / m : ℝ) : ℂ) * mainS P lM x γ := by
      intro m _; simp only [hf1, hf2]; push_cast; ring
    unfold ad ahat0
    rw [← hlMdef, ← hx, ← hN, Finset.sum_congr rfl key, Finset.sum_add_distrib,
      Finset.sum_add_distrib, ← Finset.sum_mul]
    unfold Sdm
    push_cast
    ring
  have hNx : (N : ℝ) ≤ x := by rw [hN, hx]; exact Nat.cast_div_le
  set K := N / Y' with hK
  have hmem : ∀ m ∈ Ioc 0 N, 1 ≤ m ∧ m ≤ M ∧ (m : ℝ) ≤ x ∧ 1 ≤ x / m ∧
      Real.log (x / m) ≤ lM := by
    intro m hm
    obtain ⟨a, b, c, e, f, -⟩ := range_facts hd hm
    exact ⟨a, b, c, e, f⟩
  -- the first sum
  have hb1 : ∀ m ∈ Ioc 0 N, ‖f1 m‖ ≤ ((chiAF d m : ℤ) : ℝ) / m * (Real.exp A * ε / lM) +
      Real.exp A * Cc / lM * (if m ≤ K then 0 else ((chiAF d m : ℤ) : ℝ) / m) := by
    intro m hm
    obtain ⟨hm1, hmM, hmx, hxm1, hl⟩ := hmem m hm
    have hm0 : (0 : ℝ) < m := by exact_mod_cast hm1
    simp only [hf1]
    rw [norm_chi_mul, norm_mul]
    have hp := norm_ncpow_le hm1 hmM hγ
    have hχ := chi_nonneg d m
    by_cases hmK : m ≤ K
    · rw [if_pos hmK, mul_zero, add_zero]
      have hmY : m * Y' ≤ N := (Nat.le_div_iff_mul_le hY').mp hmK
      have hY : Y ≤ x / m := by
        rw [le_div_iff₀ hm0]
        have : ((m * Y' : ℕ) : ℝ) ≤ N := by exact_mod_cast hmY
        push_cast at this; nlinarith
      have h2 := hsm lM hL _ hY hl γ hγ
      calc ((chiAF d m : ℤ) : ℝ) * (‖(m : ℂ) ^ (-(1 + γ))‖ *
            ‖Smu P lM (x / m) γ - mainS P lM (x / m) γ‖)
          ≤ ((chiAF d m : ℤ) : ℝ) * (Real.exp A / m * (ε / lM)) :=
            mul_le_mul_of_nonneg_left (mul_le_mul hp h2 (norm_nonneg _) (by positivity)) hχ
        _ = _ := by ring
    · rw [if_neg hmK]
      have h2 := hcr lM hlM _ hxm1 hl γ hγ
      have : ((chiAF d m : ℤ) : ℝ) * (‖(m : ℂ) ^ (-(1 + γ))‖ *
            ‖Smu P lM (x / m) γ - mainS P lM (x / m) γ‖) ≤
          ((chiAF d m : ℤ) : ℝ) * (Real.exp A / m * (Cc / lM)) :=
        mul_le_mul_of_nonneg_left (mul_le_mul hp h2 (norm_nonneg _) (by positivity)) hχ
      have h0 : 0 ≤ ((chiAF d m : ℤ) : ℝ) / m * (Real.exp A * ε / lM) := by positivity
      have e : ((chiAF d m : ℤ) : ℝ) * (Real.exp A / m * (Cc / lM)) =
          Real.exp A * Cc / lM * (((chiAF d m : ℤ) : ℝ) / m) := by ring
      linarith
  -- the second sum
  have hb2 : ∀ m ∈ Ioc 0 N, ‖f2 m‖ ≤ ((chiAF d m : ℤ) : ℝ) / m * (Cs * Real.log Z / lM ^ 2) +
      Cs / lM * (if m ≤ Z then 0 else ((chiAF d m : ℤ) : ℝ) / m) := by
    intro m hm
    obtain ⟨hm1, hmM, hmx, hxm1, hl⟩ := hmem m hm
    have hm0 : (0 : ℝ) < m := by exact_mod_cast hm1
    have hmc : (m : ℂ) ≠ 0 := by exact_mod_cast (by omega : m ≠ 0)
    have hsplit : (m : ℂ) ^ (-(1 + γ)) * mainS P lM (x / m) γ - (1 / (m : ℂ)) * mainS P lM x γ =
        (1 / (m : ℂ)) * ((m : ℂ) ^ (-γ) * mainS P lM (x / m) γ - mainS P lM x γ) := by
      rw [show -(1 + γ) = (-1 : ℂ) + -γ by ring, Complex.cpow_add _ _ hmc, Complex.cpow_neg_one]
      ring
    simp only [hf2]
    rw [hsplit, norm_chi_mul, norm_mul, norm_div, norm_one, Complex.norm_natCast]
    have h2 := hCs lM hlM x m hm1 hmx hxl γ hγ
    have hχ := chi_nonneg d m
    have hlm0 : 0 ≤ Real.log m := Real.log_nonneg (by exact_mod_cast hm1)
    have hA1 : ((chiAF d m : ℤ) : ℝ) * (1 / m * ‖(m : ℂ) ^ (-γ) * mainS P lM (x / m) γ -
        mainS P lM x γ‖) ≤ ((chiAF d m : ℤ) : ℝ) / m * (Cs * Real.log m / lM ^ 2) := by
      rw [show ((chiAF d m : ℤ) : ℝ) / m * (Cs * Real.log m / lM ^ 2) =
        ((chiAF d m : ℤ) : ℝ) * (1 / m * (Cs * Real.log m / lM ^ 2)) by ring]
      exact mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_left h2 (by positivity)) hχ
    by_cases hmZ : m ≤ Z
    · rw [if_pos hmZ, mul_zero, add_zero]
      refine le_trans hA1 (mul_le_mul_of_nonneg_left ?_ (by positivity))
      have : Real.log m ≤ Real.log Z := Real.log_le_log hm0 (by exact_mod_cast hmZ)
      exact div_le_div_of_nonneg_right (mul_le_mul_of_nonneg_left this hCs0) (by positivity)
    · rw [if_neg hmZ]
      have hlmM : Real.log m ≤ lM := Real.log_le_log hm0 (by exact_mod_cast hmM)
      have : ((chiAF d m : ℤ) : ℝ) / m * (Cs * Real.log m / lM ^ 2) ≤
          Cs / lM * (((chiAF d m : ℤ) : ℝ) / m) := by
        rw [show ((chiAF d m : ℤ) : ℝ) / m * (Cs * Real.log m / lM ^ 2) =
          ((chiAF d m : ℤ) : ℝ) / m * (Cs * (Real.log m / lM) / lM) by field_simp]
        rw [mul_comm]
        refine mul_le_mul_of_nonneg_right ?_ (chi_term_nonneg d m)
        have : Real.log m / lM ≤ 1 := (div_le_one hlM).mpr hlmM
        have : Cs * (Real.log m / lM) ≤ Cs := by nlinarith
        exact div_le_div_of_nonneg_right this hlM.le
      have h0 : 0 ≤ ((chiAF d m : ℤ) : ℝ) / m * (Cs * Real.log Z / lM ^ 2) := by positivity
      linarith
  have hs1 := le_trans (norm_sum_le _ _) (Finset.sum_le_sum hb1)
  have hs2 := le_trans (norm_sum_le _ _) (Finset.sum_le_sum hb2)
  rw [Finset.sum_add_distrib, ← Finset.sum_mul, ← Finset.mul_sum] at hs1 hs2
  have hab1 := sum_above_le hS hd N K
  have hab2 := sum_above_le hS hd N Z
  have hSd := hS d N hd
  have hSdm : (∑ m ∈ Ioc 0 N, ((chiAF d m : ℤ) : ℝ) / m) = Sdm d N := rfl
  rw [hSdm] at hs1 hs2
  have hT3 : ‖((Sdm d N - sig d : ℝ) : ℂ) * mainS P lM x γ‖ ≤ Tl d K * (Cm / lM) := by
    rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_sub_comm,
      abs_of_nonneg (by linarith)]
    refine mul_le_mul (Tl_anti d (Nat.div_le_self N Y')) (hCm lM hlM x hx1 hxl γ hγ)
      (norm_nonneg _) (Tl_nonneg hS hd K)
  rw [hdec]
  refine le_trans (norm_add_le _ _) ?_
  refine le_trans (add_le_add (norm_add_le _ _) hT3) ?_
  have hE := Real.exp_pos A
  have hTK := Tl_nonneg hS hd K
  have hTZ := Tl_nonneg hS hd Z
  have p1 : Sdm d N * (Real.exp A * ε / lM) ≤ sig d * (Real.exp A * ε / lM) :=
    mul_le_mul_of_nonneg_right hSd (by positivity)
  have p2 : Sdm d N * (Cs * Real.log Z / lM ^ 2) ≤ sig d * (Cs * Real.log Z / lM ^ 2) :=
    mul_le_mul_of_nonneg_right hSd (by positivity)
  have p3 : Real.exp A * Cc / lM * (∑ m ∈ Ioc 0 N,
      (if m ≤ K then (0 : ℝ) else ((chiAF d m : ℤ) : ℝ) / m)) ≤ Real.exp A * Cc / lM * Tl d K :=
    mul_le_mul_of_nonneg_left hab1 (by positivity)
  have p4 : Cs / lM * (∑ m ∈ Ioc 0 N,
      (if m ≤ Z then (0 : ℝ) else ((chiAF d m : ℤ) : ℝ) / m)) ≤ Cs / lM * Tl d Z :=
    mul_le_mul_of_nonneg_left hab2 (by positivity)
  have e : (Real.exp A * ε * sig d + Cs * Real.log Z / lM * sig d + Cs * Tl d Z +
      (Real.exp A * Cc + Cm) * Tl d K) / lM = sig d * (Real.exp A * ε / lM) +
        Real.exp A * Cc / lM * Tl d K + (sig d * (Cs * Real.log Z / lM ^ 2) + Cs / lM * Tl d Z) +
          Tl d K * (Cm / lM) := by
    field_simp
    ring
  rw [e]
  linarith

/-- `A_d = μ(d) a_d`, `Â_d = μ(d) â_d`, so `A A − Â Â = μ² (a a − â â)`. -/
theorem AA_eq (P : Polynomial ℝ) {M d : ℕ} (hd : 1 ≤ d) (α β : ℂ) :
    Ad P M d β * Ad P M d α - Ahat P M d β * Ahat P M d α =
      ((μ d : ℤ) : ℂ) ^ 2 * (ad P M d β * ad P M d α - ahat0 P M d β * ahat0 P M d α) := by
  rw [Ad_eq P M hd, Ad_eq P M hd]
  unfold Ahat ahat0 ad
  ring

theorem norm_mu_sq (d : ℕ) (z : ℂ) :
    ‖((μ d : ℤ) : ℂ) ^ 2 * z‖ = ((μ d : ℤ) : ℝ) ^ 2 * ‖z‖ := by
  rw [norm_mul, norm_pow, Complex.norm_intCast, sq_abs]

/-- The per-`d` bound: `‖W_d‖ ‖A A − Â Â‖ ≤ K₀/λ² · μ²(d) σ(d)²/d · E_d`. -/
theorem perd_bound (hS : StmtSdmLe) (P : Polynomial ℝ) {A ε Y L₀ Cc Cm Cs CS : ℝ}
    (hsm : ∀ lM : ℝ, L₀ ≤ lM → ∀ x : ℝ, Y ≤ x → Real.log x ≤ lM → ∀ β : ℂ, ‖β‖ * lM ≤ A →
      ‖Smu P lM x β - mainS P lM x β‖ ≤ ε / lM)
    (hcr : ∀ lM : ℝ, 0 < lM → ∀ x : ℝ, 1 ≤ x → Real.log x ≤ lM → ∀ β : ℂ, ‖β‖ * lM ≤ A →
      ‖Smu P lM x β - mainS P lM x β‖ ≤ Cc / lM)
    (hCm : ∀ lM : ℝ, 0 < lM → ∀ y : ℝ, 1 ≤ y → Real.log y ≤ lM → ∀ γ : ℂ, ‖γ‖ * lM ≤ A →
      ‖mainS P lM y γ‖ ≤ Cm / lM)
    (hCs : ∀ lM : ℝ, 0 < lM → ∀ x : ℝ, ∀ m : ℕ, 1 ≤ m → (m : ℝ) ≤ x → Real.log x ≤ lM →
      ∀ γ : ℂ, ‖γ‖ * lM ≤ A →
        ‖(m : ℂ) ^ (-γ) * mainS P lM (x / m) γ - mainS P lM x γ‖ ≤ Cs * Real.log m / lM ^ 2)
    (hCS : ∀ lM : ℝ, 0 < lM → ∀ y : ℝ, 1 ≤ y → Real.log y ≤ lM → ∀ γ : ℂ, ‖γ‖ * lM ≤ A →
      ‖Smu P lM y γ‖ ≤ CS / lM)
    (hε : 0 ≤ ε) (hCc : 0 ≤ Cc) (hCm0 : 0 ≤ Cm) (hCs0 : 0 ≤ Cs) (hCS0 : 0 ≤ CS)
    {Y' Z : ℕ} (hYY : Y ≤ Y') (hY' : 1 ≤ Y') (hZ : 1 ≤ Z)
    {M d : ℕ} (hd : 1 ≤ d) (hdM : d ≤ M) (hlM : 0 < Real.log M) (hL : L₀ ≤ Real.log M)
    {α β : ℂ} (hα : ‖α‖ * Real.log M ≤ A) (hβ : ‖β‖ * Real.log M ≤ A) :
    ‖Wd α β d‖ * ‖Ad P M d β * Ad P M d α - Ahat P M d β * Ahat P M d α‖ ≤
      2 * Real.exp (2 * A) * (Real.exp A * CS + Cm + 1) / Real.log M ^ 2 *
        (((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 / d *
          (Real.exp A * ε * sig d + Cs * Real.log Z / Real.log M * sig d +
            Cs * Tl d Z + (Real.exp A * Cc + Cm) * Tl d (M / d / Y'))) := by
  set lM := Real.log M with hlMdef
  set E := Real.exp A * ε * sig d + Cs * Real.log Z / lM * sig d +
    Cs * Tl d Z + (Real.exp A * Cc + Cm) * Tl d (M / d / Y') with hE
  have hd0 : (0 : ℝ) < d := by exact_mod_cast hd
  rw [AA_eq P hd, norm_mu_sq]
  have hW := Wd_bound hS hd hdM hα hβ
  have err : ∀ γ : ℂ, ‖γ‖ * lM ≤ A → ‖ad P M d γ - ahat0 P M d γ‖ ≤ E / lM := fun γ hγ =>
    ad_err hS P hsm hcr hCm hCs hε hCc hCs0 hYY hY' hZ hd hdM hlM hL hγ
  have ba := ad_bound hS P hCS hCS0 hd hlM hα
  have bh := ahat0_bound P hCm hd hdM hlM hβ
  have eβ := err β hβ
  have eα := err α hα
  have hs := sig_nonneg d
  have hEd : 0 ≤ E := by
    have := Tl_nonneg hS hd Z; have := Tl_nonneg hS hd (M / d / Y')
    simp only [hE]; positivity
  set B := (Real.exp A * CS + Cm + 1) * sig d / lM with hB
  have q1 : ‖ad P M d α‖ ≤ B := by
    refine le_trans ba ?_
    rw [hB, div_le_div_iff_of_pos_right hlM]
    have : Real.exp A * CS ≤ Real.exp A * CS + Cm + 1 := by linarith
    exact mul_le_mul_of_nonneg_right this hs
  have q2 : ‖ahat0 P M d β‖ ≤ B := by
    refine le_trans bh ?_
    rw [hB, div_le_div_iff_of_pos_right hlM]
    have : Cm ≤ Real.exp A * CS + Cm + 1 := by
      have := mul_nonneg (Real.exp_pos A).le hCS0; linarith
    rw [mul_comm]; exact mul_le_mul_of_nonneg_right this hs
  have hprod : ‖ad P M d β * ad P M d α - ahat0 P M d β * ahat0 P M d α‖ ≤ 2 * B * (E / lM) := by
    have e : ad P M d β * ad P M d α - ahat0 P M d β * ahat0 P M d α =
        (ad P M d β - ahat0 P M d β) * ad P M d α +
          ahat0 P M d β * (ad P M d α - ahat0 P M d α) := by ring
    rw [e]
    refine le_trans (norm_add_le _ _) ?_
    rw [norm_mul, norm_mul]
    have r1 := mul_le_mul eβ q1 (norm_nonneg _) (by positivity)
    have r2 := mul_le_mul q2 eα (norm_nonneg _) (by positivity)
    have : E / lM * B + B * (E / lM) = 2 * B * (E / lM) := by ring
    linarith
  have hμ : 0 ≤ ((μ d : ℤ) : ℝ) ^ 2 := sq_nonneg _
  calc ‖Wd α β d‖ * (((μ d : ℤ) : ℝ) ^ 2 * ‖ad P M d β * ad P M d α -
        ahat0 P M d β * ahat0 P M d α‖)
      ≤ (Real.exp (2 * A) * sig d / d) * (((μ d : ℤ) : ℝ) ^ 2 * (2 * B * (E / lM))) :=
        mul_le_mul hW (mul_le_mul_of_nonneg_left hprod hμ) (by positivity) (by positivity)
    _ = _ := by rw [hB]; field_simp

/-- The real arithmetic closing layer (2). -/
theorem final_arith {K₀ A ε Cs C2 C4 C7 η εt lM lZ lY S2 S3 S4 : ℝ} (hK₀ : 0 < K₀)
    (hεt : 0 < εt) (hCs : 0 ≤ Cs) (hC2 : 0 ≤ C2) (hC7 : 0 ≤ C7) (hlZ : 0 ≤ lZ) (hl1 : 1 ≤ lM)
    (hεd : ε = εt / (8 * K₀ * Real.exp A * (C2 + 1))) (hηd : η = εt / (8 * K₀ * (Cs + 1)))
    (hlZb : 8 * K₀ * Cs * lZ * C2 / εt ≤ lM) (hlYb : 4 * K₀ * C7 * C4 * (1 + lY) / εt ≤ lM)
    (s2 : S2 ≤ C2 * (1 + lM)) (s3 : S3 ≤ η * (1 + lM)) (s4 : S4 ≤ C4 * (1 + lY)) :
    K₀ / lM ^ 2 * ((Real.exp A * ε + Cs * lZ / lM) * S2 + Cs * S3 + C7 * S4) ≤ εt / lM := by
  have hlM : 0 < lM := by linarith
  have hE := Real.exp_pos A
  have hε0 : 0 ≤ ε := by rw [hεd]; positivity
  have hη0 : 0 ≤ η := by rw [hηd]; positivity
  have hq : (1 + lM) / lM ≤ 2 := by rw [div_le_iff₀ hlM]; linarith
  have hc1 : 0 ≤ Real.exp A * ε + Cs * lZ / lM := by positivity
  have t1 := mul_le_mul_of_nonneg_left s2 hc1
  have t2 := mul_le_mul_of_nonneg_left s3 hCs
  have t3 := mul_le_mul_of_nonneg_left s4 hC7
  have hK : 0 ≤ K₀ / lM ^ 2 := by positivity
  have u1 := mul_le_mul_of_nonneg_left t1 hK
  have u2 := mul_le_mul_of_nonneg_left t2 hK
  have u3 := mul_le_mul_of_nonneg_left t3 hK
  have a1 : K₀ * Real.exp A * ε * C2 ≤ εt / 8 := by
    rw [hεd]
    have : K₀ * Real.exp A * (εt / (8 * K₀ * Real.exp A * (C2 + 1))) * C2 =
        εt / 8 * (C2 / (C2 + 1)) := by field_simp
    rw [this]
    have : C2 / (C2 + 1) ≤ 1 := by rw [div_le_one (by positivity)]; linarith
    calc εt / 8 * (C2 / (C2 + 1)) ≤ εt / 8 * 1 := mul_le_mul_of_nonneg_left this (by positivity)
      _ = εt / 8 := mul_one _
  have a2 : K₀ * Cs * η ≤ εt / 8 := by
    rw [hηd]
    have : K₀ * Cs * (εt / (8 * K₀ * (Cs + 1))) = εt / 8 * (Cs / (Cs + 1)) := by field_simp
    rw [this]
    have : Cs / (Cs + 1) ≤ 1 := by rw [div_le_one (by positivity)]; linarith
    calc εt / 8 * (Cs / (Cs + 1)) ≤ εt / 8 * 1 := mul_le_mul_of_nonneg_left this (by positivity)
      _ = εt / 8 := mul_one _
  have a3 : K₀ * Cs * lZ * C2 ≤ lM * εt / 8 := by
    rw [div_le_iff₀ hεt] at hlZb; linarith
  have a4 : K₀ * C7 * C4 * (1 + lY) ≤ lM * εt / 4 := by
    rw [div_le_iff₀ hεt] at hlYb; linarith
  have b1 : K₀ / lM ^ 2 * ((Real.exp A * ε + Cs * lZ / lM) * (C2 * (1 + lM))) ≤ εt / 2 / lM := by
    have e1 : K₀ / lM ^ 2 * ((Real.exp A * ε + Cs * lZ / lM) * (C2 * (1 + lM))) =
        ((K₀ * Real.exp A * ε * C2) + (K₀ * Cs * lZ * C2) / lM) * ((1 + lM) / lM) / lM := by
      field_simp
    rw [e1]
    refine div_le_div_of_nonneg_right ?_ hlM.le
    have : (K₀ * Cs * lZ * C2) / lM ≤ εt / 8 := by rw [div_le_iff₀ hlM]; linarith
    have h0 : 0 ≤ (K₀ * Real.exp A * ε * C2) + (K₀ * Cs * lZ * C2) / lM := by positivity
    calc ((K₀ * Real.exp A * ε * C2) + (K₀ * Cs * lZ * C2) / lM) * ((1 + lM) / lM)
        ≤ ((K₀ * Real.exp A * ε * C2) + (K₀ * Cs * lZ * C2) / lM) * 2 :=
          mul_le_mul_of_nonneg_left hq h0
      _ ≤ (εt / 8 + εt / 8) * 2 := by nlinarith
      _ = εt / 2 := by ring
  have b2 : K₀ / lM ^ 2 * (Cs * (η * (1 + lM))) ≤ εt / 4 / lM := by
    have e1 : K₀ / lM ^ 2 * (Cs * (η * (1 + lM))) = (K₀ * Cs * η) * ((1 + lM) / lM) / lM := by
      field_simp
    rw [e1]
    refine div_le_div_of_nonneg_right ?_ hlM.le
    have h0 : 0 ≤ K₀ * Cs * η := by positivity
    calc (K₀ * Cs * η) * ((1 + lM) / lM) ≤ (K₀ * Cs * η) * 2 := mul_le_mul_of_nonneg_left hq h0
      _ ≤ εt / 8 * 2 := by linarith
      _ = εt / 4 := by ring
  have b3 : K₀ / lM ^ 2 * (C7 * (C4 * (1 + lY))) ≤ εt / 4 / lM := by
    have e1 : K₀ / lM ^ 2 * (C7 * (C4 * (1 + lY))) = (K₀ * C7 * C4 * (1 + lY)) / lM / lM := by
      field_simp
    rw [e1]
    refine div_le_div_of_nonneg_right ?_ hlM.le
    rw [div_le_iff₀ hlM]; linarith
  have e : K₀ / lM ^ 2 * ((Real.exp A * ε + Cs * lZ / lM) * S2 + Cs * S3 + C7 * S4) =
      K₀ / lM ^ 2 * ((Real.exp A * ε + Cs * lZ / lM) * S2) + K₀ / lM ^ 2 * (Cs * S3) +
        K₀ / lM ^ 2 * (C7 * S4) := by ring
  rw [e]
  have : εt / 2 / lM + εt / 4 / lM + εt / 4 / lM = εt / lM := by ring
  linarith

/-- **Layer (2) from the arithmetic**: the four facts on `⟨d⟩` give `StmtAdApprox P A`. -/
theorem stmtAdApprox_of_arith (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) {A : ℝ} (hA : 0 ≤ A)
    (hS : StmtSdmLe) (h2 : StmtMeanSig3) (h3 : StmtTailFixed) (h4 : StmtTailAvg) :
    StmtAdApprox P A := by
  intro εt hεt
  obtain ⟨CS, hCS0, hCS⟩ := Smu_bound P hP0 hA
  obtain ⟨Cm, hCm0, hCm⟩ := mainS_bound P hA
  obtain ⟨Cs, hCs0, hCs⟩ := mainS_shift P hA
  obtain ⟨Cc, hCc0, hCc⟩ := muSmooth_crude P hP0 hA
  obtain ⟨C2, hC20, hC2⟩ := h2
  obtain ⟨C4, hC40, hC4⟩ := h4
  set K₀ := 2 * Real.exp (2 * A) * (Real.exp A * CS + Cm + 1) with hK₀
  have hK₀0 : 0 < K₀ := by positivity
  set C7 := Real.exp A * Cc + Cm with hC7
  have hC70 : 0 ≤ C7 := by positivity
  set ε := εt / (8 * K₀ * Real.exp A * (C2 + 1)) with hεdef
  have hε0 : 0 < ε := by positivity
  set η := εt / (8 * K₀ * (Cs + 1)) with hηdef
  have hη0 : 0 < η := by positivity
  obtain ⟨Z₀, hZ₀⟩ := h3 η hη0
  set Z := max Z₀ 1 with hZdef
  have hZ1 : 1 ≤ Z := le_max_right _ _
  obtain ⟨Y, hY1, L₀, -, hsm⟩ := muSmoothR P hP0 hA hε0
  set Y' := ⌈Y⌉₊ with hY'def
  have hYY : Y ≤ Y' := Nat.le_ceil Y
  have hY'1 : 1 ≤ Y' := by have : (1 : ℝ) ≤ Y' := le_trans hY1 hYY; exact_mod_cast this
  have hlZ : 0 ≤ Real.log Z := Real.log_nonneg (by exact_mod_cast hZ1)
  set L₁ := max (max 1 L₀) (max (8 * K₀ * Cs * Real.log Z * C2 / εt)
    (4 * K₀ * C7 * C4 * (1 + Real.log Y') / εt)) with hL₁
  refine ⟨⌈Real.exp L₁⌉₊, fun M hM α β hα hβ => ?_⟩
  have hMe : Real.exp L₁ ≤ M := le_trans (Nat.le_ceil _) (by exact_mod_cast hM)
  have hlL : L₁ ≤ Real.log M := by
    rw [← Real.log_exp L₁]; exact Real.log_le_log (Real.exp_pos _) hMe
  have hl1 : 1 ≤ Real.log M := le_trans (le_trans (le_max_left _ _) (le_max_left _ _)) hlL
  have hlM : 0 < Real.log M := by linarith
  have hlL0 : L₀ ≤ Real.log M := le_trans (le_trans (le_max_right _ _) (le_max_left _ _)) hlL
  have hlZb : 8 * K₀ * Cs * Real.log Z * C2 / εt ≤ Real.log M :=
    le_trans (le_trans (le_max_left _ _) (le_max_right _ _)) hlL
  have hlYb : 4 * K₀ * C7 * C4 * (1 + Real.log Y') / εt ≤ Real.log M :=
    le_trans (le_trans (le_max_right _ _) (le_max_right _ _)) hlL
  have hperd := fun d (hdm : d ∈ Icc 1 M) => perd_bound hS P hsm hCc hCm hCs hCS hε0.le hCc0
    hCm0 hCs0 hCS0 hYY hY'1 hZ1 (Finset.mem_Icc.mp hdm).1 (Finset.mem_Icc.mp hdm).2 hlM hlL0 hα hβ
  refine le_trans (Finset.sum_le_sum hperd) ?_
  rw [← Finset.mul_sum]
  have hsplit : ∑ d ∈ Icc 1 M, ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 / d *
      (Real.exp A * ε * sig d + Cs * Real.log Z / Real.log M * sig d + Cs * Tl d Z +
        (Real.exp A * Cc + Cm) * Tl d (M / d / Y')) =
      (Real.exp A * ε + Cs * Real.log Z / Real.log M) *
          (∑ d ∈ Icc 1 M, ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 3 / d) +
        Cs * (∑ d ∈ Icc 1 M, ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 * Tl d Z / d) +
        C7 * (∑ d ∈ Icc 1 M, ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 * Tl d (M / d / Y') / d) := by
    simp only [Finset.mul_sum, ← Finset.sum_add_distrib]
    refine Finset.sum_congr rfl fun d _ => ?_
    rw [hC7]; ring
  have s3 : ∑ d ∈ Icc 1 M, ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 * Tl d Z / d ≤
      η * (1 + Real.log M) := by
    refine le_trans (Finset.sum_le_sum fun d _ => ?_) (hZ₀ M)
    have : Tl d Z ≤ Tl d Z₀ := Tl_anti d (le_max_left _ _)
    have h0 : (0 : ℝ) ≤ ((μ d : ℤ) : ℝ) ^ 2 * sig d ^ 2 := by have := sig_nonneg d; positivity
    exact div_le_div_of_nonneg_right (mul_le_mul_of_nonneg_left this h0) (Nat.cast_nonneg _)
  rw [hsplit]
  exact final_arith hK₀0 hεt hCs0 hC20 hC70 hlZ hl1 hεdef hηdef hlZb hlYb (hC2 M) s3
    (hC4 M Y' hY'1)

end

/-- info: 'SdiagLead.stmtAdApprox_of_arith' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtAdApprox_of_arith

/-- info: 'SdiagLead.ad_err' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ad_err

/-- info: 'SdiagLead.Wd_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Wd_bound

end SdiagLead
