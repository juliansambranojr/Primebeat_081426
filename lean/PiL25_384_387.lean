import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_384_387 : ∀ i ∈ Finset.Ico 387 388, F25 i = W25 i := by
  decide +kernel

end Legendre
