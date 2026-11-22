> Source: session transcript, 2026-11-22, after unit 0407

> 1

From the assistant's message before it: "1. Re-price from the theorem's `floorConst` (a script, minutes)."

From `run/price_floorconst.py`, the docstring:

```
EXPLORATORY, no prereg. The gate priced from the theorem's own constant.

AssemblyFloor.schoenfeldWeak_floor_of_RH (unit 0407): under RH, for x0 >= 16,
   |pi x - Li x| <= (3 floorConst c1 c2 112 0 698 W x0 + 13) sqrt(x) log x,
   x >= max(x0^2, 9),
   floorConst = 4 + (16 + 16 b1 + 16 b2)/log x0 + (8 b3 + 8 + 4 W)/log^2 x0
                + 18 c1/(x0 sqrt x0) + c2/(sqrt x0 log x0).
c1, c2 are existential in the theorem. Here they are the floors of unit 0405
(`as_built`, `freed` radii; A at its floor, M0, Mc, K0 at zero), and W = 0.
`c_zero` sets c1 = c2 = 0: what the route costs with no contour constant.
The gate is O68's R_of, imported unchanged, k = 1.
```
