---
id: 0601
date: 2026-11-27
type: formalization
title: "Meissel-Lehmer proved in Lean: pi(x) from phi over the primes to the cube root and pi at x/p"
refs: [lean/MeisselLehmer.lean::rough_cube, lean/MeisselLehmer.lean::primeCounting_add_P2, lean/MeisselLehmer.lean::card_twoRough, lean/MeisselLehmer.lean::meissel_lehmer, lean/Legendre.lean::primeCounting_eq_phi, lean/Census21.lean::only_four_zeros_le21]
supersedes: []
follows: 0600
sealed: false
---

**Question.** Legendre's formula carried the verified π list to the twenty-first row, at a cost that grows fast. Can a formula whose sieve runs only to the cube root be proved in Lean?

**What ran.** `lean/MeisselLehmer.lean` and `lean/Census21.lean`, each built by `lake build` with exit 0 and pinned by `#guard_msgs` at `propext, Classical.choice, Quot.sound`. `run/ml.py`, by `run/run.sh`, through `lab run`, checks the identity at four rows and sizes its sieve against Legendre's.

**What is proved.** `rough_cube`: for `x < (s+1)³`, a number in `[1, x]` with no prime factor up to `s` is one, a prime above `s`, or a product of two primes above `s`. `primeCounting_add_P2` counts that split, and `card_twoRough` sorts the products by their smaller factor, which is their least prime factor (`minFac_mul_primes`). Together, `meissel_lehmer`: `π x + 1 + Σ_p (π(x/p) − π(p−1)) = φ(x, primes ≤ s) + π s`, the sum over the primes `p` above `s` with `p² ≤ x`. `Census21.only_four_zeros_le21` carries the census with no input through the twenty-first row.

**The sizes.** The identity holds at all four rows checked (`ml.r16.holds` true, `ml.r22.holds` true, `ml.r26.holds` true). At the twenty-second row the sieve's tree has `ml.r22.phi_nodes` 238951 nodes with `s` at `ml.r22.s` 161, against `ml.r22.legendre_nodes` 8724473 for Legendre; at the twentieth `ml.r20.phi_nodes` 52363 against `ml.r20.legendre_nodes` 1542733. The prime counts the sum needs reach only `ml.r22.max_x_over_p` 25731 at the twenty-second row and `ml.r26.max_x_over_p` 164080 at the twenty-sixth, inside the rows already proved.

**What is left.** The formula is not yet run in the kernel: it needs a proved table of π at the arguments `x/p`. Row twenty-two is being built by Legendre's route meanwhile.
