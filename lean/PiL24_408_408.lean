import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_408_408 : ∀ i ∈ Finset.Ico 408 409, F24 i = W24 i := by
  decide +kernel

end Legendre
