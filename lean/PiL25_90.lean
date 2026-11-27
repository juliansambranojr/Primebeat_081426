import PiL25_90_90
import PiL25_90_91
import PiL25_90_92
import PiL25_90_93
import PiL25_90_94
import PiL25_90_95

namespace Legendre

/-- Indices 90 … 95, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_90 : ∀ i ∈ Finset.Ico 90 96, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 91 then exact g25_90_90 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 92 then exact g25_90_91 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 93 then exact g25_90_92 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 94 then exact g25_90_93 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 95 then exact g25_90_94 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 96 then exact g25_90_95 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
