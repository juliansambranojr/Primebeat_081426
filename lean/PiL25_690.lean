import PiL25_690_690
import PiL25_690_691
import PiL25_690_692
import PiL25_690_693
import PiL25_690_694
import PiL25_690_695

namespace Legendre

/-- Indices 690 … 695, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_690 : ∀ i ∈ Finset.Ico 690 696, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 691 then exact g25_690_690 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 692 then exact g25_690_691 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 693 then exact g25_690_692 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 694 then exact g25_690_693 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 695 then exact g25_690_694 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 696 then exact g25_690_695 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
