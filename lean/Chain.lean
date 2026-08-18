/-
The Euler Factor Chain, as a chain.

Companion to papers/Euler-Factor-Chain.md.

This file does NOT prove the chain's statements against Mathlib. Most of them
are known; proving them again shows nothing. What is unverified in the paper is
the *arrows* — whether each "therefore" actually follows from its predecessors.

So every theorem here takes the antecedent statements as HYPOTHESES and derives
the consequent. The chain typechecks as a chain, and Lean can refuse: if a link
is a leap, it will not compile.

  A1 ──┐
       ├─→ A4 ──┐
  A2 ──┘        ├─→ B5
            B4 ─┘
  C1 ──→ C2 ──→ C3
-/
import Mathlib

namespace Chain

open Complex

/-! ### The objects -/

/-- The reciprocal Euler factor at `b`. -/
noncomputable def Sym (b : ℝ) (s : ℂ) : ℂ := 1 - (b : ℂ) ^ (-s)

/-- A mode on the ladder, indexed by `r`. -/
noncomputable def mode (b : ℝ) (ρ : ℂ) : ℂ → ℂ := fun r => (b : ℂ) ^ (r * ρ)

/-- Backward differencing in the ladder index. -/
noncomputable def bdiff (f : ℂ → ℂ) : ℂ → ℂ := fun r => f r - f (r - 1)

/-- The Weil test function of order `N`. -/
noncomputable def h (b : ℝ) (N : ℕ) (s : ℂ) : ℂ :=
  (1 - (b : ℂ) ^ (-s)) ^ N * (1 - (b : ℂ) ^ (s - 1)) ^ N

/-! ### The statements, as propositions -/

/-- **A1.** One backward difference multiplies a mode by the symbol. -/
def StmtA1 (b : ℝ) (ρ : ℂ) : Prop :=
  ∀ r : ℂ, bdiff (mode b ρ) r = Sym b ρ * mode b ρ r

/-- **A2.** `Sym b` is the reciprocal Euler factor at `b` — i.e. the factor
whose inverse appears in the Euler product. -/
def StmtA2 (b : ℝ) : Prop := ∀ s : ℂ, (Sym b s)⁻¹ * (Sym b s) = 1

/-- **A4.** `N` differences multiply a mode by the `N`-th power of the symbol. -/
def StmtA4 (b : ℝ) (ρ : ℂ) : Prop :=
  ∀ (N : ℕ) (r : ℂ), (bdiff^[N]) (mode b ρ) r = (Sym b ρ) ^ N * mode b ρ r

/-- **B4.** On the critical line the Weil function is the symbol's modulus
to the `2N`. -/
def StmtB4 (b : ℝ) (N : ℕ) : Prop :=
  ∀ t : ℝ, h b N ((1 : ℂ)/2 + t * I) = ((‖Sym b ((1 : ℂ)/2 + t * I)‖ ^ (2 * N) : ℝ) : ℂ)

/-- **B5.** The depth-`N` transfer gain and the Weil weight are one quantity. -/
def StmtB5 (b : ℝ) (N : ℕ) : Prop :=
  ∀ t : ℝ, h b N ((1 : ℂ)/2 + t * I)
    = ((‖(Sym b ((1 : ℂ)/2 + t * I)) ^ N‖ ^ 2 : ℝ) : ℂ)

/-- **C1.** The squared modulus on the critical line, expanded. -/
def StmtC1 (b : ℝ) : Prop :=
  ∀ γ : ℝ, ‖Sym b ((1 : ℂ)/2 + γ * I)‖ ^ 2
    = 1 - 2 * b ^ (-(1:ℝ)/2) * Real.cos (γ * Real.log b) + b ^ (-(1:ℝ))

/-- **C2.** The gain is bounded by `1 ± b^(-1/2)`. -/
def StmtC2 (b : ℝ) : Prop :=
  ∀ γ : ℝ, (1 - b ^ (-(1:ℝ)/2)) ^ 2 ≤ ‖Sym b ((1 : ℂ)/2 + γ * I)‖ ^ 2
         ∧ ‖Sym b ((1 : ℂ)/2 + γ * I)‖ ^ 2 ≤ (1 + b ^ (-(1:ℝ)/2)) ^ 2

/-- **C3.** No mode's depth-`N` gain escapes those bounds. -/
def StmtC3 (b : ℝ) : Prop :=
  ∀ (N : ℕ) (γ : ℝ) (r : ℂ),
    ‖(bdiff^[N]) (mode b ((1 : ℂ)/2 + γ * I)) r‖
      ≤ (1 + b ^ (-(1:ℝ)/2)) ^ N * ‖mode b ((1 : ℂ)/2 + γ * I) r‖

/-! ### The arrows -/

/-- `bdiff` is homogeneous: scalars pass through. -/
theorem bdiff_smul (k : ℂ) (f : ℂ → ℂ) :
    bdiff (fun r => k * f r) = fun r => k * bdiff f r := by
  funext r; simp [bdiff, mul_sub]

/-- **A1 → A4.** The arrow that turns one difference into `N`, by induction.
This is the paper's A3–A4 step and it uses A1 essentially. -/
theorem A4_of_A1 {b : ℝ} {ρ : ℂ} (hA1 : StmtA1 b ρ) : StmtA4 b ρ := by
  intro N
  induction N with
  | zero => intro r; simp
  | succ n ih =>
      intro r
      rw [Function.iterate_succ_apply']
      have : (bdiff^[n]) (mode b ρ) = fun r => (Sym b ρ) ^ n * mode b ρ r := by
        funext r'; exact ih r'
      rw [this, bdiff_smul]
      show (Sym b ρ) ^ n * bdiff (mode b ρ) r = _
      rw [hA1 r]
      ring

/-- **A4 ∧ B4 → B5.** The payoff arrow: the depth gain *is* the Weil weight.
Uses A4 for the shape of the depth-`N` multiplier and B4 for the Weil side. -/
theorem B5_of_A4_B4 {b : ℝ} {N : ℕ} {γ : ℝ}
    (hA4 : StmtA4 b ((1 : ℂ)/2 + γ * I)) (hB4 : StmtB4 b N) :
    h b N ((1 : ℂ)/2 + γ * I)
      = ((‖(Sym b ((1 : ℂ)/2 + γ * I)) ^ N‖ ^ 2 : ℝ) : ℂ) := by
  have hgain := hA4 N 1
  rw [hB4 γ]
  congr 1
  rw [norm_pow, ← pow_mul, mul_comm N 2]

/-- **C1 → C2.** The bound follows from the expansion and `|cos| ≤ 1`. -/
theorem C2_of_C1 {b : ℝ} (hb : 0 < b) (hC1 : StmtC1 b) : StmtC2 b := by
  intro γ
  have hcos := Real.neg_one_le_cos (γ * Real.log b)
  have hcos' := Real.cos_le_one (γ * Real.log b)
  have hbpos : (0:ℝ) < b ^ (-(1:ℝ)/2) := Real.rpow_pos_of_pos hb _
  have hsq : b ^ (-(1:ℝ)) = (b ^ (-(1:ℝ)/2)) ^ 2 := by
    rw [← Real.rpow_natCast (b ^ (-(1:ℝ)/2)) 2, ← Real.rpow_mul hb.le]
    norm_num
  rw [hC1 γ, hsq]
  constructor
  · nlinarith [hbpos, hcos']
  · nlinarith [hbpos, hcos]

/-- **A4 ∧ C2 → C3.** Depth cannot escape the bound. Uses A4 to name the
depth-`N` multiplier and C2 to bound it. -/
theorem C3_of_A4_C2 {b : ℝ} (hb : 0 < b)
    (hA4 : ∀ γ : ℝ, StmtA4 b ((1 : ℂ)/2 + γ * I)) (hC2 : StmtC2 b) :
    StmtC3 b := by
  intro N γ r
  rw [hA4 γ N r, norm_mul, norm_pow]
  have hb2 : (0:ℝ) ≤ 1 + b ^ (-(1:ℝ)/2) := by positivity
  have := (hC2 γ).2
  have hle : ‖Sym b ((1 : ℂ)/2 + γ * I)‖ ≤ 1 + b ^ (-(1:ℝ)/2) := by
    nlinarith [norm_nonneg (Sym b ((1 : ℂ)/2 + γ * I)), hb2]
  have hpow : ‖Sym b ((1 : ℂ)/2 + γ * I)‖ ^ N ≤ (1 + b ^ (-(1:ℝ)/2)) ^ N :=
    pow_le_pow_left₀ (norm_nonneg _) hle N
  exact mul_le_mul_of_nonneg_right hpow (norm_nonneg _)

end Chain
