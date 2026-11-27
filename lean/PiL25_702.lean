import PiL25_702_702
import PiL25_702_703
import PiL25_702_704
import PiL25_702_705
import PiL25_702_706
import PiL25_702_707

namespace Legendre

/-- Indices 702 … 707, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_702 : ∀ i ∈ Finset.Ico 702 708, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 703 then exact g25_702_702 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 704 then exact g25_702_703 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 705 then exact g25_702_704 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 706 then exact g25_702_705 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 707 then exact g25_702_706 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 708 then exact g25_702_707 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
