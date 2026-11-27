import PiL25_102_102
import PiL25_102_103
import PiL25_102_104
import PiL25_102_105
import PiL25_102_106
import PiL25_102_107

namespace Legendre

/-- Indices 102 … 107, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_102 : ∀ i ∈ Finset.Ico 102 108, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 103 then exact g25_102_102 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 104 then exact g25_102_103 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 105 then exact g25_102_104 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 106 then exact g25_102_105 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 107 then exact g25_102_106 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 108 then exact g25_102_107 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
