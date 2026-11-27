import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_252_255 : ∀ i ∈ Finset.Ico 255 256, F24 i = W24 i := by
  decide +kernel

end Legendre
