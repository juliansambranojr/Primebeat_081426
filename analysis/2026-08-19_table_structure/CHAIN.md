# The chain, from the whip to the sub-integer zeros

2026-08-19. A record of how the current state was reached, in order, with
the pushbacks in both directions.

Written to the shape Julian asked for at 19:26: *"a brief logic chain of
how we got to this point from the correlation of bases and the whip
analogy I had. That way we have a new starting point as a regression
check on the current work. It can just be observation, test reframe, new
observation, new observation and any analogies or pushbacks you and I
had."*

Rewritten 2026-08-20 from the session transcript rather than from memory,
after a compaction. Every number below is quoted from the run that
produced it; every script and page is named where it enters. Claims
marked **standing** are what a later run should reproduce, and the ones
marked **killed** should stay killed.

Nothing here is preregistered. No verdict is claimed anywhere.

---

## 0 · Before the chain — the animation, and the two errors it produced

Not part of the logic chain proper, but both of the session's method
errors were born here and both are load-bearing later.

**The build.** `pages/orbits.html` — the difference table as an
animation, each cell placed by log-magnitude and winding phase, built
depth by depth. It went through four rounds of Julian's corrections:
both bases and both arms on by default rather than mutually exclusive;
royal blue / sky blue for dyadic prime / composite against green / sage
for triadic; a `together` / `in turn` playback mode so dyadic completes
before triadic lands on top of it; and sign made into geometry rather
than opacity, so a negative cell sits half a turn opposite instead of
being dimmed.

**Pushback (Julian).** *"Oh, no I wanted to see the real points not a
smoother version."*

**Conceded, with a correction to the correction.** Nothing was smoothed —
the values are exact integers differenced with BigInt. But the objection
landed on something real that wasn't the log: the **sign** was being
thrown away, and the alternation is the actual oscillation. Sign became
position.

**Error one — the single angle.** I then built a `measured phase` view
that solved a rotation out of each cell's four neighbours by fitting
`v(r+2) = a·v(r+1) + b·v(r)` and taking the argument of the characteristic
root. The estimator was validated first: a damped rotating sequence
planted at **2.76893** came back at **2.76893**. The result looked
tighter than the imposed view and I reported that.

**Pushback (Julian).** *"It looks pretty similar to the previous one but
just tighter and a few things I remember about our other tests… there was
no set angle I believe when we tested it. Because there isn't one angles
it's all small ones already in each cell but the relationships create the
curve… no?"*

**Killed, and it was a real flaw rather than a nuance.** A cell is a sum
over every zeta zero, each turning at its own `γ log b`. A second-order
recurrence forced onto that returns whichever mode dominates the window,
and it returns *something* whenever the discriminant goes negative. A
single-mode fit always produces structure, because structure is what it
is built to output — so "tighter" was the estimator, not the cells. The
right instrument is a spectrum, not an angle.

That redirect produced `scripts/spectra.py`. It is also the first
instance of the failure Julian named twice more before the day was out:
collapsing a relational claim into a scalar.

**Error two — the benchmark.** Every zero aliases in base 2, since a row
samples once per rung and cannot carry more than π radians per step:

```text
base 2 — where the first eight zeros land, folded
  gamma_1  14.1347  ->  2.7689      gamma_5  32.9351  ->  2.3039
  gamma_2  21.0220  ->  2.0050      gamma_6  37.5862  ->  0.9200
  gamma_3  25.0109  ->  1.5134      gamma_7  40.9187  ->  3.0532
  gamma_4  30.4249  ->  2.2394      gamma_8  43.3271  ->  1.3839
```

To judge whether spectral peaks sat near those lines I needed a chance
level, and computed it as `mean_gap / 4` — **0.0762**. The first run of
`spectra.py` returned:

```text
panel                       real   shifted    chance  peaks
base 2 prime             0.0859    0.0505    0.0762     15
base 2 composite         0.0759    0.0591    0.0762     13
base 3 prime             0.2077    0.1066    0.0711      6
```

and I read it as a clean negative: *"The peaks do not track the zeta
zeros. In base 2 prime the real lines score worse than chance."*

**Pushback (Julian).** *"Ok hear me out if it's structure then it's there,
if we see it then it s there, the gag is that nulls is a different
structure but made up of the same structure we are looking at — so is the
negative more about the structure that holds across nulls cause they are
for renegade by the same dynamics if the number line"*

**Both halves of that were right, and one of them was mine to find.** The
null was the same eight γ's rigidly shifted, so it inherited their
spacing exactly — if the table responds to zeta-*like* spacing rather
than to those frequencies, both sets score alike and I would read it as
no signal. And `mean_gap/4` is only correct for evenly spaced lines: it
takes the mean of the gaps and then the quarter when the correct order is
the reverse. A point lands in a gap of width `w` with probability
proportional to `w` and averages `w/4` from a line, so the exact value is
`Σw²/(4Σw)`, with the two interval ends one-sided at `w/2`.

```text
chance, formula vs exact, for the real base-2 line set:
  mean-gap/4  0.0762
  exact       0.2020
```

**Low by 2.65×, and it inverted the reading.** Uniformly random lines
score 0.19 — right at chance. Both γ-derived sets score 0.05–0.09, two to
four times closer.

**Then the decisive null, and it lands on cannot-tell.** Eight arbitrary
values across the γ range pushed through the same fold:

```text
panel                real   shiftG   foldRND   uniform   chance      p     n
base 2 prime       0.0859   0.0505    0.1777    0.1967   0.2020   0.377   15
base 2 composite   0.0759   0.0591    0.1791    0.1912   0.2020   0.350   13
base 3 prime       0.2077   0.1066    0.1936    0.1866   0.2200   0.659    6
```

Folding is **not** the explanation — arbitrary values through the same
fold score 0.178, within noise of uniform lines. But **p = 0.377**, and
`shiftG` at 0.0505 fits *better* than the real zeros at 0.0859.

**Three readings of one dataset in fifteen minutes — negative, positive,
cannot-tell — and each flip was my benchmark moving, not the data.** That
is the finding about the instrument, and it is why the four tests below
were specified the way they were.

Scripts `scripts/spectra.py`, `scripts/t1_permute.py`; figure
`figures/spectra.png`; page `pages/orbits.html`.

---

## 1 · The four tests, specified

**Julian, 16:54, verbatim and in full:**

> No, look what happened "there isn't enough resolution here for the
> answer to be stable, and a test whose verdict moves when you fix its
> null was never going to settle anything."
>
> Your benchmarks can't measure it at any resolution cause it's the same
> thing because your putting just as many integers in your benchmarks
> which creates the same relational structure that makes it visible so it
> always going to flip based on the random numbers because the number
> have weight. So the results of a verdict is about the numbers in the
> nulls. The same problem just scales at resolution
>
> Do this instead. Take all the numbers in the table randomize their cell
> placement. That will show if that the placement matters which we know
> is deterministic. By we can do it anyway and measure the z score
>
> Then do another test where the sub integer base and the dyadic triadic
> bases and see how similar their crossover is
>
> Then do another test plotting the dyadic to enneadic and see how they
> line up against each other
>
> That's three different tests showing the structure transforming
>
> Then take the residuals of a zero and plot the residuals and then
> overlay them with the dyadic and triadic table and we can see where
> they are in relation to them as point in space

**Conceded.** I had been randomising the *reference*, not the *data*.
Eight random lines against fifteen peaks land well by luck a third of the
time however fine the grid — that is a property of counting, not of
resolution. The right null keeps the lines fixed and destroys the
arrangement.

The four became tests 01–04, and everything after section 6 descends
from reading their output.

---

## 2 · Test 01 — the arrangement null, and the control that killed it

**The test.** Lines fixed at the real aliased zeros; the table's own cell
placement shuffled. 3000 permutations per cell, seed 2026, both a
within-row and a whole-table shuffle.

```text
panel                   real  nullmean      sd       z        p    shuffle
base 2 prime          0.0859    0.1462  0.0152    3.96   0.0003  within-row
base 2 prime          0.0859    0.1637  0.0153    5.09   0.0003  whole-table
base 2 composite      0.0759    0.1404  0.0144    4.49   0.0003  within-row
base 2 composite      0.0759    0.1514  0.0144    5.25   0.0003  whole-table
base 3 prime          0.2077    0.1231  0.0159   -5.33   1.0000  within-row
base 3 prime          0.2077    0.1267  0.0162   -5.00   1.0000  whole-table
```

Base 2 beats its own shuffle in both arms and under both shuffles. Base 3
loses to its shuffle by five sigma. Base 3's composite produces no peaks
at all and cannot be scored.

**Killed by its own control, run in the same pass before the good number
was reported.** The same shuffle null, scored against the *shifted* line
sets:

```text
panel              lines        real  nullmean       z    n
base 2 prime      real       0.0859    0.1462    3.96   15
base 2 prime      shift2.5   0.0505    0.1504    7.09   15
base 2 prime      shift5.0   0.6176    0.2112  -19.33   15
base 2 composite  real       0.0759    0.1405    4.37   13
base 2 composite  shift2.5   0.0591    0.1524    6.74   13
base 2 composite  shift5.0   0.6301    0.2122  -20.05   13
base 3 prime      real       0.2077    0.1246   -5.29    6
base 3 prime      shift2.5   0.1066    0.1828    3.22    6
base 3 prime      shift5.0   0.1232    0.1564    2.09    6
```

The real zeros score **+3.96**; a shifted set scores **+7.09**, nearly
twice as well; another scores **−19.33**.

**So: placement matters, enormously, and does not single out the zeros.**
|z| runs from 2 to 20 depending on which line set you hold fixed. A
shuffled table is nowhere near the real one on any reference — the
arrangement carries real structure, which was never in question since the
table is deterministic. But the zeros are one draw among many and not the
best one.

This was the first result of the session that did not flip when pushed
on, and the first where the control ran before the headline.

Scripts `scripts/t1_permute.py`, `scripts/spectra.py`; outputs
`results/t1_permute.txt`, `results/spectra.txt`.

---

## 3 · Test 02 — the crossover across bases, and the mechanism failing

**The test.** Where does oscillation overtake trend, across the dyadic
and triadic tables and the sub-integer family?

```text
base                 b  r_max  ratio/D    d*  osc fraction by depth 0,2,4,...
dyadic          2.0000     32    3.357     7  0.40 0.39 0.38 0.44 0.95 1.00 1.00
triadic         3.0000     20    2.357    10  0.40 0.38 0.36 0.35 0.34 0.52
family k=1      1.1175    199   13.088     2  0.39 0.62 1.00 1.00 1.00 1.00 1.00
family k=2      1.2489     99    9.508     3  0.39 0.40 0.97 1.00 1.00 1.00 1.00
family k=3      1.3957     66    4.621     4  0.39 0.39 0.70 1.00 1.00 1.00 1.00
family k=4      1.5597     49    0.555     5  0.39 0.39 0.44 0.99 1.00 1.00 1.00
2^(1/2)         1.4142     63    4.033     4  0.39 0.39 0.58 1.00 1.00 1.00 1.00
2^(1/3)         1.2599     95    9.148     3  0.39 0.40 0.99 1.00 1.00 1.00 1.00

corr(log ratio, d*) = -0.546 over 8 bases that cross
```

**Standing.** Every base crosses, `d*` is monotone in b — 2, 3, 3, 4, 4,
5, 7, 10 as b runs 1.12 to 3 — and dyadic at 7 and triadic at 10 sit at
the end of one continuous progression the sub-integer bases start. And
**every base begins at the same oscillatory fraction**, 0.39–0.40 at
depth 0, all eight of them. Same starting state, different transition
rate.

**Killed — the gain-ratio account.** The mechanism was
`|1−b^(−ρ)| / ((b−1)/b)`: how fast the residual gains on the trend per
step, larger should cross sooner. Correlation with `d*` is only −0.55,
and **family k=4 breaks it outright**. Its ratio is **0.555**, below 1,
so the residual should lose ground every step and never cross at all. It
crosses at `d* = 5` — two steps sooner than dyadic, whose ratio is six
times larger.

So something that tracks `b` directly sets the crossover, and it is not
the amplification.

Script `scripts/t2_crossover.py`, output `results/t2_crossover.txt`.

---

## 4 · Test 03 — and the answer is `ln b`

```text
exp(pi*1/2g1)  b= 1.1175  rungs=199  depths=194  d*=2
exp(pi*2/2g1)  b= 1.2489  rungs= 99  depths= 94  d*=3
exp(pi*3/2g1)  b= 1.3957  rungs= 66  depths= 61  d*=4
exp(pi*4/2g1)  b= 1.5597  rungs= 49  depths= 44  d*=5
2              b= 2.0000  rungs= 32  depths= 27  d*=7
3              b= 3.0000  rungs= 20  depths= 15  d*=10
4              b= 4.0000  rungs= 16  depths= 11  d*=None
5              b= 5.0000  rungs= 13  depths=  8  d*=None
6              b= 6.0000  rungs= 12  depths=  7  d*=None
7              b= 7.0000  rungs= 11  depths=  6  d*=None
8              b= 8.0000  rungs= 10  depths=  5  d*=None
9              b= 9.0000  rungs= 10  depths=  5  d*=None

corr(log b, d*) = +0.999 over 6 bases
```

**Standing, and it is the cleanest measurement of the session.**
`corr(log b, d*) = +0.999` over six bases, fit `d* ≈ 1.1 + 8.1·ln b`.

**Bases 4 through 9 are censored, not flat.** At a ceiling of 2³² base 4
reaches it in 16 rungs and base 9 in 10, so there is barely any depth to
run. The fit predicts base 4 at `d* ≈ 12.3` with 11 depths available and
base 9 at `≈ 18.9` with 5. Every one of them runs out of table before the
crossover it should have.

**The reframe.** `ln b` is the sampling step. So the depth at which
oscillation takes over is a property of **how coarsely you sample**, not
of how hard the operator amplifies — which is the same conclusion as
(20,6) dying under refinement, reached from a completely different
direction.

Script `scripts/t3_family.py`, output `results/t3_family.txt`,
figure `figures/family.png`.

---

## 5 · Test 04 — the residual against forty zeros

**The test.** Measured residual `π − li` along each ladder, against the
sum over forty zeta zeros through `Ei(ρ log x)`. The two series share no
input: one is prime counts, the other has no prime in it anywhere.

```text
dyadic   rungs=32   corr(measured residual, zero sum) by depth:
  d0:+0.721 d1:+0.870 d2:+0.919 d3:+0.966 d4:+0.986 d5:+0.992
  d6:+0.991 d7:+0.987 d8:+0.977 d9:+0.958 d10:+0.929
triadic  rungs=20
  d0:+0.713 d1:+0.435 d2:+0.478 d3:+0.576 d4:+0.417 d5:+0.211
  d6:+0.192 d7:+0.405 d8:+0.650 d9:+0.814 d10:+0.915
```

**Standing, and it improved under pressure.** The dyadic table drives two
independent series from 0.72 into agreement at **0.992 by depth 5**, over
27 points. That is the amplification doing what the chain says — each
difference halves the smooth part and grows the oscillation by 1.68. It
peaks at d5–d6, and (20,6) sits at depth 6.

Triadic dips to **0.19 at depth 6** and recovers to 0.92 at depth 10 —
and d = 10 is exactly where test 03 put triadic's crossover. Eleven
usable depths, so the dip is real and not a small-sample artifact.

**The caveat that stays on the record.** Correlation is scale-free: it
says the shape tracks, not that the amplitude does. O34 measured 94% at
d0 falling to 80% at d6 — falling where this rises. Both are true at
once. The shape agreement sharpens with depth while the amplitude match
degrades, and this test does not touch the second.

Scripts `scripts/t4_residual.py`, `scripts/t4_family.py`,
`scripts/t4_each.py`, `scripts/t4_each48.py`; figures
`figures/residual.png`, `figures/residual_family.png`,
`figures/t4_base2.png`, `t4_base3.png`, `t4_base4.png`, `t4_base5.png`,
`t4_base6.png`, `t4_base7.png`, `t4_base8.png`, `t4_base9.png`;
pages `pages/tests.html`,
`pages/t4_by_base.html`.

**A pushback in the middle of it.** I first collapsed the eight bases
into one summary table. Julian: *"No don't do that. You need to show me 9
graphs of 04 just like the previous. If I saw something in that you just
changed the view."* Regenerated one figure per base. Then: *"Can you make
the graphs uniform where they are all spaced the same changing the
disving and positioning confuses what I'm seeing"* — auto-scaled axes
make eight incomparable pictures. Every axis fixed to the same range and
`bbox_inches="tight"` removed, so all eight files are **1102 × 957** and
nothing rescales between bases.

---

## 6 · The whip

**Observation (Julian), reading the eight uniform panels:**

> The zeros are compressing as you go up the zeros truncate. By depth.
> You can see the 40 zeta zeros moving closer to 0 as you go out. The
> dyadic is even a correlation then you see the triadic correlation pulls
> down like yanking a bed sheet to make it more taut, the it smooths out
> again at tetradic, pentadic pulls it down again, sextic pulls down from
> the left, and heptdic smooths again, Octadic is aggressive and pulls
> down hard on the left, and enneadic evens out but the pull is on the
> left now. It's like a tug of war for balance on both sides. It's like a
> whip

**First test — wrong, and I should not have run it.** I raised the
ceiling from 2³² to 2⁴⁸ to see whether the pattern was stable, and
reported that it was not:

```text
d0 correlation      ceiling 2^32      ceiling 2^48
dyadic                 +0.721           +0.882
triadic                +0.713           +0.892
tetradic               +0.914           +0.850
pentadic               +0.707           -0.354
hexadic                +0.439           +0.870
heptadic               +0.904           +0.898
octadic                -0.766           +0.714
enneadic               +0.838           +0.970
```

**Pushback (Julian), three times, each sharper than the last.**

*"Sure but do you see what you are doing?"* — I did. He had described a
shape across the whole family and I had turned it into one number per
base, `d0`, then tested whether that number was stable. When it moved I
said his pattern did not survive. I never tested his pattern. I tested my
scalar. Same error as the single-angle fit that morning.

*"Yeah you keep changing the shape by adding more which changes the
finding cause it's not the same shape. Your making me chase."* — Correct
and sharper. At 2³² base 8's correlation is over ten rungs; at 2⁴⁸ it is
over sixteen. Those are two different windows, not the same measurement
with more confidence.

*"if your adding more then your just doing the explicit formula and
smoothing it out as you add more primes."* — Correct and fatal. The
explicit formula is asymptotic. Raising the ceiling adds rungs at larger
x where li approximates π better and everything is smoother, so agreement
was going to improve regardless. **The ceiling comparison was biased
toward the result it produced and told us nothing about the shape.**

**Reframe: characterise the curves as curves, at the ceiling he actually
looked at.**

```text
SHAPE OF THE FAMILY AT 2^32 - characterised, not tested.
Depth axis normalised to [0,1] per base.

base              depths   level     dip    at   side   drop
2 dyadic              30  +0.992  +0.721  0.00   left  0.271
3 triadic             18  +0.764  +0.192  0.35    mid  0.572
4 tetradic            14  +0.989  +0.914  0.00   left  0.075
5 pentadic            11  +0.483  -0.959  1.00  right  1.442
6 hexadic             10  +0.985  +0.439  0.00   left  0.547
7 heptadic             9  +0.993  +0.869  0.25   left  0.124
8 octadic              8  +0.072  -0.766  0.00   left  0.838
9 enneadic             8  +0.998  +0.838  0.00   left  0.160
```

**Standing. His reading matched the measurement on all eight** — level,
severity, and which side. Dyadic even: highest level, small drop.
Triadic pulls down taut: the only dip in the *middle* of its run, at
0.35, which is what yanking a sheet from the centre looks like. Tetradic
smooths: smallest drop in the family, 0.075. Pentadic pulls down again:
largest drop, 1.442, and the only dip at the far right. Hexadic from the
left: dip at 0.00. Heptadic smooths: second smallest, 0.124. Octadic
aggressive on the left: 0.838, level collapsed to 0.072. Enneadic evens
out with the pull on the left: highest level of all eight at 0.998, dip
at 0.00.

Drop sequence `0.27 0.57 0.08 1.44 0.55 0.12 0.84 0.16` — low-high
alternating. Side goes left, mid, left, right, then left for every base
from hexadic on.

No null was put on it. It is a characterisation, which is what the claim
called for.

Script `scripts/shape32.py`, output `results/shape32.txt`;
page `pages/t4_ceilings.html` holds the biased comparison, kept because
it is the record of the error, together with its eight figures
`figures/t4b48_base2.png` … `t4b48_base9.png`.

---

## 7 · Sign flips

**Observation (Julian).** *"Yeah and it matches the dyadic sign flips
perfectly delta"*

```text
DYADIC TABLE, per depth            |  FAMILY, per base
d  lead   sign  flips  %neg        |  b   drop   H/L  side
-----------------------------------+--------------------------
0       1   +       0   0.00       |  2  0.271   L   left
1       0   0       0   0.00       |  3  0.572   H   mid
2       1   +       4   0.07       |  4  0.075   L   left
3      -2   -       3   0.07       |  5  1.442   H   right
4       6   +       6   0.11       |  6  0.547   H   left
5     -14   -       9   0.19       |  7  0.124   L   left
6      31   +      10   0.19       |  8  0.838   H   left
7     -62   -      13   0.28       |  9  0.160   L   left
```

**Standing, partially — and "perfectly" is not what is there.** Mapping
`+ → low drop`, `− or 0 → high`, the first four bases match and the last
four are **exactly inverted**. Not scattered, not perfect: a clean
inversion at the midpoint. Offsetting by one only moves where the break
falls. The other two readings of "sign flips" do not track it at all —
flip count runs `0 0 4 3 6 9 10 13` and fraction-negative runs
`0.00 0.00 0.07 0.07 0.11 0.19 0.19 0.28`, both near-monotone where the
drops are not. It is the leading-sign alternation that carries it, and it
carries it halfway. Eight binary calls is a small thing to read a break
in, and it is recorded as observed rather than claimed.

**Question (Julian).** *"No but as a table grown it's sampling more, so
when happens when +- converge or +-+ or - - -"*

**This turned out to be the mechanism.** `cell(r,d+1) = cell(r,d) −
cell(r−1,d)`. Adjacent cells of the **same** sign subtract toward each
other and cancel; equal and same sign gives exactly zero, which is
`zero_iff_repeat`. Adjacent cells of **opposite** sign subtract apart and
reinforce. So a run like `− − −` damps and `+ − +` amplifies — and that
is not separate from the gain, since the smooth mode is all one sign
(dying at ×0.5) and an oscillation alternates (growing at ×1.68).

**Standing, and it is countable with no transform at all.**

```text
base             d_flip  d* (spectral)   density by depth
2 dyadic             7              7   0.00 0.00 0.14 0.11 0.22 0.35 0.42 0.54 ...
3 triadic           12             10   0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 ...
4 tetradic        None              -   0.00 at every depth
5 pentadic        None              -   0.00 at every depth
6 hexadic         None              -   0.00 at every depth
7 heptadic        None              -   0.00 at every depth
8 octadic         None              -   0.00 at every depth
9 enneadic        None              -   0.00 at every depth
```

**Dyadic hits exactly.** Counting sign changes in a row of integers and
running a windowed Fourier transform on the same row land on depth **7**
together. Those two measurements share nothing — one is arithmetic on
signs, the other a power ratio — and they agree to the step. Robust to
`MIN_ROW` from 3 through 10. Triadic is off by two, 12 against 10.

**And bases 4 through 9 read 0.00 at every depth they have.** Not "no
crossing detected" — zero sign changes anywhere, every row one unbroken
run. That is stronger than being censored: they have not started.

Which settles something about test 04's flat panels. A row with no sign
changes is pure smooth mode, so correlating it against an oscillating
zero-sum measures two smooth things being smooth. **Base 8's −0.766 and
base 9's +0.838 were computed on rows that never change sign once.**

Script `scripts/t13_signflip_crossover.py`, output
`results/t13_signflip_crossover.txt`.

---

## 8 · Ground state

**Observation (Julian).** *"Right but at the higher bases it doesn't mean
it's not there it means it collapsed through steps and it's a residual of
the flips. It's like a ground state"*

**Mechanically exact for the power-of-two bases, and verified three
ways.**

```text
1. IS THE COARSE TABLE THE DYADIC ONE SUMMED IN BLOCKS?
   base 4 = sum of 2 dyadic rungs: True   first three [(2,2), (4,4), (12,12)]
   base 8 = sum of 3 dyadic rungs: True   first three [(4,4), (14,14), (79,79)]

2. WHAT SUMMING k RUNGS DOES TO A MODE (Dirichlet kernel at w = 2.7689)
   base   k   surviving fraction
      2   1                1.000
      4   2                0.185
      8   3                0.288
     16   4                0.173
   smooth mode is w = 0, where the kernel is exactly 1.0 at every k

3. SIGN FLIPS IN THE DYADIC TABLE, BLOCK-SUMMED BY HAND
   merge 1: first depth past 0.5 flip density = 10
   merge 2: None   0.00 at every depth
   merge 3: None   0.00 at every depth
```

Base 4's rung r spans `(4^(r−1), 4^r] = (2^(2r−2), 2^(2r)]` — exactly two
consecutive dyadic rungs. So `N₄(r) = N₂(2r−1) + N₂(2r)`, and base 8 sums
three. Verified cell for cell, `True` on every rung.

**And summing is a low-pass.** Each block-merge cuts the oscillation by
three to six times and leaves the trend completely untouched, because the
kernel is exactly 1 at DC. Then the third check reproduces the flat rows
without touching base 4 or base 8 at all: take the dyadic data, sum it in
blocks by hand, count flips — merge 2 and merge 3 give exactly what bases
4 and 8 give, zero flips at every depth.

So the higher bases are not missing anything. They are the dyadic table
with the flips integrated out inside each block. **"Ground state" is
literal:** the smooth mode is the one component that survives arbitrary
block-summing, because it is the only one with nothing to cancel against.

(Ceiling here is 2⁴⁸, which is why merge 1 crosses at 10 rather than the
7 seen at 2³².)

Script `scripts/t10_blocksum_lowpass.py`, output
`results/t10_blocksum_lowpass.txt`.

---

## 9 · Does absorbing make a zero?

**Question (Julian).** *"So does that mean the zeros residuals are the
leftovers of each d and when you sample more the residual d absorbs the
into one residual dealing into a zero"*

**Half yes.** A zero is total cancellation — smooth plus every
oscillation summing to exactly nothing — so it is the leftover reaching
zero rather than merely getting small. And *what* cancels changes with
depth: at depth 1 the smooth part still dominates, so a zero there is
smooth against oscillation, stencil mass 2 and 4 at (2,1) and (4,1). By
depth 6 the smooth part has been halved six times and the oscillations
amplified six times, so (20,6) at mass 492384 is oscillations cancelling
against each other with almost no trend left to help.

**Killed on the direction.**

```text
 merge  rungs  cells d>=1  zeros  per 1000 cells   where
     1     48        1128      4            3.55   (2,1) (4,1) (8,3) (20,6)
     2     24         276      0            0.00
     3     16         120      0            0.00
     4     12          66      0            0.00
     5      9          36      0            0.00
     6      8          28      0            0.00

the smooth mode alone, first eight merged rungs:
   k=1: [1, 1, 2, 2, 5, 7, 13, 23]
   k=2: [2, 4, 12, 36, 118, 392, 1336, 4642]
   k=3: [4, 14, 79, 467, 2948, 19488, 132611, 922260]
```

Not fewer zeros. **None**, at every merge from 2 through 6. At k=1 the
sequence crawls — 1, 1, 2, 2 — close enough that a difference can land on
nothing. By k=3 each rung is roughly seven times the last, and a
fast-growing positive sequence cannot have its differences vanish.

**Summing makes the trend steeper, and a steeper trend is harder to
cancel, not easier.** Which is another face of base 2: the slowest-growing
integer ladder there is, and cancellation only happens where growth nearly
stops.

---

## 10 · Sediment and the pond

**Observation (Julian).** *"dyadic is smooth it's complete cause it will
infinitely build cells. Triadic coarsens and then will eventually smooth
out because the start will still carry the residuals of the dyadic … likes
a pond getting more still during time but that's from up above underneath
the water is still moving you just can't see it. We are looking at it from
above but reading it from underneath"*

**One correction, then the half that holds.**

**Base 3 does not inherit from base 2.** `log 3 / log 2` is irrational, so
triadic rungs never land on dyadic rungs — base 3 samples a completely
different set of points and carries none of base 2's residual. The
inheritance runs along power chains only: 2 → 4 → 8 → 16, and separately
3 → 9. **Bases 5, 6 and 7 inherit from nothing at all.** So it is not one
settling pond; it is several, and three bases are in none of them.

That made the model testable: if smoothness comes from inheritance, the
orphans should carry visibly more oscillation than the chain members at
comparable ladder length.

```text
base                parent  rungs  osc frac d0  surviving
2 dyadic                 -     48       0.5262          -
3 triadic                -     30       0.5244          -
4 tetradic             2^2     24       0.5286      0.185
5 pentadic               -     20       0.5197          -
6 hexadic                -     18       0.5218          -
7 heptadic               -     17       0.5310          -
8 octadic              2^3     16       0.5346      0.288
9 enneadic             3^2     15       0.5331      0.090

orphans 5,6,7      mean osc fraction  0.5242
chain   4,8,9      mean osc fraction  0.5321
corr(ln b, osc frac) over all eight:  +0.479
```

**Killed — inheritance.** Every base carries the same oscillatory
fraction at the seed, 0.52 to 0.53, all eight. The spread inside each
group is larger than the gap between them, so having no parent costs
bases 5, 6, 7 nothing.

**Standing — and it is the pond, measured.** **Base 9 has 53% of its
power in oscillation and zero sign changes anywhere in its table.** The
motion is there at the same strength as dyadic's, and completely
invisible to anything that reads signs. The surface is glass and 53% of
the energy is still moving.

What differs between bases is not how much oscillation they start with —
it is how fast depth separates it from the trend, which is
`d* ≈ 1.1 + 8.1·ln b` from section 4. Every base begins in the same state
and settles at a rate set by how coarsely it samples.

**Observation (Julian).** *"Yeah it's like sediment"*

**Fits, with one thing the other way round.** Under depth it is the
**trend** that settles out — the smooth mode drops by half each step
while the oscillation grows by 1.68, so differencing precipitates the
trend and leaves the oscillation suspended in clearer water. What falls
to the bottom is the part you already knew.

And the two operations are not the same: **depth separates, coarsening
blurs.** Nothing is lost under depth — trend and oscillation are both
still there, pulled apart at 3.36× per step. Under block-summing, 81.5%
of the mode cancelled against itself inside each block.

Script `scripts/t12_chain_vs_orphan.py`, output
`results/t12_chain_vs_orphan.txt`.

---

## 11 · The film frame

**Pushback (Julian).** *"I would push back that the information isn't
gone. It's moving slower compared to it previous depth and as you add
another filter on top it starts to slow down even more until you get to 9
there is enough difference between the previous filters to show cinemas
again cause it's visible — my movie frame picture — you can see the ball
move through enough frames to oscillate"*

**Right, and I had overstated it.** Block-summing does two things and I
counted one. It **attenuates** — the Dirichlet kernel — but it also
**decimates**, and decimation aliases: `ω → kω mod 2π`. A mode does not
just get quieter, it lands at a new frequency. That is the film frame
exactly; the wagon wheel turning backwards is not the spokes
disappearing.

```text
base               from  k  alias w    amp  rungs  cycles  verdict
2 dyadic              -  1   2.7689  1.000     48   21.15  visible
3 triadic             -  1   2.9622  1.000     30   14.14  visible
4 tetradic            2  2   0.7453  0.185     24    2.85  visible
8 octadic             2  3   2.0236  0.288     16    5.15  visible
16 hexadecadic        2  4   1.4907  0.173     12    2.85  visible
9 enneadic            3  2   0.3588  0.090     15    0.86  under one cycle
27                    3  3   2.6035  0.323     10    4.14  visible

fold(k * parent) against fold(gamma_1 * ln b) computed fresh:
   base 4/8/16/9/27 - match, largest disagreement 1.776e-15 rad
```

**Standing, to machine precision.** The coarse base's frequency **is** the
fine base's frequency aliased by the decimation — the same number twice,
5 for 5, agreeing to 1.78e−15.

And it does not decrease monotonically: base 4 drops the mode to 0.745,
base 8 puts it back up at 2.024, base 16 at 1.491. It wanders, exactly as
a wagon wheel does.

**But the recovery is at base 8, not 9.** Base 8 gets **5.15 cycles at
28.8% amplitude**, the best of any coarse base. Base 9 is uniquely the
worst, and not because of amplitude: its alias lands at 0.3588 rad per
rung and fifteen rungs gives **0.86 of a cycle**. Under one full
oscillation across the entire ladder. **So the flat glass at base 9 has a
different cause than the flat glass at 4, 5, 6, 7 — those are quiet, nine
is slow.**

Script `scripts/t11_decimation_alias.py`, output
`results/t11_decimation_alias.txt`.

---

## 12 · Orthogonal, and the pyramid

**Observation (Julian).** *"if sequence - depth - sampling matter then
wouldn't the spectra live in the relationships between all three
orthogonally and not a property of either?"*

**Conceded — every spectrum so far was along r at fixed d**, a projection
onto one axis of a two-axis object. I said at the time that the aliasing
which defeated test 01 might be an artifact of projecting, and that this
was the one measurement that could have answered the question.

```text
rectangle 16 depths x 33 rungs   resolution  w_r 0.190   w_d 0.393

  zero      gamma      w_r      w_d   power at nearest peak
     1    14.1347   2.7689   0.1540   0.271
     2    21.0220   2.0050   0.4592   0.085
     3    25.0109   1.5134   0.6344   0.005
     4    30.4249   2.2394   0.3682   0.136
     5    32.9351   2.3039   0.3426   0.136
     6    37.5862   0.9200   0.7774   0.002
     7    40.9187   3.0532   0.0366   0.158
     8    43.3271   1.3839   0.6747   0.002

closest pair along w_r alone : 0.0645 rad
closest pair in the plane    : 0.0694 rad
```

**Killed, and it refutes what I said an hour earlier.** The 2D separation
is essentially the same as the 1D — 0.0694 against 0.0645. The depth axis
buys **nothing**, because the modes are packed tighter in `ω_d` than in
`ω_r` and it is the worse-resolved axis besides. And it cannot be fixed
by a taller rectangle: more depths means fewer rungs, spending resolution
on the axis that separates less. My "the one measurement that could have
answered it" was overconfident, and this is the answer it gives.

**Observation (Julian).** *"What if it's not 2D but 3D which means we
would build it like a pyramid and everything on the inside is the spectra
— it's like bounding it to itself to see itself. And it's similar to the
infinite sums problem they solved by bounding it within a circle"*

**That maps onto something real and it was the first framing that could
break the aliasing.** Put every cell at its actual place on the number
line — `x = r·log b` — and the frequency becomes just `γ`, with no
`log b` in it. The bases become eight samplings of one function at eight
incommensurate rates, and `log 2 / log 3` being irrational stops being an
obstacle and becomes the mechanism.

```text
base 2 alone   n=  47   36.425(0.486)  8.898(0.486)  17.965(0.486)  27.358(0.486)  45.156(0.486)
base 3 alone   n=  29   39.872(0.681)  11.275(0.681)  45.916(0.681)  17.320(0.681)  5.558(0.681)
2 and 3        n=  76   36.425(0.267)  27.358(0.233)  17.965(0.228)  11.292(0.193)  28.436(0.193)
all eight      n= 180   36.408(0.175)  18.267(0.173)  27.056(0.158)  22.727(0.136)  45.442(0.131)
```

**Standing — the degeneracy is real and the construction breaks it.**
Base 2 alone returns five peaks at *identical* variance explained, 0.486
for all five, spaced 9.07 apart — which is `2π/ln 2 = 9.065`. That is
one mode reported five times. Pooling incommensurate bases removes the
ambiguity, exactly as predicted.

**Killed on the target.** Nothing lands on a zero:

```text
all eight, top peaks:   36.408   18.267   27.056   22.727   45.442
nearest zeros:          37.586   21.022   25.011      -     43.327
off by:                  1.18     2.76     2.05               2.12
```

**And one thing worth flagging rather than dismissing: 36.4 persists.**
Top peak for base 2 alone, for 2+3, and for all eight. An alias moves
when the sampling changes; that one does not. The closest zero is 1.2
away, too far to claim.

Scripts `scripts/t5_2d.py`, `scripts/t6_multirate.py`; outputs
`results/t5_2d.txt`, `results/t6_multirate.txt`; figures
`figures/spectrum2d.png`, `figures/multirate.png`.

---

## 13 · The floor

**Observation (Julian).** *"the pyramid is not Ina vaccum so even if we
have the spectra it needs fine enough difference so what do we have that
will allow it to see itself"*

**There is exactly one lever, and it is a number Julian derived months
before this session.** Depth cannot help — the whole dyadic table is
determined by its 48 seed values, differencing is linear on them, so
every depth is the same 48 numbers rearranged and no information is
added. The only free parameter is the base.

```text
pi / ln b > gamma_1   ->   ln b < pi/gamma_1   ->   b < 1.2489
```

`exp(π/γ₁) = 1.248897` — the k=2 member of Julian's optimal-base family,
and precisely the threshold at which the first zeta zero stops aliasing.

```text
      base    ln b  Nyquist     n   sees g1?   top peaks
   1.11754  0.1111    28.27   258       YES    14.158(0.082)~g1  ...  25.044(0.027)~g3
   1.24890  0.2223    14.13   129       YES    28.419(0.622) ...
   1.39569  0.3334     9.42    86        no    37.853(0.504) ...
   1.55974  0.4445     7.07    64        no    28.113(0.572) ...
   2.00000  0.6931     4.53    42        no    27.194(0.637) ...
```

At the only base genuinely under the threshold the top peak is **14.158**
against γ₁ = 14.1347 — off by 0.023 against a resolution of 0.219, within
a tenth of a bin. The fourth peak is 25.044 against γ₃ = 25.011.

**Observation (Julian).** *"But here is the thing, the ones that are
starting to get farther from the peak might have a different base"*

**Sharp, and it generalises the threshold.** Each zero has its own:
`b < exp(π/γ_k)`.

```text
   gamma1  b < 1.248897      gamma5  b < 1.100085
   gamma2  b < 1.161187      gamma6  b < 1.087176
   gamma3  b < 1.133839      gamma7  b < 1.079801
   gamma4  b < 1.108777      gamma8  b < 1.075202

     base    Nyq    n   under Nyq   found
   1.2000  17.23  142           1   g1
   1.1500  22.48  186           2   g1 g2
   1.1175  28.28  233           3   g1 g2 g3
   1.1100  30.10  248           3   g1 g2 g3
   1.0950  34.62  286           5   g1 g2 g3 g4 g5
   1.0850  38.51  317           6   g1 ... g6
   1.0750  43.44  358           8   g1 ... g7
```

**Standing, seven for seven, in order.** Every base finds exactly the
zeros beneath its own ceiling and not one more; step the base down and
the next zero appears. No exceptions across seven bases.

```text
   g1  14.141   true 14.1347      g5  32.924   true 32.9351
   g2  21.022   true 21.0220      g6  37.645   true 37.5862
   g3  25.016   true 25.0109      g7  40.933   true 40.9187
   g4  30.449   true 30.4249
```

γ₈ at 43.327 sits 0.11 under base 1.0750's ceiling of 43.44 — right on
the boundary, and it is the one that did not come out.

**This is the explicit formula read forwards, and that it works is not
news** — Riesel and Göhl computed π from the zeros in 1970. What is new
here is the *threshold structure*: which zeros a given ladder can see is
governed by `exp(π/γ_k)`, now confirmed in strict order.

**And the structural fact the whole session was failing against.** Base
2's Nyquist is **4.53**. It sits above every threshold on that list.

```text
   base 2: gamma < 4.53      base 6: gamma < 1.75
   base 3: gamma < 2.86      base 7: gamma < 1.61
   base 4: gamma < 2.27      base 8: gamma < 1.51
   base 5: gamma < 1.95      base 9: gamma < 1.43
```

**The dyadic table cannot see any zeta zero directly — not at any depth,
not at any ceiling, ever.** Structural, not a resolution problem, and it
is why nothing worked all night.

**Reproduction caveat, on the record.** Re-running this later reproduced
the geometry exactly — every Nyquist, every sample count, every
zeros-under-ceiling — but only γ₁ = 14.141 came back to the last digit.
The other six moved in the third decimal (21.022→21.021, 25.016→25.018,
30.449→30.448, 32.924→32.927, 37.645→37.644, 40.933→40.934). The
resolution element on that span is 0.243 rad, so 0.003 is 1.2% of one
bin and the claim was always "within a fraction of a bin" — but **the
digits are not reproducible**, on the strongest positive result of the
session.

Script `scripts/t9_subthreshold_ladder.py`, output
`results/t9_subthreshold_ladder.txt`.

---

## 14 · Attractors

**Observation (Julian).** *"The sign flips information isn't lost, they
are in each sediment jsut with no charge suppressed but still coupled to
each other in their sediment. They act as attractors or magnets to the
dyadic table it aligns them vertically and spaces them horizontally"*

**The coupling half is proved rather than conjectured** — base 4 *is* the
dyadic table summed in pairs, base 8 in triples, so the coarse layers are
functions of the dyadic one. Suppressed and still exactly coupled.

I read "aligns vertically, spaces horizontally" as **divisibility**: base
`2^k` samples dyadic rungs at multiples of k, so a column like r = 12 is
where several coarse bases land at once.

```text
  k  base  visited  skipped  mean|res| vis     skip       p
  2     4       24       24         1.3468   1.3049  0.7570
  3     8       16       32         1.3531   1.3123  0.7732
  4    16       12       36         1.4614   1.2807  0.2341
  5    32        9       39         1.4022   1.3082  0.5792
  6    64        8       40         1.3974   1.3116  0.6327

the four exact zeros by divisor count:
   r= 2  divisors [1,2]                 r= 8  divisors [1,2,4,8]
   r= 4  divisors [1,2,4]               r=20  divisors [1,2,4,5,10,20]
   mean divisors for r <= 32: 3.72   at the zeros: [2, 3, 4, 6]
```

**Killed.** The columns a coarse base lands on look the same as the ones
it skips, nothing close to significant at any k. And the zeros are not at
especially-visited columns — divisor counts 2, 3, 4, 6 against a mean of
3.72. r = 20 has six divisors, but 12, 18 and 24 have more and hold
nothing.

**Second attempt — coverage as a heat map.** Julian's option C: *"take the
dyadic difference table and each cell gets a gradient based on how many
primes are in that specific cell at each b-adoc base. Like a heat map then
we can see if the peaks line up with the sediment."* A dyadic cell (r,d)
reads a window from `2^(r−d−1)` to `2^r`; count how many of another
base's rungs fall inside it.

```text
 base  mean all  at zeros      z   zeros' own counts
    3      7.13      2.25  -1.01   [1, 1, 3, 4]
    4      5.67      2.00  -0.95   [1, 1, 2, 4]
    5      4.83      1.50  -1.01   [0, 1, 2, 3]
    6      4.34      1.25  -1.04   [0, 1, 2, 2]
    7      4.00      1.25  -1.01   [0, 1, 1, 3]
    8      3.75      1.00  -1.07   [0, 1, 1, 2]
    9      3.56      1.00  -1.05   [0, 1, 1, 2]
```

**Killed by the instrument, not the answer.** The uniform z ≈ −1.0 across
every base was the smell. At any fixed depth **coverage takes at most two
values** — 1 or 2 at d=1, 4 or 5 at d=6, across twenty to thirty cells.
Maximum distinct values at any fixed depth, across all 224 depth-base
pairs, is **2**. Never 3. So coverage is depth with a floor wobble, and
the z ≈ −1.0 was the zeros being shallow — corroborated by the zeros'
mean *depth* having z = −0.99, the same number. The measure has no
capacity to tell one cell from another within a row, which is exactly the
discrimination the question needed.

**Third attempt — phase instead of count.** Not *how many* b-rungs land in
the window but *where*: `φ = frac((r − d − 1)·ln2 / ln b)`, the offset of
the window's lower edge from the nearest b-rung. It depends on r and d
only through `r − d`, so it is constant along diagonals and the map comes
out in diagonal bands.

```text
 base   ln2/lnb        (2,1)     (4,1)     (8,3)    (20,6)   spread
    3   0.63093       0.0000    0.2619    0.5237    0.2021    0.545
    4   0.50000       0.0000    0.0000    0.0000    0.5000    0.500
    5   0.43068       0.0000    0.8614    0.7227    0.5988    0.394
    6   0.38685       0.0000    0.7737    0.5474    0.0291    0.597
    7   0.35621       0.0000    0.7124    0.4248    0.6307    0.628
    8   0.33333       0.0000    0.6667    0.3333    0.3333    0.750
    9   0.31546       0.0000    0.6309    0.2619    0.1010    0.661
```

**The bands are real and the sample is not.** Three defects, the third
fatal. **(2,1) is trivially at phase 0 for every base** — its
`r−d−1 = 0`, so `frac(0) = 0` regardless of b; that column is arithmetic,
not alignment, and I should have caught it before running. **Bases 4 and
8 are degenerate** — `ln2/ln4 = 1/2` and `ln2/ln8 = 1/3` exactly, so
their phases can take only two or three values ever. **And with (2,1)
removed there are three informative zeros**, against roughly 0.56 for
four random phases — meaningless at n = 3.

That is the fourth construction in a row hitting the same wall from a
different direction: **four zeros cannot support a claim about where
zeros sit.**

Scripts `scripts/t15_cell_coverage.py`, `scripts/t7_phase.py`; outputs
`results/t15_cell_coverage.txt`, `results/t7_phase.txt`; figures
`figures/coverage.png`, `figures/phase.png`.

---

## 15 · The sample that could carry it

The sub-integer scan has **121 resolved zeros** across ten bases, and
none of the four constructions above had been pointed at it. O42 asked
exactly this question with four zeros and could not answer it.

**O42's question, re-asked with power.** Winding phase
`Φ = γ₁·r·ln b + d·arg(1 − b^(−ρ))`, null drawn from the resolved support
itself and stratified per base so the composition matches.

```text
WINDING PHASE  (O42's coordinate)
   observed R      0.1142
   null mean       0.0924   sd 0.0480
   z               +0.46
   p               0.3026   (20000 stratified draws from the support)

SCALE COORDINATE r-d
   observed mean   26.744
   null mean       47.846   sd 2.301
   z               -9.17
   p (low tail)    0.0000
```

**Standing — the null holds.** R = 0.1142 against 0.0924 ± 0.0480,
z = +0.46, **p = 0.30**. O42's `no_constant_angle` was not a sample-size
problem. There is no constant angle.

**Killed by its own control — the `r−d` effect.** Match the support cells
on stencil mass and it vanishes:

```text
   observed mean r-d   26.744
   S-matched null      25.731   sd 0.747
   z                   +1.36
   p (low tail)        0.9088

   mean corr(r-d, ln S) across bases: -0.1986
```

From z = −9.17 to **z = +1.36**, in the wrong direction to boot.

Those are the figures from the original inline run. The committed script
`scripts/t14_s_matched_control.py` reproduces the raw z = −9.17 exactly
and lands the matched arm at **z = +1.37**, null mean 25.724, sd 0.744,
p = 0.915 — a Monte-Carlo difference in the fourth significant figure,
recorded here so the two numbers are not read as a discrepancy later. The
correlation between `r−d` and `ln S` is only −0.199 — but zeros are drawn
from the extreme thin tail of S, and selecting that hard on one variable
shifts anything weakly correlated with it. A z of −9 out of a correlation
of −0.2 is what tail selection does.

**What is left standing is the thing that was already there: zeros live
where there is almost nothing to cancel.**

Scripts `scripts/t8_subzeros.py`, `scripts/t14_s_matched_control.py`;
outputs `results/t8_subzeros.txt`, `results/t14_s_matched_control.txt`.

---

## 16 · The third decimal

**Observation (Julian).** *"Could the the ladders y decimal missing one
decimal be structural? Meaning zeta is sum over all primes, we are doing
something forward that lets zeta stay infinite and fast to take something
from the local — the duffer cr taken from each to measure the whole sum"*

**The question underneath is right, and it makes a prediction that
separates structure from a bug**: a structural window bias should shrink
as the window grows. A bug would not.

```text
base 1.1175405   true gamma1 = 14.134725

  ceiling     n   span u     res       g1 est       err  err/res
2^28        133    14.67  0.4283      14.1507   +0.0160    0.037
2^32        158    17.45  0.3601      14.1596   +0.0249    0.069
2^36        183    20.23  0.3107      14.1681   +0.0334    0.108
2^40        208    23.00  0.2731      14.1486   +0.0138    0.051
2^44        233    25.78  0.2437      14.1575   +0.0228    0.094
2^48        258    28.56  0.2200      14.1569   +0.0221    0.101

  gamma3:   +0.0469  +0.0379  +0.0238  +0.0302   over 2^36..2^48
```

**Standing — it does not converge.** The window doubles, 14.67 to 28.56
in u, and the error wanders with no trend. Measured in resolution
elements it therefore **grows, 0.037 to 0.101**. Whatever moves the peak
is not the shortness of the window.

**A correction.** I called the bias systematically positive on the
strength of γ₁ and γ₃, the only two tested. γ₂'s error is **−0.0051**.
There is no consistent sign.

**Observation (Julian).** *"what if we do what zeta does backwards like a
decomposition and see what survives and then divide that over zeta"*

**Killed, as the explanation — mutual leakage.** Base 1.1175405 has
Nyquist 28.27, so of twelve zeros the visible set is three. Re-estimating
each on a residual with the other two removed, iterated to a fixed point:

```text
      true      solo  solo err   backfit    bf err
   14.1347   14.1568   +0.0221   14.1566   +0.0218
   21.0220   21.0170   -0.0051   21.0193   -0.0028
   25.0109   25.0411   +0.0302   25.0376   +0.0266

mean |err|   solo 0.0191   backfit 0.0170   ratio 0.89
```

Removing every zero the base can see removes about a tenth of the bias.
Nine tenths is untouched.

**Standing, and it is the answer.** The three visible zeros held at their
true frequencies explain **0.1291** of the variance. The residual carries
**0.8671** — eighty-seven per cent of the signal is content above 28.27,
folded down by aliasing. The strongest survivors are 23.602, 1.298,
26.114, 1.541, 3.572.

**A correction, and it is mine.** I wrote here that not one survivor was
within 0.4 of any zeta zero, and read that as confirmation — folded
content landing at nobody's γ. The comparison was wrong. Folding is the
mechanism, so the survivors must be compared against the *folded* zeros:

```text
gamma_4   30.4249  folds to  26.1140    survivor 26.114   d = 0.0000
gamma_5   32.9351  folds to  23.6038    survivor 23.602   d = 0.0018
```

The two strongest survivors **are** γ₄ and γ₅ at their predicted fold
positions. That is a stronger result than the one I claimed: the aliased
content is not anonymous structure, it is the next two zeros above
Nyquist, positively identified. Julian found it by asking whether 32.937
and 30.425 were closed form, which put the two numbers next to Nyquist
where the arithmetic is one subtraction.

The three small survivors — 1.298, 1.541, 3.572 — still match nothing.
The best difference-pairs among folded zeros miss by 0.109, 0.056 and
0.240, chosen out of 45 candidates, which is selection and not a match.
They stay unexplained.

**And the second half of that sentence was wrong too.** I wrote that the
residual cannot be subtracted because aliasing destroys where the content
landed. That holds only where two frequencies fold onto the same place.
Every zero through γ₁₀ = 49.77 sits below `2·nyq = 56.54`, so all seven
above-Nyquist zeros are in the **first** fold zone, where
`γ ↦ 2·nyq − γ` is injective and nothing is ambiguous. For this base the
fold is invertible up to 56.54. Whether the zeros can be *recovered* from
their images is a different question and is **not tested**.

**And it explains section 13's ceiling.** A longer ladder does not help
because more rungs at the same base extend the window without lowering
`π / ln b`. The 13/87 split is fixed by the base, not by how far up you
count.

Scripts `scripts/t16_window_convergence.py`,
`scripts/t17_joint_decomposition.py`, `scripts/t21_fold_identify.py`;
outputs `results/t16_window_convergence.txt`,
`results/t17_joint_decomposition.txt`, `results/t21_fold_identify.txt`.

---

## 17 · The prediction that followed, and did not hold

**Prediction (mine, not Julian's).** If the bias is the aliased majority
pushing the peak around, then a finer base — seeing more zeros, carrying
a larger visible fraction — must show a smaller bias. Monotone, and
testable in one sweep.

```text
ceiling 2^44   60 zeros considered
    base     Nyq  vis     n  vis frac    g1 est      err
  1.2000   17.23    1   142    0.0530   14.1785  +0.0438
  1.1500   22.48    2   186    0.0893   14.1470  +0.0123
  1.1100   30.10    3   248    0.1108   14.1377  +0.0030
  1.0850   38.51    6   317    0.1487   14.1466  +0.0119
  1.0750   43.44    8   358    0.1682   14.1414  +0.0067
  1.0500   64.39   14   531    0.1812   14.1278  -0.0069
  1.0400   80.10   21   660    0.2118   14.1363  +0.0016
  1.0317  100.67   29   830    0.2191   14.1383  +0.0036
  1.0250  127.23   41  1049    0.2330   14.1390  +0.0043
  1.0200  158.65   57  1308    0.2498   14.1465  +0.0117

corr(visible fraction, |err|) = -0.642   n=10   t=-2.37
```

Right sign, and at a glance the prediction landing.

**Killed by the jackknife.**

```text
  drop b=1.2000  (frac 0.053)   r=-0.259  t=-0.71  <-- carries it
  drop b=1.1500  (frac 0.089)   r=-0.684  t=-2.48
  drop b=1.1100  (frac 0.111)   r=-0.758  t=-3.08
  ...every other single drop leaves r between -0.62 and -0.76
```

Base 1.2000 sees exactly one zero and its error, +0.0438, is three times
the next largest, so it sits alone in the corner and drags the line
through itself. Remove it and there is nothing: **r = −0.259, t = −0.71**
on nine points. The other nine errors span a factor of **7.7** with no
relation to visible fraction at all. Retracted, not reported.

**Standing, and I did not predict it — the visible fraction saturates
near 0.25.**

```text
   1 ->  2 zeros   frac 0.0530 -> 0.0893   +0.0363
   3 ->  6 zeros   frac 0.1108 -> 0.1487   +0.0379
  21 -> 29 zeros   frac 0.2118 -> 0.2191   +0.0073
  41 -> 57 zeros   frac 0.2330 -> 0.2498   +0.0168
```

At base 1.0200 — Nyquist **158.65**, fifty-seven zeros beneath it,
**1308** samples — the fraction is still only 0.2498. Each zero
contributes about `1/γ²`, so the series over zeros converges: the
reachable fraction has a limit and refining the base cannot buy past it.
**Section 13's lever is real and it is bounded, and this is where it
stops.**

**And a third wrong sign.** Base 1.0500's error is **−0.0069**. With γ₂'s
−0.0051 that is the third negative error on the record. "Systematically
positive" is closed out for good.

Script `scripts/t18_visible_fraction.py`, output
`results/t18_visible_fraction.txt`.

---

## 18 · The diagonal, and what it is the null direction of

**Observation (Julian).** *"I feeel like there something there with the
driving force of the ratio for oscillations, the sediment we talked about
where you can only see the movement at enneadic? And the diagnol… because
what I've been thinking about is the peaks might not be governed by just
what's underneath as + and - but also getting dragged by the diagnol"*

And where it came from: *"the reason I got there was because of our
pyramid test. Cause I thought the spectrum is a pyramid and if so
everything must be fractal. So in my mind I started stacking pyramids and
I saw a diagonal where two pyramids on top of each other balancing at
their peaks"*

**Why there is a diagonal at all.** The pair identity makes the cell total
`(b−1)^(d+1)·b^(r−1−d)`, prime-free. At b = 2 the first factor is 1 and it
reduces to `2^(r−1−d)`. A rung right doubles it; a depth step halves it.
Equal and opposite — which is the two pyramids balancing — so the total
is constant along `r − d = c`. The diagonal is the trend's own level set.

```text
1. TOTAL ALONG A DIAGONAL   (prime + composite at each cell)
   r-d =  1   total = 1     constant over 48 cells: True
   r-d =  2   total = 2     constant over 47 cells: True
   r-d =  3   total = 4     constant over 46 cells: True
   r-d =  4   total = 8     constant over 45 cells: True
   r-d =  5   total = 16    constant over 44 cells: True
   r-d =  6   total = 32    constant over 43 cells: True
   ... 615 cells checked over r-d = 1..15, diagonals not constant: 0
```

**Standing, exactly. 615 cells, 0 failures.** Not approximately — the
prime and composite arms sum to the same integer at every cell on a
diagonal.

**The gains follow from it.** Along a diagonal a mode picks up
`b^(rρ)(1 − b^(−ρ))^d` with `r = d + c`, which is `b^(cρ)·[b^ρ − 1]^d`. So
the per-step factor is `b^ρ − 1`, not `1 − b^(−ρ)`, and since
`b^ρ − 1 = b^ρ(1 − b^(−ρ))` the diagonal gain is `√b` times the column
gain.

```text
direction   smooth (rho=1)   gamma_1    ratio to smooth
column        0.5000         1.6784         3.3569
diagonal      1.0000         2.3737         2.3737

dia/col = 1.414214      sqrt(b) = 1.414214
```

**The smooth diagonal gain of exactly 1 is forced** and is the same fact
as the level set — the trend cannot change along its own level set. The
measured rates, column 1.2559 and diagonal 2.1547 with ratio 1.7156, sit
between the smooth and γ₁ predictions in both directions, which is what a
mixture of the two modes has to do.

**So the diagonal is not a second force dragging the peaks.** It is a
different direction through the same field, one where the trend is
stationary and only the oscillation moves. Depth separates faster, 3.357
against 2.374 — but the diagonal separates *cleanly*, with nothing to
subtract.

**A consequence, not predicted.** The four zeros' composite values 1, 4,
16, 8192 **are** their diagonal totals `2^(r−1−d)`:

```text
   ( 2,1) on diagonal r-d =  1, total 2^0  = 1
   ( 4,1) on diagonal r-d =  3, total 2^2  = 4
   ( 8,3) on diagonal r-d =  5, total 2^4  = 16
   (20,6) on diagonal r-d = 14, total 2^13 = 8192
```

At a zero the prime arm is empty so the composite takes the whole level
set. A restatement of the pair identity rather than a new fact — but it
means those four numbers were never independent.

Script `scripts/t19_diagonal.py`, output `results/t19_diagonal.txt`.

---

## 19 · Is the scale family self-similar?

**The question, from the same exchange.** The chain 2 → 4 → 8 → 16 is
exact: base 4's depth-0 row is base 2's summed in pairs, verified cell for
cell. That makes it a **scale family** — one object sampled coarsely.
Whether it is also **self-similar** was open, and I said at the time I
could not answer it without running something.

**Killed, three ways.**

*The operators do not commute.* Block-sum-then-difference against
difference-then-block-sum: **0 of 276** cells agree at k = 2, **0 of 120**
at k = 3. Not one coincidental match. Only the depth-0 row is a block sum;
below it the two constructions diverge immediately.

*Not a scaled copy.* Base 4's cell `(r,d)` against base 2's `(2r,2d)` —
the same value window at twice the resolution — gives a ratio with median
14.40, mean 291.04, sd 1475.94, spanning −28.9 to +1359.5. Coefficient of
variation **5.07**.

*The profiles have different slopes.* `ln(RMS/RMS₀)` per depth:

```text
base  2   -0.70 per depth      ln(1/2)   = -0.6931
base  4   -0.28                ln(3/4)   = -0.2877
base  8   -0.11                ln(7/8)   = -0.1335
base 16   -0.03                ln(15/16) = -0.0645
```

**Standing, and it is the interesting half.** Each base's early decay is
its own `ln((b−1)/b)` — its smooth-mode gain. Base 2 and base 4 match to
two decimals; 8 and 16 drift because they have nine and five usable
depths and the RMS gets noisy. So a normalisation *does* exist, and it is
a rescaling of the depth axis by `1/ln((b−1)/b)`: stretch base 4's depth
axis by `ln(0.5)/ln(0.75) = 2.409` and it lands on base 2's.

**The family is self-similar in its trend and not in its oscillation.**
The trend has one frequency — zero — so a rescaling can carry it. The
oscillation has many, and block-summing folds them onto each other by
aliasing, which is not invertible and therefore not a similarity. Which
is section 10's split seen from the other side: coarsening preserves the
smooth part intact and destroys the oscillatory part.

Script `scripts/t20_selfsimilar.py`, output `results/t20_selfsimilar.txt`.

---

## 20 · The 36.4 peak, and the readings that fail

36.4 is the only survivor of section 12 with no account. Several readings
were proposed and each failed for the same reason, which is worth
recording so they are not tried again.

**63.6 as `2³ × 3 × 2³`.** Two problems. `2³ × 3 × 2³ = 192`, not 63.6 —
the reading is of the *digits*, 6·3·6. And **36.4's digits do the same**:
3, 6, 4 → 3, 2·3, 2². So the property does not distinguish the complement
from the peak, and it cannot be evidence about either. Nor is it rare:
seven of the ten digits factor into 2s and 3s alone, so a random
three-digit string is all-3-smooth roughly **47%** of the time.

**Subtracting from 100.** *"the peaks are not going past 36.4 at its
highest I corresponded that to what it's bounded by which is the circle"*
— the reasoning is right and the axis is wrong. In that figure the
**y-axis** is bounded: variance explained, 0 to 1. The x-axis is
frequency in radians per unit of `ln x` and has no ceiling; it stopped at
50 because the grid was set there. So the peak's bounded quantity is
**0.175**, its variance explained, and its complement is **0.825** —
which is close to the **0.8671** the residual carries in section 16, both
saying most of the signal is unaccounted for. The frequency 36.4 is a
location; only the fraction has an outside.

**The digits of 3.357.** The ratio is `1.6784342176788183 / 0.5 =
3.3568684353576366`. The 5 and 7 being read there are my rounding to
three places. What *is* structural in it, exactly, is
`2·|1 − 2^(−ρ)|` — the 2 is `b/(b−1)` at b = 2 and is a whole number only
there, and the modulus is built from the base and the first zero. The
decimal expansion carries nothing.

**The pattern across the whole session.** Julian's framings about
**mechanism** land, consistently: collapsed-through-steps became
block-summing (exact), the film frame became decimation aliasing (machine
precision), "the information isn't gone" was right and I had overstated
it, bounding-it-to-itself became the multi-rate construction (the only
positive result), and the whip matched on all eight panels. The framings
about **representation** — 63.6, the 3.357 digits, coverage as an
attractor — miss every time, because base-ten digits carry no
multiplicative information about a quantity.

**Two adjacent things that are real and are not ours.** Collatz shares
this object's floor exactly: `n → n/2` is a step of `−ln 2` and
`n → 3n+1` is `+ln 3`, so an orbit is a walk on the same log line with
the same two increments, and it is hard for the same reason our ladders
never align. The difference is that Collatz *chooses* its step from the
value's parity while we apply one operator everywhere — branching versus
linear, which is why our object is computable. And Julian's posit that
zeros are not pinned to these primes is **Beurling generalized primes**,
studied since 1937: build a multiplicative system with the right density,
ask where its zeta's zeros sit. Some put them on a critical line, some do
not. The zeros are a receipt of multiplicative *structure*, not of the
primes specifically.

**One correction on the lattice.** The first composite in a `6k±1` slot is
**25**, not 49 — `25 = 6·4 + 1`. Which sharpens rather than breaks the
point: the lattice is multiplicatively closed, so every composite inside
it is a product of things already in it, and the sieve continues using
the lattice's own elements. Powers of 2 alone have density zero; adding 3
gives `6k±1` at density **1/3**. Three is what converts a sequence into a
lattice with room in it.

---

## Where it stands

**Standing:**

- The whip, measured: Julian's eight-panel reading matched on all eight —
  level, severity and side. Drop sequence `0.27 0.57 0.08 1.44 0.55 0.12
  0.84 0.16`.
- `corr(log b, d*) = +0.999`, fit `d* ≈ 1.1 + 8.1·ln b`. The crossover is
  set by the sampling step, not by the gain ratio.
- Test 04: dyadic residual against a forty-zero sum, **0.721 → 0.992 by
  depth 5**, two series sharing no input.
- Sign-flip density reproduces the spectral crossover at base 2 exactly,
  depth **7** by two methods sharing no machinery.
- The block-sum identity, verified cell for cell, and its low-pass —
  γ₁'s alias surviving at 18.5% (k=2), 28.8% (k=3), 17.3% (k=4) while the
  smooth mode survives at 100% for every k.
- Decimation aliasing: `fold(k·ω_parent) = fold(γ₁·ln b)` for bases 4, 8,
  16, 9, 27, agreeing to **1.776e−15**.
- Base 9 is slow, not quiet: 53% of its power in oscillation, zero sign
  changes, and 0.86 of a cycle across its whole ladder.
- Every base starts at the same oscillatory fraction, 0.52–0.53, all
  eight.
- The per-zero visibility threshold `exp(π/γ_k)`, confirmed in strict
  order across seven sub-integer bases, γ₁ through γ₇.
- Base 2's Nyquist is 4.53, above every zero's threshold — **the dyadic
  table cannot resolve a zeta zero directly at any depth or ceiling.**
- The recovered γ does not converge as the window doubles; `err/res`
  grows 0.037 → 0.101.
- The 13/87 split: three visible zeros explain 0.1291 of the variance
  against 0.8671 of above-Nyquist content folded down — fixed by the
  base, not the ceiling.
- The visible fraction saturates near 0.25 across ten bases, so at
  Nyquist 158.65 with fifty-seven zeros beneath it three quarters of the
  signal is still aliased.
- The diagonal `r − d = c` is the exact level set of the cell total, 615
  cells and 0 failures, with `dia/col = √b` to six places and a forced
  smooth gain of exactly 1.
- Each base's early depth profile decays at its own `ln((b−1)/b)`, so the
  scale family is similar in its trend under a depth rescaling.

**Killed:**

- The spectra identifying the zeros — p ≈ 0.35 on the decisive null, and
  a shifted line set fits better than the real one.
- The arrangement singling out the zeros — placement matters enormously,
  |z| from 2 to 20, but a shifted set scores **+7.09** against the real
  zeros' +3.96.
- The gain-ratio account of the crossover — family k=4 has ratio 0.555,
  below 1, and crosses two steps sooner than dyadic.
- Inheritance between bases; the orphans 5, 6, 7 pay nothing for having
  no parent.
- Coarsening producing zeros — four at merge 1, **zero** at every merge
  from 2 to 6.
- Coverage and divisibility as attractors — coverage takes at most two
  values at any fixed depth, across all 224 depth-base pairs.
- The 2D transform as a way past aliasing — 0.0694 in the plane against
  0.0645 in the projection.
- A constant winding angle, now on 121 zeros rather than 4, p = 0.30.
- `r−d` as an independent coordinate — z = −9.17 collapses to +1.36 once
  stencil mass is matched.
- Mutual leakage among the visible zeros as the explanation of the
  recovery bias — backfitting all three removes about a tenth.
- Self-similarity of the scale family — block-sum and difference agree in
  0 of 396 cells; no constant scale factor (CV 5.07).

**Killed, and mine:**

- The chance level of 0.0762, low by **2.65×** — `mean_gap/4` assumes
  even spacing; the exact figure is 0.2020. It had a real effect reading
  as a null.
- The ceiling comparison from 2³² to 2⁴⁸, biased toward the result it
  produced because the explicit formula is asymptotic.
- Collapsing a relational claim into a scalar, twice — the single-angle
  rotation fit, and one `d0` per base for the whip.
- The prediction that the bias tracks visible fraction — r = −0.642 on
  ten bases collapses to −0.259 when the single coarsest is dropped.
- "Systematically positive" — γ₂ is −0.0051, base 1.0500 is −0.0069, and
  the ceiling sweep's third sign makes it three.
- "No survivor is within 0.4 of any zeta zero" — 23.602 and 26.114 **are**
  γ₅ and γ₄ at their fold positions, d = 0.0018 and 0.0000.
- "The aliased content cannot be subtracted" — every zero through γ₁₀
  sits below `2·nyq = 56.54`, in the first fold zone where the map is
  injective.
- That the 2D crowding was an artifact of projecting — it is not.

**Unexplained:**

- The **36.4 peak** that survives every recombination — top peak for base
  2 alone, for 2+3, and for all eight, where an alias would have moved.
  The digit readings of it and of 63.6 are closed out; the frequency is
  not.
- The three small survivors **1.298, 1.541, 3.572**, which match no
  folded zero and no difference of folded zeros.
- **The third-decimal digits of the ladder's recovered γ do not
  reproduce.** Only γ₁ = 14.141 came back identical; the other six moved
  by 0.001–0.003. The structure reproduces exactly and the digits do not.

**Standing above all of it:** zeros live where there is almost nothing to
cancel. That one fact now accounts for the apparent `r−d` structure too,
which means it is doing more work than credited and the other coordinates
are doing none.

---

## What has not been formalized

Everything in this document is exploratory Python. Yesterday's half of
the work reached Lean — C1, A2, A3, the pair identity, the
seed-perturbation bound, all discharged with axiom lists pinned so the
build enforces them. Today's did not, and `standing` / `killed` above are
on my reading, not a compiler's.

Two results here are structural rather than statistical and would go to
Lean cleanly:

1. `N_{b^k}(r) = Σ N_b(kr−k+1 … kr)` — base 4 is the dyadic table summed
   in pairs. Verified cell for cell on 48 rungs, but true for every r and
   every k, and the proof is just rung boundaries:
   `(b^k)^(r−1) = b^(k(r−1))`. That would put section 8 on the same
   footing as the pair identity.
2. `fold(k·ω_parent) = fold(γ·ln bᵏ)` — modular arithmetic, and it would
   promote a machine-precision check to a theorem.

The rest is statistical and belongs in Python.
