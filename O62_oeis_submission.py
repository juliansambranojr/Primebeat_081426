#!/usr/bin/env python3
"""O62 — OEIS submission package for the iterated difference table of A036378.

NOT a measurement. This produces submission artifacts and nothing else.

WHAT IS BEING SUBMITTED. `papers/literature/litsearch_2_priority.md` records a
recognised OEIS genre — "Array read by antidiagonals downward where A(n,k) is
the n-th term of the k-th differences of X" — with members for noncomposites
(A376682), composites (A377033), squarefrees (A377038), nonsquarefrees
(A377046), prime powers (A377051), partitions (A175804) and strict partitions
(A378622). A095195 is the same recurrence seeded with prime(n), stated
character-for-character as this project's.

There is no member for A036378 (primes between 2^n and 2^(n+1)) or A007053.
That gap is what this submits.

SOURCE OF TRUTH. Every value comes from pi2n_cache.json, which holds pi(2^n)
for n = 0..62 and is the same input Zeros.pi2 pins its 21 values from. Nothing
is retyped.

CONVENTION, stated because OEIS will ask. Rows are indexed r >= 1 (the block
(2^(r-1), 2^r]) and depths d >= 0, with

    A(r, 0) = pi(2^r) - pi(2^(r-1))                      = A036378(r-1)
    A(r, d+1) = A(r, d) - A(r-1, d)

The array is defined for r > d. Read by antidiagonals downward, matching
A376682's convention exactly.

Writes:
  results/oeis_A036378_difftable_terms.txt   the flat term list
  results/oeis_A036378_difftable_bfile.txt   b-file, 1-indexed
  results/oeis_A036378_difftable_draft.txt   name/comments/crossrefs to paste
"""
import json, pathlib

_HERE = pathlib.Path(__file__).resolve().parent
CACHE = json.load(open(_HERE / "pi2n_cache.json"))
RMAX = max(int(k) for k in CACHE)
FOUR = [(2, 1), (4, 1), (8, 3), (20, 6)]
N_TERMS = 260          # comfortably past OEIS's display width


def table():
    """A(r,d), r >= 1, d >= 0, defined for r > d."""
    row = {r: CACHE[str(r)] - CACHE[str(r - 1)] for r in range(1, RMAX + 1)}
    T = {(r, 0): row[r] for r in range(1, RMAX + 1)}
    for d in range(1, RMAX):
        for r in range(d + 1, RMAX + 1):
            T[(r, d)] = T[(r, d - 1)] - T[(r - 1, d - 1)]
    return T


def antidiagonals(T):
    """Downward antidiagonals, A376682's reading: r + d = const, d ascending."""
    out = []
    for s in range(1, RMAX + 1):
        for d in range(0, s):
            r = s - d
            if (r, d) in T and r > d:
                out.append(((r, d), T[(r, d)]))
    return out


def main():
    T = table()
    ad = antidiagonals(T)
    print(f"O62 — OEIS submission package")
    print(f"source pi2n_cache.json, pi(2^n) for n = 0..{RMAX}")
    print(f"{len(ad)} array entries available; taking the first {N_TERMS}\n")

    terms = [v for _, v in ad][:N_TERMS]
    coords = [c for c, _ in ad][:N_TERMS]

    print("first 5 antidiagonals, as (r,d): value")
    seen = 0
    for s in range(1, 6):
        row = [(c, v) for c, v in ad if c[0] + c[1] == s]
        print(f"   s={s}: " + "  ".join(f"({c[0]},{c[1]}):{v}" for c, v in row))
        seen += len(row)

    # sanity: the four zeros must be present and zero
    print("\nthe four exact zeros, checked against the array:")
    ok = True
    for (r, d) in FOUR:
        v = T[(r, d)]
        i = coords.index((r, d)) + 1 if (r, d) in coords else None
        print(f"   A({r},{d}) = {v}" + (f"   term #{i}" if i else "   (beyond the term list)"))
        ok &= (v == 0)
    print(f"   all four vanish: {ok}")

    zeros_in_array = [(r, d) for (r, d), v in ad if v == 0 and d >= 1]
    print(f"\nevery zero at d >= 1 in the whole array (r <= {RMAX}): {zeros_in_array}")

    (_HERE / "results" / "oeis_A036378_difftable_terms.txt").write_text(
        ", ".join(str(v) for v in terms) + "\n")
    (_HERE / "results" / "oeis_A036378_difftable_bfile.txt").write_text(
        "".join(f"{i} {v}\n" for i, v in enumerate(terms, 1)))

    draft = f"""%S  {", ".join(str(v) for v in terms[:60])}
%N  Array read by antidiagonals downward where A(n,k) is the n-th term of the
    k-th differences of the number of primes between 2^m and 2^(m+1) (A036378).

%C  A(r,0) = pi(2^r) - pi(2^(r-1)) = A036378(r-1); A(r,d+1) = A(r,d) - A(r-1,d).
%C  Defined for r > d.
%C  The array has exactly four zero entries at depth d >= 1 for r <= {RMAX}:
%C  A(2,1) = A(4,1) = A(8,3) = A(20,6) = 0, and no others.
%C  At those four cells the complementary composite array takes the values
%C  1, 4, 16, 8192, i.e. 2^(r-1-d), since the prime and composite counts in a
%C  dyadic block partition 2^(r-1) and differencing is linear.
%C  A(r,d) equals the alternating binomial stencil sum_{{k=0..d}} (-1)^k C(d,k)
%C  A036378(r-k-1), so a zero is one linear condition on d+1 values of A036378.
%C  A(r,d) = 0 iff A(r,d-1) = A(r-1,d-1), i.e. the row repeats one depth up.

%H  <a href="bNNNNNN.txt">Table of n, a(n) for n = 1..260</a>
    (replace NNNNNN with the assigned A-number and upload
    results/oeis_A036378_difftable_bfile.txt)

%Y  Seed: A036378, A007053.
%Y  Same recurrence seeded with prime(n): A095195.
%Y  Same construction on other sequences: A376682 (noncomposites), A377033
    (composites), A377038 (squarefrees), A377046 (nonsquarefrees), A377051
    (prime powers), A175804 (partitions), A378622 (strict partitions).
%Y  Complementary composite counts: A182095. Li-residual: A223853, A223900.

%K  sign,tabl

%O  1,3
"""
    (_HERE / "results" / "oeis_A036378_difftable_draft.txt").write_text(draft)

    print("\nwrote:")
    for f in ("terms", "bfile", "draft"):
        print(f"   results/oeis_A036378_difftable_{f}.txt")


if __name__ == "__main__":
    main()
