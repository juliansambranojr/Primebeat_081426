import PiL25_60_60
import PiL25_60_61
import PiL25_60_62
import PiL25_60_63
import PiL25_60_64
import PiL25_60_65

namespace Legendre

/-- Indices 60 … 65, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_60 : ∀ i ∈ Finset.Ico 60 66, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 61 then exact g25_60_60 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 62 then exact g25_60_61 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 63 then exact g25_60_62 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 64 then exact g25_60_63 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 65 then exact g25_60_64 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 66 then exact g25_60_65 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
