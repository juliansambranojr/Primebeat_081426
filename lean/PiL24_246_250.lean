import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_246_250 : ∀ i ∈ Finset.Ico 250 251, F24 i = W24 i := by
  decide +kernel

end Legendre
