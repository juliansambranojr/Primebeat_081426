import PiL25_384_384
import PiL25_384_385
import PiL25_384_386
import PiL25_384_387
import PiL25_384_388
import PiL25_384_389

namespace Legendre

/-- Indices 384 … 389, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_384 : ∀ i ∈ Finset.Ico 384 390, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 385 then exact g25_384_384 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 386 then exact g25_384_385 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 387 then exact g25_384_386 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 388 then exact g25_384_387 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 389 then exact g25_384_388 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 390 then exact g25_384_389 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
