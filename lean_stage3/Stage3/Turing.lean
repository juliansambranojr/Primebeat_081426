/-
Turing — block S14 of `lean_stage3/design/stencil.md`, Turing's method, its analytic half. 2026-11-25.

A finite computation of the signs of Hardy's `Z` certifies `defect T = 0` up to a height, given
Littlewood's bound on `S₁ = ∫ S`. Three modules:

* `TuringS` (step 1): `S t = N t − θ(t)/π − 1` (the tree's `Stage3.argS`), `S₁ T = ∫_0^T S`,
  and Littlewood's bound `StmtLittlewood a b t₀ : |S₁ t₂ − S₁ t₁| ≤ a log t₂ + b`, reduced to
  three named pieces with the upper side proved.
* `TuringAvg` (step 2): Turing's lemma, the averaging of `S` over a window of length `h`.
* `TuringCert` (step 3): the certificate, `StmtSignData`, and `defect_zero_of_signs`.

**The objects.** `θ = Stage3.phaseTheta`, `θ T = ½ ∫_0^T Re ψ(1/4 + it/2) dt − (T/2) log π`, is
the continuous argument of `Γℝ(1/2 + it) = π^{−s/2} Γ(s/2)` from `θ 0 = 0`:
`LevinsonSize.gamma_part_eq` reads `Re ∫_a^b (Γℝ′/Γℝ)(1/2 + it) dt = θ b − θ a`, and along the
line `d/dt log Γℝ = i · Γℝ′/Γℝ`, so the real part of the integral is the change of `arg Γℝ`. So
`θ` is Riemann–Siegel's theta and `Z(t) = e^{iθ(t)} ζ(1/2 + it)`; the tree's `HardyZ` works with
`Λ(1/2 + it) = Γℝ ζ`, which is `|Γℝ| · Z` up to a constant sign, so it has `Z`'s sign changes.
`N = riemannZeta.N` counts `0 < Im ρ < T` (open), the defect `Defect.defect = allCount −
lineCount` counts `0 < Im ρ ≤ T` (closed); the certificate crosses between the two just above
`T₁` (`Defect.N_eq_allCount_right`).

**Turing's combinatorics, on paper** (derived here; each line is a proved theorem of step 2 or 3).
Fix `T₁` and `h > 0`. Let `t₀ < … < t_k ≤ T₁` and `T₁ < s₀ < … < s_m ≤ T₁ + h` carry strict
sign changes of `Z` between neighbours.
1. `lineCount T₁ ≥ k`, one zero on the line in each `(t_i, t_{i+1})`.
2. Take `T' > T₁` close, with no zero at heights in `(T₁, T']`: `N T' = allCount T₁`.
3. `S u − S T' = (N u − N T') − (θ u − θ T')/π`, exactly. For `u ∈ [T', T' + h]`,
   `N u − N T' ≥ c(u) = #{j : s_{j+1} < u}` (one zero in each `(s_j, s_{j+1})`, all above `T₁`)
   and `θ u − θ T' ≤ K (u − T')`, `K = (log((T₁ + 1 + h)/2) − log π + 97/T₁)/2` (Stirling,
   `Stage3.stmtDigammaLog_holds`). So `S T' ≤ S u − c(u) + K (u − T')/π`.
4. Average over `u ∈ [T', T' + h]`: `h S T' ≤ (S₁(T' + h) − S₁ T') − ∫ c + K h²/(2π)`, and
   `∫ c = Σ_j (T' + h − s_{j+1}) ≥ Σ_j (T₁ + h − s_{j+1})`.
5. Littlewood: `S₁(T' + h) − S₁ T' ≤ a log(T₁ + 1 + h) + b`. So `S T' ≤ E`,
   `E = (a log(T₁ + 1 + h) + b − Σ_j (T₁ + h − s_{j+1}))/h + h K/(2π)`.
6. `allCount T₁ = S T' + θ T'/π + 1`, and `θ T' → θ T₁`: if `θ T₁/π + 1 + E < k + 2` then
   `allCount T₁ ≤ k + 1`, the defect at `T₁` is at most `1`, it is even (`Defect.defect_even`:
   the zeros off the line pair as `ρ ↔ 1 − conj ρ`), so it is `0`, and it is monotone, so it is
   `0` below `T₁`.
The parity is the step of `2` the inequality has to beat. At Gram points (`θ(s_j)/π` integers)
the term `h K/(2π) − (1/h) Σ_j (T₁ + h − s_{j+1})` is about `3/2` and the Littlewood term `B/h`
falls with `h`, so `E < 2` is reachable; with no points above (`m = 0`) the error is
`B/h + K h/(2π) ≥ 2√(KB/(2π))`, about `2.2` at `t = 10³` for `B` of Trudgian's size (constants
from memory), and the certificate does not fire. Both on paper.

**Status.**

| step | name | content | status |
|---|---|---|---|
| 1 | `S`, `S₁`, `F` | the objects | def |
| 1 | `intervalIntegrable_S`, `S₁_sub` | `S` integrable, `S₁ t₂ − S₁ t₁ = ∫ S` | proved |
| 1 | `S₁_crude` | `|S₁ t₂ − S₁ t₁| ≤ (t₂ − t₁)(15 log t₂ + 75)` | proved; lost factor `t₂ − t₁` |
| 1 | `StmtLittlewood a b t₀` | `|S₁ t₂ − S₁ t₁| ≤ a log t₂ + b` | **open** |
| 1 | `StmtSplit` | `π ΔS₁ = ∫ F + Δ ∫_{1/2}^{2} log|ζ|` (argument principle, imaginary part) | **open** |
| 1 | `StmtOsc 2` | `|∫_{t₁}^{t₂} F| ≤ 2` (Dirichlet series on `Re = 2`) | **open** |
| 1 | `horizUpper_holds` | `∫_{1/2}^{2} log‖ζ(x + it)‖ dx ≤ (3/2) log t + (3/2) log 9` | proved |
| 1 | `StmtHorizLower a₂ b₂` | `∫_{1/2}^{2} log‖ζ(x + it)‖ dx ≥ −(a₂ log t + b₂)` | **open**, the core |
| 1 | `littlewood_of_pieces` | Split, Osc `c₀`, Lower ⊢ `StmtLittlewood ((3/2 + a₂)/π) ((c₀ + (3/2) log 9 + b₂)/π) 2` | proved |
| 2 | `theta_sub_le` | `θ u − θ t ≤ (u − t)(log(u/2) − log π + 97/t)/2` | proved |
| 2 | `avg_le`, `S_le_of_count` | Turing's lemma with a lower count `c` | proved |
| 2 | `turing_S_le` | `StmtLittlewood` ⊢ `S t ≤ (a log(t+h) + b)/h + h K/(2π)` | proved |
| 3 | `StmtSignData k t` | strict sign changes of `Λ(1/2 + it)` at given points | def; a computation, **open** (rigorous evaluation of `Z` out of scope) |
| 3 | `defect_mono`, `defect_zero_below` | the defect is monotone; `0` at `T₁` ⊢ `0` below | proved |
| 3 | `count_le_N_sub` | sign data above `T₁` ⊢ `c u ≤ N u − allCount T₁` | proved |
| 3 | `defect_zero_of_signs` | sign data, `StmtLittlewood`, `θ T₁/π + 1 + E < k + 2` ⊢ `∀ T ≤ T₁, defect T = 0` | proved |

Lost factor: `S₁_crude`'s `t₂ − t₁`. Fed to step 2 it returns the pointwise `|S| ≤ 15 log t + 75`
and certifies nothing; Littlewood's bound is the design, and its open core is
`StmtHorizLower`.

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.TuringS
import Stage3.TuringAvg
import Stage3.TuringCert

namespace Turing

/-- info: 'Turing.littlewood_of_pieces' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms littlewood_of_pieces

/-- info: 'Turing.S_le_of_count' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms S_le_of_count

/-- info: 'Turing.turing_S_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms turing_S_le

/-- info: 'Turing.defect_zero_of_signs' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms defect_zero_of_signs

end Turing
