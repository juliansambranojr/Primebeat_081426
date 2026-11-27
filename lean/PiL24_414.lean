import PiL24_414_414
import PiL24_414_415
import PiL24_414_416
import PiL24_414_417
import PiL24_414_418
import PiL24_414_419

namespace Legendre

/-- Indices 414 … 419, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_414 : ∀ i ∈ Finset.Ico 414 420, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 415 then exact g24_414_414 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 416 then exact g24_414_415 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 417 then exact g24_414_416 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 418 then exact g24_414_417 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 419 then exact g24_414_418 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 420 then exact g24_414_419 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
