# Fifth Addendum — the operator, run rather than argued

**Doc ID:** DT-A5 · **Version:** 1.0 · **Stamped:** 2026-08-14
**Author:** Julian Sambrano
**Adversarial review:** Claude (Anthropic)
**Reads with:** `dyadic-table-v2.md`, DT-A, DT-A2, DT-A3, DT-A4.
**Accompanies:** `O1_operator_selfadjointness.py`
**Closes:** a question both sides had been asserting rather than testing.

---

## 0. Why this one exists

Across the session the operator question was argued in both directions and
computed in neither. The author's position was that the table's operator is
the thing that matters and the review kept substituting definitions for a
check. The review's position was that Δ is not self-adjoint and therefore
carries no spectral content worth having. Both were assertions.

The question is finite-dimensional, exact, and takes four seconds to run.

`O1` runs it. A different answer was possible at each of the three steps, and
the third step returned something neither side had predicted.

---

## 1. Q1 — Δ is not self-adjoint, and no weight fixes it

Self-adjointness under a weighted inner product ⟨f,g⟩_w = Σ f(r)g(r)w(r)
requires **W Δ = Δ\* W** for W = diag(w), which entrywise is

```
w_i · D_ij  =  w_j · D_ji     for all i, j
```

Δ is the forward difference: D[i,i] = −1, D[i,i+1] = +1, everything else zero.
Take j = i+1. Then D[i,j] = +1 while D[j,i] = **0**, so the condition reads
w_i · 1 = w_j · 0 = 0, forcing **w_i = 0**.

No positive weight exists. The obstruction fires at the very first off-diagonal
entry, (0,1).

**This is structural, not a matter of range or precision.** Δ is one-sided —
its graph is directed. Symmetry requires a two-sided operator, and no choice of
measure can make a one-sided operator two-sided.

Recorded plainly because it settles the question in the direction the review
had claimed, but for a reason the review never gave. The earlier arguments
rested on unitarity and on domains; the actual obstruction is combinatorial and
visible in a 2×2 corner of the matrix.

---

## 2. Q2 — what is symmetric, and its spectrum

Δ\*Δ is symmetric to machine zero (‖M − Mᵀ‖ = 0.00e+00), positive
semidefinite, with spectrum entirely inside [0, 4]:

```
0.000000  0.017110  0.068148  0.152241  0.267949  0.413293
0.585786  0.782477  1.000000  1.234633  1.482362  1.738948
2.000000  2.261052  2.517638  2.765367  3.000000  3.217523
3.414214  3.586707  3.732051  3.847759  3.931852  3.982890
```

All real, by the spectral theorem, which applies here because the operator
actually is symmetric rather than being asserted to be.

---

## 3. Q3 — the spectrum is the comb filter

This is the part that was not predicted.

v2.0 §7.1 derives, analytically and with nothing fitted, that differencing
multiplies a zeta zero of height γ by **(2 sin(ω/2))ᵈ** with ω = γ·ln2 mod 2π.
A single application therefore has gain (2 sin(ω/2))² — which is exactly the
form of an eigenvalue of Δ\*Δ.

Inverting each eigenvalue through ω = 2·arcsin(√λ / 2):

```
0.000000  0.130900  0.261799  0.392699  0.523599  0.654498
0.785398  0.916298  1.047198  1.178097  1.308997  1.439897
1.570796  1.701696  1.832596  1.963495  2.094395  2.225295
2.356194  2.487094  2.617994  2.748894  2.879793  3.010693
```

Consecutive spacing: mean **0.130900**, standard deviation **2.65 × 10⁻⁹**.
And π/24 = 0.130900. Maximum deviation from the uniform grid k·π/n:
**1.30 × 10⁻⁸**.

> **The spectrum of Δ\*Δ is the §7.1 comb filter, on a uniform ω grid of
> spacing π/n.**

Two derivations of one object — one analytic, from the sampling and the
explicit formula; one linear-algebraic, from an eigendecomposition of the
actual matrix. Neither was constructed from the other. §7.1's comb is not a
heuristic about what a given depth "sees"; it is the operator's spectrum.

**Control.** The same eigensolver on the discrete Laplacian reproduces
−4 sin²(kπ/2(n+1)) with maximum error 8.88 × 10⁻¹⁶, so the numerics are sound.

---

## 4. What this does not give, stated in the same breath

Δ\*Δ is **positive semidefinite and bounded by 4**. The zeta heights {γ} are
unbounded and begin at 14.13. A bounded positive operator cannot have them as
its spectrum.

Positive semidefinite is the shape of a **quadratic form**, not of a
Hamiltonian. It is worth noting that the Connes–van Suijlekom truncated Weil
form — currently the most serious operator-theoretic attack on RH — is also a
quadratic form, and that in that construction criticality is a *theorem* while
convergence to the actual zeros remains open. Being a quadratic form is
therefore not a defect. It is also not a proof of anything.

So the real spectrum found here is a genuine fact about the operator, and it is
**not** the Hilbert–Pólya spectrum. This neither supports nor refutes RH.

---

## 5. Status

| claim | status |
|---|---|
| Δ is not self-adjoint under any positive diagonal weight | **proved**, exact, 2-line obstruction |
| Δ\*Δ is symmetric, PSD, spectrum ⊂ [0,4] | verified, exact linear algebra |
| that spectrum equals §7.1's comb filter on a π/n grid | verified to 1.3 × 10⁻⁸ |
| the spectrum is the Hilbert–Pólya spectrum | **no** — bounded, PSD, wrong shape |

DT-A3 §2.3 records the correct status of the Hilbert–Pólya question as *not
applicable* rather than *ruled out*. That stands. This addendum adds the
specific reason Δ itself could never have been the candidate — and it is not
the reason previously given.

---

## 6. Reproduction

```
pip install numpy
python3 O1_operator_selfadjointness.py            # default RMAX = 24
python3 O1_operator_selfadjointness.py --rmax 20  # faster
```

Exact integer prime counts by sieve; the only floating point is in the
eigendecomposition, and the Laplacian control bounds its error at 10⁻¹⁶.
The script asserts that the matrix Δ reproduces the finite differences of the
actual counts before doing anything else.

---

## 7. Amendment log addition

| target | correction | in |
|---|---|---|
| v2.0 §3.2, §7.1 | Δ's non-self-adjointness has a combinatorial proof; §7.1's comb filter is the spectrum of Δ\*Δ | **DT-A5** |
