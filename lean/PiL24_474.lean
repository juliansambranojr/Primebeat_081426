import PiL24_474_474
import PiL24_474_475
import PiL24_474_476
import PiL24_474_477
import PiL24_474_478
import PiL24_474_479

namespace Legendre

/-- Indices 474 … 479, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_474 : ∀ i ∈ Finset.Ico 474 480, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 475 then exact g24_474_474 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 476 then exact g24_474_475 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 477 then exact g24_474_476 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 478 then exact g24_474_477 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 479 then exact g24_474_478 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 480 then exact g24_474_479 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
