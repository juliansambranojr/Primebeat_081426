import PiL25_576_576
import PiL25_576_577
import PiL25_576_578
import PiL25_576_579
import PiL25_576_580
import PiL25_576_581

namespace Legendre

/-- Indices 576 … 581, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_576 : ∀ i ∈ Finset.Ico 576 582, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 577 then exact g25_576_576 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 578 then exact g25_576_577 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 579 then exact g25_576_578 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 580 then exact g25_576_579 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 581 then exact g25_576_580 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 582 then exact g25_576_581 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
