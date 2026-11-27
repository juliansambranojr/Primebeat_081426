import PiL25_642_642
import PiL25_642_643
import PiL25_642_644
import PiL25_642_645
import PiL25_642_646
import PiL25_642_647

namespace Legendre

/-- Indices 642 … 647, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_642 : ∀ i ∈ Finset.Ico 642 648, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 643 then exact g25_642_642 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 644 then exact g25_642_643 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 645 then exact g25_642_644 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 646 then exact g25_642_645 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 647 then exact g25_642_646 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 648 then exact g25_642_647 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
