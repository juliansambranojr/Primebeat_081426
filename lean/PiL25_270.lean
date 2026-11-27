import PiL25_270_270
import PiL25_270_271
import PiL25_270_272
import PiL25_270_273
import PiL25_270_274
import PiL25_270_275

namespace Legendre

/-- Indices 270 … 275, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_270 : ∀ i ∈ Finset.Ico 270 276, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 271 then exact g25_270_270 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 272 then exact g25_270_271 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 273 then exact g25_270_272 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 274 then exact g25_270_273 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 275 then exact g25_270_274 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 276 then exact g25_270_275 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
