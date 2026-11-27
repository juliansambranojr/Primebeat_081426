import PiL24_222_222
import PiL24_222_223
import PiL24_222_224
import PiL24_222_225
import PiL24_222_226
import PiL24_222_227

namespace Legendre

/-- Indices 222 … 227, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_222 : ∀ i ∈ Finset.Ico 222 228, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 223 then exact g24_222_222 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 224 then exact g24_222_223 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 225 then exact g24_222_224 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 226 then exact g24_222_225 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 227 then exact g24_222_226 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 228 then exact g24_222_227 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
