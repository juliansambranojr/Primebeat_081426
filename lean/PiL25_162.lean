import PiL25_162_162
import PiL25_162_163
import PiL25_162_164
import PiL25_162_165
import PiL25_162_166
import PiL25_162_167

namespace Legendre

/-- Indices 162 … 167, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_162 : ∀ i ∈ Finset.Ico 162 168, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 163 then exact g25_162_162 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 164 then exact g25_162_163 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 165 then exact g25_162_164 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 166 then exact g25_162_165 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 167 then exact g25_162_166 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 168 then exact g25_162_167 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
