import PiL25_378_378
import PiL25_378_379
import PiL25_378_380
import PiL25_378_381
import PiL25_378_382
import PiL25_378_383

namespace Legendre

/-- Indices 378 … 383, one kernel evaluation per file (a block of them exceeds one process's memory). -/
theorem g25_378 : ∀ i ∈ Finset.Ico 378 384, F25 i = W25 i := by
  intro i hi
  have h := Finset.mem_Ico.mp hi
  if h0 : i < 379 then exact g25_378_378 i (Finset.mem_Ico.mpr ⟨by omega, h0⟩)
  else if h1 : i < 380 then exact g25_378_379 i (Finset.mem_Ico.mpr ⟨by omega, h1⟩)
  else if h2 : i < 381 then exact g25_378_380 i (Finset.mem_Ico.mpr ⟨by omega, h2⟩)
  else if h3 : i < 382 then exact g25_378_381 i (Finset.mem_Ico.mpr ⟨by omega, h3⟩)
  else if h4 : i < 383 then exact g25_378_382 i (Finset.mem_Ico.mpr ⟨by omega, h4⟩)
  else if h5 : i < 384 then exact g25_378_383 i (Finset.mem_Ico.mpr ⟨by omega, h5⟩)
  else omega

end Legendre
