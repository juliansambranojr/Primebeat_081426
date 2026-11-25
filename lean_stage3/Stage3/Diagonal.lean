/-
# Diagonal — block S12 of `lean_stage3/design/stencil.md`, the diagonal. 2026-11-25.

Young's Lemma 6 (arXiv 1002.4403, §5 (5.1)–(5.3), §6) for the diagonal `diagSum` of
`TwistedMoment`, built in three parts. Notation as in `TwistedMoment`, `ApproxFE`,
`ApproxBounds`: `K(s,t) = KY α β t s = G(s)/s·g(s,t)`, `V = VY α β c x t`, `N = 1 + ‖α+β‖^(−2)`,
`L = log T`, `M = Mof T θ`, Young's `a_h = aY`, `σ₀ = sig0`, `ŵ(0) = what0`, `c₁ = c1Y`.
`d = (h,k)`, `h' = h/d`, `k' = k/d`, `C_{hk} = a_h ā_k (hk)^(−σ₀)` (`Chk`), and
`S(α,β,s) = Σ_{h,k ≤ M} C_{hk} k'^(−(1/2+α+s)) h'^(−(1/2+β+s))` (`Sdiag`).

The route. (a) On `hm = kn`, `(h',k') = 1` forces `m = k'ℓ`, `n = h'ℓ` (`diag_reindex`). At fixed
`t` the `ℓ`-sum of `(k'ℓ)^(−1/2−α)(h'ℓ)^(−1/2−β) V_c(k'h'ℓ², t)` is
`(1/2πi)∫_(c) K(s,t) ζ(1+α+β+2s) k'^(…) h'^(…) ds` (`ell_sum`, absolute convergence on `Re s = c`:
the Gaussian of `G` and `Re(1+α+β+2c) > 1`); `∫ w(t)·` passes through the `ℓ`-sum
(`inner_t`, `VY_line_bound` on `[T/4, 2T]`), the finite `h,k`-sum passes through both integrals
(`diag_per_t`), and Fubini on `ℝ × ℝ` (`joint_integrable`, `wVI_swap`) puts `∫ w g dt` inside
(`diag_mellin`). (b) At fixed `t ≥ 1` the line moves from `Re s = 1` to `Re s = −1/4`
(`shift_t`): the integrand is replaced by `Hf`, where `(w − 1)ζ(w)` is the entire `Ez =
dslope((w−1)²ζ, 1)` and `p(s) = (α+β−2s)(α+β+2s)/(α+β)²` gives its factor `α+β+2s = w − 1`, so
the pole of `ζ(1+α+β+2s)` at `s = −(α+β)/2` is gone and only `s = 0` is crossed, with residue
`ζ(1+α+β) S(α,β,0)` (`Hf_local`, `G(0) = g(0,t) = 1`). Integrated against `w`: `diag_shift`.
On `Re s = −1/4`, `‖K‖ ≪ N (t/2π)^(−1/4) e^(−y²/2)`, `‖ζ(1/2+α+β+2iy)‖ ≪ e^(2|y|)`
(`ZetaGrowth.sq_zeta_band_bound`), and `‖S‖ ≤ SB(−1/4)` (`shifted_bound`). For Young's `a_h`,
`‖a_h‖ h^(−σ₀) ≤ B h^(−1/2)`, `k'^(−Re α) ≤ e^(κ/2)` on the range, and
`h^(−1/2) k^(−1/2) k'^(−1/4) h'^(−1/4) = d^(−1) (h'k')^(−3/4)` with `(h,k) ↦ (d,h',k')` injective
give `SB(−1/4) ≤ B² e^κ M^(1/2) (1 + log M)³` (`gcd_sum`, `SB_young`); so the shifted term is
`≪ L⁵ T^(3/4+θ/2) = O(T/L)` for `θ < 1/2` (`final_size_diag`, `diag_young`). (c) The `h,k`-sum at
`s = 0` with `ζ(1+α+β)` is the named statement `StmtDiagMain`; `stmtDiag_of_main` derives
`StmtDiag` from it.

| statement | content | status |
|---|---|---|
| `Chk`, `Rhk`, `Sdiag`, `Zd`, `Wg`, `SB` | `C_{hk}`; `k'^(−1/2−α−s) h'^(−1/2−β−s)`; `S(α,β,s)`; `ζ(1+α+β+2s) S`; `∫ w g`; `Σ ‖C_{hk}‖ k'^(…) h'^(…)` | defined |
| `diag_reindex` | `Σ_{m,n} [hm = kn] F(m,n) = Σ_ℓ F(k'ℓ, h'ℓ)` | proved |
| `ell_term`, `ell_sum` | the `ℓ`-sum at fixed `t` is `(1/2πi)∫_(c) K ζ(1+α+β+2s) k'^(…) h'^(…)` | proved |
| `joint_integrable`, `wVI_integrable`, `wVI_swap` | `w(t) K(σ+iy,t) Z(σ+iy)` integrable on `ℝ²`; Fubini | proved |
| `inner_t`, `inner_hk` | one `(h,k)` of the diagonal in the per-`t` Mellin form | proved |
| `diag_per_t` | (a): `diagSum = ∫ w(t) (1/2πi)∫_(c) K(s,t) ζ(1+α+β+2s) S(α,β,s) ds dt`, `c > 1/10` | proved |
| `diag_mellin` | (a), Young's form: `diagSum = (1/2πi)∫_(c) G(s)/s (∫ w g) ζ(1+α+β+2s) S(α,β,s) ds` | proved |
| `Ez`, `Ez_eq`, `Ez_differentiable` | `(w−1)ζ(w)`, entire | proved |
| `Hf`, `Hf_eq`, `Hf_local` | the integrand with the pole at `−(α+β)/2` cancelled; residue `ζ(1+α+β) Z(0)` at `0` | proved |
| `zeta_bd`, `orig_bound` | `‖ζ(w)‖ ≤ C e^(|Im w|)` on `−1/2 ≤ Re w ≤ 4`, `‖w−1‖ ≥ 3/10`; the strip bound | proved |
| `shift_t` | (b) at fixed `t`: `∫_(1) = ζ(1+α+β) Z(0) + ∫_(−1/4)`, `Z` entire, bounded on the strip | proved |
| `diag_shift` | (b): `diagSum = ŵ(0) ζ(1+α+β) S(α,β,0) + ∫ w (1/2πi)∫_(−1/4) K ζ S` | proved |
| `shifted_bound` | (b): `‖∫ w ∫_(−1/4)‖ ≤ K₀ N T (T/8π)^(−1/4) SB(−1/4)` | proved |
| `aY_bound'`, `pow_shift_le`, `gcd_sum`, `SB_young` | `SB(−1/4) ≤ B² e^κ M^(1/2) (1 + log M)³` for Young's `ψ` | proved |
| `logpow_eps`, `final_size_diag` | `(1+κ²L²) T (T/8π)^(−1/4) M^(1/2)(1+log M)³ ≤ C T/L`, `θ < 1/2` | proved |
| `diag_young` | (a)+(b): `diagSum = ŵ(0) ζ(1+α+β) S(α,β,0) + O(T/L)`, Young's `ψ`, `θ < 1/2` | proved |
| `StmtDiagMain` | (c): `ζ(1+α+β) S(α,β,0) = c₁(α,β) + O(1/L)` (Young's Lemma 7, §7) | OPEN (named Prop) |
| `stmtDiag_of_main` | `StmtDiagMain → StmtDiag`, `θ < 1/2`, `κ > 0` | proved |

Differences from Young. (i) Young expands `P` by the Mellin formula (6.1) and writes the
`h,k,m,n`-sum as the Euler product (6.2) in `u, v, s` together; here the diagonal is reindexed
through `d = (h,k)` first, the `ℓ`-sum is `ζ(1+α+β+2s)`, and `S(α,β,s)` stays a finite sum with
`P` unexpanded. (ii) Young moves `u, v` to `Re = δ` and `s` to `Re s = −δ + ε`; here only `s`
moves, to `Re s = −1/4`, and `S` is bounded there directly by the gcd structure; the shifted term
is `O(L⁵ T^(3/4+θ/2))`, Young's `O(T^(1−ε))`. (iii) The residue is `ŵ(0) ζ(1+α+β) S(α,β,0)`
exactly; Young's (6.3) writes the same term as `ŵ(0) ζ(1+α+β) Σ_{i,j} a_i a_j i! j!/(log M)^(i+j)
J_{α,β}(M)` after (6.1). (iv) The cancellation of the pole of `ζ(1+α+β+2s)` by the zero of `p` is
made exact by `Ez`; Young states it in words. (v) (c) is not proved: `StmtDiagMain` is Lemma 7 with
the sum over `i, j` and the Taylor expansion of `ζ(1+α+β)`, stated for every `P` as `StmtDiag` is;
Young's proof uses `P(0) = 0` ((6.1) is for `i ≥ 1`) and `0 < θ < 1/2`. (vi) Only the support of
`w` and `|w| ≤ 1` are used, so `StmtDiag` is reached over `Weight` itself, with no `WeightAll`
variant; the bound is `C T/L ≤ C · errY W`. (vii) (a) holds on every line `c > 1/10`
(`‖α‖, ‖β‖ ≤ 1/10`, any `a_h`); Young uses `c = 1`, as `StmtDiag` does. (viii) The `ζ` growth on
the left line is `ZetaGrowth`'s crude `|t|²` bound, absorbed by the Gaussian; Young uses (4.2)
and the convexity bound. (ix) `T₀ = max(8, e, e^(10κ))` and `κ > 0`, as in `stmtOffDiag_holds`;
the range `Regime` keeps Lemma 6's `|α+β| ≥ 1/(κL)`, used for `N ≤ 1 + κ²L²`.

Axioms: [propext, Classical.choice, Quot.sound], pinned below on each main theorem.
-/
import Stage3.OffDiagClose
import Stage3.ZetaGrowth

namespace Diagonal

open Complex MeasureTheory Filter Topology ApproxFE ApproxBounds TwistedMoment

/-! ## Notation -/

/-- The constant of the `(h, k)` term: `a_h ā_k h^(−σ₀) k^(−σ₀)`. -/
noncomputable
def Chk (a : ℕ → ℂ) (σ₀ : ℝ) (h k : ℕ) : ℂ :=
  a h * (starRingEnd ℂ) (a k) * ((h : ℂ) ^ (-(σ₀ : ℂ)) * (k : ℂ) ^ (-(σ₀ : ℂ)))

/-- `k'^(−(1/2+α+s)) h'^(−(1/2+β+s))`, with `h' = h/(h,k)`, `k' = k/(h,k)`. -/
noncomputable
def Rhk (α β : ℂ) (h k : ℕ) (s : ℂ) : ℂ :=
  ((k / Nat.gcd h k : ℕ) : ℂ) ^ (-(1 / 2 + α + s)) *
    ((h / Nat.gcd h k : ℕ) : ℂ) ^ (-(1 / 2 + β + s))

/-- **Young's finite `h,k`-sum**, `S(α,β,s) = Σ_{h,k ≤ M} a_h ā_k (hk)^(−σ₀) k'^(−(1/2+α+s))
h'^(−(1/2+β+s))`. With Young's `a_h`, `a_h h^(−σ₀) = μ(h) P(log(M/h)/log M) h^(−1/2)`. -/
noncomputable
def Sdiag (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ) (α β s : ℂ) : ℂ :=
  ∑ h ∈ Finset.Icc 1 M, ∑ k ∈ Finset.Icc 1 M, Chk a σ₀ h k * Rhk α β h k s

/-- `ζ(1+α+β+2s)·S(α,β,s)`. -/
noncomputable
def Zd (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ) (α β s : ℂ) : ℂ :=
  riemannZeta (1 + α + β + 2 * s) * Sdiag M a σ₀ α β s

/-- One `(h, k)` piece of `Zd`. -/
noncomputable
def Zhk (a : ℕ → ℂ) (σ₀ : ℝ) (α β : ℂ) (h k : ℕ) (s : ℂ) : ℂ :=
  riemannZeta (1 + α + β + 2 * s) * (Chk a σ₀ h k * Rhk α β h k s)

/-- `∫ w(t) g(s,t) dt`. -/
noncomputable
def Wg {T L : ℝ} (W : Weight T L) (α β s : ℂ) : ℂ := ∫ t, (W.w t : ℂ) * gY α β t s

/-- The bound for `‖S(σ+iy)‖`: `Σ_{h,k} ‖C_{hk}‖ k'^(−(1/2+Re α+σ)) h'^(−(1/2+Re β+σ))`. -/
noncomputable
def SB (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ) (α β : ℂ) (σ : ℝ) : ℝ :=
  ∑ h ∈ Finset.Icc 1 M, ∑ k ∈ Finset.Icc 1 M, ‖Chk a σ₀ h k‖ *
    (((k / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 2 + α.re + σ)) *
      ((h / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 2 + β.re + σ)))

/-! ## Part (a): the indices through `d = (h, k)` -/

theorem gcd_facts {h k : ℕ} (hh : 1 ≤ h) (hk : 1 ≤ k) :
    0 < Nat.gcd h k ∧ h = Nat.gcd h k * (h / Nat.gcd h k) ∧
      k = Nat.gcd h k * (k / Nat.gcd h k) ∧ 1 ≤ h / Nat.gcd h k ∧ 1 ≤ k / Nat.gcd h k ∧
        h / Nat.gcd h k ≤ h ∧ k / Nat.gcd h k ≤ k := by
  have hd : 0 < Nat.gcd h k := Nat.gcd_pos_of_pos_left _ hh
  exact ⟨hd, (Nat.mul_div_cancel' (Nat.gcd_dvd_left h k)).symm,
    (Nat.mul_div_cancel' (Nat.gcd_dvd_right h k)).symm,
    Nat.div_pos (Nat.gcd_le_left k hh) hd, Nat.div_pos (Nat.gcd_le_right (m := h) (n := k) hk) hd,
    Nat.div_le_self _ _, Nat.div_le_self _ _⟩

/-- **The constraint `hm = kn`.** With `d = (h,k)`, `h = dh'`, `k = dk'`, `(h',k') = 1`, the
solutions are exactly `m = k'ℓ`, `n = h'ℓ`, `ℓ ≥ 1`. -/
theorem diag_reindex {h k : ℕ} (hh : 1 ≤ h) (hk : 1 ≤ k) (F : ℕ → ℕ → ℂ) :
    ∑' p : ℕ × ℕ, (if h * (p.1 + 1) = k * (p.2 + 1) then F (p.1 + 1) (p.2 + 1) else 0) =
      ∑' l : ℕ, F (k / Nat.gcd h k * (l + 1)) (h / Nat.gcd h k * (l + 1)) := by
  obtain ⟨hd, eh, ek, h1, k1, -, -⟩ := gcd_facts hh hk
  have hcop : Nat.Coprime (h / Nat.gcd h k) (k / Nat.gcd h k) := Nat.coprime_div_gcd_div_gcd hd
  set d := Nat.gcd h k with hdd
  set h' := h / d with hh'
  set k' := k / d with hk'
  set g : ℕ → ℕ × ℕ := fun l => (k' * (l + 1) - 1, h' * (l + 1) - 1) with hg
  have pk : ∀ l, 1 ≤ k' * (l + 1) := fun l =>
    Nat.one_le_iff_ne_zero.mpr (Nat.mul_ne_zero (by omega) (by omega))
  have ph : ∀ l, 1 ≤ h' * (l + 1) := fun l =>
    Nat.one_le_iff_ne_zero.mpr (Nat.mul_ne_zero (by omega) (by omega))
  have hinj : Function.Injective g := by
    intro l₁ l₂ e
    simp only [hg, Prod.mk.injEq] at e
    have e1 : k' * (l₁ + 1) = k' * (l₂ + 1) := by
      have := pk l₁
      have := pk l₂
      omega
    have := Nat.eq_of_mul_eq_mul_left (by omega : 0 < k') e1
    omega
  rw [← hinj.tsum_eq]
  · refine tsum_congr fun l => ?_
    simp only [hg]
    rw [Nat.sub_add_cancel (pk l), Nat.sub_add_cancel (ph l), if_pos]
    calc h * (k' * (l + 1)) = d * h' * (k' * (l + 1)) := by rw [← eh]
      _ = d * k' * (h' * (l + 1)) := by ring
      _ = k * (h' * (l + 1)) := by rw [← ek]
  · intro p hp
    rw [Function.mem_support] at hp
    by_cases hc : h * (p.1 + 1) = k * (p.2 + 1)
    · have hc' : h' * (p.1 + 1) = k' * (p.2 + 1) := by
        apply Nat.eq_of_mul_eq_mul_left hd
        calc d * (h' * (p.1 + 1)) = d * h' * (p.1 + 1) := by ring
          _ = h * (p.1 + 1) := by rw [← eh]
          _ = k * (p.2 + 1) := hc
          _ = d * k' * (p.2 + 1) := by rw [← ek]
          _ = d * (k' * (p.2 + 1)) := by ring
      have hdvd : k' ∣ p.1 + 1 := hcop.symm.dvd_of_dvd_mul_left ⟨p.2 + 1, hc'⟩
      obtain ⟨j, hj⟩ := hdvd
      rcases j with _ | j
      · simp at hj
      · have hn : p.2 + 1 = h' * (j + 1) := by
          apply Nat.eq_of_mul_eq_mul_left (by omega : 0 < k')
          calc k' * (p.2 + 1) = h' * (p.1 + 1) := hc'.symm
            _ = h' * (k' * (j + 1)) := by rw [hj]
            _ = k' * (h' * (j + 1)) := by ring
        refine ⟨j, ?_⟩
        simp only [hg]
        rw [← hj, ← hn]
        simp
    · exact absurd (if_neg hc) hp

/-! ## Part (a): the sum over `ℓ` -/

theorem ncpow_mul (m n : ℕ) (z : ℂ) : ((m * n : ℕ) : ℂ) ^ z = (m : ℂ) ^ z * (n : ℂ) ^ z := by
  rw [Nat.cast_mul, natCast_mul_natCast_cpow]

/-- One term of the `ℓ`-sum: `(k'ℓ)^(−1/2−α) (h'ℓ)^(−1/2−β) K (k'h'ℓ²)^(−s) =
K k'^(−1/2−α−s) h'^(−1/2−β−s) ℓ^(−(1+α+β+2s))`. -/
theorem ell_term {A B : ℕ} (hA : 1 ≤ A) (hB : 1 ≤ B) (l : ℕ) (α β s K : ℂ) :
    ((A * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + α)) * ((B * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + β)) *
        (K * ((((A * (l + 1) : ℕ) : ℝ) * ((B * (l + 1) : ℕ) : ℝ) : ℝ) : ℂ) ^ (-s)) =
      K * ((A : ℂ) ^ (-(1 / 2 + α + s)) * (B : ℂ) ^ (-(1 / 2 + β + s))) *
        (1 / ((l : ℂ) + 1) ^ (1 + α + β + 2 * s)) := by
  have ex : ((((A * (l + 1) : ℕ) : ℝ) * ((B * (l + 1) : ℕ) : ℝ) : ℝ) : ℂ) =
      ((A * (l + 1) * (B * (l + 1)) : ℕ) : ℂ) := by
    push_cast
    ring
  have hA0 : (A : ℂ) ≠ 0 := Nat.cast_ne_zero.mpr (by omega)
  have hB0 : (B : ℂ) ≠ 0 := Nat.cast_ne_zero.mpr (by omega)
  have hq0 : ((l + 1 : ℕ) : ℂ) ≠ 0 := Nat.cast_ne_zero.mpr (Nat.succ_ne_zero l)
  have hq : ((l : ℂ) + 1) = ((l + 1 : ℕ) : ℂ) := by push_cast; ring
  rw [ex]
  simp only [ncpow_mul]
  rw [hq, one_div (((l + 1 : ℕ) : ℂ) ^ (1 + α + β + 2 * s)), ← cpow_neg,
    show -(1 / 2 + α + s) = -(1 / 2 + α) + -s by ring,
    show -(1 / 2 + β + s) = -(1 / 2 + β) + -s by ring,
    show -(1 + α + β + 2 * s) = -(1 / 2 + α) + -(1 / 2 + β) + -s + -s by ring,
    cpow_add _ _ hA0, cpow_add _ _ hB0, cpow_add _ _ hq0, cpow_add _ _ hq0, cpow_add _ _ hq0]
  ring

theorem pos_xl {A B : ℕ} (hA : 1 ≤ A) (hB : 1 ≤ B) (l : ℕ) :
    0 < ((A * (l + 1) : ℕ) : ℝ) * ((B * (l + 1) : ℕ) : ℝ) := by
  have h1 : (0 : ℝ) < ((A * (l + 1) : ℕ) : ℝ) := by exact_mod_cast Nat.mul_pos hA (Nat.succ_pos l)
  have h2 : (0 : ℝ) < ((B * (l + 1) : ℕ) : ℝ) := by exact_mod_cast Nat.mul_pos hB (Nat.succ_pos l)
  positivity

/-- The `ℓ`-coefficients, weighted by `x_ℓ^(−c)`, are summable for `Re(α+β) + 2c > 0`. -/
theorem summable_cf {α β : ℂ} {c : ℝ} (hw : 0 < α.re + β.re + 2 * c) {A B : ℕ} (hA : 1 ≤ A)
    (hB : 1 ≤ B) :
    Summable fun l : ℕ => ‖((A * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + α)) *
        ((B * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + β))‖ *
      (((A * (l + 1) : ℕ) : ℝ) * ((B * (l + 1) : ℕ) : ℝ)) ^ (-c) := by
  have h1 : 1 < (1 + α + β + 2 * (c : ℂ)).re := by simp; linarith
  refine ((summable_zeta_norm h1).mul_left
    ‖(A : ℂ) ^ (-(1 / 2 + α + c)) * (B : ℂ) ^ (-(1 / 2 + β + c))‖).congr fun l => ?_
  have e := ell_term hA hB l α β (c : ℂ) 1
  have hx := pos_xl hA hB l
  have hn : ‖((((A * (l + 1) : ℕ) : ℝ) * ((B * (l + 1) : ℕ) : ℝ) : ℝ) : ℂ) ^ (-(c : ℂ))‖ =
      (((A * (l + 1) : ℕ) : ℝ) * ((B * (l + 1) : ℕ) : ℝ)) ^ (-c) := by
    rw [norm_cpow_eq_rpow_re_of_pos hx]
    simp
  have := congrArg norm e
  simp only [norm_mul, one_mul, hn] at this
  simp only [norm_mul]
  exact this.symm

/-- **The `ℓ`-sum at fixed `t`**: `Σ_ℓ (k'ℓ)^(−1/2−α)(h'ℓ)^(−1/2−β) V_c(k'h'ℓ², t) =
(1/2πi)∫_(c) G(s)/s g(s,t) ζ(1+α+β+2s) k'^(−1/2−α−s) h'^(−1/2−β−s) ds`. -/
theorem ell_sum {α β : ℂ} {t c : ℝ} (hc : 0 < c) (hu : 0 < 1 / 2 + α.re + c)
    (hv : 0 < 1 / 2 + β.re + c) (hw : 0 < α.re + β.re + 2 * c) {A B : ℕ} (hA : 1 ≤ A)
    (hB : 1 ≤ B) :
    ∑' l : ℕ, ((A * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + α)) * ((B * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + β)) *
        VY α β c (((A * (l + 1) : ℕ) : ℝ) * ((B * (l + 1) : ℕ) : ℝ)) t =
      VerticalIntegral' (fun s => KY α β t s * (riemannZeta (1 + α + β + 2 * s) *
        ((A : ℂ) ^ (-(1 / 2 + α + s)) * (B : ℂ) ^ (-(1 / 2 + β + s))))) c := by
  obtain ⟨C, hC0, hC⟩ := KY_bound (α := α) (β := β) (t := t) hc hu hv
  have hcont := KY_continuous_line (α := α) (β := β) (t := t) hc hu hv
  set L : ℝ → ℂ := fun y => (c : ℂ) + y * I with hL
  set xp : ℕ → ℝ := fun l => ((A * (l + 1) : ℕ) : ℝ) * ((B * (l + 1) : ℕ) : ℝ) with hxp
  set cf : ℕ → ℂ := fun l => ((A * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + α)) *
    ((B * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + β)) with hcf
  set F : ℕ → ℝ → ℂ := fun l y => cf l * (KY α β t (L y) * ((xp l : ℝ) : ℂ) ^ (-L y)) with hF
  have hxp0 : ∀ l, 0 < xp l := fun l => pos_xl hA hB l
  have hLre : ∀ y, (L y).re = c := fun y => by simp [hL]
  have hxpow : ∀ l y, ‖((xp l : ℝ) : ℂ) ^ (-L y)‖ = xp l ^ (-c) := fun l y => by
    rw [norm_cpow_eq_rpow_re_of_pos (hxp0 l), Complex.neg_re, hLre]
  have hFn : ∀ l y, ‖F l y‖ = (‖cf l‖ * xp l ^ (-c)) * ‖KY α β t (L y)‖ := fun l y => by
    simp only [hF, norm_mul, hxpow]
    ring
  have hGint : Integrable (fun y : ℝ => C * Real.exp (-(1 / 2) * y ^ 2)) :=
    (integrable_exp_neg_mul_sq (by norm_num : (0 : ℝ) < 1 / 2)).const_mul C
  have hKint : Integrable (fun y : ℝ => KY α β t (L y)) :=
    Integrable.mono' hGint hcont.aestronglyMeasurable (ae_of_all _ hC)
  have hFint : ∀ l, Integrable (F l) := fun l => by
    have hc2 : Continuous fun y : ℝ => ((xp l : ℝ) : ℂ) ^ (-L y) :=
      Continuous.const_cpow (by fun_prop) (Or.inl (ofReal_ne_zero.mpr (hxp0 l).ne'))
    refine Integrable.mono' (hKint.norm.const_mul (‖cf l‖ * xp l ^ (-c)))
      ((hcont.mul hc2).const_mul (cf l)).aestronglyMeasurable (ae_of_all _ fun y => ?_)
    rw [hFn]
  set I0 : ℝ := ∫ y, ‖KY α β t (L y)‖
  have hsum : Summable fun l : ℕ => ∫ y, ‖F l y‖ := by
    refine ((summable_cf hw hA hB).mul_right I0).congr fun l => ?_
    simp only [hFn]
    rw [integral_const_mul]
  have hpt : ∀ y, ∑' l, F l y = KY α β t (L y) * (riemannZeta (1 + α + β + 2 * L y) *
      ((A : ℂ) ^ (-(1 / 2 + α + L y)) * (B : ℂ) ^ (-(1 / 2 + β + L y)))) := fun y => by
    have h1 : 1 < (1 + α + β + 2 * L y).re := by simp [hL]; linarith
    simp only [hF, hcf, hxp]
    simp only [ell_term hA hB _ α β (L y) (KY α β t (L y))]
    rw [tsum_mul_left, ← zeta_eq_tsum_one_div_nat_add_one_cpow h1]
    ring
  simp only [VY, VerticalIntegral', VerticalIntegral, smul_eq_mul]
  calc ∑' l : ℕ, ((A * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + α)) * ((B * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + β)) *
        (1 / (2 * ↑Real.pi * I) * (I * ∫ y : ℝ, KY α β t (↑c + ↑y * I) *
          (↑(((A * (l + 1) : ℕ) : ℝ) * ((B * (l + 1) : ℕ) : ℝ)) : ℂ) ^ (-(↑c + ↑y * I))))
      = ∑' l : ℕ, 1 / (2 * ↑Real.pi * I) * (I * ∫ y : ℝ, F l y) := by
        refine tsum_congr fun l => ?_
        simp only [hF, hcf, hxp, hL]
        rw [integral_const_mul]
        ring
    _ = 1 / (2 * ↑Real.pi * I) * (I * ∫ y : ℝ, ∑' l, F l y) := by
        rw [tsum_mul_left, tsum_mul_left, integral_tsum_of_summable_integral_norm hFint hsum]
    _ = _ := by
        simp only [hpt, hL]

/-! ## Part (a): the sizes used for the swaps -/

theorem re_small' {α : ℂ} (hα : ‖α‖ ≤ 1 / 10) : -(1 / 10) ≤ α.re ∧ α.re ≤ 1 / 10 :=
  abs_le.mp ((Complex.abs_re_le_norm α).trans hα)

theorem im_small' {α : ℂ} (hα : ‖α‖ ≤ 1 / 10) : -(1 / 10) ≤ α.im ∧ α.im ≤ 1 / 10 :=
  abs_le.mp ((Complex.abs_im_le_norm α).trans hα)

/-- `x^σ ≤ a^σ + b^σ` for `0 < a ≤ x ≤ b`, any sign of `σ`. -/
theorem rpow_le_ends' {x a b σ : ℝ} (ha : 0 < a) (hax : a ≤ x) (hxb : x ≤ b) :
    x ^ σ ≤ a ^ σ + b ^ σ := by
  rcases le_total 0 σ with h | h
  · have := Real.rpow_le_rpow (by linarith) hxb h
    linarith [Real.rpow_nonneg ha.le σ]
  · have := Real.rpow_le_rpow_of_nonpos ha hax h
    linarith [Real.rpow_nonneg (ha.le.trans (hax.trans hxb)) σ]

/-- `e^(−y²/2) e^(2|y|) ≤ e⁴ e^(−y²/4)`. -/
theorem gauss_exp (y : ℝ) :
    Real.exp (-(1 / 2) * y ^ 2) * Real.exp (2 * |y|) ≤ Real.exp 4 * Real.exp (-(1 / 4) * y ^ 2) := by
  rw [← Real.exp_add, ← Real.exp_add]
  apply Real.exp_le_exp.mpr
  nlinarith [sq_abs y, sq_nonneg (|y| - 4)]

/-- `‖K(σ+iy, t)‖ ≤ C N (t/2π)^σ e^(−y²/2)` on one line `σ ≠ 0`, `σ > −2/5`, `t ≥ 1`. -/
theorem KY_bd {σ : ℝ} (hσ0 : -(2 / 5) < σ) (hσ : σ ≠ 0) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t → ∀ y : ℝ,
      ‖KY α β t (σ + y * I)‖ ≤
        C * (1 + 1 / ‖α + β‖ ^ 2) * (t / (2 * Real.pi)) ^ σ * Real.exp (-(1 / 2) * y ^ 2) := by
  obtain ⟨C, hC0, hC⟩ := integrand_bound (σ₀ := σ) (σ₁ := σ) (δ := |σ|) hσ0 (abs_pos.mpr hσ)
  refine ⟨C, hC0, fun α β hα hβ t ht y => ?_⟩
  have h := hC α β hα hβ t ht 1 one_pos σ y le_rfl le_rfl
    (by simpa using Complex.abs_re_le_norm ((σ : ℂ) + y * I))
  have e : (((1 : ℝ) : ℂ)) ^ (-((σ : ℂ) + y * I)) = 1 := by simp
  rw [e, mul_one, Real.one_rpow, mul_one] at h
  exact h

/-- `K(σ+iy, t)` is jointly continuous in `(t, y)`. -/
theorem KY_joint_cont {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ}
    (hσ0 : -(2 / 5) < σ) (hσ : σ ≠ 0) :
    Continuous fun p : ℝ × ℝ => KY α β p.1 (σ + p.2 * I) := by
  have ra := re_small' hα
  have rb := re_small' hβ
  rw [continuous_iff_continuousAt]
  intro p
  have hs : ((σ : ℂ) + p.2 * I) ≠ 0 := by
    intro h
    have := congrArg Complex.re h
    simp at this
    exact hσ this
  have h1 : Gammaℝ (uA α p.1 + (σ + p.2 * I)) ≠ 0 :=
    Gammaℝ_ne_zero_of_re_pos (by simp [uA_re]; linarith)
  have h2 : Gammaℝ (vB β p.1 + (σ + p.2 * I)) ≠ 0 :=
    Gammaℝ_ne_zero_of_re_pos (by simp [vB_re]; linarith)
  have h3 : Gammaℝ (uA α p.1) ≠ 0 := Gammaℝ_ne_zero_of_re_pos (by rw [uA_re]; linarith)
  have h4 : Gammaℝ (vB β p.1) ≠ 0 := Gammaℝ_ne_zero_of_re_pos (by rw [vB_re]; linarith)
  have c0 : ContinuousAt (fun p : ℝ × ℝ => (σ : ℂ) + p.2 * I) p := by fun_prop
  have cG : ContinuousAt (fun p : ℝ × ℝ => GY α β ((σ : ℂ) + p.2 * I)) p :=
    ContinuousAt.comp (g := GY α β) (ApproxShift.GY_analyticAt α β _).continuousAt c0
  have c1 : ContinuousAt (fun p : ℝ × ℝ => Gammaℝ (uA α p.1 + (σ + p.2 * I))) p :=
    ContinuousAt.comp (g := Gammaℝ) (differentiableAt_Gammaℝ h1).continuousAt
      (by unfold uA; fun_prop)
  have c2 : ContinuousAt (fun p : ℝ × ℝ => Gammaℝ (vB β p.1 + (σ + p.2 * I))) p :=
    ContinuousAt.comp (g := Gammaℝ) (differentiableAt_Gammaℝ h2).continuousAt
      (by unfold vB; fun_prop)
  have c3 : ContinuousAt (fun p : ℝ × ℝ => Gammaℝ (uA α p.1)) p :=
    ContinuousAt.comp (g := Gammaℝ) (differentiableAt_Gammaℝ h3).continuousAt
      (by unfold uA; fun_prop)
  have c4 : ContinuousAt (fun p : ℝ × ℝ => Gammaℝ (vB β p.1)) p :=
    ContinuousAt.comp (g := Gammaℝ) (differentiableAt_Gammaℝ h4).continuousAt
      (by unfold vB; fun_prop)
  unfold KY gY
  exact (cG.div c0 hs).mul ((c1.mul c2).div (c3.mul c4) (mul_ne_zero h3 h4))

/-- **The joint integrand is integrable on `ℝ × ℝ`**: `w(t) K(σ+iy,t) Z(σ+iy)`, for `Z`
continuous on the line with `‖Z(σ+iy)‖ ≤ K e^(2|y|)`. -/
theorem joint_integrable {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10)
    (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ} (hσ0 : -(2 / 5) < σ) (hσ : σ ≠ 0) {Z : ℂ → ℂ}
    (hZc : Continuous fun y : ℝ => Z (σ + y * I)) {K : ℝ}
    (hZ : ∀ y : ℝ, ‖Z (σ + y * I)‖ ≤ K * Real.exp (2 * |y|)) :
    Integrable (fun p : ℝ × ℝ => (W.w p.1 : ℂ) * (KY α β p.1 (σ + p.2 * I) * Z (σ + p.2 * I)))
      (volume.prod volume) := by
  obtain ⟨C, hC0, hC⟩ := KY_bd hσ0 hσ
  have hK0 : 0 ≤ K := by
    have := (norm_nonneg _).trans (hZ 0)
    simpa using this
  have hT0 : 0 < T := by linarith
  have hS0 : 0 ≤ (T / 4 / (2 * Real.pi)) ^ σ + (2 * T / (2 * Real.pi)) ^ σ := by positivity
  set H : ℝ := C * (1 + 1 / ‖α + β‖ ^ 2) * ((T / 4 / (2 * Real.pi)) ^ σ +
    (2 * T / (2 * Real.pi)) ^ σ) * K * Real.exp 4 with hH
  have hg1 : Integrable (Set.indicator (Set.Icc (T / 4) (2 * T)) (fun _ => (1 : ℝ))) :=
    (integrableOn_const (s := Set.Icc (T / 4) (2 * T)) (C := (1 : ℝ)) measure_Icc_lt_top.ne).integrable_indicator
      measurableSet_Icc
  have hg2 : Integrable fun y : ℝ => H * Real.exp (-(1 / 4) * y ^ 2) :=
    (integrable_exp_neg_mul_sq (by norm_num : (0 : ℝ) < 1 / 4)).const_mul H
  refine Integrable.mono' (hg1.mul_prod hg2) ?_ (ae_of_all _ fun p => ?_)
  · have c1 : Continuous fun p : ℝ × ℝ => (W.w p.1 : ℂ) :=
      continuous_ofReal.comp (W.cont.comp continuous_fst)
    have c3 : Continuous fun p : ℝ × ℝ => Z (σ + p.2 * I) := hZc.comp continuous_snd
    exact (c1.mul ((KY_joint_cont hα hβ hσ0 hσ).mul c3)).aestronglyMeasurable
  · by_cases hp : p.1 ∈ Set.Icc (T / 4) (2 * T)
    · have ht1 : 1 ≤ p.1 := by linarith [hp.1]
      have hw : |W.w p.1| ≤ 1 := W.abs_le_one p.1
      have hk := hC α β hα hβ p.1 ht1 p.2
      have hr : (p.1 / (2 * Real.pi)) ^ σ ≤
          (T / 4 / (2 * Real.pi)) ^ σ + (2 * T / (2 * Real.pi)) ^ σ :=
        rpow_le_ends' (by positivity) (div_le_div_of_nonneg_right hp.1 (by positivity))
          (div_le_div_of_nonneg_right hp.2 (by positivity))
      have hk' : ‖KY α β p.1 (σ + p.2 * I)‖ ≤ C * (1 + 1 / ‖α + β‖ ^ 2) *
          ((T / 4 / (2 * Real.pi)) ^ σ + (2 * T / (2 * Real.pi)) ^ σ) *
            Real.exp (-(1 / 2) * p.2 ^ 2) := by
        refine hk.trans (mul_le_mul_of_nonneg_right ?_ (Real.exp_pos _).le)
        exact mul_le_mul_of_nonneg_left hr (by positivity)
      have hz := hZ p.2
      have hg := gauss_exp p.2
      rw [Set.indicator_of_mem hp, one_mul, norm_mul, norm_mul, Complex.norm_real,
        Real.norm_eq_abs]
      calc |W.w p.1| * (‖KY α β p.1 (σ + p.2 * I)‖ * ‖Z (σ + p.2 * I)‖)
          ≤ 1 * ((C * (1 + 1 / ‖α + β‖ ^ 2) *
              ((T / 4 / (2 * Real.pi)) ^ σ + (2 * T / (2 * Real.pi)) ^ σ) *
              Real.exp (-(1 / 2) * p.2 ^ 2)) * (K * Real.exp (2 * |p.2|))) :=
            mul_le_mul hw (mul_le_mul hk' hz (norm_nonneg _) (by positivity)) (by positivity)
              zero_le_one
        _ = C * (1 + 1 / ‖α + β‖ ^ 2) *
              ((T / 4 / (2 * Real.pi)) ^ σ + (2 * T / (2 * Real.pi)) ^ σ) * K *
              (Real.exp (-(1 / 2) * p.2 ^ 2) * Real.exp (2 * |p.2|)) := by ring
        _ ≤ C * (1 + 1 / ‖α + β‖ ^ 2) *
              ((T / 4 / (2 * Real.pi)) ^ σ + (2 * T / (2 * Real.pi)) ^ σ) * K *
              (Real.exp 4 * Real.exp (-(1 / 4) * p.2 ^ 2)) :=
            mul_le_mul_of_nonneg_left hg (by positivity)
        _ = H * Real.exp (-(1 / 4) * p.2 ^ 2) := by rw [hH]; ring
    · have h0 := (W.zero_out hp).1
      rw [Set.indicator_of_notMem hp, h0]
      simp

/-- `w(t) (1/2πi)∫_(σ) K(s,t) Z(s) ds` is integrable in `t`. -/
theorem wVI_integrable {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10)
    (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ} (hσ0 : -(2 / 5) < σ) (hσ : σ ≠ 0) {Z : ℂ → ℂ}
    (hZc : Continuous fun y : ℝ => Z (σ + y * I)) {K : ℝ}
    (hZ : ∀ y : ℝ, ‖Z (σ + y * I)‖ ≤ K * Real.exp (2 * |y|)) :
    Integrable fun t => (W.w t : ℂ) * VerticalIntegral' (fun s => KY α β t s * Z s) σ := by
  have h2 := (joint_integrable W hT hα hβ hσ0 hσ hZc hZ).integral_prod_left
  refine (h2.const_mul (1 / (2 * Real.pi * I) * I)).congr (ae_of_all _ fun t => ?_)
  simp only [VerticalIntegral', VerticalIntegral, smul_eq_mul]
  rw [integral_const_mul]
  ring

/-- **The Fubini swap**: `∫ w(t) (1/2πi)∫_(σ) K(s,t) Z(s) ds dt =
(1/2πi)∫_(σ) G(s)/s (∫ w(t) g(s,t) dt) Z(s) ds`. -/
theorem wVI_swap {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10)
    (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ} (hσ0 : -(2 / 5) < σ) (hσ : σ ≠ 0) {Z : ℂ → ℂ}
    (hZc : Continuous fun y : ℝ => Z (σ + y * I)) {K : ℝ}
    (hZ : ∀ y : ℝ, ‖Z (σ + y * I)‖ ≤ K * Real.exp (2 * |y|)) :
    ∫ t, (W.w t : ℂ) * VerticalIntegral' (fun s => KY α β t s * Z s) σ =
      VerticalIntegral' (fun s => GY α β s / s * Wg W α β s * Z s) σ := by
  have hJ := joint_integrable W hT hα hβ hσ0 hσ hZc hZ
  have hsw := integral_integral_swap (f := fun t y : ℝ =>
    (W.w t : ℂ) * (KY α β t (σ + y * I) * Z (σ + y * I))) hJ
  simp only [VerticalIntegral', VerticalIntegral, smul_eq_mul]
  have e1 : ∀ t : ℝ, (W.w t : ℂ) * (1 / (2 * Real.pi * I) *
      (I * ∫ y : ℝ, KY α β t (σ + y * I) * Z (σ + y * I))) =
      1 / (2 * Real.pi * I) * I * ∫ y : ℝ, (W.w t : ℂ) * (KY α β t (σ + y * I) * Z (σ + y * I)) := by
    intro t
    rw [integral_const_mul]
    ring
  have e2 : ∀ y : ℝ, ∫ t : ℝ, (W.w t : ℂ) * (KY α β t (σ + y * I) * Z (σ + y * I)) =
      GY α β (σ + y * I) / (σ + y * I) * Wg W α β (σ + y * I) * Z (σ + y * I) := by
    intro y
    unfold Wg KY
    rw [← integral_const_mul, ← integral_mul_const]
    congr 1
    funext t
    ring
  simp only [e1]
  rw [integral_const_mul, hsw]
  simp only [e2]
  ring

/-! ## Part (a): the bounds on the lines -/

theorem norm_cpow_nat {n : ℕ} (hn : 1 ≤ n) (z : ℂ) : ‖(n : ℂ) ^ z‖ = (n : ℝ) ^ z.re :=
  norm_natCast_cpow_of_pos hn z

theorem re_line (x : ℂ) (σ y : ℝ) : (-(x + ((σ : ℂ) + y * I))).re = -(x.re + σ) := by
  simp

theorem Rhk_norm (α β : ℂ) {h k : ℕ} (hh : 1 ≤ h) (hk : 1 ≤ k) (σ y : ℝ) :
    ‖Rhk α β h k (σ + y * I)‖ = ((k / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 2 + α.re + σ)) *
      ((h / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 2 + β.re + σ)) := by
  obtain ⟨-, -, -, h1, k1, -, -⟩ := gcd_facts hh hk
  unfold Rhk
  rw [norm_mul, norm_cpow_nat k1, norm_cpow_nat h1, re_line, re_line]
  simp

/-- `‖Rhk(σ+iy)‖` decreases in `σ`. -/
theorem Rhk_norm_le (α β : ℂ) {h k : ℕ} (hh : 1 ≤ h) (hk : 1 ≤ k) {σ σ' : ℝ} (hσ : σ' ≤ σ)
    (y : ℝ) :
    ‖Rhk α β h k (σ + y * I)‖ ≤ ((k / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 2 + α.re + σ')) *
      ((h / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 2 + β.re + σ')) := by
  obtain ⟨-, -, -, h1, k1, -, -⟩ := gcd_facts hh hk
  rw [Rhk_norm α β hh hk]
  have k1' : (1 : ℝ) ≤ ((k / Nat.gcd h k : ℕ) : ℝ) := by exact_mod_cast k1
  have h1' : (1 : ℝ) ≤ ((h / Nat.gcd h k : ℕ) : ℝ) := by exact_mod_cast h1
  exact mul_le_mul (Real.rpow_le_rpow_of_exponent_le k1' (by linarith))
    (Real.rpow_le_rpow_of_exponent_le h1' (by linarith)) (by positivity) (by positivity)

theorem Sdiag_norm_le (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ) (α β : ℂ) {σ σ' : ℝ} (hσ : σ' ≤ σ) (y : ℝ) :
    ‖Sdiag M a σ₀ α β (σ + y * I)‖ ≤ SB M a σ₀ α β σ' := by
  unfold Sdiag SB
  refine (norm_sum_le _ _).trans (Finset.sum_le_sum fun h hh => ?_)
  refine (norm_sum_le _ _).trans (Finset.sum_le_sum fun k hk => ?_)
  rw [norm_mul]
  exact mul_le_mul_of_nonneg_left (Rhk_norm_le α β (Finset.mem_Icc.mp hh).1
    (Finset.mem_Icc.mp hk).1 hσ y) (norm_nonneg _)

theorem SB_nonneg (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ) (α β : ℂ) (σ : ℝ) : 0 ≤ SB M a σ₀ α β σ := by
  unfold SB
  exact Finset.sum_nonneg fun h _ => Finset.sum_nonneg fun k _ => by positivity

theorem Rhk_differentiable (α β : ℂ) {h k : ℕ} (hh : 1 ≤ h) (hk : 1 ≤ k) :
    Differentiable ℂ (Rhk α β h k) := by
  obtain ⟨-, -, -, h1, k1, -, -⟩ := gcd_facts hh hk
  have hk0 : ((k / Nat.gcd h k : ℕ) : ℂ) ≠ 0 := Nat.cast_ne_zero.mpr (by omega)
  have hh0 : ((h / Nat.gcd h k : ℕ) : ℂ) ≠ 0 := Nat.cast_ne_zero.mpr (by omega)
  have d1 : Differentiable ℂ fun s : ℂ => ((k / Nat.gcd h k : ℕ) : ℂ) ^ (-(1 / 2 + α + s)) :=
    Differentiable.const_cpow (by fun_prop) (Or.inl hk0)
  have d2 : Differentiable ℂ fun s : ℂ => ((h / Nat.gcd h k : ℕ) : ℂ) ^ (-(1 / 2 + β + s)) :=
    Differentiable.const_cpow (by fun_prop) (Or.inl hh0)
  exact d1.mul d2

theorem Sdiag_differentiable (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ) (α β : ℂ) :
    Differentiable ℂ (Sdiag M a σ₀ α β) := by
  have e : Sdiag M a σ₀ α β = fun s => ∑ h ∈ Finset.Icc 1 M, ∑ k ∈ Finset.Icc 1 M,
      Chk a σ₀ h k * Rhk α β h k s := rfl
  rw [e]
  refine Differentiable.fun_sum fun h hh => Differentiable.fun_sum fun k hk => ?_
  exact (differentiable_const _).mul
    (Rhk_differentiable α β (Finset.mem_Icc.mp hh).1 (Finset.mem_Icc.mp hk).1)

/-- `‖ζ(w)‖ ≤ Σ (n+1)^(−Re w)` for `Re w > 1`. -/
theorem zeta_dirichlet_bound {w : ℂ} (hw : 1 < w.re) :
    ‖riemannZeta w‖ ≤ ∑' n : ℕ, ((n : ℝ) + 1) ^ (-w.re) := by
  rw [zeta_eq_tsum_one_div_nat_add_one_cpow hw]
  refine (norm_tsum_le_tsum_norm (summable_zeta_norm hw)).trans (le_of_eq ?_)
  congr 1
  funext n
  rw [norm_div, norm_one, norm_succ_cpow, Real.rpow_neg (by positivity), one_div]

theorem re_w (α β : ℂ) (σ y : ℝ) :
    (1 + α + β + 2 * ((σ : ℂ) + y * I)).re = 1 + α.re + β.re + 2 * σ := by
  simp

theorem im_w (α β : ℂ) (σ y : ℝ) :
    (1 + α + β + 2 * ((σ : ℂ) + y * I)).im = α.im + β.im + 2 * y := by
  simp

theorem w_ne_one {α β : ℂ} {σ y : ℝ} (h : α.re + β.re + 2 * σ ≠ 0) :
    1 + α + β + 2 * ((σ : ℂ) + y * I) ≠ 1 := by
  intro e
  have := congrArg Complex.re e
  rw [re_w] at this
  simp at this
  exact h (by linarith)

/-- `ζ(1+α+β+2s)` is continuous on a line where its argument avoids `1`. -/
theorem zeta_line_cont {α β : ℂ} {σ : ℝ} (h : α.re + β.re + 2 * σ ≠ 0) :
    Continuous fun y : ℝ => riemannZeta (1 + α + β + 2 * ((σ : ℂ) + y * I)) :=
  continuous_iff_continuousAt.mpr fun y =>
    ContinuousAt.comp (g := riemannZeta) (differentiableAt_riemannZeta (w_ne_one h)).continuousAt
      (by fun_prop)

theorem line_integrable {α β : ℂ} {t c : ℝ} (hc : 0 < c) (hu : 0 < 1 / 2 + α.re + c)
    (hv : 0 < 1 / 2 + β.re + c) {Z : ℂ → ℂ} (hZc : Continuous fun y : ℝ => Z (c + y * I)) {K : ℝ}
    (hZ : ∀ y : ℝ, ‖Z (c + y * I)‖ ≤ K) :
    Integrable fun y : ℝ => KY α β t (c + y * I) * Z (c + y * I) := by
  obtain ⟨C, hC0, hC⟩ := KY_bound (α := α) (β := β) (t := t) hc hu hv
  have hcont := KY_continuous_line (α := α) (β := β) (t := t) hc hu hv
  have hK0 : 0 ≤ K := (norm_nonneg _).trans (hZ 0)
  refine Integrable.mono' ((integrable_exp_neg_mul_sq (by norm_num : (0 : ℝ) < 1 / 2)).const_mul
    (C * K)) (hcont.mul hZc).aestronglyMeasurable (ae_of_all _ fun y => ?_)
  rw [norm_mul]
  calc ‖KY α β t (c + y * I)‖ * ‖Z (c + y * I)‖ ≤ (C * Real.exp (-(1 / 2) * y ^ 2)) * K :=
        mul_le_mul (hC y) (hZ y) (norm_nonneg _) (by positivity)
    _ = C * K * Real.exp (-(1 / 2) * y ^ 2) := by ring

theorem vi_sum {ι : Type*} (s : Finset ι) (f : ι → ℂ → ℂ) (σ : ℝ)
    (hf : ∀ i ∈ s, Integrable fun y : ℝ => f i (σ + y * I)) :
    ∑ i ∈ s, VerticalIntegral' (f i) σ = VerticalIntegral' (fun z => ∑ i ∈ s, f i z) σ := by
  simp only [VerticalIntegral', VerticalIntegral, smul_eq_mul]
  rw [integral_finsetSum s (f := fun i (y : ℝ) => f i (σ + y * I)) hf, Finset.mul_sum, Finset.mul_sum]

/-- The `ζ` factor on a line right of `Re s = 0`: `‖ζ(1+α+β+2s)‖ ≤ Σ (n+1)^(−(1+Re α+Re β+2c))`. -/
noncomputable
def Kz (α β : ℂ) (c : ℝ) : ℝ := ∑' n : ℕ, ((n : ℝ) + 1) ^ (-(1 + α.re + β.re + 2 * c))

theorem zeta_line_le {α β : ℂ} {c : ℝ} (hw : 0 < α.re + β.re + 2 * c) (y : ℝ) :
    ‖riemannZeta (1 + α + β + 2 * ((c : ℂ) + y * I))‖ ≤ Kz α β c := by
  have h1 : 1 < (1 + α + β + 2 * ((c : ℂ) + y * I)).re := by rw [re_w]; linarith
  have := zeta_dirichlet_bound h1
  rw [re_w] at this
  exact this

theorem Kz_nonneg (α β : ℂ) (c : ℝ) : 0 ≤ Kz α β c :=
  tsum_nonneg fun n => by positivity

theorem Zhk_cont (a : ℕ → ℂ) (σ₀ : ℝ) {α β : ℂ} {h k : ℕ} (hh : 1 ≤ h) (hk : 1 ≤ k) {σ : ℝ}
    (hne : α.re + β.re + 2 * σ ≠ 0) :
    Continuous fun y : ℝ => Zhk a σ₀ α β h k (σ + y * I) :=
  (zeta_line_cont hne).mul (continuous_const.mul
    ((Rhk_differentiable α β hh hk).continuous.comp (by fun_prop)))

theorem Zd_cont (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ) {α β : ℂ} {σ : ℝ}
    (hne : α.re + β.re + 2 * σ ≠ 0) :
    Continuous fun y : ℝ => Zd M a σ₀ α β (σ + y * I) :=
  (zeta_line_cont hne).mul ((Sdiag_differentiable M a σ₀ α β).continuous.comp (by fun_prop))

theorem Zhk_le (a : ℕ → ℂ) (σ₀ : ℝ) {α β : ℂ} {h k : ℕ} (hh : 1 ≤ h) (hk : 1 ≤ k) {c : ℝ}
    (hw : 0 < α.re + β.re + 2 * c) (y : ℝ) :
    ‖Zhk a σ₀ α β h k (c + y * I)‖ ≤ Kz α β c * (‖Chk a σ₀ h k‖ *
      (((k / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 2 + α.re + c)) *
        ((h / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 2 + β.re + c)))) := by
  unfold Zhk
  rw [norm_mul, norm_mul, Rhk_norm α β hh hk]
  exact mul_le_mul_of_nonneg_right (zeta_line_le hw y) (by positivity)

theorem Zd_le (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ) {α β : ℂ} {c : ℝ} (hw : 0 < α.re + β.re + 2 * c)
    (y : ℝ) : ‖Zd M a σ₀ α β (c + y * I)‖ ≤ Kz α β c * SB M a σ₀ α β c := by
  unfold Zd
  rw [norm_mul]
  exact mul_le_mul (zeta_line_le hw y) (Sdiag_norm_le M a σ₀ α β le_rfl y) (norm_nonneg _)
    (Kz_nonneg α β c)

theorem le_exp_mul {K : ℝ} (hK : 0 ≤ K) (y : ℝ) : K ≤ K * Real.exp (2 * |y|) := by
  have : 1 ≤ Real.exp (2 * |y|) := Real.one_le_exp (by positivity)
  nlinarith

/-! ## Part (a): the assembly -/

/-- The `ℓ`-sum, integrated against `w`: `Σ_ℓ c_ℓ ∫ w(t) V_c(x_ℓ, t) dt =
∫ w(t) (1/2πi)∫_(c) G(s)/s g(s,t) ζ(1+α+β+2s) k'^(…) h'^(…) ds dt`. -/
theorem inner_t {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10)
    (hβ : ‖β‖ ≤ 1 / 10) {c : ℝ} (hc : 1 / 10 < c) {A B : ℕ} (hA : 1 ≤ A) (hB : 1 ≤ B) :
    ∑' l : ℕ, ((A * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + α)) * ((B * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + β)) *
        ∫ t, (W.w t : ℂ) * VY α β c (((A * (l + 1) : ℕ) : ℝ) * ((B * (l + 1) : ℕ) : ℝ)) t =
      ∫ t, (W.w t : ℂ) * VerticalIntegral' (fun s => KY α β t s *
        (riemannZeta (1 + α + β + 2 * s) *
          ((A : ℂ) ^ (-(1 / 2 + α + s)) * (B : ℂ) ^ (-(1 / 2 + β + s))))) c := by
  have ra := re_small' hα
  have rb := re_small' hβ
  have hc0 : 0 < c := by linarith
  have hT0 : 0 < T := by linarith
  have hw : 0 < α.re + β.re + 2 * c := by linarith
  obtain ⟨Cv, hCv0, hCv⟩ := VY_line_bound (σ := c) (by linarith) hc0.ne'
  set xp : ℕ → ℝ := fun l => ((A * (l + 1) : ℕ) : ℝ) * ((B * (l + 1) : ℕ) : ℝ) with hxp
  set cf : ℕ → ℂ := fun l => ((A * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + α)) *
    ((B * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + β)) with hcf
  set F : ℕ → ℝ → ℂ := fun l t => (W.w t : ℂ) * (cf l * VY α β c (xp l) t) with hF
  have hxp0 : ∀ l, 0 < xp l := fun l => pos_xl hA hB l
  have hF0 : ∀ l t, t ∉ Set.Icc (T / 4) (2 * T) → F l t = 0 := fun l t ht => by
    simp only [hF, (W.zero_out ht).1]
    simp
  have hFint : ∀ l, Integrable (F l) := fun l =>
    integrable_of_Icc (a := T / 4) (b := 2 * T) (Continuous.continuousOn
      ((continuous_ofReal.comp W.cont).mul (continuous_const.mul
        (continuous_VY hc0 hα hβ (hxp0 l))))) (hF0 l)
  set Kb : ℝ := Cv * (1 + 1 / ‖α + β‖ ^ 2) * (2 * T / (2 * Real.pi)) ^ c with hKb
  have hKb0 : 0 ≤ Kb := by positivity
  have hFb : ∀ l, ∫ t, ‖F l t‖ ≤ (‖cf l‖ * xp l ^ (-c)) * Kb * (2 * T - T / 4) := by
    intro l
    have hb : ∀ t ∈ Set.Icc (T / 4) (2 * T), ‖‖F l t‖‖ ≤ (‖cf l‖ * xp l ^ (-c)) * Kb := by
      intro t ht
      rw [norm_norm]
      have ht1 : 1 ≤ t := by linarith [ht.1]
      have hv := hCv α β hα hβ t ht1 (xp l) (hxp0 l)
      have hr : (t / (2 * Real.pi)) ^ c ≤ (2 * T / (2 * Real.pi)) ^ c :=
        Real.rpow_le_rpow (div_nonneg (by linarith) (by positivity))
          (div_le_div_of_nonneg_right ht.2 (by positivity)) hc0.le
      have hw1 : |W.w t| ≤ 1 := W.abs_le_one t
      have hv' : ‖VY α β c (xp l) t‖ ≤ Kb * xp l ^ (-c) := by
        refine hv.trans ?_
        rw [hKb]
        have : 0 ≤ xp l ^ (-c) := by positivity
        have h2 : Cv * (1 + 1 / ‖α + β‖ ^ 2) * ((t / (2 * Real.pi)) ^ c * xp l ^ (-c)) =
            Cv * (1 + 1 / ‖α + β‖ ^ 2) * (t / (2 * Real.pi)) ^ c * xp l ^ (-c) := by ring
        rw [h2]
        gcongr
      simp only [hF, norm_mul, Complex.norm_real, Real.norm_eq_abs]
      calc |W.w t| * (‖cf l‖ * ‖VY α β c (xp l) t‖) ≤ 1 * (‖cf l‖ * (Kb * xp l ^ (-c))) :=
            mul_le_mul hw1 (mul_le_mul_of_nonneg_left hv' (norm_nonneg _)) (by positivity)
              zero_le_one
        _ = (‖cf l‖ * xp l ^ (-c)) * Kb := by ring
    have h := norm_integral_le_Icc (f := fun t => ‖F l t‖) (a := T / 4) (b := 2 * T)
      (K := (‖cf l‖ * xp l ^ (-c)) * Kb) (by linarith)
      (fun t ht => by rw [hF0 l t ht, norm_zero]) hb
    rwa [Real.norm_of_nonneg (integral_nonneg fun t => norm_nonneg _)] at h
  have hsum : Summable fun l : ℕ => ∫ t, ‖F l t‖ := by
    refine Summable.of_nonneg_of_le (fun l => integral_nonneg fun t => norm_nonneg _) hFb ?_
    exact (((summable_cf hw hA hB).mul_right Kb).mul_right (2 * T - T / 4))
  have hpt : ∀ t, ∑' l, F l t = (W.w t : ℂ) * VerticalIntegral' (fun s => KY α β t s *
      (riemannZeta (1 + α + β + 2 * s) *
        ((A : ℂ) ^ (-(1 / 2 + α + s)) * (B : ℂ) ^ (-(1 / 2 + β + s))))) c := fun t => by
    simp only [hF]
    rw [tsum_mul_left]
    congr 1
    exact ell_sum hc0 (by linarith) (by linarith) hw hA hB
  calc ∑' l : ℕ, ((A * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + α)) * ((B * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + β)) *
        ∫ t, (W.w t : ℂ) * VY α β c (((A * (l + 1) : ℕ) : ℝ) * ((B * (l + 1) : ℕ) : ℝ)) t
      = ∑' l : ℕ, ∫ t, F l t := by
        refine tsum_congr fun l => ?_
        simp only [hF, hcf, hxp]
        rw [← integral_const_mul]
        congr 1
        funext t
        ring
    _ = ∫ t, ∑' l, F l t := integral_tsum_of_summable_integral_norm hFint hsum
    _ = _ := by simp only [hpt]

/-- **One `(h, k)` of the diagonal** in the per-`t` Mellin form. -/
theorem inner_hk {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) (a : ℕ → ℂ) (σ₀ : ℝ) {α β : ℂ}
    (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {c : ℝ} (hc : 1 / 10 < c) {h k : ℕ} (hh : 1 ≤ h)
    (hk : 1 ≤ k) :
    ∑' p : ℕ × ℕ, (if h * (p.1 + 1) = k * (p.2 + 1) then
        coefY a σ₀ α β h k (p.1 + 1) (p.2 + 1) * Jint W α β c h k (p.1 + 1) (p.2 + 1) else 0) =
      ∫ t, (W.w t : ℂ) * VerticalIntegral' (fun s => KY α β t s * Zhk a σ₀ α β h k s) c := by
  obtain ⟨hd, eh, ek, h1, k1, -, -⟩ := gcd_facts hh hk
  rw [diag_reindex hh hk (fun m n => coefY a σ₀ α β h k m n * Jint W α β c h k m n)]
  have hterm : ∀ l : ℕ,
      coefY a σ₀ α β h k (k / Nat.gcd h k * (l + 1)) (h / Nat.gcd h k * (l + 1)) *
        Jint W α β c h k (k / Nat.gcd h k * (l + 1)) (h / Nat.gcd h k * (l + 1)) =
      Chk a σ₀ h k * (((k / Nat.gcd h k * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + α)) *
        ((h / Nat.gcd h k * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + β)) *
        ∫ t, (W.w t : ℂ) * VY α β c (((k / Nat.gcd h k * (l + 1) : ℕ) : ℝ) *
          ((h / Nat.gcd h k * (l + 1) : ℕ) : ℝ)) t) := by
    intro l
    have hn : 1 ≤ h / Nat.gcd h k * (l + 1) :=
      Nat.one_le_iff_ne_zero.mpr (Nat.mul_ne_zero (by omega) (by omega))
    have hdg : h * (k / Nat.gcd h k * (l + 1)) = k * (h / Nat.gcd h k * (l + 1)) := by
      calc h * (k / Nat.gcd h k * (l + 1))
          = Nat.gcd h k * (h / Nat.gcd h k) * (k / Nat.gcd h k * (l + 1)) := by rw [← eh]
        _ = Nat.gcd h k * (k / Nat.gcd h k) * (h / Nat.gcd h k * (l + 1)) := by ring
        _ = k * (h / Nat.gcd h k * (l + 1)) := by rw [← ek]
    rw [Jint_diag W α β c hk hn hdg]
    unfold coefY Chk
    ring
  simp only [hterm]
  rw [tsum_mul_left, inner_t W hT hα hβ hc k1 h1, ← integral_const_mul]
  congr 1
  funext t
  have e : ∫ y : ℝ, KY α β t (↑c + ↑y * I) * Zhk a σ₀ α β h k (↑c + ↑y * I) =
      Chk a σ₀ h k * ∫ y : ℝ, KY α β t (↑c + ↑y * I) *
        (riemannZeta (1 + α + β + 2 * (↑c + ↑y * I)) *
          (((k / Nat.gcd h k : ℕ) : ℂ) ^ (-(1 / 2 + α + (↑c + ↑y * I))) *
            ((h / Nat.gcd h k : ℕ) : ℂ) ^ (-(1 / 2 + β + (↑c + ↑y * I))))) := by
    rw [← integral_const_mul]
    congr 1
    funext y
    unfold Zhk Rhk
    ring
  simp only [VerticalIntegral', VerticalIntegral, smul_eq_mul, e]
  ring

/-- **(a), per `t`**: the diagonal is `∫ w(t) (1/2πi)∫_(c) G(s)/s g(s,t) ζ(1+α+β+2s) S(α,β,s) ds dt`,
for `c > 1/10`, `T ≥ 4`, `‖α‖, ‖β‖ ≤ 1/10`, any coefficients `a_h`. -/
theorem diag_per_t {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ)
    {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {c : ℝ} (hc : 1 / 10 < c) :
    diagSum W M a σ₀ α β c =
      ∫ t, (W.w t : ℂ) * VerticalIntegral' (fun s => KY α β t s * Zd M a σ₀ α β s) c := by
  have ra := re_small' hα
  have rb := re_small' hβ
  have hc0 : 0 < c := by linarith
  have hw : 0 < α.re + β.re + 2 * c := by linarith
  have hti : ∀ h ∈ Finset.Icc 1 M, ∀ k ∈ Finset.Icc 1 M, Integrable fun t =>
      (W.w t : ℂ) * VerticalIntegral' (fun s => KY α β t s * Zhk a σ₀ α β h k s) c := by
    intro h hh k hk
    have hh1 := (Finset.mem_Icc.mp hh).1
    have hk1 := (Finset.mem_Icc.mp hk).1
    exact wVI_integrable W hT hα hβ (by linarith) hc0.ne' (Zhk_cont a σ₀ hh1 hk1 hw.ne')
      (fun y => (Zhk_le a σ₀ hh1 hk1 hw y).trans (le_exp_mul (by positivity [Kz_nonneg α β c]) y))
  have hli : ∀ t : ℝ, ∀ h ∈ Finset.Icc 1 M, ∀ k ∈ Finset.Icc 1 M, Integrable fun y : ℝ =>
      KY α β t (c + y * I) * Zhk a σ₀ α β h k (c + y * I) := by
    intro t h hh k hk
    have hh1 := (Finset.mem_Icc.mp hh).1
    have hk1 := (Finset.mem_Icc.mp hk).1
    exact line_integrable hc0 (by linarith) (by linarith) (Zhk_cont a σ₀ hh1 hk1 hw.ne')
      (Zhk_le a σ₀ hh1 hk1 hw)
  unfold diagSum
  rw [Finset.sum_congr rfl fun h hh => Finset.sum_congr rfl fun k hk =>
    inner_hk W hT a σ₀ hα hβ hc (Finset.mem_Icc.mp hh).1 (Finset.mem_Icc.mp hk).1]
  rw [Finset.sum_congr rfl fun h hh => (integral_finsetSum _ (hti h hh)).symm,
    ← integral_finsetSum _ fun h hh => integrable_finsetSum _ (hti h hh)]
  congr 1
  funext t
  simp only [← Finset.mul_sum]
  congr 1
  rw [Finset.sum_congr rfl fun h hh => vi_sum _ (fun k s => KY α β t s * Zhk a σ₀ α β h k s) c
    (hli t h hh)]
  rw [vi_sum _ (fun h s => ∑ k ∈ Finset.Icc 1 M, KY α β t s * Zhk a σ₀ α β h k s) c
    (fun h hh => integrable_finsetSum _ (hli t h hh))]
  congr 1
  funext s
  unfold Zd Sdiag Zhk
  simp only [Finset.mul_sum]

/-- **(a), Young's Mellin form of the diagonal**: for `c > 1/10`, `T ≥ 4`, `‖α‖, ‖β‖ ≤ 1/10`,
`diagSum = (1/2πi) ∫_(c) G(s)/s · (∫ w(t) g(s,t) dt) · ζ(1+α+β+2s) · S(α,β,s) ds`. -/
theorem diag_mellin {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ)
    {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {c : ℝ} (hc : 1 / 10 < c) :
    diagSum W M a σ₀ α β c = VerticalIntegral' (fun s => GY α β s / s * Wg W α β s *
      riemannZeta (1 + α + β + 2 * s) * Sdiag M a σ₀ α β s) c := by
  have ra := re_small' hα
  have rb := re_small' hβ
  have hc0 : 0 < c := by linarith
  have hw : 0 < α.re + β.re + 2 * c := by linarith
  rw [diag_per_t W hT M a σ₀ hα hβ hc, wVI_swap W hT hα hβ (by linarith) hc0.ne'
    (Zd_cont M a σ₀ hw.ne')
    (fun y => (Zd_le M a σ₀ hw y).trans (le_exp_mul (mul_nonneg (Kz_nonneg α β c)
      (SB_nonneg M a σ₀ α β c)) y))]
  unfold Zd
  simp only [mul_assoc]

/-! ## Part (b): the shift to `Re s = −1/4` -/

/-- `ζ` on the band `−1/2 ≤ Re w ≤ 4`, `‖w − 1‖ ≥ 3/10`: `‖ζ(w)‖ ≤ C e^(|Im w|)`
(from `ZetaGrowth.sq_zeta_band_bound`). -/
theorem zeta_bd : ∃ Cz : ℝ, 0 ≤ Cz ∧ ∀ w : ℂ, -(1 / 2) ≤ w.re → w.re ≤ 4 → 3 / 10 ≤ ‖w - 1‖ →
    ‖riemannZeta w‖ ≤ Cz * Real.exp |w.im| := by
  obtain ⟨C, hC0, hC⟩ := ZetaGrowth.sq_zeta_band_bound
  refine ⟨C * 24 * Real.exp 2 / (9 / 100), by positivity, fun w h1 h2 h3 => ?_⟩
  have hb := hC w (by linarith) h2
  have hn : (9 / 100 : ℝ) ≤ ‖w - 1‖ ^ 2 := by nlinarith
  have hp : (2 + |w.im|) ^ 4 ≤ 24 * Real.exp (2 + |w.im|) := by
    have := Real.pow_div_factorial_le_exp (2 + |w.im|) (by positivity) 4
    norm_num [Nat.factorial] at this
    linarith
  rw [norm_mul, norm_pow] at hb
  have hpos : 0 < ‖w - 1‖ ^ 2 := by linarith
  have h4 : ‖riemannZeta w‖ ≤ C * (2 + |w.im|) ^ 4 / ‖w - 1‖ ^ 2 := by
    rw [le_div_iff₀ hpos]
    linarith
  calc ‖riemannZeta w‖ ≤ C * (2 + |w.im|) ^ 4 / ‖w - 1‖ ^ 2 := h4
    _ ≤ C * (24 * Real.exp (2 + |w.im|)) / (9 / 100) := by
        apply div_le_div₀ (by positivity) (mul_le_mul_of_nonneg_left hp hC0.le) (by norm_num) hn
    _ = C * 24 * Real.exp 2 / (9 / 100) * Real.exp |w.im| := by rw [Real.exp_add]; ring

/-- `(w − 1) ζ(w)`, holomorphic everywhere: the slope of `(w − 1)² ζ(w)` at `1`. -/
noncomputable
def Ez : ℂ → ℂ := dslope (fun w : ℂ => (w - 1) ^ 2 * riemannZeta w) 1

theorem Ez_eq {w : ℂ} (hw : w ≠ 1) : Ez w = (w - 1) * riemannZeta w := by
  unfold Ez
  rw [dslope_of_ne _ hw, slope_def_field, sub_self, zero_pow two_ne_zero, zero_mul, sub_zero]
  have : w - 1 ≠ 0 := sub_ne_zero.mpr hw
  field_simp
  try ring

theorem Ez_differentiable : Differentiable ℂ Ez := fun w => by
  unfold Ez
  by_cases hw : w = 1
  · subst hw
    exact (ContourShift.analyticAt_dslope ContourShift.sq_mul_zeta_analyticAt_one).differentiableAt
  · exact (differentiableAt_dslope_of_ne hw).mpr (ZetaGrowth.sq_mul_zeta_analytic w).differentiableAt

/-- The shift integrand with the pole of `ζ(1+α+β+2s)` at `s = −(α+β)/2` cancelled by the zero of
`p(s)`: `e^(s²) (α+β−2s)/(α+β)² / s · g(s,t) · (w−1)ζ(w) · Z(s)`, `w = 1+α+β+2s`. -/
noncomputable
def Hf (α β : ℂ) (t : ℝ) (Z : ℂ → ℂ) (s : ℂ) : ℂ :=
  cexp (s ^ 2) * ((α + β - 2 * s) / (α + β) ^ 2) / s * gY α β t s *
    (Ez (1 + α + β + 2 * s) * Z s)

theorem Hf_eq (α β : ℂ) (t : ℝ) (Z : ℂ → ℂ) {s : ℂ} (hw : 1 + α + β + 2 * s ≠ 1) :
    Hf α β t Z s = KY α β t s * (riemannZeta (1 + α + β + 2 * s) * Z s) := by
  unfold Hf KY GY
  rw [Ez_eq hw]
  ring

theorem gY_differentiableAt {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (t : ℝ) {s : ℂ}
    (hs : -(2 / 5) < s.re) : DifferentiableAt ℂ (gY α β t) s := by
  have ra := re_small' hα
  have rb := re_small' hβ
  have h1 : Gammaℝ (uA α t + s) ≠ 0 :=
    Gammaℝ_ne_zero_of_re_pos (by rw [Complex.add_re, uA_re]; linarith)
  have h2 : Gammaℝ (vB β t + s) ≠ 0 :=
    Gammaℝ_ne_zero_of_re_pos (by rw [Complex.add_re, vB_re]; linarith)
  have hg1 : DifferentiableAt ℂ (fun s => Gammaℝ (uA α t + s)) s :=
    (differentiableAt_Gammaℝ h1).comp s (by fun_prop)
  have hg2 : DifferentiableAt ℂ (fun s => Gammaℝ (vB β t + s)) s :=
    (differentiableAt_Gammaℝ h2).comp s (by fun_prop)
  unfold gY
  exact (hg1.mul hg2).div_const _

/-- The analytic part `K` with `Hf = K/s`. -/
noncomputable
def Kf (α β : ℂ) (t : ℝ) (Z : ℂ → ℂ) (s : ℂ) : ℂ :=
  cexp (s ^ 2) * ((α + β - 2 * s) / (α + β) ^ 2) * gY α β t s * (Ez (1 + α + β + 2 * s) * Z s)

theorem Kf_differentiableAt {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (t : ℝ)
    {Z : ℂ → ℂ} (hZd : Differentiable ℂ Z) {s : ℂ} (hs : -(2 / 5) < s.re) :
    DifferentiableAt ℂ (Kf α β t Z) s := by
  have hA : DifferentiableAt ℂ (fun s : ℂ => cexp (s ^ 2) * ((α + β - 2 * s) / (α + β) ^ 2)) s := by
    fun_prop
  have hE : DifferentiableAt ℂ (fun s : ℂ => Ez (1 + α + β + 2 * s)) s :=
    (Ez_differentiable _).comp s (by fun_prop)
  unfold Kf
  exact (hA.mul (gY_differentiableAt hα hβ t hs)).mul (hE.mul (hZd s))

theorem Hf_differentiableAt {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (t : ℝ)
    {Z : ℂ → ℂ} (hZd : Differentiable ℂ Z) {s : ℂ} (hs : -(2 / 5) < s.re) (hs0 : s ≠ 0) :
    DifferentiableAt ℂ (Hf α β t Z) s := by
  have hA : DifferentiableAt ℂ (fun s : ℂ => cexp (s ^ 2) * ((α + β - 2 * s) / (α + β) ^ 2)) s := by
    fun_prop
  have hE : DifferentiableAt ℂ (fun s : ℂ => Ez (1 + α + β + 2 * s)) s :=
    (Ez_differentiable _).comp s (by fun_prop)
  unfold Hf
  exact ((hA.div differentiableAt_id hs0).mul (gY_differentiableAt hα hβ t hs)).mul
    (hE.mul (hZd s))

/-- The residue at `s = 0`: `ζ(1+α+β) Z(0)` (`G(0) = g(0,t) = 1`). -/
theorem Hf_local {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hαβ : α + β ≠ 0) (t : ℝ)
    {Z : ℂ → ℂ} (hZd : Differentiable ℂ Z) :
    ∃ h : ℂ → ℂ, AnalyticAt ℂ h 0 ∧ ∀ᶠ s in 𝓝[≠] (0 : ℂ),
      Hf α β t Z s = h s + riemannZeta (1 + α + β) * Z 0 / (s - 0) := by
  have ra := re_small' hα
  have rb := re_small' hβ
  set U : Set ℂ := {s : ℂ | -(2 / 5) < s.re} with hU
  have hUo : IsOpen U := isOpen_lt continuous_const Complex.continuous_re
  have hKd : DifferentiableOn ℂ (Kf α β t Z) U := fun s hs =>
    (Kf_differentiableAt hα hβ t hZd hs).differentiableWithinAt
  have hKa : AnalyticAt ℂ (Kf α β t Z) 0 := hKd.analyticAt (hUo.mem_nhds (by simp [hU]))
  have hu : Gammaℝ (uA α t) ≠ 0 := Gammaℝ_ne_zero_of_re_pos (by rw [uA_re]; linarith)
  have hv : Gammaℝ (vB β t) ≠ 0 := Gammaℝ_ne_zero_of_re_pos (by rw [vB_re]; linarith)
  have h1 : 1 + α + β ≠ 1 := by
    intro e
    apply hαβ
    linear_combination e
  refine ApproxShift.local_simple (K := Kf α β t Z) (φ := fun _ => 0) (a := 1) hKa
    analyticAt_const ?_ ?_
  · unfold Kf
    have e0 : (1 : ℂ) + α + β + 2 * 0 = 1 + α + β := by ring
    rw [e0, gY_zero hu hv, Ez_eq h1]
    simp only [mul_zero, sub_zero, ne_eq, OfNat.ofNat_ne_zero, not_false_eq_true, zero_pow,
      Complex.exp_zero, one_mul, mul_one]
    field_simp
    try ring
  · intro s
    unfold Hf Kf
    simp only [sub_zero, zero_add]
    ring

/-- The original integrand on the strip `−1/4 ≤ Re s ≤ 1`, away from `s = 0` and `w = 1`:
`‖K(s,t) ζ(1+α+β+2s) Z(s)‖ ≤ C N (t/2π)^σ K_Z e^(−y²/4)`. -/
theorem orig_bound : ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t →
    ∀ (Z : ℂ → ℂ) (KZ : ℝ), ∀ σ y : ℝ, -(1 / 4) ≤ σ → σ ≤ 1 → 1 / 4 ≤ ‖(σ : ℂ) + y * I‖ →
      3 / 10 ≤ ‖1 + α + β + 2 * ((σ : ℂ) + y * I) - 1‖ → ‖Z (σ + y * I)‖ ≤ KZ →
        ‖KY α β t (σ + y * I) * (riemannZeta (1 + α + β + 2 * ((σ : ℂ) + y * I)) *
          Z (σ + y * I))‖ ≤
          C * (1 + 1 / ‖α + β‖ ^ 2) * (t / (2 * Real.pi)) ^ σ * KZ * Real.exp (-(1 / 4) * y ^ 2) := by
  obtain ⟨Ci, hCi0, hCi⟩ := integrand_bound (σ₀ := -(1 / 4)) (σ₁ := 1) (δ := 1 / 4) (by norm_num)
    (by norm_num)
  obtain ⟨Cz, hCz0, hCz⟩ := zeta_bd
  refine ⟨Ci * Cz * Real.exp (1 / 5) * Real.exp 4, by positivity,
    fun α β hα hβ t ht Z KZ σ y h1 h2 h3 h4 hZ => ?_⟩
  have ra := re_small' hα
  have rb := re_small' hβ
  have ia := im_small' hα
  have ib := im_small' hβ
  have hk := hCi α β hα hβ t ht 1 one_pos σ y h1 h2 h3
  have e : (((1 : ℝ) : ℂ)) ^ (-((σ : ℂ) + y * I)) = 1 := by simp
  rw [e, mul_one, Real.one_rpow, mul_one] at hk
  have hre := re_w α β σ y
  have him := im_w α β σ y
  have hz := hCz (1 + α + β + 2 * ((σ : ℂ) + y * I)) (by rw [hre]; linarith) (by rw [hre]; linarith) h4
  rw [him] at hz
  have hi : |α.im + β.im + 2 * y| ≤ 1 / 5 + 2 * |y| := by
    have := abs_add_le (α.im + β.im) (2 * y)
    rw [abs_mul, abs_two] at this
    have : |α.im + β.im| ≤ 1 / 5 := by rw [abs_le]; constructor <;> linarith
    linarith
  have hz' : ‖riemannZeta (1 + α + β + 2 * ((σ : ℂ) + y * I))‖ ≤
      Cz * Real.exp (1 / 5) * Real.exp (2 * |y|) := by
    refine hz.trans ?_
    rw [mul_assoc, ← Real.exp_add]
    exact mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr (by linarith)) hCz0
  have hKZ : 0 ≤ KZ := (norm_nonneg _).trans hZ
  have hg := gauss_exp y
  rw [norm_mul, norm_mul]
  calc ‖KY α β t (σ + y * I)‖ * (‖riemannZeta (1 + α + β + 2 * ((σ : ℂ) + y * I))‖ *
        ‖Z (σ + y * I)‖)
      ≤ (Ci * (1 + 1 / ‖α + β‖ ^ 2) * (t / (2 * Real.pi)) ^ σ * Real.exp (-(1 / 2) * y ^ 2)) *
        ((Cz * Real.exp (1 / 5) * Real.exp (2 * |y|)) * KZ) := by
        refine mul_le_mul ?_ (mul_le_mul hz' hZ (norm_nonneg _) (by positivity)) (by positivity)
          (by positivity)
        have : Ci * (1 + 1 / ‖α + β‖ ^ 2) * ((t / (2 * Real.pi)) ^ σ) * Real.exp (-(1 / 2) * y ^ 2) =
            Ci * (1 + 1 / ‖α + β‖ ^ 2) * (t / (2 * Real.pi)) ^ σ * Real.exp (-(1 / 2) * y ^ 2) := rfl
        linarith [hk]
    _ = Ci * Cz * Real.exp (1 / 5) * (1 + 1 / ‖α + β‖ ^ 2) * (t / (2 * Real.pi)) ^ σ * KZ *
        (Real.exp (-(1 / 2) * y ^ 2) * Real.exp (2 * |y|)) := by ring
    _ ≤ Ci * Cz * Real.exp (1 / 5) * (1 + 1 / ‖α + β‖ ^ 2) * (t / (2 * Real.pi)) ^ σ * KZ *
        (Real.exp 4 * Real.exp (-(1 / 4) * y ^ 2)) :=
        mul_le_mul_of_nonneg_left hg (by positivity)
    _ = _ := by ring

/-- `e^(−y²/4) → 0` as `y → ±∞`. -/
theorem gauss4_atTop : Tendsto (fun y : ℝ => Real.exp (-(1 / 4) * y ^ 2)) atTop (𝓝 0) :=
  Real.tendsto_exp_atBot.comp
    ((tendsto_pow_atTop two_ne_zero).const_mul_atTop_of_neg (by norm_num))

theorem gauss4_atBot : Tendsto (fun y : ℝ => Real.exp (-(1 / 4) * y ^ 2)) atBot (𝓝 0) :=
  (gauss4_atTop.comp tendsto_neg_atBot_atTop).congr fun y => by simp

/-- **(b), per `t`: the shift.** For `t ≥ 1`, `α + β ≠ 0`, `Z` entire and bounded on the strip
`−1/4 ≤ Re s ≤ 1`: `(1/2πi)∫_(1) K(s,t) ζ(1+α+β+2s) Z(s) ds = ζ(1+α+β) Z(0) +
(1/2πi)∫_(−1/4) K(s,t) ζ(1+α+β+2s) Z(s) ds`. The pole of `ζ(1+α+β+2s)` at `s = −(α+β)/2` is
cancelled by the zero of `p(s)` (`Hf`), so only `s = 0` contributes. -/
theorem shift_t {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hαβ : α + β ≠ 0) {t : ℝ}
    (ht : 1 ≤ t) {Z : ℂ → ℂ} (hZd : Differentiable ℂ Z) {KZ : ℝ}
    (hZb : ∀ σ y : ℝ, -(1 / 4) ≤ σ → σ ≤ 1 → ‖Z (σ + y * I)‖ ≤ KZ) :
    VerticalIntegral' (fun s => KY α β t s * (riemannZeta (1 + α + β + 2 * s) * Z s)) 1 =
      riemannZeta (1 + α + β) * Z 0 +
        VerticalIntegral' (fun s => KY α β t s * (riemannZeta (1 + α + β + 2 * s) * Z s))
          (-(1 / 4)) := by
  obtain ⟨C, hC0, hC⟩ := orig_bound
  have ra := re_small' hα
  have rb := re_small' hβ
  have ia := im_small' hα
  have ib := im_small' hβ
  have hKZ : 0 ≤ KZ := (norm_nonneg _).trans (hZb 1 0 (by norm_num) le_rfl)
  set f : ℂ → ℂ := Hf α β t Z with hf
  set og : ℂ → ℂ := fun s => KY α β t s * (riemannZeta (1 + α + β + 2 * s) * Z s) with hog
  have hb0 : 0 < t / (2 * Real.pi) := div_pos (by linarith) (by positivity)
  set H : ℝ := C * (1 + 1 / ‖α + β‖ ^ 2) *
    ((t / (2 * Real.pi)) ^ (-(1 / 4) : ℝ) + (t / (2 * Real.pi)) ^ (1 : ℝ)) * KZ with hH
  have hH0 : 0 ≤ H := by positivity
  -- where `f` and the original integrand agree
  have hagree : ∀ σ y : ℝ, (α.re + β.re + 2 * σ ≠ 0 ∨ 1 ≤ |y|) →
      f (σ + y * I) = og (σ + y * I) := by
    intro σ y hσy
    have hw : 1 + α + β + 2 * ((σ : ℂ) + y * I) ≠ 1 := by
      rcases hσy with h | h
      · exact w_ne_one h
      · intro e
        have := congrArg Complex.im e
        rw [im_w] at this
        simp at this
        have : |y| ≤ 1 / 10 := by rw [abs_le]; constructor <;> linarith
        linarith
    simp only [hf, hog]
    exact Hf_eq α β t Z hw
  -- the bound on the strip, on the lines and for `|y| ≥ 1`
  have hbnd : ∀ σ y : ℝ, -(1 / 4) ≤ σ → σ ≤ 1 → (σ = 1 ∨ σ = -(1 / 4) ∨ 1 ≤ |y|) →
      ‖f (σ + y * I)‖ ≤ H * Real.exp (-(1 / 4) * y ^ 2) := by
    intro σ y h1 h2 hc
    have hre := re_w α β σ y
    have him := im_w α β σ y
    have hd1 : (1 + α + β + 2 * ((σ : ℂ) + y * I) - 1).re = α.re + β.re + 2 * σ := by
      rw [Complex.sub_re, hre, Complex.one_re]; ring
    have hd2 : (1 + α + β + 2 * ((σ : ℂ) + y * I) - 1).im = α.im + β.im + 2 * y := by
      rw [Complex.sub_im, him, Complex.one_im]; ring
    have hs1 := Complex.abs_re_le_norm ((σ : ℂ) + y * I)
    have hs2 := Complex.abs_im_le_norm ((σ : ℂ) + y * I)
    have hw1 := Complex.abs_re_le_norm (1 + α + β + 2 * ((σ : ℂ) + y * I) - 1)
    have hw2 := Complex.abs_im_le_norm (1 + α + β + 2 * ((σ : ℂ) + y * I) - 1)
    simp only [Complex.add_re, Complex.ofReal_re, Complex.mul_re, Complex.I_re, Complex.I_im,
      Complex.ofReal_im, Complex.add_im, Complex.mul_im, mul_zero, mul_one, sub_zero, zero_add,
      add_zero] at hs1 hs2
    rw [hd1] at hw1
    rw [hd2] at hw2
    have hcases : (1 / 4 ≤ ‖(σ : ℂ) + y * I‖ ∧
        3 / 10 ≤ ‖1 + α + β + 2 * ((σ : ℂ) + y * I) - 1‖) ∧
        (α.re + β.re + 2 * σ ≠ 0 ∨ 1 ≤ |y|) := by
      rcases hc with h | h | h
      · have hp : 3 / 10 ≤ |α.re + β.re + 2 * σ| := by
          rw [h, abs_of_pos (by linarith)]; linarith
        have hs : 1 / 4 ≤ |σ| := by rw [h]; norm_num
        exact ⟨⟨by linarith, by linarith⟩, Or.inl (by intro e; rw [h] at e; linarith)⟩
      · have hp : 3 / 10 ≤ |α.re + β.re + 2 * σ| := by
          rw [h, abs_of_neg (by linarith)]; linarith
        have hs : 1 / 4 ≤ |σ| := by rw [h]; norm_num
        exact ⟨⟨by linarith, by linarith⟩, Or.inl (by intro e; rw [h] at e; linarith)⟩
      · refine ⟨⟨by linarith, ?_⟩, Or.inr h⟩
        have : 3 / 10 ≤ |α.im + β.im + 2 * y| := by
          rcases le_or_gt 0 y with hy | hy
          · rw [abs_of_nonneg hy] at h
            rw [abs_of_pos (by linarith)]; linarith
          · rw [abs_of_neg hy] at h
            rw [abs_of_neg (by linarith)]; linarith
        linarith
    obtain ⟨⟨hn1, hn2⟩, hag⟩ := hcases
    rw [hagree σ y hag]
    refine (hC α β hα hβ t ht Z KZ σ y h1 h2 hn1 hn2 (hZb σ y h1 h2)).trans ?_
    have hr := rpow_le_ends hb0 h1 h2
    rw [hH]
    have : 0 ≤ Real.exp (-(1 / 4) * y ^ 2) := (Real.exp_pos _).le
    have hN : 0 ≤ C * (1 + 1 / ‖α + β‖ ^ 2) := by positivity
    calc C * (1 + 1 / ‖α + β‖ ^ 2) * (t / (2 * Real.pi)) ^ σ * KZ * Real.exp (-(1 / 4) * y ^ 2)
        = (C * (1 + 1 / ‖α + β‖ ^ 2)) * (t / (2 * Real.pi)) ^ σ * (KZ *
          Real.exp (-(1 / 4) * y ^ 2)) := by ring
      _ ≤ (C * (1 + 1 / ‖α + β‖ ^ 2)) * ((t / (2 * Real.pi)) ^ (-(1 / 4) : ℝ) +
          (t / (2 * Real.pi)) ^ (1 : ℝ)) * (KZ * Real.exp (-(1 / 4) * y ^ 2)) := by
          apply mul_le_mul_of_nonneg_right _ (by positivity)
          exact mul_le_mul_of_nonneg_left hr hN
      _ = _ := by ring
  -- differentiability
  have hfd : ∀ s : ℂ, -(2 / 5) < s.re → s ≠ 0 → DifferentiableAt ℂ f s := fun s hs hs0 =>
    Hf_differentiableAt hα hβ t hZd hs hs0
  -- the two lines
  have hline : ∀ σ : ℝ, (σ = 1 ∨ σ = -(1 / 4)) → Integrable fun y : ℝ => f (↑σ + y * I) := by
    intro σ hσ
    have hσ0 : σ ≠ 0 := by rcases hσ with h | h <;> rw [h] <;> norm_num
    have hσr : -(1 / 4) ≤ σ ∧ σ ≤ 1 := by rcases hσ with h | h <;> rw [h] <;> norm_num
    have hcont : Continuous fun y : ℝ => f (↑σ + y * I) :=
      continuous_iff_continuousAt.mpr fun y => ContinuousAt.comp (g := f)
        (f := fun y : ℝ => (σ : ℂ) + y * I)
        (hfd _ (by simp; linarith) (by
          intro h
          have := congrArg Complex.re h
          simp at this
          exact hσ0 this)).continuousAt (by fun_prop)
    exact Integrable.mono' ((integrable_exp_neg_mul_sq (by norm_num : (0 : ℝ) < 1 / 4)).const_mul H)
      hcont.aestronglyMeasurable (ae_of_all _ fun y => hbnd σ y hσr.1 hσr.2 (by
        rcases hσ with h | h
        · exact Or.inl h
        · exact Or.inr (Or.inl h)))
  -- the horizontal edges
  have hhb : ∀ y : ℝ, 1 ≤ |y| → ‖∫ σ : ℝ in (-(1 / 4))..1, f (σ + y * I)‖ ≤
      H * Real.exp (-(1 / 4) * y ^ 2) * |1 - -(1 / 4)| := by
    intro y hy
    apply intervalIntegral.norm_integral_le_of_norm_le_const
    intro σ hσ
    rw [Set.uIoc_of_le (by norm_num)] at hσ
    exact hbnd σ y hσ.1.le hσ.2 (Or.inr (Or.inr hy))
  have hlim : ∀ l : Filter ℝ, Tendsto (fun y : ℝ => Real.exp (-(1 / 4) * y ^ 2)) l (𝓝 0) →
      Tendsto (fun y : ℝ => H * Real.exp (-(1 / 4) * y ^ 2) * |(1 : ℝ) - -(1 / 4)|) l (𝓝 0) := by
    intro l hl
    simpa using (hl.const_mul H).mul_const |(1 : ℝ) - -(1 / 4)|
  have htop : Tendsto (fun y : ℝ => ∫ σ : ℝ in (-(1 / 4))..1, f (σ + y * I)) atTop (𝓝 0) := by
    refine squeeze_zero_norm' ?_ (hlim _ gauss4_atTop)
    filter_upwards [eventually_ge_atTop 1] with y hy
    exact hhb y (by rw [abs_of_nonneg (by linarith)]; exact hy)
  have hbot : Tendsto (fun y : ℝ => ∫ σ : ℝ in (-(1 / 4))..1, f (σ + y * I)) atBot (𝓝 0) := by
    refine squeeze_zero_norm' ?_ (hlim _ gauss4_atBot)
    filter_upwards [eventually_le_atBot (-1)] with y hy
    exact hhb y (by rw [abs_of_neg (by linarith)]; linarith)
  have hrect := rect_tendsto_ab (a := -(1 / 4)) (b := 1) hbot htop
    (hline (-(1 / 4)) (Or.inr rfl)) (hline 1 (Or.inl rfl))
  -- the residue at `0`
  have hres : ∀ Y : ℝ, 1 ≤ Y →
      RectangleIntegral' f (↑(-(1 / 4 : ℝ)) - I * ↑Y) (↑(1 : ℝ) + I * ↑Y) =
        riemannZeta (1 + α + β) * Z 0 := by
    intro Y hY
    have hmain := ContourShift.residue_rectangle_of_local (f := f) (P := {0})
      (A := fun _ => riemannZeta (1 + α + β) * Z 0)
      (z := ↑(-(1 / 4 : ℝ)) - I * ↑Y) (w := ↑(1 : ℝ) + I * ↑Y)
      (by simp; norm_num) (by simp; linarith)
      (by
        intro p hp
        rw [Finset.mem_singleton] at hp
        subst hp
        rw [rectangle_mem_nhds_iff, Complex.mem_reProdIm]
        simp only [Complex.sub_re, Complex.add_re, Complex.ofReal_re, Complex.mul_re, Complex.I_re,
          Complex.I_im, Complex.ofReal_im, Complex.sub_im, Complex.add_im, Complex.mul_im,
          zero_mul, one_mul, mul_zero, sub_zero, add_zero, zero_add, zero_sub, Complex.zero_re,
          Complex.zero_im]
        rw [Set.uIoo_of_le (by norm_num), Set.uIoo_of_le (by linarith)]
        exact ⟨⟨by norm_num, by norm_num⟩, ⟨by linarith, by linarith⟩⟩)
      (by
        intro s hs
        have hs1 := hs.1
        have hs2 : s ≠ 0 := by simpa using hs.2
        rw [Rectangle, Complex.mem_reProdIm] at hs1
        have hre := hs1.1
        simp only [sub_re, ofReal_re, mul_re, I_re, zero_mul, I_im, ofReal_im, mul_zero,
          sub_self, sub_zero, add_re, add_zero] at hre
        rw [Set.uIcc_of_le (by norm_num)] at hre
        exact (hfd s (by linarith [hre.1]) hs2).differentiableWithinAt)
      (by
        intro p hp
        rw [Finset.mem_singleton] at hp
        subst hp
        exact Hf_local hα hβ hαβ t hZd)
    rw [hmain, Finset.sum_singleton]
  have hlim2 : Tendsto (fun Y : ℝ =>
      RectangleIntegral' f (↑(-(1 / 4 : ℝ)) - I * ↑Y) (↑(1 : ℝ) + I * ↑Y)) atTop
      (𝓝 ((1 / (2 * Real.pi * I)) • (VerticalIntegral f 1 - VerticalIntegral f (-(1 / 4))))) :=
    hrect.const_smul _
  have hlim1 : Tendsto (fun Y : ℝ =>
      RectangleIntegral' f (↑(-(1 / 4 : ℝ)) - I * ↑Y) (↑(1 : ℝ) + I * ↑Y)) atTop
      (𝓝 (riemannZeta (1 + α + β) * Z 0)) :=
    tendsto_const_nhds.congr' (by
      filter_upwards [eventually_ge_atTop 1] with Y hY
      exact (hres Y hY).symm)
  have heq := tendsto_nhds_unique hlim2 hlim1
  -- back to the original integrand on the two lines
  have hl1 : VerticalIntegral f 1 = VerticalIntegral og 1 := by
    simp only [VerticalIntegral]
    congr 2
    funext y
    exact hagree 1 y (Or.inl (by linarith))
  have hl2 : VerticalIntegral f (-(1 / 4)) = VerticalIntegral og (-(1 / 4)) := by
    simp only [VerticalIntegral]
    congr 2
    funext y
    exact hagree (-(1 / 4)) y (Or.inl (by linarith))
  rw [hl1, hl2, smul_sub] at heq
  simp only [VerticalIntegral']
  rw [← heq]
  ring

/-- `ζ(1+α+β+2s)` on the left line `Re s = −1/4`: `‖ζ‖ ≤ C e^(2|y|)`. -/
theorem zeta_left : ∃ Cz : ℝ, 0 ≤ Cz ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ y : ℝ,
    ‖riemannZeta (1 + α + β + 2 * (((-(1 / 4) : ℝ) : ℂ) + y * I))‖ ≤ Cz * Real.exp (2 * |y|) := by
  obtain ⟨Cz, hCz0, hCz⟩ := zeta_bd
  refine ⟨Cz * Real.exp (1 / 5), by positivity, fun α β hα hβ y => ?_⟩
  have ra := re_small' hα
  have rb := re_small' hβ
  have ia := im_small' hα
  have ib := im_small' hβ
  have hre := re_w α β (-(1 / 4)) y
  have him := im_w α β (-(1 / 4)) y
  have hd1 : (1 + α + β + 2 * ((((-(1 / 4) : ℝ)) : ℂ) + y * I) - 1).re =
      α.re + β.re + 2 * (-(1 / 4)) := by
    rw [Complex.sub_re, hre, Complex.one_re]; ring
  have hw1 := Complex.abs_re_le_norm (1 + α + β + 2 * ((((-(1 / 4) : ℝ)) : ℂ) + y * I) - 1)
  rw [hd1, abs_of_neg (by linarith)] at hw1
  have hz := hCz _ (by rw [hre]; linarith) (by rw [hre]; linarith) (by linarith)
  rw [him] at hz
  have hi : |α.im + β.im + 2 * y| ≤ 1 / 5 + 2 * |y| := by
    have := abs_add_le (α.im + β.im) (2 * y)
    rw [abs_mul, abs_two] at this
    have : |α.im + β.im| ≤ 1 / 5 := by rw [abs_le]; constructor <;> linarith
    linarith
  refine hz.trans ?_
  rw [mul_assoc, ← Real.exp_add]
  exact mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr (by linarith)) hCz0

theorem norm_VI_le (f : ℂ → ℂ) (σ : ℝ) :
    ‖VerticalIntegral' f σ‖ ≤ 1 / (2 * Real.pi) * ∫ y : ℝ, ‖f (σ + y * I)‖ := by
  rw [VerticalIntegral', VerticalIntegral, norm_smul, norm_smul, Complex.norm_I, one_mul]
  have h1 : ‖(1 / (2 * Real.pi * I) : ℂ)‖ = 1 / (2 * Real.pi) := by
    rw [norm_div, norm_one, norm_mul, norm_mul, Complex.norm_I, Complex.norm_real,
      Real.norm_eq_abs, abs_of_pos Real.pi_pos]
    norm_num
  rw [h1]
  exact mul_le_mul_of_nonneg_left (norm_integral_le_integral_norm _) (by positivity)

/-- **(b), integrated: the main term and the shifted integral.** For `T ≥ 4`,
`‖α‖, ‖β‖ ≤ 1/10`, `α + β ≠ 0`, any coefficients:
`diagSum = ŵ(0) ζ(1+α+β) S(α,β,0) + ∫ w(t) (1/2πi)∫_(−1/4) G(s)/s g(s,t) ζ(1+α+β+2s) S(α,β,s) ds dt`. -/
theorem diag_shift {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ)
    {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hαβ : α + β ≠ 0) :
    diagSum W M a σ₀ α β 1 =
      (what0 W : ℂ) * (riemannZeta (1 + α + β) * Sdiag M a σ₀ α β 0) +
        ∫ t, (W.w t : ℂ) * VerticalIntegral' (fun s => KY α β t s * Zd M a σ₀ α β s)
          (-(1 / 4)) := by
  have ra := re_small' hα
  have rb := re_small' hβ
  obtain ⟨Cz, hCz0, hCz⟩ := zeta_left
  rw [diag_per_t W hT M a σ₀ hα hβ (by norm_num : (1 : ℝ) / 10 < 1)]
  have hpt : ∀ t, (W.w t : ℂ) * VerticalIntegral' (fun s => KY α β t s * Zd M a σ₀ α β s) 1 =
      (W.w t : ℂ) * (riemannZeta (1 + α + β) * Sdiag M a σ₀ α β 0) +
        (W.w t : ℂ) * VerticalIntegral' (fun s => KY α β t s * Zd M a σ₀ α β s) (-(1 / 4)) := by
    intro t
    by_cases ht : t ∈ Set.Icc (T / 4) (2 * T)
    · rw [← mul_add]
      congr 1
      unfold Zd
      exact shift_t hα hβ hαβ (by linarith [ht.1]) (Sdiag_differentiable M a σ₀ α β)
        (fun σ y h1 _ => Sdiag_norm_le M a σ₀ α β h1 y)
    · rw [(W.zero_out ht).1]
      simp
  simp only [hpt]
  have hi1 : Integrable fun t => (W.w t : ℂ) * (riemannZeta (1 + α + β) * Sdiag M a σ₀ α β 0) :=
    integrable_of_Icc (a := T / 4) (b := 2 * T)
      ((continuous_ofReal.comp W.cont).mul continuous_const).continuousOn
      (fun t ht => by rw [(W.zero_out ht).1]; simp)
  have hi2 := wVI_integrable W hT hα hβ (σ := -(1 / 4)) (by norm_num) (by norm_num)
    (Zd_cont M a σ₀ (α := α) (β := β) (σ := -(1 / 4)) (by intro e; linarith))
    (K := Cz * SB M a σ₀ α β (-(1 / 4))) (fun y => by
      unfold Zd
      rw [norm_mul]
      calc ‖riemannZeta (1 + α + β + 2 * ((((-(1 / 4) : ℝ)) : ℂ) + y * I))‖ *
            ‖Sdiag M a σ₀ α β (((-(1 / 4) : ℝ) : ℂ) + y * I)‖
          ≤ (Cz * Real.exp (2 * |y|)) * SB M a σ₀ α β (-(1 / 4)) :=
            mul_le_mul (hCz α β hα hβ y) (Sdiag_norm_le M a σ₀ α β le_rfl y) (norm_nonneg _)
              (by positivity)
        _ = Cz * SB M a σ₀ α β (-(1 / 4)) * Real.exp (2 * |y|) := by ring)
  rw [integral_add hi1 hi2, integral_mul_const, integral_complex_ofReal]
  rfl

/-- **(b), the size of the shifted integral**: `‖∫ w (1/2πi)∫_(−1/4) …‖ ≤
K₀ N T (T/8π)^(−1/4) SB(−1/4)`, `K₀` absolute. -/
theorem shifted_bound : ∃ K0 : ℝ, 0 ≤ K0 ∧ ∀ (T L : ℝ) (W : Weight T L), 4 ≤ T →
    ∀ (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ) (α β : ℂ), ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 →
      ‖∫ t, (W.w t : ℂ) * VerticalIntegral' (fun s => KY α β t s * Zd M a σ₀ α β s) (-(1 / 4))‖ ≤
        K0 * (1 + 1 / ‖α + β‖ ^ 2) * T * (T / (8 * Real.pi)) ^ (-(1 / 4) : ℝ) *
          SB M a σ₀ α β (-(1 / 4)) := by
  obtain ⟨C, hC0, hC⟩ := KY_bd (σ := -(1 / 4)) (by norm_num) (by norm_num)
  obtain ⟨Cz, hCz0, hCz⟩ := zeta_left
  refine ⟨2 * (1 / (2 * Real.pi) * (C * Cz * Real.exp 4 * Real.sqrt (Real.pi / (1 / 4)))),
    by positivity, fun T L W hT M a σ₀ α β hα hβ => ?_⟩
  have hT0 : 0 < T := by linarith
  set N : ℝ := 1 + 1 / ‖α + β‖ ^ 2 with hN
  set S : ℝ := SB M a σ₀ α β (-(1 / 4)) with hS
  have hS0 : 0 ≤ S := SB_nonneg M a σ₀ α β _
  set P : ℝ := (T / (8 * Real.pi)) ^ (-(1 / 4) : ℝ) with hP
  have hP0 : 0 ≤ P := by positivity
  set B : ℝ := 1 / (2 * Real.pi) * (C * Cz * Real.exp 4 * Real.sqrt (Real.pi / (1 / 4))) * N * P * S
    with hB
  have hpt : ∀ t ∈ Set.Icc (T / 4) (2 * T), ‖(W.w t : ℂ) *
      VerticalIntegral' (fun s => KY α β t s * Zd M a σ₀ α β s) (-(1 / 4))‖ ≤ B := by
    intro t ht
    have ht1 : 1 ≤ t := by linarith [ht.1]
    have hw : ‖(W.w t : ℂ)‖ ≤ 1 := by rw [Complex.norm_real, Real.norm_eq_abs]; exact W.abs_le_one t
    have hr : (t / (2 * Real.pi)) ^ (-(1 / 4) : ℝ) ≤ P := by
      rw [hP]
      apply Real.rpow_le_rpow_of_nonpos (by positivity) _ (by norm_num)
      rw [div_le_div_iff₀ (by positivity) (by positivity)]
      nlinarith [ht.1, Real.pi_pos]
    have hint : ∀ y : ℝ, ‖KY α β t (((-(1 / 4) : ℝ) : ℂ) + y * I) *
        Zd M a σ₀ α β (((-(1 / 4) : ℝ) : ℂ) + y * I)‖ ≤
        (C * Cz * Real.exp 4 * N * P * S) * Real.exp (-(1 / 4) * y ^ 2) := by
      intro y
      have hk := hC α β hα hβ t ht1 y
      have hz := hCz α β hα hβ y
      have hs := Sdiag_norm_le M a σ₀ α β (le_refl (-(1 / 4) : ℝ)) y
      have hg := gauss_exp y
      unfold Zd
      rw [norm_mul, norm_mul]
      have hk' : ‖KY α β t (((-(1 / 4) : ℝ) : ℂ) + y * I)‖ ≤
          C * N * P * Real.exp (-(1 / 2) * y ^ 2) := by
        refine hk.trans (mul_le_mul_of_nonneg_right ?_ (Real.exp_pos _).le)
        exact mul_le_mul_of_nonneg_left hr (by positivity)
      calc ‖KY α β t (((-(1 / 4) : ℝ) : ℂ) + y * I)‖ *
            (‖riemannZeta (1 + α + β + 2 * ((((-(1 / 4) : ℝ)) : ℂ) + y * I))‖ *
              ‖Sdiag M a σ₀ α β (((-(1 / 4) : ℝ) : ℂ) + y * I)‖)
          ≤ (C * N * P * Real.exp (-(1 / 2) * y ^ 2)) * ((Cz * Real.exp (2 * |y|)) * S) :=
            mul_le_mul hk' (mul_le_mul hz hs (norm_nonneg _) (by positivity)) (by positivity)
              (by positivity)
        _ = C * Cz * N * P * S * (Real.exp (-(1 / 2) * y ^ 2) * Real.exp (2 * |y|)) := by ring
        _ ≤ C * Cz * N * P * S * (Real.exp 4 * Real.exp (-(1 / 4) * y ^ 2)) :=
            mul_le_mul_of_nonneg_left hg (by positivity)
        _ = _ := by ring
    have hgi : Integrable fun y : ℝ => (C * Cz * Real.exp 4 * N * P * S) *
        Real.exp (-(1 / 4) * y ^ 2) :=
      (integrable_exp_neg_mul_sq (by norm_num : (0 : ℝ) < 1 / 4)).const_mul _
    have hle : ∫ y : ℝ, ‖KY α β t (((-(1 / 4) : ℝ) : ℂ) + y * I) *
        Zd M a σ₀ α β (((-(1 / 4) : ℝ) : ℂ) + y * I)‖ ≤
        (C * Cz * Real.exp 4 * N * P * S) * Real.sqrt (Real.pi / (1 / 4)) := by
      have := integral_mono_of_nonneg (ae_of_all _ fun y => norm_nonneg _) hgi (ae_of_all _ hint)
      rwa [integral_const_mul, integral_gaussian] at this
    have hv := norm_VI_le (fun s => KY α β t s * Zd M a σ₀ α β s) (-(1 / 4))
    rw [norm_mul]
    calc ‖(W.w t : ℂ)‖ * ‖VerticalIntegral' (fun s => KY α β t s * Zd M a σ₀ α β s) (-(1 / 4))‖
        ≤ 1 * (1 / (2 * Real.pi) * ((C * Cz * Real.exp 4 * N * P * S) *
            Real.sqrt (Real.pi / (1 / 4)))) :=
          mul_le_mul hw (hv.trans (mul_le_mul_of_nonneg_left hle (by positivity))) (norm_nonneg _)
            zero_le_one
      _ = B := by rw [hB]; ring
  have h := norm_integral_le_Icc (a := T / 4) (b := 2 * T) (K := B) (by linarith)
    (fun t ht => by rw [(W.zero_out ht).1]; simp) hpt
  have hB0 : 0 ≤ B := by positivity
  calc _ ≤ B * (2 * T - T / 4) := h
    _ ≤ B * (2 * T) := mul_le_mul_of_nonneg_left (by linarith) hB0
    _ = _ := by rw [hB]; ring

/-! ## Part (b): the size of `S` on `Re s = −1/4` for Young's mollifier -/

/-- Young's coefficients with the `h^(−1/2)` kept: `‖a_h‖ h^(−σ₀) ≤ B h^(−1/2)`,
`B = sup_{[0,1]} |P|`. -/
theorem aY_bound' (P : Polynomial ℝ) : ∃ B : ℝ, 0 ≤ B ∧ ∀ (T θ R : ℝ) (h : ℕ), 1 ≤ h →
    h ≤ Mof T θ → ‖aY P T θ R h‖ * (h : ℝ) ^ (-sig0 T R) ≤ B * (h : ℝ) ^ (-(1 / 2) : ℝ) := by
  obtain ⟨C, hC⟩ := (isCompact_Icc (a := (0 : ℝ)) (b := 1)).exists_bound_of_continuousOn
    (P.continuous (R := ℝ)).continuousOn
  refine ⟨max C 0, le_max_right _ _, fun T θ R h hh hhM => ?_⟩
  set Mr : ℝ := (Mof T θ : ℝ) with hMr
  have hh0 : (0 : ℝ) < h := by exact_mod_cast hh
  have hh1 : (1 : ℝ) ≤ h := by exact_mod_cast hh
  have hhM' : (h : ℝ) ≤ Mr := by rw [hMr]; exact_mod_cast hhM
  have hM1 : 1 ≤ Mr := hh1.trans hhM'
  set u : ℝ := Real.log (Mr / h) / Real.log Mr with hu
  have hu0 : 0 ≤ u := div_nonneg (Real.log_nonneg ((one_le_div hh0).mpr hhM'))
    (Real.log_nonneg hM1)
  have hu1 : u ≤ 1 := div_le_one_of_le₀
    (Real.log_le_log (div_pos (by linarith) hh0) (div_le_self (by linarith) hh1))
    (Real.log_nonneg hM1)
  have hPu : |P.eval u| ≤ max C 0 := by
    have := hC u ⟨hu0, hu1⟩
    rw [Real.norm_eq_abs] at this
    exact this.trans (le_max_left _ _)
  have hpow : 0 < (h : ℝ) ^ (sig0 T R - 1 / 2) := Real.rpow_pos_of_pos hh0 _
  have hμ : |((ArithmeticFunction.moebius h : ℤ) : ℝ)| ≤ 1 := by
    exact_mod_cast ArithmeticFunction.abs_moebius_le_one
  have hnorm : ‖aY P T θ R h‖ = |((ArithmeticFunction.moebius h : ℤ) : ℝ)| * |P.eval u| *
      (h : ℝ) ^ (sig0 T R - 1 / 2) := by
    unfold aY
    rw [norm_mul, norm_mul, Complex.norm_real, Complex.norm_real, Real.norm_eq_abs,
      Real.norm_eq_abs, abs_of_pos hpow, ← hMr, ← hu]
    congr 2
    rw [Complex.norm_intCast]
  have hcomb : (h : ℝ) ^ (sig0 T R - 1 / 2) * (h : ℝ) ^ (-sig0 T R) = (h : ℝ) ^ (-(1 / 2) : ℝ) := by
    rw [← Real.rpow_add hh0]
    congr 1
    ring
  rw [hnorm]
  have hB0 : 0 ≤ max C 0 := le_max_right _ _
  calc |((ArithmeticFunction.moebius h : ℤ) : ℝ)| * |P.eval u| * (h : ℝ) ^ (sig0 T R - 1 / 2) *
        (h : ℝ) ^ (-sig0 T R) =
      (|((ArithmeticFunction.moebius h : ℤ) : ℝ)| * |P.eval u|) * (h : ℝ) ^ (-(1 / 2) : ℝ) := by
        rw [← hcomb]; ring
    _ ≤ (1 * max C 0) * (h : ℝ) ^ (-(1 / 2) : ℝ) :=
        mul_le_mul_of_nonneg_right (mul_le_mul hμ hPu (abs_nonneg _) zero_le_one) (by positivity)
    _ = max C 0 * (h : ℝ) ^ (-(1 / 2) : ℝ) := by ring

theorem Chk_norm (a : ℕ → ℂ) (σ₀ : ℝ) {h k : ℕ} (hh : 1 ≤ h) (hk : 1 ≤ k) :
    ‖Chk a σ₀ h k‖ = (‖a h‖ * (h : ℝ) ^ (-σ₀)) * (‖a k‖ * (k : ℝ) ^ (-σ₀)) := by
  unfold Chk
  rw [norm_mul, norm_mul, norm_mul, Complex.norm_conj, norm_cpow_nat hh, norm_cpow_nat hk]
  simp only [Complex.neg_re, Complex.ofReal_re]
  ring

/-- `j^(−(1/2+x−1/4)) ≤ e^(κ/2) j^(−1/4)` for `1 ≤ j ≤ M ≤ T^θ`, `θ < 1/2`, `|x| ≤ κ/log T`. -/
theorem pow_shift_le {T θ κ x : ℝ} (hT : 1 < T) (hθ : θ < 1 / 2) {j M : ℕ} (hj : 1 ≤ j)
    (hjM : j ≤ M) (hM : (M : ℝ) ≤ T ^ θ) (hx : |x| ≤ κ / Real.log T) :
    (j : ℝ) ^ (-(1 / 2 + x + -(1 / 4))) ≤ Real.exp (κ / 2) * (j : ℝ) ^ (-(1 / 4) : ℝ) := by
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
  have h3 : θ * Real.log T * |x| ≤ 1 / 2 * (|x| * Real.log T) := by
    have := mul_le_mul_of_nonneg_right hθ.le (mul_nonneg hL.le (abs_nonneg x))
    linarith
  linarith

theorem harm_le (M : ℕ) : ∑ j ∈ Finset.Icc 1 M, ((j : ℝ))⁻¹ ≤ 1 + Real.log M := by
  have := harmonic_le_one_add_log M
  rw [harmonic_eq_sum_Icc] at this
  push_cast at this
  exact this

theorem sum34_le (M : ℕ) :
    ∑ j ∈ Finset.Icc 1 M, (j : ℝ) ^ (-(3 / 4) : ℝ) ≤ (M : ℝ) ^ (1 / 4 : ℝ) * (1 + Real.log M) := by
  calc ∑ j ∈ Finset.Icc 1 M, (j : ℝ) ^ (-(3 / 4) : ℝ)
      ≤ ∑ j ∈ Finset.Icc 1 M, (M : ℝ) ^ (1 / 4 : ℝ) * ((j : ℝ))⁻¹ := by
        refine Finset.sum_le_sum fun j hj => ?_
        have hj1 := (Finset.mem_Icc.mp hj).1
        have hjM := (Finset.mem_Icc.mp hj).2
        have hj0 : (0 : ℝ) < j := by exact_mod_cast hj1
        have e : (j : ℝ) ^ (-(3 / 4) : ℝ) = (j : ℝ) ^ (1 / 4 : ℝ) * ((j : ℝ))⁻¹ := by
          rw [← Real.rpow_neg_one, ← Real.rpow_add hj0]
          norm_num
        rw [e]
        exact mul_le_mul_of_nonneg_right (Real.rpow_le_rpow hj0.le (by exact_mod_cast hjM)
          (by norm_num)) (by positivity)
    _ = (M : ℝ) ^ (1 / 4 : ℝ) * ∑ j ∈ Finset.Icc 1 M, ((j : ℝ))⁻¹ := by rw [Finset.mul_sum]
    _ ≤ (M : ℝ) ^ (1 / 4 : ℝ) * (1 + Real.log M) :=
        mul_le_mul_of_nonneg_left (harm_le M) (by positivity)

/-- One term through `d = (h,k)`: `h^(−1/2) k^(−1/2) k'^(−1/4) h'^(−1/4) = d^(−1) h'^(−3/4) k'^(−3/4)`. -/
theorem gcd_term {h k : ℕ} (hh : 1 ≤ h) (hk : 1 ≤ k) :
    (h : ℝ) ^ (-(1 / 2) : ℝ) * (k : ℝ) ^ (-(1 / 2) : ℝ) *
        (((k / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 4) : ℝ) * ((h / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 4) : ℝ)) =
      ((Nat.gcd h k : ℕ) : ℝ)⁻¹ * (((h / Nat.gcd h k : ℕ) : ℝ) ^ (-(3 / 4) : ℝ) *
        ((k / Nat.gcd h k : ℕ) : ℝ) ^ (-(3 / 4) : ℝ)) := by
  obtain ⟨hd, eh, ek, h1, k1, -, -⟩ := gcd_facts hh hk
  have hd0 : (0 : ℝ) < ((Nat.gcd h k : ℕ) : ℝ) := by exact_mod_cast hd
  have hh0 : (0 : ℝ) < ((h / Nat.gcd h k : ℕ) : ℝ) := by exact_mod_cast h1
  have hk0 : (0 : ℝ) < ((k / Nat.gcd h k : ℕ) : ℝ) := by exact_mod_cast k1
  have ehr : (h : ℝ) = ((Nat.gcd h k : ℕ) : ℝ) * ((h / Nat.gcd h k : ℕ) : ℝ) := by
    rw [← Nat.cast_mul, ← eh]
  have ekr : (k : ℝ) = ((Nat.gcd h k : ℕ) : ℝ) * ((k / Nat.gcd h k : ℕ) : ℝ) := by
    rw [← Nat.cast_mul, ← ek]
  rw [ehr, ekr, Real.mul_rpow hd0.le hh0.le, Real.mul_rpow hd0.le hk0.le]
  have e3 : ((Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 2) : ℝ) * ((Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 2) : ℝ) =
      ((Nat.gcd h k : ℕ) : ℝ)⁻¹ := by
    rw [← Real.rpow_add hd0, ← Real.rpow_neg_one]
    norm_num
  have e4 : ((h / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 2) : ℝ) * ((h / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 4) : ℝ) =
      ((h / Nat.gcd h k : ℕ) : ℝ) ^ (-(3 / 4) : ℝ) := by
    rw [← Real.rpow_add hh0]
    norm_num
  have e5 : ((k / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 2) : ℝ) * ((k / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 4) : ℝ) =
      ((k / Nat.gcd h k : ℕ) : ℝ) ^ (-(3 / 4) : ℝ) := by
    rw [← Real.rpow_add hk0]
    norm_num
  rw [← e3, ← e4, ← e5]
  ring

/-- **The gcd sum**: `Σ_{h,k ≤ M} h^(−1/2) k^(−1/2) k'^(−1/4) h'^(−1/4) ≤ M^(1/2) (1 + log M)³`,
from `(h,k) ↦ (d, h', k')` injective. -/
theorem gcd_sum (M : ℕ) :
    ∑ h ∈ Finset.Icc 1 M, ∑ k ∈ Finset.Icc 1 M, (h : ℝ) ^ (-(1 / 2) : ℝ) * (k : ℝ) ^ (-(1 / 2) : ℝ) *
        (((k / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 4) : ℝ) * ((h / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 4) : ℝ)) ≤
      (M : ℝ) ^ (1 / 2 : ℝ) * (1 + Real.log M) ^ 3 := by
  classical
  set A : Finset ℕ := Finset.Icc 1 M with hA
  set g3 : ℕ × ℕ × ℕ → ℝ := fun x =>
    ((x.1 : ℕ) : ℝ)⁻¹ * (((x.2.1 : ℕ) : ℝ) ^ (-(3 / 4) : ℝ) * ((x.2.2 : ℕ) : ℝ) ^ (-(3 / 4) : ℝ))
    with hg3
  set φ : ℕ × ℕ → ℕ × ℕ × ℕ := fun p =>
    (Nat.gcd p.1 p.2, p.1 / Nat.gcd p.1 p.2, p.2 / Nat.gcd p.1 p.2) with hφ
  have hstep1 : ∑ h ∈ A, ∑ k ∈ A, (h : ℝ) ^ (-(1 / 2) : ℝ) * (k : ℝ) ^ (-(1 / 2) : ℝ) *
        (((k / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 4) : ℝ) * ((h / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 4) : ℝ)) =
      ∑ p ∈ A ×ˢ A, g3 (φ p) := by
    rw [Finset.sum_product]
    refine Finset.sum_congr rfl fun h hh => Finset.sum_congr rfl fun k hk => ?_
    simp only [hg3, hφ]
    exact gcd_term (Finset.mem_Icc.mp hh).1 (Finset.mem_Icc.mp hk).1
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
      ((∑ j ∈ A, ((j : ℕ) : ℝ) ^ (-(3 / 4) : ℝ)) * (∑ j ∈ A, ((j : ℕ) : ℝ) ^ (-(3 / 4) : ℝ))) := by
    rw [Finset.sum_product, Finset.sum_mul]
    refine Finset.sum_congr rfl fun d _ => ?_
    rw [Finset.sum_product, Finset.sum_mul_sum, Finset.mul_sum]
    refine Finset.sum_congr rfl fun j _ => ?_
    rw [Finset.mul_sum]
  have hM0 : (0 : ℝ) ≤ M := M.cast_nonneg
  have hlog0 : 0 ≤ 1 + Real.log M := by
    rcases Nat.eq_zero_or_pos M with h0 | h0
    · rw [h0]; simp
    · have : (1 : ℝ) ≤ M := by exact_mod_cast h0
      linarith [Real.log_nonneg this]
  have h34 := sum34_le M
  have hsq : (M : ℝ) ^ (1 / 4 : ℝ) * (M : ℝ) ^ (1 / 4 : ℝ) = (M : ℝ) ^ (1 / 2 : ℝ) := by
    rw [← Real.rpow_add' hM0 (by norm_num)]
    norm_num
  rw [hstep1, ← Finset.sum_image hinj]
  calc ∑ x ∈ (A ×ˢ A).image φ, g3 x ≤ ∑ x ∈ A ×ˢ (A ×ˢ A), g3 x :=
        Finset.sum_le_sum_of_subset_of_nonneg hsub fun x _ _ => hg0 x
    _ = _ := hprod
    _ ≤ (1 + Real.log M) * (((M : ℝ) ^ (1 / 4 : ℝ) * (1 + Real.log M)) *
          ((M : ℝ) ^ (1 / 4 : ℝ) * (1 + Real.log M))) := by
        apply mul_le_mul (harm_le M) (mul_le_mul h34 h34 (Finset.sum_nonneg fun j _ => by positivity)
          (by positivity)) (by positivity) hlog0
    _ = ((M : ℝ) ^ (1 / 4 : ℝ) * (M : ℝ) ^ (1 / 4 : ℝ)) * (1 + Real.log M) ^ 3 := by ring
    _ = _ := by rw [hsq]

/-- **`S` on `Re s = −1/4` for Young's mollifier**: `SB(−1/4) ≤ B² e^κ M^(1/2) (1 + log M)³`
for `‖α‖, ‖β‖ ≤ κ/log T`, `θ < 1/2`, `M = ⌊T^θ⌋`. -/
theorem SB_young (P : Polynomial ℝ) : ∃ B : ℝ, 0 ≤ B ∧ ∀ (T θ R κ : ℝ), 1 < T → θ < 1 / 2 →
    ∀ α β : ℂ, ‖α‖ ≤ κ / Real.log T → ‖β‖ ≤ κ / Real.log T →
      SB (Mof T θ) (aY P T θ R) (sig0 T R) α β (-(1 / 4)) ≤
        B ^ 2 * Real.exp κ * (((Mof T θ : ℕ) : ℝ) ^ (1 / 2 : ℝ) *
          (1 + Real.log ((Mof T θ : ℕ) : ℝ)) ^ 3) := by
  obtain ⟨B, hB0, hB⟩ := aY_bound' P
  refine ⟨B, hB0, fun T θ R κ hT hθ α β hα hβ => ?_⟩
  have hM : ((Mof T θ : ℕ) : ℝ) ≤ T ^ θ := Nat.floor_le (by positivity)
  have hxa : |α.re| ≤ κ / Real.log T := (Complex.abs_re_le_norm α).trans hα
  have hxb : |β.re| ≤ κ / Real.log T := (Complex.abs_re_le_norm β).trans hβ
  have he : Real.exp κ = Real.exp (κ / 2) * Real.exp (κ / 2) := by
    rw [← Real.exp_add]
    ring_nf
  calc SB (Mof T θ) (aY P T θ R) (sig0 T R) α β (-(1 / 4))
      ≤ ∑ h ∈ Finset.Icc 1 (Mof T θ), ∑ k ∈ Finset.Icc 1 (Mof T θ), B ^ 2 * Real.exp κ *
          ((h : ℝ) ^ (-(1 / 2) : ℝ) * (k : ℝ) ^ (-(1 / 2) : ℝ) *
            (((k / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 4) : ℝ) *
              ((h / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 4) : ℝ))) := by
        unfold SB
        refine Finset.sum_le_sum fun h hh => Finset.sum_le_sum fun k hk => ?_
        have hh1 := (Finset.mem_Icc.mp hh).1
        have hhM := (Finset.mem_Icc.mp hh).2
        have hk1 := (Finset.mem_Icc.mp hk).1
        have hkM := (Finset.mem_Icc.mp hk).2
        obtain ⟨-, -, -, h1, k1, h2, k2⟩ := gcd_facts hh1 hk1
        rw [Chk_norm _ _ hh1 hk1]
        have ea := hB T θ R h hh1 hhM
        have eb := hB T θ R k hk1 hkM
        have pa := pow_shift_le hT hθ k1 (k2.trans hkM) hM hxa
        have pb := pow_shift_le hT hθ h1 (h2.trans hhM) hM hxb
        calc ‖aY P T θ R h‖ * (h : ℝ) ^ (-sig0 T R) * (‖aY P T θ R k‖ * (k : ℝ) ^ (-sig0 T R)) *
              (((k / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 2 + α.re + -(1 / 4))) *
                ((h / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 2 + β.re + -(1 / 4))))
            ≤ (B * (h : ℝ) ^ (-(1 / 2) : ℝ)) * (B * (k : ℝ) ^ (-(1 / 2) : ℝ)) *
              ((Real.exp (κ / 2) * ((k / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 4) : ℝ)) *
                (Real.exp (κ / 2) * ((h / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 4) : ℝ))) :=
              mul_le_mul (mul_le_mul ea eb (by positivity) (by positivity))
                (mul_le_mul pa pb (by positivity) (by positivity)) (by positivity) (by positivity)
          _ = _ := by rw [he]; ring
    _ = B ^ 2 * Real.exp κ * ∑ h ∈ Finset.Icc 1 (Mof T θ), ∑ k ∈ Finset.Icc 1 (Mof T θ),
          (h : ℝ) ^ (-(1 / 2) : ℝ) * (k : ℝ) ^ (-(1 / 2) : ℝ) *
            (((k / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 4) : ℝ) *
              ((h / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 4) : ℝ)) := by
        rw [Finset.mul_sum]
        refine Finset.sum_congr rfl fun h _ => ?_
        rw [Finset.mul_sum]
    _ ≤ _ := mul_le_mul_of_nonneg_left (gcd_sum _) (by positivity)

/-- `(log T)^p ≤ ((p+1)/ε)^p T^ε` for `T ≥ 1`, `ε > 0`. -/
theorem logpow_eps (p : ℕ) {ε T : ℝ} (hε : 0 < ε) (hT : 1 ≤ T) :
    Real.log T ^ p ≤ (((p : ℝ) + 1) / ε) ^ p * T ^ ε := by
  set δ : ℝ := ε / ((p : ℝ) + 1) with hδ
  have hδ0 : 0 < δ := by positivity
  have hL := Real.log_le_rpow_div (by linarith : (0 : ℝ) ≤ T) hδ0
  have h1 := pow_le_pow_left₀ (Real.log_nonneg hT) hL p
  have e : T ^ δ / δ = ((p : ℝ) + 1) / ε * T ^ δ := by
    rw [hδ]
    field_simp
    try ring
  rw [e, mul_pow] at h1
  have h2 : (T ^ δ) ^ p ≤ T ^ ε := by
    rw [← Real.rpow_natCast, ← Real.rpow_mul (by linarith)]
    apply Real.rpow_le_rpow_of_exponent_le hT
    rw [hδ, div_mul_eq_mul_div, div_le_iff₀ (by positivity)]
    nlinarith
  exact h1.trans (mul_le_mul_of_nonneg_left h2 (by positivity))

/-- **The size of the shifted term**: for `θ < 1/2` there is `C` with
`(1 + κ²L²) T (T/8π)^(−1/4) M^(1/2) (1 + log M)³ ≤ C T/L` for `T ≥ e`, `M ≤ T^θ`. -/
theorem final_size_diag {θ : ℝ} (hθ : θ < 1 / 2) (κ : ℝ) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ T : ℝ, Real.exp 1 ≤ T → ∀ M : ℕ, (M : ℝ) ≤ T ^ θ →
      (1 + κ ^ 2 * Real.log T ^ 2) * T * (T / (8 * Real.pi)) ^ (-(1 / 4) : ℝ) *
        ((M : ℝ) ^ (1 / 2 : ℝ) * (1 + Real.log M) ^ 3) ≤ C * (T / Real.log T) := by
  set ε : ℝ := 1 / 4 - θ / 2 with hε
  have hε0 : 0 < ε := by rw [hε]; linarith
  set G : ℝ := ((((6 : ℕ) : ℝ) + 1) / ε) ^ 6 with hG
  set X : ℝ := (1 + κ ^ 2) * 8 * (8 * Real.pi) ^ (1 / 4 : ℝ) with hX
  refine ⟨X * G, by positivity, fun T hT M hM => ?_⟩
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
  have hM0 : (0 : ℝ) ≤ M := M.cast_nonneg
  have hMh : (M : ℝ) ^ (1 / 2 : ℝ) ≤ T ^ (θ / 2) := by
    calc (M : ℝ) ^ (1 / 2 : ℝ) ≤ (T ^ θ) ^ (1 / 2 : ℝ) := Real.rpow_le_rpow hM0 hM (by norm_num)
      _ = T ^ (θ / 2) := by rw [← Real.rpow_mul hT0.le]; ring_nf
  have hlogM : 0 ≤ 1 + Real.log M ∧ 1 + Real.log M ≤ 2 * L := by
    rcases Nat.eq_zero_or_pos M with h0 | h0
    · rw [h0]
      simp
      linarith
    · have hM1 : (1 : ℝ) ≤ M := by exact_mod_cast h0
      have hMT : (M : ℝ) ≤ T := hM.trans (by
        calc T ^ θ ≤ T ^ (1 : ℝ) := Real.rpow_le_rpow_of_exponent_le hT1 (by linarith)
          _ = T := Real.rpow_one T)
      have := Real.log_le_log (by linarith) hMT
      have := Real.log_nonneg hM1
      constructor <;> linarith
  have hlog3 : (1 + Real.log M) ^ 3 ≤ 8 * L ^ 3 := by
    have := pow_le_pow_left₀ hlogM.1 hlogM.2 3
    nlinarith
  have hL6 := logpow_eps 6 hε0 hT1
  rw [← hLd, ← hG] at hL6
  have hQ : T ^ ε * (T ^ (3 / 4 : ℝ) * T ^ (θ / 2)) = T := by
    rw [← Real.rpow_add hT0, ← Real.rpow_add hT0, show ε + (3 / 4 + θ / 2) = 1 by rw [hε]; ring,
      Real.rpow_one]
  have hstep : (1 + κ ^ 2 * L ^ 2) * T * (T / (8 * Real.pi)) ^ (-(1 / 4) : ℝ) *
      ((M : ℝ) ^ (1 / 2 : ℝ) * (1 + Real.log M) ^ 3) ≤
      X * L ^ 5 * (T ^ (3 / 4 : ℝ) * T ^ (θ / 2)) := by
    rw [mul_assoc (1 + κ ^ 2 * L ^ 2) T, hP]
    calc (1 + κ ^ 2 * L ^ 2) * ((8 * Real.pi) ^ (1 / 4 : ℝ) * T ^ (3 / 4 : ℝ)) *
          ((M : ℝ) ^ (1 / 2 : ℝ) * (1 + Real.log M) ^ 3)
        ≤ ((1 + κ ^ 2) * L ^ 2) * ((8 * Real.pi) ^ (1 / 4 : ℝ) * T ^ (3 / 4 : ℝ)) *
          (T ^ (θ / 2) * (8 * L ^ 3)) := by
          apply mul_le_mul (mul_le_mul_of_nonneg_right hN (by positivity))
            (mul_le_mul hMh hlog3 (by positivity) (by positivity)) (by positivity) (by positivity)
      _ = X * L ^ 5 * (T ^ (3 / 4 : ℝ) * T ^ (θ / 2)) := by rw [hX]; ring
  refine hstep.trans ?_
  rw [mul_div_assoc', le_div_iff₀ hL0]
  calc X * L ^ 5 * (T ^ (3 / 4 : ℝ) * T ^ (θ / 2)) * L =
        X * L ^ 6 * (T ^ (3 / 4 : ℝ) * T ^ (θ / 2)) := by ring
    _ ≤ X * (G * T ^ ε) * (T ^ (3 / 4 : ℝ) * T ^ (θ / 2)) := by
        apply mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_left hL6 (by positivity))
          (by positivity)
    _ = X * G * (T ^ ε * (T ^ (3 / 4 : ℝ) * T ^ (θ / 2))) := by ring
    _ = X * G * T := by rw [hQ]

/-! ## Part (c): the `h,k`-sum at `s = 0` -/

/-- OPEN, **part (c), the arithmetic core** (Young's Lemma 6 through (6.3), Lemma 7 and §7,
Conrey's lemma): `ζ(1+α+β) S(α,β,0) = c₁(α,β) + O(1/L)` on Lemma 6's range, with Young's
mollifier and `c₁` of (5.3). Route: Young §6, the Mellin formula (6.1) for each power of
`log(M/h)/log M`, the Euler product (6.2) with `A_{0,0}(0,0,0) = 1` (§7), the zero-free region
and `1/ζ` bound of [T] Thm 3.8, (3.11.8) for the shift in `u, v`, and Euler–Maclaurin for the
`n ≤ M` sum (Lemma 7). Budget: `C` depending on `P, θ, R, κ`. -/
noncomputable
def StmtDiagMain (P : Polynomial ℝ) (θ R κ : ℝ) : Prop :=
  ∃ C T₀ : ℝ, 0 ≤ C ∧ ∀ T : ℝ, T₀ ≤ T → ∀ α β : ℂ, Regime κ T α β →
    ‖riemannZeta (1 + α + β) * Sdiag (Mof T θ) (aY P T θ R) (sig0 T R) α β 0 -
      c1Y P (Mof T θ) α β‖ ≤ C / Real.log T

/-- **(a) + (b) for Young's mollifier, unconditional**: for `θ < 1/2`, `κ > 0`,
`diagSum = ŵ(0) ζ(1+α+β) S(α,β,0) + O(T/L)` on Lemma 6's range, every `Weight T (log T)`. -/
theorem diag_young (P : Polynomial ℝ) {θ : ℝ} (hθ : θ < 1 / 2) (R : ℝ) {κ : ℝ} (hκ : 0 < κ) :
    ∃ C T₀ : ℝ, 0 ≤ C ∧ ∀ T : ℝ, T₀ ≤ T → ∀ W : Weight T (Real.log T), ∀ α β : ℂ,
      Regime κ T α β →
        ‖diagSum W (Mof T θ) (aY P T θ R) (sig0 T R) α β 1 - (what0 W : ℂ) *
          (riemannZeta (1 + α + β) * Sdiag (Mof T θ) (aY P T θ R) (sig0 T R) α β 0)‖ ≤
          C * (T / Real.log T) := by
  obtain ⟨K0, hK00, hK0⟩ := shifted_bound
  obtain ⟨B, hB0, hB⟩ := SB_young P
  obtain ⟨C2, hC20, hC2⟩ := final_size_diag hθ κ
  refine ⟨K0 * B ^ 2 * Real.exp κ * C2, max (max 8 (Real.exp 1)) (Real.exp (10 * κ)),
    by positivity, fun T hT W α β hreg => ?_⟩
  have hT8 : 8 ≤ T := le_trans (le_trans (le_max_left _ _) (le_max_left _ _)) hT
  have hTe : Real.exp 1 ≤ T := le_trans (le_trans (le_max_right _ _) (le_max_left _ _)) hT
  have hTk : Real.exp (10 * κ) ≤ T := le_trans (le_max_right _ _) hT
  have hT0 : 0 < T := by linarith
  obtain ⟨hα, hβ, hαβ, hL0⟩ := hreg.small hκ hTk
  have hM : ((Mof T θ : ℕ) : ℝ) ≤ T ^ θ := Nat.floor_le (by positivity)
  rw [diag_shift W (by linarith) _ _ _ hα hβ hαβ, add_sub_cancel_left]
  have hshb := hK0 T (Real.log T) W (by linarith) (Mof T θ) (aY P T θ R) (sig0 T R) α β hα hβ
  have hSB := hB T θ R κ (by linarith) hθ α β hreg.1 hreg.2.1
  have hN := OffDiagClose.N_le hκ hL0 hreg
  have hfin := hC2 T hTe (Mof T θ) hM
  have hPpos : 0 ≤ (T / (8 * Real.pi)) ^ (-(1 / 4) : ℝ) := by positivity
  refine hshb.trans ?_
  calc K0 * (1 + 1 / ‖α + β‖ ^ 2) * T * (T / (8 * Real.pi)) ^ (-(1 / 4) : ℝ) *
        SB (Mof T θ) (aY P T θ R) (sig0 T R) α β (-(1 / 4))
      ≤ K0 * (1 + κ ^ 2 * Real.log T ^ 2) * T * (T / (8 * Real.pi)) ^ (-(1 / 4) : ℝ) *
        (B ^ 2 * Real.exp κ * (((Mof T θ : ℕ) : ℝ) ^ (1 / 2 : ℝ) *
          (1 + Real.log ((Mof T θ : ℕ) : ℝ)) ^ 3)) := by
        apply mul_le_mul _ hSB (SB_nonneg _ _ _ _ _ _) (by positivity)
        apply mul_le_mul_of_nonneg_right _ hPpos
        apply mul_le_mul_of_nonneg_right _ hT0.le
        exact mul_le_mul_of_nonneg_left hN hK00
    _ = K0 * B ^ 2 * Real.exp κ * ((1 + κ ^ 2 * Real.log T ^ 2) * T *
          (T / (8 * Real.pi)) ^ (-(1 / 4) : ℝ) * (((Mof T θ : ℕ) : ℝ) ^ (1 / 2 : ℝ) *
            (1 + Real.log ((Mof T θ : ℕ) : ℝ)) ^ 3)) := by ring
    _ ≤ K0 * B ^ 2 * Real.exp κ * (C2 * (T / Real.log T)) :=
        mul_le_mul_of_nonneg_left hfin (by positivity)
    _ = _ := by ring

/-- **`StmtDiag` from (c)**: `diag_young` and `StmtDiagMain` give Young's Lemma 6 for the
diagonal, `diagSum = c₁(α,β) ŵ(0) + O(T/L)`, for every `θ < 1/2`, `κ > 0`. -/
theorem stmtDiag_of_main (P : Polynomial ℝ) {θ : ℝ} (hθ : θ < 1 / 2) (R : ℝ) {κ : ℝ}
    (hκ : 0 < κ) (hmain : StmtDiagMain P θ R κ) : StmtDiag P θ R κ := by
  obtain ⟨C1, T1, hC10, hC1⟩ := hmain
  obtain ⟨C2, T2, hC20, hC2⟩ := diag_young P hθ R hκ
  refine ⟨2 * C1 + C2, max (max 8 (Real.exp (10 * κ))) (max T1 T2), by positivity,
    fun T hT W α β hreg => ?_⟩
  have hT8 : 8 ≤ T := le_trans (le_trans (le_max_left _ _) (le_max_left _ _)) hT
  have hTk : Real.exp (10 * κ) ≤ T := le_trans (le_trans (le_max_right _ _) (le_max_left _ _)) hT
  have hT1 : T1 ≤ T := le_trans (le_trans (le_max_left _ _) (le_max_right _ _)) hT
  have hT2 : T2 ≤ T := le_trans (le_trans (le_max_right _ _) (le_max_right _ _)) hT
  have hT0 : 0 < T := by linarith
  obtain ⟨-, -, -, hL0⟩ := hreg.small hκ hTk
  set z := riemannZeta (1 + α + β) * Sdiag (Mof T θ) (aY P T θ R) (sig0 T R) α β 0 with hz
  set c1 := c1Y P (Mof T θ) α β with hc1
  set D := diagSum W (Mof T θ) (aY P T θ R) (sig0 T R) α β 1 with hD
  have hw0 : ‖(what0 W : ℂ)‖ ≤ 2 * T := by
    rw [Complex.norm_real]
    have h := norm_integral_le_Icc (f := W.w) (a := T / 4) (b := 2 * T) (K := 1) (by linarith)
      (fun t ht => (W.zero_out ht).1) (fun t _ => by rw [Real.norm_eq_abs]; exact W.abs_le_one t)
    unfold what0
    linarith
  have hmT : ‖z - c1‖ ≤ C1 / Real.log T := hC1 T hT1 α β hreg
  have hdy : ‖D - (what0 W : ℂ) * z‖ ≤ C2 * (T / Real.log T) := hC2 T hT2 W α β hreg
  have herr : T / Real.log T ≤ errY W := by
    unfold errY
    have := W.C1_nonneg
    have := W.C2_nonneg
    have : 0 ≤ T / Real.log T := by positivity
    nlinarith
  have hsplit : D - c1 * (what0 W : ℂ) = (D - (what0 W : ℂ) * z) + (what0 W : ℂ) * (z - c1) := by
    ring
  rw [hsplit]
  calc ‖(D - (what0 W : ℂ) * z) + (what0 W : ℂ) * (z - c1)‖
      ≤ ‖D - (what0 W : ℂ) * z‖ + ‖(what0 W : ℂ)‖ * ‖z - c1‖ := by
        rw [← norm_mul]
        exact norm_add_le _ _
    _ ≤ C2 * (T / Real.log T) + 2 * T * (C1 / Real.log T) :=
        add_le_add hdy (mul_le_mul hw0 hmT (norm_nonneg _) (by positivity))
    _ = (2 * C1 + C2) * (T / Real.log T) := by ring
    _ ≤ (2 * C1 + C2) * errY W := mul_le_mul_of_nonneg_left herr (by positivity)

/-! ## Axiom pins -/

/-- info: 'Diagonal.diag_reindex' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms diag_reindex

/-- info: 'Diagonal.ell_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ell_sum

/-- info: 'Diagonal.joint_integrable' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms joint_integrable

/-- info: 'Diagonal.wVI_swap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms wVI_swap

/-- info: 'Diagonal.inner_hk' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms inner_hk

/-- info: 'Diagonal.diag_per_t' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms diag_per_t

/-- info: 'Diagonal.diag_mellin' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms diag_mellin

/-- info: 'Diagonal.Ez_differentiable' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Ez_differentiable

/-- info: 'Diagonal.Hf_local' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Hf_local

/-- info: 'Diagonal.shift_t' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms shift_t

/-- info: 'Diagonal.diag_shift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms diag_shift

/-- info: 'Diagonal.shifted_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms shifted_bound

/-- info: 'Diagonal.gcd_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gcd_sum

/-- info: 'Diagonal.SB_young' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms SB_young

/-- info: 'Diagonal.final_size_diag' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms final_size_diag

/-- info: 'Diagonal.diag_young' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms diag_young

/-- info: 'Diagonal.stmtDiag_of_main' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtDiag_of_main

end Diagonal
