import PiL25_288_288
import PiL25_288_289
import PiL25_288_290
import PiL25_288_291
import PiL25_288_292
import PiL25_288_293

namespace Legendre

/-- Indices 288 … 293, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_288 : ∀ i ∈ Finset.Ico 288 294, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 289 then exact g25_288_288 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 290 then exact g25_288_289 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 291 then exact g25_288_290 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 292 then exact g25_288_291 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 293 then exact g25_288_292 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 294 then exact g25_288_293 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
