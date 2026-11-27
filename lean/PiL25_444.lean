import PiL25_444_444
import PiL25_444_445
import PiL25_444_446
import PiL25_444_447
import PiL25_444_448
import PiL25_444_449

namespace Legendre

/-- Indices 444 … 449, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_444 : ∀ i ∈ Finset.Ico 444 450, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 445 then exact g25_444_444 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 446 then exact g25_444_445 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 447 then exact g25_444_446 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 448 then exact g25_444_447 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 449 then exact g25_444_448 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 450 then exact g25_444_449 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
