> Source: session transcript, 2026-11-22, after unit 0404

> Free the radio

From the assistant's message before it: "Free the radii: read `gz_partial_fraction` and `zeta_logderiv_good_bound` to see which radii are forced and what the constant becomes."

From `run/price_floor.py`, the docstring:

```
EXPLORATORY, no prereg. The explicit-formula route with its lost sqrt(x) kept.

Assembly.psiWeak_of_RH_EF_NT proves, inside its proof (`htotal`),
   |psi x - x| <= (9 c1 + c2) L^2 + 2 S (2 (7 + 4 b1 + 4 b2 + 2 b3) L^2 + 2 W),
S = sqrt x, L = log x, and then `assembly_arith` bounds L^2 by S L^2. Kept,
the bound for x >= x0 reads
   |psi x - x| <= (28 + 16 b1 + 16 b2 + 8 b3 + 4 W + (9 c1 + c2)/sqrt(x0)) S L^2.
This script prices that with O68's R_of (imported unchanged), k = 1 on the pi
side, pi floor x0^2 (PsiToPi.schoenfeldWeak_of_psiWeak), for two cases:
  as_built   radii 22/25 < 23/25 < 19/20 < 49/50 (EdgeBound.gz_partial_fraction)
  freed      r' = 7/8 (forced: rescale 2, reach -1/4), r < R' < R < 1 optimised
Floors only: M0, Mc, K0, W taken as 0; A = log D0/log 2 + 4 with
D0 = Cb*81/(4 czeta) + 2, Cb >= 136 (ZetaGrowth.sq_zeta_band_bound: max 135 CK + 1)
and czeta = zeta(3)/zeta(3/2) evaluated by mpmath (a value, proved nowhere here).
  Glue.edge_left_bound   Cl = 72*256*D/2 + 1, D = 36 Ce + 9 (Mc + 1)/log 2
```
