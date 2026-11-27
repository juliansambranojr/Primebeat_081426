import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_102 : ∀ i ∈ Finset.Ico 102 108, F24 i = W24 i := by
  decide +kernel

end Legendre
