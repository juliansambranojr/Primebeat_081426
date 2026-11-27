import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_384_389 : ∀ i ∈ Finset.Ico 389 390, F24 i = W24 i := by
  decide +kernel

end Legendre
