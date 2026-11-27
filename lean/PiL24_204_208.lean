import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_204_208 : ∀ i ∈ Finset.Ico 208 209, F24 i = W24 i := by
  decide +kernel

end Legendre
