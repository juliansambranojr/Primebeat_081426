import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_210_213 : ∀ i ∈ Finset.Ico 213 214, F24 i = W24 i := by
  decide +kernel

end Legendre
