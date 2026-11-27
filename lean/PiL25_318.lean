import PiL25_318_318
import PiL25_318_319
import PiL25_318_320
import PiL25_318_321
import PiL25_318_322
import PiL25_318_323

namespace Legendre

/-- Indices 318 … 323, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_318 : ∀ i ∈ Finset.Ico 318 324, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 319 then exact g25_318_318 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 320 then exact g25_318_319 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 321 then exact g25_318_320 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 322 then exact g25_318_321 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 323 then exact g25_318_322 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 324 then exact g25_318_323 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
