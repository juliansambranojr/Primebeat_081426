import PiW21

namespace Legendre

set_option maxHeartbeats 0 in
theorem g21_180 : ∀ i ∈ Finset.Ico 180 200, F21 i = W21 i := by
  decide +kernel

end Legendre
