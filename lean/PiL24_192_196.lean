import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_192_196 : ∀ i ∈ Finset.Ico 196 197, F24 i = W24 i := by
  decide +kernel

end Legendre
