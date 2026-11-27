import PiL25_6_6
import PiL25_6_7
import PiL25_6_8
import PiL25_6_9
import PiL25_6_10
import PiL25_6_11

namespace Legendre

/-- Indices 6 … 11, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_6 : ∀ i ∈ Finset.Ico 6 12, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 7 then exact g25_6_6 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 8 then exact g25_6_7 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 9 then exact g25_6_8 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 10 then exact g25_6_9 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 11 then exact g25_6_10 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 12 then exact g25_6_11 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
