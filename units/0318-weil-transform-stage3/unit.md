---
id: 0318
date: 2026-09-06
type: formalization
title: WeilTransform.lean: the tuned window's transform in closed form, the odd-part lemma, entry 302's two readings as corollaries
refs: [lean_stage3/Stage3/WeilTransform.lean::ghat_eq, lean_stage3/Stage3/WeilTransform.lean::odd_integral_exp, lean_stage3/Stage3/WeilTransform.lean::ghat_ofReal_I, lean_stage3/Stage3/WeilTransform.lean::ghat_offline]
supersedes: []
follows: 0308
sealed: false
---

**Question.** Rung 3 of the detection ladder (`units/0316`, `units/0317`). Entry 302
§3 reads the transform of the tuned window `G(u) = N·(u/h)·P(u/h)·cos(γu)`
twice, once on the real line through `Ψ` and once at the off-line point
through `Σ`. Are those one identity, and can it be proved in Stage 3 so that
what unit 0317 bounds (`Σ`) is what unit 0316 sums (the transform at `−ρ`)?

**What ran.** `lean_stage3/Stage3/WeilTransform.lean`, new, `module_lines` 237
lines, imported from `Stage3.lean`. Three build cycles: `errors_first` 4
errors on the first (a name clash between the window's `Σ` and Mathlib's
`Sigma` type, an unconstrained measure on an unused integrability fact, the
real-scalar form of the change-of-variables lemma, and a fragile rewrite of
the carrier cosine), `errors_second` 1 on the second (a cast step that the
normaliser had already finished), then clean. Full package built,
`jobs_package` 8739 jobs. `run/build.log` is the record.

**What it shows.** `theorems_proved` 9 theorems over `defs` 4 definitions
(`SigmaC`, `Psi`, `G`, `ghat`), each pinned by `#guard_msgs` to `axioms` 3
axioms, `sorries` 0 sorries.

The master identity `ghat_eq`: for `h > 0` and every complex `z`,

    ghat h γ z = (h/2)·[Σc((z + iγ)h) + Σc((z − iγ)h)],

with `Σc(w) = ∫₋₁¹ x·P(x)·sinh(w x) dx` the odd envelope at complex
argument. Three steps, each a lemma: the change of variables `u = hx`; the
carrier `cos(θ)·e^{a} = (e^{a+iθ} + e^{a−iθ})/2`; and `odd_integral_exp`, that
for an odd continuous `q` on `[−1, 1]`, `∫ q·e^{w·} = ∫ q·sinh(w·)`, because
`q·cosh(w·)` is odd and its integral over the symmetric interval vanishes.
`x·P(x)` is odd because `P` is even (`P_even`, `xP_odd`).

The two readings are corollaries. `ghat_ofReal_I`: at `z = it`,
`ghat = i(h/2)·[Ψ(h(t+γ)) + Ψ(h(t−γ))]`, entry 302's real-line formula, via
`Σc(is) = i·Ψ(s)` (`SigmaC_I_mul`, from `sinh(iθ) = i·sin θ`).
`ghat_offline`: at `z = ε + iγ`, `ghat = (h/2)·[Σc((ε + 2iγ)h) + Σ(εh)]`,
the `2γ` lobe plus unit 0317's main term, via `Σc(s) = Σ(s)` for real `s`
(`SigmaC_ofReal`).

What this buys: the transform unit 0316 sums is now the envelope unit 0317
bounds, with the lobe named. Next rung: the lobe bounded above through the
window's decay (entry 302's `Ψ_b`), then the on-line background through
`JensenCount.zeta_local_zero_count`.
