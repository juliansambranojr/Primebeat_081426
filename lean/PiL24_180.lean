import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_180 : ∀ i ∈ Finset.Ico 180 186, F24 i = W24 i := by
  decide +kernel

end Legendre
