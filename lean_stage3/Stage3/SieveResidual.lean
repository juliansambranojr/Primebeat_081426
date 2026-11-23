/-
SieveResidual — block R3 of `lean_stage3/design/runs.md`. 2026-11-23.

The roundings of the sieve and the residual of the table are tied exactly.

`SieveExact.netRounding_eq` gives the net rounding of the sieve's sum as the
closed product `N·Π(1 − 1/p)` less the count. The net rounding is of the order
of the count (unit 0475, corrected). Take from it its own smooth part,

    smoothNet N = N·Π_{p ≤ √N}(1 − 1/p) − 1 − Li N + Li √N,

and what is left is, exactly, the residual of the count at `N` less the
residual at `√N`, with the sign changed.

  cast_netRounding   the net rounding as a real number
  net_wobble         2 ≤ N ⊢ netRounding N − smoothNet N
                       = −((π N − Li N) − (π √N − Li √N))
  sqrt_two_pow       √(2^(2m)) = 2^m
  net_wobble_rows    1 ≤ m ⊢ at the doubling of row 2m the same, with the
                       residual at row 2m and the residual at row m: the row
                       and its half

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.SieveExact
import Stage3.PiZeros

namespace SieveResidual

open SieveExact

/-- The smooth part of the net rounding: the closed product, less the unit,
less the smooth count at `N`, plus the smooth count at `√N`. -/
noncomputable def smoothNet (N : ℕ) : ℝ :=
  (N : ℝ) * ∏ p ∈ smallPrimes N, (1 - 1 / (p : ℝ)) - 1
    - Stage3.Li (N : ℝ) + Stage3.Li ((Nat.sqrt N : ℕ) : ℝ)

/-- The net rounding, as a real number, is the product less the count the
sieve produces. -/
theorem cast_netRounding (N : ℕ) (hN : 2 ≤ N) :
    ((netRounding N : ℚ) : ℝ) = (N : ℝ) * ∏ p ∈ smallPrimes N, (1 - 1 / (p : ℝ))
      - (1 + (Nat.primeCounting N : ℝ) - (Nat.primeCounting (Nat.sqrt N) : ℝ)) := by
  rw [netRounding_eq N hN]
  push_cast
  ring

/-- **The roundings' wobble is the table's residual, at the row less at its
square root.** For `N ≥ 2`, the net rounding less its smooth part is minus the
residual of the count at `N` less the residual at `√N`. -/
theorem net_wobble (N : ℕ) (hN : 2 ≤ N) :
    ((netRounding N : ℚ) : ℝ) - smoothNet N
      = -(((Nat.primeCounting N : ℝ) - Stage3.Li (N : ℝ))
          - ((Nat.primeCounting (Nat.sqrt N) : ℝ) - Stage3.Li ((Nat.sqrt N : ℕ) : ℝ))) := by
  rw [cast_netRounding N hN]
  unfold smoothNet
  ring

/-- The square root of an even power of two is the power of half the exponent. -/
theorem sqrt_two_pow (m : ℕ) : Nat.sqrt (2 ^ (2 * m)) = 2 ^ m := by
  rw [show 2 ^ (2 * m) = (2 ^ m) * (2 ^ m) by rw [← pow_add]; congr 1; omega]
  exact Nat.sqrt_eq (2 ^ m)

/-- **The row and its half.** At the doubling of an even row `2m`, the net
rounding less its smooth part is minus the residual of the table at row `2m`
less the residual at row `m`. -/
theorem net_wobble_rows (m : ℕ) (hm : 1 ≤ m) :
    ((netRounding (2 ^ (2 * m)) : ℚ) : ℝ) - smoothNet (2 ^ (2 * m))
      = -(((Nat.primeCounting (2 ^ (2 * m)) : ℝ) - Stage3.Li (((2 ^ (2 * m) : ℕ) : ℝ)))
          - ((Nat.primeCounting (2 ^ m) : ℝ) - Stage3.Li (((2 ^ m : ℕ) : ℝ)))) := by
  have hN : 2 ≤ 2 ^ (2 * m) := by
    calc 2 = 2 ^ 1 := by norm_num
      _ ≤ 2 ^ (2 * m) := Nat.pow_le_pow_right (by norm_num) (by omega)
  have h := net_wobble (2 ^ (2 * m)) hN
  rw [sqrt_two_pow] at h
  exact h

/-- info: 'SieveResidual.net_wobble' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms net_wobble

/-- info: 'SieveResidual.net_wobble_rows' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms net_wobble_rows

end SieveResidual
