import PiL25_462_462
import PiL25_462_463
import PiL25_462_464
import PiL25_462_465
import PiL25_462_466
import PiL25_462_467

namespace Legendre

/-- Indices 462 … 467, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_462 : ∀ i ∈ Finset.Ico 462 468, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 463 then exact g25_462_462 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 464 then exact g25_462_463 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 465 then exact g25_462_464 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 466 then exact g25_462_465 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 467 then exact g25_462_466 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 468 then exact g25_462_467 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
