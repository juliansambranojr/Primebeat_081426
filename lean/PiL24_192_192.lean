import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_192_192 : ∀ i ∈ Finset.Ico 192 193, F24 i = W24 i := by
  decide +kernel

end Legendre
