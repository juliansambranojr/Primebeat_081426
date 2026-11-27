import PiL25_36_36
import PiL25_36_37
import PiL25_36_38
import PiL25_36_39
import PiL25_36_40
import PiL25_36_41

namespace Legendre

/-- Indices 36 … 41, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_36 : ∀ i ∈ Finset.Ico 36 42, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 37 then exact g25_36_36 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 38 then exact g25_36_37 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 39 then exact g25_36_38 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 40 then exact g25_36_39 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 41 then exact g25_36_40 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 42 then exact g25_36_41 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
