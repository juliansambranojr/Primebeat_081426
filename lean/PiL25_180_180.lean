import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_180_180 : ∀ i ∈ Finset.Ico 180 181, F25 i = W25 i := by
  decide +kernel

end Legendre
