import PiW22

namespace Legendre

set_option maxHeartbeats 0 in
theorem g22_192 : ∀ i ∈ Finset.Ico 192 200, F22 i = W22 i := by
  decide +kernel

end Legendre
