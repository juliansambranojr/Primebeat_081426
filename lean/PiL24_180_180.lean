import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_180_180 : ∀ i ∈ Finset.Ico 180 181, F24 i = W24 i := by
  decide +kernel

end Legendre
