/-
AssemblyFloor — block E1 of `lean_stage3/design/joints.md`. 2026-11-22.

`Assembly.psiWeak_of_RH_EF_NT` with nothing rounded at the end. Inside that
proof the contour constants `c₁`, `c₂` multiply `log²x` with no `√x`, and the
zero side is a polynomial in `log T`; its closing lemmas round every term up
to one multiple of `√x·log²x`, valid from `x ≥ 16` (units 0405, 0406). Here
the floor `x₀` is a parameter, the height is the power of two just below `x²`
(`StmtExplicitFormulaPoly` allows `T ≤ x²`), and each term keeps its shape.

  rem_floor        0 ≤ c₁, 0 < x, 0 < T, x² ≤ 2T, 0 ≤ G ≤ 3L
                     ⊢ c₁·x·G²/T ≤ 18·c₁·L²/x
  zeroinner_floor  (K+1)·log 2 ≤ 2L, 1 ≤ L, R ≤ 2(b₁+b₂)L + b₃
                     ⊢ the zero side's inner factor ≤ 2(L² + (4+4b₁+4b₂)L + 2b₃ + 2) + 2W
  floor_arith      0 < L₀ ≤ L, 0 < S₀ ≤ S, 0 < x₀ ≤ x
                     ⊢ the sum ≤ (4 + P/L₀ + Q/L₀² + 18c₁/(x₀S₀) + c₂/(S₀L₀))·S·L²
  psiWeak_floor    hypotheses of `psiWeak_of_RH_EF_NT`, 16 ≤ x₀, x₁ ≤ x₀
                     ⊢ StmtPsiWeak (floorConst c₁ c₂ b₁ b₂ b₃ W x₀) 2 x₀
  schoenfeldWeak_floor_of_RH
                   RH ⊢ ∃ c₁ c₂ ≥ 0, ∀ x₀ ≥ 16, the π-side bound with constant
                     3·floorConst c₁ c₂ 112 0 698 W x₀ + 13, one logarithm,
                     on x ≥ max (x₀²) 9

What the next slice needs: `c₁`, `c₂` as numerals (three compactness constants
upstream of them are unnamed), and the gate read on the `√x·log x` shape.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.Glue
import Stage3.ArgCount

namespace Stage3

open Kadiri Complex Chebyshev
open scoped Chebyshev

noncomputable section

/-- The constant of the assembly at floor `x₀`. -/
def floorConst (c₁ c₂ b₁ b₂ b₃ W x₀ : ℝ) : ℝ :=
  4 + (16 + 16 * b₁ + 16 * b₂) / Real.log x₀
    + (8 * b₃ + 8 + 4 * W) / Real.log x₀ ^ 2
    + 18 * c₁ / (x₀ * Real.sqrt x₀) + c₂ / (Real.sqrt x₀ * Real.log x₀)

/-- If `c₁`, `c₂`, `b₁`, `b₂`, `b₃`, `W` are nonnegative and `16 ≤ x₀`, then the assembly's
constant `floorConst c₁ c₂ b₁ b₂ b₃ W x₀` is nonnegative. -/
theorem floorConst_nonneg {c₁ c₂ b₁ b₂ b₃ W x₀ : ℝ} (hc₁ : 0 ≤ c₁) (hc₂ : 0 ≤ c₂)
    (hb₁ : 0 ≤ b₁) (hb₂ : 0 ≤ b₂) (hb₃ : 0 ≤ b₃) (hW : 0 ≤ W) (hx₀ : 16 ≤ x₀) :
    0 ≤ floorConst c₁ c₂ b₁ b₂ b₃ W x₀ := by
  have hx0 : (0 : ℝ) < x₀ := by linarith
  have hL : 0 < Real.log x₀ := Real.log_pos (by linarith)
  have hS : 0 < Real.sqrt x₀ := Real.sqrt_pos.mpr hx0
  unfold floorConst
  positivity

/-- The remainder with `T` near `x²`: `c₁·x·G²/T ≤ 18·c₁·L²/x`. -/
theorem rem_floor {c₁ xx TT G L : ℝ} (hc₁ : 0 ≤ c₁) (hx0 : 0 < xx) (hT0 : 0 < TT)
    (hxT : xx ^ 2 ≤ 2 * TT) (hG0 : 0 ≤ G) (hG : G ≤ 3 * L) :
    c₁ * xx * G ^ 2 / TT ≤ 18 * c₁ * L ^ 2 / xx := by
  have hsq : G ^ 2 ≤ 9 * L ^ 2 := by nlinarith
  have h1 : G ^ 2 * xx ^ 2 ≤ 9 * L ^ 2 * (2 * TT) :=
    mul_le_mul hsq hxT (by positivity) (by positivity)
  rw [div_le_div_iff₀ hT0 hx0]
  nlinarith [mul_le_mul_of_nonneg_left h1 hc₁]

/-- The zero side's inner factor, each term at its own power of `L`. -/
theorem zeroinner_floor {b₁ b₂ b₃ W R KK L : ℝ}
    (hL : 1 ≤ L) (hKK0 : 0 ≤ KK)
    (hK1 : (KK + 1) * Real.log 2 ≤ 2 * L)
    (hR : R ≤ 2 * (b₁ + b₂) * L + b₃) :
    2 * (Real.log 2 / (2 * Real.pi) * (KK + 1) * (KK + 2)
        + 3 * (KK + 1) / Real.pi + 2 * (R + 7 / 8)) + 2 * W
      ≤ 2 * (L ^ 2 + (4 + 4 * b₁ + 4 * b₂) * L + 2 * b₃ + 2) + 2 * W := by
  have hlog2lo : (0.6931471803 : ℝ) < Real.log 2 := Real.log_two_gt_d9
  have hπ : (3 : ℝ) < Real.pi := Real.pi_gt_three
  have hK1' : KK + 1 ≤ 2.9 * L := by nlinarith
  have hA1 : Real.log 2 / (2 * Real.pi) * (KK + 1) * (KK + 2)
      = ((KK + 1) * Real.log 2) * (KK + 2) / (2 * Real.pi) := by ring
  have hA2 : ((KK + 1) * Real.log 2) * (KK + 2) / (2 * Real.pi)
      ≤ (2 * L) * (KK + 2) / (2 * Real.pi) := by
    apply div_le_div_of_nonneg_right _ (by positivity)
    exact mul_le_mul_of_nonneg_right hK1 (by linarith)
  have hA3 : (2 * L) * (KK + 2) / (2 * Real.pi) ≤ (2 * L) * (KK + 2) / 6 := by
    apply div_le_div_of_nonneg_left _ (by norm_num) (by linarith)
    have : (0 : ℝ) ≤ KK + 2 := by linarith
    positivity
  have hA4 : (2 * L) * (KK + 2) / 6 ≤ (2.9 * L ^ 2 + L) / 3 := by nlinarith
  have hB : 3 * (KK + 1) / Real.pi ≤ KK + 1 := by
    rw [div_le_iff₀ Real.pi_pos]
    nlinarith
  have hL2 : L ≤ L ^ 2 := by nlinarith
  linarith

/-- The closing arithmetic with every term at its own shape. -/
theorem floor_arith {c₁ c₂ P Q A S L xx S₀ L₀ x₀ : ℝ}
    (hc₁ : 0 ≤ c₁) (hc₂ : 0 ≤ c₂) (hP : 0 ≤ P) (hQ : 0 ≤ Q)
    (hL₀ : 0 < L₀) (hL : L₀ ≤ L) (hS₀ : 0 < S₀) (hS : S₀ ≤ S)
    (hx₀ : 0 < x₀) (hx : x₀ ≤ xx)
    (hA : A ≤ 18 * c₁ * L ^ 2 / xx + c₂ * L + S * (4 * L ^ 2 + P * L + Q)) :
    A ≤ (4 + P / L₀ + Q / L₀ ^ 2 + 18 * c₁ / (x₀ * S₀) + c₂ / (S₀ * L₀))
          * S * L ^ 2 := by
  have hL0 : 0 < L := lt_of_lt_of_le hL₀ hL
  have hS0 : 0 < S := lt_of_lt_of_le hS₀ hS
  have hrL : 1 ≤ L / L₀ := (one_le_div hL₀).mpr hL
  have hrS : 1 ≤ S / S₀ := (one_le_div hS₀).mpr hS
  have t1 : P * L * S ≤ P * L * S * (L / L₀) :=
    le_mul_of_one_le_right (by positivity) hrL
  have t2 : Q * S ≤ Q * S * (L / L₀) ^ 2 :=
    le_mul_of_one_le_right (by positivity) (one_le_pow₀ hrL)
  have t3a : 18 * c₁ * L ^ 2 / xx ≤ 18 * c₁ * L ^ 2 / x₀ :=
    div_le_div_of_nonneg_left (by positivity) hx₀ hx
  have t3b : 18 * c₁ * L ^ 2 / x₀ ≤ 18 * c₁ * L ^ 2 / x₀ * (S / S₀) :=
    le_mul_of_one_le_right (by positivity) hrS
  have t4 : c₂ * L ≤ c₂ * L * (L / L₀ * (S / S₀)) :=
    le_mul_of_one_le_right (by positivity) (one_le_mul_of_one_le_of_one_le hrL hrS)
  calc A ≤ 18 * c₁ * L ^ 2 / xx + c₂ * L + S * (4 * L ^ 2 + P * L + Q) := hA
    _ = 18 * c₁ * L ^ 2 / xx + c₂ * L + 4 * S * L ^ 2 + P * L * S + Q * S := by ring
    _ ≤ 18 * c₁ * L ^ 2 / x₀ * (S / S₀) + c₂ * L * (L / L₀ * (S / S₀))
          + 4 * S * L ^ 2 + P * L * S * (L / L₀) + Q * S * (L / L₀) ^ 2 := by
        linarith
    _ = (4 + P / L₀ + Q / L₀ ^ 2 + 18 * c₁ / (x₀ * S₀) + c₂ / (S₀ * L₀))
          * S * L ^ 2 := by
        field_simp
        try ring

/-- **The assembly at floor `x₀`.** Under RH, the truncated explicit formula
and the zero-count band, `|ψ x − x| ≤ floorConst … x₀ · √x · log²x` for
`x ≥ x₀`. The height is the power of two in `(x²/2, x²]`. -/
theorem psiWeak_floor (hRH : RiemannHypothesis)
    {c₁ c₂ x₁ b₁ b₂ b₃ W x₀ : ℝ} (hc₁ : 0 ≤ c₁) (hc₂ : 0 ≤ c₂)
    (hb₁ : 0 ≤ b₁) (hb₂ : 0 ≤ b₂) (hb₃ : 0 ≤ b₃)
    (hWeq : W = weightedZeroHeightBucket)
    (hRvM2 : 0 ≤ riemannZeta.RvM b₁ b₂ b₃ 2)
    (hEF : StmtExplicitFormulaPoly c₁ c₂ x₁)
    (hNT : riemannZeta.Riemann_vonMangoldt_bound b₁ b₂ b₃)
    (hx₀ : 16 ≤ x₀) (hx₁ : x₁ ≤ x₀) :
    StmtPsiWeak (floorConst c₁ c₂ b₁ b₂ b₃ W x₀) 2 x₀ := by
  intro x hx
  have hx16 : (16 : ℝ) ≤ x := le_trans hx₀ hx
  have hxx₁ : x₁ ≤ x := le_trans hx₁ hx
  have hx0 : (0 : ℝ) < x := by linarith
  have hx₀0 : (0 : ℝ) < x₀ := by linarith
  set L : ℝ := Real.log x with hLdef
  set S : ℝ := Real.sqrt x with hSdef
  have hW : (0 : ℝ) ≤ W := by
    rw [hWeq]
    exact weightedZeroHeightBucket_nonneg
  have hlog2 : (0.6931471803 : ℝ) < Real.log 2 := Real.log_two_gt_d9
  have hL₀ : 0 < Real.log x₀ := Real.log_pos (by linarith)
  have hLL₀ : Real.log x₀ ≤ L := Real.log_le_log hx₀0 hx
  have hL16 : Real.log 16 ≤ L := Real.log_le_log (by norm_num) hx16
  have hL164 : Real.log 16 = 4 * Real.log 2 := by
    rw [show (16 : ℝ) = 2 ^ 4 by norm_num, Real.log_pow]
    push_cast
    ring
  have hL1 : (1 : ℝ) ≤ L := by nlinarith
  have hS₀ : 0 < Real.sqrt x₀ := Real.sqrt_pos.mpr hx₀0
  have hSS₀ : Real.sqrt x₀ ≤ S := Real.sqrt_le_sqrt hx
  -- the dyadic level from x²
  have hxsq : (256 : ℝ) ≤ x ^ 2 := by nlinarith
  set n : ℕ := ⌊x ^ 2⌋₊ with hndef
  have hn : 256 ≤ n := Nat.le_floor (by exact_mod_cast hxsq)
  have hm0 : Nat.log 2 n ≠ 0 := (Nat.log_pos (by norm_num) (by omega)).ne'
  obtain ⟨K, hK⟩ := Nat.exists_eq_succ_of_ne_zero hm0
  have hTle : (2 : ℝ) ^ (K + 1) ≤ x ^ 2 := by
    have h1 := Nat.pow_log_le_self 2 (by omega : n ≠ 0)
    rw [hK] at h1
    calc (2 : ℝ) ^ (K + 1) = ((2 ^ (K + 1) : ℕ) : ℝ) := by push_cast; ring
      _ ≤ (n : ℝ) := by exact_mod_cast h1
      _ ≤ x ^ 2 := Nat.floor_le (by positivity)
  have hxT : x ^ 2 ≤ 2 * (2 : ℝ) ^ (K + 1) := by
    have h1 := Nat.lt_pow_succ_log_self (by norm_num : 1 < 2) n
    rw [hK] at h1
    have hfl : x ^ 2 < (n : ℝ) + 1 := Nat.lt_floor_add_one (x ^ 2)
    have h2 : (n : ℝ) + 1 ≤ ((2 ^ (K + 1 + 1) : ℕ) : ℝ) := by exact_mod_cast h1
    have h3 : ((2 ^ (K + 1 + 1) : ℕ) : ℝ) = 2 * (2 : ℝ) ^ (K + 1) := by
      push_cast
      ring
    linarith
  set T : ℝ := (2 : ℝ) ^ (K + 1) with hTdef
  have hT0 : (0 : ℝ) < T := by positivity
  have hT2 : (2 : ℝ) ≤ T := by
    calc (2 : ℝ) = 2 ^ 1 := by norm_num
      _ ≤ 2 ^ (K + 1) := pow_le_pow_right₀ (by norm_num) (by omega)
  have hlogT : Real.log T = ((K : ℝ) + 1) * Real.log 2 := by
    rw [hTdef, Real.log_pow]
    push_cast
    ring
  have hlogT2L : Real.log T ≤ 2 * L := by
    have h := Real.log_le_log hT0 hTle
    have h2 : Real.log (x ^ 2) = 2 * L := by
      rw [Real.log_pow]
      push_cast
      ring
    linarith
  have hK1 : ((K : ℝ) + 1) * Real.log 2 ≤ 2 * L := by rw [← hlogT]; exact hlogT2L
  have hzero := norm_zeroPartialSum_le_logsq hRH hb₁ hb₂ hRvM2 hNT hx0 K
  rw [← hTdef, ← hWeq] at hzero
  have hEFx := hEF x T hxx₁ hT2 hTle
  have hlogxT : Real.log (x * T) ≤ 3 * L := by
    rw [Real.log_mul hx0.ne' hT0.ne']
    linarith
  have hlogxT0 : (0 : ℝ) ≤ Real.log (x * T) := by
    apply Real.log_nonneg
    nlinarith
  have hrem := rem_floor hc₁ hx0 hT0 hxT hlogxT0 hlogxT
  have hRvMT : riemannZeta.RvM b₁ b₂ b₃ T ≤ 2 * (b₁ + b₂) * L + b₃ := by
    unfold riemannZeta.RvM
    have hlogT0 : (0 : ℝ) ≤ Real.log T := Real.log_nonneg (by linarith)
    have hloglogT : Real.log (Real.log T) ≤ 2 * L :=
      le_trans (Real.log_le_self hlogT0) hlogT2L
    have e1 : b₁ * Real.log T ≤ b₁ * (2 * L) :=
      mul_le_mul_of_nonneg_left hlogT2L hb₁
    have e2 : b₂ * Real.log (Real.log T) ≤ b₂ * (2 * L) :=
      mul_le_mul_of_nonneg_left hloglogT hb₂
    linarith
  have hinner := zeroinner_floor (W := W) hL1 (Nat.cast_nonneg K) hK1 hRvMT
  have hS0 : (0 : ℝ) ≤ S := Real.sqrt_nonneg x
  have hzero2 : ‖zeroPartialSum x T‖
      ≤ 2 * S * (2 * (L ^ 2 + (4 + 4 * b₁ + 4 * b₂) * L + 2 * b₃ + 2) + 2 * W) :=
    le_trans hzero (mul_le_mul_of_nonneg_left hinner (by linarith))
  have hsplit : |ψ x - x| ≤ ‖((ψ x : ℝ) : ℂ) - (x : ℂ) + zeroPartialSum x T‖
      + ‖zeroPartialSum x T‖ := by
    have hid : ((ψ x - x : ℝ) : ℂ)
        = (((ψ x : ℝ) : ℂ) - (x : ℂ) + zeroPartialSum x T)
          - zeroPartialSum x T := by
      push_cast
      ring
    calc |ψ x - x| = ‖((ψ x - x : ℝ) : ℂ)‖ := by
          rw [Complex.norm_real, Real.norm_eq_abs]
      _ = ‖(((ψ x : ℝ) : ℂ) - (x : ℂ) + zeroPartialSum x T)
            - zeroPartialSum x T‖ := by rw [hid]
      _ ≤ _ := norm_sub_le _ _
  have htotal : |ψ x - x| ≤ 18 * c₁ * L ^ 2 / x + c₂ * L
      + S * (4 * L ^ 2 + (16 + 16 * b₁ + 16 * b₂) * L + (8 * b₃ + 8 + 4 * W)) := by
    linarith only [hsplit, hEFx, hrem, hzero2]
  unfold floorConst
  exact floor_arith hc₁ hc₂ (by positivity) (by positivity) hL₀ hLL₀ hS₀ hSS₀
    hx₀0 hx htotal

/-- **From RH to the `π` side, floor a parameter.** The three proved inputs
composed: `Glue.stmtEF_poly`, `ArgCount.rvM_crude`, and
`schoenfeldWeak_of_psiWeak`. -/
theorem schoenfeldWeak_floor_of_RH (hRH : RiemannHypothesis) :
    ∃ c₁ c₂ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₂ ∧ ∀ x₀ : ℝ, 16 ≤ x₀ →
      StmtSchoenfeldWeak
        (3 * floorConst c₁ c₂ 112 0 698 weightedZeroHeightBucket x₀ + 13) 1
        (max (x₀ ^ 2) 9) (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li := by
  obtain ⟨c₁, c₂, hc₁, hc₂, hEF⟩ := Glue.stmtEF_poly
  refine ⟨c₁, c₂, hc₁, hc₂, fun x₀ hx₀ => ?_⟩
  have hRvM2 : 0 ≤ riemannZeta.RvM 112 0 698 2 := by
    unfold riemannZeta.RvM
    have := Real.log_nonneg (show (1 : ℝ) ≤ 2 by norm_num)
    linarith
  have hpsi := psiWeak_floor hRH hc₁ hc₂ (by norm_num) le_rfl (by norm_num) rfl
    hRvM2 hEF ArgCount.rvM_crude hx₀ hx₀
  exact schoenfeldWeak_of_psiWeak (k := 2) le_rfl (by linarith)
    (floorConst_nonneg hc₁ hc₂ (by norm_num) le_rfl (by norm_num)
      weightedZeroHeightBucket_nonneg hx₀) hpsi

end

/-- info: 'Stage3.psiWeak_floor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms psiWeak_floor

/-- info: 'Stage3.schoenfeldWeak_floor_of_RH' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms schoenfeldWeak_floor_of_RH

end Stage3
