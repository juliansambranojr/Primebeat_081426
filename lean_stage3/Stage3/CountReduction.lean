/-
CountReduction — block N2 of `lean_stage3/design/countmodes.md`, as corrected in
its section "After the independent check". 2026-11-23.

The reduction with a power saving. Under `H_π`, the count of primes at the
doublings within `C·k²·√2^k` of `Li`, the zeros right of a line `Re s = σ > 1/2`
carry segment sums `a_k = Σ'_{β≥σ} m(ρ)·J_k(ρ·log 2)` of size at most
`A·k²·2^(kE)`, with `E = max(σ, Θ − (1 − θ')) < Θ`, `Θ` an upper bound for the
real parts and `θ'` the exponent of the zero density right of `σ`.

  cim, inv_abs_im_le      1/|γ| ≤ cim/|ρ| for every nontrivial zero
  ratio_pow, sum_tail_le  the shell ratio as a power; Σ_{j≥k} (j+1)r^j ≤ (k+1)r^k·S
  tail_rate               the weights m/|ρ| right of σ above height 2^k sum to
                            at most Ct·k·2^(−k(1−θ'))
  norm_term_le            ‖m·J_k‖ ≤ cim·2^(kb)/(k·log 2)·m/|ρ| for β ≤ b
  summable_J              the segment terms right of σ are absolutely summable
  pow_rpow, rpow_mono, sqrt_pow_le, one_le_rpow_two   powers of two
  count_modes_small       H_π, 1/2 < σ < Θ ≤ 1, β ≤ Θ ⊢ ‖a_k‖ ≤ A·k²·2^(kE), k ≥ 2

What the next slice needs: block N3-E, the Euler transform of `a_k`.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.CountModes
import Stage3.ZeroSummable
import Stage3.AttainedPi
import Stage3.FixedRowTwo

namespace CountReduction

open Finset Filter Topology Kadiri FiniteOffLine PiZeros PiRemainder MeasureTheory
  FiniteOffLinePi

noncomputable section

/-! ### The height against the size -/

/-- A constant bounding `|ρ|/|γ|` over every nontrivial zero: `2` plus the sum of
`|ρ|/|γ|` over the finitely many zeros of height below one. -/
def cim : ℝ := 2 + ∑ ρ ∈ ZF (1 : ℝ), ‖(ρ : ℂ)‖ / |(ρ : ℂ).im|

/-- The constant `cim` is at least `2`. -/
theorem two_le_cim : 2 ≤ cim := by
  unfold cim
  have : 0 ≤ ∑ ρ ∈ ZF (1 : ℝ), ‖(ρ : ℂ)‖ / |(ρ : ℂ).im| :=
    Finset.sum_nonneg fun ρ _ => by positivity
  linarith

/-- **The height of a zero against its size.** For every nontrivial zero,
`1/|γ| ≤ cim/|ρ|`. Above height one `|ρ| ≤ 1 + |γ| ≤ 2|γ|`; below it there are
finitely many zeros. -/
theorem inv_abs_im_le (ρ : NontrivialZeros) :
    |(ρ : ℂ).im|⁻¹ ≤ cim * ‖(ρ : ℂ)‖⁻¹ := by
  have hγ : 0 < |(ρ : ℂ).im| := abs_pos.mpr (CountModes.im_ne_zero ρ)
  have hn : 0 < ‖(ρ : ℂ)‖ := lt_of_lt_of_le hγ (Complex.abs_im_le_norm _)
  rcases lt_or_ge |(ρ : ℂ).im| 1 with h | h
  · have hmem : ρ ∈ ZF (1 : ℝ) := mem_ZF.mpr h
    have h1 : ‖(ρ : ℂ)‖ / |(ρ : ℂ).im| ≤ ∑ σ ∈ ZF (1 : ℝ), ‖(σ : ℂ)‖ / |(σ : ℂ).im| :=
      Finset.single_le_sum (f := fun σ : NontrivialZeros => ‖(σ : ℂ)‖ / |(σ : ℂ).im|)
        (fun σ _ => by positivity) hmem
    have h2 : ‖(ρ : ℂ)‖ / |(ρ : ℂ).im| ≤ cim := by unfold cim; linarith
    have e : |(ρ : ℂ).im|⁻¹ = ‖(ρ : ℂ)‖ / |(ρ : ℂ).im| * ‖(ρ : ℂ)‖⁻¹ := by
      field_simp
    rw [e]
    exact mul_le_mul_of_nonneg_right h2 (by positivity)
  · have hre : |(ρ : ℂ).re| ≤ 1 := by
      rw [abs_le]
      constructor <;> linarith [ρ.2.1.1, ρ.2.1.2]
    have hle : ‖(ρ : ℂ)‖ ≤ |(ρ : ℂ).re| + |(ρ : ℂ).im| := Complex.norm_le_abs_re_add_abs_im _
    have h2 : ‖(ρ : ℂ)‖ ≤ 2 * |(ρ : ℂ).im| := by linarith
    have h3 : |(ρ : ℂ).im|⁻¹ ≤ 2 * ‖(ρ : ℂ)‖⁻¹ := by
      rw [inv_le_comm₀ hγ (by positivity), mul_inv, inv_inv]
      linarith
    exact h3.trans (mul_le_mul_of_nonneg_right two_le_cim (by positivity))

/-! ### The rate of the tail -/

/-- The shell ratio as a power: `(2^θ'/2)^k = 2^(−k(1−θ'))`. -/
theorem ratio_pow (θ' : ℝ) (k : ℕ) :
    ((2:ℝ) ^ θ' / 2) ^ k = (2:ℝ) ^ (-(k:ℝ) * (1 - θ')) := by
  have h : (2:ℝ) ^ θ' / 2 = (2:ℝ) ^ (θ' - 1) := by
    rw [Real.rpow_sub (by norm_num), Real.rpow_one]
  rw [h, ← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]
  congr 1
  ring

/-- For `0 ≤ r < 1`, a finite sum of `(j + 1)·r^j` over indices `j ≥ k` is at most
`(k + 1)·r^k·S`, with `S = Σ' (i + 1)·r^i`: shift every index down by `k`. -/
theorem sum_tail_le {r : ℝ} (h0 : 0 ≤ r) (h1 : r < 1) (k : ℕ) (s : Finset ℕ)
    (hs : ∀ j ∈ s, k ≤ j) :
    ∑ j ∈ s, ((j:ℝ) + 1) * r ^ j
      ≤ ((k:ℝ) + 1) * r ^ k * ∑' i : ℕ, ((i:ℝ) + 1) * r ^ i := by
  have hS : Summable fun i : ℕ => ((i:ℝ) + 1) * r ^ i := by
    simpa using ZeroSummable.summable_shell h0 h1 1
  have hpt : ∀ j ∈ s, ((j:ℝ) + 1) * r ^ j
      ≤ ((k:ℝ) + 1) * r ^ k * ((((j - k : ℕ) : ℝ) + 1) * r ^ (j - k)) := by
    intro j hj
    obtain ⟨d, rfl⟩ := Nat.exists_eq_add_of_le (hs j hj)
    rw [Nat.add_sub_cancel_left, pow_add]
    push_cast
    have hr : 0 ≤ r ^ k * r ^ d := by positivity
    have hd : (0:ℝ) ≤ d := d.cast_nonneg
    have hk : (0:ℝ) ≤ k := k.cast_nonneg
    have hle : (k:ℝ) + d + 1 ≤ ((k:ℝ) + 1) * ((d:ℝ) + 1) := by nlinarith
    calc ((k:ℝ) + d + 1) * (r ^ k * r ^ d)
        ≤ ((k:ℝ) + 1) * ((d:ℝ) + 1) * (r ^ k * r ^ d) := mul_le_mul_of_nonneg_right hle hr
      _ = _ := by ring
  refine (Finset.sum_le_sum hpt).trans ?_
  rw [← Finset.mul_sum]
  refine mul_le_mul_of_nonneg_left ?_ (by positivity)
  have hinj : Set.InjOn (fun j : ℕ => j - k) s := by
    intro a ha b hb hab
    have := hs a ha
    have := hs b hb
    simp only at hab
    omega
  rw [← Finset.sum_image (f := fun i : ℕ => ((i:ℝ) + 1) * r ^ i) hinj]
  exact hS.sum_le_tsum _ (fun i _ => by positivity)

/-- **The rate of the tail.** For `1/2 < σ ≤ 1` there are `0 ≤ θ' < 1` and `Ct ≥ 0`
such that, for every `k ≥ 1`, the weights `m(ρ)/|ρ|` over any finite set of zeros
with `Re ρ ≥ σ` and `|Im ρ| ≥ 2^k` sum to at most `Ct·k·2^(−k(1−θ'))`. The shells
`j ≥ k` weigh `K·(j+1)·2^(−j(1−θ'))` each (`ZeroSummable.shell_sum_le`), a geometric
tail; below the first shell the density bound reads, one constant does. -/
theorem tail_rate {σ : ℝ} (hσ : 1/2 < σ) (hσ1 : σ ≤ 1) :
    ∃ θ' Ct : ℝ, 0 ≤ θ' ∧ θ' < 1 ∧ 0 ≤ Ct ∧ ∀ (k : ℕ), 1 ≤ k → ∀ v : Finset Kadiri.NontrivialZeros,
      (∀ ρ ∈ v, σ ≤ (ρ:ℂ).re ∧ (2:ℝ)^k ≤ |(ρ:ℂ).im|) →
      ∑ ρ ∈ v, ((riemannZeta.order (ρ:ℂ) : ℤ) : ℝ) / ‖(ρ:ℂ)‖
        ≤ Ct * k * (2:ℝ)^(-(k:ℝ) * (1 - θ')) := by
  classical
  obtain ⟨θ, C, T₀, hθ, hC, hd⟩ := ZeroDensity.zero_density hσ hσ1
  obtain ⟨M, hM⟩ := ZeroSummable.sum_le_const hσ hσ1
  have hM0 : 0 ≤ M := by simpa using hM ∅ (by simp)
  obtain ⟨n, hn⟩ := pow_unbounded_of_one_lt T₀ (by norm_num : (1 : ℝ) < 2)
  have hθ'0 : 0 ≤ max θ 0 := le_max_right _ _
  have hθ'1 : max θ 0 < 1 := max_lt hθ (by norm_num)
  have hr0 : 0 ≤ (2:ℝ) ^ (max θ 0) / 2 := by positivity
  have hr1 : (2:ℝ) ^ (max θ 0) / 2 < 1 := by
    have h := Real.rpow_lt_rpow_of_exponent_lt (by norm_num : (1 : ℝ) < 2) hθ'1
    rw [Real.rpow_one] at h
    linarith
  obtain ⟨K, hKdef⟩ : ∃ K : ℝ, K = 206 * C * (4:ℝ) ^ (max θ 0) := ⟨_, rfl⟩
  have hK0 : 0 ≤ K := by rw [hKdef]; positivity
  obtain ⟨S, hSdef⟩ : ∃ S : ℝ,
      S = ∑' i : ℕ, ((i:ℝ) + 1) * ((2:ℝ) ^ (max θ 0) / 2) ^ i := ⟨_, rfl⟩
  have hS0 : 0 ≤ S := by rw [hSdef]; exact tsum_nonneg fun i => by positivity
  refine ⟨max θ 0, M * (2:ℝ) ^ ((n:ℝ) * (1 - max θ 0)) + 2 * K * S, hθ'0, hθ'1,
    by positivity, ?_⟩
  intro k hk v hv
  have hk1 : (1:ℝ) ≤ k := by exact_mod_cast hk
  have hpow0 : 0 ≤ (2:ℝ) ^ (-(k:ℝ) * (1 - max θ 0)) := by positivity
  have hsplit : (M * (2:ℝ) ^ ((n:ℝ) * (1 - max θ 0)) + 2 * K * S) * k
        * (2:ℝ) ^ (-(k:ℝ) * (1 - max θ 0))
      = M * (2:ℝ) ^ ((n:ℝ) * (1 - max θ 0)) * k * (2:ℝ) ^ (-(k:ℝ) * (1 - max θ 0))
        + 2 * K * S * k * (2:ℝ) ^ (-(k:ℝ) * (1 - max θ 0)) := by ring
  rw [hsplit]
  have hA0 : 0 ≤ M * (2:ℝ) ^ ((n:ℝ) * (1 - max θ 0)) * k * (2:ℝ) ^ (-(k:ℝ) * (1 - max θ 0)) :=
    by positivity
  have hB0 : 0 ≤ 2 * K * S * k * (2:ℝ) ^ (-(k:ℝ) * (1 - max θ 0)) := by positivity
  rcases le_or_gt k n with hkn | hkn
  · -- below the first shell the density bound reads: one constant
    have hv' : ∑ ρ ∈ v, ((riemannZeta.order (ρ:ℂ) : ℤ) : ℝ) / ‖(ρ:ℂ)‖ ≤ M :=
      hM v (fun ρ hρ => (hv ρ hρ).1)
    have e1 : (2:ℝ) ^ ((n:ℝ) * (1 - max θ 0)) * (2:ℝ) ^ (-(k:ℝ) * (1 - max θ 0))
        = (2:ℝ) ^ (((n:ℝ) - k) * (1 - max θ 0)) := by
      rw [← Real.rpow_add (by norm_num)]
      congr 1
      ring
    have hkn' : (k:ℝ) ≤ n := by exact_mod_cast hkn
    have e2 : 1 ≤ (2:ℝ) ^ (((n:ℝ) - k) * (1 - max θ 0)) :=
      Real.one_le_rpow (by norm_num) (mul_nonneg (by linarith) (by linarith))
    have hMle : M ≤ M * (2:ℝ) ^ ((n:ℝ) * (1 - max θ 0)) * k
        * (2:ℝ) ^ (-(k:ℝ) * (1 - max θ 0)) := by
      calc M ≤ M * (2:ℝ) ^ (((n:ℝ) - k) * (1 - max θ 0)) := le_mul_of_one_le_right hM0 e2
        _ ≤ M * (2:ℝ) ^ (((n:ℝ) - k) * (1 - max θ 0)) * k :=
            le_mul_of_one_le_right (by positivity) hk1
        _ = _ := by rw [← e1]; ring
    linarith
  · -- the shells j ≥ k
    have hdy : ∀ ρ ∈ v, (2 : ℝ) ^ (Nat.log 2 ⌊|(ρ : ℂ).im|⌋₊) ≤ |(ρ : ℂ).im|
        ∧ |(ρ : ℂ).im| < 2 ^ (Nat.log 2 ⌊|(ρ : ℂ).im|⌋₊ + 1) := by
      intro ρ hρ
      have h1 : (1 : ℝ) ≤ 2 ^ k := one_le_pow₀ (by norm_num)
      exact ZeroSummable.dyadic_index (h1.trans (hv ρ hρ).2)
    have hkj : ∀ j ∈ v.image (fun ρ : NontrivialZeros => Nat.log 2 ⌊|(ρ : ℂ).im|⌋₊), k ≤ j := by
      intro j hj
      obtain ⟨ρ, hρ, hjeq⟩ := Finset.mem_image.mp hj
      have h2 := (hdy ρ hρ).2
      rw [hjeq] at h2
      have hlt : (2:ℝ) ^ k < 2 ^ (j + 1) := lt_of_le_of_lt (hv ρ hρ).2 h2
      have := (pow_lt_pow_iff_right₀ (by norm_num : (1 : ℝ) < 2)).mp hlt
      omega
    have hfib : ∀ j ∈ v.image (fun ρ : NontrivialZeros => Nat.log 2 ⌊|(ρ : ℂ).im|⌋₊),
        ∑ ρ ∈ v.filter (fun x : NontrivialZeros => Nat.log 2 ⌊|(x : ℂ).im|⌋₊ = j),
          ZeroSummable.w ρ ≤ K * (((j:ℝ) + 1) * ((2:ℝ) ^ (max θ 0) / 2) ^ j) := by
      intro j hj
      have hkj' := hkj j hj
      have hj1 : 1 ≤ j := by omega
      have hT : T₀ ≤ (2 : ℝ) ^ (j + 1) + 2 := by
        have : (2 : ℝ) ^ n ≤ 2 ^ (j + 1) := pow_le_pow_right₀ (by norm_num) (by omega)
        linarith
      have hs := ZeroSummable.shell_sum_le hσ hd hj1 hT
        (v.filter (fun x : NontrivialZeros => Nat.log 2 ⌊|(x : ℂ).im|⌋₊ = j)) (fun ρ hρ => by
          obtain ⟨hρv, hjeq⟩ := Finset.mem_filter.mp hρ
          obtain ⟨hlo, hhi⟩ := hdy ρ hρv
          rw [hjeq] at hlo hhi
          exact ⟨(hv ρ hρv).1, hlo, hhi⟩)
      rw [hKdef]
      exact hs.trans (ZeroSummable.shell_bound_le hC j)
    have hrk : 0 ≤ ((2:ℝ) ^ (max θ 0) / 2) ^ k := by positivity
    calc ∑ ρ ∈ v, ((riemannZeta.order (ρ:ℂ) : ℤ) : ℝ) / ‖(ρ:ℂ)‖
        = ∑ ρ ∈ v, ZeroSummable.w ρ := rfl
      _ = ∑ j ∈ v.image (fun ρ : NontrivialZeros => Nat.log 2 ⌊|(ρ : ℂ).im|⌋₊),
            ∑ ρ ∈ v.filter (fun x : NontrivialZeros => Nat.log 2 ⌊|(x : ℂ).im|⌋₊ = j),
              ZeroSummable.w ρ :=
          (Finset.sum_fiberwise_of_maps_to (fun x hx => Finset.mem_image_of_mem _ hx) _).symm
      _ ≤ ∑ j ∈ v.image (fun ρ : NontrivialZeros => Nat.log 2 ⌊|(ρ : ℂ).im|⌋₊),
            K * (((j:ℝ) + 1) * ((2:ℝ) ^ (max θ 0) / 2) ^ j) := Finset.sum_le_sum hfib
      _ = K * ∑ j ∈ v.image (fun ρ : NontrivialZeros => Nat.log 2 ⌊|(ρ : ℂ).im|⌋₊),
            ((j:ℝ) + 1) * ((2:ℝ) ^ (max θ 0) / 2) ^ j := by rw [Finset.mul_sum]
      _ ≤ K * (((k:ℝ) + 1) * ((2:ℝ) ^ (max θ 0) / 2) ^ k * S) := by
          rw [hSdef]
          exact mul_le_mul_of_nonneg_left (sum_tail_le hr0 hr1 k _ hkj) hK0
      _ = (K * ((2:ℝ) ^ (max θ 0) / 2) ^ k * S) * ((k:ℝ) + 1) := by ring
      _ ≤ (K * ((2:ℝ) ^ (max θ 0) / 2) ^ k * S) * (2 * k) :=
          mul_le_mul_of_nonneg_left (by linarith) (by positivity)
      _ = 2 * K * S * k * (2:ℝ) ^ (-(k:ℝ) * (1 - max θ 0)) := by rw [ratio_pow]; ring
      _ ≤ _ := by linarith

/-- info: 'CountReduction.tail_rate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms tail_rate

/-! ### One segment term against the weights -/

/-- **One segment term against its weight.** For `1 ≤ k` and a real part `β ≤ b`,
`‖m(ρ)·J_k(ρ·log 2)‖ ≤ cim·2^(kb)/(k·log 2)·m(ρ)/|ρ|`. -/
theorem norm_term_le (ρ : NontrivialZeros) {k : ℕ} (hk : 1 ≤ k) {b : ℝ} (hb : (ρ : ℂ).re ≤ b) :
    ‖((riemannZeta.order (ρ:ℂ) : ℤ) : ℂ) * CountModes.J k ((ρ:ℂ) * Real.log 2)‖
      ≤ cim * (2:ℝ) ^ ((k:ℝ) * b) / (k * Real.log 2)
        * (((riemannZeta.order (ρ:ℂ) : ℤ) : ℝ) / ‖(ρ:ℂ)‖) := by
  have hL : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hk0 : (0:ℝ) < k := by exact_mod_cast hk
  have hγ : 0 < |(ρ : ℂ).im| := abs_pos.mpr (CountModes.im_ne_zero ρ)
  have hn : 0 < ‖(ρ : ℂ)‖ := lt_of_lt_of_le hγ (Complex.abs_im_le_norm _)
  rw [norm_order_mul]
  have hJ := CountModes.norm_J_doubling_le ρ hk
  have hpow : (2:ℝ) ^ ((k:ℝ) * (ρ:ℂ).re) ≤ (2:ℝ) ^ ((k:ℝ) * b) :=
    Real.rpow_le_rpow_of_exponent_le (by norm_num) (mul_le_mul_of_nonneg_left hb hk0.le)
  have hinv := inv_abs_im_le ρ
  have h2 : (2:ℝ) ^ ((k:ℝ) * (ρ:ℂ).re) / (k * (|(ρ:ℂ).im| * Real.log 2))
      ≤ cim * (2:ℝ) ^ ((k:ℝ) * b) / (k * Real.log 2) * ‖(ρ:ℂ)‖⁻¹ := by
    have e : (2:ℝ) ^ ((k:ℝ) * (ρ:ℂ).re) / (k * (|(ρ:ℂ).im| * Real.log 2))
        = (2:ℝ) ^ ((k:ℝ) * (ρ:ℂ).re) / (k * Real.log 2) * |(ρ:ℂ).im|⁻¹ := by
      field_simp
    rw [e]
    calc (2:ℝ) ^ ((k:ℝ) * (ρ:ℂ).re) / (k * Real.log 2) * |(ρ:ℂ).im|⁻¹
        ≤ (2:ℝ) ^ ((k:ℝ) * b) / (k * Real.log 2) * (cim * ‖(ρ:ℂ)‖⁻¹) :=
          mul_le_mul (div_le_div_of_nonneg_right hpow (by positivity)) hinv
            (by positivity) (by positivity)
      _ = _ := by ring
  have h0 := ordR_nonneg ρ
  calc ordR ρ * ‖CountModes.J k ((ρ:ℂ) * Real.log 2)‖
      ≤ ordR ρ * (cim * (2:ℝ) ^ ((k:ℝ) * b) / (k * Real.log 2) * ‖(ρ:ℂ)‖⁻¹) :=
        mul_le_mul_of_nonneg_left (hJ.trans h2) h0
    _ = _ := by unfold ordR; rw [div_eq_mul_inv]; ring

/-- **The segment terms right of a line are absolutely summable.** For `σ > 1/2`
and `k ≥ 1`, `‖m(ρ)·J_k(ρ·log 2)‖ ≤ cim·2^k/(k·log 2)·m(ρ)/|ρ|`, and these weights
are summable (`ZeroSummable.summable_order_div`). -/
theorem summable_J {σ : ℝ} (hσ : 1/2 < σ) {k : ℕ} (hk : 1 ≤ k) :
    Summable fun ρ : {ρ : Kadiri.NontrivialZeros // σ ≤ (ρ:ℂ).re} =>
      ‖((riemannZeta.order ((ρ:Kadiri.NontrivialZeros):ℂ) : ℤ) : ℂ)
        * CountModes.J k (((ρ:Kadiri.NontrivialZeros):ℂ) * Real.log 2)‖ :=
  Summable.of_nonneg_of_le (fun _ => norm_nonneg _)
    (fun ρ => norm_term_le ρ.1 hk (b := 1) ρ.1.2.1.2.le)
    ((ZeroSummable.summable_order_div hσ).mul_left _)

/-- info: 'CountReduction.summable_J' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms summable_J

/-! ### Powers of two -/

/-- `(2^k)^b = 2^(k·b)`. -/
theorem pow_rpow (k : ℕ) (b : ℝ) : ((2:ℝ) ^ k) ^ b = (2:ℝ) ^ ((k:ℝ) * b) := by
  rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num)]

/-- `2^(k·a) ≤ 2^(k·b)` for `a ≤ b`. -/
theorem rpow_mono (k : ℕ) {a b : ℝ} (h : a ≤ b) : (2:ℝ) ^ ((k:ℝ) * a) ≤ (2:ℝ) ^ ((k:ℝ) * b) :=
  Real.rpow_le_rpow_of_exponent_le (by norm_num) (mul_le_mul_of_nonneg_left h k.cast_nonneg)

/-- `√2^k ≤ 2^(k·e)` for `e ≥ 1/2`. -/
theorem sqrt_pow_le (k : ℕ) {e : ℝ} (he : 1/2 ≤ e) : Real.sqrt 2 ^ k ≤ (2:ℝ) ^ ((k:ℝ) * e) := by
  rw [← sqrt_doubling, Real.sqrt_eq_rpow, pow_rpow]
  exact rpow_mono k he

/-- `1 ≤ 2^(k·e)` for `e ≥ 0`. -/
theorem one_le_rpow_two (k : ℕ) {e : ℝ} (he : 0 ≤ e) : 1 ≤ (2:ℝ) ^ ((k:ℝ) * e) :=
  Real.one_le_rpow (by norm_num) (mul_nonneg k.cast_nonneg he)

/-! ### The reduction -/

/-- **The reduction with a power saving** (block N2). Let the count of primes at the
doublings stay within `C·k²·√2^k` of `Li`, let `1/2 < σ < Θ ≤ 1`, and let every zero
have real part at most `Θ`. Then there are `E` with `σ ≤ E < Θ` and `A` such that,
for every `k ≥ 2`, the segment sum `Σ'_{β≥σ} m(ρ)·J_k(ρ·log 2)` is at most
`A·k²·2^(kE)`. At `x = T = 2^k` the identity of `PiZeros.pi_eq_zero_sum` writes the
zeros right of `σ` below `2^k` as the count, the zeros left of `σ` (`zinv`), the
remainders and the constants `cst ρ`; the zeros right of `σ` above `2^k` are the
tail of `tail_rate`. `E = max σ (Θ − (1 − θ'))`. -/
theorem count_modes_small {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → |(Nat.primeCounting ⌊(2:ℝ)^k⌋₊ : ℝ) - Stage3.Li ((2:ℝ)^k)|
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    {σ Θ : ℝ} (hσ : 1/2 < σ) (hσΘ : σ < Θ) (hΘ1 : Θ ≤ 1)
    (hΘ : ∀ ρ : Kadiri.NontrivialZeros, (ρ:ℂ).re ≤ Θ) :
    ∃ E A : ℝ, σ ≤ E ∧ E < Θ ∧ ∀ k : ℕ, 2 ≤ k →
      ‖∑' ρ : {ρ : Kadiri.NontrivialZeros // σ ≤ (ρ:ℂ).re},
          ((riemannZeta.order ((ρ:Kadiri.NontrivialZeros):ℂ) : ℤ) : ℂ)
            * CountModes.J k (((ρ:Kadiri.NontrivialZeros):ℂ) * Real.log 2)‖
        ≤ A * (k:ℝ)^2 * (2:ℝ)^((k:ℝ) * E) := by
  classical
  have hσ1 : σ ≤ 1 := hσΘ.le.trans hΘ1
  obtain ⟨θ', Ct, hθ'0, hθ'1, hCt, hrate⟩ := tail_rate hσ hσ1
  obtain ⟨M, hM⟩ := ZeroSummable.sum_le_const hσ hσ1
  have hM0 : 0 ≤ M := by simpa using hM ∅ (by simp)
  have hL : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hL1 : Real.log 2 < 1 := by linarith [Real.log_two_lt_d9]
  have hcim := two_le_cim
  have hApi := FixedRowTwo.Api2_nonneg
  have hc1 := FixedRowTwo.c1t_nonneg
  have hMl := two_le_Mlow
  obtain ⟨E, hEdef⟩ : ∃ E : ℝ, E = max σ (Θ - (1 - θ')) := ⟨_, rfl⟩
  obtain ⟨A, hAdef⟩ : ∃ A : ℝ, A = |C| + (2 * FixedRowTwo.Api2 + 16 * ExplicitTwo.c1t) + 8
      + 12 * (Mlow * 39000) + 4 * cim * M / Real.log 2 + cim * Ct / Real.log 2 := ⟨_, rfl⟩
  have hσE : σ ≤ E := by rw [hEdef]; exact le_max_left _ _
  have hΘE : Θ - (1 - θ') ≤ E := by rw [hEdef]; exact le_max_right _ _
  refine ⟨E, A, hσE, by rw [hEdef]; exact max_lt hσΘ (by linarith), ?_⟩
  intro k hk
  have hE2 : 1/2 ≤ E := by linarith
  have hk1 : 1 ≤ k := by omega
  have hkR : (2:ℝ) ≤ k := by exact_mod_cast hk
  have hk0 : (0:ℝ) < k := by linarith
  obtain ⟨x, hxdef⟩ : ∃ x : ℝ, x = (2:ℝ) ^ k := ⟨_, rfl⟩
  have hx4 : (4:ℝ) ≤ x := by
    rw [hxdef]
    calc (4:ℝ) = 2 ^ 2 := by norm_num
      _ ≤ 2 ^ k := pow_le_pow_right₀ (by norm_num) hk
  have hx2 : (2:ℝ) ≤ x := by linarith
  have hx0 : 0 < x := by linarith
  have hlogx : Real.log x = k * Real.log 2 := by rw [hxdef, Real.log_pow]
  have hlogx1 : 1 ≤ Real.log x := AttainedPi.one_le_log hx4
  have hkL : (k:ℝ) * Real.log 2 ≤ k := mul_le_of_le_one_right hk0.le hL1.le
  have hlogxk : Real.log x ≤ k := by rw [hlogx]; exact hkL
  have hP1 : 1 ≤ (2:ℝ) ^ ((k:ℝ) * E) := one_le_rpow_two k (by linarith)
  have hk2 : 1 ≤ (k:ℝ) ^ 2 := one_le_pow₀ (by linarith)
  have hkk : (k:ℝ) ≤ (k:ℝ) ^ 2 := by
    rw [sq]; exact le_mul_of_one_le_left hk0.le (by linarith)
  obtain ⟨Q, hQdef⟩ : ∃ Q : ℝ, Q = (k:ℝ) ^ 2 * (2:ℝ) ^ ((k:ℝ) * E) := ⟨_, rfl⟩
  have hQ1 : 1 ≤ Q := by rw [hQdef]; exact one_le_mul_of_one_le_of_one_le hk2 hP1
  have hkQ : (k:ℝ) ^ 2 ≤ Q := by rw [hQdef]; exact le_mul_of_one_le_right (by positivity) hP1
  have hPQ : (2:ℝ) ^ ((k:ℝ) * E) ≤ Q := by rw [hQdef]; exact le_mul_of_one_le_left (by positivity) hk2
  have hsq : Real.sqrt x = Real.sqrt 2 ^ k := by rw [hxdef]; exact sqrt_doubling k
  have hsqE : Real.sqrt x ≤ (2:ℝ) ^ ((k:ℝ) * E) := by rw [hsq]; exact sqrt_pow_le k hE2
  have hxσ : x ^ σ ≤ (2:ℝ) ^ ((k:ℝ) * E) := by rw [hxdef, pow_rpow]; exact rpow_mono k hσE
  -- the terms
  obtain ⟨f, hf⟩ : ∃ f : NontrivialZeros → ℂ, f = fun ρ : NontrivialZeros =>
      ((riemannZeta.order (ρ:ℂ) : ℤ) : ℂ) * CountModes.J k ((ρ:ℂ) * Real.log 2) := ⟨_, rfl⟩
  have hgoal : (∑' ρ : {ρ : NontrivialZeros // σ ≤ (ρ:ℂ).re},
      ((riemannZeta.order ((ρ:NontrivialZeros):ℂ) : ℤ) : ℂ)
        * CountModes.J k (((ρ:NontrivialZeros):ℂ) * Real.log 2))
      = ∑' ρ : {ρ : NontrivialZeros // σ ≤ (ρ:ℂ).re}, f ρ.1 := by rw [hf]
  rw [hgoal]
  have hsum : Summable fun ρ : {ρ : NontrivialZeros // σ ≤ (ρ:ℂ).re} => f ρ.1 := by
    rw [hf]; exact (summable_J hσ hk1).of_norm
  -- split at the height 2^k
  obtain ⟨s, hsdef⟩ : ∃ s : Finset {ρ : NontrivialZeros // σ ≤ (ρ:ℂ).re},
      s = (ZF x).subtype (fun ρ : NontrivialZeros => σ ≤ (ρ:ℂ).re) := ⟨_, rfl⟩
  have hsplit := hsum.sum_add_tsum_compl (s := s)
  have hfin : ∑ y ∈ s, f y.1 = ∑ ρ ∈ (ZF x).filter (fun ρ : NontrivialZeros => σ ≤ (ρ:ℂ).re),
      f ρ := by
    rw [hsdef]
    exact Finset.sum_subtype_eq_sum_filter f
  rw [hfin] at hsplit
  rw [← hsplit]
  -- the tail
  have htail : ‖∑' y : ↑((s : Set {ρ : NontrivialZeros // σ ≤ (ρ:ℂ).re})ᶜ), f y.1.1‖
      ≤ cim * Ct / Real.log 2 * (2:ℝ) ^ ((k:ℝ) * E) := by
    have hns : Summable fun y : ↑((s : Set {ρ : NontrivialZeros // σ ≤ (ρ:ℂ).re})ᶜ) =>
        ‖f y.1.1‖ := by
      rw [hf]; exact (summable_J hσ hk1).subtype _
    refine (norm_tsum_le_tsum_norm hns).trans ?_
    refine tsum_le_of_sum_le' (by positivity) (fun u => ?_)
    let e : ↑((s : Set {ρ : NontrivialZeros // σ ≤ (ρ:ℂ).re})ᶜ) ↪ NontrivialZeros :=
      ⟨fun y => y.1.1, fun a b h => Subtype.ext (Subtype.ext h)⟩
    have hmem : ∀ ρ ∈ u.map e, σ ≤ (ρ:ℂ).re ∧ (2:ℝ) ^ k ≤ |(ρ:ℂ).im| := by
      intro ρ hρ
      obtain ⟨y, -, rfl⟩ := Finset.mem_map.mp hρ
      refine ⟨y.1.2, ?_⟩
      have hnot : y.1.1 ∉ ZF x := by
        intro h
        have h' : y.1 ∈ (ZF x).subtype (fun ρ : NontrivialZeros => σ ≤ (ρ:ℂ).re) :=
          Finset.mem_subtype.mpr h
        rw [← hsdef] at h'
        exact y.2 (Finset.mem_coe.mpr h')
      rw [mem_ZF, not_lt, hxdef] at hnot
      exact hnot
    have hr := hrate k hk1 _ hmem
    have hc0 : 0 ≤ cim * (2:ℝ) ^ ((k:ℝ) * Θ) / (k * Real.log 2) := by positivity
    have e2 : (2:ℝ) ^ ((k:ℝ) * (Θ - (1 - θ')))
        = (2:ℝ) ^ ((k:ℝ) * Θ) * (2:ℝ) ^ (-(k:ℝ) * (1 - θ')) := by
      rw [← Real.rpow_add (by norm_num)]
      congr 1
      ring
    calc ∑ y ∈ u, ‖f y.1.1‖ = ∑ ρ ∈ u.map e, ‖f ρ‖ := (Finset.sum_map u e (fun ρ => ‖f ρ‖)).symm
      _ ≤ ∑ ρ ∈ u.map e, cim * (2:ℝ) ^ ((k:ℝ) * Θ) / (k * Real.log 2)
            * (((riemannZeta.order (ρ:ℂ) : ℤ) : ℝ) / ‖(ρ:ℂ)‖) :=
          Finset.sum_le_sum fun ρ _ => by rw [hf]; exact norm_term_le ρ hk1 (hΘ ρ)
      _ = cim * (2:ℝ) ^ ((k:ℝ) * Θ) / (k * Real.log 2)
            * ∑ ρ ∈ u.map e, ((riemannZeta.order (ρ:ℂ) : ℤ) : ℝ) / ‖(ρ:ℂ)‖ := by
          rw [Finset.mul_sum]
      _ ≤ cim * (2:ℝ) ^ ((k:ℝ) * Θ) / (k * Real.log 2)
            * (Ct * k * (2:ℝ) ^ (-(k:ℝ) * (1 - θ'))) := mul_le_mul_of_nonneg_left hr hc0
      _ = cim * Ct / Real.log 2 * (2:ℝ) ^ ((k:ℝ) * (Θ - (1 - θ'))) := by
          rw [e2]
          field_simp
      _ ≤ _ := mul_le_mul_of_nonneg_left (rpow_mono k hΘE) (by positivity)
-- the zeros below 2^k, by the identity of the count
  have hid := pi_eq_zero_sum hx2 x
  have hZsplit : ∑ ρ ∈ (ZF x).filter (fun ρ : NontrivialZeros => σ ≤ (ρ:ℂ).re),
        ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x
      + ∑ ρ ∈ (ZF x).filter (fun ρ : NontrivialZeros => ¬ σ ≤ (ρ:ℂ).re),
        ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x
      = ∑ ρ ∈ ZF x, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x :=
    Finset.sum_filter_add_sum_filter_not _ _ _
  have hHi : ∑ ρ ∈ (ZF x).filter (fun ρ : NontrivialZeros => σ ≤ (ρ:ℂ).re),
        ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x
      = ∑ ρ ∈ (ZF x).filter (fun ρ : NontrivialZeros => σ ≤ (ρ:ℂ).re), f ρ
        + ∑ ρ ∈ (ZF x).filter (fun ρ : NontrivialZeros => σ ≤ (ρ:ℂ).re),
          ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * CountModes.cst ρ := by
    rw [← Finset.sum_add_distrib]
    refine Finset.sum_congr rfl fun ρ _ => ?_
    rw [hxdef, CountModes.piMode_doubling ρ hk1, hf]
    ring
  obtain ⟨a, had⟩ : ∃ a : ℂ,
      a = (((Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x : ℝ) : ℂ) := ⟨_, rfl⟩
  obtain ⟨lo, hlod⟩ : ∃ lo : ℂ, lo = ∑ ρ ∈ (ZF x).filter (fun ρ : NontrivialZeros => ¬ σ ≤ (ρ:ℂ).re),
        ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x := ⟨_, rfl⟩
  obtain ⟨hc, hhcd⟩ : ∃ hc : ℂ, hc = ∑ ρ ∈ (ZF x).filter (fun ρ : NontrivialZeros => σ ≤ (ρ:ℂ).re),
          ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * CountModes.cst ρ := ⟨_, rfl⟩
  have key : ∑ ρ ∈ (ZF x).filter (fun ρ : NontrivialZeros => σ ≤ (ρ:ℂ).re), f ρ
      = -a - lo + tr (efRem x) x - tr psiTheta x - hc := by
    rw [had, hlod, hhcd]
    linear_combination hid + hZsplit - hHi
  -- the count
  have hpa : ‖a‖ ≤ |C| * Q := by
    rw [had, Complex.norm_real, Real.norm_eq_abs]
    have h := hH k hk1
    rw [← hxdef] at h
    have hs0 : 0 ≤ Real.sqrt 2 ^ k := by positivity
    calc _ ≤ C * (k:ℝ) ^ 2 * Real.sqrt 2 ^ k := h
      _ ≤ |C| * (k:ℝ) ^ 2 * Real.sqrt 2 ^ k :=
          mul_le_mul_of_nonneg_right
            (mul_le_mul_of_nonneg_right (le_abs_self C) (by positivity)) hs0
      _ ≤ |C| * (k:ℝ) ^ 2 * (2:ℝ) ^ ((k:ℝ) * E) :=
          mul_le_mul_of_nonneg_left (sqrt_pow_le k hE2) (by positivity)
      _ = |C| * Q := by rw [hQdef]; ring
  -- the remainder of the explicit formula
  have hr1 : ‖tr (efRem x) x‖ ≤ (2 * FixedRowTwo.Api2 + 16 * ExplicitTwo.c1t) * Q := by
    have h := FixedRowTwo.norm_tr_efRem_le_height_two hx2 hx2
    have e : 4 * ExplicitTwo.c1t * x * Real.log (x * x) ^ 2 / x
        = 16 * ExplicitTwo.c1t * ((k:ℝ) * Real.log 2) ^ 2 := by
      rw [Real.log_mul hx0.ne' hx0.ne', hlogx]
      field_simp
      try ring
    rw [e] at h
    have h1 : 1 + Real.log x ≤ 2 * (k:ℝ) ^ 2 := by linarith
    have h2 : ((k:ℝ) * Real.log 2) ^ 2 ≤ (k:ℝ) ^ 2 := by
      exact pow_le_pow_left₀ (by positivity) hkL 2
    refine h.trans ?_
    calc FixedRowTwo.Api2 * (1 + Real.log x) + 16 * ExplicitTwo.c1t * ((k:ℝ) * Real.log 2) ^ 2
        ≤ FixedRowTwo.Api2 * (2 * (k:ℝ) ^ 2) + 16 * ExplicitTwo.c1t * (k:ℝ) ^ 2 :=
          add_le_add (mul_le_mul_of_nonneg_left h1 hApi)
            (mul_le_mul_of_nonneg_left h2 (by positivity))
      _ = (2 * FixedRowTwo.Api2 + 16 * ExplicitTwo.c1t) * (k:ℝ) ^ 2 := by ring
      _ ≤ _ := mul_le_mul_of_nonneg_left hkQ (by positivity)
  -- the higher prime powers
  have hr2 : ‖tr psiTheta x‖ ≤ 8 * Q := by
    have h := norm_tr_psiTheta_le hx2
    linarith
  -- the zeros left of σ below 2^k
  have hlo : ‖lo‖ ≤ 12 * (Mlow * 39000) * Q := by
    have hterm : ∀ ρ ∈ (ZF x).filter (fun ρ : NontrivialZeros => ¬ σ ≤ (ρ:ℂ).re),
        ‖((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x‖
          ≤ ordR ρ * ‖(ρ : ℂ)‖⁻¹ * (12 * (2:ℝ) ^ ((k:ℝ) * E)) := by
      intro ρ hρ
      have hre : (ρ : ℂ).re ≤ σ := le_of_lt (not_le.mp (Finset.mem_filter.mp hρ).2)
      rw [norm_order_mul]
      have h := AttainedPi.norm_log_piMode_low ρ.2.1.1 ρ.2.1.2.le hσ.le hre hx4
      have hn0 : 0 ≤ ‖(ρ : ℂ)‖⁻¹ := by positivity
      have hP0 : 0 ≤ (2:ℝ) ^ ((k:ℝ) * E) := by positivity
      have h3 : ‖(ρ : ℂ)‖⁻¹ * (9 * x ^ σ + 3 * (Real.sqrt x * Real.log x))
          ≤ Real.log x * (‖(ρ : ℂ)‖⁻¹ * (12 * (2:ℝ) ^ ((k:ℝ) * E))) := by
        have h4 : 9 * x ^ σ + 3 * (Real.sqrt x * Real.log x)
            ≤ Real.log x * (12 * (2:ℝ) ^ ((k:ℝ) * E)) := by
          have h5 : x ^ σ ≤ Real.log x * (2:ℝ) ^ ((k:ℝ) * E) :=
            hxσ.trans (le_mul_of_one_le_left hP0 hlogx1)
          have h6 : Real.sqrt x * Real.log x ≤ Real.log x * (2:ℝ) ^ ((k:ℝ) * E) := by
            rw [mul_comm]
            exact mul_le_mul_of_nonneg_left hsqE (by linarith)
          linarith
        calc _ ≤ ‖(ρ : ℂ)‖⁻¹ * (Real.log x * (12 * (2:ℝ) ^ ((k:ℝ) * E))) :=
              mul_le_mul_of_nonneg_left h4 hn0
          _ = _ := by ring
      have hpm : ‖piMode (ρ : ℂ) x‖ ≤ ‖(ρ : ℂ)‖⁻¹ * (12 * (2:ℝ) ^ ((k:ℝ) * E)) :=
        le_of_mul_le_mul_left (h.trans h3) (by linarith)
      calc ordR ρ * ‖piMode (ρ : ℂ) x‖
          ≤ ordR ρ * (‖(ρ : ℂ)‖⁻¹ * (12 * (2:ℝ) ^ ((k:ℝ) * E))) :=
            mul_le_mul_of_nonneg_left hpm (ordR_nonneg ρ)
        _ = _ := by ring
    have hsub : ∑ ρ ∈ (ZF x).filter (fun ρ : NontrivialZeros => ¬ σ ≤ (ρ:ℂ).re),
        ordR ρ * ‖(ρ : ℂ)‖⁻¹ ≤ zinv x :=
      Finset.sum_le_sum_of_subset_of_nonneg (Finset.filter_subset _ _)
        (fun ρ _ _ => mul_nonneg (ordR_nonneg ρ) (by positivity))
    have hW := zinv_le_log hx4
    have hL2 : Real.log x ^ 2 ≤ (k:ℝ) ^ 2 := pow_le_pow_left₀ (by linarith) hlogxk 2
    have hK : 0 ≤ 12 * (2:ℝ) ^ ((k:ℝ) * E) := by positivity
    rw [hlod]
    calc _ ≤ ∑ ρ ∈ (ZF x).filter (fun ρ : NontrivialZeros => ¬ σ ≤ (ρ:ℂ).re),
            ‖((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x‖ := norm_sum_le _ _
      _ ≤ ∑ ρ ∈ (ZF x).filter (fun ρ : NontrivialZeros => ¬ σ ≤ (ρ:ℂ).re),
            ordR ρ * ‖(ρ : ℂ)‖⁻¹ * (12 * (2:ℝ) ^ ((k:ℝ) * E)) := Finset.sum_le_sum hterm
      _ = (∑ ρ ∈ (ZF x).filter (fun ρ : NontrivialZeros => ¬ σ ≤ (ρ:ℂ).re),
            ordR ρ * ‖(ρ : ℂ)‖⁻¹) * (12 * (2:ℝ) ^ ((k:ℝ) * E)) := by rw [Finset.sum_mul]
      _ ≤ zinv x * (12 * (2:ℝ) ^ ((k:ℝ) * E)) := mul_le_mul_of_nonneg_right hsub hK
      _ ≤ (Mlow * 39000 * Real.log x ^ 2) * (12 * (2:ℝ) ^ ((k:ℝ) * E)) :=
          mul_le_mul_of_nonneg_right hW hK
      _ ≤ (Mlow * 39000 * (k:ℝ) ^ 2) * (12 * (2:ℝ) ^ ((k:ℝ) * E)) :=
          mul_le_mul_of_nonneg_right
            (mul_le_mul_of_nonneg_left hL2 (by positivity)) hK
      _ = 12 * (Mlow * 39000) * Q := by rw [hQdef]; ring
  -- the constants of the zeros right of σ below 2^k
  have hhc : ‖hc‖ ≤ 4 * cim * M / Real.log 2 * Q := by
    have hterm : ∀ ρ ∈ (ZF x).filter (fun ρ : NontrivialZeros => σ ≤ (ρ:ℂ).re),
        ‖((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * CountModes.cst ρ‖
          ≤ 4 * cim / Real.log 2 * ZeroSummable.w ρ := by
      intro ρ _
      rw [norm_order_mul]
      have h := CountModes.norm_cst_le ρ
      have hγ : 0 < |(ρ : ℂ).im| := abs_pos.mpr (CountModes.im_ne_zero ρ)
      have hinv := inv_abs_im_le ρ
      have e : 4 / (|(ρ:ℂ).im| * Real.log 2) = 4 / Real.log 2 * |(ρ:ℂ).im|⁻¹ := by
        field_simp
      rw [e] at h
      have h2 : ‖CountModes.cst ρ‖ ≤ 4 / Real.log 2 * (cim * ‖(ρ : ℂ)‖⁻¹) :=
        h.trans (mul_le_mul_of_nonneg_left hinv (by positivity))
      calc ordR ρ * ‖CountModes.cst ρ‖
          ≤ ordR ρ * (4 / Real.log 2 * (cim * ‖(ρ : ℂ)‖⁻¹)) :=
            mul_le_mul_of_nonneg_left h2 (ordR_nonneg ρ)
        _ = _ := by unfold ordR ZeroSummable.w; rw [div_eq_mul_inv]; ring
    have hw := hM ((ZF x).filter (fun ρ : NontrivialZeros => σ ≤ (ρ:ℂ).re))
      (fun ρ hρ => (Finset.mem_filter.mp hρ).2)
    have hc0 : 0 ≤ 4 * cim / Real.log 2 := by positivity
    rw [hhcd]
    calc _ ≤ ∑ ρ ∈ (ZF x).filter (fun ρ : NontrivialZeros => σ ≤ (ρ:ℂ).re),
            ‖((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * CountModes.cst ρ‖ := norm_sum_le _ _
      _ ≤ ∑ ρ ∈ (ZF x).filter (fun ρ : NontrivialZeros => σ ≤ (ρ:ℂ).re),
            4 * cim / Real.log 2 * ZeroSummable.w ρ := Finset.sum_le_sum hterm
      _ = 4 * cim / Real.log 2 * ∑ ρ ∈ (ZF x).filter (fun ρ : NontrivialZeros => σ ≤ (ρ:ℂ).re),
            ZeroSummable.w ρ := by rw [Finset.mul_sum]
      _ ≤ 4 * cim / Real.log 2 * M := mul_le_mul_of_nonneg_left hw hc0
      _ ≤ 4 * cim / Real.log 2 * M * Q := le_mul_of_one_le_right (by positivity) hQ1
      _ = _ := by ring
  -- adding up
  have htail' : cim * Ct / Real.log 2 * (2:ℝ) ^ ((k:ℝ) * E) ≤ cim * Ct / Real.log 2 * Q :=
    mul_le_mul_of_nonneg_left hPQ (by positivity)
  rw [key]
  have n0 := norm_add_le (-a - lo + tr (efRem x) x - tr psiTheta x - hc)
    (∑' y : ↑((s : Set {ρ : NontrivialZeros // σ ≤ (ρ:ℂ).re})ᶜ), f y.1.1)
  have n1 := norm_sub_le (-a - lo + tr (efRem x) x - tr psiTheta x) hc
  have n2 := norm_sub_le (-a - lo + tr (efRem x) x) (tr psiTheta x)
  have n3 := norm_add_le (-a - lo) (tr (efRem x) x)
  have n4 := norm_sub_le (-a) lo
  have n5 : ‖-a‖ = ‖a‖ := norm_neg a
  have hfinal : A * (k:ℝ) ^ 2 * (2:ℝ) ^ ((k:ℝ) * E)
      = |C| * Q + (2 * FixedRowTwo.Api2 + 16 * ExplicitTwo.c1t) * Q + 8 * Q
        + 12 * (Mlow * 39000) * Q + 4 * cim * M / Real.log 2 * Q
        + cim * Ct / Real.log 2 * Q := by
    rw [hAdef, hQdef]
    ring
  rw [hfinal]
  linarith

/-- info: 'CountReduction.count_modes_small' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms count_modes_small

end

end CountReduction
