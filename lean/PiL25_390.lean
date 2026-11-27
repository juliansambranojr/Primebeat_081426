import PiL25_390_390
import PiL25_390_391
import PiL25_390_392
import PiL25_390_393
import PiL25_390_394
import PiL25_390_395

namespace Legendre

/-- Indices 390 … 395, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_390 : ∀ i ∈ Finset.Ico 390 396, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 391 then exact g25_390_390 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 392 then exact g25_390_391 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 393 then exact g25_390_392 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 394 then exact g25_390_393 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 395 then exact g25_390_394 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 396 then exact g25_390_395 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
