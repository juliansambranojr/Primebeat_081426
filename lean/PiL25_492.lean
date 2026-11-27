import PiL25_492_492
import PiL25_492_493
import PiL25_492_494
import PiL25_492_495
import PiL25_492_496
import PiL25_492_497

namespace Legendre

/-- Indices 492 … 497, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_492 : ∀ i ∈ Finset.Ico 492 498, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 493 then exact g25_492_492 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 494 then exact g25_492_493 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 495 then exact g25_492_494 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 496 then exact g25_492_495 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 497 then exact g25_492_496 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 498 then exact g25_492_497 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
