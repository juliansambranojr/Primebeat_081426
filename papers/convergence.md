# convergence

The same construction pointed at an elliptic curve. What transfers, what changes shape, and
where the operator's degeneracy for ζ turns out to be the rank-carrier for a curve.

Source lines cite scripts in `~/GitHub/Primebeat_081426/` or named theorems.
Nothing here is preregistered. Curve ranks are LMFDB labels, quoted not computed.

---

## A · The local factor sets the operator

**A1.** ζ's local factor is degree 1: `(1 − p^(−s))^(−1)`.
`Euler 1737`

**A2.** An elliptic curve's local factor at a good prime is degree 2:
`(1 − a_p·p^(−s) + p^(1−2s))^(−1)`.
`Hasse–Weil`

**A3.** The operator whose symbol is the reciprocal local factor is therefore a **backward
difference** for ζ and a **second-order recurrence** for `E`:
`f(r) − a_p·f(r−1) + p·f(r−2)`.
`A1 + A2 · Euler Factor Chain A3`

**A4.** Therefore the transfer to the Selberg class is not verbatim. The operator's order
tracks the local factor's degree, and only degree-1 L-functions give a plain difference table.
`A3`

---

## B · Where the symbol vanishes

**B1.** ζ: `1 − b^(−s) = 0` at `s = 2πik/log b` — every zero on **Re(s) = 0**. That set is the
alias lattice.
`Euler Factor Chain D4 · O18_joint_multiplicative_ladder.py measured the comb`

**B2.** `E`: substituting `x = p^(−s)` gives the quadratic `1 − a_p·x + p·x²`. Hasse gives
`|a_p| ≤ 2√p`, so the discriminant `a_p² − 4p` is non-positive, both roots are complex
conjugates, and `|x| = p^(−1/2)`.
`Hasse 1933`

**B3.** Therefore every root sits at **Re(s) = 1/2**.
`B2`

**B4.** Measured `Re(s) = 0.5000` at every curve-prime pair tested, across ranks 0, 1 and 2,
with Hasse holding at each.
`O40_elliptic_symbol_zeros.py`

**B5.** B3 is the Riemann Hypothesis for curves over finite fields. It is a **theorem**, and
B4 reproduces it rather than discovering it.
`Hasse 1933 · Weil 1948 in general`

**B6.** So the local Riemann Hypothesis lives inside the symbol, proven, at every prime — and
the global one is what remains open.
`B5`

---

## C · At s = 0

**C1.** ζ's symbol at `s = 0` is `1 − b⁰ = 0`.
`A1`

**C2.** Therefore the backward difference annihilates constants; `Δ^(d+1)` annihilates every
polynomial of degree ≤ `d`; the stencil's moments all vanish to order `d`; and `H(0) = H(1) = 0`
in the Weil test function, so there is no pole contribution.
`C1 · The-Four-Zeros B5 · O37_weil_form_on_stencil.py`

**C3.** `E`'s symbol at `s = 0` is `1 − a_p + p = #E(F_p)` — the point count.
`A2`

**C4.** Therefore the same evaluation, at the same point, is **null for ζ and is the point
count for a curve**.
`C1 + C3`

---

## D · The rank

**D1.** `Π_{p ≤ X} #E(F_p)/p ~ C·(log X)^r`, with `r` the rank.
`Birch & Swinnerton-Dyer 1965, numerical observation`

**D2.** Measured:

```text
curve              X=100     X=1000    X=10000    X=30000   fitted r   true r
11a1  (rank 0)    6.4878     5.7345     6.2358     6.4873      0.030        0
37a1  (rank 1)   30.5726    45.6847    74.7460    89.7917      1.250        1
389a1 (rank 2)  151.4326   328.6310   637.8856   665.9047      1.993        2
```

`O41_bsd_rank_product.py · results/bsd_rank_product.json`

**D3.** The product runs over **all** good primes including p = 2, for which `#E(F_2) = 5` on
all three curves. Two exploratory runs made before the script existed omitted p = 2 and are
therefore uniformly 2.5× smaller; their point counts cross-checked identically against a
separate `sympy.legendre_symbol` implementation, so what they verified is the counting, not
this product. Since p = 2 contributes a constant factor, it shifts `log(product)` by a
constant and leaves the fitted slope unchanged — which is why the fitted `r` values agree
between the two conventions to the printed digit.
`O41 · verified against the installed script 2026-08-18`

**D4.** The fitted exponent moves with the fitting range: 0.001 / 1.180 / 2.050 at `X ≤ 10000`
against 0.030 / 1.250 / 1.993 at `X ≤ 30000`. About ±0.07. The separation between 0, 1 and 2
is unambiguous; the third decimal is not.
`D3 · the product converges slowly, which is why nobody reads a rank off it numerically`

**D5.** Therefore the quantity carrying the rank is the symbol evaluated at `s = 0` — precisely
where ζ's symbol vanishes.
`C4 + D1`

**D6.** So the point at which ζ's operator degenerates is the point at which the elliptic
operator carries BSD's invariant. Same construction, same evaluation point, opposite behaviour.
`D5`

---

## E · Where BSD's own question sits

**E1.** The Weil test function of the ζ construction is
`h(s) = (1 − b^(−s))^N (1 − b^(s−1))^N`, which has a zero of order `N` at `s = 1` by
construction.
`Euler Factor Chain B1, B2`

**E2.** BSD is the statement that `L(E,s)` vanishes at `s = 1` to order equal to the rank.
`Birch & Swinnerton-Dyer`

**E3.** Therefore an analogous stencil built from a curve's own local factors places its
order-`N` zero on the exact point whose order of vanishing BSD is about.
`E1 + E2`

**E4.** Untested. E3 is a construction that has not been built.
`open`

---

## F · Not established

**F1.** B5 and D1 are a theorem and a known observation, reproduced. Neither is new.
`stated`

**F2.** Nothing here bears on the BSD conjecture. D2 measures a rank already known from LMFDB
and does not test the equality BSD asserts.
`stated`

**F3.** The connection in C4 and D6 has not been checked against the literature. Like the rest
of this bench's structural claims, it is one line from standard facts, which is the profile of
folklore.
`open`

**F4.** `X ≤ 30000` is small and three curves is three curves. D4's ±0.07 is the honest
resolution.
`O41`

**F5.** E3 is the only item here that would be new work rather than reproduction, and it has
not been attempted.
`E4`
