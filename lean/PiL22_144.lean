import PiW22

namespace Legendre

set_option maxHeartbeats 0 in
theorem g22_144 : ∀ i ∈ Finset.Ico 144 152, F22 i = W22 i := by
  decide +kernel

end Legendre
