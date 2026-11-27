import PiL25_624_624
import PiL25_624_625
import PiL25_624_626
import PiL25_624_627
import PiL25_624_628
import PiL25_624_629

namespace Legendre

/-- Indices 624 … 629, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_624 : ∀ i ∈ Finset.Ico 624 630, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 625 then exact g25_624_624 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 626 then exact g25_624_625 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 627 then exact g25_624_626 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 628 then exact g25_624_627 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 629 then exact g25_624_628 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 630 then exact g25_624_629 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
