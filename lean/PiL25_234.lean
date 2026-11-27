import PiL25_234_234
import PiL25_234_235
import PiL25_234_236
import PiL25_234_237
import PiL25_234_238
import PiL25_234_239

namespace Legendre

/-- Indices 234 … 239, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_234 : ∀ i ∈ Finset.Ico 234 240, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 235 then exact g25_234_234 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 236 then exact g25_234_235 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 237 then exact g25_234_236 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 238 then exact g25_234_237 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 239 then exact g25_234_238 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 240 then exact g25_234_239 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
