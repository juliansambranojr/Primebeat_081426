/-
BasinChain — block S15 of `lean_stage3/design/stencil.md`, the chain from no right zeros.
2026-11-25.

Pins: `PINS.md` § Current, "the chain to the goal from no right zeros". Sizes checked first:
`lean_stage3/checks/basinchain/sizes.py`, `.out`.

**The chain, as built.** For a real `Q` with `Q′(x) = Q′(1 − x)`, `Q(1/2) ≠ 0`, `Q(0) = 1`,
`V = ConreyCount.V Q (log T)`, `D = Defect.defect`, `S = Turing.S`:
1. `StmtNoRightZeros Q T₀` (`BasinChainCount`): for `T ≥ T₀`, `V` has no zero with
   `1/2 < Re s ≤ 3`, `T/4 ≤ Im s ≤ 2T`. No edge avoidance is asked; it holds at every height
   off the finitely many heights of zeros. Non-vacuous: RH gives it for `Q = 1`
   (`noRightZeros_one_of_rh`).
2. The count with no losses (`BasinChainCount.count_exact`, `increment_window`): at good
   heights `T/4 ≤ a < b ≤ 2T`, `T ≥ T₁(Q)`,
   `D b − D a < (S b + h(b)/π) − (S a + h(a)/π) + 1 + 2 arcsin(r₀)/π`,
   `r₀ = π²/6 − 1 + 1/100`, `h(t) = Im ∫_{1/2}^{3} V′/V (x + it) dx`.
3. Littlewood for `arg V` (`BasinChainSplit.split_V`): `∫_{t₁}^{t₂} h = J(t₁) − J(t₂)`,
   `J(t) = ∫_{1/2}^{3} log‖V(x + it)‖ dx`; `J ≤ (5/2) log(A_Q t)` (`BasinChainAvg.logJ_le`);
   `J ≥ −(a₂ log t + b₂)` is the open `StmtVHorizLower Q a₂ b₂ T₀'`.
4. Turing's averaging (`BasinChainAvg.increment_avg`, `defect_step`): `a` over `[T/2, 3T/4]`,
   `b` over `[T, 5T/4]`, `LittlewoodSharp.littlewood_sharp` for `∫ S`:
   `D T − D(3T/4) ≤ 4(α log 2T + β)/T + c₀`, `c₀ ≈ 1.455 < 2`, so `D T = D(3T/4)` for large `T`,
   and `D` is constant from some height on (`defect_eventually_const`).
5. `Defect.rh_iff_defect_zero`, with the constant shown to be `0`.

**The design finding: step 4 does not reach `D = 0`.** Monotonicity is right as the design says
(`D T ≤ D T'` for `T ≤ T'`, so `D T' = 0` gives `D T = 0` below; `TuringCert.defect_zero_below`).
But the premise `D T' = 0` at a large `T'` is not what the averaging gives. `V` depends on
`L = log T` and is controlled on `[T/4, 2T]` only (`ConreyCount` header; `DigammaBound` header:
at `t ≈ T/2^j`, `V ≈ Q(j log 2/(2L))`), so every count is a difference `D b − D a` over a window
inside `[T/4, 2T]`; the averaging makes the increments vanish and never sees `D` itself. The
result is that the zeros off the line are finitely many. RH needs one more input, the value
of `D` at one height `T₂` above the chain's threshold, and that threshold is ineffective in the
tree (`log log T₂ > 166`, from `DigammaBound.gamma_ratio`'s `B = e^{2|C| + 160}`,
`sizes.out` § 4). It is stated here as the named `StmtNoFiniteDefect` (the defect, once
constant, is `0`), which with the chain gives RH (`rh_of_noRightZeros`). It is not a lost factor:
the sizes close (`c₀ + E < 2` with `E = O(log T/T)`); the count's form leaves a constant
unseen. No size statement removes it; a count that sees `D` alone would need one `V` on
`[t₀, T]` for a fixed `t₀`, which this `V` is not.

| step | name | statement | status |
|---|---|---|---|
| 1 | `StmtNoRightZeros Q T₀` | no zero of `V` with `1/2 < Re ≤ 3`, `Im ∈ [T/4, 2T]`, `T ≥ T₀` | def (the hypothesis) |
| 1 | `noRightZeros_one_of_rh` | RH ⊢ `StmtNoRightZeros 1 T₀` | PROVED |
| 2 | `count_exact` | the count, every size exact | PROVED |
| 2 | `right_edge_le_arcsin`, `V_near_one` | `|R| ≤ 2 arcsin r₀` | PROVED |
| 2 | `increment_window` | the increment at good heights | PROVED |
| 3 | `split_logDeriv`, `split_V` | `∫ h = J t₁ − J t₂` | PROVED |
| 3 | `logJ_le` | the upper side of `J` | PROVED |
| 3 | `StmtVHorizLower Q a₂ b₂ T₀'` | the lower side of `J` | OPEN (def; route in `BasinChainAvg`) |
| 4 | `avg_double`, `increment_avg` | the averaged increment | PROVED |
| 4 | `defect_step` | `D T = D(3T/4)` for large `T` | PROVED |
| 4 | `defect_eventually_const` | `∃ T₂, ∀ T ≥ T₂, D T = D T₂` | PROVED |
| 5 | `StmtNoFiniteDefect` | `D` constant from `T₂` on ⊢ `D T₂ = 0` | OPEN (def; the base) |
| 5 | `rh_of_noRightZeros` | 1, 3's lower side, 5's base ⊢ RH | PROVED |

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.BasinChainAvg

noncomputable section

namespace BasinChain

open Polynomial

/-- **Open: the base.** Wherever the defect is constant from a height on, it is `0` there: the
off-line zeros are none or infinitely many. -/
def StmtNoFiniteDefect : Prop :=
  ∀ T₂ : ℝ, (∀ T : ℝ, T₂ ≤ T → Defect.defect T = Defect.defect T₂) → Defect.defect T₂ = 0

/-- From `D T = D(3T/4)` for `T ≥ T₂`, `D` is constant on `[T₂, ∞)`. -/
theorem const_of_step {T₂ : ℝ} (hT₂ : 0 < T₂)
    (hstep : ∀ T : ℝ, T₂ ≤ T → Defect.defect T = Defect.defect (3 * T / 4)) :
    ∀ T : ℝ, T₂ ≤ T → Defect.defect T = Defect.defect T₂ := by
  have key : ∀ n : ℕ, ∀ T : ℝ, T₂ ≤ T → T ≤ (4 / 3 : ℝ) ^ n * T₂ →
      Defect.defect T = Defect.defect T₂ := by
    intro n
    induction n with
    | zero =>
      intro T h1 h2
      rw [pow_zero, one_mul] at h2
      rw [le_antisymm h2 h1]
    | succ n ih =>
      intro T h1 h2
      rcases le_or_gt T₂ (3 * T / 4) with h | h
      · rw [hstep T h1]
        apply ih _ h
        rw [pow_succ] at h2
        nlinarith [pow_pos (by norm_num : (0 : ℝ) < 4 / 3) n]
      · apply le_antisymm
        · rw [hstep T h1]
          exact Turing.defect_mono h.le
        · exact Turing.defect_mono h1
  intro T hT
  obtain ⟨n, hn⟩ := pow_unbounded_of_one_lt (T / T₂) (by norm_num : (1 : ℝ) < 4 / 3)
  refine key n T hT ?_
  rw [div_lt_iff₀ hT₂] at hn
  exact hn.le

/-- **The chain: finitely many zeros off the line.** For `Q′` symmetric, `Q(1/2) ≠ 0`,
`Q(0) = 1`, no right zeros of `V` from `T₀` on and the lower side of `J`: the defect is constant
from some height on. -/
theorem defect_eventually_const {Q : ℝ[X]}
    (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x))
    (hQh : Q.eval (1/2) ≠ 0) (hQ0 : Q.eval 0 = 1) {T₀ a₂ b₂ T₀' : ℝ}
    (hNR : StmtNoRightZeros Q T₀) (hLow : StmtVHorizLower Q a₂ b₂ T₀') (ha₂ : 0 ≤ a₂) :
    ∃ T₂ : ℝ, ∀ T : ℝ, T₂ ≤ T → Defect.defect T = Defect.defect T₂ := by
  obtain ⟨T₂, hT₂, hstep⟩ := defect_step hQ hQh hQ0 hNR hLow ha₂
  exact ⟨T₂, const_of_step hT₂ hstep⟩

/-- **RH from no right zeros**, with the lower side of `J` and the base as named hypotheses. -/
theorem rh_of_noRightZeros {Q : ℝ[X]}
    (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x))
    (hQh : Q.eval (1/2) ≠ 0) (hQ0 : Q.eval 0 = 1) {T₀ a₂ b₂ T₀' : ℝ}
    (hNR : StmtNoRightZeros Q T₀) (hLow : StmtVHorizLower Q a₂ b₂ T₀') (ha₂ : 0 ≤ a₂)
    (hbase : StmtNoFiniteDefect) :
    RiemannHypothesis := by
  obtain ⟨T₂, hconst⟩ := defect_eventually_const hQ hQh hQ0 hNR hLow ha₂
  have h0 := hbase T₂ hconst
  apply Defect.rh_iff_defect_zero.mpr
  intro T
  rcases le_or_gt T₂ T with h | h
  · rw [hconst T h, h0]
  · exact Turing.defect_zero_below h0 T h.le

/-- info: 'BasinChain.const_of_step' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms const_of_step

/-- info: 'BasinChain.defect_eventually_const' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms defect_eventually_const

/-- info: 'BasinChain.rh_of_noRightZeros' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rh_of_noRightZeros

/-- info: 'BasinChain.increment_window' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms increment_window

/-- info: 'BasinChain.defect_step' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms defect_step

end BasinChain

end
