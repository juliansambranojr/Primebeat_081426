import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_252 : ∀ i ∈ Finset.Ico 252 258, F24 i = W24 i := by
  decide +kernel

end Legendre
