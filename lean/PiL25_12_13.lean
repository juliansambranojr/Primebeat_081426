import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_12_13 : ∀ i ∈ Finset.Ico 13 14, F25 i = W25 i := by
  decide +kernel

end Legendre
