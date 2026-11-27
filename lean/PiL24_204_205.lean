import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_204_205 : ∀ i ∈ Finset.Ico 205 206, F24 i = W24 i := by
  decide +kernel

end Legendre
