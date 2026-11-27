import PiL25_672_672
import PiL25_672_673
import PiL25_672_674
import PiL25_672_675
import PiL25_672_676
import PiL25_672_677

namespace Legendre

/-- Indices 672 … 677, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_672 : ∀ i ∈ Finset.Ico 672 678, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 673 then exact g25_672_672 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 674 then exact g25_672_673 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 675 then exact g25_672_674 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 676 then exact g25_672_675 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 677 then exact g25_672_676 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 678 then exact g25_672_677 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
