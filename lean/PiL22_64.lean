import PiW22

namespace Legendre

set_option maxHeartbeats 0 in
theorem g22_64 : ∀ i ∈ Finset.Ico 64 72, F22 i = W22 i := by
  decide +kernel

end Legendre
