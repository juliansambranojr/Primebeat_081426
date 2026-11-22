> Source: session transcript, 2026-11-22, after unit 0409

> Yes

From the assistant's message before it: "Shall I run it and log it?"

From `run/price_split.py`, the docstring:

```
EXPLORATORY, no prereg. The gate priced from floorConstSplit (unit 0409).

GlueFloor.schoenfeldWeak_floor_split_of_RH: under RH, for x0 >= 16,
   |pi x - Li x| <= (3 floorConstSplit c1 c3 c4 112 0 698 W x0 + 13) sqrt(x) log x,
   x >= max(x0^2, 9),
   floorConstSplit = 4 + (16 + 16 b1 + 16 b2)/log x0 + (8 b3 + 8 + 4 W)/log^2 x0
                     + 18 c1/(x0 sqrt x0) + c3/(sqrt x0 log x0)
                     + c4 x0^(-1/4)/sqrt x0.
c1, c3, c4 are existential in the theorem. Here, as floors:
  c1 = 2400 + 2 Ch + Cs          (Glue.explicit_formula_split)
  c3 = 13 + K0/2, K0 = 0
  c4 = 72 D, D = 36 Ce + 9 (Mc + 1)/log 2, Mc = 0
with Ce, Ch, Cs as in unit 0405 (`as_built`, `freed` radii; A at its floor,
M0 = 0), and W = 0. `c_zero` sets c1 = c3 = c4 = 0.
`classical` puts K0 = log(2 pi) and Mc = 3 (a guess at the size of the
supremum on the short segment, proved nowhere) to show how little they move.
`as_built_slack_factor`: the largest common multiple of the as-built c1, c3, c4
at which some floor still covers depth six.
The gate is O68's R_of, imported unchanged, k = 1.
```
