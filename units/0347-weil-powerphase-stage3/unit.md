---
id: 0347
date: 2026-09-06
type: formalization
title: WeilPowerPhase.lean: the tail product's phase; S is its principal part up to 2q; Re(S²) bounded below explicitly
refs: [lean_stage3/Stage3/WeilPowerPhase.lean::re_S_sq_ge, lean_stage3/Stage3/WeilPowerPhase.lean::norm_S_sub_le, lean_stage3/Stage3/WeilPowerPhase.lean::T_eq_mul, lean_stage3/Stage3/WeilPowerPhase.lean::sigma_ge]
supersedes: []
follows: 0346
sealed: false
---

**Question.** Requirement (b) of worksheet section `thirteen` (`rung5.md#13`): the argument of the tail product. Unit `0333` controls its modulus; the sign of a cluster member's term is a statement about its argument, and nothing proved it.

**What was proved.** `module_lines` 342 lines, `theorems_proved` 21 theorems, `defs` 7 definitions, `pins_module` 4 axiom pins each at `axioms` 3 axioms, `sorries` 0 sorries. The tail product is written as an exponential and its exponent split: `T_eq_mul` says `T m w n` is `exp(w² σ_n)` times `exp(δ_n)`, with `σ_n` the partial tail sum of `1/(π²(j+1)²)` and `δ_n` the sum of `log(1+x_j) − x_j`; `norm_delta_le` bounds `‖δ_n‖` by the quartic `q = ‖w‖⁴/(π⁴(m+1)³)`, through Mathlib's bound on `log(1+x) − x` at `‖x‖ ≤ 1/2`. The full tail sum `σ` is a `tsum` with `sigma_ge` and `sigma_le` bracketing it between `1/(π²(m+2))` and `1/(π²(m+1))`, both by passing the partial-sum bounds of units `0333` and `0346` to the limit. `norm_S_sub_le` is the limit statement: for `q ≤ 1`, `S m w` differs from its principal part `c·w·exp(w²σ)` by at most `2q` times that part's norm, the two sequences converging by `tendsto_S` and by the partial sums' convergence with the index shifted by `m+1`. `re_A_sq` computes the real part of the principal part squared in closed form, and `re_S_sq_ge` is the deliverable: `Re (S m w)²` is at least `c² e^{2Re(w²)σ}` times `Re(w²) cos(2 Im(w²) σ) − Im(w²) sin(2 Im(w²) σ)`, minus `c² ‖w‖² e^{2Re(w²)σ}` times `4q + 4q²`. At `w = (ε' + iΔ)h` the phase `2 Im(w²) σ` is the `ω h` of section 13 and the bracket is `h²[(ε'² − Δ²) cos − 2ε'Δ sin]`.

**The build.** `errors_first` 4 error lines, `roots` 2 root causes: a `dsimp only` after `filter_upwards` on a goal already reduced (`TRAPS.md` row `row_dsimp` 23), and `pow_le_pow_left` renamed to `pow_le_pow_left₀` on this toolchain (row `row_rename` 22); `cascade_lines` 2 lines were the pins' `sorryAx` cascade (row `row_cascade` 19). Second build clean, `jobs_module` 8663 jobs; the package builds at `jobs_package` 8757 jobs. Built under the loop at version `loop_version` 9; step 0b, the pins, was skipped this run and written after the work, recorded in `PINS.md`.

What the next slice needs. Requirement (c) of section 13: the variation of the weighted amplitude `w_h |g_i(h)|²` over the integer `h`-range, which needs the module's bounds read at `w = (ε' + iΔ)h`, `s = εh`, `m + 1 = λh`, and the hypothesis `q ≤ 1` traced to `h` and `λ`, where `q` is of size `ε⁴h/(π⁴λ³)`.
