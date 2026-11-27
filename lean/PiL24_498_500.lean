import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_498_500 : ∀ i ∈ Finset.Ico 500 501, F24 i = W24 i := by
  decide +kernel

end Legendre
