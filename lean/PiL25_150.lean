import PiL25_150_150
import PiL25_150_151
import PiL25_150_152
import PiL25_150_153
import PiL25_150_154
import PiL25_150_155

namespace Legendre

/-- Indices 150 … 155, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_150 : ∀ i ∈ Finset.Ico 150 156, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 151 then exact g25_150_150 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 152 then exact g25_150_151 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 153 then exact g25_150_152 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 154 then exact g25_150_153 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 155 then exact g25_150_154 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 156 then exact g25_150_155 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
