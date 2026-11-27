import PiL24_144_144
import PiL24_144_145
import PiL24_144_146
import PiL24_144_147
import PiL24_144_148
import PiL24_144_149

namespace Legendre

/-- Indices 144 … 149, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_144 : ∀ i ∈ Finset.Ico 144 150, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 145 then exact g24_144_144 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 146 then exact g24_144_145 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 147 then exact g24_144_146 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 148 then exact g24_144_147 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 149 then exact g24_144_148 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 150 then exact g24_144_149 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
