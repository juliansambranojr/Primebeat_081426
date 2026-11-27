import PiW21

namespace Legendre

set_option maxHeartbeats 0 in
theorem g21_40 : ∀ i ∈ Finset.Ico 40 60, F21 i = W21 i := by
  decide +kernel

end Legendre
