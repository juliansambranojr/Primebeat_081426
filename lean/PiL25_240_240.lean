import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_240_240 : ∀ i ∈ Finset.Ico 240 241, F25 i = W25 i := by
  decide +kernel

end Legendre
