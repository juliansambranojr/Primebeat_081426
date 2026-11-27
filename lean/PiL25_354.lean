import PiL25_354_354
import PiL25_354_355
import PiL25_354_356
import PiL25_354_357
import PiL25_354_358
import PiL25_354_359

namespace Legendre

/-- Indices 354 … 359, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_354 : ∀ i ∈ Finset.Ico 354 360, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 355 then exact g25_354_354 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 356 then exact g25_354_355 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 357 then exact g25_354_356 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 358 then exact g25_354_357 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 359 then exact g25_354_358 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 360 then exact g25_354_359 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
