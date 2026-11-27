import PiL25_294_294
import PiL25_294_295
import PiL25_294_296
import PiL25_294_297
import PiL25_294_298
import PiL25_294_299

namespace Legendre

/-- Indices 294 … 299, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_294 : ∀ i ∈ Finset.Ico 294 300, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 295 then exact g25_294_294 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 296 then exact g25_294_295 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 297 then exact g25_294_296 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 298 then exact g25_294_297 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 299 then exact g25_294_298 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 300 then exact g25_294_299 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
