> Source: session transcript, 2026-11-22, after reading Alpöge's note and the archive it names

> Do 2 with 1 alongside

1, from the assistant's message before it: "Measure `G` on your bench, exploratory."

From Alpöge's archive, `lean/src/Development/AutomorphicArithmetic/DedekindLFunctions/CharFamily.lean`, the function measured:

```
def G (y : ℝ) : ℝ :=
  (ramp (fun _ => 1) y).re - y * Real.log y + (1 + Real.eulerMascheroniConstant) * y
```

and from `LandauTheorems/ZeroFreeOfRpowWindow.lean`, the hypothesis whose windows are read off:

```
    (h : ∀ Y₀ : ℝ, ∃ Y : ℝ, Y₀ ≤ Y ∧ ∀ y ∈ Set.Icc Y (Y ^ (1 + δ)), Gm F y ≤ C * y ^ θ) :
```
