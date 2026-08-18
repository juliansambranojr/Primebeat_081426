# Connes, Measured

What this bench measured about A. Connes, *The Riemann Hypothesis: Past, Present and a
Letter Through Time*, arXiv:2602.04022v1, 3 Feb 2026 — including the question his §5
leaves open and the hypothesis his §6.6 leaves unproved.

Source lines cite scripts in `~/GitHub/Primebeat_081426/`. Nothing here is preregistered.
A local copy of the paper sits at `~/GitHub/primebeat_lean/docs/A_Connes_rh_2026.pdf`.

---

## A · What he asks

**A1.** §4.1, Weil's criterion: `RH ⟺ Σ_v W_v(g * g*) ≤ 0`, and it "only involves finitely
many primes at a time". Local term `W_p(f) = (log p)·Σ_{m≥1} p^(−m/2)[f(p^m) + f(p^(−m))]`.
`Connes §4.1, his eq. (9)`

**A2.** §5, a quadratic form on functions vanishing outside `[1, 13]`, minimised subject to
unit norm, using the six primes {2,3,5,7,11,13}. Carries a 50-value difference list,
`2.60179e−55` to `2.09081e−2`, stated as **upper bounds**, non-monotone in the tail. Closes
with an open question about convergence.
`Connes §5`

**A3.** §6.1, Theorem 6.1 with W. van Suijlekom: zeros of the Fourier transform lie on the
real line **provided** the minimum of the spectrum is a simple, isolated eigenvalue with
even eigenfunction.
`Connes §6.1 · Commun. Math. Phys. 406:312, 2025`

**A4.** §6.4, the truncated form `QW_λ` on support `[λ⁻¹, λ]`, `L = 2 log λ`, with
`QW_λ(f,f) = ⟨A_λ f | f⟩`. The parameter `c` in the `connes-cvs` package is this `λ`.
`Connes §6.4, his eq. (16)`

**A5.** §6.6, the remaining steps — including the unproved hypothesis that the smallest
eigenvalue is simple with even eigenvector.
`Connes §6.6`

---

## B · A2 measured

**B1.** Sweeping his own construction across cutoffs at `T = 1600`: first-zero error
`2.18784e−55` at `c = 13`, falling to `5.49291e−120` at `c = 29`.
`O20_connes_cutoff_sweep.py`

**B2.** That is approximately **28 decimal places per unit of depth**.
`derived from B1 (Δlog₁₀ 64.60 over Δd 2.315 = 27.9); recorded in CONTEXT.md, printed by no
script`

**B3.** The simplicity gap ratio never fell below `3.96e7` across the whole sweep.
`O20`

**B4.** Therefore A5's hypothesis held, measured, at every cutoff reached.
`B3`

---

## C · The cutoff has its own validity window

**C1.** The archimedean cutoff `T` fails in two distinct ways. Below the window the form is
genuinely not yet positive (`λ₁` negative, order 1). Above it, precision fails (`λ₁`
negative, order 1e−4).
`O21_archimedean_convergence.py`

**C2.** At `dps = 150` the window is `T ∈ {400, 800, 1600}`. At `dps = 300` it is
`{800, 1600, 3200}`. Doubling the digits buys exactly one more doubling of `T`.
`O21`

**C3.** `λ₁` is **not converged** — 9.1% then 8.3% per doubling.
`O21`

**C4.** The *rate* in B2 is robust to `T` (−27.93 at `T = 400`, −27.90 at `T = 1600`).
The absolute values are not.
`recomputable from the O20/O21 tables; recorded in CONTEXT.md, printed by no script`

**C5.** Therefore B1's absolute figures are cutoff-dependent and B2's rate is the citable
quantity.
`C3 + C4`

---

## D · The Prime Beat is not his object

**D1.** At the identical window {2,3,5,7,11,13}, his construction gives `2.18784e−55` and
the Prime Beat gives `1.1e−01`.
`O22_weighted_beat.py`

**D2.** A factor of **10⁵³** at the same six primes.
`D1`

**D3.** Restoring the Weil local term's `log p` weight and the prime powers moves the Beat
by ~1.4×.
`derived from results/O22_weighted_beat_run2.log: 5.015e53 / 3.485e53 = 1.439; not printed`

**D4.** Therefore the accuracy lives in the variational construction, not in the weighting.
`D2 + D3`

---

## E · Two bridges

**E1.** First attempt: a cell at depth `d` spans a value window of ratio `2^(d+1)`, his
`[λ⁻¹, λ]` spans `λ²`, so `λ = 2^((d+1)/2)`. Under it, (8,3) lands at `λ = 4` whose window
holds exactly {2,3}, and (20,6) sits one prime short of his `λ = 13`.
`O19_bridge_figure.py`

**E2.** **Withdrawn.** Matching by ratio is a choice; three defensible matchings exist.
`lab_notebook entry 23`

**E3.** Second: the difference stencil `Δ^N` is already a compactly supported function on
his domain — weights `(−1)^k C(N,k)` at points `b^(−k)`, window length `(d+1)·log b`. It
is an element of the space he minimises over, not an analogue of it.
`O37_weil_form_on_stencil.py`

**E4.** No coordinate matching is required for E3, which is what distinguishes it from E1.
`E3`

**E5.** Raw, the stencil is a sum of point masses; its Mellin transform does not decay and
`Σ_ρ h(ρ)` diverges — 430431 at 50 zero pairs, 7.8e6 at 1000. It is not an admissible test
function.
`lab_notebook entry 40. The predecessor script is preserved as O38_weil_form_BUGGY.py but
captured no log and summed over 100/200/400 zeros, not these counts — these figures are
transcript-derived and not artifact-verified.`

**E6.** Mollified with `T(s) = u(s)u(1−s)` centred at `s = 1/2`, `H` still factors as
`Ĝ·Ĝ̃`, so positivity is preserved by construction and `H` decays like `t^(−2k)`.
`O37`

**E7.** Mollification also turns the discrete support into an interval, so every prime in
the window enters — 36 in range, 25 contributing, where the raw stencil saw only `p = 2`.
`O37`

**E8.** Weil's explicit formula then balances on it: arithmetic `2644.2756560191`, spectral
`2644.2741566957`, relative `5.67e−7`.
`O37_weil_form_balance.py · calibrated on Gaussians to 1e−18 by O36_weil_calibration.py`

---

## F · Not established

**F1.** E8 is a normalisation check, not a test. Summing `2·Re H(1/2 + iγ)` over known
zeros presupposes those zeros lie on the line.
`stated`

**F2.** The mollifier is not canonical. `W` and `k` are free and E8's numbers move with
them. No parameter-independent statement has been made.
`O37`

**F3.** The mollified object is no longer the pure `Δ^N` stencil. Any claim about the
2-ladder must survive the smearing of E7.
`E7`

**F4.** The per-prime breakdown on record comes from the superseded buggy implementation
and has not been recomputed on E8's corrected run.
`O38_weil_form_BUGGY.py`

**F5.** `connes-cvs` cites Groskin, arXiv:2605.20224, which appears nowhere in Connes' own
reference list. That attribution is the package's, not his.
`REFERENCES.md`

**F6.** No literature search has been done on E3. It is one line from standard facts,
which is the profile of folklore.
`open`
