import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_402_402 : ∀ i ∈ Finset.Ico 402 403, F24 i = W24 i := by
  decide +kernel

end Legendre
