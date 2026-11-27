import PiW22

namespace Legendre

set_option maxHeartbeats 0 in
theorem g22_16 : ∀ i ∈ Finset.Ico 16 24, F22 i = W22 i := by
  decide +kernel

end Legendre
