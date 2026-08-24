/-
MainTerm — stage 2: the difference calculus that discharges hM's structure.

`Nonvanishing.lean` proved the arrow of O67's theorem with three named
hypotheses. This module attacks `hM` — the main-term floor
`Mlow ≤ |stencil of li|` — by formalising the calculus O67 verified
numerically: the MVT step, replaced by something better.

  THE REPLACEMENT. O67 (and the paper's § I2) bounds the smooth stencil by an
  iterated mean value theorem. The kernel-friendly form is monotonicity, one
  unit step at a time:

     deriv g ≥ m on [x−1, x]   ⟹   g(x) − g(x−1) ≥ m        (bdiffR_lb)

  proved by `sub_mul`-shifting `g` to `y ↦ g(y) − m·y` and citing Mathlib's
  `StrictMonoOn`/`MonotoneOn`-from-derivative. Induction then lifts it:

     iteratedDeriv n g ≥ m on [x−n, x]  ⟹  (Δⁿg)(x) ≥ m      (iter_bdiffR_lb)

  using that Δ commutes with d/dx (`deriv_bdiffR`, `iteratedDeriv_bdiffR`).

  PROVED HERE
    iter_bdiffR_eq_sum        the ℝ-domain twin of the ℤ result: n unit
                              differences are the alternating stencil
    stencilR_eq_iter          the bridge to `Nonvanishing.stencilR` at an
                              integer point
    deriv_bdiffR              Δ commutes with the derivative
    iteratedDeriv_bdiffR      … and with iterated derivatives
    bdiffR_lb                 the single monotonicity step
    iter_bdiffR_lb            the induction — MVT retired
    stencilR_ge_of            hM's shape, GIVEN a lower bound on the iterated
                              derivative of the interpolant
    tableFrom_ne_zero_of_deriv     `Nonvanishing.tableFrom_ne_zero_of` with hM
                              replaced by that derivative bound

  WHAT REMAINS AS HYPOTHESIS after this module
    hD : Mlow ≤ iteratedDeriv (d+1) L on the window — for L interpolating li
         this is the explicit expansion of the d-th derivative of `2^x/x`
         (an alternating series in 1/x) plus its pairing bound: O67's CHECK 1,
         stage 2b. Mathlib carries no logarithmic integral, so `li` itself
         enters only through an interpolant `L` and its derivative structure.
    hS : Schoenfeld — stage 3, unchanged.

  So after this module the analytic gap in the whole conditional theorem is
  exactly: (2b) one explicit derivative expansion with a pairing bound, and
  (3) Schoenfeld. The difference calculus is done.

Companion to papers/The-Four-Zeros.md § I and notes entry 114.
-/
import Mathlib
import Nonvanishing

namespace MainTerm

open Finset Set

/-- Unit backward differencing on real functions of a real variable. -/
noncomputable def bdiffR (g : ℝ → ℝ) : ℝ → ℝ := fun x => g x - g (x - 1)

/-- The ℝ-domain twin of `Nonvanishing.iter_bdiffZ_eq_fwdDiff`. -/
theorem iter_bdiffR_eq_fwdDiff (g : ℝ → ℝ) (x : ℝ) (n : ℕ) :
    (bdiffR^[n]) g x = (-1 : ℝ) ^ n * (fwdDiff (-1 : ℝ))^[n] g x := by
  induction n generalizing x with
  | zero => simp
  | succ m ih =>
      rw [Function.iterate_succ_apply' bdiffR m g]
      show (bdiffR^[m]) g x - (bdiffR^[m]) g (x - 1) = _
      rw [ih x, ih (x - 1), Function.iterate_succ_apply' (fwdDiff (-1 : ℝ)) m g]
      show _ = (-1 : ℝ) ^ (m + 1) *
        ((fwdDiff (-1 : ℝ))^[m] g (x + (-1)) - (fwdDiff (-1 : ℝ))^[m] g x)
      rw [show x + (-1 : ℝ) = x - 1 by ring, pow_succ]
      ring

/-- **`n` unit differences are the stencil**, on the real line. At an integer
point this meets `Nonvanishing.stencilR` (the bridge below). -/
theorem iter_bdiffR_eq_sum (g : ℝ → ℝ) (x : ℝ) (n : ℕ) :
    (bdiffR^[n]) g x
      = ∑ k ∈ range (n + 1), (-1 : ℝ) ^ k * (n.choose k) * g (x - k) := by
  rw [iter_bdiffR_eq_fwdDiff, fwdDiff_iter_eq_sum_shift, Finset.mul_sum]
  refine Finset.sum_congr rfl fun k hk => ?_
  have hkd : k ≤ n := Nat.lt_succ_iff.mp (Finset.mem_range.mp hk)
  have hsign : (-1 : ℝ) ^ n * (-1 : ℝ) ^ (n - k) = (-1 : ℝ) ^ k := by
    rw [← pow_add, show n + (n - k) = 2 * (n - k) + k by omega, pow_add, pow_mul]
    norm_num
  have hshift : x + k • (-1 : ℝ) = x - (k : ℝ) := by
    simp [sub_eq_add_neg]
  rw [hshift]
  simp only [zsmul_eq_mul]
  push_cast
  linear_combination ((n.choose k : ℝ)) * g (x - (k : ℝ)) * hsign

/-- **The bridge to `Nonvanishing.stencilR`.** At an integer point, the real
iterate reads the same values the ℤ-indexed stencil reads. -/
theorem stencilR_eq_iter (G : ℝ → ℝ) (r : ℤ) (n : ℕ) :
    Nonvanishing.stencilR n (fun k : ℤ => G k) r = (bdiffR^[n]) G r := by
  rw [iter_bdiffR_eq_sum, Nonvanishing.stencilR]
  refine Finset.sum_congr rfl fun k _ => ?_
  congr 1
  push_cast
  ring

/-- **Δ commutes with d/dx.** Needs differentiability of `g`; the shift is
`HasDerivAt.comp` with `x ↦ x − 1`. -/
theorem deriv_bdiffR {g : ℝ → ℝ} (hg : Differentiable ℝ g) :
    deriv (bdiffR g) = bdiffR (deriv g) := by
  funext x
  have h1 : HasDerivAt g (deriv g x) x := (hg x).hasDerivAt
  have h2 : HasDerivAt (fun y => g (y - 1)) (deriv g (x - 1)) x := by
    have := ((hg (x - 1)).hasDerivAt).comp x
      ((hasDerivAt_id x).sub_const 1)
    simpa using this
  have : HasDerivAt (bdiffR g) (deriv g x - deriv g (x - 1)) x := h1.sub h2
  exact this.deriv

/-- Δ preserves smoothness. -/
theorem contDiff_bdiffR {g : ℝ → ℝ} (hg : ContDiff ℝ (⊤ : ℕ∞) g) :
    ContDiff ℝ (⊤ : ℕ∞) (bdiffR g) := by
  exact hg.sub (hg.comp (contDiff_id.sub contDiff_const))

/-- **Δ commutes with iterated derivatives.** -/
theorem iteratedDeriv_bdiffR {g : ℝ → ℝ} (hg : ContDiff ℝ (⊤ : ℕ∞) g) (n : ℕ) :
    iteratedDeriv n (bdiffR g) = bdiffR (iteratedDeriv n g) := by
  induction n with
  | zero => simp [iteratedDeriv_zero]
  | succ m ih =>
      rw [iteratedDeriv_succ, ih, iteratedDeriv_succ]
      exact deriv_bdiffR (hg.differentiable_iteratedDeriv m
        (by exact_mod_cast WithTop.coe_lt_top _))

/-- **The single step: derivative floor ⟹ difference floor.** Shift by `m·y`
and cite monotonicity-from-derivative on `[x−1, x]`. -/
theorem bdiffR_lb {g : ℝ → ℝ} (hg : Differentiable ℝ g) {m x : ℝ}
    (hm : ∀ y ∈ Icc (x - 1) x, m ≤ deriv g y) :
    m ≤ bdiffR g x := by
  set h : ℝ → ℝ := fun y => g y - m * y with hh
  have hdiff : Differentiable ℝ h := hg.sub (differentiable_const m |>.mul differentiable_id)
  have hmono : MonotoneOn h (Icc (x - 1) x) := by
    apply monotoneOn_of_deriv_nonneg (convex_Icc _ _) hdiff.continuous.continuousOn
    · intro y hy
      exact hdiff.differentiableAt.differentiableWithinAt
    · intro y hy
      have hy' : y ∈ Icc (x - 1) x := interior_subset hy
      have hmy : HasDerivAt (fun y : ℝ => m * y) m y := by
        simpa using (hasDerivAt_id y).const_mul m
      have hde : deriv h y = deriv g y - m := by
        have : HasDerivAt h (deriv g y - m) y := ((hg y).hasDerivAt).sub hmy
        exact this.deriv
      rw [hde]
      linarith [hm y hy']
  have hle : h (x - 1) ≤ h x :=
    hmono (by constructor <;> linarith) (by constructor <;> linarith) (by linarith)
  simp only [hh] at hle
  unfold bdiffR
  nlinarith [hle]

/-- **The induction: MVT retired.** If the `n`-th derivative clears `m` on
`[x−n, x]`, the `n`-fold difference does. -/
theorem iter_bdiffR_lb {g : ℝ → ℝ} (hg : ContDiff ℝ (⊤ : ℕ∞) g) {m : ℝ} (n : ℕ)
    (x : ℝ) (hm : ∀ y ∈ Icc (x - n) x, m ≤ iteratedDeriv n g y) :
    m ≤ (bdiffR^[n]) g x := by
  induction n generalizing g x with
  | zero =>
      have := hm x (by constructor <;> simp)
      simpa using this
  | succ k ih =>
      rw [Function.iterate_succ_apply]
      apply ih (contDiff_bdiffR hg)
      intro y hy
      rw [iteratedDeriv_bdiffR hg]
      apply bdiffR_lb (hg.differentiable_iteratedDeriv k
        (by exact_mod_cast WithTop.coe_lt_top _))
      intro z hz
      rw [← iteratedDeriv_succ]
      apply hm
      obtain ⟨hy1, hy2⟩ := hy
      obtain ⟨hz1, hz2⟩ := hz
      constructor
      · push_cast at hy1 ⊢
        linarith
      · linarith

/-- **The floor, on the stencil.** If the `(d+1)`-th derivative of the
interpolant clears `c > 0` on the window, the stencil clears `c` — and hence
its absolute value does, which is `hM`'s shape. -/
theorem stencilR_ge_of {G : ℝ → ℝ} (hG : ContDiff ℝ (⊤ : ℕ∞) G) {c : ℝ}
    {r : ℤ} {d : ℕ}
    (hD : ∀ y ∈ Icc ((r : ℝ) - (d + 1)) r, c ≤ iteratedDeriv (d + 1) G y) :
    c ≤ |Nonvanishing.stencilR (d + 1) (fun k : ℤ => G k) r| := by
  have h := iter_bdiffR_lb hG (d + 1) r (by exact_mod_cast hD)
  rw [stencilR_eq_iter]
  exact h.trans (le_abs_self _)

/-- **The arrow, with hM discharged into a derivative bound.**
`Nonvanishing.tableFrom_ne_zero_of` again, but the main-term hypothesis is now
about the `(d+1)`-th derivative of a smooth interpolant of li — the difference
calculus between them is proved. What remains: the expansion of that derivative
(stage 2b) and Schoenfeld (stage 3). -/
theorem tableFrom_ne_zero_of_deriv {N : ℤ → ℤ} {f : ℤ → ℝ} {G : ℝ → ℝ} {r : ℤ} {d : ℕ}
    (hG : ContDiff ℝ (⊤ : ℕ∞) G)
    (hrow : ∀ k ∈ range (d + 2), ((N (r - k) : ℤ) : ℝ) = Nonvanishing.bdiffZ f (r - k))
    (hr : ((d + 1 : ℕ) : ℤ) ≤ r)
    (hS : Nonvanishing.StmtSchoenfeldWindow f (fun k : ℤ => G k) r (d + 1))
    (hD : ∀ y ∈ Icc ((r : ℝ) - (d + 1)) r,
          Nonvanishing.Mlow r d ≤ iteratedDeriv (d + 1) G y)
    (hgap : Nonvanishing.Ehigh r (d + 1) < Nonvanishing.Mlow r d) :
    Construction.tableFrom N r d ≠ 0 :=
  Nonvanishing.tableFrom_ne_zero_of hrow hr hS (stencilR_ge_of hG hD) hgap

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'MainTerm.iter_bdiffR_eq_fwdDiff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms MainTerm.iter_bdiffR_eq_fwdDiff

/-- info: 'MainTerm.iter_bdiffR_eq_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms MainTerm.iter_bdiffR_eq_sum

/-- info: 'MainTerm.stencilR_eq_iter' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms MainTerm.stencilR_eq_iter

/-- info: 'MainTerm.deriv_bdiffR' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms MainTerm.deriv_bdiffR

/-- info: 'MainTerm.contDiff_bdiffR' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms MainTerm.contDiff_bdiffR

/-- info: 'MainTerm.iteratedDeriv_bdiffR' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms MainTerm.iteratedDeriv_bdiffR

/-- info: 'MainTerm.bdiffR_lb' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms MainTerm.bdiffR_lb

/-- info: 'MainTerm.iter_bdiffR_lb' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms MainTerm.iter_bdiffR_lb

/-- info: 'MainTerm.stencilR_ge_of' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms MainTerm.stencilR_ge_of

/-- info: 'MainTerm.tableFrom_ne_zero_of_deriv' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms MainTerm.tableFrom_ne_zero_of_deriv

end MainTerm
