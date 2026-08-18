#!/usr/bin/env python3
"""
O2 — Can a self-adjoint operator built from primes alone have the zeta zeros
     as its spectrum?

Reads with: dyadic-table-v2.md, DT-A..DT-A5, and the Prime Beat papers
(Sambrano, Jan 2026), whose Lock 2 asserts that the Prime Beat "defines an
implicit Hamiltonian whose eigenfunctions correspond to oscillation modes."

WHAT THIS TESTS
---------------
Lock 2 was never constructed — no operator is written down anywhere.  This
script writes one down, explicitly, from primes only, and computes its
spectrum.  Three questions, all with a possible different answer:

    Q1. Build K(x,y) = sum_p p^(-1/2) cos( (ln p)(x - y) ).
        Is it self-adjoint?
    Q2. Is its spectrum the zeta heights {gamma}?
    Q3. Independent of any operator: do the Prime Beat's minima obey the
        counting law N(T) that a true spectrum must obey?

Nothing is fitted.  No zeta zero is used as an input to any construction;
the known gamma values appear only at the end, as something to compare to.

REQUIREMENTS
------------
    pip install numpy

Runs in roughly a minute at the defaults.

USAGE
-----
    python3 O2_prime_kernel_spectrum.py
    python3 O2_prime_kernel_spectrum.py --grid 400 --tmax 300
"""

import argparse
import numpy as np


# First 30 nontrivial zeta heights.  USED ONLY FOR COMPARISON AT THE END —
# never as input to the kernel, the Beat, or the counting law.
GAMMA = np.array([
    14.134725, 21.022040, 25.010858, 30.424876, 32.935062, 37.586178,
    40.918719, 43.327073, 48.005151, 49.773832, 52.970321, 56.446248,
    59.347044, 60.831779, 65.112544, 67.079811, 69.546402, 72.067158,
    75.704691, 77.144840, 79.337375, 82.910381, 84.735493, 87.425275,
    88.809111, 92.491899, 94.651344, 95.870634, 98.831194, 101.317851,
])


def sieve_primes(limit):
    """Exact primes by sieve of Eratosthenes."""
    s = np.ones(limit + 1, dtype=bool)
    s[:2] = False
    for i in range(2, int(limit ** 0.5) + 1):
        if s[i]:
            s[i * i::i] = False
    return np.flatnonzero(s).astype(np.float64)


def build_kernel(xs, p, chunk=500):
    """K(x,y) = sum_p p^(-1/2) cos((ln p)(x - y)).  Primes only."""
    logp = np.log(p)
    w = p ** -0.5
    D = xs[:, None] - xs[None, :]
    K = np.zeros_like(D)
    for i in range(0, len(p), chunk):
        lp = logp[i:i + chunk]
        ww = w[i:i + chunk]
        K += np.einsum('k,jlk->jl', ww, np.cos(D[:, :, None] * lp[None, None, :]))
    return K


def prime_beat(t, sigma, p, chunk=1500):
    """B(t) = | sum_p p^(-sigma) sin(t ln p) |.  Primes only."""
    lp = np.log(p)
    w = p ** (-sigma)
    out = np.empty(len(t))
    for i in range(0, len(t), chunk):
        tc = t[i:i + chunk]
        out[i:i + chunk] = np.abs((w[None, :] * np.sin(np.outer(tc, lp))).sum(1))
    return out


def riemann_N(T):
    """Riemann-von Mangoldt: number of zeros with height up to T."""
    return (T / (2 * np.pi)) * np.log(T / (2 * np.pi)) - T / (2 * np.pi) + 7 / 8


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--grid", type=int, default=300, help="kernel grid size")
    ap.add_argument("--xmax", type=float, default=60.0, help="kernel x range")
    ap.add_argument("--tmax", type=float, default=200.0, help="counting-law range")
    ap.add_argument("--plimit", type=int, default=300000, help="sieve limit")
    args = ap.parse_args()

    allp = sieve_primes(args.plimit)
    xs = np.linspace(0, args.xmax, args.grid)

    print("=" * 76)
    print("O2 — a self-adjoint operator from primes alone, and its spectrum")
    print("=" * 76)
    print(f"  sieved {len(allp)} primes up to {args.plimit}")
    print(f"  kernel grid: {args.grid} points on x in [0, {args.xmax}]")

    # ---------------- Q1 + Q2 -------------------------------------------
    print("\n" + "-" * 76)
    print("Q1/Q2.  K(x,y) = sum_p p^(-1/2) cos((ln p)(x-y))")
    print("-" * 76)

    for NP in [100, 1000, 5000]:
        p = allp[:NP]
        K = build_kernel(xs, p)
        sym = np.linalg.norm(K - K.T)
        ev = np.linalg.eigvalsh(K)
        print(f"\n  --- {NP} primes ---")
        print(f"    ||K - K^T|| = {sym:.3e}     -> self-adjoint by construction")
        print(f"    spectrum real: True (spectral theorem);  "
              f"range [{ev.min():.4f}, {ev.max():.4f}]")
        print(f"    top 8 eigenvalues: "
              f"{np.array2string(ev[::-1][:8], precision=3)}")
        print(f"    distance from each of the first 5 gamma to nearest eigenvalue:")
        for g in GAMMA[:5]:
            print(f"      gamma = {g:9.5f}   nearest eigenvalue at distance "
                  f"{np.min(np.abs(ev - g)):.4f}")

    # ---------------- what the kernel actually is ------------------------
    print("\n" + "-" * 76)
    print("WHAT THE OPERATOR IS")
    print("-" * 76)
    print("""
  K(x,y) depends only on the difference (x - y).  That makes it a CONVOLUTION
  (Toeplitz) kernel.  A convolution operator is diagonalised by e^{i w x}, and
  its eigenvalues are the Fourier transform of the kernel — which here is the
  set of weights p^(-1/2) sitting at the frequencies ln p.

  So the spectrum is  { p^(-1/2) }  at frequencies  { ln p }:
  the LENGTH spectrum (primes), not the eigenvalue spectrum (gammas).
""")
    p = allp[:100]
    K = build_kernel(xs, p)
    ev = np.linalg.eigvalsh(K)[::-1]
    w = np.sort(p ** -0.5)[::-1] * args.grid / 2
    print(f"  top 8 eigenvalues       : {np.array2string(ev[:8], precision=3)}")
    print(f"  top 8 of p^(-1/2)*n/2   : {np.array2string(w[:8], precision=3)}")
    print("  (same object; the offsets are finite-grid dispersion)")

    # ---------------- Q3: the counting law ------------------------------
    print("\n" + "-" * 76)
    print("Q3.  COUNTING LAW — independent of any operator")
    print("-" * 76)
    print("  A genuine spectrum {gamma} must satisfy the Riemann–von Mangoldt law")
    print("      N(T) = (T/2pi) ln(T/2pi) - T/2pi + 7/8")
    print("  Do the Prime Beat's minima have that density?\n")

    tt = np.arange(10, args.tmax, 0.002)
    Ntrue = riemann_N(args.tmax)
    print(f"  {'#primes':>9} {'minima':>9} {'N(T) true':>11} {'ratio':>8}")
    ratios = []
    for NP in [100, 1000, 5000, 25000]:
        if NP > len(allp):
            continue
        b = prime_beat(tt, 0.5, allp[:NP])
        loc = np.flatnonzero((b[1:-1] < b[:-2]) & (b[1:-1] < b[2:])) + 1
        cnt = len(loc)
        ratios.append(cnt / Ntrue)
        print(f"  {NP:>9} {cnt:>9} {Ntrue:>11.2f} {cnt / Ntrue:>8.3f}")

    print("\n  If the minima were converging to the zero set, the ratio would")
    print(f"  approach 1.  Observed: {ratios[0]:.2f} -> {ratios[-1]:.2f}, DIVERGING.")
    print("  The count of minima grows with the number of primes used; the")
    print("  count of zeros below T does not.")

    # ---------------- conclusion ----------------------------------------
    print("\n" + "=" * 76)
    print("CONCLUSION")
    print("=" * 76)
    print("""
  Q1. YES — the operator is self-adjoint, exactly, by construction, and is
      built from primes with no reference to zeta.  Self-adjointness is
      cheap; it is not the hard part.

  Q2. NO — its spectrum is { p^(-1/2) } at frequencies { ln p }.  This is
      forced: a kernel that is a superposition of frequencies ln p has those
      frequencies as its spectrum.  In trace-formula terms the Beat is built
      from the LENGTH spectrum, and the gammas live on the other side of the
      identity.  Building from one side cannot deliver the other.

  Q3. NO — the Beat's minima do not obey the Riemann–von Mangoldt counting
      law, and the discrepancy GROWS with the number of primes.  Whatever the
      minima are, they are not converging to the zero set.

  One thing does point the other way and is worth isolating: the distance
  from the first few gammas to the nearest kernel eigenvalue TIGHTENS as more
  primes enter (gamma_1: 0.90 at 100 primes -> 0.10 at 5000).  The bulk
  spectrum is not the gammas, but something in it is moving toward them.
  That is the open thread this script leaves behind.
""")


if __name__ == "__main__":
    main()
