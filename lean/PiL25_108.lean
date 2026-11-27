import PiL25_108_108
import PiL25_108_109
import PiL25_108_110
import PiL25_108_111
import PiL25_108_112
import PiL25_108_113

namespace Legendre

/-- Indices 108 … 113, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_108 : ∀ i ∈ Finset.Ico 108 114, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 109 then exact g25_108_108 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 110 then exact g25_108_109 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 111 then exact g25_108_110 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 112 then exact g25_108_111 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 113 then exact g25_108_112 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 114 then exact g25_108_113 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
