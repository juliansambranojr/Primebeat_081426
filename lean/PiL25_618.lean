import PiL25_618_618
import PiL25_618_619
import PiL25_618_620
import PiL25_618_621
import PiL25_618_622
import PiL25_618_623

namespace Legendre

/-- Indices 618 … 623, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_618 : ∀ i ∈ Finset.Ico 618 624, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 619 then exact g25_618_618 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 620 then exact g25_618_619 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 621 then exact g25_618_620 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 622 then exact g25_618_621 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 623 then exact g25_618_622 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 624 then exact g25_618_623 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
