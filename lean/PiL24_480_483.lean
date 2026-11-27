import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_480_483 : ∀ i ∈ Finset.Ico 483 484, F24 i = W24 i := by
  decide +kernel

end Legendre
