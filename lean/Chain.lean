/-
The Euler Factor Chain, as a chain.

Companion to papers/Euler-Factor-Chain.md.

This file does NOT prove the chain's statements against Mathlib. Most of them
are known; proving them again shows nothing. What is unverified in the paper is
the *arrows* — whether each "therefore" actually follows from its predecessors.

So every theorem here takes the antecedent statements as HYPOTHESES and derives
the consequent. The chain typechecks as a chain, and Lean can refuse: if a link
is a leap, it will not compile.

C1 is no longer a hypothesis: it is discharged below from the node proof
`EulerFactorChain.gain_sq_on_critical_line`, which is what turns `C2_of_C1`
into the unconditional `C2`.
-/
import Mathlib
import EulerFactorChain

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

/-- **A2.** Euler's product. It is a statement about *all* primes at once, so
it carries no base index `b`, and it holds only where the product converges —
hence the `1 < s.re` hypothesis, which is Euler's own content and not a
technicality. -/
def StmtA2 : Prop :=
  ∀ s : ℂ, 1 < s.re → ∏' p : Nat.Primes, (1 - (p : ℂ) ^ (-s))⁻¹ = riemannZeta s

/-- **A3.** The single-base reading, with the `b` index kept. Two conjuncts.

The first says the chain's `Sym` at a prime base is the Euler product's factor
at that prime. It is **definitional** — `Sym b s` unfolds to `1 - b^(-s)` and
the only content is the `ℕ → ℝ → ℂ` cast — and it is stated rather than dressed
up, because the paper's A3 ("therefore `1 − b^(−s)` is the reciprocal Euler
factor at `b`") is precisely a renaming, not an inference.

The second is A2 rewritten in that vocabulary. It is what makes A2 and A3 one
product rather than two adjacent facts: the objects the chain differences with
are the objects Euler multiplies.

Note what A3 does *not* say. It is quantified over `Nat.Primes`, so it makes no
claim at the composite bases `b = 4, 6, 8, 9` that blocks D and H use; there
`1 - b^(-s)` is still the symbol of `Δ` but is not a factor of `ζ`. -/
def StmtA3 : Prop :=
  (∀ (p : Nat.Primes) (s : ℂ), Sym ((p : ℕ) : ℝ) s = 1 - (p : ℂ) ^ (-s))
    ∧ (∀ s : ℂ, 1 < s.re →
        ∏' p : Nat.Primes, (Sym ((p : ℕ) : ℝ) s)⁻¹ = riemannZeta s)

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

**Lean needs only `hB4`.** The proof rewrites by it, then moves the exponent
inside the norm — `‖Sym‖^(2N) = ‖Sym^N‖^2`, which is `norm_pow` and nothing
else. `hA4` is carried to mirror the paper's stated dependency, not because the
proof consumes it: the `have` binding it is inert, and it is instantiated at
`r = 1`, which appears nowhere in the goal.

`hB4` is also doing silent work. The statement carries no `0 < b`, and the
conjugate-factor identity behind B4 holds only there, so `hB4` stands in for
the positivity this signature omits. It cannot be dropped. -/
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

/-! ### Discharging A2 and A3

Neither is a hypothesis. A2 is Mathlib's Euler product; A3 is that same product
read one factor at a time, in the chain's own notation. -/

/-- **A2**, proved rather than assumed, from
`EulerFactorChain.euler_product_riemannZeta` (Mathlib's
`riemannZeta_eulerProduct_tprod`). No base index, and the convergence
hypothesis travels with it. -/
theorem A2 : StmtA2 := fun _ hs => EulerFactorChain.euler_product_riemannZeta hs

/-- **A3**, proved rather than assumed. The first conjunct is
`EulerFactorChain.sym_natCast`, which is a cast lemma; the second is
`EulerFactorChain.euler_product_sym`, i.e. A2 with `Sym` substituted in. -/
theorem A3 : StmtA3 :=
  ⟨fun p s => EulerFactorChain.sym_natCast (p : ℕ) s,
   fun _ hs => EulerFactorChain.euler_product_sym hs⟩

/-! ### Discharging C1

The chain's only remaining unproved leaf on the C branch. `Sym` here and
`EulerFactorChain.sym` there are the same definition, so the node theorem
applies directly. -/

/-- **C1**, proved rather than assumed. The expansion is
`EulerFactorChain.gain_sq_on_critical_line`, the law of cosines with sides `1`
and `b^(-1/2)`. Needs only `0 < b`. -/
theorem C1 {b : ℝ} (hb : 0 < b) : StmtC1 b := by
  intro γ
  show ‖1 - (b : ℂ) ^ (-((1 : ℂ)/2 + γ * I))‖ ^ 2 = _
  exact EulerFactorChain.gain_sq_on_critical_line hb γ

/-- **C2**, now unconditional. Same arrow as `C2_of_C1`, with its hypothesis
supplied by `C1`; the implication is still the thing Lean checks. -/
theorem C2 {b : ℝ} (hb : 0 < b) : StmtC2 b := C2_of_C1 hb (C1 hb)

/-! ### Discharging A1 and B4

The two remaining leaves. Both are node theorems in `EulerFactorChain`, stated
there in unfolded notation; `Sym`/`sym` and the two `h`s are the same
definitions, so each applies directly. Closing them makes A4, B5 and C3
unconditional too — the arrows below are unchanged, they are simply applied. -/

/-- **A1**, proved rather than assumed, from
`EulerFactorChain.symbol_of_backward_difference`. Needs only `b ≠ 0`. -/
theorem A1 {b : ℝ} (hb : b ≠ 0) (ρ : ℂ) : StmtA1 b ρ := by
  intro r
  show (b : ℂ) ^ (r * ρ) - (b : ℂ) ^ ((r - 1) * ρ) = _
  exact EulerFactorChain.symbol_of_backward_difference b hb ρ r

/-- **A4**, now unconditional. Same arrow as `A4_of_A1`, with its hypothesis
supplied by `A1`. -/
theorem A4 {b : ℝ} (hb : b ≠ 0) (ρ : ℂ) : StmtA4 b ρ := A4_of_A1 (A1 hb ρ)

/-- **B4**, proved rather than assumed, from
`EulerFactorChain.h_eq_gain_pow_on_critical_line`. Needs only `0 < b`. -/
theorem B4 {b : ℝ} (hb : 0 < b) (N : ℕ) : StmtB4 b N := by
  intro t
  exact EulerFactorChain.h_eq_gain_pow_on_critical_line hb N t

/-- **B5**, now unconditional. Same arrow as `B5_of_A4_B4`, with both
hypotheses supplied. The depth gain *is* the Weil weight, with nothing
assumed. -/
theorem B5 {b : ℝ} (hb : 0 < b) (N : ℕ) : StmtB5 b N :=
  fun t => B5_of_A4_B4 (A4 hb.ne' ((1 : ℂ)/2 + t * I)) (B4 hb N)

/-- **C3**, now unconditional. Same arrow as `C3_of_A4_C2`, with `A4` and `C2`
supplied. No mode's depth-`N` gain escapes the bound, with nothing assumed. -/
theorem C3 {b : ℝ} (hb : 0 < b) : StmtC3 b :=
  C3_of_A4_C2 hb (fun γ => A4 hb.ne' ((1 : ℂ)/2 + γ * I)) (C2 hb)

/-! ### Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'Chain.bdiff_smul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.bdiff_smul

/-- info: 'Chain.A4_of_A1' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.A4_of_A1

/-- info: 'Chain.B5_of_A4_B4' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.B5_of_A4_B4

/-- info: 'Chain.C2_of_C1' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.C2_of_C1

/-- info: 'Chain.C3_of_A4_C2' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.C3_of_A4_C2

/-- info: 'Chain.A2' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.A2

/-- info: 'Chain.A3' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.A3

/-- info: 'Chain.C1' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.C1

/-- info: 'Chain.C2' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.C2

/-- info: 'Chain.A1' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.A1

/-- info: 'Chain.A4' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.A4

/-- info: 'Chain.B4' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.B4

/-- info: 'Chain.B5' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.B5

/-- info: 'Chain.C3' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.C3

end Chain
