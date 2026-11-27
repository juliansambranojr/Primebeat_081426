import PiL24_522_522
import PiL24_522_523
import PiL24_522_524
import PiL24_522_525
import PiL24_522_526
import PiL24_522_527

namespace Legendre

/-- Indices 522 … 527, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_522 : ∀ i ∈ Finset.Ico 522 528, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 523 then exact g24_522_522 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 524 then exact g24_522_523 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 525 then exact g24_522_524 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 526 then exact g24_522_525 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 527 then exact g24_522_526 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 528 then exact g24_522_527 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
