import PiL25_30_30
import PiL25_30_31
import PiL25_30_32
import PiL25_30_33
import PiL25_30_34
import PiL25_30_35

namespace Legendre

/-- Indices 30 … 35, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_30 : ∀ i ∈ Finset.Ico 30 36, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 31 then exact g25_30_30 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 32 then exact g25_30_31 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 33 then exact g25_30_32 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 34 then exact g25_30_33 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 35 then exact g25_30_34 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 36 then exact g25_30_35 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
