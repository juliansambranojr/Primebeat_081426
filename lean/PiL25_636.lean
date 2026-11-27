import PiL25_636_636
import PiL25_636_637
import PiL25_636_638
import PiL25_636_639
import PiL25_636_640
import PiL25_636_641

namespace Legendre

/-- Indices 636 … 641, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_636 : ∀ i ∈ Finset.Ico 636 642, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 637 then exact g25_636_636 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 638 then exact g25_636_637 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 639 then exact g25_636_638 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 640 then exact g25_636_639 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 641 then exact g25_636_640 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 642 then exact g25_636_641 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
