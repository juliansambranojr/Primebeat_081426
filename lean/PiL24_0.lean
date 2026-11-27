import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_0 : ∀ i ∈ Finset.Ico 0 6, F24 i = W24 i := by
  decide +kernel

end Legendre
