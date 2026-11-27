import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_210_211 : ∀ i ∈ Finset.Ico 211 212, F24 i = W24 i := by
  decide +kernel

end Legendre
