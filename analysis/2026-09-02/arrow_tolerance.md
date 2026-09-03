# The rung-to-strip arrow, priced at the consumer's precision

EXPLORATORY. No prereg, no decision rule, no verdict. This is a census in
entry 130's shape (`notes/lab_notebook_2.md:11870-11898`), run because the
orchestrator called the arrow "hard for real reasons" in chat without
measuring anything — the consensus echo that
`/Users/juliansambrano/GitHub/CLAUDE.md:235-240` names.

The arrow under price is entry 303 §(d)
(`notes/lab_notebook_2.md:193-199`):

```text
def StmtWeilPositive (L : ℝ) : Prop :=
  ∀ G, HasCompactSupport G → tsupport G ⊆ Icc (-L/2) (L/2) → 0 ≤ Q(G)
StmtWeilPositive L → riemannZeta.RH_up_to (T L)
```

Numbers: `analysis/2026-09-02/results/arrow_price.numbers` (JSON sha256 on
line 1 of that file), produced by `arrow_price.py` from the keys of
`analysis/2026-09-01/results/weil_Lc_theory.numbers` and
`analysis/2026-09-01/results/weil_Lc_eps.numbers`. Every number below is a
key in one of those three; none is retyped from a report. Lean locations
are in the PNT+ package at pin `47fa48680663df41146704d02a5b092d792bd5b9`
(`lean_stage3/lake-manifest.json:8`); the package path is abbreviated `PKG`
for `lean_stage3/.lake/packages/PrimeNumberTheoremAnd/PrimeNumberTheoremAnd/IEANTN`.

Units throughout are `weil_QX.py`'s: `G` supported on `[-L/2, L/2]`, so
`F = G ⋆ G̃` is supported on `[-L, L]` and exactly the prime powers
`n ≤ X = e^L` enter the arithmetic side (`analysis/2026-09-01/weil_QX.py:35-37`,
entry 295 at `notes/lab_notebook_2.md:1898-1900`). `L` is the support
length; `X = e^L` is the prime-side truncation. `ε` is the off-line
distance `Re ρ − 1/2`; `γ` is the height.

## 1. The target — who consumes the conclusion, and at what height

**Nothing in this tree consumes it.** `grep -rn 'RH_up_to'` over
`lean_stage3/Stage3/`, `lean_stage3/Stage3.lean` and `lean/` returns zero
lines. Stage 3's own open leaf is a HALF-PLANE, not a rectangle:

```text
def StmtZeroFreeRight (θ : ℝ) : Prop :=
  ∀ s : ℂ, θ < s.re → s ≠ 1 → ζ s ≠ 0
```

(`lean_stage3/Stage3/Abscissa.lean:112-113`), taken as a hypothesis binder
at 20 sites across `Abscissa`, `ThetaPull`, `ThetaPsi`, `ThetaLine`,
`ThetaPi` and `ThetaConverse` (36 mentions in six modules).
No finite-height rectangle satisfies it at any `L`. **The arrow does not
feed the dial.** Its only consumers are upstream.

**Upstream, at the pin, there are fifteen.** Located by
`grep -rn 'RH_up_to' <PKG>/..` with `.lake/build` artefacts dropped; the
full table with locations is `consumers[0..14].*` in the `.numbers`. The
height each demands, and the support the height law then prices
(`consumers[i].t_req`, `.L_need_measured_eps1e-3`, `.X_need_measured_eps1e-3`):

| consumer | location | T required | L needed | X = e^L |
| --- | --- | --- | --- | --- |
| Büthe theorem_2a (ψ) | `PKG/TMEEMT.lean:157` | 18.7151 | 1.667 | 5.299 |
| Büthe theorem_2c (π\*) | `PKG/TMEEMT.lean:183` | 18.7151 | 1.667 | 5.299 |
| Büthe theorem_2b (θ) | `PKG/TMEEMT.lean:170` | 47.6156 | 3.319 | 27.63 |
| Büthe theorem_2d (π) | `PKG/TMEEMT.lean:196` | 90.3153 | 4.451 | 85.72 |
| `bklnw_thm_16` | `PKG/BKLNW/BKLNW_app.lean:1135` | 3000 | 10.646 | 4.204e4 |
| `CH2.cor_1_2_a`, `_b` | `PKG/CH2/CH2.lean:4319`, `:4333` | 1e7 | 24.993 | 7.147e10 |
| `Platt_theorem` | `PKG/ZetaSummary.lean:103` | 3.061e10 | 39.188 | 1.045e17 |
| `GW_theorem`, `BKLNW.Inputs.hH` | `PKG/ZetaSummary.lean:113`, `BKLNW_app.lean:24` | 2.446e12 | 46.936 | 2.42e20 |
| `GourdonDemichel2004.has_prime_in_interval` | `PKG/TMEEMT.lean:1303` | 2.44e12 | 46.931 | 2.41e20 |
| `PT_theorem_1` | `PKG/ZetaSummary.lean:123` | 3e12 | 47.297 | 3.473e20 |
| `FKS.Inputs.hH₀`, `Hσ_zeroes`, `eq_13` | `PKG/FioriKadiriSwidinsky/FioriKadiriSwidinsky.lean:26`, `:408`, `:418` | free | — | — |

The four Büthe rows carry `4.92 * sqrt (x / log x) ≤ T` as hypothesis, so
their `T` is a function of `x`; the table evaluates it at each theorem's
own floor in `x` (`hx : x > 59`, `599`, `59`, `2657` at `TMEEMT.lean:158`,
`:171`, `:184`, `:197`).

**The loosest conclusion that still satisfies a real consumer** is
`riemannZeta.RH_up_to 18.7151` — Büthe theorem_2a at `x` just past 59
(`loosest_consumer.t_req` 18.71509903700793, `loosest_consumer.loc`).
That height sits between `γ₁` = 14.134725141734695 (`gamma_1`) and
`γ₂` = 21.022039638771556 (`theory.k=2|eps=0.001.gamma_k`): **the loosest
real target is a rectangle containing exactly one zero ordinate.**

**All fifteen consumers are `sorry` at the pin.** `consumers_proved_at_pin`
is 0. Every one of `theorem_2a`–`2d`, `has_prime_in_interval`,
`Platt_theorem`, `GW_theorem`, `PT_theorem_1`, `bklnw_thm_16`,
`cor_1_2_a`, `cor_1_2_b`, `Hσ_zeroes` and `eq_13` closes with `sorry`; the
two `Inputs` rows are structure fields, not theorems. So discharging the
arrow today would supply a hypothesis to nothing that is itself proved.

## 2. The quantitative gap, piece by piece

Entry 302's construction (`analysis/2026-09-01/weil_Lc_theory.md`) fixes a
raised-cosine window and balances `2|B|²` against `Z_near + Z_far + beyond`
at one zero, one height, one `ε`. What separates that from an explicit
uniform `L(ε, γ)` is six pieces. Each is priced
`{literature bound | provable bound | unproved hypothesis}`.

### P1 — the Weil identity for compactly supported G · UNPROVED UPSTREAM

`StmtWeilExplicit` as entry 303 §(c) writes it
(`notes/lab_notebook_2.md:162-168`). Upstream states it:
`kadiri_thm_3_1_q1` (`PKG/Kadiri.lean:1362`), the `q = 1` case of Kadiri's
Weil-type explicit formula, and the compact-support specialisation
`identity_16_complex` (`:3224`). Neither is proved: `Kadiri.lean` carries
14 `sorry` tokens (`grep -c sorry` = 14), of which the four on the theorem's
dependency path are `:1424`, `:1444` (the two `T → ∞` limit-management
steps, annotated at `:1416`) and `:454`, `:486` (the horizontal arcs);
`identity_16_complex`'s own is `:3243`. **Price: a bound that must be
proved, at the size of the hEF arc (entries 257–271, nine modules) plus a
limit the arc never needed.**

### P2 — the far-tail bound on Z′ · LITERATURE BOUND, STATED UPSTREAM

The far tail is bounded by `∫ f dN̄ + |∫ f dR|` with
`|R(T)| ≤ Rmax(T)` (`weil_Lc_theory.md`, section 3(ii)). The bench assumed
`params.Rmax_form` = `0.137 log T + 0.443 log log T + 4.35 (assumed)`.
Upstream states exactly that Prop —
`riemannZeta.Riemann_vonMangoldt_bound b₁ b₂ b₃`
(`PKG/ZetaDefinitions.lean:149-162`) — and instantiates it as
`backlund_bound : Riemann_vonMangoldt_bound 0.137 0.443 6.1`
(`PKG/Kadiri.lean:2618`, `sorry` at `:2619`). **The first two constants
agree; the third does not** — the bench assumed 4.35 where upstream carries
6.1, so the assumed form is sharper than what upstream would supply.
Cost of the correction (`rmax_mismatch.rows[*]`): `Rmax` inflates by
1.3402 at `γ₁`, 1.2812 at `γ₁₀₀₀`, 1.2515 at `γ_N`; since `2|B|² ∝ ε²h³`,
that moves `L` by at most `rmax_mismatch.max_L_inflation_upper_bound`
1.1025×, against a fit rms residual of 0.1724 in `L`
(`fits.0.01.far_only_bound.rms_resid`). **Price: a literature bound, still
`sorry` upstream, and the bench's version of it is 1.10× optimistic —
inside its own fit noise.**

### P3 — the near-lobe cancellation · THE GENUINELY OPEN PIECE

The measured `L_c` is achieved by a numerical minimiser of the form built
from the zero list. Entry 302's reading (2) says the minimiser spends its
shape on cancelling the near lobe, by 7.66e4 in `Z′` at `k = 10` (U6,
`notes/lab_notebook_2.md:604-607`), and entry 302's closing sentence names
the next instrument as "an envelope orthogonal to the seven nearest
`Ψ(h(γ_j − γ_k))`" (`:631-634`). **That construction reads the zero
ordinates it is trying to locate.** A uniform explicit `L(ε, γ)` needs a
`G` written down without them.

The variant that IS written down without them is the fixed raised-cosine
window, `variants.full`. Its prices are 2.1–5.2× the measured
(`theory.k=1|eps=0.001.ratio_meas_over_theory` 0.1930 to
`theory.k=30|eps=0.1.ratio_meas_over_theory` 0.6232), and at `k = 1000` it
has NO root at any `ε` on the instrument's grid. The highest height at
which an explicitly-written `G` is measured to detect at all is
`fixed_window_highest_detected.gamma_k` 541.8474371212013 (k = 300,
ε = 0.1, at `theory.k=300|eps=0.1.variants.full.L_c` 10.040299585102444);
at `fixed_window_fails_at.gamma_k` 1419.4224809459956 the fixed window
fails where the zero-aware minimiser detects at
`fixed_window_fails_at.minimiser_L_c` 9.331087701519795. **Price: a
construction that does not exist. Not a hypothesis, not a bound — a
missing G-family, and the only measured surrogate stops working two
octaves above `γ₁`.**

### P4 — the lower bound on |B|² · PROVABLE, IN CLOSED FORM

For the fixed window `2|B|² = ε² h³ m2²/(m22 + C(2γh))`
(`weil_Lc_theory.md` section 3(i)) with `m2 = 1/3 − 2/π²` and
`m22 = (2 − 15/π²)/8` exact (`params.window.m2` 0.130691,
`params.window.m22` 0.0600228, U4 diff 0.0). First-order against exact
over the 24 measured rows is 0.96236 to 1.00067
(`section0_minimisers[23].first_over_exact`,
`section0_minimisers[5].first_over_exact`). **Price: a provable bound —
elementary integrals, already checked against quadrature at U1, U2, U4,
U5.**

### P5 — the prime side at the rung · PRECISION-BOUND, AND THE TOLERANCE DOES NOT HELP

Entry 296's consequence paragraph (`notes/lab_notebook_2.md:1869-1877`):
at rung `X = 3` the Connes–Consani numerics pin the prime 2 to within
`10⁻³`, so a proof of that rung "cannot bound the prime term crudely
against an archimedean margin (Bombieri Thm 12's method); it must use
log 2 to that precision." **This is the one place the crude-explicit spec
buys nothing.** The rungs the arrow needs all lie past `X = 2`
(section 3 below), and past `X = 2` the prime term is a cancellation, not
a margin: entry 295 measures `pole/prime` = 0.948 at `X = 10⁴` with the
total 0.094 sitting on terms of 784 — a four-digit cancellation
(`notes/lab_notebook_2.md:2008`). **Price: an unproved hypothesis in the
form the ladder needs it — Connes–Consani Conjecture 4.1
(`notes/lab_notebook_2.md:1813-1816`) is exactly this statement, and it is
a conjecture.**

### P6 — the ε quantifier · CHEAP, AND THIS IS THE SURPRISE

`RH_up_to T` excludes every zero with `Re ρ ∈ (0.5, 1)`, so the arrow must
detect at every `ε > 0`, and no finite `L` does. Priced, the gap is small.
Entry 299's law at `γ₁`, seven values of `ε`, is
`eps_law_gamma1.a` 0.792368024385266 + `eps_law_gamma1.b`
0.0732632723135109 · log(1/ε), R² `eps_law_gamma1.R2` 0.9917768277454492.
Extended (`eps_law_extension[*]`):

```text
  eps = 1e-01   L_c = 0.9611   X =     2.6145
  eps = 1e-03   L_c = 1.2985   X =     3.6636
  eps = 1e-06   L_c = 1.8045   X =     6.0772
  eps = 1e-10   L_c = 2.4793   X =    11.9331
  eps = 1e-20   L_c = 4.1663   X =    64.4743
  eps = 1e-50   L_c = 9.2271   X = 10169.1505
```

Excluding `γ₁` at every `ε` down to `10⁻¹⁰` costs `X` = 11.93 — inside the
range Connes–Consani's numerics have already tested (λ² ~ 11, entry 296).
**Price: the quantifier is a cost of 0.073 in `L` per e-fold in `1/ε` at
`γ₁`, and the ε → 0 limit is the only part of it that is genuinely
infinite.** Consumer tolerance removes even that limit: see section 3.

## 3. The crude-constant budget

The height law from entry 301's measurements, per `ε`
(`laws.measured.<eps>.{a,b,R2,n}`):

```text
  eps=0.001   a -3.5132  b 1.7686  R2 0.9934  n 8
  eps=0.01    a -2.9408  b 1.4772  R2 0.9948  n 8
  eps=0.1     a -2.6937  b 1.3159  R2 0.9921  n 8
```

`L = a + b log T`, so **`X = e^L = e^a · T^b`**: `a` is a prefactor, `b` is
an exponent. That inverts entry 130's usual finding. There the budget was
a factor 70–700 on a multiplicative constant and the leaf was free
(`notes/lab_notebook_2.md:11880-11885`). Here a factor 70 on the prefactor
buys `Δa = 4.248`, which at `T = 3e12` moves `X` from 3.473e20 to 2.431e22
— affordable. A factor of 1.1 on `b` moves `X` at the same `T` from
3.473e20 to 5.589e22, and a factor of 2 moves it to 4.047e42
(`constant_sensitivity[4].*`). Across all twelve (variant, ε) cells `b`
ranges over `b_range.min` 0.6072608975189738 to `b_range.max`
3.192722125209896, which at `T = 3e12` is `X` between
`b_range.X_at_3e12_min` 1124849.07 and `b_range.X_at_3e12_max` 2.043e38.
**The exponent is the load-bearing constant and its measured uncertainty
spans 32 orders of magnitude in `X`.**

### Where the arrow is vacuous

`L_vac = a + b log γ₁`: below it the conclusion excludes nothing, because
there is no zero of height ≤ γ₁ (`vacuity_threshold.*`):

```text
  variant           eps=0.001   eps=0.01   eps=0.1
  measured             1.1710     0.9718    0.7917
  far_only_bound       3.9953     2.4397    1.3935
  far_only_exact       2.5796     1.5677    0.7939
  full                 6.6511     4.7200    2.8707
```

**The entire proved literature is below every one of these.** Positivity
at support `L = log 2` = 0.6931 is a theorem independent of RH — Yoshida
Lemma 2 / Theorem 1 at `a ≤ log 2/2`, Bombieri Theorem 12 for
`|I| < log 2`, Burnol, Connes–Consani Theorem 1, Suzuki Theorem 1.4
(entry 296's Answer (b), `notes/lab_notebook_2.md:1850-1856`). At that
`L` the arrow reaches `rungs[0].T_reach.0.001` 10.7879,
`.0.01` 11.7045, `.0.1` 13.1150 — all three below `γ₁` = 14.1347, all
three `rungs[0].vacuous_at_eps.*` true. **Every proved rung is vacuous,
and the reason is arithmetic: `X = 2` is exactly where the first prime
enters at weight zero.**

The measured first non-vacuous rungs (`k1_measured[*]`, direct
measurements at `γ₁`, not the regression):

```text
  eps = 0.001   L_c = 1.2835   X = 3.6094   dL from log 2 = +0.5904
  eps = 0.01    L_c = 1.1387   X = 3.1228   dL from log 2 = +0.4456
  eps = 0.1     L_c = 0.9597   X = 2.6110   dL from log 2 = +0.2666
```

**The gap between everything proved and the first rung that says anything
is 0.2666 in `L`** — `X` from 2 to 2.611, which does not reach the second
prime.

### Where the arrow beats a consumer

At `ε = 10⁻³` the loosest consumer (`T` = 18.7151) needs
`consumers[0].L_need_measured_eps1e-3` 1.6674566170815415, i.e.
`consumers[0].X_need_measured_eps1e-3` 5.298674087455248 — three primes.
`CH2.cor_1_2_a` (`T` = 1e7) needs `L` 24.993, `X` 7.147e10.
`Platt_theorem` needs `L` 39.188, `X` 1.045e17.

### The ε budget the consumers actually have

A zero at `1/2 + ε` of height ≤ `T` inflates its own term in the explicit
formula by `x^ε`; requiring `x^ε ≤ K` gives `ε_max = log K / log x`,
capped at 1/2 (`eps_budget[*]`). Entry 130's scale is `K` = 70–700:

```text
  x        T = 4.92 sqrt(x/log x)   eps(K=2)   eps(K=70)   eps(K=700)
  59                     18.7151     0.16999    0.50000*    0.50000*
  1e3                    59.1966     0.10034    0.50000*    0.50000*
  1e6                    1323.68     0.05017     0.30752     0.47418
  1e9                    34177.2     0.03345     0.20501     0.31612
  1e12                    935980     0.02509     0.15376     0.23709
  1e19                2.35223e+09    0.01584     0.09711     0.14974
  * capped at 1/2 -- the consumer tolerates any zero in the strip
```

and the support that `ε` then costs, at that `T`
(`eps_budget_support[*].L`, `.X`, variant `measured`):

```text
  x        T             L(K=2)    X        L(K=70)   X        L(K=700)  X
  59       18.7151        1.093    2.985      0.975    2.651     0.975    2.651
  1e3      59.1966        2.641   14.03       2.283    9.806     2.283    9.806
  1e6      1323.68        7.028    1128       6.070    432.7     5.841    344.2
  1e9      34177.2       11.800   1.333e5    10.263   2.865e4    9.896   1.984e4
  1e12     935980        16.778   1.935e7    14.651   2.306e6   14.143   1.387e6
  1e19     2.35223e+09   28.868   3.447e12   25.346   1.017e11  24.504   4.386e10
```

The two capped cells evaluate the height law at `ε` = 1/2, five times the
instrument's largest measured `ε`. The loosest consumer's target
`T` = 18.7151 priced at each `ε`, with the distance to the proved rung
(`loosest_consumer_by_eps.rows[*]`):

```text
  eps = 0.5     L = 0.9748   X = 2.6507   dL from log 2 = +0.2817  EXTRAPOLATED
  eps = 0.1     L = 1.1518   X = 3.1639   dL from log 2 = +0.4587
  eps = 0.01    L = 1.4050   X = 4.0755   dL from log 2 = +0.7119
  eps = 0.001   L = 1.6582   X = 5.2499   dL from log 2 = +0.9651
```

**At `K` = 70 and `x` = 59 the required support falls to `L` = 0.9748,
`X` = 2.6507; at the largest measured `ε` = 0.1 it is `L` = 1.1518,
`X` = 3.1639.** The tolerance moves the target into the gap between the
proved rung and the first measured non-vacuous one, and no further: it
does not reach `log 2` = 0.6931.

The same table at the fixed explicit window (`eps_budget_support_full`)
runs the other way at large `x` — `L` = 50.745 at `x` = 1e19, `K` = 70,
against 25.346 for the minimiser — because the `full` variant's `b` grows
with `ε` rather than falling (`surfaces.full.B1` −0.3009 on a two-point fit
at ε = 0.001). That column is not to be trusted; see section 5.

## 3b. The upstream race — nothing is discharged for free

Per the Stage-3 convention that leaves double as watch targets
(`CLAUDE.md:173-176`). In the package directory,
`git fetch origin` returned exit 0 with `FETCH_HEAD` written today, and
`git log --oneline 47fa486..origin/main` lists five commits, `a515467`
(2026-08-30 13:45:29 −0700, the current `origin/main`) back to `c6c7361`.
`git log --format='%h %s%n%b' 47fa486..origin/main` grepped case-insensitively
for `weil|explicit|positiv|criterion|fourier` returns **nothing** (exit 1).
`git diff --name-only 47fa486..origin/main` touches three files:
`.github/workflows/build.yml`, `IEANTN/Dusart.lean`, `IEANTN/TMEEMT.lean`.

`grep -rniE 'weil' --include='*.lean'` over the whole package returns two
lines, both in `Kadiri.lean` (`:80`, `:1319`), both naming the Weil-type
explicit formula. **There is no statement of a Weil positivity criterion
upstream in either direction, and nothing since the pin has moved toward
one.** Entry 303's count of five commits over this range is reproduced
today.

The one leaf that a pin bump could discharge is P2: `backlund_bound`
(`PKG/Kadiri.lean:2618`) is the whole content of the far-tail bound's
`Rmax`, and it is `sorry` at `:2619` — the same watch target entries 130
and 274 name.

## 4. Bottom line

**The piece that is genuinely open is P3, and the tolerance does not help
it.** Four of the six pieces are priced inside reach: P4 is elementary and
already quadrature-checked; P2 is a literature bound stated upstream, and
the bench's version of it is 1.10× optimistic, inside its own fit noise;
P6, the quantifier that looked fatal, costs 0.073 in `L` per e-fold in
`1/ε` at `γ₁` and is removed outright by the consumer's own `x^ε`
tolerance; P1 is a proof at a known size (the hEF arc plus a limit) whose
statement exists upstream. P5 and P3 are different in kind. P5 is
Connes–Consani Conjecture 4.1 and the crude-explicit spec buys nothing
against it, because past `X = 2` the prime side is a four-digit
cancellation rather than a margin. P3 has no statement at all: every
measured `L_c` in entries 299–302 was attained by a minimiser built from
the zero list, and the one `G` written down independently of the zeros —
the raised-cosine window — costs 2.1–5.2× more support and stops detecting
entirely at `γ₁₀₀₀`.

The tolerance measurement changes the target and does not close it. The
loosest real consumer wants a rectangle to `T` = 18.7151, one zero
ordinate; at `K` = 70 that costs `L` = 0.9748 (`ε` capped at 1/2, past the
instrument's range) or `L` = 1.1518 at the largest measured `ε` = 0.1; the
proved literature stands at `L` = log 2 = 0.6931, `X` = 2. **The remaining
distance is between 0.2817 and 0.4587 in `L`, and it is exactly the step of
admitting the prime 2 at nonzero weight** — the step entry 296 records as
needing `log 2` to `10⁻³`.

Stated positively: the arrow at the loosest useful precision needs six
pieces, of which one (P4) is available, one (P2) is available as an
upstream statement awaiting its proof, one (P6) is dischargeable by the
consumer's own tolerance, one (P1) is a known-size build, and two (P3, P5)
are open — P5 as a published conjecture, P3 as a construction nobody has
written down.

## 5. The three weakest points of this census

1. **The height law is a regression on eight points and is extrapolated
   twenty-three e-folds.** The measured `b` at `ε = 10⁻³` is 1.7686 over
   `γ` from 14.13 to 1419.42, `log γ` spanning 2.649 to 7.258
   (`fits.0.001.measured.n` 8, R² 0.9934). Every `T` past 1e4 in section 1
   is outside that range, and `Platt_theorem`'s `L` = 39.188 rests on
   extrapolating `log T` to 24.15 — more than three times the fitted span.
   The bilinear surface reproduces the 24 measured rows at rms
   `surface_validation.rms_resid` 0.2050 and max
   `surface_validation.max_abs_resid` 0.4678, which is honest inside the
   grid and says nothing outside it.

2. **The `full` variant's fits are two- and six-point.**
   `fits.0.001.full.n` is 2 with R² 1.0 — two points — and
   `fits.0.01.full.n` is 6 at R² `fits.0.01.full.R2` 0.6866. P3's price is
   the most load-bearing claim in this census and it stands on the worst
   fits in the file. The `eps_budget_support_full` table inherits that and
   its large-`x` column is not usable.

3. **The `x^ε` tolerance in P6 and section 3 is my arithmetic, not a
   theorem in this tree.** The inflation of a zero's term by `x^ε` is the
   standard shape of the explicit formula's zero sum, but no consumer in
   the pinned package is stated with a notched rectangle — every one takes
   `riemannZeta.RH_up_to T` literally (`PKG/ZetaDefinitions.lean:116-117`),
   and all fifteen are `sorry`. Cashing the tolerance means writing a new
   Stmt and re-proving a consumer that has never been proved. The budget
   table is a measurement of what a re-proof could afford, not of anything
   that exists.
