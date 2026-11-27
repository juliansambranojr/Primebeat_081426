import PiW22

namespace Legendre

set_option maxHeartbeats 0 in
theorem g22_128 : ∀ i ∈ Finset.Ico 128 136, F22 i = W22 i := by
  decide +kernel

end Legendre
