import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_90_95 : ∀ i ∈ Finset.Ico 95 96, F25 i = W25 i := by
  decide +kernel

end Legendre
