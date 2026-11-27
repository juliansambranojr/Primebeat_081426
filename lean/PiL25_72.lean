import PiL25_72_72
import PiL25_72_73
import PiL25_72_74
import PiL25_72_75
import PiL25_72_76
import PiL25_72_77

namespace Legendre

/-- Indices 72 … 77, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_72 : ∀ i ∈ Finset.Ico 72 78, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 73 then exact g25_72_72 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 74 then exact g25_72_73 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 75 then exact g25_72_74 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 76 then exact g25_72_75 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 77 then exact g25_72_76 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 78 then exact g25_72_77 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
