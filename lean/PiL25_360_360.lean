import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_360_360 : ∀ i ∈ Finset.Ico 360 361, F25 i = W25 i := by
  decide +kernel

end Legendre
