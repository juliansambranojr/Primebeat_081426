import PiL25_726_726
import PiL25_726_727
import PiL25_726_728
import PiL25_726_729
import PiL25_726_730
import PiL25_726_731

namespace Legendre

/-- Indices 726 … 731, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_726 : ∀ i ∈ Finset.Ico 726 732, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 727 then exact g25_726_726 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 728 then exact g25_726_727 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 729 then exact g25_726_728 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 730 then exact g25_726_729 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 731 then exact g25_726_730 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 732 then exact g25_726_731 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
