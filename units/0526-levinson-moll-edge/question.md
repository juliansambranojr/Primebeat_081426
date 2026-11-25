> Source: session transcript, 2026-11-24

> Log and the mollifies edge terms



From `lean_stage3/Stage3/LevinsonMollEdge.lean`, the pinned statements:

```
theorem molli_sub_one_le {M : ℕ} {β : ℕ → ℂ} {B : ℝ} (hβ1 : β 1 = 1)
    (hβ : ∀ h, ‖β h‖ ≤ B) (hM : 1 ≤ M) {X : ℝ} {s : ℂ} (hs : s.re = X) (hX : 0 ≤ X) :
    ‖molli M β s - 1‖ ≤ M * B / (2 : ℝ) ^ X :=
```

```
theorem f_sub_one_le {c : ℝ} (hc0 : 0 ≤ c) (hc1 : c ≤ 1) {M : ℕ} (hM : 1 ≤ M)
    {β : ℕ → ℂ} {B : ℝ} (hβ1 : β 1 = 1) (hβ : ∀ h, ‖β h‖ ≤ B) {X : ℝ} (hX : 3 ≤ X)
    {s : ℂ} (hs : s.re = X) :
    ‖(riemannZeta s + c * deriv riemannZeta s) * molli M β s - 1‖ ≤ tailDelta M B X :=
```

```
theorem right_log_term_le {c : ℝ} (hc0 : 0 ≤ c) (hc1 : c ≤ 1) {M : ℕ} (hM : 1 ≤ M)
    {β : ℕ → ℂ} {B : ℝ} (hβ1 : β 1 = 1) (hβ : ∀ h, ‖β h‖ ≤ B) {X a b : ℝ} (hX : 3 ≤ X)
    (hXMB : 32 * M * B ≤ (2 : ℝ) ^ X) (hab : a ≤ b) :
    -(∫ t in a..b, Real.log ‖(riemannZeta (↑X + ↑t * I) + c * deriv riemannZeta (↑X + ↑t * I))
        * molli M β (↑X + ↑t * I)‖)
      ≤ (b - a) * (2 * tailDelta M B X) :=
```

```
theorem right_arg_term_le {c : ℝ} (hc0 : 0 ≤ c) (hc1 : c ≤ 1) {M : ℕ} (hM : 1 ≤ M)
    {β : ℕ → ℂ} {B : ℝ} (hβ1 : β 1 = 1) (hβ : ∀ h, ‖β h‖ ≤ B) {X a b : ℝ} (hX : 3 ≤ X)
    (hXMB : 32 * M * B ≤ (2 : ℝ) ^ X) (hab : a ≤ b) :
    |(∫ t in a..b, logDeriv (fun s => (riemannZeta s + c * deriv riemannZeta s) * molli M β s)
      (↑X + ↑t * I)).re| ≤ Real.pi :=
```

```
theorem right_terms_le {c : ℝ} (hc0 : 0 ≤ c) (hc1 : c ≤ 1) {M : ℕ} (hM : 1 ≤ M)
    {β : ℕ → ℂ} {B : ℝ} (hβ1 : β 1 = 1) (hβ : ∀ h, ‖β h‖ ≤ B) {X σ₀ a b : ℝ} (hX : 3 ≤ X)
    (hXMB : 32 * M * B ≤ (2 : ℝ) ^ X) (hσX : σ₀ ≤ X) (hab : a ≤ b) :
    -(∫ t in a..b, Real.log ‖(riemannZeta (↑X + ↑t * I) + c * deriv riemannZeta (↑X + ↑t * I))
        * molli M β (↑X + ↑t * I)‖)
      + (X - σ₀) * (∫ t in a..b, logDeriv
          (fun s => (riemannZeta s + c * deriv riemannZeta s) * molli M β s) (↑X + ↑t * I)).re
      ≤ (b - a) * (2 * tailDelta M B X) + (X - σ₀) * Real.pi :=
```

```
theorem real_zero_count_gen {g : ℂ → ℂ} {m M r R : ℝ} (hr0 : 0 < r) (hrR : r < R)
    (hR1 : R < 1)
    (hd : DifferentiableOn ℂ g (Metric.ball (0 : ℂ) (11 / 10))) (hm : 0 < m)
    (h0 : m ≤ (g 0).re) (hM : ∀ z : ℂ, ‖z‖ ≤ R → ‖g z‖ ≤ M) :
    ∃ Z : Finset ℝ, (∀ x : ℝ, |x| ≤ r → (g x).re = 0 → x ∈ Z) ∧
      (Z.card : ℝ) ≤ 1 / Real.log (R / r) * Real.log (M / m) :=
```

```
theorem edge_le_gen {F : ℂ → ℂ} {X T Mf σ : ℝ} (hX : 1 ≤ X) (hXT : 2 * X ≤ T)
    (hFa : ∀ w : ℂ, w ≠ 1 → AnalyticAt ℂ F w)
    (h0 : 1 / 2 ≤ (F (↑X + ↑T * I)).re)
    (hM : ∀ w : ℂ, ‖w - (↑X + ↑T * I)‖ ≤ X - 1 / 8 → ‖F w‖ ≤ Mf)
    (hσ : 1 / 4 ≤ σ) (hσX : σ ≤ X)
    (hne : ∀ x ∈ Set.Icc σ X, F (↑x + ↑T * I) ≠ 0) :
    |edgeH F X T σ| ≤ Real.pi * ((8 * X - 1) * Real.log (2 * Mf) + 1) :=
```

```
theorem horizontal_terms_le {c : ℝ} (hc0 : 0 ≤ c) (hc1 : c ≤ 1) {M : ℕ} (hM : 1 ≤ M)
    {β : ℕ → ℂ} {B : ℝ} (hβ1 : β 1 = 1) (hβ : ∀ h, ‖β h‖ ≤ B) {X σ₀ T : ℝ} (hX : 3 ≤ X)
    (hXMB : 32 * M * B ≤ (2 : ℝ) ^ X) (hσ₀ : 1 / 4 ≤ σ₀) (hσX : σ₀ ≤ X) (hXT : 2 * X ≤ T)
    (hne : ∀ x ∈ Set.Icc σ₀ X, (riemannZeta (↑x + ↑T * I) + c * deriv riemannZeta (↑x + ↑T * I))
      * molli M β (↑x + ↑T * I) ≠ 0) :
    |∫ σ in σ₀..X, edgeH (fun s => (riemannZeta s + c * deriv riemannZeta s) * molli M β s)
        X T σ|
      ≤ (X - σ₀) * (Real.pi * ((8 * X - 1)
          * (Real.log T + Real.log M + Real.log B + 8) + 1)) :=
```

