import PiL24_402_402
import PiL24_402_403
import PiL24_402_404
import PiL24_402_405
import PiL24_402_406
import PiL24_402_407

namespace Legendre

/-- Indices 402 … 407, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_402 : ∀ i ∈ Finset.Ico 402 408, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 403 then exact g24_402_402 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 404 then exact g24_402_403 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 405 then exact g24_402_404 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 406 then exact g24_402_405 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 407 then exact g24_402_406 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 408 then exact g24_402_407 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
