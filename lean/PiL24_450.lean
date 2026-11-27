import PiL24_450_450
import PiL24_450_451
import PiL24_450_452
import PiL24_450_453
import PiL24_450_454
import PiL24_450_455

namespace Legendre

/-- Indices 450 … 455, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_450 : ∀ i ∈ Finset.Ico 450 456, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 451 then exact g24_450_450 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 452 then exact g24_450_451 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 453 then exact g24_450_452 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 454 then exact g24_450_453 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 455 then exact g24_450_454 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 456 then exact g24_450_455 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
