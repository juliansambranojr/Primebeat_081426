# Sixth Addendum — the radius/rotation split, and a clean negative

**Doc ID:** DT-A6 · **Version:** 1.0 · **Stamped:** 2026-08-14
**Author:** Julian Sambrano
**Adversarial review:** Claude (Anthropic)
**Reads with:** `dyadic-table-v2.md`, DT-A, DT-A2, DT-A3, DT-A4, DT-A5.
**Accompanies:** `O3_collapse_radius_vs_rotation.py`,
`O3b_rebounds_and_oscillating_fit.py`
**Records:** one structural reframe that holds, and one consequence of it that
does not.

---

## 0. What this document is

DT-A5 recorded a result nobody predicted: §7.1's comb filter is the spectrum of
Δ*Δ. This document records the reframe that followed from it, and the test
that reframe suggested — which came back negative, three times, under three
controls.

The negative is the useful part. The series' recurring failure mode is
**reaching a conclusion and then selecting the support for it** (DT-A4 §6).
This is the first entry where a proposed mechanism was tested before it was
written up, failed, and is being recorded as failed with the controls attached.

One over-claim was made mid-session and is recorded in §3.2 rather than
quietly dropped.

---

## 1. The split, which is algebra

At x = 2^r, a zero ρ = β + iγ contributes

```
x^rho  =  2^(beta*r)  ·  exp(i * gamma * r * ln2)
          \_________/     \____________________/
            RADIUS               ROTATION
```

This is an identity, not a model. Every measurement the table performs is one
of the two, and separating them reorganizes results that were previously filed
apart:

| quantity | which | where |
|---|---|---|
| the 2^(r/2) periodogram normalization | divides out the **radius** | DT-A3 §1, DT-A4 §4.3 |
| ω = γ·ln2 mod 2π, comb-filter passband | **rotation** rate per regime | v2.0 §7.1 |
| aliasing of zeros 6 and 22 | rotations differing by a full turn | v2.0 §7.1 |
| annihilation at γ ≈ 9.065k | whole turns per regime | v2.0 §7.1 |
| the monotone drift 2.7343 → 2.6549 | **rotation** measurement degrading | DT-A4 §4.3 |
| the growth exponent α | the **radius** exponent β | v2.0 §7.3 |

**Two consequences worth stating.**

**(a)** DT-A4 §4.3 flagged the 2^(r/2) normalization as "presuming RH's
exponent" and left it as an unresolved caveat. It is now exact: dividing by the
radius is what puts the sequence on the unit circle so the periodogram can read
rotation rate. What it presumes is precisely Re(ρ) = 1/2, and the reason the
periodogram pipeline cannot constrain Re(ρ) is that the quantity is cancelled
in step one.

**(b)** v2.0 §7.3's α is filed under "fitted constants, range-dependent." Under
the split it is **the table's empirical estimate of Re(ρ)**, obtained with no
normalization assumed. Its drift — 0.350 at r ≤ 40, **0.4334** at r ≤ 60 — is
that measurement converging toward 1/2 as the range extends.

Neither of these is a new computation. Both are relabelings of existing
results, and the relabeling is what the split buys.

---

## 2. The test the split suggested

DT-A §5.3 closed off the "displaced depth-10 zero" reading by observing that
past r = 33 the ratio |Δᵈe| / Δᵈs collapses — 0.976, 0.453, 0.085, 0.029,
0.0007. That refutation stands and is not revisited here. But the **collapse
itself** was only observed, never explained.

Under the split it has a prediction with no free parameter:

```
|D^d e|  ~  2^(alpha*r)          (radius, alpha < 1)
D^d s    ~  2^r / r              (smooth, from li)

=>  ratio(r+1)/ratio(r)  =  2^-(1-alpha) * r/(r+1)   ~=  0.675 per regime
```

If the observed decay matches that, geometrically and steadily, the collapse is
pure radius — envelope, instrument, fully explained. If it is faster and
erratic, something depth-specific is acting, and the candidate is the
**rotation**: cos(γ r ln2 + φ) passing through zero depresses the ratio at
particular r regardless of the envelope.

Discriminator: does the residual (observed decay − predicted) track the
rotation phase ω₁·r mod 2π?

---

## 3. Three negatives

### 3.1 O3 — phase coupling

Run on the author's hardware, depths 1–10, 120 regime-steps, r ≤ 45.

```
corr(residual, cos(omega_1 * r)) = +0.0239
corr(residual, sin(omega_1 * r)) = -0.0988
combined amplitude               =  0.1017

CONTROL, 2000 random-phase trials:
  null mean 0.1273, 95th percentile 0.1689
  p(null >= observed) = 0.8525
```

**Negative.** The residual does not track rotation phase.

### 3.2 O3b Test A — rebounds, and an over-claim

The raw ratios are visibly non-monotone. Depth 6 reads 1.000, 0.960, 0.670,
0.336, 0.101, 0.021, then **rebounds** to 0.042, 0.066 before falling again.
Counting across all depths: **38 of 120 steps are rebounds.**

The claim made at that moment, before any control was run, was that *pure
envelope decay predicts zero rebounds.* **That claim is wrong.** It holds for
noiseless decay only. Under lognormal noise at the observed scale:

```
null mean rebounds  : 4.16 per 12 steps
observed            : 3.80 per 12 steps
p(null >= observed) = 0.7325
```

The observed rate is **lower** than noise produces. No signal. Recorded here
rather than dropped because the shape is the one the series exists to catch: a
statistic computed, a conclusion drawn, the control run afterward.

### 3.3 O3b Test B — the oscillating fit

Fitting envelope × |cos(ωr + φ)| against a pure exponential improves R² by
**+0.1736** on average across ten depths, and the fitted frequencies appear to
cluster — depths 2, 6, 8, 9 give 2.435, 2.450, 2.505, 2.595 against ω₁'s
aliased value of 2.7689.

Control: the same fit on pure monotone decay plus noise, 60 trials.

```
null mean improvement +0.0890,  95th percentile +0.1552
observed              +0.1736                 p = 0.050

null fitted frequencies: mean 1.8369, sd 0.8033
real fitted frequencies: mean 1.3200, sd 0.9724
```

Marginal at best — the improvement sits on the null's 95th percentile. And the
frequency scatter is **statistically indistinguishable from noise**, so the
apparent clustering near ω₁ is what four fitted parameters produce against
thirteen points.

**Negative.**

---

## 4. What this settles

**Standing.**

- The radius/rotation split (§1). It is an identity and is unaffected by any of
  these results.
- The relabelings in §1(a) and §1(b). Both are readings of existing fits.
- DT-A5's finding that §7.1's comb filter is the spectrum of Δ*Δ.
- DT-A §5.3's refutation of the triangular reading, unchanged.

**Not standing.**

- The proposal that the boundary collapse is the zeros' rotation passing
  through zero. Three tests, three controls, three negatives.
- With it, the mechanism that had been offered for the author's T₄ occlusion
  reading. That reading is now without a mechanism again, and DT-A §5.3's
  original account — envelope decay, nowhere to displace to — is what the data
  supports.

**Honest limits on the negative.** α is a fitted, range-dependent constant.
Adjacent regimes share cells, so the 120 steps are not 120 independent draws.
Only γ₁'s phase was tested, and §7.1 shows γ₁ dominates strongly at depth 6 but
less so elsewhere — a test using each depth's own dominant zero would be
sharper and was not run.

---

## 5. Reproduction

```
pip install mpmath numpy primecountpy
python3 O3_collapse_radius_vs_rotation.py
python3 O3b_rebounds_and_oscillating_fit.py
```

r ≤ 45 suffices; the deepest boundary used is d = 10 at r = 33 and the collapse
is fully visible within twelve regimes. Counts are exact integers and cached;
the only floating point is in the ratio, the fit, and the controls.

---

## 6. Amendment log addition

| target | correction | in |
|---|---|---|
| v2.0 §3.2, §7.1 | Δ not self-adjoint under any weight; §7.1's comb is the spectrum of Δ\*Δ | DT-A5 |
| v2.0 §7.3; DT-A4 §4.3 | α is the radius exponent; the 2^(r/2) normalization divides the radius out — relabeled, not recomputed | **DT-A6 §1** |
| DT-A §5.3 | the collapse remains envelope decay; the rotation mechanism is tested and fails | **DT-A6 §3** |
