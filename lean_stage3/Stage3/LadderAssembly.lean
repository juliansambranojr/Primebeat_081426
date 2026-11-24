/-
LadderAssembly — block S5 of `lean_stage3/design/stencil.md`. 2026-11-24.

Julian, 2026-11-24: assemble the ladder route; step (D) and the assembled
theorem. Block S4 (`ResidueRoute.isolated_boundary_mode_false`) needs a mode
`u₁ = 2^(−ρ₁)` isolated in `K σ = closure {2^(−ρ) : Re ρ ≥ σ}` and on the frontier
of the component of `0` in `{|u| < 2^(−σ)} ∖ K σ`.

(D) If `Θ = Re ρ₁` bounds every real part, every `u ∈ K σ` has `|u| ≥ 2^(−Θ)`, so
the open disc `|u| < 2^(−Θ)` misses `K σ`, is connected, holds `0` and sits in the
component. `|u₁| = 2^(−Θ)` puts `u₁` in the closure of that disc, and `u₁ ∈ K σ`
keeps it out of the component: `u₁` is on its frontier, for every `σ ≤ Θ`.

Assembly. Off the line, a tame top is `ρ₁` with `1/2 < Re ρ₁`, every real part
`≤ Re ρ₁`, and `σ₀ ∈ (1/2, Re ρ₁)`, `ε > 0` with every mode of `Re ρ ≥ σ₀` other
than `u₁` at distance `≥ ε` from it. Isolation passes to `K σ` for `σ ≥ σ₀` with
`ε/2`, and S4 at `Θ = Re ρ₁`, `σ = max E σ₀ < Θ` gives `False`.

  top_mode_on_frontier   every Re ρ ≤ Re ρ₁, σ ≤ Re ρ₁ ⊢ 2^(−ρ₁) on the frontier
                         of the component of 0 in ball 0 (2^(−σ)) ∖ K σ
  rh_of_ladder_tame      the ladder bound H, a tame top off the line ⊢ RiemannHypothesis

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.ResidueRoute
import Stage3.ClosedLoopJoin

namespace LadderAssembly

open Filter Topology Kadiri FiniteOffLine

/-- **(D) The top mode is on the frontier.** If every zero has real part at most
`Re ρ₁` and `σ ≤ Re ρ₁`, the mode `2^(−ρ₁)` lies on the frontier of the connected
component of `{|u| < 2^(−σ)} ∖ K σ` that holds `0`. -/
theorem top_mode_on_frontier (ρ₁ : Kadiri.NontrivialZeros)
    (htop : ∀ ρ : Kadiri.NontrivialZeros, (ρ : ℂ).re ≤ (ρ₁ : ℂ).re)
    {σ : ℝ} (hσ : σ ≤ (ρ₁ : ℂ).re) :
    (2:ℂ) ^ (-(ρ₁ : ℂ)) ∈
      frontier (connectedComponentIn
        (Metric.ball (0:ℂ) ((2:ℝ) ^ (-σ)) \ ResidueRoute.K σ) 0) := by
  set Θ := (ρ₁ : ℂ).re with hΘdef
  set S := Metric.ball (0:ℂ) ((2:ℝ) ^ (-σ)) \ ResidueRoute.K σ with hSdef
  have hr : (0:ℝ) < (2:ℝ) ^ (-Θ) := by positivity
  -- every point of `K σ` has norm at least `2^(−Θ)`
  have hKlow : ResidueRoute.K σ ⊆ {u : ℂ | (2:ℝ) ^ (-Θ) ≤ ‖u‖} := by
    apply closure_minimal
    · rintro u ⟨ρ, -, rfl⟩
      show (2:ℝ) ^ (-Θ) ≤ ‖(2:ℂ) ^ (-(ρ : ℂ))‖
      rw [norm_two_cpow, Complex.neg_re]
      exact Real.rpow_le_rpow_of_exponent_le (by norm_num) (neg_le_neg (htop ρ))
    · exact isClosed_le continuous_const continuous_norm
  -- the disc of radius `2^(−Θ)` sits in `S`
  have hball : Metric.ball (0:ℂ) ((2:ℝ) ^ (-Θ)) ⊆ S := by
    intro u hu
    refine ⟨?_, ?_⟩
    · rw [Metric.mem_ball] at hu ⊢
      exact hu.trans_le
        (Real.rpow_le_rpow_of_exponent_le (by norm_num) (neg_le_neg hσ))
    · intro hK
      have h1 := hKlow hK
      rw [Metric.mem_ball, dist_zero_right] at hu
      exact absurd h1 (not_le.mpr hu)
  have hsub : Metric.ball (0:ℂ) ((2:ℝ) ^ (-Θ)) ⊆ connectedComponentIn S 0 :=
    (convex_ball (0:ℂ) _).isPreconnected.subset_connectedComponentIn
      (Metric.mem_ball_self hr) hball
  have hu₁K : (2:ℂ) ^ (-(ρ₁ : ℂ)) ∈ ResidueRoute.K σ :=
    subset_closure ⟨ρ₁, hσ, rfl⟩
  have hnorm : ‖(2:ℂ) ^ (-(ρ₁ : ℂ))‖ = (2:ℝ) ^ (-Θ) := by
    rw [norm_two_cpow, Complex.neg_re]
  have hcl : (2:ℂ) ^ (-(ρ₁ : ℂ)) ∈ closure (connectedComponentIn S 0) := by
    apply closure_mono hsub
    rw [closure_ball (0:ℂ) hr.ne', Metric.mem_closedBall, dist_zero_right, hnorm]
  have hnot : (2:ℂ) ^ (-(ρ₁ : ℂ)) ∉ connectedComponentIn S 0 := fun h =>
    (connectedComponentIn_subset S 0 h).2 hu₁K
  rw [frontier, Set.mem_sdiff]
  exact ⟨hcl, fun h => hnot (interior_subset h)⟩

/-- **The ladder route, assembled.** Under the ladder bound
`|ψ(2^k) − 2^k| ≤ C·k²·√2^k` for `k ≥ 1`, if every failure of the Riemann
hypothesis has a tame top — a zero `ρ₁` with `1/2 < Re ρ₁`, every real part at most
`Re ρ₁`, and `σ₀ ∈ (1/2, Re ρ₁)`, `ε > 0` with every mode of real part `≥ σ₀` other
than `2^(−ρ₁)` at distance at least `ε` from it — then the Riemann hypothesis
holds. -/
theorem rh_of_ladder_tame {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → ‖(Chebyshev.psi ((2:ℝ)^k) : ℂ) - (((2:ℝ)^k : ℝ) : ℂ)‖
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    (htame : ¬ RiemannHypothesis → ∃ ρ₁ : Kadiri.NontrivialZeros,
      1/2 < (ρ₁:ℂ).re ∧ (∀ ρ : Kadiri.NontrivialZeros, (ρ:ℂ).re ≤ (ρ₁:ℂ).re) ∧
      ∃ σ₀ ε : ℝ, 1/2 < σ₀ ∧ σ₀ < (ρ₁:ℂ).re ∧ 0 < ε ∧
        ∀ ρ : Kadiri.NontrivialZeros, σ₀ ≤ (ρ:ℂ).re →
          (2:ℂ)^(-(ρ:ℂ)) ≠ (2:ℂ)^(-(ρ₁:ℂ)) →
          ε ≤ ‖(2:ℂ)^(-(ρ:ℂ)) - (2:ℂ)^(-(ρ₁:ℂ))‖) :
    RiemannHypothesis := by
  by_contra hRH
  obtain ⟨ρ₁, -, htop, σ₀, ε, hσ₀, hσ₀Θ, hε, hiso⟩ := htame hRH
  obtain ⟨E, -, hEΘ, hfalse⟩ :=
    ResidueRoute.isolated_boundary_mode_false hH hσ₀ hσ₀Θ ρ₁.2.1.2.le htop
  have hσΘ : max E σ₀ < (ρ₁ : ℂ).re := max_lt hEΘ hσ₀Θ
  refine hfalse (max E σ₀) (le_max_left _ _) ρ₁ hσΘ ⟨ε / 2, half_pos hε, ?_⟩
    (top_mode_on_frontier ρ₁ htop hσΘ.le)
  intro u hu hdist
  -- `u` is in the closure of `{u₁}`
  have hcl : u ∈ closure ({(2:ℂ) ^ (-(ρ₁ : ℂ))} : Set ℂ) := by
    rw [Metric.mem_closure_iff]
    intro δ hδ
    have hgap : 0 < ε / 2 - ‖u - (2:ℂ) ^ (-(ρ₁ : ℂ))‖ := by linarith
    obtain ⟨v, hv, hvd⟩ := Metric.mem_closure_iff.mp hu
      (min δ (ε / 2 - ‖u - (2:ℂ) ^ (-(ρ₁ : ℂ))‖)) (lt_min hδ hgap)
    obtain ⟨ρ, hρσ, rfl⟩ := hv
    have hρσ₀ : σ₀ ≤ (ρ : ℂ).re := (le_max_right E σ₀).trans hρσ
    have hd1 : dist u ((2:ℂ) ^ (-(ρ : ℂ))) < δ := hvd.trans_le (min_le_left _ _)
    have hd2 : dist u ((2:ℂ) ^ (-(ρ : ℂ))) < ε / 2 - ‖u - (2:ℂ) ^ (-(ρ₁ : ℂ))‖ :=
      hvd.trans_le (min_le_right _ _)
    have heq : (2:ℂ) ^ (-(ρ : ℂ)) = (2:ℂ) ^ (-(ρ₁ : ℂ)) := by
      by_contra hne
      have h1 := hiso ρ hρσ₀ hne
      have h2 : ‖(2:ℂ) ^ (-(ρ : ℂ)) - (2:ℂ) ^ (-(ρ₁ : ℂ))‖
          ≤ ‖(2:ℂ) ^ (-(ρ : ℂ)) - u‖ + ‖u - (2:ℂ) ^ (-(ρ₁ : ℂ))‖ := norm_sub_le_norm_sub_add_norm_sub _ _ _
      rw [dist_eq_norm, ← norm_neg, neg_sub] at hd2
      linarith
    exact ⟨_, rfl, heq ▸ hd1⟩
  rwa [closure_singleton, Set.mem_singleton_iff] at hcl

/-- info: 'LadderAssembly.top_mode_on_frontier' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms top_mode_on_frontier

/-- info: 'LadderAssembly.rh_of_ladder_tame' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rh_of_ladder_tame

end LadderAssembly
