import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_360_365 : ∀ i ∈ Finset.Ico 365 366, F25 i = W25 i := by
  decide +kernel

end Legendre
