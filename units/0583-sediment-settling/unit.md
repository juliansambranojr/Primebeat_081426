---
id: 0583
date: 2026-11-26
type: run
title: "The sediment settles in its own band: the completed truncation to the first N integers has no zero off the line where N is the number of terms that belongs, for N up to five"
refs: [lean_stage3/Stage3/TuringRun.lean::rh_up_to]
supersedes: []
follows: 0582
context: Julian, the basins settle as the sediment of primes and composites arrives; measured as the zeros of the completed sum over the first N integers, with the sediment counted by N
sealed: false
---

**Question.** Built from the first N integers alone, with zeta's reflection, where does the function have zeros off the line, and does adding sediment settle them?

**What ran.** `run/sediment.py` and `run/bands.py`, by `run/run.sh`, through `lab run`. The function is the completed sum over the first N integers plus its mirror at one minus s, with zeta's reflection exactly. Zeros right of the line are counted by winding, strip by strip of height five up to `results.t1` 200.0, for N from one to twelve. EXPLORATORY: no prereg, no verdict.

**What it gave, read by height alone.** More sediment brings more zeros off the line, low down: none for N one, `results.N2_right_total` 1 for N two, `results.N12_right_total` 19 for N twelve. Every strip's winding is within `results.N7_max_dev_from_integer` 3.3306690738754696e-15 of an integer.

**What it gave, read by band.** Chosen after seeing the data: the band where N terms are the number that belongs at a height, from twice pi N squared to twice pi N plus one squared, the Riemann-Siegel length. In its own band, N two has `bands.N2_in_band` 0 zeros off the line against `bands.N2_below_band` 1 below; N three `bands.N3_in_band` 0 against `bands.N3_below_band` 4 below and `bands.N3_above_band` 2 above; N four `bands.N4_in_band` 0 against `bands.N4_below_band` 7; N five `bands.N5_in_band` 0 against `bands.N5_below_band` 9. Every zero off the line sits where the sediment is out of its band, mostly where more of it has been put down than that height has received.

**What it says, for the picture.** The layers settle their own basins: a zero is off the line only where a layer is placed outside its own time. The bands of N six to twelve, heights from about two hundred and twenty-six to about a thousand and sixty-two, were never computed; they are the out-of-sample test, to be preregistered. That this family of truncations has been studied in the literature is from memory and not checked.

What remains. The preregistered run on the unmeasured bands.
