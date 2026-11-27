import PiL25_42_42
import PiL25_42_43
import PiL25_42_44
import PiL25_42_45
import PiL25_42_46
import PiL25_42_47

namespace Legendre

/-- Indices 42 … 47, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_42 : ∀ i ∈ Finset.Ico 42 48, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 43 then exact g25_42_42 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 44 then exact g25_42_43 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 45 then exact g25_42_44 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 46 then exact g25_42_45 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 47 then exact g25_42_46 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 48 then exact g25_42_47 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
