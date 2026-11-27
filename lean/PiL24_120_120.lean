import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_120_120 : ∀ i ∈ Finset.Ico 120 121, F24 i = W24 i := by
  decide +kernel

end Legendre
