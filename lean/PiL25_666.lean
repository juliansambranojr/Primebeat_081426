import PiL25_666_666
import PiL25_666_667
import PiL25_666_668
import PiL25_666_669
import PiL25_666_670
import PiL25_666_671

namespace Legendre

/-- Indices 666 … 671, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_666 : ∀ i ∈ Finset.Ico 666 672, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 667 then exact g25_666_666 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 668 then exact g25_666_667 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 669 then exact g25_666_668 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 670 then exact g25_666_669 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 671 then exact g25_666_670 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 672 then exact g25_666_671 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
