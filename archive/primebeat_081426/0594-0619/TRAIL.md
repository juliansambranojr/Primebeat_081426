# Decision trail, units 0594–0619

Range closed at tag `archive/primebeat_081426/0594-0619` (commit 13f04b5, the merge of PR #25). Branch it was written on:
`claude/serene-knuth-jcsdkx`, cloud session `session_01QgKxrKkcM2vFjFqGZMWrfY`, 2026-11-26 to 2026-11-27.

**How to use this file.** It gives the route: which question each unit answered, what was tried, what was
decided, and which question that opened. It holds no results of its own. Every fact an answer needs is taken from
the unit named, read at the tag (`git show archive/primebeat_081426/0594-0619:units/<id>/unit.md`); every number in a unit sits
beside its `values.tsv` key. An instance started from this file answers by filling in from the units.

**The goal the range served.** Julian's loop: one theorem in his tree saying every cell of the true dyadic prime
table (`ToInfinity.trueRow`), every depth, every row, is zero only at (2,1), (4,1), (8,3), (20,6) — no sorry, no
added axiom, no `native_decide`, axioms exactly propext, Classical.choice, Quot.sound.

## The route

1. **0594 floor-lost-factor.** Question: why the old gate stalled with depth. Found: the main-term floor's
   derivative bound loses (1/log 2)^d. Decided: replace it with the exact difference (`ExactFloor`…`ExactRH`).
   Opened: how far the exact floor carries the census.
2. **0595 census-twenty.** Rows 1–20, every depth, with no input, the π list proved by sieves in the kernel.
   Opened: what happens past the band the error bounds reach — the deep corner.
3. **0596 edge-diagonal.** Read the corner along its edge: each zeta zero enters a cell as (2^ρ − 1)^d, the main
   term as 1. Decided: the corner is a sum over the zeros. Opened: does that sum rebuild it.
4. **0597 corner-from-zeros.** Yes: 2000 zeros give the sign of almost every corner cell. Opened: could an offline
   zero hide or be amplified by depth.
5. **0598 offline-gain.** Depth never amplifies an offline zero beyond what the row carries (`OfflineGain`).
6. **0599 offline-threshold.** Where an offline zero would show; a size heuristic leaves about 1e-17 room for
   further zeros past row 92. Decided: heuristics are not proofs; look for exact structure.
7. **0600 prime-power-cells.** At a prime-power depth a cell is two rows mod p (`ParityCell`); keeps most such
   cells off zero where the rows are known. Opened: computing more rows.
8. **0601 meissel-lehmer.** Meissel–Lehmer proved in Lean, a cheaper counting route than Legendre. Not yet run in
   the kernel.
9. **0603 census-twenty-two.** Rows 1–22 from the primes (Legendre, blocks of eight terms to fit the kernel).
   Then Julian corrected the session: RH is proved in Lean (`leanprover-community/riemann-hypothesis`); stop
   treating RH as out of reach. Decided: use it.
10. **0604 rh-route-depths.** The RH route (stage 3) welded to the Lean RH proof by statement
    (`utilities/check_weld.py`). Depths 1–12 every row; depth 12 needed the zero count's constant cut from 112 to
    15 (second-order digamma, `Stirling2`, `RvMSharp`). Opened: depth 13 needs a smaller constant still.
11. **0605 per-row-route.** Decided: charge each row its own error, not the window bottom's (`WeakDepths`).
    Depths 13–14 at constant 127; then two lost factors found — the ψ-to-π transfer's factor three, the floor
    integral's log 2 — and depth 15 at constant 40.
12. **0602 route-constant-factors (decision).** The rule "a lost factor is a design failure" applied: the floor
    constant split into its pieces. Found: the constant a depth needs falls about 3.5× per depth, so error bounds
    close the middle band only to about depth 20 at row 93, at any constant. Decided: the corner needs another
    argument.
13. **0606 depth-line.** Two-floor transfer (constant 13): depth 16 every row, and every depth past r = 4d + 30.
14. **0607 open-corner-count.** Steeper line r = 3.7d + 39 for d ≥ 30; past row 92 about four cells in five stay
    open. The deep corner is most of the table.
15. **0608 novelty-check.** Julian asked what is new. The table and its facts, and Meissel–Lehmer in Lean; the
    explicit-formula route and zero counts were done before.
16. **0609 corner-harmonics.** Julian's posit: the beat starts from the first primes, the corner is its
    harmonics. Measured: the zeros near the odd harmonics of π/log 2 alone rebuild the corner. Posit holds as a
    family; no single zero leads.
17. **0610 corner-zoom.** Julian: the corner is a larger spread of primes, self-similar. Measured: one comb raised
    to the depth — narrows at the predicted rate, leaders a record sequence, base 3 its own comb.
18. **0611 leader-gap.** The leader against the runner-up and against the rest: small against the rest by size,
    and the sum of sizes diverges. Decided: a size argument is a design limit.
19. **0612 rest-cancellation.** The rest cancels like independent phases; its root-square size is bounded; the
    leader is of the same size.
20. **0613 leader-phase.** Half the leader's losses are its own phase near zero.
21. **0614 real-loss-remainder.** The other half: the near-harmonic family lining up; far zeros play no part.
22. **0615 harmonic-alignment.** The near-harmonic zeros beat at the differences of their offsets, as predicted:
    a corner cell is an almost-periodic function of the row — Julian's beat one level up.
23. **0616 kronecker-reach (decision).** Kronecker–Weyl / Rubinstein–Sarnak: rarity of corner zeros under RH +
    LI, never their absence. Julian: beyond current methods is not impossible.
24. **0617 exact-certificates.** Lucas congruences and the weighted prime count settle a cell when the rows are
    known mod p; no link to the beat. The exact route runs through π(2^m) mod small primes.
25. **0618 census-twenty-three.** Rows 1–23 from the primes; π input narrowed to rows 24–92. Records a correction
    to commit a3b787c's message.
26. **0619 capstone.** One statement: every zero outside `Capstone.OpenCorner` is one of the four, given the π
    list on rows 24–92 and the RH route.

## Where the range left things

- Proved: unit 0619's statement, with its two inputs (π list rows 24–92; `WeakDepths.StmtRoute13` from RH).
- Open: the π list rows 24–92 (rows 24–25 generated, built on the Mac after the range closed); the deep corner
  (`OpenCorner`), structured as in 0609–0617.
- Held at Julian's word: `Stage3/TuringRun600*.lean` (commit f347b0e).
- The prose answers to the teleport questions: `notes/2026-11-27-handoff-teleport-questions.md`.
