import PiL25_744_744
import PiL25_744_745
import PiL25_744_746
import PiL25_744_747
import PiL25_744_748
import PiL25_744_749

namespace Legendre

/-- Indices 744 … 749, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_744 : ∀ i ∈ Finset.Ico 744 750, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 745 then exact g25_744_744 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 746 then exact g25_744_745 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 747 then exact g25_744_746 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 748 then exact g25_744_747 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 749 then exact g25_744_748 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 750 then exact g25_744_749 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
