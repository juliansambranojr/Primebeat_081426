/-
WeilPowerNear — the near members' sign. Rung 5, seventeenth slice;
worksheet § 13 block 13g. 2026-09-07.

A member at `ζ = ε' + iΔ` with `0 < Δ < ε'`, weighted against the target
at `ε`, contributes at each `h` the real part
`e^{z.re·u}/ε² · ((ε'² − Δ²) cos θ − 2ε'Δ sin θ)` with `θ = 4ε'Δ·u` and
`u = uLam λ h` (unit 0352's objects, unit 0347's `re_A_sq` at the shell).
The bracket is nonnegative when `tan θ ≤ (ε'² − Δ²)/(2ε'Δ)`; the crude
sufficient condition, from `sin θ ≤ θ` and `cos θ ≥ 1 − 2θ/π` on
`[0, π/2]`, is `θ·(2ε'Δ + 2(ε'² − Δ²)/π) ≤ ε'² − Δ²`. The phase at `h` is
at most its value at `b`, since `uLam λ h ≤ h/(λπ²)` (the upper half of
`uLam_bracket`, the correction `1/(2λ³π²(h+1))` being under the intercept
`1/(2λ²π²)` exactly when `λ(h+1) ≥ 1`). So every term is nonnegative and
so is the shell sum: these members help the target at every `h`.

Sizes. For `Δ ≪ ε'` the condition N2 reads `4ε'Δb/(λπ²) ≲ π/2`, i.e.
`Δ ≲ λπ³/(8ε'b)`: exactly unit 0351's near boundary. Between it and the
far bound of 13f (`Δ ≳ λ/(εX)` for a bound under the range) sits the shell
0351 prices. No factor is lost: this block has no constant to lose, its
output is a sign.

Regime, as the block names it:
  R1 `0 < ε'`;  R3 `0 < Δ`;  N1 `Δ < ε'`;  R5 `0 < ε`;  L1 `1 ≤ λ` (ℕ);
  G4 `1 ≤ a` (ℕ);
  N2 `4ε'Δ·(b/(λπ²)) · (2ε'Δ + 2(ε'² − Δ²)/π) ≤ ε'² − Δ²`.

Defs. none.

Theorems, with the hypotheses the block lists:
  uLam_nonneg         none                     0 ≤ uLam λ h
  uLam_le             L1, 1 ≤ h                uLam λ h ≤ h/(λπ²)
  cos_ge_lin          0 ≤ θ, θ ≤ π/2           1 − 2θ/π ≤ cos θ
  bracket_nonneg      R1, R3, N1, 0 ≤ θ,       0 ≤ (ε'²−Δ²)cos θ − 2ε'Δ sin θ
                      θ·(2ε'Δ + 2(ε'²−Δ²)/π)
                        ≤ ε'² − Δ²
  re_term_eq          R5 as `ε ≠ 0`            the weighted term's real part
  phase_le            R1, R3, L1, 1 ≤ h,       4ε'Δ·uLam λ h ≤ 4ε'Δ·b/(λπ²)
                      h ≤ b
  term_nonneg         R1, R3, N1, R5, L1,      0 ≤ the term at `h`
                      1 ≤ h, h ≤ b, N2
  shellSum_nonneg     R1, R3, N1, R5, L1,      0 ≤ shellSum
                      G4, N2
  shellSum_nonneg_abs R1, Δ ≠ 0, |Δ| < ε',     0 ≤ shellSum
                      R5, L1, G4, N2 with |Δ|

Pinned: bracket_nonneg, term_nonneg, shellSum_nonneg, shellSum_nonneg_abs.

What the next slice needs: the shell between this block's near boundary
`Δ ≲ λπ³/(8ε'b)` and 13f's far bound `Δ ≳ λ/(εX)`, which unit 0351 prices
with the tight count; and the sum of these signs and 13f's bounds over the
members at a fixed `Δ`-scale.

Axioms: every pinned theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.WeilPowerShell

namespace WeilPowerNear

/-- The window's phase argument is nonnegative at every `h`. -/
theorem uLam_nonneg (lam h : ℕ) : 0 ≤ WeilPowerGeomGen.uLam lam h := by
  unfold WeilPowerGeomGen.uLam
  refine mul_nonneg (sq_nonneg _) ?_
  have hs := WeilPowerPhase.sigma_ge (lam * h - 1)
  have hp : (0:ℝ) ≤ 1 / (Real.pi ^ 2 * (((lam * h - 1 : ℕ) : ℝ) + 2)) := by positivity
  linarith

/-- The upper half of `uLam_bracket`, with the intercept absorbed: the
correction `1/(2λ³π²(h+1))` is under `1/(2λ²π²)` exactly when `λ(h+1) ≥ 1`. -/
theorem uLam_le {lam h : ℕ} (hl : 1 ≤ lam) (hh : 1 ≤ h) :
    WeilPowerGeomGen.uLam lam h ≤ (h : ℝ) / ((lam : ℝ) * Real.pi ^ 2) := by
  obtain ⟨_, hb⟩ := WeilPowerGeomGen.uLam_bracket hl hh
  have hl1 : (1:ℝ) ≤ (lam : ℝ) := by exact_mod_cast hl
  have hh0 : (0:ℝ) ≤ (h : ℝ) := Nat.cast_nonneg h
  have hLH : (1:ℝ) ≤ (lam : ℝ) * ((h : ℝ) + 1) := by nlinarith
  have hpos : (0:ℝ) < 2 * (lam : ℝ) ^ 2 * Real.pi ^ 2 := by positivity
  have hkey : 1 / (2 * (lam : ℝ) ^ 3 * Real.pi ^ 2) / ((h : ℝ) + 1)
      ≤ 1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2) := by
    rw [div_div, div_le_div_iff₀ (by positivity) (by positivity)]
    nlinarith [mul_le_mul_of_nonneg_left hLH hpos.le]
  linarith

/-- `cos` above its chord on `[0, π/2]`: `Real.mul_le_sin` at `π/2 − θ`. -/
theorem cos_ge_lin {θ : ℝ} (h0 : 0 ≤ θ) (h1 : θ ≤ Real.pi / 2) :
    1 - 2 * θ / Real.pi ≤ Real.cos θ := by
  have hpi : (0:ℝ) < Real.pi := Real.pi_pos
  have h := Real.mul_le_sin (x := Real.pi / 2 - θ) (by linarith) (by linarith)
  rw [Real.sin_pi_div_two_sub] at h
  have hid : 2 / Real.pi * (Real.pi / 2 - θ) = 1 - 2 * θ / Real.pi := by
    field_simp
    try ring
  rw [hid] at h
  exact h

/-- The bracket's sign under the crude condition N2. -/
theorem bracket_nonneg {e' D θ : ℝ} (h1 : 0 < e') (h3 : 0 < D) (hD : D < e')
    (h0 : 0 ≤ θ)
    (hθ : θ * (2 * e' * D + 2 * (e' ^ 2 - D ^ 2) / Real.pi) ≤ e' ^ 2 - D ^ 2) :
    0 ≤ (e' ^ 2 - D ^ 2) * Real.cos θ - 2 * e' * D * Real.sin θ := by
  have hpi : (0:ℝ) < Real.pi := Real.pi_pos
  have hQ : (0:ℝ) < e' ^ 2 - D ^ 2 := by nlinarith
  have hed : (0:ℝ) < 2 * e' * D := by positivity
  have hmul : θ * (2 * e' * D + 2 * (e' ^ 2 - D ^ 2) / Real.pi) * Real.pi
      ≤ (e' ^ 2 - D ^ 2) * Real.pi := mul_le_mul_of_nonneg_right hθ hpi.le
  have hexp : θ * (2 * e' * D + 2 * (e' ^ 2 - D ^ 2) / Real.pi) * Real.pi
      = θ * (2 * e' * D) * Real.pi + 2 * θ * (e' ^ 2 - D ^ 2) := by
    field_simp
    try ring
  rw [hexp] at hmul
  have hstep : 2 * θ * (e' ^ 2 - D ^ 2) ≤ Real.pi * (e' ^ 2 - D ^ 2) := by
    nlinarith [mul_nonneg (mul_nonneg h0 hed.le) hpi.le]
  have hθpi : θ ≤ Real.pi / 2 := by nlinarith
  have hcos := mul_le_mul_of_nonneg_left (cos_ge_lin h0 hθpi) hQ.le
  have hsin := mul_le_mul_of_nonneg_left (Real.sin_le h0) hed.le
  -- `nlinarith [hcos, hsin]` failed on the first try (`linarith failed to find a
  -- contradiction`). Goal at this point:
  --   e' D θ : ℝ
  --   h1 : 0 < e'
  --   h3 : 0 < D
  --   hD : D < e'
  --   h0 : 0 ≤ θ
  --   hθ : θ * (2 * e' * D + 2 * (e' ^ 2 - D ^ 2) / Real.pi) ≤ e' ^ 2 - D ^ 2
  --   hpi : 0 < Real.pi
  --   hQ : 0 < e' ^ 2 - D ^ 2
  --   hed : 0 < 2 * e' * D
  --   hmul : θ * (2 * e' * D) * Real.pi + 2 * θ * (e' ^ 2 - D ^ 2)
  --            ≤ (e' ^ 2 - D ^ 2) * Real.pi
  --   hexp : θ * (2 * e' * D + 2 * (e' ^ 2 - D ^ 2) / Real.pi) * Real.pi
  --            = θ * (2 * e' * D) * Real.pi + 2 * θ * (e' ^ 2 - D ^ 2)
  --   hstep : 2 * θ * (e' ^ 2 - D ^ 2) ≤ Real.pi * (e' ^ 2 - D ^ 2)
  --   hθpi : θ ≤ Real.pi / 2
  --   hcos : (e' ^ 2 - D ^ 2) * (1 - 2 * θ / Real.pi) ≤ (e' ^ 2 - D ^ 2) * Real.cos θ
  --   hsin : 2 * e' * D * Real.sin θ ≤ 2 * e' * D * θ
  --   ⊢ 0 ≤ (e' ^ 2 - D ^ 2) * Real.cos θ - 2 * e' * D * Real.sin θ
  -- `linarith [hcos, hsin, hθ]` also fails: linarith takes each product as one
  -- atom. `key` rewrites the two products into the same atoms; then it is linear.
  have key : (e' ^ 2 - D ^ 2) * (1 - 2 * θ / Real.pi) - 2 * e' * D * θ
      = (e' ^ 2 - D ^ 2) - θ * (2 * e' * D + 2 * (e' ^ 2 - D ^ 2) / Real.pi) := by ring
  linarith [hcos, hsin, hθ, key]
/-- The weighted term's real part, explicit. -/
theorem re_term_eq (e' D e u : ℝ) (he : e ≠ 0) :
    (WeilPowerShell.coef e' D e * Complex.exp (WeilPowerShell.zOf e' D e * (u : ℂ))).re
      = Real.exp (2 * (e' ^ 2 - D ^ 2 - e ^ 2) * u) / e ^ 2
        * ((e' ^ 2 - D ^ 2) * Real.cos (4 * e' * D * u)
            - 2 * e' * D * Real.sin (4 * e' * D * u)) := by
  have hsqre : (((e' : ℂ) + Complex.I * (D : ℂ)) ^ 2).re = e' ^ 2 - D ^ 2 := by
    simp [pow_two, Complex.mul_re, Complex.mul_im]
    try ring
  have hsqim : (((e' : ℂ) + Complex.I * (D : ℂ)) ^ 2).im = 2 * e' * D := by
    simp [pow_two, Complex.mul_re, Complex.mul_im]
    try ring
  have hcr : (WeilPowerShell.coef e' D e).re = (e' ^ 2 - D ^ 2) / e ^ 2 := by
    simp only [WeilPowerShell.coef, ← Complex.ofReal_pow, Complex.div_ofReal_re, hsqre]
  have hci : (WeilPowerShell.coef e' D e).im = 2 * e' * D / e ^ 2 := by
    simp only [WeilPowerShell.coef, ← Complex.ofReal_pow, Complex.div_ofReal_im, hsqim]
  have hzr : (WeilPowerShell.zOf e' D e * (u : ℂ)).re
      = 2 * (e' ^ 2 - D ^ 2 - e ^ 2) * u := by
    simp [Complex.mul_re, WeilPowerShell.zOf_re, WeilPowerShell.zOf_im]
  have hzi : (WeilPowerShell.zOf e' D e * (u : ℂ)).im = 4 * e' * D * u := by
    simp [Complex.mul_im, WeilPowerShell.zOf_re, WeilPowerShell.zOf_im]
  rw [Complex.mul_re, Complex.exp_re, Complex.exp_im, hcr, hci, hzr, hzi]
  field_simp
  try ring

/-- The phase is largest at the top of the range. -/
theorem phase_le {e' D : ℝ} {lam h b : ℕ} (h1 : 0 < e') (h3 : 0 < D)
    (hl : 1 ≤ lam) (hh : 1 ≤ h) (hhb : h ≤ b) :
    4 * e' * D * WeilPowerGeomGen.uLam lam h
      ≤ 4 * e' * D * ((b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) := by
  have hed : (0:ℝ) ≤ 4 * e' * D := by positivity
  refine mul_le_mul_of_nonneg_left ?_ hed
  refine (uLam_le hl hh).trans ?_
  refine div_le_div_of_nonneg_right ?_ (by positivity)
  exact_mod_cast hhb

/-- One near member's term is nonnegative at every `h` in the range. -/
theorem term_nonneg {e' D e : ℝ} {lam h b : ℕ} (h1 : 0 < e') (h3 : 0 < D)
    (hD : D < e') (h5 : 0 < e) (hl : 1 ≤ lam) (hh : 1 ≤ h) (hhb : h ≤ b)
    (hN : 4 * e' * D * ((b : ℝ) / ((lam : ℝ) * Real.pi ^ 2))
            * (2 * e' * D + 2 * (e' ^ 2 - D ^ 2) / Real.pi) ≤ e' ^ 2 - D ^ 2) :
    0 ≤ (WeilPowerShell.coef e' D e
          * Complex.exp (WeilPowerShell.zOf e' D e
              * ((WeilPowerGeomGen.uLam lam h : ℝ) : ℂ))).re := by
  rw [re_term_eq e' D e _ (ne_of_gt h5)]
  refine mul_nonneg (div_nonneg (Real.exp_pos _).le (sq_nonneg e)) ?_
  have hQ : (0:ℝ) < e' ^ 2 - D ^ 2 := by nlinarith
  have hed : (0:ℝ) ≤ 2 * e' * D := by positivity
  have hdiv : (0:ℝ) ≤ 2 * (e' ^ 2 - D ^ 2) / Real.pi :=
    div_nonneg (by linarith) Real.pi_pos.le
  have hC : (0:ℝ) ≤ 2 * e' * D + 2 * (e' ^ 2 - D ^ 2) / Real.pi := by linarith
  refine bracket_nonneg h1 h3 hD
    (mul_nonneg (by positivity) (uLam_nonneg lam h)) ?_
  exact le_trans (mul_le_mul_of_nonneg_right (phase_le h1 h3 hl hh hhb) hC) hN

/-- The near member's shell sum is nonnegative: it helps the target. -/
theorem shellSum_nonneg {e' D e : ℝ} {lam a b : ℕ} (h1 : 0 < e') (h3 : 0 < D)
    (hD : D < e') (h5 : 0 < e) (hl : 1 ≤ lam) (ha : 1 ≤ a)
    (hN : 4 * e' * D * ((b : ℝ) / ((lam : ℝ) * Real.pi ^ 2))
            * (2 * e' * D + 2 * (e' ^ 2 - D ^ 2) / Real.pi) ≤ e' ^ 2 - D ^ 2) :
    0 ≤ WeilPowerShell.shellSum e' D e lam a b := by
  simp only [WeilPowerShell.shellSum]
  refine Finset.sum_nonneg ?_
  intro k hk
  rw [Finset.mem_Ico] at hk
  exact term_nonneg h1 h3 hD h5 hl (le_trans ha hk.1) (le_of_lt hk.2) hN

/-- The same with `|Δ|`, the sign of `Δ` split off through `shellSum_neg`. -/
theorem shellSum_nonneg_abs {e' D e : ℝ} {lam a b : ℕ} (h1 : 0 < e') (hD0 : D ≠ 0)
    (hD : |D| < e') (h5 : 0 < e) (hl : 1 ≤ lam) (ha : 1 ≤ a)
    (hN : 4 * e' * |D| * ((b : ℝ) / ((lam : ℝ) * Real.pi ^ 2))
            * (2 * e' * |D| + 2 * (e' ^ 2 - |D| ^ 2) / Real.pi) ≤ e' ^ 2 - |D| ^ 2) :
    0 ≤ WeilPowerShell.shellSum e' D e lam a b := by
  rcases lt_or_gt_of_ne hD0 with hneg | hpos
  · rw [← WeilPowerShell.shellSum_neg e' D e lam a b]
    rw [abs_of_neg hneg] at hD hN
    exact shellSum_nonneg h1 (by linarith) hD h5 hl ha hN
  · rw [abs_of_pos hpos] at hD hN
    exact shellSum_nonneg h1 hpos hD h5 hl ha hN

/-- info: 'WeilPowerNear.bracket_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms bracket_nonneg

/-- info: 'WeilPowerNear.term_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms term_nonneg

/-- info: 'WeilPowerNear.shellSum_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms shellSum_nonneg

/-- info: 'WeilPowerNear.shellSum_nonneg_abs' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms shellSum_nonneg_abs

end WeilPowerNear
