import PiL24_366_366
import PiL24_366_367
import PiL24_366_368
import PiL24_366_369
import PiL24_366_370
import PiL24_366_371

namespace Legendre

/-- Indices 366 … 371, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_366 : ∀ i ∈ Finset.Ico 366 372, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 367 then exact g24_366_366 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 368 then exact g24_366_367 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 369 then exact g24_366_368 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 370 then exact g24_366_369 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 371 then exact g24_366_370 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 372 then exact g24_366_371 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
