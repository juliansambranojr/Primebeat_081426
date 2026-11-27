import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_486 : ∀ i ∈ Finset.Ico 486 492, F24 i = W24 i := by
  decide +kernel

end Legendre
