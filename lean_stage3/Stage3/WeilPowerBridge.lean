/-
WeilPowerBridge — the term at an actual zero: two sidebands, the far one bounded.
Rung 5, twentieth slice; worksheet § 13 block 13j. 2026-09-07.

Every module of blocks 13a–13i is about `S m w` for a free complex `w`.
This module is the connection the ladder never made: it states the zero
form's term at `ρ : Kadiri.NontrivialZeros`, an actual nontrivial zero of
zeta, and reads that term in `S` at the two sidebands the window puts it on.

From `WeilPowerBackground.term_re_eq` and `WeilOddPower.what_eq`,

  termW h γ m ρ = −(h/2)²·Re((S m w₊ + S m w₋)²),  w± = (ρ − 1/2 ± iγ)·h,

the window being a cosine at height `γ` times an envelope. Expanding,
`−(h/2)²[Re(S₋²) + 2Re(S₊S₋) + Re(S₊²)]`. Block 13b bounds `Re(S₋²)` below
(`WeilPowerPhase.re_S_sq_ge`); nothing bounded the other two. The far
sideband has `Im w₊ = (Im ρ + γ)h`, about `2γh`, and § 4's far bound
`WeilPowerBounds.norm_S_le_far` gives
`‖S m w₊‖ ≤ cS m · cosh(Re w₊) · (2/Im w₊²)^{m+1}` once
`2(Re w₊² + π²(m+1)²) ≤ Im w₊²`.

Sizes. `‖S m w₊‖ ≤ cS m · cosh(ε'h) · (2/((Im ρ + γ)h)²)^{m+1}`; with
`(Im ρ + γ)h ≥ 2γh − h/2` and `m + 1 = λh` this is
`cS m · e^{ε'h} · (1/(2γ²h²))^{λh}`, super-exponentially small in `h` for
`γ ≥ 2`, against `Re(S₋²) ~ c²ε'²h²e^{2ε'²h/(π²λ)}`. The cross term is
`2‖S₊‖‖S₋‖`, the same order times `‖S₋‖`. No factor is lost: the far
sideband is § 4's decay and it is the only new thing here.

Regime, as the block names it:
  F1 `0 < h`;
  F2 `2·((Re ρ − 1/2)²h² + π²(m+1)²) ≤ ((Im ρ + γ)h)²`, the far condition at
     `w₊`, which is `(Im ρ + γ)² ≥ 2((Re ρ − 1/2)² + π²λ²)`;
  and for the last theorem block 13b's regime at `w₋`:
  F3 `QS m w₋ ≠ 0`;  F4 `‖w₋‖² ≤ π²(m+2)²/2`;  F5 `q m w₋ ≤ 1`.

Defs. `wp h γ ρ = (ρ − 1/2 + iγ)h` and `wm h γ ρ = (ρ − 1/2 − iγ)h`, the two
sidebands the zero is read at.

Theorems, with the hypotheses the block lists:
  im_sq_sub_re_sq     none            `z.im² − z.re² = −(z²).re`
  term_eq_sidebands   F1              the term as `−(h/2)²(Re S₋² + 2Re S₊S₋
                                       + Re S₊²)`
  term_le_sidebands   F1              the same with `Re(z) ≥ −‖z‖` on the
                                       cross and far pieces
  wp_re, wp_im        none            `(wp).re = (ρ.re − 1/2)h`,
                                       `(wp).im = (ρ.im + γ)h`
  far_sideband_le     F2              `‖S m w₊‖ ≤ cS m·cosh((ρ.re − 1/2)h)
                                       ·(2/((ρ.im + γ)h)²)^(m+1)`
  term_le_at_zero     F1 F2 F3 F4 F5  the term at `ρ : Kadiri.NontrivialZeros`,
                                       every constant explicit

Pinned: term_eq_sidebands, term_le_sidebands, far_sideband_le,
term_le_at_zero.

What the next slice needs: the size of the whole term, sidebands included,
priced on this statement rather than on `S` alone; and the assembly's choice
of `γ` discharging F2 rather than carrying it as a hypothesis.

Axioms: every pinned theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.WeilPowerPhase
import Stage3.WeilPowerBands
import Stage3.WeilPowerBounds

namespace WeilPowerBridge

noncomputable section

open WeilOddPower WeilPowerBackground WeilPowerPhase WeilPowerBounds WeilPowerGauss

/-- The far sideband: `w₊ = (ρ − 1/2 + iγ)h`. -/
def wp (h γ : ℝ) (ρ : ℂ) : ℂ := (ρ - 1 / 2 + Complex.I * (γ : ℂ)) * (h : ℂ)

/-- The near sideband: `w₋ = (ρ − 1/2 − iγ)h`. -/
def wm (h γ : ℝ) (ρ : ℂ) : ℂ := (ρ - 1 / 2 - Complex.I * (γ : ℂ)) * (h : ℂ)

/-- `Im(z)² − Re(z)² = −Re(z²)`: the arithmetic that turns the background's
term into a square. -/
theorem im_sq_sub_re_sq (z : ℂ) : z.im ^ 2 - z.re ^ 2 = -(z ^ 2).re := by
  simp [pow_two, Complex.mul_re]

/-- The term of the zero form at `ρ`, read at the two sidebands: the window
is a cosine at height `γ` times an envelope, so `what` is `(h/2)(S₊ + S₋)`
and the term is `−(h/2)²` times the real part of its square. -/
theorem term_eq_sidebands {h : ℝ} (hh : 0 < h) (γ : ℝ) (m : ℕ) (ρ : ℂ) :
    WeilPowerBands.termW h γ m ρ
      = -((h / 2) ^ 2 * (((S m (wm h γ ρ)) ^ 2).re
          + 2 * (S m (wp h γ ρ) * S m (wm h γ ρ)).re
          + ((S m (wp h γ ρ)) ^ 2).re)) := by
  have hcast : ((h : ℂ) / 2) ^ 2 = (((h / 2) ^ 2 : ℝ) : ℂ) := by push_cast; ring
  have hre : ∀ a b : ℂ, ((a + b) ^ 2).re = (b ^ 2).re + 2 * (a * b).re + (a ^ 2).re := by
    intro a b
    simp only [pow_two, Complex.add_re, Complex.add_im, Complex.mul_re]
    ring
  unfold WeilPowerBands.termW wp wm
  rw [term_re_eq hh, what_eq hh, im_sq_sub_re_sq, mul_pow, hcast,
    Complex.re_ofReal_mul, hre]
  try ring

/-- The same term with the two unbounded pieces sent to their norms:
`Re(S₊S₋) ≥ −‖S₊‖‖S₋‖` and `Re(S₊²) ≥ −‖S₊‖²`, and a larger bracket makes
the term more negative. -/
theorem term_le_sidebands {h : ℝ} (hh : 0 < h) (γ : ℝ) (m : ℕ) (ρ : ℂ) :
    WeilPowerBands.termW h γ m ρ
      ≤ -((h / 2) ^ 2 * (((S m (wm h γ ρ)) ^ 2).re
          - 2 * ‖S m (wp h γ ρ)‖ * ‖S m (wm h γ ρ)‖
          - ‖S m (wp h γ ρ)‖ ^ 2)) := by
  rw [term_eq_sidebands hh]
  have h1 : -(‖S m (wp h γ ρ)‖ * ‖S m (wm h γ ρ)‖)
      ≤ (S m (wp h γ ρ) * S m (wm h γ ρ)).re := by
    have h1' : -‖S m (wp h γ ρ) * S m (wm h γ ρ)‖
        ≤ (S m (wp h γ ρ) * S m (wm h γ ρ)).re :=
      neg_le_of_abs_le (Complex.abs_re_le_norm (S m (wp h γ ρ) * S m (wm h γ ρ)))
    rwa [norm_mul] at h1'
  have h2 : -(‖S m (wp h γ ρ)‖ ^ 2) ≤ ((S m (wp h γ ρ)) ^ 2).re := by
    have h2' : -‖(S m (wp h γ ρ)) ^ 2‖ ≤ ((S m (wp h γ ρ)) ^ 2).re :=
      neg_le_of_abs_le (Complex.abs_re_le_norm ((S m (wp h γ ρ)) ^ 2))
    rwa [norm_pow] at h2'
  have hc : (0 : ℝ) ≤ (h / 2) ^ 2 := sq_nonneg _
  have hb : ((S m (wm h γ ρ)) ^ 2).re - 2 * ‖S m (wp h γ ρ)‖ * ‖S m (wm h γ ρ)‖
        - ‖S m (wp h γ ρ)‖ ^ 2
      ≤ ((S m (wm h γ ρ)) ^ 2).re + 2 * (S m (wp h γ ρ) * S m (wm h γ ρ)).re
        + ((S m (wp h γ ρ)) ^ 2).re := by linarith
  exact neg_le_neg (mul_le_mul_of_nonneg_left hb hc)

/-- `Re w₊ = (ρ.re − 1/2)h`. -/
theorem wp_re (h γ : ℝ) (ρ : ℂ) : (wp h γ ρ).re = (ρ.re - 1 / 2) * h := by
  simp [wp, Complex.mul_re, Complex.mul_im]
  try ring

/-- `Im w₊ = (ρ.im + γ)h`: the far sideband sits at about `2γh` when `ρ` is
near height `γ`. -/
theorem wp_im (h γ : ℝ) (ρ : ℂ) : (wp h γ ρ).im = (ρ.im + γ) * h := by
  simp [wp, Complex.mul_re, Complex.mul_im]
  try ring

/-- The far sideband is § 4's decay: once the far condition holds at `w₊`,
`‖S m w₊‖` is `cS m·cosh((ρ.re − 1/2)h)` times `(2/((ρ.im + γ)h)²)^(m+1)`. -/
theorem far_sideband_le {h γ : ℝ} {m : ℕ} {ρ : ℂ}
    (hfar : 2 * (((ρ.re - 1 / 2) * h) ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2)
              ≤ ((ρ.im + γ) * h) ^ 2) :
    ‖S m (wp h γ ρ)‖
      ≤ cS m * Real.cosh ((ρ.re - 1 / 2) * h) * (2 / ((ρ.im + γ) * h) ^ 2) ^ (m + 1) := by
  have hhyp : 2 * ((wp h γ ρ).re ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2)
      ≤ (wp h γ ρ).im ^ 2 := by
    rw [wp_re, wp_im]
    exact hfar
  have h1 := norm_S_le_far (m := m) (w := wp h γ ρ) hhyp
  rwa [wp_re, wp_im] at h1

/-- The term at an actual nontrivial zero of zeta, every constant explicit:
13b's lower bound on the near sideband, § 4's decay on the far one, and the
cross term between them. This is the ladder attached to a zero. -/
theorem term_le_at_zero {h γ : ℝ} {m : ℕ} (hh : 0 < h) (ρ : Kadiri.NontrivialZeros)
    (hfar : 2 * ((((ρ : ℂ).re - 1 / 2) * h) ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2)
              ≤ (((ρ : ℂ).im + γ) * h) ^ 2)
    (hne : QS m (wm h γ (ρ : ℂ)) ≠ 0)
    (hsmall : ‖wm h γ (ρ : ℂ)‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2)
    (hq : q m (wm h γ (ρ : ℂ)) ≤ 1) :
    WeilPowerBands.termW h γ m (ρ : ℂ)
      ≤ -((h / 2) ^ 2 *
          ((cS m / D m) ^ 2 * Real.exp (2 * ((wm h γ (ρ : ℂ)) ^ 2).re * sigma m)
              * (((wm h γ (ρ : ℂ)) ^ 2).re
                  * Real.cos (2 * ((wm h γ (ρ : ℂ)) ^ 2).im * sigma m)
                - ((wm h γ (ρ : ℂ)) ^ 2).im
                  * Real.sin (2 * ((wm h γ (ρ : ℂ)) ^ 2).im * sigma m))
            - (cS m / D m) ^ 2 * ‖wm h γ (ρ : ℂ)‖ ^ 2
              * Real.exp (2 * ((wm h γ (ρ : ℂ)) ^ 2).re * sigma m)
              * (4 * q m (wm h γ (ρ : ℂ)) + 4 * q m (wm h γ (ρ : ℂ)) ^ 2)
          - 2 * (cS m * Real.cosh (((ρ : ℂ).re - 1 / 2) * h)
                  * (2 / (((ρ : ℂ).im + γ) * h) ^ 2) ^ (m + 1)) * ‖S m (wm h γ (ρ : ℂ))‖
          - (cS m * Real.cosh (((ρ : ℂ).re - 1 / 2) * h)
                  * (2 / (((ρ : ℂ).im + γ) * h) ^ 2) ^ (m + 1)) ^ 2)) := by
  have hle := term_le_sidebands hh γ m (ρ : ℂ)
  have hP := re_S_sq_ge hne hsmall hq
  have hF := far_sideband_le (h := h) (γ := γ) (m := m) (ρ := (ρ : ℂ)) hfar
  have hSp : (0 : ℝ) ≤ ‖S m (wp h γ (ρ : ℂ))‖ := norm_nonneg _
  have hSm : (0 : ℝ) ≤ ‖S m (wm h γ (ρ : ℂ))‖ := norm_nonneg _
  have hcross : 2 * ‖S m (wp h γ (ρ : ℂ))‖ * ‖S m (wm h γ (ρ : ℂ))‖
      ≤ 2 * (cS m * Real.cosh (((ρ : ℂ).re - 1 / 2) * h)
            * (2 / (((ρ : ℂ).im + γ) * h) ^ 2) ^ (m + 1)) * ‖S m (wm h γ (ρ : ℂ))‖ := by
    have h2 : 2 * ‖S m (wp h γ (ρ : ℂ))‖
        ≤ 2 * (cS m * Real.cosh (((ρ : ℂ).re - 1 / 2) * h)
              * (2 / (((ρ : ℂ).im + γ) * h) ^ 2) ^ (m + 1)) := by linarith
    exact mul_le_mul_of_nonneg_right h2 hSm
  have hsq : ‖S m (wp h γ (ρ : ℂ))‖ ^ 2
      ≤ (cS m * Real.cosh (((ρ : ℂ).re - 1 / 2) * h)
            * (2 / (((ρ : ℂ).im + γ) * h) ^ 2) ^ (m + 1)) ^ 2 :=
    pow_le_pow_left₀ hSp hF 2
  have hc : (0 : ℝ) ≤ (h / 2) ^ 2 := sq_nonneg _
  refine le_trans hle (neg_le_neg (mul_le_mul_of_nonneg_left ?_ hc))
  linarith

/-- info: 'WeilPowerBridge.term_eq_sidebands' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms term_eq_sidebands

/-- info: 'WeilPowerBridge.term_le_sidebands' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms term_le_sidebands

/-- info: 'WeilPowerBridge.far_sideband_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms far_sideband_le

/-- info: 'WeilPowerBridge.term_le_at_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms term_le_at_zero

end

end WeilPowerBridge
