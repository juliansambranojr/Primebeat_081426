import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_450 : ∀ i ∈ Finset.Ico 450 456, F24 i = W24 i := by
  decide +kernel

end Legendre
