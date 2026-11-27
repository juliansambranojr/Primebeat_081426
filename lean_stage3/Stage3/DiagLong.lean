/-
# DiagLong — block S13 of `lean_stage3/design/stencil.md`, B3 step 1, the diagonal at any length. 2026-11-25.

The goal was `FloorLong.StmtDiagErr P θ R κ` for every `θ > 0`. Today it is
`Diagonal.diag_young`, `θ < 1/2`. This module proves the same range by a different route, and
reduces every `θ ≥ 1/2` to one named Prop, `StmtDiagTail`. That Prop is equivalent to the
goal, so the reduction loses nothing. The θ range proved is `0 ≤ θ < 1/2`. It stops there
because of a lost factor, named below.

**The split.** `diag_shift` writes `diagSum = ŵ(0) ζ(1+α+β) S(α,β,0) + J(ζ S)`, where `J` is
the integral shifted to `Re s = −1/4`. `S(α,β,s)` is a sum over pairs `(h, k)`. Each term
carries `(h'k')^(−s)`, with `h' = h/(h,k)` and `k' = k/(h,k)`. We split the pairs at
`h'k' = X = T^(1−η)` (`cF`, `cG`, `diag_split`). The short pairs lose nothing on the shifted
line: `J(ζ S_short) ≪ L⁵ T^(3/4) X^(1/4) = L⁵ T^(1−η/4) = O(T/L)` at every length
(`short_part`). The long pairs `h'k' > T^(1−η)` exist only when `M² > T^(1−η)`, so only when
`θ > (1−η)/2`. For `θ < 1/2` and `η = 1 − 2θ` there are none (`Zc_cG_zero`), which gives
`stmtDiagErr_holds`.

**The lost factor (CLAUDE.md, "a lost factor is a design failure").** Take the long pairs on
the line `Re s = −A`. The weight gives `T^(−A)`. Their terms in `S` have size
`(hk)^(−1/2)(h'k')^(A−1/2)`, and over `h, k ≤ M` they add to about `M^(2A)`. So the line
costs `T^(1−A) M^(2A) = T^(1 + A(2θ−1))`. For `θ ≥ 1/2` that is at least `T` for every
`A ≥ 0`. The factor `T^(A(2θ−1))` grows with `T`. It is the size of the long pairs on the
shifted line, and no step can remove it. Young's route meets the same factor. Young (§6,
after (6.2), read this session) moves `u, v` to `Re = δ` and `s` to `Re s = −δ + ε`. The
`1/ζ(1+α+u+s)`, `1/ζ(1+β+v+s)` of (6.2) must stay right of the zeros, so the saving in
`s` cannot pass the cost `M^(2δ)` in `u, v`. Young says the new contour gives `O(T^(1−ε))`
because `M ≤ T^θ` with `θ < 1/2` (the text copy reads "θ < 21" for `θ < 1/2`). His route
reaches `θ < 1/2`, the tree's range; §6 moves `u, v` only to `Re = δ`. On
the line `Re s = 0`, with absolute values, the long pairs cost `T · ζ(1+α+β) · Σ_long |C R|`,
and that grows like a power of `L` (`checks/diaglong/tail.out`, column `L2abs`).

**What the long pairs need (on paper, unchecked by anyone else).** On a long pair, the
shifted term per pair is `e(h'k')`. It is a smooth function of `x = h'k'`: about `0` for
`x ≪ T` and about `−ŵ(0) ζ(1+α+β)` for `x ≫ T`. So `J(ζ S_long) ≈ −ŵ(0) ζ(1+α+β)
Σ_{h'k' > T} C_{hk} R_{hk}(0)` plus a smooth transition. When `h'k' > Y²`, one of `h'`,
`k'` exceeds `Y`. Summed over that variable with the other fixed, the term is a tail
`Σ_{n > Y, (n, q) = 1} μ(n) n^(−1−β) F(log n)`, with `F` a polynomial times `e`. The
statement needs this tail to be `≪ (log Y)^(−A)`, `A ≥ 6`, uniformly in `q ≤ T^(2θ)`. That
is the prime number theorem with a classical error term, stated for `μ`. It needs no power
saving, and it holds at every `θ`. So `StmtDiagErr` is plausibly true for every `θ > 0`, by
the cancellation of `μ`. No contour shift with a power saving reaches it. The numeric check agrees and proves nothing: `L²·tail` stays small and
changes sign as `M` grows (θ = 0.6: between −0.0013 and 0.0047; θ = 0.75: 0.018 to 0.073;
θ = 1: between −0.82 and 0.12, with no drift), while `L²·abs` grows (0.94 → 3.70, 10.2 → 42.3,
31.8 → 134 for `M = 1000 → 16000`). Run it with `python3 -I checks/diaglong/tail.py`.
Nothing in the tree gives `Σ μ(n)/n` with a rate. PNT+ at the pin
(`PrimeNumberTheoremAnd/Consequences.lean`) has `mu_pnt`, `Σ_{n<x} μ(n) = o(x)` with no rate,
and `sum_mobius_div_self_le`, `|Σ_{n<N} μ(n)/n| ≤ 1`.

| name | content | status |
|---|---|---|
| `hkr`, `Sc`, `SBc`, `cF`, `cG`, `Zc`, `Jsh` | `h'k'`; the `h,k`-sum with any coefficients and its line bound; the short and long pairs; `ζ·Sc`; the integral on `Re s = −1/4` | defined |
| `Sdiag_split`, `Zd_split` | `S = S_short + S_long` | proved |
| `line_int`, `J_add` | `J(Z₁ + Z₂) = J(Z₁) + J(Z₂)` | proved |
| `J_bound` | `‖J(Z)‖ ≤ K₀ N T (T/8π)^(−1/4) K_Z` when `‖Z(−1/4+iy)‖ ≤ K_Z e^(2\|y\|)` | proved |
| `diag_split` | `diagSum = ŵ(0) ζ(1+α+β) S(α,β,0) + J(ζ S_short) + J(ζ S_long)` | proved |
| `pow_shift_gen`, `short_fac`, `gcd_sum1`, `SBF_young` | `SBc_short(−1/4) ≤ B² e^(2θκ) X^(1/4) (1 + log M)³`, any `θ ≥ 0` | proved |
| `final_size_long`, `short_part` | `J(ζ S_short) = O(T/L)` at `X = T^(1−η)`, every `θ ≥ 0`, `η > 0` | proved |
| `StmtDiagTail` | `J(ζ S_long) = O(T/L)` | OPEN for `2θ > 1 − η` (named Prop) |
| `Zc_cG_zero`, `stmtDiagTail_of_le` | no long pairs for `2θ ≤ 1 − η` | proved |
| `stmtDiagErr_of_tail` | `StmtDiagTail → StmtDiagErr`, every `θ ≥ 0` | proved |
| `tail_of_stmtDiagErr` | `StmtDiagErr → StmtDiagTail`, every `θ ≥ 0` | proved |
| `stmtDiagErr_holds` | `StmtDiagErr P θ R κ` for `0 ≤ θ < 1/2` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below on each main theorem.
-/
import Stage3.FloorLongErr

namespace DiagLong

open Complex MeasureTheory Filter Topology ApproxFE ApproxBounds TwistedMoment Diagonal

noncomputable section

/-! ## Notation -/

/-- `h'k'`, with `h' = h/(h,k)`, `k' = k/(h,k)`. -/
def hkr (h k : ℕ) : ℕ := (h / Nat.gcd h k) * (k / Nat.gcd h k)

/-- The diagonal's `h,k`-sum with any coefficients: `Σ_{h,k ≤ M} c_{hk} k'^(−(1/2+α+s))
h'^(−(1/2+β+s))`; `Sdiag` is `c = Chk`. -/
def Sc (M : ℕ) (c : ℕ → ℕ → ℂ) (α β s : ℂ) : ℂ :=
  ∑ h ∈ Finset.Icc 1 M, ∑ k ∈ Finset.Icc 1 M, c h k * Rhk α β h k s

/-- The bound for `‖Sc(σ+iy)‖`. -/
def SBc (M : ℕ) (c : ℕ → ℕ → ℂ) (α β : ℂ) (σ : ℝ) : ℝ :=
  ∑ h ∈ Finset.Icc 1 M, ∑ k ∈ Finset.Icc 1 M, ‖c h k‖ *
    (((k / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 2 + α.re + σ)) *
      ((h / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 2 + β.re + σ)))

/-- The short pairs, `h'k' ≤ X`. -/
def cF (a : ℕ → ℂ) (σ₀ X : ℝ) (h k : ℕ) : ℂ :=
  if ((hkr h k : ℕ) : ℝ) ≤ X then Chk a σ₀ h k else 0

/-- The long pairs, `h'k' > X`. -/
def cG (a : ℕ → ℂ) (σ₀ X : ℝ) (h k : ℕ) : ℂ :=
  if ((hkr h k : ℕ) : ℝ) ≤ X then 0 else Chk a σ₀ h k

/-- `ζ(1+α+β+2s)·Sc(s)`. -/
def Zc (M : ℕ) (c : ℕ → ℕ → ℂ) (α β s : ℂ) : ℂ :=
  riemannZeta (1 + α + β + 2 * s) * Sc M c α β s

/-- The shifted integral, `∫ w(t) (1/2πi)∫_(−1/4) K(s,t) Z(s) ds dt`. -/
def Jsh {T L : ℝ} (W : Weight T L) (α β : ℂ) (Z : ℂ → ℂ) : ℂ :=
  ∫ t, (W.w t : ℂ) * VerticalIntegral' (fun s => KY α β t s * Z s) (-(1 / 4))

/-! ## The split of the pairs -/

theorem Sdiag_split (M : ℕ) (a : ℕ → ℂ) (σ₀ X : ℝ) (α β s : ℂ) :
    Sdiag M a σ₀ α β s = Sc M (cF a σ₀ X) α β s + Sc M (cG a σ₀ X) α β s := by
  unfold Sdiag Sc cF cG
  rw [← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl fun h _ => ?_
  rw [← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl fun k _ => ?_
  split_ifs <;> ring

theorem Zd_split (M : ℕ) (a : ℕ → ℂ) (σ₀ X : ℝ) (α β : ℂ) :
    Zd M a σ₀ α β = fun s => Zc M (cF a σ₀ X) α β s + Zc M (cG a σ₀ X) α β s := by
  funext s
  unfold Zd Zc
  rw [Sdiag_split M a σ₀ X]
  ring

theorem Sc_differentiable (M : ℕ) (c : ℕ → ℕ → ℂ) (α β : ℂ) :
    Differentiable ℂ (Sc M c α β) := by
  have e : Sc M c α β = fun s => ∑ h ∈ Finset.Icc 1 M, ∑ k ∈ Finset.Icc 1 M,
      c h k * Rhk α β h k s := rfl
  rw [e]
  refine Differentiable.fun_sum fun h hh => Differentiable.fun_sum fun k hk => ?_
  exact (differentiable_const _).mul
    (Rhk_differentiable α β (Finset.mem_Icc.mp hh).1 (Finset.mem_Icc.mp hk).1)

theorem Sc_norm_le (M : ℕ) (c : ℕ → ℕ → ℂ) (α β : ℂ) {σ σ' : ℝ} (hσ : σ' ≤ σ) (y : ℝ) :
    ‖Sc M c α β (σ + y * I)‖ ≤ SBc M c α β σ' := by
  unfold Sc SBc
  refine (norm_sum_le _ _).trans (Finset.sum_le_sum fun h hh => ?_)
  refine (norm_sum_le _ _).trans (Finset.sum_le_sum fun k hk => ?_)
  rw [norm_mul]
  exact mul_le_mul_of_nonneg_left (Rhk_norm_le α β (Finset.mem_Icc.mp hh).1
    (Finset.mem_Icc.mp hk).1 hσ y) (norm_nonneg _)

theorem SBc_nonneg (M : ℕ) (c : ℕ → ℕ → ℂ) (α β : ℂ) (σ : ℝ) : 0 ≤ SBc M c α β σ := by
  unfold SBc
  exact Finset.sum_nonneg fun h _ => Finset.sum_nonneg fun k _ => by positivity

theorem Zc_cont (M : ℕ) (c : ℕ → ℕ → ℂ) {α β : ℂ} {σ : ℝ} (hne : α.re + β.re + 2 * σ ≠ 0) :
    Continuous fun y : ℝ => Zc M c α β (σ + y * I) :=
  (zeta_line_cont hne).mul ((Sc_differentiable M c α β).continuous.comp (by fun_prop))

/-- `‖Zc(−1/4+iy)‖ ≤ C_z SBc(−1/4) e^(2|y|)`. -/
theorem Zc_left : ∃ Cz : ℝ, 0 ≤ Cz ∧ ∀ (M : ℕ) (c : ℕ → ℕ → ℂ) (α β : ℂ), ‖α‖ ≤ 1 / 10 →
    ‖β‖ ≤ 1 / 10 → ∀ y : ℝ, ‖Zc M c α β (((-(1 / 4) : ℝ) : ℂ) + y * I)‖ ≤
      Cz * SBc M c α β (-(1 / 4)) * Real.exp (2 * |y|) := by
  obtain ⟨Cz, hCz0, hCz⟩ := zeta_left
  refine ⟨Cz, hCz0, fun M c α β hα hβ y => ?_⟩
  unfold Zc
  rw [norm_mul]
  calc ‖riemannZeta (1 + α + β + 2 * ((((-(1 / 4) : ℝ)) : ℂ) + y * I))‖ *
        ‖Sc M c α β (((-(1 / 4) : ℝ) : ℂ) + y * I)‖
      ≤ (Cz * Real.exp (2 * |y|)) * SBc M c α β (-(1 / 4)) :=
        mul_le_mul (hCz α β hα hβ y) (Sc_norm_le M c α β le_rfl y) (norm_nonneg _)
          (by positivity)
    _ = Cz * SBc M c α β (-(1 / 4)) * Real.exp (2 * |y|) := by ring

/-! ## The shifted integral is additive and bounded by the line's supremum -/

theorem line_int {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {t : ℝ} (ht : 1 ≤ t)
    {Z : ℂ → ℂ} (hZc : Continuous fun y : ℝ => Z (((-(1 / 4) : ℝ) : ℂ) + y * I)) {K : ℝ}
    (hZ : ∀ y : ℝ, ‖Z (((-(1 / 4) : ℝ) : ℂ) + y * I)‖ ≤ K * Real.exp (2 * |y|)) :
    Integrable fun y : ℝ => KY α β t (((-(1 / 4) : ℝ) : ℂ) + y * I) *
      Z (((-(1 / 4) : ℝ) : ℂ) + y * I) := by
  obtain ⟨C, hC0, hC⟩ := KY_bd (σ := -(1 / 4)) (by norm_num) (by norm_num)
  have hK0 : 0 ≤ K := by
    have := (norm_nonneg _).trans (hZ 0)
    simpa using this
  set H : ℝ := C * (1 + 1 / ‖α + β‖ ^ 2) * (t / (2 * Real.pi)) ^ (-(1 / 4) : ℝ) * K *
    Real.exp 4 with hH
  refine Integrable.mono' ((integrable_exp_neg_mul_sq (by norm_num : (0 : ℝ) < 1 / 4)).const_mul H)
    ?_ (ae_of_all _ fun y => ?_)
  · have c0 := (KY_joint_cont hα hβ (σ := -(1 / 4)) (by norm_num) (by norm_num)).comp
      (continuous_const.prodMk continuous_id : Continuous fun y : ℝ => (t, y))
    have e : (fun y : ℝ => KY α β t (((-(1 / 4) : ℝ) : ℂ) + y * I)) =
        (fun p : ℝ × ℝ => KY α β p.1 (((-(1 / 4) : ℝ) : ℂ) + p.2 * I)) ∘
          (fun y : ℝ => (t, y)) := rfl
    have c1 : Continuous fun y : ℝ => KY α β t (((-(1 / 4) : ℝ) : ℂ) + y * I) := by
      rw [e]
      exact c0
    exact (c1.mul hZc).aestronglyMeasurable
  · rw [norm_mul]
    have hk := hC α β hα hβ t ht y
    have hg := gauss_exp y
    calc ‖KY α β t (((-(1 / 4) : ℝ) : ℂ) + y * I)‖ * ‖Z (((-(1 / 4) : ℝ) : ℂ) + y * I)‖
        ≤ (C * (1 + 1 / ‖α + β‖ ^ 2) * (t / (2 * Real.pi)) ^ (-(1 / 4) : ℝ) *
            Real.exp (-(1 / 2) * y ^ 2)) * (K * Real.exp (2 * |y|)) :=
          mul_le_mul hk (hZ y) (norm_nonneg _) (by positivity)
      _ = C * (1 + 1 / ‖α + β‖ ^ 2) * (t / (2 * Real.pi)) ^ (-(1 / 4) : ℝ) * K *
            (Real.exp (-(1 / 2) * y ^ 2) * Real.exp (2 * |y|)) := by ring
      _ ≤ C * (1 + 1 / ‖α + β‖ ^ 2) * (t / (2 * Real.pi)) ^ (-(1 / 4) : ℝ) * K *
            (Real.exp 4 * Real.exp (-(1 / 4) * y ^ 2)) :=
          mul_le_mul_of_nonneg_left hg (by positivity)
      _ = H * Real.exp (-(1 / 4) * y ^ 2) := by rw [hH]; ring

/-- **The shifted integral is additive** in `Z`, for `Z₁, Z₂` continuous on the line with
`‖Z_i(−1/4+iy)‖ ≤ K_i e^(2|y|)`. -/
theorem J_add {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10)
    (hβ : ‖β‖ ≤ 1 / 10) {Z1 Z2 : ℂ → ℂ}
    (h1c : Continuous fun y : ℝ => Z1 (((-(1 / 4) : ℝ) : ℂ) + y * I))
    (h2c : Continuous fun y : ℝ => Z2 (((-(1 / 4) : ℝ) : ℂ) + y * I)) {K1 K2 : ℝ}
    (h1 : ∀ y : ℝ, ‖Z1 (((-(1 / 4) : ℝ) : ℂ) + y * I)‖ ≤ K1 * Real.exp (2 * |y|))
    (h2 : ∀ y : ℝ, ‖Z2 (((-(1 / 4) : ℝ) : ℂ) + y * I)‖ ≤ K2 * Real.exp (2 * |y|)) :
    Jsh W α β (fun s => Z1 s + Z2 s) = Jsh W α β Z1 + Jsh W α β Z2 := by
  have i1 := wVI_integrable W hT hα hβ (σ := -(1 / 4)) (by norm_num) (by norm_num) h1c h1
  have i2 := wVI_integrable W hT hα hβ (σ := -(1 / 4)) (by norm_num) (by norm_num) h2c h2
  unfold Jsh
  rw [← integral_add i1 i2]
  congr 1
  funext t
  by_cases ht : t ∈ Set.Icc (T / 4) (2 * T)
  · have ht1 : 1 ≤ t := by linarith [ht.1]
    have l1 := line_int hα hβ ht1 h1c h1
    have l2 := line_int hα hβ ht1 h2c h2
    rw [← mul_add]
    congr 1
    simp only [VerticalIntegral', VerticalIntegral, smul_eq_mul]
    have e : (fun y : ℝ => KY α β t (((-(1 / 4) : ℝ) : ℂ) + y * I) *
        (Z1 (((-(1 / 4) : ℝ) : ℂ) + y * I) + Z2 (((-(1 / 4) : ℝ) : ℂ) + y * I))) =
        fun y : ℝ => KY α β t (((-(1 / 4) : ℝ) : ℂ) + y * I) * Z1 (((-(1 / 4) : ℝ) : ℂ) + y * I) +
          KY α β t (((-(1 / 4) : ℝ) : ℂ) + y * I) * Z2 (((-(1 / 4) : ℝ) : ℂ) + y * I) := by
      funext y
      ring
    rw [e, integral_add l1 l2]
    ring
  · rw [(W.zero_out ht).1]
    simp

/-- **The shifted integral by the line's supremum**: `‖J(Z)‖ ≤ K₀ N T (T/8π)^(−1/4) K_Z` when
`‖Z(−1/4+iy)‖ ≤ K_Z e^(2|y|)`; `Diagonal.shifted_bound` with `ζ·S` replaced by any `Z`. -/
theorem J_bound : ∃ K0 : ℝ, 0 ≤ K0 ∧ ∀ (T L : ℝ) (W : Weight T L), 4 ≤ T →
    ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ (Z : ℂ → ℂ) (KZ : ℝ),
      (∀ y : ℝ, ‖Z (((-(1 / 4) : ℝ) : ℂ) + y * I)‖ ≤ KZ * Real.exp (2 * |y|)) →
        ‖Jsh W α β Z‖ ≤ K0 * (1 + 1 / ‖α + β‖ ^ 2) * T * (T / (8 * Real.pi)) ^ (-(1 / 4) : ℝ) *
          KZ := by
  obtain ⟨C, hC0, hC⟩ := KY_bd (σ := -(1 / 4)) (by norm_num) (by norm_num)
  refine ⟨2 * (1 / (2 * Real.pi) * (C * Real.exp 4 * Real.sqrt (Real.pi / (1 / 4)))),
    by positivity, fun T L W hT α β hα hβ Z S hZ => ?_⟩
  have hT0 : 0 < T := by linarith
  have hS0 : 0 ≤ S := by
    have := (norm_nonneg _).trans (hZ 0)
    simpa using this
  set N : ℝ := 1 + 1 / ‖α + β‖ ^ 2 with hN
  set P : ℝ := (T / (8 * Real.pi)) ^ (-(1 / 4) : ℝ) with hP
  have hP0 : 0 ≤ P := by positivity
  set B : ℝ := 1 / (2 * Real.pi) * (C * Real.exp 4 * Real.sqrt (Real.pi / (1 / 4))) * N * P * S
    with hB
  have hpt : ∀ t ∈ Set.Icc (T / 4) (2 * T), ‖(W.w t : ℂ) *
      VerticalIntegral' (fun s => KY α β t s * Z s) (-(1 / 4))‖ ≤ B := by
    intro t ht
    have ht1 : 1 ≤ t := by linarith [ht.1]
    have hw : ‖(W.w t : ℂ)‖ ≤ 1 := by rw [Complex.norm_real, Real.norm_eq_abs]; exact W.abs_le_one t
    have hr : (t / (2 * Real.pi)) ^ (-(1 / 4) : ℝ) ≤ P := by
      rw [hP]
      apply Real.rpow_le_rpow_of_nonpos (by positivity) _ (by norm_num)
      rw [div_le_div_iff₀ (by positivity) (by positivity)]
      nlinarith [ht.1, Real.pi_pos]
    have hint : ∀ y : ℝ, ‖KY α β t (((-(1 / 4) : ℝ) : ℂ) + y * I) *
        Z (((-(1 / 4) : ℝ) : ℂ) + y * I)‖ ≤
        (C * Real.exp 4 * N * P * S) * Real.exp (-(1 / 4) * y ^ 2) := by
      intro y
      have hk := hC α β hα hβ t ht1 y
      have hs := hZ y
      have hg := gauss_exp y
      rw [norm_mul]
      have hk' : ‖KY α β t (((-(1 / 4) : ℝ) : ℂ) + y * I)‖ ≤
          C * N * P * Real.exp (-(1 / 2) * y ^ 2) := by
        refine hk.trans (mul_le_mul_of_nonneg_right ?_ (Real.exp_pos _).le)
        exact mul_le_mul_of_nonneg_left hr (by positivity)
      calc ‖KY α β t (((-(1 / 4) : ℝ) : ℂ) + y * I)‖ * ‖Z (((-(1 / 4) : ℝ) : ℂ) + y * I)‖
          ≤ (C * N * P * Real.exp (-(1 / 2) * y ^ 2)) * (S * Real.exp (2 * |y|)) :=
            mul_le_mul hk' hs (norm_nonneg _) (by positivity)
        _ = C * N * P * S * (Real.exp (-(1 / 2) * y ^ 2) * Real.exp (2 * |y|)) := by ring
        _ ≤ C * N * P * S * (Real.exp 4 * Real.exp (-(1 / 4) * y ^ 2)) :=
            mul_le_mul_of_nonneg_left hg (by positivity)
        _ = _ := by ring
    have hgi : Integrable fun y : ℝ => (C * Real.exp 4 * N * P * S) *
        Real.exp (-(1 / 4) * y ^ 2) :=
      (integrable_exp_neg_mul_sq (by norm_num : (0 : ℝ) < 1 / 4)).const_mul _
    have hle : ∫ y : ℝ, ‖KY α β t (((-(1 / 4) : ℝ) : ℂ) + y * I) *
        Z (((-(1 / 4) : ℝ) : ℂ) + y * I)‖ ≤
        (C * Real.exp 4 * N * P * S) * Real.sqrt (Real.pi / (1 / 4)) := by
      have := integral_mono_of_nonneg (ae_of_all _ fun y => norm_nonneg _) hgi (ae_of_all _ hint)
      rwa [integral_const_mul, integral_gaussian] at this
    have hv := norm_VI_le (fun s => KY α β t s * Z s) (-(1 / 4))
    rw [norm_mul]
    calc ‖(W.w t : ℂ)‖ * ‖VerticalIntegral' (fun s => KY α β t s * Z s) (-(1 / 4))‖
        ≤ 1 * (1 / (2 * Real.pi) * ((C * Real.exp 4 * N * P * S) *
            Real.sqrt (Real.pi / (1 / 4)))) :=
          mul_le_mul hw (hv.trans (mul_le_mul_of_nonneg_left hle (by positivity))) (norm_nonneg _)
            zero_le_one
      _ = B := by rw [hB]; ring
  have h := norm_integral_le_Icc (a := T / 4) (b := 2 * T) (K := B) (by linarith)
    (fun t ht => by rw [(W.zero_out ht).1]; simp) hpt
  have hB0 : 0 ≤ B := by positivity
  unfold Jsh
  calc _ ≤ B * (2 * T - T / 4) := h
    _ ≤ B * (2 * T) := mul_le_mul_of_nonneg_left (by linarith) hB0
    _ = _ := by rw [hB]; ring

/-- **The diagonal in three pieces**: `diagSum = ŵ(0) ζ(1+α+β) S(α,β,0) + J(ζ S_{h'k' ≤ X}) +
J(ζ S_{h'k' > X})`, any `X`, any coefficients. -/
theorem diag_split {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) (M : ℕ) (a : ℕ → ℂ) (σ₀ X : ℝ)
    {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hαβ : α + β ≠ 0) :
    diagSum W M a σ₀ α β 1 =
      (what0 W : ℂ) * (riemannZeta (1 + α + β) * Sdiag M a σ₀ α β 0) +
        (Jsh W α β (Zc M (cF a σ₀ X) α β) + Jsh W α β (Zc M (cG a σ₀ X) α β)) := by
  have ra := re_small' hα
  have rb := re_small' hβ
  obtain ⟨Cz, hCz0, hCz⟩ := Zc_left
  have hne : α.re + β.re + 2 * (-(1 / 4) : ℝ) ≠ 0 := by intro e; linarith
  rw [diag_shift W hT M a σ₀ hα hβ hαβ]
  congr 1
  have e : ∫ t, (W.w t : ℂ) * VerticalIntegral' (fun s => KY α β t s * Zd M a σ₀ α β s)
      (-(1 / 4)) = Jsh W α β (Zd M a σ₀ α β) := rfl
  rw [e, Zd_split M a σ₀ X]
  exact J_add W hT hα hβ (Zc_cont M _ hne) (Zc_cont M _ hne) (hCz M _ α β hα hβ)
    (hCz M _ α β hα hβ)

/-! ## The short pairs at any length -/

/-- `j^(−(1/2+x−1/4)) ≤ e^(θκ) j^(−1/4)` for `1 ≤ j ≤ M ≤ T^θ`, `θ ≥ 0`, `|x| ≤ κ/log T`;
`Diagonal.pow_shift_le` with `θ < 1/2` replaced by `θ ≥ 0`. -/
theorem pow_shift_gen {T θ κ x : ℝ} (hT : 1 < T) (hθ : 0 ≤ θ) {j M : ℕ} (hj : 1 ≤ j)
    (hjM : j ≤ M) (hM : (M : ℝ) ≤ T ^ θ) (hx : |x| ≤ κ / Real.log T) :
    (j : ℝ) ^ (-(1 / 2 + x + -(1 / 4))) ≤ Real.exp (θ * κ) * (j : ℝ) ^ (-(1 / 4) : ℝ) := by
  have hj0 : (0 : ℝ) < j := by exact_mod_cast hj
  have hj1 : (1 : ℝ) ≤ j := by exact_mod_cast hj
  have hL : 0 < Real.log T := Real.log_pos hT
  have hT0 : 0 < T := by linarith
  have hjT : (j : ℝ) ≤ T ^ θ := le_trans (by exact_mod_cast hjM) hM
  have hlog : Real.log j ≤ θ * Real.log T := by
    rw [← Real.log_rpow hT0]
    exact Real.log_le_log hj0 hjT
  have hlj : 0 ≤ Real.log j := Real.log_nonneg hj1
  have hxL : |x| * Real.log T ≤ κ := by
    rw [le_div_iff₀ hL] at hx
    exact hx
  have e : (j : ℝ) ^ (-(1 / 2 + x + -(1 / 4))) = (j : ℝ) ^ (-(1 / 4) : ℝ) * (j : ℝ) ^ (-x) := by
    rw [← Real.rpow_add hj0]
    congr 1
    ring
  rw [e, mul_comm]
  apply mul_le_mul_of_nonneg_right _ (by positivity)
  rw [Real.rpow_def_of_pos hj0]
  apply Real.exp_le_exp.mpr
  have h1 : Real.log j * -x ≤ Real.log j * |x| :=
    mul_le_mul_of_nonneg_left (by linarith [neg_abs_le x, le_abs_self x]) hlj
  have h2 : Real.log j * |x| ≤ θ * Real.log T * |x| :=
    mul_le_mul_of_nonneg_right hlog (abs_nonneg x)
  have h3 : θ * Real.log T * |x| ≤ θ * κ := by
    have := mul_le_mul_of_nonneg_left hxL hθ
    linarith
  linarith

/-- `a^(−3/4) b^(−3/4) ≤ X^(1/4) a^(−1) b^(−1)` for `ab ≤ X`. -/
theorem short_fac {a b : ℕ} (ha : 1 ≤ a) (hb : 1 ≤ b) {X : ℝ} (hX : ((a * b : ℕ) : ℝ) ≤ X) :
    (a : ℝ) ^ (-(3 / 4) : ℝ) * (b : ℝ) ^ (-(3 / 4) : ℝ) ≤
      X ^ (1 / 4 : ℝ) * ((a : ℝ)⁻¹ * (b : ℝ)⁻¹) := by
  have ha0 : (0 : ℝ) < a := by exact_mod_cast ha
  have hb0 : (0 : ℝ) < b := by exact_mod_cast hb
  have hp : (0 : ℝ) < (a : ℝ) * b := mul_pos ha0 hb0
  have hX' : (a : ℝ) * b ≤ X := by rw [← Nat.cast_mul]; exact hX
  rw [← Real.mul_rpow ha0.le hb0.le]
  have e1 : ((a : ℝ) * b) ^ (-(3 / 4) : ℝ) = ((a : ℝ) * b) ^ (1 / 4 : ℝ) * ((a : ℝ) * b)⁻¹ := by
    rw [← Real.rpow_neg_one, ← Real.rpow_add hp]
    norm_num
  rw [e1, mul_inv]
  exact mul_le_mul_of_nonneg_right (Real.rpow_le_rpow hp.le hX' (by norm_num)) (by positivity)

/-- **The gcd sum at exponent one**: `Σ_{h,k ≤ M} d^(−1) h'^(−1) k'^(−1) ≤ (1 + log M)³`, from
`(h,k) ↦ (d, h', k')` injective (the proof of `Diagonal.gcd_sum`). -/
theorem gcd_sum1 (M : ℕ) :
    ∑ h ∈ Finset.Icc 1 M, ∑ k ∈ Finset.Icc 1 M, ((Nat.gcd h k : ℕ) : ℝ)⁻¹ *
      (((h / Nat.gcd h k : ℕ) : ℝ)⁻¹ * ((k / Nat.gcd h k : ℕ) : ℝ)⁻¹) ≤ (1 + Real.log M) ^ 3 := by
  classical
  set A : Finset ℕ := Finset.Icc 1 M with hA
  set g3 : ℕ × ℕ × ℕ → ℝ := fun x =>
    ((x.1 : ℕ) : ℝ)⁻¹ * (((x.2.1 : ℕ) : ℝ)⁻¹ * ((x.2.2 : ℕ) : ℝ)⁻¹) with hg3
  set φ : ℕ × ℕ → ℕ × ℕ × ℕ := fun p =>
    (Nat.gcd p.1 p.2, p.1 / Nat.gcd p.1 p.2, p.2 / Nat.gcd p.1 p.2) with hφ
  have hstep1 : ∑ h ∈ A, ∑ k ∈ A, ((Nat.gcd h k : ℕ) : ℝ)⁻¹ *
      (((h / Nat.gcd h k : ℕ) : ℝ)⁻¹ * ((k / Nat.gcd h k : ℕ) : ℝ)⁻¹) =
      ∑ p ∈ A ×ˢ A, g3 (φ p) := by
    rw [Finset.sum_product]
  have hinj : Set.InjOn φ ↑(A ×ˢ A) := by
    intro p _ q _ e
    simp only [hφ, Prod.mk.injEq] at e
    obtain ⟨e1, e2, e3⟩ := e
    have hp1 : p.1 = Nat.gcd p.1 p.2 * (p.1 / Nat.gcd p.1 p.2) :=
      (Nat.mul_div_cancel' (Nat.gcd_dvd_left _ _)).symm
    have hp2 : p.2 = Nat.gcd p.1 p.2 * (p.2 / Nat.gcd p.1 p.2) :=
      (Nat.mul_div_cancel' (Nat.gcd_dvd_right _ _)).symm
    have hq1 : q.1 = Nat.gcd q.1 q.2 * (q.1 / Nat.gcd q.1 q.2) :=
      (Nat.mul_div_cancel' (Nat.gcd_dvd_left _ _)).symm
    have hq2 : q.2 = Nat.gcd q.1 q.2 * (q.2 / Nat.gcd q.1 q.2) :=
      (Nat.mul_div_cancel' (Nat.gcd_dvd_right _ _)).symm
    exact Prod.ext (hp1.trans ((congrArg₂ (· * ·) e1 e2).trans hq1.symm))
      (hp2.trans ((congrArg₂ (· * ·) e1 e3).trans hq2.symm))
  have hsub : (A ×ˢ A).image φ ⊆ A ×ˢ (A ×ˢ A) := by
    intro x hx
    rw [Finset.mem_image] at hx
    obtain ⟨p, hp, rfl⟩ := hx
    rw [Finset.mem_product] at hp
    have h1 := Finset.mem_Icc.mp hp.1
    have h2 := Finset.mem_Icc.mp hp.2
    obtain ⟨hd, -, -, a1, b1, a2, b2⟩ := gcd_facts h1.1 h2.1
    simp only [hφ, Finset.mem_product, hA, Finset.mem_Icc]
    refine ⟨⟨hd, (Nat.gcd_le_left _ h1.1).trans h1.2⟩, ⟨a1, a2.trans h1.2⟩, ⟨b1, b2.trans h2.2⟩⟩
  have hg0 : ∀ x, 0 ≤ g3 x := fun x => by simp only [hg3]; positivity
  have hprod : ∑ x ∈ A ×ˢ (A ×ˢ A), g3 x = (∑ d ∈ A, ((d : ℕ) : ℝ)⁻¹) *
      ((∑ j ∈ A, ((j : ℕ) : ℝ)⁻¹) * (∑ j ∈ A, ((j : ℕ) : ℝ)⁻¹)) := by
    rw [Finset.sum_product, Finset.sum_mul]
    refine Finset.sum_congr rfl fun d _ => ?_
    rw [Finset.sum_product, Finset.sum_mul_sum, Finset.mul_sum]
    refine Finset.sum_congr rfl fun j _ => ?_
    rw [Finset.mul_sum]
  have hlog0 : 0 ≤ 1 + Real.log M := by
    rcases Nat.eq_zero_or_pos M with h0 | h0
    · rw [h0]; simp
    · have : (1 : ℝ) ≤ M := by exact_mod_cast h0
      linarith [Real.log_nonneg this]
  have hh := harm_le M
  have hh0 : 0 ≤ ∑ j ∈ A, ((j : ℕ) : ℝ)⁻¹ := Finset.sum_nonneg fun j _ => by positivity
  rw [hstep1, ← Finset.sum_image hinj]
  calc ∑ x ∈ (A ×ˢ A).image φ, g3 x ≤ ∑ x ∈ A ×ˢ (A ×ˢ A), g3 x :=
        Finset.sum_le_sum_of_subset_of_nonneg hsub fun x _ _ => hg0 x
    _ = _ := hprod
    _ ≤ (1 + Real.log M) * ((1 + Real.log M) * (1 + Real.log M)) :=
        mul_le_mul hh (mul_le_mul hh hh hh0 hlog0) (mul_nonneg hh0 hh0) hlog0
    _ = (1 + Real.log M) ^ 3 := by ring

/-- **The short pairs on `Re s = −1/4`, any length**: `SBc_F(−1/4) ≤ B² e^(2θκ) X^(1/4)
(1 + log M)³` for Young's coefficients, `‖α‖, ‖β‖ ≤ κ/log T`, `θ ≥ 0`, `X > 0`. -/
theorem SBF_young (P : Polynomial ℝ) : ∃ B : ℝ, 0 ≤ B ∧ ∀ (T θ R κ X : ℝ), 1 < T → 0 ≤ θ →
    0 < X → ∀ α β : ℂ, ‖α‖ ≤ κ / Real.log T → ‖β‖ ≤ κ / Real.log T →
      SBc (Mof T θ) (cF (aY P T θ R) (sig0 T R) X) α β (-(1 / 4)) ≤
        B ^ 2 * Real.exp (2 * (θ * κ)) *
          (X ^ (1 / 4 : ℝ) * (1 + Real.log ((Mof T θ : ℕ) : ℝ)) ^ 3) := by
  obtain ⟨B, hB0, hB⟩ := aY_bound' P
  refine ⟨B, hB0, fun T θ R κ X hT hθ hX α β hα hβ => ?_⟩
  have hM : ((Mof T θ : ℕ) : ℝ) ≤ T ^ θ := Nat.floor_le (by positivity)
  have hxa : |α.re| ≤ κ / Real.log T := (Complex.abs_re_le_norm α).trans hα
  have hxb : |β.re| ≤ κ / Real.log T := (Complex.abs_re_le_norm β).trans hβ
  have he : Real.exp (2 * (θ * κ)) = Real.exp (θ * κ) * Real.exp (θ * κ) := by
    rw [← Real.exp_add]
    ring_nf
  set E : ℝ := B ^ 2 * Real.exp (2 * (θ * κ)) * X ^ (1 / 4 : ℝ) with hE
  have hE0 : 0 ≤ E := by positivity
  calc SBc (Mof T θ) (cF (aY P T θ R) (sig0 T R) X) α β (-(1 / 4))
      ≤ ∑ h ∈ Finset.Icc 1 (Mof T θ), ∑ k ∈ Finset.Icc 1 (Mof T θ), E *
          (((Nat.gcd h k : ℕ) : ℝ)⁻¹ *
            (((h / Nat.gcd h k : ℕ) : ℝ)⁻¹ * ((k / Nat.gcd h k : ℕ) : ℝ)⁻¹)) := by
        unfold SBc
        refine Finset.sum_le_sum fun h hh => Finset.sum_le_sum fun k hk => ?_
        have hh1 := (Finset.mem_Icc.mp hh).1
        have hhM := (Finset.mem_Icc.mp hh).2
        have hk1 := (Finset.mem_Icc.mp hk).1
        have hkM := (Finset.mem_Icc.mp hk).2
        obtain ⟨hd, -, -, h1, k1, h2, k2⟩ := gcd_facts hh1 hk1
        have hd0 : (0 : ℝ) < ((Nat.gcd h k : ℕ) : ℝ) := by exact_mod_cast hd
        unfold cF
        by_cases hc : ((hkr h k : ℕ) : ℝ) ≤ X
        · rw [if_pos hc, Chk_norm _ _ hh1 hk1]
          have ea := hB T θ R h hh1 hhM
          have eb := hB T θ R k hk1 hkM
          have pa := pow_shift_gen hT hθ k1 (k2.trans hkM) hM hxa
          have pb := pow_shift_gen hT hθ h1 (h2.trans hhM) hM hxb
          have hsf := short_fac h1 k1 (X := X) hc
          calc ‖aY P T θ R h‖ * (h : ℝ) ^ (-sig0 T R) * (‖aY P T θ R k‖ * (k : ℝ) ^ (-sig0 T R)) *
                (((k / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 2 + α.re + -(1 / 4))) *
                  ((h / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 2 + β.re + -(1 / 4))))
              ≤ (B * (h : ℝ) ^ (-(1 / 2) : ℝ)) * (B * (k : ℝ) ^ (-(1 / 2) : ℝ)) *
                ((Real.exp (θ * κ) * ((k / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 4) : ℝ)) *
                  (Real.exp (θ * κ) * ((h / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 4) : ℝ))) :=
                mul_le_mul (mul_le_mul ea eb (by positivity) (by positivity))
                  (mul_le_mul pa pb (by positivity) (by positivity)) (by positivity) (by positivity)
            _ = B ^ 2 * Real.exp (2 * (θ * κ)) * ((h : ℝ) ^ (-(1 / 2) : ℝ) *
                (k : ℝ) ^ (-(1 / 2) : ℝ) * (((k / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 4) : ℝ) *
                  ((h / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 4) : ℝ))) := by rw [he]; ring
            _ = B ^ 2 * Real.exp (2 * (θ * κ)) * (((Nat.gcd h k : ℕ) : ℝ)⁻¹ *
                (((h / Nat.gcd h k : ℕ) : ℝ) ^ (-(3 / 4) : ℝ) *
                  ((k / Nat.gcd h k : ℕ) : ℝ) ^ (-(3 / 4) : ℝ))) := by rw [gcd_term hh1 hk1]
            _ ≤ B ^ 2 * Real.exp (2 * (θ * κ)) * (((Nat.gcd h k : ℕ) : ℝ)⁻¹ *
                (X ^ (1 / 4 : ℝ) * (((h / Nat.gcd h k : ℕ) : ℝ)⁻¹ *
                  ((k / Nat.gcd h k : ℕ) : ℝ)⁻¹))) := by
                apply mul_le_mul_of_nonneg_left _ (by positivity)
                exact mul_le_mul_of_nonneg_left hsf (by positivity)
            _ = E * (((Nat.gcd h k : ℕ) : ℝ)⁻¹ *
                (((h / Nat.gcd h k : ℕ) : ℝ)⁻¹ * ((k / Nat.gcd h k : ℕ) : ℝ)⁻¹)) := by
                rw [hE]; ring
        · rw [if_neg hc, norm_zero, zero_mul]
          positivity
    _ = E * ∑ h ∈ Finset.Icc 1 (Mof T θ), ∑ k ∈ Finset.Icc 1 (Mof T θ),
          ((Nat.gcd h k : ℕ) : ℝ)⁻¹ *
            (((h / Nat.gcd h k : ℕ) : ℝ)⁻¹ * ((k / Nat.gcd h k : ℕ) : ℝ)⁻¹) := by
        rw [Finset.mul_sum]
        refine Finset.sum_congr rfl fun h _ => ?_
        rw [Finset.mul_sum]
    _ ≤ E * (1 + Real.log ((Mof T θ : ℕ) : ℝ)) ^ 3 := mul_le_mul_of_nonneg_left (gcd_sum1 _) hE0
    _ = _ := by rw [hE]; ring

/-- **The size of the short pairs' term**: for `θ ≥ 0`, `η > 0` there is `C` with
`(1 + κ²L²) T (T/8π)^(−1/4) (T^(1−η))^(1/4) (1 + log M)³ ≤ C T/L` for `T ≥ e`, `M ≤ T^θ`. -/
theorem final_size_long {θ η : ℝ} (hθ : 0 ≤ θ) (hη : 0 < η) (κ : ℝ) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ T : ℝ, Real.exp 1 ≤ T → ∀ M : ℕ, (M : ℝ) ≤ T ^ θ →
      (1 + κ ^ 2 * Real.log T ^ 2) * T * (T / (8 * Real.pi)) ^ (-(1 / 4) : ℝ) *
        ((T ^ (1 - η)) ^ (1 / 4 : ℝ) * (1 + Real.log M) ^ 3) ≤ C * (T / Real.log T) := by
  set ε : ℝ := η / 4 with hε
  have hε0 : 0 < ε := by rw [hε]; linarith
  set G : ℝ := ((((6 : ℕ) : ℝ) + 1) / ε) ^ 6 with hG
  set Y : ℝ := (1 + κ ^ 2) * (1 + θ) ^ 3 * (8 * Real.pi) ^ (1 / 4 : ℝ) with hY
  refine ⟨Y * G, by positivity, fun T hT M hM => ?_⟩
  have hT1 : 1 ≤ T := le_trans (by linarith [Real.add_one_le_exp (1 : ℝ)]) hT
  have hT0 : 0 < T := by linarith
  set L : ℝ := Real.log T with hLd
  have hL1 : 1 ≤ L := by
    rw [hLd, ← Real.log_exp 1]
    exact Real.log_le_log (Real.exp_pos 1) hT
  have hL0 : 0 < L := by linarith
  have h8 : (0 : ℝ) < 8 * Real.pi := by positivity
  have hN : 1 + κ ^ 2 * L ^ 2 ≤ (1 + κ ^ 2) * L ^ 2 := by nlinarith [sq_nonneg κ]
  have hP : T * (T / (8 * Real.pi)) ^ (-(1 / 4) : ℝ) =
      (8 * Real.pi) ^ (1 / 4 : ℝ) * T ^ (3 / 4 : ℝ) := by
    rw [Real.div_rpow hT0.le h8.le, Real.rpow_neg h8.le, div_inv_eq_mul]
    have : T * T ^ (-(1 / 4) : ℝ) = T ^ (3 / 4 : ℝ) := by
      rw [show (3 / 4 : ℝ) = 1 + -(1 / 4) by norm_num, Real.rpow_add hT0, Real.rpow_one]
    rw [← this]
    ring
  have hX : (T ^ (1 - η)) ^ (1 / 4 : ℝ) = T ^ ((1 - η) / 4) := by
    rw [← Real.rpow_mul hT0.le]
    ring_nf
  have hlogM : 0 ≤ 1 + Real.log M ∧ 1 + Real.log M ≤ (1 + θ) * L := by
    rcases Nat.eq_zero_or_pos M with h0 | h0
    · rw [h0]
      simp
      nlinarith
    · have hM1 : (1 : ℝ) ≤ M := by exact_mod_cast h0
      have h1 := Real.log_le_log (by linarith) hM
      rw [Real.log_rpow hT0] at h1
      have := Real.log_nonneg hM1
      constructor <;> nlinarith
  have hlog3 : (1 + Real.log M) ^ 3 ≤ (1 + θ) ^ 3 * L ^ 3 := by
    have := pow_le_pow_left₀ hlogM.1 hlogM.2 3
    rw [mul_pow] at this
    exact this
  have hL6 := logpow_eps 6 hε0 hT1
  rw [← hLd, ← hG] at hL6
  have hQ : T ^ ε * (T ^ (3 / 4 : ℝ) * T ^ ((1 - η) / 4)) = T := by
    rw [← Real.rpow_add hT0, ← Real.rpow_add hT0,
      show ε + (3 / 4 + (1 - η) / 4) = 1 by rw [hε]; ring, Real.rpow_one]
  have hstep : (1 + κ ^ 2 * L ^ 2) * T * (T / (8 * Real.pi)) ^ (-(1 / 4) : ℝ) *
      ((T ^ (1 - η)) ^ (1 / 4 : ℝ) * (1 + Real.log M) ^ 3) ≤
      Y * L ^ 5 * (T ^ (3 / 4 : ℝ) * T ^ ((1 - η) / 4)) := by
    rw [mul_assoc (1 + κ ^ 2 * L ^ 2) T, hP, hX]
    calc (1 + κ ^ 2 * L ^ 2) * ((8 * Real.pi) ^ (1 / 4 : ℝ) * T ^ (3 / 4 : ℝ)) *
          (T ^ ((1 - η) / 4) * (1 + Real.log M) ^ 3)
        ≤ ((1 + κ ^ 2) * L ^ 2) * ((8 * Real.pi) ^ (1 / 4 : ℝ) * T ^ (3 / 4 : ℝ)) *
          (T ^ ((1 - η) / 4) * ((1 + θ) ^ 3 * L ^ 3)) := by
          apply mul_le_mul (mul_le_mul_of_nonneg_right hN (by positivity))
            (mul_le_mul_of_nonneg_left hlog3 (by positivity)) (by positivity) (by positivity)
      _ = Y * L ^ 5 * (T ^ (3 / 4 : ℝ) * T ^ ((1 - η) / 4)) := by rw [hY]; ring
  refine hstep.trans ?_
  rw [mul_div_assoc', le_div_iff₀ hL0]
  calc Y * L ^ 5 * (T ^ (3 / 4 : ℝ) * T ^ ((1 - η) / 4)) * L =
        Y * L ^ 6 * (T ^ (3 / 4 : ℝ) * T ^ ((1 - η) / 4)) := by ring
    _ ≤ Y * (G * T ^ ε) * (T ^ (3 / 4 : ℝ) * T ^ ((1 - η) / 4)) := by
        apply mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_left hL6 (by positivity))
          (by positivity)
    _ = Y * G * (T ^ ε * (T ^ (3 / 4 : ℝ) * T ^ ((1 - η) / 4))) := by ring
    _ = Y * G * T := by rw [hQ]

/-- **The short pairs at any length**: for `θ ≥ 0`, `0 < η`, `κ > 0`, the shifted integral of
the pairs with `h'k' ≤ T^(1−η)` is `O(T/L)` on Lemma 6's range, every `Weight T (log T)`. -/
theorem short_part (P : Polynomial ℝ) {θ η : ℝ} (hθ : 0 ≤ θ) (hη : 0 < η) (R : ℝ) {κ : ℝ}
    (hκ : 0 < κ) :
    ∃ C T₀ : ℝ, 0 ≤ C ∧ ∀ T : ℝ, T₀ ≤ T → ∀ W : Weight T (Real.log T), ∀ α β : ℂ,
      Regime κ T α β →
        ‖Jsh W α β (Zc (Mof T θ) (cF (aY P T θ R) (sig0 T R) (T ^ (1 - η))) α β)‖ ≤
          C * (T / Real.log T) := by
  obtain ⟨K0, hK00, hK0⟩ := J_bound
  obtain ⟨Cz, hCz0, hCz⟩ := Zc_left
  obtain ⟨B, hB0, hB⟩ := SBF_young P
  obtain ⟨C2, hC20, hC2⟩ := final_size_long hθ hη κ
  refine ⟨K0 * Cz * (B ^ 2 * Real.exp (2 * (θ * κ))) * C2,
    max (max 8 (Real.exp 1)) (Real.exp (10 * κ)), by positivity, fun T hT W α β hreg => ?_⟩
  have hT8 : 8 ≤ T := le_trans (le_trans (le_max_left _ _) (le_max_left _ _)) hT
  have hTe : Real.exp 1 ≤ T := le_trans (le_trans (le_max_right _ _) (le_max_left _ _)) hT
  have hTk : Real.exp (10 * κ) ≤ T := le_trans (le_max_right _ _) hT
  have hT0 : 0 < T := by linarith
  obtain ⟨hα, hβ, -, hL0⟩ := hreg.small hκ hTk
  have hM : ((Mof T θ : ℕ) : ℝ) ≤ T ^ θ := Nat.floor_le (by positivity)
  set c := cF (aY P T θ R) (sig0 T R) (T ^ (1 - η)) with hc
  set S := SBc (Mof T θ) c α β (-(1 / 4)) with hS
  have hS0 : 0 ≤ S := SBc_nonneg _ _ _ _ _
  have hJ := hK0 T (Real.log T) W (by linarith) α β hα hβ (Zc (Mof T θ) c α β) (Cz * S)
    (hCz (Mof T θ) c α β hα hβ)
  have hSB := hB T θ R κ (T ^ (1 - η)) (by linarith) hθ (by positivity) α β hreg.1 hreg.2.1
  have hN := OffDiagClose.N_le hκ hL0 hreg
  have hfin := hC2 T hTe (Mof T θ) hM
  have hPpos : 0 ≤ (T / (8 * Real.pi)) ^ (-(1 / 4) : ℝ) := by positivity
  refine hJ.trans ?_
  calc K0 * (1 + 1 / ‖α + β‖ ^ 2) * T * (T / (8 * Real.pi)) ^ (-(1 / 4) : ℝ) * (Cz * S)
      ≤ K0 * (1 + κ ^ 2 * Real.log T ^ 2) * T * (T / (8 * Real.pi)) ^ (-(1 / 4) : ℝ) *
        (Cz * (B ^ 2 * Real.exp (2 * (θ * κ)) * ((T ^ (1 - η)) ^ (1 / 4 : ℝ) *
          (1 + Real.log ((Mof T θ : ℕ) : ℝ)) ^ 3))) := by
        apply mul_le_mul _ (mul_le_mul_of_nonneg_left hSB hCz0) (by positivity) (by positivity)
        apply mul_le_mul_of_nonneg_right _ hPpos
        apply mul_le_mul_of_nonneg_right _ hT0.le
        exact mul_le_mul_of_nonneg_left hN hK00
    _ = K0 * Cz * (B ^ 2 * Real.exp (2 * (θ * κ))) * ((1 + κ ^ 2 * Real.log T ^ 2) * T *
          (T / (8 * Real.pi)) ^ (-(1 / 4) : ℝ) * ((T ^ (1 - η)) ^ (1 / 4 : ℝ) *
            (1 + Real.log ((Mof T θ : ℕ) : ℝ)) ^ 3)) := by ring
    _ ≤ K0 * Cz * (B ^ 2 * Real.exp (2 * (θ * κ))) * (C2 * (T / Real.log T)) :=
        mul_le_mul_of_nonneg_left hfin (by positivity)
    _ = _ := by ring

/-! ## The long pairs: the one named input -/

/-- OPEN for `θ > (1 − η)/2`, **the long pairs** (S13 B3 step 1): the shifted integral of the
pairs with `h'k' > T^(1−η)` is `O(T/L)` on Lemma 6's range. Empty, hence proved, for
`2θ ≤ 1 − η` (`stmtDiagTail_of_le`). Equivalent to `FloorLong.StmtDiagErr` for every `θ ≥ 0`
(`stmtDiagErr_of_tail`, `tail_of_stmtDiagErr`). Budget: any constants. Route (the module
header): no shift of `s`, `u`, `v` saves a power of `T` here; the cancellation is that of
`μ` in the tails `Σ_{n > Y, (n,q) = 1} μ(n) n^(−1−β) F(log n)` with `Y ≥ T^((1−η)/2)`,
the prime number theorem with a `(log Y)^(−A)` error, `A ≥ 6`, uniformly in `q ≤ T^(2θ)`. -/
def StmtDiagTail (P : Polynomial ℝ) (θ R κ η : ℝ) : Prop :=
  ∃ C T₀ : ℝ, 0 ≤ C ∧ ∀ T : ℝ, T₀ ≤ T → ∀ W : Weight T (Real.log T), ∀ α β : ℂ,
    Regime κ T α β →
      ‖Jsh W α β (Zc (Mof T θ) (cG (aY P T θ R) (sig0 T R) (T ^ (1 - η))) α β)‖ ≤
        C * (T / Real.log T)

/-- No long pairs below one half: for `T ≥ 1`, `T^(2θ) ≤ X`, every pair in the sum
has `h'k' ≤ hk ≤ M² ≤ X`, so `Zc_G = 0`. -/
theorem Zc_cG_zero {T θ X : ℝ} (hT : 1 ≤ T) (hX : T ^ (2 * θ) ≤ X)
    (a : ℕ → ℂ) (σ₀ : ℝ) (α β : ℂ) : Zc (Mof T θ) (cG a σ₀ X) α β = fun _ => 0 := by
  have hT0 : 0 < T := by linarith
  have hM : ((Mof T θ : ℕ) : ℝ) ≤ T ^ θ := Nat.floor_le (by positivity)
  have hsq : T ^ θ * T ^ θ = T ^ (2 * θ) := by
    rw [← Real.rpow_add hT0]
    ring_nf
  funext s
  unfold Zc Sc
  rw [Finset.sum_eq_zero, mul_zero]
  intro h hh
  refine Finset.sum_eq_zero fun k hk => ?_
  have hh1 := (Finset.mem_Icc.mp hh).1
  have hhM := (Finset.mem_Icc.mp hh).2
  have hk1 := (Finset.mem_Icc.mp hk).1
  have hkM := (Finset.mem_Icc.mp hk).2
  obtain ⟨-, -, -, -, -, h2, k2⟩ := gcd_facts hh1 hk1
  have hle : hkr h k ≤ Mof T θ * Mof T θ :=
    Nat.mul_le_mul (h2.trans hhM) (k2.trans hkM)
  have hc : ((hkr h k : ℕ) : ℝ) ≤ X := by
    calc ((hkr h k : ℕ) : ℝ) ≤ ((Mof T θ * Mof T θ : ℕ) : ℝ) := by exact_mod_cast hle
      _ = ((Mof T θ : ℕ) : ℝ) * ((Mof T θ : ℕ) : ℝ) := Nat.cast_mul _ _
      _ ≤ T ^ θ * T ^ θ := mul_le_mul hM hM (by positivity) (by positivity)
      _ = T ^ (2 * θ) := hsq
      _ ≤ X := hX
  unfold cG
  rw [if_pos hc, zero_mul]

/-- **The long pairs are absent for `2θ ≤ 1 − η`**: `StmtDiagTail` holds with `C = 0`. -/
theorem stmtDiagTail_of_le (P : Polynomial ℝ) {θ η : ℝ} (h : 2 * θ ≤ 1 - η)
    (R κ : ℝ) : StmtDiagTail P θ R κ η := by
  refine ⟨0, 1, le_rfl, fun T hT W α β _ => ?_⟩
  have hX : T ^ (2 * θ) ≤ T ^ (1 - η) := Real.rpow_le_rpow_of_exponent_le hT h
  rw [Zc_cG_zero hT hX]
  simp [Jsh, VerticalIntegral', VerticalIntegral]

/-- **The diagonal at length `θ` from the long pairs**: for every `θ ≥ 0`, `η > 0`, `κ > 0`,
`StmtDiagTail P θ R κ η → FloorLong.StmtDiagErr P θ R κ`. -/
theorem stmtDiagErr_of_tail (P : Polynomial ℝ) {θ η : ℝ} (hθ : 0 ≤ θ) (hη : 0 < η) (R : ℝ)
    {κ : ℝ} (hκ : 0 < κ) (ht : StmtDiagTail P θ R κ η) : FloorLong.StmtDiagErr P θ R κ := by
  obtain ⟨C1, T1, hC10, hC1⟩ := short_part P hθ hη R hκ
  obtain ⟨C2, T2, hC20, hC2⟩ := ht
  refine ⟨C1 + C2, max (max 8 (Real.exp (10 * κ))) (max T1 T2), by positivity,
    fun T hT W α β hreg => ?_⟩
  simp only [max_le_iff] at hT
  obtain ⟨⟨hT8, hTk⟩, hTa, hTb⟩ := hT
  obtain ⟨hα, hβ, hαβ, -⟩ := hreg.small hκ hTk
  rw [diag_split W (by linarith) _ _ _ (T ^ (1 - η)) hα hβ hαβ, add_sub_cancel_left]
  calc _ ≤ _ := norm_add_le _ _
    _ ≤ C1 * (T / Real.log T) + C2 * (T / Real.log T) :=
        add_le_add (hC1 T hTa W α β hreg) (hC2 T hTb W α β hreg)
    _ = (C1 + C2) * (T / Real.log T) := by ring

/-- **The reduction loses nothing**: `FloorLong.StmtDiagErr P θ R κ → StmtDiagTail P θ R κ η`
for every `θ ≥ 0`, `η > 0`, `κ > 0`; with `stmtDiagErr_of_tail`, the long pairs are exactly
what the diagonal at length `θ` asks. -/
theorem tail_of_stmtDiagErr (P : Polynomial ℝ) {θ η : ℝ} (hθ : 0 ≤ θ) (hη : 0 < η) (R : ℝ)
    {κ : ℝ} (hκ : 0 < κ) (hd : FloorLong.StmtDiagErr P θ R κ) : StmtDiagTail P θ R κ η := by
  obtain ⟨C1, T1, hC10, hC1⟩ := short_part P hθ hη R hκ
  obtain ⟨C2, T2, hC20, hC2⟩ := hd
  refine ⟨C1 + C2, max (max 8 (Real.exp (10 * κ))) (max T1 T2), by positivity,
    fun T hT W α β hreg => ?_⟩
  simp only [max_le_iff] at hT
  obtain ⟨⟨hT8, hTk⟩, hTa, hTb⟩ := hT
  obtain ⟨hα, hβ, hαβ, -⟩ := hreg.small hκ hTk
  have hs := diag_split W (by linarith) (Mof T θ) (aY P T θ R) (sig0 T R) (T ^ (1 - η)) hα hβ hαβ
  have hD := hC2 T hTb W α β hreg
  have h1 := hC1 T hTa W α β hreg
  rw [hs, add_sub_cancel_left] at hD
  set A := Jsh W α β (Zc (Mof T θ) (cF (aY P T θ R) (sig0 T R) (T ^ (1 - η))) α β)
  set G := Jsh W α β (Zc (Mof T θ) (cG (aY P T θ R) (sig0 T R) (T ^ (1 - η))) α β)
  have e : G = (A + G) - A := by ring
  rw [e]
  calc ‖(A + G) - A‖ ≤ ‖A + G‖ + ‖A‖ := norm_sub_le _ _
    _ ≤ C2 * (T / Real.log T) + C1 * (T / Real.log T) := add_le_add hD h1
    _ = (C1 + C2) * (T / Real.log T) := by ring

/-- **The diagonal below one half, by the split**: `FloorLong.StmtDiagErr P θ R κ` for
`0 ≤ θ < 1/2`, `κ > 0` (the long pairs are empty at `η = 1 − 2θ`); the range of
`Diagonal.diag_young`, reached here with no long pair. -/
theorem stmtDiagErr_holds (P : Polynomial ℝ) {θ : ℝ} (hθ0 : 0 ≤ θ) (hθ : θ < 1 / 2) (R : ℝ)
    {κ : ℝ} (hκ : 0 < κ) : FloorLong.StmtDiagErr P θ R κ :=
  stmtDiagErr_of_tail P hθ0 (η := 1 - 2 * θ) (by linarith) R hκ
    (stmtDiagTail_of_le P (by linarith) R κ)

/-! ## Axiom pins -/

/-- info: 'DiagLong.diag_split' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms diag_split

/-- info: 'DiagLong.short_part' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms short_part

/-- info: 'DiagLong.stmtDiagTail_of_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtDiagTail_of_le

/-- info: 'DiagLong.stmtDiagErr_of_tail' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtDiagErr_of_tail

/-- info: 'DiagLong.tail_of_stmtDiagErr' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms tail_of_stmtDiagErr

/-- info: 'DiagLong.stmtDiagErr_holds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtDiagErr_holds

end

end DiagLong
