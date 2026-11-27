import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_528 : ∀ i ∈ Finset.Ico 528 534, F24 i = W24 i := by
  decide +kernel

end Legendre
