import PiL25_252_252
import PiL25_252_253
import PiL25_252_254
import PiL25_252_255
import PiL25_252_256
import PiL25_252_257

namespace Legendre

/-- Indices 252 … 257, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_252 : ∀ i ∈ Finset.Ico 252 258, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 253 then exact g25_252_252 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 254 then exact g25_252_253 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 255 then exact g25_252_254 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 256 then exact g25_252_255 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 257 then exact g25_252_256 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 258 then exact g25_252_257 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
