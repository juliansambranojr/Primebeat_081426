import PiL25_84_84
import PiL25_84_85
import PiL25_84_86
import PiL25_84_87
import PiL25_84_88
import PiL25_84_89

namespace Legendre

/-- Indices 84 … 89, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_84 : ∀ i ∈ Finset.Ico 84 90, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 85 then exact g25_84_84 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 86 then exact g25_84_85 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 87 then exact g25_84_86 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 88 then exact g25_84_87 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 89 then exact g25_84_88 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 90 then exact g25_84_89 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
