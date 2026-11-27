import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_360_360 : ∀ i ∈ Finset.Ico 360 361, F24 i = W24 i := by
  decide +kernel

end Legendre
