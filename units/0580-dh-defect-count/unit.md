---
id: 0580
date: 2026-11-26
type: run
title: "The defect count on Davenport-Heilbronn: the verifier rejects at each off-line pair, by two each time; on zeta it stays at zero"
refs: [lean_stage3/Stage3/Defect.lean::rh_iff_defect_zero]
supersedes: []
follows: 0579
context: Julian asked to run the Turing defect count on Davenport-Heilbronn, which has the same functional equation as an L-function and no Euler product, and see the verifier reject it
sealed: false
---

**Question.** Does the defect count, all zeros up to a height minus the sign changes on the line, catch the off-line zeros of the Davenport-Heilbronn function, and stay at zero for zeta?

**What ran.** `run/dhdefect.py`, by `run/run.sh`, through `lab run`. The function and its Hardy-type Z are those of `O80_dh_zeros.py` at the repo root. All zeros are counted by the winding of the completed function around strips of height five, from real part minus three fifths to eight fifths, summed; the zeros on the line by the sign changes of Z on a grid of a hundredth. Zeta is the control. EXPLORATORY: no prereg, no verdict.

**The first run failed.** Its record is `run/lab_run.001.json`. Its winding started each edge with forty points, about three apart at the top, and lost whole turns: above a hundred the count of all zeros fell, which a cumulative count cannot do. The second run starts each edge at spacing a twentieth and counts strip by strip.

**What it shows.** Zeta's defect is zero at every height: at the top `results.zeta_T130_defect` 0, with `results.zeta_T130_all` 43 zeros and `results.zeta_T130_line` 43 on the line. The Davenport-Heilbronn defect is `results.dh_T85_defect` 0 up to eighty-five, `results.dh_T90_defect` 2 from ninety, still `results.dh_T110_defect` 2 at a hundred and ten, and `results.dh_T115_defect` 4 from a hundred and fifteen; at the top `results.dh_T130_all` 75 zeros against `results.dh_T130_line` 71 on the line, a defect of `results.dh_T130_defect` 4. The two jumps sit at the two off-line zeros of `O80_dh_zeros.py`, near heights eighty-six and a hundred and fourteen, each with its mirror across the line.

**What it says.** The verifier rejects Davenport-Heilbronn exactly where its zeros leave the line, and accepts zeta on the same range. The functional equation alone does not pass the count.

What remains. The coupling measurement that separates the two functions, written as a prereg.
