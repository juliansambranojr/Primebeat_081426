import PiL25_516_516
import PiL25_516_517
import PiL25_516_518
import PiL25_516_519
import PiL25_516_520
import PiL25_516_521

namespace Legendre

/-- Indices 516 … 521, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_516 : ∀ i ∈ Finset.Ico 516 522, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 517 then exact g25_516_516 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 518 then exact g25_516_517 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 519 then exact g25_516_518 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 520 then exact g25_516_519 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 521 then exact g25_516_520 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 522 then exact g25_516_521 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
