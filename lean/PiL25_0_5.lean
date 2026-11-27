import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_0_5 : ∀ i ∈ Finset.Ico 5 6, F25 i = W25 i := by
  decide +kernel

end Legendre
