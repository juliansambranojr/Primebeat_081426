import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_48 : ∀ i ∈ Finset.Ico 48 54, F24 i = W24 i := by
  decide +kernel

end Legendre
