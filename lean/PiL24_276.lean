import PiL24_276_276
import PiL24_276_277
import PiL24_276_278
import PiL24_276_279
import PiL24_276_280
import PiL24_276_281

namespace Legendre

/-- Indices 276 … 281, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_276 : ∀ i ∈ Finset.Ico 276 282, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 277 then exact g24_276_276 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 278 then exact g24_276_277 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 279 then exact g24_276_278 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 280 then exact g24_276_279 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 281 then exact g24_276_280 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 282 then exact g24_276_281 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
