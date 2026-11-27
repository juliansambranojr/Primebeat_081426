import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_234 : ∀ i ∈ Finset.Ico 234 240, F24 i = W24 i := by
  decide +kernel

end Legendre
