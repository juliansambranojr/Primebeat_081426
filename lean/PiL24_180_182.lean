import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_180_182 : ∀ i ∈ Finset.Ico 182 183, F24 i = W24 i := by
  decide +kernel

end Legendre
