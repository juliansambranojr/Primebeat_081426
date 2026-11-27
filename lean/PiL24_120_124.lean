import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_120_124 : ∀ i ∈ Finset.Ico 124 125, F24 i = W24 i := by
  decide +kernel

end Legendre
