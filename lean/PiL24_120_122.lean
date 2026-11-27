import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_120_122 : ∀ i ∈ Finset.Ico 122 123, F24 i = W24 i := by
  decide +kernel

end Legendre
