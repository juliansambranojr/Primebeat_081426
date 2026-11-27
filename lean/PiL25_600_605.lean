import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_600_605 : ∀ i ∈ Finset.Ico 605 606, F25 i = W25 i := by
  decide +kernel

end Legendre
