import PiL24_486_486
import PiL24_486_487
import PiL24_486_488
import PiL24_486_489
import PiL24_486_490
import PiL24_486_491

namespace Legendre

/-- Indices 486 … 491, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_486 : ∀ i ∈ Finset.Ico 486 492, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 487 then exact g24_486_486 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 488 then exact g24_486_487 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 489 then exact g24_486_488 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 490 then exact g24_486_489 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 491 then exact g24_486_490 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 492 then exact g24_486_491 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
