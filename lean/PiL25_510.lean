import PiL25_510_510
import PiL25_510_511
import PiL25_510_512
import PiL25_510_513
import PiL25_510_514
import PiL25_510_515

namespace Legendre

/-- Indices 510 … 515, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_510 : ∀ i ∈ Finset.Ico 510 516, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 511 then exact g25_510_510 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 512 then exact g25_510_511 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 513 then exact g25_510_512 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 514 then exact g25_510_513 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 515 then exact g25_510_514 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 516 then exact g25_510_515 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
