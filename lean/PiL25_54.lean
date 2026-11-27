import PiL25_54_54
import PiL25_54_55
import PiL25_54_56
import PiL25_54_57
import PiL25_54_58
import PiL25_54_59

namespace Legendre

/-- Indices 54 … 59, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_54 : ∀ i ∈ Finset.Ico 54 60, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 55 then exact g25_54_54 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 56 then exact g25_54_55 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 57 then exact g25_54_56 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 58 then exact g25_54_57 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 59 then exact g25_54_58 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 60 then exact g25_54_59 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
