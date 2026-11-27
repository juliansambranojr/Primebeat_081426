import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_120_125 : ∀ i ∈ Finset.Ico 125 126, F24 i = W24 i := by
  decide +kernel

end Legendre
