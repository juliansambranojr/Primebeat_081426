import PiW22

namespace Legendre

set_option maxHeartbeats 0 in
theorem g22_240 : ∀ i ∈ Finset.Ico 240 248, F22 i = W22 i := by
  decide +kernel

end Legendre
