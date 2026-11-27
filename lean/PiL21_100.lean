import PiW21

namespace Legendre

set_option maxHeartbeats 0 in
theorem g21_100 : ∀ i ∈ Finset.Ico 100 120, F21 i = W21 i := by
  decide +kernel

end Legendre
