import PiL24_282_282
import PiL24_282_283
import PiL24_282_284
import PiL24_282_285
import PiL24_282_286
import PiL24_282_287

namespace Legendre

/-- Indices 282 … 287, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_282 : ∀ i ∈ Finset.Ico 282 288, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 283 then exact g24_282_282 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 284 then exact g24_282_283 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 285 then exact g24_282_284 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 286 then exact g24_282_285 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 287 then exact g24_282_286 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 288 then exact g24_282_287 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
