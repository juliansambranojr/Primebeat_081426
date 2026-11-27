import PiL25_588_588
import PiL25_588_589
import PiL25_588_590
import PiL25_588_591
import PiL25_588_592
import PiL25_588_593

namespace Legendre

/-- Indices 588 … 593, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_588 : ∀ i ∈ Finset.Ico 588 594, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 589 then exact g25_588_588 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 590 then exact g25_588_589 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 591 then exact g25_588_590 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 592 then exact g25_588_591 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 593 then exact g25_588_592 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 594 then exact g25_588_593 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
