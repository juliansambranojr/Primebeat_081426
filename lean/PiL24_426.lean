import PiL24_426_426
import PiL24_426_427
import PiL24_426_428
import PiL24_426_429
import PiL24_426_430
import PiL24_426_431

namespace Legendre

/-- Indices 426 … 431, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_426 : ∀ i ∈ Finset.Ico 426 432, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 427 then exact g24_426_426 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 428 then exact g24_426_427 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 429 then exact g24_426_428 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 430 then exact g24_426_429 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 431 then exact g24_426_430 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 432 then exact g24_426_431 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
