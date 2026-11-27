import PiL25_684_684
import PiL25_684_685
import PiL25_684_686
import PiL25_684_687
import PiL25_684_688
import PiL25_684_689

namespace Legendre

/-- Indices 684 … 689, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_684 : ∀ i ∈ Finset.Ico 684 690, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 685 then exact g25_684_684 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 686 then exact g25_684_685 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 687 then exact g25_684_686 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 688 then exact g25_684_687 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 689 then exact g25_684_688 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 690 then exact g25_684_689 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
