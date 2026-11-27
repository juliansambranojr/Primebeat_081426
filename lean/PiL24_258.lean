import PiL24_258_258
import PiL24_258_259
import PiL24_258_260
import PiL24_258_261
import PiL24_258_262
import PiL24_258_263

namespace Legendre

/-- Indices 258 … 263, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_258 : ∀ i ∈ Finset.Ico 258 264, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 259 then exact g24_258_258 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 260 then exact g24_258_259 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 261 then exact g24_258_260 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 262 then exact g24_258_261 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 263 then exact g24_258_262 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 264 then exact g24_258_263 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
