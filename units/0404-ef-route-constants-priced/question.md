> Source: session transcript, 2026-11-22, after unit 0403

> Yes and yes, but where are we now? This is why I need the tunnel

From the assistant's message before it: "Do you want me to trace `Ch`, `Cl` and `Cs` down to numerals next (read-only, reporting where each one comes from)? And should this pricing be logged as a unit?"

From `run/price_ef_route.py`, the docstring:

```
EXPLORATORY, no prereg. Prices the explicit-formula route to the census.

Imports O68_weak_bound_tolerance.py unchanged for R_of. The route:
  Assembly.psiWeak_of_RH_EF_NT   |psi - x| <= C sqrt(x) log^2 x, x >= 16,
      C = 9 c1 + c2 + 28 + 16 b1 + 16 b2 + 8 b3 + 4 W
  Glue.explicit_formula_poly     c1 = 2400 + 2 Ch + Cs, c2 = 13 + Cl + K0/2
  ArgCount.rvM_crude             (b1, b2, b3) = (112, 0, 698)
  PsiToPi.schoenfeldWeak_of_psiWeak   C_pi = 3 C + 13, k - 1, x0 = max(x0^2, 9)
Lower bounds on the existentials, each read from the `refine` that builds it:
  EdgeBound.gz_partial_fraction  C1 = G/2 * A, A = log D0/log 2 + 4, D0 > 2
  EdgeBound.ball_order_sum_le    C2 = M0/log 2 + 8 W0 + 1, M0 >= 0
  EdgeBound.edge_bound_core      Ce = C1 + C2 + 1/log 2
  Glue.zeta_logderiv_good_bound  Cp = Ce * 2 * (180 + 1060/log 2)
  Glue.edge_horizontal_bound     Ch = Cp * 3 * (9/4)
  Glue.band_order_sum_le         Cs = 8 W0, W0 = 15 + 88/log 2
Cl, K0, W are dropped (each is proved >= 0), so every figure is a floor.
```
