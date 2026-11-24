---
id: 0498
date: 2026-11-23
type: formalization
title: "The Holy Family's channel: a zero meets its mirror exactly at the pair's midpoint"
refs: [lean_stage3/Stage3/HolyChannel.lean::holy_pair_shares, lean_stage3/Stage3/HolyChannel.lean::member_is_two, lean_stage3/Stage3/HolyChannel.lean::meet_iff_channel, lean_stage3/Stage3/HolyChannel.lean::channel_iff_self_mirror, lean_stage3/Stage3/HolyChannel.lean::spiralLink_iff_channel]
supersedes: []
follows: 0497
context: Julian read the open link through the Holy Family of `lean_primebeat`: the uneven pair one third and two thirds is the residual every prime carries, and the zero is the mirror that lets it pass; this is block J9 of `lean_stage3/design/closedloop.md`
sealed: false
---

**Question.** Block J9 of `lean_stage3/design/closedloop.md`. Where does a zero sit against the Holy Family's pair, and what does the spiral link read as there?

**What was proved.** `lean_stage3/Stage3/HolyChannel.lean`: `module_lines` 101 lines, `theorems_proved` 6 theorems, `defs` 2 definitions, `sorries` 0 sorries, `pins` 5 axiom pins. The first build had `errors_first` 1 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8882 jobs, the module at `jobs_module` 8842. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`holy_pair_shares`: a zero whose share is the support has its mirror at the condition. The Holy Family has the shape of a pair split unevenly.

`member_is_two`: a zero at the share of either member is a different point from its mirror, and its mode and its mirror's are different sizes at every total above one.

`meet_iff_channel`: a zero's mode meets its mirror's exactly when its share is the Holy Family's midpoint. `channel_iff_self_mirror`: exactly when the zero is its own mirror. Two facing mirrors cannot tell A from B exactly when they are one mirror.

`spiralLink_iff_channel`: the spiral link holds exactly when every zero is the channel.

**Who wrote it.** Written and built here. The file was searched for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

**What it joins.** The Holy Family of unit `unit_family` 478 feeds the share link and the open link by name.

What remains. The channel itself has no proof: a reason in the table that no zero takes an uneven share.
