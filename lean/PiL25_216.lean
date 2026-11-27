import PiL25_216_216
import PiL25_216_217
import PiL25_216_218
import PiL25_216_219
import PiL25_216_220
import PiL25_216_221

namespace Legendre

/-- Indices 216 … 221, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_216 : ∀ i ∈ Finset.Ico 216 222, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 217 then exact g25_216_216 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 218 then exact g25_216_217 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 219 then exact g25_216_218 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 220 then exact g25_216_219 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 221 then exact g25_216_220 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 222 then exact g25_216_221 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
