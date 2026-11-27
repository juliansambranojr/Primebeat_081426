import PiL24_438_438
import PiL24_438_439
import PiL24_438_440
import PiL24_438_441
import PiL24_438_442
import PiL24_438_443

namespace Legendre

/-- Indices 438 … 443, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_438 : ∀ i ∈ Finset.Ico 438 444, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 439 then exact g24_438_438 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 440 then exact g24_438_439 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 441 then exact g24_438_440 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 442 then exact g24_438_441 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 443 then exact g24_438_442 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 444 then exact g24_438_443 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
