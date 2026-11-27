import PiL25_372_372
import PiL25_372_373
import PiL25_372_374
import PiL25_372_375
import PiL25_372_376
import PiL25_372_377

namespace Legendre

/-- Indices 372 … 377, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_372 : ∀ i ∈ Finset.Ico 372 378, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 373 then exact g25_372_372 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 374 then exact g25_372_373 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 375 then exact g25_372_374 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 376 then exact g25_372_375 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 377 then exact g25_372_376 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 378 then exact g25_372_377 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
