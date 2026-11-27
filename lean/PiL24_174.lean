import PiL24_174_174
import PiL24_174_175
import PiL24_174_176
import PiL24_174_177
import PiL24_174_178
import PiL24_174_179

namespace Legendre

/-- Indices 174 … 179, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_174 : ∀ i ∈ Finset.Ico 174 180, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 175 then exact g24_174_174 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 176 then exact g24_174_175 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 177 then exact g24_174_176 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 178 then exact g24_174_177 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 179 then exact g24_174_178 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 180 then exact g24_174_179 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
