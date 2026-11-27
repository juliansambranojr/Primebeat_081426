import PiL24_504_504
import PiL24_504_505
import PiL24_504_506
import PiL24_504_507
import PiL24_504_508
import PiL24_504_509

namespace Legendre

/-- Indices 504 … 509, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_504 : ∀ i ∈ Finset.Ico 504 510, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 505 then exact g24_504_504 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 506 then exact g24_504_505 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 507 then exact g24_504_506 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 508 then exact g24_504_507 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 509 then exact g24_504_508 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 510 then exact g24_504_509 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
