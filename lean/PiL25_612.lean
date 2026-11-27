import PiL25_612_612
import PiL25_612_613
import PiL25_612_614
import PiL25_612_615
import PiL25_612_616
import PiL25_612_617

namespace Legendre

/-- Indices 612 … 617, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_612 : ∀ i ∈ Finset.Ico 612 618, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 613 then exact g25_612_612 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 614 then exact g25_612_613 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 615 then exact g25_612_614 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 616 then exact g25_612_615 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 617 then exact g25_612_616 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 618 then exact g25_612_617 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
