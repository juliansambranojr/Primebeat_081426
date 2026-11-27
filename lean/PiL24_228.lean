import PiL24_228_228
import PiL24_228_229
import PiL24_228_230
import PiL24_228_231
import PiL24_228_232
import PiL24_228_233

namespace Legendre

/-- Indices 228 … 233, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_228 : ∀ i ∈ Finset.Ico 228 234, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 229 then exact g24_228_228 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 230 then exact g24_228_229 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 231 then exact g24_228_230 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 232 then exact g24_228_231 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 233 then exact g24_228_232 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 234 then exact g24_228_233 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
