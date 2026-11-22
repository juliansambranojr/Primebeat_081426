> Source: session transcript, 2026-11-22, after unit 0418

> Go on that

From unit 0419's closing paragraph, the item taken up: "The pricing rerun on the proved ceilings."

From `run/price_num.py`, the docstring:

```
EXPLORATORY, no prereg. The gate priced from the kernel-checked ceilings.

RouteNum.relErrWindow_route_num (unit 0419): under RH, for x0 >= 16, the pi-side
constant is routeConst x0 = 3 floorConstSplit c1n c3n c4n 112 0 698 0 x0 + 13,
   floorConstSplit = 4 + (16 + 16 b1 + 16 b2)/log x0 + (8 b3 + 8 + 4 W)/log^2 x0
                     + 18 c1/(x0 sqrt x0) + c3/(sqrt x0 log x0)
                     + c4 x0^(-1/4)/sqrt x0,
on sqrt(x) log x, x >= x0^2. The three constants are taken at the ceilings
proved in RouteNum: c1n <= 88216610000, c3n <= 15, c4n <= 6468930000.
floorConstSplit is increasing in each, so the result is an upper bound on the
theorem's constant. The gate is O68's R_of, imported unchanged, k = 1; it is a
script's gate and not the Lean gate.
```
