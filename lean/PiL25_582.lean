import PiL25_582_582
import PiL25_582_583
import PiL25_582_584
import PiL25_582_585
import PiL25_582_586
import PiL25_582_587

namespace Legendre

/-- Indices 582 … 587, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_582 : ∀ i ∈ Finset.Ico 582 588, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 583 then exact g25_582_582 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 584 then exact g25_582_583 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 585 then exact g25_582_584 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 586 then exact g25_582_585 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 587 then exact g25_582_586 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 588 then exact g25_582_587 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
