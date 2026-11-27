import PiL25_564_564
import PiL25_564_565
import PiL25_564_566
import PiL25_564_567
import PiL25_564_568
import PiL25_564_569

namespace Legendre

/-- Indices 564 … 569, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_564 : ∀ i ∈ Finset.Ico 564 570, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 565 then exact g25_564_564 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 566 then exact g25_564_565 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 567 then exact g25_564_566 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 568 then exact g25_564_567 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 569 then exact g25_564_568 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 570 then exact g25_564_569 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
