import PiL25_168_168
import PiL25_168_169
import PiL25_168_170
import PiL25_168_171
import PiL25_168_172
import PiL25_168_173

namespace Legendre

/-- Indices 168 … 173, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_168 : ∀ i ∈ Finset.Ico 168 174, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 169 then exact g25_168_168 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 170 then exact g25_168_169 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 171 then exact g25_168_170 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 172 then exact g25_168_171 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 173 then exact g25_168_172 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 174 then exact g25_168_173 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
