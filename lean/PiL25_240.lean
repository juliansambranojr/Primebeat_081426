import PiL25_240_240
import PiL25_240_241
import PiL25_240_242
import PiL25_240_243
import PiL25_240_244
import PiL25_240_245

namespace Legendre

/-- Indices 240 … 245, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_240 : ∀ i ∈ Finset.Ico 240 246, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 241 then exact g25_240_240 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 242 then exact g25_240_241 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 243 then exact g25_240_242 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 244 then exact g25_240_243 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 245 then exact g25_240_244 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 246 then exact g25_240_245 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
