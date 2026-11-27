import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_336_340 : ∀ i ∈ Finset.Ico 340 341, F24 i = W24 i := by
  decide +kernel

end Legendre
