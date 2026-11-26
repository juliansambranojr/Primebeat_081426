/-
DepthSix — the depth-6 cells of the dyadic prime difference table to row 92, computed by the kernel.

THE DATA. `piTwoPow` lists π(2^n) for n = 0..92, copied from the OEIS b-file of A007053 at the
repo root (`b007053.txt`), which agrees with `pi2n_cache.json` on n ≤ 62. Lean does not compute
π(2^n) here: the list is an input, named, and every theorem below is about the table it gives.
`DepthSix.StmtPiData` states that the list is π; nothing proves it in this file.

WHAT IS PROVED, by `decide`, from the list alone:
  * the cell (20,6) is 0;
  * every depth-6 cell from row 21 to row 92 is positive;
  * between rows 7 and 92, row 20 is the only depth-6 cell that is 0.

WHAT IS NOT: rows past 92. Unit 0584 carries them with the published bound of Fiori, Kadiri and
Swidinsky (Table 6 row 1, stated with `sorry` in PNT+); that step is not in Lean.
-/
import Mathlib
import Construction

namespace DepthSix

/-- π(2^n) for n = 0..92, from `b007053.txt` (OEIS A007053). An input, not a computation. -/
def piTwoPow : List Int := [
  0,
  1,
  2,
  4,
  6,
  11,
  18,
  31,
  54,
  97,
  172,
  309,
  564,
  1028,
  1900,
  3512,
  6542,
  12251,
  23000,
  43390,
  82025,
  155611,
  295947,
  564163,
  1077871,
  2063689,
  3957809,
  7603553,
  14630843,
  28192750,
  54400028,
  105097565,
  203280221,
  393615806,
  762939111,
  1480206279,
  2874398515,
  5586502348,
  10866266172,
  21151907950,
  41203088796,
  80316571436,
  156661034233,
  305761713237,
  597116381732,
  1166746786182,
  2280998753949,
  4461632979717,
  8731188863470,
  17094432576778,
  33483379603407,
  65612899915304,
  128625503610475,
  252252704148404,
  494890204904784,
  971269945245201,
  1906879381028850,
  3745011184713964,
  7357400267843990,
  14458792895301660,
  28423094496953330,
  55890484045084135,
  109932807585469973,
  216289611853439384,
  425656284035217743,
  837903145466607212,
  1649819700464785589,
  3249254387052557215,
  6400771597544937806,
  12611864618760352880,
  24855455363362685793,
  48995571600129458363,
  96601075195075186855,
  190499823401327905601,
  375744164937699609596,
  741263521140740113483,
  1462626667154509638735,
  2886507381056867953916,
  5697549648954257752872,
  11248065615133675809379,
  22209558889635384205844,
  43860397052947409356492,
  86631124695994360074872,
  171136408646923240987028,
  338124238545210097236684,
  668150111666935905701562,
  1320486952377516565496055,
  2610087356951889016077639,
  5159830247726102115466054,
  10201730804263125133012340,
  20172933541156002700963336,
  39895115987049029184882256,
  78908656317357166866404346]

/-- The row of the table: the primes in (2^(r-1), 2^r], from the list, for 1 ≤ r ≤ 92. -/
def row (r : Int) : Int :=
  if 1 ≤ r ∧ r ≤ 92 then piTwoPow.getD r.toNat 0 - piTwoPow.getD (r - 1).toNat 0 else 0

/-- The list is π at powers of two — the trusted input, stated and not proved. -/
def StmtPiData : Prop := ∀ n : Nat, n ≤ 92 → (piTwoPow.getD n 0 : Int) = (Nat.primeCounting (2 ^ n) : Int)

/-- (20,6) vanishes. -/
theorem zero_20_6 : Construction.tableFrom row 20 6 = 0 := by decide

/-- Every depth-6 cell from row 21 to row 92 is positive. -/
theorem depth6_pos : (List.range' 21 72).all (fun r : Nat => decide (0 < Construction.tableFrom row r 6)) = true := by
  decide

/-- Between rows 7 and 92, the only depth-6 cell that is 0 is at row 20. -/
theorem depth6_only_zero :
    (List.range' 7 86).filter (fun r : Nat => Construction.tableFrom row r 6 == 0) = [20] := by
  decide

end DepthSix

/-- info: 'DepthSix.depth6_only_zero' depends on axioms: [propext] -/
#guard_msgs in
#print axioms DepthSix.depth6_only_zero
