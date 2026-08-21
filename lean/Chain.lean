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
import Construction

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

/-- **C3, the other half.** The paper's C3 reads "no mode grows *or decays*
without bound under depth". `StmtC3` is the growth half only. This is the decay
half, and the ingredient was already present and unused: `StmtC2`'s FIRST
conjunct bounds the gain below, `C2_of_C1` proves it, and `C3_of_A4_C2` calls
only `.2`.

The absolute value is not cosmetic. For `0 < b < 1` the quantity
`1 - b^(-1/2)` is negative, and the unbarred statement, while still true, says
nothing. With `|·|` the bound has content at every positive base except `b = 1`,
where `Sym` vanishes identically and both sides are 0.

`papers/Euler-Factor-Chain.md` § F5's spread
`((1+b^(-1/2))/(1-b^(-1/2)))^(d+1)` is the ratio of the two bounds; its
denominator had no formal counterpart until this. -/
def StmtC3lower (b : ℝ) : Prop :=
  ∀ (N : ℕ) (γ : ℝ) (r : ℂ),
    |1 - b ^ (-(1:ℝ)/2)| ^ N * ‖mode b ((1 : ℂ)/2 + γ * I) r‖
      ≤ ‖(bdiff^[N]) (mode b ((1 : ℂ)/2 + γ * I)) r‖

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

/-- **A4 ∧ C2 → C3 (decay half).** A strict mirror of `C3_of_A4_C2`, reading
`(hC2 γ).1` where that reads `.2`.

Note the signature: no `0 < b`. The proof does not consume one, and carrying a
hypothesis a proof does not use is what made `B5_of_A4_B4`'s docstring false.
Positivity enters only through `C2`, at the point where `hC2` is supplied. -/
theorem C3lower_of_A4_C2 {b : ℝ}
    (hA4 : ∀ γ : ℝ, StmtA4 b ((1 : ℂ)/2 + γ * I)) (hC2 : StmtC2 b) :
    StmtC3lower b := by
  intro N γ r
  rw [hA4 γ N r, norm_mul, norm_pow]
  have habs : |1 - b ^ (-(1:ℝ)/2)| ≤ ‖Sym b ((1 : ℂ)/2 + γ * I)‖ :=
    abs_le_of_sq_le_sq (hC2 γ).1 (norm_nonneg _)
  have hpow : |1 - b ^ (-(1:ℝ)/2)| ^ N ≤ ‖Sym b ((1 : ℂ)/2 + γ * I)‖ ^ N :=
    pow_le_pow_left₀ (abs_nonneg _) habs N
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

/-- **C3's decay half, unconditional.** Same arrow as `C3lower_of_A4_C2` with
both hypotheses supplied. With `C3` this is the paper's C3 in full: a mode's
depth-`N` amplitude is trapped between `|1 − b^(−1/2)|^N` and
`(1 + b^(−1/2))^N` times its undifferenced amplitude, at every rung and every
`γ`. -/
theorem C3lower {b : ℝ} (hb : 0 < b) : StmtC3lower b :=
  C3lower_of_A4_C2 (fun γ => A4 hb.ne' ((1 : ℂ)/2 + γ * I)) (C2 hb)

/-! ### The seam: the integer table is this operator

Everything above is about `bdiff` on `ℂ → ℂ`. `Construction.tableFrom` is the
same backward difference on `ℤ → ℤ`, and until now nothing joined them — the
formalisation read as two stacks rather than one chain.

These three weld it. After them, an integer cell of the dyadic table is an
object the analytic half of this file has theorems about. -/

/-- **The weld.** `Construction.tableFrom` and `bdiff` are the same operation on
two domains. If `g : ℂ → ℂ` agrees with the integer row `N` at every integer,
the table's cell at `(r,d)` IS `bdiff` iterated `d` times on `g` at `r`. -/
theorem tableFrom_eq_bdiff_iter {N : ℤ → ℤ} {g : ℂ → ℂ}
    (hag : ∀ n : ℤ, ((N n : ℤ) : ℂ) = g (n : ℂ)) (r : ℤ) (d : ℕ) :
    ((Construction.tableFrom N r d : ℤ) : ℂ) = (bdiff^[d]) g (r : ℂ) := by
  induction d generalizing r with
  | zero => exact hag r
  | succ n ih =>
      rw [Function.iterate_succ_apply']
      show ((Construction.tableFrom N r n - Construction.tableFrom N (r - 1) n : ℤ) : ℂ)
        = (bdiff^[n]) g (r : ℂ) - (bdiff^[n]) g ((r : ℂ) - 1)
      push_cast
      rw [ih r, ih (r - 1)]
      push_cast
      ring

/-- **The chain, welded.** An integer row agreeing with a mode across the window
a cell reads: the cell is the symbol to the `d`, times the mode.

**The hypothesis is window-local and that is not a detail.** An earlier version
asked for agreement at every `n : ℤ`, which is vacuous: `mode b ρ n = w^n`, so
`n = 1` puts `w` in ℤ and `n = −1` puts `w⁻¹` in ℤ, and an integer whose inverse
is an integer is `±1` — a hypothesis class of exactly two rows, none of them a
prime count. `PairIdentity.lean` § "A geometric row collapses" states the same
criterion and localises for the same reason. Found by adversarial audit; notes
entry 70. `#guard_msgs` cannot see vacuity, so the build did not object. -/
theorem tableFrom_mode {b : ℝ} (hb : b ≠ 0) (ρ : ℂ) {N : ℤ → ℤ} (r : ℤ) (d : ℕ)
    (hag : ∀ k : ℕ, k ≤ d → ((N (r - k) : ℤ) : ℂ) = mode b ρ ((r : ℂ) - k)) :
    ((Construction.tableFrom N r d : ℤ) : ℂ) = (Sym b ρ) ^ d * mode b ρ (r : ℂ) := by
  induction d generalizing r with
  | zero =>
      have h0 := hag 0 (Nat.le_refl 0)
      simpa using h0
  | succ n ih =>
      have h1 : ((Construction.tableFrom N r n : ℤ) : ℂ)
          = (Sym b ρ) ^ n * mode b ρ (r : ℂ) :=
        ih r fun k hk => hag k (Nat.le_succ_of_le hk)
      have h2 : ((Construction.tableFrom N (r - 1) n : ℤ) : ℂ)
          = (Sym b ρ) ^ n * mode b ρ (((r - 1 : ℤ) : ℂ)) := by
        refine ih (r - 1) fun k hk => ?_
        have hk1 := hag (k + 1) (Nat.succ_le_succ hk)
        have e1 : r - ((k + 1 : ℕ) : ℤ) = r - 1 - (k : ℤ) := by push_cast; ring
        have e2 : (r : ℂ) - ((k + 1 : ℕ) : ℂ) = ((r - 1 : ℤ) : ℂ) - ((k : ℕ) : ℂ) := by
          push_cast; ring
        rw [e1, e2] at hk1
        exact hk1
      show ((Construction.tableFrom N r n - Construction.tableFrom N (r - 1) n : ℤ) : ℂ) = _
      push_cast
      push_cast at h2
      rw [h1, h2, ← mul_sub]
      have hstep : mode b ρ (r : ℂ) - mode b ρ ((r : ℂ) - 1)
          = Sym b ρ * mode b ρ (r : ℂ) := A1 hb ρ (r : ℂ)
      rw [hstep, pow_succ]
      ring

/-- **The table on the critical line.** The cell's modulus is `‖Sym‖^d` times
the mode's — which is what `StmtC2` and `StmtC3` bound, and what the periodicity
below makes an angle. -/
theorem tableFrom_norm_on_critical_line {b : ℝ} (hb : b ≠ 0) (γ : ℝ) {N : ℤ → ℤ}
    (r : ℤ) (d : ℕ)
    (hag : ∀ k : ℕ, k ≤ d →
      ((N (r - k) : ℤ) : ℂ) = mode b ((1 : ℂ)/2 + γ * I) ((r : ℂ) - k)) :
    ‖((Construction.tableFrom N r d : ℤ) : ℂ)‖
      = ‖Sym b ((1 : ℂ)/2 + γ * I)‖ ^ d * ‖mode b ((1 : ℂ)/2 + γ * I) (r : ℂ)‖ := by
  rw [tableFrom_mode hb _ r d hag, norm_mul, norm_pow]

/-! ### The pole lattice, and the circle it makes

`1/Sym` is the reciprocal Euler factor, and its poles are the zeros of `Sym`.
Those sit on a lattice of spacing `2πi / log b` — the `2πik/log b` lattice of
Flajolet, Grabner, Kirschenhofer, Prodinger and Tichy
(`papers/literature/litsearch_1_hinge.md` § 3), and the same lattice
`EulerFactorChain`'s A2 docstring excludes.

**That lattice is why there is a circle.** `Sym` returns to itself after one
lattice step, so `γ` is an angle rather than a line, and the period is the
lattice spacing. Deriving the periodicity from `cos` instead would get the same
number from the symptom. -/

/-- **The pole lattice.** `Sym b s = 0` exactly on `s ∈ (2πi / log b)·ℤ`. -/
theorem sym_eq_zero_iff {b : ℝ} (hb : 0 < b) (hb1 : b ≠ 1) (s : ℂ) :
    Sym b s = 0 ↔ ∃ k : ℤ, s = (k : ℂ) * (2 * Real.pi * I / Real.log b) := by
  have hb0 : (b : ℂ) ≠ 0 := by exact_mod_cast hb.ne'
  have hlog : Real.log b ≠ 0 := Real.log_ne_zero_of_pos_of_ne_one hb hb1
  have hlogC : (Real.log b : ℂ) ≠ 0 := by exact_mod_cast hlog
  have hclog : Complex.log (b : ℂ) = (Real.log b : ℂ) := (Complex.ofReal_log hb.le).symm
  unfold Sym
  rw [sub_eq_zero, eq_comm, Complex.cpow_def_of_ne_zero hb0, hclog,
      Complex.exp_eq_one_iff]
  constructor
  · rintro ⟨n, hn⟩
    refine ⟨-n, ?_⟩
    push_cast
    field_simp at hn ⊢
    linear_combination -hn
  · rintro ⟨k, hk⟩
    refine ⟨-k, ?_⟩
    subst hk
    push_cast
    field_simp

/-- **The symbol is periodic with the lattice period.** One step along the pole
lattice returns `Sym` to itself, because `b^(−2πi/log b) = exp(−2πi) = 1`. This
is the origin of the circle. -/
theorem sym_periodic {b : ℝ} (hb : 0 < b) (hb1 : b ≠ 1) (s : ℂ) :
    Sym b (s + 2 * Real.pi * I / Real.log b) = Sym b s := by
  have hb0 : (b : ℂ) ≠ 0 := by exact_mod_cast hb.ne'
  have hlog : Real.log b ≠ 0 := Real.log_ne_zero_of_pos_of_ne_one hb hb1
  have hlogC : (Real.log b : ℂ) ≠ 0 := by exact_mod_cast hlog
  have hclog : Complex.log (b : ℂ) = (Real.log b : ℂ) := (Complex.ofReal_log hb.le).symm
  unfold Sym
  rw [Complex.cpow_def_of_ne_zero hb0, Complex.cpow_def_of_ne_zero hb0, hclog]
  congr 1
  have harg : (Real.log b : ℂ) * -(s + 2 * (Real.pi : ℂ) * I / (Real.log b : ℂ))
      = (Real.log b : ℂ) * -s + -(2 * (Real.pi : ℂ) * I) := by
    field_simp
    ring
  rw [harg, Complex.exp_add, Complex.exp_neg, Complex.exp_two_pi_mul_I]
  simp

/-- **The circle.** The gain on the critical line is periodic in `γ` with period
`2π / log b`.

`b ≠ 1` is not decoration. At `b = 1` the period is `2π/0 = 0` and
`Function.Periodic f 0` holds for every `f`, so dropping the hypothesis gives a
statement that is true and empty exactly at the degenerate base —
`period_vacuous_at_one` below is that fact, proved. **`#guard_msgs` cannot catch
vacuity**: a vacuous theorem has a perfectly ordinary axiom list. -/
theorem gain_sq_periodic {b : ℝ} (hb : 0 < b) (hb1 : b ≠ 1) :
    Function.Periodic (fun γ : ℝ => ‖Sym b ((1 : ℂ)/2 + γ * I)‖ ^ 2)
      (2 * Real.pi / Real.log b) := by
  intro γ
  have hlogC : (Real.log b : ℂ) ≠ 0 := by
    exact_mod_cast Real.log_ne_zero_of_pos_of_ne_one hb hb1
  show ‖Sym b ((1 : ℂ)/2 + ((γ + 2 * Real.pi / Real.log b) : ℝ) * I)‖ ^ 2
      = ‖Sym b ((1 : ℂ)/2 + (γ : ℝ) * I)‖ ^ 2
  rw [show ((1 : ℂ)/2 + ((γ + 2 * Real.pi / Real.log b : ℝ) : ℂ) * I)
        = ((1 : ℂ)/2 + (γ : ℂ) * I) + 2 * (Real.pi : ℂ) * I / (Real.log b : ℂ) by
      push_cast; field_simp; ring,
      sym_periodic hb hb1]

/-- The trap `gain_sq_periodic`'s `b ≠ 1` closes: at `b = 1` the period is zero
and the statement holds for **any** function whatsoever. -/
theorem period_vacuous_at_one (f : ℝ → ℝ) :
    Function.Periodic f (2 * Real.pi / Real.log 1) := by simp

/-! ### Block D, formalised

`papers/Euler-Factor-Chain.md` § D — the winding — is listed as **not
formalised** in `lean/BUILD.md`. It states in prose that the C2 band's floor
sits at `γ log b ≡ 0 (mod 2π)` and its ceiling at `γ log b ≡ π (mod 2π)` (D1);
that the smooth term, having `γ = 0`, sits exactly on the floor (D2); that
differencing therefore dissipates the smooth part maximally while amplifying
modes near the ceiling (D3); and that the bases placing `γ` at the ceiling are
`exp(π(2k+1)/γ)` (D4).

All of it follows from `EulerFactorChain.gain_sq_on_critical_line`, already
proved, by evaluating `cos` at `±1`. Notes entry 77.

**These supply the attainment `StmtC2` lacks.** C2 proves the gain is
*contained* in `[1 − b^(−1/2), 1 + b^(−1/2)]` and never exhibits a `γ` reaching
either end. `C2_floor_attained` and `C2_ceiling_attained` do. O49 measures the
residual table's own gain at 97.68% ± 2.91% of that ceiling across twelve bases
(entry 75), so the bound is not merely attainable but attained in the data.

**Not to be confused with `sym_eq_zero_iff`.** That lattice is where `Sym`
vanishes outright, at `s = 2πik/log b`, which has `Re s = 0`. The floor here is
on the critical line `Re s = 1/2`, where the gain is `1 − b^(−1/2)` and not
zero. Same phase condition, different line: the C2 floor is where the critical
line passes closest to the zero lattice. -/

private theorem sq_rpow_half {b : ℝ} (hb : 0 < b) :
    (b ^ (-(1:ℝ)/2)) ^ 2 = b ^ (-(1:ℝ)) := by
  rw [← Real.rpow_natCast (b ^ (-(1:ℝ)/2)) 2, ← Real.rpow_mul hb.le]
  norm_num

/-- **D1, floor half.** Where `cos(γ log b) = 1` the gain is the floor of C2. -/
theorem gain_sq_at_floor {b : ℝ} (hb : 0 < b) (γ : ℝ)
    (hcos : Real.cos (γ * Real.log b) = 1) :
    ‖Sym b ((1 : ℂ)/2 + γ * I)‖ ^ 2 = (1 - b ^ (-(1:ℝ)/2)) ^ 2 := by
  unfold Sym
  rw [EulerFactorChain.gain_sq_on_critical_line hb, hcos, ← sq_rpow_half hb]
  ring

/-- **D1, ceiling half.** Where `cos(γ log b) = −1` the gain is the ceiling. -/
theorem gain_sq_at_ceiling {b : ℝ} (hb : 0 < b) (γ : ℝ)
    (hcos : Real.cos (γ * Real.log b) = -1) :
    ‖Sym b ((1 : ℂ)/2 + γ * I)‖ ^ 2 = (1 + b ^ (-(1:ℝ)/2)) ^ 2 := by
  unfold Sym
  rw [EulerFactorChain.gain_sq_on_critical_line hb, hcos, ← sq_rpow_half hb]
  ring

/-- **D2.** The smooth term has `γ = 0`, so it sits exactly ON the floor. This
is why differencing dissipates it fastest of anything in the band. -/
theorem C2_floor_attained {b : ℝ} (hb : 0 < b) :
    ‖Sym b ((1 : ℂ)/2 + (0 : ℝ) * I)‖ ^ 2 = (1 - b ^ (-(1:ℝ)/2)) ^ 2 :=
  gain_sq_at_floor hb 0 (by simp)

/-- **C2's upper bound is ATTAINED.** `StmtC2` proves containment; this exhibits
a `γ` that reaches the ceiling. Witness `γ = π / log b`. -/
theorem C2_ceiling_attained {b : ℝ} (hb : 0 < b) (hb1 : b ≠ 1) :
    ∃ γ : ℝ, ‖Sym b ((1 : ℂ)/2 + γ * I)‖ ^ 2 = (1 + b ^ (-(1:ℝ)/2)) ^ 2 := by
  have hlog : Real.log b ≠ 0 := Real.log_ne_zero_of_pos_of_ne_one hb hb1
  refine ⟨Real.pi / Real.log b, gain_sq_at_ceiling hb _ ?_⟩
  rw [div_mul_cancel₀ _ hlog, Real.cos_pi]

/-- **D4.** The bases placing `γ` exactly at the ceiling are `exp(π(2k+1)/γ)`.
For `γ₁` the paper lists `1.2489, 1.948, 3.039, 4.741, 7.395 …`; `1.2489` is the
O45 locked family's `k = 2`. -/
theorem ceiling_base {γ : ℝ} (hγ : γ ≠ 0) (k : ℤ) :
    ‖Sym (Real.exp (Real.pi * (2 * k + 1) / γ)) ((1 : ℂ)/2 + γ * I)‖ ^ 2
      = (1 + (Real.exp (Real.pi * (2 * k + 1) / γ)) ^ (-(1:ℝ)/2)) ^ 2 := by
  refine gain_sq_at_ceiling (Real.exp_pos _) γ ?_
  rw [Real.log_exp, mul_div_cancel₀ _ hγ]
  rw [show Real.pi * (2 * (k : ℝ) + 1) = Real.pi + (k : ℝ) * (2 * Real.pi) by ring]
  simp [Real.cos_add_int_mul_two_pi]

/-- **D3.** Differencing amplifies ceiling modes strictly more than floor modes.
That is the power iteration, as an inequality — and it needs only `0 < b`, not
`b ≠ 1`, because the proof does not consume one. -/
theorem ceiling_dominates_floor {b : ℝ} (hb : 0 < b) :
    (1 - b ^ (-(1:ℝ)/2)) ^ 2 < (1 + b ^ (-(1:ℝ)/2)) ^ 2 := by
  have hpos : 0 < b ^ (-(1:ℝ)/2) := Real.rpow_pos_of_pos hb _
  nlinarith [hpos]

/-! ### Two ladders: one circle, or a torus -/

/-- **The collapse.** Each base contributes a circle of period `2π / log b`. If
the two periods are commensurate — an integer multiple of one equals an integer
multiple of the other — the joint gain is periodic in a SINGLE variable and the
two circles are one.

This is the trap `analysis/2026-08-19_table_structure` t24 measured, as a
theorem: a base set commensurate by construction forces cross-base alignment
rather than finding it. See notes entries 54 and 56.

**`0 < m` and `0 < n` are load-bearing.** Without them `m = n = 0` satisfies
`hcomm` as `0 = 0` for *every* pair of bases, commensurate or not, and the
conclusion degrades to `Periodic f 0` — which `period_vacuous_at_one` below
proves is empty. So the unguarded version is true and carries none of the
commensurability content this docstring claims. Found by adversarial audit;
notes entry 70. -/
theorem joint_gain_periodic_of_commensurate
    {b₁ b₂ : ℝ} (h₁ : 0 < b₁) (hn₁ : b₁ ≠ 1) (h₂ : 0 < b₂) (hn₂ : b₂ ≠ 1)
    (m n : ℕ) (hm : 0 < m) (hn : 0 < n)
    (hcomm : (m : ℝ) * (2 * Real.pi / Real.log b₁)
           = (n : ℝ) * (2 * Real.pi / Real.log b₂)) :
    Function.Periodic
      (fun γ : ℝ => ‖Sym b₁ ((1 : ℂ)/2 + γ * I)‖ ^ 2
                  * ‖Sym b₂ ((1 : ℂ)/2 + γ * I)‖ ^ 2)
      ((m : ℝ) * (2 * Real.pi / Real.log b₁)) := by
  have p₁ := (gain_sq_periodic h₁ hn₁).nat_mul m
  have p₂ := (gain_sq_periodic h₂ hn₂).nat_mul n
  rw [← hcomm] at p₂
  exact p₁.mul p₂

/-- **The torus.** Take the `b₁`-ladder's circle. The `b₂`-ladder steps around
it by its own period. Those steps are DENSE — the second ladder winds forever
without closing — exactly when `log b₁ / log b₂` is irrational. Rational, and
the orbit is finite and the two circles collapse, which is the theorem above.

Kronecker, via `AddCircle.denseRange_zsmul_coe_iff`. The whole content is the
ratio of the logs: commensurate ladders close, incommensurate ones fill. -/
theorem second_ladder_winds_densely {b₁ b₂ : ℝ}
    (h₁ : 0 < b₁) (hn₁ : b₁ ≠ 1) (h₂ : 0 < b₂) (hn₂ : b₂ ≠ 1) :
    DenseRange (fun k : ℤ => k •
        ((2 * Real.pi / Real.log b₂ : ℝ) :
          AddCircle (2 * Real.pi / Real.log b₁)))
      ↔ Irrational (Real.log b₁ / Real.log b₂) := by
  rw [AddCircle.denseRange_zsmul_coe_iff]
  have l₁ : Real.log b₁ ≠ 0 := Real.log_ne_zero_of_pos_of_ne_one h₁ hn₁
  have l₂ : Real.log b₂ ≠ 0 := Real.log_ne_zero_of_pos_of_ne_one h₂ hn₂
  have hpi : Real.pi ≠ 0 := Real.pi_ne_zero
  have hratio : (2 * Real.pi / Real.log b₂) / (2 * Real.pi / Real.log b₁)
      = Real.log b₁ / Real.log b₂ := by field_simp
  rw [hratio]

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

/-- info: 'Chain.C3lower_of_A4_C2' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.C3lower_of_A4_C2

/-- info: 'Chain.C3lower' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.C3lower

/-- info: 'Chain.tableFrom_eq_bdiff_iter' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.tableFrom_eq_bdiff_iter

/-- info: 'Chain.tableFrom_mode' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.tableFrom_mode

/-- info: 'Chain.tableFrom_norm_on_critical_line' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.tableFrom_norm_on_critical_line

/-- info: 'Chain.sym_eq_zero_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.sym_eq_zero_iff

/-- info: 'Chain.sym_periodic' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.sym_periodic

/-- info: 'Chain.gain_sq_periodic' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.gain_sq_periodic

/-- info: 'Chain.period_vacuous_at_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.period_vacuous_at_one

/-- info: 'Chain.gain_sq_at_floor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.gain_sq_at_floor

/-- info: 'Chain.gain_sq_at_ceiling' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.gain_sq_at_ceiling

/-- info: 'Chain.C2_floor_attained' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.C2_floor_attained

/-- info: 'Chain.C2_ceiling_attained' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.C2_ceiling_attained

/-- info: 'Chain.ceiling_base' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.ceiling_base

/-- info: 'Chain.ceiling_dominates_floor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.ceiling_dominates_floor

/-- info: 'Chain.joint_gain_periodic_of_commensurate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.joint_gain_periodic_of_commensurate

/-- info: 'Chain.second_ladder_winds_densely' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Chain.second_ladder_winds_densely

end Chain
