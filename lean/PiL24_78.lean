import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_78 : ∀ i ∈ Finset.Ico 78 84, F24 i = W24 i := by
  decide +kernel

end Legendre
