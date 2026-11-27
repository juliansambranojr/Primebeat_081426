import PiL25_756_756
import PiL25_756_757
import PiL25_756_758
import PiL25_756_759

namespace Legendre

/-- Indices 756 … 759, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_756 : ∀ i ∈ Finset.Ico 756 760, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 757 then exact g25_756_756 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 758 then exact g25_756_757 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 759 then exact g25_756_758 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 760 then exact g25_756_759 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else omega

end Legendre
