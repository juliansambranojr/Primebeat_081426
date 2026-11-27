import PiL25_600_600
import PiL25_600_601
import PiL25_600_602
import PiL25_600_603
import PiL25_600_604
import PiL25_600_605

namespace Legendre

/-- Indices 600 … 605, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_600 : ∀ i ∈ Finset.Ico 600 606, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 601 then exact g25_600_600 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 602 then exact g25_600_601 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 603 then exact g25_600_602 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 604 then exact g25_600_603 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 605 then exact g25_600_604 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 606 then exact g25_600_605 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
