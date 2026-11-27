import PiL24_336_336
import PiL24_336_337
import PiL24_336_338
import PiL24_336_339
import PiL24_336_340
import PiL24_336_341

namespace Legendre

/-- Indices 336 … 341, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_336 : ∀ i ∈ Finset.Ico 336 342, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 337 then exact g24_336_336 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 338 then exact g24_336_337 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 339 then exact g24_336_338 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 340 then exact g24_336_339 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 341 then exact g24_336_340 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 342 then exact g24_336_341 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
