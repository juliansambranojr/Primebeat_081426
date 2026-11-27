import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_72 : ∀ i ∈ Finset.Ico 72 78, F24 i = W24 i := by
  decide +kernel

end Legendre
