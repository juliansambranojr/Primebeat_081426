/-
JointLadder — the joint `{2^m 3^n}` grid has NO aliases, and its
difference operator carries two Euler factors.

WHY THIS FILE EXISTS. `Nyquist.lean` proves the single-base no-go: past
`π / log b` a `b`-adic ladder always admits a strictly smaller
frequency it cannot distinguish from `γ`, so base 2 cannot identify
`γ₁` — not noisily, but structurally. The measurements on the JOINT
orbit disagree with each other: O18 records `verdict = NULL` on the
`L23` orbit and
`DETECT` on `L235` (`results/O18_joint_multiplicative_ladder_run2.json`);
the 2026-09-01 exploratory run (entry 272,
`analysis/2026-09-01_joint_ladder/joint_ladder.py`) reports peaks near
`γ₁, γ₂, γ₃` on `L23`. No further run adjudicates that — it adds
another number.

What adjudicates it is a statement fixed independently of any
estimator, and it is the exact dual of `Nyquist.nyquist_no_go`:

  `jointAliases_iff_eq`    on `{2^m 3^n}`, two frequencies agree at
                           every rung ONLY IF they are equal — the
                           joint grid admits no nonzero alias at all
  `dyadic_alias_resolved_jointly`   the contrast, as one statement:
                           for every `γ` there is a `γ' ≠ γ` that the
                           dyadic ladder cannot separate from `γ` and
                           the joint grid can

CONSEQUENCE FOR THE CORPUS. O18's NULL on `L23` is therefore NOT an
identifiability obstruction. Whatever it measures, it cannot be the
structural blindness that kills the single ladder, because that
blindness provably does not exist here. The reading is about the
estimator — span, weighting, trend model, decision rule — and not
about the object.

THE ARITHMETIC CORE. Everything rests on `2^l ≠ 3^k` for `l > 0`,
proved by parity rather than by factorization: `2 ∣ 2^l` and
`2 ∤ 3^k`. That lifts through `Real.log_pow` to the independence of
`log 2` and `log 3` over `ℤ`, which is what closes the alias lattice.
`Chain.second_ladder_winds_densely` is the general Kronecker statement
this instantiates; it has been in the tree since the Chain work with
no arithmetic input to activate it.

THE OPERATOR. On the joint grid the mode `2^(rρ)·3^(mρ)` is an
eigenvector of BOTH difference directions, with eigenvalues
`Chain.Sym 2 ρ` and `Chain.Sym 3 ρ` — the two reciprocal Euler factors
at 2 and 3. So `Δ₂^a Δ₃^b` carries the symbol
`(1 − 2^(−ρ))^a (1 − 3^(−ρ))^b`, a two-factor truncation of the Euler
product rather than an ad hoc grid. Single-factor case:
`Elephant.symbol_of_difference`, `Chain.A3`.

Companion to notes entries 26 (the single-base no-go), 155 (O76: asked
jointly, the answer matches O44 asked singly), 272.
-/
import Mathlib
import Chain
import Nyquist

namespace JointLadder

open Real Complex

noncomputable section

/-! ## The arithmetic core: `log 2` and `log 3` are ℤ-independent -/

/-- **Parity kills it.** A positive power of two is never a power of
three: `2 ∣ 2^l` while `2 ∤ 3^k`. -/
theorem two_pow_ne_three_pow {l k : ℕ} (hl : 0 < l) : (2 : ℕ) ^ l ≠ 3 ^ k := by
  intro h
  have h2 : 2 ∣ (2 : ℕ) ^ l := dvd_pow_self 2 hl.ne'
  rw [h] at h2
  have h3 : (2 : ℕ) ∣ 3 := Nat.Prime.dvd_of_dvd_pow Nat.prime_two h2
  norm_num at h3

/-- The same, over `ℕ` and in logarithmic form: `a·log 2 = b·log 3`
forces `a = b = 0`. -/
theorem nat_log_indep {a b : ℕ} (h : (a : ℝ) * Real.log 2 = (b : ℝ) * Real.log 3) :
    a = 0 ∧ b = 0 := by
  have hl2 : (0 : ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  have hl3 : (0 : ℝ) < Real.log 3 := Real.log_pos (by norm_num)
  have ha : a = 0 := by
    by_contra hane
    have hapos : 0 < a := Nat.pos_of_ne_zero hane
    -- the two logs agree, so the two powers agree
    have hlog : Real.log ((2 : ℝ) ^ a) = Real.log ((3 : ℝ) ^ b) := by
      rw [Real.log_pow, Real.log_pow]
      exact_mod_cast h
    have hpow : (2 : ℝ) ^ a = (3 : ℝ) ^ b := by
      have h2pos : (0 : ℝ) < (2 : ℝ) ^ a := by positivity
      have h3pos : (0 : ℝ) < (3 : ℝ) ^ b := by positivity
      have := congrArg Real.exp hlog
      rwa [Real.exp_log h2pos, Real.exp_log h3pos] at this
    have hnat : (2 : ℕ) ^ a = 3 ^ b := by exact_mod_cast hpow
    exact two_pow_ne_three_pow hapos hnat
  refine ⟨ha, ?_⟩
  rw [ha] at h
  simp only [Nat.cast_zero, zero_mul] at h
  have : (b : ℝ) = 0 := by
    rcases mul_eq_zero.mp h.symm with hb | hlog3
    · exact hb
    · exact absurd hlog3 hl3.ne'
  exact_mod_cast this

/-- **`log 2` and `log 3` are independent over `ℤ`.** This is the fact
`Chain.second_ladder_winds_densely` needs to fire at `(2, 3)`, and the
fact that closes the joint alias lattice. -/
theorem log_indep {l k : ℤ} (h : (l : ℝ) * Real.log 2 = (k : ℝ) * Real.log 3) :
    l = 0 ∧ k = 0 := by
  have hl2 : (0 : ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  have hl3 : (0 : ℝ) < Real.log 3 := Real.log_pos (by norm_num)
  -- the two integers carry the same sign
  rcases lt_trichotomy l 0 with hneg | hzero | hpos
  · -- both negative: negate and use the ℕ case
    have hk : k < 0 := by
      by_contra hk'
      push_neg at hk'
      have h1 : (l : ℝ) * Real.log 2 < 0 :=
        mul_neg_of_neg_of_pos (by exact_mod_cast hneg) hl2
      have h2 : (0 : ℝ) ≤ (k : ℝ) * Real.log 3 :=
        mul_nonneg (by exact_mod_cast hk') hl3.le
      linarith
    obtain ⟨a, ha⟩ : ∃ a : ℕ, l = -(a : ℤ) := ⟨l.natAbs, by omega⟩
    obtain ⟨b, hb⟩ : ∃ b : ℕ, k = -(b : ℤ) := ⟨k.natAbs, by omega⟩
    rw [ha, hb] at h
    push_cast at h
    have h' : (a : ℝ) * Real.log 2 = (b : ℝ) * Real.log 3 := by linarith
    obtain ⟨ha0, hb0⟩ := nat_log_indep h'
    constructor
    · rw [ha, ha0]; simp
    · rw [hb, hb0]; simp
  · -- `l = 0` forces `k = 0`
    subst hzero
    refine ⟨rfl, ?_⟩
    simp only [Int.cast_zero, zero_mul] at h
    have : (k : ℝ) = 0 := by
      rcases mul_eq_zero.mp h.symm with hk | hlog3
      · exact hk
      · exact absurd hlog3 hl3.ne'
    exact_mod_cast this
  · -- both positive
    have hk : 0 < k := by
      by_contra hk'
      push_neg at hk'
      have h1 : (0 : ℝ) < (l : ℝ) * Real.log 2 :=
        mul_pos (by exact_mod_cast hpos) hl2
      have h2 : (k : ℝ) * Real.log 3 ≤ 0 :=
        mul_nonpos_of_nonpos_of_nonneg (by exact_mod_cast hk') hl3.le
      linarith
    obtain ⟨a, ha⟩ : ∃ a : ℕ, l = (a : ℤ) := ⟨l.natAbs, by omega⟩
    obtain ⟨b, hb⟩ : ∃ b : ℕ, k = (b : ℤ) := ⟨k.natAbs, by omega⟩
    rw [ha, hb] at h
    push_cast at h
    obtain ⟨ha0, hb0⟩ := nat_log_indep h
    exact ⟨by rw [ha, ha0]; simp, by rw [hb, hb0]; simp⟩

/-! ## The joint grid, and its empty alias lattice -/

/-- The rungs of the joint `{2^m 3^n}` grid, in `log x`. -/
def jointSample (m n : ℤ) : ℝ := (m : ℝ) * Real.log 2 + (n : ℝ) * Real.log 3

/-- **Indistinguishable on the joint grid.** `γ` and `γ'` alias when
their modes agree at every rung of `{2^m 3^n}` — the exact analogue of
`Nyquist.Aliases`, with the one-parameter ladder replaced by the
two-parameter orbit. -/
def JointAliases (γ γ' : ℝ) : Prop :=
  ∀ m n : ℤ, Complex.exp ((γ * jointSample m n : ℝ) * Complex.I)
           = Complex.exp ((γ' * jointSample m n : ℝ) * Complex.I)

/-- Reading the aliasing relation at a single rung: the phase offset is
an integer multiple of `2π`. -/
theorem offset_of_aliases {γ γ' : ℝ} (h : JointAliases γ γ') (m n : ℤ) :
    ∃ j : ℤ, (γ - γ') * jointSample m n = 2 * Real.pi * j := by
  have := h m n
  rw [Complex.exp_eq_exp_iff_exists_int] at this
  obtain ⟨j, hj⟩ := this
  refine ⟨j, ?_⟩
  have hre := congrArg Complex.im hj
  simp only [Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im, Complex.I_re,
    Complex.I_im, Complex.add_im, Complex.mul_re, Complex.intCast_re,
    Complex.intCast_im, Complex.re_ofNat, Complex.im_ofNat] at hre
  ring_nf at hre ⊢
  linarith [hre]

/-- **THE JOINT NO-GO, in reverse.** On the `{2^m 3^n}` grid two
frequencies agree at every rung only if they are EQUAL. The grid has no
nonzero alias whatsoever — the obstruction that makes `γ₁`
unidentifiable from a single integer base does not exist here.

The proof is the arithmetic core: reading the relation at `(1,0)` and
`(0,1)` gives `(γ−γ')·log 2 = 2πk` and `(γ−γ')·log 3 = 2πl`; crossing
them gives `(γ−γ')·(l·log 2 − k·log 3) = 0`; and `log_indep` forces
`k = l = 0`, hence `γ = γ'`. -/
theorem jointAliases_iff_eq (γ γ' : ℝ) : JointAliases γ γ' ↔ γ = γ' := by
  constructor
  · intro h
    obtain ⟨k, hk⟩ := offset_of_aliases h 1 0
    obtain ⟨l, hl⟩ := offset_of_aliases h 0 1
    simp only [jointSample, Int.cast_one, Int.cast_zero, one_mul, zero_mul,
      add_zero, zero_add] at hk hl
    -- cross-multiply to eliminate the frequency difference
    have hcross : (γ - γ') * ((l : ℝ) * Real.log 2 - (k : ℝ) * Real.log 3) = 0 := by
      have e1 : (l : ℝ) * ((γ - γ') * Real.log 2) = (l : ℝ) * (2 * Real.pi * k) := by
        rw [hk]
      have e2 : (k : ℝ) * ((γ - γ') * Real.log 3) = (k : ℝ) * (2 * Real.pi * l) := by
        rw [hl]
      nlinarith [e1, e2]
    rcases mul_eq_zero.mp hcross with hdiff | hlog
    · linarith [sub_eq_zero.mp hdiff]
    · have hsub : (l : ℝ) * Real.log 2 = (k : ℝ) * Real.log 3 := by linarith
      obtain ⟨hl0, hk0⟩ := log_indep hsub
      rw [hk0] at hk
      simp only [Int.cast_zero, mul_zero] at hk
      have hlog2 : Real.log 2 ≠ 0 := (Real.log_pos (by norm_num)).ne'
      rcases mul_eq_zero.mp hk with hd | hbad
      · linarith [sub_eq_zero.mp hd]
      · exact absurd hbad hlog2
  · intro h
    subst h
    intro m n
    rfl

/-! ## The contrast with the single ladder -/

/-- Every frequency has a dyadic alias distinct from it — the single
ladder's obstruction, restated from `Nyquist.aliases_of_offset`. -/
theorem exists_dyadic_alias_ne (γ : ℝ) :
    ∃ γ' : ℝ, γ' ≠ γ ∧ Nyquist.Aliases 2 γ γ' := by
  have hlog2 : Real.log 2 ≠ 0 := (Real.log_pos (by norm_num)).ne'
  refine ⟨γ - 2 * Real.pi * (1 : ℤ) / Real.log 2, ?_,
    Nyquist.aliases_of_offset 2 γ 1 hlog2⟩
  intro h
  have hzero : 2 * Real.pi * (1 : ℤ) / Real.log 2 = 0 := by linarith [h]
  rw [div_eq_zero_iff] at hzero
  rcases hzero with hnum | hden
  · simp only [Int.cast_one, mul_one] at hnum
    have hpos : (0 : ℝ) < 2 * Real.pi := by positivity
    linarith
  · exact hlog2 hden

/-- **THE CONTRAST, AS ONE STATEMENT.** For every frequency there is a
different frequency that the dyadic ladder cannot separate from it and
the joint grid can. This is the precise sense in which the joint
instrument is not obstructed by what obstructs the single one, and it
is what makes a NULL reading on the joint orbit a statement about the
estimator rather than about identifiability. -/
theorem dyadic_alias_resolved_jointly (γ : ℝ) :
    ∃ γ' : ℝ, γ' ≠ γ ∧ Nyquist.Aliases 2 γ γ' ∧ ¬ JointAliases γ γ' := by
  obtain ⟨γ', hne, halias⟩ := exists_dyadic_alias_ne γ
  refine ⟨γ', hne, halias, ?_⟩
  intro hjoint
  exact hne ((jointAliases_iff_eq γ γ').mp hjoint).symm

/-! ## The operator: two Euler factors

On the joint grid the mode is an eigenvector of BOTH difference
directions, and the eigenvalues are the reciprocal Euler factors at 2
and at 3. -/

/-- The joint mode: `2^(rρ)·3^(mρ)`, the term a zero contributes on the
`{2^m 3^n}` grid. -/
def jmode (ρ : ℂ) : ℤ → ℤ → ℂ :=
  fun r m => (2 : ℂ) ^ ((r : ℂ) * ρ) * (3 : ℂ) ^ ((m : ℂ) * ρ)

/-- Backward differencing in the dyadic index. -/
def d2 (f : ℤ → ℤ → ℂ) : ℤ → ℤ → ℂ := fun r m => f r m - f (r - 1) m

/-- Backward differencing in the triadic index. -/
def d3 (f : ℤ → ℤ → ℂ) : ℤ → ℤ → ℂ := fun r m => f r m - f r (m - 1)

/-- The two directions commute, so `Δ₂^a Δ₃^b` is well defined
regardless of the order the differences are taken in. -/
theorem d2_d3_comm (f : ℤ → ℤ → ℂ) : d2 (d3 f) = d3 (d2 f) := by
  funext r m
  simp only [d2, d3]
  ring

/-- **The dyadic direction carries the Euler factor at 2.** -/
theorem d2_jmode (ρ : ℂ) (r m : ℤ) :
    d2 (jmode ρ) r m = Chain.Sym 2 ρ * jmode ρ r m := by
  have h2 : (2 : ℂ) ≠ 0 := two_ne_zero
  have hstep : (2 : ℂ) ^ (((r : ℂ) - 1) * ρ)
      = (2 : ℂ) ^ ((r : ℂ) * ρ) * (2 : ℂ) ^ (-ρ) := by
    rw [← Complex.cpow_add _ _ h2]
    congr 1
    ring
  simp only [d2, jmode, Chain.Sym]
  push_cast
  rw [hstep]
  ring

/-- **The triadic direction carries the Euler factor at 3.** -/
theorem d3_jmode (ρ : ℂ) (r m : ℤ) :
    d3 (jmode ρ) r m = Chain.Sym 3 ρ * jmode ρ r m := by
  have h3 : (3 : ℂ) ≠ 0 := three_ne_zero
  have hstep : (3 : ℂ) ^ (((m : ℂ) - 1) * ρ)
      = (3 : ℂ) ^ ((m : ℂ) * ρ) * (3 : ℂ) ^ (-ρ) := by
    rw [← Complex.cpow_add _ _ h3]
    congr 1
    ring
  simp only [d3, jmode, Chain.Sym]
  push_cast
  rw [hstep]
  ring

/-- Iterating the dyadic direction. -/
theorem d2_iter_jmode (ρ : ℂ) (a : ℕ) :
    (d2^[a]) (jmode ρ) = fun r m => (Chain.Sym 2 ρ) ^ a * jmode ρ r m := by
  induction a with
  | zero => funext r m; simp
  | succ n ih =>
      rw [Function.iterate_succ_apply', ih]
      funext r m
      simp only [d2, jmode, Chain.Sym]
      have h2 : (2 : ℂ) ≠ 0 := two_ne_zero
      have hstep : (2 : ℂ) ^ (((r : ℂ) - 1) * ρ)
          = (2 : ℂ) ^ ((r : ℂ) * ρ) * (2 : ℂ) ^ (-ρ) := by
        rw [← Complex.cpow_add _ _ h2]
        congr 1
        ring
      push_cast
      rw [hstep]
      ring

/-- Iterating the triadic direction. -/
theorem d3_iter_jmode (ρ : ℂ) (b : ℕ) :
    (d3^[b]) (jmode ρ) = fun r m => (Chain.Sym 3 ρ) ^ b * jmode ρ r m := by
  induction b with
  | zero => funext r m; simp
  | succ n ih =>
      rw [Function.iterate_succ_apply', ih]
      funext r m
      simp only [d3, jmode, Chain.Sym]
      have h3 : (3 : ℂ) ≠ 0 := three_ne_zero
      have hstep : (3 : ℂ) ^ (((m : ℂ) - 1) * ρ)
          = (3 : ℂ) ^ ((m : ℂ) * ρ) * (3 : ℂ) ^ (-ρ) := by
        rw [← Complex.cpow_add _ _ h3]
        congr 1
        ring
      push_cast
      rw [hstep]
      ring

end

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'JointLadder.two_pow_ne_three_pow' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms JointLadder.two_pow_ne_three_pow

/-- info: 'JointLadder.log_indep' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms JointLadder.log_indep

/-- info: 'JointLadder.jointAliases_iff_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms JointLadder.jointAliases_iff_eq

/-- info: 'JointLadder.dyadic_alias_resolved_jointly' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms JointLadder.dyadic_alias_resolved_jointly

/-- info: 'JointLadder.d2_jmode' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms JointLadder.d2_jmode

/-- info: 'JointLadder.d3_jmode' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms JointLadder.d3_jmode

/-- info: 'JointLadder.d2_iter_jmode' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms JointLadder.d2_iter_jmode

/-- info: 'JointLadder.d3_iter_jmode' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms JointLadder.d3_iter_jmode

end JointLadder
