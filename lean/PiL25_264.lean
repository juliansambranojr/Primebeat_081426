import PiL25_264_264
import PiL25_264_265
import PiL25_264_266
import PiL25_264_267
import PiL25_264_268
import PiL25_264_269

namespace Legendre

/-- Indices 264 … 269, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_264 : ∀ i ∈ Finset.Ico 264 270, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 265 then exact g25_264_264 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 266 then exact g25_264_265 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 267 then exact g25_264_266 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 268 then exact g25_264_267 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 269 then exact g25_264_268 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 270 then exact g25_264_269 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
