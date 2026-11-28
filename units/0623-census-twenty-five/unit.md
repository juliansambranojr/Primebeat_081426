---
id: 0623
date: 2026-11-27
type: formalization
title: The four zeros in rows 1 to 25, every depth, from the primes; the capstone on the pi input narrowed to rows 26 to 92
refs: [lean/PiRow24.lean::pi24, lean/PiRow25.lean::pi25, lean/Census24.lean::only_four_zeros_le24, lean/Census25.lean::only_four_zeros_le25, lean/Census25.lean::piData25_of_26, lean/Capstone.lean::only_four_zeros_outside_corner26]
supersedes: []
follows: 0618
sealed: false
---

**Question.** Can the census with nothing assumed reach the twenty-fifth row on the Mac, and the capstone take the named π input on rows twenty-six to ninety-two only?

**What ran.** `utilities/pirows/build_rows.sh`, which builds each module of a row with its own `lake build`, one at a time, three times on 2026-11-27; their outputs are `run/build_a.out`, `run/build_b.out` and `run/build_c.out`, copied in as produced, and `run/builds.py` reads them. Then `lean/Capstone.lean` with the new theorem, built by `lake build Capstone`, exit 0. `run/table.py` sieves to the twenty-fifth row and lists every zero of the table there; `run/pins.py` reads the axiom pins and runs the weld check. All three through `run/run.sh` and `lab run`.

**The builds.** Row twenty-four lists `builds.modules_listed.24` 552 modules, `builds.row24_term_modules` 550 of them term blocks; row twenty-five lists `builds.modules_listed.25` 889, `builds.row25_term_modules` 887 term blocks. The first run, `build_rows.sh 24 25`, built `builds.build_a.ok` 551 modules and stopped at `builds.build_a.failed[0][0]` "PiRow24" with code `builds.build_a.failed[0][1]` 124, the script's timeout of three thousand seconds; the script's note on that line that a failure means out of memory is fixed text it prints on every failure. The second run built `PiRow24` in `meta.builds.build_b.PiRow24_seconds` 1249 seconds and `Census24` in `meta.builds.build_b.Census24_seconds` 43, `builds.build_b.ok` 725 modules in all, and was stopped by Julian during row twenty-five when the Mac ran low; its output has no exit line. The third, `build_rows.sh 25` alone, exited `builds.build_c.exit` 0 after `meta.builds.build_c.seconds` 10481 seconds with `builds.build_c.ok` 890 modules "ok", `PiRow25` in `meta.builds.build_c.PiRow25_seconds` 23 seconds and `Census25` in `meta.builds.build_c.Census25_seconds` 7. No module of either row's list is missing from the "ok" lines of the `3` runs.

**What is proved.** `PiRow24.pi24`: the prime count at two to the twenty-fourth is `table.pi24` 1077871; `PiRow25.pi25`: at two to the twenty-fifth it is `table.pi25` 2063689; both by Legendre's formula, one term per file. `Census25.only_four_zeros_le25`: in rows one to twenty-five, at every depth, the only zeros are the four, with no named input; pin `pins.pins.only_four_zeros_le25.axioms` "propext, Classical.choice, Quot.sound". `Census25.piData25_of_26` gives the π input on rows twenty-five to ninety-two back from rows twenty-six to ninety-two. `Capstone.only_four_zeros_outside_corner26`: every zero of the true table outside the open corner is one of the four, from `Census25.StmtPiData26` and `WeakDepths.StmtRoute13`; pin `pins.pins.only_four_zeros_outside_corner26.axioms` "propext, Classical.choice, Quot.sound". `StmtRoute13` is what `RouteSharp.weakWindow13_of_RH` proves from RH, and unit 0622 (rh-axioms-seen) saw the Lean proof of RH built from source on this Mac with the same three axioms.

**The check outside Lean.** The sieve gives `table.pi24` 1077871 and `table.pi25` 2063689, the counts the theorems state, and the `table.cells` 300 cells below the diagonal hold `table.n_zeros` 4 zeros: (`table.zeros[0][0]` 2, `table.zeros[0][1]` 1), (`table.zeros[1][0]` 4, `table.zeros[1][1]` 1), (`table.zeros[2][0]` 8, `table.zeros[2][1]` 3), (`table.zeros[3][0]` 20, `table.zeros[3][1]` 6). The weld check passed with `pins.welds_ok` 20 welds and `pins.welds_broken` 0 broken.

**What is left.** The capstone's π input is the list on rows twenty-six to ninety-two. The terms per row grow. Unit 0621 (`rh-route-below-93`) found that the RH route, even with its floor moved down, reaches no cell below row fifty and only shallow cells above it.
