import PiL24_330_330
import PiL24_330_331
import PiL24_330_332
import PiL24_330_333
import PiL24_330_334
import PiL24_330_335

namespace Legendre

/-- Indices 330 … 335, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_330 : ∀ i ∈ Finset.Ico 330 336, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 331 then exact g24_330_330 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 332 then exact g24_330_331 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 333 then exact g24_330_332 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 334 then exact g24_330_333 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 335 then exact g24_330_334 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 336 then exact g24_330_335 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
