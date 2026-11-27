import PiL25_498_498
import PiL25_498_499
import PiL25_498_500
import PiL25_498_501
import PiL25_498_502
import PiL25_498_503

namespace Legendre

/-- Indices 498 … 503, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_498 : ∀ i ∈ Finset.Ico 498 504, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 499 then exact g25_498_498 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 500 then exact g25_498_499 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 501 then exact g25_498_500 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 502 then exact g25_498_501 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 503 then exact g25_498_502 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 504 then exact g25_498_503 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
