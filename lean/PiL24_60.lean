import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_60 : ∀ i ∈ Finset.Ico 60 66, F24 i = W24 i := by
  decide +kernel

end Legendre
