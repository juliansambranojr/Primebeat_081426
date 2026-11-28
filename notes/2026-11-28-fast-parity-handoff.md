# Handoff to the Mac: the fast route to π(2^m) mod 2, rows 81–93

Julian's answer to corner question 7 (`notes/corner-questions.md`), 2026-11-28: "Send the c". The cloud
session built the route; the Mac runs the check on rows 81–92 and then row 93. Everything here is
EXPLORATORY bench work. Nothing is a unit yet: when the rows are in, log one (ask Julian first).

## What it computes

S(x) = Σ_{n≤x} 2^ω(n) is 1 + 2·Π(x) mod 4 (Π the count of prime powers ≤ x), and
π(x) = Π(x) − Σ_{k≥2} π(⌊x^{1/k}⌋). `fast.c` computes S(2^m) mod 2^64 as A + B1 + B2 (the header of
`fast.c` gives the split: the hull-walk divisor sum for e ≤ c, a segmented μ sweep with a segmented τ
stream for c < e ≤ L, and a Mertens-type recursion for e > L), then the roots by Lucy's method, and prints

    m  S_mod_2^64  S_mod4  pi_parity  sec_A  sec_B1  sec_B2  sec_roots

Code: `analysis/2026-11-28/fast_parity/` (`fast.c`, `dsum2.h`; `runrows.sh` the driver;
`test_dsum2.c` the hull-walk test; `plainS.c` the plain reference for S mod 2^64).

## How far it is checked (cloud, 2026-11-28)

- The hull-walk divisor sum: 203031 values against the plain loop, all equal (`test_dsum2.c`).
- Full S mod 2^64 against `plainS.c`: equal on every test, rows 16–58, many (c, L) splits chosen so
  the recursion, the middle queries and the τ stream all run.
- π(2^m) mod 2 against the π list (`units/0641-corner-residues/run/pi_2pow.txt`): rows 2–47 spot
  checks, and every row 66–79, all equal. Row 80 was running when this was written; the session will
  append its line below.
- The plain C code (unit 0643) is exact on rows 2–66 and is the reference below 67.

## Build on the Mac

`__int128` is fine on arm64 clang. Apple clang needs libomp for OpenMP:

    brew install libomp
    clang -O3 -mcpu=native -Xpreprocessor -fopenmp -I$(brew --prefix libomp)/include \
      -L$(brew --prefix libomp)/lib -lomp fast.c -o fast4 -lm

(`runrows.sh` calls `./fast4`.) Rebuild and run `test_dsum2.c` first. Then rerun two rows the cloud
already did, say 72 and 76, and compare the whole output line, S mod 2^64 included:

    72 6825415563506810599 3 1 ...        (c=2^21, L=2^30)

That checks the build before anything new is trusted. `long double` is a plain double on arm64; the
square, cube and k-th roots are corrected by integer loops after the estimate, so that is safe.

## Run

`OMP_NUM_THREADS` = the Mac's performance cores. Parameters: c = 2^round(0.29 m), L = 2^round(0.415 m)
(what `runrows.sh` uses). Rows 81–92 against the list, then 93:

    ./runrows.sh 81 92        # appends to rows.log: output | list=<parity from the π list> c L wall
    ./fast4 93 27 39

Timings on the cloud's four cores (wall seconds): row 72 79.6, row 76 267.0, row 79 655.2; growth about
2^0.43 per row, so about 9 hours at row 92 and 12 hours at row 93 on four cores, less on more. Memory
at row 93 is about 1.5 GB by the arrays' sizes (the μ table to c, its 8-byte scratch, the small M table
to x^(1/4), Lucy's two arrays at the square root); not measured.

## What a row past 92 gives

The parity of π(2^93), hence of row 93 of the table, a(93) = π(2^93) − π(2^92). By the parity
certificate (`lean/ParityCell.lean`, unit 0617), each corner cell in row 93 whose Lucas support mod 2
lies in rows with known parity, and whose value is odd, is nonzero. That covers the odd ones among the
cells row 93 completes; the corner past it stays open (corner question 4: finite-row certificates, the
rest a measure statement).

## Rows 67–79 (cloud, fast route, four cores)

    m   pi_parity  list   c     L     wall_s
    67  1          1      2^19  2^28  21.5
    68  0          0      2^20  2^28  24.4
    69  0          0      2^20  2^29  33.7
    70  1          1      2^20  2^29  48.9
    71  1          1      2^21  2^29  56.3
    72  1          1      2^21  2^30  79.6
    73  1          1      2^21  2^30  108.9
    74  0          0      2^21  2^31  161.5
    75  1          1      2^22  2^31  191.8
    76  1          1      2^22  2^32  267.0
    77  0          0      2^22  2^32  355.3
    78  0          0      2^23  2^32  482.3
    79  1          1      2^23  2^33  655.2
