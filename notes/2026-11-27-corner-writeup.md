# The deep corner of the dyadic prime table — write-up, 2026-11-27

The table: row `r` is `π(2^r) − π(2^(r−1))`, and each depth is the backward difference of the one
above. Its only known zeros are (2,1), (4,1), (8,3) and (20,6). This note gathers what the session
established about the part of the table no error bound reaches, the cells with depth past about a
third of the row. Every number below is in the unit named beside it; every theorem is in the Lean
file named, built by `lake build` with exit 0 and pinned at `propext, Classical.choice, Quot.sound`.

## 1. The bottom of the table is settled from the primes

`Census21.only_four_zeros_le21`: in rows 1–21, at every depth, the only zeros are the four, with no
named input — the prime counts are computed by the kernel through verified sieves (`PiSieve`,
`Legendre`). `Census20.zero_20_6_true`: (20,6) is a zero of the true table (unit 0595).

## 2. The corner is where the table reads the zeros

Along an edge diagonal, the cell at row `g + d`, depth `d`, is the `d`-th forward difference of the
rows from `g` (`EdgeDiagonal.edge_eq_fwdDiff`). An exponential `z^m` passes through with the factor
`(z − 1)^d` (`fwdDiff_iter_geom`, `fwdDiff_iter_sum`): the main term `2^m` with factor one per depth
(`fwdDiff_iter_two`), a zero `ρ` with `2^ρ − 1`, whose size lies between `2^β − 1` and `2^β + 1`
(`normSq_sub_one_le`). So in the corner the zeros must outgrow the main term. The data agree: edge
cells grow per depth by about the `log(1 + √2)` a zero on the line can reach (unit 0596).

The corner comes back from the zeros cell by cell. The smooth part alone gets the sign of a corner
cell little better than a coin; two thousand zeros get almost all of them, with a median error under
a tenth (unit 0597).

## 3. Four routes to keeping a corner cell off zero, and where each stops

1. **Error bounds.** The exact floor (`ExactFloor` to `ExactRH`) carries the gate to about
   `r ≈ 3.5d` under RH; past it the oscillation leads (unit 0594).
2. **Amplification.** Depth never magnifies an offline zero beyond what the row gives it:
   `2^β + 1 ≤ 2^(β − 1/2)(2^(1/2) + 1)` (`OfflineGain`, unit 0598). On the data a zero moved off the
   line shows at about the same rate in every region (unit 0599).
3. **Size.** Counting each cell's chance of landing on zero by its size, the cells past the computed
   range leave room for about 1e-17 further zeros (unit 0599). A heuristic: the cells are fixed by
   the primes, not drawn.
4. **Congruences.** At a prime-power depth a cell is two rows mod `p`
   (`ParityCell.prime_dvd_cell_prime_pow`), which keeps most such cells off zero — but only where the
   rows are known (unit 0600). `CornerSign`: a cell with parents of opposite sign is not zero.

## 4. What it means for the census to infinity

Each depth has only finitely many zeros, from the prime number theorem alone
(`PNTDepth.eventually_ne_zero_x`, welded to PNT+). What no route here supplies is the row where each
depth clears, nor any statement about the corner that holds for every row: that is a statement about
the zeros' sum, and the four routes above show it cannot come from amplification, size or
congruence alone.

## 5. The tools built for the counting

Legendre's formula (`Legendre.primeCounting_eq_phi`) and Meissel–Lehmer's
(`MeisselLehmer.meissel_lehmer`) are both proved; the latter sieves only to the cube root (unit 0601).
