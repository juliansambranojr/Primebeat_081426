import PiL25_348_348
import PiL25_348_349
import PiL25_348_350
import PiL25_348_351
import PiL25_348_352
import PiL25_348_353

namespace Legendre

/-- Indices 348 … 353, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_348 : ∀ i ∈ Finset.Ico 348 354, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 349 then exact g25_348_348 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 350 then exact g25_348_349 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 351 then exact g25_348_350 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 352 then exact g25_348_351 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 353 then exact g25_348_352 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 354 then exact g25_348_353 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
