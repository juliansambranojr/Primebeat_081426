import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_204 : ∀ i ∈ Finset.Ico 204 210, F24 i = W24 i := by
  decide +kernel

end Legendre
