import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_300_302 : ∀ i ∈ Finset.Ico 302 303, F24 i = W24 i := by
  decide +kernel

end Legendre
