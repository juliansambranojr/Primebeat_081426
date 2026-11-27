import PiL25_696_696
import PiL25_696_697
import PiL25_696_698
import PiL25_696_699
import PiL25_696_700
import PiL25_696_701

namespace Legendre

/-- Indices 696 … 701, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_696 : ∀ i ∈ Finset.Ico 696 702, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 697 then exact g25_696_696 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 698 then exact g25_696_697 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 699 then exact g25_696_698 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 700 then exact g25_696_699 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 701 then exact g25_696_700 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 702 then exact g25_696_701 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
