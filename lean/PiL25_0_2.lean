import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_0_2 : ∀ i ∈ Finset.Ico 2 3, F25 i = W25 i := by
  decide +kernel

end Legendre
