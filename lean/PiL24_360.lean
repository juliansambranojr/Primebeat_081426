import PiL24_360_360
import PiL24_360_361
import PiL24_360_362
import PiL24_360_363
import PiL24_360_364
import PiL24_360_365

namespace Legendre

/-- Indices 360 … 365, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_360 : ∀ i ∈ Finset.Ico 360 366, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 361 then exact g24_360_360 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 362 then exact g24_360_361 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 363 then exact g24_360_362 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 364 then exact g24_360_363 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 365 then exact g24_360_364 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 366 then exact g24_360_365 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
