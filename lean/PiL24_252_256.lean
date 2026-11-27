import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_252_256 : ∀ i ∈ Finset.Ico 256 257, F24 i = W24 i := by
  decide +kernel

end Legendre
