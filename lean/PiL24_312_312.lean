import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_312_312 : ∀ i ∈ Finset.Ico 312 313, F24 i = W24 i := by
  decide +kernel

end Legendre
