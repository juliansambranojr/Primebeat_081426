/-
Superposition — the missing licence for building the residual from the zeros.

`Chain.A4_of_A1` gives the depth-N gain for a SINGLE mode. Every use of it on
the bench applies it to a SUM over zeta zeros (O34, O35). Nothing so far
permits that step. This file supplies it, and nothing else.

The number is not the target. If this derivation fails, the method that
produced 94% / 92% / 80% was never licensed; if it holds, those measurements
become a test of the model rather than of the algebra.
-/
import Chain

namespace Superposition

open Complex Chain Finset

variable {ι : Type*} {b : ℝ} {s : Finset ι} {ρ : ι → ℂ} {c : ι → ℂ}

/-- A finite superposition of ladder modes. -/
noncomputable def modeSum (b : ℝ) (ρ : ι → ℂ) (c : ι → ℂ) (s : Finset ι) : ℂ → ℂ :=
  fun r => ∑ i ∈ s, c i * mode b (ρ i) r

/-- `bdiff` distributes over a finite sum. -/
theorem bdiff_sum (f : ι → ℂ → ℂ) (s : Finset ι) :
    bdiff (fun r => ∑ i ∈ s, f i r) = fun r => ∑ i ∈ s, bdiff (f i) r := by
  funext r
  simp only [bdiff, Finset.sum_sub_distrib]

/-- **The licence.** If A1 holds for every mode in the family, then `N`
differences act on the superposition by acting on each mode separately. This is
what permits applying the depth gain to a sum over zeros. -/
theorem A4_sum_of_A1 (hA1 : ∀ i ∈ s, StmtA1 b (ρ i)) :
    ∀ (N : ℕ) (r : ℂ),
      (bdiff^[N]) (modeSum b ρ c s) r
        = ∑ i ∈ s, c i * (Sym b (ρ i)) ^ N * mode b (ρ i) r := by
  intro N
  induction N with
  | zero => intro r; simp [modeSum]
  | succ n ih =>
      intro r
      rw [Function.iterate_succ_apply']
      have hstep : (bdiff^[n]) (modeSum b ρ c s)
          = fun r => ∑ i ∈ s, (c i * (Sym b (ρ i)) ^ n) * mode b (ρ i) r := by
        funext r'; rw [ih r']
      rw [hstep, bdiff_sum]
      refine Finset.sum_congr rfl fun i hi => ?_
      have : bdiff (fun r => (c i * (Sym b (ρ i)) ^ n) * mode b (ρ i) r)
          = fun r => (c i * (Sym b (ρ i)) ^ n) * bdiff (mode b (ρ i)) r :=
        bdiff_smul _ _
      rw [this]
      show c i * (Sym b (ρ i)) ^ n * bdiff (mode b (ρ i)) r = _
      rw [hA1 i hi r]
      ring

/-- **Corollary — the falsifiable form.** Every mode is scaled by its own gain,
so the depth-`N` superposition is the depth-0 one with each term reweighted by
`(Sym b ρᵢ)^N`. The measured fractions in O34 test this model; they are not
inputs to it. -/
theorem depth_reweights_each_mode (hA1 : ∀ i ∈ s, StmtA1 b (ρ i)) (N : ℕ) (r : ℂ) :
    (bdiff^[N]) (modeSum b ρ c s) r
      = modeSum b ρ (fun i => c i * (Sym b (ρ i)) ^ N) s r := by
  rw [A4_sum_of_A1 hA1 N r]
  unfold modeSum
  exact Finset.sum_congr rfl fun i _ => by ring

/-! ## The integer table, welded to a superposition

`Chain.tableFrom_eq_bdiff_iter` carries the integer table onto `bdiff^[d]`.
`depth_reweights_each_mode` carries `bdiff^[d]` onto the reweighted sum. Nothing
composed them, so the chain reached the table and reached the zeros and did not
join the two — verified by grep across all eleven modules, `modeSum` occurring
only here and `tableFrom` only in five other files, disjointly. Notes entry 70.
-/

/-- **The table is a superposition, reweighted by depth.** An integer row
agreeing at every integer with a finite superposition of ladder modes: its cell
at `(r,d)` is that superposition with each mode carrying its own `(Sym b ρᵢ)^d`.

**The global hypothesis is not vacuous here, and that is the whole point.**
`Chain.tableFrom_mode` had to be localised to a window because a single mode
forces `w = ±1` on an integer row. A *sum* is different: only the total need be
integer-valued, and no individual `cᵢ · wᵢ^n` is constrained. Conjugate pairs are
the standard case — `ρ₂ = −ρ₁` with `c₁ = c₂ = 1/2` gives `Re(wⁿ)`, integer at
every `n`, with neither mode `±1`. That is exactly how Riemann–von Mangoldt
produces a real integer-valued row from non-real modes.

This is the theorem O34/O35 were measuring against when they reported 94% / 92%
/ 80% of the row-20 residual at depths 0, 3 and 6. -/
theorem tableFrom_eq_modeSum_reweighted (hA1 : ∀ i ∈ s, StmtA1 b (ρ i))
    {N : ℤ → ℤ} (hag : ∀ n : ℤ, ((N n : ℤ) : ℂ) = modeSum b ρ c s (n : ℂ))
    (r : ℤ) (d : ℕ) :
    ((Construction.tableFrom N r d : ℤ) : ℂ)
      = modeSum b ρ (fun i => c i * (Sym b (ρ i)) ^ d) s (r : ℂ) := by
  rw [Chain.tableFrom_eq_bdiff_iter hag r d, depth_reweights_each_mode hA1 d r]

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'Superposition.bdiff_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Superposition.bdiff_sum

/-- info: 'Superposition.A4_sum_of_A1' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Superposition.A4_sum_of_A1

/-- info: 'Superposition.depth_reweights_each_mode' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Superposition.depth_reweights_each_mode

/-- info: 'Superposition.tableFrom_eq_modeSum_reweighted' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Superposition.tableFrom_eq_modeSum_reweighted

end Superposition
