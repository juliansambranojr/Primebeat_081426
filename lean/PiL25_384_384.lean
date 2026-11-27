import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_384_384 : ∀ i ∈ Finset.Ico 384 385, F25 i = W25 i := by
  decide +kernel

end Legendre
