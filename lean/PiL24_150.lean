import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_150 : ∀ i ∈ Finset.Ico 150 156, F24 i = W24 i := by
  decide +kernel

end Legendre
