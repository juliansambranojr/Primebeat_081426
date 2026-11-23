---
id: 0457
date: 2026-11-23
type: decision
title: "The explicit formula's left edge loses a factor that grows with the height: the cap at the square is a single bound on a single line"
refs: [lean_stage3/Stage3/GlueNum.lean::explicit_formula_split_num, lean_stage3/Stage3/GlueNum.lean::edge_left_sharp_num, lean_stage3/Stage3/CellRows.lean::cell_tail_tendsto]
supersedes: []
follows: 0456
context: unit 0441 took the height of the zero sum to infinity along the rows and left the fixed row open because the tree's explicit formula caps the height at the square of the doubling; the proof of that formula was read for where the cap is used, 2026-11-23
sealed: false
---

**Question.** Where does the tree's explicit formula use its cap on the height, and what does the cap pay for?

**What ran.** `run/record.json` holds the counts written here. `Glue.explicit_formula_split_num` was copied to a scratch module with the cap deleted and built; the scratch file was removed after. EXPLORATORY: no prereg, no verdict.

**Where.** The scratch build failed at `record.uses_of_cap` 1 step and nowhere else: the hypothesis that the good height is at most twice the square, handed to `Glue.edge_left_sharp_num`. That theorem uses it to write the logarithm of the height as at most a constant times the logarithm of the doubling. The other `record.pieces_without_cap` 4 pieces of the proof carry no cap: Perron's formula, the residue identity, the bound on the horizontal edges, and the swap between a height and the good height beside it.

**The factor.** The left edge of the contour is the integral of the logarithmic derivative of zeta times the power of the doubling over the variable, up the line a quarter to the left of zero. The tree bounds it in absolute value. The logarithmic derivative is at most a constant times the logarithm of the height there, and the integral of the reciprocal of the variable adds another logarithm. The bound is the square of the logarithm of the height over the fourth root of the doubling. It grows with the height. The integral itself stays bounded, because the power of the doubling turns along the line and the absolute value throws the turning away.

**What it is.** A design failure in how the left edge is bounded. The proofs in `Stage3/GlueNum.lean` are correct and stay. The cap at the square is what keeps the lost factor at the size of the logarithm of the doubling.

**The repair.** `lean_stage3/design/leftedge.md`, `record.blocks` 3 blocks. Block F1 keeps the left edge as a term, so the formula holds at every height, and states the absolute bound with its growing factor. Block F2 bounds the edge free of the height: by the functional equation the logarithmic derivative on that line is a Dirichlet series in the von Mangoldt function plus a smooth part from the gamma factor, and each is integrated by parts against the turning power. Block F3 is the cell at a fixed row, the part unit `record.unit_t3a` 0441 left open.

**Decision.** Block F1 is built first. Block F2 follows it.
