import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_30_30 : ∀ i ∈ Finset.Ico 30 31, F25 i = W25 i := by
  decide +kernel

end Legendre
