import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_12_15 : ∀ i ∈ Finset.Ico 15 16, F25 i = W25 i := by
  decide +kernel

end Legendre
