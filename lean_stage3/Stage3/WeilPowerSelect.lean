/-
WeilPowerSelect — selection of the target. Rung 5, tenth slice, worksheet
section 8. 2026-09-06.

The worksheet's need: a target with `ε'² − Δ² ≤ ε² + K'π²λ/h` for every
other zero in a widened box, so the cluster (§9) contributes at most a
bounded factor. Two independent pieces answer it.

Far heights need no selection at all. `farDelta_le`: a zero with real
part offset `ε' ∈ [0, 1/2]` and height offset `1/2 ≤ |Δ|` already has
`ε'² − Δ² ≤ 0`, true against any target with `0 < ε` — the worksheet's
first paragraph, no choice of target involved.

Near heights (`|Δ| < 1/2`) need the target chosen. The worksheet's
argument — `t_k` a zero of largest real part among zeros with
`|Im| ≤ T + k/2`, the sequence `ε(t_k)` nondecreasing and bounded by
`1/2`, so it cannot climb by more than a threshold at every step for
long — turns out not to need the "nondecreasing" half at all: boundedness
of `ε(t_k)²` at every step already stops the climb (`exists_step_le`
below). This module takes `E : ℕ → ℝ` ("the largest real-part offset
among zeros in box `k`") as a parameter, the same choice unit 0341 made
for `ε', Δ, ε, h`. Wiring `E` to an actual finite set of zeros — the
worksheet's "maximum over a finite set", the argument of
`WeilOnLine.lowSet_finite` widened, or a band count — is left to
whichever later module needs it; `K'` stays a free positive parameter,
exactly as in the worksheet, which never assigns it a value. Monotonicity
of `E` is kept as a hypothesis only where it is actually used:
`target_ge_box`, the worksheet's closing sentence.

`exists_step_le` is the pigeonhole lemma: a sequence `f` with `f 0 ≥ 0`,
bounded above by `B` at every step, cannot climb by more than `δ` at each
of `N` steps once `N·δ > B` — proved by contradiction, since climbing by
more than `δ` at every one of `N` steps would carry `f 0` past
`B − N·δ < 0`, i.e. would force `f 0 < 0`. No monotonicity hypothesis on
`f` is needed or used.

`exists_target_step` specializes it: `f = E²` is bounded by `1/4`
(`E k ≤ 1/2`, `E k ≥ 0`), `δ = δSel K' λ h = K'π²λ/h`,
`N = ⌊h/(4K'π²λ)⌋₊ + 1` is exactly the threshold `B/δ` rounded up, so
there is a step `k ≤ h/(4K'π²λ)` with `E(k+1)² ≤ E(k)² + K'π²λ/h`.

`target_bound` reads that `k` as the worksheet's `t_k`: any zero at real
part `ε'` inside the `(k+1)`-box (so `ε' ≤ E(k+1)`, `E(k+1)` being that
box's maximum) satisfies `ε'² ≤ E(k)² + K'π²λ/h`, the cluster's criterion.
`target_height_le` reads the same `k` as an explicit height bound: the
box at step `k` sits at height `T + k/2 ≤ T + h/(8K'π²λ)`. The
worksheet's rougher "`+ 1`" came from rounding `(k+1)/2` rather than
`k/2`; once the step count itself is explicit (`Nat.floor`, not a crude
round number) the slack is not needed, so the module's bound corrects it
rather than restating it. `target_ge_box`: `E 0 ≤ E k`, the target's own
`ε` is at least the box zero's, by monotonicity alone.

What this leaves out: `E`'s connection to an actual off-line zero set,
and the cluster itself (worksheet § 9), which combines this module's
bound with `WeilPowerCompare.rate_neg_of_ge`.
-/
import Stage3.WeilPowerCompare

namespace WeilPowerSelect

noncomputable section

open Real

/-- **Far heights need no selection.** A zero with real part offset in
`[0, 1/2]` and height offset at least `1/2` already has `ε'² ≤ Δ²`, with
no choice of target at all. -/
theorem farDelta_le {ε' Δ : ℝ} (hε'0 : 0 ≤ ε') (hε'half : ε' ≤ 1 / 2)
    (hΔ : 1 / 2 ≤ |Δ|) : ε' ^ 2 - Δ ^ 2 ≤ 0 := by
  have h1 : ε' ^ 2 ≤ 1 / 4 := by nlinarith
  have h2 : (1 / 4 : ℝ) ≤ Δ ^ 2 := by
    have habs := sq_abs Δ
    nlinarith [sq_nonneg (|Δ| - 1 / 2)]
  linarith

/-- **The pigeonhole lemma.** A sequence, nonnegative at `0` and bounded
above by `B` at every step, cannot climb by more than `δ` at every one of
`N` steps once `N·δ > B`. Monotonicity of `f` is not needed: boundedness
at each step is already enough to stop the climb. -/
theorem exists_step_le {f : ℕ → ℝ} {B δ : ℝ}
    (hbound : ∀ k, f k ≤ B) (hnonneg : 0 ≤ f 0) {N : ℕ} (hN : B < (N : ℝ) * δ) :
    ∃ k < N, f (k + 1) ≤ f k + δ := by
  by_contra hcon
  push_neg at hcon
  have hstep : ∀ k, k ≤ N → f 0 + (k : ℝ) * δ ≤ f k := by
    intro k
    induction k with
    | zero => intro _; simp
    | succ n ih =>
      intro hk
      have hnN : n < N := lt_of_lt_of_le (Nat.lt_succ_self n) hk
      have hstepn : f n + δ < f (n + 1) := hcon n hnN
      have ihn : f 0 + (n : ℝ) * δ ≤ f n := ih (le_of_lt hnN)
      have hcast : ((n + 1 : ℕ) : ℝ) = (n : ℝ) + 1 := by push_cast; ring
      rw [hcast]
      nlinarith [ihn, hstepn]
  have hfin := hstep N le_rfl
  have hb := hbound N
  linarith [hfin, hb, hnonneg, hN]

/-- The step size, `K'π²λ/h`. -/
def δSel (K' lam h : ℝ) : ℝ := K' * Real.pi ^ 2 * lam / h

theorem δSel_pos {K' lam h : ℝ} (hK' : 0 < K') (hlam : 0 < lam) (hh : 0 < h) :
    0 < δSel K' lam h := by
  unfold δSel
  have : (0 : ℝ) < Real.pi ^ 2 := by positivity
  positivity

/-- **The step exists, with its height explicit.** `E`'s square cannot
climb by more than `δSel K' λ h` at every step past `h/(4K'π²λ)`. -/
theorem exists_target_step {E : ℕ → ℝ}
    (hbound : ∀ k, 0 ≤ E k ∧ E k ≤ 1 / 2) {K' lam h : ℝ}
    (hK' : 0 < K') (hlam : 0 < lam) (hh : 0 < h) :
    ∃ k : ℕ, (k : ℝ) ≤ h / (4 * K' * Real.pi ^ 2 * lam) ∧
      (E (k + 1)) ^ 2 ≤ (E k) ^ 2 + δSel K' lam h := by
  have hpi : (0 : ℝ) < Real.pi ^ 2 := by positivity
  have hden : (0 : ℝ) < 4 * K' * Real.pi ^ 2 * lam := by positivity
  set thr : ℝ := h / (4 * K' * Real.pi ^ 2 * lam) with hthr_def
  have hthr_nonneg : 0 ≤ thr := by rw [hthr_def]; positivity
  set N : ℕ := ⌊thr⌋₊ + 1 with hN_def
  have hNthr : thr < (N : ℝ) := by
    rw [hN_def]
    push_cast
    exact Nat.lt_floor_add_one thr
  have hfbound : ∀ k, (E k) ^ 2 ≤ (1 / 2 : ℝ) ^ 2 := fun k =>
    pow_le_pow_left₀ (hbound k).1 (hbound k).2 2
  have hfnonneg : (0 : ℝ) ≤ (E 0) ^ 2 := sq_nonneg _
  have heq : thr * δSel K' lam h = (1 / 2 : ℝ) ^ 2 := by
    rw [hthr_def]
    unfold δSel
    field_simp
    ring
  have hN : (1 / 2 : ℝ) ^ 2 < (N : ℝ) * δSel K' lam h := by
    rw [← heq]
    have hδpos := δSel_pos hK' hlam hh
    exact mul_lt_mul_of_pos_right hNthr hδpos
  obtain ⟨k, hkN, hstep⟩ :=
    exists_step_le (f := fun k => (E k) ^ 2) hfbound hfnonneg hN
  refine ⟨k, ?_, hstep⟩
  have hkfloor : k ≤ ⌊thr⌋₊ := by omega
  calc (k : ℝ) ≤ (⌊thr⌋₊ : ℝ) := by exact_mod_cast hkfloor
    _ ≤ thr := Nat.floor_le hthr_nonneg

/-- **Selection of the target.** There is a step `k`, at height at most
`h/(4K'π²λ)` above the box's own step, whose `(k+1)`-neighbours all meet
the cluster's criterion against `E k`. -/
theorem target_bound {E : ℕ → ℝ}
    (hbound : ∀ k, 0 ≤ E k ∧ E k ≤ 1 / 2) {K' lam h : ℝ}
    (hK' : 0 < K') (hlam : 0 < lam) (hh : 0 < h) :
    ∃ k : ℕ, (k : ℝ) ≤ h / (4 * K' * Real.pi ^ 2 * lam) ∧
      ∀ ε', 0 ≤ ε' → ε' ≤ E (k + 1) → ε' ^ 2 ≤ (E k) ^ 2 + δSel K' lam h := by
  obtain ⟨k, hk, hstep⟩ := exists_target_step hbound hK' hlam hh
  refine ⟨k, hk, fun ε' hε'0 hε'le => ?_⟩
  have h1 : ε' ^ 2 ≤ (E (k + 1)) ^ 2 := pow_le_pow_left₀ hε'0 hε'le 2
  linarith [hstep]

/-- The step's height above the box: `T + k/2 ≤ T + h/(8K'π²λ)`. -/
theorem target_height_le {k : ℕ} {K' lam h T : ℝ}
    (hk : (k : ℝ) ≤ h / (4 * K' * Real.pi ^ 2 * lam)) :
    T + (k : ℝ) / 2 ≤ T + h / (8 * K' * Real.pi ^ 2 * lam) := by
  have heq : h / (4 * K' * Real.pi ^ 2 * lam) / 2 = h / (8 * K' * Real.pi ^ 2 * lam) := by
    rw [div_div]
    ring_nf
  have h2 : (k : ℝ) / 2 ≤ h / (4 * K' * Real.pi ^ 2 * lam) / 2 := by linarith
  linarith [heq, h2]

/-- **The target's own real-part offset is at least the box zero's.** -/
theorem target_ge_box {E : ℕ → ℝ} (hmono : Monotone E) (k : ℕ) : E 0 ≤ E k :=
  hmono (Nat.zero_le k)

end

/-- info: 'WeilPowerSelect.farDelta_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms farDelta_le

/-- info: 'WeilPowerSelect.exists_step_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms exists_step_le

/-- info: 'WeilPowerSelect.target_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms target_bound

/-- info: 'WeilPowerSelect.target_height_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms target_height_le

end WeilPowerSelect
