import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_318 : ∀ i ∈ Finset.Ico 318 324, F24 i = W24 i := by
  decide +kernel

end Legendre
