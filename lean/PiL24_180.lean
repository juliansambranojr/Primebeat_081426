import PiL24_180_180
import PiL24_180_181
import PiL24_180_182
import PiL24_180_183
import PiL24_180_184
import PiL24_180_185

namespace Legendre

/-- Indices 180 … 185, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_180 : ∀ i ∈ Finset.Ico 180 186, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 181 then exact g24_180_180 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 182 then exact g24_180_181 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 183 then exact g24_180_182 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 184 then exact g24_180_183 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 185 then exact g24_180_184 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 186 then exact g24_180_185 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
