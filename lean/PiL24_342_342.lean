import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_342_342 : ∀ i ∈ Finset.Ico 342 343, F24 i = W24 i := by
  decide +kernel

end Legendre
