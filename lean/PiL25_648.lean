import PiL25_648_648
import PiL25_648_649
import PiL25_648_650
import PiL25_648_651
import PiL25_648_652
import PiL25_648_653

namespace Legendre

/-- Indices 648 … 653, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_648 : ∀ i ∈ Finset.Ico 648 654, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 649 then exact g25_648_648 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 650 then exact g25_648_649 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 651 then exact g25_648_650 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 652 then exact g25_648_651 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 653 then exact g25_648_652 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 654 then exact g25_648_653 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
