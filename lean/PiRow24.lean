/-
PiRow24 — row 24 of the π list by Legendre's formula, `π(2^24) + 1 = φ(2^24, primes ≤ 4096) + π(4096)`.
`φ` is unrolled (`phi_add_peel`, `peel_eq_sum`) into 564 terms `F24 i`; each block file `PiL24_*` checks
`F24 i = W24 i` on its indices in one kernel evaluation, and the table `W24` is summed here.
-/
import PiL24_0
import PiL24_6
import PiL24_12
import PiL24_18
import PiL24_24
import PiL24_30
import PiL24_36
import PiL24_42
import PiL24_48
import PiL24_54
import PiL24_60
import PiL24_66
import PiL24_72
import PiL24_78
import PiL24_84
import PiL24_90
import PiL24_96
import PiL24_102
import PiL24_108
import PiL24_114
import PiL24_120
import PiL24_126
import PiL24_132
import PiL24_138
import PiL24_144
import PiL24_150
import PiL24_156
import PiL24_162
import PiL24_168
import PiL24_174
import PiL24_180
import PiL24_186
import PiL24_192
import PiL24_198
import PiL24_204
import PiL24_210
import PiL24_216
import PiL24_222
import PiL24_228
import PiL24_234
import PiL24_240
import PiL24_246
import PiL24_252
import PiL24_258
import PiL24_264
import PiL24_270
import PiL24_276
import PiL24_282
import PiL24_288
import PiL24_294
import PiL24_300
import PiL24_306
import PiL24_312
import PiL24_318
import PiL24_324
import PiL24_330
import PiL24_336
import PiL24_342
import PiL24_348
import PiL24_354
import PiL24_360
import PiL24_366
import PiL24_372
import PiL24_378
import PiL24_384
import PiL24_390
import PiL24_396
import PiL24_402
import PiL24_408
import PiL24_414
import PiL24_420
import PiL24_426
import PiL24_432
import PiL24_438
import PiL24_444
import PiL24_450
import PiL24_456
import PiL24_462
import PiL24_468
import PiL24_474
import PiL24_480
import PiL24_486
import PiL24_492
import PiL24_498
import PiL24_504
import PiL24_510
import PiL24_516
import PiL24_522
import PiL24_528
import PiL24_534
import PiL24_540
import PiL24_546
import PiL24_552
import PiL24_558
import PiRow23

namespace PiChunks
open Legendre

theorem pi_4096 : Nat.primeCounting 4096 = 564 := by
  rw [PiSieve.primeCounting_eq_cnt2]; decide +kernel

set_option maxRecDepth 20000 in
theorem F24_eq_W24 : ∀ i, i < 564 → F24 i = W24 i := by
  intro i hi
  if h0 : i < 6 then exact g24_0 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 12 then exact g24_6 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 18 then exact g24_12 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 24 then exact g24_18 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 30 then exact g24_24 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 36 then exact g24_30 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else if h6 : i < 42 then exact g24_36 i (Finset.mem_Ico.mpr ⟨by omega, h6⟩)
  else if h7 : i < 48 then exact g24_42 i (Finset.mem_Ico.mpr ⟨by omega, h7⟩)
  else if h8 : i < 54 then exact g24_48 i (Finset.mem_Ico.mpr ⟨by omega, h8⟩)
  else if h9 : i < 60 then exact g24_54 i (Finset.mem_Ico.mpr ⟨by omega, h9⟩)
  else if h10 : i < 66 then exact g24_60 i (Finset.mem_Ico.mpr ⟨by omega, h10⟩)
  else if h11 : i < 72 then exact g24_66 i (Finset.mem_Ico.mpr ⟨by omega, h11⟩)
  else if h12 : i < 78 then exact g24_72 i (Finset.mem_Ico.mpr ⟨by omega, h12⟩)
  else if h13 : i < 84 then exact g24_78 i (Finset.mem_Ico.mpr ⟨by omega, h13⟩)
  else if h14 : i < 90 then exact g24_84 i (Finset.mem_Ico.mpr ⟨by omega, h14⟩)
  else if h15 : i < 96 then exact g24_90 i (Finset.mem_Ico.mpr ⟨by omega, h15⟩)
  else if h16 : i < 102 then exact g24_96 i (Finset.mem_Ico.mpr ⟨by omega, h16⟩)
  else if h17 : i < 108 then exact g24_102 i (Finset.mem_Ico.mpr ⟨by omega, h17⟩)
  else if h18 : i < 114 then exact g24_108 i (Finset.mem_Ico.mpr ⟨by omega, h18⟩)
  else if h19 : i < 120 then exact g24_114 i (Finset.mem_Ico.mpr ⟨by omega, h19⟩)
  else if h20 : i < 126 then exact g24_120 i (Finset.mem_Ico.mpr ⟨by omega, h20⟩)
  else if h21 : i < 132 then exact g24_126 i (Finset.mem_Ico.mpr ⟨by omega, h21⟩)
  else if h22 : i < 138 then exact g24_132 i (Finset.mem_Ico.mpr ⟨by omega, h22⟩)
  else if h23 : i < 144 then exact g24_138 i (Finset.mem_Ico.mpr ⟨by omega, h23⟩)
  else if h24 : i < 150 then exact g24_144 i (Finset.mem_Ico.mpr ⟨by omega, h24⟩)
  else if h25 : i < 156 then exact g24_150 i (Finset.mem_Ico.mpr ⟨by omega, h25⟩)
  else if h26 : i < 162 then exact g24_156 i (Finset.mem_Ico.mpr ⟨by omega, h26⟩)
  else if h27 : i < 168 then exact g24_162 i (Finset.mem_Ico.mpr ⟨by omega, h27⟩)
  else if h28 : i < 174 then exact g24_168 i (Finset.mem_Ico.mpr ⟨by omega, h28⟩)
  else if h29 : i < 180 then exact g24_174 i (Finset.mem_Ico.mpr ⟨by omega, h29⟩)
  else if h30 : i < 186 then exact g24_180 i (Finset.mem_Ico.mpr ⟨by omega, h30⟩)
  else if h31 : i < 192 then exact g24_186 i (Finset.mem_Ico.mpr ⟨by omega, h31⟩)
  else if h32 : i < 198 then exact g24_192 i (Finset.mem_Ico.mpr ⟨by omega, h32⟩)
  else if h33 : i < 204 then exact g24_198 i (Finset.mem_Ico.mpr ⟨by omega, h33⟩)
  else if h34 : i < 210 then exact g24_204 i (Finset.mem_Ico.mpr ⟨by omega, h34⟩)
  else if h35 : i < 216 then exact g24_210 i (Finset.mem_Ico.mpr ⟨by omega, h35⟩)
  else if h36 : i < 222 then exact g24_216 i (Finset.mem_Ico.mpr ⟨by omega, h36⟩)
  else if h37 : i < 228 then exact g24_222 i (Finset.mem_Ico.mpr ⟨by omega, h37⟩)
  else if h38 : i < 234 then exact g24_228 i (Finset.mem_Ico.mpr ⟨by omega, h38⟩)
  else if h39 : i < 240 then exact g24_234 i (Finset.mem_Ico.mpr ⟨by omega, h39⟩)
  else if h40 : i < 246 then exact g24_240 i (Finset.mem_Ico.mpr ⟨by omega, h40⟩)
  else if h41 : i < 252 then exact g24_246 i (Finset.mem_Ico.mpr ⟨by omega, h41⟩)
  else if h42 : i < 258 then exact g24_252 i (Finset.mem_Ico.mpr ⟨by omega, h42⟩)
  else if h43 : i < 264 then exact g24_258 i (Finset.mem_Ico.mpr ⟨by omega, h43⟩)
  else if h44 : i < 270 then exact g24_264 i (Finset.mem_Ico.mpr ⟨by omega, h44⟩)
  else if h45 : i < 276 then exact g24_270 i (Finset.mem_Ico.mpr ⟨by omega, h45⟩)
  else if h46 : i < 282 then exact g24_276 i (Finset.mem_Ico.mpr ⟨by omega, h46⟩)
  else if h47 : i < 288 then exact g24_282 i (Finset.mem_Ico.mpr ⟨by omega, h47⟩)
  else if h48 : i < 294 then exact g24_288 i (Finset.mem_Ico.mpr ⟨by omega, h48⟩)
  else if h49 : i < 300 then exact g24_294 i (Finset.mem_Ico.mpr ⟨by omega, h49⟩)
  else if h50 : i < 306 then exact g24_300 i (Finset.mem_Ico.mpr ⟨by omega, h50⟩)
  else if h51 : i < 312 then exact g24_306 i (Finset.mem_Ico.mpr ⟨by omega, h51⟩)
  else if h52 : i < 318 then exact g24_312 i (Finset.mem_Ico.mpr ⟨by omega, h52⟩)
  else if h53 : i < 324 then exact g24_318 i (Finset.mem_Ico.mpr ⟨by omega, h53⟩)
  else if h54 : i < 330 then exact g24_324 i (Finset.mem_Ico.mpr ⟨by omega, h54⟩)
  else if h55 : i < 336 then exact g24_330 i (Finset.mem_Ico.mpr ⟨by omega, h55⟩)
  else if h56 : i < 342 then exact g24_336 i (Finset.mem_Ico.mpr ⟨by omega, h56⟩)
  else if h57 : i < 348 then exact g24_342 i (Finset.mem_Ico.mpr ⟨by omega, h57⟩)
  else if h58 : i < 354 then exact g24_348 i (Finset.mem_Ico.mpr ⟨by omega, h58⟩)
  else if h59 : i < 360 then exact g24_354 i (Finset.mem_Ico.mpr ⟨by omega, h59⟩)
  else if h60 : i < 366 then exact g24_360 i (Finset.mem_Ico.mpr ⟨by omega, h60⟩)
  else if h61 : i < 372 then exact g24_366 i (Finset.mem_Ico.mpr ⟨by omega, h61⟩)
  else if h62 : i < 378 then exact g24_372 i (Finset.mem_Ico.mpr ⟨by omega, h62⟩)
  else if h63 : i < 384 then exact g24_378 i (Finset.mem_Ico.mpr ⟨by omega, h63⟩)
  else if h64 : i < 390 then exact g24_384 i (Finset.mem_Ico.mpr ⟨by omega, h64⟩)
  else if h65 : i < 396 then exact g24_390 i (Finset.mem_Ico.mpr ⟨by omega, h65⟩)
  else if h66 : i < 402 then exact g24_396 i (Finset.mem_Ico.mpr ⟨by omega, h66⟩)
  else if h67 : i < 408 then exact g24_402 i (Finset.mem_Ico.mpr ⟨by omega, h67⟩)
  else if h68 : i < 414 then exact g24_408 i (Finset.mem_Ico.mpr ⟨by omega, h68⟩)
  else if h69 : i < 420 then exact g24_414 i (Finset.mem_Ico.mpr ⟨by omega, h69⟩)
  else if h70 : i < 426 then exact g24_420 i (Finset.mem_Ico.mpr ⟨by omega, h70⟩)
  else if h71 : i < 432 then exact g24_426 i (Finset.mem_Ico.mpr ⟨by omega, h71⟩)
  else if h72 : i < 438 then exact g24_432 i (Finset.mem_Ico.mpr ⟨by omega, h72⟩)
  else if h73 : i < 444 then exact g24_438 i (Finset.mem_Ico.mpr ⟨by omega, h73⟩)
  else if h74 : i < 450 then exact g24_444 i (Finset.mem_Ico.mpr ⟨by omega, h74⟩)
  else if h75 : i < 456 then exact g24_450 i (Finset.mem_Ico.mpr ⟨by omega, h75⟩)
  else if h76 : i < 462 then exact g24_456 i (Finset.mem_Ico.mpr ⟨by omega, h76⟩)
  else if h77 : i < 468 then exact g24_462 i (Finset.mem_Ico.mpr ⟨by omega, h77⟩)
  else if h78 : i < 474 then exact g24_468 i (Finset.mem_Ico.mpr ⟨by omega, h78⟩)
  else if h79 : i < 480 then exact g24_474 i (Finset.mem_Ico.mpr ⟨by omega, h79⟩)
  else if h80 : i < 486 then exact g24_480 i (Finset.mem_Ico.mpr ⟨by omega, h80⟩)
  else if h81 : i < 492 then exact g24_486 i (Finset.mem_Ico.mpr ⟨by omega, h81⟩)
  else if h82 : i < 498 then exact g24_492 i (Finset.mem_Ico.mpr ⟨by omega, h82⟩)
  else if h83 : i < 504 then exact g24_498 i (Finset.mem_Ico.mpr ⟨by omega, h83⟩)
  else if h84 : i < 510 then exact g24_504 i (Finset.mem_Ico.mpr ⟨by omega, h84⟩)
  else if h85 : i < 516 then exact g24_510 i (Finset.mem_Ico.mpr ⟨by omega, h85⟩)
  else if h86 : i < 522 then exact g24_516 i (Finset.mem_Ico.mpr ⟨by omega, h86⟩)
  else if h87 : i < 528 then exact g24_522 i (Finset.mem_Ico.mpr ⟨by omega, h87⟩)
  else if h88 : i < 534 then exact g24_528 i (Finset.mem_Ico.mpr ⟨by omega, h88⟩)
  else if h89 : i < 540 then exact g24_534 i (Finset.mem_Ico.mpr ⟨by omega, h89⟩)
  else if h90 : i < 546 then exact g24_540 i (Finset.mem_Ico.mpr ⟨by omega, h90⟩)
  else if h91 : i < 552 then exact g24_546 i (Finset.mem_Ico.mpr ⟨by omega, h91⟩)
  else if h92 : i < 558 then exact g24_552 i (Finset.mem_Ico.mpr ⟨by omega, h92⟩)
  else if h93 : i < 564 then exact g24_558 i (Finset.mem_Ico.mpr ⟨by omega, h93⟩)
  else omega

set_option maxHeartbeats 0 in
theorem pi24 : Nat.primeCounting (2 ^ 24) = 1077871 := by
  have hpeel := phi_add_peel (primesTo 4096) (primesTo_prime 4096) (primesTo_nodup 4096) (x := 16777216) (by norm_num)
  have hsum := peel_eq_sum 16777216 (primesTo 4096)
  have hlen : (primesTo 4096).length = 564 := by decide +kernel
  rw [hlen] at hsum
  have hF : (∑ i ∈ Finset.range 564, phi (16777216 / (primesTo 4096).getD i 0) ((primesTo 4096).drop (i + 1)))
      = ∑ i ∈ Finset.range 564, F24 i := rfl
  have hW : ∑ i ∈ Finset.range 564, F24 i = ∑ i ∈ Finset.range 564, W24 i :=
    Finset.sum_congr rfl fun i hi => F24_eq_W24 i (Finset.mem_range.mp hi)
  have hV : ∑ i ∈ Finset.range 564, W24 i = 15699908 := by decide +kernel
  have hL := primeCounting_eq_phi (x := 16777216) (s := 4096) (by norm_num) (by norm_num) (by norm_num)
  rw [pi_4096] at hL
  rw [show (2 : ℕ) ^ 24 = 16777216 by norm_num]
  omega

/-- **`StmtPiData` on rows 0 … 24, proved.** -/
theorem piData_le24 : ∀ n : Nat, n ≤ 24 →
    (DepthSix.piTwoPow.getD n 0 : Int) = (Nat.primeCounting (2 ^ n) : Int) := by
  intro n hn
  rcases Nat.lt_or_ge n 24 with h | h
  · exact piData_le23 n (by omega)
  · have : n = 24 := by omega
    subst this; rw [pi24]; decide

end PiChunks

/-- info: 'PiChunks.piData_le24' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PiChunks.piData_le24
