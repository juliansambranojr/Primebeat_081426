import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_42 : ∀ i ∈ Finset.Ico 42 48, F24 i = W24 i := by
  decide +kernel

end Legendre
