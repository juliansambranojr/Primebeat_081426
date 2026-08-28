/-
NyquistPeak — the difference filter's gain at frequency `γ` is stationary,
and maximal, exactly at the Nyquist boundary `b* = exp(π/γ)`.

`lean/NEXT.md` § 5.1. This is the load-bearing half of the mechanism
argument behind a LOCKED prereg's mechanical output.

WHY IT IS HERE. `preregs/dense_boundary_scan_v1_20260827.md` is LOCKED
and states, before the run and at its lines 42-46: "No mechanism predicts
a step, and the expected outcome is `no_step`. … The difference filter's
per-rung gain at γ₁ is `|1 − e^{iθ}|^d = (2 sin(θ/2))^d`, which is smooth
at `θ = π` and in fact **stationary** there — `b*` is a smooth maximum of
the γ₁ response, not a break in it." Notes entry 224 reads the run the
same way. Both are prose. This module makes the smooth-stationary-maximum
half kernel-checked.

WHAT IS PROVED.

  norm_sym_on_imaginary_axis   `‖Chain.Sym b (γ i)‖ = 2 |sin(γ log b / 2)|`
                               — the prereg's formula, DERIVED from the
                               tree's own symbol rather than restated
  gain_eq_norm_sym_pow         the depth-`d` gain is that, to the `d`
  gain_hasDerivAt_pi           the θ-derivative VANISHES at `θ = π`
  gain_le_gain_pi              and `π` is a global maximum
  gain_lt_gain_pi              a STRICT one, at every other phase
  gain_stationary_in_base      the same in the bench's coordinate: zero
                               slope in `b`, at `b = b*`
  boundary_is_smooth_stationary_maximum
                               the § 5.1 statement as one object, welded
                               to `Nyquist.nyquist`

WHICH LINE. `Chain`'s block D (`gain_sq_at_floor` … `ceiling_base`)
works on the CRITICAL line `s = 1/2 + γi`, where the gain carries the
`b^(−1/2)` envelope and the band is `1 ± b^(−1/2)`. The prereg's
`(2 sin(θ/2))^d` is the same symbol on the line `Re s = 0`: the residual
the bench differences has already been divided by `√x`, so its modes are
pure oscillations `x^(iγ)` and the envelope is gone. Same `Chain.Sym`,
same phase condition `θ ≡ π`, different line — which is why `b*` here and
`Chain.ceiling_base`'s `k = 0` base are the same number.

A NOTE ON WHAT `#guard_msgs` CANNOT SEE. `gain_hasDerivAt_pi` holds at
every depth including `d = 0`, where it says nothing at all: `gain 0` is
the constant `1`, so every phase is stationary and every phase is a
maximum. `depth_zero_vacuous` below is that fact, proved, in the shape
`Chain.period_vacuous_at_one` established. **`#guard_msgs` cannot catch
vacuity** — a vacuous theorem has a perfectly ordinary axiom list. The
depth hypothesis `d ≠ 0` on the strict statements is what closes it, and
`results/dense_boundary_scan.json` `params.d_min` is `1`, so the measured
regime is the guarded one.

Companion to notes entries 223, 224, 225.
-/
import Mathlib
import Chain
import Nyquist

namespace NyquistPeak

open Real Complex Filter Topology

noncomputable section

/-- **The gain of the depth-`d` difference filter, as a function of phase.**
`θ = γ · log b` is the phase one rung of a `b`-ladder advances a mode of
frequency `γ`. The definition is written in the prereg's own form; that it
is `Chain.Sym`'s modulus is proved, not assumed — see
`gain_eq_norm_sym_pow`. -/
def gain (d : ℕ) (θ : ℝ) : ℝ := (2 * |Real.sin (θ / 2)|) ^ d

/-! ### The bridge to `Chain.Sym`

`Chain.Sym b s = 1 − b^(−s)` is the symbol of one backward difference
(`Chain.StmtA1`). On the line `Re s = 0` it is `1 − e^(−iθ)`. -/

/-- The symbol on the imaginary axis is `1 − e^(−iθ)` with `θ = γ log b`. -/
theorem sym_on_imaginary_axis {b : ℝ} (hb : 0 < b) (γ : ℝ) :
    Chain.Sym b (γ * Complex.I)
      = 1 - Complex.exp (((-(γ * Real.log b) : ℝ) : ℂ) * Complex.I) := by
  have hb0 : (b : ℂ) ≠ 0 := by exact_mod_cast hb.ne'
  have hclog : Complex.log (b : ℂ) = (Real.log b : ℂ) := (Complex.ofReal_log hb.le).symm
  unfold Chain.Sym
  rw [Complex.cpow_def_of_ne_zero hb0, hclog]
  congr 1
  push_cast
  ring_nf

/-- **The prereg's formula, derived.** `‖Chain.Sym b (γ i)‖ = 2 |sin(θ/2)|`
with `θ = γ log b`. `preregs/dense_boundary_scan_v1_20260827.md` line 44
writes it `|1 − e^{iθ}|`; this is that modulus, computed from the tree's
own symbol rather than restated as a definition. -/
theorem norm_sym_on_imaginary_axis {b : ℝ} (hb : 0 < b) (γ : ℝ) :
    ‖Chain.Sym b (γ * Complex.I)‖ = 2 * |Real.sin (γ * Real.log b / 2)| := by
  set t : ℝ := γ * Real.log b / 2 with ht
  have h2 : γ * Real.log b = 2 * t := by rw [ht]; ring
  have hkey : Chain.Sym b (γ * Complex.I)
      = ((1 - Real.cos (2 * t) : ℝ) : ℂ) + ((Real.sin (2 * t) : ℝ) : ℂ) * Complex.I := by
    rw [sym_on_imaginary_axis hb γ, h2, Complex.exp_mul_I, ← Complex.ofReal_cos,
      ← Complex.ofReal_sin, Real.cos_neg, Real.sin_neg]
    push_cast
    ring
  have hcos : Real.cos (2 * t) = 1 - 2 * Real.sin t ^ 2 := by
    rw [Real.cos_two_mul]
    nlinarith [Real.sin_sq_add_cos_sq t]
  have hsq : ‖Chain.Sym b (γ * Complex.I)‖ ^ 2 = (2 * |Real.sin t|) ^ 2 := by
    have habs : |Real.sin t| ^ 2 = Real.sin t ^ 2 := sq_abs _
    rw [hkey, Complex.sq_norm, Complex.normSq_add_mul_I, hcos, Real.sin_two_mul]
    linear_combination (4 * Real.sin t ^ 2) * Real.sin_sq_add_cos_sq t - 4 * habs
  have h1 := congrArg Real.sqrt hsq
  rwa [Real.sqrt_sq (norm_nonneg _), Real.sqrt_sq (by positivity)] at h1

/-- **The depth-`d` gain is the symbol's modulus to the `d`.** This is the
link that makes everything below a statement about the object the tree
already has. -/
theorem gain_eq_norm_sym_pow {b : ℝ} (hb : 0 < b) (γ : ℝ) (d : ℕ) :
    gain d (γ * Real.log b) = ‖Chain.Sym b (γ * Complex.I)‖ ^ d := by
  rw [gain, norm_sym_on_imaginary_axis hb γ]

/-! ### The stationary maximum, in phase -/

/-- The gain at phase `π` is `2^d` — the ceiling of the band. -/
theorem gain_pi (d : ℕ) : gain d Real.pi = 2 ^ d := by
  simp [gain, Real.sin_pi_div_two]

/-- The gain at phase `0` is `0` at every positive depth: the smooth term,
having `γ = 0`, is annihilated outright. `Chain.C2_floor_attained` is the
critical-line counterpart. This is also the witness that `π` is a strict
maximum rather than a plateau. -/
theorem gain_zero_phase {d : ℕ} (hd : d ≠ 0) : gain d 0 = 0 := by
  simp [gain, zero_pow hd]

/-- **HALF ONE — the derivative vanishes at `θ = π`.** `2|sin(θ/2)|` is
smooth on a neighbourhood of `π` (the absolute value is inert there, since
`sin` is non-negative on `(0, π)`), and its derivative carries a factor
`cos(π/2) = 0`. -/
theorem gain_hasDerivAt_pi (d : ℕ) : HasDerivAt (gain d) 0 Real.pi := by
  have hhalf : HasDerivAt (fun θ : ℝ => θ / 2) (1 / 2 : ℝ) Real.pi :=
    (hasDerivAt_id Real.pi).div_const 2
  have hsin : HasDerivAt (fun θ : ℝ => Real.sin (θ / 2))
      (Real.cos (Real.pi / 2) * (1 / 2)) Real.pi := hhalf.sin
  have hsin0 : HasDerivAt (fun θ : ℝ => Real.sin (θ / 2)) 0 Real.pi := by
    simpa [Real.cos_pi_div_two] using hsin
  have hmul : HasDerivAt (fun θ : ℝ => 2 * Real.sin (θ / 2)) 0 Real.pi := by
    simpa using hsin0.const_mul (2 : ℝ)
  have hpow : HasDerivAt (fun θ : ℝ => (2 * Real.sin (θ / 2)) ^ d) 0 Real.pi := by
    simpa using hmul.pow d
  have heq : gain d =ᶠ[nhds Real.pi] fun θ : ℝ => (2 * Real.sin (θ / 2)) ^ d := by
    filter_upwards [Ioo_mem_nhds Real.pi_pos (by linarith [Real.pi_pos] : Real.pi < 2 * Real.pi)]
      with θ hθ
    have hnn : 0 ≤ Real.sin (θ / 2) :=
      Real.sin_nonneg_of_nonneg_of_le_pi (by linarith [hθ.1]) (by linarith [hθ.2])
    simp [gain, abs_of_nonneg hnn]
  exact hpow.congr_of_eventuallyEq heq

/-- The same, in `deriv` form. -/
theorem deriv_gain_pi (d : ℕ) : deriv (gain d) Real.pi = 0 :=
  (gain_hasDerivAt_pi d).deriv

/-- **HALF TWO — `π` is a maximum.** Global, not merely local: no phase
anywhere reaches a larger gain. -/
theorem gain_le_gain_pi (d : ℕ) (θ : ℝ) : gain d θ ≤ gain d Real.pi := by
  rw [gain_pi]
  have h : 2 * |Real.sin (θ / 2)| ≤ 2 := by
    have := Real.abs_sin_le_one (θ / 2); linarith
  exact pow_le_pow_left₀ (by positivity) h d

/-- **The maximum is STRICT.** At every phase off the peak the gain is
strictly smaller, so the stationary point of `gain_hasDerivAt_pi` cannot
be a minimum or an inflection. `d ≠ 0` is load-bearing and not a vacuity
guard: at `d = 0` the statement is false, since `gain 0` is constant. -/
theorem gain_lt_gain_pi {d : ℕ} (hd : d ≠ 0) {θ : ℝ}
    (hθ : |Real.sin (θ / 2)| ≠ 1) : gain d θ < gain d Real.pi := by
  rw [gain_pi]
  have h1 : |Real.sin (θ / 2)| < 1 := lt_of_le_of_ne (Real.abs_sin_le_one _) hθ
  have h : 2 * |Real.sin (θ / 2)| < 2 := by linarith
  exact pow_lt_pow_left₀ h (by positivity) hd

/-- The degeneracy the depth hypothesis closes. At `d = 0` the gain is the
constant `1`, so `gain_hasDerivAt_pi` — which is true at every depth — says
nothing there: every phase is stationary and every phase is a maximum.
**`#guard_msgs` cannot catch that**; a vacuous theorem has an ordinary
axiom list. Same shape as `Chain.period_vacuous_at_one`. -/
theorem depth_zero_vacuous (θ : ℝ) : gain 0 θ = 1 := by simp [gain]

/-- **§ 5.1 in phase coordinates, as one object.** Stationary at `π`, and a
strict global maximum there. -/
theorem stationary_maximum {d : ℕ} (hd : d ≠ 0) :
    HasDerivAt (gain d) 0 Real.pi
      ∧ (∀ θ : ℝ, gain d θ ≤ gain d Real.pi)
      ∧ (∀ θ : ℝ, |Real.sin (θ / 2)| ≠ 1 → gain d θ < gain d Real.pi) :=
  ⟨gain_hasDerivAt_pi d, gain_le_gain_pi d, fun _ h => gain_lt_gain_pi hd h⟩

/-! ### The bench's coordinate: the base `b* = exp(π/γ)`

`preregs/dense_boundary_scan_v1_20260827.md` line 61 locks
`b* = exp(π/γ₁) = 1.248896812346038861164`, and
`results/dense_boundary_scan.json` `params.b_star` carries the same
literal. Nothing below depends on either number: `b*` is a function of
`γ`, and the theorems are stated at every `γ > 0`. -/

/-- **The Nyquist boundary base at frequency `γ`.** `Nyquist.nyquist` maps
it back to `γ`; see `nyquist_boundaryBase`. -/
def boundaryBase (γ : ℝ) : ℝ := Real.exp (Real.pi / γ)

/-- The boundary base is positive. -/
theorem boundaryBase_pos (γ : ℝ) : 0 < boundaryBase γ := Real.exp_pos _

/-- At a positive frequency the boundary base exceeds `1`, so it lies in
the range `Nyquist.base_bound_of_resolvable` speaks about. -/
theorem one_lt_boundaryBase {γ : ℝ} (hγ : 0 < γ) : 1 < boundaryBase γ := by
  have h : Real.exp 0 < Real.exp (Real.pi / γ) :=
    Real.exp_lt_exp.mpr (div_pos Real.pi_pos hγ)
  simpa [boundaryBase] using h

/-- **The boundary base puts the phase exactly at `π`.** `γ ≠ 0` is
load-bearing and its failure makes the statement false, not vacuous: at
`γ = 0` Lean's `π/0` is `0`, so `boundaryBase 0 = 1` and the phase is `0`,
where `gain_zero_phase` says the gain vanishes. -/
theorem phase_at_boundaryBase {γ : ℝ} (hγ : γ ≠ 0) :
    γ * Real.log (boundaryBase γ) = Real.pi := by
  rw [boundaryBase, Real.log_exp, mul_div_cancel₀ _ hγ]

/-- **`b*` is exactly the base whose Nyquist frequency is `γ`.** This is
the weld to `lean/Nyquist.lean`: `Nyquist.base_bound_of_resolvable` caps a
base that resolves `γ` at `exp(π/γ)`, and that cap is this base. -/
theorem nyquist_boundaryBase {γ : ℝ} (hγ : 0 < γ) :
    Nyquist.nyquist (boundaryBase γ) = γ := by
  have hpi : Real.pi ≠ 0 := Real.pi_ne_zero
  rw [Nyquist.nyquist, boundaryBase, Real.log_exp]
  field_simp

/-- The gain at `b*` is the ceiling `2^d`, and it is the symbol's own
modulus that reaches it. -/
theorem norm_sym_pow_at_boundaryBase (d : ℕ) {γ : ℝ} (hγ : γ ≠ 0) :
    ‖Chain.Sym (boundaryBase γ) (γ * Complex.I)‖ ^ d = 2 ^ d := by
  rw [← gain_eq_norm_sym_pow (boundaryBase_pos γ), phase_at_boundaryBase hγ, gain_pi]

/-- **HALF ONE, in the scanned coordinate.** Sweeping the base through
`b*` at fixed frequency `γ`, the `γ` gain has slope exactly zero. This is
the statement the dense boundary scan's `no_step` was predicted from: the
ingredient does not step at `b*` because it does not even tilt there. -/
theorem gain_stationary_in_base (d : ℕ) {γ : ℝ} (hγ : γ ≠ 0) :
    HasDerivAt (fun b : ℝ => gain d (γ * Real.log b)) 0 (boundaryBase γ) := by
  have hb : boundaryBase γ ≠ 0 := ne_of_gt (boundaryBase_pos γ)
  have hinner : HasDerivAt (fun b : ℝ => γ * Real.log b)
      (γ * (boundaryBase γ)⁻¹) (boundaryBase γ) := (Real.hasDerivAt_log hb).const_mul γ
  have houter : HasDerivAt (gain d) 0 (γ * Real.log (boundaryBase γ)) := by
    rw [phase_at_boundaryBase hγ]; exact gain_hasDerivAt_pi d
  simpa [Function.comp] using houter.comp (boundaryBase γ) hinner

/-- **Not a discontinuity.** Differentiability at `b*` gives continuity
there, which is the negative half of the prereg's claim. -/
theorem gain_continuousAt_boundaryBase (d : ℕ) {γ : ℝ} (hγ : γ ≠ 0) :
    ContinuousAt (fun b : ℝ => gain d (γ * Real.log b)) (boundaryBase γ) :=
  (gain_stationary_in_base d hγ).continuousAt

/-- **HALF TWO, in the scanned coordinate.** No base anywhere gives a
larger `γ` gain than `b*` does. -/
theorem gain_le_at_boundaryBase (d : ℕ) {γ : ℝ} (hγ : γ ≠ 0) (b : ℝ) :
    gain d (γ * Real.log b) ≤ gain d (γ * Real.log (boundaryBase γ)) := by
  rw [phase_at_boundaryBase hγ]
  exact gain_le_gain_pi d _

/-- **§ 5.1, as the prereg states it.** For a positive frequency `γ` and a
positive depth `d`: `b* = exp(π/γ)` is the base whose Nyquist frequency is
`γ`; the `γ` gain is differentiable there with derivative zero; and it is
a global maximum over all bases. So `b*` is a smooth stationary maximum of
the `γ` response, and nothing in the gain steps across it.

The maximum is stated twice, weakly over every base and strictly off the
peak, so `d ≠ 0` is load-bearing rather than decorative: at depth `0` the
fourth conjunct is false, since `depth_zero_vacuous` makes the gain
constant. `results/dense_boundary_scan.json` `params.d_min` is `1`, so
the measured regime is the guarded one. -/
theorem boundary_is_smooth_stationary_maximum {γ : ℝ} (hγ : 0 < γ) {d : ℕ} (hd : d ≠ 0) :
    Nyquist.nyquist (boundaryBase γ) = γ
      ∧ HasDerivAt (fun b : ℝ => gain d (γ * Real.log b)) 0 (boundaryBase γ)
      ∧ (∀ b : ℝ, gain d (γ * Real.log b) ≤ gain d (γ * Real.log (boundaryBase γ)))
      ∧ (∀ b : ℝ, |Real.sin (γ * Real.log b / 2)| ≠ 1 →
          gain d (γ * Real.log b) < gain d (γ * Real.log (boundaryBase γ)))
      ∧ gain d (γ * Real.log (boundaryBase γ)) = 2 ^ d := by
  refine ⟨nyquist_boundaryBase hγ, gain_stationary_in_base d (ne_of_gt hγ),
    fun b => gain_le_at_boundaryBase d (ne_of_gt hγ) b, ?_, ?_⟩
  · rw [phase_at_boundaryBase (ne_of_gt hγ)]
    exact fun b hb => gain_lt_gain_pi hd hb
  · rw [phase_at_boundaryBase (ne_of_gt hγ), gain_pi]

end

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.

Every theorem here mentions ℝ or ℂ, so `Classical.choice` is the floor —
`lean/BUILD.md` § What can never move. It is the house baseline for this
part of the tree, not a cost, and notes entry 225 says so.
-/

/-- info: 'NyquistPeak.sym_on_imaginary_axis' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms NyquistPeak.sym_on_imaginary_axis

/-- info: 'NyquistPeak.norm_sym_on_imaginary_axis' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms NyquistPeak.norm_sym_on_imaginary_axis

/-- info: 'NyquistPeak.gain_eq_norm_sym_pow' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms NyquistPeak.gain_eq_norm_sym_pow

/-- info: 'NyquistPeak.gain_pi' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms NyquistPeak.gain_pi

/-- info: 'NyquistPeak.gain_zero_phase' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms NyquistPeak.gain_zero_phase

/-- info: 'NyquistPeak.gain_hasDerivAt_pi' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms NyquistPeak.gain_hasDerivAt_pi

/-- info: 'NyquistPeak.deriv_gain_pi' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms NyquistPeak.deriv_gain_pi

/-- info: 'NyquistPeak.gain_le_gain_pi' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms NyquistPeak.gain_le_gain_pi

/-- info: 'NyquistPeak.gain_lt_gain_pi' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms NyquistPeak.gain_lt_gain_pi

/-- info: 'NyquistPeak.depth_zero_vacuous' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms NyquistPeak.depth_zero_vacuous

/-- info: 'NyquistPeak.stationary_maximum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms NyquistPeak.stationary_maximum

/-- info: 'NyquistPeak.boundaryBase_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms NyquistPeak.boundaryBase_pos

/-- info: 'NyquistPeak.one_lt_boundaryBase' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms NyquistPeak.one_lt_boundaryBase

/-- info: 'NyquistPeak.phase_at_boundaryBase' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms NyquistPeak.phase_at_boundaryBase

/-- info: 'NyquistPeak.nyquist_boundaryBase' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms NyquistPeak.nyquist_boundaryBase

/-- info: 'NyquistPeak.norm_sym_pow_at_boundaryBase' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms NyquistPeak.norm_sym_pow_at_boundaryBase

/-- info: 'NyquistPeak.gain_stationary_in_base' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms NyquistPeak.gain_stationary_in_base

/-- info: 'NyquistPeak.gain_continuousAt_boundaryBase' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms NyquistPeak.gain_continuousAt_boundaryBase

/-- info: 'NyquistPeak.gain_le_at_boundaryBase' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms NyquistPeak.gain_le_at_boundaryBase

/-- info: 'NyquistPeak.boundary_is_smooth_stationary_maximum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms NyquistPeak.boundary_is_smooth_stationary_maximum

end NyquistPeak
