> Source: session transcript, 2026-11-22, after unit 0405

> B it is

From the assistant's message before it: "**(b)** Price the choice of `T` first, then do (a) with the `T` that wins."

From `run/price_height.py`, the docstring:

```
EXPLORATORY, no prereg. The explicit-formula route priced over the height T.

Proved pieces, each read from its statement:
  Glue.explicit_formula_poly  for 16 <= x, 2 <= T <= x^2:
      |psi x - x + Z(x,T)| <= c1 x log^2(xT)/T + c2 log x
  Assembly.norm_zeroPartialSum_le_logsq  under RH, T = 2^(K+1):
      |Z(x,T)| <= 2 sqrt(x) (2 [log2/(2 pi) (K+1)(K+2) + 3 (K+1)/pi
                                + 2 (b1 log T + b3 + 7/8)] + 2 W)
  ArgCount.rvM_crude  (b1, b2, b3) = (112, 0, 698)
  PsiToPi.schoenfeldWeak_of_psiWeak  C sqrt(t) log^2 t on [x0, oo) gives
      (3 C + 13) sqrt(x) log x on [x0^2, oo)
The model: T the power of two in (x^a/2, x^a], 1 <= a <= 2, so log T <= a L,
x/T <= 2 x^(1-a), log(xT) <= (1+a) L, with L = log x. Dividing by sqrt(x) L^2
every term is decreasing in x, so the constant on [x0, oo) is its value at x0:
  C_psi(x0, a) = 4 [ a (a L0 + log 2) / (2 pi log 2 L0) + 3 a / (pi log 2 L0)
                     + 2 (b1 a / L0 + (b3 + 7/8) / L0^2) ]
                 + 2 c1 (1+a)^2 x0^(1/2 - a) + c2 / (sqrt(x0) L0)        (W = 0)
Assembly.psiWeak_of_RH_EF_NT is the case a = 1 with each term then bounded by
its L^2 multiple at L >= 1 and the last two by sqrt(x) L^2: 7404 + 9 c1 + c2.
c1, c2 are floors, as in unit 0405: `as_built` and `freed` radii.
The gate is O68's R_of, imported unchanged, k = 1, floor x0^2.
```
