import PiW22

namespace Legendre

set_option maxHeartbeats 0 in
theorem g22_40 : ∀ i ∈ Finset.Ico 40 48, F22 i = W22 i := by
  decide +kernel

end Legendre
