import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_600_603 : ∀ i ∈ Finset.Ico 603 604, F25 i = W25 i := by
  decide +kernel

end Legendre
