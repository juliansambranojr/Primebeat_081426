/-
GeneratorPeak — why the block-size account cannot explain a peak at four.

THE MEASUREMENT (results/O24_gen_xmax3e9_run.log, and the 1.5e8 and 1e9 logs):
`P_max/median` over generator sets G1..G8 rises to G4 = {2,3,5,7} and falls
after, at every xmax measured. The peak is interior.

THE PROPOSED MECHANISM (lab_notebook entry 24): a tradeoff. More generators give
a denser orbit — more rungs, better frequency resolution — but split the same
prime range over more blocks, so per-block signal falls. The peak is where the
two balance.

WHAT IS PROVED HERE: that mechanism, in power-law form, has NO interior peak.
If the score is `R^α * n^β` with `R` rungs and `n = P / R` primes per block, then
`score = P^β * R^(α-β)`, which is strictly monotone in the generator count
whenever `α ≠ β` — and constant when `α = β`. Monotone or constant; never peaked.

So the measurement refutes the mechanism. Either the tradeoff is not a power law,
or something outside it pins the peak to four.

The measured numbers are NOT imported into any proof below. They appear once, at
the end, as the falsifier.
-/
import Mathlib

namespace GeneratorPeak

open Real

/-! ## The model -/

variable (R : ℕ → ℝ) (P α β : ℝ)

/-- Primes per block: the fixed prime supply `P` split over `R k` rungs. -/
noncomputable def perBlock (R : ℕ → ℝ) (P : ℝ) (k : ℕ) : ℝ := P / R k

/-- The proposed score: resolution to the `α`, per-block signal to the `β`. -/
noncomputable def score (R : ℕ → ℝ) (P α β : ℝ) (k : ℕ) : ℝ :=
  (R k) ^ α * (perBlock R P k) ^ β

/-! ## The collapse -/

/-- The two terms are not independent. `n = P / R` collapses the product to a
single power of `R`. This is the whole content: the tradeoff is not a tradeoff. -/
theorem score_eq (hR : ∀ k, 0 < R k) (hP : 0 < P) (k : ℕ) :
    score R P α β k = P ^ β * (R k) ^ (α - β) := by
  unfold score perBlock
  rw [Real.div_rpow hP.le (hR k).le, Real.rpow_sub (hR k)]
  field_simp

/-! ## No interior peak -/

/-- If resolution outweighs per-block signal, the score strictly increases with
the generator count — more generators is always better, so no interior peak. -/
theorem strictMono_of_lt (hR : ∀ k, 0 < R k) (hRmono : StrictMono R) (hP : 0 < P)
    (hab : β < α) : StrictMono (score R P α β) := by
  intro i j hij
  rw [score_eq R P α β hR hP, score_eq R P α β hR hP]
  have hpos : (0:ℝ) < P ^ β := Real.rpow_pos_of_pos hP β
  refine mul_lt_mul_of_pos_left ?_ hpos
  exact Real.rpow_lt_rpow (hR i).le (hRmono hij) (by linarith)

/-- If per-block signal outweighs resolution, the score strictly decreases —
fewer generators is always better, so again no interior peak. -/
theorem strictAnti_of_lt (hR : ∀ k, 0 < R k) (hRmono : StrictMono R) (hP : 0 < P)
    (hab : α < β) : StrictAnti (score R P α β) := by
  intro i j hij
  rw [score_eq R P α β hR hP, score_eq R P α β hR hP]
  have hpos : (0:ℝ) < P ^ β := Real.rpow_pos_of_pos hP β
  refine mul_lt_mul_of_pos_left ?_ hpos
  exact Real.rpow_lt_rpow_of_neg (hR i) (hRmono hij) (by linarith)

/-- If the exponents match, the score does not depend on the generator count. -/
theorem const_of_eq (hR : ∀ k, 0 < R k) (hP : 0 < P) (hab : α = β) (i j : ℕ) :
    score R P α β i = score R P α β j := by
  rw [score_eq R P α β hR hP, score_eq R P α β hR hP, hab, sub_self,
      Real.rpow_zero, Real.rpow_zero]

/-! ## The falsifier

An interior peak means some `k` beats both its neighbours. The three theorems
above exhaust the cases: strictly increasing, strictly decreasing, or constant.
None admits a strict interior maximum.
-/

/-- **No power-law tradeoff of this form has an interior peak.** -/
theorem no_interior_peak (hR : ∀ k, 0 < R k) (hRmono : StrictMono R) (hP : 0 < P)
    (k : ℕ) (hk : 0 < k)
    (hpeak : score R P α β (k - 1) < score R P α β k ∧
             score R P α β (k + 1) < score R P α β k) : False := by
  obtain ⟨hlo, hhi⟩ := hpeak
  rcases lt_trichotomy α β with h | h | h
  · -- strictly decreasing: score k < score (k-1), contradicting hlo
    have := strictAnti_of_lt R P α β hR hRmono hP h (Nat.sub_lt hk one_pos)
    linarith
  · -- constant: score (k+1) = score k, contradicting hhi
    have := const_of_eq R P α β hR hP h (k + 1) k
    linarith
  · -- strictly increasing: score k < score (k+1), contradicting hhi
    have := strictMono_of_lt R P α β hR hRmono hP h (Nat.lt_succ_self k)
    linarith

/-! ## What the bench measured

`P_max/median` at xmax = 3e9, from `results/O24_gen_xmax3e9_run.log`. Recorded
here only to state the contradiction; used in no proof above.
-/

/-- G1..G8 at xmax = 3e9. -/
def measured : List ℝ :=
  [5.501266, 8.192902, 23.628706, 38.299307, 27.061132, 18.321235, 14.885732, 12.039652]

/-- The measurement is not monotone: G4 exceeds both G3 and G5. -/
theorem measured_has_interior_peak :
    (23.628706 : ℝ) < 38.299307 ∧ (27.061132 : ℝ) < 38.299307 := by
  refine ⟨by norm_num, by norm_num⟩

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'GeneratorPeak.score_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms GeneratorPeak.score_eq

/-- info: 'GeneratorPeak.strictMono_of_lt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms GeneratorPeak.strictMono_of_lt

/-- info: 'GeneratorPeak.strictAnti_of_lt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms GeneratorPeak.strictAnti_of_lt

/-- info: 'GeneratorPeak.const_of_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms GeneratorPeak.const_of_eq

/-- info: 'GeneratorPeak.no_interior_peak' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms GeneratorPeak.no_interior_peak

/-- info: 'GeneratorPeak.measured_has_interior_peak' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms GeneratorPeak.measured_has_interior_peak

end GeneratorPeak
