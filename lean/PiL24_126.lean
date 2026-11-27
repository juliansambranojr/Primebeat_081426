import PiL24_126_126
import PiL24_126_127
import PiL24_126_128
import PiL24_126_129
import PiL24_126_130
import PiL24_126_131

namespace Legendre

/-- Indices 126 … 131, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_126 : ∀ i ∈ Finset.Ico 126 132, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 127 then exact g24_126_126 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 128 then exact g24_126_127 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 129 then exact g24_126_128 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 130 then exact g24_126_129 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 131 then exact g24_126_130 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 132 then exact g24_126_131 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
