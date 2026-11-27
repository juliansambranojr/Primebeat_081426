import PiL25_654_654
import PiL25_654_655
import PiL25_654_656
import PiL25_654_657
import PiL25_654_658
import PiL25_654_659

namespace Legendre

/-- Indices 654 … 659, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_654 : ∀ i ∈ Finset.Ico 654 660, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 655 then exact g25_654_654 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 656 then exact g25_654_655 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 657 then exact g25_654_656 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 658 then exact g25_654_657 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 659 then exact g25_654_658 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 660 then exact g25_654_659 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
