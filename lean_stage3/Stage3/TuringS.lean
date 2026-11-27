/-
TuringS — block S14 of `lean_stage3/design/stencil.md`, Turing's method, step 1: `S`, `S₁`
and Littlewood's bound on `∫ S`. 2026-11-25.

`S t = N t − θ(t)/π − 1`, with `N = riemannZeta.N` (open at `t`) and `θ = Stage3.phaseTheta`,
is the tree's `Stage3.argS` (`S_eq_argS`, by `rfl`). `S₁ T = ∫_0^T S`. `S` is a monotone
function minus a continuous one, so it is integrable on every interval (`intervalIntegrable_S`),
and `S₁ t₂ − S₁ t₁ = ∫_{t₁}^{t₂} S` (`S₁_sub`).

**Littlewood's bound, the route.** At a good height `t ≥ 2`,
`ArgIdentity.argS_eq_zetaArgContour` reads

  `π S(t) = F(t) − Im ∫_{1/2}^{2} L(x + it) dx`,   `F(t) = Re ∫_0^t L(2 + iu) du`,  `L = ζ′/ζ`.

The bad heights in `[t₁, t₂]` are finitely many, so the identity holds a.e. there. Integrate in
`t` and swap the order (Fubini; `1/|s − ρ|` is integrable on the rectangle,
`Littlewood.integrableOn_logDeriv`): along a vertical, `∂_t log|ζ(x + it)| = −Im L(x + it)`, so

  `π (S₁ t₂ − S₁ t₁) = ∫_{t₁}^{t₂} F + ∫_{1/2}^{2} (log|ζ(x + it₂)| − log|ζ(x + it₁)|) dx`.  (Split)

This is the identity `StmtSplit`. It is the imaginary component of the integrated argument
principle. `Littlewood.littlewood_rect` is its real component: it weighs the zeros by
`Re ρ − a` against `∫ log|f|` on the vertical edges, and it says nothing about `∫ arg` along a
vertical. The vertical form of `Littlewood.integral_re_logDeriv_horizontal` is that lemma for
`w ↦ ζ(−iw)` (a quarter turn), which is the route for `StmtSplit`; it is not built here.

The three terms of (Split):
* `∫ F`. On `Re = 2`, `L = −Σ Λ(n) n^{−s}`, so `F(t) = −Σ Λ(n)/(n² log n) · sin(t log n)` and
  `∫_{t₁}^{t₂} F = Σ Λ(n)/(n² log² n) · (cos(t₂ log n) − cos(t₁ log n))`, of size at most
  `2 Σ_{n ≥ 2} 1/(n² log 2) = 2(π²/6 − 1)/log 2 < 1.87`, for every `t₁ ≤ t₂`. Named
  `StmtOsc 2`; the termwise integration of the Dirichlet series is not built.
* the upper side of `∫_{1/2}^{2} log|ζ(x + it)| dx`: `‖ζ(x + it)‖ ≤ 2 + 4‖x + it‖ ≤ 9t` for
  `t ≥ 2` (`LevinsonEdge.zeta_norm_le`), so the integral is at most `(3/2)(log t + log 9)`.
  **Proved** (`horizUpper_holds`).
* the lower side, `∫_{1/2}^{2} log|ζ(x + it)| dx ≥ −(a₂ log t + b₂)`. This is the analytic
  core of Littlewood's bound: `log|ζ|` has a log singularity at each zero near the segment, and
  their number is `O(log t)` (`JensenCount.zetaLocalCount`). The classical route is
  Poisson–Jensen on the disc about `2 + it` (`JensenCount.zeta_disk_upper`,
  `JensenCount.zeta_centre_lower`): `log|ζ| = (Poisson average) + Σ log|Blaschke factor|`, each
  Blaschke factor's integral over the segment is at least an absolute constant, and the Poisson
  average is bounded below by Jensen. Named `StmtHorizLower a₂ b₂`; budget `a₂ ≤ 30`,
  `b₂ ≤ 200`.

**The composition** (`littlewood_of_pieces`, proved): from (Split), `StmtOsc c₀`, the proved
upper side and `StmtHorizLower a₂ b₂`,

  `|S₁ t₂ − S₁ t₁| ≤ ((3/2 + a₂)/π) · log t₂ + (c₀ + (3/2) log 9 + b₂)/π`  for `2 ≤ t₁ ≤ t₂`.

**The crude bound and its lost factor** (`S₁_crude`, proved): from `ArgCount.argS_le_gt_two`,
`|S₁ t₂ − S₁ t₁| ≤ (t₂ − t₁)(15 log t₂ + 75)`. The factor `t₂ − t₁` grows with the window. Fed to
Turing's averaging over a length `h` it returns `|S| ≤ 15 log t + 75`, the pointwise bound, so
it certifies nothing: the step is right and the size is wrong. Littlewood's bound has no such
factor, which is why (Split) and the lower side are the design, and the crude bound is kept only
as the recorded loss.

| name | content | status |
|---|---|---|
| `S` | `N t − (θ t/π + 1)` | def |
| `S₁` | `∫_0^T S` | def |
| `F` | `Re ∫_0^t L(2 + iu) du` | def |
| `S_eq_argS` | `S t = Stage3.argS t` | proved |
| `continuous_phaseTheta` | `θ` continuous | proved |
| `intervalIntegrable_S` | `S` integrable on `[a, b]` | proved |
| `S₁_sub` | `S₁ t₂ − S₁ t₁ = ∫_{t₁}^{t₂} S` | proved |
| `S₁_crude` | `2 < t₁ ≤ t₂ ⊢ |S₁ t₂ − S₁ t₁| ≤ (t₂ − t₁)(15 log t₂ + 75)` | proved, lost factor `t₂ − t₁` |
| `StmtLittlewood a b t₀` | `t₀ ≤ t₁ ≤ t₂ ⊢ |S₁ t₂ − S₁ t₁| ≤ a log t₂ + b` | open (the goal) |
| `StmtSplit` | (Split) for `2 ≤ t₁ ≤ t₂` | open |
| `StmtOsc c₀` | `|∫_{t₁}^{t₂} F| ≤ c₀` | open, `c₀ = 2` |
| `StmtHorizUpper a₁ b₁` | `∫_{1/2}^{2} log‖ζ(x + it)‖ dx ≤ a₁ log t + b₁`, `t ≥ 2` | def |
| `horizUpper_holds` | `StmtHorizUpper (3/2) ((3/2) log 9)` | proved |
| `StmtHorizLower a₂ b₂` | `−(a₂ log t + b₂) ≤ ∫_{1/2}^{2} log‖ζ(x + it)‖ dx`, `t ≥ 2` | open |
| `littlewood_of_pieces` | Split, Osc, Lower ⊢ `StmtLittlewood ((3/2 + a₂)/π) ((c₀ + (3/2) log 9 + b₂)/π) 2` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.Defect
import Stage3.LevinsonEdge

namespace Turing

open Complex MeasureTheory

noncomputable section

/-- `S(t) = N(t) − θ(t)/π − 1`. -/
def S (t : ℝ) : ℝ := riemannZeta.N t - (Stage3.phaseTheta t / Real.pi + 1)

/-- `S₁(T) = ∫_0^T S`. -/
def S₁ (T : ℝ) : ℝ := ∫ t in (0 : ℝ)..T, S t

/-- The right-edge term: `Re ∫_0^t ζ′/ζ (2 + iu) du`. -/
def F (t : ℝ) : ℝ :=
  (∫ u in (0 : ℝ)..t, logDeriv riemannZeta (2 + (u : ℂ) * Complex.I)).re

/-- **Littlewood's bound on `S₁`**, the goal of step 1. -/
def StmtLittlewood (a b t₀ : ℝ) : Prop :=
  ∀ t₁ t₂ : ℝ, t₀ ≤ t₁ → t₁ ≤ t₂ → |S₁ t₂ - S₁ t₁| ≤ a * Real.log t₂ + b

/-- The imaginary component of the integrated argument principle on `[1/2, 2] × [t₁, t₂]`. -/
def StmtSplit : Prop :=
  ∀ t₁ t₂ : ℝ, 2 ≤ t₁ → t₁ ≤ t₂ →
    Real.pi * (S₁ t₂ - S₁ t₁) = (∫ t in t₁..t₂, F t) +
      ((∫ x in (1 / 2 : ℝ)..2, Real.log ‖riemannZeta ((x : ℂ) + (t₂ : ℂ) * Complex.I)‖) -
        ∫ x in (1 / 2 : ℝ)..2, Real.log ‖riemannZeta ((x : ℂ) + (t₁ : ℂ) * Complex.I)‖)

/-- The right edge oscillates: its integral is bounded uniformly. -/
def StmtOsc (c₀ : ℝ) : Prop :=
  ∀ t₁ t₂ : ℝ, t₁ ≤ t₂ → |∫ t in t₁..t₂, F t| ≤ c₀

/-- The upper side of the horizontal `log |ζ|` integral. -/
def StmtHorizUpper (a₁ b₁ : ℝ) : Prop :=
  ∀ t : ℝ, 2 ≤ t →
    (∫ x in (1 / 2 : ℝ)..2, Real.log ‖riemannZeta ((x : ℂ) + (t : ℂ) * Complex.I)‖)
      ≤ a₁ * Real.log t + b₁

/-- The lower side of the horizontal `log |ζ|` integral: the analytic core. -/
def StmtHorizLower (a₂ b₂ : ℝ) : Prop :=
  ∀ t : ℝ, 2 ≤ t →
    -(a₂ * Real.log t + b₂) ≤
      ∫ x in (1 / 2 : ℝ)..2, Real.log ‖riemannZeta ((x : ℂ) + (t : ℂ) * Complex.I)‖

end

theorem S_eq_argS (t : ℝ) : S t = Stage3.argS t := rfl

theorem continuous_phaseTheta : Continuous Stage3.phaseTheta := by
  have h := intervalIntegral.continuous_primitive Stage3.intervalIntegrable_phasePoint 0
  have : Stage3.phaseTheta = fun T => (1 / 2) * (∫ t in (0 : ℝ)..T, Stage3.phasePoint t)
      - T / 2 * Real.log Real.pi := by
    funext T; rfl
  rw [this]
  fun_prop

theorem intervalIntegrable_S (a b : ℝ) : IntervalIntegrable S volume a b := by
  have hN : IntervalIntegrable (fun t => riemannZeta.N t) volume a b :=
    Monotone.intervalIntegrable (fun _ _ h => ArgCount.N_mono h)
  have hθ : Continuous fun t => Stage3.phaseTheta t / Real.pi + 1 := by
    have := continuous_phaseTheta
    fun_prop
  exact hN.sub (hθ.intervalIntegrable a b)

theorem S₁_sub (t₁ t₂ : ℝ) : S₁ t₂ - S₁ t₁ = ∫ t in t₁..t₂, S t :=
  intervalIntegral.integral_interval_sub_left (intervalIntegrable_S 0 t₂)
    (intervalIntegrable_S 0 t₁)

/-- **The crude bound**, from the pointwise `|S| ≤ 15 log t + 75`. It carries the factor
`t₂ − t₁`, the lost factor of step 1. -/
theorem S₁_crude {t₁ t₂ : ℝ} (h2 : 2 < t₁) (h12 : t₁ ≤ t₂) :
    |S₁ t₂ - S₁ t₁| ≤ (t₂ - t₁) * (15 * Real.log t₂ + 75) := by
  rw [S₁_sub]
  have hb : ∀ x ∈ Set.uIoc t₁ t₂, ‖S x‖ ≤ 15 * Real.log t₂ + 75 := by
    intro x hx
    rw [Set.uIoc_of_le h12] at hx
    have hx2 : 2 < x := by linarith [hx.1]
    rw [Real.norm_eq_abs, S_eq_argS]
    have h := ArgCount.argS_le_gt_two hx2
    have hl : Real.log x ≤ Real.log t₂ := Real.log_le_log (by linarith) hx.2
    linarith
  have h := intervalIntegral.norm_integral_le_of_norm_le_const hb
  rw [Real.norm_eq_abs, abs_of_nonneg (by linarith : (0 : ℝ) ≤ t₂ - t₁)] at h
  linarith

/-- The pointwise bound behind the upper side: `log ‖ζ(x + it)‖ ≤ log 9 + log t`. -/
theorem log_zeta_le {x t : ℝ} (hx1 : 1 / 2 ≤ x) (hx2 : x ≤ 2) (ht : 2 ≤ t) :
    Real.log ‖riemannZeta ((x : ℂ) + (t : ℂ) * Complex.I)‖ ≤ Real.log 9 + Real.log t := by
  set u : ℂ := (x : ℂ) + (t : ℂ) * Complex.I with hu
  have hre : u.re = x := by simp [hu]
  have him : u.im = t := by simp [hu]
  have hz := LevinsonEdge.zeta_norm_le (u := u) (by rw [hre]; linarith) (by rw [him]; linarith)
  have hnu : ‖u‖ ≤ x + t := by
    calc ‖u‖ ≤ ‖(x : ℂ)‖ + ‖(t : ℂ) * Complex.I‖ := norm_add_le _ _
      _ = x + t := by
        rw [norm_mul, Complex.norm_I, mul_one, Complex.norm_real, Complex.norm_real,
          Real.norm_eq_abs, Real.norm_eq_abs, abs_of_nonneg (by linarith),
          abs_of_nonneg (by linarith)]
  have h9 : ‖riemannZeta u‖ ≤ 9 * t := by linarith
  have hlog : Real.log 9 + Real.log t = Real.log (9 * t) :=
    (Real.log_mul (by norm_num) (by linarith)).symm
  rw [hlog]
  rcases eq_or_lt_of_le (norm_nonneg (riemannZeta u)) with h0 | hpos
  · rw [← h0, Real.log_zero]
    exact Real.log_nonneg (by linarith)
  · exact Real.log_le_log hpos h9

/-- **The upper side, proved.** -/
theorem horizUpper_holds : StmtHorizUpper (3 / 2) ((3 / 2) * Real.log 9) := by
  intro t ht
  have hl9 : 0 ≤ Real.log 9 := Real.log_nonneg (by norm_num)
  have hlt : 0 ≤ Real.log t := Real.log_nonneg (by linarith)
  by_cases hi : IntervalIntegrable
      (fun x : ℝ => Real.log ‖riemannZeta ((x : ℂ) + (t : ℂ) * Complex.I)‖) volume (1 / 2) 2
  · have hm := intervalIntegral.integral_mono_on (by norm_num : (1 / 2 : ℝ) ≤ 2) hi
      (intervalIntegrable_const (c := Real.log 9 + Real.log t))
      (fun x hx => log_zeta_le hx.1 hx.2 ht)
    rw [intervalIntegral.integral_const, smul_eq_mul] at hm
    linarith
  · rw [intervalIntegral.integral_undef hi]
    positivity

/-- **Littlewood's bound from its pieces.** -/
theorem littlewood_of_pieces {c₀ a₂ b₂ : ℝ} (hsplit : StmtSplit) (hosc : StmtOsc c₀)
    (hlow : StmtHorizLower a₂ b₂) (ha₂ : 0 ≤ a₂) :
    StmtLittlewood ((3 / 2 + a₂) / Real.pi) ((c₀ + (3 / 2) * Real.log 9 + b₂) / Real.pi) 2 := by
  intro t₁ t₂ h1 h12
  have hπ : 0 < Real.pi := Real.pi_pos
  have hs := hsplit t₁ t₂ h1 h12
  have ho := abs_le.mp (hosc t₁ t₂ h12)
  have hu1 := horizUpper_holds t₁ h1
  have hu2 := horizUpper_holds t₂ (by linarith)
  have hl1 := hlow t₁ h1
  have hl2 := hlow t₂ (by linarith)
  have hlog : Real.log t₁ ≤ Real.log t₂ := Real.log_le_log (by linarith) h12
  have hlog0 : 0 ≤ Real.log t₁ := Real.log_nonneg (by linarith)
  have e1 : a₂ * Real.log t₁ ≤ a₂ * Real.log t₂ := mul_le_mul_of_nonneg_left hlog ha₂
  have key : |Real.pi * (S₁ t₂ - S₁ t₁)| ≤
      (3 / 2 + a₂) * Real.log t₂ + (c₀ + (3 / 2) * Real.log 9 + b₂) := by
    rw [hs, abs_le]
    constructor <;> nlinarith
  rw [abs_mul, abs_of_pos hπ] at key
  rw [div_mul_eq_mul_div, ← add_div, le_div_iff₀ hπ]
  linarith

/-- info: 'Turing.intervalIntegrable_S' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms intervalIntegrable_S

/-- info: 'Turing.S₁_crude' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms S₁_crude

/-- info: 'Turing.horizUpper_holds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms horizUpper_holds

/-- info: 'Turing.littlewood_of_pieces' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms littlewood_of_pieces

end Turing
