import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_360_363 : ∀ i ∈ Finset.Ico 363 364, F24 i = W24 i := by
  decide +kernel

end Legendre
