---
id: 0345
date: 2026-09-06
type: decision
title: Rung 5 section 9 as sketched dies on size; the Gaussian lower bound's lost factors come first
refs: [lean_stage3/Stage3/WeilPowerGauss.lean::cprime_ge, lean_stage3/Stage3/WeilPowerGauss.lean::sum_inv_sq_ge]
supersedes: []
follows: 0344
sealed: false
---

**Question.** Step 1 of the loop for worksheet section `nine` (`rung5.md#9`), the cluster: does the sketch's fix for its own caveat (an `h`-independent superset of the cluster, then simultaneous Dirichlet over `h`) close, and if it does, what module comes first?

**What was found.** It does not close, on size. Dirichlet over `N` frequencies needs a range of length `Q^N` in `h`. The alignment must leave every cosine bounded away from zero, so `Q` is at least `q_min` 8. `N` is the band count at the target's height, at least `band_a` 15 times the log of that height plus `band_b` 73. The target's height after section 8's walk is `T` plus `H/(8K'π²λ)`, where `H` is the top of the range. So `H` must exceed `(T + H/(8K'π²λ))` raised to `15 log 8`, an exponent above `expo` 31, at every `T`. The range outgrows the height it has to fit inside. Restricting `N` to the shell of zeros near the target's real part does not help, since the shell can hold the whole band. The alignment route is closed; the worksheet's section 9 says so at its head and keeps the sketch below as the record.

Behind it sits a second finding, in the proved bounds. Unit `0333`'s lower bound at the target and its upper bound at any zero differ by two factors that were never priced. The constant `cS m / D m` is bracketed between `4/(π(m+1)(2m+3))` and `4/(π(m+1))`, a factor `2m+3`; with `m` of the order of `h` that is polynomial in the support. The tail sum is bracketed between `(m+2)/(2m+3)²` and `1/(m+1)`, a factor tending to `rate_loss` 4 in the growth rate, so the target's proven rate is a quarter of a competitor's. Section 7's suppression, as proved in unit `0341`, therefore holds only for zeros a constant fraction below the target in `ε'² − Δ²`, which is what its constant `cE/cP` between `2/9` and `1/4` records. Under `CLAUDE.md` § Rule — a lost factor is a design failure this is design: every route to the assembly needs the two factors gone before anything about the cluster can be said.

**Decision.** Two things. The route for the cluster becomes averaging over `h` with weights that flatten the target, written as the worksheet's new section `thirteen` (`rung5.md#13`) with its five requirements in order and its open number (the quartic phase error, under `0.3` radians only for `h` at most `88λ³/ε⁴`). And the module this run builds is requirement (a), the sharp constants: `WeilPowerSharp`, unit `0346`, keeping `cS m / D m` exact on both sides and replacing the tail-sum lower bound by the telescoping `1/(j+1)² ≥ 1/((j+1)(j+2))`, which gives rate `s²/(π²(m+2))` below against `Re(w²)/(π²(m+1))` above and a comparison with prefactor `‖w‖/s`.

What remains: requirements (b) to (e) of section 13, each a module; the `Re(w²) ≤ 0` case of the sharp upper bound; and the fixed point in `λ` that the open number forces, or an exact phase bound that avoids it.
