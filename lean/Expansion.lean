/-
Expansion — stage 2b: the derivative of 2^x/x, explicitly, and its floor.

`MainTerm.lean` reduced O67's main-term hypothesis to `hD`: a floor on the
`(d+1)`-th derivative of the li-interpolant on the window — equivalently, on
the `d`-th derivative of `2^x/x`. This module supplies both halves:

  THE EXPANSION (O67's step 3).  With
     c d j = C(d,j) · (log 2)^(d−j) · (−1)^j · j!
     S d x = Σ_{j≤d} c d j · x^(−(j+1))          (zpow, so x ≠ 0 suffices)
     F d x = e^((log 2)·x) · S d x               (that factor IS 2^x)
  `hasDerivAt_F` proves `F d` flows to `F (d+1)` at every `x ≠ 0`, via the
  coefficient recurrence `c (d+1) j = (log 2)·c d j + (−j)·c d (j−1)` — Pascal
  with the factorial absorbed, the `j = 0` edge dying against `−j`. Hence
  `iteratedDeriv d (2^x/x) = F d` on `(0,∞)` (`iteratedDeriv_f2x`).

  THE FLOOR (O67's alternating step).  The unsigned terms `t d j x` halve —
  `t (j+1) ≤ t j / 2` in the wedge `2d ≤ (log 2)·x`, which follows from
  `d ≤ 0.34·x` and `0.6931 < log 2` — so the downward tail bound
  `0 ≤ B k ≤ t k` gives `S ≥ t₀ − t₁ ≥ t₀/2`, i.e.
     F d x ≥ (1/2) · 2^x · (log 2)^d / x        (`F_floor`).

  THE DISCHARGE (`hD_of_window`, `tableFrom_ne_zero_of_li`).  On the window
  `[r−d−1, r]` with `1 ≤ r−d−1` and the wedge at the window bottom, the floor
  clears `Nonvanishing.Mlow`. O67's conditional theorem then has hypotheses
  only: `hG`/`hG'` (a smooth interpolant with derivative `2^x/x` on `(0,∞)` —
  everything the proof ever used about li, which Mathlib does not carry),
  `hS` (Schoenfeld, stage 3), `hrow`, `hgap`, and arithmetic.

Companion to papers/The-Four-Zeros.md § I and notes entry 115.
-/
import Mathlib
import MainTerm

namespace Expansion

open Finset Set

noncomputable section

/-- The expansion coefficients: `C(d,j)·(log 2)^(d−j)·(−1)^j·j!`.
`Nat.choose` vanishes past the diagonal, so no `ite` is needed. -/
def c (d j : ℕ) : ℝ :=
  (d.choose j) * Real.log 2 ^ (d - j) * (-1) ^ j * (j.factorial)

/-- The rational part of the `d`-th derivative of `2^x/x`. -/
def S (d : ℕ) (x : ℝ) : ℝ :=
  ∑ j ∈ range (d + 1), c d j * x ^ (-(j + 1 : ℤ))

/-- The `d`-th derivative of `2^x/x`, in closed form. -/
def F (d : ℕ) (x : ℝ) : ℝ := Real.exp (Real.log 2 * x) * S d x

/-- The function itself, in the exp form the calculus uses. -/
def f2x (x : ℝ) : ℝ := Real.exp (Real.log 2 * x) / x

/-- `e^((log 2)·x) = 2^x`. -/
theorem exp_eq_rpow (x : ℝ) : Real.exp (Real.log 2 * x) = (2 : ℝ) ^ x :=
  (Real.rpow_def_of_pos (by norm_num) x).symm

/-- `F 0` is the function itself. -/
theorem F_zero (x : ℝ) : F 0 x = f2x x := by
  unfold F S c f2x
  simp [zpow_neg, div_eq_mul_inv]

/-- **The coefficient recurrence** — Pascal with the factorial absorbed; the
`j = 0` edge dies against the `−j` factor. -/
theorem c_rec (d j : ℕ) :
    c (d + 1) j = Real.log 2 * c d j + (-(j : ℝ)) * c d (j - 1) := by
  match j with
  | 0 =>
      unfold c
      simp only [Nat.choose_zero_right, Nat.sub_zero, Nat.factorial_zero,
        Nat.cast_zero, Nat.cast_one, neg_zero, pow_zero, zero_mul, add_zero,
        mul_one, one_mul]
      rw [pow_succ]
      ring
  | j + 1 =>
      unfold c
      rcases Nat.lt_or_ge j d with hlt | hge
      · -- inside: genuine Pascal; d+1−(j+1) = d−j and d−j = (d−(j+1))+1
        rw [Nat.succ_sub_succ, Nat.choose_succ_succ d j, Nat.add_sub_cancel]
        have hexp : Real.log 2 ^ (d - j) = Real.log 2 * Real.log 2 ^ (d - (j + 1)) := by
          rw [← pow_succ']
          congr 1
          omega
        rw [hexp, Nat.factorial_succ]
        push_cast
        ring
      · -- at or past the diagonal: j ≥ d
        rcases Nat.eq_or_lt_of_le hge with heq | hlt2
        · -- j = d: the first RHS term dies on choose d (d+1) = 0
          subst heq
          have h3 : d + 1 - (d + 1) = 0 := by omega
          have h4 : d + 1 - 1 = d := by omega
          rw [h3, Nat.choose_self, Nat.choose_eq_zero_of_lt (by omega : d < d + 1),
              h4, Nat.choose_self, Nat.sub_self, Nat.factorial_succ]
          push_cast
          ring
        · -- j > d: everything dies
          simp only [Nat.choose_eq_zero_of_lt (show d < j + 1 by omega),
            Nat.choose_eq_zero_of_lt (show d + 1 < j + 1 by omega),
            Nat.add_sub_cancel,
            Nat.choose_eq_zero_of_lt (show d < j by omega),
            Nat.cast_zero, zero_mul, mul_zero, add_zero]

/-- **`S` differentiates term-by-term** into the pre-recombination sum. -/
theorem hasDerivAt_S (d : ℕ) {x : ℝ} (hx : x ≠ 0) :
    HasDerivAt (S d)
      (∑ j ∈ range (d + 1), c d j * (-(j : ℝ) - 1) * x ^ (-(j + 2 : ℤ))) x := by
  have h : ∀ j ∈ range (d + 1),
      HasDerivAt (fun y : ℝ => c d j * y ^ (-(j + 1 : ℤ)))
        (c d j * (-(j : ℝ) - 1) * x ^ (-(j + 2 : ℤ))) x := by
    intro j _
    have hz := hasDerivAt_zpow (-(j + 1 : ℤ)) x (Or.inl hx)
    have h2 := hz.const_mul (c d j)
    convert h2 using 1
    have he : (-(j + 1 : ℤ)) - 1 = -(j + 2 : ℤ) := by ring
    rw [he]
    push_cast
    ring
  unfold S
  convert HasDerivAt.sum h using 1
  ext y
  simp

/-- **The expansion advances:** `F d` has derivative `F (d+1)` at `x ≠ 0`.
Product rule, the coefficient recurrence, and one `sum_range_succ'` reindex. -/
theorem hasDerivAt_F (d : ℕ) {x : ℝ} (hx : x ≠ 0) :
    HasDerivAt (F d) (F (d + 1) x) x := by
  have hB : HasDerivAt (fun y : ℝ => Real.exp (Real.log 2 * y))
      (Real.log 2 * Real.exp (Real.log 2 * x)) x := by
    have h1 : HasDerivAt (fun y : ℝ => Real.log 2 * y) (Real.log 2) x := by
      simpa using (hasDerivAt_id x).const_mul (Real.log 2)
    have h2 := (Real.hasDerivAt_exp (Real.log 2 * x)).comp x h1
    convert h2 using 1
    exact mul_comm _ _
  have hprod := hB.mul (hasDerivAt_S d hx)
  have key : Real.log 2 * Real.exp (Real.log 2 * x) * S d x
      + Real.exp (Real.log 2 * x)
        * ∑ j ∈ range (d + 1), c d j * (-(j : ℝ) - 1) * x ^ (-(j + 2 : ℤ))
      = F (d + 1) x := by
    suffices hsum : Real.log 2 * S d x
        + ∑ j ∈ range (d + 1), c d j * (-(j : ℝ) - 1) * x ^ (-(j + 2 : ℤ))
        = S (d + 1) x by
      unfold F
      rw [← hsum]
      ring
    unfold S
    rw [Finset.mul_sum]
    have rhs_split : ∑ j ∈ range (d + 2), c (d + 1) j * x ^ (-(j + 1 : ℤ))
        = ∑ j ∈ range (d + 2), (Real.log 2 * c d j) * x ^ (-(j + 1 : ℤ))
          + ∑ j ∈ range (d + 2), ((-(j : ℝ)) * c d (j - 1)) * x ^ (-(j + 1 : ℤ)) := by
      rw [← Finset.sum_add_distrib]
      exact Finset.sum_congr rfl fun j _ => by rw [c_rec d j]; ring
    rw [rhs_split]
    congr 1
    · -- log2-sum: the extra j = d+1 term dies on choose
      rw [Finset.sum_range_succ
            (f := fun j => (Real.log 2 * c d j) * x ^ (-(j + 1 : ℤ))) (n := d + 1)]
      have hc0 : c d (d + 1) = 0 := by
        unfold c
        rw [Nat.choose_eq_zero_of_lt (by omega)]
        ring
      rw [hc0]
      simp only [mul_zero, zero_mul, add_zero]
      exact Finset.sum_congr rfl fun j _ => by ring
    · -- shifted sum: peel j = 0 (dies on −0), reindex j ↦ j+1
      rw [Finset.sum_range_succ' (fun j => ((-(j : ℝ)) * c d (j - 1)) * x ^ (-(j + 1 : ℤ)))
            (d + 1)]
      simp only [Nat.cast_zero, neg_zero, zero_mul, add_zero]
      refine Finset.sum_congr rfl fun j _ => ?_
      have h1 : (j + 1 : ℕ) - 1 = j := by omega
      rw [h1]
      push_cast
      rw [show ((j : ℤ) + 1 + 1) = (j : ℤ) + 2 from by ring]
      ring
  rw [key] at hprod
  exact hprod

/-- **`iteratedDeriv d` of `2^x/x` IS `F d`, on `(0,∞)`.** Induction; the step
replaces `iteratedDeriv d f2x` by `F d` through `EventuallyEq.deriv_eq` on the
open half-line, then advances by `hasDerivAt_F`. -/
theorem iteratedDeriv_f2x (d : ℕ) :
    ∀ x ∈ Ioi (0 : ℝ), iteratedDeriv d f2x x = F d x := by
  induction d with
  | zero =>
      intro x _
      rw [iteratedDeriv_zero, F_zero]
  | succ n ih =>
      intro x hx
      rw [iteratedDeriv_succ]
      have hev : iteratedDeriv n f2x =ᶠ[nhds x] F n :=
        Filter.eventuallyEq_of_mem (Ioi_mem_nhds hx) ih
      rw [hev.deriv_eq]
      exact (hasDerivAt_F n (ne_of_gt hx)).deriv

/-! ## The floor -/

/-- The unsigned term of `S`. -/
def t (d j : ℕ) (x : ℝ) : ℝ :=
  (d.choose j) * Real.log 2 ^ (d - j) * (j.factorial) * x ^ (-(j + 1 : ℤ))

/-- Every unsigned term is nonnegative on `x > 0`. -/
theorem t_nonneg {d j : ℕ} {x : ℝ} (hx : 0 < x) : 0 ≤ t d j x := by
  unfold t
  have := Real.log_nonneg (by norm_num : (1:ℝ) ≤ 2)
  have : (0:ℝ) < x ^ (-(j + 1 : ℤ)) := by
    rw [zpow_neg]; positivity
  positivity

/-- `S` is the alternating sum of the unsigned terms. -/
theorem S_eq_alt (d : ℕ) (x : ℝ) :
    S d x = ∑ j ∈ range (d + 1), (-1 : ℝ) ^ j * t d j x := by
  unfold S c t
  exact Finset.sum_congr rfl fun j _ => by ring

/-- The choose-ratio identity, in ℕ where it is clean:
`C(d,j+1)·(j+1)! = C(d,j)·j!·(d−j)`. -/
theorem choose_factorial_step (d j : ℕ) :
    d.choose (j + 1) * (j + 1).factorial = d.choose j * j.factorial * (d - j) := by
  rw [Nat.factorial_succ, ← Nat.mul_assoc,
      show d.choose (j + 1) * (j + 1) = d.choose j * (d - j) from Nat.choose_succ_right_eq d j]
  ring

/-- **The terms halve** in the wedge `2d ≤ (log 2)·x`: `t (j+1) ≤ t j / 2`. -/
theorem t_halves {d : ℕ} {x : ℝ} (hx : 0 < x) (hw : 2 * (d : ℝ) ≤ Real.log 2 * x)
    (j : ℕ) : t d (j + 1) x ≤ t d j x / 2 := by
  rcases Nat.lt_or_ge j d with hlt | hge
  · -- inside the triangle
    have hlogpos : (0 : ℝ) < Real.log 2 := Real.log_pos (by norm_num)
    have hxz2 : (0 : ℝ) < x ^ (-(j + 2 : ℤ)) := by rw [zpow_neg]; positivity
    -- rewrite both sides over the common factor A = C(d,j)·j!·(log2)^(d−j−1)
    have hA : (0 : ℝ) ≤ (d.choose j) * (j.factorial) * Real.log 2 ^ (d - (j + 1)) := by
      positivity
    have hexp : Real.log 2 ^ (d - j) = Real.log 2 ^ (d - (j + 1)) * Real.log 2 := by
      rw [← pow_succ]
      congr 1
      omega
    have hzsplit : x ^ (-(j + 1 : ℤ)) = x ^ (-(j + 2 : ℤ)) * x := by
      rw [← zpow_add_one₀ (ne_of_gt hx)]
      congr 1
    have hchoose : ((d.choose (j + 1) * (j + 1).factorial : ℕ) : ℝ)
        = (d.choose j * j.factorial : ℕ) * ((d - j : ℕ) : ℝ) := by
      rw [choose_factorial_step]
      push_cast
      ring
    have hdj : ((d - j : ℕ) : ℝ) ≤ (d : ℝ) := by
      have : d - j ≤ d := Nat.sub_le d j
      exact_mod_cast this
    have hcc : (d.choose (j + 1) : ℝ) * ((j + 1).factorial)
        = ((d.choose j) * (j.factorial)) * ((d - j : ℕ) : ℝ) := by
      exact_mod_cast hchoose
    have Lval : t d (j + 1) x
        = ((d.choose j) * (j.factorial) * Real.log 2 ^ (d - (j + 1)))
          * (((d - j : ℕ) : ℝ) * x ^ (-(j + 2 : ℤ))) := by
      unfold t
      rw [show (-((↑(j + 1) : ℤ) + 1)) = -((j : ℤ) + 2) from by push_cast; ring]
      linear_combination (Real.log 2 ^ (d - (j + 1)) * x ^ (-(j + 2 : ℤ))) * hcc
    have Rval : t d j x / 2
        = ((d.choose j) * (j.factorial) * Real.log 2 ^ (d - (j + 1)))
          * (Real.log 2 * x / 2 * x ^ (-(j + 2 : ℤ))) := by
      unfold t
      rw [hexp, hzsplit]
      ring
    rw [Lval, Rval]
    apply mul_le_mul_of_nonneg_left _ hA
    apply mul_le_mul_of_nonneg_right _ hxz2.le
    linarith [hdj, hw]
  · -- past the diagonal: the next term is zero
    unfold t
    rw [Nat.choose_eq_zero_of_lt (by omega)]
    have h0 : (0 : ℝ) ≤ (d.choose j) * Real.log 2 ^ (d - j) * (j.factorial)
        * x ^ (-(j + 1 : ℤ)) := by
      have := Real.log_nonneg (by norm_num : (1:ℝ) ≤ 2)
      have : (0:ℝ) < x ^ (-(j + 1 : ℤ)) := by rw [zpow_neg]; positivity
      positivity
    simp only [Nat.cast_zero, zero_mul]
    linarith

/-- The downward tail `B k = Σ_{j<d+1−k} (−1)^j t(k+j)`. -/
def B (d : ℕ) (x : ℝ) (k : ℕ) : ℝ :=
  ∑ j ∈ range (d + 1 - k), (-1 : ℝ) ^ j * t d (k + j) x

/-- Peeling the head of the tail: `B k = t k − B (k+1)` for `k ≤ d`. -/
theorem B_peel {d : ℕ} {x : ℝ} {k : ℕ} (hk : k ≤ d) :
    B d x k = t d k x - B d x (k + 1) := by
  unfold B
  have hm : d + 1 - k = (d - k) + 1 := by omega
  have hm2 : d + 1 - (k + 1) = d - k := by omega
  rw [hm, hm2, Finset.sum_range_succ' (fun j => (-1 : ℝ) ^ j * t d (k + j) x) (d - k)]
  have head : (-1 : ℝ) ^ 0 * t d (k + 0) x = t d k x := by simp
  rw [head]
  have shift : ∑ j ∈ range (d - k), (-1 : ℝ) ^ (j + 1) * t d (k + (j + 1)) x
      = -∑ j ∈ range (d - k), (-1 : ℝ) ^ j * t d ((k + 1) + j) x := by
    rw [← Finset.sum_neg_distrib]
    refine Finset.sum_congr rfl fun j _ => ?_
    rw [show k + (j + 1) = (k + 1) + j by omega, pow_succ]
    ring
  rw [shift]
  ring

/-- **The tail bound `0 ≤ B k ≤ t k`**, by downward induction on the tail
length, using only that the terms halve. -/
theorem B_bounds {d : ℕ} {x : ℝ} (hx : 0 < x) (hw : 2 * (d : ℝ) ≤ Real.log 2 * x) :
    ∀ m k, k + m = d → 0 ≤ B d x k ∧ B d x k ≤ t d k x := by
  intro m
  induction m with
  | zero =>
      intro k hk
      have hkd : k = d := by omega
      subst hkd
      have hB : B k x k = t k k x := by
        unfold B
        rw [show k + 1 - k = 1 by omega]
        simp
      rw [hB]
      exact ⟨t_nonneg hx, le_refl _⟩
  | succ n ih =>
      intro k hk
      have hkd : k ≤ d := by omega
      have hnext := ih (k + 1) (by omega)
      obtain ⟨h0, h1⟩ := hnext
      have hpeel := B_peel (d := d) (x := x) hkd
      have hhalf := t_halves hx hw k
      constructor
      · rw [hpeel]
        have : t d (k + 1) x ≤ t d k x :=
          hhalf.trans (by linarith [t_nonneg (d := d) (j := k) hx])
        linarith
      · rw [hpeel]
        linarith

/-- The leading term: `t 0 = (log 2)^d / x`. -/
theorem t_zero (d : ℕ) (x : ℝ) : t d 0 x = Real.log 2 ^ d * x⁻¹ := by
  unfold t
  simp [zpow_neg]

/-- **The floor on `S`:** in the wedge, `S d x ≥ t₀/2 = (log 2)^d/(2x)`. -/
theorem S_floor {d : ℕ} {x : ℝ} (hx : 0 < x) (hw : 2 * (d : ℝ) ≤ Real.log 2 * x) :
    Real.log 2 ^ d / (2 * x) ≤ S d x := by
  have hSB : S d x = B d x 0 := by
    unfold B
    rw [S_eq_alt]
    simp
  have hfloor : Real.log 2 ^ d / (2 * x) = t d 0 x / 2 := by
    rw [t_zero]
    field_simp
  rw [hSB, hfloor]
  rcases Nat.eq_zero_or_pos d with hd0 | hdpos
  · -- d = 0: the sum is the single term t₀
    subst hd0
    have hB : B 0 x 0 = t 0 0 x := by
      unfold B
      simp
    rw [hB]
    have := t_nonneg (d := 0) (j := 0) hx
    linarith
  · -- d ≥ 1: peel, bound the tail by t₁, and halve
    rw [B_peel (Nat.zero_le d)]
    have htail := (B_bounds hx hw (d - 1) 1 (by omega)).2
    have hhalf := t_halves hx hw 0
    linarith

/-- The full floor on the closed form: `F d x ≥ (1/2)·2^x·(log 2)^d/x`. -/
theorem F_floor {d : ℕ} {x : ℝ} (hx : 0 < x) (hw : 2 * (d : ℝ) ≤ Real.log 2 * x) :
    (2 : ℝ) ^ x * (Real.log 2 ^ d / (2 * x)) ≤ F d x := by
  unfold F
  rw [exp_eq_rpow]
  exact mul_le_mul_of_nonneg_left (S_floor hx hw)
    (Real.rpow_nonneg (by norm_num) x)

/-- **`hD` discharged.** On the window `[r−(d+1), r]` with the window bottom
positive and the wedge holding there, the `(d+1)`-th derivative of any smooth
interpolant whose derivative is `2^x/x` on `(0,∞)` clears `Mlow`. The chain:
`iteratedDeriv (d+1) G = iteratedDeriv d (2^x/x) = F d ≥ floor ≥ Mlow`. -/
theorem hD_of_window {G : ℝ → ℝ} {r : ℤ} {d : ℕ}
    (hG' : ∀ x ∈ Ioi ((1 : ℝ) / 2), HasDerivAt G (f2x x) x)
    (hbot : (1 : ℝ) ≤ (r : ℝ) - (d + 1))
    (hw : 2 * (d : ℝ) ≤ Real.log 2 * ((r : ℝ) - (d + 1))) :
    ∀ y ∈ Icc ((r : ℝ) - (d + 1)) r,
      Nonvanishing.Mlow r d ≤ iteratedDeriv (d + 1) G y := by
  intro y hy
  obtain ⟨hy1, hy2⟩ := hy
  have hypos : (0 : ℝ) < y := by linarith
  have hrpos : (0 : ℝ) < (r : ℝ) := by linarith
  -- iteratedDeriv (d+1) G = iteratedDeriv d f2x on (0,∞)
  have hstep : iteratedDeriv (d + 1) G y = iteratedDeriv d f2x y := by
    rw [iteratedDeriv_succ']
    have hev : ∀ x ∈ Ioi ((1 : ℝ) / 2), deriv G x = f2x x := fun x hx =>
      (hG' x hx).deriv
    -- congr of iteratedDeriv on the open half-line, by induction
    have congr_on : ∀ (n : ℕ) (u v : ℝ → ℝ),
        (∀ x ∈ Ioi ((1 : ℝ) / 2), u x = v x) →
        ∀ x ∈ Ioi ((1 : ℝ) / 2), iteratedDeriv n u x = iteratedDeriv n v x := by
      intro n
      induction n with
      | zero => intro u v h x hx; simpa using h x hx
      | succ m ih =>
          intro u v h x hx
          rw [iteratedDeriv_succ, iteratedDeriv_succ]
          have hev2 : iteratedDeriv m u =ᶠ[nhds x] iteratedDeriv m v :=
            Filter.eventuallyEq_of_mem (Ioi_mem_nhds hx) (ih u v h)
          exact hev2.deriv_eq
    exact congr_on d (deriv G) f2x hev y (by show (1 : ℝ) / 2 < y; linarith)
  rw [hstep, iteratedDeriv_f2x d y (by exact hypos)]
  -- the wedge transports from the window bottom to y (both sides of it grow)
  have hwy : 2 * (d : ℝ) ≤ Real.log 2 * y := by
    have hlog : (0 : ℝ) < Real.log 2 := Real.log_pos (by norm_num)
    nlinarith [hlog]
  have hF := F_floor hypos hwy
  -- compare the floor at y with Mlow at (r, d)
  have hlogpow : (0 : ℝ) ≤ Real.log 2 ^ d :=
    pow_nonneg (Real.log_nonneg (by norm_num)) d
  have hcmp : Nonvanishing.Mlow r d ≤ (2 : ℝ) ^ y * (Real.log 2 ^ d / (2 * y)) := by
    unfold Nonvanishing.Mlow
    have h2y : (2 : ℝ) ^ ((r : ℝ) - d - 1) ≤ (2 : ℝ) ^ y := by
      apply Real.rpow_le_rpow_left_iff (by norm_num : (1:ℝ) < 2) |>.mpr
      linarith
    have hinv : (1 : ℝ) / (2 * (r : ℝ)) ≤ 1 / (2 * y) := by
      apply one_div_le_one_div_of_le
      · linarith
      · linarith
    calc (1 / 2) * (2 : ℝ) ^ ((r : ℝ) - d - 1) * Real.log 2 ^ d / r
        = (2 : ℝ) ^ ((r : ℝ) - d - 1) * (Real.log 2 ^ d * (1 / (2 * (r : ℝ)))) := by
          field_simp
      _ ≤ (2 : ℝ) ^ y * (Real.log 2 ^ d * (1 / (2 * y))) := by
          apply mul_le_mul h2y _ _ (Real.rpow_nonneg (by norm_num) y)
          · exact mul_le_mul_of_nonneg_left hinv hlogpow
          · positivity
      _ = (2 : ℝ) ^ y * (Real.log 2 ^ d / (2 * y)) := by ring
  linarith

/-- **O67's conditional theorem, with the analysis discharged.** The
hypotheses are now exactly: the interpolant and its derivative structure (what
"li" means here), Schoenfeld on the window (stage 3), the row agreement, the
gap arithmetic, and the wedge/positivity arithmetic. The MVT, the alternating
series, the expansion of `2^x/x` — all under the kernel. -/
theorem tableFrom_ne_zero_of_li {N : ℤ → ℤ} {f : ℤ → ℝ} {G : ℝ → ℝ} {r : ℤ} {d : ℕ}
    (hG : ContDiff ℝ (⊤ : ℕ∞) G)
    (hG' : ∀ x ∈ Ioi ((1 : ℝ) / 2), HasDerivAt G (f2x x) x)
    (hrow : ∀ k ∈ range (d + 2), ((N (r - k) : ℤ) : ℝ) = Nonvanishing.bdiffZ f (r - k))
    (hr : ((d + 1 : ℕ) : ℤ) ≤ r)
    (hS : Nonvanishing.StmtSchoenfeldWindow f (fun k : ℤ => G k) r (d + 1))
    (hbot : (1 : ℝ) ≤ (r : ℝ) - (d + 1))
    (hw : 2 * (d : ℝ) ≤ Real.log 2 * ((r : ℝ) - (d + 1)))
    (hgap : Nonvanishing.Ehigh r (d + 1) < Nonvanishing.Mlow r d) :
    Construction.tableFrom N r d ≠ 0 :=
  MainTerm.tableFrom_ne_zero_of_deriv hG hrow hr hS
    (hD_of_window hG' hbot hw) hgap

end

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'Expansion.exp_eq_rpow' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Expansion.exp_eq_rpow

/-- info: 'Expansion.F_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Expansion.F_zero

/-- info: 'Expansion.c_rec' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Expansion.c_rec

/-- info: 'Expansion.hasDerivAt_S' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Expansion.hasDerivAt_S

/-- info: 'Expansion.hasDerivAt_F' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Expansion.hasDerivAt_F

/-- info: 'Expansion.iteratedDeriv_f2x' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Expansion.iteratedDeriv_f2x

/-- info: 'Expansion.t_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Expansion.t_nonneg

/-- info: 'Expansion.S_eq_alt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Expansion.S_eq_alt

/-- info: 'Expansion.choose_factorial_step' depends on axioms: [propext] -/
#guard_msgs in
#print axioms Expansion.choose_factorial_step

/-- info: 'Expansion.t_halves' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Expansion.t_halves

/-- info: 'Expansion.B_peel' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Expansion.B_peel

/-- info: 'Expansion.B_bounds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Expansion.B_bounds

/-- info: 'Expansion.t_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Expansion.t_zero

/-- info: 'Expansion.S_floor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Expansion.S_floor

/-- info: 'Expansion.F_floor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Expansion.F_floor

/-- info: 'Expansion.hD_of_window' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Expansion.hD_of_window

/-- info: 'Expansion.tableFrom_ne_zero_of_li' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Expansion.tableFrom_ne_zero_of_li

end Expansion
