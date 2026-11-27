import PiL25_138_138
import PiL25_138_139
import PiL25_138_140
import PiL25_138_141
import PiL25_138_142
import PiL25_138_143

namespace Legendre

/-- Indices 138 … 143, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_138 : ∀ i ∈ Finset.Ico 138 144, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 139 then exact g25_138_138 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 140 then exact g25_138_139 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 141 then exact g25_138_140 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 142 then exact g25_138_141 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 143 then exact g25_138_142 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 144 then exact g25_138_143 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
