import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_414 : ∀ i ∈ Finset.Ico 414 420, F24 i = W24 i := by
  decide +kernel

end Legendre
