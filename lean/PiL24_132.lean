import PiL24_132_132
import PiL24_132_133
import PiL24_132_134
import PiL24_132_135
import PiL24_132_136
import PiL24_132_137

namespace Legendre

/-- Indices 132 … 137, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_132 : ∀ i ∈ Finset.Ico 132 138, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 133 then exact g24_132_132 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 134 then exact g24_132_133 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 135 then exact g24_132_134 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 136 then exact g24_132_135 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 137 then exact g24_132_136 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 138 then exact g24_132_137 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
