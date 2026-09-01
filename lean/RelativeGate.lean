/-
RelativeGate — the census gate, stated without assuming an error shape.

WHY THIS FILE EXISTS. `Nonvanishing.lean` states the census gate in the
RH shape: `StmtSchoenfeldWindow` carries `√x·log x/(8π)` per value, and
`Ehigh` accumulates it into `2^(r/2)·(1+2^(−1/2))^n`. Every downstream
tolerance study (O68, entry 118) then swept the family
`C·√x·(log x)^k` — every row RH-strength. Whether the gate NEEDS that
shape was never asked, and the answer was assumed rather than derived.

It does not. Carry a bare relative-error hypothesis instead —
`|f(m) − L(m)| ≤ ρ · 2^m` on the window, no functional form at all —
and the accumulated ceiling is `ρ·2^r·(3/2)^n`. Against
`Mlow r d = 0.5·2^(r−d−1)·(log 2)^d/r` the factor `2^r` CANCELS, and
`relGate_iff` proves what is left:

    ρ·2^r·(3/2)^(d+1) < Mlow r d   ↔   ρ < (log 2)^d / (2·r·3^(d+1))

so the census's whole requirement is a bound on RELATIVE error against
`1/r`. Writing `log x = r·log 2` this is `ρ < ε_d/log x` with
`ε_d = 0.5·(log 2/3)^(d+1)` — the constant shrinking by a factor
`3/log 2 ≈ 4.33` per unit of depth, which is the true price of depth.

WHAT FOLLOWS, AND WHAT DOES NOT. Since PNT alone gives relative error
`o(1/log x)`, the arrow holds at every depth for SOME crossover rung —
the census never needed RH as a matter of logic. What it needs is the
crossover to land at or below `r = 92`, where O43's computed `π(2^n)`
stops (`preregs/extended_zero_census_v1_locked_20260818.md` line 116
fixes `R_ext = 92`: "chosen because it is where published data stops").
The theorem is a pincer and only the arrow arm can move. So RH's role
here is quantitative, not structural: it is the only bound anyone has
that is strong enough to land under that wall.

`schoenfeldWindow_relErr` welds the new layer to the old one — the RH
window hypothesis is an instance, with `ρ = log 2·r/(8π)·2^(−(r−n)/2)`.
The witness is the WINDOW BOTTOM, not the top: relative error `2^(−m/2)`
grows as `m` falls, so the worst rung of the window is its lowest.
`powerSaving_relErr` gives the other instance: a power bound
`|f − L| ≤ A·x^θ` yields `ρ = A·2^((r−n)(θ−1))`, the form in which the
depth threshold is a statement about `θ` alone.

Companion to notes entries 118, 130, 277.
-/
import Mathlib
import Nonvanishing

namespace RelativeGate

open Finset Nonvanishing

noncomputable section

/-! ## The shape-free hypothesis and ceiling -/

/-- **Relative error on the window.** Each of the `n+1` values the
stencil reads sits within `ρ` times its own scale `2^m`. No functional
form is assumed — this is the weakest hypothesis the gate can consume. -/
def StmtRelErrWindow (f L : ℤ → ℝ) (r : ℤ) (n : ℕ) (ρ : ℝ) : Prop :=
  ∀ k ∈ range (n + 1),
    |f (r - k) - L (r - k)| ≤ ρ * (2 : ℝ) ^ ((r : ℝ) - k)

/-- The accumulated ceiling under a relative-error hypothesis:
`ρ·2^r·(3/2)^n`. The per-value scale halves down the window, so the
binomial sum contributes `Σ C(n,k) 2^(−k) = (3/2)^n` — the exact
analogue of `Ehigh`'s `(1+2^(−1/2))^n`, with `2^(−1/2)` replaced by
`2^(−1)`. -/
def EhighRel (r : ℤ) (n : ℕ) (ρ : ℝ) : ℝ :=
  ρ * (2 : ℝ) ^ (r : ℝ) * (3 / 2) ^ n

/-- Each windowed relative bound is the top-of-window scale times
`2^(−k)`. -/
theorem relWindow_term_le {r : ℤ} {ρ : ℝ} (k : ℕ) :
    ρ * (2 : ℝ) ^ ((r : ℝ) - k)
      = ρ * (2 : ℝ) ^ (r : ℝ) * ((2 : ℝ) ^ (-(1 : ℝ))) ^ k := by
  have h2 : (0 : ℝ) < 2 := by norm_num
  have hstep : (2 : ℝ) ^ ((r : ℝ) - k)
      = (2 : ℝ) ^ (r : ℝ) * ((2 : ℝ) ^ (-(1 : ℝ))) ^ k := by
    rw [← Real.rpow_natCast ((2 : ℝ) ^ (-(1 : ℝ))) k, ← Real.rpow_mul h2.le,
      ← Real.rpow_add h2]
    congr 1
    ring
  rw [hstep, mul_assoc]

/-- **The error bound, shape-free.** Triangle inequality, the per-term
scale, and the binomial theorem at `t = 1/2`. -/
theorem relError_bound {f L : ℤ → ℝ} {r : ℤ} {n : ℕ} {ρ : ℝ}
    (hS : StmtRelErrWindow f L r n ρ) :
    |stencilR n (fun x => f x - L x) r| ≤ EhighRel r n ρ := by
  unfold stencilR EhighRel
  calc |∑ k ∈ range (n + 1), (-1 : ℝ) ^ k * (n.choose k) * (f (r - k) - L (r - k))|
      ≤ ∑ k ∈ range (n + 1), |(-1 : ℝ) ^ k * (n.choose k) * (f (r - k) - L (r - k))| :=
        Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ k ∈ range (n + 1), (n.choose k : ℝ)
          * (ρ * (2 : ℝ) ^ (r : ℝ) * ((2 : ℝ) ^ (-(1 : ℝ))) ^ k) := by
        refine Finset.sum_le_sum fun k hk => ?_
        rw [abs_mul, abs_mul, abs_pow, abs_neg, abs_one, one_pow, one_mul,
            Nat.abs_cast]
        refine mul_le_mul_of_nonneg_left ?_ (Nat.cast_nonneg _)
        rw [← relWindow_term_le k]
        exact hS k hk
    _ = ρ * (2 : ℝ) ^ (r : ℝ)
          * ∑ k ∈ range (n + 1), (n.choose k : ℝ) * ((2 : ℝ) ^ (-(1 : ℝ))) ^ k := by
        rw [Finset.mul_sum]
        exact Finset.sum_congr rfl fun k _ => by ring
    _ = ρ * (2 : ℝ) ^ (r : ℝ) * (3 / 2) ^ n := by
        congr 1
        have hhalf : (2 : ℝ) ^ (-(1 : ℝ)) = 1 / 2 := by
          rw [Real.rpow_neg_one]
          norm_num
        rw [hhalf, show (3 : ℝ) / 2 = 1 / 2 + 1 by norm_num, add_pow]
        exact Finset.sum_congr rfl fun k hk => by rw [one_pow, mul_one, mul_comm]

/-! ## The reduction: the `2^r` cancels -/

/-- **THE GATE, REDUCED.** The census condition against a relative-error
ceiling is a bound on `ρ` alone — the scale `2^r` appears on both sides
and cancels. What survives is

    ρ < (log 2)^d / (2 · r · 3^(d+1))

i.e., writing `log x = r·log 2`, `ρ < ε_d/log x` with
`ε_d = 0.5·(log 2 / 3)^(d+1)`. -/
theorem relGate_iff {r : ℤ} {d : ℕ} {ρ : ℝ} (hr : (0 : ℝ) < r) :
    EhighRel r (d + 1) ρ < Mlow r d
      ↔ ρ < Real.log 2 ^ d / (2 * r * 3 ^ (d + 1)) := by
  have h2 : (0 : ℝ) < 2 := by norm_num
  have hpow : (0 : ℝ) < (2 : ℝ) ^ (r : ℝ) := Real.rpow_pos_of_pos h2 _
  have hthree : (0 : ℝ) < (3 / 2 : ℝ) ^ (d + 1) := by positivity
  have hK : (0 : ℝ) < (2 : ℝ) ^ (r : ℝ) * (3 / 2 : ℝ) ^ (d + 1) := mul_pos hpow hthree
  -- express the RH-shaped floor over the same factor `2^r`
  have hsplit : (2 : ℝ) ^ ((r : ℝ) - d - 1)
      = (2 : ℝ) ^ (r : ℝ) / (2 : ℝ) ^ (d + 1) := by
    have hcast : (2 : ℝ) ^ (d + 1) = (2 : ℝ) ^ (((d : ℝ) + 1)) := by
      rw [← Real.rpow_natCast (2 : ℝ) (d + 1)]
      congr 1
      push_cast
      ring
    rw [hcast, ← Real.rpow_sub h2]
    congr 1
    ring
  have h2d : ((2 : ℝ) ^ (d + 1)) ≠ 0 := by positivity
  have h3d : ((3 : ℝ) ^ (d + 1)) ≠ 0 := by positivity
  have hM : Mlow r d
      = (2 : ℝ) ^ (r : ℝ) * (3 / 2 : ℝ) ^ (d + 1)
        * (Real.log 2 ^ d / (2 * r * 3 ^ (d + 1))) := by
    unfold Mlow
    rw [hsplit, div_pow]
    field_simp
  rw [EhighRel, hM]
  constructor
  · intro h
    by_contra hcon
    push_neg at hcon
    have : ((2 : ℝ) ^ (r : ℝ) * (3 / 2 : ℝ) ^ (d + 1))
          * (Real.log 2 ^ d / (2 * r * 3 ^ (d + 1)))
        ≤ ((2 : ℝ) ^ (r : ℝ) * (3 / 2 : ℝ) ^ (d + 1)) * ρ :=
      mul_le_mul_of_nonneg_left hcon hK.le
    linarith [h, this]
  · intro h
    have hmul : ((2 : ℝ) ^ (r : ℝ) * (3 / 2 : ℝ) ^ (d + 1)) * ρ
        < ((2 : ℝ) ^ (r : ℝ) * (3 / 2 : ℝ) ^ (d + 1))
          * (Real.log 2 ^ d / (2 * r * 3 ^ (d + 1))) :=
      mul_lt_mul_of_pos_left h hK
    linarith [hmul]

/-- The threshold as a single constant divided by `log x`: with
`log x = r·log 2`, the gate reads `ρ < ε_d / log x` where
`ε_d = 0.5·(log 2/3)^(d+1)`. The constant falls by `3/log 2 ≈ 4.33`
per unit of depth. -/
theorem relGate_eps {r : ℤ} {d : ℕ} (hr : (0 : ℝ) < r) :
    Real.log 2 ^ d / (2 * r * 3 ^ (d + 1))
      = ((1 / 2) * (Real.log 2 / 3) ^ (d + 1)) / ((r : ℝ) * Real.log 2) := by
  have hlog : Real.log 2 ≠ 0 := (Real.log_pos (by norm_num)).ne'
  have hrne : (r : ℝ) ≠ 0 := hr.ne'
  rw [div_pow]
  field_simp
  ring

/-! ## The arrow, shape-free -/

/-- **The arrow, with no assumption on the error's shape.** -/
theorem nonvanishing_of_relErr {f L : ℤ → ℝ} {r : ℤ} {d : ℕ} {ρ : ℝ}
    (hS : StmtRelErrWindow f L r (d + 1) ρ)
    (hM : Mlow r d ≤ |stencilR (d + 1) L r|)
    (hgap : EhighRel r (d + 1) ρ < Mlow r d) :
    stencilR (d + 1) f r ≠ 0 := by
  intro hzero
  have herr := relError_bound hS
  rw [stencilR_sub, hzero, zero_sub, abs_neg] at herr
  linarith

/-- **Onto the integer table**, shape-free. Mirrors
`Nonvanishing.tableFrom_ne_zero_of` with the relative-error hypothesis
in place of the Schoenfeld one. -/
theorem tableFrom_ne_zero_of_relErr {N : ℤ → ℤ} {f L : ℤ → ℝ} {r : ℤ} {d : ℕ}
    {ρ : ℝ}
    (hrow : ∀ k ∈ range (d + 2), ((N (r - k) : ℤ) : ℝ) = bdiffZ f (r - k))
    (hS : StmtRelErrWindow f L r (d + 1) ρ)
    (hM : Mlow r d ≤ |stencilR (d + 1) L r|)
    (hgap : EhighRel r (d + 1) ρ < Mlow r d) :
    Construction.tableFrom N r d ≠ 0 := by
  intro hzero
  apply nonvanishing_of_relErr hS hM hgap
  rw [← stencilR_row]
  have hcast : ((Construction.tableFrom N r d : ℤ) : ℝ)
      = stencilR d (fun x => ((N x : ℤ) : ℝ)) r := by
    rw [Zeros.tableFrom_eq_stencil, Zeros.stencil, stencilR]
    push_cast
    rfl
  have hwin : stencilR d (fun x => ((N x : ℤ) : ℝ)) r = stencilR d (bdiffZ f) r := by
    unfold stencilR
    refine Finset.sum_congr rfl fun k hk => ?_
    have hk2 : k ∈ range (d + 2) := by
      have := Finset.mem_range.mp hk
      exact Finset.mem_range.mpr (by omega)
    show (-1 : ℝ) ^ k * (d.choose k) * ((N (r - k) : ℤ) : ℝ) = _
    rw [hrow k hk2]
  rw [← hwin, ← hcast, hzero]
  norm_num

/-- **The weld to the RH layer.** `Nonvanishing.StmtSchoenfeldWindow` is
an instance of the shape-free hypothesis. The relative error is worst at
the window BOTTOM — `√x/x = 2^(−m/2)` grows as `m` falls — so the
witness is `ρ = (log 2·r/(8π))·2^(−(r−n)/2)`, not the top-of-window
value. Both factors are then bounded termwise: `r−k ≤ r` for the linear
one, `k ≤ n` for the exponential one. -/
theorem schoenfeldWindow_relErr {f L : ℤ → ℝ} {r : ℤ} {n : ℕ}
    (hr : (n : ℤ) ≤ r) (hS : Nonvanishing.StmtSchoenfeldWindow f L r n) :
    StmtRelErrWindow f L r n
      ((Real.log 2 * r / (8 * Real.pi)) * (2 : ℝ) ^ (-((r : ℝ) - n) / 2)) := by
  intro k hk
  refine (hS k hk).trans ?_
  have h2 : (0 : ℝ) < 2 := by norm_num
  have hlog : (0 : ℝ) ≤ Real.log 2 := Real.log_nonneg (by norm_num)
  have hpi : (0 : ℝ) < 8 * Real.pi := by positivity
  have hkn : (k : ℝ) ≤ (n : ℝ) := by
    exact_mod_cast Nat.lt_succ_iff.mp (Finset.mem_range.mp hk)
  have hkr : (k : ℝ) ≤ (r : ℝ) := by
    have hki : (k : ℤ) ≤ r :=
      le_trans (by exact_mod_cast Nat.lt_succ_iff.mp (Finset.mem_range.mp hk)) hr
    exact_mod_cast hki
  have hcomb : (Real.log 2 * r / (8 * Real.pi)) * (2 : ℝ) ^ (-((r : ℝ) - n) / 2)
        * (2 : ℝ) ^ ((r : ℝ) - k)
      = (Real.log 2 * r / (8 * Real.pi))
        * (2 : ℝ) ^ ((r : ℝ) - k - ((r : ℝ) - n) / 2) := by
    rw [mul_assoc, ← Real.rpow_add h2]
    congr 2
    ring
  rw [hcomb]
  have hexp : (2 : ℝ) ^ (((r : ℝ) - k) / 2)
      ≤ (2 : ℝ) ^ ((r : ℝ) - k - ((r : ℝ) - n) / 2) := by
    refine Real.rpow_le_rpow_of_exponent_le (by norm_num) ?_
    linarith
  have hlin : Real.log 2 * ((r : ℝ) - k) / (8 * Real.pi)
      ≤ Real.log 2 * r / (8 * Real.pi) := by
    rw [div_le_div_iff_of_pos_right hpi]
    nlinarith [hlog, Nat.cast_nonneg (α := ℝ) k]
  have hlinnn : (0 : ℝ) ≤ Real.log 2 * ((r : ℝ) - k) / (8 * Real.pi) := by
    have hrk : (0 : ℝ) ≤ (r : ℝ) - k := by linarith
    positivity
  calc Real.log 2 * ((r : ℝ) - k) / (8 * Real.pi) * (2 : ℝ) ^ (((r : ℝ) - k) / 2)
      ≤ Real.log 2 * ((r : ℝ) - k) / (8 * Real.pi)
          * (2 : ℝ) ^ ((r : ℝ) - k - ((r : ℝ) - n) / 2) :=
        mul_le_mul_of_nonneg_left hexp hlinnn
    _ ≤ Real.log 2 * r / (8 * Real.pi)
          * (2 : ℝ) ^ ((r : ℝ) - k - ((r : ℝ) - n) / 2) :=
        mul_le_mul_of_nonneg_right hlin (Real.rpow_nonneg (by norm_num) _)

/-- **The power-saving instance.** A bound `|f − L| ≤ A·x^θ` at
`x = 2^m` gives relative error `A·2^(m(θ−1))`, worst at the window
bottom when `θ ≤ 1`. So the witness is `ρ = A·2^((r−n)(θ−1))`, and the
gate becomes a statement about the exponent `θ` alone. -/
theorem powerSaving_relErr {f L : ℤ → ℝ} {r : ℤ} {n : ℕ} {A θ : ℝ}
    (hA : 0 ≤ A) (hθ : θ ≤ 1)
    (hP : ∀ k ∈ range (n + 1),
      |f (r - k) - L (r - k)| ≤ A * ((2 : ℝ) ^ ((r : ℝ) - k)) ^ θ) :
    StmtRelErrWindow f L r n (A * (2 : ℝ) ^ (((r : ℝ) - n) * (θ - 1))) := by
  intro k hk
  refine (hP k hk).trans ?_
  have h2 : (0 : ℝ) < 2 := by norm_num
  have hkn : (k : ℝ) ≤ (n : ℝ) := by
    exact_mod_cast Nat.lt_succ_iff.mp (Finset.mem_range.mp hk)
  have hlhs : ((2 : ℝ) ^ ((r : ℝ) - k)) ^ θ = (2 : ℝ) ^ (((r : ℝ) - k) * θ) := by
    rw [← Real.rpow_mul h2.le]
  have hrhs : (2 : ℝ) ^ (((r : ℝ) - n) * (θ - 1)) * (2 : ℝ) ^ ((r : ℝ) - k)
      = (2 : ℝ) ^ (((r : ℝ) - n) * (θ - 1) + ((r : ℝ) - k)) := by
    rw [← Real.rpow_add h2]
  rw [hlhs, mul_assoc, hrhs]
  refine mul_le_mul_of_nonneg_left ?_ hA
  refine Real.rpow_le_rpow_of_exponent_le (by norm_num) ?_
  nlinarith [hkn, hθ]

end

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'RelativeGate.relError_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms RelativeGate.relError_bound

/-- info: 'RelativeGate.relGate_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms RelativeGate.relGate_iff

/-- info: 'RelativeGate.relGate_eps' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms RelativeGate.relGate_eps

/-- info: 'RelativeGate.nonvanishing_of_relErr' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms RelativeGate.nonvanishing_of_relErr

/-- info: 'RelativeGate.tableFrom_ne_zero_of_relErr' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms RelativeGate.tableFrom_ne_zero_of_relErr

/-- info: 'RelativeGate.schoenfeldWindow_relErr' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms RelativeGate.schoenfeldWindow_relErr

/-- info: 'RelativeGate.powerSaving_relErr' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms RelativeGate.powerSaving_relErr

end RelativeGate
