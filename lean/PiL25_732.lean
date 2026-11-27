import PiL25_732_732
import PiL25_732_733
import PiL25_732_734
import PiL25_732_735
import PiL25_732_736
import PiL25_732_737

namespace Legendre

/-- Indices 732 … 737, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_732 : ∀ i ∈ Finset.Ico 732 738, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 733 then exact g25_732_732 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 734 then exact g25_732_733 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 735 then exact g25_732_734 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 736 then exact g25_732_735 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 737 then exact g25_732_736 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 738 then exact g25_732_737 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
