import PiL25_714_714
import PiL25_714_715
import PiL25_714_716
import PiL25_714_717
import PiL25_714_718
import PiL25_714_719

namespace Legendre

/-- Indices 714 … 719, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_714 : ∀ i ∈ Finset.Ico 714 720, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 715 then exact g25_714_714 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 716 then exact g25_714_715 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 717 then exact g25_714_716 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 718 then exact g25_714_717 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 719 then exact g25_714_718 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 720 then exact g25_714_719 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
