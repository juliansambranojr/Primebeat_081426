/-
CellResidual — block T5 of `lean_stage3/design/joints.md`, second part. 2026-11-22.

The Riemann hypothesis as the size of the cells. For the dyadic ladder started
at `a`, the rungs are `a·2^m`; the residual of the count on a rung is
`resid a m = π(⌊a·2^m⌋) − Li(a·2^m)`, and the residual of the cell `(r, d)` is
the stencil of order `d + 1` on those: the cell of the count minus the same
cell of the smooth row. `CellsSqrt C r₀` says every cell of every ladder with
`1 ≤ a ≤ 2` has residual at most `C·(1 + 2^(−1/2))^(d+1)·(r+1)·2^(r/2)` from
row `r₀ + (d+1)` on. The theorem: the Riemann hypothesis holds exactly when
some `C`, `r₀` make that true.

One ladder cannot see between its own rungs, so the equivalence is over every
ladder `1 ≤ a ≤ 2`, which together are every `x`. On the table itself
(`a = 1`, `Construction.tableFrom TableRoute.rowN`) the forward direction is
`table_cell_resid`; its converse on that one ladder is joint 10 and is open.

  resid, cellResid, cellSize, CellsSqrt   the definitions above
  stencilR_abs_le          |g(r−k)| ≤ B·t^k on the window ⊢ |stencilR n g r| ≤ B·(1+t)^n
  stencilR_one             stencilR 1 g r = g r − g (r − 1)
  weak_nonneg              StmtSchoenfeldWeak C 1 x₀ π Li ⊢ the same at max C 0, max x₀ 2
  resid_le                 one rung under the π-side bound
  cells_of_schoenfeldWeak  0 ≤ C, 1 ≤ r₀, x₀ ≤ 2^r₀, StmtSchoenfeldWeak C 1 x₀ π Li
                             ⊢ CellsSqrt (C·√2·log 2) r₀
  cells_of_RH              RiemannHypothesis ⊢ ∃ C r₀, CellsSqrt C r₀
  step_le                  CellsSqrt C r₀, r₀ + 1 ≤ r ⊢ |resid a r − resid a (r−1)| ≤ C·cellSize r 0
  ladder_le                the depth-0 cells summed up one ladder
  base_bound               the first rung, bounded over 1 ≤ a ≤ 2
  schoenfeldWeak_of_cells  CellsSqrt C r₀ ⊢ ∃ C' x₁, StmtSchoenfeldWeak C' 1 x₁ π Li
  RH_iff_cells             RiemannHypothesis ↔ ∃ C r₀, CellsSqrt C r₀
  tableFrom_cast           the integer cell, cast, is the stencil of the count
  table_cell_eq            the table's cell minus the smooth cell is cellResid 1 r d
  table_cell_resid         RiemannHypothesis ⊢ ∃ C r₀, every cell of the table past
                             row r₀ + (d+1) is within C·cellSize r d of the smooth cell

Sizes. The converse uses depth `0` only: `|g(r) − g(r−1)| ≤ D·(r+1)·2^(r/2)`
summed from the first rung, with `4·N ≤ 3·(N+1)·√2`, gives
`|g(r)| ≤ M + 4D·(r+1)·2^(r/2)`; then `2^(r/2) ≤ √x`, `r + 1 ≤ 3·log x`,
`1 ≤ √x·log x`.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.PiToPsi
import Stage3.TableRoute

namespace CellResidual

open Finset Nonvanishing Stage3

noncomputable section

/-- The residual of the count on the rung `a·2^m`. -/
def resid (a : ℝ) (m : ℤ) : ℝ :=
  (Nat.primeCounting ⌊a * (2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ) - Stage3.Li (a * (2 : ℝ) ^ (m : ℝ))

/-- The residual of the cell `(r, d)` on the ladder started at `a`. -/
def cellResid (a : ℝ) (r : ℤ) (d : ℕ) : ℝ := stencilR (d + 1) (resid a) r

/-- Square-root size at the cell `(r, d)`. -/
def cellSize (r : ℤ) (d : ℕ) : ℝ :=
  (1 + (2 : ℝ) ^ (-(1 : ℝ) / 2)) ^ (d + 1) * ((r : ℝ) + 1) * (2 : ℝ) ^ ((r : ℝ) / 2)

/-- Every cell of every dyadic ladder has its residual at square-root size. -/
def CellsSqrt (C : ℝ) (r₀ : ℤ) : Prop :=
  ∀ a ∈ Set.Icc (1 : ℝ) 2, ∀ (d : ℕ) (r : ℤ), r₀ + ((d + 1 : ℕ) : ℤ) ≤ r →
    |cellResid a r d| ≤ C * cellSize r d

/-- **A cell is no larger than its window allows.** If the values the stencil reads shrink by a factor `t` per step down the window, the cell is at most the top bound times `(1 + t)^n`. -/
theorem stencilR_abs_le {g : ℤ → ℝ} {r : ℤ} {n : ℕ} {B t : ℝ}
    (h : ∀ k ∈ range (n + 1), |g (r - k)| ≤ B * t ^ k) :
    |stencilR n g r| ≤ B * (1 + t) ^ n := by
  unfold stencilR
  calc |∑ k ∈ range (n + 1), (-1 : ℝ) ^ k * (n.choose k) * g (r - k)|
      ≤ ∑ k ∈ range (n + 1), |(-1 : ℝ) ^ k * (n.choose k) * g (r - k)| :=
        Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ k ∈ range (n + 1), (n.choose k : ℝ) * (B * t ^ k) := by
        refine Finset.sum_le_sum fun k hk => ?_
        rw [abs_mul, abs_mul, abs_pow, abs_neg, abs_one, one_pow, one_mul, Nat.abs_cast]
        exact mul_le_mul_of_nonneg_left (h k hk) (Nat.cast_nonneg _)
    _ = B * ∑ k ∈ range (n + 1), (n.choose k : ℝ) * t ^ k := by
        rw [Finset.mul_sum]
        exact Finset.sum_congr rfl fun k _ => by ring
    _ = _ := by
        congr 1
        rw [add_comm (1 : ℝ), add_pow]
        exact Finset.sum_congr rfl fun k hk => by
          rw [one_pow, mul_one, mul_comm]

/-- The stencil of order one is one backward difference. -/
theorem stencilR_one (g : ℤ → ℝ) (r : ℤ) : stencilR 1 g r = g r - g (r - 1) := by
  rw [← iter_bdiffZ_eq_stencilR]
  rfl

/-- The square-root bound on the count may be taken with a constant that is not negative and a starting point of at least two. -/
theorem weak_nonneg {C x₀ : ℝ}
    (h : StmtSchoenfeldWeak C 1 x₀ (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li) :
    StmtSchoenfeldWeak (max C 0) 1 (max x₀ 2)
      (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li := by
  intro x hx
  have hx2 : (2 : ℝ) ≤ x := le_trans (le_max_right _ _) hx
  have hs0 : 0 ≤ Real.sqrt x := Real.sqrt_nonneg x
  have hL0 : 0 ≤ Real.log x ^ 1 := pow_nonneg (Real.log_nonneg (by linarith)) 1
  refine le_trans (h x (le_trans (le_max_left _ _) hx)) ?_
  exact mul_le_mul_of_nonneg_right
    (mul_le_mul_of_nonneg_right (le_max_left C 0) hs0) hL0

/-- **One rung.** Under the square-root bound on the count, the residual on the rung `a·2^m` is at most a constant times `(m + 1)·2^(m/2)`. -/
theorem resid_le {C x₀ a : ℝ} {m : ℤ} (hC : 0 ≤ C) (ha : a ∈ Set.Icc (1 : ℝ) 2)
    (hm : 1 ≤ m) (hx₀ : x₀ ≤ (2 : ℝ) ^ (m : ℝ))
    (h : StmtSchoenfeldWeak C 1 x₀ (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li) :
    |resid a m| ≤ (C * Real.sqrt 2 * Real.log 2) * (((m : ℝ) + 1) * (2 : ℝ) ^ ((m : ℝ) / 2)) := by
  have hp : (0 : ℝ) < (2 : ℝ) ^ (m : ℝ) := Real.rpow_pos_of_pos (by norm_num) _
  have hm1 : (1 : ℝ) ≤ (m : ℝ) := by exact_mod_cast hm
  have hp1 : (1 : ℝ) ≤ (2 : ℝ) ^ (m : ℝ) := Real.one_le_rpow (by norm_num) (by linarith)
  have hx : x₀ ≤ a * (2 : ℝ) ^ (m : ℝ) := le_trans hx₀ (le_mul_of_one_le_left hp.le ha.1)
  have hb := h (a * (2 : ℝ) ^ (m : ℝ)) hx
  rw [pow_one] at hb
  have hsq : Real.sqrt (a * (2 : ℝ) ^ (m : ℝ)) ≤ Real.sqrt 2 * (2 : ℝ) ^ ((m : ℝ) / 2) := by
    have e : Real.sqrt ((2 : ℝ) ^ (m : ℝ)) = (2 : ℝ) ^ ((m : ℝ) / 2) := by
      rw [Real.sqrt_eq_rpow, ← Real.rpow_mul (by norm_num)]
      congr 1
      ring
    rw [← e, ← Real.sqrt_mul (by norm_num)]
    exact Real.sqrt_le_sqrt (mul_le_mul_of_nonneg_right ha.2 hp.le)
  have hlog : Real.log (a * (2 : ℝ) ^ (m : ℝ)) ≤ ((m : ℝ) + 1) * Real.log 2 := by
    have h2 : Real.log (2 * (2 : ℝ) ^ (m : ℝ)) = ((m : ℝ) + 1) * Real.log 2 := by
      rw [Real.log_mul (by norm_num) hp.ne', Real.log_rpow (by norm_num)]
      ring
    rw [← h2]
    exact Real.log_le_log (mul_pos (by linarith [ha.1]) hp)
      (mul_le_mul_of_nonneg_right ha.2 hp.le)
  have hlog0 : 0 ≤ Real.log (a * (2 : ℝ) ^ (m : ℝ)) :=
    Real.log_nonneg (one_le_mul_of_one_le_of_one_le ha.1 hp1)
  have hpos : 0 ≤ C * (Real.sqrt 2 * (2 : ℝ) ^ ((m : ℝ) / 2)) :=
    mul_nonneg hC (mul_nonneg (Real.sqrt_nonneg 2) (Real.rpow_nonneg (by norm_num) _))
  unfold resid
  calc |(Nat.primeCounting ⌊a * (2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ) - Stage3.Li (a * (2 : ℝ) ^ (m : ℝ))|
      ≤ C * Real.sqrt (a * (2 : ℝ) ^ (m : ℝ)) * Real.log (a * (2 : ℝ) ^ (m : ℝ)) := hb
    _ ≤ C * (Real.sqrt 2 * (2 : ℝ) ^ ((m : ℝ) / 2)) * (((m : ℝ) + 1) * Real.log 2) :=
        mul_le_mul (mul_le_mul_of_nonneg_left hsq hC) hlog hlog0 hpos
    _ = _ := by ring

/-- **Forward.** The `π`-side bound gives every cell of every ladder. -/
theorem cells_of_schoenfeldWeak {C x₀ : ℝ} {r₀ : ℤ} (hC : 0 ≤ C) (hr₀ : 1 ≤ r₀)
    (hx₀ : x₀ ≤ (2 : ℝ) ^ (r₀ : ℝ))
    (h : StmtSchoenfeldWeak C 1 x₀ (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li) :
    CellsSqrt (C * Real.sqrt 2 * Real.log 2) r₀ := by
  intro a ha d r hr
  have hK : 0 ≤ C * Real.sqrt 2 * Real.log 2 :=
    mul_nonneg (mul_nonneg hC (Real.sqrt_nonneg 2)) (Real.log_nonneg (by norm_num))
  have hterm : ∀ k ∈ range (d + 1 + 1), |resid a (r - k)|
      ≤ ((C * Real.sqrt 2 * Real.log 2) * (((r : ℝ) + 1) * (2 : ℝ) ^ ((r : ℝ) / 2)))
        * ((2 : ℝ) ^ (-(1 : ℝ) / 2)) ^ k := by
    intro k hk
    have hkd : k ≤ d + 1 := Nat.lt_succ_iff.mp (Finset.mem_range.mp hk)
    have hm : r₀ ≤ r - (k : ℤ) := by omega
    have hm1 : 1 ≤ r - (k : ℤ) := by omega
    have hx : x₀ ≤ (2 : ℝ) ^ (((r - (k : ℤ) : ℤ)) : ℝ) :=
      le_trans hx₀ (Real.rpow_le_rpow_of_exponent_le (by norm_num) (by exact_mod_cast hm))
    refine le_trans (resid_le hC ha hm1 hx h) ?_
    have hsplit : (2 : ℝ) ^ ((((r - (k : ℤ) : ℤ)) : ℝ) / 2)
        = (2 : ℝ) ^ ((r : ℝ) / 2) * ((2 : ℝ) ^ (-(1 : ℝ) / 2)) ^ k := by
      rw [← Real.rpow_natCast ((2 : ℝ) ^ (-(1 : ℝ) / 2)) k, ← Real.rpow_mul (by norm_num),
        ← Real.rpow_add (by norm_num)]
      congr 1
      push_cast
      ring
    rw [hsplit]
    have hlin : ((((r - (k : ℤ) : ℤ)) : ℝ)) + 1 ≤ (r : ℝ) + 1 := by
      push_cast
      linarith [(Nat.cast_nonneg k : (0 : ℝ) ≤ (k : ℝ))]
    have hpos : 0 ≤ (2 : ℝ) ^ ((r : ℝ) / 2) * ((2 : ℝ) ^ (-(1 : ℝ) / 2)) ^ k := by positivity
    calc (C * Real.sqrt 2 * Real.log 2)
          * (((((r - (k : ℤ) : ℤ)) : ℝ) + 1)
            * ((2 : ℝ) ^ ((r : ℝ) / 2) * ((2 : ℝ) ^ (-(1 : ℝ) / 2)) ^ k))
        ≤ (C * Real.sqrt 2 * Real.log 2)
          * (((r : ℝ) + 1) * ((2 : ℝ) ^ ((r : ℝ) / 2) * ((2 : ℝ) ^ (-(1 : ℝ) / 2)) ^ k)) :=
          mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_right hlin hpos) hK
      _ = _ := by ring
  have key := stencilR_abs_le hterm
  unfold cellResid cellSize
  refine le_trans key (le_of_eq ?_)
  ring

/-- **Forward, from the Riemann hypothesis.** Under it every cell of every dyadic ladder has its residual at square-root size. -/
theorem cells_of_RH (hRH : RiemannHypothesis) : ∃ (C : ℝ) (r₀ : ℤ), CellsSqrt C r₀ := by
  obtain ⟨C, x₀, h⟩ := PiToPsi.RH_iff_schoenfeldWeak.mp hRH
  obtain ⟨n, hn⟩ := pow_unbounded_of_one_lt (max x₀ 2) (by norm_num : (1 : ℝ) < 2)
  refine ⟨_, (n : ℤ) + 1,
    cells_of_schoenfeldWeak (le_max_right C 0) (by omega) ?_ (weak_nonneg h)⟩
  calc max x₀ 2 ≤ (2 : ℝ) ^ n := hn.le
    _ = (2 : ℝ) ^ (n : ℝ) := (Real.rpow_natCast 2 n).symm
    _ ≤ (2 : ℝ) ^ ((((n : ℤ) + 1 : ℤ)) : ℝ) :=
        Real.rpow_le_rpow_of_exponent_le (by norm_num) (by push_cast; linarith)

/-- A depth-0 cell is the difference of two neighbouring rungs, so `CellsSqrt` bounds that difference. -/
theorem step_le {C : ℝ} {r₀ : ℤ} (h : CellsSqrt C r₀) {a : ℝ} (ha : a ∈ Set.Icc (1 : ℝ) 2)
    {r : ℤ} (hr : r₀ + 1 ≤ r) :
    |resid a r - resid a (r - 1)| ≤ C * cellSize r 0 := by
  have h0 := h a ha 0 r (by simpa using hr)
  unfold cellResid at h0
  rwa [stencilR_one] at h0

/-- The square root of two is at least four thirds; the telescoping sum closes on this. -/
theorem two_rpow_half_ge : (4 : ℝ) / 3 ≤ (2 : ℝ) ^ ((1 : ℝ) / 2) := by
  have hq : (0 : ℝ) < (2 : ℝ) ^ ((1 : ℝ) / 2) := Real.rpow_pos_of_pos (by norm_num) _
  have hq2 : (2 : ℝ) ^ ((1 : ℝ) / 2) * (2 : ℝ) ^ ((1 : ℝ) / 2) = 2 := by
    rw [← Real.rpow_add (by norm_num)]
    norm_num
  by_contra hlt
  have hlt' : (2 : ℝ) ^ ((1 : ℝ) / 2) < 4 / 3 := lt_of_not_ge hlt
  nlinarith

/-- **The depth-0 cells, summed up one ladder.** -/
theorem ladder_le {C : ℝ} {r₀ : ℤ} (hr₀ : 0 ≤ r₀) (h : CellsSqrt C r₀) {a : ℝ}
    (ha : a ∈ Set.Icc (1 : ℝ) 2) {M : ℝ} (hM : |resid a r₀| ≤ M) (n : ℕ) :
    |resid a (r₀ + (n : ℤ))|
      ≤ M + 4 * (|C| * (1 + (2 : ℝ) ^ (-(1 : ℝ) / 2))) * ((r₀ : ℝ) + n + 1)
          * (2 : ℝ) ^ (((r₀ : ℝ) + n) / 2) := by
  have hr0 : (0 : ℝ) ≤ (r₀ : ℝ) := by exact_mod_cast hr₀
  have hD : 0 ≤ |C| * (1 + (2 : ℝ) ^ (-(1 : ℝ) / 2)) := by positivity
  induction n with
  | zero =>
      have hu : 0 ≤ (2 : ℝ) ^ (((r₀ : ℝ) + ((0 : ℕ) : ℝ)) / 2) :=
        Real.rpow_nonneg (by norm_num) _
      have hnn : 0 ≤ 4 * (|C| * (1 + (2 : ℝ) ^ (-(1 : ℝ) / 2))) * ((r₀ : ℝ) + ((0 : ℕ) : ℝ) + 1)
          * (2 : ℝ) ^ (((r₀ : ℝ) + ((0 : ℕ) : ℝ)) / 2) := by
        have : (0 : ℝ) ≤ (r₀ : ℝ) + ((0 : ℕ) : ℝ) + 1 := by push_cast; linarith
        positivity
      have e : r₀ + ((0 : ℕ) : ℤ) = r₀ := by simp
      rw [e]
      linarith
  | succ n ih =>
      have hrr : r₀ + 1 ≤ r₀ + ((n + 1 : ℕ) : ℤ) := by push_cast; omega
      have hprev : r₀ + ((n + 1 : ℕ) : ℤ) - 1 = r₀ + (n : ℤ) := by push_cast; ring
      have hstep := step_le h ha hrr
      rw [hprev] at hstep
      have hu : 0 < (2 : ℝ) ^ (((r₀ : ℝ) + n) / 2) := Real.rpow_pos_of_pos (by norm_num) _
      have hsplit : (2 : ℝ) ^ (((r₀ : ℝ) + ((n + 1 : ℕ) : ℝ)) / 2)
          = (2 : ℝ) ^ ((1 : ℝ) / 2) * (2 : ℝ) ^ (((r₀ : ℝ) + n) / 2) := by
        rw [← Real.rpow_add (by norm_num)]
        congr 1
        push_cast
        ring
      have hsize : cellSize (r₀ + ((n + 1 : ℕ) : ℤ)) 0
          = (1 + (2 : ℝ) ^ (-(1 : ℝ) / 2)) * ((r₀ : ℝ) + n + 1 + 1)
            * ((2 : ℝ) ^ ((1 : ℝ) / 2) * (2 : ℝ) ^ (((r₀ : ℝ) + n) / 2)) := by
        unfold cellSize
        rw [← hsplit]
        push_cast
        ring
      have hCle : C * cellSize (r₀ + ((n + 1 : ℕ) : ℤ)) 0
          ≤ |C| * cellSize (r₀ + ((n + 1 : ℕ) : ℤ)) 0 := by
        refine mul_le_mul_of_nonneg_right (le_abs_self C) ?_
        rw [hsize]
        have : (0 : ℝ) ≤ (r₀ : ℝ) + n + 1 + 1 := by positivity
        positivity
      have htri : |resid a (r₀ + ((n + 1 : ℕ) : ℤ))|
          ≤ |resid a (r₀ + (n : ℤ))|
            + |resid a (r₀ + ((n + 1 : ℕ) : ℤ)) - resid a (r₀ + (n : ℤ))| := by
        have := abs_add_le (resid a (r₀ + (n : ℤ)))
          (resid a (r₀ + ((n + 1 : ℕ) : ℤ)) - resid a (r₀ + (n : ℤ)))
        simpa using this
      have hq := two_rpow_half_ge
      have hN : (0 : ℝ) ≤ (r₀ : ℝ) + n + 1 := by positivity
      have hkey : 4 * ((r₀ : ℝ) + n + 1)
          ≤ 3 * ((r₀ : ℝ) + n + 1 + 1) * (2 : ℝ) ^ ((1 : ℝ) / 2) := by
        nlinarith [mul_nonneg (by linarith : (0 : ℝ) ≤ (r₀ : ℝ) + n + 1 + 1)
          (sub_nonneg.mpr hq)]
      have hprod := mul_nonneg (mul_nonneg hD hu.le) (sub_nonneg.mpr hkey)
      rw [hsplit]
      have e : M + 4 * (|C| * (1 + (2 : ℝ) ^ (-(1 : ℝ) / 2))) * ((r₀ : ℝ) + ((n + 1 : ℕ) : ℝ) + 1)
            * ((2 : ℝ) ^ ((1 : ℝ) / 2) * (2 : ℝ) ^ (((r₀ : ℝ) + n) / 2))
          - (M + 4 * (|C| * (1 + (2 : ℝ) ^ (-(1 : ℝ) / 2))) * ((r₀ : ℝ) + n + 1)
              * (2 : ℝ) ^ (((r₀ : ℝ) + n) / 2)
            + |C| * ((1 + (2 : ℝ) ^ (-(1 : ℝ) / 2)) * ((r₀ : ℝ) + n + 1 + 1)
              * ((2 : ℝ) ^ ((1 : ℝ) / 2) * (2 : ℝ) ^ (((r₀ : ℝ) + n) / 2))))
          = |C| * (1 + (2 : ℝ) ^ (-(1 : ℝ) / 2)) * (2 : ℝ) ^ (((r₀ : ℝ) + n) / 2)
            * (3 * ((r₀ : ℝ) + n + 1 + 1) * (2 : ℝ) ^ ((1 : ℝ) / 2)
              - 4 * ((r₀ : ℝ) + n + 1)) := by
        push_cast
        ring
      rw [hsize] at hCle hstep
      linarith

/-- The first rung, bounded over the whole range of starting points. -/
theorem base_bound (r₀ : ℤ) (hr₀ : 1 ≤ r₀) :
    ∃ M : ℝ, ∀ a ∈ Set.Icc (1 : ℝ) 2, |resid a r₀| ≤ M := by
  have hr1 : (1 : ℝ) ≤ (r₀ : ℝ) := by exact_mod_cast hr₀
  have hp : (2 : ℝ) ≤ (2 : ℝ) ^ (r₀ : ℝ) := by
    calc (2 : ℝ) = (2 : ℝ) ^ (1 : ℝ) := (Real.rpow_one 2).symm
      _ ≤ (2 : ℝ) ^ (r₀ : ℝ) := Real.rpow_le_rpow_of_exponent_le (by norm_num) hr1
  have hsub : Set.Icc ((2 : ℝ) ^ (r₀ : ℝ)) (2 * (2 : ℝ) ^ (r₀ : ℝ)) ⊆ Set.Ioi 1 := by
    intro y hy
    exact lt_of_lt_of_le (by linarith) hy.1
  obtain ⟨CL, hCL⟩ := isCompact_Icc.exists_bound_of_continuousOn
    (PiToPsi.continuousOn_Li.mono hsub)
  refine ⟨2 * (2 : ℝ) ^ (r₀ : ℝ) + 1 + CL, fun a ha => ?_⟩
  have hy : a * (2 : ℝ) ^ (r₀ : ℝ) ∈ Set.Icc ((2 : ℝ) ^ (r₀ : ℝ)) (2 * (2 : ℝ) ^ (r₀ : ℝ)) :=
    ⟨le_mul_of_one_le_left (by linarith) ha.1,
      mul_le_mul_of_nonneg_right ha.2 (by linarith)⟩
  have hLi := hCL _ hy
  rw [Real.norm_eq_abs] at hLi
  have hy0 : 0 ≤ a * (2 : ℝ) ^ (r₀ : ℝ) := by linarith [hy.1]
  have hpi : (Nat.primeCounting ⌊a * (2 : ℝ) ^ (r₀ : ℝ)⌋₊ : ℝ) ≤ a * (2 : ℝ) ^ (r₀ : ℝ) + 1 := by
    have h1 : Nat.primeCounting ⌊a * (2 : ℝ) ^ (r₀ : ℝ)⌋₊ ≤ ⌊a * (2 : ℝ) ^ (r₀ : ℝ)⌋₊ + 1 :=
      Nat.count_le Nat.Prime
    have h2 : (⌊a * (2 : ℝ) ^ (r₀ : ℝ)⌋₊ : ℝ) ≤ a * (2 : ℝ) ^ (r₀ : ℝ) := Nat.floor_le hy0
    have h3 : (Nat.primeCounting ⌊a * (2 : ℝ) ^ (r₀ : ℝ)⌋₊ : ℝ)
        ≤ (⌊a * (2 : ℝ) ^ (r₀ : ℝ)⌋₊ : ℝ) + 1 := by exact_mod_cast h1
    linarith
  have hpi0 : (0 : ℝ) ≤ (Nat.primeCounting ⌊a * (2 : ℝ) ^ (r₀ : ℝ)⌋₊ : ℝ) := Nat.cast_nonneg _
  unfold resid
  refine le_trans (abs_sub _ _) ?_
  rw [abs_of_nonneg hpi0]
  linarith [hy.2]

/-- **Converse.** The cells at square-root size give the `π`-side bound. -/
theorem schoenfeldWeak_of_cells {C : ℝ} {r₀ : ℤ} (h : CellsSqrt C r₀) :
    ∃ C' x₁ : ℝ,
      StmtSchoenfeldWeak C' 1 x₁ (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li := by
  have hs2 : (2 : ℤ) ≤ max r₀ 2 := le_max_right _ _
  have hs : CellsSqrt C (max r₀ 2) := fun a ha d r hr =>
    h a ha d r (le_trans (by have := le_max_left r₀ 2; omega) hr)
  obtain ⟨M, hM⟩ := base_bound (max r₀ 2) (by omega)
  have hM0 : 0 ≤ M := le_trans (abs_nonneg _) (hM 1 ⟨le_rfl, by norm_num⟩)
  have hD : 0 ≤ |C| * (1 + (2 : ℝ) ^ (-(1 : ℝ) / 2)) := by positivity
  refine ⟨M + 12 * (|C| * (1 + (2 : ℝ) ^ (-(1 : ℝ) / 2))), (2 : ℝ) ^ ((max r₀ 2 : ℤ) : ℝ),
    fun x hx => ?_⟩
  have hsR : (2 : ℝ) ≤ ((max r₀ 2 : ℤ) : ℝ) := by exact_mod_cast hs2
  have hxpos : 0 < x := lt_of_lt_of_le (Real.rpow_pos_of_pos (by norm_num) _) hx
  -- the row of x and its starting point
  have hLs : ((max r₀ 2 : ℤ) : ℝ) ≤ Real.logb 2 x :=
    (Real.le_logb_iff_rpow_le (by norm_num) hxpos).mpr hx
  have hxL : (2 : ℝ) ^ (Real.logb 2 x) = x :=
    Real.rpow_logb (by norm_num) (by norm_num) hxpos
  have hsr : max r₀ 2 ≤ ⌊Real.logb 2 x⌋ := Int.le_floor.mpr hLs
  have hrL : ((⌊Real.logb 2 x⌋ : ℤ) : ℝ) ≤ Real.logb 2 x := Int.floor_le _
  have hLr : Real.logb 2 x < ((⌊Real.logb 2 x⌋ : ℤ) : ℝ) + 1 := Int.lt_floor_add_one _
  have hL2 : (2 : ℝ) ≤ Real.logb 2 x := le_trans hsR hLs
  have hp : (0 : ℝ) < (2 : ℝ) ^ ((⌊Real.logb 2 x⌋ : ℤ) : ℝ) :=
    Real.rpow_pos_of_pos (by norm_num) _
  have hlo : (2 : ℝ) ^ ((⌊Real.logb 2 x⌋ : ℤ) : ℝ) ≤ x := by
    calc (2 : ℝ) ^ ((⌊Real.logb 2 x⌋ : ℤ) : ℝ) ≤ (2 : ℝ) ^ (Real.logb 2 x) :=
          Real.rpow_le_rpow_of_exponent_le (by norm_num) hrL
      _ = x := hxL
  have hhi : x ≤ 2 * (2 : ℝ) ^ ((⌊Real.logb 2 x⌋ : ℤ) : ℝ) := by
    calc x = (2 : ℝ) ^ (Real.logb 2 x) := hxL.symm
      _ ≤ (2 : ℝ) ^ (((⌊Real.logb 2 x⌋ : ℤ) : ℝ) + 1) :=
          Real.rpow_le_rpow_of_exponent_le (by norm_num) hLr.le
      _ = 2 * (2 : ℝ) ^ ((⌊Real.logb 2 x⌋ : ℤ) : ℝ) := by
          rw [Real.rpow_add (by norm_num), Real.rpow_one]
          ring
  have ha : x / (2 : ℝ) ^ ((⌊Real.logb 2 x⌋ : ℤ) : ℝ) ∈ Set.Icc (1 : ℝ) 2 :=
    ⟨(one_le_div hp).mpr hlo, (div_le_iff₀ hp).mpr hhi⟩
  have hax : x / (2 : ℝ) ^ ((⌊Real.logb 2 x⌋ : ℤ) : ℝ) * (2 : ℝ) ^ ((⌊Real.logb 2 x⌋ : ℤ) : ℝ)
      = x := div_mul_cancel₀ _ hp.ne'
  -- up the ladder from the first rung
  have hn : max r₀ 2 + (((⌊Real.logb 2 x⌋ - max r₀ 2).toNat : ℕ) : ℤ) = ⌊Real.logb 2 x⌋ := by
    rw [Int.toNat_of_nonneg (sub_nonneg.mpr hsr)]
    ring
  have hnR : ((max r₀ 2 : ℤ) : ℝ) + (((⌊Real.logb 2 x⌋ - max r₀ 2).toNat : ℕ) : ℝ)
      = ((⌊Real.logb 2 x⌋ : ℤ) : ℝ) := by exact_mod_cast hn
  have hlad := ladder_le (by omega : (0 : ℤ) ≤ max r₀ 2) hs ha (hM _ ha)
    (⌊Real.logb 2 x⌋ - max r₀ 2).toNat
  rw [hn, hnR] at hlad
  unfold resid at hlad
  rw [hax] at hlad
  -- sizes in x
  have hlog2 : (2 : ℝ) / 3 ≤ Real.log 2 := by
    have := Real.log_two_gt_d9
    linarith
  have hlogx : Real.log x = Real.logb 2 x * Real.log 2 := by
    rw [Real.logb, div_mul_cancel₀ _ (Real.log_pos (by norm_num)).ne']
  have hsqrt : Real.sqrt x = (2 : ℝ) ^ (Real.logb 2 x / 2) := by
    rw [Real.sqrt_eq_rpow]
    nth_rewrite 1 [← hxL]
    rw [← Real.rpow_mul (by norm_num)]
    congr 1
    ring
  have hpow : (2 : ℝ) ^ (((⌊Real.logb 2 x⌋ : ℤ) : ℝ) / 2) ≤ Real.sqrt x := by
    rw [hsqrt]
    exact Real.rpow_le_rpow_of_exponent_le (by norm_num) (by linarith)
  have hs2' : (2 : ℝ) ≤ Real.sqrt x := by
    rw [hsqrt]
    calc (2 : ℝ) = (2 : ℝ) ^ (1 : ℝ) := (Real.rpow_one 2).symm
      _ ≤ (2 : ℝ) ^ (Real.logb 2 x / 2) :=
          Real.rpow_le_rpow_of_exponent_le (by norm_num) (by linarith)
  have hLx1 : 1 ≤ Real.log x := by
    rw [hlogx]
    nlinarith
  have hr3 : ((⌊Real.logb 2 x⌋ : ℤ) : ℝ) + 1 ≤ 3 * Real.log x := by
    rw [hlogx]
    nlinarith
  have hr0 : (0 : ℝ) ≤ ((⌊Real.logb 2 x⌋ : ℤ) : ℝ) + 1 := by
    have : (2 : ℝ) ≤ ((⌊Real.logb 2 x⌋ : ℤ) : ℝ) := le_trans hsR (by exact_mod_cast hsr)
    linarith
  have hu0 : (0 : ℝ) ≤ (2 : ℝ) ^ (((⌊Real.logb 2 x⌋ : ℤ) : ℝ) / 2) :=
    Real.rpow_nonneg (by norm_num) _
  have hprod : (((⌊Real.logb 2 x⌋ : ℤ) : ℝ) + 1) * (2 : ℝ) ^ (((⌊Real.logb 2 x⌋ : ℤ) : ℝ) / 2)
      ≤ (3 * Real.log x) * Real.sqrt x :=
    mul_le_mul hr3 hpow hu0 (by linarith)
  have hone : 1 ≤ Real.sqrt x * Real.log x :=
    one_le_mul_of_one_le_of_one_le (by linarith) hLx1
  have hMx : M ≤ M * (Real.sqrt x * Real.log x) := le_mul_of_one_le_right hM0 hone
  have hDx := mul_le_mul_of_nonneg_left hprod hD
  rw [pow_one]
  have e : (M + 12 * (|C| * (1 + (2 : ℝ) ^ (-(1 : ℝ) / 2)))) * Real.sqrt x * Real.log x
      = M * (Real.sqrt x * Real.log x)
        + 4 * ((|C| * (1 + (2 : ℝ) ^ (-(1 : ℝ) / 2))) * ((3 * Real.log x) * Real.sqrt x)) := by
    ring
  rw [e]
  have e2 : 4 * (|C| * (1 + (2 : ℝ) ^ (-(1 : ℝ) / 2))) * (((⌊Real.logb 2 x⌋ : ℤ) : ℝ) + 1)
        * (2 : ℝ) ^ (((⌊Real.logb 2 x⌋ : ℤ) : ℝ) / 2)
      = 4 * ((|C| * (1 + (2 : ℝ) ^ (-(1 : ℝ) / 2)))
        * ((((⌊Real.logb 2 x⌋ : ℤ) : ℝ) + 1) * (2 : ℝ) ^ (((⌊Real.logb 2 x⌋ : ℤ) : ℝ) / 2))) := by
    ring
  rw [e2] at hlad
  linarith

/-- **The Riemann hypothesis is the cells at square-root size**, over every
dyadic ladder. -/
theorem RH_iff_cells : RiemannHypothesis ↔ ∃ (C : ℝ) (r₀ : ℤ), CellsSqrt C r₀ := by
  constructor
  · exact cells_of_RH
  · rintro ⟨C, r₀, h⟩
    obtain ⟨C', x₁, h'⟩ := schoenfeldWeak_of_cells h
    exact PiToPsi.RH_of_schoenfeldWeak h'

/-- The integer cell, cast, is the stencil of the count one order up. -/
theorem tableFrom_cast {N : ℤ → ℤ} {f : ℤ → ℝ} {r : ℤ} {d : ℕ}
    (hrow : ∀ k ∈ range (d + 1), ((N (r - k) : ℤ) : ℝ) = bdiffZ f (r - k)) :
    ((Construction.tableFrom N r d : ℤ) : ℝ) = stencilR (d + 1) f r := by
  rw [← stencilR_row]
  have hcast : ((Construction.tableFrom N r d : ℤ) : ℝ)
      = stencilR d (fun x => ((N x : ℤ) : ℝ)) r := by
    rw [Zeros.tableFrom_eq_stencil, Zeros.stencil, stencilR]
    push_cast
    rfl
  rw [hcast]
  unfold stencilR
  refine Finset.sum_congr rfl fun k hk => ?_
  show (-1 : ℝ) ^ k * (d.choose k) * ((N (r - k) : ℤ) : ℝ) = _
  rw [hrow k hk]

/-- The table's cell minus the smooth cell is the residual on the ladder `a = 1`. -/
theorem table_cell_eq (r : ℤ) (d : ℕ) :
    ((Construction.tableFrom TableRoute.rowN r d : ℤ) : ℝ)
        - stencilR (d + 1) (fun m : ℤ => Stage3.Li ((2 : ℝ) ^ (m : ℝ))) r
      = cellResid 1 r d := by
  have hcast := tableFrom_cast (N := TableRoute.rowN)
    (f := fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ)) (r := r) (d := d)
    (by
      intro k _
      unfold TableRoute.rowN bdiffZ
      push_cast
      rfl)
  rw [hcast, ← stencilR_sub]
  unfold cellResid
  congr 1
  funext m
  unfold resid
  rw [one_mul]

/-- **On the table itself.** Under the Riemann hypothesis every cell of the
dyadic table stays within square-root size of the smooth cell. -/
theorem table_cell_resid (hRH : RiemannHypothesis) :
    ∃ (C : ℝ) (r₀ : ℤ), ∀ (d : ℕ) (r : ℤ), r₀ + ((d + 1 : ℕ) : ℤ) ≤ r →
      |((Construction.tableFrom TableRoute.rowN r d : ℤ) : ℝ)
          - stencilR (d + 1) (fun m : ℤ => Stage3.Li ((2 : ℝ) ^ (m : ℝ))) r|
        ≤ C * cellSize r d := by
  obtain ⟨C, r₀, h⟩ := cells_of_RH hRH
  refine ⟨C, r₀, fun d r hr => ?_⟩
  rw [table_cell_eq]
  exact h 1 ⟨le_rfl, by norm_num⟩ d r hr

/-- info: 'CellResidual.cells_of_schoenfeldWeak' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms cells_of_schoenfeldWeak

/-- info: 'CellResidual.schoenfeldWeak_of_cells' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms schoenfeldWeak_of_cells

/-- info: 'CellResidual.RH_iff_cells' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms RH_iff_cells

/-- info: 'CellResidual.table_cell_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms table_cell_eq

/-- info: 'CellResidual.table_cell_resid' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms table_cell_resid

end

end CellResidual
