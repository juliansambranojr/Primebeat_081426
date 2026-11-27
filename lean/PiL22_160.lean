import PiW22

namespace Legendre

set_option maxHeartbeats 0 in
theorem g22_160 : ∀ i ∈ Finset.Ico 160 168, F22 i = W22 i := by
  decide +kernel

end Legendre
