import PiL25_558_558
import PiL25_558_559
import PiL25_558_560
import PiL25_558_561
import PiL25_558_562
import PiL25_558_563

namespace Legendre

/-- Indices 558 … 563, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_558 : ∀ i ∈ Finset.Ico 558 564, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 559 then exact g25_558_558 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 560 then exact g25_558_559 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 561 then exact g25_558_560 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 562 then exact g25_558_561 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 563 then exact g25_558_562 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 564 then exact g25_558_563 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
