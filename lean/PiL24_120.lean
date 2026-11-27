import PiL24_120_120
import PiL24_120_121
import PiL24_120_122
import PiL24_120_123
import PiL24_120_124
import PiL24_120_125

namespace Legendre

/-- Indices 120 … 125, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_120 : ∀ i ∈ Finset.Ico 120 126, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 121 then exact g24_120_120 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 122 then exact g24_120_121 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 123 then exact g24_120_122 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 124 then exact g24_120_123 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 125 then exact g24_120_124 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 126 then exact g24_120_125 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
