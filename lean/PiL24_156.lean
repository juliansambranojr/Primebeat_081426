import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_156 : ∀ i ∈ Finset.Ico 156 162, F24 i = W24 i := by
  decide +kernel

end Legendre
