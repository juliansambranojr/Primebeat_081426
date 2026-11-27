import PiL25_660_660
import PiL25_660_661
import PiL25_660_662
import PiL25_660_663
import PiL25_660_664
import PiL25_660_665

namespace Legendre

/-- Indices 660 … 665, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_660 : ∀ i ∈ Finset.Ico 660 666, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 661 then exact g25_660_660 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 662 then exact g25_660_661 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 663 then exact g25_660_662 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 664 then exact g25_660_663 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 665 then exact g25_660_664 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 666 then exact g25_660_665 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
