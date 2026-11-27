import PiL25_540_540
import PiL25_540_541
import PiL25_540_542
import PiL25_540_543
import PiL25_540_544
import PiL25_540_545

namespace Legendre

/-- Indices 540 … 545, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_540 : ∀ i ∈ Finset.Ico 540 546, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 541 then exact g25_540_540 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 542 then exact g25_540_541 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 543 then exact g25_540_542 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 544 then exact g25_540_543 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 545 then exact g25_540_544 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 546 then exact g25_540_545 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
