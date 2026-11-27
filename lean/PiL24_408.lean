import PiL24_408_408
import PiL24_408_409
import PiL24_408_410
import PiL24_408_411
import PiL24_408_412
import PiL24_408_413

namespace Legendre

/-- Indices 408 … 413, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_408 : ∀ i ∈ Finset.Ico 408 414, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 409 then exact g24_408_408 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 410 then exact g24_408_409 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 411 then exact g24_408_410 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 412 then exact g24_408_411 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 413 then exact g24_408_412 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 414 then exact g24_408_413 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
