import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_360_362 : ∀ i ∈ Finset.Ico 362 363, F24 i = W24 i := by
  decide +kernel

end Legendre
