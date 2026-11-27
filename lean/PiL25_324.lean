import PiL25_324_324
import PiL25_324_325
import PiL25_324_326
import PiL25_324_327
import PiL25_324_328
import PiL25_324_329

namespace Legendre

/-- Indices 324 … 329, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_324 : ∀ i ∈ Finset.Ico 324 330, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 325 then exact g25_324_324 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 326 then exact g25_324_325 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 327 then exact g25_324_326 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 328 then exact g25_324_327 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 329 then exact g25_324_328 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 330 then exact g25_324_329 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
