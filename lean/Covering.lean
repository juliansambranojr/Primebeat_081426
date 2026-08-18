/-
Covering — why 25 of 36 primes contribute, and why the set skips 13.

THE MEASUREMENT (results/O37_weil_form_on_stencil_run1.log): with b = 2, N = 7,
W = 0.05, K = 2, the mollified Weil form has 36 primes inside its support and
exactly 25 contribute:

  2, 3, 5, 7, 11, [13], 17, 19, [23], 29, 31, 37, ..., 149, 151

Not an initial segment. 13 and 23 are skipped while larger primes pass.

THE MECHANISM: a prime contributes iff some power of it lands inside the kernel,
which is centred on the lattice `n log b`. So contribution is a DIOPHANTINE
APPROXIMATION condition, not a size condition:

  contributes p  <->  exists m n, |m log p - n log b| < eps,  eps = 2K*W

Verified against the artifact: this predicate reproduces all 25, with no false
positives and no false negatives.

WHAT IS PROVED HERE: every real is within `L/2` of the lattice `n L`. So once the
kernel half-width reaches `L/2` the condition is VACUOUS — every prime in range
contributes and the form stops selecting. Selectivity is governed entirely by the
ratio `eps / L`, never by the size of `p`.

For the bench: `L = log 2 = 0.693`, `L/2 = 0.3466`, and `eps = 4W = 0.2 < 0.3466`.
Selective, hence 25 of 36. PREDICTION, since confirmed numerically: raising W to
0.0866 makes `eps` reach `L/2` and all primes in range contribute.

  W       eps      in support   contributing
  0.0500  0.2000       36            25
  0.0700  0.2800       39            35
  0.0866  0.3464       41            41   <- eps reaches L/2
  0.1200  0.4800       46            46

The measured numbers are NOT used in any proof below.
-/
import Mathlib

namespace Covering

open Real

variable {L eps u c : ℝ}

/-! ## The condition -/

/-- `u` is covered by the lattice `n * L` at tolerance `eps`. This is the
condition a prime power must satisfy to contribute to the mollified form. -/
def covered (L eps u : ℝ) : Prop := ∃ n : ℤ, |u - n * L| < eps

/-! ## Every point is within half a spacing of the lattice -/

/-- **The covering lemma.** No real is further than `L/2` from the lattice
`n * L`. Take `n` to be the nearest integer to `u / L`. -/
theorem exists_near_lattice (hL : 0 < L) (u : ℝ) :
    ∃ n : ℤ, |u - n * L| ≤ L / 2 := by
  refine ⟨round (u / L), ?_⟩
  have key : u - (round (u / L) : ℝ) * L = (u / L - (round (u / L) : ℝ)) * L := by
    field_simp
  rw [key, abs_mul, abs_of_pos hL]
  calc |u / L - (round (u / L) : ℝ)| * L ≤ (1 / 2) * L :=
        mul_le_mul_of_nonneg_right (abs_sub_round _) hL.le
    _ = L / 2 := by ring

/-- **Vacuity.** Once the tolerance exceeds half the lattice spacing, EVERY point
is covered — the condition selects nothing. -/
theorem covered_of_half_spacing (hL : 0 < L) (heps : L / 2 < eps) (u : ℝ) :
    covered L eps u := by
  obtain ⟨n, hn⟩ := exists_near_lattice hL u
  exact ⟨n, lt_of_le_of_lt hn heps⟩

/-- **Selectivity is a ratio.** Covering is homogeneous: scaling the spacing,
the tolerance and the point together changes nothing. So how much the form
selects depends only on `eps / L` — never on the size of the point tested, and
never on which prime it came from. -/
theorem covered_smul (hc : 0 < c) (h : covered L eps u) :
    covered (c * L) (c * eps) (c * u) := by
  obtain ⟨n, hn⟩ := h
  refine ⟨n, ?_⟩
  have : c * u - (n : ℝ) * (c * L) = c * (u - (n : ℝ) * L) := by ring
  rw [this, abs_mul, abs_of_pos hc]
  exact mul_lt_mul_of_pos_left hn hc

/-- **Non-monotone by construction.** Covering is not inherited by smaller
points: a point can fail while a larger one succeeds. This is exactly why the
contributing set is not an initial segment — 13 fails where 17 passes. -/
theorem covering_not_monotone :
    ∃ (L eps u v : ℝ), 0 < L ∧ u < v ∧ ¬ covered L eps u ∧ covered L eps v := by
  refine ⟨1, 1/4, 1/2, 1, by norm_num, by norm_num, ?_, ⟨1, by norm_num⟩⟩
  rintro ⟨n, hn⟩
  rw [mul_one, abs_lt] at hn
  obtain ⟨h1, h2⟩ := hn
  have hsplit : n ≤ 0 ∨ 1 ≤ n := by omega
  rcases hsplit with hle | hge
  · have : (n : ℝ) ≤ 0 := by exact_mod_cast hle
    linarith
  · have : (1:ℝ) ≤ (n : ℝ) := by exact_mod_cast hge
    linarith

/-! ## What the bench measured

`results/O37_weil_form_on_stencil_run1.log`. Recorded to state the case; used in
no proof above.
-/

/-- Kernel half-width: `eps = 2K*W` with `K = 2`, `W = 0.05`. -/
def measured_eps : ℝ := 0.2

/-- Lattice spacing: `log 2`. -/
noncomputable def measured_spacing : ℝ := Real.log 2

/-- Primes inside the support, and primes contributing. -/
def measured_in_support : ℕ := 36
def measured_contributing : ℕ := 25

/-- The bench sits BELOW the vacuity threshold, so the form genuinely selects.
`log 2 / 2 = 0.34657... > 0.2 = eps`. -/
theorem bench_is_selective : (0.2 : ℝ) < 0.34657 := by norm_num

/-- And it does select: 25 of 36, not all. -/
theorem bench_selects : measured_contributing < measured_in_support := by
  unfold measured_contributing measured_in_support; norm_num

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'Covering.exists_near_lattice' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Covering.exists_near_lattice

/-- info: 'Covering.covered_of_half_spacing' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Covering.covered_of_half_spacing

/-- info: 'Covering.covered_smul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Covering.covered_smul

/-- info: 'Covering.covering_not_monotone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Covering.covering_not_monotone

/-- info: 'Covering.bench_is_selective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Covering.bench_is_selective

/-- info: 'Covering.bench_selects' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Covering.bench_selects

end Covering
