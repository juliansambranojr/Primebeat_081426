import PiL24_156_156
import PiL24_156_157
import PiL24_156_158
import PiL24_156_159
import PiL24_156_160
import PiL24_156_161

namespace Legendre

/-- Indices 156 … 161, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_156 : ∀ i ∈ Finset.Ico 156 162, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 157 then exact g24_156_156 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 158 then exact g24_156_157 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 159 then exact g24_156_158 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 160 then exact g24_156_159 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 161 then exact g24_156_160 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 162 then exact g24_156_161 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
