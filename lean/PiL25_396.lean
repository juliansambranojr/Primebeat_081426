import PiL25_396_396
import PiL25_396_397
import PiL25_396_398
import PiL25_396_399
import PiL25_396_400
import PiL25_396_401

namespace Legendre

/-- Indices 396 … 401, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_396 : ∀ i ∈ Finset.Ico 396 402, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 397 then exact g25_396_396 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 398 then exact g25_396_397 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 399 then exact g25_396_398 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 400 then exact g25_396_399 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 401 then exact g25_396_400 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 402 then exact g25_396_401 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
