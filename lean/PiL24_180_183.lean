import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_180_183 : ∀ i ∈ Finset.Ico 183 184, F24 i = W24 i := by
  decide +kernel

end Legendre
