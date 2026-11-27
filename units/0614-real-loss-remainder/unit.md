---
id: 0614
date: 2026-11-27
type: measurement
title: The remainder in the leader's real losses: which zeros make it, at which depths, and how unusual it is
refs: [lean/EdgeDiagonal.lean::edge_eq_fwdDiff]
supersedes: []
follows: 0613
sealed: false
---

**Question.** In about half the cells the corner's leader loses, its full swing is still below the rest (unit 0613, leader-phase). What is the rest in those cells?

**What ran.** `run/remainder.py`, by `run/run.sh`, through `lab run`, on unit 0597's corner of the true table, `remainder.cells` 2962 cells, first two thousand zeros, the comb's leader and runner-up (unit 0610, corner-zoom). A real loss is a cell where the leader's envelope is below the rest. The rest is split into the runner-up, the other zeros near a harmonic, the zeros far from one, and the tail past two thousand zeros; each part's median share of the rest is reported, so the shares need not sum to one.

**How many, and where.** `remainder.real_losses` 708 real losses and `remainder.phase_losses` 711 phase losses. The real losses gather where the comb's leader is about to change (unit 0611, leader-gap): `remainder.real_share_d36_66` 0.375 of the cells at depths thirty-six to sixty-six, against `remainder.real_share_d10_19` 0.082 at ten to nineteen, `remainder.real_share_d20_35` 0.182 at twenty to thirty-five and `remainder.real_share_d67_91` 0.092 past sixty-seven.

**What the rest is made of.** In the real losses the runner-up carries a median `remainder.rest_share_in_real.runner_up` 0.398 of the rest and the other near-harmonic zeros `remainder.rest_share_in_real.other_near` 0.595; the far zeros carry `remainder.rest_share_in_real.far` -0.0 and the tail past two thousand zeros `remainder.rest_share_in_real.tail` 0.025. Elsewhere the runner-up carries more, `remainder.rest_share_elsewhere.runner_up` 0.616, and the other near zeros `remainder.rest_share_elsewhere.other_near` 0.356. The runner-up's envelope is `remainder.runner_up_env_over_leader_env.real` 0.748 of the leader's in the real losses and `remainder.runner_up_env_over_leader_env.elsewhere` 0.616 elsewhere.

**How unusual the rest is.** Against the root of its squares (unit 0612) the rest is `remainder.rest_over_rms.real` 1.522 in the real losses and `remainder.rest_over_rms.elsewhere` 0.456 elsewhere, while the leader's envelope is `remainder.leader_env_over_rms.real` 1.183 and `remainder.leader_env_over_rms.elsewhere` 1.268 of it in both. The leader is the same size in both; the real losses are cells where the near-harmonic zeros line up and their sum runs to about one and a half times its usual size.

**What it shows.** The real losses are made by the comb's own family: the runner-up and the other zeros near a harmonic, lining up in phase, most often near a change of leader. The far zeros and the tail past two thousand zeros play no part. The corner is a contest among the harmonic zeros alone. Exploratory; no outcome marked.
