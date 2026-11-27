import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_396_400 : ∀ i ∈ Finset.Ico 400 401, F24 i = W24 i := by
  decide +kernel

end Legendre
