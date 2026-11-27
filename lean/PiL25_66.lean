import PiL25_66_66
import PiL25_66_67
import PiL25_66_68
import PiL25_66_69
import PiL25_66_70
import PiL25_66_71

namespace Legendre

/-- Indices 66 … 71, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_66 : ∀ i ∈ Finset.Ico 66 72, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 67 then exact g25_66_66 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 68 then exact g25_66_67 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 69 then exact g25_66_68 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 70 then exact g25_66_69 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 71 then exact g25_66_70 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 72 then exact g25_66_71 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
