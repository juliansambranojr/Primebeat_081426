> Source: session transcript, 2026-09-09, after unit 0369

> Just checking to make the builder didn't get stuck

> What do you think?

From `lean_stage3/Stage3/IndicatorContDiff.lean`, the pinned statement:

```
theorem contDiff_one_indicator_Icc {a b : ℝ} (hab : a ≤ b) {f : ℝ → ℝ}
    (hf : ContDiff ℝ 1 f) (ha : f a = 0) (hb : f b = 0)
    (hda : deriv f a = 0) (hdb : deriv f b = 0) :
    ContDiff ℝ 1 (Set.indicator (Set.Icc a b) f)
```
