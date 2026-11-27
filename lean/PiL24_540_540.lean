import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_540_540 : ∀ i ∈ Finset.Ico 540 541, F24 i = W24 i := by
  decide +kernel

end Legendre
