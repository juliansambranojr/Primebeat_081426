# Fast route to pi(2^m) mod 2 — work in progress (not a result)

Julian's answer to corner question 6 (`notes/corner-questions.md`): build the faster route to row 93's
parity, checked against rows 2-92 before it is trusted past 92. This folder keeps the code safe while it
is built; nothing here is evidence until it is a unit.

- `dsum.h` — D(n) = sum_{k<=n} tau(k) mod 2^64 by a hull walk under the hyperbola; `test_dsum.c` checks it
  against the plain loop.
- `fast.c` — S(2^m) = sum 2^omega(n) mod 2^64 split as A + B1 + B2 (see its header), then pi(2^m) mod 2.
  Build: `gcc -O3 -march=native -fopenmp fast.c -o fast -lm`; run: `./fast m log2c log2L`.
- `plainS.c` — the plain reference, printing S mod 2^64 (its divisor table carries D mod 2^64).

Update: `dsum2.h` adds a 64-bit hull path; `fast.c` now uses it and a cache-sized tau sieve;
`runrows.sh` runs rows against the pi list. State at the previous commit: full S mod 2^64 agrees with `plainS` on every test so far (rows 16-58, many splits);
pi(2^m) mod 2 agrees with the pi list on the rows spot-checked. Not yet timed cleanly; not yet run past 66.

State now: pi(2^m) mod 2 from `fast.c` agrees with the pi list on rows 66, 68, 70 and 72 (rows past the
plain code's 66), and full S mod 2^64 agrees with `plainS` wherever both ran. Wall time on four cores:
13.4 s at row 66, 24 s at 68, 45 s at 70, 79 s at 72, about 2^0.4 per row. Rows 67-80 running now.
