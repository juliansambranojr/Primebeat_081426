import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_6 : ∀ i ∈ Finset.Ico 6 12, F24 i = W24 i := by
  decide +kernel

end Legendre
