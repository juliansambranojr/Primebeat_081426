import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_120_120 : ∀ i ∈ Finset.Ico 120 121, F25 i = W25 i := by
  decide +kernel

end Legendre
