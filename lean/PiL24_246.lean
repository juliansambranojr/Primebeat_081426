import PiL24_246_246
import PiL24_246_247
import PiL24_246_248
import PiL24_246_249
import PiL24_246_250
import PiL24_246_251

namespace Legendre

/-- Indices 246 … 251, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_246 : ∀ i ∈ Finset.Ico 246 252, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 247 then exact g24_246_246 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 248 then exact g24_246_247 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 249 then exact g24_246_248 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 250 then exact g24_246_249 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 251 then exact g24_246_250 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 252 then exact g24_246_251 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
