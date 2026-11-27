import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_510_510 : ∀ i ∈ Finset.Ico 510 511, F24 i = W24 i := by
  decide +kernel

end Legendre
