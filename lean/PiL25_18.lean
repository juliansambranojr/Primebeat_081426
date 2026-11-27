import PiL25_18_18
import PiL25_18_19
import PiL25_18_20
import PiL25_18_21
import PiL25_18_22
import PiL25_18_23

namespace Legendre

/-- Indices 18 … 23, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_18 : ∀ i ∈ Finset.Ico 18 24, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 19 then exact g25_18_18 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 20 then exact g25_18_19 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 21 then exact g25_18_20 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 22 then exact g25_18_21 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 23 then exact g25_18_22 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 24 then exact g25_18_23 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
