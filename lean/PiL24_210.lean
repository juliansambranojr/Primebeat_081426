import PiL24_210_210
import PiL24_210_211
import PiL24_210_212
import PiL24_210_213
import PiL24_210_214
import PiL24_210_215

namespace Legendre

/-- Indices 210 … 215, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_210 : ∀ i ∈ Finset.Ico 210 216, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 211 then exact g24_210_210 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 212 then exact g24_210_211 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 213 then exact g24_210_212 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 214 then exact g24_210_213 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 215 then exact g24_210_214 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 216 then exact g24_210_215 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
