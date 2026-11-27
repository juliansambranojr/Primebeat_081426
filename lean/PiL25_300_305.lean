import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_300_305 : ∀ i ∈ Finset.Ico 305 306, F25 i = W25 i := by
  decide +kernel

end Legendre
