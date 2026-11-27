import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_240 : ∀ i ∈ Finset.Ico 240 246, F24 i = W24 i := by
  decide +kernel

end Legendre
