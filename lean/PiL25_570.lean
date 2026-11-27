import PiL25_570_570
import PiL25_570_571
import PiL25_570_572
import PiL25_570_573
import PiL25_570_574
import PiL25_570_575

namespace Legendre

/-- Indices 570 … 575, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_570 : ∀ i ∈ Finset.Ico 570 576, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 571 then exact g25_570_570 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 572 then exact g25_570_571 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 573 then exact g25_570_572 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 574 then exact g25_570_573 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 575 then exact g25_570_574 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 576 then exact g25_570_575 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
