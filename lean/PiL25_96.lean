import PiL25_96_96
import PiL25_96_97
import PiL25_96_98
import PiL25_96_99
import PiL25_96_100
import PiL25_96_101

namespace Legendre

/-- Indices 96 … 101, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_96 : ∀ i ∈ Finset.Ico 96 102, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 97 then exact g25_96_96 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 98 then exact g25_96_97 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 99 then exact g25_96_98 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 100 then exact g25_96_99 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 101 then exact g25_96_100 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 102 then exact g25_96_101 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
