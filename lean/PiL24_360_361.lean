import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_360_361 : ∀ i ∈ Finset.Ico 361 362, F24 i = W24 i := by
  decide +kernel

end Legendre
