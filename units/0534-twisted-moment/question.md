> Source: session transcript, 2026-11-25

> Yes



From `lean_stage3/Stage3/TwistedMoment.lean`, the pinned statements:

```
theorem ibp_twice {F F1 F2 : ℝ → ℂ} {a b l : ℝ} (hl : l ≠ 0)
    (hF : ∀ t, HasDerivAt F (F1 t) t) (hF1 : ∀ t, HasDerivAt F1 (F2 t) t)
    (hF2 : IntervalIntegrable F2 volume a b)
    (ha : F a = 0) (hb : F b = 0) (ha1 : F1 a = 0) (hb1 : F1 b = 0) :
    ∫ t in a..b, F t * eL l t = -(1 / (l : ℂ) ^ 2) * ∫ t in a..b, F2 t * eL l t :=
```

```
theorem offdiag_term {A : ℝ} (hA : 0 < A) :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ (T L : ℝ) (W : Weight T L), 8 ≤ T → 1 ≤ L →
      ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 →
      ∀ x : ℝ, 0 < x → ∀ c : ℝ, 0 < c → ∀ l : ℝ, l ≠ 0 →
        ‖∫ t, (W.w t : ℂ) * VY α β c x t * eL l t‖ ≤
          K * (1 + W.C1 + W.C2) * (1 + 1 / ‖α + β‖ ^ 2) * T * ((T / L) ^ 2)⁻¹ * (l ^ 2)⁻¹ *
            (1 + x / (2 * T)) ^ (-A) :=
```

```
theorem inv_log_sq_le {P Q : ℕ} (hP : 1 ≤ P) (hQ : 1 ≤ Q) (hPQ : P ≠ Q) :
    ((Real.log ((P : ℝ) / Q)) ^ 2)⁻¹ ≤ 4 * (P : ℝ) * Q :=
```

```
theorem offdiag_term_young {A : ℝ} (hA : 0 < A) :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ (T L : ℝ) (W : Weight T L), 8 ≤ T → 1 ≤ L →
      ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 → ∀ c : ℝ, 0 < c →
      ∀ h k m n : ℕ, 1 ≤ h → 1 ≤ k → 1 ≤ m → 1 ≤ n → h * m ≠ k * n →
        ‖∫ t, (W.w t : ℂ) * VY α β c ((m : ℝ) * n) t *
            ((h : ℂ) * m / ((k : ℂ) * n)) ^ (-((t : ℂ) * I))‖ ≤
          K * (1 + W.C1 + W.C2) * (1 + 1 / ‖α + β‖ ^ 2) * T * ((T / L) ^ 2)⁻¹ *
            (4 * ((h : ℝ) * m) * ((k : ℝ) * n)) * (1 + (m : ℝ) * n / (2 * T)) ^ (-A) :=
```

```
theorem msq_expand (M : ℕ) (a : ℕ → ℂ) (σ₀ t : ℝ) :
    ((msq M a σ₀ t : ℝ) : ℂ) = ∑ h ∈ Finset.Icc 1 M, ∑ k ∈ Finset.Icc 1 M,
      a h * (starRingEnd ℂ) (a k) * ((h : ℂ) ^ (-((σ₀ : ℂ) + t * I)) *
        (k : ℂ) ^ (-((σ₀ : ℂ) - t * I))) :=
```

```
theorem I_split {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ)
    {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hαβ : α + β ≠ 0)
    {c : ℝ} (hc : 7 / 10 ≤ c) :
    Imom W M a σ₀ α β = I1 W M a σ₀ α β c + IX W M a σ₀ α β c - Ires W M a σ₀ α β :=
```

```
theorem Ires_small :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ (T L : ℝ) (W : Weight T L), 4 ≤ T →
      ∀ (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ) (α β : ℂ), ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 →
        ‖Ires W M a σ₀ α β‖ ≤ C * (1 + 1 / ‖α + β‖ ^ 2) *
          (∑ h ∈ Finset.Icc 1 M, ‖a h‖ * (h : ℝ) ^ (-σ₀)) ^ 2 * T * Real.exp (-(T ^ 2 / 32)) :=
```

```
theorem I1_expand {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ)
    {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {c : ℝ} (hc : 0 < c) :
    I1 W M a σ₀ α β c = ∑ h ∈ Finset.Icc 1 M, ∑ k ∈ Finset.Icc 1 M, ∑' p : ℕ × ℕ,
      coefY a σ₀ α β h k (p.1 + 1) (p.2 + 1) * Jint W α β c h k (p.1 + 1) (p.2 + 1) :=
```

```
theorem I1_diag_off {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ)
    {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {c : ℝ} (hc : 0 < c) :
    I1 W M a σ₀ α β c = diagSum W M a σ₀ α β c + offSum W M a σ₀ α β c :=
```

```
theorem Jint_diag {T L : ℝ} (W : Weight T L) (α β : ℂ) (c : ℝ) {h k m n : ℕ} (hk : 1 ≤ k)
    (hn : 1 ≤ n) (hd : h * m = k * n) :
    Jint W α β c h k m n = ∫ t, (W.w t : ℂ) * VY α β c ((m : ℝ) * n) t :=
```

```
theorem offSum_bound :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ (T L : ℝ) (W : Weight T L), 8 ≤ T → 1 ≤ L →
      ∀ (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ) (α β : ℂ), ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 →
      ∀ c : ℝ, 0 < c →
        ‖offSum W M a σ₀ α β c‖ ≤ K * (1 + W.C1 + W.C2) * (1 + 1 / ‖α + β‖ ^ 2) * T *
          ((T / L) ^ 2)⁻¹ * (∑ h ∈ Finset.Icc 1 M, ‖a h‖ * (h : ℝ) ^ (1 - σ₀)) ^ 2 *
          offSeries T :=
```

```
theorem lemma3_res_of_parts {P : Polynomial ℝ} {θ R κ : ℝ} (hκ : 0 < κ)
    (hD : StmtDiag P θ R κ) (hO : StmtOffDiag P θ R κ) (hX : StmtX P θ R κ) :
    StmtLemma3res P θ R κ :=
```

