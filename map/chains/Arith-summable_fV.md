# What `Arith.summable_fV` rests on

[`Arith.summable_fV`](../lean_stage3/ArithTail.md#Arith-summable_fV) in `lean_stage3/Stage3/ArithTail.lean`, line 173.

**Proves**

```lean
Summable fV
```

Behind it: 19 theorems and 7 definitions in 3 files. Every one is listed below; Lean recorded each step.

## The files it passes through

```mermaid
flowchart LR
  f0["<b>SdiagLeadCore</b><br/>1 used"]:::thm
  f1["<b>ArithBase</b><br/>11 used"]:::thm
  f2["<b>ArithTail</b><br/>summable_fV"]:::end_
  f0 --> f1
  f1 --> f2
  classDef cnt fill:#dff5ec,stroke:#17694a,color:#111
  classDef shp fill:#f1ecfb,stroke:#5b3fa0,color:#111
  classDef rh fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef thm fill:#eef4ff,stroke:#335,color:#111
  classDef end_ fill:#e7f7e7,stroke:#2a7,color:#111,stroke-width:2px
  classDef lone fill:#fff,stroke:#999,color:#111,stroke-dasharray:4 3
  classDef bad fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef ext fill:#fff8e1,stroke:#b80,color:#111
```

An arrow A → B reads "B uses something proved or defined in A"; indirect arrows are left out. Green: the theorem itself. Yellow: a file in the other tree. The number is how many of that file's declarations are on the way.

## Every declaration on the way

Files in dependency order. ★ marks what the theorem's own proof uses directly.

### [`SdiagLeadCore`](../lean_stage3/SdiagLeadCore.md) — 1

- [`SdiagLead.sig`](../lean_stage3/SdiagLeadCore.md#SdiagLead-sig) — *def*

### [`ArithBase`](../lean_stage3/ArithBase.md) — 11

- [`Arith.sp`](../lean_stage3/ArithBase.md#Arith-sp) — *def*
- [`Arith.sig_eq_prod`](../lean_stage3/ArithBase.md#Arith-sig_eq_prod) — `` sig d = ∏ p ∈ d.primeFactors, sp p ``
- [`Arith.sig_mul`](../lean_stage3/ArithBase.md#Arith-sig_mul) — `` sig (m * n) = sig m * sig n ``
- [`Arith.sp_eq`](../lean_stage3/ArithBase.md#Arith-sp_eq) — `` sp p = (p : ℝ) / ((p : ℝ) - 1) ``
- [`Arith.sp_bounds`](../lean_stage3/ArithBase.md#Arith-sp_bounds) — `` 1 ≤ sp p ∧ sp p ≤ 2 ∧ sp p - 1 ≤ 2 / p ``
- [`Arith.sig_nonneg`](../lean_stage3/ArithBase.md#Arith-sig_nonneg) — `` 0 ≤ sig d ``
- [`Arith.euler_le`](../lean_stage3/ArithBase.md#Arith-euler_le) — `` ∑ m ∈ range N, f m ≤ Real.exp (∑ p ∈ N.primesBelow, e p) ``
- [`Arith.zs`](../lean_stage3/ArithBase.md#Arith-zs) — *def*
- [`Arith.sum_primes_le_zs`](../lean_stage3/ArithBase.md#Arith-sum_primes_le_zs) — `` ∑ p ∈ N.primesBelow, e p ≤ c * zs ``
- [`Arith.qp`](../lean_stage3/ArithBase.md#Arith-qp) — *def*
- [`Arith.qp_bounds`](../lean_stage3/ArithBase.md#Arith-qp_bounds) — `` 0 < qp p ∧ qp p ≤ 3 / 4 ∧ 1 / (p : ℝ) ≤ qp p ``

### [`ArithTail`](../lean_stage3/ArithTail.md) — 14

- [`Arith.rad'`](../lean_stage3/ArithTail.md#Arith-rad-) — *def*
- [`Arith.rad_mul`](../lean_stage3/ArithTail.md#Arith-rad_mul) — `` rad' (m * n) = rad' m * rad' n ``
- [`Arith.rad_prime_pow`](../lean_stage3/ArithTail.md#Arith-rad_prime_pow) — `` rad' (p ^ k) = p ``
- [`Arith.sig_prime_pow`](../lean_stage3/ArithTail.md#Arith-sig_prime_pow) — `` sig (p ^ k) = sp p ``
- ★ [`Arith.fV`](../lean_stage3/ArithTail.md#Arith-fV) — *def*
- [`Arith.CV`](../lean_stage3/ArithTail.md#Arith-CV) — *def*
- ★ [`Arith.fV_nonneg`](../lean_stage3/ArithTail.md#Arith-fV_nonneg) — `` 0 ≤ fV m ``
- [`Arith.fV_mul`](../lean_stage3/ArithTail.md#Arith-fV_mul) — `` fV (m * n) = fV m * fV n ``
- [`Arith.fV_one`](../lean_stage3/ArithTail.md#Arith-fV_one) — `` fV 1 = 1 ``
- [`Arith.fV_prime_pow`](../lean_stage3/ArithTail.md#Arith-fV_prime_pow) — `` fV (p ^ k) = sp p ^ 2 / p * qp p ^ k ``
- [`Arith.fV_hasSum`](../lean_stage3/ArithTail.md#Arith-fV_hasSum) — `` HasSum (fun k => fV (p ^ k)) (1 + sp p ^ 2 / p * (qp p / (1 - qp p))) ``
- [`Arith.fV_e_le`](../lean_stage3/ArithTail.md#Arith-fV_e_le) — `` sp p ^ 2 / p * (qp p / (1 - qp p)) ≤ 16 / ((p : ℝ) * √(p : ℝ)) ``
- [`Arith.fV_e_nonneg`](../lean_stage3/ArithTail.md#Arith-fV_e_nonneg) — `` 0 ≤ sp p ^ 2 / p * (qp p / (1 - qp p)) ``
- ★ [`Arith.sum_fV_le`](../lean_stage3/ArithTail.md#Arith-sum_fV_le) — `` ∑ m ∈ range N, fV m ≤ CV ``

