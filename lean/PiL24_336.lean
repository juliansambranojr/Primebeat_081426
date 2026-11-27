import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_336 : ∀ i ∈ Finset.Ico 336 342, F24 i = W24 i := by
  decide +kernel

end Legendre
