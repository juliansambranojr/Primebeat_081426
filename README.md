# Primebeat — the iterated difference table of π(2ⁿ)

Take the number of primes in each dyadic block, `N(r) = π(2^r) − π(2^(r−1))`,
and difference it repeatedly:

```text
cell(r, 0)   = N(r)
cell(r, d+1) = cell(r, d) − cell(r−1, d)
```

Over `r ≤ 62`, `d ≤ 61` — 1953 cells — **exactly four are zero**, and no others:

```text
(2,1)    (4,1)    (8,3)    (20,6)
```

You can check that in ten seconds:

```bash
python3 four_zeros.py
```

No dependencies, no network, 63 integers of input. Nothing else in this
repository is required to reproduce it.

This repo is a measurement bench and a Lean 4 formalization built around that
object. It is a working research log, not a library — nothing here is importable
and nothing depends on it.

---

## What is proved

A Lean 4 / Mathlib tree, **20 modules, 250 theorems**, every one pinned to its
own axiom list by `#guard_msgs` on `#print axioms`, so the build fails the moment
a proof's axiom footprint changes. No `sorry`.

```bash
cd lean && lake exe cache get && lake build      # expect 8042 jobs, no errors
```

Highlights, with the axioms they cost:

| Theorem | Says | Axioms |
|---|---|---|
| `Construction.unique_of_isTableOf` | fix the row and every cell is forced | **none** |
| `Zeros.measured_zeros_all_vanish` | all four zeros, computed from 21 integers | **none** |
| `Zeros.zero_iff_repeat` | a zero is exactly a repeat one depth up | `propext` |
| `Zeros.tableFrom_eq_stencil` | a cell is the alternating binomial stencil | `propext, Classical.choice, Quot.sound` |
| `PairIdentity.pair_identity` | prime + composite = `(b−1)^(d+1)·b^e`, no primes on the right | `propext, Quot.sound` |
| `Chain.sym_eq_zero_iff` | the difference operator's symbol dies exactly on `Re s = 0` | ℂ floor |
| `Transform.zeros_in_fundamental_annulus` | ζ's nontrivial zeros lie in `b^(−1) < ‖z‖ < 1` | ℂ floor |
| `Transform.critical_circle_is_lattice_inversion_mean` | that lattice, inverted, has its geometric mean on `‖z‖ = b^(−1/2)` | ℂ floor |

The axiom column is the point. `Construction` does not import Mathlib at all and
its results depend on nothing; the four zeros are *computed*, not transcribed.

## What is measured

Scripts `O11`–`O66` and `t*`, each writing a JSON artifact and a run log to
`results/`. What the measurements are **for**: the explicit formula guarantees
the zeta zeros are in the prime residual, so recovering them is a check that
the pipeline works, not a discovery about ζ — RH is verified elsewhere to
heights this bench will never reach. What the bench measures that matters is
its own consistency, and two open empirical questions.

- **O43** — the exact-zero census extended to `r = 92` on published `π(2ⁿ)`:
  4186 cells, no new zeros. The one measurement about the central object.
- **O58** — the internal-consistency instrument. Every earlier result was
  expressed in the `√x` normalisation RH predicts, with nothing testing it;
  O58 measures the exponent per zero instead of assuming it
  (`Re ρ = 0.49957 ± 0.00175` for the six below `γ = 40`), closing a recorded
  circularity. O57's blind recovery of those six at `330×` separation is the
  pipeline demonstration it feeds on.
- **Two unplaced candidates** — the generator-orbit peak at `{2,3,5,7}` (O24),
  whose proposed mechanism `GeneratorPeak.no_interior_peak` formally excludes
  in power-law form while the peak persists, with a named kill test near
  `xmax ≈ 4·10¹¹`; and the twin process keeping Hardy–Littlewood pair
  structure while losing number rigidity (O66), currently resting on a
  measurement whose endpoint is degenerate with its own control. Neither is
  claimable yet; both are stated with what they need.

Measurements are labelled **EXPLORATORY** unless a locked prereg in `preregs/`
governs them. Four preregistered tests are closed; their verdicts and the
retracted ones are in `CONTEXT.md § Current state of the world`.

## What is open

The Riemann hypothesis. The tree contains three theorems of the form
`RiemannHypothesis ↔ <geometric condition>` and **no proof object of type
`RiemannHypothesis`**. Those equivalences are coordinate changes; they move the
statement and decide nothing.

Two dead arguments are recorded rather than deleted — see notes entries 99–100
and `papers/What-Didnt-Work.md`. A repository that only records its successes is
not usable by anyone else.

---

## Layout

```text
four_zeros.py      the ten-second check, no dependencies
lean/              20 modules, 250 theorems; see lean/THEOREMS.md for the index
papers/            one document per object; format in papers/FORMAT.md
  literature/      prior-art searches, including what was NOT found
notes/             lab_notebook.md (1–44), lab_notebook_2.md (45–), NOTEPAD.md
preregs/           locked protocols; format in preregs/FORMAT.md
results/           every run's JSON artifact and log
utilities/         check_refs.py, check_values.py, gate.py
imported/          vendored third-party data with SHA manifests
CONTEXT.md         the blueprint: what each test measures and what it returned
REFERENCES.md      cited documents, sibling repos, constants
```

## Verifying

```bash
python3 four_zeros.py                    # the central object, no deps
python3 utilities/check_refs.py          # every citation resolves
python3 utilities/check_refs.py --audit  # pair each citation with its target
python3 utilities/check_values.py        # every number in papers/ traced to an artifact
cd lean && lake build                    # 8046 jobs, 250 theorems, 250 axiom pins
```

`check_refs.py` verifies that a citation's target **exists**; it cannot verify
that the target says what the citing line claims. That gap is recorded as a
known defect and `--audit` exists to make it reviewable by a person.

## Environment

Python 3.14 with `requirements.txt`. Most measurement scripts additionally need
[primecount](https://github.com/kimwalisch/primecount) via `primecountpy`, which
is a native binary and is **not** captured by the requirements file — install it
separately (`brew install primecount` on macOS). `four_zeros.py` needs none of
this.

Lean pins `leanprover/lean4:v4.28.0` and Mathlib `v4.28.0`. **Do not run
`lake update`** — four dependencies track `main` and re-resolving them puts the
axiom pins at risk. Use `lake exe cache get` on a fresh clone.

## Prior art

`papers/literature/` records three searches. The construction is a recognised
OEIS genre — A376682 (noncomposites), A377033 (composites), A377051 (prime
powers) — and **A095195 is this exact recurrence** seeded with `prime(n)`.
No member of that family exists for A036378 or A007053, which is the gap
`results/oeis_A036378_difftable_draft.txt` submits.

## License

Apache-2.0. See `LICENSE`.

## The notebook is part of the publication

This repository is an open lab notebook as well as a result: the
`notes/` record is the dated working history of a human–AI
collaboration, corrections included — the credibility of the papers
rests on the gates (`check_refs`, `check_values`, the axiom pins)
that weld the record and the mathematics together. Entries 143–144
of `notes/lab_notebook_2.md` describe the methodology; it is part of
what this repository publishes.
