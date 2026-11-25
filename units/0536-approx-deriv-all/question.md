> Source: session transcript, 2026-11-25

> Yes to all of it please



From `lean_stage3/Stage3/ApproxDerivAll.lean`, the pinned statements:

```
theorem ibp_iter_chain {a b l : ℝ} (hl : l ≠ 0) (j : ℕ) :
    ∀ F : ℕ → ℝ → ℂ, (∀ k < j, ∀ t, HasDerivAt (F k) (F (k + 1) t) t) →
      IntervalIntegrable (F j) volume a b → (∀ k < j, F k a = 0) → (∀ k < j, F k b = 0) →
        ∫ t in a..b, F 0 t * eL l t =
          (1 / ((l : ℂ) * I)) ^ j * ∫ t in a..b, F j t * eL l t :=
```

```
theorem ibp_iter {F : ℝ → ℂ} {a b l : ℝ} (hl : l ≠ 0) (j : ℕ) (hF : ContDiff ℝ j F)
    (ha : ∀ k < j, iteratedDeriv k F a = 0) (hb : ∀ k < j, iteratedDeriv k F b = 0) :
    ∫ t in a..b, F t * eL l t =
      (1 / ((l : ℂ) * I)) ^ j * ∫ t in a..b, iteratedDeriv j F t * eL l t :=
```

```
theorem hasDerivAt_tauK_line (h w₀ e : ℂ) (k n : ℕ) (t : ℝ) (hp : (n : ℂ) + (w₀ + t * e) ≠ 0)
    (hq : (n : ℂ) + (w₀ + t * e) + h ≠ 0) :
    HasDerivAt (fun t : ℝ => tauK k h (w₀ + t * e) n) (e * tauK (k + 1) h (w₀ + t * e) n) t :=
```

```
theorem norm_tauK_le {h w : ℂ} {a Y : ℝ} (ha : 0 < a) (hY : 0 ≤ Y) (h1 : a ≤ w.re)
    (h2 : a ≤ (w + h).re) (h3 : Y ≤ |w.im|) (h4 : Y ≤ |(w + h).im|) (k n : ℕ) :
    ‖tauK k h w n‖ ≤ ((k + 1).factorial : ℝ) * ‖h‖ * 2 ^ (k + 2) * (1 / (a + Y)) ^ k *
      (1 / ((n : ℝ) + (a + Y)) ^ 2) :=
```

```
theorem dYk_hasDerivAt {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) (k : ℕ) (t : ℝ) :
    HasDerivAt (fun t => dYk α β k t s) (dYk α β (k + 1) t s) t :=
```

```
theorem dYk_contDiff {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) (n : ℕ) : ∀ k : ℕ, ContDiff ℝ n (fun t => dYk α β k t s) :=
```

```
theorem iteratedDeriv_dY {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) (k : ℕ) :
    iteratedDeriv k (fun t => dY α β t s) = fun t => dYk α β k t s :=
```

```
theorem dY_contDiff {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) : ContDiff ℝ ∞ (fun t => dY α β t s) :=
```

```
theorem dYk_bound {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ}
    (hσ0 : -(1 / 4) ≤ σ) (k : ℕ) {t : ℝ} (ht : 1 ≤ t) (y : ℝ) :
    t ^ (k + 1) * ‖dYk α β k t (σ + y * I)‖ ≤ Dk k * (1 + |σ|) * (1 + |y|) ^ (k + 2) :=
```

```
theorem dY_iter_bound {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ}
    (hσ0 : -(1 / 4) ≤ σ) (k : ℕ) {t : ℝ} (ht : 1 ≤ t) (y : ℝ) :
    t ^ (k + 1) * ‖iteratedDeriv k (fun t => dY α β t (σ + y * I)) t‖ ≤
      Dk k * (1 + |σ|) * (1 + |y|) ^ (k + 2) :=
```

```
theorem leib_bound (D : ℕ → ℝ) (hD : ∀ m, 0 ≤ D m) (J : ℕ) :
    ∃ M : ℝ, 0 ≤ M ∧ ∀ (H d : ℕ → ℂ) (G a q : ℝ), 1 ≤ a → 0 ≤ q → ‖H 0‖ ≤ G →
      (∀ j, H (j + 1) = ∑ i ∈ Finset.range (j + 1), (j.choose i : ℂ) * H i * d (j - i)) →
      (∀ m, ‖d m‖ ≤ D m * a * q ^ (m + 1)) → ∀ i ≤ J, ‖H i‖ ≤ G * M * (a * q) ^ i :=
```

```
theorem gY_contDiff {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) (n : ℕ) : ContDiff ℝ n (fun t => gY α β t s) :=
```

```
theorem gY_iter_succ {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) (j : ℕ) (t : ℝ) :
    iteratedDeriv (j + 1) (fun t => gY α β t s) t = ∑ i ∈ Finset.range (j + 1),
      (j.choose i : ℂ) * iteratedDeriv i (fun t => gY α β t s) t * dYk α β (j - i) t s :=
```

```
theorem gY_iter_bound {σ : ℝ} (hσ0 : -(1 / 4) ≤ σ) (j : ℕ) :
    ∃ M : ℝ, 0 ≤ M ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t → ∀ y : ℝ,
      ‖iteratedDeriv j (fun t => gY α β t (σ + y * I)) t‖ ≤
        ‖gY α β t (σ + y * I)‖ * M * ((1 + |σ|) * (1 + |y|) ^ 2 / t) ^ j :=
```

```
theorem VYk_hasDerivAt {σ : ℝ} (hσ0 : -(1 / 4) ≤ σ) (hσ : σ ≠ 0) {α β : ℂ}
    (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {x : ℝ} (hx : 0 < x) (j : ℕ) (t₀ : ℝ) :
    HasDerivAt (fun t => VYk α β j σ x t) (VYk α β (j + 1) σ x t₀) t₀ :=
```

```
theorem VYk_line_bound {σ : ℝ} (hσ0 : -(1 / 4) ≤ σ) (hσ : σ ≠ 0) (j : ℕ) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t →
      ∀ x : ℝ, 0 < x →
        ‖(t : ℂ) ^ j * VYk α β j σ x t‖ ≤
          C * (1 + 1 / ‖α + β‖ ^ 2) * ((t / (2 * Real.pi)) ^ σ * x ^ (-σ)) :=
```

```
theorem VYk_lines {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hαβ : α + β ≠ 0)
    {x : ℝ} (hx : 0 < x) {c A : ℝ} (hc : 0 < c) (hA : 0 < A) (j : ℕ) :
    ∀ y : ℝ, 1 ≤ y → VYk α β (j + 1) c x y = VYk α β (j + 1) A x y ∧
      VYk α β (j + 1) c x y = VYk α β (j + 1) (-(1 / 4)) x y :=
```

```
theorem iteratedDeriv_VY_all {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {x : ℝ}
    (hx : 0 < x) {c : ℝ} (hc : 0 < c) (j : ℕ) :
    iteratedDeriv j (fun t => VY α β c x t) = fun t => VYk α β j c x t :=
```

```
theorem VY_contDiff {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {x : ℝ}
    (hx : 0 < x) {c : ℝ} (hc : 0 < c) : ContDiff ℝ ∞ (fun t => VY α β c x t) :=
```

```
theorem VY_iter_bound {j : ℕ} (hj : 1 ≤ j) {A : ℝ} (hA : 0 < A) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 →
      ∀ t : ℝ, 1 ≤ t → ∀ x : ℝ, 0 < x → ∀ c : ℝ, 0 < c →
        ‖(t : ℂ) ^ j * iteratedDeriv j (fun t => VY α β c x t) t‖ ≤
          C * (1 + 1 / ‖α + β‖ ^ 2) * (1 + x / t) ^ (-A) :=
```

