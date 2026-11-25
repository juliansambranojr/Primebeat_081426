/-
# Stage3.DiagMainMu — the log-weighted Möbius sum, `Σ_{n ≤ N} μ(n)/n · log(N/n) → 1`

The Möbius input of `DiagMain`'s route (see its docstring for why `mu_pnt_alt`'s
`Σ μ(n)/n = o(1)` alone loses a factor `log M` there). Elementary from PNT+'s `mu_pnt`
(`M(x) = o(x)`) and `mu_pnt_alt` (`m(x) = o(1)`), no zero-free region:
`Σ_{n ≤ N} μ(n)/n · H(⌊N/n⌋) = 1` (`mobius_harmonic`), so
`ψ_μ(N) = 1 − γ m(N) + Σ_{n ≤ N} μ(n)/n ρ_N(n)` with `ρ_N(n) = log(N/n) + γ − H(⌊N/n⌋)`,
`|ρ_N(n)| ≤ 1/⌊N/n⌋` (`harm_log_bound`). The head `n ≤ N/Y` is `≤ 2/Y` (`head_bound`); on the
tail `ρ_N(n)/n` splits into two antitone nonnegative weights and Abel's inequality
(`abel_ineq`) with `|M(t)| ≤ ηt + C` (`MMu_bound`) gives `≤ 2(ηN + C)(Y/N)(log Y + H(Y))`
(`tail_bound`).

| name | content | status |
|---|---|---|
| `psiMu`, `mMu`, `MMu`, `rhoN` | `ψ_μ(N)`, `m(N)`, `M(N)`, `ρ_N(n)` | def |
| `MMu_bound` | `|M(t)| ≤ ηt + C` for all `t`, from `mu_pnt` | proved |
| `mMu_tendsto` | `m(N) → 0`, from `mu_pnt_alt` | proved |
| `sum_divisors_mu`, `mobius_harmonic` | `Σ_{d|n} μ(d) = [n=1]`; `Σ_{n ≤ N} μ(n)/n H(⌊N/n⌋) = 1`, `N ≥ 1` | proved |
| `div_bounds`, `harmonic_mono`, `one_le_harmonic`, `gamma_nonneg`, `gamma_lt_one` | floor and harmonic facts | proved |
| `harm_log_bound` | `|log(N/n) + γ − H(⌊N/n⌋)| ≤ 1/⌊N/n⌋` | proved |
| `abel_ineq` | `|Σ_{a<n≤b} c_n f_n| ≤ B f_{a+1}`, `f` antitone `≥ 0`, partial sums `≤ B` | proved |
| `head_bound`, `tail_bound`, `D_small` | the head `≤ 2/Y`; the tail by Abel; `Σ μ(n)/n ρ_N(n) → 0` | proved |
| `psiMu_tendsto` | `ψ_μ(N) → 1` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.DiagMainStmt
import PrimeNumberTheoremAnd.Consequences

namespace DiagMain

open Filter Topology Finset
open scoped ArithmeticFunction.Moebius

noncomputable section

/-! ## The log-weighted Möbius sum `ψ_μ(N) = Σ_{n ≤ N} μ(n)/n · log(N/n) → 1` -/

/-- `ψ_μ(N) = Σ_{n ≤ N} μ(n)/n · log(N/n)`. -/
def psiMu (N : ℕ) : ℝ := ∑ n ∈ Ioc 0 N, (μ n : ℝ) / n * Real.log ((N : ℝ) / n)

/-- `m(N) = Σ_{n ≤ N} μ(n)/n`. -/
def mMu (N : ℕ) : ℝ := ∑ n ∈ Ioc 0 N, (μ n : ℝ) / n

/-- `M(N) = Σ_{n ≤ N} μ(n)`. -/
def MMu (N : ℕ) : ℝ := ∑ n ∈ Ioc 0 N, (μ n : ℝ)

theorem sum_range_succ_eq_Ioc (g : ℕ → ℝ) (hg : g 0 = 0) (t : ℕ) :
    ∑ n ∈ range (t + 1), g n = ∑ n ∈ Ioc 0 t, g n := by
  induction t with
  | zero => simp [hg]
  | succ t ih => rw [Finset.sum_range_succ, ih, Finset.sum_Ioc_succ_top (Nat.zero_le _)]

/-- `|M(t)| ≤ η t + C` for every `t`, from `mu_pnt`. -/
theorem MMu_bound {η : ℝ} (hη : 0 < η) : ∃ C : ℝ, 0 ≤ C ∧ ∀ t : ℕ, |MMu t| ≤ η * t + C := by
  have h := mu_pnt
  rw [Asymptotics.isLittleO_iff] at h
  obtain ⟨x₀, hx₀⟩ := eventually_atTop.mp (h hη)
  refine ⟨η + max x₀ 0, by positivity, fun t => ?_⟩
  rcases le_or_gt x₀ ((t : ℝ) + 1) with hx | hx
  · have := hx₀ ((t : ℝ) + 1) hx
    have hfl : ⌊(t : ℝ) + 1⌋₊ = t + 1 := by exact_mod_cast Nat.floor_natCast (t + 1)
    rw [hfl, Int.norm_eq_abs, Real.norm_eq_abs] at this
    have hs : ((∑ n ∈ range (t + 1), μ n : ℤ) : ℝ) = MMu t := by
      rw [MMu, ← sum_range_succ_eq_Ioc (fun n => (μ n : ℝ)) (by simp)]; push_cast; rfl
    have ht1 : |(t : ℝ) + 1| = (t : ℝ) + 1 := abs_of_pos (by positivity)
    rw [hs, ht1] at this
    nlinarith [le_max_right x₀ 0]
  · have h1 : |MMu t| ≤ t := by
      unfold MMu
      refine le_trans (Finset.abs_sum_le_sum_abs _ _) ?_
      calc ∑ n ∈ Ioc 0 t, |(μ n : ℝ)| ≤ ∑ n ∈ Ioc 0 t, (1 : ℝ) :=
            Finset.sum_le_sum fun n _ => by exact_mod_cast ArithmeticFunction.abs_moebius_le_one
        _ = t := by simp
    have : (t : ℝ) ≤ max x₀ 0 := by linarith [le_max_left x₀ 0]
    nlinarith [Nat.cast_nonneg (α := ℝ) t]

/-- `m(N) → 0`, from `mu_pnt_alt`. -/
theorem mMu_tendsto : Tendsto mMu atTop (𝓝 0) := by
  have h := mu_pnt_alt
  rw [Asymptotics.isLittleO_one_iff] at h
  have h2 := h.comp (tendsto_natCast_atTop_atTop.atTop_add (tendsto_const_nhds (x := (1 : ℝ))))
  refine h2.congr fun N => ?_
  simp only [Function.comp_apply]
  have hfl : ⌊(N : ℝ) + 1⌋₊ = N + 1 := by exact_mod_cast Nat.floor_natCast (N + 1)
  rw [hfl, mMu, sum_range_succ_eq_Ioc (fun n => (μ n : ℝ) / n) (by simp)]

/-- `Σ_{d | n} μ(d) = [n = 1]`, over `ℝ`. -/
theorem sum_divisors_mu (n : ℕ) : ∑ d ∈ n.divisors, (μ d : ℝ) = if n = 1 then 1 else 0 := by
  have hz := congrArg (fun F : ArithmeticFunction ℝ => F n)
    (ArithmeticFunction.coe_moebius_mul_coe_zeta (R := ℝ))
  simp only [ArithmeticFunction.coe_mul_zeta_apply, ArithmeticFunction.intCoe_apply,
    ArithmeticFunction.one_apply] at hz
  exact hz

/-- `Σ_{n ≤ N} μ(n)/n · H(⌊N/n⌋) = 1`, `N ≥ 1`. -/
theorem mobius_harmonic {N : ℕ} (hN : 1 ≤ N) :
    ∑ n ∈ Ioc 0 N, (μ n : ℝ) / n * (harmonic (N / n) : ℝ) = 1 := by
  let f : ArithmeticFunction ℝ := ⟨fun n => (μ n : ℝ) / n, by simp⟩
  let g : ArithmeticFunction ℝ := ⟨fun n => (n : ℝ)⁻¹, by simp⟩
  have h := ArithmeticFunction.sum_Ioc_mul_eq_sum_sum f g N
  have hfg : ∀ n ∈ Ioc 0 N, (f * g) n = if n = 1 then 1 else 0 := by
    intro n hn
    have hn0 : n ≠ 0 := (Finset.mem_Ioc.mp hn).1.ne'
    rw [ArithmeticFunction.mul_apply]
    have hterm : ∀ x ∈ n.divisorsAntidiagonal, f x.1 * g x.2 = (μ x.1 : ℝ) / n := by
      intro x hx
      rw [Nat.mem_divisorsAntidiagonal] at hx
      have h1 : (x.1 : ℝ) * x.2 = n := by exact_mod_cast hx.1
      have hx1 : (x.1 : ℝ) ≠ 0 := by
        intro h0; rw [h0, zero_mul] at h1; exact hn0 (by exact_mod_cast h1.symm)
      have hx2 : (x.2 : ℝ) ≠ 0 := by
        intro h0; rw [h0, mul_zero] at h1; exact hn0 (by exact_mod_cast h1.symm)
      show (μ x.1 : ℝ) / x.1 * (x.2 : ℝ)⁻¹ = (μ x.1 : ℝ) / n
      rw [← h1]; field_simp
    rw [Finset.sum_congr rfl hterm, ← Finset.sum_div,
      Nat.sum_divisorsAntidiagonal (fun a _ => (μ a : ℝ)), sum_divisors_mu]
    split_ifs with h1
    · subst h1; simp
    · simp
  have hL : ∑ n ∈ Ioc 0 N, (f * g) n = 1 := by
    rw [Finset.sum_congr rfl hfg, Finset.sum_ite_eq']
    have hN1 : 1 ∈ Ioc 0 N := Finset.mem_Ioc.mpr ⟨Nat.one_pos, hN⟩
    simp [hN1]
  rw [hL] at h
  rw [h]
  refine Finset.sum_congr rfl fun n _ => ?_
  show (μ n : ℝ) / n * (harmonic (N / n) : ℝ) = (μ n : ℝ) / n * ∑ m ∈ Ioc 0 (N / n), (m : ℝ)⁻¹
  congr 1
  rw [harmonic_eq_sum_Icc]
  push_cast
  rfl

/-! ## `H(k) = log y + γ + O(1/k)`, `k = ⌊y⌋` -/

/-- `⌊N/n⌋ ≤ N/n < ⌊N/n⌋ + 1` over `ℝ`, `n ≥ 1`. -/
theorem div_bounds {N n : ℕ} (hn : 0 < n) :
    ((N / n : ℕ) : ℝ) ≤ (N : ℝ) / n ∧ (N : ℝ) / n < ((N / n : ℕ) : ℝ) + 1 := by
  refine ⟨Nat.cast_div_le, ?_⟩
  have h := Nat.lt_mul_div_succ N hn
  have hn' : (0 : ℝ) < n := by exact_mod_cast hn
  rw [div_lt_iff₀ hn']
  have : (N : ℝ) < n * ((N / n : ℕ) + 1 : ℕ) := by exact_mod_cast h
  push_cast at this; linarith

theorem harmonic_mono : Monotone (fun k : ℕ => (harmonic k : ℝ)) := by
  refine monotone_nat_of_le_succ fun k => ?_
  simp only [harmonic_succ, Rat.cast_add]
  have : (0 : ℝ) ≤ ((((k + 1 : ℕ) : ℚ))⁻¹ : ℚ) := by positivity
  linarith

theorem one_le_harmonic {k : ℕ} (hk : 1 ≤ k) : (1 : ℝ) ≤ harmonic k := by
  have := harmonic_mono hk
  simpa [harmonic] using this

theorem gamma_nonneg : 0 ≤ Real.eulerMascheroniConstant :=
  le_trans (by norm_num) Real.one_half_lt_eulerMascheroniConstant.le

theorem gamma_lt_one : Real.eulerMascheroniConstant < 1 :=
  lt_trans Real.eulerMascheroniConstant_lt_two_thirds (by norm_num)

/-- `|log(N/n) + γ − H(⌊N/n⌋)| ≤ 1/⌊N/n⌋` for `1 ≤ n ≤ N`. -/
theorem harm_log_bound {N n : ℕ} (hn : 0 < n) (hnN : n ≤ N) :
    |Real.log ((N : ℝ) / n) + Real.eulerMascheroniConstant - harmonic (N / n)| ≤
      1 / ((N / n : ℕ) : ℝ) := by
  set k := N / n with hk
  have hk1 : 1 ≤ k := Nat.div_pos hnN hn
  have hk0 : (0 : ℝ) < k := by exact_mod_cast hk1
  obtain ⟨hle, hlt⟩ := div_bounds (N := N) hn
  rw [← hk] at hle hlt
  have hγ1 := Real.eulerMascheroniConstant_lt_eulerMascheroniSeq' k
  have hγ2 := Real.eulerMascheroniSeq_lt_eulerMascheroniConstant k
  rw [Real.eulerMascheroniSeq', if_neg (by omega)] at hγ1
  rw [Real.eulerMascheroniSeq] at hγ2
  have hl1 : Real.log k ≤ Real.log ((N : ℝ) / n) := Real.log_le_log hk0 hle
  have hl2 : Real.log ((N : ℝ) / n) ≤ Real.log ((k : ℝ) + 1) :=
    Real.log_le_log (lt_of_lt_of_le hk0 hle) hlt.le
  have hl3 : Real.log ((k : ℝ) + 1) - Real.log k ≤ 1 / k := by
    rw [← Real.log_div (by positivity) hk0.ne']
    have := Real.log_le_sub_one_of_pos (show (0 : ℝ) < ((k : ℝ) + 1) / k by positivity)
    rw [show ((k : ℝ) + 1) / k - 1 = 1 / k by field_simp; ring] at this
    exact this
  rw [abs_le]; constructor <;> linarith

/-! ## Abel's inequality -/

/-- For `f` antitone and nonnegative on `(a, b]`, `|Σ_{a<n≤b} c_n f_n| ≤ B f_{a+1}`, where `B`
bounds every partial sum `|Σ_{a<n≤t} c_n|`, `t ≤ b`. -/
theorem abel_ineq (c f : ℕ → ℝ) {a b : ℕ} {B : ℝ} (hab : a < b)
    (hf : ∀ n, a < n → n < b → f (n + 1) ≤ f n) (hf0 : 0 ≤ f b)
    (hB : ∀ t, a < t → t ≤ b → |∑ n ∈ Ioc a t, c n| ≤ B) :
    |∑ n ∈ Ioc a b, c n * f n| ≤ B * f (a + 1) := by
  have key : ∀ t, a + 1 ≤ t → t ≤ b →
      |∑ n ∈ Ioc a t, c n * f n - (∑ n ∈ Ioc a t, c n) * f t| ≤ B * (f (a + 1) - f t) := by
    intro t ht
    induction t, ht using Nat.le_induction with
    | base =>
      intro _
      rw [Finset.sum_Ioc_succ_top (le_refl a), Finset.sum_Ioc_succ_top (le_refl a)]
      simp
    | succ t ht ih =>
      intro htb
      have ih' := ih (by omega)
      rw [Finset.sum_Ioc_succ_top (by omega), Finset.sum_Ioc_succ_top (by omega)]
      have hS := hB t (by omega) (by omega)
      have hft := hf t (by omega) (by omega)
      have e : (∑ n ∈ Ioc a t, c n * f n + c (t + 1) * f (t + 1)) -
          (∑ n ∈ Ioc a t, c n + c (t + 1)) * f (t + 1) =
          (∑ n ∈ Ioc a t, c n * f n - (∑ n ∈ Ioc a t, c n) * f t) +
            (∑ n ∈ Ioc a t, c n) * (f t - f (t + 1)) := by ring
      rw [e]
      refine le_trans (abs_add_le _ _) ?_
      have h2 : |(∑ n ∈ Ioc a t, c n) * (f t - f (t + 1))| ≤ B * (f t - f (t + 1)) := by
        rw [abs_mul, abs_of_nonneg (show (0 : ℝ) ≤ f t - f (t + 1) by linarith)]
        exact mul_le_mul_of_nonneg_right hS (by linarith)
      have : B * (f (a + 1) - f t) + B * (f t - f (t + 1)) = B * (f (a + 1) - f (t + 1)) := by
        ring
      linarith
  have hk := key b hab le_rfl
  have hSb := hB b hab le_rfl
  have hB0 : 0 ≤ B := le_trans (abs_nonneg _) hSb
  have h3 : |(∑ n ∈ Ioc a b, c n) * f b| ≤ B * f b := by
    rw [abs_mul, abs_of_nonneg hf0]; exact mul_le_mul_of_nonneg_right hSb hf0
  have e : ∑ n ∈ Ioc a b, c n * f n =
      (∑ n ∈ Ioc a b, c n * f n - (∑ n ∈ Ioc a b, c n) * f b) + (∑ n ∈ Ioc a b, c n) * f b := by
    ring
  rw [e]
  refine le_trans (abs_add_le _ _) ?_
  have : B * (f (a + 1) - f b) + B * f b = B * f (a + 1) := by ring
  linarith

/-! ## `ψ_μ(N) → 1` -/

/-- `ρ_N(n) = log(N/n) + γ − H(⌊N/n⌋)`, so `ψ_μ(N) = 1 − γ m(N) + Σ μ(n)/n ρ_N(n)`. -/
def rhoN (N n : ℕ) : ℝ :=
  Real.log ((N : ℝ) / n) + Real.eulerMascheroniConstant - harmonic (N / n)

/-- The head `n ≤ N/Y`: `|ρ_N(n)| ≤ 1/⌊N/n⌋ ≤ 2n/N`, so the head is `≤ 2/Y`. -/
theorem head_bound {N Y : ℕ} (hN : 1 ≤ N) (hY : 1 ≤ Y) :
    |∑ n ∈ Ioc 0 (N / Y), (μ n : ℝ) / n * rhoN N n| ≤ 2 / Y := by
  have hN0 : (0 : ℝ) < N := by exact_mod_cast hN
  have hY0 : (0 : ℝ) < Y := by exact_mod_cast hY
  refine le_trans (Finset.abs_sum_le_sum_abs _ _) ?_
  have hterm : ∀ n ∈ Ioc 0 (N / Y), |(μ n : ℝ) / n * rhoN N n| ≤ 2 / N := by
    intro n hn
    obtain ⟨hn0, hnY⟩ := Finset.mem_Ioc.mp hn
    have hnY' : n * Y ≤ N := (Nat.le_div_iff_mul_le (by omega)).mp hnY
    have hnN : n ≤ N := le_trans (Nat.le_mul_of_pos_right n hY) hnY'
    have hkY : Y ≤ N / n := (Nat.le_div_iff_mul_le hn0).mpr (by rw [mul_comm]; exact hnY')
    have hk1 : 1 ≤ N / n := le_trans hY hkY
    have hk0 : (0 : ℝ) < ((N / n : ℕ) : ℝ) := by exact_mod_cast hk1
    have hk1' : (1 : ℝ) ≤ ((N / n : ℕ) : ℝ) := by exact_mod_cast hk1
    have hn0' : (0 : ℝ) < n := by exact_mod_cast hn0
    have hrho := harm_log_bound hn0 hnN
    have hmu : |(μ n : ℝ)| ≤ 1 := by exact_mod_cast ArithmeticFunction.abs_moebius_le_one
    have hlt : (N : ℝ) < n * (((N / n : ℕ) : ℝ) + 1) := by
      have := Nat.lt_mul_div_succ N hn0
      have : (N : ℝ) < ((n * (N / n + 1) : ℕ) : ℝ) := by exact_mod_cast this
      push_cast at this; exact this
    rw [abs_mul, abs_div, abs_of_pos hn0']
    have h1 : |(μ n : ℝ)| / n ≤ 1 / n := div_le_div_of_nonneg_right hmu hn0'.le
    have h2 : 1 / (n : ℝ) * (1 / ((N / n : ℕ) : ℝ)) ≤ 2 / N := by
      rw [div_mul_div_comm, div_le_div_iff₀ (by positivity) hN0]
      nlinarith
    calc |(μ n : ℝ)| / n * |rhoN N n| ≤ 1 / n * (1 / ((N / n : ℕ) : ℝ)) :=
          mul_le_mul h1 hrho (abs_nonneg _) (by positivity)
      _ ≤ 2 / N := h2
  refine le_trans (Finset.sum_le_sum hterm) ?_
  rw [Finset.sum_const, Nat.card_Ioc, nsmul_eq_mul, Nat.sub_zero]
  have ha : ((N / Y : ℕ) : ℝ) * Y ≤ N := by exact_mod_cast Nat.div_mul_le_self N Y
  rw [mul_div_assoc', div_le_div_iff₀ hN0 hY0]
  nlinarith

/-- Abel's inequality on the tail `N/Y < n ≤ N`, for `log(N/n)/n` and `(H(⌊N/n⌋) − γ)/n`. -/
theorem tail_bound {N Y : ℕ} (hN : 1 ≤ N) (hY : 2 ≤ Y) {B : ℝ}
    (hB : ∀ t, N / Y < t → t ≤ N → |∑ n ∈ Ioc (N / Y) t, (μ n : ℝ)| ≤ B) :
    |∑ n ∈ Ioc (N / Y) N, (μ n : ℝ) / n * rhoN N n| ≤
      B * ((Y : ℝ) / N) * (Real.log Y + harmonic Y) := by
  have hN0 : (0 : ℝ) < N := by exact_mod_cast hN
  have hY0 : (0 : ℝ) < Y := by exact_mod_cast (by omega : 0 < Y)
  have haN : N / Y < N := Nat.div_lt_self (by omega) (by omega)
  have hltN : N < Y * (N / Y + 1) := Nat.lt_mul_div_succ N (by omega : 0 < Y)
  generalize N / Y = a at haN hltN hB ⊢
  let f1 : ℕ → ℝ := fun n => Real.log ((N : ℝ) / n) / n
  let f2 : ℕ → ℝ := fun n => ((harmonic (N / n) : ℝ) - Real.eulerMascheroniConstant) / n
  have hsplit : ∑ n ∈ Ioc a N, (μ n : ℝ) / n * rhoN N n =
      ∑ n ∈ Ioc a N, (μ n : ℝ) * f1 n - ∑ n ∈ Ioc a N, (μ n : ℝ) * f2 n := by
    rw [← Finset.sum_sub_distrib]
    refine Finset.sum_congr rfl fun n _ => ?_
    simp only [rhoN, f1, f2]; ring
  -- facts on `(a, N]`
  have hpos : ∀ n, a < n → (0 : ℝ) < n := fun n h => by exact_mod_cast (by omega : 0 < n)
  have hge1 : ∀ n, 0 < n → n ≤ N → (1 : ℝ) ≤ (N : ℝ) / n := by
    intro n h0 hn
    rw [le_div_iff₀ (by exact_mod_cast h0)]; simpa using (by exact_mod_cast hn : (n : ℝ) ≤ N)
  have hB0 : 0 ≤ B := le_trans (abs_nonneg _) (hB N haN le_rfl)
  -- monotonicity
  have hf1 : ∀ n, a < n → n < N → f1 (n + 1) ≤ f1 n := by
    intro n han hnN
    have hn0 := hpos n han
    have hn1 : (0 : ℝ) < ((n + 1 : ℕ) : ℝ) := by positivity
    have hl1 : 0 ≤ Real.log ((N : ℝ) / (n + 1 : ℕ)) :=
      Real.log_nonneg (hge1 (n + 1) (by omega) (by omega))
    have hl2 : Real.log ((N : ℝ) / (n + 1 : ℕ)) ≤ Real.log ((N : ℝ) / n) := by
      refine Real.log_le_log (by positivity) ?_
      exact div_le_div_of_nonneg_left hN0.le hn0 (by push_cast; linarith)
    show Real.log ((N : ℝ) / (n + 1 : ℕ)) / (n + 1 : ℕ) ≤ Real.log ((N : ℝ) / n) / n
    calc Real.log ((N : ℝ) / (n + 1 : ℕ)) / (n + 1 : ℕ)
        ≤ Real.log ((N : ℝ) / n) / (n + 1 : ℕ) := div_le_div_of_nonneg_right hl2 hn1.le
      _ ≤ Real.log ((N : ℝ) / n) / n :=
          div_le_div_of_nonneg_left (le_trans hl1 hl2) hn0 (by push_cast; linarith)
  have hf2 : ∀ n, a < n → n < N → f2 (n + 1) ≤ f2 n := by
    intro n han hnN
    have hn0 := hpos n han
    have hn1 : (0 : ℝ) < ((n + 1 : ℕ) : ℝ) := by positivity
    have hH1 : (1 : ℝ) ≤ harmonic (N / (n + 1)) :=
      one_le_harmonic (Nat.div_pos (by omega) (by omega))
    have hH2 : (harmonic (N / (n + 1)) : ℝ) ≤ harmonic (N / n) :=
      harmonic_mono (Nat.div_le_div_left (by omega) (by omega))
    have hg := gamma_lt_one
    show ((harmonic (N / (n + 1)) : ℝ) - Real.eulerMascheroniConstant) / (n + 1 : ℕ) ≤
      ((harmonic (N / n) : ℝ) - Real.eulerMascheroniConstant) / n
    calc ((harmonic (N / (n + 1)) : ℝ) - Real.eulerMascheroniConstant) / (n + 1 : ℕ)
        ≤ ((harmonic (N / n) : ℝ) - Real.eulerMascheroniConstant) / (n + 1 : ℕ) :=
          div_le_div_of_nonneg_right (by linarith) hn1.le
      _ ≤ ((harmonic (N / n) : ℝ) - Real.eulerMascheroniConstant) / n :=
          div_le_div_of_nonneg_left (by linarith) hn0 (by push_cast; linarith)
  have hf10 : 0 ≤ f1 N := by
    show 0 ≤ Real.log ((N : ℝ) / N) / N
    rw [div_self hN0.ne', Real.log_one, zero_div]
  have hf20 : 0 ≤ f2 N := by
    show 0 ≤ ((harmonic (N / N) : ℝ) - Real.eulerMascheroniConstant) / N
    rw [Nat.div_self (by omega)]
    have := one_le_harmonic (le_refl 1)
    have := gamma_lt_one
    exact div_nonneg (by linarith) hN0.le
  have A1 := abel_ineq (fun n => (μ n : ℝ)) f1 haN hf1 hf10 hB
  have A2 := abel_ineq (fun n => (μ n : ℝ)) f2 haN hf2 hf20 hB
  -- values at `a + 1`
  have hlt : (N : ℝ) < Y * ((a + 1 : ℕ) : ℝ) := by
    have : (N : ℝ) < ((Y * (a + 1) : ℕ) : ℝ) := by exact_mod_cast hltN
    push_cast at this ⊢; exact this
  have ha1 : (0 : ℝ) < ((a + 1 : ℕ) : ℝ) := by positivity
  have hinv : 1 / ((a + 1 : ℕ) : ℝ) ≤ (Y : ℝ) / N := by
    rw [div_le_div_iff₀ ha1 hN0]; linarith
  have hq : (N : ℝ) / ((a + 1 : ℕ) : ℝ) ≤ Y := by
    rw [div_le_iff₀ ha1]; linarith
  have hf1a : f1 (a + 1) ≤ Real.log Y * ((Y : ℝ) / N) := by
    show Real.log ((N : ℝ) / (a + 1 : ℕ)) / (a + 1 : ℕ) ≤ Real.log Y * ((Y : ℝ) / N)
    have hl0 : 0 ≤ Real.log ((N : ℝ) / (a + 1 : ℕ)) :=
      Real.log_nonneg (hge1 (a + 1) (by omega) (by omega))
    have hl : Real.log ((N : ℝ) / (a + 1 : ℕ)) ≤ Real.log Y :=
      Real.log_le_log (by positivity) hq
    rw [div_eq_mul_one_div]
    exact mul_le_mul hl hinv (by positivity) (le_trans hl0 hl)
  have hf2a : f2 (a + 1) ≤ (harmonic Y : ℝ) * ((Y : ℝ) / N) := by
    show ((harmonic (N / (a + 1)) : ℝ) - Real.eulerMascheroniConstant) / (a + 1 : ℕ) ≤
      (harmonic Y : ℝ) * ((Y : ℝ) / N)
    have hdiv : N / (a + 1) ≤ Y := by
      apply Nat.div_le_of_le_mul
      rw [mul_comm]; exact hltN.le
    have hH : (harmonic (N / (a + 1)) : ℝ) ≤ harmonic Y := harmonic_mono hdiv
    have hH1 : (1 : ℝ) ≤ harmonic (N / (a + 1)) :=
      one_le_harmonic (Nat.div_pos (by omega) (by omega))
    have hg0 := gamma_nonneg
    have hg1 := gamma_lt_one
    rw [div_eq_mul_one_div]
    exact mul_le_mul (by linarith) hinv (by positivity) (by linarith)
  rw [hsplit]
  refine le_trans (abs_sub _ _) ?_
  have e1 : B * f1 (a + 1) ≤ B * (Real.log Y * ((Y : ℝ) / N)) := mul_le_mul_of_nonneg_left hf1a hB0
  have e2 : B * f2 (a + 1) ≤ B * ((harmonic Y : ℝ) * ((Y : ℝ) / N)) :=
    mul_le_mul_of_nonneg_left hf2a hB0
  have e3 : B * (Real.log Y * ((Y : ℝ) / N)) + B * ((harmonic Y : ℝ) * ((Y : ℝ) / N)) =
      B * ((Y : ℝ) / N) * (Real.log Y + harmonic Y) := by ring
  linarith

/-- `Σ_{n ≤ N} μ(n)/n ρ_N(n) → 0`: the head is `≤ 2/Y`, the tail `≤ 4ηY(log Y + H(Y))`. -/
theorem D_small {ε : ℝ} (hε : 0 < ε) : ∃ N₀ : ℕ, ∀ N : ℕ, N₀ ≤ N →
    |∑ n ∈ Ioc 0 N, (μ n : ℝ) / n * rhoN N n| ≤ ε := by
  set Y : ℕ := ⌈4 / ε⌉₊ + 1 with hYdef
  have hc1 : 1 ≤ ⌈4 / ε⌉₊ := Nat.one_le_iff_ne_zero.mpr (by
    rw [Ne, Nat.ceil_eq_zero, not_le]; positivity)
  have hY2 : 2 ≤ Y := by omega
  have hY0 : (0 : ℝ) < Y := by exact_mod_cast (by omega : 0 < Y)
  have hYε : 2 / (Y : ℝ) ≤ ε / 2 := by
    have h4 : 4 / ε ≤ (Y : ℝ) := by
      have := Nat.le_ceil (4 / ε)
      have : ((⌈4 / ε⌉₊ : ℕ) : ℝ) ≤ Y := by exact_mod_cast (by omega : ⌈4 / ε⌉₊ ≤ Y)
      linarith
    rw [div_le_iff₀ hε] at h4
    rw [div_le_div_iff₀ hY0 (by norm_num)]; linarith
  have hlogY : 0 ≤ Real.log Y := Real.log_nonneg (by exact_mod_cast (by omega : 1 ≤ Y))
  have hHY : 0 ≤ (harmonic Y : ℝ) := le_trans zero_le_one (one_le_harmonic (by omega))
  set K : ℝ := (Y : ℝ) * (Real.log Y + harmonic Y) + 1 with hKdef
  have hK : 0 < K := by positivity
  set η : ℝ := ε / (8 * K) with hηdef
  have hη : 0 < η := by positivity
  obtain ⟨C, hC0, hC⟩ := MMu_bound hη
  refine ⟨⌈C / η⌉₊ + 1, fun N hN => ?_⟩
  have hN1 : 1 ≤ N := by omega
  have hN0 : (0 : ℝ) < N := by exact_mod_cast hN1
  have hNC : C ≤ η * N := by
    have := Nat.le_ceil (C / η)
    have : ((⌈C / η⌉₊ : ℕ) : ℝ) ≤ N := by exact_mod_cast (by omega : ⌈C / η⌉₊ ≤ N)
    have : C / η ≤ N := by linarith
    rwa [div_le_iff₀ hη, mul_comm] at this
  have haN : N / Y ≤ N := Nat.div_le_self N Y
  rw [← Finset.sum_Ioc_consecutive _ (Nat.zero_le (N / Y)) haN]
  have hhead := head_bound hN1 (by omega : 1 ≤ Y)
  set B : ℝ := 2 * (η * N + C) with hBdef
  have hBt : ∀ t, N / Y < t → t ≤ N → |∑ n ∈ Ioc (N / Y) t, (μ n : ℝ)| ≤ B := by
    intro t hat htN
    have e := Finset.sum_Ioc_consecutive (fun n => (μ n : ℝ)) (Nat.zero_le (N / Y)) hat.le
    have e' : ∑ n ∈ Ioc (N / Y) t, (μ n : ℝ) = MMu t - MMu (N / Y) := by
      unfold MMu; linarith
    rw [e']
    have h1 := hC t
    have h2 := hC (N / Y)
    have ht : (t : ℝ) ≤ N := by exact_mod_cast htN
    have ha : ((N / Y : ℕ) : ℝ) ≤ N := by exact_mod_cast haN
    refine le_trans (abs_sub _ _) ?_
    nlinarith
  have htail := tail_bound hN1 hY2 hBt
  have hBY : B * ((Y : ℝ) / N) ≤ 4 * η * Y := by
    rw [hBdef, show 2 * (η * N + C) * ((Y : ℝ) / N) = 2 * (η * N + C) * Y / N by ring,
      div_le_iff₀ hN0]
    nlinarith
  have htail' : B * ((Y : ℝ) / N) * (Real.log Y + harmonic Y) ≤ ε / 2 := by
    have h1 : B * ((Y : ℝ) / N) * (Real.log Y + harmonic Y) ≤
        4 * η * Y * (Real.log Y + harmonic Y) :=
      mul_le_mul_of_nonneg_right hBY (by positivity)
    have h2 : 4 * η * Y * (Real.log Y + harmonic Y) ≤ 4 * η * K := by
      rw [hKdef]; nlinarith
    have h3 : 4 * η * K = ε / 2 := by rw [hηdef]; field_simp; ring
    linarith
  refine le_trans (abs_add_le _ _) ?_
  linarith

/-- **`ψ_μ(N) = Σ_{n ≤ N} μ(n)/n · log(N/n) → 1`**, from `mu_pnt` and `mu_pnt_alt`: the
identity `Σ μ(n)/n · H(⌊N/n⌋) = 1`, `H(k) = log k + γ + O(1/k)` on the head and Abel's
inequality with `M(t) = o(t)` on the tail. -/
theorem psiMu_tendsto : Tendsto psiMu atTop (𝓝 1) := by
  have hD : Tendsto (fun N : ℕ => ∑ n ∈ Ioc 0 N, (μ n : ℝ) / n * rhoN N n) atTop (𝓝 0) := by
    rw [Metric.tendsto_atTop]
    intro ε hε
    obtain ⟨N₀, hN₀⟩ := D_small (half_pos hε)
    refine ⟨N₀, fun N hN => ?_⟩
    rw [Real.dist_eq, sub_zero]
    exact lt_of_le_of_lt (hN₀ N hN) (half_lt_self hε)
  have hlim : Tendsto (fun N : ℕ => 1 - Real.eulerMascheroniConstant * mMu N +
      ∑ n ∈ Ioc 0 N, (μ n : ℝ) / n * rhoN N n) atTop (𝓝 1) := by
    have := ((tendsto_const_nhds (x := (1 : ℝ))).sub
      (mMu_tendsto.const_mul Real.eulerMascheroniConstant)).add hD
    simpa using this
  refine hlim.congr' ?_
  filter_upwards [eventually_ge_atTop 1] with N hN
  have hH := mobius_harmonic hN
  have e : ∑ n ∈ Ioc 0 N, (μ n : ℝ) / n * rhoN N n =
      psiMu N + Real.eulerMascheroniConstant * mMu N -
        ∑ n ∈ Ioc 0 N, (μ n : ℝ) / n * (harmonic (N / n) : ℝ) := by
    simp only [rhoN, psiMu, mMu, Finset.mul_sum, ← Finset.sum_add_distrib,
      ← Finset.sum_sub_distrib]
    refine Finset.sum_congr rfl fun n _ => ?_
    ring
  rw [e, hH]; ring

end

/-- info: 'DiagMain.psiMu_tendsto' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms psiMu_tendsto

/-- info: 'DiagMain.mobius_harmonic' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mobius_harmonic

/-- info: 'DiagMain.abel_ineq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms abel_ineq

/-- info: 'DiagMain.D_small' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms D_small

end DiagMain
