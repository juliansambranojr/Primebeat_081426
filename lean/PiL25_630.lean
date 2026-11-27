import PiL25_630_630
import PiL25_630_631
import PiL25_630_632
import PiL25_630_633
import PiL25_630_634
import PiL25_630_635

namespace Legendre

/-- Indices 630 … 635, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_630 : ∀ i ∈ Finset.Ico 630 636, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 631 then exact g25_630_630 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 632 then exact g25_630_631 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 633 then exact g25_630_632 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 634 then exact g25_630_633 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 635 then exact g25_630_634 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 636 then exact g25_630_635 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
