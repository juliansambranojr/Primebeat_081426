---
id: 0578
date: 2026-11-26
type: run
title: "The basins settle under the de Bruijn-Newman flow: forward the spacing evens out, backward the closest pairs collide, the closest last"
refs: [lean_stage3/Stage3/TuringRun.lean::rh_up_to]
supersedes: []
follows: 0577
context: block H1 of `lean_stage3/design/heatflow.md`, the measurement of the zeros as they move under the flow, up to the point run's height
sealed: false
---

**Question.** Under the de Bruijn-Newman flow, how do the real zeros below the point run's height move as the time lambda goes forward and back from zero?

**What ran.** `run/heatflow.py` and `run/collisions.py`, by `run/run.sh`, through `lab run`. The function is the heat-flow deformation of Xi, computed on a contour moved off the real axis so that double precision holds, on the trapezoid rule. Its real zeros are found up to `results.x1` 877.252, twice the point run's height, for twenty-one times lambda from minus a fifth to a fifth. `run/collisions.py` then finds, by bisection in lambda, the time at which each of the five closest pairs at time zero collides. The first run had no collision script; its record is `run/lab_run.001.json`. EXPLORATORY: no prereg, no verdict.

**Check.** At time zero the script finds `results.validate_count_lam0` 228 zeros, the count of zeta's zeros below the point run's height, each at twice the zeta zero to within `results.validate_max_abs_err_lam0` 1.1868905858136714e-10.

**Forward, the basins settle.** Every zero stays real up to time a fifth. The spread of the gaps over the local mean falls from `results.lam_+0.00_spacing_sd` 0.36633266809406095 at time zero to `results.lam_+0.20_spacing_sd` 0.31278604417272965 at a fifth, and the smallest gap grows from `results.lam_+0.00_min_gap` 0.8728104823311469 to `results.lam_+0.20_min_gap` 1.457706263078876.

**Backward, the closest pairs come unsettled.** At minus a fifth the spread is `results.lam_-0.20_spacing_sd` 0.5009425753263954. The five closest pairs at time zero collide, and leave the real axis, at times in the order of their gaps:
- gap `collisions.pair0.gap0` 0.8728104823311469 at height `collisions.pair0.t` 415.23701237573357: time `collisions.pair0.lam_collide` -0.099072265625;
- gap `collisions.pair1.gap0` 0.9963589278668223 at height `collisions.pair1.t` 376.0750024987024: time `collisions.pair1.lam_collide` -0.13100585937499998;
- gap `collisions.pair2.gap0` 1.131952616746048 at height `collisions.pair2.t` 333.92836667905704: time `collisions.pair2.lam_collide` -0.169482421875;
- gap `collisions.pair3.gap0` 1.2157705193849324 at height `collisions.pair3.t` 295.2693122491118: time `collisions.pair3.lam_collide` -0.20151367187500002;
- gap `collisions.pair4.gap0` 1.4315734307587604 at height `collisions.pair4.t` 221.0728121970036: time `collisions.pair4.lam_collide` -0.282080078125.

The closer a pair sits today, the later it settled. The latest settling below this height is the closest pair's. One other drop in the count of real zeros, at minus a twenty-fifth, is the top zero crossing the window's edge.

**For the picture.** The constant Lambda is the latest collision over all heights. Below this height it sits near the first pair's time. The Riemann hypothesis is that no collision falls after time zero.

What remains. The repulsion law checked against the zeros' velocities, and the collision times on higher stretches, where closer pairs push them toward zero.
