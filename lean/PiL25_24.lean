import PiL25_24_24
import PiL25_24_25
import PiL25_24_26
import PiL25_24_27
import PiL25_24_28
import PiL25_24_29

namespace Legendre

/-- Indices 24 … 29, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_24 : ∀ i ∈ Finset.Ico 24 30, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 25 then exact g25_24_24 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 26 then exact g25_24_25 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 27 then exact g25_24_26 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 28 then exact g25_24_27 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 29 then exact g25_24_28 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 30 then exact g25_24_29 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
