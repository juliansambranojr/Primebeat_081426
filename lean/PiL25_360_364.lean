import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_360_364 : ∀ i ∈ Finset.Ico 364 365, F25 i = W25 i := by
  decide +kernel

end Legendre
