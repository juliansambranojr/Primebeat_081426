import PiL24_306_306
import PiL24_306_307
import PiL24_306_308
import PiL24_306_309
import PiL24_306_310
import PiL24_306_311

namespace Legendre

/-- Indices 306 … 311, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g24_306 : ∀ i ∈ Finset.Ico 306 312, F24 i = W24 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 307 then exact g24_306_306 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 308 then exact g24_306_307 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 309 then exact g24_306_308 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 310 then exact g24_306_309 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 311 then exact g24_306_310 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 312 then exact g24_306_311 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
