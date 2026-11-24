---
id: 0510
date: 2026-11-24
type: decision
title: "The ladder assembly of unit 0509 is weaker than unit 0467's attained case; the open arrangement is creeping alone"
refs: [lean_stage3/Stage3/FilterAttained.lean::attained_psi, lean_stage3/Stage3/LadderAssembly.lean::rh_of_ladder_tame, lean_stage3/Stage3/ResidueRoute.lean::isolated_boundary_mode_false, lean_stage3/Stage3/LadderMean.lean::mean_extract]
supersedes: []
follows: 0509
context: the ladder-route loop closed with `rh_of_ladder_tame`, and the reply listed a pile-up case as open without opening the files; Julian asked what is next and to check, 2026-11-24
sealed: false
---

**Question.** After units `unit_residue` 508 and `unit_assembly` 509, which arrangements of the zeros right of one half does the ladder route still leave open?

**What was read.** The statements in Lean, opened this session. `FilterAttained.attained_psi`, of unit `unit_attained` 467: H, and some zero whose real part bounds every real part, give `RiemannHypothesis`. It takes no isolation. `LadderMean.mean_extract`, of unit `unit_mean` 432, averages along the rows and picks out the weight of one folded class of the top line, with infinitely many modes on it.

**The finding.** `LadderAssembly.rh_of_ladder_tame` takes the hypotheses of `attained_psi` and isolation besides. It is weaker, and it adds nothing toward the Riemann hypothesis. The arrangement where other modes crowd onto an attained top mode was never open: `attained_psi` covers it. `ResidueRoute.isolated_boundary_mode_false` asks no top: it forbids any zero right of σ, near the top, whose mode is isolated and on the edge of the component of zero in the small disc. That is the piece of the loop that bites where `attained_psi` cannot.

**The decision.** The open arrangement on the ladder route is the one where the largest real part is never attained, the creeping case, which the headers of `AttainedPi` and `LadderMean` record as open. Inside it the residue route rules out an isolated mode on the edge. The next design is the creeping limit set whose every mode on that edge is a limit of other modes. H stays an input; nothing in the tree proves it.

**What it is not.** No run. It does not test the Riemann hypothesis. The cost: the loop's last step rebuilt a weaker statement because the attained files were not opened before the step was designed.
