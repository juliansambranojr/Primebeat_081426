import PiW21

namespace Legendre

set_option maxHeartbeats 0 in
theorem g21_120 : ∀ i ∈ Finset.Ico 120 140, F21 i = W21 i := by
  decide +kernel

end Legendre
