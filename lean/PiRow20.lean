/-
PiRow20 — row 20 of the π list: `pi19` and the primes in `(2^19, 2^20]`, one block of 4096
per file (`PiB20_*`), each stating the count's step as a linear fact, joined by `omega`.
-/
import PiB20_524289
import PiB20_528385
import PiB20_532481
import PiB20_536577
import PiB20_540673
import PiB20_544769
import PiB20_548865
import PiB20_552961
import PiB20_557057
import PiB20_561153
import PiB20_565249
import PiB20_569345
import PiB20_573441
import PiB20_577537
import PiB20_581633
import PiB20_585729
import PiB20_589825
import PiB20_593921
import PiB20_598017
import PiB20_602113
import PiB20_606209
import PiB20_610305
import PiB20_614401
import PiB20_618497
import PiB20_622593
import PiB20_626689
import PiB20_630785
import PiB20_634881
import PiB20_638977
import PiB20_643073
import PiB20_647169
import PiB20_651265
import PiB20_655361
import PiB20_659457
import PiB20_663553
import PiB20_667649
import PiB20_671745
import PiB20_675841
import PiB20_679937
import PiB20_684033
import PiB20_688129
import PiB20_692225
import PiB20_696321
import PiB20_700417
import PiB20_704513
import PiB20_708609
import PiB20_712705
import PiB20_716801
import PiB20_720897
import PiB20_724993
import PiB20_729089
import PiB20_733185
import PiB20_737281
import PiB20_741377
import PiB20_745473
import PiB20_749569
import PiB20_753665
import PiB20_757761
import PiB20_761857
import PiB20_765953
import PiB20_770049
import PiB20_774145
import PiB20_778241
import PiB20_782337
import PiB20_786433
import PiB20_790529
import PiB20_794625
import PiB20_798721
import PiB20_802817
import PiB20_806913
import PiB20_811009
import PiB20_815105
import PiB20_819201
import PiB20_823297
import PiB20_827393
import PiB20_831489
import PiB20_835585
import PiB20_839681
import PiB20_843777
import PiB20_847873
import PiB20_851969
import PiB20_856065
import PiB20_860161
import PiB20_864257
import PiB20_868353
import PiB20_872449
import PiB20_876545
import PiB20_880641
import PiB20_884737
import PiB20_888833
import PiB20_892929
import PiB20_897025
import PiB20_901121
import PiB20_905217
import PiB20_909313
import PiB20_913409
import PiB20_917505
import PiB20_921601
import PiB20_925697
import PiB20_929793
import PiB20_933889
import PiB20_937985
import PiB20_942081
import PiB20_946177
import PiB20_950273
import PiB20_954369
import PiB20_958465
import PiB20_962561
import PiB20_966657
import PiB20_970753
import PiB20_974849
import PiB20_978945
import PiB20_983041
import PiB20_987137
import PiB20_991233
import PiB20_995329
import PiB20_999425
import PiB20_1003521
import PiB20_1007617
import PiB20_1011713
import PiB20_1015809
import PiB20_1019905
import PiB20_1024001
import PiB20_1028097
import PiB20_1032193
import PiB20_1036289
import PiB20_1040385
import PiB20_1044481
import PiRow19

namespace PiChunks

theorem pi20 : Nat.primeCounting (2 ^ 20) = 82025 := by
  have hp := pi19
  simp only [Nat.primeCounting, Nat.primeCounting', Nat.reducePow, Nat.reduceAdd] at hp ⊢
  have := b20_524289
  have := b20_528385
  have := b20_532481
  have := b20_536577
  have := b20_540673
  have := b20_544769
  have := b20_548865
  have := b20_552961
  have := b20_557057
  have := b20_561153
  have := b20_565249
  have := b20_569345
  have := b20_573441
  have := b20_577537
  have := b20_581633
  have := b20_585729
  have := b20_589825
  have := b20_593921
  have := b20_598017
  have := b20_602113
  have := b20_606209
  have := b20_610305
  have := b20_614401
  have := b20_618497
  have := b20_622593
  have := b20_626689
  have := b20_630785
  have := b20_634881
  have := b20_638977
  have := b20_643073
  have := b20_647169
  have := b20_651265
  have := b20_655361
  have := b20_659457
  have := b20_663553
  have := b20_667649
  have := b20_671745
  have := b20_675841
  have := b20_679937
  have := b20_684033
  have := b20_688129
  have := b20_692225
  have := b20_696321
  have := b20_700417
  have := b20_704513
  have := b20_708609
  have := b20_712705
  have := b20_716801
  have := b20_720897
  have := b20_724993
  have := b20_729089
  have := b20_733185
  have := b20_737281
  have := b20_741377
  have := b20_745473
  have := b20_749569
  have := b20_753665
  have := b20_757761
  have := b20_761857
  have := b20_765953
  have := b20_770049
  have := b20_774145
  have := b20_778241
  have := b20_782337
  have := b20_786433
  have := b20_790529
  have := b20_794625
  have := b20_798721
  have := b20_802817
  have := b20_806913
  have := b20_811009
  have := b20_815105
  have := b20_819201
  have := b20_823297
  have := b20_827393
  have := b20_831489
  have := b20_835585
  have := b20_839681
  have := b20_843777
  have := b20_847873
  have := b20_851969
  have := b20_856065
  have := b20_860161
  have := b20_864257
  have := b20_868353
  have := b20_872449
  have := b20_876545
  have := b20_880641
  have := b20_884737
  have := b20_888833
  have := b20_892929
  have := b20_897025
  have := b20_901121
  have := b20_905217
  have := b20_909313
  have := b20_913409
  have := b20_917505
  have := b20_921601
  have := b20_925697
  have := b20_929793
  have := b20_933889
  have := b20_937985
  have := b20_942081
  have := b20_946177
  have := b20_950273
  have := b20_954369
  have := b20_958465
  have := b20_962561
  have := b20_966657
  have := b20_970753
  have := b20_974849
  have := b20_978945
  have := b20_983041
  have := b20_987137
  have := b20_991233
  have := b20_995329
  have := b20_999425
  have := b20_1003521
  have := b20_1007617
  have := b20_1011713
  have := b20_1015809
  have := b20_1019905
  have := b20_1024001
  have := b20_1028097
  have := b20_1032193
  have := b20_1036289
  have := b20_1040385
  have := b20_1044481
  omega

/-- **`StmtPiData` on rows 0 … 20, proved.** -/
theorem piData_le20 : ∀ n : Nat, n ≤ 20 →
    (DepthSix.piTwoPow.getD n 0 : Int) = (Nat.primeCounting (2 ^ n) : Int) := by
  intro n hn
  rcases Nat.lt_or_ge n 20 with h | h
  · exact piData_le19 n (by omega)
  · have : n = 20 := by omega
    subst this; rw [pi20]; decide

end PiChunks

/-- info: 'PiChunks.piData_le20' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PiChunks.piData_le20
