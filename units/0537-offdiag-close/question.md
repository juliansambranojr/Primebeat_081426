> Source: session transcript, 2026-11-25

> Yes to all of it



From `lean_stage3/Stage3/OffDiagClose.lean`, the pinned statements:

```
theorem phi_iter_bdd (i : ℕ) : ∃ B : ℝ, 0 ≤ B ∧ ∀ s, |iteratedDeriv i Real.smoothTransition s| ≤ B :=
```

```
theorem winY_iter_le {T L : ℝ} (hΔ : 0 < T / L) (j : ℕ) (t : ℝ) :
    |iteratedDeriv j (winY T L) t| ≤ winC j * ((T / L) ^ j)⁻¹ :=
```

```
theorem weightAll_exists : ∃ Cs : ℕ → ℝ, (∀ j, 0 ≤ Cs j) ∧ ∀ T L : ℝ, 8 ≤ T → 1 ≤ L →
    ∃ W : WeightAll T L, W.Cj = Cs ∧ W.C1 = Cs 1 ∧ W.C2 = Cs 2 ∧
      ∀ t, W.w t = Real.smoothTransition ((t - T / 4) / (T / L)) *
        Real.smoothTransition ((2 * T - t) / (T / L)) :=
```

```
theorem VY_iter_bound0 (r : ℕ) {A : ℝ} (hA : 0 < A) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 →
      ∀ t : ℝ, 1 ≤ t → ∀ x : ℝ, 0 < x → ∀ c : ℝ, 0 < c →
        ‖(t : ℂ) ^ r * iteratedDeriv r (fun t => VY α β c x t) t‖ ≤
          C * (1 + 1 / ‖α + β‖ ^ 2) * (1 + x / t) ^ (-A) :=
```

```
theorem Fw_iter_bound (j : ℕ) {A : ℝ} (hA : 0 < A) :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ (T L : ℝ) (W : WeightAll T L), 4 ≤ T → 1 ≤ L →
      ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 →
      ∀ x : ℝ, 0 < x → ∀ c : ℝ, 0 < c → ∀ t : ℝ,
        ‖iteratedDeriv j (Fw W.toWeight α β c x) t‖ ≤ K * wsum W j * (1 + 1 / ‖α + β‖ ^ 2) *
          ((T / L) ^ j)⁻¹ * (1 + x / (2 * T)) ^ (-A) :=
```

```
theorem offdiag_term_iter (j : ℕ) {A : ℝ} (hA : 0 < A) :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ (T L : ℝ) (W : WeightAll T L), 8 ≤ T → 1 ≤ L →
      ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 →
      ∀ x : ℝ, 0 < x → ∀ c : ℝ, 0 < c → ∀ l : ℝ, l ≠ 0 →
        ‖∫ t, (W.w t : ℂ) * VY α β c x t * eL l t‖ ≤
          K * wsum W j * (1 + 1 / ‖α + β‖ ^ 2) * T * ((T / L) ^ j)⁻¹ * (|l| ^ j)⁻¹ *
            (1 + x / (2 * T)) ^ (-A) :=
```

```
theorem offdiag_term_iter_young (r : ℕ) {A : ℝ} (hA : 0 < A) :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ (T L : ℝ) (W : WeightAll T L), 8 ≤ T → 1 ≤ L →
      ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 → ∀ c : ℝ, 0 < c →
      ∀ h k m n : ℕ, 1 ≤ h → 1 ≤ k → 1 ≤ m → 1 ≤ n → h * m ≠ k * n →
        ‖Jint W.toWeight α β c h k m n‖ ≤
          K * wsum W (2 * r) * (1 + 1 / ‖α + β‖ ^ 2) * T * ((T / L) ^ (2 * r))⁻¹ *
            (4 * ((h : ℝ) * m) * ((k : ℝ) * n)) ^ r * (1 + (m : ℝ) * n / (2 * T)) ^ (-A) :=
```

```
theorem decay_trade {y T : ℝ} (hy : 0 < y) (hT : 0 < T) (r : ℕ) :
    y ^ r * y ^ (-(2 / 5) : ℝ) * (1 + y / (2 * T)) ^ (-((r : ℝ) + 4 / 5)) ≤
      (2 * T) ^ ((r : ℝ) + 4 / 5) * y ^ (-(6 / 5) : ℝ) :=
```

```
theorem off_term_iter_le (r : ℕ) {K : ℝ}
    (hK : ∀ (T L : ℝ) (W : WeightAll T L), 8 ≤ T → 1 ≤ L →
      ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 → ∀ c : ℝ, 0 < c →
      ∀ h k m n : ℕ, 1 ≤ h → 1 ≤ k → 1 ≤ m → 1 ≤ n → h * m ≠ k * n →
        ‖Jint W.toWeight α β c h k m n‖ ≤
          K * wsum W (2 * r) * (1 + 1 / ‖α + β‖ ^ 2) * T * ((T / L) ^ (2 * r))⁻¹ *
            (4 * ((h : ℝ) * m) * ((k : ℝ) * n)) ^ r *
            (1 + (m : ℝ) * n / (2 * T)) ^ (-((r : ℝ) + 4 / 5)))
    (hK0 : 0 ≤ K) {T L : ℝ} (W : WeightAll T L) (hT : 8 ≤ T) (hL : 1 ≤ L) (M : ℕ) (a : ℕ → ℂ)
    (σ₀ B : ℝ) (hB0 : 0 ≤ B) (hB : ∀ h : ℕ, 1 ≤ h → h ≤ M → ‖a h‖ * (h : ℝ) ^ (-σ₀) ≤ B)
    {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hαβ : α + β ≠ 0) {c : ℝ} (hc : 0 < c)
    {h k : ℕ} (hh : 1 ≤ h) (hhM : h ≤ M) (hk : 1 ≤ k) (hkM : k ≤ M) (p : ℕ × ℕ)
    (hd : h * (p.1 + 1) ≠ k * (p.2 + 1)) :
    ‖coefY a σ₀ α β h k (p.1 + 1) (p.2 + 1) * Jint W.toWeight α β c h k (p.1 + 1) (p.2 + 1)‖ ≤
      (K * wsum W (2 * r) * (1 + 1 / ‖α + β‖ ^ 2) * T * ((T / L) ^ (2 * r))⁻¹) * B ^ 2 * 4 ^ r *
        (M : ℝ) ^ (2 * r) * ((2 * T) ^ ((r : ℝ) + 4 / 5) * major6 p) :=
```

```
theorem offSum_bound_iter (r : ℕ) :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ (T L : ℝ) (W : WeightAll T L), 8 ≤ T → 1 ≤ L →
      ∀ (M : ℕ) (a : ℕ → ℂ) (σ₀ B : ℝ), 0 ≤ B →
      (∀ h : ℕ, 1 ≤ h → h ≤ M → ‖a h‖ * (h : ℝ) ^ (-σ₀) ≤ B) →
      ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 → ∀ c : ℝ, 0 < c →
        ‖offSum W.toWeight M a σ₀ α β c‖ ≤ K * wsum W (2 * r) * (1 + 1 / ‖α + β‖ ^ 2) * T *
          ((T / L) ^ (2 * r))⁻¹ * B ^ 2 * (M : ℝ) ^ (2 * r + 2) * (2 * T) ^ ((r : ℝ) + 4 / 5) :=
```

```
theorem aY_bound (P : Polynomial ℝ) : ∃ B : ℝ, 0 ≤ B ∧ ∀ (T θ R : ℝ) (h : ℕ), 1 ≤ h →
    h ≤ Mof T θ → ‖aY P T θ R h‖ * (h : ℝ) ^ (-sig0 T R) ≤ B :=
```

```
theorem logpow_le (p : ℕ) {T : ℝ} (hT : 1 ≤ T) :
    Real.log T ^ p ≤ (5 * ((p : ℝ) + 1)) ^ p * T ^ (1 / 5 : ℝ) :=
```

```
theorem Tpow_le {θ : ℝ} (hθ : θ < 1 / 2) {r : ℕ} (hr : 2 ≤ (r : ℝ) * (1 - 2 * θ)) {T L Mr : ℝ}
    (hT : 1 ≤ T) (hL : 0 < L) (hM0 : 0 ≤ Mr) (hM : Mr ≤ T ^ θ) :
    T * ((T / L) ^ (2 * r))⁻¹ * Mr ^ (2 * r + 2) * (2 * T) ^ ((r : ℝ) + 4 / 5) ≤
      (2 : ℝ) ^ ((r : ℝ) + 4 / 5) * L ^ (2 * r) * T ^ (4 / 5 : ℝ) :=
```

```
theorem final_size {θ : ℝ} (hθ : θ < 1 / 2) {r : ℕ} (hr : 2 ≤ (r : ℝ) * (1 - 2 * θ)) (κ : ℝ) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ T : ℝ, Real.exp 1 ≤ T → ∀ Mr : ℝ, 0 ≤ Mr → Mr ≤ T ^ θ →
      (1 + κ ^ 2 * Real.log T ^ 2) * T * ((T / Real.log T) ^ (2 * r))⁻¹ * Mr ^ (2 * r + 2) *
        (2 * T) ^ ((r : ℝ) + 4 / 5) ≤ C * (T / Real.log T) :=
```

```
theorem stmtOffDiag_holds (P : Polynomial ℝ) {θ : ℝ} (hθ : θ < 1 / 2) (R : ℝ) {κ : ℝ}
    (hκ : 0 < κ) : StmtOffDiagAll P θ R κ :=
```

