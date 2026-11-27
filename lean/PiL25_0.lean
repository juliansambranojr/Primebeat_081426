import PiL25_0_0
import PiL25_0_1
import PiL25_0_2
import PiL25_0_3
import PiL25_0_4
import PiL25_0_5

namespace Legendre

/-- Indices 0 … 5, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_0 : ∀ i ∈ Finset.Ico 0 6, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 1 then exact g25_0_0 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 2 then exact g25_0_1 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 3 then exact g25_0_2 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 4 then exact g25_0_3 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 5 then exact g25_0_4 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 6 then exact g25_0_5 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
