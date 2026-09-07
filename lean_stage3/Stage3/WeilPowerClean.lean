/-
WeilPowerClean — the clean shell. Rung 5, eighteenth slice; worksheet
§ 13 block 13h. 2026-09-07.

The range `[a, b]` is cut into shells `[aρ^k, aρ^{k+1})`, `k = 0 .. K-1`,
at a ratio `ρ > 1`. A member at `ζ = ε' + iΔ` is *blocked on shell k* when
neither 13f nor 13g settles it there: 13g's sign needs `Δ · X_k` below
`lo`, 13f's bound falls under the shell's own length only when `Δ · X_k`
is above `hi`, with `X_k = aρ^k` the shell's left end. So one member's
blocking set is `{k : lo ≤ Δ X_k ≤ hi}`, and because `X_k` climbs by the
fixed factor `ρ` while the window `[lo, hi]` does not move, that set sits
inside `W + 1` consecutive shells for any `W` with `hi < lo · ρ^(W+1)`.
With `N` members, `N(W+1)` shells can be blocked; a `K` above that leaves
one shell clean, and on a clean shell every member is settled by 13f or
13g.

Sizes. `lo ≈ λπ³/(8ε')` from 13g's N2 at `Δ ≪ ε'`, `hi ≈ Cλε'/ε²` from
13f's geometric part. Their ratio `hi/lo ≈ 8Cε'²/(π³ε²)` carries no `λ`,
no `h` and no `T`, so with `ε' ≈ ε` (§ 8) it is an absolute constant and
`W` is one too. Range: `b/a = ρ^K` with `K > N(W+1)`, so
`log(b/a) > N(W+1) log ρ`; with `N ≤ c₁ log T' + c₂` the range is `T'`
raised to `c₁(W+1) log ρ`, and letting `ρ → 1` with `W` following,
`(W+1) log ρ → log(hi/lo)`, so the route needs `c₁ · log(hi/lo) < 1`.
That corrects unit 0351's `1/(2 ln 1.5) ≈ 1.23`, which priced one blocked
shell per member: at a window ratio of `8` the requirement is
`c₁ < 0.481`. Trudgian's `0.112` still clears it and the tree's crude
chain at about `7` still does not, so the leaf the route hangs on is
unchanged, only its constant. No factor is lost: `W` is absolute, and the
only quantity that grows is `K`, which is what the range buys.

Regime, as the block names it:
  P1 `1 ≤ ρ`;  P2 `0 < lo`;  P3 `hi < lo · ρ^(W+1)`;
  P4 `S.card * (W + 1) < K`.
Nothing here needs `a > 0`, `Δ > 0` or an upper bound on `ρ`: the window
hypothesis carries the work.

Defs. none. The shell scale is written out as `a * ρ ^ k`.

Theorems, with the hypotheses the block lists:
  blocked_card_le            P1, P2, P3         B.card ≤ W + 1
  exists_unblocked           P4                 a k < K in no B j
  exists_clean_shell         P1, P2, P3, P4     a k < K in no B j
  exists_clean_shell_of_count P1, P2, P3 and    a k < K in no B j
                             the count S.card ≤ N, N(W+1) < K

Pinned: blocked_card_le, exists_unblocked, exists_clean_shell,
exists_clean_shell_of_count.

What the next slice needs: 13i names `StmtShortCount` with its constant
`c₁` and derives it from `ArgCrude.StmtSCrude`, then instantiates `B j`
from 13f and 13g so that `hB` is discharged rather than assumed.

Axioms: every pinned theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.Statement

namespace WeilPowerClean

/-- One member's blocked shells sit inside `W + 1` consecutive shells:
the shell scale `a * ρ ^ k` climbs by the factor `ρ`, while the window
`[lo, hi]` does not move. -/
theorem blocked_card_le {a ρ lo hi d : ℝ} {W : ℕ} (B : Finset ℕ)
    (hρ : 1 ≤ ρ) (hlo : 0 < lo) (hW : hi < lo * ρ ^ (W + 1))
    (hB : ∀ k ∈ B, lo ≤ d * (a * ρ ^ k) ∧ d * (a * ρ ^ k) ≤ hi) :
    B.card ≤ W + 1 := by
  rcases B.eq_empty_or_nonempty with rfl | hne
  · simp
  have hρ0 : (0 : ℝ) ≤ ρ := le_trans zero_le_one hρ
  have hmin : lo ≤ d * (a * ρ ^ B.min' hne) := (hB _ (Finset.min'_mem B hne)).1
  have hmax : d * (a * ρ ^ B.max' hne) ≤ hi := (hB _ (Finset.max'_mem B hne)).2
  have hsub : B ⊆ Finset.Icc (B.min' hne) (B.max' hne) := fun k hk =>
    Finset.mem_Icc.mpr ⟨Finset.min'_le B k hk, Finset.le_max' B k hk⟩
  have hcard : B.card ≤ B.max' hne + 1 - B.min' hne := by
    have h := Finset.card_le_card hsub
    rwa [Nat.card_Icc] at h
  have hgap : B.max' hne ≤ B.min' hne + W := by
    by_contra hcon
    push_neg at hcon
    have hle : W + 1 ≤ B.max' hne - B.min' hne := by omega
    have hpow : ρ ^ (B.max' hne - B.min' hne) * ρ ^ B.min' hne = ρ ^ B.max' hne := by
      rw [← pow_add, Nat.sub_add_cancel (by omega)]
    have hstep : ρ ^ (W + 1) ≤ ρ ^ (B.max' hne - B.min' hne) := pow_le_pow_right₀ hρ hle
    have hnn : 0 ≤ d * (a * ρ ^ B.min' hne) := le_trans hlo.le hmin
    have key : lo * ρ ^ (W + 1) ≤ d * (a * ρ ^ B.max' hne) := by
      calc lo * ρ ^ (W + 1)
          ≤ d * (a * ρ ^ B.min' hne) * ρ ^ (B.max' hne - B.min' hne) :=
            mul_le_mul hmin hstep (pow_nonneg hρ0 _) hnn
        _ = d * (a * (ρ ^ (B.max' hne - B.min' hne) * ρ ^ B.min' hne)) := by ring
        _ = d * (a * ρ ^ B.max' hne) := by rw [hpow]
    linarith
  omega

/-- More shells than the members can block leaves one shell in no member's
blocking set. -/
theorem exists_unblocked {ι : Type*} [DecidableEq ι] (S : Finset ι)
    (B : ι → Finset ℕ) {K W : ℕ}
    (hB : ∀ j ∈ S, (B j).card ≤ W) (hK : S.card * W < K) :
    ∃ k, k < K ∧ ∀ j ∈ S, k ∉ B j := by
  have hcard : (S.biUnion B).card ≤ S.card * W := by
    refine le_trans Finset.card_biUnion_le (le_trans (Finset.sum_le_sum hB) ?_)
    rw [Finset.sum_const, smul_eq_mul]
  have hns : ¬ (Finset.range K ⊆ S.biUnion B) := by
    intro hsubs
    have h := Finset.card_le_card hsubs
    rw [Finset.card_range] at h
    omega
  obtain ⟨k, hk, hkn⟩ := Finset.not_subset.mp hns
  refine ⟨k, Finset.mem_range.mp hk, ?_⟩
  intro j hj hmem
  exact hkn (Finset.mem_biUnion.mpr ⟨j, hj, hmem⟩)

/-- The clean shell: `blocked_card_le` at each member, then
`exists_unblocked` at `W + 1`. -/
theorem exists_clean_shell {ι : Type*} [DecidableEq ι] (S : Finset ι)
    (B : ι → Finset ℕ) (d : ι → ℝ) {a ρ lo hi : ℝ} {W K : ℕ}
    (hρ : 1 ≤ ρ) (hlo : 0 < lo) (hW : hi < lo * ρ ^ (W + 1))
    (hB : ∀ j ∈ S, ∀ k ∈ B j,
       lo ≤ d j * (a * ρ ^ k) ∧ d j * (a * ρ ^ k) ≤ hi)
    (hK : S.card * (W + 1) < K) :
    ∃ k, k < K ∧ ∀ j ∈ S, k ∉ B j :=
  exists_unblocked S B (fun j hj => blocked_card_le (B j) hρ hlo hW (hB j hj)) hK

/-- The same with the member count given by a bound `N`. -/
theorem exists_clean_shell_of_count {ι : Type*} [DecidableEq ι]
    (S : Finset ι) (B : ι → Finset ℕ) (d : ι → ℝ)
    {a ρ lo hi : ℝ} {W K N : ℕ}
    (hρ : 1 ≤ ρ) (hlo : 0 < lo) (hW : hi < lo * ρ ^ (W + 1))
    (hB : ∀ j ∈ S, ∀ k ∈ B j,
       lo ≤ d j * (a * ρ ^ k) ∧ d j * (a * ρ ^ k) ≤ hi)
    (hN : S.card ≤ N) (hK : N * (W + 1) < K) :
    ∃ k, k < K ∧ ∀ j ∈ S, k ∉ B j :=
  exists_clean_shell S B d hρ hlo hW hB
    (lt_of_le_of_lt (Nat.mul_le_mul_right (W + 1) hN) hK)

/-- info: 'WeilPowerClean.blocked_card_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms blocked_card_le

/-- info: 'WeilPowerClean.exists_unblocked' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms exists_unblocked

/-- info: 'WeilPowerClean.exists_clean_shell' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms exists_clean_shell

/-- info: 'WeilPowerClean.exists_clean_shell_of_count' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms exists_clean_shell_of_count

end WeilPowerClean
