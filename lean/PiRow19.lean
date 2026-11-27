/-
PiRow19 — row 19 of the π list: `pi18` and the primes in `(2^18, 2^19]`, one block of 4096
per file (`PiB19_*`), each stating the count's step as a linear fact, joined by `omega`.
-/
import PiB19_262145
import PiB19_266241
import PiB19_270337
import PiB19_274433
import PiB19_278529
import PiB19_282625
import PiB19_286721
import PiB19_290817
import PiB19_294913
import PiB19_299009
import PiB19_303105
import PiB19_307201
import PiB19_311297
import PiB19_315393
import PiB19_319489
import PiB19_323585
import PiB19_327681
import PiB19_331777
import PiB19_335873
import PiB19_339969
import PiB19_344065
import PiB19_348161
import PiB19_352257
import PiB19_356353
import PiB19_360449
import PiB19_364545
import PiB19_368641
import PiB19_372737
import PiB19_376833
import PiB19_380929
import PiB19_385025
import PiB19_389121
import PiB19_393217
import PiB19_397313
import PiB19_401409
import PiB19_405505
import PiB19_409601
import PiB19_413697
import PiB19_417793
import PiB19_421889
import PiB19_425985
import PiB19_430081
import PiB19_434177
import PiB19_438273
import PiB19_442369
import PiB19_446465
import PiB19_450561
import PiB19_454657
import PiB19_458753
import PiB19_462849
import PiB19_466945
import PiB19_471041
import PiB19_475137
import PiB19_479233
import PiB19_483329
import PiB19_487425
import PiB19_491521
import PiB19_495617
import PiB19_499713
import PiB19_503809
import PiB19_507905
import PiB19_512001
import PiB19_516097
import PiB19_520193
import PiRow18

namespace PiChunks

theorem pi19 : Nat.primeCounting (2 ^ 19) = 43390 := by
  have hp := pi18
  simp only [Nat.primeCounting, Nat.primeCounting', Nat.reducePow, Nat.reduceAdd] at hp ⊢
  have := b19_262145
  have := b19_266241
  have := b19_270337
  have := b19_274433
  have := b19_278529
  have := b19_282625
  have := b19_286721
  have := b19_290817
  have := b19_294913
  have := b19_299009
  have := b19_303105
  have := b19_307201
  have := b19_311297
  have := b19_315393
  have := b19_319489
  have := b19_323585
  have := b19_327681
  have := b19_331777
  have := b19_335873
  have := b19_339969
  have := b19_344065
  have := b19_348161
  have := b19_352257
  have := b19_356353
  have := b19_360449
  have := b19_364545
  have := b19_368641
  have := b19_372737
  have := b19_376833
  have := b19_380929
  have := b19_385025
  have := b19_389121
  have := b19_393217
  have := b19_397313
  have := b19_401409
  have := b19_405505
  have := b19_409601
  have := b19_413697
  have := b19_417793
  have := b19_421889
  have := b19_425985
  have := b19_430081
  have := b19_434177
  have := b19_438273
  have := b19_442369
  have := b19_446465
  have := b19_450561
  have := b19_454657
  have := b19_458753
  have := b19_462849
  have := b19_466945
  have := b19_471041
  have := b19_475137
  have := b19_479233
  have := b19_483329
  have := b19_487425
  have := b19_491521
  have := b19_495617
  have := b19_499713
  have := b19_503809
  have := b19_507905
  have := b19_512001
  have := b19_516097
  have := b19_520193
  omega

/-- **`StmtPiData` on rows 0 … 19, proved.** -/
theorem piData_le19 : ∀ n : Nat, n ≤ 19 →
    (DepthSix.piTwoPow.getD n 0 : Int) = (Nat.primeCounting (2 ^ n) : Int) := by
  intro n hn
  rcases Nat.lt_or_ge n 19 with h | h
  · exact piData_le18 n (by omega)
  · have : n = 19 := by omega
    subst this; rw [pi19]; decide

end PiChunks

/-- info: 'PiChunks.piData_le19' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PiChunks.piData_le19
