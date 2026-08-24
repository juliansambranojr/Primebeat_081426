/-
The chain's numbers, as a Lean object.

Third layer of `lean/`. Not a proof file — a RECORD file with checkable
numeric relations.

  EulerFactorChain.lean   the entry points, proved against Mathlib
  Chain.lean              the arrows, proved as implications
  Measured.lean           the numbers, each beside what the theorems predict

Three kinds of declaration:

  predicted_*   computed from the chain's theorems
  measured_*    a literal, docstring naming the results artifact it came from
  agreement_*   a theorem bounding |predicted - measured| at a stated tolerance

The `agreement_*` theorems are the part Lean checks. They do not establish that
a measurement is correct — only that the agreement claimed in the papers is
arithmetically true at the tolerance claimed.

Section `Unpaired` lists measurements with NO predicted counterpart. That
section is the specification for the next proof file.

PROVENANCE: every literal below was read out of `results/*.json` at the time of
writing, and its docstring names the file. Where a figure exists only in prose
(`CONTEXT.md`, `lab_notebook.md`) it is marked `PROSE-ONLY`.
-/
import Chain

namespace Measured

open Real

/-! ## Paired — theorem predicts, run measures -/

section TransformRadius

/-- Predicted radius of the smooth part's z-transform: `b^(-1)`. Chain G2. -/
noncomputable def predicted_radius_smooth (b : ℝ) : ℝ := b ⁻¹

/-- Predicted radius of the residual's z-transform: `b^(-1/2)`. Chain G2. -/
noncomputable def predicted_radius_resid (b : ℝ) : ℝ := b ^ (-(1:ℝ)/2)

/-- Measured mean |z| of the smooth control's roots at depth 0, b = 2.
`results/transform_radius.json` → `summary.truncation_offsets.smooth.measured_mean_abs`. -/
def measured_radius_smooth : ℝ := 0.5330466333805305

/-- Measured mean |z| of the residual's roots at depth 6, b = 2.
`results/transform_radius.json` → `summary.truncation_offsets.resid`. -/
def measured_radius_resid : ℝ := 0.7542802496369435

/-- Fractional offset of the smooth control above its theoretical radius.
`results/transform_radius.json` → `summary.truncation_offset_comparison.smooth_minus_theory_frac`. -/
def measured_offset_smooth : ℝ := 0.06609326676106098

/-- Fractional offset of the residual above its theoretical radius.
`results/transform_radius.json` → `summary.truncation_offset_comparison.resid_minus_theory_frac`. -/
def measured_offset_resid : ℝ := 0.06671335886672924

/-- **The one numeric relation that carries an inference.** The two offsets agree
to well under a tenth of a percentage point. That agreement is what identifies
them as a truncation artifact rather than a real difference between the two
circles — a signal would not produce the same offset in both.
`results/transform_radius.json` → `difference_of_offsets = 0.0006200921056682684`. -/
theorem agreement_offsets_match :
    |measured_offset_smooth - measured_offset_resid| < 0.001 := by
  unfold measured_offset_smooth measured_offset_resid
  rw [abs_lt]; constructor <;> norm_num

/-- The smooth control sits above `b^(-1) = 0.5` by the measured offset. -/
theorem agreement_radius_smooth :
    |measured_radius_smooth - 0.5 * (1 + measured_offset_smooth)| < 1e-9 := by
  unfold measured_radius_smooth measured_offset_smooth
  rw [abs_lt]; constructor <;> norm_num

end TransformRadius

section BSD

/-- Predicted: the exponent in `∏ #E(F_p)/p ~ C (log X)^r` is the rank.
Birch & Swinnerton-Dyer 1965. Ranks from LMFDB, quoted not computed. -/
def predicted_rank_11a1 : ℝ := 0
def predicted_rank_37a1 : ℝ := 1
def predicted_rank_389a1 : ℝ := 2

/-- Fitted exponent, curve 11a1. `results/bsd_rank_product.json` → `summary.11a1.fitted_r`. -/
def measured_rank_11a1 : ℝ := 0.0301198144374232
/-- Fitted exponent, curve 37a1. `results/bsd_rank_product.json` → `summary.37a1.fitted_r`. -/
def measured_rank_37a1 : ℝ := 1.2498415688932238
/-- Fitted exponent, curve 389a1. `results/bsd_rank_product.json` → `summary.389a1.fitted_r`. -/
def measured_rank_389a1 : ℝ := 1.9933396889613508

/-- Ranks 0 and 2 land inside 0.05. Rank 1 does NOT — it is 0.25 high, which is
the slow convergence of the product at `X ≤ 30000`, not a disagreement about
the rank. Encoded at the honest tolerance rather than a flattering one. -/
theorem agreement_rank_11a1 : |measured_rank_11a1 - predicted_rank_11a1| < 0.05 := by
  unfold measured_rank_11a1 predicted_rank_11a1
  rw [abs_lt]; constructor <;> norm_num

/-- Rank 2 lands inside 0.01 — the tightest of the three curves. -/
theorem agreement_rank_389a1 : |measured_rank_389a1 - predicted_rank_389a1| < 0.01 := by
  unfold measured_rank_389a1 predicted_rank_389a1
  rw [abs_lt]; constructor <;> norm_num

/-- Rank 1 needs a tolerance of 0.3. Recorded as such — the separation between
ranks is unambiguous, the third decimal is not. -/
theorem agreement_rank_37a1 : |measured_rank_37a1 - predicted_rank_37a1| < 0.3 := by
  unfold measured_rank_37a1 predicted_rank_37a1
  rw [abs_lt]; constructor <;> norm_num

end BSD

section EllipticSymbol

/-- Predicted: the roots of `1 - a_p x + p x²` lie on `Re(s) = 1/2`. Hasse 1933 —
the Riemann Hypothesis for curves over finite fields, a theorem. -/
noncomputable def predicted_elliptic_re : ℝ := 1/2

/-- Maximum |Re(s) - 1/2| over 43 curve-prime pairs, ranks 0, 1 and 2.
`results/elliptic_symbol_zeros.json` → `summary.max_abs_dev_from_half`. -/
def measured_elliptic_max_dev : ℝ := 2.220446049250313e-16

/-- Agreement at machine epsilon: the deviation is one ulp of a float64. -/
theorem agreement_elliptic : measured_elliptic_max_dev < 1e-15 := by
  unfold measured_elliptic_max_dev; norm_num

end EllipticSymbol

section WeilBalance

/-- Arithmetic side of Weil's explicit formula on the mollified stencil.
`results/O37_weil_form_balance_run1.log`. -/
def measured_weil_arithmetic : ℝ := 2644.2756560191

/-- Spectral side, 600 zero pairs plus a smoothed tail estimate. Same log. -/
def measured_weil_spectral : ℝ := 2644.2741566957

/-- The two sides agree to 5.7e-7 relative. NOTE: this is a normalisation check,
not a test — summing over known zeros presupposes they lie on the line. -/
theorem agreement_weil_balance :
    |measured_weil_arithmetic - measured_weil_spectral|
      < 1e-6 * measured_weil_arithmetic := by
  unfold measured_weil_arithmetic measured_weil_spectral
  rw [abs_lt]; constructor <;> norm_num

end WeilBalance

/-! ## Unpaired — measurements with no predicted counterpart

Each `def` below is a number the bench produced that NO theorem in the chain
predicts. These are the holes. Closing one means writing a theorem whose
conclusion is the measured value, and importing it here to make a pair.
-/

section Unpaired

/-- The four exact zeros of the dyadic prime difference table, `(r, d)`,
over `r ≤ 62, d ≤ 61`. `results/O16_run2.log`. **No theorem predicts these.** -/
def measured_exact_zeros : List (ℕ × ℕ) := [(2,1), (4,1), (8,3), (20,6)]

/-- Fraction of the row-20 residual reproduced from the zeta zeros alone, at
depths 0, 3, 6, with 200 zero pairs. PROSE-ONLY — `lab_notebook.md` entry 38;
`O34_zeta_residual_model.py` writes no results file.
**No theorem predicts these fractions.** -/
def measured_residual_from_zeros : List ℝ := [0.94, 0.92, 0.80]

/-- Depth at which the root structure breaks down: prime table, residual, and
the smooth control (which never does).
`results/transform_radius.json` → `summary.breakdown_depth`.
**No theorem predicts 13 or 10.** -/
def measured_breakdown_prime : ℕ := 13
def measured_breakdown_resid : ℕ := 10

/-- Generator-orbit peak: `P_max/median` at G4 = {2,3,5,7} across three xmax
settings. `results/O24_gen_*_run.log`.
**No theorem predicts that the peak sits at four primes.** -/
def measured_G4_peak : List ℝ := [26.733822, 31.371849, 38.299307]

/-- Primes contributing to the mollified Weil form, out of 36 in the window.
`results/O37_weil_form_on_stencil_run1.log`.
**No theorem predicts 25, and it depends on the mollifier parameters.** -/
def measured_contributing_primes : ℕ := 25

end Unpaired

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'Measured.agreement_offsets_match' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Measured.agreement_offsets_match

/-- info: 'Measured.agreement_radius_smooth' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Measured.agreement_radius_smooth

/-- info: 'Measured.agreement_rank_11a1' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Measured.agreement_rank_11a1

/-- info: 'Measured.agreement_rank_389a1' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Measured.agreement_rank_389a1

/-- info: 'Measured.agreement_rank_37a1' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Measured.agreement_rank_37a1

/-- info: 'Measured.agreement_elliptic' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Measured.agreement_elliptic

/-- info: 'Measured.agreement_weil_balance' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Measured.agreement_weil_balance

end Measured
