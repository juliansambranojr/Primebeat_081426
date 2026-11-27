import PiL25_738_738
import PiL25_738_739
import PiL25_738_740
import PiL25_738_741
import PiL25_738_742
import PiL25_738_743

namespace Legendre

/-- Indices 738 … 743, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_738 : ∀ i ∈ Finset.Ico 738 744, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 739 then exact g25_738_738 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 740 then exact g25_738_739 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 741 then exact g25_738_740 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 742 then exact g25_738_741 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 743 then exact g25_738_742 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 744 then exact g25_738_743 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
