---
id: 0344
date: 2026-09-06
type: formalization
title: "WeilPowerSelect.lean: selection of the target, a pigeonhole lemma without monotonicity"
refs: [lean_stage3/Stage3/WeilPowerSelect.lean::farDelta_le, lean_stage3/Stage3/WeilPowerSelect.lean::exists_step_le, lean_stage3/Stage3/WeilPowerSelect.lean::target_bound, lean_stage3/Stage3/WeilPowerSelect.lean::target_height_le]
supersedes: []
follows: 0341
sealed: false
---

**Question.** Rung `rung` 5, `slice` 10. Worksheet `section` 8 asks how to
choose the target: among off-line zeros, one whose real-part offset `ε`
makes every other zero's `ε'² − Δ²` bounded by `ε² + K'π²λ/h`, so the
cluster (§9) contributes at most a bounded factor. The worksheet's plan
is a maximum over a finite, growing box and an induction with a
bounded-increase step.

**What ran.** `lean_stage3/Stage3/WeilPowerSelect.lean`, new,
`module_lines` 190 lines, imported from `Stage3.lean`. `errors_first` 3
errors on the first build. Full package built, `jobs_package` 8755 jobs;
the module alone is `jobs_module` 8663 jobs. `run/build.log` is the
record.

**What it shows.** `theorems_proved` 7 theorems and `defs` 1 definition
(`δSel`), the pinned theorems by `#guard_msgs` to `axioms` 3 axioms,
`sorries` 0 sorries.

Far heights need no selection. `farDelta_le`: a zero with real part
offset `ε' ∈ [0, 1/2]` and height offset `1/2 ≤ |Δ|` already has
`ε'² − Δ² ≤ 0`, true against any target with `0 < ε` — the worksheet's
first paragraph, no choice of target at all.

Near heights need the target chosen. The worksheet's argument — `t_k` a
zero of largest real part among zeros with `|Im| ≤ T + k/2`, the sequence
`ε(t_k)` nondecreasing and bounded by `1/2` — turns out to need only the
bound, not the monotonicity: `exists_step_le` is the pigeonhole lemma
(a sequence `f`, `f 0 ≥ 0`, `f k ≤ B` at every step, cannot climb by more
than `δ` at every one of `N` steps once `N·δ > B`), proved by
contradiction with no `Monotone f` hypothesis anywhere in its statement or
proof. The module takes `E : ℕ → ℝ` — "the largest real-part offset among
zeros in box `k`" — as a parameter, the same parameterize-downstream
choice unit 0341 made for `ε', Δ, ε, h`; wiring `E` to an actual finite
zero set (`WeilOnLine.lowSet_finite`'s argument widened, or a band count)
is left to whichever later module needs it, and `K'` stays a free
positive parameter, exactly as in the worksheet, which never assigns it
a value.

`exists_target_step` specializes the pigeonhole lemma: `f = E²` is
bounded by `1/4` (`E k ∈ [0, 1/2]`), `δ = δSel K' λ h = K'π²λ/h`,
`N = ⌊h/(4K'π²λ)⌋₊ + 1` is the threshold `B/δ` rounded up by
`Nat.lt_floor_add_one`, so there is a step `k ≤ h/(4K'π²λ)` with
`E(k+1)² ≤ E(k)² + K'π²λ/h`. `target_bound` reads that `k` as the
worksheet's `t_k`: any zero at real part `ε'` inside the `(k+1)`-box (so
`ε' ≤ E(k+1)`, `E(k+1)` being that box's maximum) satisfies
`ε'² ≤ E(k)² + K'π²λ/h`, the cluster's criterion, with no sign hypothesis
on `ε' − ε` at all. `target_height_le` reads the same `k` as an explicit
height bound: the box at step `k` sits at `T + k/2 ≤ T + h/(8K'π²λ)`.
The worksheet's rougher `+ 1` came from rounding `(k+1)/2` rather than
`k/2`; once the step count itself is `⌊h/(4K'π²λ)⌋₊ + 1` rather than a
crude round number, that slack is not needed, so the module's bound
corrects the worksheet's number rather than restating it. `target_ge_box`
closes the section: `E 0 ≤ E k`, the target's own `ε` is at least the box
zero's — the one fact in this module that does need `Monotone E`.

What this leaves out: `E`'s connection to an actual off-line zero set
(the "maximum over a finite set" half of the worksheet's Lean-shape
note), and the cluster itself (worksheet § 9), which combines this
module's bound with `WeilPowerCompare.rate_neg_of_ge`.

What the next slice needs. Worksheet § 9: the cluster of off-line zeros
with `|Δ| < 1/2` and `ε'² > ε² − K'π²λ/h`, counted by the band count of
one band, each aligned by simultaneous Dirichlet so every member is
negative at once — the caveat there (the cluster is defined through `h`,
which Dirichlet then picks) is still open. Unit 0316's arrow still waits
on the assembly of worksheet § 10.
