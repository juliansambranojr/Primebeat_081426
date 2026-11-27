import PiW21

namespace Legendre

set_option maxHeartbeats 0 in
theorem g21_140 : ∀ i ∈ Finset.Ico 140 160, F21 i = W21 i := by
  decide +kernel

end Legendre
