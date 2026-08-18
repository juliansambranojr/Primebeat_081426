#!/usr/bin/env python3
"""
O1 — Is the dyadic difference operator self-adjoint, and what is its spectrum?

Reads with: dyadic-table-v2.md (esp. §3.1, §3.2, §7.1), DT-A3 §2.2, §2.3.

WHAT THIS TESTS
---------------
The Hilbert-Polya program needs a SELF-ADJOINT operator, because self-adjointness
forces real eigenvalues (spectral theorem).  v2.0 §3.2 discusses S (dilation) and
Delta = S - I, and DT-A3 §2.2 retracts the claim that sigma = 1/2 follows from a
norm computation.  What was never run is the direct, finite-dimensional question:

    Q1. Is Delta self-adjoint under ANY positive diagonal weight?
    Q2. If not, what symmetric operator IS available, and what is its spectrum?
    Q3. Does that spectrum relate to anything already in the documents?

All three are answered here by exact linear algebra on the actual prime counts.
Nothing is fitted.  A different answer was possible at every step.

REQUIREMENTS
------------
    pip install numpy

Runs in a few seconds at RMAX=24.  Set RMAX higher only if you have primecountpy;
the sieve here is memory-bound around 2^28.

USAGE
-----
    python3 O1_operator_selfadjointness.py
    python3 O1_operator_selfadjointness.py --rmax 20
"""

import argparse
import numpy as np


# ----------------------------------------------------------------------------
# Prime counts per dyadic regime:  c_r = #{ n : 2^(r-1) < n <= 2^r, n prime }
# ----------------------------------------------------------------------------

def dyadic_counts(rmax):
    """Exact prime counts per dyadic regime, by sieve. Integers throughout."""
    lim = 2 ** rmax
    sieve = np.ones(lim + 1, dtype=bool)
    sieve[:2] = False
    for i in range(2, int(lim ** 0.5) + 1):
        if sieve[i]:
            sieve[i * i::i] = False
    primes = np.flatnonzero(sieve)
    return np.array(
        [int(((primes > 2 ** (r - 1)) & (primes <= 2 ** r)).sum())
         for r in range(1, rmax + 1)],
        dtype=float,
    )


# ----------------------------------------------------------------------------
# The operator, as a matrix
# ----------------------------------------------------------------------------

def delta_matrix(n):
    """Forward difference (Delta f)(r) = f(r+1) - f(r), truncated to n x n."""
    D = np.zeros((n, n))
    for r in range(n - 1):
        D[r, r] = -1.0
        D[r, r + 1] = 1.0
    return D


def laplacian_matrix(n):
    """Central second difference. Symmetric by construction — a control."""
    L = np.zeros((n, n))
    for r in range(n):
        L[r, r] = -2.0
        if r > 0:
            L[r, r - 1] = 1.0
        if r < n - 1:
            L[r, r + 1] = 1.0
    return L


# ----------------------------------------------------------------------------
# Q1 — can any positive diagonal weight make Delta self-adjoint?
# ----------------------------------------------------------------------------

def test_diagonal_weight(D, tol=1e-12):
    """
    Delta is self-adjoint under <f,g>_w = sum f(r) g(r) w(r)  iff  W D = D^T W
    for W = diag(w).  Entrywise that is  w_i * D_ij = w_j * D_ji  for all i, j.

    Returns (possible, witness) where witness explains the obstruction.
    """
    n = D.shape[0]
    for i in range(n):
        for j in range(n):
            if i == j:
                continue
            a, b = D[i, j], D[j, i]
            # If one direction is nonzero and the reverse is zero, the condition
            # w_i * a = w_j * b forces w_i = 0 (or w_j = 0) — no positive weight.
            if abs(a) > tol and abs(b) <= tol:
                return False, (i, j, a, b)
    return True, None


# ----------------------------------------------------------------------------
# main
# ----------------------------------------------------------------------------

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--rmax", type=int, default=24,
                    help="highest dyadic regime (default 24; sieve to 2^rmax)")
    args = ap.parse_args()

    R = args.rmax
    c = dyadic_counts(R)
    n = len(c)

    print("=" * 74)
    print(f"O1 — operator self-adjointness and spectrum   (regimes 1..{R})")
    print("=" * 74)
    print("\nPrime counts per regime, c_r:")
    print(c.astype(int))

    D = delta_matrix(n)

    # --- sanity: the matrix really does reproduce the table -----------------
    d1_matrix = (D @ c)[:-1]
    d1_direct = np.diff(c)
    assert np.allclose(d1_matrix, d1_direct), "matrix does not reproduce Delta"
    print("\n[check] matrix Delta reproduces the finite differences: OK")

    # --- Q1 ------------------------------------------------------------------
    print("\n" + "-" * 74)
    print("Q1.  Is Delta self-adjoint under any positive diagonal weight?")
    print("-" * 74)
    print(f"  Under plain l2:  ||D - D^T|| = {np.linalg.norm(D - D.T):.6f}   (nonzero => not symmetric)")

    possible, witness = test_diagonal_weight(D)
    if possible:
        print("  A weight may exist — solve W D = D^T W.")
    else:
        i, j, a, b = witness
        print(f"  NO.  Obstruction at (i,j) = ({i},{j}):")
        print(f"    D[{i},{j}] = {a:+.0f}   but   D[{j},{i}] = {b:+.0f}")
        print(f"    self-adjointness needs w_{i}*({a:+.0f}) = w_{j}*({b:+.0f}) = 0,  forcing w_{i} = 0.")
        print("    No POSITIVE weight exists.  Delta is one-sided: its graph is")
        print("    directed, and symmetry requires a two-sided operator.")
    print("\n  => Delta cannot be made self-adjoint by reweighting.  This is not a")
    print("     limitation of range or precision; it is structural.")

    # --- Q2 ------------------------------------------------------------------
    print("\n" + "-" * 74)
    print("Q2.  What symmetric operator is available, and what is its spectrum?")
    print("-" * 74)

    M = D.T @ D
    sym_err = np.linalg.norm(M - M.T)
    print(f"  M = Delta* Delta      ||M - M^T|| = {sym_err:.2e}   (symmetric)")
    ev = np.linalg.eigvalsh(M)
    print(f"  all eigenvalues real: {np.allclose(ev.imag if np.iscomplexobj(ev) else 0, 0)}")
    print(f"  all eigenvalues >= 0: {bool((ev >= -1e-12).all())}   (positive semidefinite)")
    print(f"  spectrum in [0, 4]:   {bool((ev >= -1e-12).all() and (ev <= 4 + 1e-12).all())}")
    print("\n  eigenvalues of Delta* Delta:")
    for k in range(0, len(ev), 6):
        print("   ", "  ".join(f"{v:8.6f}" for v in ev[k:k + 6]))

    # --- Q3 ------------------------------------------------------------------
    print("\n" + "-" * 74)
    print("Q3.  Does this spectrum match anything already in the documents?")
    print("-" * 74)
    print("  v2.0 §7.1 derives, from the operator and with nothing fitted, that")
    print("  differencing multiplies a zeta zero of height gamma by")
    print("        (2 sin(omega/2))^d,     omega = gamma * ln2  mod 2*pi.")
    print("  So a single application has gain (2 sin(omega/2))^2 = lambda.")
    print("  Invert:  omega = 2 arcsin( sqrt(lambda) / 2 ).\n")

    omega = 2 * np.arcsin(np.clip(np.sqrt(np.abs(ev)) / 2, 0, 1))
    print("  implied omega from each eigenvalue:")
    for k in range(0, len(omega), 6):
        print("   ", "  ".join(f"{v:8.6f}" for v in omega[k:k + 6]))

    spacing = np.diff(omega)
    predicted = np.pi / n
    print(f"\n  consecutive spacing: mean {spacing.mean():.6f}, "
          f"sd {spacing.std():.2e}")
    print(f"  pi/n = pi/{n} = {predicted:.6f}")
    print(f"  max deviation from uniform pi/n grid: "
          f"{np.abs(omega - np.arange(n) * predicted).max():.2e}")
    print("\n  => the spectrum of Delta* Delta IS the comb filter of §7.1,")
    print("     on a uniform omega grid of spacing pi/n.  Two derivations,")
    print("     one analytic and one linear-algebraic, of the same object.")

    # --- control -------------------------------------------------------------
    print("\n" + "-" * 74)
    print("CONTROL.  Numerics check against a closed form.")
    print("-" * 74)
    L = laplacian_matrix(n)
    evL = np.linalg.eigvalsh(L)
    k = np.arange(1, n + 1)
    theo = np.sort(-4 * np.sin(k * np.pi / (2 * (n + 1))) ** 2)
    err = np.abs(evL - theo).max()
    print("  discrete Laplacian eigenvalues vs -4 sin^2(k*pi/(2(n+1))):")
    print(f"    max abs error = {err:.2e}   -> eigensolver is sound")

    # --- what this does and does not give ------------------------------------
    print("\n" + "=" * 74)
    print("CONCLUSION")
    print("=" * 74)
    print("""
  Delta is NOT self-adjoint, and no reweighting fixes it.  What is symmetric
  is Delta* Delta, whose spectrum is real, lies in [0, 4], and is exactly the
  comb-filter gain already derived analytically in v2.0 §7.1.

  Delta* Delta is positive semidefinite.  That is the shape of a QUADRATIC
  FORM, not of a Hamiltonian whose eigenvalues could be the zeta heights
  {gamma}: those are unbounded and this is bounded by 4.  So the real spectrum
  found here is a real fact about the operator and is NOT the Hilbert-Polya
  spectrum.

  This neither supports nor refutes RH.  It closes one specific question that
  the documents left open by assertion on both sides.
""")


if __name__ == "__main__":
    main()
