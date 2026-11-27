import PiL25_678_678
import PiL25_678_679
import PiL25_678_680
import PiL25_678_681
import PiL25_678_682
import PiL25_678_683

namespace Legendre

/-- Indices 678 … 683, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_678 : ∀ i ∈ Finset.Ico 678 684, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 679 then exact g25_678_678 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 680 then exact g25_678_679 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 681 then exact g25_678_680 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 682 then exact g25_678_681 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 683 then exact g25_678_682 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 684 then exact g25_678_683 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
