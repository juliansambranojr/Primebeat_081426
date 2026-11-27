import PiL25_78_78
import PiL25_78_79
import PiL25_78_80
import PiL25_78_81
import PiL25_78_82
import PiL25_78_83

namespace Legendre

/-- Indices 78 … 83, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_78 : ∀ i ∈ Finset.Ico 78 84, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 79 then exact g25_78_78 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 80 then exact g25_78_79 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 81 then exact g25_78_80 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 82 then exact g25_78_81 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 83 then exact g25_78_82 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 84 then exact g25_78_83 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
