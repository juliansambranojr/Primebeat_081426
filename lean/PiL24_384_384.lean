import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_384_384 : ∀ i ∈ Finset.Ico 384 385, F24 i = W24 i := by
  decide +kernel

end Legendre
