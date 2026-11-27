import PiL25_420_420
import PiL25_420_421
import PiL25_420_422
import PiL25_420_423
import PiL25_420_424
import PiL25_420_425

namespace Legendre

/-- Indices 420 … 425, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_420 : ∀ i ∈ Finset.Ico 420 426, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 421 then exact g25_420_420 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 422 then exact g25_420_421 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 423 then exact g25_420_422 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 424 then exact g25_420_423 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 425 then exact g25_420_424 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 426 then exact g25_420_425 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
