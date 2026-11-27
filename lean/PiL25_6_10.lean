import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_6_10 : ∀ i ∈ Finset.Ico 10 11, F25 i = W25 i := by
  decide +kernel

end Legendre
