import PiL25_594_594
import PiL25_594_595
import PiL25_594_596
import PiL25_594_597
import PiL25_594_598
import PiL25_594_599

namespace Legendre

/-- Indices 594 … 599, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_594 : ∀ i ∈ Finset.Ico 594 600, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 595 then exact g25_594_594 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 596 then exact g25_594_595 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 597 then exact g25_594_596 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 598 then exact g25_594_597 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 599 then exact g25_594_598 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 600 then exact g25_594_599 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
