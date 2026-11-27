import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_102_103 : ∀ i ∈ Finset.Ico 103 104, F25 i = W25 i := by
  decide +kernel

end Legendre
