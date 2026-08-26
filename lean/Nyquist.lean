/-
Nyquist — why an entire family of integer-base approaches must fail,
rather than merely happening to.

`notes/lab_notebook.md` entry 26 records this as THEOREM-SHAPED and
leaves it unformalised: "A b-adic sampling of the residual in log x
cannot resolve frequency gamma unless log b < pi/gamma. For gamma_1
that is b < exp(pi/gamma_1) = 1.2489. Base 2 fails it by a factor of
three." The entry also states its own scope honestly — this follows
from Shannon, so it is an application rather than new mathematics —
and that is why it belongs in the kernel rather than in prose: the
content is not the inequality but the claim that failing it makes a
frequency UNIDENTIFIABLE, and that claim is a statement about the
existence of a second frequency, which is exactly the kind of thing a
proof assistant is for.

THE SETTING. A b-adic ladder samples at `x = b^r`, so in `log x` the
samples sit at `r * log b`, evenly spaced. A mode of frequency `gamma`
contributes `exp(i * gamma * log x)`. Two frequencies are
INDISTINGUISHABLE on that ladder when their modes agree at every rung
— no measurement on the ladder, of any kind, can separate them.

WHAT IS PROVED.

  aliases_of_offset      `gamma' = gamma - 2*pi*k / log b` aliases with
                         `gamma`, for every integer `k`
  nyquist_no_go          past the Nyquist frequency `pi / log b`, there
                         is ALWAYS a strictly-smaller-modulus frequency
                         that aliases — so `gamma` is not identifiable
  base_bound_of_resolvable  contrapositive, in the entry's own form:
                         resolving `gamma` forces `b <= exp(pi/gamma)`
  base_two_past_nyquist  base 2 exceeds its own Nyquist frequency at
                         every `gamma >= 14`
  base_two_fails_by_three  `3 * nyquist 2 < 14`, which is entry 26's
                         "fails by a factor of three", proved rather
                         than asserted

Entry 16 measured the same fact directly: the dyadic ladder sits at
the 100th percentile against surrogates while showing eight peaks of
identical height spaced `2*pi/log 2` — the signal present, the
frequency unidentifiable. That is this theorem, seen from the data
side.

Companion to notes entries 16, 26.
-/
import Mathlib

namespace Nyquist

open Real Complex

noncomputable section

/-- The rungs of a `b`-adic ladder, in `log x`: sampling at `x = b^r`
puts the samples at `r * log b`. -/
def sample (b : ℝ) (r : ℤ) : ℝ := (r : ℝ) * Real.log b

/-- **Indistinguishable frequencies.** `γ` and `γ'` alias on the
`b`-adic ladder when their modes agree at every rung. No measurement on
the ladder can separate them, because the ladder never evaluates
anything else. -/
def Aliases (b γ γ' : ℝ) : Prop :=
  ∀ r : ℤ, Complex.exp ((γ * sample b r : ℝ) * Complex.I)
         = Complex.exp ((γ' * sample b r : ℝ) * Complex.I)

/-- **The aliasing offset.** Shifting a frequency by `2πk / log b`
changes nothing the ladder can see. -/
theorem aliases_of_offset (b γ : ℝ) (k : ℤ) (hb : Real.log b ≠ 0) :
    Aliases b γ (γ - 2 * π * k / Real.log b) := by
  intro r
  have key : γ * sample b r
      = (γ - 2 * π * k / Real.log b) * sample b r + (r : ℝ) * (k : ℝ) * (2 * π) := by
    simp only [sample]
    field_simp
    ring
  rw [Complex.exp_eq_exp_iff_exists_int]
  refine ⟨r * k, ?_⟩
  rw [key]
  push_cast
  ring

/-- The **Nyquist frequency** of a `b`-adic ladder: the highest
frequency the rungs can carry without ambiguity. -/
def nyquist (b : ℝ) : ℝ := π / Real.log b

/-- **THE NO-GO.** Past the Nyquist frequency there is always a
frequency of strictly smaller modulus that the ladder cannot
distinguish from `γ`. So `γ` is not identifiable from `b`-adic samples
— not because the measurement is noisy, but because a different answer
fits the same data exactly. -/
theorem nyquist_no_go (b γ : ℝ) (hb : 1 < b) (hγ : nyquist b < γ) :
    ∃ γ', |γ'| < |γ| ∧ Aliases b γ γ' := by
  have hlog : 0 < Real.log b := Real.log_pos hb
  have h1 : π / Real.log b < γ := hγ
  have hpos : 0 < γ := lt_trans (div_pos Real.pi_pos hlog) h1
  have hdpos : 0 < 2 * π / Real.log b := by positivity
  have h2 : 2 * π / Real.log b < 2 * γ := by
    rw [div_lt_iff₀ hlog] at h1 ⊢
    linarith
  refine ⟨γ - 2 * π / Real.log b, ?_, ?_⟩
  · rw [abs_of_pos hpos, abs_lt]
    exact ⟨by linarith, by linarith⟩
  · have := aliases_of_offset b γ 1 (ne_of_gt hlog)
    simpa using this

/-- **Entry 26's inequality, as the contrapositive.** If no
smaller-modulus frequency aliases with `γ` — that is, if `γ` really is
identifiable from the ladder — then the base is bounded:
`b ≤ exp(π/γ)`. For `γ₁` this is the recorded `1.2489`. -/
theorem base_bound_of_resolvable (b γ : ℝ) (hb : 1 < b) (hγ : 0 < γ)
    (hres : ∀ γ', |γ'| < |γ| → ¬ Aliases b γ γ') :
    b ≤ Real.exp (π / γ) := by
  have hlog : 0 < Real.log b := Real.log_pos hb
  have hle : γ ≤ nyquist b := by
    by_contra h
    obtain ⟨γ', hlt, hal⟩ := nyquist_no_go b γ hb (not_le.mp h)
    exact hres γ' hlt hal
  have hle' : γ * Real.log b ≤ π := by
    have hh : γ ≤ π / Real.log b := hle
    rw [le_div_iff₀ hlog] at hh
    linarith
  have : Real.log b ≤ π / γ := by
    rw [le_div_iff₀ hγ]
    linarith
  calc b = Real.exp (Real.log b) := (Real.exp_log (lt_trans one_pos hb)).symm
    _ ≤ Real.exp (π / γ) := Real.exp_le_exp.mpr this

/-- **Base 2 is past its own Nyquist frequency at every `γ ≥ 14`**, and
`γ₁ = 14.134…` is such a `γ`. So by `nyquist_no_go`, no dyadic ladder
identifies it. -/
theorem base_two_past_nyquist (γ : ℝ) (hγ : 14 ≤ γ) : nyquist 2 < γ := by
  have hlog : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  have hlb : (0.6931471803:ℝ) < Real.log 2 := Real.log_two_gt_d9
  have hpi : π < 3.15 := by
    have := Real.pi_lt_d2; linarith
  rw [nyquist, div_lt_iff₀ hlog]
  have h14 : (14:ℝ) * 0.6931471803 ≤ γ * Real.log 2 := by nlinarith
  linarith

/-- **Entry 26's "fails by a factor of three", proved.** Three times
base 2's Nyquist frequency still does not reach 14, so `γ₁` sits past
it with a factor to spare. -/
theorem base_two_fails_by_three : 3 * nyquist 2 < 14 := by
  have hlog : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  have hlb : (0.6931471803:ℝ) < Real.log 2 := Real.log_two_gt_d9
  have hpi : π < 3.15 := by
    have := Real.pi_lt_d2; linarith
  rw [nyquist, ← mul_div_assoc, div_lt_iff₀ hlog]
  linarith

end

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'Nyquist.aliases_of_offset' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Nyquist.aliases_of_offset

/-- info: 'Nyquist.nyquist_no_go' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Nyquist.nyquist_no_go

/-- info: 'Nyquist.base_bound_of_resolvable' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Nyquist.base_bound_of_resolvable

/-- info: 'Nyquist.base_two_past_nyquist' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Nyquist.base_two_past_nyquist

/-- info: 'Nyquist.base_two_fails_by_three' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Nyquist.base_two_fails_by_three

end Nyquist
