> Source: session transcript, 2026-11-25

> Yes to all and we will take your recommendation



From `lean_stage3/Stage3/Diagonal.lean`, the pinned statements:

```
theorem diag_reindex {h k : ℕ} (hh : 1 ≤ h) (hk : 1 ≤ k) (F : ℕ → ℕ → ℂ) :
    ∑' p : ℕ × ℕ, (if h * (p.1 + 1) = k * (p.2 + 1) then F (p.1 + 1) (p.2 + 1) else 0) =
      ∑' l : ℕ, F (k / Nat.gcd h k * (l + 1)) (h / Nat.gcd h k * (l + 1)) :=
```

```
theorem ell_sum {α β : ℂ} {t c : ℝ} (hc : 0 < c) (hu : 0 < 1 / 2 + α.re + c)
    (hv : 0 < 1 / 2 + β.re + c) (hw : 0 < α.re + β.re + 2 * c) {A B : ℕ} (hA : 1 ≤ A)
    (hB : 1 ≤ B) :
    ∑' l : ℕ, ((A * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + α)) * ((B * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + β)) *
        VY α β c (((A * (l + 1) : ℕ) : ℝ) * ((B * (l + 1) : ℕ) : ℝ)) t =
      VerticalIntegral' (fun s => KY α β t s * (riemannZeta (1 + α + β + 2 * s) *
        ((A : ℂ) ^ (-(1 / 2 + α + s)) * (B : ℂ) ^ (-(1 / 2 + β + s))))) c :=
```

```
theorem joint_integrable {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10)
    (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ} (hσ0 : -(2 / 5) < σ) (hσ : σ ≠ 0) {Z : ℂ → ℂ}
    (hZc : Continuous fun y : ℝ => Z (σ + y * I)) {K : ℝ}
    (hZ : ∀ y : ℝ, ‖Z (σ + y * I)‖ ≤ K * Real.exp (2 * |y|)) :
    Integrable (fun p : ℝ × ℝ => (W.w p.1 : ℂ) * (KY α β p.1 (σ + p.2 * I) * Z (σ + p.2 * I)))
      (volume.prod volume) :=
```

```
theorem wVI_swap {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10)
    (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ} (hσ0 : -(2 / 5) < σ) (hσ : σ ≠ 0) {Z : ℂ → ℂ}
    (hZc : Continuous fun y : ℝ => Z (σ + y * I)) {K : ℝ}
    (hZ : ∀ y : ℝ, ‖Z (σ + y * I)‖ ≤ K * Real.exp (2 * |y|)) :
    ∫ t, (W.w t : ℂ) * VerticalIntegral' (fun s => KY α β t s * Z s) σ =
      VerticalIntegral' (fun s => GY α β s / s * Wg W α β s * Z s) σ :=
```

```
theorem inner_hk {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) (a : ℕ → ℂ) (σ₀ : ℝ) {α β : ℂ}
    (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {c : ℝ} (hc : 1 / 10 < c) {h k : ℕ} (hh : 1 ≤ h)
    (hk : 1 ≤ k) :
    ∑' p : ℕ × ℕ, (if h * (p.1 + 1) = k * (p.2 + 1) then
        coefY a σ₀ α β h k (p.1 + 1) (p.2 + 1) * Jint W α β c h k (p.1 + 1) (p.2 + 1) else 0) =
      ∫ t, (W.w t : ℂ) * VerticalIntegral' (fun s => KY α β t s * Zhk a σ₀ α β h k s) c :=
```

```
theorem diag_per_t {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ)
    {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {c : ℝ} (hc : 1 / 10 < c) :
    diagSum W M a σ₀ α β c =
      ∫ t, (W.w t : ℂ) * VerticalIntegral' (fun s => KY α β t s * Zd M a σ₀ α β s) c :=
```

```
theorem diag_mellin {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ)
    {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {c : ℝ} (hc : 1 / 10 < c) :
    diagSum W M a σ₀ α β c = VerticalIntegral' (fun s => GY α β s / s * Wg W α β s *
      riemannZeta (1 + α + β + 2 * s) * Sdiag M a σ₀ α β s) c :=
```

```
theorem Ez_differentiable : Differentiable ℂ Ez :=
```

```
theorem Hf_local {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hαβ : α + β ≠ 0) (t : ℝ)
    {Z : ℂ → ℂ} (hZd : Differentiable ℂ Z) :
    ∃ h : ℂ → ℂ, AnalyticAt ℂ h 0 ∧ ∀ᶠ s in 𝓝[≠] (0 : ℂ),
      Hf α β t Z s = h s + riemannZeta (1 + α + β) * Z 0 / (s - 0) :=
```

```
theorem shift_t {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hαβ : α + β ≠ 0) {t : ℝ}
    (ht : 1 ≤ t) {Z : ℂ → ℂ} (hZd : Differentiable ℂ Z) {KZ : ℝ}
    (hZb : ∀ σ y : ℝ, -(1 / 4) ≤ σ → σ ≤ 1 → ‖Z (σ + y * I)‖ ≤ KZ) :
    VerticalIntegral' (fun s => KY α β t s * (riemannZeta (1 + α + β + 2 * s) * Z s)) 1 =
      riemannZeta (1 + α + β) * Z 0 +
        VerticalIntegral' (fun s => KY α β t s * (riemannZeta (1 + α + β + 2 * s) * Z s))
          (-(1 / 4)) :=
```

```
theorem diag_shift {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ)
    {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hαβ : α + β ≠ 0) :
    diagSum W M a σ₀ α β 1 =
      (what0 W : ℂ) * (riemannZeta (1 + α + β) * Sdiag M a σ₀ α β 0) +
        ∫ t, (W.w t : ℂ) * VerticalIntegral' (fun s => KY α β t s * Zd M a σ₀ α β s)
          (-(1 / 4)) :=
```

```
theorem shifted_bound : ∃ K0 : ℝ, 0 ≤ K0 ∧ ∀ (T L : ℝ) (W : Weight T L), 4 ≤ T →
    ∀ (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ) (α β : ℂ), ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 →
      ‖∫ t, (W.w t : ℂ) * VerticalIntegral' (fun s => KY α β t s * Zd M a σ₀ α β s) (-(1 / 4))‖ ≤
        K0 * (1 + 1 / ‖α + β‖ ^ 2) * T * (T / (8 * Real.pi)) ^ (-(1 / 4) : ℝ) *
          SB M a σ₀ α β (-(1 / 4)) :=
```

```
theorem gcd_sum (M : ℕ) :
    ∑ h ∈ Finset.Icc 1 M, ∑ k ∈ Finset.Icc 1 M, (h : ℝ) ^ (-(1 / 2) : ℝ) * (k : ℝ) ^ (-(1 / 2) : ℝ) *
        (((k / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 4) : ℝ) * ((h / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 4) : ℝ)) ≤
      (M : ℝ) ^ (1 / 2 : ℝ) * (1 + Real.log M) ^ 3 :=
```

```
theorem SB_young (P : Polynomial ℝ) : ∃ B : ℝ, 0 ≤ B ∧ ∀ (T θ R κ : ℝ), 1 < T → θ < 1 / 2 →
    ∀ α β : ℂ, ‖α‖ ≤ κ / Real.log T → ‖β‖ ≤ κ / Real.log T →
      SB (Mof T θ) (aY P T θ R) (sig0 T R) α β (-(1 / 4)) ≤
        B ^ 2 * Real.exp κ * (((Mof T θ : ℕ) : ℝ) ^ (1 / 2 : ℝ) *
          (1 + Real.log ((Mof T θ : ℕ) : ℝ)) ^ 3) :=
```

```
theorem final_size_diag {θ : ℝ} (hθ : θ < 1 / 2) (κ : ℝ) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ T : ℝ, Real.exp 1 ≤ T → ∀ M : ℕ, (M : ℝ) ≤ T ^ θ →
      (1 + κ ^ 2 * Real.log T ^ 2) * T * (T / (8 * Real.pi)) ^ (-(1 / 4) : ℝ) *
        ((M : ℝ) ^ (1 / 2 : ℝ) * (1 + Real.log M) ^ 3) ≤ C * (T / Real.log T) :=
```

```
theorem diag_young (P : Polynomial ℝ) {θ : ℝ} (hθ : θ < 1 / 2) (R : ℝ) {κ : ℝ} (hκ : 0 < κ) :
    ∃ C T₀ : ℝ, 0 ≤ C ∧ ∀ T : ℝ, T₀ ≤ T → ∀ W : Weight T (Real.log T), ∀ α β : ℂ,
      Regime κ T α β →
        ‖diagSum W (Mof T θ) (aY P T θ R) (sig0 T R) α β 1 - (what0 W : ℂ) *
          (riemannZeta (1 + α + β) * Sdiag (Mof T θ) (aY P T θ R) (sig0 T R) α β 0)‖ ≤
          C * (T / Real.log T) :=
```

```
theorem stmtDiag_of_main (P : Polynomial ℝ) {θ : ℝ} (hθ : θ < 1 / 2) (R : ℝ) {κ : ℝ}
    (hκ : 0 < κ) (hmain : StmtDiagMain P θ R κ) : StmtDiag P θ R κ :=
```

