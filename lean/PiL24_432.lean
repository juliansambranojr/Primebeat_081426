import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_432 : ∀ i ∈ Finset.Ico 432 438, F24 i = W24 i := by
  decide +kernel

end Legendre
