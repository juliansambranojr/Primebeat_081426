/-
PiRow23 — row 23 of the π list by Legendre's formula, `π(2^23) + 1 = φ(2^23, primes ≤ 2896) + π(2896)`.
`φ` is unrolled (`phi_add_peel`, `peel_eq_sum`) into 418 terms `F23 i`; each block file `PiL23_*` checks
`F23 i = W23 i` on its indices in one kernel evaluation, and the table `W23` is summed here.
-/
import PiL23_0
import PiL23_6
import PiL23_12
import PiL23_18
import PiL23_24
import PiL23_30
import PiL23_36
import PiL23_42
import PiL23_48
import PiL23_54
import PiL23_60
import PiL23_66
import PiL23_72
import PiL23_78
import PiL23_84
import PiL23_90
import PiL23_96
import PiL23_102
import PiL23_108
import PiL23_114
import PiL23_120
import PiL23_126
import PiL23_132
import PiL23_138
import PiL23_144
import PiL23_150
import PiL23_156
import PiL23_162
import PiL23_168
import PiL23_174
import PiL23_180
import PiL23_186
import PiL23_192
import PiL23_198
import PiL23_204
import PiL23_210
import PiL23_216
import PiL23_222
import PiL23_228
import PiL23_234
import PiL23_240
import PiL23_246
import PiL23_252
import PiL23_258
import PiL23_264
import PiL23_270
import PiL23_276
import PiL23_282
import PiL23_288
import PiL23_294
import PiL23_300
import PiL23_306
import PiL23_312
import PiL23_318
import PiL23_324
import PiL23_330
import PiL23_336
import PiL23_342
import PiL23_348
import PiL23_354
import PiL23_360
import PiL23_366
import PiL23_372
import PiL23_378
import PiL23_384
import PiL23_390
import PiL23_396
import PiL23_402
import PiL23_408
import PiL23_414
import PiRow22

namespace PiChunks
open Legendre

theorem pi_2896 : Nat.primeCounting 2896 = 418 := by
  rw [PiSieve.primeCounting_eq_cnt2]; decide +kernel

set_option maxRecDepth 20000 in
theorem F23_eq_W23 : ∀ i, i < 418 → F23 i = W23 i := by
  intro i hi
  if h0 : i < 6 then exact g23_0 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 12 then exact g23_6 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 18 then exact g23_12 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 24 then exact g23_18 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 30 then exact g23_24 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 36 then exact g23_30 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else if h6 : i < 42 then exact g23_36 i (Finset.mem_Ico.mpr ⟨by omega, h6⟩)
  else if h7 : i < 48 then exact g23_42 i (Finset.mem_Ico.mpr ⟨by omega, h7⟩)
  else if h8 : i < 54 then exact g23_48 i (Finset.mem_Ico.mpr ⟨by omega, h8⟩)
  else if h9 : i < 60 then exact g23_54 i (Finset.mem_Ico.mpr ⟨by omega, h9⟩)
  else if h10 : i < 66 then exact g23_60 i (Finset.mem_Ico.mpr ⟨by omega, h10⟩)
  else if h11 : i < 72 then exact g23_66 i (Finset.mem_Ico.mpr ⟨by omega, h11⟩)
  else if h12 : i < 78 then exact g23_72 i (Finset.mem_Ico.mpr ⟨by omega, h12⟩)
  else if h13 : i < 84 then exact g23_78 i (Finset.mem_Ico.mpr ⟨by omega, h13⟩)
  else if h14 : i < 90 then exact g23_84 i (Finset.mem_Ico.mpr ⟨by omega, h14⟩)
  else if h15 : i < 96 then exact g23_90 i (Finset.mem_Ico.mpr ⟨by omega, h15⟩)
  else if h16 : i < 102 then exact g23_96 i (Finset.mem_Ico.mpr ⟨by omega, h16⟩)
  else if h17 : i < 108 then exact g23_102 i (Finset.mem_Ico.mpr ⟨by omega, h17⟩)
  else if h18 : i < 114 then exact g23_108 i (Finset.mem_Ico.mpr ⟨by omega, h18⟩)
  else if h19 : i < 120 then exact g23_114 i (Finset.mem_Ico.mpr ⟨by omega, h19⟩)
  else if h20 : i < 126 then exact g23_120 i (Finset.mem_Ico.mpr ⟨by omega, h20⟩)
  else if h21 : i < 132 then exact g23_126 i (Finset.mem_Ico.mpr ⟨by omega, h21⟩)
  else if h22 : i < 138 then exact g23_132 i (Finset.mem_Ico.mpr ⟨by omega, h22⟩)
  else if h23 : i < 144 then exact g23_138 i (Finset.mem_Ico.mpr ⟨by omega, h23⟩)
  else if h24 : i < 150 then exact g23_144 i (Finset.mem_Ico.mpr ⟨by omega, h24⟩)
  else if h25 : i < 156 then exact g23_150 i (Finset.mem_Ico.mpr ⟨by omega, h25⟩)
  else if h26 : i < 162 then exact g23_156 i (Finset.mem_Ico.mpr ⟨by omega, h26⟩)
  else if h27 : i < 168 then exact g23_162 i (Finset.mem_Ico.mpr ⟨by omega, h27⟩)
  else if h28 : i < 174 then exact g23_168 i (Finset.mem_Ico.mpr ⟨by omega, h28⟩)
  else if h29 : i < 180 then exact g23_174 i (Finset.mem_Ico.mpr ⟨by omega, h29⟩)
  else if h30 : i < 186 then exact g23_180 i (Finset.mem_Ico.mpr ⟨by omega, h30⟩)
  else if h31 : i < 192 then exact g23_186 i (Finset.mem_Ico.mpr ⟨by omega, h31⟩)
  else if h32 : i < 198 then exact g23_192 i (Finset.mem_Ico.mpr ⟨by omega, h32⟩)
  else if h33 : i < 204 then exact g23_198 i (Finset.mem_Ico.mpr ⟨by omega, h33⟩)
  else if h34 : i < 210 then exact g23_204 i (Finset.mem_Ico.mpr ⟨by omega, h34⟩)
  else if h35 : i < 216 then exact g23_210 i (Finset.mem_Ico.mpr ⟨by omega, h35⟩)
  else if h36 : i < 222 then exact g23_216 i (Finset.mem_Ico.mpr ⟨by omega, h36⟩)
  else if h37 : i < 228 then exact g23_222 i (Finset.mem_Ico.mpr ⟨by omega, h37⟩)
  else if h38 : i < 234 then exact g23_228 i (Finset.mem_Ico.mpr ⟨by omega, h38⟩)
  else if h39 : i < 240 then exact g23_234 i (Finset.mem_Ico.mpr ⟨by omega, h39⟩)
  else if h40 : i < 246 then exact g23_240 i (Finset.mem_Ico.mpr ⟨by omega, h40⟩)
  else if h41 : i < 252 then exact g23_246 i (Finset.mem_Ico.mpr ⟨by omega, h41⟩)
  else if h42 : i < 258 then exact g23_252 i (Finset.mem_Ico.mpr ⟨by omega, h42⟩)
  else if h43 : i < 264 then exact g23_258 i (Finset.mem_Ico.mpr ⟨by omega, h43⟩)
  else if h44 : i < 270 then exact g23_264 i (Finset.mem_Ico.mpr ⟨by omega, h44⟩)
  else if h45 : i < 276 then exact g23_270 i (Finset.mem_Ico.mpr ⟨by omega, h45⟩)
  else if h46 : i < 282 then exact g23_276 i (Finset.mem_Ico.mpr ⟨by omega, h46⟩)
  else if h47 : i < 288 then exact g23_282 i (Finset.mem_Ico.mpr ⟨by omega, h47⟩)
  else if h48 : i < 294 then exact g23_288 i (Finset.mem_Ico.mpr ⟨by omega, h48⟩)
  else if h49 : i < 300 then exact g23_294 i (Finset.mem_Ico.mpr ⟨by omega, h49⟩)
  else if h50 : i < 306 then exact g23_300 i (Finset.mem_Ico.mpr ⟨by omega, h50⟩)
  else if h51 : i < 312 then exact g23_306 i (Finset.mem_Ico.mpr ⟨by omega, h51⟩)
  else if h52 : i < 318 then exact g23_312 i (Finset.mem_Ico.mpr ⟨by omega, h52⟩)
  else if h53 : i < 324 then exact g23_318 i (Finset.mem_Ico.mpr ⟨by omega, h53⟩)
  else if h54 : i < 330 then exact g23_324 i (Finset.mem_Ico.mpr ⟨by omega, h54⟩)
  else if h55 : i < 336 then exact g23_330 i (Finset.mem_Ico.mpr ⟨by omega, h55⟩)
  else if h56 : i < 342 then exact g23_336 i (Finset.mem_Ico.mpr ⟨by omega, h56⟩)
  else if h57 : i < 348 then exact g23_342 i (Finset.mem_Ico.mpr ⟨by omega, h57⟩)
  else if h58 : i < 354 then exact g23_348 i (Finset.mem_Ico.mpr ⟨by omega, h58⟩)
  else if h59 : i < 360 then exact g23_354 i (Finset.mem_Ico.mpr ⟨by omega, h59⟩)
  else if h60 : i < 366 then exact g23_360 i (Finset.mem_Ico.mpr ⟨by omega, h60⟩)
  else if h61 : i < 372 then exact g23_366 i (Finset.mem_Ico.mpr ⟨by omega, h61⟩)
  else if h62 : i < 378 then exact g23_372 i (Finset.mem_Ico.mpr ⟨by omega, h62⟩)
  else if h63 : i < 384 then exact g23_378 i (Finset.mem_Ico.mpr ⟨by omega, h63⟩)
  else if h64 : i < 390 then exact g23_384 i (Finset.mem_Ico.mpr ⟨by omega, h64⟩)
  else if h65 : i < 396 then exact g23_390 i (Finset.mem_Ico.mpr ⟨by omega, h65⟩)
  else if h66 : i < 402 then exact g23_396 i (Finset.mem_Ico.mpr ⟨by omega, h66⟩)
  else if h67 : i < 408 then exact g23_402 i (Finset.mem_Ico.mpr ⟨by omega, h67⟩)
  else if h68 : i < 414 then exact g23_408 i (Finset.mem_Ico.mpr ⟨by omega, h68⟩)
  else if h69 : i < 418 then exact g23_414 i (Finset.mem_Ico.mpr ⟨by omega, h69⟩)
  else omega

set_option maxHeartbeats 0 in
theorem pi23 : Nat.primeCounting (2 ^ 23) = 564163 := by
  have hpeel := phi_add_peel (primesTo 2896) (primesTo_prime 2896) (primesTo_nodup 2896) (x := 8388608) (by norm_num)
  have hsum := peel_eq_sum 8388608 (primesTo 2896)
  have hlen : (primesTo 2896).length = 418 := by decide +kernel
  rw [hlen] at hsum
  have hF : (∑ i ∈ Finset.range 418, phi (8388608 / (primesTo 2896).getD i 0) ((primesTo 2896).drop (i + 1)))
      = ∑ i ∈ Finset.range 418, F23 i := rfl
  have hW : ∑ i ∈ Finset.range 418, F23 i = ∑ i ∈ Finset.range 418, W23 i :=
    Finset.sum_congr rfl fun i hi => F23_eq_W23 i (Finset.mem_range.mp hi)
  have hV : ∑ i ∈ Finset.range 418, W23 i = 7824862 := by decide +kernel
  have hL := primeCounting_eq_phi (x := 8388608) (s := 2896) (by norm_num) (by norm_num) (by norm_num)
  rw [pi_2896] at hL
  rw [show (2 : ℕ) ^ 23 = 8388608 by norm_num]
  omega

/-- **`StmtPiData` on rows 0 … 23, proved.** -/
theorem piData_le23 : ∀ n : Nat, n ≤ 23 →
    (DepthSix.piTwoPow.getD n 0 : Int) = (Nat.primeCounting (2 ^ n) : Int) := by
  intro n hn
  rcases Nat.lt_or_ge n 23 with h | h
  · exact piData_le22 n (by omega)
  · have : n = 23 := by omega
    subst this; rw [pi23]; decide

end PiChunks

/-- info: 'PiChunks.piData_le23' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PiChunks.piData_le23
