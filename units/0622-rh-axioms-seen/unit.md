---
id: 0622
date: 2026-11-27
type: run
title: The Lean proof of RH, its axioms seen on the Mac, from the prebuilt cache and from source
refs: [none]
supersedes: []
follows: 0621
sealed: false
---

**Question.** What axioms does the Lean proof of the Riemann hypothesis in `leanprover-community/riemann-hypothesis` depend on, seen on this Mac, and is its `RiemannHypothesis` the statement this repo's weld names?

**What ran.** First, on 2026-11-27, in a clone at `~/GitHub/riemann-hypothesis`: `lake exe cache get`, `lake build`, then `lake env lean scripts/PrintAxioms.lean`. Its log is `run/cache_build.log`, copied in as produced. Then `run/rhaxioms.py`, by `run/run.sh`, through `lab run` (exit 0, `meta.lab_run.001.meta.wall_s` 32.444 seconds). It reads the clone's commit, toolchain and Mathlib pin, runs `scripts/PrintAxioms.lean` again, compares Mathlib's `RiemannHypothesis` there with the weld's stored copy, and runs `utilities/check_weld.py`.

**The clone.** Commit `rhaxioms.commit` 7c4ccbd64d02774b0a5b40a5f923f5b7a18e8abc, the commit the cloud session read (`notes/2026-11-27-handoff-teleport-questions.md`, answer `1`). Toolchain `leanprover/lean4:v4.37.0-rc1`. Mathlib at `rhaxioms.mathlib_rev` 31ce06eaadf4a200c0e1407c5f10953cf606b8f8. The theorem, `src/Main.lean`: `theorem riemannHypothesis : RiemannHypothesis := New.zeta_zeros_on_line New.grh`. The source is `rhaxioms.src_lean_files` 802 Lean files.

**The axioms.** `scripts/PrintAxioms.lean` printed `rhaxioms.theorems_printed` 5 theorems, exit `rhaxioms.axioms_exit` 0. All `rhaxioms.theorems_standard_only` 5 depend on exactly `propext`, `Classical.choice` and `Quot.sound`: `riemannHypothesis` with `rhaxioms.axioms.riemannHypothesis.count` 3 axioms, and the four companions on ζ and Dirichlet L-functions. No `sorryAx` appears.

**The weld.** Mathlib's `RiemannHypothesis` in the clone is line for line the copy at `utilities/weld_sources/RiemannHypothesis_mathlib_31ce06e.lean`. `check_weld.py` exits `rhaxioms.weld_exit` 0 with `rhaxioms.welds_broken` 0 broken welds. So the `hRH : RiemannHypothesis` that `RouteSharp.weakWindow13_of_RH` assumes is the statement this theorem proves.

**What this run did not check.** The project's `rhaxioms.project_oleans` 803 compiled files came from the repository's prebuilt cache: `rhaxioms.cache.downloaded` 802 of `rhaxioms.cache.of` 802 downloaded, `meta.rhaxioms.cache.failed_sha256` 0 failing their `SHA-256` check. The `rhaxioms.cache_log_built_lines` 41 "Built" lines in the log all belong to the cache tool and one library file it needs; the build step compiled no module of the proof. Printing axioms reads those files, so that first run did not have the kernel re-check the proof on this Mac. The repository's own `CACHE.md` says the cache verifies nothing and that checking the proof means building it from source.

**The source build.** So the proof was built again in a second, fresh clone, `~/GitHub/riemann-hypothesis-src`, at the same commit `rhaxioms.source_build.commit` 7c4ccbd64d02774b0a5b40a5f923f5b7a18e8abc, fetching only Mathlib's official cache (`lake exe mathlib/cache get`) and nothing of the project's or Tau Ceti's. Its log is `run/source_build.log`, read by the second `lab run` (`meta.lab_run.002.meta.wall_s` 35.045 seconds). `lake build` exited `rhaxioms.source_build.build_exit` 0 after `meta.rhaxioms.source_build.build_seconds` 706 seconds, with row `25` of the π list building alongside it. It built `rhaxioms.source_build.built` 2535 modules and replayed `rhaxioms.source_build.replayed` 0, restored `rhaxioms.source_build.restored` 0, fetched `rhaxioms.source_build.fetched` 0 and downloaded `rhaxioms.source_build.downloaded` 0. Of the built modules, `rhaxioms.source_build.built_project_modules` 802 are the proof's own (`rhaxioms.source_build.built_by_prefix.Lib` 495 under `Lib`, `rhaxioms.source_build.built_by_prefix.New` 305 under `New`, plus `Statements` and `Main`), every one of its Lean files, and `rhaxioms.source_build.built_by_prefix.TauCeti` 1695 are the Tau Ceti library it imports. Each module built is elaborated by Lean and its declarations checked by the kernel as they are added. `scripts/PrintAxioms.lean` then printed `rhaxioms.source_build.theorems_printed` 5 theorems, exit `rhaxioms.source_build.axioms_exit` 0, all `rhaxioms.source_build.theorems_standard_only` 5 on exactly `propext`, `Classical.choice` and `Quot.sound`, with no `sorryAx`.

**What stays unchecked here.** Mathlib itself came from its official cache and was not rebuilt. No second, independent kernel (such as lean4lean) was run: on the readable edition it is stated to need far more memory than this Mac has.
