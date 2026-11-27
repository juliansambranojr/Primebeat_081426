import PiL25_546_546
import PiL25_546_547
import PiL25_546_548
import PiL25_546_549
import PiL25_546_550
import PiL25_546_551

namespace Legendre

/-- Indices 546 … 551, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_546 : ∀ i ∈ Finset.Ico 546 552, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 547 then exact g25_546_546 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 548 then exact g25_546_547 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 549 then exact g25_546_548 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 550 then exact g25_546_549 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 551 then exact g25_546_550 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 552 then exact g25_546_551 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
