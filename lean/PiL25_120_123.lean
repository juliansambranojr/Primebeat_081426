import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_120_123 : ∀ i ∈ Finset.Ico 123 124, F25 i = W25 i := by
  decide +kernel

end Legendre
