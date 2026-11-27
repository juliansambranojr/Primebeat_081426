import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_306 : ∀ i ∈ Finset.Ico 306 312, F24 i = W24 i := by
  decide +kernel

end Legendre
