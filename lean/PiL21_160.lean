import PiW21

namespace Legendre

set_option maxHeartbeats 0 in
theorem g21_160 : ∀ i ∈ Finset.Ico 160 180, F21 i = W21 i := by
  decide +kernel

end Legendre
