import PiW21

namespace Legendre

set_option maxHeartbeats 0 in
theorem g21_80 : ∀ i ∈ Finset.Ico 80 100, F21 i = W21 i := by
  decide +kernel

end Legendre
