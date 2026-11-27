import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_270 : ∀ i ∈ Finset.Ico 270 276, F24 i = W24 i := by
  decide +kernel

end Legendre
