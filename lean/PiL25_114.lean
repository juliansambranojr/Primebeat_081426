import PiL25_114_114
import PiL25_114_115
import PiL25_114_116
import PiL25_114_117
import PiL25_114_118
import PiL25_114_119

namespace Legendre

/-- Indices 114 … 119, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_114 : ∀ i ∈ Finset.Ico 114 120, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 115 then exact g25_114_114 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 116 then exact g25_114_115 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 117 then exact g25_114_116 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 118 then exact g25_114_117 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 119 then exact g25_114_118 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 120 then exact g25_114_119 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
