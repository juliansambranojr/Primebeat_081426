import PiL25_534_534
import PiL25_534_535
import PiL25_534_536
import PiL25_534_537
import PiL25_534_538
import PiL25_534_539

namespace Legendre

/-- Indices 534 … 539, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_534 : ∀ i ∈ Finset.Ico 534 540, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 535 then exact g25_534_534 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 536 then exact g25_534_535 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 537 then exact g25_534_536 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 538 then exact g25_534_537 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 539 then exact g25_534_538 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 540 then exact g25_534_539 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
