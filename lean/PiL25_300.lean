import PiL25_300_300
import PiL25_300_301
import PiL25_300_302
import PiL25_300_303
import PiL25_300_304
import PiL25_300_305

namespace Legendre

/-- Indices 300 … 305, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_300 : ∀ i ∈ Finset.Ico 300 306, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 301 then exact g25_300_300 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 302 then exact g25_300_301 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 303 then exact g25_300_302 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 304 then exact g25_300_303 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 305 then exact g25_300_304 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 306 then exact g25_300_305 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
