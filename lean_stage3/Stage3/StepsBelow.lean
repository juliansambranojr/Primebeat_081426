/-
StepsBelow — block R9 of `lean_stage3/design/runs.md`, the turned steps. 2026-11-23.

At a zero `ρ₀` the turned steps to a cutoff, less their smooth term, are not
`O(N^δ)` for any `δ < Re ρ₀ − Re s`. The route is `ThetaConverse` with the
staircase `B(x) = Σ_{n≤x} a_n·(x − n)`, `a_n = Λ(n)·n^(−s)`, in place of `ψ`:

  B, B_nat, B_interp    the staircase; `B(N) = N·S(N,s)`; linear between integers
  K_one                 `K(1) = κ·N^(1−s) + c₀ + c₁/N`, `κ = 1/((1−s)(2−s))`
  D_le                  the bound at integers gives `‖B(x) − κ·x^(2−s)‖ ≤ C'·x^(1+δ)`
  term_integral         `∫_1^∞ (x−n)_+·x^(−w−2) = n^(−w)/(w(w+1))`
  mellin_identity       Re w > 1+δ ⊢ `−ζ'/ζ(s+w)/(w(w+1)) = M[R](−w−1) + κ/(s+w−1)`
  Fz_differentiableAt   the right side times `w(w+1)` is analytic on Re(s+w) > Re s + δ, s+w ≠ 1
  zeta_ne_zero_of_agree V3–V4 of `ThetaConverse` for any such continuation
  rain_steps            the conclusion, by contradiction

No side hypothesis is added: `δ ≥ 0` and `δ < Re ρ₀ − Re s` give `Re s < Re ρ₀ < 1`,
so `s ≠ 1` and `s ≠ 2`; and `ρ₀ ≠ s` follows the same way. The smooth term's
constant and `1/N` parts are absorbed into `x^(1+δ)` since `δ ≥ 0`; only
`κ·x^(2−s)` is subtracted. The pole used is that of `−ζ'/ζ` at `ρ₀` itself,
through the factorisation of `ζ` at `ρ₀` as in V4.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.StepsRate
import Stage3.ThetaConverse

namespace StepsBelow

open Complex Set MeasureTheory Topology Filter StepsPeak Kadiri

local notation "ζ" => riemannZeta

noncomputable section

/-! ## The staircase -/

/-- The weight `a_n = Λ(n)·n^(−s)`. -/
def coef (s : ℂ) (n : ℕ) : ℂ := (ArithmeticFunction.vonMangoldt n : ℂ) * (n : ℂ) ^ (-s)

/-- The tent `(x − n)_+`. -/
def tent (n : ℕ) (x : ℝ) : ℝ := max (x - n) 0

/-- The staircase truncated to the first `K` steps. -/
def Bk (s : ℂ) (K : ℕ) (x : ℝ) : ℂ := ∑ n ∈ Finset.range K, coef s n * (tent n x : ℂ)

/-- The staircase `B(x) = Σ_{n≤x} a_n·(x − n)`. -/
def B (s : ℂ) (x : ℝ) : ℂ := Bk s (⌊x⌋₊ + 1) x

theorem coef_zero (s : ℂ) : coef s 0 = 0 := by simp [coef]

theorem tent_nonneg (n : ℕ) (x : ℝ) : 0 ≤ tent n x := le_max_right _ _

theorem tent_eq_zero {n : ℕ} {x : ℝ} (h : x ≤ n) : tent n x = 0 :=
  max_eq_right (by linarith)

theorem tent_eq {n : ℕ} {x : ℝ} (h : (n:ℝ) ≤ x) : tent n x = x - n :=
  max_eq_left (by linarith)

theorem Bk_eq {s : ℂ} {K K' : ℕ} {x : ℝ} (hK : x < K) (hKK : K ≤ K') :
    Bk s K' x = Bk s K x := by
  unfold Bk
  symm
  refine Finset.sum_subset (Finset.range_mono hKK) (fun n _ hn => ?_)
  have hn' : K ≤ n := by simpa using hn
  have : (K:ℝ) ≤ n := by exact_mod_cast hn'
  rw [tent_eq_zero (by linarith), Complex.ofReal_zero, mul_zero]

theorem lt_floor_succ (x : ℝ) : x < ((⌊x⌋₊ + 1 : ℕ) : ℝ) := by
  push_cast; exact Nat.lt_floor_add_one x

theorem B_eq_Bk {s : ℂ} {K : ℕ} {x : ℝ} (hK : x < K) : B s x = Bk s K x := by
  unfold B
  rcases le_total K (⌊x⌋₊ + 1) with h | h
  · exact Bk_eq hK h
  · exact (Bk_eq (lt_floor_succ x) h).symm

theorem Bk_continuous (s : ℂ) (K : ℕ) : Continuous (Bk s K) := by
  unfold Bk tent
  fun_prop

theorem B_continuous (s : ℂ) : Continuous (B s) := by
  rw [continuous_iff_continuousAt]
  intro x
  have hev : Bk s (⌊x⌋₊ + 1) =ᶠ[𝓝 x] B s := by
    filter_upwards [Iio_mem_nhds (lt_floor_succ x)] with y hy
    exact (B_eq_Bk hy).symm
  exact (Bk_continuous s _).continuousAt.congr hev

/-- **At the integers** the staircase is the cutoff times the turned steps. -/
theorem B_nat (s : ℂ) {N : ℕ} (hN : 2 ≤ N) : B s N = (N : ℂ) * S N s := by
  have hN0 : (N:ℂ) ≠ 0 := by
    have : (N:ℝ) ≠ 0 := by
      have : (2:ℝ) ≤ N := by exact_mod_cast hN
      linarith
    exact_mod_cast this
  rw [B_eq_Bk (K := N + 1) (by push_cast; linarith), Bk, S, Finset.mul_sum,
    Nat.range_succ_eq_Icc_zero]
  refine Finset.sum_congr rfl (fun n hn => ?_)
  have hn' : n ≤ N := (Finset.mem_Icc.mp hn).2
  rw [tent_eq (by exact_mod_cast hn')]
  unfold coef ramp
  push_cast
  field_simp
  try ring

/-- **Linear between the integers.** -/
theorem B_interp (s : ℂ) (N : ℕ) {x : ℝ} (h1 : (N:ℝ) ≤ x) (h2 : x ≤ N + 1) :
    B s x = ((1 - (x - N) : ℝ) : ℂ) * B s N + ((x - N : ℝ) : ℂ) * B s ((N + 1 : ℕ) : ℝ) := by
  have hK : ∀ y : ℝ, y ≤ N + 1 → y < ((N + 2 : ℕ) : ℝ) := fun y hy => by push_cast; linarith
  rw [B_eq_Bk (hK x h2), B_eq_Bk (hK N (by linarith)),
    B_eq_Bk (hK _ (by push_cast; linarith))]
  unfold Bk
  rw [Finset.mul_sum, Finset.mul_sum, ← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl (fun n _ => ?_)
  have ht : tent n x = (1 - (x - N)) * tent n N + (x - N) * tent n ((N + 1 : ℕ) : ℝ) := by
    by_cases hn : n ≤ N
    · have hn' : (n:ℝ) ≤ N := by exact_mod_cast hn
      rw [tent_eq (by linarith), tent_eq hn', tent_eq (by push_cast; linarith)]
      push_cast; ring
    · have hn' : (N:ℝ) + 1 ≤ n := by
        have : N + 1 ≤ n := by omega
        exact_mod_cast this
      rw [tent_eq_zero (by linarith), tent_eq_zero (by linarith),
        tent_eq_zero (by push_cast; linarith)]
      ring
  rw [ht]
  push_cast
  ring

/-! ## The smooth term -/

/-- `κ = 1/((1−s)(2−s))`. -/
def kap (s : ℂ) : ℂ := 1 / ((1 - s) * (2 - s))

def c0 (s : ℂ) : ℂ := -s * 2 ^ (1 - s) / (1 - s)

def c1 (s : ℂ) : ℂ := (s - 1) * 2 ^ (2 - s) / (2 - s)

theorem natC_ne_zero {N : ℕ} (hN : 2 ≤ N) : (N:ℂ) ≠ 0 := by
  have : (N:ℝ) ≠ 0 := by
    have : (2:ℝ) ≤ N := by exact_mod_cast hN
    linarith
  exact_mod_cast this

theorem natC_cpow_two_sub {N : ℕ} (hN : 2 ≤ N) (s : ℂ) :
    (N:ℂ) ^ (2 - s) = (N:ℂ) ^ (1 - s) * N := by
  rw [show (2:ℂ) - s = (1 - s) + 1 by ring, Complex.cpow_add _ _ (natC_ne_zero hN),
    Complex.cpow_one]

/-- **The smooth term in closed form**: `K(1) = κ·N^(1−s) + c₀ + c₁/N`. -/
theorem K_one {N : ℕ} (hN : 2 ≤ N) {s : ℂ} (hs1 : s ≠ 1) (hs2 : s ≠ 2) :
    K N s 1 = kap s * (N:ℂ) ^ (1 - s) + c0 s + c1 s / N := by
  have hN0 := natC_ne_zero hN
  have h1 : (1:ℂ) - s ≠ 0 := sub_ne_zero.mpr (Ne.symm hs1)
  have h2 : (2:ℂ) - s ≠ 0 := sub_ne_zero.mpr (Ne.symm hs2)
  rw [K_eq hN (Ne.symm hs1) (fun h => hs2 (by linear_combination -h)),
    show (1:ℂ) - s + 1 = 2 - s by ring, natC_cpow_two_sub hN]
  unfold kap c0 c1
  generalize (N:ℂ) ^ (1 - s) = P
  generalize (2:ℂ) ^ (1 - s) = Q
  generalize (2:ℂ) ^ (2 - s) = R
  field_simp
  try ring

/-- The staircase less its smooth part. -/
def D (s : ℂ) (x : ℝ) : ℂ := B s x - kap s * (x : ℂ) ^ (2 - s)

theorem D_nat {N : ℕ} (hN : 2 ≤ N) {s : ℂ} (hs1 : s ≠ 1) (hs2 : s ≠ 2) :
    D s N = (N:ℂ) * (S N s - K N s 1) + (N:ℂ) * c0 s + c1 s := by
  have hN0 := natC_ne_zero hN
  rw [D, B_nat s hN, K_one hN hs1 hs2, Complex.ofReal_natCast, natC_cpow_two_sub hN]
  field_simp
  try ring

theorem D_nat_le {N : ℕ} (hN : 2 ≤ N) {s : ℂ} (hs1 : s ≠ 1) (hs2 : s ≠ 2) {δ : ℝ}
    (hδ : 0 ≤ δ) {C : ℝ} (H : ‖S N s - K N s 1‖ ≤ C * (N:ℝ) ^ δ) :
    ‖D s N‖ ≤ (|C| + ‖c0 s‖ + ‖c1 s‖) * (N:ℝ) ^ (1 + δ) := by
  have hN1 : (1:ℝ) ≤ N := by exact_mod_cast (by omega : 1 ≤ N)
  have hNpos : (0:ℝ) < N := by linarith
  have hP : (N:ℝ) ^ (1 + δ) = N * N ^ δ := by rw [Real.rpow_add hNpos, Real.rpow_one]
  have hNd : 1 ≤ (N:ℝ) ^ δ := Real.one_le_rpow hN1 hδ
  have hH : ‖S N s - K N s 1‖ ≤ |C| * (N:ℝ) ^ δ :=
    H.trans (mul_le_mul_of_nonneg_right (le_abs_self C) (by positivity))
  have e1 := mul_le_mul_of_nonneg_left hH hNpos.le
  have hNN : 1 ≤ (N:ℝ) * N ^ δ := by nlinarith
  have e2 : (N:ℝ) * ‖c0 s‖ ≤ N * N ^ δ * ‖c0 s‖ := by
    nlinarith [mul_le_mul_of_nonneg_left hNd (mul_nonneg hNpos.le (norm_nonneg (c0 s)))]
  have e3 : ‖c1 s‖ ≤ N * N ^ δ * ‖c1 s‖ := by
    nlinarith [mul_le_mul_of_nonneg_right hNN (norm_nonneg (c1 s))]
  rw [D_nat hN hs1 hs2]
  calc ‖(N:ℂ) * (S N s - K N s 1) + (N:ℂ) * c0 s + c1 s‖
      ≤ ‖(N:ℂ) * (S N s - K N s 1)‖ + ‖(N:ℂ) * c0 s‖ + ‖c1 s‖ := norm_add₃_le
    _ = N * ‖S N s - K N s 1‖ + N * ‖c0 s‖ + ‖c1 s‖ := by
        rw [norm_mul, norm_mul, Complex.norm_natCast]
    _ ≤ (|C| + ‖c0 s‖ + ‖c1 s‖) * (N:ℝ) ^ (1 + δ) := by
        rw [hP]; nlinarith

/-- A difference of the smooth power, by the integral of its derivative. -/
theorem pow_diff_le {s : ℂ} (hs : 0 < s.re) (hs2 : s ≠ 2) {x y : ℝ} (hx : 1 ≤ x)
    (hxy : x ≤ y) :
    ‖(y:ℂ) ^ (2 - s) - (x:ℂ) ^ (2 - s)‖ ≤ ‖2 - s‖ * (y * (y - x)) := by
  have h0 : (0:ℝ) ∉ Set.uIcc x y := by
    rw [Set.uIcc_of_le hxy]; intro h; linarith [h.1]
  have hr : (1 - s) ≠ -1 := fun h => hs2 (by linear_combination -h)
  have hI := integral_cpow (a := x) (b := y) (r := 1 - s) (Or.inr ⟨hr, h0⟩)
  rw [show 1 - s + 1 = 2 - s by ring] at hI
  have h2 : (2:ℂ) - s ≠ 0 := sub_ne_zero.mpr (Ne.symm hs2)
  have he : (y:ℂ) ^ (2 - s) - (x:ℂ) ^ (2 - s) = (2 - s) * ∫ u in x..y, (u:ℂ) ^ (1 - s) := by
    rw [hI]; field_simp
  have hbd : ∀ u ∈ Set.uIoc x y, ‖(fun u : ℝ => (u:ℂ) ^ (1 - s)) u‖ ≤ y := by
    intro u hu
    rw [Set.uIoc_of_le hxy] at hu
    have hu0 : 0 < u := by linarith [hu.1]
    show ‖(u:ℂ) ^ (1 - s)‖ ≤ y
    rw [Complex.norm_cpow_eq_rpow_re_of_pos hu0]
    calc u ^ (1 - s).re ≤ u ^ (1:ℝ) :=
          Real.rpow_le_rpow_of_exponent_le (by linarith [hu.1]) (by simp; linarith)
      _ = u := Real.rpow_one u
      _ ≤ y := hu.2
  have hb := intervalIntegral.norm_integral_le_of_norm_le_const hbd
  rw [abs_of_nonneg (by linarith)] at hb
  rw [he, norm_mul]
  exact mul_le_mul_of_nonneg_left hb (norm_nonneg _)

/-- **From the integers to the reals.** A bound `‖S(N,s) − K(1)‖ ≤ C·N^δ` from `N₁` on
gives `‖B(x) − κ·x^(2−s)‖ ≤ C'·x^(1+δ)` from `N₁` on. -/
theorem D_le {s : ℂ} (hs : 0 < s.re) (hs1 : s ≠ 1) (hs2 : s ≠ 2) {δ : ℝ} (hδ : 0 ≤ δ)
    {C : ℝ} {N₁ : ℕ} (hN₁ : 2 ≤ N₁)
    (H : ∀ N : ℕ, N₁ ≤ N → ‖S N s - K N s 1‖ ≤ C * (N:ℝ) ^ δ) {x : ℝ} (hx : (N₁:ℝ) ≤ x) :
    ‖D s x‖ ≤ ((|C| + ‖c0 s‖ + ‖c1 s‖) * 2 ^ (1 + δ) + 2 * (‖kap s‖ * ‖2 - s‖))
      * x ^ (1 + δ) := by
  have hN₁' : (2:ℝ) ≤ N₁ := by exact_mod_cast hN₁
  have hx0 : 0 ≤ x := by linarith
  have hx1 : 1 ≤ x := by linarith
  have hNx : ((⌊x⌋₊ : ℕ) : ℝ) ≤ x := Nat.floor_le hx0
  have hxN : x < ((⌊x⌋₊ : ℕ) : ℝ) + 1 := Nat.lt_floor_add_one x
  have hN1N : N₁ ≤ ⌊x⌋₊ := Nat.le_floor hx
  have hN2 : 2 ≤ ⌊x⌋₊ := le_trans hN₁ hN1N
  have hN2' : (2:ℝ) ≤ ((⌊x⌋₊ : ℕ) : ℝ) := by exact_mod_cast hN2
  have hC₂0 : 0 ≤ |C| + ‖c0 s‖ + ‖c1 s‖ := by positivity
  have hD0 := D_nat_le hN2 hs1 hs2 hδ (H ⌊x⌋₊ hN1N)
  have hD1 := D_nat_le (by omega : 2 ≤ ⌊x⌋₊ + 1) hs1 hs2 hδ (H (⌊x⌋₊ + 1) (by omega))
  have hQ1 : (1:ℝ) ≤ 2 ^ (1 + δ) := Real.one_le_rpow (by norm_num) (by linarith)
  have hP0 : 0 ≤ x ^ (1 + δ) := by positivity
  have hxP : x ≤ x ^ (1 + δ) := by
    calc x = x ^ (1:ℝ) := (Real.rpow_one x).symm
      _ ≤ x ^ (1 + δ) := Real.rpow_le_rpow_of_exponent_le hx1 (by linarith)
  have hNP : ((⌊x⌋₊ : ℕ) : ℝ) ^ (1 + δ) ≤ 2 ^ (1 + δ) * x ^ (1 + δ) := by
    calc ((⌊x⌋₊ : ℕ) : ℝ) ^ (1 + δ) ≤ x ^ (1 + δ) :=
          Real.rpow_le_rpow (by linarith) hNx (by linarith)
      _ ≤ 2 ^ (1 + δ) * x ^ (1 + δ) := le_mul_of_one_le_left hP0 hQ1
  have hN1P : ((⌊x⌋₊ + 1 : ℕ) : ℝ) ^ (1 + δ) ≤ 2 ^ (1 + δ) * x ^ (1 + δ) := by
    calc ((⌊x⌋₊ + 1 : ℕ) : ℝ) ^ (1 + δ) ≤ (2 * x) ^ (1 + δ) :=
          Real.rpow_le_rpow (by positivity) (by push_cast; linarith) (by linarith)
      _ = 2 ^ (1 + δ) * x ^ (1 + δ) := Real.mul_rpow (by norm_num) hx0
  have hαβ : ((1 - (x - ⌊x⌋₊) : ℝ) : ℂ) + ((x - ⌊x⌋₊ : ℝ) : ℂ) = 1 := by push_cast; ring
  have hB := B_interp s ⌊x⌋₊ hNx hxN.le
  have hid : D s x = ((1 - (x - ⌊x⌋₊) : ℝ) : ℂ) * D s (⌊x⌋₊ : ℕ)
      + ((x - ⌊x⌋₊ : ℝ) : ℂ) * D s ((⌊x⌋₊ + 1 : ℕ) : ℝ)
      + kap s * (((1 - (x - ⌊x⌋₊) : ℝ) : ℂ)
          * ((((⌊x⌋₊ : ℕ) : ℝ) : ℂ) ^ (2 - s) - (x:ℂ) ^ (2 - s))
        + ((x - ⌊x⌋₊ : ℝ) : ℂ) * ((((⌊x⌋₊ + 1 : ℕ) : ℝ) : ℂ) ^ (2 - s) - (x:ℂ) ^ (2 - s))) := by
    unfold D
    rw [hB]
    linear_combination (kap s * (x:ℂ) ^ (2 - s)) * hαβ
  have ht0 : 0 ≤ x - ⌊x⌋₊ := by linarith
  have ht1 : 0 ≤ 1 - (x - ⌊x⌋₊) := by linarith
  have a1 : ‖((1 - (x - ⌊x⌋₊) : ℝ) : ℂ) * D s (⌊x⌋₊ : ℕ)‖
      ≤ (1 - (x - ⌊x⌋₊)) * ((|C| + ‖c0 s‖ + ‖c1 s‖) * (2 ^ (1 + δ) * x ^ (1 + δ))) := by
    rw [norm_mul, Complex.norm_real, Real.norm_of_nonneg ht1]
    exact mul_le_mul_of_nonneg_left (hD0.trans (mul_le_mul_of_nonneg_left hNP hC₂0)) ht1
  have a2 : ‖((x - ⌊x⌋₊ : ℝ) : ℂ) * D s ((⌊x⌋₊ + 1 : ℕ) : ℝ)‖
      ≤ (x - ⌊x⌋₊) * ((|C| + ‖c0 s‖ + ‖c1 s‖) * (2 ^ (1 + δ) * x ^ (1 + δ))) := by
    rw [norm_mul, Complex.norm_real, Real.norm_of_nonneg ht0]
    exact mul_le_mul_of_nonneg_left (hD1.trans (mul_le_mul_of_nonneg_left hN1P hC₂0)) ht0
  have hq0 : 0 ≤ ‖(2:ℂ) - s‖ := norm_nonneg _
  have b1 : ‖(((⌊x⌋₊ : ℕ) : ℝ) : ℂ) ^ (2 - s) - (x:ℂ) ^ (2 - s)‖ ≤ ‖2 - s‖ * (2 * x) := by
    rw [norm_sub_rev]
    refine (pow_diff_le hs hs2 (by linarith) hNx).trans ?_
    apply mul_le_mul_of_nonneg_left _ hq0
    nlinarith
  have b2 : ‖((((⌊x⌋₊ + 1 : ℕ) : ℝ) : ℂ)) ^ (2 - s) - (x:ℂ) ^ (2 - s)‖ ≤ ‖2 - s‖ * (2 * x) := by
    refine (pow_diff_le hs hs2 hx1 (by push_cast; linarith)).trans ?_
    apply mul_le_mul_of_nonneg_left _ hq0
    push_cast
    nlinarith
  have a3 : ‖kap s * (((1 - (x - ⌊x⌋₊) : ℝ) : ℂ)
          * ((((⌊x⌋₊ : ℕ) : ℝ) : ℂ) ^ (2 - s) - (x:ℂ) ^ (2 - s))
        + ((x - ⌊x⌋₊ : ℝ) : ℂ) * ((((⌊x⌋₊ + 1 : ℕ) : ℝ) : ℂ) ^ (2 - s) - (x:ℂ) ^ (2 - s)))‖
      ≤ 2 * (‖kap s‖ * ‖2 - s‖) * x ^ (1 + δ) := by
    rw [norm_mul]
    have hin := norm_add_le (((1 - (x - ⌊x⌋₊) : ℝ) : ℂ)
          * ((((⌊x⌋₊ : ℕ) : ℝ) : ℂ) ^ (2 - s) - (x:ℂ) ^ (2 - s)))
        (((x - ⌊x⌋₊ : ℝ) : ℂ) * ((((⌊x⌋₊ + 1 : ℕ) : ℝ) : ℂ) ^ (2 - s) - (x:ℂ) ^ (2 - s)))
    rw [norm_mul, norm_mul, Complex.norm_real, Complex.norm_real, Real.norm_of_nonneg ht1,
      Real.norm_of_nonneg ht0] at hin
    have c1' := mul_le_mul_of_nonneg_left b1 ht1
    have c2' := mul_le_mul_of_nonneg_left b2 ht0
    have hsum : ‖((1 - (x - ⌊x⌋₊) : ℝ) : ℂ)
          * ((((⌊x⌋₊ : ℕ) : ℝ) : ℂ) ^ (2 - s) - (x:ℂ) ^ (2 - s))
        + ((x - ⌊x⌋₊ : ℝ) : ℂ) * ((((⌊x⌋₊ + 1 : ℕ) : ℝ) : ℂ) ^ (2 - s) - (x:ℂ) ^ (2 - s))‖
        ≤ ‖2 - s‖ * (2 * x) := by nlinarith
    have hk0 : 0 ≤ ‖kap s‖ := norm_nonneg _
    have := mul_le_mul_of_nonneg_left hsum hk0
    have h4 := mul_le_mul_of_nonneg_left hxP (by positivity : 0 ≤ 2 * (‖kap s‖ * ‖2 - s‖))
    nlinarith
  rw [hid]
  have h5 := norm_add₃_le (a := ((1 - (x - ⌊x⌋₊) : ℝ) : ℂ) * D s (⌊x⌋₊ : ℕ))
    (b := ((x - ⌊x⌋₊ : ℝ) : ℂ) * D s ((⌊x⌋₊ + 1 : ℕ) : ℝ))
    (c := kap s * (((1 - (x - ⌊x⌋₊) : ℝ) : ℂ)
          * ((((⌊x⌋₊ : ℕ) : ℝ) : ℂ) ^ (2 - s) - (x:ℂ) ^ (2 - s))
        + ((x - ⌊x⌋₊ : ℝ) : ℂ) * ((((⌊x⌋₊ + 1 : ℕ) : ℝ) : ℂ) ^ (2 - s) - (x:ℂ) ^ (2 - s))))
  nlinarith

/-! ## The Mellin transform of the remainder -/

/-- The remainder `B(x) − κ·x^(2−s)` on `(1, ∞)`, zero below. -/
def Rtr (s : ℂ) : ℝ → ℂ := Set.indicator (Set.Ioi 1) (D s)

theorem D_continuousOn (s : ℂ) : ContinuousOn (D s) (Ioi 0) :=
  (B_continuous s).continuousOn.sub (continuousOn_const.mul (cont_cpow (2 - s)))

theorem Rtr_locallyIntegrable (s : ℂ) : LocallyIntegrableOn (Rtr s) (Ioi 0) := by
  rw [locallyIntegrableOn_iff isOpen_Ioi.isLocallyClosed]
  intro k hk hkc
  exact (((D_continuousOn s).mono hk).integrableOn_compact hkc).indicator measurableSet_Ioi

theorem Rtr_bot (s : ℂ) (b : ℝ) : Rtr s =O[𝓝[>] 0] (fun x : ℝ => x ^ (-b)) := by
  apply Asymptotics.IsBigO.of_bound 0
  filter_upwards [Ioo_mem_nhdsGT zero_lt_one] with t ht
  have hnot : t ∉ Set.Ioi (1:ℝ) := by
    simp only [Set.mem_Ioi, not_lt]
    exact le_of_lt ht.2
  rw [Rtr, Set.indicator_of_notMem hnot]
  simp

theorem Rtr_top {s : ℂ} (hs : 0 < s.re) (hs1 : s ≠ 1) (hs2 : s ≠ 2) {δ : ℝ} (hδ : 0 ≤ δ)
    {C : ℝ} {N₁ : ℕ} (hN₁ : 2 ≤ N₁)
    (H : ∀ N : ℕ, N₁ ≤ N → ‖S N s - K N s 1‖ ≤ C * (N:ℝ) ^ δ) :
    Rtr s =O[atTop] (fun x : ℝ => x ^ (-(-(1 + δ)))) := by
  apply Asymptotics.IsBigO.of_bound
    ((|C| + ‖c0 s‖ + ‖c1 s‖) * 2 ^ (1 + δ) + 2 * (‖kap s‖ * ‖2 - s‖))
  filter_upwards [eventually_ge_atTop (N₁:ℝ)] with x hx
  have hN₁' : (2:ℝ) ≤ N₁ := by exact_mod_cast hN₁
  have hx1 : x ∈ Set.Ioi (1:ℝ) := show (1:ℝ) < x by linarith
  rw [Rtr, Set.indicator_of_mem hx1, neg_neg,
    Real.norm_of_nonneg (Real.rpow_nonneg (by linarith) _)]
  exact D_le hs hs1 hs2 hδ hN₁ H hx

/-! ## One step at a time: the Mellin transform of a tent -/

theorem tent_mul_eq (c w : ℂ) (n : ℕ) (x : ℝ) :
    c * (tent n x : ℂ) * (x:ℂ) ^ (-w - 2)
      = Set.indicator (Set.Ioi (n:ℝ))
          (fun x : ℝ => c * ((x:ℂ) ^ (-w - 1) - n * (x:ℂ) ^ (-w - 2))) x := by
  by_cases hx : x ∈ Set.Ioi (n:ℝ)
  · rw [Set.indicator_of_mem hx, tent_eq (le_of_lt hx)]
    have hx0 : (x:ℂ) ≠ 0 := by
      have : (0:ℝ) < x := lt_of_le_of_lt (Nat.cast_nonneg n) hx
      exact_mod_cast this.ne'
    rw [show -w - 1 = (-w - 2) + 1 by ring, Complex.cpow_add _ _ hx0, Complex.cpow_one]
    push_cast
    ring
  · rw [Set.indicator_of_notMem hx, tent_eq_zero (not_lt.mp hx)]
    simp

theorem tent_mul_eq_real (c r : ℝ) (n : ℕ) (x : ℝ) :
    c * tent n x * x ^ (-r - 2)
      = Set.indicator (Set.Ioi (n:ℝ)) (fun x : ℝ => c * (x ^ (-r - 1) - n * x ^ (-r - 2))) x := by
  by_cases hx : x ∈ Set.Ioi (n:ℝ)
  · rw [Set.indicator_of_mem hx, tent_eq (le_of_lt hx)]
    have hx0 : (0:ℝ) < x := lt_of_le_of_lt (Nat.cast_nonneg n) hx
    rw [show -r - 1 = (-r - 2) + 1 by ring, Real.rpow_add hx0, Real.rpow_one]
    ring
  · rw [Set.indicator_of_notMem hx, tent_eq_zero (not_lt.mp hx)]
    simp

theorem re_lt_one {w : ℂ} (hw : 0 < w.re) : (-w - 1).re < -1 ∧ (-w - 2).re < -1 := by
  constructor <;> simp <;> linarith

theorem term_integrableOn (c w : ℂ) (n : ℕ) (hw : 0 < w.re) :
    IntegrableOn (fun x : ℝ => c * (tent n x : ℂ) * (x:ℂ) ^ (-w - 2)) (Ioi 1) := by
  rw [show (fun x : ℝ => c * (tent n x : ℂ) * (x:ℂ) ^ (-w - 2))
      = Set.indicator (Set.Ioi (n:ℝ))
          (fun x : ℝ => c * ((x:ℂ) ^ (-w - 1) - n * (x:ℂ) ^ (-w - 2))) from
      funext (tent_mul_eq c w n)]
  have h1 : IntegrableOn (fun x : ℝ => (x:ℂ) ^ (-w - 1)) (Ioi 1) :=
    integrableOn_Ioi_cpow_of_lt (re_lt_one hw).1 one_pos
  have h2 : IntegrableOn (fun x : ℝ => (x:ℂ) ^ (-w - 2)) (Ioi 1) :=
    integrableOn_Ioi_cpow_of_lt (re_lt_one hw).2 one_pos
  exact ((h1.sub (h2.const_mul (n:ℂ))).const_mul c).indicator measurableSet_Ioi

/-- **The Mellin transform of a tent**: `∫_1^∞ (x−n)_+·x^(−w−2) = n^(−w)/(w(w+1))`. -/
theorem term_integral (c : ℂ) {n : ℕ} (hn : 1 ≤ n) {w : ℂ} (hw : 0 < w.re) :
    ∫ x in Ioi (1:ℝ), c * (tent n x : ℂ) * (x:ℂ) ^ (-w - 2)
      = c * (n:ℂ) ^ (-w) / (w * (w + 1)) := by
  have hn' : (1:ℝ) ≤ n := by exact_mod_cast hn
  have hn0 : (0:ℝ) < n := by linarith
  rw [show (fun x : ℝ => c * (tent n x : ℂ) * (x:ℂ) ^ (-w - 2))
      = Set.indicator (Set.Ioi (n:ℝ))
          (fun x : ℝ => c * ((x:ℂ) ^ (-w - 1) - n * (x:ℂ) ^ (-w - 2))) from
      funext (tent_mul_eq c w n),
    setIntegral_indicator measurableSet_Ioi,
    Set.inter_eq_right.mpr (Set.Ioi_subset_Ioi hn')]
  have h1 : IntegrableOn (fun x : ℝ => (x:ℂ) ^ (-w - 1)) (Ioi (n:ℝ)) :=
    integrableOn_Ioi_cpow_of_lt (re_lt_one hw).1 hn0
  have h2 : IntegrableOn (fun x : ℝ => (x:ℂ) ^ (-w - 2)) (Ioi (n:ℝ)) :=
    integrableOn_Ioi_cpow_of_lt (re_lt_one hw).2 hn0
  rw [integral_const_mul, integral_sub h1 (h2.const_mul _), integral_const_mul,
    integral_Ioi_cpow_of_lt (re_lt_one hw).1 hn0, integral_Ioi_cpow_of_lt (re_lt_one hw).2 hn0,
    show -w - 1 + 1 = -w by ring, show -w - 2 + 1 = -w - 1 by ring, Complex.ofReal_natCast]
  have hw0 : w ≠ 0 := fun h => by rw [h] at hw; simp at hw
  have hw1 : w + 1 ≠ 0 := fun h => by
    have := congrArg Complex.re h
    simp at this
    linarith
  have hw0' : -w ≠ 0 := neg_ne_zero.mpr hw0
  have hw1' : -w - 1 ≠ 0 := fun h => hw1 (by linear_combination -h)
  have hnC : (n:ℂ) ≠ 0 := by exact_mod_cast (by omega : n ≠ 0)
  have hp : (n:ℂ) ^ (-w) = (n:ℂ) ^ (-w - 1) * n := by
    conv_lhs => rw [show -w = (-w - 1) + 1 by ring]
    rw [Complex.cpow_add _ _ hnC, Complex.cpow_one]
  rw [hp]
  generalize (n:ℂ) ^ (-w - 1) = P
  field_simp
  try ring

theorem term_integral_real (c : ℝ) {n : ℕ} (hn : 1 ≤ n) {r : ℝ} (hr : 0 < r) :
    ∫ x in Ioi (1:ℝ), c * tent n x * x ^ (-r - 2) = c * (n:ℝ) ^ (-r) / (r * (r + 1)) := by
  have hn' : (1:ℝ) ≤ n := by exact_mod_cast hn
  have hn0 : (0:ℝ) < n := by linarith
  rw [show (fun x : ℝ => c * tent n x * x ^ (-r - 2))
      = Set.indicator (Set.Ioi (n:ℝ)) (fun x : ℝ => c * (x ^ (-r - 1) - n * x ^ (-r - 2))) from
      funext (tent_mul_eq_real c r n),
    setIntegral_indicator measurableSet_Ioi,
    Set.inter_eq_right.mpr (Set.Ioi_subset_Ioi hn')]
  have h1 : IntegrableOn (fun x : ℝ => x ^ (-r - 1)) (Ioi (n:ℝ)) :=
    integrableOn_Ioi_rpow_of_lt (by linarith) hn0
  have h2 : IntegrableOn (fun x : ℝ => x ^ (-r - 2)) (Ioi (n:ℝ)) :=
    integrableOn_Ioi_rpow_of_lt (by linarith) hn0
  rw [integral_const_mul, integral_sub h1 (h2.const_mul _), integral_const_mul,
    integral_Ioi_rpow_of_lt (by linarith) hn0, integral_Ioi_rpow_of_lt (by linarith) hn0,
    show -r - 1 + 1 = -r by ring, show -r - 2 + 1 = -r - 1 by ring]
  have hp : (n:ℝ) ^ (-r) = (n:ℝ) ^ (-r - 1) * n := by
    conv_lhs => rw [show -r = (-r - 1) + 1 by ring]
    rw [Real.rpow_add hn0, Real.rpow_one]
  have hr1 : -r - 1 ≠ 0 := by intro h; linarith
  have hr0 : -r ≠ 0 := by intro h; linarith
  have hr1' : r + 1 ≠ 0 := by intro h; linarith
  rw [hp]
  generalize (n:ℝ) ^ (-r - 1) = P
  field_simp
  try ring

theorem term_norm_integral (s w : ℂ) {n : ℕ} (hn : 1 ≤ n) (hw : 0 < w.re) :
    ∫ x in Ioi (1:ℝ), ‖coef s n * (tent n x : ℂ) * (x:ℂ) ^ (-w - 2)‖
      = ‖coef s n‖ * (n:ℝ) ^ (-w.re) / (w.re * (w.re + 1)) := by
  rw [← term_integral_real _ hn hw]
  refine setIntegral_congr_fun measurableSet_Ioi (fun x hx => ?_)
  have hx0 : (0:ℝ) < x := lt_trans zero_lt_one hx
  rw [norm_mul, norm_mul, Complex.norm_real, Real.norm_of_nonneg (tent_nonneg n x),
    Complex.norm_cpow_eq_rpow_re_of_pos hx0, show (-w - 2).re = -w.re - 2 by simp]

theorem summable_norm_integrals (s w : ℂ) (hw : 0 < w.re) (h1 : 1 < (s + w).re) :
    Summable (fun n : ℕ =>
      ∫ x in Ioi (1:ℝ), ‖coef s n * (tent n x : ℂ) * (x:ℂ) ^ (-w - 2)‖) := by
  have hL : Summable (fun n : ℕ =>
      ‖LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (s + w) n‖) :=
    summable_norm_iff.mpr (ArithmeticFunction.LSeriesSummable_vonMangoldt h1)
  refine (hL.div_const (w.re * (w.re + 1))).congr (fun n => ?_)
  rcases Nat.eq_zero_or_pos n with h0 | hpos
  · subst h0
    simp [coef_zero]
  · rw [term_norm_integral s w hpos hw, LSeries.norm_term_eq, if_neg hpos.ne']
    congr 1
    have hn0 : (0:ℝ) < n := by exact_mod_cast hpos
    rw [coef, norm_mul, Complex.norm_natCast_cpow_of_pos hpos, Complex.add_re, Complex.neg_re,
      mul_assoc, ← Real.rpow_add hn0, div_eq_mul_inv, ← Real.rpow_neg hn0.le]
    congr 2
    ring

theorem term_integral_eq (s w : ℂ) (hw : 0 < w.re) (n : ℕ) :
    ∫ x in Ioi (1:ℝ), coef s n * (tent n x : ℂ) * (x:ℂ) ^ (-w - 2)
      = LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (s + w) n
          / (w * (w + 1)) := by
  rcases Nat.eq_zero_or_pos n with h0 | hpos
  · subst h0
    simp [coef_zero]
  · rw [term_integral _ hpos hw, LSeries.term_def, if_neg hpos.ne', coef]
    have hnC : (n:ℂ) ≠ 0 := by exact_mod_cast hpos.ne'
    rw [mul_assoc, ← Complex.cpow_add _ _ hnC, show -s + -w = -(s + w) by ring,
      Complex.cpow_neg]
    simp only [div_eq_mul_inv]

theorem tsum_terms (s w : ℂ) (x : ℝ) :
    ∑' n : ℕ, coef s n * (tent n x : ℂ) * (x:ℂ) ^ (-w - 2) = B s x * (x:ℂ) ^ (-w - 2) := by
  have hz : ∀ n ∉ Finset.range (⌊x⌋₊ + 1), coef s n * (tent n x : ℂ) * (x:ℂ) ^ (-w - 2) = 0 := by
    intro n hn
    have hn' : ⌊x⌋₊ + 1 ≤ n := by simpa using hn
    have : x < n := lt_of_lt_of_le (lt_floor_succ x) (by exact_mod_cast hn')
    rw [tent_eq_zero this.le]
    simp
  rw [tsum_eq_sum hz, B, Bk, Finset.sum_mul]

theorem D_integral_eq_mellin (s w : ℂ) :
    ∫ x in Ioi (1:ℝ), D s x * (x:ℂ) ^ (-w - 2) = mellin (Rtr s) (-w - 1) := by
  rw [mellin]
  have h : ∀ t : ℝ, (t : ℂ) ^ (-w - 1 - 1) • Rtr s t
      = Set.indicator (Set.Ioi 1) (fun x : ℝ ↦ D s x * (x : ℂ) ^ (-w - 2)) t := by
    intro t
    by_cases ht : t ∈ Set.Ioi (1:ℝ)
    · rw [Rtr, Set.indicator_of_mem ht, Set.indicator_of_mem ht, smul_eq_mul,
        show -w - 1 - 1 = -w - 2 by ring, mul_comm]
    · rw [Rtr, Set.indicator_of_notMem ht, Set.indicator_of_notMem ht, smul_zero]
  simp_rw [h]
  rw [MeasureTheory.integral_indicator measurableSet_Ioi,
    Measure.restrict_restrict measurableSet_Ioi]
  have hset : Set.Ioi (1:ℝ) ∩ Set.Ioi (0:ℝ) = Set.Ioi (1:ℝ) := by
    apply Set.inter_eq_left.mpr
    intro t ht
    exact Set.mem_Ioi.mpr (lt_trans zero_lt_one (Set.mem_Ioi.mp ht))
  rw [hset]

/-- **The Mellin identity.** Under the bound, for `Re w > 1 + δ`:
`−ζ'/ζ(s+w) = w(w+1)·(M[R](−w−1) + κ/(s+w−1))`. -/
theorem mellin_identity {s : ℂ} (hs : 0 < s.re) (hs1 : s ≠ 1) (hs2 : s ≠ 2) {δ : ℝ}
    (hδ : 0 ≤ δ) {C : ℝ} {N₁ : ℕ} (hN₁ : 2 ≤ N₁)
    (H : ∀ N : ℕ, N₁ ≤ N → ‖S N s - K N s 1‖ ≤ C * (N:ℝ) ^ δ) {w : ℂ} (hw : 1 + δ < w.re) :
    -deriv ζ (s + w) / ζ (s + w)
      = w * (w + 1) * (mellin (Rtr s) (-w - 1) + kap s / (s + w - 1)) := by
  have hw0 : 0 < w.re := by linarith
  have hsw : 1 < (s + w).re := by rw [Complex.add_re]; linarith
  have hL := StepsPole.steps_sum hsw
  have hint := integral_tsum_of_summable_integral_norm
    (μ := volume.restrict (Ioi (1:ℝ)))
    (F := fun n : ℕ => fun x : ℝ => coef s n * (tent n x : ℂ) * (x:ℂ) ^ (-w - 2))
    (fun n => term_integrableOn _ w n hw0) (summable_norm_integrals s w hw0 hsw)
  simp only [term_integral_eq s w hw0, tsum_terms] at hint
  rw [tsum_div_const] at hint
  have hLS : LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (s + w)
      = ∑' n, LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (s + w) n := rfl
  rw [← hLS] at hint
  have hre : (-w - 1).re < -(1 + δ) := by simp; linarith
  have hconv := mellinConvergent_of_isBigO_rpow (Rtr_locallyIntegrable s)
    (Rtr_top hs hs1 hs2 hδ hN₁ H) hre (Rtr_bot s ((-w - 1).re - 1)) (by linarith)
  have hDint : IntegrableOn (fun x : ℝ => D s x * (x:ℂ) ^ (-w - 2)) (Ioi 1) := by
    refine (IntegrableOn.mono_set hconv (Ioi_subset_Ioi zero_le_one)).congr_fun
      (fun t ht => ?_) measurableSet_Ioi
    simp only []
    rw [Rtr, Set.indicator_of_mem ht, smul_eq_mul, show -w - 1 - 1 = -w - 2 by ring, mul_comm]
  have hre2 : (-s - w).re < -1 := by simp; linarith
  have hKint : IntegrableOn (fun x : ℝ => kap s * (x:ℂ) ^ (-s - w)) (Ioi 1) :=
    (integrableOn_Ioi_cpow_of_lt hre2 one_pos).const_mul _
  have hsplit : ∫ x in Ioi (1:ℝ), B s x * (x:ℂ) ^ (-w - 2)
      = (∫ x in Ioi (1:ℝ), D s x * (x:ℂ) ^ (-w - 2))
        + ∫ x in Ioi (1:ℝ), kap s * (x:ℂ) ^ (-s - w) := by
    rw [← integral_add hDint hKint]
    refine setIntegral_congr_fun measurableSet_Ioi (fun x hx => ?_)
    have hx0 : (x:ℂ) ≠ 0 := by
      have : (0:ℝ) < x := lt_trans zero_lt_one hx
      exact_mod_cast this.ne'
    have e : (x:ℂ) ^ (2 - s) * (x:ℂ) ^ (-w - 2) = (x:ℂ) ^ (-s - w) := by
      rw [← Complex.cpow_add _ _ hx0]; congr 1; ring
    simp only [D]
    linear_combination kap s * e
  have hsw1 : s + w - 1 ≠ 0 := fun h => by
    have := congrArg Complex.re h
    simp at this
    linarith
  have hsw1' : -s - w + 1 ≠ 0 := fun h => hsw1 (by linear_combination -h)
  have hKval : ∫ x in Ioi (1:ℝ), kap s * (x:ℂ) ^ (-s - w) = kap s / (s + w - 1) := by
    rw [integral_const_mul, integral_Ioi_cpow_of_lt hre2 one_pos, Complex.ofReal_one,
      Complex.one_cpow]
    field_simp
    try ring
  rw [hsplit, D_integral_eq_mellin, hKval] at hint
  have hw0' : w ≠ 0 := fun h => by rw [h] at hw0; simp at hw0
  have hw1 : w + 1 ≠ 0 := fun h => by
    have := congrArg Complex.re h
    simp at this
    linarith
  rw [← hL, ← hint]
  field_simp

/-! ## The continuation -/

/-- The continuation of `−ζ'/ζ`: `F(z) = w(w+1)·(M[R](−w−1) + κ/(z−1))`, `w = z − s`. -/
def Fz (s z : ℂ) : ℂ := (z - s) * (z - s + 1) * (mellin (Rtr s) (-(z - s) - 1) + kap s / (z - 1))

theorem Fz_eq {s : ℂ} (hs : 0 < s.re) (hs1 : s ≠ 1) (hs2 : s ≠ 2) {δ : ℝ}
    (hδ : 0 ≤ δ) {C : ℝ} {N₁ : ℕ} (hN₁ : 2 ≤ N₁)
    (H : ∀ N : ℕ, N₁ ≤ N → ‖S N s - K N s 1‖ ≤ C * (N:ℝ) ^ δ) {z : ℂ}
    (hz : s.re + (1 + δ) < z.re) :
    Fz s z = -deriv ζ z / ζ z := by
  have hw : 1 + δ < (z - s).re := by rw [Complex.sub_re]; linarith
  have h := mellin_identity hs hs1 hs2 hδ hN₁ H hw
  rw [show s + (z - s) = z by ring] at h
  rw [h]
  rfl

theorem Fz_differentiableAt {s : ℂ} (hs : 0 < s.re) (hs1 : s ≠ 1) (hs2 : s ≠ 2) {δ : ℝ}
    (hδ : 0 ≤ δ) {C : ℝ} {N₁ : ℕ} (hN₁ : 2 ≤ N₁)
    (H : ∀ N : ℕ, N₁ ≤ N → ‖S N s - K N s 1‖ ≤ C * (N:ℝ) ^ δ) {z : ℂ}
    (hz : s.re + δ < z.re) (hz1 : z ≠ 1) :
    DifferentiableAt ℂ (Fz s) z := by
  have hre : (-(z - s) - 1).re < -(1 + δ) := by simp; linarith
  have hmel : DifferentiableAt ℂ (mellin (Rtr s)) (-(z - s) - 1) :=
    mellin_differentiableAt_of_isBigO_rpow (Rtr_locallyIntegrable s)
      (Rtr_top hs hs1 hs2 hδ hN₁ H) hre (Rtr_bot s ((-(z - s) - 1).re - 1)) (by linarith)
  have hin : DifferentiableAt ℂ (fun z : ℂ => -(z - s) - 1) z := by fun_prop
  have hc : DifferentiableAt ℂ (fun z : ℂ => mellin (Rtr s) (-(z - s) - 1)) z :=
    DifferentiableAt.comp (g := mellin (Rtr s)) (f := fun z : ℂ => -(z - s) - 1) z hmel hin
  have hk : DifferentiableAt ℂ (fun z : ℂ => kap s / (z - 1)) z :=
    (differentiableAt_const _).div (differentiableAt_id.sub_const 1) (sub_ne_zero.mpr hz1)
  have hp : DifferentiableAt ℂ (fun z : ℂ => (z - s) * (z - s + 1)) z := by fun_prop
  exact hp.mul (hc.add hk)

/-! ## V3–V4 for any continuation of `−ζ'/ζ` -/

theorem anchor_mem (θ X : ℝ) (hX : 1 ≤ X) :
    ((max θ X + 1 : ℝ) : ℂ) ∈ Stage3.regionθ θ ∧ X < ((max θ X + 1 : ℝ) : ℂ).re := by
  have h1 : X < max θ X + 1 := by linarith [le_max_right θ X]
  have h2 : θ < max θ X + 1 := by linarith [le_max_left θ X]
  refine ⟨⟨by simp [h2], ?_⟩, by simp [h1]⟩
  intro he
  have := congrArg Complex.re he
  simp only [Complex.ofReal_re, Complex.one_re] at this
  linarith

/-- **V3, for any continuation.** An `F` analytic on `{re > θ} \ {1}` that is
`−ζ'/ζ` right of `X ≥ 1` satisfies `F·ζ + ζ′ = 0` on the whole region. -/
theorem eqOn_zero_of_agree {θ X : ℝ} {F : ℂ → ℂ}
    (hF : AnalyticOnNhd ℂ F (Stage3.regionθ θ)) (hX : 1 ≤ X)
    (heq : ∀ z : ℂ, X < z.re → F z = -deriv ζ z / ζ z) :
    Set.EqOn (fun z : ℂ ↦ F z * ζ z + deriv ζ z) 0 (Stage3.regionθ θ) := by
  have hG : AnalyticOnNhd ℂ (fun z : ℂ ↦ F z * ζ z + deriv ζ z) (Stage3.regionθ θ) :=
    (hF.mul (Stage3.zeta_analyticOnNhd_regionθ θ)).add
      (Stage3.zeta_analyticOnNhd_regionθ θ).deriv
  obtain ⟨hp, hp1⟩ := anchor_mem θ X hX
  have hev : (fun z : ℂ ↦ F z * ζ z + deriv ζ z) =ᶠ[𝓝 ((max θ X + 1 : ℝ) : ℂ)] 0 := by
    have hopen : IsOpen {z : ℂ | X < z.re} := isOpen_lt continuous_const Complex.continuous_re
    filter_upwards [hopen.mem_nhds (show _ ∈ {z : ℂ | X < z.re} from hp1)] with z hz
    have hz1 : 1 < z.re := lt_of_le_of_lt hX hz
    have hzz : ζ z ≠ 0 := riemannZeta_ne_zero_of_one_lt_re hz1
    show F z * ζ z + deriv ζ z = 0
    rw [heq z hz, neg_div, neg_mul, div_mul_cancel₀ _ hzz]
    ring
  exact hG.eqOn_zero_of_preconnected_of_eventuallyEq_zero (Stage3.preconnected_regionθ θ) hp hev

/-- **V4, for any continuation.** Under the hypotheses of V3, no zero of `ζ` has
real part above `θ`. `ThetaConverse.no_zero_right_of_theta` with `F` abstract. -/
theorem zeta_ne_zero_of_agree {θ X : ℝ} {F : ℂ → ℂ}
    (hF : AnalyticOnNhd ℂ F (Stage3.regionθ θ)) (hX : 1 ≤ X)
    (heq : ∀ z : ℂ, X < z.re → F z = -deriv ζ z / ζ z)
    {ρ : ℂ} (hρ : θ < ρ.re) (hρ1 : ρ ≠ 1) :
    ζ ρ ≠ 0 := by
  intro hzρ
  have hρmem : ρ ∈ Stage3.regionθ θ := ⟨hρ, hρ1⟩
  have hζan : AnalyticAt ℂ ζ ρ := Stage3.zeta_analyticOnNhd_regionθ θ ρ hρmem
  rcases eq_or_ne (analyticOrderAt ζ ρ) ⊤ with htop | hfin
  · have hev0 : ζ =ᶠ[𝓝 ρ] 0 := by
      filter_upwards [analyticOrderAt_eq_top.mp htop] with z hz
      simpa using hz
    have hall := (Stage3.zeta_analyticOnNhd_regionθ θ).eqOn_zero_of_preconnected_of_eventuallyEq_zero
      (Stage3.preconnected_regionθ θ) hρmem hev0
    obtain ⟨hp, hp1⟩ := anchor_mem θ X hX
    have hp0 : ζ ((max θ X + 1 : ℝ) : ℂ) = 0 := by simpa using hall hp
    exact riemannZeta_ne_zero_of_one_lt_re (lt_of_le_of_lt hX hp1) hp0
  · have hcast : analyticOrderAt ζ ρ = (analyticOrderNatAt ζ ρ : ℕ∞) :=
      (Nat.cast_analyticOrderNatAt hfin).symm
    obtain ⟨g, hg, hgρ, hfac⟩ := (hζan.analyticOrderAt_eq_natCast).mp hcast
    obtain ⟨m, hm⟩ : ∃ m, analyticOrderNatAt ζ ρ = m + 1 := by
      rcases Nat.eq_zero_or_pos (analyticOrderNatAt ζ ρ) with h0 | hpos
      · exfalso
        have hself := hfac.self_of_nhds
        rw [h0, pow_zero, one_smul, hzρ] at hself
        exact hgρ hself.symm
      · exact ⟨analyticOrderNatAt ζ ρ - 1, by omega⟩
    rw [hm] at hfac
    have hfac' : ∀ᶠ z in 𝓝 ρ, ζ z = (z - ρ) ^ (m + 1) * g z := by
      filter_upwards [hfac] with z hz
      simpa [smul_eq_mul] using hz
    have hζ'ev := Filter.EventuallyEq.deriv
      (show ζ =ᶠ[𝓝 ρ] fun z : ℂ ↦ (z - ρ) ^ (m + 1) * g z from hfac')
    have hderiv : ∀ᶠ z in 𝓝 ρ, deriv (fun w : ℂ ↦ (w - ρ) ^ (m + 1) * g w) z
        = ((m : ℂ) + 1) * (z - ρ) ^ m * g z + (z - ρ) ^ (m + 1) * deriv g z := by
      filter_upwards [hg.eventually_analyticAt] with z hgz
      have h1 : HasDerivAt (fun w : ℂ ↦ (w - ρ) ^ (m + 1))
          (((m : ℂ) + 1) * (z - ρ) ^ m) z := by
        have h := ((hasDerivAt_id z).sub_const ρ).pow (m + 1)
        simp only [Nat.add_sub_cancel, mul_one, Nat.cast_add, Nat.cast_one, id_eq] at h
        exact h
      have h2 : HasDerivAt g (deriv g z) z := hgz.differentiableAt.hasDerivAt
      have h3 : HasDerivAt (fun w : ℂ ↦ (w - ρ) ^ (m + 1) * g w)
          (((m : ℂ) + 1) * (z - ρ) ^ m * g z + (z - ρ) ^ (m + 1) * deriv g z) z :=
        h1.mul h2
      rw [h3.deriv]
    have hGev : ∀ᶠ z in 𝓝 ρ, F z * ζ z + deriv ζ z = 0 := by
      filter_upwards [(Stage3.isOpen_regionθ θ).mem_nhds hρmem] with z hz
      simpa using eqOn_zero_of_agree hF hX heq hz
    have hpunct : ∀ᶠ z in 𝓝[≠] ρ,
        ((m : ℂ) + 1) * g z + (z - ρ) * (F z * g z + deriv g z) = 0 := by
      have hall : ∀ᶠ z in 𝓝 ρ,
          (z - ρ) ^ m * (((m : ℂ) + 1) * g z + (z - ρ) * (F z * g z + deriv g z)) = 0 := by
        filter_upwards [hfac', hζ'ev, hderiv, hGev] with z h1 h2 h3 h4
        calc (z - ρ) ^ m * (((m : ℂ) + 1) * g z + (z - ρ) * (F z * g z + deriv g z))
            = F z * ((z - ρ) ^ (m + 1) * g z)
              + (((m : ℂ) + 1) * (z - ρ) ^ m * g z + (z - ρ) ^ (m + 1) * deriv g z) := by
              ring
          _ = F z * ζ z + deriv ζ z := by rw [← h1, ← h3, ← h2]
          _ = 0 := h4
      filter_upwards [hall.filter_mono nhdsWithin_le_nhds, self_mem_nhdsWithin] with z hz hzρ'
      have hne : z - ρ ≠ 0 := sub_ne_zero.mpr (Set.mem_compl_singleton_iff.mp hzρ')
      exact (mul_eq_zero.mp hz).resolve_left (pow_ne_zero m hne)
    have hcont : ContinuousAt
        (fun z : ℂ ↦ ((m : ℂ) + 1) * g z + (z - ρ) * (F z * g z + deriv g z)) ρ := by
      have hFc : ContinuousAt F ρ := (hF ρ hρmem).continuousAt
      have hgc : ContinuousAt g ρ := hg.continuousAt
      have hg'c : ContinuousAt (deriv g) ρ := hg.deriv.continuousAt
      exact (continuousAt_const.mul hgc).add
        ((continuousAt_id.sub continuousAt_const).mul ((hFc.mul hgc).add hg'c))
    have hlim1 : Filter.Tendsto
        (fun z : ℂ ↦ ((m : ℂ) + 1) * g z + (z - ρ) * (F z * g z + deriv g z)) (𝓝[≠] ρ)
        (𝓝 (((m : ℂ) + 1) * g ρ + (ρ - ρ) * (F ρ * g ρ + deriv g ρ))) :=
      hcont.tendsto.mono_left nhdsWithin_le_nhds
    have hlim2 : Filter.Tendsto
        (fun z : ℂ ↦ ((m : ℂ) + 1) * g z + (z - ρ) * (F z * g z + deriv g z)) (𝓝[≠] ρ)
        (𝓝 0) := by
      refine Filter.Tendsto.congr' ?_ tendsto_const_nhds
      filter_upwards [hpunct] with z hz
      exact hz.symm
    have hval : ((m : ℂ) + 1) * g ρ + (ρ - ρ) * (F ρ * g ρ + deriv g ρ) = 0 :=
      tendsto_nhds_unique hlim1 hlim2
    rw [sub_self, zero_mul, add_zero] at hval
    have hm1 : ((m : ℂ) + 1) ≠ 0 := by exact_mod_cast Nat.succ_ne_zero m
    exact hgρ ((mul_eq_zero.mp hval).resolve_left hm1)

/-! ## The rain -/

/-- **The converse for the turned steps.** A bound `‖S(N,s) − K(1)‖ ≤ C·N^δ` from `N₁`
on, `δ ≥ 0`, leaves no zero of `ζ` with real part above `Re s + δ`. -/
theorem zeta_ne_zero_of_steps_bound {s : ℂ} (hs : 0 < s.re) (hs1 : s ≠ 1) (hs2 : s ≠ 2)
    {δ : ℝ} (hδ : 0 ≤ δ) {C : ℝ} {N₁ : ℕ} (hN₁ : 2 ≤ N₁)
    (H : ∀ N : ℕ, N₁ ≤ N → ‖S N s - K N s 1‖ ≤ C * (N:ℝ) ^ δ)
    {ρ : ℂ} (hρ : s.re + δ < ρ.re) (hρ1 : ρ ≠ 1) : ζ ρ ≠ 0 := by
  have hF : AnalyticOnNhd ℂ (Fz s) (Stage3.regionθ (s.re + δ)) :=
    DifferentiableOn.analyticOnNhd
      (fun z hz => (Fz_differentiableAt hs hs1 hs2 hδ hN₁ H hz.1 hz.2).differentiableWithinAt)
      (Stage3.isOpen_regionθ _)
  exact zeta_ne_zero_of_agree hF (X := max 1 (s.re + (1 + δ))) (le_max_left _ _)
    (fun z hz => Fz_eq hs hs1 hs2 hδ hN₁ H (lt_of_le_of_lt (le_max_right _ _) hz)) hρ hρ1

/-- info: 'StepsBelow.zeta_ne_zero_of_steps_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeta_ne_zero_of_steps_bound

/-- **The rain comes.** At a zero `ρ₀`, the turned steps to a cutoff, less their smooth
term, exceed `C·N^δ` at cutoffs beyond any `N₀`, for every `0 ≤ δ < Re ρ₀ − Re s`. -/
theorem rain_steps (ρ₀ : Kadiri.NontrivialZeros) {s : ℂ} (hs : 0 < s.re)
    (hne : (ρ₀ : ℂ) ≠ s) {δ : ℝ} (hδ0 : 0 ≤ δ) (hδ : δ < (ρ₀ : ℂ).re - s.re)
    (C : ℝ) (N₀ : ℕ) :
    ∃ N : ℕ, N₀ ≤ N ∧ 2 ≤ N ∧ C * (N : ℝ) ^ δ < ‖StepsPeak.S N s - StepsPeak.K N s 1‖ := by
  have hρlt : (ρ₀ : ℂ).re < 1 := ρ₀.2.1.2
  have hsre : s.re < 1 := by linarith
  have hs1 : s ≠ 1 := fun h => by rw [h] at hsre; simp at hsre
  have hs2 : s ≠ 2 := fun h => by rw [h] at hsre; norm_num at hsre
  by_contra hcon
  have H : ∀ N : ℕ, max N₀ 2 ≤ N → ‖S N s - K N s 1‖ ≤ C * (N:ℝ) ^ δ :=
    fun N hN => not_lt.mp (fun h => hcon
      ⟨N, le_trans (le_max_left _ _) hN, le_trans (le_max_right _ _) hN, h⟩)
  exact zeta_ne_zero_of_steps_bound hs hs1 hs2 hδ0 (le_max_right N₀ 2) H (by linarith)
    (nontrivialZero_ne_one ρ₀) ρ₀.2.2.2

/-- info: 'StepsBelow.rain_steps' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rain_steps

end

end StepsBelow
