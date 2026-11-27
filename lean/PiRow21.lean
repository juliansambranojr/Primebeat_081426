/-
PiRow21 — row 21 of the π list by Legendre's formula, `π(2^21) + 1 = φ(2^21, primes ≤ 1448) + π(1448)`.
`φ` is unrolled (`phi_add_peel`, `peel_eq_sum`) into 229 terms `F21 i`; each block file `PiL21_*` checks
`F21 i = W21 i` on its indices in one kernel evaluation, and the table `W21` is summed here.
-/
import PiL21_0
import PiL21_20
import PiL21_40
import PiL21_60
import PiL21_80
import PiL21_100
import PiL21_120
import PiL21_140
import PiL21_160
import PiL21_180
import PiL21_200
import PiL21_220
import PiRow20

namespace PiChunks
open Legendre

theorem pi_1448 : Nat.primeCounting 1448 = 229 := by
  rw [PiSieve.primeCounting_eq_cnt2]; decide +kernel

theorem F21_eq_W21 : ∀ i, i < 229 → F21 i = W21 i := by
  intro i hi
  if h0 : i < 20 then exact g21_0 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 40 then exact g21_20 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 60 then exact g21_40 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 80 then exact g21_60 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 100 then exact g21_80 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 120 then exact g21_100 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else if h6 : i < 140 then exact g21_120 i (Finset.mem_Ico.mpr ⟨by omega, h6⟩)
  else if h7 : i < 160 then exact g21_140 i (Finset.mem_Ico.mpr ⟨by omega, h7⟩)
  else if h8 : i < 180 then exact g21_160 i (Finset.mem_Ico.mpr ⟨by omega, h8⟩)
  else if h9 : i < 200 then exact g21_180 i (Finset.mem_Ico.mpr ⟨by omega, h9⟩)
  else if h10 : i < 220 then exact g21_200 i (Finset.mem_Ico.mpr ⟨by omega, h10⟩)
  else if h11 : i < 229 then exact g21_220 i (Finset.mem_Ico.mpr ⟨by omega, h11⟩)
  else omega

set_option maxHeartbeats 0 in
theorem pi21 : Nat.primeCounting (2 ^ 21) = 155611 := by
  have hpeel := phi_add_peel (primesTo 1448) (primesTo_prime 1448) (primesTo_nodup 1448) (x := 2097152) (by norm_num)
  have hsum := peel_eq_sum 2097152 (primesTo 1448)
  have hlen : (primesTo 1448).length = 229 := by decide +kernel
  rw [hlen] at hsum
  have hF : (∑ i ∈ Finset.range 229, phi (2097152 / (primesTo 1448).getD i 0) ((primesTo 1448).drop (i + 1)))
      = ∑ i ∈ Finset.range 229, F21 i := rfl
  have hW : ∑ i ∈ Finset.range 229, F21 i = ∑ i ∈ Finset.range 229, W21 i :=
    Finset.sum_congr rfl fun i hi => F21_eq_W21 i (Finset.mem_range.mp hi)
  have hV : ∑ i ∈ Finset.range 229, W21 i = 1941769 := by decide +kernel
  have hL := primeCounting_eq_phi (x := 2097152) (s := 1448) (by norm_num) (by norm_num) (by norm_num)
  rw [pi_1448] at hL
  rw [show (2 : ℕ) ^ 21 = 2097152 by norm_num]
  omega

/-- **`StmtPiData` on rows 0 … 21, proved.** -/
theorem piData_le21 : ∀ n : Nat, n ≤ 21 →
    (DepthSix.piTwoPow.getD n 0 : Int) = (Nat.primeCounting (2 ^ n) : Int) := by
  intro n hn
  rcases Nat.lt_or_ge n 21 with h | h
  · exact piData_le20 n (by omega)
  · have : n = 21 := by omega
    subst this; rw [pi21]; decide

end PiChunks

/-- info: 'PiChunks.piData_le21' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PiChunks.piData_le21
