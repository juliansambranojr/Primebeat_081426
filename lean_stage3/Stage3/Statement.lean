/-
Statement — step 2: the weak bound family, and the bridges between shapes.

O68 (entry 118) measured the tolerance: the census survives bounds of the
shape C·√x·(log x)^k far weaker than Schoenfeld's — depth 10 at C = 1,
k = 2; depth 6 at C = 1000. This module gives that family its Lean name
and proves the bridges:

  StmtSchoenfeldWeak C k x₀ :  ∀ x ≥ x₀,  |pi x − li x| ≤ C·√x·(log x)^k
  StmtWeakWindow C k        :  the same bound translated to the dyadic
                               window, 2^((r−j)/2)·(log 2·(r−j))^k shape

  schoenfeld_iff_weak       :  Schoenfeld 1976 Cor. 1 is the member
                               C = 1/(8π), k = 1, x₀ = 2657
  weakWindow_of_global      :  global weak bound ⟹ window weak bound,
                               whenever the window bottom clears x₀
  weakWindow_at_schoenfeld  :  at Schoenfeld's parameters the weak window
                               is the bench's StmtSchoenfeldWindow,
                               character for character in the bound
  window_of_global          :  the composition — the bench bridge
                               (lean/Schoenfeld.lean, v4.28.0) reproved
                               on this toolchain, demonstrating the weld
  weak_mono / weak_anti_x₀  :  a stronger constant or a lower floor only
                               strengthens the hypothesis

`StmtSchoenfeld` and `StmtSchoenfeldWindow` are character-level copies of
the bench definitions (lean/Schoenfeld.lean, lean/Nonvanishing.lean);
utilities/check_weld.py holds the identity. The weld caveat from
Stage3.lean applies to everything here.

Companion to notes entries 118, 119, 121.
-/
import Mathlib

namespace Stage3

open Finset

noncomputable section

/-- Character-level copy of `Nonvanishing.StmtSchoenfeldWindow` from the
bench tree (lean/Nonvanishing.lean). The weld: utilities/check_weld.py
verifies the two definition bodies are textually identical. -/
def StmtSchoenfeldWindow (f L : ℤ → ℝ) (r : ℤ) (n : ℕ) : Prop :=
  ∀ k ∈ range (n + 1),
    |f (r - k) - L (r - k)|
      ≤ (Real.log 2 * ((r : ℝ) - k) / (8 * Real.pi)) * (2 : ℝ) ^ (((r : ℝ) - k) / 2)

/-- Character-level copy of `Schoenfeld.StmtSchoenfeld` from the bench tree
(lean/Schoenfeld.lean). The weld: utilities/check_weld.py verifies the two
definition bodies are textually identical. -/
def StmtSchoenfeld (pi li : ℝ → ℝ) : Prop :=
  ∀ x : ℝ, 2657 ≤ x → |pi x - li x| ≤ Real.sqrt x * Real.log x / (8 * Real.pi)

/-- **The weak family** (O68's grid, as a Prop): `|pi − li| ≤ C·√x·(log x)^k`
from `x₀` on. The census survives members far weaker than Schoenfeld's:
depth 10 at `C = 1, k = 2`, depth 6 at `C = 1000, k = 2` (entry 118). -/
def StmtSchoenfeldWeak (C : ℝ) (k : ℕ) (x₀ : ℝ) (pi li : ℝ → ℝ) : Prop :=
  ∀ x : ℝ, x₀ ≤ x → |pi x - li x| ≤ C * Real.sqrt x * Real.log x ^ k

/-- The weak bound translated to the dyadic window: at `x = 2^(r−j)` the
bound reads `C·(log 2·(r−j))^k·2^((r−j)/2)`. -/
def StmtWeakWindow (C : ℝ) (k : ℕ) (f L : ℤ → ℝ) (r : ℤ) (n : ℕ) : Prop :=
  ∀ j ∈ range (n + 1),
    |f (r - j) - L (r - j)|
      ≤ C * (Real.log 2 * ((r : ℝ) - j)) ^ k * (2 : ℝ) ^ (((r : ℝ) - j) / 2)

/-- **Schoenfeld is a member of the family:** Corollary 1 is exactly
`C = 1/(8π), k = 1, x₀ = 2657`. -/
theorem schoenfeld_iff_weak {pi li : ℝ → ℝ} :
    StmtSchoenfeld pi li ↔ StmtSchoenfeldWeak (1 / (8 * Real.pi)) 1 2657 pi li := by
  unfold StmtSchoenfeld StmtSchoenfeldWeak
  have hEq : ∀ x : ℝ, 1 / (8 * Real.pi) * Real.sqrt x * Real.log x ^ 1
      = Real.sqrt x * Real.log x / (8 * Real.pi) := fun x => by ring
  exact forall_congr' fun x => imp_congr_right fun _ => by rw [hEq x]

/-- A lower floor only strengthens the hypothesis. -/
theorem weak_anti_x₀ {C : ℝ} {k : ℕ} {x₀ x₀' : ℝ} {pi li : ℝ → ℝ}
    (hx : x₀ ≤ x₀') (h : StmtSchoenfeldWeak C k x₀ pi li) :
    StmtSchoenfeldWeak C k x₀' pi li :=
  fun x hx' => h x (le_trans hx hx')

/-- A larger constant only weakens the hypothesis (needs `1 ≤ x₀` so the
envelope `√x·(log x)^k` is nonnegative on the range). -/
theorem weak_mono {C C' : ℝ} {k : ℕ} {x₀ : ℝ} {pi li : ℝ → ℝ}
    (hx₀ : 1 ≤ x₀) (hC : C ≤ C') (h : StmtSchoenfeldWeak C k x₀ pi li) :
    StmtSchoenfeldWeak C' k x₀ pi li := by
  intro x hx
  refine le_trans (h x hx) ?_
  have h1x : (1 : ℝ) ≤ x := le_trans hx₀ hx
  have hs : 0 ≤ Real.sqrt x := Real.sqrt_nonneg x
  have hl : 0 ≤ Real.log x ^ k := pow_nonneg (Real.log_nonneg h1x) k
  have : C * Real.sqrt x ≤ C' * Real.sqrt x :=
    mul_le_mul_of_nonneg_right hC hs
  exact mul_le_mul_of_nonneg_right this hl

/-- **The bridge, weak form:** the global weak bound implies the window
bound whenever the window bottom clears the floor:
`x₀ ≤ 2^(r−n)`. The translation is `√(2^y) = 2^(y/2)` and
`log(2^y) = y·log 2`, exactly as in the bench's special case. -/
theorem weakWindow_of_global {C : ℝ} {k : ℕ} {x₀ : ℝ} {pi li : ℝ → ℝ}
    {f L : ℤ → ℝ} {r : ℤ} {n : ℕ}
    (hpi : StmtSchoenfeldWeak C k x₀ pi li)
    (hf : ∀ m : ℤ, f m = pi ((2 : ℝ) ^ (m : ℝ)))
    (hL : ∀ m : ℤ, L m = li ((2 : ℝ) ^ (m : ℝ)))
    (hbot : x₀ ≤ (2 : ℝ) ^ ((r : ℝ) - n)) :
    StmtWeakWindow C k f L r n := by
  intro j hj
  have hjn : j ≤ n := Nat.lt_succ_iff.mp (Finset.mem_range.mp hj)
  set y : ℝ := (r : ℝ) - j with hy
  have hcast : ((r - j : ℤ) : ℝ) = y := by push_cast [hy]; ring
  have hyn : (r : ℝ) - n ≤ y := by
    have : (j : ℝ) ≤ n := by exact_mod_cast hjn
    simp only [hy]; linarith
  have hx₀y : x₀ ≤ (2 : ℝ) ^ y :=
    le_trans hbot (Real.rpow_le_rpow_of_exponent_le (by norm_num) hyn)
  have hfm : f (r - j) = pi ((2 : ℝ) ^ y) := by rw [hf (r - j), hcast]
  have hLm : L (r - j) = li ((2 : ℝ) ^ y) := by rw [hL (r - j), hcast]
  rw [hfm, hLm]
  have hsqrt : Real.sqrt ((2 : ℝ) ^ y) = (2 : ℝ) ^ (y / 2) := by
    rw [Real.sqrt_eq_rpow, ← Real.rpow_mul (by norm_num : (0 : ℝ) ≤ 2)]
    congr 1
    ring
  have hlog : Real.log ((2 : ℝ) ^ y) = y * Real.log 2 :=
    Real.log_rpow (by norm_num) y
  calc |pi ((2 : ℝ) ^ y) - li ((2 : ℝ) ^ y)|
      ≤ C * Real.sqrt ((2 : ℝ) ^ y) * Real.log ((2 : ℝ) ^ y) ^ k :=
        hpi ((2 : ℝ) ^ y) hx₀y
    _ = C * (Real.log 2 * y) ^ k * (2 : ℝ) ^ (y / 2) := by
        rw [hsqrt, hlog, mul_comm y (Real.log 2)]
        ring

/-- **At Schoenfeld's parameters the weak window is the bench's window:**
`C = 1/(8π), k = 1` recovers `StmtSchoenfeldWindow`'s bound character for
character. -/
theorem weakWindow_at_schoenfeld {f L : ℤ → ℝ} {r : ℤ} {n : ℕ} :
    StmtWeakWindow (1 / (8 * Real.pi)) 1 f L r n ↔ StmtSchoenfeldWindow f L r n := by
  unfold StmtWeakWindow StmtSchoenfeldWindow
  have hEq : ∀ j : ℕ, 1 / (8 * Real.pi) * (Real.log 2 * ((r : ℝ) - j)) ^ 1
        * (2 : ℝ) ^ (((r : ℝ) - j) / 2)
      = (Real.log 2 * ((r : ℝ) - j) / (8 * Real.pi))
        * (2 : ℝ) ^ (((r : ℝ) - j) / 2) := fun j => by ring
  exact forall_congr' fun j => forall_congr' fun _ => by rw [hEq j]

/-- **The composition — the bench bridge reproved on this toolchain.**
Identical statement to the bench's `Schoenfeld.window_of_global`
(lean/Schoenfeld.lean, v4.28.0, kernel-checked there); proved here through
the weak family, demonstrating the weld carries. -/
theorem window_of_global {pi li : ℝ → ℝ} {f L : ℤ → ℝ} {r : ℤ} {n : ℕ}
    (hpi : StmtSchoenfeld pi li)
    (hf : ∀ m : ℤ, f m = pi ((2 : ℝ) ^ (m : ℝ)))
    (hL : ∀ m : ℤ, L m = li ((2 : ℝ) ^ (m : ℝ)))
    (hbot : (12 : ℤ) ≤ r - n) :
    StmtSchoenfeldWindow f L r n := by
  refine weakWindow_at_schoenfeld.mp ?_
  refine weakWindow_of_global (schoenfeld_iff_weak.mp hpi) hf hL ?_
  have hbR : (12 : ℝ) ≤ (r : ℝ) - n := by
    have : ((12 : ℤ) : ℝ) ≤ ((r - n : ℤ) : ℝ) := by exact_mod_cast hbot
    push_cast at this
    linarith
  calc (2657 : ℝ) ≤ (2 : ℝ) ^ ((12 : ℕ) : ℝ) := by
        rw [Real.rpow_natCast]; norm_num
    _ ≤ (2 : ℝ) ^ ((r : ℝ) - n) :=
        Real.rpow_le_rpow_of_exponent_le (by norm_num) (by exact_mod_cast hbR)

end

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'Stage3.schoenfeld_iff_weak' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.schoenfeld_iff_weak

/-- info: 'Stage3.weak_anti_x₀' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.weak_anti_x₀

/-- info: 'Stage3.weak_mono' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.weak_mono

/-- info: 'Stage3.weakWindow_of_global' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.weakWindow_of_global

/-- info: 'Stage3.weakWindow_at_schoenfeld' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.weakWindow_at_schoenfeld

/-- info: 'Stage3.window_of_global' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.window_of_global

end Stage3
