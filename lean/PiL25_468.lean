import PiL25_468_468
import PiL25_468_469
import PiL25_468_470
import PiL25_468_471
import PiL25_468_472
import PiL25_468_473

namespace Legendre

/-- Indices 468 … 473, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_468 : ∀ i ∈ Finset.Ico 468 474, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 469 then exact g25_468_468 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 470 then exact g25_468_469 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 471 then exact g25_468_470 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 472 then exact g25_468_471 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 473 then exact g25_468_472 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 474 then exact g25_468_473 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
