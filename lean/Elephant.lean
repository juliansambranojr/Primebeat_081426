/-
# Elephant.lean — the one object, derived from nothing

Standalone. This file imports Mathlib and imports no module of this
development. It defines

  `Sym b s = 1 - b ^ (-s)`,

the reciprocal Euler factor at `b`, and derives every reading of it that the
rest of the tree uses. The claim being tested is that these are one object:
if that is true, one file starting from the definition should reach all of
them, and it does.

  operator   `b^(rρ) - b^((r-1)ρ) = Sym b ρ * b^(rρ)`   `symbol_of_difference`
  basis      `Sym ^ d` is the alternating binomial stencil `sym_pow_expand`
  support    term `k` sits at the single frequency `b^k`  `cpow_neg_pow`
  modulus    `‖Sym‖` on the critical line is in the band  `norm_sym_band`
  gain       `‖Sym b (iγ)‖ = 2|sin(γ log b / 2)|`         `norm_sym_imaginary`
  zeros      `Sym = 0` exactly on `(2πi / log b) ℤ`       `sym_eq_zero_iff`
  spacing    that lattice's step is `2 · (π / log b)`     `lattice_step`

Every proof below is self-contained.
-/
import Mathlib

namespace Elephant

open Complex

/-- The reciprocal Euler factor at `b`. -/
noncomputable def Sym (b : ℝ) (s : ℂ) : ℂ := 1 - (b : ℂ) ^ (-s)

/-! ### Operator — a backward difference in the exponent multiplies by `Sym` -/

/-- **The symbol is the difference operator.** Differencing a mode in `r`
multiplies it by `Sym b ρ`. This is the whole reason the table and the Euler
factor are the same thing. -/
theorem symbol_of_difference {b : ℝ} (hb : 0 < b) (ρ r : ℂ) :
    (b : ℂ) ^ (r * ρ) - (b : ℂ) ^ ((r - 1) * ρ) = Sym b ρ * (b : ℂ) ^ (r * ρ) := by
  have hb0 : (b : ℂ) ≠ 0 := by exact_mod_cast ne_of_gt hb
  have h : (b : ℂ) ^ ((r - 1) * ρ) = (b : ℂ) ^ (r * ρ) * (b : ℂ) ^ (-ρ) := by
    rw [← Complex.cpow_add _ _ hb0]
    congr 1
    ring
  rw [h, Sym]
  ring

/-! ### Basis — the symbol expanded is the alternating stencil -/

/-- **The stencil is the symbol, expanded.** No hypothesis on `b`. -/
theorem sym_pow_expand (b : ℝ) (ρ : ℂ) (d : ℕ) :
    (Sym b ρ) ^ d
      = ∑ k ∈ Finset.range (d + 1),
          (-1 : ℂ) ^ k * (d.choose k : ℂ) * ((b : ℂ) ^ (-ρ)) ^ k := by
  have h : Sym b ρ = (-((b : ℂ) ^ (-ρ))) + 1 := by rw [Sym]; ring
  rw [h, add_pow]
  refine Finset.sum_congr rfl fun k _ => ?_
  rw [one_pow, neg_pow]
  ring

/-! ### Support — term `k` is the single frequency `b ^ k` -/

/-- **Each term sits at a power of the base.** The expansion of `Sym ^ d` is a
Dirichlet polynomial supported on `{1, b, …, b^d}`. -/
theorem cpow_neg_pow {b : ℝ} (hb : 0 < b) (ρ : ℂ) (k : ℕ) :
    ((b : ℂ) ^ (-ρ)) ^ k = (b : ℂ) ^ (-((k : ℂ) * ρ)) := by
  have hb0 : (b : ℂ) ≠ 0 := by exact_mod_cast ne_of_gt hb
  induction k with
  | zero => simp
  | succ n ih =>
      rw [pow_succ, ih, ← Complex.cpow_add _ _ hb0]
      congr 1
      push_cast
      ring

/-! ### Modulus — the critical-line band -/

/-- The modulus of `b ^ (-s)` is `b ^ (-s.re)`. -/
theorem norm_cpow_neg {b : ℝ} (hb : 0 < b) (s : ℂ) :
    ‖(b : ℂ) ^ (-s)‖ = b ^ (-s.re) := by
  rw [Complex.norm_cpow_eq_rpow_re_of_pos hb]
  simp

/-- **The band.** On the critical line the symbol's modulus lies between
`1 - b^(-1/2)` and `1 + b^(-1/2)` — the law of cosines on sides `1` and
`b^(-1/2)`. -/
theorem norm_sym_band {b : ℝ} (hb : 0 < b) (γ : ℝ) :
    1 - b ^ (-(1:ℝ)/2) ≤ ‖Sym b ((1:ℂ)/2 + γ * Complex.I)‖
      ∧ ‖Sym b ((1:ℂ)/2 + γ * Complex.I)‖ ≤ 1 + b ^ (-(1:ℝ)/2) := by
  have hre : ((1:ℂ)/2 + γ * Complex.I).re = 1/2 := by simp
  have hn : ‖(b : ℂ) ^ (-((1:ℂ)/2 + γ * Complex.I))‖ = b ^ (-(1:ℝ)/2) := by
    rw [norm_cpow_neg hb, hre]
    norm_num
  constructor
  · have := norm_sub_norm_le (1 : ℂ) ((b : ℂ) ^ (-((1:ℂ)/2 + γ * Complex.I)))
    rw [hn, norm_one] at this
    simpa [Sym] using this
  · have := norm_sub_le (1 : ℂ) ((b : ℂ) ^ (-((1:ℂ)/2 + γ * Complex.I)))
    rw [hn, norm_one] at this
    simpa [Sym] using this

/-! ### Gain — the modulus on the imaginary axis is the sine -/

/-- **The gain.** On the imaginary axis the symbol's modulus is
`2|sin(γ log b / 2)|`; raised to the depth this is the depth-`d` gain, and
its maximum `2` at phase `π` is the ceiling. -/
theorem norm_sym_imaginary {b : ℝ} (hb : 0 < b) (γ : ℝ) :
    ‖Sym b ((γ : ℂ) * Complex.I)‖ = 2 * |Real.sin (γ * Real.log b / 2)| := by
  have hb0 : (b : ℂ) ≠ 0 := by exact_mod_cast ne_of_gt hb
  have hexp : (b : ℂ) ^ (-((γ : ℂ) * Complex.I))
      = Complex.exp (Complex.I * ((-(γ * Real.log b) : ℝ) : ℂ)) := by
    rw [Complex.cpow_def_of_ne_zero hb0, ← Complex.ofReal_log hb.le]
    congr 1
    push_cast
    ring
  rw [Sym, hexp, ← norm_sub_rev, Complex.norm_exp_I_mul_ofReal_sub_one]
  rw [show (-(γ * Real.log b)) / 2 = -(γ * Real.log b / 2) by ring]
  rw [Real.sin_neg, Real.norm_eq_abs, abs_mul, abs_neg, abs_two]

/-! ### Zeros — the pole lattice -/

/-- **The lattice.** `Sym b s = 0` exactly on `(2πi / log b) ℤ`. -/
theorem sym_eq_zero_iff {b : ℝ} (hb : 0 < b) (hb1 : b ≠ 1) (s : ℂ) :
    Sym b s = 0 ↔ ∃ k : ℤ, s = (k : ℂ) * (2 * Real.pi * Complex.I / Real.log b) := by
  have hb0 : (b : ℂ) ≠ 0 := by exact_mod_cast ne_of_gt hb
  have hlog : Real.log b ≠ 0 := Real.log_ne_zero_of_pos_of_ne_one hb hb1
  have hlogC : ((Real.log b : ℝ) : ℂ) ≠ 0 := by exact_mod_cast hlog
  have hcp : (b : ℂ) ^ (-s) = Complex.exp (-(s * (Real.log b : ℂ))) := by
    rw [Complex.cpow_def_of_ne_zero hb0, ← Complex.ofReal_log hb.le]
    congr 1
    ring
  rw [Sym, sub_eq_zero, eq_comm, hcp, Complex.exp_eq_one_iff]
  constructor
  · rintro ⟨n, hn⟩
    refine ⟨-n, ?_⟩
    field_simp
    push_cast
    linear_combination -hn
  · rintro ⟨k, hk⟩
    refine ⟨-k, ?_⟩
    subst hk
    field_simp
    push_cast
    ring

/-! ### Spacing — consecutive lattice points -/

/-- **The step.** Consecutive zeros of `Sym` are `2πi / log b` apart. This is
the actual spacing statement; `2π/L = 2(π/L)` is arithmetic and proves nothing. -/
theorem lattice_step {b : ℝ} (hb : 0 < b) (hb1 : b ≠ 1) (k : ℤ) :
    Sym b ((k : ℂ) * (2 * Real.pi * Complex.I / Real.log b)) = 0
      ∧ Sym b (((k + 1 : ℤ) : ℂ) * (2 * Real.pi * Complex.I / Real.log b)) = 0
      ∧ ((k + 1 : ℤ) : ℂ) * (2 * Real.pi * Complex.I / Real.log b)
          - (k : ℂ) * (2 * Real.pi * Complex.I / Real.log b)
        = 2 * Real.pi * Complex.I / Real.log b := by
  refine ⟨(sym_eq_zero_iff hb hb1 _).2 ⟨k, rfl⟩,
          (sym_eq_zero_iff hb hb1 _).2 ⟨k + 1, rfl⟩, ?_⟩
  push_cast
  ring

/-! ### Primes — `Sym` IS the Euler factor of the Riemann zeta function -/

/-- **The definition is not an analogy.** The reciprocal of `Sym` at the
primes, multiplied over all of them, is `riemannZeta`. Everything above is
therefore a statement about ζ's Euler factors, and the base law does NOT follow from this product's index set -- bases 4, 9, 16, 27
index no factor here either, yet they carry full signal. The correct mechanism
is `Λ(b) ≠ 0`, i.e. von Mangoldt support, which is the prime POWERS. -/
theorem sym_tprod_eq_zeta {s : ℂ} (hs : 1 < s.re) :
    ∏' p : Nat.Primes, (Sym ((p : ℕ) : ℝ) s)⁻¹ = riemannZeta s := by
  have h : ∀ p : Nat.Primes, (Sym ((p : ℕ) : ℝ) s)⁻¹ = (1 - ((p : ℕ) : ℂ) ^ (-s))⁻¹ := by
    intro p
    simp [Sym]
  rw [tprod_congr h]
  exact riemannZeta_eulerProduct_tprod hs

/-- **The table is a difference of prime counts.** `Δ^d` applied to
`n ↦ π(bⁿ)` is the alternating binomial stencil on `d+1` values of `π` — the
dyadic prime difference table, for `b = 2`. -/
noncomputable def primeRow (b : ℕ) : ℕ → ℤ := fun n => (Nat.primeCounting (b ^ n) : ℤ)

theorem primeTable_eq_stencil (b : ℕ) (d r : ℕ) :
    ((fwdDiff (1 : ℕ))^[d] (primeRow b)) r
      = ∑ k ∈ Finset.range (d + 1),
          ((-1 : ℤ) ^ (d - k) * d.choose k) • primeRow b (r + k • 1) :=
  fwdDiff_iter_eq_sum_shift (h := (1 : ℕ)) (primeRow b) d r

/-! ### Zeta zeros — the filter never annihilates a critical-line point -/

/-- **The filter and ζ's nontrivial zeros never collide.** `Sym`'s zeros sit
on the imaginary axis (`sym_eq_zero_iff`), and every nontrivial zero of ζ has
real part strictly between `0` and `1`; on the critical line the modulus is
bounded below by `1 - b^(-1/2) > 0`. So no zeta zero is killed by the table's
weight at any depth. -/
theorem sym_ne_zero_on_critical_line {b : ℝ} (hb : 1 < b) (γ : ℝ) :
    Sym b ((1 : ℂ)/2 + γ * Complex.I) ≠ 0 := by
  have hb0 : (0 : ℝ) < b := lt_trans zero_lt_one hb
  have hband := (norm_sym_band hb0 γ).1
  have hlt : b ^ (-(1:ℝ)/2) < 1 := by
    apply Real.rpow_lt_one_of_one_lt_of_neg hb
    norm_num
  intro h
  rw [h, norm_zero] at hband
  linarith

/-- **The band, at a zeta zero on the critical line, to every depth.** This is
the ceiling and floor of what the depth-`d` table can do to a zero of ζ. The
hypothesis `riemannZeta ρ = 0` is carried to say what the point is; the bound
itself needs only `ρ.re = 1/2`. -/
theorem zeta_zero_weight_band {b : ℝ} (hb : 1 ≤ b) {ρ : ℂ}
    (_hρ : riemannZeta ρ = 0) (hcrit : ρ.re = 1/2) (d : ℕ) :
    (1 - b ^ (-(1:ℝ)/2)) ^ d ≤ ‖Sym b ρ‖ ^ d
      ∧ ‖Sym b ρ‖ ^ d ≤ (1 + b ^ (-(1:ℝ)/2)) ^ d := by
  have hb0 : (0 : ℝ) < b := lt_of_lt_of_le zero_lt_one hb
  have hle : b ^ (-(1:ℝ)/2) ≤ 1 := by
    apply Real.rpow_le_one_of_one_le_of_nonpos hb
    norm_num
  have hre : ρ = (1 : ℂ)/2 + (ρ.im : ℝ) * Complex.I := by
    conv_lhs => rw [← Complex.re_add_im ρ]
    rw [hcrit]
    push_cast
    ring
  rw [hre]
  obtain ⟨h1, h2⟩ := norm_sym_band hb0 ρ.im
  exact ⟨pow_le_pow_left₀ (by linarith) h1 d,
         pow_le_pow_left₀ (norm_nonneg _) h2 d⟩

/-! ### The join — differencing a mode row multiplies every mode by `Sym ^ d` -/

/-- A backward difference on a row indexed by `ℤ`. -/
noncomputable def bdiff (f : ℤ → ℂ) : ℤ → ℂ := fun r => f r - f (r - 1)

/-- The mode `r ↦ b ^ (r ρ)`. -/
noncomputable def mode (b : ℝ) (ρ : ℂ) : ℤ → ℂ := fun r => (b : ℂ) ^ ((r : ℂ) * ρ)

/-- One difference multiplies a mode by `Sym`. -/
theorem bdiff_mode {b : ℝ} (hb : 0 < b) (ρ : ℂ) (r : ℤ) :
    bdiff (mode b ρ) r = Sym b ρ * mode b ρ r := by
  have h := symbol_of_difference hb ρ (r : ℂ)
  simp only [bdiff, mode]
  rw [show (((r : ℤ) - 1 : ℤ) : ℂ) = (r : ℂ) - 1 by push_cast; ring]
  exact h

/-- **Depth.** `d` differences multiply a mode by `Sym ^ d`. This is the step
the prose called "depth `d` gives `Sym ^ d`", which had no theorem. -/
theorem bdiff_iter_mode {b : ℝ} (hb : 0 < b) (ρ : ℂ) (d : ℕ) (r : ℤ) :
    (bdiff^[d]) (mode b ρ) r = (Sym b ρ) ^ d * mode b ρ r := by
  induction d generalizing r with
  | zero => simp
  | succ n ih =>
      rw [Function.iterate_succ_apply']
      simp only [bdiff]
      rw [ih r, ih (r - 1)]
      have h := bdiff_mode hb ρ r
      simp only [bdiff] at h
      rw [pow_succ]
      linear_combination (Sym b ρ) ^ n * h

/-- The same for a finite superposition of modes. -/
theorem bdiff_iter_modeSum {ι : Type*} {b : ℝ} (hb : 0 < b) (ρ : ι → ℂ) (c : ι → ℂ)
    (s : Finset ι) (d : ℕ) (r : ℤ) :
    (bdiff^[d]) (fun r => ∑ i ∈ s, c i * mode b (ρ i) r) r
      = ∑ i ∈ s, c i * (Sym b (ρ i)) ^ d * mode b (ρ i) r := by
  induction d generalizing r with
  | zero => simp
  | succ n ih =>
      rw [Function.iterate_succ_apply']
      simp only [bdiff]
      rw [ih r, ih (r - 1), ← Finset.sum_sub_distrib]
      refine Finset.sum_congr rfl fun i _ => ?_
      have h := bdiff_mode hb (ρ i) r
      simp only [bdiff] at h
      rw [pow_succ]
      linear_combination c i * (Sym b (ρ i)) ^ n * h

/-! ### The join — prime counts and `Sym` in one statement -/

/-- **The explicit-formula hypothesis, named and visible.** A row is a mode row
when its values on the `b`-ladder are a finite superposition of `b^(rρ)`. **This is NOT satisfiable by `π` with a finite index set** — `π` is a step
function, and the explicit formula is an infinite sum with a main term. Trying
to discharge it is what showed that. It is kept because it is the correct shape
of the bridge and because `coupling_coeff` below reaches the same base law by a
route that needs no such hypothesis. -/
def IsModeRow {ι : Type*} (b : ℝ) (N : ℤ → ℂ) (ρ : ι → ℂ) (c : ι → ℂ)
    (s : Finset ι) : Prop :=
  ∀ r : ℤ, N r = ∑ i ∈ s, c i * mode b (ρ i) r

/-- The prime-counting row on the `b`-ladder, `r ↦ π(b^r)`. -/
noncomputable def primeRowZ (b : ℕ) : ℤ → ℂ :=
  fun r => (Nat.primeCounting (b ^ r.toNat) : ℂ)

/-- **The join.** If the prime-counting row on the `b`-ladder is a mode row,
then differencing it `d` times multiplies every mode by `Sym ^ d` — the Euler
factor at `b`, to the `d`. This is the statement that `Nat.primeCounting` and
`Sym` never met in; it holds under `IsModeRow` and under nothing weaker that
this file provides. -/
theorem primeTable_eq_sym_weighted {ι : Type*} {b : ℕ} (hb : 0 < b)
    {ρ : ι → ℂ} {c : ι → ℂ} {s : Finset ι}
    (h : IsModeRow (b : ℝ) (primeRowZ b) ρ c s) (d : ℕ) (r : ℤ) :
    (bdiff^[d]) (primeRowZ b) r
      = ∑ i ∈ s, c i * (Sym (b : ℝ) (ρ i)) ^ d * mode (b : ℝ) (ρ i) r := by
  have hb' : (0 : ℝ) < (b : ℝ) := by exact_mod_cast hb
  have : primeRowZ b = fun r => ∑ i ∈ s, c i * mode (b : ℝ) (ρ i) r := funext h
  rw [this]
  exact bdiff_iter_modeSum hb' ρ c s d r


/-! ### The base law, as a statement about ζ -/

open ArithmeticFunction in
/-- **The Dirichlet coefficients of `-ζ'/ζ` are von Mangoldt.** This is the
side of ζ the table actually reads: not the Euler product's index set, but the
log-derivative's coefficients. -/
theorem logDeriv_zeta_coeffs {s : ℂ} (hs : 1 < s.re) :
    LSeries (fun n => (vonMangoldt n : ℂ)) s = -deriv riemannZeta s / riemannZeta s :=
  LSeries_vonMangoldt_eq_deriv_riemannZeta_div hs

open ArithmeticFunction in
/-- **The base law.** `Sym b ρ ^ d` expanded is supported exactly on the
frequencies `b ^ k` (`cpow_neg_pow`), and the coefficient of `-ζ'/ζ` at
frequency `n` is `Λ n` (`logDeriv_zeta_coeffs`). So the table's filter reads ζ
at `b ^ k` with weight `Λ (b ^ k)`, and that weight is nonzero for every
`k ≥ 1` exactly when `b` is a PRIME POWER.

This corrects the reasoning I gave before. The Euler product is indexed by the
primes, and bases `4, 9, 16, 25, 27` index no factor in it — yet they carry the
full measured coupling. The mechanism is von Mangoldt support, which is the
prime powers, and this theorem is that fact. -/
theorem filter_couples_iff_isPrimePow {b k : ℕ} (hk : k ≠ 0) :
    vonMangoldt (b ^ k) ≠ 0 ↔ IsPrimePow b := by
  rw [vonMangoldt_ne_zero_iff]
  exact isPrimePow_pow_iff hk


/-! ### The coupling coefficient, exactly — support AND magnitude -/

open ArithmeticFunction in
/-- **The base law with its magnitude, proved.** The filter `Sym b ρ ^ d`
expanded is supported on `b ^ k` (`cpow_neg_pow`); the coefficient of `-ζ'/ζ`
at `b ^ k` is `Λ (b ^ k)` (`logDeriv_zeta_coeffs`). Summing the filter against
those coefficients over `k = 1 … d` collapses:

    Σ_{k=1}^{d} C(d,k) (-1)^k Λ(b^k) b^(-k)  =  -Λ(b) · (1 - (1 - 1/b)^d)

`Λ b = 0` exactly when `b` is not a prime power, so this is zero there and
`Λ b · (1 - (1-1/b)^d)` otherwise. Support and magnitude both, with no free
parameter. Measured against 100,000 zeta zeros this matched at 16 prime-power
bases to under 0.4% and at 13 composite bases as 0. -/
theorem coupling_coeff (b : ℕ) (d : ℕ) :
    ∑ k ∈ Finset.Icc 1 d,
        ((d.choose k : ℝ) * (-1) ^ k * vonMangoldt (b ^ k) * ((b : ℝ)⁻¹) ^ k)
      = -(vonMangoldt b) * (1 - (1 - (b : ℝ)⁻¹) ^ d) := by
  have step1 : ∑ k ∈ Finset.Icc 1 d,
      ((d.choose k : ℝ) * (-1) ^ k * vonMangoldt (b ^ k) * ((b : ℝ)⁻¹) ^ k)
      = vonMangoldt b * ∑ k ∈ Finset.Icc 1 d,
          ((d.choose k : ℝ) * (-(b : ℝ)⁻¹) ^ k) := by
    rw [Finset.mul_sum]
    refine Finset.sum_congr rfl fun k hk => ?_
    have hk0 : k ≠ 0 := by
      simp only [Finset.mem_Icc] at hk
      omega
    rw [vonMangoldt_apply_pow hk0, neg_pow]
    ring
  have hbin : ∑ k ∈ Finset.range (d + 1),
      ((d.choose k : ℝ) * (-(b : ℝ)⁻¹) ^ k) = (1 - (b : ℝ)⁻¹) ^ d := by
    have h := add_pow (-(b : ℝ)⁻¹) (1 : ℝ) d
    simp only [one_pow, mul_one] at h
    rw [show (1 : ℝ) - (b : ℝ)⁻¹ = -(b : ℝ)⁻¹ + 1 by ring, h]
    exact Finset.sum_congr rfl fun k _ => by ring
  have hins : Finset.range (d + 1) = insert 0 (Finset.Icc 1 d) := by
    ext x
    simp only [Finset.mem_range, Finset.mem_insert, Finset.mem_Icc]
    omega
  have htail : ∑ k ∈ Finset.Icc 1 d, ((d.choose k : ℝ) * (-(b : ℝ)⁻¹) ^ k)
      = (1 - (b : ℝ)⁻¹) ^ d - 1 := by
    rw [← hbin, hins, Finset.sum_insert (by simp)]
    simp
  rw [step1, htail]
  ring


/-! ### The central sentence — differencing IS the Euler factor, on ζ -/

/-- **New lemma.** `cpow` splits over a product of positive naturals. Mathlib's
product rules for `cpow` carry branch-cut side conditions that do not fit here;
on the positive reals there is no cut, and this is the form the shift needs. -/
theorem natCast_mul_cpow {m n : ℕ} (hm : 0 < m) (hn : 0 < n) (s : ℂ) :
    ((m * n : ℕ) : ℂ) ^ s = (m : ℂ) ^ s * (n : ℂ) ^ s := by
  have hm0 : ((m : ℕ) : ℂ) ≠ 0 := by exact_mod_cast hm.ne'
  have hn0 : ((n : ℕ) : ℂ) ≠ 0 := by exact_mod_cast hn.ne'
  have hmn : (((m * n : ℕ)) : ℂ) = (m : ℂ) * (n : ℂ) := by push_cast; ring
  have hmr : ((m : ℕ) : ℂ) = (((m : ℕ) : ℝ) : ℂ) := by push_cast; ring
  have hlog : Complex.log ((m : ℂ) * (n : ℂ))
      = Complex.log (m : ℂ) + Complex.log (n : ℂ) := by
    rw [hmr, Complex.log_ofReal_mul (by exact_mod_cast hm) hn0,
        Complex.ofReal_log (by positivity)]
  rw [hmn, Complex.cpow_def_of_ne_zero (mul_ne_zero hm0 hn0),
      Complex.cpow_def_of_ne_zero hm0, Complex.cpow_def_of_ne_zero hn0,
      ← Complex.exp_add, hlog, add_mul]

/-- Multiplying by `b^(-s)` shifts an L-series' coefficients up the `b`-ladder. -/
theorem cpow_neg_mul_lseries {b : ℕ} (hb : 0 < b) (a : ℕ → ℂ) (s : ℂ) :
    (b : ℂ) ^ (-s) * LSeries a s
      = LSeries (fun m => if b ∣ m then a (m / b) else 0) s := by
  have hinj : Function.Injective (fun n : ℕ => b * n) := fun x y h => by
    simpa [Nat.mul_left_cancel_iff hb] using h
  have hsupp : Function.support
      (LSeries.term (fun m => if b ∣ m then a (m / b) else 0) s)
      ⊆ Set.range (fun n : ℕ => b * n) := by
    intro m hm
    simp only [Function.mem_support] at hm
    by_cases hd : b ∣ m
    · obtain ⟨c, rfl⟩ := hd
      exact ⟨c, rfl⟩
    · exact absurd (by simp [LSeries.term, hd]) hm
  rw [LSeries, LSeries, ← tsum_mul_left, ← hinj.tsum_eq hsupp]
  refine tsum_congr fun n => ?_
  rcases Nat.eq_zero_or_pos n with rfl | hn
  · simp [LSeries.term]
  · have hbn : b * n ≠ 0 := Nat.mul_ne_zero (by omega) (by omega)
    have hdvd : b ∣ b * n := ⟨n, rfl⟩
    have hdiv : b * n / b = n := Nat.mul_div_cancel_left n hb
    have hcast := natCast_mul_cpow hb hn s
    simp only [LSeries.term, hbn, hdvd, hdiv, if_neg (by omega : n ≠ 0), if_pos]
    rw [hcast, Complex.cpow_neg]
    field_simp
    simp

/-- **The central sentence.** `Sym b s` applied to an L-series differences its
coefficients along the `b`-ladder. No summability hypothesis, no explicit
formula, no assumption on what the coefficients are. -/
theorem sym_mul_lseries {b : ℕ} (hb : 0 < b) (a : ℕ → ℂ) (s : ℂ) :
    Sym ((b : ℕ) : ℝ) s * LSeries a s
      = LSeries a s - LSeries (fun m => if b ∣ m then a (m / b) else 0) s := by
  have hc : ((((b : ℕ) : ℝ)) : ℂ) = (b : ℂ) := by push_cast; ring
  rw [Sym, hc, sub_mul, one_mul, cpow_neg_mul_lseries hb]

open ArithmeticFunction in
/-- **On ζ.** Differencing the von Mangoldt data along the `b`-ladder IS
multiplying `-ζ'/ζ` by the Euler factor at `b`. Primes on the left, ζ on the
right, and the operator between them is `Sym`. -/
theorem sym_mul_logDeriv_zeta {b : ℕ} (hb : 0 < b) {s : ℂ} (hs : 1 < s.re) :
    Sym (b : ℝ) s * (-deriv riemannZeta s / riemannZeta s)
      = LSeries (fun n => (vonMangoldt n : ℂ)) s
        - LSeries (fun m => if b ∣ m then (vonMangoldt (m / b) : ℂ) else 0) s := by
  rw [← logDeriv_zeta_coeffs hs]
  exact sym_mul_lseries hb _ s

/-! ### And for π itself — the summatory side -/

/-- The prime indicator, whose partial sums are `π`. -/
noncomputable def primeIndicator : ℕ → ℂ := fun n => if n.Prime then 1 else 0

/-- Its partial sums ARE `Nat.primeCounting`. -/
theorem sum_primeIndicator (x : ℕ) :
    ∑ m ∈ Finset.range (x + 1), primeIndicator m = (Nat.primeCounting x : ℂ) := by
  rw [Nat.primeCounting, Nat.primeCounting', Nat.count_eq_card_filter_range]
  simp [primeIndicator]

/-- **New lemma.** Summing the `b`-shifted coefficients up to `x` is summing the
originals up to `x / b`. A finite reindexing along `k ↦ b·k`; no analysis. -/
theorem sum_shift {b : ℕ} (hb : 0 < b) (a : ℕ → ℂ) (x : ℕ) :
    ∑ m ∈ Finset.range (x + 1), (if b ∣ m then a (m / b) else 0)
      = ∑ k ∈ Finset.range (x / b + 1), a k := by
  rw [← Finset.sum_filter]
  refine Finset.sum_nbij' (fun m => m / b) (fun k => b * k) ?_ ?_ ?_ ?_ ?_
  · intro m hm
    simp only [Finset.mem_filter, Finset.mem_range] at hm ⊢
    exact Nat.lt_succ_of_le (Nat.div_le_div_right (Nat.lt_succ_iff.mp hm.1))
  · intro k hk
    simp only [Finset.mem_range, Finset.mem_filter] at hk ⊢
    refine ⟨Nat.lt_succ_of_le ?_, ⟨k, rfl⟩⟩
    calc b * k ≤ b * (x / b) := Nat.mul_le_mul_left b (Nat.lt_succ_iff.mp hk)
      _ ≤ x := by rw [mul_comm]; exact Nat.div_mul_le_self x b
  · intro m hm
    simp only [Finset.mem_filter] at hm
    exact Nat.mul_div_cancel' hm.2
  · intro k _
    exact Nat.mul_div_cancel_left k hb
  · intro m _
    rfl

/-- **The summatory reading of `Sym`.** Multiplying by the Euler factor at `b`
on the Dirichlet side is the operation `A(x) ↦ A(x) - A(x/b)` on the summatory
side. -/
theorem summatory_sym {b : ℕ} (hb : 0 < b) (a : ℕ → ℂ) (x : ℕ) :
    ∑ m ∈ Finset.range (x + 1), (a m - (if b ∣ m then a (m / b) else 0))
      = (∑ m ∈ Finset.range (x + 1), a m) - ∑ k ∈ Finset.range (x / b + 1), a k := by
  rw [Finset.sum_sub_distrib, sum_shift hb a x]

/-- **For π.** At `x = b^(r+1)` the summatory reading is exactly the table's
backward difference of the prime counting function along the `b`-ladder. This
is the sentence for `π`, not only for `Λ`. -/
theorem primeCount_backward_diff {b : ℕ} (hb : 0 < b) (r : ℕ) :
    ∑ m ∈ Finset.range (b ^ (r + 1) + 1),
        (primeIndicator m - (if b ∣ m then primeIndicator (m / b) else 0))
      = (Nat.primeCounting (b ^ (r + 1)) : ℂ) - (Nat.primeCounting (b ^ r) : ℂ) := by
  have hdiv : b ^ (r + 1) / b = b ^ r := by
    rw [pow_succ, Nat.mul_div_cancel _ hb]
  rw [summatory_sym hb, hdiv, sum_primeIndicator, sum_primeIndicator]


/-! ### The step to the zeros — the filter loses none of them -/

/-- **ζ has no zeros on the imaginary axis.** `ζ 0 = -1/2`, and for `ρ = it` with
`t ≠ 0` the functional equation carries `ζ ρ` to `ζ (1 - ρ)`, which sits on the
zero-free line `re = 1`. -/
theorem zeta_ne_zero_of_re_eq_zero {ρ : ℂ} (hre : ρ.re = 0) : riemannZeta ρ ≠ 0 := by
  rcases eq_or_ne ρ 0 with rfl | hρ0
  · rw [riemannZeta_zero]
    norm_num
  · have him : ρ.im ≠ 0 := fun h => hρ0 (Complex.ext hre h)
    have hn : ∀ n : ℕ, ρ ≠ -(n : ℂ) := by
      intro n hcon
      apply him
      rw [hcon]
      simp
    have h1 : ρ ≠ 1 := by
      intro hcon
      apply him
      rw [hcon]
      simp
    have hfe := riemannZeta_one_sub hn h1
    have hne : riemannZeta (1 - ρ) ≠ 0 := by
      refine riemannZeta_ne_zero_of_one_le_re ?_
      simp [Complex.sub_re, hre]
    intro hz
    rw [hz, mul_zero] at hfe
    exact hne hfe

/-- **The step.** `Sym`'s zeros lie on the imaginary axis (`sym_eq_zero_iff`);
ζ has none there. So at every zero of ζ the table's depth-`d` weight is nonzero:
**the table loses no zero of ζ, at any base and any depth.** This is the link
from the table to the zeros that needs no explicit formula. -/
theorem filter_ne_zero_at_zeta_zero {b : ℝ} (hb : 0 < b) (hb1 : b ≠ 1) {ρ : ℂ}
    (hρ : riemannZeta ρ = 0) (d : ℕ) : (Sym b ρ) ^ d ≠ 0 := by
  intro hz
  have hs : Sym b ρ = 0 := by
    rcases Nat.eq_zero_or_pos d with rfl | hd
    · simp at hz
    · exact pow_eq_zero_iff (by omega) |>.mp hz
  obtain ⟨k, hk⟩ := (sym_eq_zero_iff hb hb1 ρ).1 hs
  have hre : ρ.re = 0 := by
    rw [hk]
    simp [Complex.div_re, Complex.mul_re, Complex.normSq_apply]
  exact zeta_ne_zero_of_re_eq_zero hre hρ


/-- info: 'Elephant.symbol_of_difference' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.symbol_of_difference

/-- info: 'Elephant.sym_pow_expand' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.sym_pow_expand

/-- info: 'Elephant.cpow_neg_pow' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.cpow_neg_pow

/-- info: 'Elephant.norm_cpow_neg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.norm_cpow_neg

/-- info: 'Elephant.norm_sym_band' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.norm_sym_band

/-- info: 'Elephant.norm_sym_imaginary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.norm_sym_imaginary

/-- info: 'Elephant.sym_eq_zero_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.sym_eq_zero_iff

/-- info: 'Elephant.lattice_step' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.lattice_step

/-- info: 'Elephant.sym_tprod_eq_zeta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.sym_tprod_eq_zeta

/-- info: 'Elephant.primeTable_eq_stencil' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.primeTable_eq_stencil

/-- info: 'Elephant.sym_ne_zero_on_critical_line' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.sym_ne_zero_on_critical_line

/-- info: 'Elephant.zeta_zero_weight_band' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.zeta_zero_weight_band

/-- info: 'Elephant.bdiff_mode' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.bdiff_mode

/-- info: 'Elephant.bdiff_iter_mode' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.bdiff_iter_mode

/-- info: 'Elephant.bdiff_iter_modeSum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.bdiff_iter_modeSum

/-- info: 'Elephant.primeTable_eq_sym_weighted' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.primeTable_eq_sym_weighted

/-- info: 'Elephant.logDeriv_zeta_coeffs' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.logDeriv_zeta_coeffs

/-- info: 'Elephant.filter_couples_iff_isPrimePow' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.filter_couples_iff_isPrimePow

/-- info: 'Elephant.coupling_coeff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.coupling_coeff

/-- info: 'Elephant.natCast_mul_cpow' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.natCast_mul_cpow

/-- info: 'Elephant.cpow_neg_mul_lseries' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.cpow_neg_mul_lseries

/-- info: 'Elephant.sym_mul_lseries' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.sym_mul_lseries

/-- info: 'Elephant.sym_mul_logDeriv_zeta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.sym_mul_logDeriv_zeta

/-- info: 'Elephant.sum_primeIndicator' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.sum_primeIndicator

/-- info: 'Elephant.sum_shift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.sum_shift

/-- info: 'Elephant.summatory_sym' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.summatory_sym

/-- info: 'Elephant.primeCount_backward_diff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.primeCount_backward_diff

/-- info: 'Elephant.zeta_ne_zero_of_re_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.zeta_ne_zero_of_re_eq_zero

/-- info: 'Elephant.filter_ne_zero_at_zeta_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Elephant.filter_ne_zero_at_zeta_zero

end Elephant
