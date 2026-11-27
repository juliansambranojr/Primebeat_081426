import PiL25_12_12
import PiL25_12_13
import PiL25_12_14
import PiL25_12_15
import PiL25_12_16
import PiL25_12_17

namespace Legendre

/-- Indices 12 … 17, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_12 : ∀ i ∈ Finset.Ico 12 18, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 13 then exact g25_12_12 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 14 then exact g25_12_13 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 15 then exact g25_12_14 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 16 then exact g25_12_15 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 17 then exact g25_12_16 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 18 then exact g25_12_17 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
