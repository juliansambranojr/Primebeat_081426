import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_360_364 : ∀ i ∈ Finset.Ico 364 365, F24 i = W24 i := by
  decide +kernel

end Legendre
