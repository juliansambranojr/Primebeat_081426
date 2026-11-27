import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_246 : ∀ i ∈ Finset.Ico 246 252, F24 i = W24 i := by
  decide +kernel

end Legendre
