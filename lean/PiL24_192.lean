import PiL24_192_192
import PiL24_192_193
import PiL24_192_194
import PiL24_192_195
import PiL24_192_196
import PiL24_192_197

namespace Legendre

/-- Indices 192 … 197, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_192 : ∀ i ∈ Finset.Ico 192 198, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 193 then exact g24_192_192 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 194 then exact g24_192_193 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 195 then exact g24_192_194 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 196 then exact g24_192_195 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 197 then exact g24_192_196 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 198 then exact g24_192_197 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
