import PiL25_456_456
import PiL25_456_457
import PiL25_456_458
import PiL25_456_459
import PiL25_456_460
import PiL25_456_461

namespace Legendre

/-- Indices 456 … 461, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_456 : ∀ i ∈ Finset.Ico 456 462, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 457 then exact g25_456_456 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 458 then exact g25_456_457 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 459 then exact g25_456_458 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 460 then exact g25_456_459 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 461 then exact g25_456_460 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 462 then exact g25_456_461 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
