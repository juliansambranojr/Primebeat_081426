---
id: 0330
date: 2026-09-06
type: formalization
title: "WeilOddPower.lean: the odd envelope sin(pi x) P^m as an exact derivative, its transform through K, and the switched window's transform"
refs: [lean_stage3/Stage3/WeilOddPower.lean::S_eq, lean_stage3/Stage3/WeilOddPower.lean::S_mul_QS, lean_stage3/Stage3/WeilOddPower.lean::what_eq]
supersedes: []
follows: 0329
sealed: false
---

**Question.** Rung `rung` 5, third slice. Unit 0329 gave the even
envelope's transform `K`. The window's envelope has to be odd, since
oddness is what makes every term of the zero form minus a square (unit
0326). Entry 302's odd factor was `x`, whose transform is the derivative
of `K` in `w`, and the bounds on that derivative are ugly in the regime
where `m` is of the order of the support. Is there an odd factor whose
transform needs no derivative?

**What ran.** `lean_stage3/Stage3/WeilOddPower.lean`, new, `module_lines`
244 lines, imported from `Stage3.lean`. `errors_first` 5 errors on the
first build, all local: a double-angle rewrite that hit both sides, a cast
lemma that wanted no `mod_cast`, a `field_simp` that closed its goal, a
factorial rewrite that hit the wrong factorial, and the continuity
attribute for the new envelope. Full package built, `jobs_package` 8748
jobs. `run/build.log` is the record.

**What it shows.** `theorems_proved` 11 theorems and `defs` 6 definitions
(`q`, `S`, `QS`, `cS`, `W`, `what`), the pinned theorems by `#guard_msgs`
to `axioms` 3 axioms, `sorries` 0 sorries.

The odd factor. Take `sin(πx)` in place of `x`. Then the odd envelope
`q m x = sin(πx)·P(x)^m` equals `sin_coeff` 2 times `sin(πx/2)` times the
half-angle cosine to the power `2m+1`, and that is an exact derivative:
`q m` is a constant times the derivative of the half-angle cosine to the
power `2m+2`, the constant being minus 2 over `(m+1)π` (`q_eq`).

The transform. One integration by parts, with the boundary term zero
because the power vanishes at the ends, gives `S_eq`: the odd transform
`S m w` equals `2w` times `K (m+1) w` over `(m+1)π`. No derivative
anywhere. With unit 0329's product identity, `S_mul_QS`: `S m w` times
the product over `j` from 1 to `m+1` of `w² + π²j²` equals
`2·π^{2m+1}·(2m+1)!/4^m` times `sinh w`. Multiplied out, at every `w`.
`S_zero_mul`: at `m` equal `m_check` 0 this is the elementary integral of
`sin(πx)e^{wx}`, `2π·sinh w` over `w² + π²`.

The window. `W h γ m u` is `q m (u/h)` times `cos(γu)` on `[−h, h]`, and
`what_eq` gives its transform as `h/2` times the sum of `S m` at
`(z + iγ)h` and at `(z − iγ)h`, by unit 0318's change of variables and
the same splitting of the carrier into two exponentials.

What this closes. The switched window is defined and its transform is in
closed form at every point of the plane: `sinh` over a polynomial of
degree `2m + 2` in `w` whose zeros all lie on the imaginary axis at
`±iπj`. The odd factor `x` of entry 302 is retired for the new window; on
the line the new transform is still purely imaginary, since `sinh` of an
imaginary argument is, and the product is real there.

What the next slice needs from it. Bounds on `S m w` read off the
polynomial: an upper bound through `cosh(Re w)` over the product, and a
lower bound at real `w`, in the regime where the product behaves like a
Gaussian.
