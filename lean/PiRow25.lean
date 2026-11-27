/-
PiRow25 — row 25 of the π list by Legendre's formula, `π(2^25) + 1 = φ(2^25, primes ≤ 5792) + π(5792)`.
`φ` is unrolled (`phi_add_peel`, `peel_eq_sum`) into 760 terms `F25 i`; each block file `PiL25_*` checks
`F25 i = W25 i` on its indices in one kernel evaluation, and the table `W25` is summed here.
-/
import PiL25_0
import PiL25_6
import PiL25_12
import PiL25_18
import PiL25_24
import PiL25_30
import PiL25_36
import PiL25_42
import PiL25_48
import PiL25_54
import PiL25_60
import PiL25_66
import PiL25_72
import PiL25_78
import PiL25_84
import PiL25_90
import PiL25_96
import PiL25_102
import PiL25_108
import PiL25_114
import PiL25_120
import PiL25_126
import PiL25_132
import PiL25_138
import PiL25_144
import PiL25_150
import PiL25_156
import PiL25_162
import PiL25_168
import PiL25_174
import PiL25_180
import PiL25_186
import PiL25_192
import PiL25_198
import PiL25_204
import PiL25_210
import PiL25_216
import PiL25_222
import PiL25_228
import PiL25_234
import PiL25_240
import PiL25_246
import PiL25_252
import PiL25_258
import PiL25_264
import PiL25_270
import PiL25_276
import PiL25_282
import PiL25_288
import PiL25_294
import PiL25_300
import PiL25_306
import PiL25_312
import PiL25_318
import PiL25_324
import PiL25_330
import PiL25_336
import PiL25_342
import PiL25_348
import PiL25_354
import PiL25_360
import PiL25_366
import PiL25_372
import PiL25_378
import PiL25_384
import PiL25_390
import PiL25_396
import PiL25_402
import PiL25_408
import PiL25_414
import PiL25_420
import PiL25_426
import PiL25_432
import PiL25_438
import PiL25_444
import PiL25_450
import PiL25_456
import PiL25_462
import PiL25_468
import PiL25_474
import PiL25_480
import PiL25_486
import PiL25_492
import PiL25_498
import PiL25_504
import PiL25_510
import PiL25_516
import PiL25_522
import PiL25_528
import PiL25_534
import PiL25_540
import PiL25_546
import PiL25_552
import PiL25_558
import PiL25_564
import PiL25_570
import PiL25_576
import PiL25_582
import PiL25_588
import PiL25_594
import PiL25_600
import PiL25_606
import PiL25_612
import PiL25_618
import PiL25_624
import PiL25_630
import PiL25_636
import PiL25_642
import PiL25_648
import PiL25_654
import PiL25_660
import PiL25_666
import PiL25_672
import PiL25_678
import PiL25_684
import PiL25_690
import PiL25_696
import PiL25_702
import PiL25_708
import PiL25_714
import PiL25_720
import PiL25_726
import PiL25_732
import PiL25_738
import PiL25_744
import PiL25_750
import PiL25_756
import PiRow24

namespace PiChunks
open Legendre

theorem pi_5792 : Nat.primeCounting 5792 = 760 := by
  rw [PiSieve.primeCounting_eq_cnt2]; decide +kernel

set_option maxRecDepth 20000 in
theorem F25_eq_W25 : ∀ i, i < 760 → F25 i = W25 i := by
  intro i hi
  if h0 : i < 6 then exact g25_0 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 12 then exact g25_6 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 18 then exact g25_12 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 24 then exact g25_18 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 30 then exact g25_24 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 36 then exact g25_30 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else if h6 : i < 42 then exact g25_36 i (Finset.mem_Ico.mpr ⟨by omega, h6⟩)
  else if h7 : i < 48 then exact g25_42 i (Finset.mem_Ico.mpr ⟨by omega, h7⟩)
  else if h8 : i < 54 then exact g25_48 i (Finset.mem_Ico.mpr ⟨by omega, h8⟩)
  else if h9 : i < 60 then exact g25_54 i (Finset.mem_Ico.mpr ⟨by omega, h9⟩)
  else if h10 : i < 66 then exact g25_60 i (Finset.mem_Ico.mpr ⟨by omega, h10⟩)
  else if h11 : i < 72 then exact g25_66 i (Finset.mem_Ico.mpr ⟨by omega, h11⟩)
  else if h12 : i < 78 then exact g25_72 i (Finset.mem_Ico.mpr ⟨by omega, h12⟩)
  else if h13 : i < 84 then exact g25_78 i (Finset.mem_Ico.mpr ⟨by omega, h13⟩)
  else if h14 : i < 90 then exact g25_84 i (Finset.mem_Ico.mpr ⟨by omega, h14⟩)
  else if h15 : i < 96 then exact g25_90 i (Finset.mem_Ico.mpr ⟨by omega, h15⟩)
  else if h16 : i < 102 then exact g25_96 i (Finset.mem_Ico.mpr ⟨by omega, h16⟩)
  else if h17 : i < 108 then exact g25_102 i (Finset.mem_Ico.mpr ⟨by omega, h17⟩)
  else if h18 : i < 114 then exact g25_108 i (Finset.mem_Ico.mpr ⟨by omega, h18⟩)
  else if h19 : i < 120 then exact g25_114 i (Finset.mem_Ico.mpr ⟨by omega, h19⟩)
  else if h20 : i < 126 then exact g25_120 i (Finset.mem_Ico.mpr ⟨by omega, h20⟩)
  else if h21 : i < 132 then exact g25_126 i (Finset.mem_Ico.mpr ⟨by omega, h21⟩)
  else if h22 : i < 138 then exact g25_132 i (Finset.mem_Ico.mpr ⟨by omega, h22⟩)
  else if h23 : i < 144 then exact g25_138 i (Finset.mem_Ico.mpr ⟨by omega, h23⟩)
  else if h24 : i < 150 then exact g25_144 i (Finset.mem_Ico.mpr ⟨by omega, h24⟩)
  else if h25 : i < 156 then exact g25_150 i (Finset.mem_Ico.mpr ⟨by omega, h25⟩)
  else if h26 : i < 162 then exact g25_156 i (Finset.mem_Ico.mpr ⟨by omega, h26⟩)
  else if h27 : i < 168 then exact g25_162 i (Finset.mem_Ico.mpr ⟨by omega, h27⟩)
  else if h28 : i < 174 then exact g25_168 i (Finset.mem_Ico.mpr ⟨by omega, h28⟩)
  else if h29 : i < 180 then exact g25_174 i (Finset.mem_Ico.mpr ⟨by omega, h29⟩)
  else if h30 : i < 186 then exact g25_180 i (Finset.mem_Ico.mpr ⟨by omega, h30⟩)
  else if h31 : i < 192 then exact g25_186 i (Finset.mem_Ico.mpr ⟨by omega, h31⟩)
  else if h32 : i < 198 then exact g25_192 i (Finset.mem_Ico.mpr ⟨by omega, h32⟩)
  else if h33 : i < 204 then exact g25_198 i (Finset.mem_Ico.mpr ⟨by omega, h33⟩)
  else if h34 : i < 210 then exact g25_204 i (Finset.mem_Ico.mpr ⟨by omega, h34⟩)
  else if h35 : i < 216 then exact g25_210 i (Finset.mem_Ico.mpr ⟨by omega, h35⟩)
  else if h36 : i < 222 then exact g25_216 i (Finset.mem_Ico.mpr ⟨by omega, h36⟩)
  else if h37 : i < 228 then exact g25_222 i (Finset.mem_Ico.mpr ⟨by omega, h37⟩)
  else if h38 : i < 234 then exact g25_228 i (Finset.mem_Ico.mpr ⟨by omega, h38⟩)
  else if h39 : i < 240 then exact g25_234 i (Finset.mem_Ico.mpr ⟨by omega, h39⟩)
  else if h40 : i < 246 then exact g25_240 i (Finset.mem_Ico.mpr ⟨by omega, h40⟩)
  else if h41 : i < 252 then exact g25_246 i (Finset.mem_Ico.mpr ⟨by omega, h41⟩)
  else if h42 : i < 258 then exact g25_252 i (Finset.mem_Ico.mpr ⟨by omega, h42⟩)
  else if h43 : i < 264 then exact g25_258 i (Finset.mem_Ico.mpr ⟨by omega, h43⟩)
  else if h44 : i < 270 then exact g25_264 i (Finset.mem_Ico.mpr ⟨by omega, h44⟩)
  else if h45 : i < 276 then exact g25_270 i (Finset.mem_Ico.mpr ⟨by omega, h45⟩)
  else if h46 : i < 282 then exact g25_276 i (Finset.mem_Ico.mpr ⟨by omega, h46⟩)
  else if h47 : i < 288 then exact g25_282 i (Finset.mem_Ico.mpr ⟨by omega, h47⟩)
  else if h48 : i < 294 then exact g25_288 i (Finset.mem_Ico.mpr ⟨by omega, h48⟩)
  else if h49 : i < 300 then exact g25_294 i (Finset.mem_Ico.mpr ⟨by omega, h49⟩)
  else if h50 : i < 306 then exact g25_300 i (Finset.mem_Ico.mpr ⟨by omega, h50⟩)
  else if h51 : i < 312 then exact g25_306 i (Finset.mem_Ico.mpr ⟨by omega, h51⟩)
  else if h52 : i < 318 then exact g25_312 i (Finset.mem_Ico.mpr ⟨by omega, h52⟩)
  else if h53 : i < 324 then exact g25_318 i (Finset.mem_Ico.mpr ⟨by omega, h53⟩)
  else if h54 : i < 330 then exact g25_324 i (Finset.mem_Ico.mpr ⟨by omega, h54⟩)
  else if h55 : i < 336 then exact g25_330 i (Finset.mem_Ico.mpr ⟨by omega, h55⟩)
  else if h56 : i < 342 then exact g25_336 i (Finset.mem_Ico.mpr ⟨by omega, h56⟩)
  else if h57 : i < 348 then exact g25_342 i (Finset.mem_Ico.mpr ⟨by omega, h57⟩)
  else if h58 : i < 354 then exact g25_348 i (Finset.mem_Ico.mpr ⟨by omega, h58⟩)
  else if h59 : i < 360 then exact g25_354 i (Finset.mem_Ico.mpr ⟨by omega, h59⟩)
  else if h60 : i < 366 then exact g25_360 i (Finset.mem_Ico.mpr ⟨by omega, h60⟩)
  else if h61 : i < 372 then exact g25_366 i (Finset.mem_Ico.mpr ⟨by omega, h61⟩)
  else if h62 : i < 378 then exact g25_372 i (Finset.mem_Ico.mpr ⟨by omega, h62⟩)
  else if h63 : i < 384 then exact g25_378 i (Finset.mem_Ico.mpr ⟨by omega, h63⟩)
  else if h64 : i < 390 then exact g25_384 i (Finset.mem_Ico.mpr ⟨by omega, h64⟩)
  else if h65 : i < 396 then exact g25_390 i (Finset.mem_Ico.mpr ⟨by omega, h65⟩)
  else if h66 : i < 402 then exact g25_396 i (Finset.mem_Ico.mpr ⟨by omega, h66⟩)
  else if h67 : i < 408 then exact g25_402 i (Finset.mem_Ico.mpr ⟨by omega, h67⟩)
  else if h68 : i < 414 then exact g25_408 i (Finset.mem_Ico.mpr ⟨by omega, h68⟩)
  else if h69 : i < 420 then exact g25_414 i (Finset.mem_Ico.mpr ⟨by omega, h69⟩)
  else if h70 : i < 426 then exact g25_420 i (Finset.mem_Ico.mpr ⟨by omega, h70⟩)
  else if h71 : i < 432 then exact g25_426 i (Finset.mem_Ico.mpr ⟨by omega, h71⟩)
  else if h72 : i < 438 then exact g25_432 i (Finset.mem_Ico.mpr ⟨by omega, h72⟩)
  else if h73 : i < 444 then exact g25_438 i (Finset.mem_Ico.mpr ⟨by omega, h73⟩)
  else if h74 : i < 450 then exact g25_444 i (Finset.mem_Ico.mpr ⟨by omega, h74⟩)
  else if h75 : i < 456 then exact g25_450 i (Finset.mem_Ico.mpr ⟨by omega, h75⟩)
  else if h76 : i < 462 then exact g25_456 i (Finset.mem_Ico.mpr ⟨by omega, h76⟩)
  else if h77 : i < 468 then exact g25_462 i (Finset.mem_Ico.mpr ⟨by omega, h77⟩)
  else if h78 : i < 474 then exact g25_468 i (Finset.mem_Ico.mpr ⟨by omega, h78⟩)
  else if h79 : i < 480 then exact g25_474 i (Finset.mem_Ico.mpr ⟨by omega, h79⟩)
  else if h80 : i < 486 then exact g25_480 i (Finset.mem_Ico.mpr ⟨by omega, h80⟩)
  else if h81 : i < 492 then exact g25_486 i (Finset.mem_Ico.mpr ⟨by omega, h81⟩)
  else if h82 : i < 498 then exact g25_492 i (Finset.mem_Ico.mpr ⟨by omega, h82⟩)
  else if h83 : i < 504 then exact g25_498 i (Finset.mem_Ico.mpr ⟨by omega, h83⟩)
  else if h84 : i < 510 then exact g25_504 i (Finset.mem_Ico.mpr ⟨by omega, h84⟩)
  else if h85 : i < 516 then exact g25_510 i (Finset.mem_Ico.mpr ⟨by omega, h85⟩)
  else if h86 : i < 522 then exact g25_516 i (Finset.mem_Ico.mpr ⟨by omega, h86⟩)
  else if h87 : i < 528 then exact g25_522 i (Finset.mem_Ico.mpr ⟨by omega, h87⟩)
  else if h88 : i < 534 then exact g25_528 i (Finset.mem_Ico.mpr ⟨by omega, h88⟩)
  else if h89 : i < 540 then exact g25_534 i (Finset.mem_Ico.mpr ⟨by omega, h89⟩)
  else if h90 : i < 546 then exact g25_540 i (Finset.mem_Ico.mpr ⟨by omega, h90⟩)
  else if h91 : i < 552 then exact g25_546 i (Finset.mem_Ico.mpr ⟨by omega, h91⟩)
  else if h92 : i < 558 then exact g25_552 i (Finset.mem_Ico.mpr ⟨by omega, h92⟩)
  else if h93 : i < 564 then exact g25_558 i (Finset.mem_Ico.mpr ⟨by omega, h93⟩)
  else if h94 : i < 570 then exact g25_564 i (Finset.mem_Ico.mpr ⟨by omega, h94⟩)
  else if h95 : i < 576 then exact g25_570 i (Finset.mem_Ico.mpr ⟨by omega, h95⟩)
  else if h96 : i < 582 then exact g25_576 i (Finset.mem_Ico.mpr ⟨by omega, h96⟩)
  else if h97 : i < 588 then exact g25_582 i (Finset.mem_Ico.mpr ⟨by omega, h97⟩)
  else if h98 : i < 594 then exact g25_588 i (Finset.mem_Ico.mpr ⟨by omega, h98⟩)
  else if h99 : i < 600 then exact g25_594 i (Finset.mem_Ico.mpr ⟨by omega, h99⟩)
  else if h100 : i < 606 then exact g25_600 i (Finset.mem_Ico.mpr ⟨by omega, h100⟩)
  else if h101 : i < 612 then exact g25_606 i (Finset.mem_Ico.mpr ⟨by omega, h101⟩)
  else if h102 : i < 618 then exact g25_612 i (Finset.mem_Ico.mpr ⟨by omega, h102⟩)
  else if h103 : i < 624 then exact g25_618 i (Finset.mem_Ico.mpr ⟨by omega, h103⟩)
  else if h104 : i < 630 then exact g25_624 i (Finset.mem_Ico.mpr ⟨by omega, h104⟩)
  else if h105 : i < 636 then exact g25_630 i (Finset.mem_Ico.mpr ⟨by omega, h105⟩)
  else if h106 : i < 642 then exact g25_636 i (Finset.mem_Ico.mpr ⟨by omega, h106⟩)
  else if h107 : i < 648 then exact g25_642 i (Finset.mem_Ico.mpr ⟨by omega, h107⟩)
  else if h108 : i < 654 then exact g25_648 i (Finset.mem_Ico.mpr ⟨by omega, h108⟩)
  else if h109 : i < 660 then exact g25_654 i (Finset.mem_Ico.mpr ⟨by omega, h109⟩)
  else if h110 : i < 666 then exact g25_660 i (Finset.mem_Ico.mpr ⟨by omega, h110⟩)
  else if h111 : i < 672 then exact g25_666 i (Finset.mem_Ico.mpr ⟨by omega, h111⟩)
  else if h112 : i < 678 then exact g25_672 i (Finset.mem_Ico.mpr ⟨by omega, h112⟩)
  else if h113 : i < 684 then exact g25_678 i (Finset.mem_Ico.mpr ⟨by omega, h113⟩)
  else if h114 : i < 690 then exact g25_684 i (Finset.mem_Ico.mpr ⟨by omega, h114⟩)
  else if h115 : i < 696 then exact g25_690 i (Finset.mem_Ico.mpr ⟨by omega, h115⟩)
  else if h116 : i < 702 then exact g25_696 i (Finset.mem_Ico.mpr ⟨by omega, h116⟩)
  else if h117 : i < 708 then exact g25_702 i (Finset.mem_Ico.mpr ⟨by omega, h117⟩)
  else if h118 : i < 714 then exact g25_708 i (Finset.mem_Ico.mpr ⟨by omega, h118⟩)
  else if h119 : i < 720 then exact g25_714 i (Finset.mem_Ico.mpr ⟨by omega, h119⟩)
  else if h120 : i < 726 then exact g25_720 i (Finset.mem_Ico.mpr ⟨by omega, h120⟩)
  else if h121 : i < 732 then exact g25_726 i (Finset.mem_Ico.mpr ⟨by omega, h121⟩)
  else if h122 : i < 738 then exact g25_732 i (Finset.mem_Ico.mpr ⟨by omega, h122⟩)
  else if h123 : i < 744 then exact g25_738 i (Finset.mem_Ico.mpr ⟨by omega, h123⟩)
  else if h124 : i < 750 then exact g25_744 i (Finset.mem_Ico.mpr ⟨by omega, h124⟩)
  else if h125 : i < 756 then exact g25_750 i (Finset.mem_Ico.mpr ⟨by omega, h125⟩)
  else if h126 : i < 760 then exact g25_756 i (Finset.mem_Ico.mpr ⟨by omega, h126⟩)
  else omega

set_option maxHeartbeats 0 in
theorem pi25 : Nat.primeCounting (2 ^ 25) = 2063689 := by
  have hpeel := phi_add_peel (primesTo 5792) (primesTo_prime 5792) (primesTo_nodup 5792) (x := 33554432) (by norm_num)
  have hsum := peel_eq_sum 33554432 (primesTo 5792)
  have hlen : (primesTo 5792).length = 760 := by decide +kernel
  rw [hlen] at hsum
  have hF : (∑ i ∈ Finset.range 760, phi (33554432 / (primesTo 5792).getD i 0) ((primesTo 5792).drop (i + 1)))
      = ∑ i ∈ Finset.range 760, F25 i := rfl
  have hW : ∑ i ∈ Finset.range 760, F25 i = ∑ i ∈ Finset.range 760, W25 i :=
    Finset.sum_congr rfl fun i hi => F25_eq_W25 i (Finset.mem_range.mp hi)
  have hV : ∑ i ∈ Finset.range 760, W25 i = 31491502 := by decide +kernel
  have hL := primeCounting_eq_phi (x := 33554432) (s := 5792) (by norm_num) (by norm_num) (by norm_num)
  rw [pi_5792] at hL
  rw [show (2 : ℕ) ^ 25 = 33554432 by norm_num]
  omega

/-- **`StmtPiData` on rows 0 … 25, proved.** -/
theorem piData_le25 : ∀ n : Nat, n ≤ 25 →
    (DepthSix.piTwoPow.getD n 0 : Int) = (Nat.primeCounting (2 ^ n) : Int) := by
  intro n hn
  rcases Nat.lt_or_ge n 25 with h | h
  · exact piData_le24 n (by omega)
  · have : n = 25 := by omega
    subst this; rw [pi25]; decide

end PiChunks

/-- info: 'PiChunks.piData_le25' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PiChunks.piData_le25
