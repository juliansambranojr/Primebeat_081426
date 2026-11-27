import PiW24

namespace Legendre

set_option maxHeartbeats 0 in
theorem g24_330_330 : ∀ i ∈ Finset.Ico 330 331, F24 i = W24 i := by
  decide +kernel

end Legendre
