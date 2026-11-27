import PiW21

namespace Legendre

set_option maxHeartbeats 0 in
theorem g21_200 : ∀ i ∈ Finset.Ico 200 220, F21 i = W21 i := by
  decide +kernel

end Legendre
