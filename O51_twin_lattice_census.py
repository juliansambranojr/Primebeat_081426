#!/usr/bin/env python3
"""O51 — EXPLORATORY. No prereg, no verdict.

The three-way occupancy census of the 2*3 lattice, in dyadic blocks.

`lean/TwinLattice.lean` proves every twin pair above 3 sits at (6k-1, 6k+1), so
the pocket between them is the lattice site 6k. That makes each site 6k one of
four things:

    twin   both 6k-1 and 6k+1 prime      the site is doubly flanked
    lo     only 6k-1 prime               flanked below
    hi     only 6k+1 prime               flanked above
    bare   neither

This counts them per dyadic block and asks four things, none of which has been
asked on this bench:

  1. Does the four-way split partition the sites exactly? (It must; a failure
     is a bug, so this is the self-check.)
  2. Is the site count per block EXACTLY geometric? PairIdentity.pair_identity
     needs a geometric total, and floor() may break it. Measured, not assumed.
  3. lo vs hi -- the Chebyshev bias read on the lattice rather than on x.
  4. Does the difference table of the TWIN arm have exact zeros? That is the
     direct analogue of the four zeros of the prime table (O16, O43, O44),
     asked of a different arithmetic object on the same construction.

Reads with: lean/TwinLattice.lean, notes/lab_notebook_2.md entry 81,
CONTEXT.md core quantities (the tableFrom recurrence), O44_cross_base_zero_scan.py
"""
import json, math, pathlib, sys
import numpy as np

_HERE = pathlib.Path(__file__).resolve().parent
RMAX = 30                      # dyadic rungs; ceiling 2^RMAX
N = 2 ** RMAX


def odd_sieve(n):
    """s[i] True iff 2i+1 is prime, for 2i+1 < n."""
    s = np.ones(n // 2, dtype=bool)
    s[0] = False                                   # 1 is not prime
    for i in range(3, int(n ** 0.5) + 1, 2):
        if s[i // 2]:
            s[(i * i) // 2::i] = False
    return s


def is_prime_odd(s, x):
    """vectorised primality for odd x (arrays)."""
    return s[x // 2]


def main():
    print("O51 - twin lattice census.  EXPLORATORY, no prereg, no verdict.")
    print(f"ceiling 2^{RMAX} = {N:,}\n")
    s = odd_sieve(N + 8)

    rows = []
    for r in range(2, RMAX + 1):
        lo_x, hi_x = 2 ** (r - 1), 2 ** r
        k0 = lo_x // 6 + 1
        k1 = hi_x // 6
        if k1 < k0:
            continue
        k = np.arange(k0, k1 + 1, dtype=np.int64)
        site = 6 * k
        a = is_prime_odd(s, site - 1)
        b = is_prime_odd(s, site + 1)
        twin = int(np.sum(a & b)); lo = int(np.sum(a & ~b))
        hi = int(np.sum(~a & b)); bare = int(np.sum(~a & ~b))
        n_sites = len(k)
        rows.append({"r": r, "n_sites": n_sites, "twin": twin, "lo": lo,
                     "hi": hi, "bare": bare,
                     "partition_ok": twin + lo + hi + bare == n_sites})

    print("1. CENSUS  (partition self-check in the last column)")
    print(f"{'r':>3} {'sites':>10} {'twin':>9} {'lo':>9} {'hi':>9} {'bare':>10}  ok")
    for x in rows:
        print(f"{x['r']:>3} {x['n_sites']:>10,} {x['twin']:>9,} {x['lo']:>9,} "
              f"{x['hi']:>9,} {x['bare']:>10,}  {x['partition_ok']}")
    allok = all(x["partition_ok"] for x in rows)
    print(f"   partition exact at every rung: {allok}")

    print("\n2. IS THE SITE COUNT EXACTLY GEOMETRIC?")
    print("   pair_identity needs a geometric total; floor() may break it.")
    print(f"{'r':>3} {'n_sites':>10} {'2^(r-1)/6':>14} {'difference':>11}")
    exact = True
    for x in rows:
        pred = 2 ** (x["r"] - 1) / 6
        d = x["n_sites"] - pred
        if abs(d) > 1e-9:
            exact = False
        print(f"{x['r']:>3} {x['n_sites']:>10,} {pred:>14.4f} {d:>11.4f}")
    print(f"   exactly geometric: {exact}")

    print("\n3. CHEBYSHEV ON THE LATTICE  (lo = 6k-1 only, hi = 6k+1 only)")
    print(f"{'r':>3} {'lo':>9} {'hi':>9} {'lo-hi':>8} {'(lo-hi)/sqrt(sites)':>20}")
    for x in rows[-12:]:
        d = x["lo"] - x["hi"]
        print(f"{x['r']:>3} {x['lo']:>9,} {x['hi']:>9,} {d:>8,} "
              f"{d / math.sqrt(x['n_sites']):>20.4f}")

    print("\n4. DOES THE TWIN ARM'S DIFFERENCE TABLE HAVE EXACT ZEROS?")
    print("   same recurrence as Construction.tableFrom, on the twin row")
    row = {x["r"]: x["twin"] for x in rows}
    rs = sorted(row)
    tab = {0: dict(row)}
    dmax = len(rs) - 2
    for d in range(1, dmax + 1):
        tab[d] = {q: tab[d - 1][q] - tab[d - 1][q - 1]
                  for q in rs if q in tab[d - 1] and q - 1 in tab[d - 1]}
    zeros = [(q, d) for d in range(1, dmax + 1) for q in sorted(tab[d])
             if tab[d][q] == 0]
    print(f"   cells examined at d >= 1: "
          f"{sum(len(tab[d]) for d in range(1, dmax + 1)):,}")
    print(f"   EXACT ZEROS: {zeros if zeros else 'NONE'}")
    print(f"   (prime table for comparison: (2,1) (4,1) (8,3) (20,6), "
          f"r <= 92 -- O43)")

    out = {"schema_version": "1", "script": "O51_twin_lattice_census.py",
           "exploratory": True, "prereg": None,
           "params": {"rmax": RMAX, "ceiling": N, "lattice": 6},
           "summary": {"partition_exact_everywhere": allok,
                       "site_count_exactly_geometric": exact,
                       "twin_arm_exact_zeros": zeros,
                       "n_cells_examined": sum(len(tab[d])
                                               for d in range(1, dmax + 1))},
           "rows": rows}
    p = _HERE / "results" / "twin_lattice_census.json"
    p.write_text(json.dumps(out, indent=2))
    print(f"\nwrote {p}")


if __name__ == "__main__":
    main()
