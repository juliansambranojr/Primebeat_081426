> Source: session transcript, 2026-11-25

> Yes log



From `lean_stage3/Stage3/TuringCert.lean`, the pinned statements:

```
theorem defect_mono {T T' : ℝ} (h : T ≤ T') : defect T ≤ defect T' :=
```

```
theorem count_le_N_sub {m : ℕ} {s : Fin (m + 1) → ℝ} {T₁ u : ℝ} (hT₁ : 0 ≤ T₁)
    (hs : StmtSignData m s) (hsT : T₁ < s 0) (hu : T₁ < u) :
    (∑ j : Fin m, if s j.succ < u then (1 : ℝ) else 0)
      ≤ riemannZeta.N u - (allCount T₁ : ℝ) :=
```

```
theorem defect_zero_of_signs {k m : ℕ} {t : Fin (k + 1) → ℝ} {s : Fin (m + 1) → ℝ}
    {T₁ a b t₀ h : ℝ}
    (hbelow : StmtSignData k t) (htT : t (Fin.last k) ≤ T₁)
    (habove : StmtSignData m s) (hsT : T₁ < s 0) (hsh : s (Fin.last m) ≤ T₁ + h)
    (hL : StmtLittlewood a b t₀) (ha : 0 ≤ a) (ht₀ : t₀ ≤ T₁) (h1 : 1 ≤ T₁) (hh : 0 < h)
    (hnum : Stage3.phaseTheta T₁ / Real.pi + 1 + turingErr a b h T₁ s < k + 2) :
    ∀ T ≤ T₁, defect T = 0 :=
```

