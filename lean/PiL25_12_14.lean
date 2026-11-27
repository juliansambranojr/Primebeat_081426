import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_12_14 : ∀ i ∈ Finset.Ico 14 15, F25 i = W25 i := by
  decide +kernel

end Legendre
