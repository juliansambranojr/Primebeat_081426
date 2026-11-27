import PiW22

namespace Legendre

set_option maxHeartbeats 0 in
theorem g22_32 : ∀ i ∈ Finset.Ico 32 40, F22 i = W22 i := by
  decide +kernel

end Legendre
