import PiL24_432_432
import PiL24_432_433
import PiL24_432_434
import PiL24_432_435
import PiL24_432_436
import PiL24_432_437

namespace Legendre

/-- Indices 432 … 437, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_432 : ∀ i ∈ Finset.Ico 432 438, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 433 then exact g24_432_432 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 434 then exact g24_432_433 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 435 then exact g24_432_434 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 436 then exact g24_432_435 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 437 then exact g24_432_436 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 438 then exact g24_432_437 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
