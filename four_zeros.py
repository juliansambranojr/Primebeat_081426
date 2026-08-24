#!/usr/bin/env python3
"""The four exact zeros of the iterated difference table of pi(2^n).

No dependencies. No network. Runs in well under a second.

    N(r)         = pi(2^r) - pi(2^(r-1))          primes in (2^(r-1), 2^r]
    cell(r, 0)   = N(r)
    cell(r, d+1) = cell(r, d) - cell(r-1, d)

Over r <= 62, d <= 61 -- 1953 cells -- exactly four vanish at depth d >= 1:

    (2,1)   (4,1)   (8,3)   (20,6)

The only input is pi(2^n) for n = 0..62, listed below. Those are published
values (OEIS A007053); nothing else enters. The same four cells are proved to
vanish in lean/Zeros.lean as `measured_zeros_all_vanish`, at NO AXIOMS -- the
Lean kernel computes them from the same integers.

Part of https://github.com/juliansambranojr/Primebeat_081426 -- Apache-2.0.
"""

# pi(2^n) for n = 0..62.  OEIS A007053.
PI2 = [
    0, 1, 2, 4, 6,
    11, 18, 31, 54, 97,
    172, 309, 564, 1028, 1900,
    3512, 6542, 12251, 23000, 43390,
    82025, 155611, 295947, 564163, 1077871,
    2063689, 3957809, 7603553, 14630843, 28192750,
    54400028, 105097565, 203280221, 393615806, 762939111,
    1480206279, 2874398515, 5586502348, 10866266172, 21151907950,
    41203088796, 80316571436, 156661034233, 305761713237, 597116381732,
    1166746786182, 2280998753949, 4461632979717, 8731188863470, 17094432576778,
    33483379603407, 65612899915304, 128625503610475, 252252704148404, 494890204904784,
    971269945245201, 1906879381028850, 3745011184713964, 7357400267843990, 14458792895301660,
    28423094496953330, 55890484045084135, 109932807585469973
]


def table(pi2):
    """cell[(r, d)] for r >= 1, d >= 0, defined where r > d."""
    rmax = len(pi2) - 1
    cell = {(r, 0): pi2[r] - pi2[r - 1] for r in range(1, rmax + 1)}
    for d in range(1, rmax):
        for r in range(d + 1, rmax + 1):
            cell[(r, d)] = cell[(r, d - 1)] - cell[(r - 1, d - 1)]
    return cell, rmax


def main():
    cell, rmax = table(PI2)
    total = len(cell)
    zeros = sorted((r, d) for (r, d), v in cell.items() if v == 0 and d >= 1)

    print(f"pi(2^n) for n = 0..{rmax}   ->   {total} cells")
    print(f"exact zeros at depth d >= 1: {zeros}")
    print(f"count: {len(zeros)}\n")

    # each zero, spelled out as the alternating binomial stencil on pi
    from math import comb
    for (r, d) in zeros:
        terms = [(-1) ** k * comb(d, k) * (PI2[r - k] - PI2[r - k - 1])
                 for k in range(d + 1)]
        parts = []
        for k, t in enumerate(terms):
            w = (-1) ** k * comb(d, k)
            n = PI2[r - k] - PI2[r - k - 1]
            parts.append(f"{'+' if w > 0 else '-'} {abs(w)}*{n}")
        s = " ".join(parts).lstrip("+ ")
        print(f"({r},{d}):  {s}  =  {sum(terms)}")

    # the two readings of a zero, both checked here
    print()
    for (r, d) in zeros:
        rep = cell[(r, d - 1)] == cell[(r - 1, d - 1)]
        print(f"({r},{d}): row repeats one depth up: {rep}"
              f"   [cell({r},{d-1}) = cell({r-1},{d-1}) = {cell[(r, d - 1)]}]")

    # the composite arm carries the whole block at each zero
    print()
    for (r, d) in zeros:
        print(f"({r},{d}): composite arm = 2^({r}-1-{d}) = {2 ** (r - 1 - d)}")

    assert zeros == [(2, 1), (4, 1), (8, 3), (20, 6)], zeros
    print("\nOK")


if __name__ == "__main__":
    main()
