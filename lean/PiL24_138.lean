import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_138 : ∀ i ∈ Finset.Ico 138 144, F24 i = W24 i := by
  decide +kernel

end Legendre
