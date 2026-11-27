import PiL25_186_186
import PiL25_186_187
import PiL25_186_188
import PiL25_186_189
import PiL25_186_190
import PiL25_186_191

namespace Legendre

/-- Indices 186 … 191, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_186 : ∀ i ∈ Finset.Ico 186 192, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 187 then exact g25_186_186 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 188 then exact g25_186_187 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 189 then exact g25_186_188 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 190 then exact g25_186_189 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 191 then exact g25_186_190 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 192 then exact g25_186_191 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
