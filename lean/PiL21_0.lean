import PiW21

namespace Legendre

set_option maxHeartbeats 0 in
theorem g21_0 : ∀ i ∈ Finset.Ico 0 20, F21 i = W21 i := by
  decide +kernel

end Legendre
