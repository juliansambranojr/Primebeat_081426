import PiL24_552_552
import PiL24_552_553
import PiL24_552_554
import PiL24_552_555
import PiL24_552_556
import PiL24_552_557

namespace Legendre

/-- Indices 552 … 557, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_552 : ∀ i ∈ Finset.Ico 552 558, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 553 then exact g24_552_552 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 554 then exact g24_552_553 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 555 then exact g24_552_554 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 556 then exact g24_552_555 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 557 then exact g24_552_556 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 558 then exact g24_552_557 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
