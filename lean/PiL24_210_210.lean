import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_210_210 : ∀ i ∈ Finset.Ico 210 211, F24 i = W24 i := by
  decide +kernel

end Legendre
