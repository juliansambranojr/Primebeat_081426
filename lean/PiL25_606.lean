import PiL25_606_606
import PiL25_606_607
import PiL25_606_608
import PiL25_606_609
import PiL25_606_610
import PiL25_606_611

namespace Legendre

/-- Indices 606 … 611, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_606 : ∀ i ∈ Finset.Ico 606 612, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 607 then exact g25_606_606 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 608 then exact g25_606_607 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 609 then exact g25_606_608 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 610 then exact g25_606_609 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 611 then exact g25_606_610 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 612 then exact g25_606_611 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
