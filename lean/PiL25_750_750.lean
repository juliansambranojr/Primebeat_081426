import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_750_750 : ∀ i ∈ Finset.Ico 750 751, F25 i = W25 i := by
  decide +kernel

end Legendre
