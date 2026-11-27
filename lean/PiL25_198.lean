import PiL25_198_198
import PiL25_198_199
import PiL25_198_200
import PiL25_198_201
import PiL25_198_202
import PiL25_198_203

namespace Legendre

/-- Indices 198 … 203, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_198 : ∀ i ∈ Finset.Ico 198 204, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 199 then exact g25_198_198 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 200 then exact g25_198_199 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 201 then exact g25_198_200 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 202 then exact g25_198_201 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 203 then exact g25_198_202 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 204 then exact g25_198_203 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
