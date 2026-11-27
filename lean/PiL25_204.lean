import PiL25_204_204
import PiL25_204_205
import PiL25_204_206
import PiL25_204_207
import PiL25_204_208
import PiL25_204_209

namespace Legendre

/-- Indices 204 … 209, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_204 : ∀ i ∈ Finset.Ico 204 210, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 205 then exact g25_204_204 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 206 then exact g25_204_205 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 207 then exact g25_204_206 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 208 then exact g25_204_207 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 209 then exact g25_204_208 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 210 then exact g25_204_209 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
