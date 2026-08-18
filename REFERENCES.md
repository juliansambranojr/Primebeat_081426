# REFERENCES — Primebeat_081426

## Cited documents

### Present in this tree

- `files (2)/dyadic-table-addendum-5.md` — **DT-A5**, "Fifth Addendum —
  the operator, run rather than argued". Doc ID DT-A5 · v1.0 · stamped
  2026-08-14 · author Julian Sambrano · adversarial review Claude.
  Accompanies `O1_operator_selfadjointness.py`.
- `files (2)/dyadic-table-addendum-6.md` — **DT-A6**, "Sixth Addendum —
  the radius/rotation split, and a clean negative". Doc ID DT-A6 · v1.0
  · stamped 2026-08-14. Accompanies `O3_collapse_radius_vs_rotation.py`
  and `O3b_rebounds_and_oscillating_fit.py`. **§1(b) is the reading O7
  was built to test** — cite it by that name.

### Cited but absent everywhere on this machine

Every script header carries a `Reads with:` line pointing at documents
that are in neither this folder nor `primebeat/` nor `primebeat_lean/`.
Locate or reconstruct before treating any script's framing as grounded:

- `dyadic-table-v2.md` — the base document the addenda extend
- DT-A, DT-A2, DT-A3, DT-A4 — addenda 1–4
- DT-A7, DT-A8 — referenced forward
- O3c — the second O3 follow-up (O3b is present; O3c is not)
- "Prime Beat papers (Sambrano, Jan 2026)" — cited by
  `O9_convergence_abscissa.py` and `files (2)/O2_prime_kernel_spectrum.py`.
  Best candidate on disk is
  `primebeat_lean/notebook/The Prime Beat - A Scale-Invariant Structural
  Isomorphism for Coherence.md` (+ `.pdf`) — **not confirmed as the same
  document.** Julian to verify before it is cited as such.

## Preregs

- `preregs/alpha_depth_trend_v1_locked_20260814.md` — the α(d)
  depth-trend prereg (v1), STATUS LOCKED. House standard for prereg
  form; see this project's `CLAUDE.md` § Prereg discipline.
- `preregs/alpha_depth_trend_v1_locked_20260814.sha256` — single line,
  `e8dd8430d489fa7dee3135f6f0a7b73bf70100c5fb6aa1aeea9b9cfe433ed109`,
  matching the `post_compute_sha256` in the .md Run record.

## Sibling repos

Read-only for orientation. No code is shared in either direction — no
imports, no shared module, no filename collisions.

### `/Users/juliansambrano/GitHub/primebeat/`

Python implementation and testbed (17 suites A1–A17, notebook/ with
OBS_*/HYP_*). Shares the *concept* of the dyadic difference table
(`primebeat/core/tables.py` → `load_dyadic`, `load_triadic`,
`load_silenced`) but uses different filenames and a different
generator. The "silenced" table variant does not appear here.

### `/Users/juliansambrano/GitHub/primebeat_lean/`

Lean 4 formal companion. This is where the shared vocabulary lives:

- `notebook/The Prime Beat - A Scale-Invariant Structural Isomorphism
  for Coherence.md` / `.pdf`
- `notebook/CONNES_BRIDGE_MAP.md` — the Connes-side material O8
  operationalizes
- `docs/A_Connes_rh_2026.pdf`
- `docs/Spectral_Structural_Duality_Sambrano_2026.pdf`
- `context.md`

## Packages and environment

`.venv/` — Python 3.14.3 from `/opt/homebrew/opt/python@3.14`,
`include-system-site-packages = false`. **There is no
`requirements.txt` and no lockfile.** Installed:

| Package | Version | Used by |
|---------|---------|---------|
| `connes-cvs` | 0.3.1 | O8 (truncated Weil / Galerkin Q(c)) |
| `python-flint` | 0.9.0 | transitively |
| `cysignals` | 1.12.6 | transitively |
| `mpmath` | 1.3.0 | O8, O9, O3 |
| `numpy` | 2.5.2 | all |
| `primecountpy` | 0.2.1 | π(2ⁿ) cache, primary |
| `sympy` | 1.14.0 | π(2ⁿ) cache, fallback |
| `mclass` | 1.3.4 | — |
| `mpath` | 1.1.3 | — |

`connes-cvs` implements the Connes–van Suijlekom truncated Weil form;
upstream reference is Groskin, arXiv:2605.20224. **Provenance caveat:**
Groskin and arXiv:2605.20224 appear nowhere in Connes' own reference list
(see below), so that attribution is the package's, not Connes'.

**A. Connes, "The Riemann Hypothesis: Past, Present and a Letter Through
Time", arXiv:2602.04022v1, submitted 3 Feb 2026, 42 pp.** The primary
external source for O19–O22. A local copy of the PDF also sits at
`/Users/juliansambrano/GitHub/primebeat_lean/docs/A_Connes_rh_2026.pdf`.
Sections this bench actually uses:

- **§4.1** Weil's positivity criterion. The equivalence
  `RH ⟺ Σ_v W_v(g * g*) ≤ 0`, and the statement that it "only involves
  finitely many primes at a time". Local term, his eq. (9):
  `W_p(f) = (log p) Σ_{m≥1} p^(−m/2) [ f(p^m) + f(p^(−m)) ]` — the object
  O22 compares the Prime Beat against.
- **§5** "A Letter to Professor Bernhard Riemann". The construction: a
  quadratic form on functions vanishing outside [1, 13], minimised subject
  to unit norm, Mellin transform of the minimiser. Uses the six primes
  {2,3,5,7,11,13} and prime powers {2,3,4,5,7,8,9,11,13}. Carries the
  50-value difference list, 2.60179e−55 to 2.09081e−2, stated as **upper
  bounds**, non-monotone in the tail. Closes with the open question that
  O20 measures.
- **§6.1** Theorem 6.1, joint with W. van Suijlekom ("Quadratic Forms, Real
  Zeros and Echoes of the Spectral Action", Commun. Math. Phys. 406:312,
  2025). Zeros of the Fourier transform lie on the real line **provided**
  the minimum of the spectrum is a simple, isolated eigenvalue with even
  eigenfunction. Footnote 14 records the trigonometric truncation N = 100.
- **§6.3** The prolate spheroidal wave functions — Slepian, Pollak and
  Landau — entering via Shannon's question about simultaneous time- and
  band-limitation, with N ≃ 2TW. Same time–frequency limitation this bench
  meets as aliasing in O15/O18.
- **§6.4** The truncated form QW_λ on support [λ⁻¹, λ], `L = 2 log λ`, and
  the operator A_λ with `QW_λ(f,f) = ⟨A_λ f | f⟩` (his eq. 16). The
  parameter `c` in `connes-cvs` is this λ.
- **§6.6** The remaining steps, including the unproved hypothesis that the
  smallest eigenvalue is simple with even eigenvector — the quantity O20's
  gap ratio measures.

Bridge coordinate used by O19–O22, derived in `O19_bridge_figure.py`'s
docstring: a table cell at depth d spans a value window of ratio 2^(d+1)
and Connes' window spans λ², so **λ = 2^((d+1)/2)**. Matching by ratio is
a choice, not a theorem.

**API note:** the zero-extraction call returns a *dict*
(`gamma_detected`, `error`, `residual`, `converged`, `failure`,
`tolerance`), not a scalar. `O8_weil_inner_product.py.bak` assumed a
scalar and raised "cannot create mpf from {…}"; the current version
unpacks the dict. Any new `connes-cvs` code must unpack.

## Constants used across the bench

| Symbol | Value | Where locked |
|--------|-------|--------------|
| γ₁ | 14.134725141734693 | O3, O6, O8 |
| ω₁ | 3.514260 rad/regime (γ₁·ln2; aliases to 2.7689) | O3, O3b |
| β (synthetic null) | 0.4334 | prereg locked-parameters table |
| seed | 2026 (`default_rng(2026)`) | hardcoded; prereg says **do not add a `--seed` flag** |
| σ | 1/2 (beat weighting `p^(−1/2)`) | O2, O9 |

## Operating contract

- `/Users/juliansambrano/GitHub/CLAUDE.md` — root rules
- `/Users/juliansambrano/GitHub/AGENT_CLAUDE.md` — agent operating envelope
- `/Users/juliansambrano/GitHub/NOTEPAD_TEMPLATE.md` — NOTEPAD format
