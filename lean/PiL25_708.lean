import PiL25_708_708
import PiL25_708_709
import PiL25_708_710
import PiL25_708_711
import PiL25_708_712
import PiL25_708_713

namespace Legendre

/-- Indices 708 … 713, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_708 : ∀ i ∈ Finset.Ico 708 714, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 709 then exact g25_708_708 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 710 then exact g25_708_709 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 711 then exact g25_708_710 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 712 then exact g25_708_711 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 713 then exact g25_708_712 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 714 then exact g25_708_713 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
