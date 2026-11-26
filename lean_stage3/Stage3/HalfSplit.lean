/-
# Stage3.HalfSplit — the sieve's rounding measured from Julian's half

`HalfSieve.netRounding_centered` measures every rounding of the sieve from one half, the
offset of the doubling's midpoint (`ignition_is_zeta_zero`: the half is `−ζ(0)`). Measured from
the half, the rounding of `N/d` is a sawtooth; it jumps exactly where `d ∣ N`. This file proves
the two exact facts the split of 2026-11-26 rests on (exploratory run in scratch):

  flag_sum      over the sieve's products that divide `N`, the signs add to `1` exactly when
                no prime up to `√N` divides `N`, and to `0` otherwise: the half's jumps flag
                whether `N` has a small prime factor
  fract_tail    a product `d > N` has `fract (N/d) = N/d`: past `N` the rounding is exact
-/
import Stage3.HalfSieve
import Stage3.PrimeStep

namespace HalfSplit

open Finset SieveExact

/-- **The half's jumps flag the small factors of `N`.** -/
theorem flag_sum (N : ℕ) :
    ∑ T ∈ (smallPrimes N).powerset.filter (fun T => (∏ p ∈ T, p) ∣ N), (-1 : ℤ) ^ T.card
      = if ∀ p ∈ smallPrimes N, ¬ p ∣ N then 1 else 0 := by
  have hset : (smallPrimes N).powerset.filter (fun T => (∏ p ∈ T, p) ∣ N)
      = ((smallPrimes N).filter (· ∣ N)).powerset := by
    ext T
    simp only [mem_filter, mem_powerset]
    constructor
    · rintro ⟨hT, hd⟩ p hp
      refine mem_filter.mpr ⟨hT hp, ?_⟩
      exact (forall_dvd_iff_prod_dvd T (fun q hq => prime_of_mem_smallPrimes (hT hq)) N).mpr hd p hp
    · intro hT
      have hTS : T ⊆ smallPrimes N := fun p hp => (mem_filter.mp (hT hp)).1
      refine ⟨hTS, ?_⟩
      exact (forall_dvd_iff_prod_dvd T (fun q hq => prime_of_mem_smallPrimes (hTS hq)) N).mp
        (fun p hp => (mem_filter.mp (hT hp)).2)
  rw [hset, Finset.sum_powerset_neg_one_pow_card]
  congr 1
  apply propext
  rw [filter_eq_empty_iff]

/-- **Past `N` the rounding is exact.** -/
theorem fract_tail {N d : ℕ} (hd : N < d) : Int.fract ((N : ℚ) / (d : ℚ)) = (N : ℚ) / (d : ℚ) := by
  have hd0 : (0 : ℚ) < d := by exact_mod_cast (lt_of_le_of_lt (Nat.zero_le N) hd)
  rw [Int.fract_eq_self]
  constructor
  · positivity
  · rw [div_lt_one hd0]; exact_mod_cast hd

end HalfSplit

/-- info: 'HalfSplit.flag_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfSplit.flag_sum

/-- info: 'HalfSplit.fract_tail' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfSplit.fract_tail

namespace HalfSplit

open Finset SieveExact

/-- The sieve's products up to `N`. -/
def lowT (N : ℕ) : Finset (Finset ℕ) := (smallPrimes N).powerset.filter (fun T => (∏ p ∈ T, p) ≤ N)

/-- The sieve's products past `N`. -/
def highT (N : ℕ) : Finset (Finset ℕ) := (smallPrimes N).powerset.filter (fun T => ¬ (∏ p ∈ T, p) ≤ N)

/-- **The net rounding, split at `N`.** The roundings of the products up to `N`, plus the
products past `N`, each contributing exactly `N/d`. -/
theorem net_split (N : ℕ) :
    netRounding N =
      ∑ T ∈ lowT N, (-1 : ℚ) ^ T.card * Int.fract ((N : ℚ) / ((∏ p ∈ T, p : ℕ) : ℚ))
      + ∑ T ∈ highT N, (-1 : ℚ) ^ T.card * ((N : ℚ) / ((∏ p ∈ T, p : ℕ) : ℚ)) := by
  unfold netRounding lowT highT
  rw [← Finset.sum_filter_add_sum_filter_not _ (fun T => (∏ p ∈ T, p) ≤ N)]
  congr 1
  refine Finset.sum_congr rfl fun T hT => ?_
  rw [fract_tail (not_le.mp (mem_filter.mp hT).2)]

/-- **The tail meets the product.** The smooth part less the tail is the exact fractions of
the products up to `N` alone. -/
theorem smooth_less_tail (N : ℕ) :
    smoothPart N - ∑ T ∈ highT N, (-1 : ℚ) ^ T.card * ((N : ℚ) / ((∏ p ∈ T, p : ℕ) : ℚ))
      = ∑ T ∈ lowT N, (-1 : ℚ) ^ T.card * ((N : ℚ) / ((∏ p ∈ T, p : ℕ) : ℚ)) := by
  unfold smoothPart lowT highT
  rw [← Finset.sum_filter_add_sum_filter_not _ (fun T => (∏ p ∈ T, p) ≤ N)]
  ring

/-- **The survivors are the floors of the products up to `N`.** With the tail gone, the
sieve's count is the signed floors `⌊N/d⌋` over the products `d ≤ N`. -/
theorem survivors_low (N : ℕ) :
    ((survivors N).card : ℚ) =
      ∑ T ∈ lowT N, (-1 : ℚ) ^ T.card * ((N / ∏ p ∈ T, p : ℕ) : ℚ) := by
  rw [sieve_split, net_split]
  have h := smooth_less_tail N
  rw [show ∀ a b c : ℚ, a - (b + c) = (a - c) - b from fun a b c => by ring, h,
    ← Finset.sum_sub_distrib]
  refine Finset.sum_congr rfl fun T _ => ?_
  rw [natDiv_eq_sub_fract]
  ring

end HalfSplit

/-- info: 'HalfSplit.net_split' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfSplit.net_split

/-- info: 'HalfSplit.smooth_less_tail' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfSplit.smooth_less_tail

/-- info: 'HalfSplit.survivors_low' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfSplit.survivors_low

namespace HalfSplit

open Finset SieveExact

/-- **The wobble through the products up to `N` alone.** The sieve's wobble is the smooth
counts `1 + Li N − Li √N` less the signed floors `⌊N/d⌋` of the products `d ≤ N`. Every
product past `N` has dropped out. -/
theorem wobble_low (N : ℕ) :
    HalfSieve.wobble N = 1 + Stage3.Li (N : ℝ) - Stage3.Li ((Nat.sqrt N : ℕ) : ℝ)
      - ∑ T ∈ lowT N, (-1 : ℝ) ^ T.card * ((N / ∏ p ∈ T, p : ℕ) : ℝ) := by
  have hs := sieve_split N
  rw [survivors_low, smoothPart_eq_prod] at hs
  have hnet : netRounding N = (N : ℚ) * ∏ p ∈ smallPrimes N, (1 - 1 / (p : ℚ))
      - ∑ T ∈ lowT N, (-1 : ℚ) ^ T.card * ((N / ∏ p ∈ T, p : ℕ) : ℚ) := by linarith
  unfold HalfSieve.wobble SieveResidual.smoothNet
  rw [hnet]
  push_cast
  ring

end HalfSplit

/-- info: 'HalfSplit.wobble_low' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfSplit.wobble_low

namespace HalfSplit

open Finset SieveExact

/-- **The low part measured from the half.** Each floor `⌊N/d⌋` is `N/d` less its rounding, and
the rounding is measured from Julian's half: the wobble is the smooth counts, less the exact
fractions of the products up to `N`, plus their centered roundings, plus half their signs. -/
theorem wobble_centered_low (N : ℕ) :
    HalfSieve.wobble N = 1 + Stage3.Li (N : ℝ) - Stage3.Li ((Nat.sqrt N : ℕ) : ℝ)
      - ∑ T ∈ lowT N, (-1 : ℝ) ^ T.card * ((N : ℝ) / ((∏ p ∈ T, p : ℕ) : ℝ))
      + ∑ T ∈ lowT N, (-1 : ℝ) ^ T.card *
          (((Int.fract ((N : ℚ) / ((∏ p ∈ T, p : ℕ) : ℚ)) : ℚ) : ℝ) - 1 / 2)
      + (1 / 2) * ∑ T ∈ lowT N, (-1 : ℝ) ^ T.card := by
  rw [wobble_low]
  have key : ∀ T ∈ lowT N, (-1 : ℝ) ^ T.card * ((N / ∏ p ∈ T, p : ℕ) : ℝ)
      = (-1 : ℝ) ^ T.card * ((N : ℝ) / ((∏ p ∈ T, p : ℕ) : ℝ))
        - (-1 : ℝ) ^ T.card * (((Int.fract ((N : ℚ) / ((∏ p ∈ T, p : ℕ) : ℚ)) : ℚ) : ℝ) - 1 / 2)
        - (1 / 2) * (-1 : ℝ) ^ T.card := by
    intro T _
    have h := natDiv_eq_sub_fract N (∏ p ∈ T, p)
    have h' : ((N / ∏ p ∈ T, p : ℕ) : ℝ) = (N : ℝ) / ((∏ p ∈ T, p : ℕ) : ℝ)
        - ((Int.fract ((N : ℚ) / ((∏ p ∈ T, p : ℕ) : ℚ)) : ℚ) : ℝ) := by
      have := congrArg (fun q : ℚ => (q : ℝ)) h
      push_cast at this ⊢
      exact this
    rw [h']; ring
  rw [Finset.sum_congr rfl key, Finset.sum_sub_distrib, Finset.sum_sub_distrib, ← Finset.mul_sum]
  ring

end HalfSplit

/-- info: 'HalfSplit.wobble_centered_low' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfSplit.wobble_centered_low

namespace HalfSplit

open Finset SieveExact

/-- A set of primes is read off its product: a prime is in it exactly when it divides it. -/
theorem mem_iff_dvd_prod {T : Finset ℕ} (hT : ∀ q ∈ T, q.Prime) {p : ℕ} (hp : p.Prime) :
    p ∈ T ↔ p ∣ ∏ q ∈ T, q := by
  constructor
  · intro h; exact Finset.dvd_prod_of_mem _ h
  · intro h
    obtain ⟨q, hq, hpq⟩ := (Prime.dvd_finsetProd_iff hp.prime _).mp h
    rwa [(Nat.prime_dvd_prime_iff_eq hp (hT q hq)).mp hpq]

/-- **The products up to `N` are at most `N` in number.** Distinct sets of primes have distinct
products, and each lies in `[1, N]`. -/
theorem card_lowT_le (N : ℕ) : (lowT N).card ≤ N := by
  have hinj : Set.InjOn (fun T : Finset ℕ => ∏ p ∈ T, p) (lowT N) := by
    intro T hT T' hT' h
    have hTp : ∀ q ∈ T, q.Prime := fun q hq =>
      prime_of_mem_smallPrimes (mem_powerset.mp (mem_filter.mp hT).1 hq)
    have hT'p : ∀ q ∈ T', q.Prime := fun q hq =>
      prime_of_mem_smallPrimes (mem_powerset.mp (mem_filter.mp hT').1 hq)
    ext p
    constructor
    · intro hp
      have hpp := hTp p hp
      rw [mem_iff_dvd_prod hT'p hpp]
      have := (mem_iff_dvd_prod hTp hpp).mp hp
      simpa [h] using this
    · intro hp
      have hpp := hT'p p hp
      rw [mem_iff_dvd_prod hTp hpp]
      have := (mem_iff_dvd_prod hT'p hpp).mp hp
      simpa [h] using this
  have hmaps : ∀ T ∈ lowT N, (∏ p ∈ T, p) ∈ Icc 1 N := by
    intro T hT
    have hTp : ∀ q ∈ T, q.Prime := fun q hq =>
      prime_of_mem_smallPrimes (mem_powerset.mp (mem_filter.mp hT).1 hq)
    refine mem_Icc.mpr ⟨?_, (mem_filter.mp hT).2⟩
    exact Nat.one_le_iff_ne_zero.mpr (Finset.prod_ne_zero_iff.mpr fun q hq => (hTp q hq).ne_zero)
  have := Finset.card_le_card_of_injOn _ hmaps hinj
  simpa using this

end HalfSplit

/-- info: 'HalfSplit.card_lowT_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfSplit.card_lowT_le

namespace HalfSplit

open Finset SieveExact

/-- **Each centered rounding is at most a half.** So their signed sum over the products up to
`N` is at most `N / 2`. This is the bound from sizes alone; it is `√N` short of `WobbleSqrt`,
a factor that grows with `N`, so it cannot close the line by itself. -/
theorem centered_low_le (N : ℕ) :
    |∑ T ∈ lowT N, (-1 : ℝ) ^ T.card *
        (((Int.fract ((N : ℚ) / ((∏ p ∈ T, p : ℕ) : ℚ)) : ℚ) : ℝ) - 1 / 2)| ≤ (N : ℝ) / 2 := by
  have hterm : ∀ T ∈ lowT N, |(-1 : ℝ) ^ T.card *
      (((Int.fract ((N : ℚ) / ((∏ p ∈ T, p : ℕ) : ℚ)) : ℚ) : ℝ) - 1 / 2)| ≤ 1 / 2 := by
    intro T _
    rw [abs_mul, abs_pow, abs_neg, abs_one, one_pow, one_mul, abs_le]
    have h0 := Int.fract_nonneg ((N : ℚ) / ((∏ p ∈ T, p : ℕ) : ℚ))
    have h1 := Int.fract_lt_one ((N : ℚ) / ((∏ p ∈ T, p : ℕ) : ℚ))
    have h0' : (0 : ℝ) ≤ ((Int.fract ((N : ℚ) / ((∏ p ∈ T, p : ℕ) : ℚ)) : ℚ) : ℝ) := by
      exact_mod_cast h0
    have h1' : ((Int.fract ((N : ℚ) / ((∏ p ∈ T, p : ℕ) : ℚ)) : ℚ) : ℝ) < 1 := by
      exact_mod_cast h1
    constructor <;> linarith
  calc _ ≤ ∑ T ∈ lowT N, |(-1 : ℝ) ^ T.card *
          (((Int.fract ((N : ℚ) / ((∏ p ∈ T, p : ℕ) : ℚ)) : ℚ) : ℝ) - 1 / 2)| :=
        Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ T ∈ lowT N, (1 / 2 : ℝ) := Finset.sum_le_sum hterm
    _ = (lowT N).card / 2 := by rw [Finset.sum_const, nsmul_eq_mul]; ring
    _ ≤ (N : ℝ) / 2 := by
        have := card_lowT_le N
        have : ((lowT N).card : ℝ) ≤ N := by exact_mod_cast this
        linarith

end HalfSplit

/-- info: 'HalfSplit.centered_low_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfSplit.centered_low_le

namespace HalfSplit

open Finset SieveExact

/-- **The centered rounding is Bernoulli's first function.** Measured from Julian's half, the
rounding of `x` is `B₁(fract x)`, and the half itself is `−B₁(0) = −ζ(0)`. This puts the
sieve's roundings on Mathlib's Bernoulli functions, whose Fourier series
(`hasSum_one_div_pow_mul_fourier_mul_bernoulliFun`) carry the harmonics. -/
theorem centered_eq_bernoulli (q : ℚ) :
    ((Int.fract q : ℚ) : ℝ) - 1 / 2 = bernoulliFun 1 (((Int.fract q : ℚ) : ℝ)) := by
  rw [bernoulliFun_one]

/-- The half is Bernoulli's first number, negated: `B₁(0) = −1/2`. -/
theorem half_is_bernoulli : bernoulliFun 1 0 = -(1 / 2) := by
  rw [bernoulliFun_one]; ring

end HalfSplit

/-- info: 'HalfSplit.centered_eq_bernoulli' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfSplit.centered_eq_bernoulli

/-- info: 'HalfSplit.half_is_bernoulli' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfSplit.half_is_bernoulli

namespace HalfSplit

open Finset SieveExact Real

/-- **The integrated rounding's harmonics.** One level up from the centered rounding, Bernoulli's
second function of the rounding of `x` is a sum of cosines of `x` itself, with weights `1/n²`,
absolutely convergent:

    π² · B₂(fract x) = Σ_{n ≥ 1} cos(2π n x) / n². -/
theorem bernoulli_two_rounding (x : ℝ) :
    HasSum (fun n : ℕ => 1 / (n : ℝ) ^ 2 * Real.cos (2 * π * n * x))
      (π ^ 2 * bernoulliFun 2 (Int.fract x)) := by
  have hx : Int.fract x ∈ Set.Icc (0 : ℝ) 1 :=
    ⟨Int.fract_nonneg x, (Int.fract_lt_one x).le⟩
  have h := hasSum_one_div_nat_pow_mul_cos (k := 1) one_ne_zero hx
  have hcos : ∀ n : ℕ, Real.cos (2 * π * n * Int.fract x) = Real.cos (2 * π * n * x) := by
    intro n
    have : 2 * π * n * x = 2 * π * n * Int.fract x + (n * ⌊x⌋ : ℤ) * (2 * π) := by
      have := Int.fract_add_floor x
      nth_rewrite 1 [← this]; push_cast; ring
    rw [this, Real.cos_add_int_mul_two_pi]
  simp only [hcos] at h
  convert h using 1
  simp only [bernoulliFun, Nat.factorial, Nat.succ_eq_add_one]
  norm_num
  left; ring

end HalfSplit

/-- info: 'HalfSplit.bernoulli_two_rounding' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfSplit.bernoulli_two_rounding

namespace HalfSplit

open Finset SieveExact Real

/-- **The sieve's integrated roundings as harmonics.** Over the products `d` up to `N`, the
signed second Bernoulli functions of the roundings of `N/d` are one cosine series: the `n`-th
harmonic is the signed sum of `cos(2π n N/d)` over the products, weighted `1/n²`. -/
theorem sieve_bernoulli_two (N : ℕ) :
    HasSum (fun n : ℕ => 1 / (n : ℝ) ^ 2 * ∑ T ∈ lowT N, (-1 : ℝ) ^ T.card *
        Real.cos (2 * π * n * ((N : ℝ) / ((∏ p ∈ T, p : ℕ) : ℝ))))
      (π ^ 2 * ∑ T ∈ lowT N, (-1 : ℝ) ^ T.card *
        bernoulliFun 2 (Int.fract ((N : ℝ) / ((∏ p ∈ T, p : ℕ) : ℝ)))) := by
  have h := hasSum_sum (s := lowT N) (fun T _ =>
    (bernoulli_two_rounding ((N : ℝ) / ((∏ p ∈ T, p : ℕ) : ℝ))).mul_left ((-1 : ℝ) ^ T.card))
  have e1 : (fun n : ℕ => 1 / (n : ℝ) ^ 2 * ∑ T ∈ lowT N, (-1 : ℝ) ^ T.card *
        Real.cos (2 * π * n * ((N : ℝ) / ((∏ p ∈ T, p : ℕ) : ℝ)))) =
      fun n : ℕ => ∑ T ∈ lowT N, (-1 : ℝ) ^ T.card * (1 / (n : ℝ) ^ 2 *
        Real.cos (2 * π * n * ((N : ℝ) / ((∏ p ∈ T, p : ℕ) : ℝ)))) := by
    funext n
    rw [Finset.mul_sum]
    exact Finset.sum_congr rfl fun T _ => by ring
  have e2 : π ^ 2 * ∑ T ∈ lowT N, (-1 : ℝ) ^ T.card *
        bernoulliFun 2 (Int.fract ((N : ℝ) / ((∏ p ∈ T, p : ℕ) : ℝ))) =
      ∑ T ∈ lowT N, (-1 : ℝ) ^ T.card * (π ^ 2 *
        bernoulliFun 2 (Int.fract ((N : ℝ) / ((∏ p ∈ T, p : ℕ) : ℝ)))) := by
    rw [Finset.mul_sum]
    exact Finset.sum_congr rfl fun T _ => by ring
  rw [e1, e2]
  exact h

end HalfSplit

/-- info: 'HalfSplit.sieve_bernoulli_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfSplit.sieve_bernoulli_two

namespace HalfSplit

open Finset SieveExact Real

/-- **Down from B₂ to Julian's half.** Between two integers, the integrated rounding
`B₂(fract y)` has slope `2·B₁(fract y)`: twice the rounding measured from the half. So the
harmonics of `sieve_bernoulli_two`, differentiated, are the harmonics of the centered roundings. -/
theorem hasDerivAt_bernoulli_two_fract {k : ℤ} {x : ℝ} (hx : x ∈ Set.Ioo (k : ℝ) (k + 1)) :
    HasDerivAt (fun y => bernoulliFun 2 (Int.fract y)) (2 * bernoulliFun 1 (Int.fract x)) x := by
  have hfr : ∀ y ∈ Set.Ioo (k : ℝ) (k + 1), Int.fract y = y - k := by
    intro y hy
    rw [Int.fract, Int.floor_eq_iff.mpr ⟨hy.1.le, hy.2⟩]
  have hev : (fun y => bernoulliFun 2 (Int.fract y)) =ᶠ[nhds x] (fun y => bernoulliFun 2 (y - k)) :=
    Filter.eventuallyEq_of_mem (Ioo_mem_nhds hx.1 hx.2) fun y hy => by simp only [hfr y hy]
  have hd : HasDerivAt (fun y => bernoulliFun 2 (y - k)) (2 * bernoulliFun 1 (x - k)) x := by
    have := (hasDerivAt_bernoulliFun 2 (x - k)).comp x ((hasDerivAt_id x).sub_const (k : ℝ))
    simp only [mul_one, Nat.cast_ofNat] at this
    exact this
  rw [hfr x hx]
  exact hd.congr_of_eventuallyEq hev

end HalfSplit

/-- info: 'HalfSplit.hasDerivAt_bernoulli_two_fract' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfSplit.hasDerivAt_bernoulli_two_fract

namespace HalfSplit

open Real

/-- **The half from a step of B₂.** A step `h` in the integrated rounding is twice the step times
the rounding measured from the half, plus the step squared:

    B₂(y + h) − B₂(y) = 2h·B₁(y) + h². -/
theorem bernoulli_two_step (y h : ℝ) :
    bernoulliFun 2 (y + h) - bernoulliFun 2 y = 2 * h * bernoulliFun 1 y + h ^ 2 := by
  rw [bernoulliFun_two, bernoulliFun_two, bernoulliFun_one]; ring

/-- In the rounding: inside one unit cell, a step of the integrated rounding gives Julian's half. -/
theorem bernoulli_two_step_fract {x h : ℝ} (hh : 0 ≤ h) (hcell : Int.fract x + h < 1) :
    bernoulliFun 2 (Int.fract (x + h)) - bernoulliFun 2 (Int.fract x)
      = 2 * h * bernoulliFun 1 (Int.fract x) + h ^ 2 := by
  have : Int.fract (x + h) = Int.fract x + h := by
    rw [Int.fract_eq_iff]
    refine ⟨by linarith [Int.fract_nonneg x], hcell, ⌊x⌋, ?_⟩
    rw [Int.fract]; ring
  rw [this, bernoulli_two_step]

end HalfSplit

/-- info: 'HalfSplit.bernoulli_two_step' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfSplit.bernoulli_two_step

/-- info: 'HalfSplit.bernoulli_two_step_fract' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfSplit.bernoulli_two_step_fract

namespace HalfSplit

open Finset SieveExact Real

/-- A shift of `N` by less than one never leaves the rounding's cell: `fract(N/d) + t/d < 1`. -/
theorem fract_add_lt_one {N d : ℕ} (hd : 0 < d) {t : ℝ} (ht : t < 1) :
    Int.fract ((N : ℝ) / d) + t / d < 1 := by
  rw [Int.fract_div_natCast_eq_div_natCast_mod]
  have hd' : (0 : ℝ) < d := by exact_mod_cast hd
  have hm : ((N % d : ℕ) : ℝ) + 1 ≤ d := by exact_mod_cast Nat.mod_lt N hd
  rw [← add_div, div_lt_one hd']
  linarith

/-- **The sieve's step from B₂ to the half.** Shifting `N` by `t ∈ [0, 1)`, the signed change of
the integrated roundings over the products up to `N` is the signed centered roundings, weighted
`2t/d`, plus `t²/d²`. -/
theorem sieve_step (N : ℕ) {t : ℝ} (ht0 : 0 ≤ t) (ht1 : t < 1) :
    ∑ T ∈ lowT N, (-1 : ℝ) ^ T.card *
        (bernoulliFun 2 (Int.fract (((N : ℝ) + t) / ((∏ p ∈ T, p : ℕ) : ℝ)))
          - bernoulliFun 2 (Int.fract ((N : ℝ) / ((∏ p ∈ T, p : ℕ) : ℝ))))
      = ∑ T ∈ lowT N, (-1 : ℝ) ^ T.card *
        (2 * (t / ((∏ p ∈ T, p : ℕ) : ℝ)) *
            bernoulliFun 1 (Int.fract ((N : ℝ) / ((∏ p ∈ T, p : ℕ) : ℝ)))
          + (t / ((∏ p ∈ T, p : ℕ) : ℝ)) ^ 2) := by
  refine Finset.sum_congr rfl fun T hT => ?_
  have hTp : ∀ q ∈ T, q.Prime := fun q hq =>
    prime_of_mem_smallPrimes (mem_powerset.mp (mem_filter.mp hT).1 hq)
  have hd : 0 < ∏ p ∈ T, p := Nat.pos_of_ne_zero
    (Finset.prod_ne_zero_iff.mpr fun q hq => (hTp q hq).ne_zero)
  have hd' : (0 : ℝ) < ((∏ p ∈ T, p : ℕ) : ℝ) := by exact_mod_cast hd
  have hshift : ((N : ℝ) + t) / ((∏ p ∈ T, p : ℕ) : ℝ)
      = (N : ℝ) / ((∏ p ∈ T, p : ℕ) : ℝ) + t / ((∏ p ∈ T, p : ℕ) : ℝ) := add_div _ _ _
  rw [hshift, bernoulli_two_step_fract (div_nonneg ht0 hd'.le) (fract_add_lt_one hd ht1)]

end HalfSplit

/-- info: 'HalfSplit.sieve_step' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfSplit.sieve_step

namespace HalfSplit

open Finset SieveExact Real

/-- `sieve_bernoulli_two` at any real point `y`, over the products of any finite family. -/
theorem family_bernoulli_two (F : Finset (Finset ℕ)) (y : ℝ) :
    HasSum (fun n : ℕ => 1 / (n : ℝ) ^ 2 * ∑ T ∈ F, (-1 : ℝ) ^ T.card *
        Real.cos (2 * π * n * (y / ((∏ p ∈ T, p : ℕ) : ℝ))))
      (π ^ 2 * ∑ T ∈ F, (-1 : ℝ) ^ T.card *
        bernoulliFun 2 (Int.fract (y / ((∏ p ∈ T, p : ℕ) : ℝ)))) := by
  have h := hasSum_sum (s := F) (fun T _ =>
    (bernoulli_two_rounding (y / ((∏ p ∈ T, p : ℕ) : ℝ))).mul_left ((-1 : ℝ) ^ T.card))
  have e1 : (fun n : ℕ => 1 / (n : ℝ) ^ 2 * ∑ T ∈ F, (-1 : ℝ) ^ T.card *
        Real.cos (2 * π * n * (y / ((∏ p ∈ T, p : ℕ) : ℝ)))) =
      fun n : ℕ => ∑ T ∈ F, (-1 : ℝ) ^ T.card * (1 / (n : ℝ) ^ 2 *
        Real.cos (2 * π * n * (y / ((∏ p ∈ T, p : ℕ) : ℝ)))) := by
    funext n; rw [Finset.mul_sum]; exact Finset.sum_congr rfl fun T _ => by ring
  have e2 : π ^ 2 * ∑ T ∈ F, (-1 : ℝ) ^ T.card *
        bernoulliFun 2 (Int.fract (y / ((∏ p ∈ T, p : ℕ) : ℝ))) =
      ∑ T ∈ F, (-1 : ℝ) ^ T.card * (π ^ 2 *
        bernoulliFun 2 (Int.fract (y / ((∏ p ∈ T, p : ℕ) : ℝ)))) := by
    rw [Finset.mul_sum]; exact Finset.sum_congr rfl fun T _ => by ring
  rw [e1, e2]; exact h

/-- **Julian's half as harmonics.** For `t ∈ [0, 1)`, the sieve's centered roundings over the
products up to `N`, weighted `2t/d`, plus `t²/d²`, are `1/π²` times the series whose `n`-th term
is `1/n²` times the signed change of `cos(2π n y/d)` from `y = N` to `y = N + t`. -/
theorem half_as_harmonics (N : ℕ) {t : ℝ} (ht0 : 0 ≤ t) (ht1 : t < 1) :
    HasSum (fun n : ℕ => 1 / (n : ℝ) ^ 2 * ∑ T ∈ lowT N, (-1 : ℝ) ^ T.card *
        (Real.cos (2 * π * n * (((N : ℝ) + t) / ((∏ p ∈ T, p : ℕ) : ℝ)))
          - Real.cos (2 * π * n * ((N : ℝ) / ((∏ p ∈ T, p : ℕ) : ℝ)))))
      (π ^ 2 * ∑ T ∈ lowT N, (-1 : ℝ) ^ T.card *
        (2 * (t / ((∏ p ∈ T, p : ℕ) : ℝ)) *
            bernoulliFun 1 (Int.fract ((N : ℝ) / ((∏ p ∈ T, p : ℕ) : ℝ)))
          + (t / ((∏ p ∈ T, p : ℕ) : ℝ)) ^ 2)) := by
  have h := (family_bernoulli_two (lowT N) ((N : ℝ) + t)).sub (family_bernoulli_two (lowT N) N)
  rw [← sieve_step N ht0 ht1]
  simp only [mul_sub, Finset.sum_sub_distrib] at h ⊢
  exact h

end HalfSplit

/-- info: 'HalfSplit.half_as_harmonics' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfSplit.half_as_harmonics

namespace HalfSplit

open Finset SieveExact Real

/-- The `n`-th harmonic of the sieve at the point `y`: the signed cosines over the products up
to `N`. -/
noncomputable def harmonic (N n : ℕ) (y : ℝ) : ℝ :=
  ∑ T ∈ lowT N, (-1 : ℝ) ^ T.card * Real.cos (2 * π * n * (y / ((∏ p ∈ T, p : ℕ) : ℝ)))

/-- **Each harmonic is at most `N` in size.** From sizes alone. Measured (scratch, exploratory,
2026-11-26): at `y = N`, `n ≤ 8`, the harmonic stays below `0.44·√N` for `N = 10³ … 10⁶`
while the products number `0.15·N`: the cancellation the bound must capture. -/
theorem abs_harmonic_le (N n : ℕ) (y : ℝ) : |harmonic N n y| ≤ N := by
  unfold harmonic
  calc _ ≤ ∑ T ∈ lowT N, |(-1 : ℝ) ^ T.card *
          Real.cos (2 * π * n * (y / ((∏ p ∈ T, p : ℕ) : ℝ)))| := Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ T ∈ lowT N, (1 : ℝ) := by
        refine Finset.sum_le_sum fun T _ => ?_
        rw [abs_mul, abs_pow, abs_neg, abs_one, one_pow, one_mul]
        exact Real.abs_cos_le_one _
    _ = (lowT N).card := by simp
    _ ≤ N := by exact_mod_cast card_lowT_le N

end HalfSplit

/-- info: 'HalfSplit.abs_harmonic_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfSplit.abs_harmonic_le

namespace HalfSplit

open Finset SieveExact Real

/-- The harmonic's term for one set of primes: its signed cosine if its product is at most `N`,
else nothing. -/
noncomputable def hterm (N n : ℕ) (y : ℝ) (T : Finset ℕ) : ℝ :=
  if (∏ p ∈ T, p) ≤ N then (-1 : ℝ) ^ T.card * Real.cos (2 * π * n * (y / ((∏ p ∈ T, p : ℕ) : ℝ)))
  else 0

/-- **The harmonic by its largest prime.** Grouped as `PrimeStep.net_by_steps` groups the
wobble: the empty product, plus for each prime `p ≤ √N` the products whose largest prime is `p`. -/
theorem harmonic_by_max (N n : ℕ) (y : ℝ) :
    harmonic N n y = hterm N n y ∅ +
      ∑ p ∈ smallPrimes N, ∑ t ∈ ((smallPrimes N).filter (· < p)).powerset,
        hterm N n y (insert p t) := by
  have h : harmonic N n y = ∑ T ∈ (smallPrimes N).powerset, hterm N n y T := by
    unfold harmonic lowT hterm
    rw [Finset.sum_filter]
  rw [h, PrimeStep.sum_powerset_by_max]

end HalfSplit

/-- info: 'HalfSplit.harmonic_by_max' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfSplit.harmonic_by_max
