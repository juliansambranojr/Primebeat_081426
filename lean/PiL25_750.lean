import PiL25_750_750
import PiL25_750_751
import PiL25_750_752
import PiL25_750_753
import PiL25_750_754
import PiL25_750_755

namespace Legendre

/-- Indices 750 … 755, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_750 : ∀ i ∈ Finset.Ico 750 756, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 751 then exact g25_750_750 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 752 then exact g25_750_751 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 753 then exact g25_750_752 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 754 then exact g25_750_753 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 755 then exact g25_750_754 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 756 then exact g25_750_755 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
