> Source: session transcript, 2026-11-25

> Yes



From `lean_stage3/Stage3/SwapX.lean`, the pinned statements:

```
theorem norm_Dk_le {s : ℂ} (hs : ‖s‖ ≤ 1) (k : ℕ) :
    ‖Dk s (k + 1)‖ ≤ ‖s‖ * ((k + 1).factorial : ℝ) :=
```

```
theorem iter_phi (ℓ : ℂ →L[ℝ] ℝ) (c s : ℂ) (a b : ℝ) (k : ℕ) :
    Set.EqOn (iteratedDeriv (k + 1) (phi ℓ c s a b))
      (fun t => b * ℓ (c * (Dk s (k + 1) * Gk s (k + 1) t))) (Set.Ioi 0) :=
```

```
theorem phi_iter_le (hT : 0 < T)
    (h01 : ∀ t ∈ Set.Icc (T / 4) (2 * T), 0 ≤ phi ℓ c s a b t ∧ phi ℓ c s a b t ≤ 1)
    (hder : ∀ k : ℕ, ∀ t ∈ Set.Icc (T / 4) (2 * T),
      |b * ℓ (c * (Dk s (k + 1) * Gk s (k + 1) t))| ≤
        ((k + 1).factorial : ℝ) * 4 ^ (k + 1) * ((T / L) ^ (k + 1))⁻¹)
    (k : ℕ) {t : ℝ} (ht : t ∈ Set.Icc (T / 4) (2 * T)) :
    |iteratedDeriv k (phi ℓ c s a b) t| ≤ (k.factorial : ℝ) * 4 ^ k * ((T / L) ^ k)⁻¹ :=
```

```
theorem logratio_le {T t : ℝ} (hT : 0 < T) (ht : t ∈ Set.Icc (T / 4) (2 * T)) :
    |Real.log t - Real.log (2 * Real.pi * T)| ≤ 26 :=
```

```
theorem g_sub_one (hκ : 0 < κ) (hT : 0 < T) (hL : 52 * κ ≤ L) (hs : ‖s‖ ≤ 2 * κ / L) {t : ℝ}
    (ht : t ∈ Set.Icc (T / 4) (2 * T)) : ‖cT s T * Gk s 0 t - 1‖ ≤ Kt κ / L :=
```

```
theorem hder_of (ℓ : ℂ →L[ℝ] ℝ) (hℓ : ∀ z, |ℓ z| ≤ ‖z‖) (hκ : 0 < κ) (hT : 0 < T)
    (hL1 : 1 ≤ L) (hL : 52 * κ ≤ L) (hs : ‖s‖ ≤ 2 * κ / L) (k : ℕ) (t : ℝ)
    (ht : t ∈ Set.Icc (T / 4) (2 * T)) :
    |L / (2 * Kt κ) * ℓ (cT s T * (Dk s (k + 1) * Gk s (k + 1) t))| ≤
      ((k + 1).factorial : ℝ) * 4 ^ (k + 1) * ((T / L) ^ (k + 1))⁻¹ :=
```

```
theorem decomp (hκ : 0 < κ) (hL0 : 0 < L) (w : ℝ) (t : ℝ) :
    (w : ℂ) * (cT s T * Gk s 0 t - 1) = ((Kt κ / L : ℝ) : ℂ) *
      (((2 * (w * phi Complex.reCLM (cT s T) s (1 / 2 - L / (2 * Kt κ)) (L / (2 * Kt κ)) t) - w
        : ℝ) : ℂ) + I * (((2 * (w * phi Complex.imCLM (cT s T) s (1 / 2) (L / (2 * Kt κ)) t)
          - w : ℝ) : ℂ))) :=
```

```
theorem S1_sharp {η : ℝ} (hη : 0 < η) (hη4 : η ≤ 1 / 4) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 → ‖α‖ ≤ η →
      ‖β‖ ≤ η → ∀ t : ℝ, 1 ≤ t →
        ‖S1 α β 1 t‖ ≤ C * (1 + 1 / ‖α + β‖ ^ 2) * t ^ (1 / 2 + 2 * η) :=
```

```
theorem msq_young (P : Polynomial ℝ) : ∃ B : ℝ, 0 ≤ B ∧ ∀ (T θ R t : ℝ),
    msq (Mof T θ) (aY P T θ R) (sig0 T R) t ≤
      B ^ 2 * ((Mof T θ : ℝ) * (1 + Real.log (Mof T θ))) :=
```

```
theorem size_X {θ : ℝ} (hθ : θ < 1 / 2) (κ : ℝ) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ T : ℝ, Real.exp 1 ≤ T → ∀ M : ℕ, (M : ℝ) ≤ T ^ θ →
      (1 + κ ^ 2 * Real.log T ^ 2) * (2 * T) ^ (1 / 2 + 2 * etaX θ) *
        ((M : ℝ) * (1 + Real.log M)) ≤ C * (T / Real.log T) :=
```

```
theorem c1Y_bound (P : Polynomial ℝ) {θ : ℝ} (hθ : θ < 1 / 2) {κ : ℝ} (hκ : 0 < κ) :
    ∃ C T₀ : ℝ, 0 ≤ C ∧ ∀ T : ℝ, T₀ ≤ T → ∀ α β : ℂ, Regime κ T α β →
      ‖c1Y P (Mof T θ) α β‖ ≤ C :=
```

```
theorem Tp_g {T t : ℝ} (hT : 0 < T) (ht : 0 < t) (z : ℂ) :
    (T : ℂ) ^ z * (cT z T * Gk z 0 t) = (((t / (2 * Real.pi) : ℝ)) : ℂ) ^ z :=
```

```
theorem E_bound {T L : ℝ} (hT8 : 8 ≤ T) (W : Weight T L) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ)
    {α β : ℂ} {Cst CS N Bm e : ℝ} (hCst : 0 ≤ Cst) (hCS : 0 ≤ CS) (hN : 0 ≤ N) (hBm : 0 ≤ Bm)
    (he : 0 ≤ e)
    (hst : ∀ t : ℝ, 1 ≤ t → ‖XY α β t - (((t / (2 * Real.pi) : ℝ)) : ℂ) ^ (-(α + β))‖ ≤ Cst / t)
    (hS1 : ∀ t : ℝ, 1 ≤ t → ‖S1 (-β) (-α) 1 t‖ ≤ CS * N * t ^ e)
    (hmsq : ∀ t, msq M a σ₀ t ≤ Bm) :
    ‖∫ t, (W.w t : ℂ) * ((XY α β t - (T : ℂ) ^ (-(α + β)) *
        (cT (-(α + β)) T * Gk (-(α + β)) 0 t)) * S1 (-β) (-α) 1 t) * (msq M a σ₀ t : ℂ)‖ ≤
      8 * Cst * CS * N * (2 * T) ^ e * Bm :=
```

```
theorem J_alg {K L T Cc Cd Co Cu eu ev eW : ℝ} (hK : 0 ≤ K) (hL1 : 1 ≤ L) (hT : 0 ≤ T)
    (hCc : 0 ≤ Cc) (hCd : 0 ≤ Cd) (hCo : 0 ≤ Co) (hCu : 0 ≤ Cu) {u v w : ℂ}
    (hu : ‖u‖ ≤ 2 * T * (Cc + 1) + Cd * (T / L) + Co * eu)
    (hv : ‖v‖ ≤ 2 * T * (Cc + 1) + Cd * (T / L) + Co * ev)
    (hw : ‖w‖ ≤ 2 * T * (Cc + 1) + Cd * (T / L) + Co * eW)
    (heu : eu ≤ Cu * (T / L)) (hev : ev ≤ Cu * (T / L)) (hTL : T / L ≤ eW) :
    ‖((K / L : ℝ) : ℂ) * ((2 * u - w) + I * (2 * v - w))‖ ≤
      2 * K * (6 * (Cc + 1) + 3 * Cd + 2 * Co * Cu + Co) * eW :=
```

```
theorem stmtXAll_of (P : Polynomial ℝ) {θ : ℝ} (hθ : θ < 1 / 2) (R : ℝ) {κ : ℝ} (hκ : 0 < κ)
    (hS : StmtXStirling) (hmain : StmtDiagMainO P θ R κ) : StmtXAll P θ R κ :=
```

```
theorem lemma3_resO_of_partsAll {P : Polynomial ℝ} {θ R κ : ℝ} (hκ : 0 < κ)
    (hD : StmtDiagO P θ R κ) (hO : StmtOffDiagAll P θ R κ) (hX : StmtXAll P θ R κ) :
    StmtLemma3resO P θ R κ :=
```

```
theorem lemma3_resO_of_mainO (P : Polynomial ℝ) {θ : ℝ} (hθ : θ < 1 / 2) (R : ℝ) {κ : ℝ}
    (hκ : 0 < κ) (hS : StmtXStirling) (hmain : StmtDiagMainO P θ R κ) :
    StmtLemma3resO P θ R κ :=
```

