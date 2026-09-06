---
id: 0339
date: 2026-09-06
type: decision
title: "Pins: the four-line expectation record per task, the task analogue of #print axioms, with a misreads table"
refs: [lean_stage3/Stage3/WeilDetect.lean::box_empty_of_positive_of_detect]
supersedes: []
follows: 0338
sealed: false
---

**Question.** Julian asked two things. What are the Lean files pointing
at, and can the pin, the `#print axioms` line that certifies what a
theorem rests on, become a method beyond proofs: a silent record of what
the model takes as given and commits to deliver, so that when work looks
lazy the misalignment is read off the record instead of argued.

**What ran.** Nothing numerical. `run/` is empty. The ref is the theorem
every Lean file points at: detection plus positivity on one support
empties the box.

**What it shows.**

The investigation. Every module constrains one statement, `StmtDetect`:
an off-line zero in a box of height `T` forces the Weil form negative at
an explicit support `L(ε, T)`. With the arrow of unit 0316, a form
measured nonnegative at that support empties the box; the form at support
`L` is a finite sum over primes, which unit 0328 showed reproduces the
zero side. So the program investigates whether a finite computation over
the primes, read through the right window, certifies a rectangle of the
strip free of zeros, with the certificate a checked theorem plus a
measurement, and the rectangle growing with the support.

The pins. A task has the four parts a theorem has: what done looks like
(the statement), the ambiguities resolved the model's way (the
hypotheses), what it needs from Julian (the axioms), and what it left out
(the boundary). `PINS.md` at the repo root holds them, `pin_lines` 4
lines per task, written silently before the work. When the work looks
lazy the pins are read first; one of `outcomes` 3 things shows: a wrong
assumption, an unmet dependency, or a narrower done. Wrong pins go to a
misreads table there, seeded with `misreads` 2 rows from this session:
pricing a rung as a person's day, and the route of unit 0325.

**What was built.** `PINS.md`, with the current task's pins (rung 5 from
the worksheet's section 7) and the first archived entry (this file).
`lean_stage3/LOOP.md`, version `loop_ver` 5, section 0b: pin the task
before the work. The memory note points at the file.

**Decision.** Julian's. The pins carry no checker; there is nothing
mechanical to check in them yet. What they change is the order: the
boundary is written before it is crossed.

What remains. Rung 5 from section 7, under its pins.
