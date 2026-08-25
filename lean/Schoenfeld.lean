/-
Schoenfeld — stage 3's interface: the literature sentence, verbatim.

`Expansion.tableFrom_ne_zero_of_li` carries the conditional arrow with `hS`
stated window-wise, in bench shape: per-`k` bounds with the power already
translated to `2^((r−k)/2)`. Nobody can check that against Schoenfeld 1976
by eye. This module moves the unproven surface to the exact cited sentence:

  StmtSchoenfeld pi li :  ∀ x ≥ 2657,  |pi x − li x| ≤ √x · log x / (8π)

(Schoenfeld 1976, Corollary 1 — RH-conditional in the literature), and proves
the bridge: the global sentence implies every window hypothesis whose bottom
clears `2^12 = 4096 ≥ 2657` (`window_of_global`), which the capstone's
`12 ≤ r − (d+1)` supplies. `tableFrom_ne_zero_of_schoenfeld` is then the
assembled arrow whose one analytic input IS the published inequality, over
abstract `pi li : ℝ → ℝ` tied to the table's row function and the smooth
interpolant at the points `2^m`.

Entry 116 records the scope decision this module implements: the statement
shrink is step 1 of every stage-3 route, done in-tree; the decomposition
(hS → {hRH, hEF}) is a separate decision.

Companion to papers/The-Four-Zeros.md § I and notes entries 115, 116.
-/
import Mathlib
import Expansion

namespace Schoenfeld

open Finset Set

noncomputable section

/-- **Schoenfeld 1976, Corollary 1, verbatim shape:** for all `x ≥ 2657`,
`|π(x) − li(x)| ≤ √x · log x / (8π)`. RH-conditional in the literature;
here a named hypothesis over abstract `pi li : ℝ → ℝ`. -/
def StmtSchoenfeld (pi li : ℝ → ℝ) : Prop :=
  ∀ x : ℝ, 2657 ≤ x → |pi x - li x| ≤ Real.sqrt x * Real.log x / (8 * Real.pi)

/-- **The bridge:** the global sentence implies the bench-shaped window
hypothesis whenever the window bottom clears `12`, since
`2^12 = 4096 ≥ 2657`. The translation is `√(2^y) = 2^(y/2)` and
`log(2^y) = y·log 2`. -/
theorem window_of_global {pi li : ℝ → ℝ} {f L : ℤ → ℝ} {r : ℤ} {n : ℕ}
    (hpi : StmtSchoenfeld pi li)
    (hf : ∀ m : ℤ, f m = pi ((2 : ℝ) ^ (m : ℝ)))
    (hL : ∀ m : ℤ, L m = li ((2 : ℝ) ^ (m : ℝ)))
    (hbot : (12 : ℤ) ≤ r - n) :
    Nonvanishing.StmtSchoenfeldWindow f L r n := by
  intro k hk
  have hkn : k ≤ n := Nat.lt_succ_iff.mp (Finset.mem_range.mp hk)
  have hm12 : (12 : ℤ) ≤ r - k := by
    have : (k : ℤ) ≤ n := by exact_mod_cast hkn
    omega
  set y : ℝ := (r : ℝ) - k with hy
  have hcast : ((r - k : ℤ) : ℝ) = y := by push_cast [hy]; ring
  have hmR : (12 : ℝ) ≤ y := by rw [← hcast]; exact_mod_cast hm12
  have hx4096 : (4096 : ℝ) ≤ (2 : ℝ) ^ y := by
    calc (4096 : ℝ) = (2 : ℝ) ^ ((12 : ℕ) : ℝ) := by
          rw [Real.rpow_natCast]; norm_num
      _ ≤ (2 : ℝ) ^ y := by
          apply Real.rpow_le_rpow_of_exponent_le (by norm_num)
          exact_mod_cast hmR
  have h2657 : (2657 : ℝ) ≤ (2 : ℝ) ^ y := le_trans (by norm_num) hx4096
  have hfm : f (r - k) = pi ((2 : ℝ) ^ y) := by rw [hf (r - k), hcast]
  have hLm : L (r - k) = li ((2 : ℝ) ^ y) := by rw [hL (r - k), hcast]
  rw [hfm, hLm]
  have hsqrt : Real.sqrt ((2 : ℝ) ^ y) = (2 : ℝ) ^ (y / 2) := by
    rw [Real.sqrt_eq_rpow, ← Real.rpow_mul (by norm_num : (0 : ℝ) ≤ 2)]
    congr 1
    ring
  have hlog : Real.log ((2 : ℝ) ^ y) = y * Real.log 2 :=
    Real.log_rpow (by norm_num) y
  calc |pi ((2 : ℝ) ^ y) - li ((2 : ℝ) ^ y)|
      ≤ Real.sqrt ((2 : ℝ) ^ y) * Real.log ((2 : ℝ) ^ y) / (8 * Real.pi) :=
        hpi ((2 : ℝ) ^ y) h2657
    _ = (Real.log 2 * y / (8 * Real.pi)) * (2 : ℝ) ^ (y / 2) := by
        rw [hsqrt, hlog]; ring

/-- **The arrow, with the literature sentence as its one analytic input.**
Identical to `Expansion.tableFrom_ne_zero_of_li` except that `hS` is replaced
by `StmtSchoenfeld` — Schoenfeld's published inequality character for
character — plus the compatibility of `f` and `G` with `pi` and `li` at the
points `2^m`, and the window bottom raised to `12 ≤ r − (d+1)` so every
window point clears Schoenfeld's floor `x ≥ 2657`. -/
theorem tableFrom_ne_zero_of_schoenfeld {N : ℤ → ℤ} {f : ℤ → ℝ} {G : ℝ → ℝ}
    {pi li : ℝ → ℝ} {r : ℤ} {d : ℕ}
    (hG : ContDiff ℝ (⊤ : ℕ∞) G)
    (hG' : ∀ x ∈ Ioi ((1 : ℝ) / 2), HasDerivAt G (Expansion.f2x x) x)
    (hpi : StmtSchoenfeld pi li)
    (hf : ∀ m : ℤ, f m = pi ((2 : ℝ) ^ (m : ℝ)))
    (hli : ∀ m : ℤ, G (m : ℝ) = li ((2 : ℝ) ^ (m : ℝ)))
    (hrow : ∀ k ∈ range (d + 2), ((N (r - k) : ℤ) : ℝ) = Nonvanishing.bdiffZ f (r - k))
    (hr : ((d + 1 : ℕ) : ℤ) ≤ r)
    (hbot : (12 : ℤ) ≤ r - ((d + 1 : ℕ) : ℤ))
    (hw : 2 * (d : ℝ) ≤ Real.log 2 * ((r : ℝ) - (d + 1)))
    (hgap : Nonvanishing.Ehigh r (d + 1) < Nonvanishing.Mlow r d) :
    Construction.tableFrom N r d ≠ 0 := by
  have hbotR : (1 : ℝ) ≤ (r : ℝ) - (d + 1) := by
    have : ((12 : ℤ) : ℝ) ≤ ((r - ((d + 1 : ℕ) : ℤ) : ℤ) : ℝ) := by
      exact_mod_cast hbot
    push_cast at this
    linarith
  exact Expansion.tableFrom_ne_zero_of_li hG hG' hrow hr
    (window_of_global hpi hf hli hbot) hbotR hw hgap

end

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'Schoenfeld.window_of_global' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Schoenfeld.window_of_global

/-- info: 'Schoenfeld.tableFrom_ne_zero_of_schoenfeld' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Schoenfeld.tableFrom_ne_zero_of_schoenfeld

end Schoenfeld
