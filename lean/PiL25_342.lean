import PiL25_342_342
import PiL25_342_343
import PiL25_342_344
import PiL25_342_345
import PiL25_342_346
import PiL25_342_347

namespace Legendre

/-- Indices 342 … 347, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_342 : ∀ i ∈ Finset.Ico 342 348, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 343 then exact g25_342_342 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 344 then exact g25_342_343 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 345 then exact g25_342_344 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 346 then exact g25_342_345 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 347 then exact g25_342_346 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 348 then exact g25_342_347 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
