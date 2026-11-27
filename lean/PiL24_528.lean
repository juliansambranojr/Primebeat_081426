import PiL24_528_528
import PiL24_528_529
import PiL24_528_530
import PiL24_528_531
import PiL24_528_532
import PiL24_528_533

namespace Legendre

/-- Indices 528 … 533, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_528 : ∀ i ∈ Finset.Ico 528 534, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 529 then exact g24_528_528 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 530 then exact g24_528_529 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 531 then exact g24_528_530 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 532 then exact g24_528_531 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 533 then exact g24_528_532 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 534 then exact g24_528_533 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
