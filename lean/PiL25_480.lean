import PiL25_480_480
import PiL25_480_481
import PiL25_480_482
import PiL25_480_483
import PiL25_480_484
import PiL25_480_485

namespace Legendre

/-- Indices 480 … 485, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_480 : ∀ i ∈ Finset.Ico 480 486, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 481 then exact g25_480_480 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 482 then exact g25_480_481 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 483 then exact g25_480_482 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 484 then exact g25_480_483 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 485 then exact g25_480_484 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 486 then exact g25_480_485 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
