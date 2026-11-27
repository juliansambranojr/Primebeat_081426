import PiW25

namespace Legendre

set_option maxHeartbeats 0 in
theorem g25_252_255 : ∀ i ∈ Finset.Ico 255 256, F25 i = W25 i := by
  decide +kernel

end Legendre
