/-
PiRow22 — row 22 of the π list by Legendre's formula, `π(2^22) + 1 = φ(2^22, primes ≤ 2048) + π(2048)`.
`φ` is unrolled (`phi_add_peel`, `peel_eq_sum`) into 309 terms `F22 i`; each block file `PiL22_*` checks
`F22 i = W22 i` on its indices in one kernel evaluation, and the table `W22` is summed here.
-/
import PiL22_0
import PiL22_8
import PiL22_16
import PiL22_24
import PiL22_32
import PiL22_40
import PiL22_48
import PiL22_56
import PiL22_64
import PiL22_72
import PiL22_80
import PiL22_88
import PiL22_96
import PiL22_104
import PiL22_112
import PiL22_120
import PiL22_128
import PiL22_136
import PiL22_144
import PiL22_152
import PiL22_160
import PiL22_168
import PiL22_176
import PiL22_184
import PiL22_192
import PiL22_200
import PiL22_208
import PiL22_216
import PiL22_224
import PiL22_232
import PiL22_240
import PiL22_248
import PiL22_256
import PiL22_264
import PiL22_272
import PiL22_280
import PiL22_288
import PiL22_296
import PiL22_304
import PiRow21

namespace PiChunks
open Legendre

theorem pi_2048 : Nat.primeCounting 2048 = 309 := by
  rw [PiSieve.primeCounting_eq_cnt2]; decide +kernel

theorem F22_eq_W22 : ∀ i, i < 309 → F22 i = W22 i := by
  intro i hi
  if h0 : i < 8 then exact g22_0 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 16 then exact g22_8 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 24 then exact g22_16 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 32 then exact g22_24 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 40 then exact g22_32 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 48 then exact g22_40 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else if h6 : i < 56 then exact g22_48 i (Finset.mem_Ico.mpr ⟨by omega, h6⟩)
  else if h7 : i < 64 then exact g22_56 i (Finset.mem_Ico.mpr ⟨by omega, h7⟩)
  else if h8 : i < 72 then exact g22_64 i (Finset.mem_Ico.mpr ⟨by omega, h8⟩)
  else if h9 : i < 80 then exact g22_72 i (Finset.mem_Ico.mpr ⟨by omega, h9⟩)
  else if h10 : i < 88 then exact g22_80 i (Finset.mem_Ico.mpr ⟨by omega, h10⟩)
  else if h11 : i < 96 then exact g22_88 i (Finset.mem_Ico.mpr ⟨by omega, h11⟩)
  else if h12 : i < 104 then exact g22_96 i (Finset.mem_Ico.mpr ⟨by omega, h12⟩)
  else if h13 : i < 112 then exact g22_104 i (Finset.mem_Ico.mpr ⟨by omega, h13⟩)
  else if h14 : i < 120 then exact g22_112 i (Finset.mem_Ico.mpr ⟨by omega, h14⟩)
  else if h15 : i < 128 then exact g22_120 i (Finset.mem_Ico.mpr ⟨by omega, h15⟩)
  else if h16 : i < 136 then exact g22_128 i (Finset.mem_Ico.mpr ⟨by omega, h16⟩)
  else if h17 : i < 144 then exact g22_136 i (Finset.mem_Ico.mpr ⟨by omega, h17⟩)
  else if h18 : i < 152 then exact g22_144 i (Finset.mem_Ico.mpr ⟨by omega, h18⟩)
  else if h19 : i < 160 then exact g22_152 i (Finset.mem_Ico.mpr ⟨by omega, h19⟩)
  else if h20 : i < 168 then exact g22_160 i (Finset.mem_Ico.mpr ⟨by omega, h20⟩)
  else if h21 : i < 176 then exact g22_168 i (Finset.mem_Ico.mpr ⟨by omega, h21⟩)
  else if h22 : i < 184 then exact g22_176 i (Finset.mem_Ico.mpr ⟨by omega, h22⟩)
  else if h23 : i < 192 then exact g22_184 i (Finset.mem_Ico.mpr ⟨by omega, h23⟩)
  else if h24 : i < 200 then exact g22_192 i (Finset.mem_Ico.mpr ⟨by omega, h24⟩)
  else if h25 : i < 208 then exact g22_200 i (Finset.mem_Ico.mpr ⟨by omega, h25⟩)
  else if h26 : i < 216 then exact g22_208 i (Finset.mem_Ico.mpr ⟨by omega, h26⟩)
  else if h27 : i < 224 then exact g22_216 i (Finset.mem_Ico.mpr ⟨by omega, h27⟩)
  else if h28 : i < 232 then exact g22_224 i (Finset.mem_Ico.mpr ⟨by omega, h28⟩)
  else if h29 : i < 240 then exact g22_232 i (Finset.mem_Ico.mpr ⟨by omega, h29⟩)
  else if h30 : i < 248 then exact g22_240 i (Finset.mem_Ico.mpr ⟨by omega, h30⟩)
  else if h31 : i < 256 then exact g22_248 i (Finset.mem_Ico.mpr ⟨by omega, h31⟩)
  else if h32 : i < 264 then exact g22_256 i (Finset.mem_Ico.mpr ⟨by omega, h32⟩)
  else if h33 : i < 272 then exact g22_264 i (Finset.mem_Ico.mpr ⟨by omega, h33⟩)
  else if h34 : i < 280 then exact g22_272 i (Finset.mem_Ico.mpr ⟨by omega, h34⟩)
  else if h35 : i < 288 then exact g22_280 i (Finset.mem_Ico.mpr ⟨by omega, h35⟩)
  else if h36 : i < 296 then exact g22_288 i (Finset.mem_Ico.mpr ⟨by omega, h36⟩)
  else if h37 : i < 304 then exact g22_296 i (Finset.mem_Ico.mpr ⟨by omega, h37⟩)
  else if h38 : i < 309 then exact g22_304 i (Finset.mem_Ico.mpr ⟨by omega, h38⟩)
  else omega

set_option maxHeartbeats 0 in
theorem pi22 : Nat.primeCounting (2 ^ 22) = 295947 := by
  have hpeel := phi_add_peel (primesTo 2048) (primesTo_prime 2048) (primesTo_nodup 2048) (x := 4194304) (by norm_num)
  have hsum := peel_eq_sum 4194304 (primesTo 2048)
  have hlen : (primesTo 2048).length = 309 := by decide +kernel
  rw [hlen] at hsum
  have hF : (∑ i ∈ Finset.range 309, phi (4194304 / (primesTo 2048).getD i 0) ((primesTo 2048).drop (i + 1)))
      = ∑ i ∈ Finset.range 309, F22 i := rfl
  have hW : ∑ i ∈ Finset.range 309, F22 i = ∑ i ∈ Finset.range 309, W22 i :=
    Finset.sum_congr rfl fun i hi => F22_eq_W22 i (Finset.mem_range.mp hi)
  have hV : ∑ i ∈ Finset.range 309, W22 i = 3898665 := by decide +kernel
  have hL := primeCounting_eq_phi (x := 4194304) (s := 2048) (by norm_num) (by norm_num) (by norm_num)
  rw [pi_2048] at hL
  rw [show (2 : ℕ) ^ 22 = 4194304 by norm_num]
  omega

/-- **`StmtPiData` on rows 0 … 22, proved.** -/
theorem piData_le22 : ∀ n : Nat, n ≤ 22 →
    (DepthSix.piTwoPow.getD n 0 : Int) = (Nat.primeCounting (2 ^ n) : Int) := by
  intro n hn
  rcases Nat.lt_or_ge n 22 with h | h
  · exact piData_le21 n (by omega)
  · have : n = 22 := by omega
    subst this; rw [pi22]; decide

end PiChunks

/-- info: 'PiChunks.piData_le22' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PiChunks.piData_le22
