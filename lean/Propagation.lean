/-
Propagation — the recurrence as transport: the light cone, and the propagator.

`papers/Depth-as-Time.md` reads depth as time. Take that literally: with `d` as
time and `r` as space, the recurrence

    cell(r, d+1) = cell(r, d) − cell(r−1, d)

is one step of FIRST-ORDER UPWIND TRANSPORT, iterated. Not the second-order
wave equation — the honest name is transport, and this header is where the
distinction is recorded. Signals move one rung per depth step, leftward in the
window: speed exactly 1.

Three facts follow, and the point of this module is that they are the
standard PDE vocabulary, proved for the actual table operator:

  * DOMAIN OF DEPENDENCE (already in the tree). A cell at `(r,d)` reads only
    the rungs `[r−d, r]` — `Construction.zero_determined_by_row`. That is the
    backward light cone, proved before anyone called it one.
  * RANGE OF INFLUENCE (new). A point source at rung `s` — the row `δ_s` —
    reaches exactly the cells with `s ≤ r ≤ s+d`: zero outside the forward
    cone, and NONZERO at every cell strictly inside it. The discrete
    transport has no lacunae: a disturbance fills its entire cone.
  * THE PROPAGATOR (new, and it is the stencil). The fundamental solution is
    `cell(s+k, d) = (−1)^k · C(d,k)` — the alternating binomial row. The
    Green's function of this evolution IS Pascal's triangle with signs,
    which is `Zeros.tableFrom_eq_stencil` read as a propagator.

The reflection law at a node — a zero at `(r,d)` forcing the `±v` pair onto
the diagonal one in, `±343` at `(20,6)` — is `Zeros.neg_below_zero` and
`Zeros.pair_shares_diagonal`, and is not repeated here.

**This module does not import Mathlib** — Lean core only, per
`lean/BUILD.md` § Mathlib-free core, which says to extend that discipline to
the integer modules. Core carries no `Nat.choose`, so the binomial is defined
here by the Pascal recurrence, which makes Pascal definitional. Under Mathlib
it would be `Nat.choose`; `Zeros.tableFrom_eq_stencil` carries that side.

Companion to papers/Depth-as-Time.md § A, papers/The-Fold.md § C, and notes
entry 106.
-/
import Construction
import SeedPerturbation

-- Core has no ℤ/ℕ notation; `local` keeps these inside this file.
local notation "ℤ" => Int
local notation "ℕ" => Nat

namespace Propagation

open Construction

/-! ## The binomial, by Pascal -/

/-- Binomial coefficients by the Pascal recurrence, ℤ-valued. Core has no
`Nat.choose`; defining it this way makes Pascal's identity definitional. -/
def pasc : ℕ → ℕ → ℤ
  | _, 0 => 1
  | 0, _ + 1 => 0
  | n + 1, k + 1 => pasc n k + pasc n (k + 1)

/-- The left edge of the triangle is all ones. -/
theorem pasc_zero (n : ℕ) : pasc n 0 = 1 := by cases n <;> rfl

/-- Pascal's identity — definitional, because `pasc` is defined by it. -/
theorem pasc_succ (n k : ℕ) : pasc (n + 1) (k + 1) = pasc n k + pasc n (k + 1) := rfl

/-- Above the diagonal the binomial vanishes. -/
theorem pasc_eq_zero {n k : ℕ} (h : n < k) : pasc n k = 0 := by
  induction n generalizing k with
  | zero =>
      match k, h with
      | k + 1, _ => rfl
  | succ m ih =>
      match k, h with
      | k + 1, h =>
        rw [pasc_succ]
        rw [ih (Nat.lt_of_succ_lt_succ h), ih (Nat.lt_succ_of_lt (Nat.lt_of_succ_lt_succ h))]
        rfl

/-- On and below the diagonal it is positive — this is what "no lacunae" rests
on: the propagator never vanishes inside its cone. -/
theorem pasc_pos {n k : ℕ} (h : k ≤ n) : 0 < pasc n k := by
  induction n generalizing k with
  | zero =>
      match k, h with
      | 0, _ => exact Int.zero_lt_one
  | succ m ih =>
      match k with
      | 0 => exact Int.zero_lt_one
      | k + 1 =>
        rw [pasc_succ]
        have h1 : 0 < pasc m k := ih (Nat.le_of_succ_le_succ h)
        match Nat.lt_or_ge m (k + 1) with
        | Or.inl hlt =>
            rw [pasc_eq_zero hlt]
            omega
        | Or.inr hge =>
            have h2 : 0 < pasc m (k + 1) := ih hge
            omega

/-! ## The point source -/

/-- A unit disturbance at rung `s`: the delta row. -/
def deltaRow (s : ℤ) : ℤ → ℤ := fun x => if x = s then 1 else 0

/-- **Outside the forward cone, nothing.** A source at `s` does not reach a
cell whose window `[r−d, r]` misses `s` — the range of influence is bounded by
speed 1. Downstream (`r < s`) and past the cone's left edge (`s < r−d`) the
cell is zero. -/
theorem outside_cone_zero (s r : ℤ) (d : ℕ) (h : r < s ∨ s < r - (d : ℤ)) :
    tableFrom (deltaRow s) r d = 0 := by
  have hwin : ∀ k : ℕ, k ≤ d →
      deltaRow s (r - (k : ℤ)) = (fun _ : ℤ => (0 : ℤ)) (r - (k : ℤ)) := by
    intro k hk
    show (if r - (k : ℤ) = s then (1 : ℤ) else 0) = 0
    have hne : ¬(r - (k : ℤ) = s) := by omega
    simp [hne]
  rw [zero_determined_by_row (M := fun _ : ℤ => (0 : ℤ)) r d hwin]
  exact SeedPerturbation.tableFrom_zero r d

/-- **Inside the cone, the propagator.** At offset `k ≤ d` from the source the
cell is exactly `(−1)^k · C(d,k)`: the Green's function of the evolution is
the alternating binomial row — the stencil, read as a propagator. -/
theorem propagator (s : ℤ) (d k : ℕ) (hk : k ≤ d) :
    tableFrom (deltaRow s) (s + (k : ℤ)) d = (-1) ^ k * pasc d k := by
  induction d generalizing k with
  | zero =>
      match k, hk with
      | 0, _ =>
        show deltaRow s (s + 0) = (-1) ^ 0 * pasc 0 0
        show (if s + 0 = s then (1 : ℤ) else 0) = (-1) ^ 0 * pasc 0 0
        simp
        rfl
  | succ n ih =>
      show tableFrom (deltaRow s) (s + (k : ℤ)) n
            - tableFrom (deltaRow s) (s + (k : ℤ) - 1) n = _
      match k with
      | 0 =>
          rw [ih 0 (Nat.zero_le n),
              show s + ((0 : ℕ) : ℤ) - 1 = s + (0 : ℤ) - 1 from rfl,
              outside_cone_zero s (s + (0 : ℤ) - 1) n (Or.inl (by omega))]
          rw [pasc_zero, pasc_zero]
          decide
      | k + 1 =>
          have e1 : s + ((k + 1 : ℕ) : ℤ) - 1 = s + (k : ℤ) := by omega
          rw [e1]
          match Nat.lt_or_ge n (k + 1) with
          | Or.inr hge =>
              -- both cells inside the cone at time n
              rw [ih (k + 1) hge, ih k (Nat.le_of_succ_le hge)]
              rw [pasc_succ]
              have hsign : ((-1 : ℤ)) ^ (k + 1) = -((-1 : ℤ)) ^ k := by
                rw [Int.pow_succ, Int.mul_neg, Int.mul_one]
              simp only [hsign, Int.neg_mul, Int.mul_add, Int.sub_eq_add_neg]
              exact Int.add_comm _ _
          | Or.inl hlt =>
              -- k+1 = n+1 exactly (since k+1 ≤ n+1 and n < k+1)
              have hk1 : k + 1 = n + 1 := by omega
              have hkn : k = n := by omega
              subst hkn
              rw [outside_cone_zero s (s + ((k + 1 : ℕ) : ℤ)) k (Or.inr (by omega)),
                  ih k (Nat.le_refl k)]
              rw [pasc_succ, pasc_eq_zero (Nat.lt_succ_self k)]
              have hsign : ((-1 : ℤ)) ^ (k + 1) = -((-1 : ℤ)) ^ k := by
                rw [Int.pow_succ, Int.mul_neg, Int.mul_one]
              simp only [hsign, Int.neg_mul, Int.add_zero, Int.zero_sub]

/-- `(−1)^m` is `1` or `−1`. Stated here because core carries no pow lemmas. -/
theorem neg_one_pow (m : ℕ) : ((-1 : ℤ)) ^ m = 1 ∨ ((-1 : ℤ)) ^ m = -1 := by
  induction m with
  | zero => exact Or.inl rfl
  | succ n ih =>
      rw [Int.pow_succ]
      match ih with
      | Or.inl h => rw [h]; exact Or.inr rfl
      | Or.inr h => rw [h]; exact Or.inl rfl

/-- **No lacunae.** Strictly inside the forward cone the disturbance is felt at
EVERY cell — the propagator never vanishes there. Discrete 1+1 transport fills
its cone, where the 3+1 wave equation would leave the interior silent. -/
theorem cone_filled (s : ℤ) (d k : ℕ) (hk : k ≤ d) :
    tableFrom (deltaRow s) (s + (k : ℤ)) d ≠ 0 := by
  rw [propagator s d k hk]
  have hp : 0 < pasc d k := pasc_pos hk
  match neg_one_pow k with
  | Or.inl h => rw [h, Int.one_mul]; omega
  | Or.inr h => rw [h, Int.neg_one_mul]; omega

/-- **The flux form.** The recurrence rearranged as a conservation step: what
the cell holds at time `d+1` plus what flowed left is what it held at `d`.
Definitional — recorded so the transport reading has its conservation law
stated. The interval form (a sum at time `d+1` telescoping to boundary terms)
is `Isogeny.telescope`, on the Mathlib side. -/
theorem flux_form (N : ℤ → ℤ) (r : ℤ) (d : ℕ) :
    tableFrom N r (d + 1) + tableFrom N (r - 1) d = tableFrom N r d := by
  show tableFrom N r d - tableFrom N (r - 1) d + tableFrom N (r - 1) d = _
  omega

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.

With Mathlib absent the floor is `propext`, entering through `rw`/`simp`;
`omega` adds `Quot.sound`.
-/

/-- info: 'Propagation.pasc_zero' does not depend on any axioms -/
#guard_msgs in
#print axioms Propagation.pasc_zero

/-- info: 'Propagation.pasc_succ' does not depend on any axioms -/
#guard_msgs in
#print axioms Propagation.pasc_succ

/-- info: 'Propagation.pasc_eq_zero' does not depend on any axioms -/
#guard_msgs in
#print axioms Propagation.pasc_eq_zero

/-- info: 'Propagation.neg_one_pow' depends on axioms: [propext] -/
#guard_msgs in
#print axioms Propagation.neg_one_pow

/-- info: 'Propagation.pasc_pos' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms Propagation.pasc_pos

/-- info: 'Propagation.outside_cone_zero' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms Propagation.outside_cone_zero

/-- info: 'Propagation.propagator' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms Propagation.propagator

/-- info: 'Propagation.cone_filled' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms Propagation.cone_filled

/-- info: 'Propagation.flux_form' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms Propagation.flux_form

end Propagation
