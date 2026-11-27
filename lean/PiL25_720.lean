import PiL25_720_720
import PiL25_720_721
import PiL25_720_722
import PiL25_720_723
import PiL25_720_724
import PiL25_720_725

namespace Legendre

/-- Indices 720 … 725, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_720 : ∀ i ∈ Finset.Ico 720 726, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 721 then exact g25_720_720 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 722 then exact g25_720_721 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 723 then exact g25_720_722 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 724 then exact g25_720_723 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 725 then exact g25_720_724 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 726 then exact g25_720_725 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
