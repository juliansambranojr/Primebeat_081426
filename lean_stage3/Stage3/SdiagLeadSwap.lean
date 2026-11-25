/-
# Stage3.SdiagLeadSwap — the exact reduction of `Sdiag` through `d | (h,k)`. 2026-11-25.

Step 1 of the route in `Stage3/DiagMain.lean`'s docstring, the Jordan swap, exact (no size).
With Young's `a_h` (`aY`), `a_h h^(−σ₀) = μ(h) P_h h^(−1/2)` and `Chk·Rhk` at `s = 0` is
`μ(h)μ(k) P_h P_k (h,k)^{1+α+β} h^{−1−β} k^{−1−α}` (`term_eq`); `(h,k)^z = Σ_{d | (h,k)} J_z(d)`
with `J_z = μ * id^z` (`Jz_sum`); the swap (`gcd_swap`) and `h = d n` (`sum_dvd_reindex`) give

`S(α,β,0) = Σ_{d ≤ M} J_{1+α+β}(d) d^{−(2+α+β)} A_d(β) A_d(α)`,
`A_d(γ) = Σ_{n ≤ M/d} μ(dn) P(log(M/(dn))/log M) n^{−(1+γ)}` (`Sdiag_swap`).

| name | content | status |
|---|---|---|
| `Pw`, `fw`, `Jz`, `Ad` | `P_n`; `μ(n) P_n n^{−(1+γ)}`; `J_z(d) = Σ_{ab = d} μ(a) b^z`; `A_d(γ)` | def |
| `Jz_sum` | `Σ_{d | n} J_z(d) = n^z`, `n ≥ 1` | proved |
| `term_eq` | `Chk·Rhk(·,0) = fw β h · fw α k · (h,k)^{1+α+β}` | proved |
| `gcd_swap` | `Σ_{h,k} F_h G_k Σ_{d|(h,k)} J_d = Σ_d J_d (Σ_{d|h} F_h)(Σ_{d|k} G_k)` | proved |
| `sum_dvd_reindex` | `Σ_{h ≤ M, d | h} F_h = Σ_{n ≤ M/d} F_{dn}` | proved |
| `Sdiag_swap` | `S(α,β,0) = Σ_{d ≤ M} J(d) d^{−(2+α+β)} A_d(β) A_d(α)` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.DiagMain

namespace SdiagLead

open Complex Finset TwistedMoment Diagonal
open scoped ArithmeticFunction.Moebius

noncomputable section

/-- `P_n = P(log(M/n)/log M)`, Young's weight. -/
def Pw (P : Polynomial ℝ) (M n : ℕ) : ℝ := P.eval (Real.log ((M : ℝ) / n) / Real.log M)

/-- `μ(n) P_n n^{−(1+γ)}`. -/
def fw (P : Polynomial ℝ) (M : ℕ) (γ : ℂ) (n : ℕ) : ℂ :=
  ((μ n : ℤ) : ℂ) * ((Pw P M n : ℝ) : ℂ) * (n : ℂ) ^ (-(1 + γ))

/-- `J_z(d) = Σ_{ab = d} μ(a) b^z`, so `Σ_{d | n} J_z(d) = n^z`. -/
def Jz (z : ℂ) (d : ℕ) : ℂ := ∑ x ∈ d.divisorsAntidiagonal, ((μ x.1 : ℤ) : ℂ) * (x.2 : ℂ) ^ z

/-- `A_d(γ) = Σ_{n ≤ M/d} μ(dn) P_{dn} n^{−(1+γ)}`. -/
def Ad (P : Polynomial ℝ) (M d : ℕ) (γ : ℂ) : ℂ :=
  ∑ n ∈ Icc 1 (M / d), ((μ (d * n) : ℤ) : ℂ) * ((Pw P M (d * n) : ℝ) : ℂ) * (n : ℂ) ^ (-(1 + γ))

theorem Jz_sum (z : ℂ) {n : ℕ} (hn : 0 < n) : ∑ d ∈ n.divisors, Jz z d = (n : ℂ) ^ z :=
  (ArithmeticFunction.sum_eq_iff_sum_mul_moebius_eq (f := Jz z)
    (g := fun n : ℕ => (n : ℂ) ^ z)).mpr (fun _ _ => rfl) n hn

theorem natcpow_ne {n : ℕ} (hn : 1 ≤ n) : (n : ℂ) ≠ 0 := by
  exact_mod_cast (by omega : n ≠ 0)

/-- `a_h h^{−σ₀} = μ(h) P_h h^{−1/2}`. -/
theorem aY_mul (P : Polynomial ℝ) (T θ R : ℝ) {h : ℕ} (hh : 1 ≤ h) :
    aY P T θ R h * (h : ℂ) ^ (-(sig0 T R : ℂ)) =
      ((μ h : ℤ) : ℂ) * ((Pw P (Mof T θ) h : ℝ) : ℂ) * (h : ℂ) ^ (-(1 / 2 : ℂ)) := by
  unfold aY
  rw [Complex.ofReal_cpow (Nat.cast_nonneg h), Complex.ofReal_natCast, mul_assoc,
    ← Complex.cpow_add _ _ (natcpow_ne hh)]
  have : ((sig0 T R - 1 / 2 : ℝ) : ℂ) + -(sig0 T R : ℂ) = -(1 / 2 : ℂ) := by push_cast; ring
  rw [this]; rfl

theorem conj_aY (P : Polynomial ℝ) (T θ R : ℝ) (h : ℕ) :
    (starRingEnd ℂ) (aY P T θ R h) = aY P T θ R h := by
  unfold aY
  simp only [map_mul, map_intCast, Complex.conj_ofReal]

/-- **One term**: `Chk·Rhk(·,0) = μ(h)P_h h^{−1−β} · μ(k)P_k k^{−1−α} · (h,k)^{1+α+β}`. -/
theorem term_eq (P : Polynomial ℝ) (T θ R : ℝ) {h k : ℕ} (hh : 1 ≤ h) (hk : 1 ≤ k) (α β : ℂ) :
    Chk (aY P T θ R) (sig0 T R) h k * Rhk α β h k 0 =
      fw P (Mof T θ) β h * fw P (Mof T θ) α k * ((Nat.gcd h k : ℕ) : ℂ) ^ (1 + α + β) := by
  have hg1 : 1 ≤ Nat.gcd h k := Nat.gcd_pos_of_pos_left _ hh
  set g := Nat.gcd h k with hgdef
  have hhg : h = g * (h / g) := (Nat.mul_div_cancel' (Nat.gcd_dvd_left h k)).symm
  have hkg : k = g * (k / g) := (Nat.mul_div_cancel' (Nat.gcd_dvd_right h k)).symm
  set h' := h / g with hh'def
  set k' := k / g with hk'def
  have hh'1 : 1 ≤ h' := by
    rcases Nat.eq_zero_or_pos h' with h0 | h0
    · rw [h0, mul_zero] at hhg; omega
    · exact h0
  have hk'1 : 1 ≤ k' := by
    rcases Nat.eq_zero_or_pos k' with h0 | h0
    · rw [h0, mul_zero] at hkg; omega
    · exact h0
  have ph : ∀ w : ℂ, (h : ℂ) ^ w = (g : ℂ) ^ w * (h' : ℂ) ^ w := fun w => by
    rw [← ncpow_mul, ← hhg]
  have pk : ∀ w : ℂ, (k : ℂ) ^ w = (g : ℂ) ^ w * (k' : ℂ) ^ w := fun w => by
    rw [← ncpow_mul, ← hkg]
  have hA := aY_mul P T θ R hh
  have hB := aY_mul P T θ R hk
  have e1 : (h' : ℂ) ^ (-(1 / 2 : ℂ)) * (h' : ℂ) ^ (-(1 / 2 + β + 0)) = (h' : ℂ) ^ (-(1 + β)) := by
    rw [← Complex.cpow_add _ _ (natcpow_ne hh'1)]; ring_nf
  have e2 : (k' : ℂ) ^ (-(1 / 2 : ℂ)) * (k' : ℂ) ^ (-(1 / 2 + α + 0)) = (k' : ℂ) ^ (-(1 + α)) := by
    rw [← Complex.cpow_add _ _ (natcpow_ne hk'1)]; ring_nf
  have e3 : (g : ℂ) ^ (-(1 / 2 : ℂ)) * (g : ℂ) ^ (-(1 / 2 : ℂ)) =
      (g : ℂ) ^ (-(1 + β)) * (g : ℂ) ^ (-(1 + α)) * (g : ℂ) ^ (1 + α + β) := by
    rw [← Complex.cpow_add _ _ (natcpow_ne hg1), ← Complex.cpow_add _ _ (natcpow_ne hg1),
      ← Complex.cpow_add _ _ (natcpow_ne hg1)]
    ring_nf
  unfold Chk Rhk fw
  rw [conj_aY]
  have hre : aY P T θ R h * aY P T θ R k * ((h : ℂ) ^ (-(sig0 T R : ℂ)) * (k : ℂ) ^ (-(sig0 T R : ℂ)))
      = (aY P T θ R h * (h : ℂ) ^ (-(sig0 T R : ℂ))) *
        (aY P T θ R k * (k : ℂ) ^ (-(sig0 T R : ℂ))) := by ring
  rw [hre, hA, hB, ph, pk, ph (-(1 + β)), pk (-(1 + α))]
  have : ((μ h : ℤ) : ℂ) * ((Pw P (Mof T θ) h : ℝ) : ℂ) * ((g : ℂ) ^ (-(1 / 2 : ℂ)) *
        (h' : ℂ) ^ (-(1 / 2 : ℂ))) * (((μ k : ℤ) : ℂ) * ((Pw P (Mof T θ) k : ℝ) : ℂ) *
        ((g : ℂ) ^ (-(1 / 2 : ℂ)) * (k' : ℂ) ^ (-(1 / 2 : ℂ)))) *
        ((k' : ℂ) ^ (-(1 / 2 + α + 0)) * (h' : ℂ) ^ (-(1 / 2 + β + 0))) =
      ((μ h : ℤ) : ℂ) * ((Pw P (Mof T θ) h : ℝ) : ℂ) * ((μ k : ℤ) : ℂ) *
        ((Pw P (Mof T θ) k : ℝ) : ℂ) *
        ((h' : ℂ) ^ (-(1 / 2 : ℂ)) * (h' : ℂ) ^ (-(1 / 2 + β + 0))) *
        ((k' : ℂ) ^ (-(1 / 2 : ℂ)) * (k' : ℂ) ^ (-(1 / 2 + α + 0))) *
        ((g : ℂ) ^ (-(1 / 2 : ℂ)) * (g : ℂ) ^ (-(1 / 2 : ℂ))) := by ring
  rw [this, e1, e2, e3]
  ring

/-- **The swap**: `Σ_{h,k} F_h G_k Σ_{d|(h,k)} J_d = Σ_{d ≤ M} J_d (Σ_{d|h} F_h)(Σ_{d|k} G_k)`. -/
theorem gcd_swap (M : ℕ) (F G J : ℕ → ℂ) :
    ∑ h ∈ Icc 1 M, ∑ k ∈ Icc 1 M, F h * G k * ∑ d ∈ (Nat.gcd h k).divisors, J d =
      ∑ d ∈ Icc 1 M, J d * (∑ h ∈ (Icc 1 M).filter (d ∣ ·), F h) *
        (∑ k ∈ (Icc 1 M).filter (d ∣ ·), G k) := by
  have hdiv : ∀ h ∈ Icc 1 M, ∀ k ∈ Icc 1 M, ∑ d ∈ (Nat.gcd h k).divisors, J d =
      ∑ d ∈ Icc 1 M, if d ∣ h ∧ d ∣ k then J d else 0 := by
    intro h hh k hk
    rw [← Finset.sum_filter]
    refine Finset.sum_congr ?_ fun _ _ => rfl
    ext d
    simp only [Nat.mem_divisors, Finset.mem_filter, Finset.mem_Icc, Nat.dvd_gcd_iff]
    obtain ⟨hh1, hhM⟩ := Finset.mem_Icc.mp hh
    constructor
    · rintro ⟨⟨h1, h2⟩, -⟩
      exact ⟨⟨Nat.pos_of_dvd_of_pos h1 hh1, le_trans (Nat.le_of_dvd hh1 h1) hhM⟩, h1, h2⟩
    · rintro ⟨-, h1, h2⟩
      exact ⟨⟨h1, h2⟩, (Nat.gcd_pos_of_pos_left _ hh1).ne'⟩
  calc ∑ h ∈ Icc 1 M, ∑ k ∈ Icc 1 M, F h * G k * ∑ d ∈ (Nat.gcd h k).divisors, J d
      = ∑ h ∈ Icc 1 M, ∑ k ∈ Icc 1 M, ∑ d ∈ Icc 1 M,
          (if d ∣ h ∧ d ∣ k then F h * G k * J d else 0) := by
        refine Finset.sum_congr rfl fun h hh => Finset.sum_congr rfl fun k hk => ?_
        rw [hdiv h hh k hk, Finset.mul_sum]
        refine Finset.sum_congr rfl fun d _ => ?_
        split_ifs <;> simp
    _ = ∑ h ∈ Icc 1 M, ∑ d ∈ Icc 1 M, ∑ k ∈ Icc 1 M,
          (if d ∣ h ∧ d ∣ k then F h * G k * J d else 0) :=
        Finset.sum_congr rfl fun h _ => Finset.sum_comm
    _ = ∑ d ∈ Icc 1 M, ∑ h ∈ Icc 1 M, ∑ k ∈ Icc 1 M,
          (if d ∣ h ∧ d ∣ k then F h * G k * J d else 0) := Finset.sum_comm
    _ = _ := by
        refine Finset.sum_congr rfl fun d _ => ?_
        rw [Finset.sum_filter, Finset.sum_filter, mul_assoc, Finset.sum_mul_sum, Finset.mul_sum]
        refine Finset.sum_congr rfl fun h _ => ?_
        rw [Finset.mul_sum]
        refine Finset.sum_congr rfl fun k _ => ?_
        by_cases h1 : d ∣ h <;> by_cases h2 : d ∣ k <;> simp [h1, h2]
        ring

/-- `Σ_{h ≤ M, d | h} F_h = Σ_{n ≤ M/d} F_{dn}`. -/
theorem sum_dvd_reindex (M : ℕ) {d : ℕ} (hd : 1 ≤ d) (F : ℕ → ℂ) :
    ∑ h ∈ (Icc 1 M).filter (d ∣ ·), F h = ∑ n ∈ Icc 1 (M / d), F (d * n) := by
  refine Finset.sum_nbij' (fun h => h / d) (fun n => d * n) ?_ ?_ ?_ ?_ ?_
  · intro h hh
    simp only [Finset.mem_filter, Finset.mem_Icc] at hh
    obtain ⟨⟨h1, h2⟩, h3⟩ := hh
    simp only [Finset.mem_Icc]
    exact ⟨Nat.div_pos (Nat.le_of_dvd h1 h3) hd, Nat.div_le_div_right h2⟩
  · intro n hn
    simp only [Finset.mem_Icc] at hn
    simp only [Finset.mem_filter, Finset.mem_Icc]
    refine ⟨⟨Nat.mul_pos hd hn.1, le_trans (Nat.mul_le_mul_left d hn.2) (Nat.mul_div_le M d)⟩,
      Dvd.intro n rfl⟩
  · intro h hh
    simp only [Finset.mem_filter] at hh
    exact Nat.mul_div_cancel' hh.2
  · intro n _
    exact Nat.mul_div_cancel_left n hd
  · intro h hh
    simp only [Finset.mem_filter] at hh
    rw [Nat.mul_div_cancel' hh.2]

theorem fw_mul (P : Polynomial ℝ) (M : ℕ) (γ : ℂ) (d n : ℕ) :
    fw P M γ (d * n) = (d : ℂ) ^ (-(1 + γ)) *
      (((μ (d * n) : ℤ) : ℂ) * ((Pw P M (d * n) : ℝ) : ℂ) * (n : ℂ) ^ (-(1 + γ))) := by
  unfold fw; rw [ncpow_mul]; ring

/-- **The reduction**: `S(α,β,0) = Σ_{d ≤ M} J_{1+α+β}(d) d^{−(2+α+β)} A_d(β) A_d(α)`. -/
theorem Sdiag_swap (P : Polynomial ℝ) (T θ R : ℝ) (α β : ℂ) :
    Sdiag (Mof T θ) (aY P T θ R) (sig0 T R) α β 0 =
      ∑ d ∈ Icc 1 (Mof T θ), Jz (1 + α + β) d * (d : ℂ) ^ (-(2 + α + β)) *
        Ad P (Mof T θ) d β * Ad P (Mof T θ) d α := by
  unfold Sdiag
  set M := Mof T θ
  have h1 : ∀ h ∈ Icc 1 M, ∀ k ∈ Icc 1 M, Chk (aY P T θ R) (sig0 T R) h k * Rhk α β h k 0 =
      fw P M β h * fw P M α k * ∑ d ∈ (Nat.gcd h k).divisors, Jz (1 + α + β) d := by
    intro h hh k hk
    have hh1 := (Finset.mem_Icc.mp hh).1
    have hk1 := (Finset.mem_Icc.mp hk).1
    rw [term_eq P T θ R hh1 hk1, Jz_sum _ (Nat.gcd_pos_of_pos_left _ hh1)]
  rw [Finset.sum_congr rfl fun h hh => Finset.sum_congr rfl fun k hk => h1 h hh k hk, gcd_swap]
  refine Finset.sum_congr rfl fun d hd => ?_
  have hd1 := (Finset.mem_Icc.mp hd).1
  rw [sum_dvd_reindex M hd1, sum_dvd_reindex M hd1]
  simp only [fw_mul, ← Finset.mul_sum]
  have e : (d : ℂ) ^ (-(1 + β)) * (d : ℂ) ^ (-(1 + α)) = (d : ℂ) ^ (-(2 + α + β)) := by
    rw [← Complex.cpow_add _ _ (natcpow_ne hd1)]; ring_nf
  unfold Ad
  rw [← e]; ring

end

/-- info: 'SdiagLead.Sdiag_swap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Sdiag_swap

/-- info: 'SdiagLead.term_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms term_eq

/-- info: 'SdiagLead.gcd_swap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gcd_swap

end SdiagLead
