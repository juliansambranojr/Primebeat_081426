/-
# SwapX — block S12 of `lean_stage3/design/stencil.md`, Part 5 of the twisted moment, the X-term. 2026-11-25.

Target: `TwistedMoment.StmtX`, `I_X(α,β) = T^(−α−β) I₁(−β,−α) + O(T/L)` (Young, arXiv 1002.4403,
§5). Notation as in `TwistedMoment`, `OffDiagClose`, `Diagonal`, `DiagonalO`: `L = log T`,
`Δ = T/L`, `N = 1 + ‖α+β‖^(−2)`, `S₁ = S1`, `|ψ|² = msq`, Young's `a_h = aY`, `M = Mof T θ`,
`errY W = (1 + C₁ + C₂) T/L`, `z = −(α+β)`, `g(t) = (t/(2πT))^z = c_T G₀(t)`.

The route (Young's: the twist goes into the weight). `I_X − T^z I₁(−β,−α) = ∫ w (X − T^z g) S₁ |ψ|²
+ T^z ∫ w (g − 1) S₁ |ψ|²` (`split_eq`). (1) **The twist.** `|g − 1| ≤ K/L`, `K = 104κ`, on
`[T/4, 2T]` (`g_sub_one`, `|log(t/(2πT))| ≤ 26`), and `w (g − 1) = (K/L)((2wφ_re − w) +
i(2wφ_im − w))` (`decomp`) with `φ_re = 1/2 + (L/2K)(Re g − 1)`, `φ_im = 1/2 + (L/2K) Im g` in
`[0, 1]`. `G_k(t) = t^(z−k)` has `G_k′ = (z−k) G_{k+1}`, so `φ^(k+1) = (L/2K) ℓ(c_T D_{k+1}
G_{k+1})` on `t > 0` (`iter_phi`), `‖D_{k+1}‖ ≤ ‖z‖ (k+1)!` (`norm_Dk_le`), and
`|φ^(k)| ≤ k! 4^k Δ^(−k)` on the support (`hder_of`, `phi_iter_le`). Leibniz makes `wφ` a
`WeightAll` with `C′_j = Σ C(j,i) C_i (j−i)! 4^(j−i)` (`twist`), so each of the three `I₁` is
`diag + off` with `diag = ŵ(0) ζ(1−α−β) S(−β,−α,0) + O(T/L)` (`diag_young`), `off = O(errY)`
(`stmtOffDiag_holds` at the family `C′`), and `‖ζ S‖ ≤ ‖c₁‖ + 1` (`StmtDiagMainO` at `ε = 1`,
`c1Y_bound`): `‖I₁‖ ≤ 2T(C_c+1) + O(T/L)` (`I1_X_bound`), and `(K/L)·O(T) = O(T/L)` (`J_alg`).
(2) **The Stirling remainder.** `‖X − (t/2π)^z‖ ≤ C/t` (`StmtXStirling`, OPEN), `T^z g = (t/2π)^z`
(`Tp_g`), `‖S₁(t)‖ ≤ C N t^(1/2+2η)` for `‖α‖, ‖β‖ ≤ η` (`S1_sharp`, the decay traded at
`(mn)^(−1−η)`), `|ψ|² ≤ B² M (1 + log M)` (`msq_young`, Cauchy–Schwarz on `Σ h^(−1/2)`); with
`η = (1/2 − θ⁺)/8` the part is `≪ L³ T^(1 − (3/4)(1/2 − θ⁺)) ≤ C T/L` (`E_bound`, `size_X`).

The size check (CLAUDE.md, "a lost factor is a design failure"). The docstring route of `StmtX`
bounds `∫ w |S₁(−β,−α)| |ψ|²` with the absolute value inside. `S₁ ≈ ζ(1/2−β+it) ζ(1/2−α−it)`,
so that integral is the mollified second moment with `|·|` on a complex sum; what the tree can
bound it by is the pointwise `‖S₁‖ ≪ N t^(1/2+2η)`, giving `T^(3/2+θ+2η) L²` against the `T`
needed, a lost factor `≍ T^(1/2+θ)`, and Cauchy–Schwarz against `∫|ψ|² ≍ T L` and a fourth
moment loses powers of `L`. The route here keeps the absolute value off `S₁`: the `O(1/L)` twist
is a weight, so only `‖I₁‖ = O(T)` is used, and only the `O(1/t)` Stirling remainder meets the
pointwise bound (`T^(1/2+θ+2η)`, which closes for every `θ < 1/2`). Two smaller factors were
caught: `aY_bound` (`‖a_h‖ h^(−σ₀) ≤ B`) gives `|ψ|² ≤ B² M²`, so the remainder would close
only for `θ < 1/4`; `aY_bound'` (`≤ B h^(−1/2)`) is used. `S1_term_bound` (exponent `2/5`, from
`‖α‖ ≤ 1/10`) gives `t^(3/5+…)` and `θ < 2/5`; `S1_sharp` uses the range `‖α‖ ≤ κ/L ≤ η`.

| name | content | status |
|---|---|---|
| `Gk`, `Dk`, `cT`, `phi` | `G_k = t^(z−k)`, `D_k = z(z−1)⋯(z−k+1)`, `c_T = (2πT)^(−z)`, `φ = a + bℓ(c_T G₀)` | def |
| `Gk_hasDerivAt`, `iter_phi`, `norm_Dk_le` | `G_k′ = (z−k)G_{k+1}`; `φ^(k+1) = bℓ(c_T D_{k+1} G_{k+1})` on `t > 0`; `‖D_{k+1}‖ ≤ ‖z‖(k+1)!` | proved |
| `phi_contDiffAt`, `phi_iter_le` | `φ` smooth off `0`; `|φ^(k)| ≤ k! 4^k Δ^(−k)` on the support | proved |
| `twC`, `twist` | `C′_j`; `w·φ` as a `WeightAll T L` | def |
| `logratio_le`, `cG_eq`, `norm_cG` | `|log(t/(2πT))| ≤ 26`; `c_T G₀ = e^(z log(t/2πT))`; `‖c_T G_k‖` | proved |
| `g_sub_one`, `hder_of`, `h01_re`, `h01_im`, `decomp` | `‖g − 1‖ ≤ K/L`; the hypotheses of `twist`; the pointwise split | proved |
| `S1_term_sharp`, `S1_sharp` | `‖S₁(α,β,1,t)‖ ≤ C N t^(1/2+2η)`, `‖α‖, ‖β‖ ≤ η ≤ 1/4` | proved |
| `sum_half_sq`, `msq_young` | `(Σ_{h≤M} h^(−1/2))² ≤ M(1+log M)`; `|ψ|² ≤ B² M(1+log M)` | proved |
| `etaX`, `size_X` | `η = (1/2−θ⁺)/8`; `N (2T)^(1/2+2η) M(1+log M) ≤ C T/L` | proved |
| `c1Y_bound` | `‖c₁(α,β)‖ ≤ C` on `Regime κ T`, `θ < 1/2` (`c₁ = 0` for `θ ≤ 0`) | proved |
| `StmtXStirling` | `‖X_{α,β,t} − (t/2π)^(−α−β)‖ ≤ C/t`, `‖α‖, ‖β‖ ≤ 1/10`, `t ≥ 1` | OPEN (named Prop) |
| `Tp_g`, `integrable_IX`, `lin_comb`, `split_eq` | `T^z g = (t/2π)^z`; integrability; the two linear identities | proved |
| `E_bound`, `I1_X_bound`, `J_alg`, `le_twC` | the remainder; `‖I₁‖ = O(T)` per weight; the `(K/L)`-algebra | proved |
| `StmtXAll` | `StmtX` over `WeightAll`, constants `C_j ≤ Cs j`, shape of `StmtOffDiagAll` | defined |
| `stmtXAll_of` | `StmtXStirling → StmtDiagMainO → StmtXAll`, `θ < 1/2`, `κ > 0` | proved |
| `lemma3_resO_of_partsAll` | `StmtDiagO → StmtOffDiagAll → StmtXAll → StmtLemma3resO`, `κ > 0` | proved |
| `lemma3_resO_of_mainO` | `StmtXStirling → StmtDiagMainO → StmtLemma3resO`, `θ < 1/2`, `κ > 0` | proved |

Differences from the target. (i) `stmtX_holds` (unconditional `StmtX`) is not built. Two inputs
are open: Stirling with the phase (`StmtXStirling`; the tree has the size only) and the main
term's boundedness, through `StmtDiagMainO`, since the twisted weights carry the diagonal
`ŵ(0) ζ S` with `ŵ_twisted(0) ≍ T` and `ζ(1−α−β) S(−β,−α,0)` is `O(1)` only by Young's Lemma 7
(the trivial bound on `S` is `≫ 1` against `ζ ≍ L`). (ii) `StmtXAll` is over `WeightAll`, as
the off-diagonal: the twisted weights need `stmtOffDiag_holds`, which needs (2.3) for every
`j`. `StmtX` over `Weight` would need `StmtOffDiag` over `Weight`, which the tree does not have.
(iii) The bound is `O(T/L)` (`C · errY W`), not `o(T)`; `lemma3_resO_of_partsAll` absorbs it
as `lemma3_resO_of_parts` absorbs `StmtX`. (iv) `lemma3_resO_of_mainO` is
`DiagonalO.lemma3_resO_of_mainO_X` with the X-hypothesis replaced by `StmtXStirling`.

Axioms: [propext, Classical.choice, Quot.sound], pinned below on each main theorem.
-/
import Stage3.DiagonalO
import Stage3.DiagMain

namespace SwapX

open Complex MeasureTheory Filter Topology ApproxFE ApproxBounds TwistedMoment OffDiagClose
  Diagonal DiagMainStmt DiagonalO
open scoped ContDiff

noncomputable section

/-! ## Part 1: the twist `(t/(2πT))^s` and its derivatives -/

/-- `G_k(t) = exp((s − k) log t)`, so `G_k(t) = t^(s−k)` for `t > 0`. -/
def Gk (s : ℂ) (k : ℕ) (t : ℝ) : ℂ := cexp ((s - k) * (Real.log t : ℂ))

/-- `D_k = s(s−1)⋯(s−k+1)`. -/
def Dk (s : ℂ) : ℕ → ℂ
  | 0 => 1
  | k + 1 => Dk s k * (s - k)

/-- The constant `c_T = exp(−s log(2πT))`, so `c_T G_0(t) = (t/(2πT))^s`. -/
def cT (s : ℂ) (T : ℝ) : ℂ := cexp (-(s * (Real.log (2 * Real.pi * T) : ℂ)))

theorem Gk_hasDerivAt (s : ℂ) (k : ℕ) {t : ℝ} (ht : 0 < t) :
    HasDerivAt (Gk s k) ((s - k) * Gk s (k + 1) t) t := by
  have h1 : HasDerivAt (fun t : ℝ => ((Real.log t : ℝ) : ℂ)) ((t⁻¹ : ℝ) : ℂ) t :=
    (Real.hasDerivAt_log ht.ne').ofReal_comp
  have h2 := (h1.const_mul (s - k)).cexp
  have e : Gk s (k + 1) t = cexp ((s - k) * (Real.log t : ℂ)) * ((t⁻¹ : ℝ) : ℂ) := by
    unfold Gk
    rw [show (s - ((k + 1 : ℕ) : ℂ)) * (Real.log t : ℂ) =
        (s - k) * (Real.log t : ℂ) + (-(Real.log t : ℂ)) by push_cast; ring, Complex.exp_add]
    congr 1
    rw [← Complex.ofReal_neg, ← Complex.ofReal_exp, Real.exp_neg, Real.exp_log ht]
  show HasDerivAt (fun t : ℝ => cexp ((s - k) * (Real.log t : ℂ))) _ t
  refine h2.congr_deriv ?_
  rw [e]
  ring

theorem norm_Dk_le {s : ℂ} (hs : ‖s‖ ≤ 1) (k : ℕ) :
    ‖Dk s (k + 1)‖ ≤ ‖s‖ * ((k + 1).factorial : ℝ) := by
  induction k with
  | zero => simp [Dk]
  | succ k ih =>
    have e : Dk s (k + 1 + 1) = Dk s (k + 1) * (s - ((k + 1 : ℕ) : ℂ)) := rfl
    rw [e, norm_mul]
    have h1 : ‖s - ((k + 1 : ℕ) : ℂ)‖ ≤ ((k + 2 : ℕ) : ℝ) := by
      refine (norm_sub_le _ _).trans ?_
      rw [Complex.norm_natCast]
      push_cast
      linarith
    rw [Nat.factorial_succ (k + 1), Nat.cast_mul]
    have h0 : 0 ≤ ‖s‖ * ((k + 1).factorial : ℝ) := by positivity
    calc ‖Dk s (k + 1)‖ * ‖s - ((k + 1 : ℕ) : ℂ)‖ ≤ (‖s‖ * ((k + 1).factorial : ℝ)) *
          ((k + 2 : ℕ) : ℝ) := mul_le_mul ih h1 (norm_nonneg _) h0
      _ = _ := by push_cast; ring

/-- The real twist `φ(t) = a + b·ℓ(c·G_0(t))`, `ℓ` a real-linear functional (`re` or `im`). -/
def phi (ℓ : ℂ →L[ℝ] ℝ) (c s : ℂ) (a b : ℝ) (t : ℝ) : ℝ := a + b * ℓ (c * Gk s 0 t)

theorem lin_hasDerivAt (ℓ : ℂ →L[ℝ] ℝ) (c : ℂ) (b : ℝ) {F : ℝ → ℂ} {F' : ℂ} {t : ℝ}
    (hF : HasDerivAt F F' t) : HasDerivAt (fun t => b * ℓ (c * F t)) (b * ℓ (c * F')) t := by
  have h1 := ℓ.hasFDerivAt.comp_hasDerivAt t (hF.const_mul c)
  exact h1.const_mul b

theorem iter_phi (ℓ : ℂ →L[ℝ] ℝ) (c s : ℂ) (a b : ℝ) (k : ℕ) :
    Set.EqOn (iteratedDeriv (k + 1) (phi ℓ c s a b))
      (fun t => b * ℓ (c * (Dk s (k + 1) * Gk s (k + 1) t))) (Set.Ioi 0) := by
  induction k with
  | zero =>
    intro t ht
    rw [iteratedDeriv_one]
    have h := ((lin_hasDerivAt ℓ c b (Gk_hasDerivAt s 0 ht)).const_add a)
    have e : phi ℓ c s a b = fun t => a + b * ℓ (c * Gk s 0 t) := rfl
    rw [e, h.deriv]
    simp [Dk]
  | succ k ih =>
    intro t ht
    rw [iteratedDeriv_succ]
    have hev : iteratedDeriv (k + 1) (phi ℓ c s a b) =ᶠ[𝓝 t]
        (fun t => b * ℓ (c * (Dk s (k + 1) * Gk s (k + 1) t))) :=
      Filter.eventuallyEq_of_mem (Ioi_mem_nhds ht) ih
    rw [hev.deriv_eq]
    have h := lin_hasDerivAt ℓ c b (((Gk_hasDerivAt s (k + 1) ht).const_mul (Dk s (k + 1))))
    rw [h.deriv]
    have e : Dk s (k + 1 + 1) = Dk s (k + 1) * (s - ((k + 1 : ℕ) : ℂ)) := rfl
    rw [e]
    congr 3
    ring

theorem phi_contDiffAt (ℓ : ℂ →L[ℝ] ℝ) (c s : ℂ) (a b : ℝ) {t : ℝ} (ht : t ≠ 0) :
    ContDiffAt ℝ ∞ (phi ℓ c s a b) t := by
  have hlog : ContDiffAt ℝ ∞ (fun t : ℝ => ((Real.log t : ℝ) : ℂ)) t :=
    Complex.ofRealCLM.contDiff.contDiffAt.comp t (Real.contDiffAt_log.mpr ht)
  have hG : ContDiffAt ℝ ∞ (Gk s 0) t :=
    Complex.contDiff_exp.contDiffAt.comp t (contDiffAt_const.mul hlog)
  exact contDiffAt_const.add (contDiffAt_const.mul
    (ℓ.contDiff.contDiffAt.comp t (contDiffAt_const.mul hG)))

/-- The twisted constants `C'_j = Σ_{i ≤ j} C(j,i) C_i (j−i)! 4^(j−i)`. -/
def twC (C : ℕ → ℝ) (j : ℕ) : ℝ :=
  ∑ i ∈ Finset.range (j + 1), (j.choose i : ℝ) * C i * (((j - i).factorial : ℝ) * 4 ^ (j - i))

theorem twC_nonneg {C : ℕ → ℝ} (hC : ∀ j, 0 ≤ C j) (j : ℕ) : 0 ≤ twC C j :=
  Finset.sum_nonneg fun i _ => by have := hC i; positivity

theorem twC_mono {C C' : ℕ → ℝ} (h : ∀ j, C j ≤ C' j) (j : ℕ) :
    twC C j ≤ twC C' j :=
  Finset.sum_le_sum fun i _ => by
    apply mul_le_mul_of_nonneg_right _ (by positivity)
    exact mul_le_mul_of_nonneg_left (h i) (by positivity)

section Twist

variable {T L : ℝ} (W : WeightAll T L) (ℓ : ℂ →L[ℝ] ℝ) (c s : ℂ) (a b : ℝ)

/-- The derivative bounds of `φ` on the support: `|φ^(k)| ≤ k! 4^k Δ^(−k)`. -/
theorem phi_iter_le (hT : 0 < T)
    (h01 : ∀ t ∈ Set.Icc (T / 4) (2 * T), 0 ≤ phi ℓ c s a b t ∧ phi ℓ c s a b t ≤ 1)
    (hder : ∀ k : ℕ, ∀ t ∈ Set.Icc (T / 4) (2 * T),
      |b * ℓ (c * (Dk s (k + 1) * Gk s (k + 1) t))| ≤
        ((k + 1).factorial : ℝ) * 4 ^ (k + 1) * ((T / L) ^ (k + 1))⁻¹)
    (k : ℕ) {t : ℝ} (ht : t ∈ Set.Icc (T / 4) (2 * T)) :
    |iteratedDeriv k (phi ℓ c s a b) t| ≤ (k.factorial : ℝ) * 4 ^ k * ((T / L) ^ k)⁻¹ := by
  rcases k with _ | k
  · rw [iteratedDeriv_zero]
    obtain ⟨h0, h1⟩ := h01 t ht
    rw [abs_of_nonneg h0]
    simpa using h1
  · have ht0 : 0 < t := by linarith [ht.1]
    rw [iter_phi ℓ c s a b k ht0]
    exact hder k t ht

/-- **The twisted weight** `w·φ`, a `WeightAll T L`. -/
def twist (hT : 0 < T) (hΔ : 0 < T / L)
    (h01 : ∀ t ∈ Set.Icc (T / 4) (2 * T), 0 ≤ phi ℓ c s a b t ∧ phi ℓ c s a b t ≤ 1)
    (hder : ∀ k : ℕ, ∀ t ∈ Set.Icc (T / 4) (2 * T),
      |b * ℓ (c * (Dk s (k + 1) * Gk s (k + 1) t))| ≤
        ((k + 1).factorial : ℝ) * 4 ^ (k + 1) * ((T / L) ^ (k + 1))⁻¹) : WeightAll T L :=
  have hsm : ContDiff ℝ ∞ (fun t => W.w t * phi ℓ c s a b t) := by
    rw [contDiff_iff_contDiffAt]
    intro t
    by_cases ht : t ≤ 0
    · refine contDiffAt_const (c := (0 : ℝ)).congr_of_eventuallyEq ?_
      have hU : Set.Iio (T / 4) ∈ 𝓝 t := Iio_mem_nhds (by linarith)
      filter_upwards [hU] with u hu
      have : u ∉ Set.Icc (T / 4) (2 * T) := fun h => by linarith [h.1, (Set.mem_Iio.mp hu)]
      rw [(W.zero_out this).1, zero_mul]
    · exact W.smooth.contDiffAt.mul (phi_contDiffAt ℓ c s a b (by linarith))
  have hiter : ∀ j t, |iteratedDeriv j (fun t => W.w t * phi ℓ c s a b t) t| ≤
      twC W.Cj j * ((T / L) ^ j)⁻¹ := by
    intro j t
    by_cases hs : t ∈ Set.Icc (T / 4) (2 * T)
    · have ht0 : 0 < t := by linarith [hs.1]
      have hf : ContDiffAt ℝ j W.w t := (contDiff_infty.mp W.smooth j).contDiffAt
      have hg : ContDiffAt ℝ j (phi ℓ c s a b) t :=
        (contDiffAt_infty.mp (phi_contDiffAt ℓ c s a b ht0.ne') j)
      rw [iteratedDeriv_fun_mul hf hg]
      refine (Finset.abs_sum_le_sum_abs _ _).trans ?_
      unfold twC
      rw [Finset.sum_mul]
      refine Finset.sum_le_sum fun i hi => ?_
      have hij : i ≤ j := Nat.lt_succ_iff.mp (Finset.mem_range.mp hi)
      have hw := W.dj i t
      have hp := phi_iter_le ℓ c s a b hT h01 hder (j - i) hs
      rw [abs_mul, abs_mul, Nat.abs_cast]
      have hpow : ((T / L) ^ i)⁻¹ * ((T / L) ^ (j - i))⁻¹ = ((T / L) ^ j)⁻¹ := by
        rw [← mul_inv, ← pow_add, Nat.add_sub_cancel' hij]
      have hCi := W.Cj_nonneg i
      calc (j.choose i : ℝ) * |iteratedDeriv i W.w t| * |iteratedDeriv (j - i) (phi ℓ c s a b) t|
          ≤ (j.choose i : ℝ) * (W.Cj i * ((T / L) ^ i)⁻¹) *
              (((j - i).factorial : ℝ) * 4 ^ (j - i) * ((T / L) ^ (j - i))⁻¹) := by
            apply mul_le_mul (mul_le_mul_of_nonneg_left hw (by positivity)) hp (abs_nonneg _)
            positivity
        _ = (j.choose i : ℝ) * W.Cj i * (((j - i).factorial : ℝ) * 4 ^ (j - i)) *
              (((T / L) ^ i)⁻¹ * ((T / L) ^ (j - i))⁻¹) := by ring
        _ = _ := by rw [hpow]
    · have hU : IsOpen (Set.Icc (T / 4) (2 * T))ᶜ := isClosed_Icc.isOpen_compl
      have hEq : Set.EqOn (fun t => W.w t * phi ℓ c s a b t) (fun _ => (0 : ℝ))
          (Set.Icc (T / 4) (2 * T))ᶜ := fun u hu => by
        simp only
        rw [(W.zero_out hu).1, zero_mul]
      rw [Set.EqOn.iteratedDeriv_of_isOpen hEq hU j hs, iteratedDeriv_fun_const_zero, abs_zero]
      exact mul_nonneg (twC_nonneg W.Cj_nonneg j) (by positivity)
  { w := fun t => W.w t * phi ℓ c s a b t
    smooth := hsm
    supp := fun t ht => W.supp t (left_ne_zero_of_mul ht)
    nonneg := fun t => by
      by_cases hs : t ∈ Set.Icc (T / 4) (2 * T)
      · exact mul_nonneg (W.nonneg t) (h01 t hs).1
      · rw [(W.zero_out hs).1, zero_mul]
    le_one := fun t => by
      by_cases hs : t ∈ Set.Icc (T / 4) (2 * T)
      · calc W.w t * phi ℓ c s a b t ≤ 1 * 1 :=
            mul_le_mul (W.le_one t) (h01 t hs).2 (h01 t hs).1 zero_le_one
          _ = 1 := one_mul 1
      · rw [(W.zero_out hs).1, zero_mul]; exact zero_le_one
    C1 := twC W.Cj 1
    C2 := twC W.Cj 2
    C1_nonneg := twC_nonneg W.Cj_nonneg 1
    C2_nonneg := twC_nonneg W.Cj_nonneg 2
    d1 := fun t => by
      have h := hiter 1 t
      rwa [iteratedDeriv_one, pow_one] at h
    d2 := fun t => by
      have h := hiter 2 t
      rwa [iteratedDeriv_succ, iteratedDeriv_one] at h
    Cj := twC W.Cj
    Cj_nonneg := twC_nonneg W.Cj_nonneg
    dj := hiter }

end Twist

/-! ## Part 2: the twist on the support, `s = −(α+β)`, `‖s‖ ≤ 2κ/L` -/

/-- `|log(t/(2πT))| ≤ 26` on `[T/4, 2T]`. -/
theorem logratio_le {T t : ℝ} (hT : 0 < T) (ht : t ∈ Set.Icc (T / 4) (2 * T)) :
    |Real.log t - Real.log (2 * Real.pi * T)| ≤ 26 := by
  have ht0 : 0 < t := by linarith [ht.1]
  have hC : 0 < 2 * Real.pi * T := by positivity
  have hpi := Real.pi_gt_three
  have hpi2 := Real.pi_lt_d2
  rw [← Real.log_div ht0.ne' hC.ne']
  set x := t / (2 * Real.pi * T) with hx
  have hx0 : 0 < x := div_pos ht0 hC
  have hx1 : x ≤ 1 := by
    rw [hx, div_le_one hC]
    nlinarith [ht.2]
  have hinv : x⁻¹ ≤ 8 * Real.pi := by
    rw [hx, inv_div, div_le_iff₀ ht0]
    nlinarith [ht.1]
  have hle : Real.log x ≤ 0 := Real.log_nonpos hx0.le hx1
  have hge : -Real.log x ≤ x⁻¹ - 1 := by
    rw [← Real.log_inv]
    exact Real.log_le_sub_one_of_pos (inv_pos.mpr hx0)
  rw [abs_of_nonpos hle]
  linarith

/-- `c_T G_0(t) = exp(s (log t − log(2πT)))`. -/
theorem cG_eq (s : ℂ) (T t : ℝ) :
    cT s T * Gk s 0 t = cexp (s * ((Real.log t - Real.log (2 * Real.pi * T) : ℝ) : ℂ)) := by
  unfold cT Gk
  rw [← Complex.exp_add]
  congr 1
  push_cast
  ring

/-- `‖c_T G_k(t)‖ = e^(Re s (log t − log(2πT))) t^(−k)`, `t > 0`. -/
theorem norm_cG (s : ℂ) (T : ℝ) (k : ℕ) {t : ℝ} (ht : 0 < t) :
    ‖cT s T * Gk s k t‖ = Real.exp (s.re * (Real.log t - Real.log (2 * Real.pi * T))) *
      (t⁻¹) ^ k := by
  unfold cT Gk
  rw [norm_mul, Complex.norm_exp, Complex.norm_exp]
  have e1 : (-(s * (Real.log (2 * Real.pi * T) : ℂ))).re = -(s.re * Real.log (2 * Real.pi * T)) := by
    rw [Complex.neg_re, Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im]; ring
  have e2 : ((s - k) * (Real.log t : ℂ)).re = (s.re - k) * Real.log t := by
    rw [Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im, Complex.sub_re, Complex.sub_im,
      Complex.natCast_re, Complex.natCast_im]; ring
  rw [e1, e2, ← Real.exp_add]
  have e3 : (t⁻¹) ^ k = Real.exp (-(k * Real.log t)) := by
    rw [Real.exp_neg, Real.exp_nat_mul, Real.exp_log ht, inv_pow]
  rw [e3, ← Real.exp_add]
  congr 1
  ring

section Concrete

variable {κ T L : ℝ} {s : ℂ}

/-- The size constant `K = 104κ`: `‖(t/(2πT))^s − 1‖ ≤ K/L` on the support. -/
def Kt (κ : ℝ) : ℝ := 104 * κ

theorem sl_le (hκ : 0 < κ) (hT : 0 < T) (hL : 52 * κ ≤ L) (hs : ‖s‖ ≤ 2 * κ / L) {t : ℝ}
    (ht : t ∈ Set.Icc (T / 4) (2 * T)) :
    ‖s * ((Real.log t - Real.log (2 * Real.pi * T) : ℝ) : ℂ)‖ ≤ 52 * κ / L := by
  have hL0 : 0 < L := by linarith
  rw [norm_mul, Complex.norm_real, Real.norm_eq_abs]
  have h := logratio_le hT ht
  calc ‖s‖ * |Real.log t - Real.log (2 * Real.pi * T)| ≤ (2 * κ / L) * 26 :=
        mul_le_mul hs h (abs_nonneg _) (by positivity)
    _ = 52 * κ / L := by ring

theorem g_sub_one (hκ : 0 < κ) (hT : 0 < T) (hL : 52 * κ ≤ L) (hs : ‖s‖ ≤ 2 * κ / L) {t : ℝ}
    (ht : t ∈ Set.Icc (T / 4) (2 * T)) : ‖cT s T * Gk s 0 t - 1‖ ≤ Kt κ / L := by
  have hL0 : 0 < L := by linarith
  have h := sl_le hκ hT hL hs ht
  have h1 : 52 * κ / L ≤ 1 := by rw [div_le_one hL0]; exact hL
  rw [cG_eq]
  refine (Complex.norm_exp_sub_one_le (h.trans h1)).trans ?_
  unfold Kt
  calc 2 * ‖s * ((Real.log t - Real.log (2 * Real.pi * T) : ℝ) : ℂ)‖ ≤ 2 * (52 * κ / L) := by
        linarith
    _ = 104 * κ / L := by ring

/-- The derivative bound `hder` of `twist`, for any `ℓ` with `|ℓ z| ≤ ‖z‖`, `b = L/(2K)`. -/
theorem hder_of (ℓ : ℂ →L[ℝ] ℝ) (hℓ : ∀ z, |ℓ z| ≤ ‖z‖) (hκ : 0 < κ) (hT : 0 < T)
    (hL1 : 1 ≤ L) (hL : 52 * κ ≤ L) (hs : ‖s‖ ≤ 2 * κ / L) (k : ℕ) (t : ℝ)
    (ht : t ∈ Set.Icc (T / 4) (2 * T)) :
    |L / (2 * Kt κ) * ℓ (cT s T * (Dk s (k + 1) * Gk s (k + 1) t))| ≤
      ((k + 1).factorial : ℝ) * 4 ^ (k + 1) * ((T / L) ^ (k + 1))⁻¹ := by
  have hL0 : 0 < L := by linarith
  have ht0 : 0 < t := by linarith [ht.1]
  have hs1 : ‖s‖ ≤ 1 := by
    have : 2 * κ / L ≤ 1 := by rw [div_le_one hL0]; linarith
    linarith
  have hD := norm_Dk_le hs1 k
  have hn := norm_cG s T (k + 1) ht0
  have hexp : Real.exp (s.re * (Real.log t - Real.log (2 * Real.pi * T))) ≤ Real.exp 1 := by
    apply Real.exp_le_exp.mpr
    have h := sl_le hκ hT hL hs ht
    rw [norm_mul, Complex.norm_real, Real.norm_eq_abs] at h
    have h1 : 52 * κ / L ≤ 1 := by rw [div_le_one hL0]; exact hL
    have h2 : s.re * (Real.log t - Real.log (2 * Real.pi * T)) ≤
        ‖s‖ * |Real.log t - Real.log (2 * Real.pi * T)| := by
      refine (le_abs_self _).trans ?_
      rw [abs_mul]
      exact mul_le_mul_of_nonneg_right (Complex.abs_re_le_norm s) (abs_nonneg _)
    linarith
  have hti : t⁻¹ ≤ 4 * (T / L)⁻¹ := inv_t_le hT hL1 ht.1
  have hb : L / (2 * Kt κ) * ‖s‖ ≤ 1 / 104 := by
    unfold Kt
    calc L / (2 * (104 * κ)) * ‖s‖ ≤ L / (2 * (104 * κ)) * (2 * κ / L) :=
          mul_le_mul_of_nonneg_left hs (by positivity)
      _ = 1 / 104 := by field_simp
  have he : Real.exp 1 ≤ 104 := by
    have := Real.exp_one_lt_d9
    linarith
  have hb0 : 0 ≤ L / (2 * Kt κ) := by unfold Kt; positivity
  rw [abs_mul, abs_of_nonneg hb0]
  have hz : |ℓ (cT s T * (Dk s (k + 1) * Gk s (k + 1) t))| ≤
      ‖s‖ * ((k + 1).factorial : ℝ) * (Real.exp 1 * (t⁻¹) ^ (k + 1)) := by
    refine (hℓ _).trans ?_
    rw [show cT s T * (Dk s (k + 1) * Gk s (k + 1) t) = Dk s (k + 1) * (cT s T * Gk s (k + 1) t)
      by ring, norm_mul, hn]
    exact mul_le_mul hD (mul_le_mul_of_nonneg_right hexp (by positivity)) (by positivity)
      (by positivity)
  have hp : (t⁻¹) ^ (k + 1) ≤ (4 * (T / L)⁻¹) ^ (k + 1) :=
    pow_le_pow_left₀ (by positivity) hti (k + 1)
  calc L / (2 * Kt κ) * |ℓ (cT s T * (Dk s (k + 1) * Gk s (k + 1) t))|
      ≤ L / (2 * Kt κ) * (‖s‖ * ((k + 1).factorial : ℝ) * (Real.exp 1 * (t⁻¹) ^ (k + 1))) :=
        mul_le_mul_of_nonneg_left hz hb0
    _ = (L / (2 * Kt κ) * ‖s‖) * Real.exp 1 * ((k + 1).factorial : ℝ) * (t⁻¹) ^ (k + 1) := by ring
    _ ≤ (1 / 104) * 104 * ((k + 1).factorial : ℝ) * (4 * (T / L)⁻¹) ^ (k + 1) := by
        apply mul_le_mul _ hp (by positivity) (by positivity)
        apply mul_le_mul_of_nonneg_right _ (by positivity)
        exact mul_le_mul hb he (Real.exp_pos 1).le (by norm_num)
    _ = _ := by rw [mul_pow, inv_pow]; ring

theorem h01_re (hκ : 0 < κ) (hT : 0 < T) (hL : 52 * κ ≤ L) (hs : ‖s‖ ≤ 2 * κ / L) (t : ℝ)
    (ht : t ∈ Set.Icc (T / 4) (2 * T)) :
    0 ≤ phi Complex.reCLM (cT s T) s (1 / 2 - L / (2 * Kt κ)) (L / (2 * Kt κ)) t ∧
      phi Complex.reCLM (cT s T) s (1 / 2 - L / (2 * Kt κ)) (L / (2 * Kt κ)) t ≤ 1 := by
  have hL0 : 0 < L := by linarith
  have hK : 0 < Kt κ := by unfold Kt; positivity
  have h := g_sub_one hκ hT hL hs ht
  have hre : |(cT s T * Gk s 0 t).re - 1| ≤ Kt κ / L := by
    have := Complex.abs_re_le_norm (cT s T * Gk s 0 t - 1)
    rw [Complex.sub_re, Complex.one_re] at this
    linarith
  have hb : |L / (2 * Kt κ) * ((cT s T * Gk s 0 t).re - 1)| ≤ 1 / 2 := by
    rw [abs_mul, abs_of_pos (by positivity)]
    calc L / (2 * Kt κ) * |(cT s T * Gk s 0 t).re - 1| ≤ L / (2 * Kt κ) * (Kt κ / L) :=
          mul_le_mul_of_nonneg_left hre (by positivity)
      _ = 1 / 2 := by field_simp
  have e : phi Complex.reCLM (cT s T) s (1 / 2 - L / (2 * Kt κ)) (L / (2 * Kt κ)) t =
      1 / 2 + L / (2 * Kt κ) * ((cT s T * Gk s 0 t).re - 1) := by
    unfold phi
    rw [Complex.reCLM_apply]
    ring
  rw [e]
  constructor <;> linarith [abs_le.mp hb]

theorem h01_im (hκ : 0 < κ) (hT : 0 < T) (hL : 52 * κ ≤ L) (hs : ‖s‖ ≤ 2 * κ / L) (t : ℝ)
    (ht : t ∈ Set.Icc (T / 4) (2 * T)) :
    0 ≤ phi Complex.imCLM (cT s T) s (1 / 2) (L / (2 * Kt κ)) t ∧
      phi Complex.imCLM (cT s T) s (1 / 2) (L / (2 * Kt κ)) t ≤ 1 := by
  have hL0 : 0 < L := by linarith
  have hK : 0 < Kt κ := by unfold Kt; positivity
  have h := g_sub_one hκ hT hL hs ht
  have him : |(cT s T * Gk s 0 t).im| ≤ Kt κ / L := by
    have := Complex.abs_im_le_norm (cT s T * Gk s 0 t - 1)
    rw [Complex.sub_im, Complex.one_im, sub_zero] at this
    linarith
  have hb : |L / (2 * Kt κ) * (cT s T * Gk s 0 t).im| ≤ 1 / 2 := by
    rw [abs_mul, abs_of_pos (by positivity)]
    calc L / (2 * Kt κ) * |(cT s T * Gk s 0 t).im| ≤ L / (2 * Kt κ) * (Kt κ / L) :=
          mul_le_mul_of_nonneg_left him (by positivity)
      _ = 1 / 2 := by field_simp
  have e : phi Complex.imCLM (cT s T) s (1 / 2) (L / (2 * Kt κ)) t =
      1 / 2 + L / (2 * Kt κ) * (cT s T * Gk s 0 t).im := by
    unfold phi
    rw [Complex.imCLM_apply]
  rw [e]
  constructor <;> linarith [abs_le.mp hb]

/-- The pointwise decomposition: `w (g − 1) = (K/L) ((2 w φ_re − w) + i (2 w φ_im − w))`. -/
theorem decomp (hκ : 0 < κ) (hL0 : 0 < L) (w : ℝ) (t : ℝ) :
    (w : ℂ) * (cT s T * Gk s 0 t - 1) = ((Kt κ / L : ℝ) : ℂ) *
      (((2 * (w * phi Complex.reCLM (cT s T) s (1 / 2 - L / (2 * Kt κ)) (L / (2 * Kt κ)) t) - w
        : ℝ) : ℂ) + I * (((2 * (w * phi Complex.imCLM (cT s T) s (1 / 2) (L / (2 * Kt κ)) t)
          - w : ℝ) : ℂ))) := by
  have hK : 0 < Kt κ := by unfold Kt; positivity
  unfold phi
  rw [Complex.reCLM_apply, Complex.imCLM_apply]
  set g := cT s T * Gk s 0 t
  apply Complex.ext
  · simp only [Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im, Complex.sub_re,
      Complex.one_re, Complex.sub_im, Complex.one_im, Complex.add_re, Complex.I_re,
      Complex.I_im, Complex.add_im, Complex.mul_im]
    field_simp
    ring
  · simp only [Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im, Complex.sub_re,
      Complex.one_re, Complex.sub_im, Complex.one_im, Complex.add_re, Complex.I_re,
      Complex.I_im, Complex.add_im, Complex.mul_im]
    field_simp
    ring

end Concrete

/-! ## Part 3: the sizes — `S1` pointwise on Young's range, `|ψ|²`, `c₁` -/

/-- A term of `S1` on Young's range: `≤ C_V N t^(1/2+2η) ((m+1)(n+1))^(−1−η)`. -/
theorem S1_term_sharp {η CV : ℝ} (hη : 0 < η) (hη4 : η ≤ 1 / 4) (hCV0 : 0 ≤ CV)
    {α β : ℂ} (hαη : ‖α‖ ≤ η) (hβη : ‖β‖ ≤ η) {t : ℝ} (ht : 1 ≤ t)
    (hV : ∀ x : ℝ, 0 < x → ‖VY α β 1 x t‖ ≤ CV * (1 + 1 / ‖α + β‖ ^ 2) * (1 + x / t) ^ (-(1 : ℝ)))
    (p : ℕ × ℕ) :
    ‖((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) *
      VY α β 1 (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t‖ ≤
      CV * (1 + 1 / ‖α + β‖ ^ 2) * t ^ (1 / 2 + 2 * η) *
        (((p.1 : ℝ) + 1) ^ (-(1 + η)) * ((p.2 : ℝ) + 1) ^ (-(1 + η))) := by
  set a : ℝ := 1 / 2 + 2 * η with ha
  set e : ℝ := -(1 + η) with he
  set N : ℝ := 1 + 1 / ‖α + β‖ ^ 2 with hN
  have hN0 : 0 ≤ N := by positivity
  have ht0 : 0 < t := by linarith
  have hta : 0 ≤ t ^ a := by positivity
  set m : ℝ := (p.1 : ℝ) + 1 with hm
  set n : ℝ := (p.2 : ℝ) + 1 with hn
  have hm1 : 1 ≤ m := by rw [hm]; linarith [(p.1.cast_nonneg : (0 : ℝ) ≤ p.1)]
  have hn1 : 1 ≤ n := by rw [hn]; linarith [(p.2.cast_nonneg : (0 : ℝ) ≤ p.2)]
  have hm0 : 0 < m := by linarith
  have hn0 : 0 < n := by linarith
  have hx : 0 < m * n := by positivity
  have e1 : ‖((p.1 : ℂ) + 1) ^ (-uA α t)‖ = m ^ (-(1 / 2 + α.re)) := by
    rw [norm_succ_cpow, Complex.neg_re, uA_re]
  have e2 : ‖((p.2 : ℂ) + 1) ^ (-vB β t)‖ = n ^ (-(1 / 2 + β.re)) := by
    rw [norm_succ_cpow, Complex.neg_re, vB_re]
  have hra : -α.re ≤ η := by
    have := neg_abs_le α.re
    have := Complex.abs_re_le_norm α
    linarith
  have hrb : -β.re ≤ η := by
    have := neg_abs_le β.re
    have := Complex.abs_re_le_norm β
    linarith
  have f1 : m ^ (-(1 / 2 + α.re)) ≤ m ^ (-(1 / 2) + η) :=
    Real.rpow_le_rpow_of_exponent_le hm1 (by linarith only [hra])
  have f2 : n ^ (-(1 / 2 + β.re)) ≤ n ^ (-(1 / 2) + η) :=
    Real.rpow_le_rpow_of_exponent_le hn1 (by linarith only [hrb])
  have hy : 0 < m * n / t := div_pos hx ht0
  have d1 : (1 + m * n / t) ^ (-(1 : ℝ)) ≤ (1 + m * n / t) ^ (-a) :=
    Real.rpow_le_rpow_of_exponent_le (le_add_of_nonneg_right hy.le)
      (by rw [ha]; linarith only [hη4])
  have d2 : (1 + m * n / t) ^ (-a) ≤ (m * n / t) ^ (-a) :=
    Real.rpow_le_rpow_of_nonpos hy (le_add_of_nonneg_left zero_le_one)
      (by rw [ha]; linarith only [hη])
  have d3 : (m * n / t) ^ (-a) = t ^ a * (m ^ (-a) * n ^ (-a)) := by
    rw [Real.div_rpow hx.le ht0.le, Real.rpow_neg ht0.le, div_inv_eq_mul,
      Real.mul_rpow hm0.le hn0.le]
    ring
  have hV' : ‖VY α β 1 (m * n) t‖ ≤ CV * N * (t ^ a * (m ^ (-a) * n ^ (-a))) := by
    refine (hV (m * n) hx).trans ?_
    rw [← d3]
    exact mul_le_mul_of_nonneg_left (d1.trans d2) (by positivity)
  have c1 : m ^ (-(1 / 2) + η) * m ^ (-a) = m ^ e := by
    rw [← Real.rpow_add hm0, ha, he]; ring_nf
  have c2 : n ^ (-(1 / 2) + η) * n ^ (-a) = n ^ e := by
    rw [← Real.rpow_add hn0, ha, he]; ring_nf
  rw [norm_mul, norm_mul, e1, e2]
  calc m ^ (-(1 / 2 + α.re)) * n ^ (-(1 / 2 + β.re)) * ‖VY α β 1 (m * n) t‖ ≤
        (m ^ (-(1 / 2) + η) * n ^ (-(1 / 2) + η)) *
          (CV * N * (t ^ a * (m ^ (-a) * n ^ (-a)))) :=
        mul_le_mul (mul_le_mul f1 f2 (by positivity) (by positivity)) hV' (norm_nonneg _)
          (by positivity)
    _ = CV * N * t ^ a * ((m ^ (-(1 / 2) + η) * m ^ (-a)) * (n ^ (-(1 / 2) + η) * n ^ (-a))) := by
        ring
    _ = _ := by rw [c1, c2]

/-- **`S1` pointwise, sharp in the range**: for `‖α‖, ‖β‖ ≤ η ≤ 1/4`,
`‖S1(α,β,1,t)‖ ≤ C N t^(1/2+2η)` (the exponent `1/2 + ‖α‖` of each sum, the decay traded at
`(mn)^(−1−η)`). The `‖α‖ ≤ 1/10` bound `S1_term_bound` gives `t^(3/5+…)`, too large here. -/
theorem S1_sharp {η : ℝ} (hη : 0 < η) (hη4 : η ≤ 1 / 4) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 → ‖α‖ ≤ η →
      ‖β‖ ≤ η → ∀ t : ℝ, 1 ≤ t →
        ‖S1 α β 1 t‖ ≤ C * (1 + 1 / ‖α + β‖ ^ 2) * t ^ (1 / 2 + 2 * η) := by
  obtain ⟨CV, hCV0, hCV⟩ := VY_decay_young (A := 1) one_pos
  set e : ℝ := -(1 + η) with he
  have hs1 : Summable fun m : ℕ => ‖((m : ℝ) + 1) ^ e‖ := by
    have := (summable_succ_rpow (r := e) (by rw [he]; linarith)).abs
    simpa [Real.norm_eq_abs] using this
  have hsum : Summable fun p : ℕ × ℕ => ((p.1 : ℝ) + 1) ^ e * ((p.2 : ℝ) + 1) ^ e :=
    summable_mul_of_summable_norm hs1 hs1
  set Z : ℝ := ∑' p : ℕ × ℕ, ((p.1 : ℝ) + 1) ^ e * ((p.2 : ℝ) + 1) ^ e with hZ
  have hZ0 : 0 ≤ Z := tsum_nonneg fun p => by positivity
  refine ⟨CV * Z, by positivity, fun α β hα hβ hαβ hαη hβη t ht => ?_⟩
  set a : ℝ := 1 / 2 + 2 * η with ha
  set N : ℝ := 1 + 1 / ‖α + β‖ ^ 2 with hN
  have hN0 : 0 ≤ N := by positivity
  have ht0 : 0 < t := by linarith
  have hta : 0 ≤ t ^ a := by positivity
  have hb := S1_term_sharp hη hη4 hCV0 hαη hβη ht
    (fun x hx => hCV α β hα hβ hαβ t ht x hx 1 one_pos)
  unfold S1
  have hsum' := (hsum.mul_left (CV * N * t ^ a)).hasSum
  refine (tsum_of_norm_bounded hsum' hb).trans_eq ?_
  rw [tsum_mul_left, ← hZ]
  ring

/-- `(Σ_{h ≤ M} h^(−1/2))² ≤ M (1 + log M)` (Cauchy–Schwarz and `harm_le`). -/
theorem sum_half_sq (M : ℕ) :
    (∑ h ∈ Finset.Icc 1 M, (h : ℝ) ^ (-(1 / 2) : ℝ)) ^ 2 ≤ (M : ℝ) * (1 + Real.log M) := by
  have hcs := Finset.sum_mul_sq_le_sq_mul_sq (Finset.Icc 1 M) (fun _ => (1 : ℝ))
    (fun h : ℕ => (h : ℝ) ^ (-(1 / 2) : ℝ))
  simp only [one_mul, one_pow, Finset.sum_const, Nat.card_Icc, add_tsub_cancel_right,
    nsmul_eq_mul, mul_one] at hcs
  have hsq : ∀ h ∈ Finset.Icc 1 M, ((h : ℝ) ^ (-(1 / 2) : ℝ)) ^ 2 = (h : ℝ)⁻¹ := by
    intro h _
    rw [← Real.rpow_natCast, ← Real.rpow_mul (Nat.cast_nonneg h)]
    norm_num [Real.rpow_neg_one]
  rw [Finset.sum_congr rfl hsq] at hcs
  exact hcs.trans (mul_le_mul_of_nonneg_left (harm_le M) (Nat.cast_nonneg M))

/-- Young's mollifier: `|ψ(σ₀+it)|² ≤ B² M (1 + log M)`. -/
theorem msq_young (P : Polynomial ℝ) : ∃ B : ℝ, 0 ≤ B ∧ ∀ (T θ R t : ℝ),
    msq (Mof T θ) (aY P T θ R) (sig0 T R) t ≤
      B ^ 2 * ((Mof T θ : ℝ) * (1 + Real.log (Mof T θ))) := by
  obtain ⟨B, hB0, hB⟩ := aY_bound' P
  refine ⟨B, hB0, fun T θ R t => ?_⟩
  refine (msq_le _ _ _ t).trans ?_
  have h1 : ∑ h ∈ Finset.Icc 1 (Mof T θ), ‖aY P T θ R h‖ * (h : ℝ) ^ (-sig0 T R) ≤
      B * ∑ h ∈ Finset.Icc 1 (Mof T θ), (h : ℝ) ^ (-(1 / 2) : ℝ) := by
    rw [Finset.mul_sum]
    exact Finset.sum_le_sum fun h hh =>
      hB T θ R h (Finset.mem_Icc.mp hh).1 (Finset.mem_Icc.mp hh).2
  have h0 : 0 ≤ ∑ h ∈ Finset.Icc 1 (Mof T θ), ‖aY P T θ R h‖ * (h : ℝ) ^ (-sig0 T R) :=
    Finset.sum_nonneg fun h _ => by positivity
  calc (∑ h ∈ Finset.Icc 1 (Mof T θ), ‖aY P T θ R h‖ * (h : ℝ) ^ (-sig0 T R)) ^ 2 ≤
        (B * ∑ h ∈ Finset.Icc 1 (Mof T θ), (h : ℝ) ^ (-(1 / 2) : ℝ)) ^ 2 :=
        pow_le_pow_left₀ h0 h1 2
    _ = B ^ 2 * (∑ h ∈ Finset.Icc 1 (Mof T θ), (h : ℝ) ^ (-(1 / 2) : ℝ)) ^ 2 := by ring
    _ ≤ _ := mul_le_mul_of_nonneg_left (sum_half_sq _) (by positivity)

/-- The exponent margin `η = (1/2 − θ⁺)/8`. -/
def etaX (θ : ℝ) : ℝ := (1 / 2 - max θ 0) / 8

theorem etaX_pos {θ : ℝ} (hθ : θ < 1 / 2) : 0 < etaX θ := by
  unfold etaX
  have : max θ 0 < 1 / 2 := max_lt hθ (by norm_num)
  linarith

theorem etaX_le {θ : ℝ} : etaX θ ≤ 1 / 16 := by
  unfold etaX
  have := le_max_right θ 0
  linarith

/-- **The size of the `O(1/t)` part**: `N (2T)^(1/2+2η) M (1 + log M) ≤ C T/L`, `θ < 1/2`,
`η = etaX θ`. The power of `T` is `1 − (3/4)(1/2 − θ⁺) < 1`; the logs are absorbed. -/
theorem size_X {θ : ℝ} (hθ : θ < 1 / 2) (κ : ℝ) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ T : ℝ, Real.exp 1 ≤ T → ∀ M : ℕ, (M : ℝ) ≤ T ^ θ →
      (1 + κ ^ 2 * Real.log T ^ 2) * (2 * T) ^ (1 / 2 + 2 * etaX θ) *
        ((M : ℝ) * (1 + Real.log M)) ≤ C * (T / Real.log T) := by
  set θp : ℝ := max θ 0 with hθp
  have hθp1 : θp < 1 / 2 := max_lt hθ (by norm_num)
  have hθp0 : 0 ≤ θp := le_max_right θ 0
  set a : ℝ := 1 / 2 + 2 * etaX θ with ha
  have ha0 : 0 ≤ a := by have := etaX_pos hθ; rw [ha]; linarith
  set ε : ℝ := 3 / 4 * (1 / 2 - θp) with hε
  have hε0 : 0 < ε := by rw [hε]; linarith
  have hsum : a + θp + ε = 1 := by rw [ha, hε, etaX, ← hθp]; ring
  set G : ℝ := ((((4 : ℕ) : ℝ) + 1) / ε) ^ 4 with hG
  refine ⟨2 ^ a * (1 + κ ^ 2) * 2 * G, by positivity, fun T hT M hM => ?_⟩
  have hT1 : 1 ≤ T := le_trans (by linarith [Real.add_one_le_exp (1 : ℝ)]) hT
  have hT0 : 0 < T := by linarith
  set L := Real.log T with hL
  have hL1 : 1 ≤ L := by
    rw [hL, ← Real.log_exp 1]
    exact Real.log_le_log (Real.exp_pos 1) hT
  have hL0 : 0 < L := by linarith
  have hMθ : (M : ℝ) ≤ T ^ θp :=
    hM.trans (Real.rpow_le_rpow_of_exponent_le hT1 (le_max_left θ 0))
  have hlogM : 1 + Real.log M ≤ 2 * L := by
    rcases Nat.eq_zero_or_pos M with h0 | hpos
    · rw [h0]; simp; linarith
    · have hM1 : (1 : ℝ) ≤ M := by exact_mod_cast hpos
      have h1 : Real.log M ≤ Real.log (T ^ θp) := Real.log_le_log (by linarith) hMθ
      rw [Real.log_rpow hT0] at h1
      have : θp * L ≤ L := by nlinarith
      linarith
  have hN : 1 + κ ^ 2 * L ^ 2 ≤ (1 + κ ^ 2) * L ^ 2 := by nlinarith [sq_nonneg κ]
  have h2T : (2 * T) ^ a = 2 ^ a * T ^ a := Real.mul_rpow (by norm_num) hT0.le
  have hMl : (M : ℝ) * (1 + Real.log M) ≤ T ^ θp * (2 * L) :=
    mul_le_mul hMθ hlogM (by
      rcases Nat.eq_zero_or_pos M with h0 | hpos
      · rw [h0]; simp
      · have : (1 : ℝ) ≤ M := by exact_mod_cast hpos
        have := Real.log_nonneg this
        linarith) (by positivity)
  have hlog := logpow_eps 4 hε0 hT1
  rw [← hL] at hlog
  have hTT : T ^ a * T ^ θp * T ^ ε = T := by
    rw [← Real.rpow_add hT0, ← Real.rpow_add hT0, hsum, Real.rpow_one]
  rw [← mul_div_assoc, le_div_iff₀ hL0]
  calc (1 + κ ^ 2 * L ^ 2) * (2 * T) ^ a * ((M : ℝ) * (1 + Real.log M)) * L ≤
        ((1 + κ ^ 2) * L ^ 2) * (2 ^ a * T ^ a) * (T ^ θp * (2 * L)) * L := by
        rw [h2T]
        apply mul_le_mul_of_nonneg_right _ hL0.le
        exact mul_le_mul (mul_le_mul_of_nonneg_right hN (by positivity)) hMl (by positivity)
          (by positivity)
    _ = 2 ^ a * (1 + κ ^ 2) * 2 * (T ^ a * T ^ θp) * L ^ 4 := by ring
    _ ≤ 2 ^ a * (1 + κ ^ 2) * 2 * (T ^ a * T ^ θp) * (G * T ^ ε) :=
        mul_le_mul_of_nonneg_left hlog (by positivity)
    _ = 2 ^ a * (1 + κ ^ 2) * 2 * G * (T ^ a * T ^ θp * T ^ ε) := by ring
    _ = _ := by rw [hTT]

/-- `‖c₁(α,β)‖ ≤ C` on the range: `1/((α+β) log M) ≤ 2κ/θ` and `IY_bound` for `θ > 0`;
`log M = 0`, so `c₁ = 0`, for `θ ≤ 0`. -/
theorem c1Y_bound (P : Polynomial ℝ) {θ : ℝ} (hθ : θ < 1 / 2) {κ : ℝ} (hκ : 0 < κ) :
    ∃ C T₀ : ℝ, 0 ≤ C ∧ ∀ T : ℝ, T₀ ≤ T → ∀ α β : ℂ, Regime κ T α β →
      ‖c1Y P (Mof T θ) α β‖ ≤ C := by
  by_cases hθ0 : 0 < θ
  · obtain ⟨CI, hCI0, hCI⟩ := DiagMain.IY_bound P (A := κ) hκ.le
    refine ⟨2 * κ / θ * CI, max (Real.exp 1) (Real.exp (4 * Real.log 2 / θ)), by positivity,
      fun T hT α β hreg => ?_⟩
    have hTe : Real.exp 1 ≤ T := le_trans (le_max_left _ _) hT
    have hT2 : Real.exp (4 * Real.log 2 / θ) ≤ T := le_trans (le_max_right _ _) hT
    have hT1 : 1 < T := lt_of_lt_of_le (by
      have := Real.add_one_le_exp (1 : ℝ); linarith) hTe
    have hT0 : 0 < T := by linarith
    have hL0 : 0 < Real.log T := Real.log_pos hT1
    have hLθ : 4 * Real.log 2 / θ ≤ Real.log T := by
      rw [← Real.log_exp (4 * Real.log 2 / θ)]
      exact Real.log_le_log (Real.exp_pos _) hT2
    have hge := DiagMain.logM_ge hT1 hθ0 hLθ
    have hle := DiagMain.logM_le hT1.le hθ0.le
    have hlm0 : 0 < Real.log (Mof T θ) := lt_of_lt_of_le (by positivity) hge
    obtain ⟨h1, h2, h3⟩ := hreg
    have hA : ∀ γ : ℂ, ‖γ‖ ≤ κ / Real.log T → ‖γ‖ * Real.log (Mof T θ) ≤ κ := by
      intro γ hγ
      calc ‖γ‖ * Real.log (Mof T θ) ≤ κ / Real.log T * (θ * Real.log T) :=
            mul_le_mul hγ hle hlm0.le (by positivity)
        _ = κ * θ := by field_simp
        _ ≤ κ := by nlinarith
    have hI := hCI (Mof T θ) α β (hA α h1) (hA β h2)
    rw [DiagMain.c1Y_eq, norm_mul]
    have hab : 0 < ‖α + β‖ := lt_of_lt_of_le (by positivity) h3
    have hinv : ‖1 / ((α + β) * (Real.log (Mof T θ) : ℂ))‖ ≤ 2 * κ / θ := by
      rw [norm_div, norm_one, norm_mul, Complex.norm_real, Real.norm_eq_abs,
        abs_of_pos hlm0, div_le_div_iff₀ (by positivity) hθ0]
      have h4 : 1 ≤ κ * Real.log T * ‖α + β‖ := by
        rw [div_le_iff₀ (by positivity)] at h3
        linarith
      nlinarith
    exact mul_le_mul hinv hI (norm_nonneg _) (by positivity)
  · refine ⟨0, 1, le_refl 0, fun T hT α β _ => ?_⟩
    have hθ' : θ ≤ 0 := not_lt.mp hθ0
    have hM : (Mof T θ : ℝ) ≤ 1 :=
      (Nat.floor_le (by positivity)).trans (Real.rpow_le_one_of_one_le_of_nonpos hT hθ')
    have hM' : Mof T θ ≤ 1 := by exact_mod_cast hM
    have hlog : Real.log (Mof T θ) = 0 := by
      interval_cases h : Mof T θ <;> simp
    rw [DiagMain.c1Y_eq, hlog]
    simp

/-! ## Part 4: the open Stirling step, the identities, the assembly -/

/-- OPEN, **(4.2) in its asymptotic form, with the phase**: `X_{α,β,t} = (t/2π)^(−α−β) + O(1/t)`,
uniformly in `‖α‖, ‖β‖ ≤ 1/10`, `t ≥ 1`. `XY_size` gives only the size, `log_norm_Gamma_approx`
only `log‖Γ‖` up to `O(1)`, PNT+'s `StripBounds` upper bounds; none carries the argument.
Route: `X = π^(α+β) Γ(z−α/2)Γ(z̄'−β/2)/(Γ(z+α/2)Γ(z̄'+β/2))`, `z = 1/4 − it/2`; each ratio is
`exp(−∫_{−a}^{a} ψ(z+u) du)` along the segment, and `ψ(w) = log w + O(1/|w|)` on
`1/5 ≤ Re w ≤ 3/10` from the digamma series (`digamma_eq_tsum`, PNT+ `DigammaSeries`,
with no open proofs), the `Stirling.lean` comparison (`re_digamma_sub_log_le`) extended to the imaginary
part and to `O(1/|w|)`. Budget: any `C`; the use below needs the power `t^(−1)`, since the
pointwise `S1` costs `t^(1/2+2η)` and `|ψ|²` costs `T^θ`. -/
def StmtXStirling : Prop :=
  ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t →
    ‖XY α β t - (((t / (2 * Real.pi) : ℝ)) : ℂ) ^ (-(α + β))‖ ≤ C / t

/-- `T^z (t/(2πT))^z = (t/2π)^z`. -/
theorem Tp_g {T t : ℝ} (hT : 0 < T) (ht : 0 < t) (z : ℂ) :
    (T : ℂ) ^ z * (cT z T * Gk z 0 t) = (((t / (2 * Real.pi) : ℝ)) : ℂ) ^ z := by
  have h2 : 0 < t / (2 * Real.pi) := by positivity
  rw [Complex.cpow_def_of_ne_zero (Complex.ofReal_ne_zero.mpr hT.ne'),
    Complex.cpow_def_of_ne_zero (Complex.ofReal_ne_zero.mpr h2.ne'), cG_eq, ← Complex.exp_add]
  congr 1
  rw [← Complex.ofReal_log hT.le, ← Complex.ofReal_log h2.le,
    Real.log_div ht.ne' (by positivity), Real.log_mul (by positivity) hT.ne']
  push_cast
  ring

/-- The `X`-integrand is integrable (as in `I_split`). -/
theorem integrable_IX {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ)
    {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hαβ : α + β ≠ 0) :
    Integrable fun t => (W.w t : ℂ) * (XY α β t * S1 (-β) (-α) 1 t) * (msq M a σ₀ t : ℂ) := by
  have h0 := integrable_Imom W M a σ₀ hα hβ
  have h1 := integrable_I1 W hT M a σ₀ hα hβ (c := 1) one_pos
  have h3 := integrable_Ires W hT M a σ₀ hα hβ
  have hsplit := integrand_split W hT M a σ₀ hα hβ hαβ (c := 1) (by norm_num)
  refine ((h0.sub h1).add h3).congr (ae_of_all _ fun t => ?_)
  simp only [Pi.add_apply, Pi.sub_apply]
  rw [hsplit t]
  ring

/-- Linearity: `∫ k((2f_u − f) + i(2f_v − f)) = k((2∫f_u − ∫f) + i(2∫f_v − ∫f))`. -/
theorem lin_comb {F f fu fv : ℝ → ℂ} (hf : Integrable f) (hfu : Integrable fu)
    (hfv : Integrable fv) (k : ℂ)
    (h : ∀ t, F t = k * ((2 * fu t - f t) + I * (2 * fv t - f t))) :
    Integrable F ∧ ∫ t, F t = k * ((2 * (∫ t, fu t) - ∫ t, f t) + I * (2 * (∫ t, fv t) - ∫ t, f t)) := by
  have hA : Integrable fun t => 2 * fu t - f t := (hfu.const_mul 2).sub hf
  have hB : Integrable fun t => 2 * fv t - f t := (hfv.const_mul 2).sub hf
  have hBI : Integrable fun t => I * (2 * fv t - f t) := hB.const_mul I
  have hS : Integrable fun t => (2 * fu t - f t) + I * (2 * fv t - f t) := hA.add hBI
  have hF : F = fun t => k * ((2 * fu t - f t) + I * (2 * fv t - f t)) := funext h
  refine ⟨hF ▸ hS.const_mul k, ?_⟩
  rw [hF, integral_const_mul, integral_add hA hBI, integral_const_mul,
    integral_sub (hfu.const_mul 2) hf, integral_sub (hfv.const_mul 2) hf, integral_const_mul,
    integral_const_mul]

/-- The `O(1/t)` part, bounded with the pointwise `S1` and `|ψ|²`. -/
theorem E_bound {T L : ℝ} (hT8 : 8 ≤ T) (W : Weight T L) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ)
    {α β : ℂ} {Cst CS N Bm e : ℝ} (hCst : 0 ≤ Cst) (hCS : 0 ≤ CS) (hN : 0 ≤ N) (hBm : 0 ≤ Bm)
    (he : 0 ≤ e)
    (hst : ∀ t : ℝ, 1 ≤ t → ‖XY α β t - (((t / (2 * Real.pi) : ℝ)) : ℂ) ^ (-(α + β))‖ ≤ Cst / t)
    (hS1 : ∀ t : ℝ, 1 ≤ t → ‖S1 (-β) (-α) 1 t‖ ≤ CS * N * t ^ e)
    (hmsq : ∀ t, msq M a σ₀ t ≤ Bm) :
    ‖∫ t, (W.w t : ℂ) * ((XY α β t - (T : ℂ) ^ (-(α + β)) *
        (cT (-(α + β)) T * Gk (-(α + β)) 0 t)) * S1 (-β) (-α) 1 t) * (msq M a σ₀ t : ℂ)‖ ≤
      8 * Cst * CS * N * (2 * T) ^ e * Bm := by
  have hT0 : 0 < T := by linarith
  set K : ℝ := 4 * Cst / T * (CS * N * (2 * T) ^ e) * Bm with hK
  have hK0 : 0 ≤ K := by positivity
  have hb := norm_integral_le_Icc (a := T / 4) (b := 2 * T) (K := K)
    (f := fun t => (W.w t : ℂ) * ((XY α β t - (T : ℂ) ^ (-(α + β)) *
        (cT (-(α + β)) T * Gk (-(α + β)) 0 t)) * S1 (-β) (-α) 1 t) * (msq M a σ₀ t : ℂ))
    (by linarith) (fun t ht => w_zero_mul W ht _ _) (fun t ht => by
      have ht0 : 0 < t := by linarith [ht.1]
      have ht1 : 1 ≤ t := by linarith [ht.1]
      rw [Tp_g hT0 ht0, norm_mul, norm_mul, norm_mul, Complex.norm_real, Complex.norm_real,
        Real.norm_eq_abs, Real.norm_eq_abs, abs_of_nonneg (msq_nonneg M a σ₀ t)]
      have hw := W.abs_le_one t
      have h1 : Cst / t ≤ 4 * Cst / T := by
        rw [div_le_div_iff₀ ht0 hT0]
        nlinarith [ht.1]
      have h2 : t ^ e ≤ (2 * T) ^ e := Real.rpow_le_rpow ht0.le ht.2 he
      have hX := (hst t ht1).trans h1
      have hS := (hS1 t ht1).trans (mul_le_mul_of_nonneg_left h2 (by positivity))
      calc |W.w t| * (‖XY α β t - (((t / (2 * Real.pi) : ℝ)) : ℂ) ^ (-(α + β))‖ *
            ‖S1 (-β) (-α) 1 t‖) * msq M a σ₀ t
          ≤ 1 * ((4 * Cst / T) * (CS * N * (2 * T) ^ e)) * Bm := by
            apply mul_le_mul _ (hmsq t) (msq_nonneg M a σ₀ t) (by positivity)
            exact mul_le_mul hw (mul_le_mul hX hS (norm_nonneg _) (by positivity))
              (by positivity) zero_le_one
        _ = K := by rw [hK]; ring)
  refine hb.trans ?_
  calc K * (2 * T - T / 4) ≤ K * (2 * T) := mul_le_mul_of_nonneg_left (by linarith) hK0
    _ = 8 * Cst * CS * N * (2 * T) ^ e * Bm := by
        rw [hK]
        field_simp
        ring

theorem le_twC {C : ℕ → ℝ} (hC : ∀ j, 0 ≤ C j) (j : ℕ) : C j ≤ twC C j := by
  unfold twC
  have h := Finset.single_le_sum (f := fun i => (j.choose i : ℝ) * C i *
      (((j - i).factorial : ℝ) * 4 ^ (j - i)))
    (fun i _ => by have := hC i; positivity) (Finset.self_mem_range_succ j)
  simpa using h

/-- `‖I₁‖ ≤ 2T(C_c+1) + C_d T/L + C_o errY` for one weight, from the diagonal, the main term
bounded, and the off-diagonal. -/
theorem I1_X_bound {T Cd Co Cc : ℝ} (hT8 : 8 ≤ T) (X : WeightAll T (Real.log T)) (M : ℕ)
    (a : ℕ → ℂ) (σ₀ : ℝ) {α β Z : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10)
    (bd : ‖diagSum X.toWeight M a σ₀ α β 1 - (what0 X.toWeight : ℂ) * Z‖ ≤
      Cd * (T / Real.log T))
    (bo : ‖offSum X.toWeight M a σ₀ α β 1‖ ≤ Co * errY X.toWeight) (hZ : ‖Z‖ ≤ Cc + 1) :
    ‖I1 X.toWeight M a σ₀ α β 1‖ ≤ 2 * T * (Cc + 1) + Cd * (T / Real.log T) +
      Co * errY X.toWeight := by
  have hT0 : 0 < T := by linarith
  rw [I1_diag_off X.toWeight (by linarith) M a σ₀ hα hβ one_pos]
  have hw := what0_le X.toWeight hT0
  have e : diagSum X.toWeight M a σ₀ α β 1 + offSum X.toWeight M a σ₀ α β 1 =
      (diagSum X.toWeight M a σ₀ α β 1 - (what0 X.toWeight : ℂ) * Z) +
        (what0 X.toWeight : ℂ) * Z + offSum X.toWeight M a σ₀ α β 1 := by ring
  rw [e]
  have n1 := norm_add_le ((diagSum X.toWeight M a σ₀ α β 1 - (what0 X.toWeight : ℂ) * Z) +
    (what0 X.toWeight : ℂ) * Z) (offSum X.toWeight M a σ₀ α β 1)
  have n2 := norm_add_le (diagSum X.toWeight M a σ₀ α β 1 - (what0 X.toWeight : ℂ) * Z)
    ((what0 X.toWeight : ℂ) * Z)
  have n3 : ‖(what0 X.toWeight : ℂ) * Z‖ ≤ 2 * T * (Cc + 1) := by
    rw [norm_mul]
    exact mul_le_mul hw hZ (norm_nonneg _) (by positivity)
  linarith

/-- The algebra of the twisted part: `(K/L)((2u − w) + i(2v − w))` with each `‖·‖ = O(T)`. -/
theorem J_alg {K L T Cc Cd Co Cu eu ev eW : ℝ} (hK : 0 ≤ K) (hL1 : 1 ≤ L) (hT : 0 ≤ T)
    (hCc : 0 ≤ Cc) (hCd : 0 ≤ Cd) (hCo : 0 ≤ Co) (hCu : 0 ≤ Cu) {u v w : ℂ}
    (hu : ‖u‖ ≤ 2 * T * (Cc + 1) + Cd * (T / L) + Co * eu)
    (hv : ‖v‖ ≤ 2 * T * (Cc + 1) + Cd * (T / L) + Co * ev)
    (hw : ‖w‖ ≤ 2 * T * (Cc + 1) + Cd * (T / L) + Co * eW)
    (heu : eu ≤ Cu * (T / L)) (hev : ev ≤ Cu * (T / L)) (hTL : T / L ≤ eW) :
    ‖((K / L : ℝ) : ℂ) * ((2 * u - w) + I * (2 * v - w))‖ ≤
      2 * K * (6 * (Cc + 1) + 3 * Cd + 2 * Co * Cu + Co) * eW := by
  have hL0 : 0 < L := by linarith
  have hTL0 : 0 ≤ T / L := div_nonneg hT hL0.le
  have hn : ‖(2 * u - w) + I * (2 * v - w)‖ ≤ 2 * (‖u‖ + ‖v‖ + ‖w‖) := by
    have e1 := norm_add_le (2 * u - w) (I * (2 * v - w))
    have e2 := norm_sub_le (2 * u) w
    have e3 := norm_sub_le (2 * v) w
    rw [norm_mul, Complex.norm_I, one_mul] at e1
    rw [norm_mul, Complex.norm_two] at e2 e3
    linarith
  have hkl : ‖((K / L : ℝ) : ℂ)‖ = K / L := by
    rw [Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg (by positivity)]
  rw [norm_mul, hkl]
  have a1 := mul_le_mul_of_nonneg_left heu hCo
  have a2 := mul_le_mul_of_nonneg_left hev hCo
  have hsum : ‖u‖ + ‖v‖ + ‖w‖ ≤ 6 * T * (Cc + 1) + 3 * Cd * (T / L) +
      Co * (2 * Cu * (T / L) + eW) := by
    have e : Co * (2 * Cu * (T / L) + eW) = Co * (Cu * (T / L)) + Co * (Cu * (T / L)) +
        Co * eW := by ring
    rw [e]
    linarith only [hu, hv, hw, a1, a2]
  have hT1 : T / L ≤ T := div_le_self hT hL1
  have hTLL : T / L / L ≤ T / L := div_le_self hTL0 hL1
  have hKL : K / L ≤ K := div_le_self hK hL1
  have heW : 0 ≤ eW := hTL0.trans hTL
  have b1 : K / L * T = K * (T / L) := by ring
  have b2 : K / L * (T / L) ≤ K * eW := by
    rw [show K / L * (T / L) = K * (T / L / L) by ring]
    exact mul_le_mul_of_nonneg_left (hTLL.trans hTL) hK
  have b3 : K / L * eW ≤ K * eW := mul_le_mul_of_nonneg_right hKL heW
  have b4 : K * (T / L) ≤ K * eW := mul_le_mul_of_nonneg_left hTL hK
  have hpos : 0 ≤ K / L := by positivity
  calc K / L * ‖(2 * u - w) + I * (2 * v - w)‖
      ≤ K / L * (2 * (6 * T * (Cc + 1) + 3 * Cd * (T / L) + Co * (2 * Cu * (T / L) + eW))) :=
        mul_le_mul_of_nonneg_left (hn.trans (by linarith)) hpos
    _ = 2 * (6 * (Cc + 1) * (K / L * T) + (3 * Cd + 2 * Co * Cu) * (K / L * (T / L)) +
          Co * (K / L * eW)) := by ring
    _ ≤ 2 * (6 * (Cc + 1) * (K * eW) + (3 * Cd + 2 * Co * Cu) * (K * eW) + Co * (K * eW)) := by
        rw [b1]
        have h3 : 0 ≤ 3 * Cd + 2 * Co * Cu := by positivity
        have c1 := mul_le_mul_of_nonneg_left b4 (by positivity : (0 : ℝ) ≤ 6 * (Cc + 1))
        have c2 := mul_le_mul_of_nonneg_left b2 h3
        have c3 := mul_le_mul_of_nonneg_left b3 hCo
        linarith
    _ = _ := by ring

/-- The split `I_X − T^z I₁ = ∫ w (X − T^z g) S₁ |ψ|² + T^z ∫ w (g − 1) S₁ |ψ|²`. -/
theorem split_eq {f2 f F E : ℝ → ℂ} (Tp : ℂ) (i2 : Integrable f2) (i1 : Integrable f)
    (iF : Integrable F) (h : ∀ t, E t = f2 t - (Tp * f t + Tp * F t)) :
    (∫ t, f2 t) - Tp * (∫ t, f t) = (∫ t, E t) + Tp * ∫ t, F t := by
  rw [integral_congr_ae (ae_of_all _ h),
    integral_sub (f := f2) (g := fun t => Tp * f t + Tp * F t) i2
      ((i1.const_mul Tp).add (iF.const_mul Tp)),
    integral_add (f := fun t => Tp * f t) (g := fun t => Tp * F t) (i1.const_mul Tp)
      (iF.const_mul Tp), integral_const_mul, integral_const_mul]
  ring

/-- **The X-term over `WeightAll`** (the shape of `StmtOffDiagAll`):
`I_X(α,β) = T^(−α−β) I₁(−β,−α) + O(T/L)`, the constant depending on a family `Cs` fixed first. -/
def StmtXAll (P : Polynomial ℝ) (θ R κ : ℝ) : Prop :=
  ∀ Cs : ℕ → ℝ, ∃ C T₀ : ℝ, 0 ≤ C ∧ ∀ T : ℝ, T₀ ≤ T → ∀ W : WeightAll T (Real.log T),
    (∀ j, W.Cj j ≤ Cs j) → ∀ α β : ℂ, Regime κ T α β →
      ‖IX W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) α β 1 -
        (T : ℂ) ^ (-(α + β)) * I1 W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) (-β) (-α) 1‖ ≤
        C * errY W.toWeight

/-- **The X-term, from Stirling's phase and the main term.** For `θ < 1/2`, `κ > 0`: the
twist `(t/(2πT))^(−α−β) = 1 + O(1/L)` is carried by two weights `w φ_re`, `w φ_im` of the same
class (`twist`), so `T^(−α−β) ∫ w ((t/(2πT))^(−α−β) − 1) S₁(−β,−α) |ψ|²` is `(K/L)` times
three `I₁`'s, each `O(T)` by `diag_young`, `stmtOffDiag_holds` and `‖ζ(1−α−β) S(−β,−α,0)‖ ≤
‖c₁‖ + 1` (`StmtDiagMainO`, `c1Y_bound`); the Stirling remainder `O(1/t)` against the pointwise
`S1_sharp` and `msq_young` is `O(L³ T^(1 − (3/4)(1/2−θ⁺)))` (`size_X`). -/
theorem stmtXAll_of (P : Polynomial ℝ) {θ : ℝ} (hθ : θ < 1 / 2) (R : ℝ) {κ : ℝ} (hκ : 0 < κ)
    (hS : StmtXStirling) (hmain : StmtDiagMainO P θ R κ) : StmtXAll P θ R κ := by
  intro Cs
  set Cs' : ℕ → ℝ := twC (fun i => max (Cs i) 0) with hCs'
  have hCm0 : ∀ i, 0 ≤ max (Cs i) 0 := fun i => le_max_right _ _
  obtain ⟨Co, To, hCo0, ho⟩ := stmtOffDiag_holds P hθ R hκ Cs'
  obtain ⟨Cd, Td, hCd0, hd⟩ := diag_young P hθ R hκ
  obtain ⟨Tm, hm⟩ := hmain 1 one_pos
  obtain ⟨Cc, Tc, hCc0, hc⟩ := c1Y_bound P hθ hκ
  obtain ⟨Cst, hCst0, hst⟩ := hS
  have hη := etaX_pos hθ
  have hη16 := etaX_le (θ := θ)
  obtain ⟨CS, hCS0, hS1⟩ := S1_sharp hη (by linarith)
  obtain ⟨B, hB0, hB⟩ := msq_young P
  obtain ⟨Cf, hCf0, hfs⟩ := size_X hθ κ
  have hK : 0 < Kt κ := by unfold Kt; positivity
  set E2 := Real.exp (2 * κ) with hE2
  set Cu : ℝ := 1 + Cs' 1 + Cs' 2 with hCu
  have hCs'0 : ∀ j, 0 ≤ Cs' j := twC_nonneg hCm0
  have hCu0 : 0 ≤ Cu := by have := hCs'0 1; have := hCs'0 2; rw [hCu]; linarith
  set Q : ℝ := 6 * (Cc + 1) + 3 * Cd + 2 * Co * Cu + Co with hQ
  have hQ0 : 0 ≤ Q := by rw [hQ]; positivity
  refine ⟨E2 * (2 * Kt κ * Q) + 8 * Cst * CS * B ^ 2 * Cf,
    max (max (max To Td) (max Tm Tc)) (max (max 8 (Real.exp 1))
      (max (Real.exp (10 * κ)) (max (Real.exp (52 * κ)) (Real.exp (κ / etaX θ))))),
    by positivity, fun T hT W hW α β hreg => ?_⟩
  simp only [max_le_iff] at hT
  obtain ⟨⟨⟨hTo, hTd⟩, hTm, hTc⟩, ⟨hT8, hTe⟩, hT10, hT52, hTη⟩ := hT
  have hT0 : 0 < T := by linarith
  have hlog : ∀ x : ℝ, Real.exp x ≤ T → x ≤ Real.log T := fun x hx => by
    rw [← Real.log_exp x]; exact Real.log_le_log (Real.exp_pos x) hx
  have hL1 : 1 ≤ Real.log T := hlog 1 hTe
  have hL52 : 52 * κ ≤ Real.log T := hlog _ hT52
  have hLη : κ / etaX θ ≤ Real.log T := hlog _ hTη
  have hL0 : 0 < Real.log T := by linarith
  have hΔ : 0 < T / Real.log T := div_pos hT0 hL0
  obtain ⟨hα, hβ, hαβ, -⟩ := hreg.small hκ hT10
  have hreg' := hreg.swap
  obtain ⟨hα', hβ', hαβ', -⟩ := hreg'.small hκ hT10
  have hkη : κ / Real.log T ≤ etaX θ := by
    rw [div_le_iff₀ hL0]
    rw [div_le_iff₀ hη] at hLη
    linarith
  have hs : ‖-(α + β)‖ ≤ 2 * κ / Real.log T := by
    rw [norm_neg]
    refine (norm_add_le α β).trans ?_
    have := hreg.1
    have := hreg.2.1
    have e : 2 * κ / Real.log T = κ / Real.log T + κ / Real.log T := by ring
    linarith
  set z : ℂ := -(α + β) with hz
  set M := Mof T θ with hM
  set a := aY P T θ R with ha
  set σ := sig0 T R with hσ
  set b : ℝ := Real.log T / (2 * Kt κ) with hb
  -- the two twisted weights
  set Wu := twist W Complex.reCLM (cT z T) z (1 / 2 - b) b hT0 hΔ
    (h01_re hκ hT0 hL52 hs) (hder_of Complex.reCLM
      (fun w => by rw [Complex.reCLM_apply]; exact Complex.abs_re_le_norm w) hκ hT0 hL1 hL52 hs)
    with hWu
  set Wv := twist W Complex.imCLM (cT z T) z (1 / 2) b hT0 hΔ
    (h01_im hκ hT0 hL52 hs) (hder_of Complex.imCLM
      (fun w => by rw [Complex.imCLM_apply]; exact Complex.abs_im_le_norm w) hκ hT0 hL1 hL52 hs)
    with hWv
  have hWC : ∀ j, twC W.Cj j ≤ Cs' j :=
    twC_mono (fun i => (hW i).trans (le_max_left _ _))
  have hWC' : ∀ j, W.Cj j ≤ Cs' j := fun j =>
    ((hW j).trans (le_max_left _ _)).trans (le_twC hCm0 j)
  -- each `I₁` is `O(T)`
  have hZ : ‖riemannZeta (1 + -β + -α) * Sdiag M a σ (-β) (-α) 0‖ ≤ Cc + 1 := by
    have h1 := hm T hTm (-β) (-α) hreg'
    have h2 := hc T hTc (-β) (-α) hreg'
    have := norm_sub_norm_le (riemannZeta (1 + -β + -α) * Sdiag M a σ (-β) (-α) 0)
      (c1Y P M (-β) (-α))
    linarith
  have hI : ∀ X : WeightAll T (Real.log T), (∀ j, X.Cj j ≤ Cs' j) →
      ‖I1 X.toWeight M a σ (-β) (-α) 1‖ ≤ 2 * T * (Cc + 1) + Cd * (T / Real.log T) +
        Co * errY X.toWeight := fun X hX =>
    I1_X_bound hT8 X M a σ hα' hβ' (hd T hTd X.toWeight (-β) (-α) hreg')
      (ho T hTo X hX (-β) (-α) hreg') hZ
  have hIu := hI Wu hWC
  have hIv := hI Wv hWC
  have hIw := hI W hWC'
  have hTL : T / Real.log T ≤ errY W.toWeight := by
    unfold errY
    have := W.C1_nonneg
    have := W.C2_nonneg
    nlinarith
  have herru : errY Wu.toWeight ≤ Cu * (T / Real.log T) := by
    show (1 + twC W.Cj 1 + twC W.Cj 2) * (T / Real.log T) ≤ _
    rw [hCu]
    exact mul_le_mul_of_nonneg_right (by linarith [hWC 1, hWC 2]) hΔ.le
  have herrv : errY Wv.toWeight ≤ Cu * (T / Real.log T) := by
    show (1 + twC W.Cj 1 + twC W.Cj 2) * (T / Real.log T) ≤ _
    rw [hCu]
    exact mul_le_mul_of_nonneg_right (by linarith [hWC 1, hWC 2]) hΔ.le
  -- the integrands
  set S' := fun t => S1 (-β) (-α) 1 t with hS'
  set f := fun t => (W.w t : ℂ) * S1 (-β) (-α) 1 t * (msq M a σ t : ℂ) with hf
  set fu := fun t => (Wu.w t : ℂ) * S1 (-β) (-α) 1 t * (msq M a σ t : ℂ) with hfu
  set fv := fun t => (Wv.w t : ℂ) * S1 (-β) (-α) 1 t * (msq M a σ t : ℂ) with hfv
  set F := fun t => (W.w t : ℂ) * (cT z T * Gk z 0 t - 1) * S1 (-β) (-α) 1 t *
    (msq M a σ t : ℂ) with hF
  have iF := integrable_I1 W.toWeight (by linarith) M a σ hα' hβ' (c := 1) one_pos
  have iFu := integrable_I1 Wu.toWeight (by linarith) M a σ hα' hβ' (c := 1) one_pos
  have iFv := integrable_I1 Wv.toWeight (by linarith) M a σ hα' hβ' (c := 1) one_pos
  have hpt : ∀ t, F t = ((Kt κ / Real.log T : ℝ) : ℂ) *
      ((2 * fu t - f t) + I * (2 * fv t - f t)) := by
    intro t
    simp only [hF, hf, hfu, hfv]
    rw [decomp hκ hL0 (W.w t) t]
    have eu : Wu.w t = W.w t * phi Complex.reCLM (cT z T) z (1 / 2 - b) b t := rfl
    have ev : Wv.w t = W.w t * phi Complex.imCLM (cT z T) z (1 / 2) b t := rfl
    rw [eu, ev]
    push_cast
    ring
  obtain ⟨iJ, hJ⟩ := lin_comb iF iFu iFv _ hpt
  set J := ∫ t, F t with hJdef
  have hJb : ‖J‖ ≤ 2 * Kt κ * Q * errY W.toWeight := by
    rw [hJ, hQ]
    exact J_alg hK.le hL1 hT0.le hCc0 hCd0 hCo0 hCu0 hIu hIv hIw herru herrv hTL
  -- the remainder
  set Tp : ℂ := (T : ℂ) ^ z with hTp
  have iX := integrable_IX W.toWeight (by linarith) M a σ hα hβ hαβ
  have hsplit : IX W.toWeight M a σ α β 1 - Tp * I1 W.toWeight M a σ (-β) (-α) 1 =
      (∫ t, (W.w t : ℂ) * ((XY α β t - Tp * (cT z T * Gk z 0 t)) * S1 (-β) (-α) 1 t) *
        (msq M a σ t : ℂ)) + Tp * J :=
    split_eq Tp iX iF iJ fun t => by simp only [hF]; ring
  have hNb : 1 + 1 / ‖-β + -α‖ ^ 2 ≤ 1 + κ ^ 2 * Real.log T ^ 2 := N_le hκ hL0 hreg'
  have hEb := E_bound hT8 W.toWeight M a σ (α := α) (β := β) hCst0 hCS0
    (by positivity : (0 : ℝ) ≤ 1 + κ ^ 2 * Real.log T ^ 2)
    (by positivity : (0 : ℝ) ≤ B ^ 2 * ((M : ℝ) * (1 + Real.log M)))
    (by linarith : (0 : ℝ) ≤ 1 / 2 + 2 * etaX θ)
    (fun t ht => hst α β hα hβ t ht)
    (fun t ht => (hS1 (-β) (-α) hα' hβ' hαβ' (by rw [norm_neg]; exact hreg.2.1.trans hkη)
      (by rw [norm_neg]; exact hreg.1.trans hkη) t ht).trans (by
        apply mul_le_mul_of_nonneg_right _ (by positivity)
        exact mul_le_mul_of_nonneg_left hNb hCS0))
    (fun t => hB T θ R t)
  have hMr : ((M : ℕ) : ℝ) ≤ T ^ θ := Nat.floor_le (by positivity)
  have hsz := hfs T hTe M hMr
  have hEb' : ‖∫ t, (W.w t : ℂ) * ((XY α β t - Tp * (cT z T * Gk z 0 t)) * S1 (-β) (-α) 1 t) *
      (msq M a σ t : ℂ)‖ ≤ 8 * Cst * CS * B ^ 2 * Cf * errY W.toWeight := by
    refine hEb.trans ?_
    calc 8 * Cst * CS * (1 + κ ^ 2 * Real.log T ^ 2) * (2 * T) ^ (1 / 2 + 2 * etaX θ) *
          (B ^ 2 * ((M : ℝ) * (1 + Real.log M))) =
        8 * Cst * CS * B ^ 2 * ((1 + κ ^ 2 * Real.log T ^ 2) *
          (2 * T) ^ (1 / 2 + 2 * etaX θ) * ((M : ℝ) * (1 + Real.log M))) := by ring
      _ ≤ 8 * Cst * CS * B ^ 2 * (Cf * (T / Real.log T)) :=
          mul_le_mul_of_nonneg_left hsz (by positivity)
      _ ≤ 8 * Cst * CS * B ^ 2 * (Cf * errY W.toWeight) :=
          mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_left hTL hCf0) (by positivity)
      _ = _ := by ring
  have hTpb : ‖Tp‖ ≤ E2 := by
    rw [hTp, hz]
    exact norm_Tpow_le (by linarith) hreg
  rw [hsplit]
  calc _ ≤ ‖∫ t, (W.w t : ℂ) * ((XY α β t - Tp * (cT z T * Gk z 0 t)) * S1 (-β) (-α) 1 t) *
          (msq M a σ t : ℂ)‖ + ‖Tp * J‖ := norm_add_le _ _
    _ ≤ 8 * Cst * CS * B ^ 2 * Cf * errY W.toWeight + E2 * (2 * Kt κ * Q * errY W.toWeight) := by
        rw [norm_mul]
        exact add_le_add hEb' (mul_le_mul hTpb hJb (norm_nonneg _) (Real.exp_pos _).le)
    _ = _ := by ring

/-- **The assembly, `o(T)`, with the X-term over `WeightAll`**: `lemma3_resO_of_parts` with
`StmtXAll` in place of `StmtX` (the weights there are already `WeightAll`). -/
theorem lemma3_resO_of_partsAll {P : Polynomial ℝ} {θ R κ : ℝ} (hκ : 0 < κ)
    (hD : StmtDiagO P θ R κ) (hO : StmtOffDiagAll P θ R κ) (hX : StmtXAll P θ R κ) :
    StmtLemma3resO P θ R κ := by
  intro Cs ε hε
  set e := Real.exp (2 * κ) with he
  have he0 : 0 < e := Real.exp_pos _
  set ε₁ := ε / (2 * (1 + e)) with hε₁
  have hε₁0 : 0 < ε₁ := by positivity
  have hε₁e : ε₁ * (1 + e) = ε / 2 := by
    rw [hε₁]
    field_simp
  obtain ⟨Td, hd⟩ := hD ε₁ hε₁0
  obtain ⟨Co, To, hCo, ho⟩ := hO Cs
  obtain ⟨Cx, Tx, hCx, hx⟩ := hX Cs
  set K := Co + Cx + e * Co with hK
  refine ⟨max (max Td To) (max Tx (max (max 8 (Real.exp (10 * κ))) (Real.exp (K / (ε / 2))))),
    fun T hT W hW α β hreg => ?_⟩
  simp only [max_le_iff] at hT
  obtain ⟨⟨hTd, hTo⟩, hTx, ⟨hT8, hTe⟩, hTK⟩ := hT
  obtain ⟨hα, hβ, hαβ, hL0⟩ := hreg.small hκ hTe
  have hreg' := hreg.swap
  obtain ⟨hα', hβ', hαβ', _⟩ := hreg'.small hκ hTe
  set V := W.toWeight
  set M := Mof T θ
  set a := aY P T θ R
  set σ := sig0 T R
  have hsplit := I_split V (by linarith) M a σ hα hβ hαβ (c := 1) (by norm_num)
  have h1 := I1_diag_off V (by linarith) M a σ hα hβ (c := 1) one_pos
  have h1' := I1_diag_off V (by linarith) M a σ hα' hβ' (c := 1) one_pos
  have bd := hd T hTd V α β hreg
  have bd' := hd T hTd V (-β) (-α) hreg'
  have bo := ho T hTo W hW α β hreg
  have bo' := ho T hTo W hW (-β) (-α) hreg'
  have bx := hx T hTx W hW α β hreg
  have hTp := norm_Tpow_le (by linarith) hreg
  have habs : K * errY V ≤ ε / 2 * errO V := errY_absorb V (by positivity) (by linarith) hTK
  set Tp : ℂ := (T : ℂ) ^ (-(α + β))
  set wh : ℂ := (what0 V : ℂ)
  set dg := diagSum V M a σ α β 1
  set dg' := diagSum V M a σ (-β) (-α) 1
  set of := offSum V M a σ α β 1
  set of' := offSum V M a σ (-β) (-α) 1
  set ix := IX V M a σ α β 1
  set rs := Ires V M a σ α β
  have key : Imom V M a σ α β - cY P M T α β * wh =
      (dg - c1Y P M α β * wh) + of + (ix - Tp * I1 V M a σ (-β) (-α) 1) +
        Tp * (dg' - c1Y P M (-β) (-α) * wh) + Tp * of' - rs := by
    rw [hsplit, h1, h1']
    unfold cY
    ring
  rw [key]
  have m1 : ‖Tp * (dg' - c1Y P M (-β) (-α) * wh)‖ ≤ e * (ε₁ * errO V) := by
    rw [norm_mul]
    exact mul_le_mul hTp bd' (norm_nonneg _) he0.le
  have m2 : ‖Tp * of'‖ ≤ e * (Co * errY V) := by
    rw [norm_mul]
    exact mul_le_mul hTp bo' (norm_nonneg _) he0.le
  calc _ ≤ ‖(dg - c1Y P M α β * wh) + of + (ix - Tp * I1 V M a σ (-β) (-α) 1) +
          Tp * (dg' - c1Y P M (-β) (-α) * wh) + Tp * of'‖ + ‖rs‖ := norm_sub_le _ _
    _ ≤ ‖dg - c1Y P M α β * wh‖ + ‖of‖ + ‖ix - Tp * I1 V M a σ (-β) (-α) 1‖ +
          ‖Tp * (dg' - c1Y P M (-β) (-α) * wh)‖ + ‖Tp * of'‖ + ‖rs‖ := by
        have n1 := norm_add_le ((dg - c1Y P M α β * wh) + of + (ix - Tp * I1 V M a σ (-β) (-α) 1) +
          Tp * (dg' - c1Y P M (-β) (-α) * wh)) (Tp * of')
        have n2 := norm_add_le ((dg - c1Y P M α β * wh) + of + (ix - Tp * I1 V M a σ (-β) (-α) 1))
          (Tp * (dg' - c1Y P M (-β) (-α) * wh))
        have n3 := norm_add_le ((dg - c1Y P M α β * wh) + of) (ix - Tp * I1 V M a σ (-β) (-α) 1)
        have n4 := norm_add_le (dg - c1Y P M α β * wh) of
        linarith
    _ ≤ ε₁ * errO V + Co * errY V + Cx * errY V + e * (ε₁ * errO V) +
          e * (Co * errY V) + ‖rs‖ := by linarith
    _ = ε₁ * (1 + e) * errO V + K * errY V + ‖rs‖ := by rw [hK]; ring
    _ ≤ ε / 2 * errO V + ε / 2 * errO V + ‖rs‖ := by rw [hε₁e]; linarith
    _ = ε * errO V + ‖rs‖ := by ring

/-- **Lemma 3 up to `I_res`, `o(T)`, from the main term and Stirling's phase**: the diagonal by
`stmtDiagO_of_mainO`, the off-diagonal by `stmtOffDiag_holds`, the X-term by `stmtXAll_of`,
for `θ < 1/2`, `κ > 0`. `lemma3_resO_of_mainO_X` with its X-hypothesis discharged. -/
theorem lemma3_resO_of_mainO (P : Polynomial ℝ) {θ : ℝ} (hθ : θ < 1 / 2) (R : ℝ) {κ : ℝ}
    (hκ : 0 < κ) (hS : StmtXStirling) (hmain : StmtDiagMainO P θ R κ) :
    StmtLemma3resO P θ R κ :=
  lemma3_resO_of_partsAll hκ (stmtDiagO_of_mainO P hθ R hκ hmain) (stmtOffDiag_holds P hθ R hκ)
    (stmtXAll_of P hθ R hκ hS hmain)

/-! ## Axiom pins -/

/-- info: 'SwapX.norm_Dk_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_Dk_le

/-- info: 'SwapX.iter_phi' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms iter_phi

/-- info: 'SwapX.phi_iter_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms phi_iter_le

/-- info: 'SwapX.logratio_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms logratio_le

/-- info: 'SwapX.g_sub_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms g_sub_one

/-- info: 'SwapX.hder_of' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms hder_of

/-- info: 'SwapX.decomp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms decomp

/-- info: 'SwapX.S1_sharp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms S1_sharp

/-- info: 'SwapX.msq_young' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms msq_young

/-- info: 'SwapX.size_X' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms size_X

/-- info: 'SwapX.c1Y_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms c1Y_bound

/-- info: 'SwapX.Tp_g' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Tp_g

/-- info: 'SwapX.E_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms E_bound

/-- info: 'SwapX.J_alg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms J_alg

/-- info: 'SwapX.stmtXAll_of' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtXAll_of

/-- info: 'SwapX.lemma3_resO_of_partsAll' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms lemma3_resO_of_partsAll

/-- info: 'SwapX.lemma3_resO_of_mainO' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms lemma3_resO_of_mainO

end

end SwapX
