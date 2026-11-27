import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_210_212 : ∀ i ∈ Finset.Ico 212 213, F24 i = W24 i := by
  decide +kernel

end Legendre
