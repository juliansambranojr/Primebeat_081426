/*
 * twincount.c -- count twin primes up to N, writing pi_2(x) at dense checkpoints.
 *
 * Uses primesieve's iterator, which streams primes without materialising them,
 * so memory is flat (a few MB) regardless of N.
 *
 * Output: CSV "x,pi2" with one row per checkpoint. Default 10^7 spacing to 10^11
 * gives 10,000 rows -- enough to rebuild the excursion structure, ~150 KB.
 *
 * Build:
 *     gcc -O3 -march=native twincount.c -o twincount -lprimesieve
 * Run:
 *     ./twincount 100000000000 10000000 twins_1e11.csv
 *
 * Resume: if the output file already exists and ends mid-run, pass the last
 * checkpoint as a 4th argument to skip ahead:
 *     ./twincount 100000000000 10000000 twins_1e11.csv 43000000000
 * (this re-sieves from 0 but only writes rows past the given x; primesieve is
 *  fast enough that this is usually simpler than true resumption)
 */
#include <primesieve.h>
#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <time.h>

int main(int argc, char** argv)
{
    uint64_t N       = (argc > 1) ? strtoull(argv[1], NULL, 10) : 100000000000ULL;
    uint64_t step    = (argc > 2) ? strtoull(argv[2], NULL, 10) : 10000000ULL;
    const char* path = (argc > 3) ? argv[3] : "twins.csv";
    uint64_t skip_to = (argc > 4) ? strtoull(argv[4], NULL, 10) : 0ULL;

    FILE* f = fopen(path, skip_to ? "a" : "w");
    if (!f) { perror("fopen"); return 1; }
    if (!skip_to) fprintf(f, "x,pi2\n");

    primesieve_iterator it;
    primesieve_init(&it);

    uint64_t prev = primesieve_next_prime(&it);   /* 2 */
    uint64_t cur;
    uint64_t twins = 0;
    uint64_t next_ckpt = step;

    clock_t t0 = clock();

    while ((cur = primesieve_next_prime(&it)) < N) {
        /* checkpoint on every boundary the new prime has passed */
        while (cur > next_ckpt && next_ckpt <= N) {
            if (next_ckpt > skip_to)
                fprintf(f, "%" PRIu64 ",%" PRIu64 "\n", next_ckpt, twins);
            next_ckpt += step;
        }
        /* a twin pair is counted at its LOWER member, so only count once the
           upper member is known to be <= the checkpoint boundary */
        if (cur - prev == 2) twins++;
        prev = cur;
    }
    while (next_ckpt <= N) {
        if (next_ckpt > skip_to)
            fprintf(f, "%" PRIu64 ",%" PRIu64 "\n", next_ckpt, twins);
        next_ckpt += step;
    }

    primesieve_free_iterator(&it);
    fclose(f);

    double secs = (double)(clock() - t0) / CLOCKS_PER_SEC;
    fprintf(stderr, "pi_2(%" PRIu64 ") = %" PRIu64 "   %.1f s\n", N, twins, secs);
    return 0;
}
