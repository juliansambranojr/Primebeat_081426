import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_12 : ∀ i ∈ Finset.Ico 12 18, F24 i = W24 i := by
  decide +kernel

end Legendre
