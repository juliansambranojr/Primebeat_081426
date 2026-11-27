import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_342_343 : ∀ i ∈ Finset.Ico 343 344, F24 i = W24 i := by
  decide +kernel

end Legendre
