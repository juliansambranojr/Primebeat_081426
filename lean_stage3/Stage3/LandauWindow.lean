/-
LandauWindow — the Landau window criterion as a statement, and what it gives:
a one-sided bound on one function of the primes, on long windows, implies
Mathlib's `RiemannHypothesis`. Block 1 of `lean_stage3/design/landau.md`.
2026-11-22.

The function is

    G(y) = Σ_{n ≤ y} Λ(n)·(y/n − 1) − y·log y + (1 + γ)·y,

the smoothed von Mangoldt sum with its main terms removed. The criterion:
if for arbitrarily large `Y` one has `G(y) ≤ C·y^θ` on all of
`[Y, Y^(1+δ)]`, then `ζ` has no zero with real part above `θ`. Its shape is
read from the archive Levent Alpöge released on 2026-11-20
(`Deduction.zeroFree_of_rpow_window`, there for families of Dirichlet
characters). No code is taken from that archive, which carries no licence.
Here the criterion is `StmtLandauWindow`, a named leaf for `ζ` alone; its
proof is planned in the worksheet and is not in this module.

What this module proves is everything around the leaf:

  WindowBound θ δ C       the hypothesis, a statement about primes only
  StmtLandauWindow        the criterion, as a statement
  zeta_neg_nat_ne_zero    ζ(−n) ≠ 0 unless n = 2(k+1): the trivial zeros are
                          the only zeros at the nonpositive integers
  rh_of_zeroFree_half     no zero with real part above 1/2 → RiemannHypothesis
  zeroFree_half_of_window StmtLandauWindow, and a window bound at every
                          θ in (1/2, 1) → no zero with real part above 1/2
  rh_of_window            the same hypotheses → RiemannHypothesis

`rh_of_zeroFree_half` is the functional equation: a zero left of the line,
off the nonpositive integers, reflects to a zero right of it.

What the next slice needs: the Mellin transform of `rampSum` on `Re s > 1`,
`∫₁^∞ rampSum(y)·y^(−s−1) dy = −ζ'/ζ(s)/(s(s−1))`, which is where `G` meets
the zeros (worksheet, slice 2).

Axioms: every theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Mathlib

namespace LandauWindow

noncomputable section

open Complex

/-- `Σ_{n ≤ y} Λ(n)·(y/n − 1)`, the von Mangoldt sum against the ramp. -/
def rampSum (y : ℝ) : ℝ :=
  ∑ n ∈ Finset.range (⌊y⌋₊ + 1), ArithmeticFunction.vonMangoldt n * max (y / n - 1) 0

/-- The ramp sum with its main terms removed. -/
def G (y : ℝ) : ℝ :=
  rampSum y - y * Real.log y + (1 + Real.eulerMascheroniConstant) * y

/-- The hypothesis: `G(y) ≤ C·y^θ` on a window `[Y, Y^(1+δ)]`, for arbitrarily large `Y`. -/
def WindowBound (θ δ C : ℝ) : Prop :=
  ∀ Y₀ : ℝ, ∃ Y : ℝ, Y₀ ≤ Y ∧ ∀ y ∈ Set.Icc Y (Y ^ (1 + δ)), G y ≤ C * y ^ θ

/-- **The Landau window criterion, as a statement.** -/
def StmtLandauWindow : Prop :=
  ∀ θ δ C : ℝ, 0 < θ → θ < 1 → 0 < δ → WindowBound θ δ C →
    ∀ s : ℂ, θ < s.re → riemannZeta s ≠ 0

/-- `ζ` does not vanish at a nonpositive integer other than a trivial zero. -/
theorem zeta_neg_nat_ne_zero (n : ℕ) (hn : ¬∃ k : ℕ, n = 2 * (k + 1)) :
    riemannZeta (-(n : ℂ)) ≠ 0 := by
  rcases Nat.even_or_odd n with he | ho
  · obtain ⟨k, hk⟩ := he
    rcases Nat.eq_zero_or_pos k with hk0 | hkpos
    · have hn0 : n = 0 := by omega
      subst hn0
      simp [riemannZeta_zero]
    · exact absurd ⟨k - 1, by omega⟩ hn
  · obtain ⟨k, hk⟩ := ho
    have hs : ∀ m : ℕ, ((n : ℂ) + 1) ≠ -(m : ℂ) := by
      intro m h
      have h2 := congrArg Complex.re h
      simp at h2
      have h3 : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
      have h4 : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
      linarith
    have hs' : ((n : ℂ) + 1) ≠ 1 := by
      intro h
      have h2 : (n : ℂ) = 0 := by linear_combination h
      have h3 : n = 0 := by exact_mod_cast h2
      omega
    have hfe := riemannZeta_one_sub hs hs'
    have harg : (1 : ℂ) - ((n : ℂ) + 1) = -(n : ℂ) := by ring
    rw [harg] at hfe
    rw [hfe]
    have h2pi : (2 * (Real.pi : ℂ)) ≠ 0 := by
      have hpi : (Real.pi : ℂ) ≠ 0 := by exact_mod_cast Real.pi_ne_zero
      exact mul_ne_zero two_ne_zero hpi
    have hcos : Complex.cos ((Real.pi : ℂ) * ((n : ℂ) + 1) / 2) ≠ 0 := by
      have harg2 : (Real.pi : ℂ) * ((n : ℂ) + 1) / 2
          = ((((k + 1 : ℕ) : ℝ) * Real.pi : ℝ) : ℂ) := by
        rw [hk]
        push_cast
        ring
      rw [harg2, ← Complex.ofReal_cos, Real.cos_nat_mul_pi]
      exact_mod_cast pow_ne_zero (k + 1) (by norm_num : (-1 : ℝ) ≠ 0)
    have hzeta : riemannZeta ((n : ℂ) + 1) ≠ 0 := by
      apply riemannZeta_ne_zero_of_one_lt_re
      simp
      have : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast (by omega : 1 ≤ n)
      linarith
    have hpow : (2 * (Real.pi : ℂ)) ^ (-((n : ℂ) + 1)) ≠ 0 :=
      Complex.cpow_ne_zero_iff.mpr (Or.inl h2pi)
    exact mul_ne_zero (mul_ne_zero (mul_ne_zero (mul_ne_zero two_ne_zero hpow)
      (Complex.Gamma_ne_zero hs)) hcos) hzeta

/-- **From a zero-free half-plane to the Riemann hypothesis.** -/
theorem rh_of_zeroFree_half (h : ∀ s : ℂ, 1 / 2 < s.re → riemannZeta s ≠ 0) :
    RiemannHypothesis := by
  intro s hz hnt hne1
  by_contra hre
  rcases lt_or_gt_of_ne hre with hlt | hgt
  · by_cases hn : ∃ n : ℕ, s = -(n : ℂ)
    · obtain ⟨n, rfl⟩ := hn
      refine zeta_neg_nat_ne_zero n ?_ hz
      rintro ⟨k, hk⟩
      apply hnt
      refine ⟨k, ?_⟩
      rw [hk]
      push_cast
      ring
    · push Not at hn
      have hfe := riemannZeta_one_sub hn hne1
      rw [hz, mul_zero] at hfe
      refine h (1 - s) ?_ hfe
      simp
      linarith
  · exact h s hgt hz

/-- The criterion and a window bound at every `θ` above `1/2` give a zero-free half-plane. -/
theorem zeroFree_half_of_window (hL : StmtLandauWindow)
    (hW : ∀ θ : ℝ, 1 / 2 < θ → θ < 1 → ∃ δ C : ℝ, 0 < δ ∧ WindowBound θ δ C) :
    ∀ s : ℂ, 1 / 2 < s.re → riemannZeta s ≠ 0 := by
  intro s hs
  by_cases h1 : 1 ≤ s.re
  · exact riemannZeta_ne_zero_of_one_le_re h1
  · have h1' : s.re < 1 := lt_of_not_ge h1
    set θ : ℝ := (1 / 2 + s.re) / 2 with hθ
    have hθ1 : 1 / 2 < θ := by rw [hθ]; linarith
    have hθ2 : θ < s.re := by rw [hθ]; linarith
    have hθ3 : θ < 1 := by linarith
    obtain ⟨δ, C, hδ, hWB⟩ := hW θ hθ1 hθ3
    exact hL θ δ C (by linarith) hθ3 hδ hWB s hθ2

/-- **The window bound gives the Riemann hypothesis**, given the criterion. -/
theorem rh_of_window (hL : StmtLandauWindow)
    (hW : ∀ θ : ℝ, 1 / 2 < θ → θ < 1 → ∃ δ C : ℝ, 0 < δ ∧ WindowBound θ δ C) :
    RiemannHypothesis :=
  rh_of_zeroFree_half (zeroFree_half_of_window hL hW)

end

/-- info: 'LandauWindow.zeta_neg_nat_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeta_neg_nat_ne_zero

/-- info: 'LandauWindow.rh_of_zeroFree_half' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rh_of_zeroFree_half

/-- info: 'LandauWindow.zeroFree_half_of_window' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeroFree_half_of_window

/-- info: 'LandauWindow.rh_of_window' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rh_of_window

end LandauWindow
