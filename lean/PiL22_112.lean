import PiW22

namespace Legendre

set_option maxHeartbeats 0 in
theorem g22_112 : ∀ i ∈ Finset.Ico 112 120, F22 i = W22 i := by
  decide +kernel

end Legendre
