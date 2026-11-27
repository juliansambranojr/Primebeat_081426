import PiL25_312_312
import PiL25_312_313
import PiL25_312_314
import PiL25_312_315
import PiL25_312_316
import PiL25_312_317

namespace Legendre

/-- Indices 312 … 317, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_312 : ∀ i ∈ Finset.Ico 312 318, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 313 then exact g25_312_312 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 314 then exact g25_312_313 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 315 then exact g25_312_314 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 316 then exact g25_312_315 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 317 then exact g25_312_316 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 318 then exact g25_312_317 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
