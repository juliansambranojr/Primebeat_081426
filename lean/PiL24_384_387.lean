import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_384_387 : ∀ i ∈ Finset.Ico 387 388, F24 i = W24 i := by
  decide +kernel

end Legendre
