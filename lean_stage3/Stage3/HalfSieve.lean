/-
HalfSieve — block R6 of `lean_stage3/design/runs.md`. 2026-11-23.

The half of the closed loop, carried into the sieve.

The midpoint of every doubling sits one half above `2^n − 1`
(`ClosedLoopChain.structural_ignition`). That half is minus the value of zeta
at zero. In the sieve's sum every rounding is a fractional part, and the signs
of a Pascal row add to nothing, so the half of every rounding cancels
identically: the net rounding is the sum of the roundings measured from one
half. What is left after the smooth part is the wobble, and the residual of the
count at `N` is the residual at `√N` less the wobble at `N`. The spiral link
holds exactly when the wobble stays at square-root size.

  ignition_is_zeta_zero   Midpoint n − (2^n − 1) = −ζ(0)
  half_cancels            4 ≤ N ⊢ the signs over the sieve's terms add to 0
  netRounding_centered    4 ≤ N ⊢ netRounding N = Σ ±(fract(N/d) − 1/2)
  resid_step              2 ≤ N ⊢ resid N = resid √N − wobble N
  resid_of_wobble         the wobble at square-root size at every N gives the
                            residual at square-root size at every N
  schoenfeld_of_wobble    and so the square-root bound on the count
  spiralLink_iff_wobble   SpiralLink ↔ WobbleSqrt

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.StepsPole
import Stage3.OneChain
import Stage3.PiToPsi
import Stage3.RowLeaves

namespace HalfSieve

open SieveExact SieveResidual Stage3

/-- **The half is zeta at zero.** The offset of the midpoint of the `n`-th
doubling above `2^n − 1` is minus the value of zeta at zero, at every `n`. -/
theorem ignition_is_zeta_zero (n : ℕ) :
    ((ClosedLoopChain.Midpoint n : ℚ) : ℂ) - ((2 : ℂ) ^ n - 1) = - riemannZeta 0 := by
  rw [ClosedLoopChain.structural_ignition n, riemannZeta_zero]
  push_cast
  ring

/-- From `N = 4` on the prime `2` is among the sieve's primes. -/
theorem two_mem_smallPrimes {N : ℕ} (hN : 4 ≤ N) : 2 ∈ smallPrimes N := by
  unfold smallPrimes
  rw [Finset.mem_filter, Finset.mem_range]
  refine ⟨?_, Nat.prime_two⟩
  have h2 : 2 ≤ Nat.sqrt N := Nat.le_sqrt.mpr (by omega)
  omega

/-- **The signs of the sieve add to nothing.** Over all the sieve's terms the
signs `(−1)^|T|` sum to zero: the alternating sum of a Pascal row. -/
theorem half_cancels {N : ℕ} (hN : 4 ≤ N) :
    ∑ T ∈ (smallPrimes N).powerset, (-1 : ℚ) ^ T.card = 0 := by
  have h := Finset.sum_powerset_neg_one_pow_card_of_nonempty
    (x := smallPrimes N) ⟨2, two_mem_smallPrimes hN⟩
  have h2 : ((∑ T ∈ (smallPrimes N).powerset, (-1 : ℤ) ^ T.card : ℤ) : ℚ) = 0 := by
    rw [h]; simp
  push_cast at h2
  exact h2

/-- **The roundings measured from one half.** The half of every rounding
cancels identically in the sieve's sum. -/
theorem netRounding_centered {N : ℕ} (hN : 4 ≤ N) :
    netRounding N = ∑ T ∈ (smallPrimes N).powerset,
      (-1 : ℚ) ^ T.card * (Int.fract ((N : ℚ) / ((∏ p ∈ T, p : ℕ) : ℚ)) - 1 / 2) := by
  have h := half_cancels hN
  unfold netRounding
  simp only [mul_sub]
  rw [Finset.sum_sub_distrib, ← Finset.sum_mul, h, zero_mul, sub_zero]

/-- The wobble of the sieve at `N`: its net rounding less its smooth part. -/
noncomputable def wobble (N : ℕ) : ℝ := ((netRounding N : ℚ) : ℝ) - smoothNet N

/-- The residual of the count at `N`. -/
noncomputable def resid (N : ℕ) : ℝ := (Nat.primeCounting N : ℝ) - Stage3.Li (N : ℝ)

/-- **The residual, one square root down.** -/
theorem resid_step {N : ℕ} (hN : 2 ≤ N) : resid N = resid (Nat.sqrt N) - wobble N := by
  unfold resid wobble
  rw [net_wobble N hN]
  ring

/-- **The wobble carries the residual.** If the wobble is at square-root size
at every `N ≥ 2`, so is the residual of the count. -/
theorem resid_of_wobble {C : ℝ} (hC : 0 ≤ C)
    (h : ∀ N : ℕ, 2 ≤ N → |wobble N| ≤ C * Real.sqrt (N : ℝ) * Real.log (N : ℝ)) :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ N : ℕ, 2 ≤ N →
      |resid N| ≤ K * Real.sqrt (N : ℝ) * Real.log (N : ℝ) := by
  obtain ⟨M, hM⟩ : ∃ M : ℝ, M = |resid 1| + |resid 2| + |resid 3| := ⟨_, rfl⟩
  have a1 := abs_nonneg (resid 1)
  have a2 := abs_nonneg (resid 2)
  have a3 := abs_nonneg (resid 3)
  have hM0 : 0 ≤ M := by rw [hM]; linarith
  have hK0 : 0 ≤ 2 * C + 2 * M := by linarith
  refine ⟨2 * C + 2 * M, hK0, ?_⟩
  intro N
  induction N using Nat.strong_induction_on with
  | _ N ih =>
    intro hN
    have hNr : (2 : ℝ) ≤ (N : ℝ) := by exact_mod_cast hN
    have hlog2 : (1 : ℝ) / 2 < Real.log 2 := by
      have := Real.log_two_gt_d9; linarith
    have hlog : Real.log 2 ≤ Real.log (N : ℝ) := Real.log_le_log (by norm_num) hNr
    have hsqrt1 : 1 ≤ Real.sqrt (N : ℝ) := by
      have h1 : Real.sqrt 1 ≤ Real.sqrt (N : ℝ) := Real.sqrt_le_sqrt (by linarith)
      rwa [Real.sqrt_one] at h1
    have hunit : (1 : ℝ) / 2 ≤ Real.sqrt (N : ℝ) * Real.log (N : ℝ) := by nlinarith
    have hw := h N hN
    have habs : |resid N| ≤ |resid (Nat.sqrt N)| + |wobble N| := by
      rw [resid_step hN]; exact abs_sub _ _
    have hMt : 0 ≤ M * (Real.sqrt (N : ℝ) * Real.log (N : ℝ)) :=
      mul_nonneg hM0 (by linarith)
    have hCt : 0 ≤ C * (Real.sqrt (N : ℝ) * Real.log (N : ℝ)) :=
      mul_nonneg hC (by linarith)
    by_cases hs : Nat.sqrt N < 4
    · have hpos : 1 ≤ Nat.sqrt N := Nat.le_sqrt.mpr (by omega)
      have hsM : |resid (Nat.sqrt N)| ≤ M := by
        have hcase : Nat.sqrt N = 1 ∨ Nat.sqrt N = 2 ∨ Nat.sqrt N = 3 := by omega
        rcases hcase with e | e | e <;> rw [e, hM] <;> linarith
      have hM2 : M ≤ 2 * (M * (Real.sqrt (N : ℝ) * Real.log (N : ℝ))) := by nlinarith
      have e : (2 * C + 2 * M) * Real.sqrt (N : ℝ) * Real.log (N : ℝ)
          = 2 * (C * (Real.sqrt (N : ℝ) * Real.log (N : ℝ)))
            + 2 * (M * (Real.sqrt (N : ℝ) * Real.log (N : ℝ))) := by ring
      have e2 : C * Real.sqrt (N : ℝ) * Real.log (N : ℝ)
          = C * (Real.sqrt (N : ℝ) * Real.log (N : ℝ)) := by ring
      rw [e]
      rw [e2] at hw
      linarith
    · have hs4 : 4 ≤ Nat.sqrt N := by omega
      have hslt : Nat.sqrt N < N := Nat.sqrt_lt_self (by omega)
      have ihs := ih (Nat.sqrt N) hslt (by omega)
      have hss : Nat.sqrt N * Nat.sqrt N ≤ N := Nat.sqrt_le N
      have hsr : (4 : ℝ) ≤ (Nat.sqrt N : ℝ) := by exact_mod_cast hs4
      have hsN : (Nat.sqrt N : ℝ) ≤ (N : ℝ) := by exact_mod_cast hslt.le
      have h4s : (4 : ℝ) * (Nat.sqrt N : ℝ) ≤ (N : ℝ) := by
        have h4 : 4 * Nat.sqrt N ≤ N := le_trans (Nat.mul_le_mul_right _ hs4) hss
        exact_mod_cast h4
      have hroot : 2 * Real.sqrt (Nat.sqrt N : ℝ) ≤ Real.sqrt (N : ℝ) := by
        have h1 : Real.sqrt (4 * (Nat.sqrt N : ℝ)) ≤ Real.sqrt (N : ℝ) := Real.sqrt_le_sqrt h4s
        have h4 : Real.sqrt 4 = 2 := by
          rw [show (4 : ℝ) = 2 ^ 2 by norm_num]
          exact Real.sqrt_sq (by norm_num)
        rw [Real.sqrt_mul (by norm_num), h4] at h1
        exact h1
      have hlogs : Real.log (Nat.sqrt N : ℝ) ≤ Real.log (N : ℝ) :=
        Real.log_le_log (by linarith) hsN
      have hlogs0 : 0 ≤ Real.log (Nat.sqrt N : ℝ) := Real.log_nonneg (by linarith)
      have ha : Real.sqrt (Nat.sqrt N : ℝ) ≤ Real.sqrt (N : ℝ) / 2 := by linarith
      have hb : (2 * C + 2 * M) * Real.sqrt (Nat.sqrt N : ℝ)
          ≤ (2 * C + 2 * M) * (Real.sqrt (N : ℝ) / 2) := mul_le_mul_of_nonneg_left ha hK0
      have h1 : (2 * C + 2 * M) * Real.sqrt (Nat.sqrt N : ℝ) * Real.log (Nat.sqrt N : ℝ)
          ≤ (2 * C + 2 * M) * (Real.sqrt (N : ℝ) / 2) * Real.log (N : ℝ) :=
        mul_le_mul hb hlogs hlogs0 (mul_nonneg hK0 (by linarith))
      have e1 : (2 * C + 2 * M) * (Real.sqrt (N : ℝ) / 2) * Real.log (N : ℝ)
            + C * Real.sqrt (N : ℝ) * Real.log (N : ℝ)
          = (2 * C + 2 * M) * Real.sqrt (N : ℝ) * Real.log (N : ℝ)
            - M * (Real.sqrt (N : ℝ) * Real.log (N : ℝ)) := by ring
      linarith

/-- Li moves by at most `2` between an integer `n ≥ 2` and a real `x` in
`[n, n+1)`. -/
theorem Li_floor_close {x : ℝ} {n : ℕ} (hn : 2 ≤ n) (hnx : (n : ℝ) ≤ x) (hx : x < (n : ℝ) + 1) :
    |Stage3.Li x - Stage3.Li (n : ℝ)| ≤ 2 := by
  have hnr : (2 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
  rcases eq_or_lt_of_le hnx with heq | hlt
  · rw [← heq]; simp
  · obtain ⟨c, hc, hcd⟩ := exists_hasDerivAt_eq_slope Stage3.Li (fun y => 1 / Real.log y) hlt
      (fun y hy => (Stage3.hasDerivAt_Li (by linarith [hy.1])).continuousAt.continuousWithinAt)
      (fun y hy => Stage3.hasDerivAt_Li (by linarith [hy.1]))
    have hc2 : (2 : ℝ) ≤ c := by linarith [hc.1]
    have hlog2 : (1 : ℝ) / 2 < Real.log 2 := by
      have := Real.log_two_gt_d9; linarith
    have hlogc : Real.log 2 ≤ Real.log c := Real.log_le_log (by norm_num) hc2
    have hlpos : 0 < Real.log c := by linarith
    have hxn : 0 < x - (n : ℝ) := by linarith
    have hval : Stage3.Li x - Stage3.Li (n : ℝ) = (1 / Real.log c) * (x - (n : ℝ)) := by
      rw [hcd]; field_simp
    have hinv0 : 0 ≤ 1 / Real.log c := by positivity
    have hinv2 : 1 / Real.log c ≤ 2 := by
      rw [div_le_iff₀ hlpos]; linarith
    rw [hval, abs_of_nonneg (mul_nonneg hinv0 hxn.le)]
    nlinarith

/-- **The wobble gives the square-root bound on the count.** -/
theorem schoenfeld_of_wobble {C : ℝ} (hC : 0 ≤ C)
    (h : ∀ N : ℕ, 2 ≤ N → |wobble N| ≤ C * Real.sqrt (N : ℝ) * Real.log (N : ℝ)) :
    ∃ K : ℝ, StmtSchoenfeldWeak K 1 2 (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li := by
  obtain ⟨K, hK0, hK⟩ := resid_of_wobble hC h
  refine ⟨K + 4, ?_⟩
  intro x hx
  have hx0 : (0 : ℝ) ≤ x := by linarith
  have hn : 2 ≤ ⌊x⌋₊ := Nat.le_floor (by exact_mod_cast hx)
  have hnx : ((⌊x⌋₊ : ℕ) : ℝ) ≤ x := Nat.floor_le hx0
  have hxn : x < ((⌊x⌋₊ : ℕ) : ℝ) + 1 := Nat.lt_floor_add_one x
  have hnr : (2 : ℝ) ≤ ((⌊x⌋₊ : ℕ) : ℝ) := by exact_mod_cast hn
  have hr := hK ⌊x⌋₊ hn
  have hL := Li_floor_close hn hnx hxn
  have hlog2 : (1 : ℝ) / 2 < Real.log 2 := by
    have := Real.log_two_gt_d9; linarith
  have hlogx : Real.log 2 ≤ Real.log x := Real.log_le_log (by norm_num) hx
  have hsqrt1 : 1 ≤ Real.sqrt x := by
    have h1 : Real.sqrt 1 ≤ Real.sqrt x := Real.sqrt_le_sqrt (by linarith)
    rwa [Real.sqrt_one] at h1
  have hunit : (1 : ℝ) / 2 ≤ Real.sqrt x * Real.log x := by nlinarith
  have hsq : Real.sqrt ((⌊x⌋₊ : ℕ) : ℝ) ≤ Real.sqrt x := Real.sqrt_le_sqrt hnx
  have hlg : Real.log ((⌊x⌋₊ : ℕ) : ℝ) ≤ Real.log x := Real.log_le_log (by linarith) hnx
  have hlg0 : 0 ≤ Real.log ((⌊x⌋₊ : ℕ) : ℝ) := Real.log_nonneg (by linarith)
  have hmono : K * Real.sqrt ((⌊x⌋₊ : ℕ) : ℝ) * Real.log ((⌊x⌋₊ : ℕ) : ℝ)
      ≤ K * Real.sqrt x * Real.log x :=
    mul_le_mul (mul_le_mul_of_nonneg_left hsq hK0) hlg hlg0
      (mul_nonneg hK0 (Real.sqrt_nonneg x))
  have htri : |(Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x|
      ≤ |resid ⌊x⌋₊| + |Stage3.Li x - Stage3.Li ((⌊x⌋₊ : ℕ) : ℝ)| := by
    have e : (Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x
        = resid ⌊x⌋₊ - (Stage3.Li x - Stage3.Li ((⌊x⌋₊ : ℕ) : ℝ)) := by
      unfold resid; ring
    rw [e]; exact abs_sub _ _
  have e3 : (K + 4) * Real.sqrt x * Real.log x ^ 1
      = K * Real.sqrt x * Real.log x + 4 * (Real.sqrt x * Real.log x) := by ring
  show |(Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x| ≤ (K + 4) * Real.sqrt x * Real.log x ^ 1
  rw [e3]
  linarith

/-- The wobble of the sieve stays at square-root size from some `N₀` on. -/
def WobbleSqrt : Prop :=
  ∃ (C : ℝ) (N₀ : ℕ), ∀ N : ℕ, N₀ ≤ N →
    |wobble N| ≤ C * Real.sqrt (N : ℝ) * Real.log (N : ℝ)

/-- A bound from some `N₀` on is a bound from `2` on, with a larger constant. -/
theorem wobble_all (h : WobbleSqrt) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ N : ℕ, 2 ≤ N →
      |wobble N| ≤ C * Real.sqrt (N : ℝ) * Real.log (N : ℝ) := by
  obtain ⟨C, N₀, hC⟩ := h
  obtain ⟨M, hM⟩ := Finset.exists_le ((Finset.range N₀).image fun N => |wobble N|)
  have hC0 : 0 ≤ max C 0 := le_max_right _ _
  have hM0 : 0 ≤ max M 0 := le_max_right _ _
  refine ⟨max C 0 + 2 * max M 0, by linarith, ?_⟩
  intro N hN
  have hNr : (2 : ℝ) ≤ (N : ℝ) := by exact_mod_cast hN
  have hlog2 : (1 : ℝ) / 2 < Real.log 2 := by
    have := Real.log_two_gt_d9; linarith
  have hlog : Real.log 2 ≤ Real.log (N : ℝ) := Real.log_le_log (by norm_num) hNr
  have hsqrt1 : 1 ≤ Real.sqrt (N : ℝ) := by
    have h1 : Real.sqrt 1 ≤ Real.sqrt (N : ℝ) := Real.sqrt_le_sqrt (by linarith)
    rwa [Real.sqrt_one] at h1
  have hunit : (1 : ℝ) / 2 ≤ Real.sqrt (N : ℝ) * Real.log (N : ℝ) := by nlinarith
  have e : (max C 0 + 2 * max M 0) * Real.sqrt (N : ℝ) * Real.log (N : ℝ)
      = max C 0 * (Real.sqrt (N : ℝ) * Real.log (N : ℝ))
        + 2 * (max M 0 * (Real.sqrt (N : ℝ) * Real.log (N : ℝ))) := by ring
  have t1 : 0 ≤ max C 0 * (Real.sqrt (N : ℝ) * Real.log (N : ℝ)) :=
    mul_nonneg hC0 (by linarith)
  have t2 : max M 0 ≤ 2 * (max M 0 * (Real.sqrt (N : ℝ) * Real.log (N : ℝ))) := by nlinarith
  rw [e]
  by_cases hlt : N < N₀
  · have h1 : |wobble N| ≤ M :=
      hM _ (Finset.mem_image_of_mem _ (Finset.mem_range.mpr hlt))
    have h2 : M ≤ max M 0 := le_max_left _ _
    linarith
  · have h1 := hC N (by omega)
    have h2 : C * Real.sqrt (N : ℝ) * Real.log (N : ℝ)
        ≤ max C 0 * (Real.sqrt (N : ℝ) * Real.log (N : ℝ)) := by
      rw [mul_assoc]
      exact mul_le_mul_of_nonneg_right (le_max_left _ _) (by linarith)
    have t3 : 0 ≤ max M 0 * (Real.sqrt (N : ℝ) * Real.log (N : ℝ)) :=
      mul_nonneg hM0 (by linarith)
    linarith

/-- **From the wobble to the loop.** If the sieve's wobble stays at square-root
size, the spiral link holds. -/
theorem spiralLink_of_wobble (h : WobbleSqrt) : SpiralLink.SpiralLink := by
  obtain ⟨C, hC0, hC⟩ := wobble_all h
  obtain ⟨K, hK⟩ := schoenfeld_of_wobble hC0 hC
  exact SpiralLink.rh_iff_spiralLink.mp (PiToPsi.RH_of_schoenfeldWeak hK)

/-- **From the loop to the wobble.** If the spiral link holds, the sieve's
wobble stays at square-root size. -/
theorem wobble_of_spiralLink (h : SpiralLink.SpiralLink) : WobbleSqrt := by
  obtain ⟨C, x₀, hS⟩ :=
    PiToPsi.RH_iff_schoenfeldWeak.mp (SpiralLink.rh_iff_spiralLink.mpr h)
  have hres : ∀ n : ℕ, 2 ≤ n → x₀ ≤ (n : ℝ) →
      |resid n| ≤ max C 0 * (Real.sqrt (n : ℝ) * Real.log (n : ℝ)) := by
    intro n hn hx
    have h1 := hS (n : ℝ) hx
    simp only [Nat.floor_natCast, pow_one] at h1
    have hnr : (2 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
    have hnn : 0 ≤ Real.sqrt (n : ℝ) * Real.log (n : ℝ) :=
      mul_nonneg (Real.sqrt_nonneg _) (Real.log_nonneg (by linarith))
    have h2 : C * Real.sqrt (n : ℝ) * Real.log (n : ℝ)
        ≤ max C 0 * (Real.sqrt (n : ℝ) * Real.log (n : ℝ)) := by
      rw [mul_assoc]
      exact mul_le_mul_of_nonneg_right (le_max_left _ _) hnn
    unfold resid
    linarith
  have hC0 : 0 ≤ max C 0 := le_max_right _ _
  refine ⟨2 * max C 0, (⌈x₀⌉₊ + 2) ^ 2, ?_⟩
  intro N hN
  have hs : ⌈x₀⌉₊ + 2 ≤ Nat.sqrt N := Nat.le_sqrt'.mpr hN
  have hslt : Nat.sqrt N ≤ N := Nat.sqrt_le_self N
  have hN2 : 2 ≤ N := by omega
  have hxs : x₀ ≤ (Nat.sqrt N : ℝ) := by
    have h1 : x₀ ≤ (⌈x₀⌉₊ : ℝ) := Nat.le_ceil x₀
    have h2 : ((⌈x₀⌉₊ : ℕ) : ℝ) ≤ (Nat.sqrt N : ℝ) := by exact_mod_cast (by omega : ⌈x₀⌉₊ ≤ Nat.sqrt N)
    linarith
  have hsN : (Nat.sqrt N : ℝ) ≤ (N : ℝ) := by exact_mod_cast hslt
  have hsr : (2 : ℝ) ≤ (Nat.sqrt N : ℝ) := by exact_mod_cast (by omega : 2 ≤ Nat.sqrt N)
  have hrs := hres (Nat.sqrt N) (by omega) hxs
  have hrN := hres N hN2 (by linarith)
  have hw : wobble N = resid (Nat.sqrt N) - resid N := by
    have := resid_step hN2; linarith
  have hsq : Real.sqrt (Nat.sqrt N : ℝ) ≤ Real.sqrt (N : ℝ) := Real.sqrt_le_sqrt hsN
  have hlg : Real.log (Nat.sqrt N : ℝ) ≤ Real.log (N : ℝ) := Real.log_le_log (by linarith) hsN
  have hlg0 : 0 ≤ Real.log (Nat.sqrt N : ℝ) := Real.log_nonneg (by linarith)
  have hmono : Real.sqrt (Nat.sqrt N : ℝ) * Real.log (Nat.sqrt N : ℝ)
      ≤ Real.sqrt (N : ℝ) * Real.log (N : ℝ) :=
    mul_le_mul hsq hlg hlg0 (Real.sqrt_nonneg _)
  have hm2 : max C 0 * (Real.sqrt (Nat.sqrt N : ℝ) * Real.log (Nat.sqrt N : ℝ))
      ≤ max C 0 * (Real.sqrt (N : ℝ) * Real.log (N : ℝ)) :=
    mul_le_mul_of_nonneg_left hmono hC0
  have habs : |wobble N| ≤ |resid (Nat.sqrt N)| + |resid N| := by
    rw [hw]; exact abs_sub _ _
  have e : 2 * max C 0 * Real.sqrt (N : ℝ) * Real.log (N : ℝ)
      = 2 * (max C 0 * (Real.sqrt (N : ℝ) * Real.log (N : ℝ))) := by ring
  rw [e]
  linarith

/-- **The loop is the sieve's wobble.** The spiral link holds exactly when the
sieve's roundings, measured from one half and less their smooth part, stay at
square-root size. -/
theorem spiralLink_iff_wobble : SpiralLink.SpiralLink ↔ WobbleSqrt :=
  ⟨wobble_of_spiralLink, spiralLink_of_wobble⟩

/-- info: 'HalfSieve.ignition_is_zeta_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ignition_is_zeta_zero

/-- info: 'HalfSieve.netRounding_centered' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms netRounding_centered

/-- info: 'HalfSieve.resid_of_wobble' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms resid_of_wobble

/-- info: 'HalfSieve.spiralLink_iff_wobble' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms spiralLink_iff_wobble

end HalfSieve
