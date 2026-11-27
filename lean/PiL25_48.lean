import PiL25_48_48
import PiL25_48_49
import PiL25_48_50
import PiL25_48_51
import PiL25_48_52
import PiL25_48_53

namespace Legendre

/-- Indices 48 … 53, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_48 : ∀ i ∈ Finset.Ico 48 54, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 49 then exact g25_48_48 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 50 then exact g25_48_49 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 51 then exact g25_48_50 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 52 then exact g25_48_51 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 53 then exact g25_48_52 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 54 then exact g25_48_53 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
